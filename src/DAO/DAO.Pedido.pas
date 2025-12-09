unit DAO.Pedido;

interface

uses
  System.Generics.Collections,
  Model.Pedido,
  Model.ItemPedido,
  FireDAC.Comp.Client;

type
  /// <summary>
  /// Data Access Object para Pedido
  /// Implementa o padrão DAO com transações para integridade dos dados
  /// </summary>
  TPedidoDAO = class
  private
    FQuery: TFDQuery;
    
    procedure InserirItens(Pedido: TPedido);
    procedure CarregarItens(Pedido: TPedido);
  public
    constructor Create;
    destructor Destroy; override;
    
    /// <summary>
    /// Insere um novo pedido no banco de dados
    /// </summary>
    function Inserir(Pedido: TPedido): Boolean;
    
    /// <summary>
    /// Atualiza os dados de um pedido existente
    /// </summary>
    function Atualizar(Pedido: TPedido): Boolean;
    
    /// <summary>
    /// Exclui um pedido pelo número
    /// </summary>
    function Excluir(NumeroPedido: Integer): Boolean;
    
    /// <summary>
    /// Busca um pedido pelo número
    /// </summary>
    function BuscarPorNumero(NumeroPedido: Integer): TPedido;
    
    /// <summary>
    /// Lista todos os pedidos
    /// </summary>
    function ListarTodos: TObjectList<TPedido>;
    
    /// <summary>
    /// Lista pedidos por cliente
    /// </summary>
    function ListarPorCliente(CodigoCliente: Integer): TObjectList<TPedido>;
  end;

implementation

uses
  System.SysUtils,
  DAO.Conexao;

{ TPedidoDAO }

constructor TPedidoDAO.Create;
begin
  inherited Create;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := TConexao.GetInstancia.GetConexao;
end;

destructor TPedidoDAO.Destroy;
begin
  FQuery.Free;
  inherited;
end;

function TPedidoDAO.Inserir(Pedido: TPedido): Boolean;
var
  Mensagem: string;
  Conexao: TFDConnection;
begin
  Result := False;
  
  if not Pedido.Validar(Mensagem) then
    raise Exception.Create('Erro ao validar pedido: ' + Mensagem);
  
  Conexao := TConexao.GetInstancia.GetConexao;
  Conexao.StartTransaction;
  
  try
    // Insere o pedido
    FQuery.SQL.Clear;
    FQuery.SQL.Add('INSERT INTO pedidos (data_emissao, codigo_cliente, valor_total)');
    FQuery.SQL.Add('VALUES (:data_emissao, :codigo_cliente, :valor_total)');
    
    FQuery.ParamByName('data_emissao').AsDateTime := Pedido.DataEmissao;
    FQuery.ParamByName('codigo_cliente').AsInteger := Pedido.CodigoCliente;
    FQuery.ParamByName('valor_total').AsCurrency := Pedido.ValorTotal;
    
    FQuery.ExecSQL;
    
    // Recupera o número do pedido gerado
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT LAST_INSERT_ID() AS numero_pedido');
    FQuery.Open;
    Pedido.NumeroPedido := FQuery.FieldByName('numero_pedido').AsInteger;
    
    // Insere os itens do pedido
    InserirItens(Pedido);
    
    Conexao.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      Conexao.Rollback;
      raise Exception.Create('Erro ao inserir pedido: ' + E.Message);
    end;
  end;
end;

procedure TPedidoDAO.InserirItens(Pedido: TPedido);
var
  Item: TItemPedido;
  IdItem: Integer;
