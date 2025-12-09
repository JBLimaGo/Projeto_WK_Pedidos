unit Controller.Pedido;

interface

uses
  System.Generics.Collections,
  Model.Pedido,
  Model.ItemPedido,
  Model.Cliente,
  Model.Produto,
  DAO.Pedido,
  DAO.Cliente,
  DAO.Produto;

type
  /// <summary>
  /// Controller para Pedido - camada de regras de negócio
  /// Implementa o padrão MVC separando lógica de negócio da View
  /// Coordena múltiplos DAOs para operações complexas
  /// </summary>
  TPedidoController = class
  private
    FPedidoDAO: TPedidoDAO;
    FClienteDAO: TClienteDAO;
    FProdutoDAO: TProdutoDAO;
  public
    constructor Create;
    destructor Destroy; override;
    
    /// <summary>
    /// Salva um pedido (insere ou atualiza)
    /// Valida se o cliente e produtos existem
    /// </summary>
    function Salvar(Pedido: TPedido; out Mensagem: string): Boolean;
    
    /// <summary>
    /// Exclui um pedido
    /// </summary>
    function Excluir(NumeroPedido: Integer; out Mensagem: string): Boolean;
    
    /// <summary>
    /// Busca um pedido pelo número
    /// </summary>
    function Buscar(NumeroPedido: Integer): TPedido;
    
    /// <summary>
    /// Lista todos os pedidos
    /// </summary>
    function ListarTodos: TObjectList<TPedido>;
    
    /// <summary>
    /// Lista pedidos por cliente
    /// </summary>
    function ListarPorCliente(CodigoCliente: Integer): TObjectList<TPedido>;
    
    /// <summary>
    /// Valida se um cliente existe
    /// </summary>
    function ValidarCliente(CodigoCliente: Integer): Boolean;
    
    /// <summary>
    /// Valida se um produto existe e retorna seus dados
    /// </summary>
    function ValidarProduto(CodigoProduto: Integer; out Produto: TProduto): Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TPedidoController }

constructor TPedidoController.Create;
begin
  inherited Create;
  FPedidoDAO := TPedidoDAO.Create;
  FClienteDAO := TClienteDAO.Create;
  FProdutoDAO := TProdutoDAO.Create;
end;

destructor TPedidoController.Destroy;
begin
  FPedidoDAO.Free;
  FClienteDAO.Free;
  FProdutoDAO.Free;
  inherited;
end;

function TPedidoController.ValidarCliente(CodigoCliente: Integer): Boolean;
var
  Cliente: TCliente;
begin
  Cliente := FClienteDAO.BuscarPorCodigo(CodigoCliente);
  try
    Result := Assigned(Cliente);
  finally
    if Assigned(Cliente) then
      Cliente.Free;
  end;
end;

function TPedidoController.ValidarProduto(CodigoProduto: Integer; out Produto: TProduto): Boolean;
begin
  Produto := FProdutoDAO.BuscarPorCodigo(CodigoProduto);
  Result := Assigned(Produto);
end;

function TPedidoController.Salvar(Pedido: TPedido; out Mensagem: string): Boolean;
var
  Item: TItemPedido;
  Produto: TProduto;
begin
  Result := False;
  Mensagem := '';
  
  try
    // Valida o pedido
    if not Pedido.Validar(Mensagem) then
      Exit;
    
    // Valida se o cliente existe
    if not ValidarCliente(Pedido.CodigoCliente) then
    begin
      Mensagem := 'Cliente não encontrado';
      Exit;
    end;
    
    // Valida se todos os produtos existem
    for Item in Pedido.Itens do
    begin
      Produto := nil;
      try
        if not ValidarProduto(Item.CodigoProduto, Produto) then
        begin
          Mensagem := 'Produto com código ' + IntToStr(Item.CodigoProduto) + ' não encontrado';
          Exit;
        end;
        
        // Atualiza o valor unitário com o preço atual do produto
        Item.ValorUnitario := Produto.PrecoVenda;
        Item.AtualizarValorTotal;
      finally
        if Assigned(Produto) then
          Produto.Free;
      end;
    end;
    
    // Atualiza o valor total do pedido
    Pedido.AtualizarValorTotal;
    
    // Se tem número, atualiza, senão insere
    if Pedido.NumeroPedido > 0 then
      Result := FPedidoDAO.Atualizar(Pedido)
    else
      Result := FPedidoDAO.Inserir(Pedido);
      
    if Result then
      Mensagem := 'Pedido salvo com sucesso. Número: ' + IntToStr(Pedido.NumeroPedido);
  except
    on E: Exception do
    begin
      Mensagem := 'Erro ao salvar pedido: ' + E.Message;
      Result := False;
    end;
  end;
end;

function TPedidoController.Excluir(NumeroPedido: Integer; out Mensagem: string): Boolean;
begin
  Result := False;
  Mensagem := '';
  
  try
    if NumeroPedido <= 0 then
    begin
      Mensagem := 'Número do pedido inválido';
      Exit;
    end;
    
    Result := FPedidoDAO.Excluir(NumeroPedido);
    
    if Result then
      Mensagem := 'Pedido excluído com sucesso';
  except
    on E: Exception do
    begin
      Mensagem := 'Erro ao excluir pedido: ' + E.Message;
      Result := False;
    end;
  end;
end;

function TPedidoController.Buscar(NumeroPedido: Integer): TPedido;
begin
  try
    Result := FPedidoDAO.BuscarPorNumero(NumeroPedido);
  except
    on E: Exception do
    begin
      Result := nil;
      raise Exception.Create('Erro ao buscar pedido: ' + E.Message);
    end;
  end;
end;

function TPedidoController.ListarTodos: TObjectList<TPedido>;
begin
  try
    Result := FPedidoDAO.ListarTodos;
  except
    on E: Exception do
    begin
      Result := nil;
      raise Exception.Create('Erro ao listar pedidos: ' + E.Message);
    end;
  end;
end;

function TPedidoController.ListarPorCliente(CodigoCliente: Integer): TObjectList<TPedido>;
begin
  try
    Result := FPedidoDAO.ListarPorCliente(CodigoCliente);
  except
    on E: Exception do
    begin
      Result := nil;
      raise Exception.Create('Erro ao listar pedidos: ' + E.Message);
    end;
  end;
end;

end.
