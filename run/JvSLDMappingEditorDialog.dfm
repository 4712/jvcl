object frmSLDMappingEditorDialog: TfrmSLDMappingEditorDialog
  Left = 296
  Top = 191
  BorderStyle = bsDialog
  Caption = 'Mapping Editor...'
  ClientHeight = 175
  ClientWidth = 410
  Color = clBtnFace
  Constraints.MaxHeight = 221
  Constraints.MinHeight = 221
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = EditorFrame.mnuCharMapEdit
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object lblDigitClassCaption: TLabel
    Left = 120
    Top = 15
    Width = 51
    Height = 13
    Caption = 'Digit class:'
  end
  object lblSegmentCountCaption: TLabel
    Left = 120
    Top = 40
    Width = 70
    Height = 13
    Caption = '# of segments:'
  end
  object lblCharCaption: TLabel
    Left = 120
    Top = 65
    Width = 49
    Height = 13
    Caption = 'Character:'
  end
  object lblMapperValueCaption: TLabel
    Left = 120
    Top = 90
    Width = 73
    Height = 13
    Caption = 'Mapping value:'
  end
  object lblSegmentsCaption: TLabel
    Left = 120
    Top = 115
    Width = 50
    Height = 13
    Caption = 'Segments:'
  end
  object lblDigitClass: TLabel
    Left = 205
    Top = 15
    Width = 200
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblSegmentCount: TLabel
    Left = 205
    Top = 40
    Width = 200
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblChar: TLabel
    Left = 205
    Top = 65
    Width = 200
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblMapperValue: TLabel
    Left = 205
    Top = 90
    Width = 200
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblSegments: TLabel
    Left = 205
    Top = 115
    Width = 200
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  inline EditorFrame: TfmeJvSegmentedLEDDisplayMapper
    Left = 5
    Top = 5
    PopupMenu = EditorFrame.pmDigit
  end
  object btnOK: TButton
    Left = 330
    Top = 145
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
  end
end
