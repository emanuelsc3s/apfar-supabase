object Form_Principal: TForm_Principal
  Left = 0
  Top = 0
  Caption = 'Form_Principal'
  ClientHeight = 359
  ClientWidth = 863
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 847
    Height = 313
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Verdana'
    TitleFont.Style = []
  end
  object btn_Importar: TButton
    Left = 780
    Top = 327
    Width = 75
    Height = 25
    Caption = 'Importar'
    TabOrder = 1
    OnClick = btn_ImportarClick
  end
  object FDConnection1: TFDConnection
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
    Connection = FDConnection1
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
