unit uDAOs;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, FireDAC.Comp.Client,
  FireDAC.Stan.Param, uModels, uConnectionFactory, FireDAC.Stan.Intf, Data.DB;

type
  TClienteDAO = class
  public
    class function GetByCodigo(AConn: TFDConnection; ACodigo: Integer): TCliente;
  end;

  TProdutoDAO = class
  public
    class function GetByCodigo(AConn: TFDConnection; ACodigo: Integer): TProduto;
  end;

  TPedidoDAO = class
  public
    /// Gera número de pedido sequencial
    class function GeneratePedidoNumber(AConn: TFDConnection): Int64;
    /// Grava pedido e itens
    class procedure SavePedido(AConn: TFDConnection; APedido: TPedido);
    /// Carrega pedido
    class function LoadPedido(AConn: TFDConnection; ANumeroPedido: Int64): TPedido;
    /// Cancela pedido (apaga pedidos e itens)
    class procedure CancelPedido(AConn: TFDConnection; ANumeroPedido: Int64);
  end;

implementation

{ TClienteDAO }

class function TClienteDAO.GetByCodigo(AConn: TFDConnection; ACodigo: Integer): TCliente;
var
  q: TFDQuery;
begin
  Result := nil;
  q := TFDQuery.Create(nil);
  try
    q.Connection := AConn;
    q.SQL.Text   := 'SELECT codigo, nome, cidade, uf FROM clientes WHERE codigo = :cod';
    q.ParamByName('cod').AsInteger := ACodigo;
    q.Open;

    if not q.IsEmpty then
      begin
        Result        := TCliente.Create;
        Result.Codigo := q.FieldByName('codigo').AsInteger;
        Result.Nome   := q.FieldByName('nome').AsString;
        Result.Cidade := q.FieldByName('cidade').AsString;
        Result.UF     := q.FieldByName('uf').AsString;
      end;
  finally
    q.Free;
  end;
end;

{ TProdutoDAO }

class function TProdutoDAO.GetByCodigo(AConn: TFDConnection; ACodigo: Integer): TProduto;
var
  q: TFDQuery;
begin
  Result := nil;
  q := TFDQuery.Create(nil);
  try
    q.Connection := AConn;
    q.SQL.Text   := 'SELECT codigo, descricao, preco_venda FROM produtos WHERE codigo = :cod';
    q.ParamByName('cod').AsInteger := ACodigo;
    q.Open;

    if not q.IsEmpty then
      begin
        Result             := TProduto.Create;
        Result.Codigo      := q.FieldByName('codigo').AsInteger;
        Result.Descricao   := q.FieldByName('descricao').AsString;
        Result.PrecoVenda  := q.FieldByName('preco_venda').AsCurrency;
      end;
  finally
    q.Free;
  end;
end;

{ TPedidoDAO }

class function TPedidoDAO.GeneratePedidoNumber(AConn: TFDConnection): Int64;
var
  q: TFDQuery;
begin
  // Usa tabela pedido_seq; faz SELECT ... FOR UPDATE para garantir sequência única na transação
  q := TFDQuery.Create(nil);
  try
    q.Connection := AConn;
    q.SQL.Text   := 'SELECT last_no FROM pedido_seq WHERE id = 1 FOR UPDATE';
    q.Open;

    if q.IsEmpty then
      raise Exception.Create('Sequência de pedidos não inicializada (pedido_seq).');

    Result := q.FieldByName('last_no').AsLargeInt + 1;

    q.Close;
    q.SQL.Text                      := 'UPDATE pedido_seq SET last_no = :new WHERE id = 1';
    q.ParamByName('new').AsLargeInt := Result;
    q.ExecSQL;

  finally
    q.Free;
  end;
end;

class procedure TPedidoDAO.SavePedido(AConn: TFDConnection; APedido: TPedido);
var
  q: TFDQuery;
  i: Integer;
  it: TPedidoItem;
