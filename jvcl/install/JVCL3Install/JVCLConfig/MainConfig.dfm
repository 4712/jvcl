object FormMainConfig: TFormMainConfig
  Left = 140
  Top = 111
  BorderStyle = bsDialog
  Caption = 'JVCL Configuration'
  ClientHeight = 397
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BevelBorder: TBevel
    Left = 278
    Top = 48
    Width = 462
    Height = 141
  end
  object Label1: TLabel
    Left = 280
    Top = 200
    Width = 439
    Height = 16
    Caption = 
      'jvcl.inc changes are global to all installed Delphi/BCB versions' +
      '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CheckListBox: TCheckListBox
    Left = 0
    Top = 48
    Width = 273
    Height = 349
    OnClickCheck = CheckListBoxClickCheck
    Align = alLeft
    ItemHeight = 16
    Style = lbOwnerDrawFixed
    TabOrder = 0
    OnClick = CheckListBoxClick
  end
  object ScrollBox: TScrollBox
    Left = 280
    Top = 49
    Width = 457
    Height = 137
    BorderStyle = bsNone
    TabOrder = 1
    object LblComment: TLabel
      Left = 8
      Top = 8
      Width = 58
      Height = 13
      Caption = 'LblComment'
    end
  end
  object BtnReload: TBitBtn
    Left = 280
    Top = 368
    Width = 113
    Height = 25
    Caption = '&Reload from file'
    TabOrder = 2
    OnClick = BtnReloadClick
  end
  object BtnQuit: TBitBtn
    Left = 664
    Top = 368
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Quit'
    TabOrder = 4
    OnClick = BtnQuitClick
  end
  object BtnSave: TBitBtn
    Left = 576
    Top = 368
    Width = 75
    Height = 25
    Caption = '&Save'
    TabOrder = 3
    OnClick = BtnSaveClick
  end
  object TitlePanel: TPanel
    Left = 0
    Top = 0
    Width = 744
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 5
    DesignSize = (
      744
      44)
    object imgProjectJEDI: TImage
      Left = 620
      Top = 5
      Width = 116
      Height = 31
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      AutoSize = True
    end
    object Label4: TLabel
      Left = 8
      Top = 13
      Width = 396
      Height = 18
      Caption = 'Project JEDI   JVCL 3 Installer - jvcl.inc Editor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BevelHeader: TBevel
      Left = 0
      Top = 34
      Width = 744
      Height = 10
      Align = alBottom
      Shape = bsBottomLine
    end
    object LabelTmp1: TLabel
      Left = 632
      Top = 16
      Width = 92
      Height = 13
      Caption = 'Assigned to runtime'
      Visible = False
    end
  end
  object PanelSpace: TPanel
    Left = 0
    Top = 44
    Width = 744
    Height = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 6
  end
end
