object frmMain: TfrmMain
  Left = 267
  Top = 113
  Width = 543
  Height = 393
  Caption = 'TJvUrlListGrabber demo'
  Color = clBtnFace
  Constraints.MinHeight = 390
  Constraints.MinWidth = 540
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblExpl: TLabel
    Left = 4
    Top = 148
    Width = 397
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Please use the memo below to indicate one URL per line. Those ur' +
      'l will then be grabbed by the component when you press Go in the' +
      ' Design Time box'
    WordWrap = True
  end
  object memExplanation: TMemo
    Left = 7
    Top = 4
    Width = 520
    Height = 133
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'This is the demo for TJvUrlListGrabber.'
      
        'This component takes a list of strings through its Urls property' +
        ', each representing a URL to grab. At present '
      'it only supports HTTP and FTP URLs.'
      
        'This component is intended to replace TJvHttpGrabber, TJvFtpGrab' +
        'ber and TJvMultiHttpGrabber. '
      
        'As it is still in the early stages of development and may lack s' +
        'ome methods and/or properties. '
      'It is already able to grab files though.'
      
        'The dynamic creation group allows to work with a component creat' +
        'ed dynamically at runtime as opposed to using the one available ' +
        'on the form at design time. This has been done to test both usag' +
        'es as there may be errors that only show up by using a design cr' +
        'eated component.')
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
  end
  object grbDynamic: TGroupBox
    Left = 415
    Top = 140
    Width = 113
    Height = 65
    Anchors = [akTop, akRight]
    Caption = ' Dynamic creation '
    TabOrder = 1
    object btnGoDynamic: TButton
      Left = 18
      Top = 24
      Width = 71
      Height = 25
      Caption = 'Go'
      TabOrder = 0
      OnClick = btnGoDynamicClick
    end
  end
  object grbDesign: TGroupBox
    Left = 415
    Top = 207
    Width = 113
    Height = 125
    Anchors = [akTop, akRight, akBottom]
    Caption = ' Design time use '
    TabOrder = 2
    object btnGoDesign: TButton
      Left = 20
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Go'
      TabOrder = 0
      OnClick = btnGoDesignClick
    end
    object btnClear: TButton
      Left = 20
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Clear list'
      TabOrder = 1
      OnClick = btnClearClick
    end
    object btnStop: TButton
      Left = 20
      Top = 88
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 2
      OnClick = btnStopClick
    end
  end
  object memUrls: TMemo
    Left = 8
    Top = 188
    Width = 389
    Height = 142
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'http://jvcl.sf.net'
      'ftp://homepages.borland.com/home/jedi/jvcl/Licensing.html'
      'file://C:/log2.txt'
      'C:\log2.txt')
    TabOrder = 3
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 347
    Width = 535
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object julGrabber: TJvUrlListGrabber
    Left = 384
    Top = 156
  end
end
