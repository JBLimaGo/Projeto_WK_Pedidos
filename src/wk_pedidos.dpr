program wk_pedidos;

uses
  Vcl.Forms,
  FrmPedidos in 'FrmPedidos.pas' {FPedido},
  uConfig in 'uConfig.pas',
  uConnectionFactory in 'uConnectionFactory.pas',
  uModels in 'uModels.pas',
  uDAOs in 'uDAOs.pas',
  uServices in 'uServices.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPedido, FPedido);
  Application.Run;
end.
