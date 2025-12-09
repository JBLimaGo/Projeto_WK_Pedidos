unit View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  /// <summary>
  /// Formulário principal da aplicação
  /// Implementa a camada View do padrão MVC
  /// </summary>
  TFormPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    MenuCadastros: TMenuItem;
    MenuClientes: TMenuItem;
    MenuProdutos: TMenuItem;
    N1: TMenuItem;
    MenuSair: TMenuItem;
    MenuMovimentos: TMenuItem;
    MenuPedidos: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure MenuClientesClick(Sender: TObject);
    procedure MenuProdutosClick(Sender: TObject);
    procedure MenuPedidosClick(Sender: TObject);
    procedure MenuSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure TestarConexao;
  public
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses
  DAO.Conexao;

{$R *.dfm}

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  TestarConexao;
end;

procedure TFormPrincipal.TestarConexao;
begin
  try
    if TConexao.GetInstancia.TestarConexao then
      ShowMessage('Conexão com banco de dados estabelecida com sucesso!')
    else
      ShowMessage('Erro ao conectar com o banco de dados. Verifique as configurações.');
  except
    on E: Exception do
      ShowMessage('Erro ao testar conexão: ' + E.Message);
  end;
end;

procedure TFormPrincipal.MenuClientesClick(Sender: TObject);
begin
  ShowMessage('Módulo de Clientes em desenvolvimento');
  // Aqui seria chamado: FormCliente.ShowModal;
end;

procedure TFormPrincipal.MenuProdutosClick(Sender: TObject);
begin
  ShowMessage('Módulo de Produtos em desenvolvimento');
  // Aqui seria chamado: FormProduto.ShowModal;
end;

procedure TFormPrincipal.MenuPedidosClick(Sender: TObject);
begin
  ShowMessage('Módulo de Pedidos em desenvolvimento');
  // Aqui seria chamado: FormPedido.ShowModal;
end;

procedure TFormPrincipal.MenuSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
