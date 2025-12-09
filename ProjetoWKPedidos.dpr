program ProjetoWKPedidos;

uses
  Vcl.Forms,
  View.Principal in 'src\View\View.Principal.pas' {FormPrincipal},
  Model.Cliente in 'src\Model\Model.Cliente.pas',
  Model.Produto in 'src\Model\Model.Produto.pas',
  Model.ItemPedido in 'src\Model\Model.ItemPedido.pas',
  Model.Pedido in 'src\Model\Model.Pedido.pas',
  DAO.Conexao in 'src\DAO\DAO.Conexao.pas',
  DAO.Cliente in 'src\DAO\DAO.Cliente.pas',
  DAO.Produto in 'src\DAO\DAO.Produto.pas',
  DAO.Pedido in 'src\DAO\DAO.Pedido.pas',
  Controller.Cliente in 'src\Controller\Controller.Cliente.pas',
  Controller.Produto in 'src\Controller\Controller.Produto.pas',
  Controller.Pedido in 'src\Controller\Controller.Pedido.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
