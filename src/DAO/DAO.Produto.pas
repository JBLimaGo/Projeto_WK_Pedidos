unit DAO.Produto;

interface

uses
  System.Generics.Collections,
  Model.Produto,
  FireDAC.Comp.Client;

type
  /// <summary>
  /// Data Access Object para Produto
  /// Implementa o padrão DAO para separação de responsabilidades
  /// </summary>
  TProdutoDAO = class
  private
    FQuery: TFDQuery;
  public
    constructor Create;
    destructor Destroy; override;
    
    /// <summary>
    /// Insere um novo produto no banco de dados
    /// </summary>
    function Inserir(Produto: TProduto): Boolean;
    
    /// <summary>
    /// Atualiza os dados de um produto existente
    /// </summary>
    function Atualizar(Produto: TProduto): Boolean;
    
    /// <summary>
    /// Exclui um produto pelo código
    /// </summary>
    function Excluir(Codigo: Integer): Boolean;
    
    /// <summary>
    /// Busca um produto pelo código
    /// </summary>
    function BuscarPorCodigo(Codigo: Integer): TProduto;
    
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
  System.SysUtils,
  DAO.Conexao;

{ TProdutoDAO }

constructor TProdutoDAO.Create;
begin
  inherited Create;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := TConexao.GetInstancia.GetConexao;
end;

destructor TProdutoDAO.Destroy;
begin
  FQuery.Free;
  inherited;
end;

function TProdutoDAO.Inserir(Produto: TProduto): Boolean;
var
  Mensagem: string;
begin
  Result := False;
  
  if not Produto.Validar(Mensagem) then
    raise Exception.Create('Erro ao validar produto: ' + Mensagem);
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('INSERT INTO produtos (descricao, preco_venda)');
    FQuery.SQL.Add('VALUES (:descricao, :preco_venda)');
    
    FQuery.ParamByName('descricao').AsString := Produto.Descricao;
    FQuery.ParamByName('preco_venda').AsCurrency := Produto.PrecoVenda;
    
    FQuery.ExecSQL;
    
    // Recupera o ID gerado
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT LAST_INSERT_ID() AS codigo');
    FQuery.Open;
    Produto.Codigo := FQuery.FieldByName('codigo').AsInteger;
    
    Result := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao inserir produto: ' + E.Message);
  end;
end;

function TProdutoDAO.Atualizar(Produto: TProduto): Boolean;
var
  Mensagem: string;
begin
  Result := False;
  
  if not Produto.Validar(Mensagem) then
    raise Exception.Create('Erro ao validar produto: ' + Mensagem);
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('UPDATE produtos SET');
    FQuery.SQL.Add('  descricao = :descricao,');
    FQuery.SQL.Add('  preco_venda = :preco_venda');
    FQuery.SQL.Add('WHERE codigo = :codigo');
    
    FQuery.ParamByName('codigo').AsInteger := Produto.Codigo;
    FQuery.ParamByName('descricao').AsString := Produto.Descricao;
    FQuery.ParamByName('preco_venda').AsCurrency := Produto.PrecoVenda;
    
    FQuery.ExecSQL;
    Result := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao atualizar produto: ' + E.Message);
  end;
end;

function TProdutoDAO.Excluir(Codigo: Integer): Boolean;
begin
  Result := False;
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('DELETE FROM produtos WHERE codigo = :codigo');
    FQuery.ParamByName('codigo').AsInteger := Codigo;
    FQuery.ExecSQL;
    
    Result := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao excluir produto: ' + E.Message);
  end;
end;

function TProdutoDAO.BuscarPorCodigo(Codigo: Integer): TProduto;
begin
  Result := nil;
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT codigo, descricao, preco_venda');
    FQuery.SQL.Add('FROM produtos');
    FQuery.SQL.Add('WHERE codigo = :codigo');
    FQuery.ParamByName('codigo').AsInteger := Codigo;
    FQuery.Open;
    
    if not FQuery.IsEmpty then
    begin
      Result := TProduto.Create;
      Result.Codigo := FQuery.FieldByName('codigo').AsInteger;
      Result.Descricao := FQuery.FieldByName('descricao').AsString;
      Result.PrecoVenda := FQuery.FieldByName('preco_venda').AsCurrency;
    end;
  except
    on E: Exception do
    begin
      if Assigned(Result) then
        Result.Free;
      raise Exception.Create('Erro ao buscar produto: ' + E.Message);
    end;
  end;
end;

function TProdutoDAO.ListarTodos: TObjectList<TProduto>;
var
  Produto: TProduto;
begin
  Result := TObjectList<TProduto>.Create(True);
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT codigo, descricao, preco_venda');
    FQuery.SQL.Add('FROM produtos');
    FQuery.SQL.Add('ORDER BY descricao');
    FQuery.Open;
    
    while not FQuery.Eof do
    begin
      Produto := TProduto.Create;
      Produto.Codigo := FQuery.FieldByName('codigo').AsInteger;
      Produto.Descricao := FQuery.FieldByName('descricao').AsString;
      Produto.PrecoVenda := FQuery.FieldByName('preco_venda').AsCurrency;
      
      Result.Add(Produto);
      FQuery.Next;
    end;
  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create('Erro ao listar produtos: ' + E.Message);
    end;
  end;
end;

function TProdutoDAO.BuscarPorDescricao(Descricao: string): TObjectList<TProduto>;
var
  Produto: TProduto;
begin
  Result := TObjectList<TProduto>.Create(True);
  
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT codigo, descricao, preco_venda');
    FQuery.SQL.Add('FROM produtos');
    FQuery.SQL.Add('WHERE descricao LIKE :descricao');
    FQuery.SQL.Add('ORDER BY descricao');
    FQuery.ParamByName('descricao').AsString := '%' + Descricao + '%';
    FQuery.Open;
    
    while not FQuery.Eof do
    begin
      Produto := TProduto.Create;
      Produto.Codigo := FQuery.FieldByName('codigo').AsInteger;
      Produto.Descricao := FQuery.FieldByName('descricao').AsString;
      Produto.PrecoVenda := FQuery.FieldByName('preco_venda').AsCurrency;
      
      Result.Add(Produto);
      FQuery.Next;
    end;
  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create('Erro ao buscar produtos por descrição: ' + E.Message);
    end;
  end;
end;

end.
