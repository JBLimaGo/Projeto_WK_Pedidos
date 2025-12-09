unit uModels;

interface

uses
  System.SysUtils, System.Generics.Collections, Math;

type

  //  MODEL: Cliente
  TCliente = class
  private
    FCodigo: Integer;
    FNome: string;
    FCidade: string;
    FUF: string;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property Cidade: string read FCidade write FCidade;
    property UF: string read FUF write FUF;
  end;

  //  MODEL: Produto
  TProduto = class
  private
    FCodigo: Integer;
    FDescricao: string;
    FPrecoVenda: Currency;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Descricao: string read FDescricao write FDescricao;
    property PrecoVenda: Currency read FPrecoVenda write FPrecoVenda;
  end;

  //  MODEL: Itens do Pedido
  TPedidoItem = class
  private
    FAutoincrem: Int64;
    FCodigoProduto: Integer;
    FDescricao: string;
    FQuantidade: Double;
    FValorUnitario: Currency;
    function GetValorTotal: Currency;
  public
    property Autoincrem: Int64 read FAutoincrem write FAutoincrem;
    property CodigoProduto: Integer read FCodigoProduto write FCodigoProduto;
    property Descricao: string read FDescricao write FDescricao;
    property Quantidade: Double read FQuantidade write FQuantidade;
    property ValorUnitario: Currency read FValorUnitario write FValorUnitario;
    property ValorTotal: Currency read GetValorTotal;
  end;

  //  MODEL: Pedido
  TPedido = class
  private
    FNumeroPedido: Int64;
    FDataEmissao: TDateTime;
    FCodigoCliente: Integer;
    FValorTotal: Currency;
    FItens: TObjectList<TPedidoItem>;
  public
    constructor Create;
    destructor Destroy; override;

    property NumeroPedido: Int64 read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
    property Itens: TObjectList<TPedidoItem> read FItens;

    procedure RecalcularTotal;
  end;

implementation

{ TPedidoItem }

function TPedidoItem.GetValorTotal: Currency;
begin
  Result := RoundTo(FQuantidade * FValorUnitario, -2);
end;

{ TPedido }

constructor TPedido.Create;
begin
  FItens := TObjectList<TPedidoItem>.Create(True);
  FDataEmissao := Now;
  FValorTotal := 0;
end;

destructor TPedido.Destroy;
begin
  FItens.Free;
  inherited;
end;

procedure TPedido.RecalcularTotal;
var
  it: TPedidoItem;
begin
  FValorTotal := 0;
  for it in FItens do
    FValorTotal := FValorTotal + it.ValorTotal;
end;

end.

