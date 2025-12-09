unit DAO.Conexao;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.DApt;

type
  /// <summary>
  /// Classe Singleton para gerenciar a conexão com o banco de dados
  /// Implementa o padrão Singleton (Design Pattern)
  /// </summary>
  TConexao = class
  private
    class var FInstancia: TConexao;
    FConexao: TFDConnection;
    
    constructor CreatePrivate;
    procedure ConfigurarConexao;
  public
    destructor Destroy; override;
    
    /// <summary>
    /// Retorna a instância única da conexão (Singleton)
    /// </summary>
    class function GetInstancia: TConexao;
    
    /// <summary>
    /// Libera a instância do Singleton
    /// </summary>
    class procedure LiberarInstancia;
    
    /// <summary>
    /// Retorna a conexão FireDAC
    /// </summary>
    function GetConexao: TFDConnection;
    
    /// <summary>
    /// Testa a conexão com o banco de dados
    /// </summary>
    function TestarConexao: Boolean;
  end;

implementation

uses
  System.SysUtils,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef;

{ TConexao }

constructor TConexao.CreatePrivate;
begin
  inherited Create;
  FConexao := TFDConnection.Create(nil);
  ConfigurarConexao;
end;

destructor TConexao.Destroy;
begin
  FConexao.Free;
  inherited;
end;

procedure TConexao.ConfigurarConexao;
begin
  FConexao.Params.Clear;
  FConexao.Params.Add('DriverID=MySQL');
  FConexao.Params.Add('Server=localhost');
  FConexao.Params.Add('Port=3306');
  FConexao.Params.Add('Database=pedidos');
  FConexao.Params.Add('User_Name=root');
  // NOTA DE SEGURANÇA: Em ambiente de produção, não use senha vazia e não hardcode credenciais
  // Utilize variáveis de ambiente, arquivo de configuração criptografado ou gerenciador de secrets
  FConexao.Params.Add('Password=');  
  FConexao.Params.Add('CharacterSet=utf8mb4');
  
  FConexao.LoginPrompt := False;
end;

class function TConexao.GetInstancia: TConexao;
begin
  if not Assigned(FInstancia) then
    FInstancia := TConexao.CreatePrivate;
  Result := FInstancia;
end;

class procedure TConexao.LiberarInstancia;
begin
  if Assigned(FInstancia) then
    FreeAndNil(FInstancia);
end;

function TConexao.GetConexao: TFDConnection;
begin
  Result := FConexao;
  
  if not FConexao.Connected then
    FConexao.Connected := True;
end;

function TConexao.TestarConexao: Boolean;
begin
  try
    FConexao.Connected := True;
    Result := FConexao.Connected;
  except
    Result := False;
  end;
end;

initialization

finalization
  TConexao.LiberarInstancia;

end.
