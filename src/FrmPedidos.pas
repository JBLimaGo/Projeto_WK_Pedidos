unit FrmPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.Dialogs, uModels, uServices,
  uConnectionFactory, uDAOs, System.UITypes, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Vcl.ExtCtrls, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  TFPedido = class(TForm)
    lblTitulo: TLabel;
    GroupBox1: TGroupBox; // Cliente
    Label1: TLabel;
    edtCodigoCliente: TEdit;
    lblNomeCliente: TLabel;
    lblCidadeCliente: TLabel;
    lblUFCliente: TLabel;
    GroupBox2: TGroupBox; // Produto
    Label2: TLabel;
    edtCodigoProduto: TEdit;
    Label3: TLabel;
    edtQuantidade: TEdit;
    Label4: TLabel;
    edtValorUnitario: TEdit;
    btnInserir: TButton;
    dbgItens: TDBGrid;
    dsItens: TDataSource;
    mtItens: TFDMemTable;
    PanelBottom: TPanel;
    lblTotalPedido: TLabel;
    btnGravar: TButton;
    btnNovo: TButton;
    btnLoadPedido: TButton;
    btnCancelPedido: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure edtCodigoClienteExit(Sender: TObject);
    procedure dbgItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnLoadPedidoClick(Sender: TObject);
    procedure btnCancelPedidoClick(Sender: TObject);
  private
    FConn: TFDConnection;
    FPedido: TPedido;
    FIniPath: string;
    FEditingIndex: Integer; // -1 = inserindo novo, >=0 = índice do item editado
    procedure SetupMemTable;
    procedure RefreshTotals;
    procedure ClearForm;
    procedure LoadClienteToLabels(ACodigo: Integer);
    procedure LoadItemToInputs(AIndex: Integer);
    procedure PopulateMemTableFromPedido;
    procedure PopulatePedidoFromMemTable;
  public
    { Public declarations }
  end;

var
  FPedido: TFPedido;

implementation

{$R *.dfm}

uses
  System.IOUtils, System.Math;

{ TFrmPedidos }

procedure TFPedido.FormCreate(Sender: TObject);
begin
  // db_connection.ini na pasta do exe
  FIniPath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'db_connection.ini');

  // Cria conexão via factory
  FConn := TConnectionFactory.GetConnection(FIniPath);

  // Inicializa memtable
  SetupMemTable;

  FPedido       := TPedido.Create;
  FEditingIndex := -1;

  // Inicial state
  btnLoadPedido.Visible   := Trim(edtCodigoCliente.Text) = '';
  btnCancelPedido.Visible := Trim(edtCodigoCliente.Text) = '';
end;

procedure TFPedido.FormDestroy(Sender: TObject);
begin
  FPedido.Free;
  if Assigned(FConn) then
    TConnectionFactory.CloseConnection;
end;

procedure TFPedido.SetupMemTable;
begin
  // define campos do memtable: codigo_produto, descricao, quantidade, valor_unitario, valor_total
  if mtItens.Active then
    mtItens.Close;

  mtItens.FieldDefs.Clear;
  mtItens.FieldDefs.Add('codigo_produto', ftInteger);
  mtItens.FieldDefs.Add('descricao', ftString, 200);
  mtItens.FieldDefs.Add('quantidade', ftFloat);
  mtItens.FieldDefs.Add('valor_unitario', ftCurrency);
  mtItens.FieldDefs.Add('valor_total', ftCurrency);
  mtItens.CreateDataSet;
  dsItens.DataSet := mtItens;

end;

procedure TFPedido.edtCodigoClienteExit(Sender: TObject);
var
  cod: Integer;
begin
  if Trim(edtCodigoCliente.Text) = '' then
    begin
      lblNomeCliente.Caption   := '';
      lblCidadeCliente.Caption := '';
      lblUFCliente.Caption     := '';
      btnLoadPedido.Visible    := True;
      btnCancelPedido.Visible  := True;
      Exit;
    end;

  if not TryStrToInt(edtCodigoCliente.Text, cod) then
    begin
      ShowMessage('Código de cliente inválido.');
      Exit;
    end;

  LoadClienteToLabels(cod);
  btnLoadPedido.Visible   := False;
  btnCancelPedido.Visible := False;
