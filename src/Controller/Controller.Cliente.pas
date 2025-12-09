unit Controller.Cliente;

interface

uses
  System.Generics.Collections,
  Model.Cliente,
  DAO.Cliente;

type
  /// <summary>
  /// Controller para Cliente - camada de regras de negócio
  /// Implementa o padrão MVC separando lógica de negócio da View
  /// </summary>
  TClienteController = class
  private
    FDAO: TClienteDAO;
  public
    constructor Create;
    destructor Destroy; override;
    
    /// <summary>
    /// Salva um cliente (insere ou atualiza)
    /// </summary>
    function Salvar(Cliente: TCliente; out Mensagem: string): Boolean;
    
    /// <summary>
    /// Exclui um cliente
    /// </summary>
    function Excluir(Codigo: Integer; out Mensagem: string): Boolean;
    
    /// <summary>
    /// Busca um cliente pelo código
    /// </summary>
    function Buscar(Codigo: Integer): TCliente;
    
    /// <summary>
    /// Lista todos os clientes
    /// </summary>
    function ListarTodos: TObjectList<TCliente>;
    
    /// <summary>
    /// Busca clientes por nome
    /// </summary>
    function BuscarPorNome(Nome: string): TObjectList<TCliente>;
  end;

implementation

uses
  System.SysUtils;

{ TClienteController }

constructor TClienteController.Create;
begin
  inherited Create;
  FDAO := TClienteDAO.Create;
end;

destructor TClienteController.Destroy;
begin
  FDAO.Free;
  inherited;
end;

function TClienteController.Salvar(Cliente: TCliente; out Mensagem: string): Boolean;
begin
  Result := False;
  Mensagem := '';
  
  try
    // Valida o cliente
    if not Cliente.Validar(Mensagem) then
      Exit;
    
    // Se tem código, atualiza, senão insere
    if Cliente.Codigo > 0 then
      Result := FDAO.Atualizar(Cliente)
    else
      Result := FDAO.Inserir(Cliente);
      
    if Result then
      Mensagem := 'Cliente salvo com sucesso';
  except
    on E: Exception do
    begin
      Mensagem := 'Erro ao salvar cliente: ' + E.Message;
      Result := False;
    end;
  end;
end;

function TClienteController.Excluir(Codigo: Integer; out Mensagem: string): Boolean;
begin
  Result := False;
  Mensagem := '';
  
  try
    if Codigo <= 0 then
    begin
      Mensagem := 'Código do cliente inválido';
      Exit;
    end;
    
    Result := FDAO.Excluir(Codigo);
    
    if Result then
      Mensagem := 'Cliente excluído com sucesso';
  except
    on E: Exception do
    begin
      Mensagem := 'Erro ao excluir cliente: ' + E.Message;
      Result := False;
    end;
  end;
end;

function TClienteController.Buscar(Codigo: Integer): TCliente;
begin
  try
    Result := FDAO.BuscarPorCodigo(Codigo);
  except
    on E: Exception do
    begin
      Result := nil;
      raise Exception.Create('Erro ao buscar cliente: ' + E.Message);
    end;
  end;
end;

function TClienteController.ListarTodos: TObjectList<TCliente>;
begin
  try
    Result := FDAO.ListarTodos;
  except
    on E: Exception do
    begin
      Result := nil;
      raise Exception.Create('Erro ao listar clientes: ' + E.Message);
    end;
  end;
end;

function TClienteController.BuscarPorNome(Nome: string): TObjectList<TCliente>;
begin
  try
    Result := FDAO.BuscarPorNome(Nome);
  except
    on E: Exception do
    begin
      Result := nil;
      raise Exception.Create('Erro ao buscar clientes: ' + E.Message);
    end;
  end;
end;

end.