begin
  if APedido = nil then
    raise Exception.Create('Pedido inválido.');

  q := TFDQuery.Create(nil);
  try
    q.Connection := AConn;

    // Inicia transação
    AConn.StartTransaction;
    try
      // Se número do pedido = 0, gerar novo
      if APedido.NumeroPedido = 0 then
        APedido.NumeroPedido := GeneratePedidoNumber(AConn);

      // Inserir na tabela pedidos
      q.SQL.Text := 'INSERT INTO pedidos (numero_pedido, data_emissao, codigo_cliente, valor_total) ' +
                    'VALUES (:num, :data, :codcli, :valor)';

      q.Params[0].AsLargeInt := APedido.NumeroPedido;
      q.ParamByName('data').AsDateTime := APedido.DataEmissao;
      q.ParamByName('codcli').AsInteger := APedido.CodigoCliente;
      q.ParamByName('valor').AsCurrency := APedido.ValorTotal;
      q.ExecSQL;

      // Inserir itens
      for i := 0 to APedido.Itens.Count - 1 do
      begin
        it := APedido.Itens[i];
        q.SQL.Text := 'INSERT INTO pedido_produtos (numero_pedido, codigo_produto, quantidade, valor_unitario, valor_total) ' +
                      'VALUES (:num, :codprod, :qtde, :vunit, :vtotal)';

        q.ParamByName('num').AsLargeInt := APedido.NumeroPedido;
        q.ParamByName('codprod').AsInteger := it.CodigoProduto;
        q.ParamByName('qtde').AsFloat := it.Quantidade;
        q.ParamByName('vunit').AsCurrency := it.ValorUnitario;
        q.ParamByName('vtotal').AsCurrency := it.ValorTotal;
        q.ExecSQL;
      end;

      AConn.Commit;
    except
      on E: Exception do
      begin
        AConn.Rollback;
        raise; // propaga exceção para camada superior
      end;
    end;
  finally
    q.Free;
  end;
end;

class function TPedidoDAO.LoadPedido(AConn: TFDConnection; ANumeroPedido: Int64): TPedido;
var
  q: TFDQuery;
  itm: TPedidoItem;
begin
  Result := nil;
  q := TFDQuery.Create(nil);
  try
    q.Connection := AConn;

    // Carrega dados gerais
    q.SQL.Text := 'SELECT numero_pedido, data_emissao, codigo_cliente, valor_total FROM pedidos WHERE numero_pedido = :num';
    q.ParamByName('num').AsLargeInt := ANumeroPedido;
    q.Open;

    if q.IsEmpty then
      Exit;

    Result := TPedido.Create;
    Result.NumeroPedido := q.FieldByName('numero_pedido').AsLargeInt;
    Result.DataEmissao := q.FieldByName('data_emissao').AsDateTime;
    Result.CodigoCliente := q.FieldByName('codigo_cliente').AsInteger;
    Result.ValorTotal := q.FieldByName('valor_total').AsCurrency;
    q.Close;

    // Carrega itens
    q.SQL.Text := 'SELECT autoincrem, codigo_produto,  produtos.descricao, quantidade, valor_unitario, valor_total FROM pedido_produtos inner join produtos on (pedido_produtos.codigo_produto = produtos.codigo) WHERE numero_pedido = :num ORDER BY autoincrem';
    q.ParamByName('num').AsLargeInt := ANumeroPedido;
    q.Open;

    while not q.Eof do
      begin
        itm := TPedidoItem.Create;
        itm.Autoincrem       := q.FieldByName('autoincrem').AsLargeInt;
        itm.CodigoProduto    := q.FieldByName('codigo_produto').AsInteger;
        itm.Quantidade       := q.FieldByName('quantidade').AsFloat;
        itm.ValorUnitario    := q.FieldByName('valor_unitario').AsCurrency;
        itm.Descricao        := q.FieldByName('descricao').AsString;
        Result.Itens.Add(itm);
        q.Next;
      end;

  finally
    q.Free;
  end;
end;

class procedure TPedidoDAO.CancelPedido(AConn: TFDConnection; ANumeroPedido: Int64);
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  try
    q.Connection := AConn;
    AConn.StartTransaction;
    try
      // Apaga itens
      q.SQL.Text := 'DELETE FROM pedido_produtos WHERE numero_pedido = :num';
      q.ParamByName('num').AsLargeInt := ANumeroPedido;
      q.ExecSQL;

      // Apaga pedido
      q.SQL.Text := 'DELETE FROM pedidos WHERE numero_pedido = :num';
      q.ParamByName('num').AsLargeInt := ANumeroPedido;
      q.ExecSQL;

      AConn.Commit;
    except
      on E: Exception do
      begin
        AConn.Rollback;
        raise;
      end;
    end;
  finally
    q.Free;
  end;
end;

end.

