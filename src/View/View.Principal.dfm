object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  Caption = 'Sistema de Pedidos WK - Delphi 10.4 Sydney'
  ClientHeight = 500
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 500
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 48
      Width = 346
      Height = 29
      Caption = 'Sistema de Pedidos WK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 32
      Top = 96
      Width = 219
      Height = 16
      Caption = 'Desenvolvido em Delphi 10.4 Sydney'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 32
      Top = 160
      Width = 274
      Height = 16
      Caption = 'Arquitetura: MVC (Model-View-Controller)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 32
      Top = 200
      Width = 426
      Height = 208
      Caption = 
        'Caracter'#237'sticas Implementadas:'#13#10#13#10'- Programa'#231#227'o Orientada a Obj' +
        'etos (POO)'#13#10'- Encapsulamento e Heran'#231'a'#13#10'- Padr'#227'o MVC (Model-Vi' +
        'ew-Controller)'#13#10'- Padr'#227'o DAO (Data Access Object)'#13#10'- Padr'#227'o Si' +
        'ngleton para conex'#227'o'#13#10'- Clean Code e boas pr'#225'ticas'#13#10'- Valida'#231 +
        #245'es de neg'#243'cio'#13#10'- Transa'#231#245'es de banco de dados'#13#10'- Tratamento' +
        ' de exce'#231#245'es'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object MainMenu1: TMainMenu
    Left = 720
    Top = 8
    object MenuCadastros: TMenuItem
      Caption = 'Cadastros'
      object MenuClientes: TMenuItem
        Caption = 'Clientes'
        OnClick = MenuClientesClick
      end
      object MenuProdutos: TMenuItem
        Caption = 'Produtos'
        OnClick = MenuProdutosClick
      end
    end
    object MenuMovimentos: TMenuItem
      Caption = 'Movimentos'
      object MenuPedidos: TMenuItem
        Caption = 'Pedidos'
        OnClick = MenuPedidosClick
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MenuSair: TMenuItem
      Caption = 'Sair'
      OnClick = MenuSairClick
    end
  end
end