end;

procedure TFPedido.LoadClienteToLabels(ACodigo: Integer);
var
  cli: TCliente;
begin
  cli := TClienteDAO.GetByCodigo(FConn, ACodigo);
  try
    if cli = nil then
      begin
        lblNomeCliente.Caption   := 'Cliente não encontrado';
        lblCidadeCliente.Caption := '';
        lblUFCliente.Caption     := '';
        Exit;
      end;

    lblNomeCliente.Caption    := cli.Nome;
    lblCidadeCliente.Caption  := cli.Cidade;
    lblUFCliente.Caption      := cli.UF;
  finally
    cli.Free;
  end;
end;

procedure TFPedido.btnInserirClick(Sender: TObject);
var
  codProd: Integer;
  qtde: Double;
  vunit: Currency;
begin
  // leitura e validação básica
  if not TryStrToInt(edtCodigoProduto.Text, codProd) then
    begin
      ShowMessage('Código do produto inválido.');
      Exit;
    end;

  if not TryStrToFloat(edtQuantidade.Text, qtde) then
    begin
      ShowMessage('Quantidade inválida.');
      Exit;
    end;

  if not TryStrToCurr(edtValorUnitario.Text, vunit) then
    begin
      ShowMessage('Valor unitário inválido.');
      Exit;
    end;

  try

    if FEditingIndex >= 0 then
      TPedidoService.UpdateItem(FPedido, FEditingIndex, codProd, qtde, vunit)
    else
      TPedidoService.AddItemToPedido(FPedido, codProd, qtde, vunit, FConn);

    PopulateMemTableFromPedido;

    edtCodigoProduto.Clear;
    edtQuantidade.Clear;
    edtValorUnitario.Clear;
    edtCodigoProduto.SetFocus;
    FEditingIndex := -1;
  except
    on E: Exception do
      ShowMessage('Erro: ' + E.Message);
  end;

  RefreshTotals;
end;


procedure TFPedido.PopulateMemTableFromPedido;
var
  i: Integer;
  it: TPedidoItem;
begin
  mtItens.DisableControls;
  try
    mtItens.EmptyDataSet;

    for i := 0 to FPedido.Itens.Count - 1 do
      begin
        it  := FPedido.Itens[i];

        mtItens.Append;
        mtItens.FieldByName('codigo_produto').AsInteger   := it.CodigoProduto;
        mtItens.FieldByName('descricao').AsString         := it.Descricao;
        mtItens.FieldByName('quantidade').AsFloat         := it.Quantidade;
        mtItens.FieldByName('valor_unitario').AsCurrency  := it.ValorUnitario;
        mtItens.FieldByName('valor_total').AsCurrency     := it.ValorTotal;
        mtItens.Post;

      end;
  finally
    mtItens.EnableControls;
  end;
end;

procedure TFPedido.RefreshTotals;
begin
  FPedido.RecalcularTotal;
  lblTotalPedido.Caption := Format('Total do Pedido: %n', [FPedido.ValorTotal]);
end;

procedure TFPedido.dbgItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  idx: Integer;
  s: string;
