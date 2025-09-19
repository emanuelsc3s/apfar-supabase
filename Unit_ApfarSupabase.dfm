object Form_Principal: TForm_Principal
  Left = 0
  Top = 0
  Caption = 'Form_Principal'
  ClientHeight = 404
  ClientWidth = 872
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 847
    Height = 289
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Verdana'
    TitleFont.Style = []
  end
  object btn_ImportarReceber: TPanel
    Left = 609
    Top = 303
    Width = 120
    Height = 35
    Cursor = crHandPoint
    BevelOuter = bvNone
    Caption = 'Imp. Receber'
    Color = 12477460
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    OnClick = btn_ImportarReceberClick
  end
  object btn_Fechar: TPanel
    Left = 735
    Top = 303
    Width = 120
    Height = 35
    Cursor = crHandPoint
    BevelOuter = bvNone
    Caption = 'Fechar'
    Color = 12477460
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    OnClick = btn_FecharClick
  end
  object btn_Configurar: TPanel
    Left = 8
    Top = 303
    Width = 120
    Height = 35
    Cursor = crHandPoint
    BevelOuter = bvNone
    Caption = 'Configurar BD'
    Color = 12477460
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
    OnClick = btn_ConfigurarClick
  end
  object btn_ImportarLicitacao: TPanel
    Left = 483
    Top = 303
    Width = 120
    Height = 35
    Cursor = crHandPoint
    BevelOuter = bvNone
    Caption = 'Imp. Licita'#231#227'o'
    Color = 12477460
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 4
    OnClick = btn_ImportarLicitacaoClick
  end
  object btn_ImportarLoteDesvio: TPanel
    Left = 134
    Top = 303
    Width = 141
    Height = 35
    Cursor = crHandPoint
    BevelOuter = bvNone
    Caption = 'Imp. Lote Desvio'
    Color = 12477460
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 5
    OnClick = btn_ImportarLoteDesvioClick
  end
  object btn_Cliente: TPanel
    Left = 357
    Top = 303
    Width = 120
    Height = 35
    Cursor = crHandPoint
    BevelOuter = bvNone
    Caption = 'Imp. Cliente'
    Color = 12477460
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 6
    OnClick = btn_ClienteClick
  end
  object btn_ExportaCotacao: TPanel
    Left = 357
    Top = 351
    Width = 120
    Height = 35
    Cursor = crHandPoint
    BevelOuter = bvNone
    Caption = 'Exp. Cota'#231#227'o'
    Color = 12477460
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 7
    OnClick = btn_ExportaCotacaoClick
  end
  object btn_ImportarLicitacaoItem: TPanel
    Left = 483
    Top = 351
    Width = 120
    Height = 35
    Cursor = crHandPoint
    BevelOuter = bvNone
    Caption = 'Imp. Licita'#231#227'o'
    Color = 12477460
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 8
    OnClick = btn_ImportarLicitacaoItemClick
  end
  object btn_ImportarProduto: TPanel
    Left = 609
    Top = 351
    Width = 120
    Height = 35
    Cursor = crHandPoint
    BevelOuter = bvNone
    Caption = 'Imp. Receber'
    Color = 12477460
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 9
    OnClick = btn_ImportarProdutoClick
  end
  object FDConnectionSupabase: TFDConnection
    Params.Strings = (
      'Server=aws-0-sa-east-1.pooler.supabase.com'
      'Database=postgres'
      'User_Name=postgres.dojavjvqvobnumebaouc'
      'Password=aUilaqvCRLaFLOqr'
      'LoginTimeout=30'
      'MetaCurSchema=public'
      'Port=6543'
      'DriverID=PG')
    LoginPrompt = False
    Left = 272
    Top = 16
  end
  object qSupabase: TFDQuery
    Connection = FDConnectionSupabase
    Left = 272
    Top = 120
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files\PostgreSQL\17\bin\libpq.dll'
    Left = 272
    Top = 64
  end
  object FDConnectionTOTVS: TFDConnection
    Left = 392
    Top = 24
  end
  object FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink
    Left = 392
    Top = 80
  end
  object qTOTVS: TFDQuery
    Connection = FDConnectionTOTVS
    Left = 392
    Top = 136
  end
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = qTOTVS
    Left = 392
    Top = 192
  end
  object FDConnectionSICFAR: TFDConnection
    Left = 528
    Top = 24
  end
  object qSICFAR: TFDQuery
    Connection = FDConnectionSICFAR
    Left = 528
    Top = 136
  end
  object FBDriverLink: TFDPhysFBDriverLink
    Left = 528
    Top = 80
  end
end