begin
  IdItem := 1;
  
  for Item in Pedido.Itens do
  begin
    FQuery.SQL.Clear;
    FQuery.SQL.Add('INSERT INTO pedidos_produtos (numero_pedido, id_item, codigo_produto, quantidade, valor_unitario, valor_total)');
    FQuery.SQL.Add('VALUES (:numero_pedido, :id_item, :codigo_produto, :quantidade, :valor_unitario, :valor_total)');
    
    FQuery.ParamByName('numero_pedido').AsInteger := Pedido.NumeroPedido;
    FQuery.ParamByName('id_item').AsInteger := IdItem;
    FQuery.ParamByName('codigo_produto').AsInteger := Item.CodigoProduto;
    FQuery.ParamByName('quantidade').AsFloat := Item.Quantidade;
    FQuery.ParamByName('valor_unitario').AsCurrency := Item.ValorUnitario;
    FQuery.ParamByName('valor_total').AsCurrency := Item.ValorTotal;
    
    FQuery.ExecSQL;
    
    Item.Id := IdItem;
    Inc(IdItem);
  end;
end;

function TPedidoDAO.Atualizar(Pedido: TPedido): Boolean;
var
  Mensagem: string;
  Conexao: TFDConnection;
begin
  Result := False;
  
  if not Pedido.Validar(Mensagem) then
    raise Exception.Create('Erro ao validar pedido: ' + Mensagem);
  
  Conexao := TConexao.GetInstancia.GetConexao;
  Conexao.StartTransaction;
  
  try
    // Atualiza o pedido
    FQuery.SQL.Clear;
    FQuery.SQL.Add('UPDATE pedidos SET');
    FQuery.SQL.Add('  data_emissao = :data_emissao,');
    FQuery.SQL.Add('  codigo_cliente = :codigo_cliente,');
    FQuery.SQL.Add('  valor_total = :valor_total');
    FQuery.SQL.Add('WHERE numero_pedido = :numero_pedido');
    
    FQuery.ParamByName('numero_pedido').AsInteger := Pedido.NumeroPedido;
    FQuery.ParamByName('data_emissao').AsDateTime := Pedido.DataEmissao;
    FQuery.ParamByName('codigo_cliente').AsInteger := Pedido.CodigoCliente;
    FQuery.ParamByName('valor_total').AsCurrency := Pedido.ValorTotal;
    
    FQuery.ExecSQL;
    
    // Remove os itens existentes
    FQuery.SQL.Clear;
    FQuery.SQL.Add('DELETE FROM pedidos_produtos WHERE numero_pedido = :numero_pedido');
    FQuery.ParamByName('numero_pedido').AsInteger := Pedido.NumeroPedido;
    FQuery.ExecSQL;
    
    // Insere os novos itens
    InserirItens(Pedido);
    
    Conexao.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      Conexao.Rollback;
      raise Exception.Create('Erro ao atualizar pedido: ' + E.Message);
    end;
  end;
end;

function TPedidoDAO.Excluir(NumeroPedido: Integer): Boolean;
var
  Conexao: TFDConnection;
begin
  Result := False;
  
  Conexao := TConexao.GetInstancia.GetConexao;
  Conexao.StartTransaction;
  
  try
    // Remove os itens do pedido
    FQuery.SQL.Clear;
    FQuery.SQL.Add('DELETE FROM pedidos_produtos WHERE numero_pedido = :numero_pedido');
    FQuery.ParamByName('numero_pedido').AsInteger := NumeroPedido;
    FQuery.ExecSQL;
    
    // Remove o pedido
    FQuery.SQL.Clear;
    FQuery.SQL.Add('DELETE FROM pedidos WHERE numero_pedido = :numero_pedido');
    FQuery.ParamByName('numero_pedido').AsInteger := NumeroPedido;
    FQuery.ExecSQL;
    
    Conexao.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      Conexao.Rollback;
      raise Exception.Create('Erro ao excluir pedido: ' + E.Message);
    end;
  end;
end;

