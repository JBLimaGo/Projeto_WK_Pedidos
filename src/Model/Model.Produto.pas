unit Model.Produto;

interface

type
  /// <summary>
  /// Classe que representa um Produto no sistema
  /// Implementa encapsulamento e princípios de OOP
  /// </summary>
  TProduto = class
  private
    FCodigo: Integer;
    FDescricao: string;
    FPrecoVenda: Currency;
    
    procedure SetCodigo(const Value: Integer);
    procedure SetDescricao(const Value: string);
    procedure SetPrecoVenda(const Value: Currency);
  public
    constructor Create;
    destructor Destroy; override;
    
    /// <summary>
    /// Valida os dados do produto
    /// </summary>
    function Validar(out Mensagem: string): Boolean;
    
    // Properties com encapsulamento
    property Codigo: Integer read FCodigo write SetCodigo;
    property Descricao: string read FDescricao write SetDescricao;
    property PrecoVenda: Currency read FPrecoVenda write SetPrecoVenda;
  end;

implementation

uses
  System.SysUtils;

{ TProduto }

constructor TProduto.Create;
begin
  inherited Create;
  FCodigo := 0;
  FDescricao := '';
  FPrecoVenda := 0;
end;

destructor TProduto.Destroy;
begin
  inherited;
end;

procedure TProduto.SetCodigo(const Value: Integer);
begin
  if Value < 0 then
    raise Exception.Create('Código do produto não pode ser negativo');
  FCodigo := Value;
end;

procedure TProduto.SetDescricao(const Value: string);
begin
  FDescricao := Trim(Value);
end;

procedure TProduto.SetPrecoVenda(const Value: Currency);
begin
  if Value < 0 then
    raise Exception.Create('Preço de venda não pode ser negativo');
  FPrecoVenda := Value;
end;

function TProduto.Validar(out Mensagem: string): Boolean;
begin
  Result := True;
  Mensagem := '';
  
  if Trim(FDescricao) = '' then
  begin
    Mensagem := 'Descrição do produto é obrigatória';
    Result := False;
    Exit;
  end;
  
  if Length(FDescricao) < 3 then
  begin
    Mensagem := 'Descrição do produto deve ter no mínimo 3 caracteres';
    Result := False;
    Exit;
  end;
  
  if FPrecoVenda <= 0 then
  begin
    Mensagem := 'Preço de venda deve ser maior que zero';
    Result := False;
    Exit;
  end;
end;

end.
