unit uServices;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, uModels, uDAOs;

type
  TPedidoService = class
  public
    class procedure AddItemToPedido(APedido: TPedido; ACodigoProduto: Integer; AQuantidade: Double; AValorUnitario: Currency; AConn: TFDConnection);
    class procedure UpdateItem(APedido: TPedido; AIndex: Integer; AQuantidade: Double; AValorUnitario: Currency);
    class procedure RemoveItem(APedido: TPedido; AIndex: Integer);
    class procedure SavePedido(AConn: TFDConnection; APedido: TPedido);
    class function LoadPedido(AConn: TFDConnection; ANumeroPedido: Int64): TPedido;
    class procedure CancelPedido(AConn: TFDConnection; ANumeroPedido: Int64);
  end;

implementation

{ TPedidoService }

class procedure TPedidoService.AddItemToPedido(APedido: TPedido; ACodigoProduto: Integer; AQuantidade: Double; AValorUnitario: Currency; AConn: TFDConnection);
var
  prod: TProduto;
  item: TPedidoItem;
begin
  if AQuantidade <= 0 then
    raise Exception.Create('Quantidade deve ser maior que zero.');

  if AValorUnitario <= 0 then
    raise Exception.Create('Valor unitário deve ser maior que zero.');

  prod := TProdutoDAO.GetByCodigo(AConn, ACodigoProduto);

  if prod = nil then
    raise Exception.CreateFmt('Produto %d não encontrado.', [ACodigoProduto]);

  item               := TPedidoItem.Create;
  item.CodigoProduto := ACodigoProduto;
  item.Descricao     := prod.Descricao;
  item.Quantidade    := AQuantidade;
  item.ValorUnitario := AValorUnitario;

  APedido.Itens.Add(item);
  APedido.RecalcularTotal;
  prod.Free;
end;

class procedure TPedidoService.UpdateItem(APedido: TPedido; AIndex: Integer; AQuantidade: Double; AValorUnitario: Currency);
var
  it: TPedidoItem;
begin

  if (AIndex < 0) or (AIndex >= APedido.Itens.Count) then
    raise Exception.Create('Item inválido para atualização.');

  it               := APedido.Itens[AIndex];
  it.Quantidade    := AQuantidade;
  it.ValorUnitario := AValorUnitario;
  APedido.RecalcularTotal;
end;

class procedure TPedidoService.RemoveItem(APedido: TPedido; AIndex: Integer);
begin
  if (AIndex < 0) or (AIndex >= APedido.Itens.Count) then
    raise Exception.Create('Item inválido para remoção.');

  APedido.Itens.Delete(AIndex);
  APedido.RecalcularTotal;
end;

class procedure TPedidoService.SavePedido(AConn: TFDConnection; APedido: TPedido);
begin
  if APedido.CodigoCliente <= 0 then
    raise Exception.Create('Código do cliente não informado.');

  if APedido.Itens.Count = 0 then
    raise Exception.Create('Pedido sem itens não pode ser gravado.');

  APedido.RecalcularTotal;
  TPedidoDAO.SavePedido(AConn, APedido);
end;

class function TPedidoService.LoadPedido(AConn: TFDConnection; ANumeroPedido: Int64): TPedido;
begin
  Result := TPedidoDAO.LoadPedido(AConn, ANumeroPedido);
end;

class procedure TPedidoService.CancelPedido(AConn: TFDConnection; ANumeroPedido: Int64);
begin
  TPedidoDAO.CancelPedido(AConn, ANumeroPedido);
end;

end.

