object Form_ConfigSqlServer: TForm_ConfigSqlServer
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Configura'#231#227'o FD MS SQL Server'
  ClientHeight = 406
  ClientWidth = 637
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 80
    Width = 39
    Height = 13
    Caption = 'Server'
  end
  object Label2: TLabel
    Left = 16
    Top = 124
    Width = 54
    Height = 13
    Caption = 'Database'
  end
  object Label3: TLabel
    Left = 16
    Top = 168
    Width = 58
    Height = 13
    Caption = 'Username'
  end
  object Label4: TLabel
    Left = 16
    Top = 212
    Width = 54
    Height = 13
    Caption = 'Password'
  end
  object Label6: TLabel
    Left = 16
    Top = 250
    Width = 47
    Height = 13
    Caption = 'Network'
  end
  object Label7: TLabel
    Left = 16
    Top = 294
    Width = 46
    Height = 13
    Caption = 'Address'
  end
  object Label8: TLabel
    Left = 16
    Top = 338
    Width = 61
    Height = 13
    Caption = 'OSAuthent'
  end
  object Label9: TLabel
    Left = 346
    Top = 80
    Width = 33
    Height = 13
    Caption = 'MARS'
  end
  object Label10: TLabel
    Left = 346
    Top = 124
    Width = 67
    Height = 13
    Caption = 'Workstation'
  end
  object Label11: TLabel
    Left = 346
    Top = 168
    Width = 99
    Height = 13
    Caption = 'Application Name'
  end
  object Label12: TLabel
    Left = 346
    Top = 212
    Width = 60
    Height = 13
    Caption = 'Vendor Lib'
  end
  object Label14: TLabel
    Left = 75
    Top = 10
    Width = 340
    Height = 29
    Caption = 'Configura'#195#167#195#163'o MS SQL Server'
    Color = clWindow
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -24
    Font.Name = 'Trebuchet MS'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object EditServer: TEdit
    Left = 130
    Top = 77
    Width = 209
    Height = 21
    TabOrder = 0
  end
  object EditDatabase: TEdit
    Left = 130
    Top = 121
    Width = 209
    Height = 21
    TabOrder = 1
  end
  object EditUsername: TEdit
    Left = 130
    Top = 165
    Width = 209
    Height = 21
    TabOrder = 2
  end
  object EditPassword: TEdit
    Left = 130
    Top = 209
    Width = 209
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object EditNetwork: TEdit
    Left = 130
    Top = 247
    Width = 209
    Height = 21
    TabOrder = 4
  end
  object EditAddress: TEdit
    Left = 130
    Top = 291
    Width = 209
    Height = 21
    TabOrder = 5
  end
  object ComboBoxOSAuthent: TComboBox
    Left = 130
    Top = 335
    Width = 209
    Height = 21
    Style = csDropDownList
    TabOrder = 6
    Items.Strings = (
      'Yes'#11
      'No')
  end
  object ComboBoxMARS: TComboBox
    Left = 458
    Top = 77
    Width = 164
    Height = 21
    Style = csDropDownList
    TabOrder = 7
    Items.Strings = (
      'Yes'
      'No')
  end
  object EditWorkstation: TEdit
    Left = 458
    Top = 121
    Width = 164
    Height = 21
    TabOrder = 8
  end
  object EditApplicationName: TEdit
    Left = 458
    Top = 165
    Width = 164
    Height = 21
    TabOrder = 9
  end
  object EditVendorLib: TEdit
    Left = 458
    Top = 209
    Width = 164
    Height = 21
    TabOrder = 10
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 637
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    Color = 12477460
    ParentBackground = False
    TabOrder = 11
    object Image2: TImage
      Left = 16
      Top = 10
      Width = 48
      Height = 48
      Stretch = True
    end
    object Label15: TLabel
      Left = 75
      Top = 10
      Width = 311
      Height = 29
      Caption = 'Configura'#231#227'o MS SQL Server'
      Color = clWindow
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -24
      Font.Name = 'Trebuchet MS'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label16: TLabel
      Left = 75
      Top = 38
      Width = 490
      Height = 16
      Caption = 
        'Informe os par'#226'metros necess'#225'rios para conex'#227'o '#224' base de dados M' +
        'S SQL Server...'
      Color = clWindow
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = '.'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
  end
  object btnSalvar: TPanel
    Left = 414
    Top = 362
    Width = 100
    Height = 35
    Cursor = crHandPoint
    BevelOuter = bvNone
    Caption = 'Salvar'
    Color = 12477460
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 12
    OnClick = btnSalvarClick
  end
  object btnFechar: TPanel
    Left = 522
    Top = 362
    Width = 100
    Height = 35
    Cursor = crHandPoint
    BevelOuter = bvNone
    Caption = 'Fechar'
    Color = clGray
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 13
    OnClick = btnFecharClick
  end
end
