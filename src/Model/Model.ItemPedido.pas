unit Model.ItemPedido;

interface

uses
  Model.Produto;

type
  /// <summary>
  /// Classe que representa um Item de Pedido
  /// Implementa composição (tem-um relacionamento com Produto)
  /// </summary>
  TItemPedido = class
  private
    FId: Integer;
    FCodigoProduto: Integer;
    FQuantidade: Double;
    FValorUnitario: Currency;
    FValorTotal: Currency;
    
    procedure SetCodigoProduto(const Value: Integer);
    procedure SetQuantidade(const Value: Double);
    procedure SetValorUnitario(const Value: Currency);
    procedure CalcularValorTotal;
  public
    constructor Create;
    destructor Destroy; override;
    
    /// <summary>
    /// Valida os dados do item do pedido
    /// </summary>
    function Validar(out Mensagem: string): Boolean;
    
    /// <summary>
    /// Calcula o valor total do item (Quantidade * ValorUnitario)
    /// </summary>
    procedure AtualizarValorTotal;
    
    // Properties com encapsulamento
    property Id: Integer read FId write FId;
    property CodigoProduto: Integer read FCodigoProduto write SetCodigoProduto;
    property Quantidade: Double read FQuantidade write SetQuantidade;
    property ValorUnitario: Currency read FValorUnitario write SetValorUnitario;
    property ValorTotal: Currency read FValorTotal;
  end;

implementation

uses
  System.SysUtils;

{ TItemPedido }

constructor TItemPedido.Create;
begin
  inherited Create;
  FId := 0;
  FCodigoProduto := 0;
  FQuantidade := 0;
  FValorUnitario := 0;
  FValorTotal := 0;
end;

destructor TItemPedido.Destroy;
begin
  inherited;
end;

procedure TItemPedido.SetCodigoProduto(const Value: Integer);
begin
  if Value < 0 then
    raise Exception.Create('Código do produto não pode ser negativo');
  FCodigoProduto := Value;
end;

procedure TItemPedido.SetQuantidade(const Value: Double);
begin
  if Value <= 0 then
    raise Exception.Create('Quantidade deve ser maior que zero');
  FQuantidade := Value;
  CalcularValorTotal;
end;

procedure TItemPedido.SetValorUnitario(const Value: Currency);
begin
  if Value < 0 then
    raise Exception.Create('Valor unitário não pode ser negativo');
  FValorUnitario := Value;
  CalcularValorTotal;
end;

procedure TItemPedido.CalcularValorTotal;
begin
  FValorTotal := FQuantidade * FValorUnitario;
end;

procedure TItemPedido.AtualizarValorTotal;
begin
  CalcularValorTotal;
end;

function TItemPedido.Validar(out Mensagem: string): Boolean;
begin
  Result := True;
  Mensagem := '';
  
  if FCodigoProduto <= 0 then
  begin
    Mensagem := 'Produto não informado';
    Result := False;
    Exit;
  end;
  
  if FQuantidade <= 0 then
  begin
    Mensagem := 'Quantidade deve ser maior que zero';
    Result := False;
    Exit;
  end;
  
  if FValorUnitario <= 0 then
  begin
    Mensagem := 'Valor unitário deve ser maior que zero';
    Result := False;
    Exit;
  end;
end;

end.
