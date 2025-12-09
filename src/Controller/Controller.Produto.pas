unit Controller.Produto;

interface

uses
  System.Generics.Collections,
  Model.Produto,
  DAO.Produto;

type
  /// <summary>
  /// Controller para Produto - camada de regras de negócio
  /// Implementa o padrão MVC separando lógica de negócio da View
  /// </summary>
  TProdutoController = class
  private
    FDAO: TProdutoDAO;
  public
    constructor Create;
    destructor Destroy; override;
    
    /// <summary>
    /// Salva um produto (insere ou atualiza)
    /// </summary>
    function Salvar(Produto: TProduto; out Mensagem: string): Boolean;
    
    /// <summary>
    /// Exclui um produto
    /// </summary>
    function Excluir(Codigo: Integer; out Mensagem: string): Boolean;
    
    /// <summary>
    /// Busca um produto pelo código
    /// </summary>
    function Buscar(Codigo: Integer): TProduto;
    
    /// <summary>
    /// Lista todos os produtos
    /// </summary>
    function ListarTodos: TObjectList<TProduto>;
    
    /// <summary>
    /// Busca produtos por descrição
    /// </summary>
    function BuscarPorDescricao(Descricao: string): TObjectList<TProduto>;
  end;

implementation

uses
  System.SysUtils;

{ TProdutoController }

constructor TProdutoController.Create;
begin
  inherited Create;
  FDAO := TProdutoDAO.Create;
end;

destructor TProdutoController.Destroy;
begin
  FDAO.Free;
  inherited;
end;

function TProdutoController.Salvar(Produto: TProduto; out Mensagem: string): Boolean;
begin
  Result := False;
  Mensagem := '';
  
  try
    // Valida o produto
    if not Produto.Validar(Mensagem) then
      Exit;
    
    // Se tem código, atualiza, senão insere
    if Produto.Codigo > 0 then
      Result := FDAO.Atualizar(Produto)
    else
      Result := FDAO.Inserir(Produto);
      
    if Result then
      Mensagem := 'Produto salvo com sucesso';
  except
    on E: Exception do
    begin
      Mensagem := 'Erro ao salvar produto: ' + E.Message;
      Result := False;
    end;
  end;
end;

function TProdutoController.Excluir(Codigo: Integer; out Mensagem: string): Boolean;
begin
  Result := False;
  Mensagem := '';
  
  try
    if Codigo <= 0 then
    begin
      Mensagem := 'Código do produto inválido';
      Exit;
    end;
    
    Result := FDAO.Excluir(Codigo);
    
    if Result then
      Mensagem := 'Produto excluído com sucesso';
  except
    on E: Exception do
    begin
      Mensagem := 'Erro ao excluir produto: ' + E.Message;
      Result := False;
    end;
  end;
end;

function TProdutoController.Buscar(Codigo: Integer): TProduto;
begin
  try
    Result := FDAO.BuscarPorCodigo(Codigo);
  except
    on E: Exception do
    begin
      Result := nil;
      raise Exception.Create('Erro ao buscar produto: ' + E.Message);
    end;
  end;
end;

function TProdutoController.ListarTodos: TObjectList<TProduto>;
begin
  try
    Result := FDAO.ListarTodos;
  except
    on E: Exception do
    begin
      Result := nil;
      raise Exception.Create('Erro ao listar produtos: ' + E.Message);
    end;
  end;
end;

function TProdutoController.BuscarPorDescricao(Descricao: string): TObjectList<TProduto>;
begin
  try
    Result := FDAO.BuscarPorDescricao(Descricao);
  except
    on E: Exception do
    begin
      Result := nil;
      raise Exception.Create('Erro ao buscar produtos: ' + E.Message);
    end;
  end;
end;

end.
