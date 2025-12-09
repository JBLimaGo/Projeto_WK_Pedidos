object FPedido: TFPedido
  Left = 0
  Top = 0
  Caption = 'Pedidos de Venda'
  ClientHeight = 600
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object lblTitulo: TLabel
    Left = 16
    Top = 8
    Width = 160
    Height = 15
    Caption = 'TELA DE PEDIDOS DE VENDA'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 48
    Width = 860
    Height = 100
    Caption = 'Cliente'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 82
      Height = 15
      Caption = 'C'#243'digo Cliente:'
    end
    object lblNomeCliente: TLabel
      Left = 220
      Top = 24
      Width = 36
      Height = 15
      Caption = 'Nome:'
    end
    object lblCidadeCliente: TLabel
      Left = 220
      Top = 48
      Width = 40
      Height = 15
      Caption = 'Cidade:'
    end
    object lblUFCliente: TLabel
      Left = 380
      Top = 48
      Width = 17
      Height = 15
      Caption = 'UF:'
    end
    object edtCodigoCliente: TEdit
      Left = 120
      Top = 20
      Width = 80
      Height = 23
      TabOrder = 0
      OnExit = edtCodigoClienteExit
    end
    object btnLoadPedido: TButton
      Left = 620
      Top = 20
      Width = 120
      Height = 25
      Caption = 'Carregar Pedido'
      TabOrder = 1
      Visible = False
      OnClick = btnLoadPedidoClick
    end
    object btnCancelPedido: TButton
      Left = 620
      Top = 55
      Width = 120
      Height = 25
      Caption = 'Cancelar Pedido'
      TabOrder = 2
      Visible = False
      OnClick = btnCancelPedidoClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 156
    Width = 860
    Height = 110
    Caption = 'Produto'
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 24
      Width = 88
      Height = 15
      Caption = 'C'#243'digo Produto:'
    end
    object Label3: TLabel
      Left = 220
      Top = 24
      Width = 65
      Height = 15
      Caption = 'Quantidade:'
    end
    object Label4: TLabel
      Left = 400
      Top = 24
      Width = 74
      Height = 15
      Caption = 'Valor Unit'#225'rio:'
    end
    object edtCodigoProduto: TEdit
      Left = 120
      Top = 20
      Width = 80
      Height = 23
      TabOrder = 0
    end
    object edtQuantidade: TEdit
      Left = 300
      Top = 20
      Width = 80
      Height = 23
      TabOrder = 1
    end
    object edtValorUnitario: TEdit
      Left = 490
      Top = 20
      Width = 80
      Height = 23
      TabOrder = 2
    end
    object btnInserir: TButton
      Left = 600
      Top = 20
      Width = 140
      Height = 30
      Caption = 'Inserir / Atualizar Item'
      TabOrder = 3
      OnClick = btnInserirClick
    end
  end
  object dbgItens: TDBGrid
    Left = 16
    Top = 272
    Width = 860
    Height = 240
    DataSource = dsItens
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnKeyDown = dbgItensKeyDown
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 520
    Width = 900
    Height = 80
    Align = alBottom
    TabOrder = 3
    object lblTotalPedido: TLabel
      Left = 16
      Top = 16
      Width = 115
      Height = 15
      Caption = 'Total do Pedido: 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnGravar: TButton
      Left = 700
      Top = 16
      Width = 150
      Height = 40
      Caption = 'Gravar Pedido'
      TabOrder = 1
      OnClick = btnGravarClick
    end
    object btnNovo: TButton
      Left = 530
      Top = 16
      Width = 150
      Height = 40
      Caption = 'Novo Pedido'
      TabOrder = 0
      OnClick = btnNovoClick
    end
  end
  object dsItens: TDataSource
    Left = 780
    Top = 350
  end
  object mtItens: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 780
    Top = 310
  end
end
