unit uConnectionFactory;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, FireDAC.Phys, FireDAC.Stan.Def,
  FireDAC.Stan.Async, FireDAC.Dapt, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  uConfig;

type
  TConnectionFactory = class
  private
    class var FConnection: TFDConnection;
  public
    class function GetConnection(const IniPath: string): TFDConnection;
    class procedure CloseConnection;
  end;

implementation

{ TConnectionFactory }

class function TConnectionFactory.GetConnection(const IniPath: string): TFDConnection;
var
  cfg: TDBConfig;
  PhysMySQLDriverLink: TFDPhysMySQLDriverLink;
begin
  if Assigned(FConnection) then
    Exit(FConnection);

  cfg := LoadDBConfig(IniPath);

  // Checa se o drive do FireDAC MySQL esteja disponível
  PhysMySQLDriverLink           := TFDPhysMySQLDriverLink.Create(nil);
  PhysMySQLDriverLink.VendorLib := cfg.LibPath;

  FConnection := TFDConnection.Create(nil);
  with FConnection do
  begin
    LoginPrompt := False;
    Params.DriverID := 'MySQL';
    Params.Database := cfg.Database;
    Params.UserName := cfg.Username;
    Params.Password := cfg.Password;
    Params.Add('Server=' + cfg.Server);
    Params.Add('Port=' + cfg.Port.ToString);

    // Define o conjunto de Caracteres
    Params.Add('CharacterSet=utf8mb4');

    // Mantem a conexão aberta para reutilização
    Connected := True;
  end;

  Result := FConnection;
end;

class procedure TConnectionFactory.CloseConnection;
begin
  if Assigned(FConnection) then
  begin
    try
      FConnection.Connected := False;
    finally
      FreeAndNil(FConnection);
    end;
  end;
end;

end.