begin
  // ENTER para editar item
  if Key = VK_RETURN then
    begin
      if mtItens.IsEmpty then
        Exit;

      idx := mtItens.RecNo - 1; // índice zero-based

      if (idx >= 0) and (idx < FPedido.Itens.Count) then
        begin
          FEditingIndex := idx;
          LoadItemToInputs(idx);
          Key := 0; // evita som
        end;
    end
  else
    if Key = VK_DELETE then
      begin
        if mtItens.IsEmpty then
          Exit;

        if MessageDlg('Deseja excluir o item selecionado?', TMsgDlgType.mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
            idx := mtItens.RecNo - 1;

            try
              TPedidoService.RemoveItem(FPedido, idx);
              PopulateMemTableFromPedido;
              RefreshTotals;
            except
              on E: Exception do
                ShowMessage('Erro ao remover item: ' + E.Message);
            end;
          end;

        Key := 0;
      end;
end;

procedure TFPedido.LoadItemToInputs(AIndex: Integer);
var
  it: TPedidoItem;
begin
  if (AIndex < 0) or (AIndex >= FPedido.Itens.Count) then
    Exit;

  it := FPedido.Itens[AIndex];
  edtCodigoProduto.Text    := it.CodigoProduto.ToString;
  edtQuantidade.Text       := FormatFloat('0.###', it.Quantidade);
  edtValorUnitario.Text    := FormatFloat('0.00', it.ValorUnitario);
  edtCodigoProduto.SetFocus;
end;

procedure TFPedido.btnGravarClick(Sender: TObject);
begin
  try
    // popula properties do pedido antes de salvar
    PopulatePedidoFromMemTable;
    FPedido.DataEmissao := Now;



    // valida e grava
    TPedidoService.SavePedido(FConn, FPedido);
    ShowMessage('Pedido gravado com sucesso. Nº: ' + FPedido.NumeroPedido.ToString);

    // limpa tela para novo pedido
    btnNovo.Click;
  except
    on E: Exception do
      ShowMessage('Erro ao gravar pedido: ' + E.Message);
  end;
end;

procedure TFPedido.PopulatePedidoFromMemTable;
var
  i: Integer;
  it: TPedidoItem;
  cod: Integer;
begin

  // já temos FPedido.Itens sincronizados pois usávamos Add/Update/Remove por FPedido
  // apenas asseguramos campos do cliente e recalculamos total
  if TryStrToInt(edtCodigoCliente.Text, cod) then
    FPedido.CodigoCliente := cod
  else
    FPedido.CodigoCliente := 0;

  FPedido.RecalcularTotal;
end;

procedure TFPedido.btnNovoClick(Sender: TObject);
begin
  ClearForm;
end;

procedure TFPedido.ClearForm;
begin
  edtCodigoCliente.Clear;
  lblNomeCliente.Caption   := '';
  lblCidadeCliente.Caption := '';
  lblUFCliente.Caption     := '';
  edtCodigoProduto.Clear;
  edtQuantidade.Clear;
  edtValorUnitario.Clear;
  mtItens.EmptyDataSet;
  FPedido.Free;
  FPedido       := TPedido.Create;
  FEditingIndex := -1;
  RefreshTotals;
  btnLoadPedido.Visible   := True;
  btnCancelPedido.Visible := True;
end;

procedure TFPedido.btnLoadPedidoClick(Sender: TObject);
var
  s: string;
  num: Int64;
  ped: TPedido;
begin
  s := InputBox('Carregar Pedido', 'Número do pedido:', '');

  if s = '' then
   Exit;

  if not TryStrToInt64(s, num) then
    begin
      ShowMessage('Número de pedido inválido.');
      Exit;
    end;

  try
    ped := TPedidoService.LoadPedido(FConn, num);

    if ped = nil then
      begin
        ShowMessage('Pedido não encontrado.');
        Exit;
      end;

    // Carrega dados no form
    FPedido.Free;
    FPedido               := ped;
    edtCodigoCliente.Text := FPedido.CodigoCliente.ToString;
    LoadClienteToLabels(FPedido.CodigoCliente);
    PopulateMemTableFromPedido;
    RefreshTotals;
    btnLoadPedido.Visible   := False;
    btnCancelPedido.Visible := False;

  except
    on E: Exception do
      ShowMessage('Erro ao carregar pedido: ' + E.Message);
  end;
end;

procedure TFPedido.btnCancelPedidoClick(Sender: TObject);
var
  s: string;
  num: Int64;
begin
  s := InputBox('Cancelar Pedido', 'Número do pedido a cancelar:', '');

  if s = '' then
    Exit;

  if not TryStrToInt64(s, num) then
    begin
      ShowMessage('Número de pedido inválido.');
      Exit;
    end;

  if MessageDlg('Confirma exclusão do pedido ' + s + '?', TMsgDlgType.mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  try
    TPedidoService.CancelPedido(FConn, num);
    ShowMessage('Pedido cancelado com sucesso.');
  except
    on E: Exception do
      ShowMessage('Erro ao cancelar pedido: ' + E.Message);
  end;
end;

end.

