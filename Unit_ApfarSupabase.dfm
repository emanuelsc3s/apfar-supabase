object Form_Principal: TForm_Principal
  Left = 0
  Top = 0
  Caption = 'Form_Principal'
  ClientHeight = 350
  ClientWidth = 863
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
  object btn_Importar: TPanel
    Left = 609
    Top = 303
    Width = 120
    Height = 35
    Cursor = crHandPoint
    BevelOuter = bvNone
    Caption = 'Importar'
    Color = 12477460
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    OnClick = btn_ImportarClick
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
    Left = 368
    Top = 112
  end
  object qSupabase: TFDQuery
    Connection = FDConnectionSupabase
    Left = 368
    Top = 216
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files\PostgreSQL\17\bin\libpq.dll'
    Left = 368
    Top = 160
  end
  object FDConnectionTOTVS: TFDConnection
    Left = 488
    Top = 120
  end
  object FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink
    Left = 488
    Top = 176
  end
  object qTOTVS: TFDQuery
    Connection = FDConnectionTOTVS
    Left = 488
    Top = 232
  end
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = qSupabase
    Left = 368
    Top = 272
  end
end
