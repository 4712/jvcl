object Form2: TForm2
  Left = 311
  Top = 300
  Width = 199
  Height = 188
  BorderStyle = bsSizeToolWin
  Caption = 'VC++ Style'
  Color = clBtnFace
  DockSite = True
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 191
    Height = 161
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel1'
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Shell Dlg 2'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Memo1: TMemo
      Left = 2
      Top = 2
      Width = 187
      Height = 157
      Align = alClient
      BorderStyle = bsNone
      ImeName = #215#207#185#226#198#180#210#244#202#228#200#235#183#168
      TabOrder = 0
    end
  end
  object lbDockClient1: TJvDockClient
    OnFormShow = lbDockClient1FormShow
    OnFormHide = lbDockClient1FormHide
    LRDockWidth = 100
    TBDockHeight = 100
    DirectDrag = True
    ShowHint = True
    EnableCloseButton = True
    EachOtherDock = False
    Left = 48
    Top = 40
  end
end
