unit uConfig;

interface

uses
  System.SysUtils, System.IniFiles;

type
  TDBConfig = record
    Database: string;
    Username: string;
    Password: string;
    Server: string;
    Port: Integer;
    LibPath: string;
    SSLMode: Integer;

  end;

function LoadDBConfig(const IniFilePath: string): TDBConfig;

implementation

function LoadDBConfig(const IniFilePath: string): TDBConfig;
var
  Ini: TIniFile;
begin
  if not FileExists(IniFilePath) then
    raise Exception.CreateFmt('Arquivo INI não encontrado: %s', [IniFilePath]);

  Ini := TIniFile.Create(IniFilePath);
  try
    Result.Database := Ini.ReadString('Database', 'Database', '');
    Result.Username := Ini.ReadString('Database', 'Username', '');
    Result.Password := Ini.ReadString('Database', 'Password', '');
    Result.Server   := Ini.ReadString('Database', 'Server', '127.0.0.1');
    Result.Port     := Ini.ReadInteger('Database', 'Port', 3306);
    Result.LibPath  := Ini.ReadString('Database', 'LibPath', '');

    if Result.Database = '' then
      raise Exception.Create('Parâmetro Database não informado no INI.');
  finally
    Ini.Free;
  end;
end;

end.

