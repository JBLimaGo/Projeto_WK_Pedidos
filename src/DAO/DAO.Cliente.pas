unit DAO.Cliente;

interface

uses
  System.Generics.Collections,
  Model.Cliente,
  FireDAC.Comp.Client;

type
  /// <summary>
  /// Data Access Object para Cliente
  /// Implementa o padrão DAO para separação de responsabilidades
  /// </summary>
  TClienteDAO = class
  private
    FQuery: TFDQuery;
  public
    constructor Create;
    destructor Destroy; override;
    
    /// <summary>
    /// Insere um novo cliente no banco de dados
    /// </summary>
    function Inserir(Cliente: TCliente): Boolean;
    
    /// <summary>
    /// Atualiza os dados de um cliente existente
    /// </summary>
    function Atualizar(Cliente: TCliente): Boolean;
    
    /// <summary>
    /// Exclui um cliente pelo código
    /// </summary>
    function Excluir(Codigo: Integer): Boolean;
    
    /// <summary>
    /// Busca um cliente pelo código
    /// </summary>
    function BuscarPorCodigo(Codigo: Integer): TCliente;
    
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
  System.SysUtils,
  DAO.Conexao;

{ TClienteDAO }

constructor TClienteDAO.Create;
begin
  inherited Create;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := TConexao.GetInstancia.GetConexao;
end;

destructor TClienteDAO.Destroy;
begin
  FQuery.Free;
  inherited;
end;

function TClienteDAO.Inserir(Cliente: TCliente): Boolean;
var
  Mensagem: string;
begin
  Result := False;
  
  if not Cliente.Validar(Mensagem) then
    raise Exception.Create('Erro ao validar cliente: ' + Mensagem);
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('INSERT INTO clientes (nome, cidade, uf)');
    FQuery.SQL.Add('VALUES (:nome, :cidade, :uf)');
    
    FQuery.ParamByName('nome').AsString := Cliente.Nome;
    FQuery.ParamByName('cidade').AsString := Cliente.Cidade;
    FQuery.ParamByName('uf').AsString := Cliente.UF;
    
    FQuery.ExecSQL;
    
    // Recupera o ID gerado
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT LAST_INSERT_ID() AS codigo');
    FQuery.Open;
    Cliente.Codigo := FQuery.FieldByName('codigo').AsInteger;
    
    Result := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao inserir cliente: ' + E.Message);
  end;
end;

function TClienteDAO.Atualizar(Cliente: TCliente): Boolean;
var
  Mensagem: string;
begin
  Result := False;
  
  if not Cliente.Validar(Mensagem) then
    raise Exception.Create('Erro ao validar cliente: ' + Mensagem);
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('UPDATE clientes SET');
    FQuery.SQL.Add('  nome = :nome,');
    FQuery.SQL.Add('  cidade = :cidade,');
    FQuery.SQL.Add('  uf = :uf');
    FQuery.SQL.Add('WHERE codigo = :codigo');
    
    FQuery.ParamByName('codigo').AsInteger := Cliente.Codigo;
    FQuery.ParamByName('nome').AsString := Cliente.Nome;
    FQuery.ParamByName('cidade').AsString := Cliente.Cidade;
    FQuery.ParamByName('uf').AsString := Cliente.UF;
    
    FQuery.ExecSQL;
    Result := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao atualizar cliente: ' + E.Message);
  end;
end;

function TClienteDAO.Excluir(Codigo: Integer): Boolean;
begin
  Result := False;
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('DELETE FROM clientes WHERE codigo = :codigo');
    FQuery.ParamByName('codigo').AsInteger := Codigo;
    FQuery.ExecSQL;
    
    Result := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao excluir cliente: ' + E.Message);
  end;
end;

function TClienteDAO.BuscarPorCodigo(Codigo: Integer): TCliente;
begin
  Result := nil;
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT codigo, nome, cidade, uf');
    FQuery.SQL.Add('FROM clientes');
    FQuery.SQL.Add('WHERE codigo = :codigo');
    FQuery.ParamByName('codigo').AsInteger := Codigo;
    FQuery.Open;
    
    if not FQuery.IsEmpty then
    begin
      Result := TCliente.Create;
      Result.Codigo := FQuery.FieldByName('codigo').AsInteger;
      Result.Nome := FQuery.FieldByName('nome').AsString;
      Result.Cidade := FQuery.FieldByName('cidade').AsString;
      Result.UF := FQuery.FieldByName('uf').AsString;
    end;
  except
    on E: Exception do
    begin
      if Assigned(Result) then
        Result.Free;
      raise Exception.Create('Erro ao buscar cliente: ' + E.Message);
    end;
  end;
end;

function TClienteDAO.ListarTodos: TObjectList<TCliente>;
var
  Cliente: TCliente;
begin
  Result := TObjectList<TCliente>.Create(True);
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT codigo, nome, cidade, uf');
    FQuery.SQL.Add('FROM clientes');
    FQuery.SQL.Add('ORDER BY nome');
    FQuery.Open;
    
    while not FQuery.Eof do
    begin
      Cliente := TCliente.Create;
      Cliente.Codigo := FQuery.FieldByName('codigo').AsInteger;
      Cliente.Nome := FQuery.FieldByName('nome').AsString;
      Cliente.Cidade := FQuery.FieldByName('cidade').AsString;
      Cliente.UF := FQuery.FieldByName('uf').AsString;
      
      Result.Add(Cliente);
      FQuery.Next;
    end;
  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create('Erro ao listar clientes: ' + E.Message);
    end;
  end;
end;

function TClienteDAO.BuscarPorNome(Nome: string): TObjectList<TCliente>;
var
  Cliente: TCliente;
begin
  Result := TObjectList<TCliente>.Create(True);
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT codigo, nome, cidade, uf');
    FQuery.SQL.Add('FROM clientes');
    FQuery.SQL.Add('WHERE nome LIKE :nome');
    FQuery.SQL.Add('ORDER BY nome');
    FQuery.ParamByName('nome').AsString := '%' + Nome + '%';
    FQuery.Open;
    
    while not FQuery.Eof do
    begin
      Cliente := TCliente.Create;
      Cliente.Codigo := FQuery.FieldByName('codigo').AsInteger;
      Cliente.Nome := FQuery.FieldByName('nome').AsString;
      Cliente.Cidade := FQuery.FieldByName('cidade').AsString;
      Cliente.UF := FQuery.FieldByName('uf').AsString;
      
      Result.Add(Cliente);
      FQuery.Next;
    end;
  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create('Erro ao buscar clientes por nome: ' + E.Message);
    end;
  end;
end;

end.