function TPedidoDAO.BuscarPorNumero(NumeroPedido: Integer): TPedido;
begin
  Result := nil;
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT numero_pedido, data_emissao, codigo_cliente, valor_total');
    FQuery.SQL.Add('FROM pedidos');
    FQuery.SQL.Add('WHERE numero_pedido = :numero_pedido');
    FQuery.ParamByName('numero_pedido').AsInteger := NumeroPedido;
    FQuery.Open;
    
    if not FQuery.IsEmpty then
    begin
      Result := TPedido.Create;
      Result.NumeroPedido := FQuery.FieldByName('numero_pedido').AsInteger;
      Result.DataEmissao := FQuery.FieldByName('data_emissao').AsDateTime;
      Result.CodigoCliente := FQuery.FieldByName('codigo_cliente').AsInteger;
      
      CarregarItens(Result);
    end;
  except
    on E: Exception do
    begin
      if Assigned(Result) then
        Result.Free;
      raise Exception.Create('Erro ao buscar pedido: ' + E.Message);
    end;
  end;
end;

procedure TPedidoDAO.CarregarItens(Pedido: TPedido);
var
  Item: TItemPedido;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add('SELECT id_item, codigo_produto, quantidade, valor_unitario, valor_total');
  FQuery.SQL.Add('FROM pedidos_produtos');
  FQuery.SQL.Add('WHERE numero_pedido = :numero_pedido');
  FQuery.SQL.Add('ORDER BY id_item');
  FQuery.ParamByName('numero_pedido').AsInteger := Pedido.NumeroPedido;
  FQuery.Open;
  
  while not FQuery.Eof do
  begin
    Item := TItemPedido.Create;
    Item.Id := FQuery.FieldByName('id_item').AsInteger;
    Item.CodigoProduto := FQuery.FieldByName('codigo_produto').AsInteger;
    Item.Quantidade := FQuery.FieldByName('quantidade').AsFloat;
    Item.ValorUnitario := FQuery.FieldByName('valor_unitario').AsCurrency;
    
    Pedido.AdicionarItem(Item);
    FQuery.Next;
  end;
end;

function TPedidoDAO.ListarTodos: TObjectList<TPedido>;
var
  Pedido: TPedido;
begin
  Result := TObjectList<TPedido>.Create(True);
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT numero_pedido, data_emissao, codigo_cliente, valor_total');
    FQuery.SQL.Add('FROM pedidos');
    FQuery.SQL.Add('ORDER BY numero_pedido DESC');
    FQuery.Open;
    
    while not FQuery.Eof do
    begin
      Pedido := TPedido.Create;
      Pedido.NumeroPedido := FQuery.FieldByName('numero_pedido').AsInteger;
      Pedido.DataEmissao := FQuery.FieldByName('data_emissao').AsDateTime;
      Pedido.CodigoCliente := FQuery.FieldByName('codigo_cliente').AsInteger;
      
      CarregarItens(Pedido);
      
      Result.Add(Pedido);
      FQuery.Next;
    end;
  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create('Erro ao listar pedidos: ' + E.Message);
    end;
  end;
end;

function TPedidoDAO.ListarPorCliente(CodigoCliente: Integer): TObjectList<TPedido>;
var
  Pedido: TPedido;
begin
  Result := TObjectList<TPedido>.Create(True);
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT numero_pedido, data_emissao, codigo_cliente, valor_total');
    FQuery.SQL.Add('FROM pedidos');
    FQuery.SQL.Add('WHERE codigo_cliente = :codigo_cliente');
    FQuery.SQL.Add('ORDER BY numero_pedido DESC');
    FQuery.ParamByName('codigo_cliente').AsInteger := CodigoCliente;
    FQuery.Open;
    
    while not FQuery.Eof do
    begin
      Pedido := TPedido.Create;
      Pedido.NumeroPedido := FQuery.FieldByName('numero_pedido').AsInteger;
      Pedido.DataEmissao := FQuery.FieldByName('data_emissao').AsDateTime;
      Pedido.CodigoCliente := FQuery.FieldByName('codigo_cliente').AsInteger;
      
      CarregarItens(Pedido);
      
      Result.Add(Pedido);
      FQuery.Next;
    end;
  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create('Erro ao listar pedidos por cliente: ' + E.Message);
    end;
  end;
end;

end.
