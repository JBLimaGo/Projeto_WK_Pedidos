unit Model.Pedido;

interface

uses
  System.Generics.Collections,
  Model.Cliente,
  Model.ItemPedido;

type
  /// <summary>
  /// Classe que representa um Pedido no sistema
  /// Implementa agregação e composição (OOP)
  /// </summary>
  TPedido = class
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDateTime;
    FCodigoCliente: Integer;
    FValorTotal: Currency;
    FItens: TObjectList<TItemPedido>;
    
    procedure SetNumeroPedido(const Value: Integer);
    procedure SetCodigoCliente(const Value: Integer);
    procedure CalcularValorTotal;
  public
    constructor Create;
    destructor Destroy; override;
    
    /// <summary>
    /// Adiciona um item ao pedido
    /// </summary>
    procedure AdicionarItem(Item: TItemPedido);
    
    /// <summary>
    /// Remove um item do pedido pelo ID
    /// </summary>
    function RemoverItem(Id: Integer): Boolean;
    
    /// <summary>
    /// Atualiza o valor total do pedido
    /// </summary>
    procedure AtualizarValorTotal;
    
    /// <summary>
    /// Valida os dados do pedido
    /// </summary>
    function Validar(out Mensagem: string): Boolean;
    
    /// <summary>
    /// Limpa todos os itens do pedido
    /// </summary>
    procedure LimparItens;
    
    // Properties com encapsulamento
    property NumeroPedido: Integer read FNumeroPedido write SetNumeroPedido;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write SetCodigoCliente;
    property ValorTotal: Currency read FValorTotal;
    property Itens: TObjectList<TItemPedido> read FItens;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils;

{ TPedido }

constructor TPedido.Create;
begin
  inherited Create;
  FNumeroPedido := 0;
  FDataEmissao := Now;
  FCodigoCliente := 0;
  FValorTotal := 0;
  FItens := TObjectList<TItemPedido>.Create(True); // True = possui os objetos
end;

destructor TPedido.Destroy;
begin
  FItens.Free;
  inherited;
end;

procedure TPedido.SetNumeroPedido(const Value: Integer);
begin
  if Value < 0 then
    raise Exception.Create('Número do pedido não pode ser negativo');
  FNumeroPedido := Value;
end;

procedure TPedido.SetCodigoCliente(const Value: Integer);
begin
  if Value <= 0 then
    raise Exception.Create('Código do cliente inválido');
  FCodigoCliente := Value;
end;

procedure TPedido.AdicionarItem(Item: TItemPedido);
begin
  if not Assigned(Item) then
    raise Exception.Create('Item não pode ser nulo');
    
  FItens.Add(Item);
  CalcularValorTotal;
end;

function TPedido.RemoverItem(Id: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := FItens.Count - 1 downto 0 do
  begin
    if FItens[I].Id = Id then
    begin
      FItens.Delete(I);
      CalcularValorTotal;
      Result := True;
      Break;
    end;
  end;
end;

procedure TPedido.CalcularValorTotal;
var
  Item: TItemPedido;
begin
  FValorTotal := 0;
  for Item in FItens do
  begin
    FValorTotal := FValorTotal + Item.ValorTotal;
  end;
end;

procedure TPedido.AtualizarValorTotal;
begin
  CalcularValorTotal;
end;

procedure TPedido.LimparItens;
begin
  FItens.Clear;
  FValorTotal := 0;
end;

function TPedido.Validar(out Mensagem: string): Boolean;
var
  Item: TItemPedido;
  MensagemItem: string;
begin
  Result := True;
  Mensagem := '';
  
  if FCodigoCliente <= 0 then
  begin
    Mensagem := 'Cliente não informado';
    Result := False;
    Exit;
  end;
  
  if FItens.Count = 0 then
  begin
    Mensagem := 'Pedido deve ter pelo menos um item';
    Result := False;
    Exit;
  end;
  
  // Valida cada item
  for Item in FItens do
  begin
    if not Item.Validar(MensagemItem) then
    begin
      Mensagem := 'Erro no item: ' + MensagemItem;
      Result := False;
      Exit;
    end;
  end;
end;

end.
