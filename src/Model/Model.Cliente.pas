unit Model.Cliente;

interface

type
  /// <summary>
  /// Classe que representa um Cliente no sistema
  /// Implementa encapsulamento e princípios de OOP
  /// </summary>
  TCliente = class
  private
    FCodigo: Integer;
    FNome: string;
    FCidade: string;
    FUF: string;
    
    procedure SetCodigo(const Value: Integer);
    procedure SetNome(const Value: string);
    procedure SetCidade(const Value: string);
    procedure SetUF(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    
    /// <summary>
    /// Valida os dados do cliente
    /// </summary>
    function Validar(out Mensagem: string): Boolean;
    
    // Properties com encapsulamento
    property Codigo: Integer read FCodigo write SetCodigo;
    property Nome: string read FNome write SetNome;
    property Cidade: string read FCidade write SetCidade;
    property UF: string read FUF write SetUF;
  end;

implementation

uses
  System.SysUtils;

{ TCliente }

constructor TCliente.Create;
begin
  inherited Create;
  FCodigo := 0;
  FNome := '';
  FCidade := '';
  FUF := '';
end;

destructor TCliente.Destroy;
begin
  inherited;
end;

procedure TCliente.SetCodigo(const Value: Integer);
begin
  if Value < 0 then
    raise Exception.Create('Código do cliente não pode ser negativo');
  FCodigo := Value;
end;

procedure TCliente.SetNome(const Value: string);
begin
  FNome := Trim(Value);
end;

procedure TCliente.SetCidade(const Value: string);
begin
  FCidade := Trim(Value);
end;

procedure TCliente.SetUF(const Value: string);
begin
  FUF := UpperCase(Trim(Value));
end;

function TCliente.Validar(out Mensagem: string): Boolean;
begin
  Result := True;
  Mensagem := '';
  
  if Trim(FNome) = '' then
  begin
    Mensagem := 'Nome do cliente é obrigatório';
    Result := False;
    Exit;
  end;
  
  if Length(FNome) < 3 then
  begin
    Mensagem := 'Nome do cliente deve ter no mínimo 3 caracteres';
    Result := False;
    Exit;
  end;
  
  if Trim(FCidade) = '' then
  begin
    Mensagem := 'Cidade é obrigatória';
    Result := False;
    Exit;
  end;
  
  if (Trim(FUF) = '') or (Length(FUF) <> 2) then
  begin
    Mensagem := 'UF deve ter 2 caracteres';
    Result := False;
    Exit;
  end;
end;

end.
