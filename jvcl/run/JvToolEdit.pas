{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvToolEdit.PAS, released on 2002-07-04.

The Initial Developers of the Original Code are: Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 1997, 1998 Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 2001,2002 SGB Software
All Rights Reserved.

Contributers:
  Rob den Braasem [rbraasem att xs4all dott nl]
  Polaris Software
  rblaurindo
  Andreas Hausladen

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
  (rb) Move button related functionality from TJvCustomComboEdit to TJvEditButton
-----------------------------------------------------------------------------}
// $Id$

{$I jvcl.inc}

{$IFDEF COMPILER6_UP}
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$ENDIF COMPILER6_UP}

unit JvToolEdit;

interface

uses
  SysUtils, Classes,
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF MSWINDOWS}
  {$IFDEF VCL}
  Messages,
  {$ENDIF VCL}
  Graphics, Controls, Forms, Dialogs, StdCtrls, Menus, Buttons,
  FileCtrl, Mask, ImgList, ActnList, ExtDlgs,
  {$IFDEF COMPILER6_UP}
  RTLConsts, Variants,
  {$ENDIF COMPILER6_UP}
  {$IFDEF VisualCLX}
  Qt, QComboEdits, QWindows, Types, JvQExComboEdits,
  {$ENDIF VisualCLX}
  JvSpeedButton, JvTypes, JvExMask, JvExForms;

const
  scAltDown = scAlt + VK_DOWN;
  DefEditBtnWidth = 21;

type
  TFileExt = type string;

  TCloseUpEvent = procedure(Sender: TObject; Accept: Boolean) of object;
  TPopupAlign = (epaRight, epaLeft);

  TJvPopupWindow = class(TJvExCustomForm)
  private
    FEditor: TWinControl;
    FCloseUp: TCloseUpEvent;
    {$IFDEF VCL}
    procedure WMMouseActivate(var Msg: TMessage); message WM_MOUSEACTIVATE;
    {$ENDIF VCL}
  protected
    {$IFDEF VCL}
    procedure CreateParams(var Params: TCreateParams); override;
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    procedure SetParent(const Value: TWidgetControl); override;
    function WidgetFlags: Integer; override;
    {$ENDIF VisualCLX}
    function GetValue: Variant; virtual; abstract;
    procedure SetValue(const Value: Variant); virtual; abstract;
    procedure InvalidateEditor;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure CloseUp(Accept: Boolean); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    function GetPopupText: string; virtual;
    procedure Hide;
    procedure Show(Origin: TPoint); virtual; // Polaris
    property OnCloseUp: TCloseUpEvent read FCloseUp write FCloseUp;
  end;

  TJvEditButton = class(TJvImageSpeedButton)
  private
    FNoAction: Boolean;
    {$IFDEF VCL}
    procedure WMContextMenu(var Msg: TWMContextMenu); message WM_CONTEXTMENU;
    {$ENDIF VCL}
    function GetGlyph: TBitmap;
    function GetNumGlyphs: TJvNumGlyphs;
    function GetUseGlyph: Boolean;
    procedure SetGlyph(const Value: TBitmap);
    procedure SetNumGlyphs(Value: TJvNumGlyphs);
  protected
    {$IFDEF JVCLThemesEnabled}
    FDrawThemedDropDownBtn: Boolean;
    {$ENDIF JVCLThemesEnabled}
    FStandard: Boolean; // Polaris
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure PaintImage(Canvas: TCanvas; ARect: TRect; const Offset: TPoint;
      AState: TJvButtonState; DrawMark: Boolean); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;

    property UseGlyph: Boolean read GetUseGlyph;// write FDrawGlyph;
    property Glyph: TBitmap read GetGlyph write SetGlyph;
    property NumGlyphs: TJvNumGlyphs read GetNumGlyphs write SetNumGlyphs;
  end;

  TGlyphKind = (gkCustom, gkDefault, gkDropDown, gkEllipsis);
  TJvImageKind = (ikCustom, ikDefault, ikDropDown, ikEllipsis);

  TJvCustomComboEdit = class;

  {$IFDEF VCL}
  TJvCustomComboEditActionLink = class(TWinControlActionLink)
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  TJvCustomComboEditActionLink = class(TWidgetControlActionLink)
  {$ENDIF VisualCLX}
  protected
    function IsCaptionLinked: Boolean; override;
    function IsHintLinked: Boolean; override;
    function IsImageIndexLinked: Boolean; override;
    function IsOnExecuteLinked: Boolean; override;
    function IsShortCutLinked: Boolean; override;
    procedure SetHint(const Value: THintString); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
    procedure SetShortCut(Value: TShortCut); override;
  end;

  TJvCustomComboEditActionLinkClass = class of TJvCustomComboEditActionLink;

  {$IFDEF VCL}
  TJvCustomComboEdit = class(TJvExCustomMaskEdit)
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  TJvCustomComboEdit = class(TJvExCustomComboMaskEdit)
  {$ENDIF VisualCLX}
  private
    FBtnControl: TWinControl;
    FOnButtonClick: TNotifyEvent;
    FClickKey: TShortCut;
    FReadOnly: Boolean;
    FDirectInput: Boolean;
    FAlwaysEnable: Boolean;
    FAlignment: TAlignment;
    FPopupAlign: TPopupAlign;
    FGroupIndex: Integer; // RDB
    FDisabledColor: TColor; // RDB
    FDisabledTextColor: TColor; // RDB
    FOnKeyDown: TKeyEvent; // RDB
    FImages: TCustomImageList;
    FImageIndex: TImageIndex;
    FImageKind: TJvImageKind;
    FNumGlyphs: Integer;
    FStreamedButtonWidth: Integer;
    FOnEnabledChanged: TNotifyEvent;
    function BtnWidthStored: Boolean;
    function GetButtonFlat: Boolean;
    function GetButtonHint: string;
    function GetButtonWidth: Integer;
    function GetDirectInput: Boolean;
    function GetGlyph: TBitmap;
    function GetGlyphKind: TGlyphKind;
    function GetMinHeight: Integer;
    function GetNumGlyphs: TNumGlyphs;
    function GetPopupVisible: Boolean;
    function GetTextHeight: Integer;
    function IsImageIndexStored: Boolean;
    function IsCustomGlyph: Boolean;
    procedure EditButtonClick(Sender: TObject);
    procedure ReadGlyphKind(Reader: TReader);
    procedure RecreateGlyph;
    procedure SetAlignment(Value: TAlignment);
    procedure SetButtonFlat(const Value: Boolean);
    procedure SetButtonHint(const Value: string);
    procedure SetButtonWidth(Value: Integer);
    procedure SetEditRect;
    procedure SetGlyph(Value: TBitmap);
    procedure SetGlyphKind(Value: TGlyphKind);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetImageKind(const Value: TJvImageKind);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetNumGlyphs(const Value: TNumGlyphs);
    procedure UpdateBtnBounds;
    procedure UpdateEdit; // RDB

    {$IFDEF VCL}
    procedure CMBiDiModeChanged(var Msg: TMessage); message CM_BIDIMODECHANGED;
    procedure CMCancelMode(var Msg: TCMCancelMode); message CM_CANCELMODE;
    procedure CMCtl3DChanged(var Msg: TMessage); message CM_CTL3DCHANGED;
    procedure CNCtlColor(var Msg: TMessage); message CN_CTLCOLOREDIT;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT; // RDB
    {$IFDEF JVCLThemesEnabled}
    procedure WMNCPaint(var Msg: TWMNCPaint); message WM_NCPAINT;
    procedure WMNCCalcSize(var Msg: TWMNCCalcSize); message WM_NCCALCSIZE;
    {$ENDIF JVCLThemesEnabled}
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    {$ENDIF VCL}
  protected
    FButton: TJvEditButton; // Polaris
    FPopupVisible: Boolean; // Polaris
    FFocused: Boolean; // Polaris
    FPopup: TWinControl;
    procedure DoClearText; override;
    procedure DoClipboardCut; override;
    procedure DoClipboardPaste; override;
    procedure DoBoundsChanged; override;
    procedure DoKillFocus(FocusedWnd: HWND); override;
    procedure DoSetFocus(FocusedWnd: HWND); override;
    procedure EnabledChanged; override;
    procedure FontChanged; override;
    procedure DoEnter; override;
    function DoPaintBackground(Canvas: TCanvas; Param: Integer): Boolean; override;
    {$IFDEF VisualCLX}
    procedure DoFlatChanged; override;
    procedure Paint; override;
    {$ENDIF VisualCLX}
    class function DefaultImageIndex: TImageIndex; virtual;
    class function DefaultImages: TCustomImageList; virtual;
    function AcceptPopup(var Value: Variant): Boolean; virtual;
    function EditCanModify: Boolean; override;
    function GetActionLinkClass: TControlActionLinkClass; override;
    function GetPopupValue: Variant; virtual;
    function GetReadOnly: Boolean; virtual;
    procedure AcceptValue(const Value: Variant); virtual;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure AdjustHeight;
    procedure ButtonClick; dynamic;
    procedure Change; override;
    {$IFDEF VCL}
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    procedure CreateWidget; override;
    {$ENDIF VisualCLX}
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoChange; virtual; //virtual Polaris
    procedure HidePopup; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure LocalKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); // RDB
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PopupChange; virtual;
    procedure PopupCloseUp(Sender: TObject; Accept: Boolean); virtual; //virtual Polaris
    procedure PopupDropDown(DisableEdit: Boolean); virtual;
    procedure SetClipboardCommands(const Value: TJvClipboardCommands); override; // RDB
    procedure SetDirectInput(Value: Boolean); // Polaris
    procedure SetDisabledColor(const Value: TColor); virtual; // RDB
    procedure SetDisabledTextColor(const Value: TColor); virtual; // RDB
    procedure SetGroupIndex(const Value: Integer); // RDB
    procedure SetPopupValue(const Value: Variant); virtual;
    procedure SetReadOnly(Value: Boolean); virtual;
    procedure SetShowCaret; // Polaris
    procedure ShowPopup(Origin: TPoint); virtual;
    procedure UpdatePopupVisible;

    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property AlwaysEnable: Boolean read FAlwaysEnable write FAlwaysEnable default False;
    property Button: TJvEditButton read FButton;
    property ButtonFlat: Boolean read GetButtonFlat write SetButtonFlat;
    property ButtonHint: string read GetButtonHint write SetButtonHint;
    property ButtonWidth: Integer read GetButtonWidth write SetButtonWidth stored BtnWidthStored;
    property ClickKey: TShortCut read FClickKey write FClickKey default scAltDown;
    property DirectInput: Boolean read GetDirectInput write SetDirectInput default True;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clWindow; // RDB
    property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor default clGrayText; // RDB
    property Glyph: TBitmap read GetGlyph write SetGlyph stored IsCustomGlyph;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex stored IsImageIndexStored default -1;
    property ImageKind: TJvImageKind read FImageKind write SetImageKind default ikCustom;
    property Images: TCustomImageList read FImages write SetImages;
    property NumGlyphs: TNumGlyphs read GetNumGlyphs write SetNumGlyphs default 1;
    property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
    property OnKeyDown: TKeyEvent read FOnKeyDown write FOnKeyDown;
    property PopupAlign: TPopupAlign read FPopupAlign write FPopupAlign default epaRight;
    property PopupVisible: Boolean read GetPopupVisible;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;

    property OnEnabledChanged: TNotifyEvent read FOnEnabledChanged write FOnEnabledChanged;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoClick;
    procedure SelectAll;
    { Backwards compatibility; moved to public&published; eventually remove }
    property GlyphKind: TGlyphKind read GetGlyphKind write SetGlyphKind;
  end;

  TJvComboEdit = class(TJvCustomComboEdit)
  public
    property Button;
  published
    //Polaris
    property Action;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    {$IFDEF VCL}
    property BiDiMode;
    property DragCursor;
    property DragKind;
    property ImeMode;
    property ImeName;
    property OEMConvert;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF VCL}
    property BorderStyle;
    property ButtonFlat;
    property ButtonHint;
    property ButtonWidth;
    property CharCase;
    property ClickKey;
    property ClipboardCommands; // RDB
    property Color;
    property Constraints;
    property DirectInput;
    property DisabledColor; // RDB
    property DisabledTextColor; // RDB
    property DragMode;
    property EditMask;
    property Enabled;
    property Font;
    property Glyph;
    property HideSelection;
    property ImageIndex;
    property ImageKind;
    property Images;
    property MaxLength;
    property NumGlyphs;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnButtonClick;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown; // RDB
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

  { TJvFileDirEdit }
  { The common parent of TJvFilenameEdit and TJvDirectoryEdit          }
  { For internal use only; it's not intended to be used separately }

type
  TExecOpenDialogEvent = procedure(Sender: TObject; var Name: string;
    var Action: Boolean) of object;

  {$IFDEF VCL}
  TJvAutoCompleteOption = (acoAutoappendForceOff, acoAutoappendForceOn,
    acoAutosuggestForceOff, acoAutosuggestForceOn, acoDefault, acoFileSystem,
    acoFileSysDirs, acoURLAll, acoURLHistory, acoURLMRU, acoUseTab);
  TJvAutoCompleteOptions = set of TJvAutoCompleteOption;
  {$ENDIF VCL}

  TJvFileDirEdit = class(TJvCustomComboEdit)
  private
    FErrMode: Cardinal;
    FMultipleDirs: Boolean;
    FOnDropFiles: TNotifyEvent;
    FOnBeforeDialog: TExecOpenDialogEvent;
    FOnAfterDialog: TExecOpenDialogEvent;
    {$IFDEF VCL}
    FAcceptFiles: Boolean;
    FAutoComplete: Boolean;
    FAutoCompleteOptions: TJvAutoCompleteOptions;
    procedure SetDragAccept(Value: Boolean);
    procedure SetAutoComplete(Value: Boolean);
    procedure SetAcceptFiles(Value: Boolean);
    procedure SetAutoCompleteOptions(const Value: TJvAutoCompleteOptions);
    procedure UpdateAutoComplete;
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    {$IFDEF JVCLThemesEnabled}
    procedure CMSysColorChange(var Msg: TMessage); message CM_SYSCOLORCHANGE;
    {$ENDIF JVCLThemesEnabled}
    {$ENDIF VCL}
  protected
    {$IFDEF VCL}
    procedure CreateHandle; override;
    procedure DestroyWindowHandle; override;
    {$ENDIF VCL}
    function GetLongName: string; virtual; abstract;
    function GetShortName: string; virtual; abstract;
    procedure DoAfterDialog(var FileName: string; var Action: Boolean); dynamic;
    procedure DoBeforeDialog(var FileName: string; var Action: Boolean); dynamic;
    procedure ReceptFileDir(const AFileName: string); virtual; abstract;
    procedure ClearFileList; virtual;
    procedure DisableSysErrors;
    procedure EnableSysErrors;
    {$IFDEF VCL}
    property AutoComplete: Boolean read FAutoComplete write SetAutoComplete default True;
    property AutoCompleteOptions: TJvAutoCompleteOptions read FAutoCompleteOptions write SetAutoCompleteOptions;
    {$ENDIF VCL}
    property ImageKind default ikDefault;
    property MaxLength;
  public
    constructor Create(AOwner: TComponent); override;
    property LongName: string read GetLongName;
    property ShortName: string read GetShortName;
  published
    {$IFDEF VCL}
    property AcceptFiles: Boolean read FAcceptFiles write SetAcceptFiles default True;
    {$ENDIF VCL}
    property AutoSize;
    property OnBeforeDialog: TExecOpenDialogEvent read FOnBeforeDialog
      write FOnBeforeDialog;
    property OnAfterDialog: TExecOpenDialogEvent read FOnAfterDialog
      write FOnAfterDialog;
    property OnDropFiles: TNotifyEvent read FOnDropFiles write FOnDropFiles;
    property OnButtonClick;
    property ClipboardCommands; // RDB
    property DisabledTextColor; // RDB
    property DisabledColor; // RDB
    property OnKeyDown; // RDB
  end;

  TFileDialogKind = (dkOpen, dkSave, dkOpenPicture, dkSavePicture);

  TJvFilenameEdit = class(TJvFileDirEdit)
  private
    FDialog: TOpenDialog;
    FDialogKind: TFileDialogKind;
    FAddQuotes: Boolean;
    procedure CreateEditDialog;
    function GetFileName: TFileName;
    function GetDefaultExt: TFileExt;
    {$IFDEF VCL}
    function GetFileEditStyle: TFileEditStyle;
    {$ENDIF VCL}
    function GetFilter: string;
    function GetFilterIndex: Integer;
    function GetInitialDir: string;
    function GetHistoryList: TStrings;
    function GetOptions: TOpenOptions;
    function GetDialogTitle: string;
    function GetDialogFiles: TStrings;
    procedure SetDialogKind(Value: TFileDialogKind);
    procedure SetFileName(const Value: TFileName);
    procedure SetDefaultExt(Value: TFileExt);
    {$IFDEF VCL}
    procedure SetFileEditStyle(Value: TFileEditStyle);
    {$ENDIF VCL}
    procedure SetFilter(const Value: string);
    procedure SetFilterIndex(Value: Integer);
    procedure SetInitialDir(const Value: string);
    procedure SetHistoryList(Value: TStrings);
    procedure SetOptions(Value: TOpenOptions);
    procedure SetDialogTitle(const Value: string);
    function IsCustomTitle: Boolean;
    function IsCustomFilter: Boolean;
  protected
    procedure ButtonClick; override;
    procedure ReceptFileDir(const AFileName: string); override;
    procedure ClearFileList; override;
    function GetLongName: string; override;
    function GetShortName: string; override;
    class function DefaultImageIndex: TImageIndex; override;
  public
    constructor Create(AOwner: TComponent); override;
    property Dialog: TOpenDialog read FDialog;
    property DialogFiles: TStrings read GetDialogFiles;
  published
    //Polaris
    property Action;
    property Align;
    property AutoSize;
    property AddQuotes: Boolean read FAddQuotes write FAddQuotes default True;
    property DialogKind: TFileDialogKind read FDialogKind write SetDialogKind
      default dkOpen;
    property DefaultExt: TFileExt read GetDefaultExt write SetDefaultExt;
    {$IFDEF VCL}
    property AutoComplete;
    property AutoCompleteOptions default [acoAutosuggestForceOn, acoFileSystem];
    { (rb) Obsolete; added 'stored False', eventually remove }
    property FileEditStyle: TFileEditStyle read GetFileEditStyle write SetFileEditStyle stored False;
    {$ENDIF VCL}
    property FileName: TFileName read GetFileName write SetFileName stored False;
    property Filter: string read GetFilter write SetFilter stored IsCustomFilter;
    property FilterIndex: Integer read GetFilterIndex write SetFilterIndex default 1;
    property InitialDir: string read GetInitialDir write SetInitialDir;
    { (rb) Obsolete; added 'stored False', eventually remove }
    property HistoryList: TStrings read GetHistoryList write SetHistoryList stored False;
    property DialogOptions: TOpenOptions read GetOptions write SetOptions
      default [ofHideReadOnly];
    property DialogTitle: string read GetDialogTitle write SetDialogTitle
      stored IsCustomTitle;
    property AutoSelect;
    property ButtonHint;
    property ButtonFlat;
    property BorderStyle;
    property CharCase;
    property ClickKey;
    property Color;
    property DirectInput;
    {$IFDEF VCL}
    property DragCursor;
    property BiDiMode;
    property DragKind;
    property ParentBiDiMode;
    property ImeMode;
    property ImeName;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF VCL}
    property DragMode;
    property EditMask;
    property Enabled;
    property Font;
    property Glyph;
    property ImageIndex;
    property Images;
    property ImageKind;
    property NumGlyphs;
    property ButtonWidth;
    property HideSelection;
    property Anchors;
    property Constraints;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnContextPopup;
  end;

  TDirDialogKind = (dkVCL, dkWin32);

  TJvDirectoryEdit = class(TJvFileDirEdit)
  private
    {$IFDEF VCL}
    FOptions: TSelectDirOpts;
    {$ENDIF VCL}
    FInitialDir: string;
    FDialogText: string;
    FDialogKind: TDirDialogKind;
  protected
    FMultipleDirs: Boolean; // Polaris (???)
    procedure ButtonClick; override;
    procedure ReceptFileDir(const AFileName: string); override;
    function GetLongName: string; override;
    function GetShortName: string; override;
    class function DefaultImageIndex: TImageIndex; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    //Polaris
    property Action;
    property Align;
    property AutoSize;
    property DialogKind: TDirDialogKind read FDialogKind write FDialogKind default dkVCL;
    property DialogText: string read FDialogText write FDialogText;
    {$IFDEF VCL}
    property AutoComplete;
    property AutoCompleteOptions default [acoAutosuggestForceOn, acoFileSystem, acoFileSysDirs];
    property DialogOptions: TSelectDirOpts read FOptions write FOptions default [];
    {$ENDIF VCL}
    property InitialDir: string read FInitialDir write FInitialDir;
    property MultipleDirs: Boolean read FMultipleDirs write FMultipleDirs default False;
    property AutoSelect;
    property ButtonHint;
    property ButtonFlat;
    property BorderStyle;
    property CharCase;
    property ClickKey;
    property Color;
    property DirectInput;
    {$IFDEF VCL}
    property DragCursor;
    property BiDiMode;
    property ParentBiDiMode;
    property ImeMode;
    property ImeName;
    property DragKind;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF VCL}
    property DragMode;
    property EditMask;
    property Enabled;
    property Font;
    property Glyph;
    property ImageIndex;
    property Images;
    property ImageKind;
    property NumGlyphs;
    property ButtonWidth;
    property HideSelection;
    property Anchors;
    property Constraints;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnContextPopup;
  end;

  TCalendarStyle = (csPopup, csDialog);
  TYearDigits = (dyDefault, dyFour, dyTwo);

const
  {$IFDEF DEFAULT_POPUP_CALENDAR}
  dcsDefault = csPopup;
  {$ELSE}
  dcsDefault = csDialog;
  {$ENDIF DEFAULT_POPUP_CALENDAR}

type
  TExecDateDialog = procedure(Sender: TObject; var ADate: TDateTime;
    var Action: Boolean) of object;
  TJvInvalidDateEvent = procedure(Sender: TObject; const DateString:string; var NewDate:TDateTime; var Accept:boolean) of object; 

  TJvCustomDateEdit = class(TJvCustomComboEdit)
  private
    FMinDate: TDateTime; // Polaris
    FMaxDate: TDateTime; // Polaris
    FTitle: string;
    FOnAcceptDate: TExecDateDialog;
    FOnInvalidDate: TJvInvalidDateEvent;
    FDefaultToday: Boolean;
    //    FHooked: Boolean;
    FPopupColor: TColor;
    FCheckOnExit: Boolean;
    FBlanksChar: Char;
    FCalendarHints: TStringList;
    FStartOfWeek: TDayOfWeekName;
    FWeekends: TDaysOfWeek;
    FWeekendColor: TColor;
    FYearDigits: TYearDigits;
    FDateFormat: string[10];
    FFormatting: Boolean;
    // Polaris
    procedure SetMinDate(Value: TDateTime);
    procedure SetMaxDate(Value: TDateTime);
    // Polaris
    function GetDate: TDateTime;
    //    procedure SetDate(Value: TDateTime);
    procedure SetYearDigits(Value: TYearDigits);
    function GetPopupColor: TColor;
    procedure SetPopupColor(Value: TColor);
    function GetDialogTitle: string;
    procedure SetDialogTitle(const Value: string);
    function IsCustomTitle: Boolean;
    function GetCalendarStyle: TCalendarStyle;
    procedure SetCalendarStyle(Value: TCalendarStyle);
    function GetCalendarHints: TStrings;
    procedure SetCalendarHints(Value: TStrings);
    procedure CalendarHintsChanged(Sender: TObject);
    procedure SetWeekendColor(Value: TColor);
    procedure SetWeekends(Value: TDaysOfWeek);
    procedure SetStartOfWeek(Value: TDayOfWeekName);
    procedure SetBlanksChar(Value: Char);
    function TextStored: Boolean;
    // Polaris
    function StoreMinDate: Boolean;
    function StoreMaxDate: Boolean;
    // Polaris
    function FourDigitYear: Boolean;
    //    function FormatSettingsChange(var Msg: TMessage): Boolean;
    {$IFDEF VCL}
    procedure WMContextMenu(var Msg: TWMContextMenu); message WM_CONTEXTMENU;
    {$ENDIF VCL}
  protected
    // Polaris
    FDateAutoBetween: Boolean;
    procedure SetDate(Value: TDateTime); virtual;
    function DoInvalidDate(const DateString:string; var ANewDate:TDateTime):boolean;virtual;
    procedure SetDateAutoBetween(Value: Boolean); virtual;
    procedure TestDateBetween(var Value: TDateTime); virtual;
    // Polaris
    procedure DoExit; override;
    procedure Change; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    {$IFDEF VCL}
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    procedure CreateWidget; override;
    {$ENDIF VisualCLX}
    function AcceptPopup(var Value: Variant): Boolean; override;
    procedure AcceptValue(const Value: Variant); override;
    procedure SetPopupValue(const Value: Variant); override;
    function GetDateFormat: string;
    procedure ApplyDate(Value: TDateTime); virtual;
    class function DefaultImageIndex: TImageIndex; override;
    procedure UpdateFormat;
    procedure UpdatePopup;
    procedure ButtonClick; override;
    property BlanksChar: Char read FBlanksChar write SetBlanksChar default ' ';
    property CalendarHints: TStrings read GetCalendarHints write SetCalendarHints;
    property CheckOnExit: Boolean read FCheckOnExit write FCheckOnExit default False;
    property DefaultToday: Boolean read FDefaultToday write FDefaultToday default False;
    property DialogTitle: string read GetDialogTitle write SetDialogTitle stored IsCustomTitle;
    property EditMask stored False;
    property Formatting: Boolean read FFormatting;
    property ImageKind default ikDefault;
    property PopupColor: TColor read GetPopupColor write SetPopupColor default clMenu;
    property CalendarStyle: TCalendarStyle read GetCalendarStyle
      write SetCalendarStyle default dcsDefault;
    property StartOfWeek: TDayOfWeekName read FStartOfWeek write SetStartOfWeek default Mon;
    property Weekends: TDaysOfWeek read FWeekends write SetWeekends default [Sun];
    property WeekendColor: TColor read FWeekendColor write SetWeekendColor default clRed;
    property YearDigits: TYearDigits read FYearDigits write SetYearDigits default dyDefault;
    property OnAcceptDate: TExecDateDialog read FOnAcceptDate write FOnAcceptDate;
    property OnInvalidDate: TJvInvalidDateEvent read FOnInvalidDate write FOnInvalidDate;
    property MaxLength stored False;
    property Text stored TextStored;
  public
    // Polaris
    property DateAutoBetween: Boolean read FDateAutoBetween write SetDateAutoBetween default True;
    property MinDate: TDateTime read FMinDate write SetMinDate stored StoreMinDate;
    property MaxDate: TDateTime read FMaxDate write SetMaxDate stored StoreMaxDate;
    procedure ValidateEdit; override;
    // Polaris
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CheckValidDate;
    function GetDateMask: string;
    procedure UpdateMask; virtual;
    property Date: TDateTime read GetDate write SetDate;
    property PopupVisible;
  end;

  TJvDateEdit = class(TJvCustomDateEdit)
    // Polaris
  protected
    procedure SetDate(Value: TDateTime); override;
    // Polaris
  public
    constructor Create(AOwner: TComponent); override;
    property EditMask;
  published
    property DateAutoBetween; // Polaris
    property MinDate; // Polaris
    property MaxDate; // Polaris
    property Align; // Polaris
    property Action;
    property AutoSelect;
    property AutoSize;
    property BlanksChar;
    property BorderStyle;
    property ButtonHint;
    property ButtonFlat;
    property CalendarHints;
    property CheckOnExit;
    property ClickKey;
    property Color;
    property DefaultToday;
    property DialogTitle;
    property DirectInput;
    {$IFDEF VCL}
    property DragCursor;
    property BiDiMode;
    property DragKind;
    property ParentBiDiMode;
    property ImeMode;
    property ImeName;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF VCL}
    property DragMode;
    property Enabled;
    property Font;
    property Glyph;
    property ImageIndex;
    property Images;
    property ImageKind;
    property NumGlyphs;
    property ButtonWidth;
    property HideSelection;
    property Anchors;
    property Constraints;
    property MaxLength;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupAlign;
    property PopupColor;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property CalendarStyle;
    property StartOfWeek;
    property Weekends;
    property WeekendColor;
    property YearDigits;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnAcceptDate;
    property OnInvalidDate;
    property OnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnContextPopup;
    property ClipboardCommands; // RDB
    property DisabledTextColor; // RDB
    property DisabledColor; // RDB
    property OnKeyDown; // RDB
  end;

  EComboEditError = class(EJVCLException);

{ Utility routines }

procedure DateFormatChanged;

function EditorTextMargins(Editor: TCustomEdit): TPoint;
{$IFDEF VCL}
function PaintComboEdit(Editor: TJvCustomComboEdit; const AText: string;
  AAlignment: TAlignment; StandardPaint: Boolean;
  var ACanvas: TControlCanvas; var Msg: TWMPaint): Boolean;
function PaintEdit(Editor: TCustomEdit; const AText: string;
  AAlignment: TAlignment; PopupVisible: Boolean;
  DisabledTextColor: TColor; StandardPaint: Boolean;
  var ACanvas: TControlCanvas; var Msg: TWMPaint): Boolean;
{$ENDIF VCL}
{$IFDEF VisualCLX}
function PaintComboEdit(Editor: TJvCustomComboEdit; const AText: string;
  AAlignment: TAlignment; StandardPaint: Boolean; Flat: Boolean;
  ACanvas: TCanvas): Boolean;
{ PaintEdit (CLX) needs an implemented EM_GETRECT message handler or a
  TCustomComboEdit/TCustomComboMask class. If no EM_GETTEXT handler exists or
  the class is derived from another class, it uses the ClientRect of the edit
  control. }
function PaintEdit(Editor: TCustomEdit; const AText: WideString;
  AAlignment: TAlignment; PopupVisible: Boolean; 
  DisabledTextColor: TColor; StandardPaint: Boolean; Flat: Boolean;
  ACanvas: TCanvas): Boolean;
{$ENDIF VisualCLX}

{$IFDEF VisualCLX}
const
  OBM_COMBO = 1;
{$ENDIF VisualCLX}
function LoadDefaultBitmap(Bmp: TBitmap; Item: Integer): Boolean;

function IsInWordArray(Value: Word; const A: array of Word): Boolean;

implementation

uses
  Math, Consts,
  {$IFDEF MSWINDOWS}
  ShellAPI,
  {$ENDIF WINDOWS}
  {$IFDEF VCL}
  JvBrowseFolder, ActiveX,
  {$ENDIF VCL}
  JvFinalize, JvThemes, JvResources, JvConsts, JvJCLUtils, JvExControls,
  JvPickDate, JvJVCLUtils;

const
  sUnitName = 'JvToolEdit';

{$IFDEF MSWINDOWS}
{$R ..\Resources\JvToolEdit.res}
{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
{$R ../Resources/JvToolEdit.res}
{$ENDIF LINUX}

type
  TCustomEditHack = class(TCustomEdit);
  TCustomFormHack = class(TCustomForm);    
  TWinControlHack = class(TWinControl);

const
  sDirBmp = 'JV_SEDITBMP';  { Directory editor button glyph }
  sFileBmp = 'JV_FEDITBMP';  { Filename editor button glyph }
  sDateBmp = 'JV_DEDITBMP';  { Date editor button glyph }

  {$IFDEF JVCLThemesEnabled}
  // (rb) should/can these be put in a seperate resource file?
  sDirXPBmp = 'JV_SEDITXPBMP';
  sFileXPBmp = 'JV_FEDITXPBMP';
  {$ENDIF JVCLThemesEnabled}

  { TDateHook is used to only have 1 hook per application for monitoring
    date changes;

    We can't use WM_WININICHANGE or CM_WININICHANGE in the controls
    itself, because it comes too early. (The Application object does the
    changing on receiving WM_WININICHANGE; The Application object receives it
    later than the forms, controls etc.
  }

{$IFDEF VCL}

type
  TDateHook = class(TObject)
  private
    FCount: Integer;
    FHooked: Boolean;
    FWinIniChangeReceived: Boolean;
  protected
    function FormatSettingsChange(var Msg: TMessage): Boolean;
    procedure Hook;
    procedure UnHook;
  public
    procedure Add;
    procedure Delete;
  end;

var
  GDateHook: TDateHook = nil;

type
  TSHAutoComplete = function (hwndEdit: HWnd; dwFlags: DWORD): HResult; stdcall;

const
  SHACF_DEFAULT                  = $00000000;  // Currently (SHACF_FILESYSTEM | SHACF_URLALL)
  SHACF_FILESYSTEM               = $00000001;  // This includes the File System as well as the rest of the shell (Desktop\My Computer\Control Panel\)
  SHACF_URLHISTORY               = $00000002;  // URLs in the User's History
  SHACF_URLMRU                   = $00000004;  // URLs in the User's Recently Used list.
  SHACF_URLALL                   = (SHACF_URLHISTORY or SHACF_URLMRU);
  SHACF_USETAB                   = $00000008;  // Use the tab to move thru the autocomplete possibilities instead of to the next dialog/window control.
  SHACF_FILESYS_ONLY             = $00000010;  // This includes the File System

  // WIN32_IE >= 0x0600)

  SHACF_FILESYS_DIRS             = $00000020;  // Same as SHACF_FILESYS_ONLY except it only includes directories, UNC servers, and UNC server shares.
  SHACF_AUTOSUGGEST_FORCE_ON     = $10000000;  // Ignore the registry default and force the feature on.
  SHACF_AUTOSUGGEST_FORCE_OFF    = $20000000;  // Ignore the registry default and force the feature off.
  SHACF_AUTOAPPEND_FORCE_ON      = $40000000;  // Ignore the registry default and force the feature on. (Also know as AutoComplete)
  SHACF_AUTOAPPEND_FORCE_OFF     = $80000000;  // Ignore the registry default and force the feature off. (Also know as AutoComplete)

  ShlwapiDLLName  = 'Shlwapi.dll';
  SHAutoCompleteName = 'SHAutoComplete';

var
  GNeedToUninitialize: Boolean = False;
  GShlwapiHandle: THandle = 0;
  GTriedLoadShlwapiDll: Boolean = False;
  SHAutoComplete: TSHAutoComplete = nil;

{$ENDIF VCL}

var
  GDateImageIndex: TImageIndex = -1;
  GDefaultComboEditImagesList: TImageList = nil;
  GDirImageIndex: TImageIndex = -1;
  GFileImageIndex: TImageIndex = -1;
  {$IFDEF JVCLThemesEnabled}
  GDirImageIndexXP: TImageIndex = -1;
  GFileImageIndexXP: TImageIndex = -1;
  {$ENDIF JVCLThemesEnabled}

//=== Local procedures =======================================================

{$IFDEF VCL}
function DateHook: TDateHook;
begin
  if GDateHook = nil then
  begin
    GDateHook := TDateHook.Create;
    AddFinalizeObjectNil(sUnitName, TObject(GDateHook));
  end;
  Result := GDateHook;
end;
{$ENDIF VCL}

function ClipFilename(const FileName: string): string;
var
  Params: string;
begin
  if FileExists(FileName) then
    Result := FileName
  else
  if DirectoryExists(FileName) then
    Result := IncludeTrailingPathDelimiter(FileName)
  else
    SplitCommandLine(FileName, Result, Params);
end;

function ExtFilename(const FileName: string): string;
begin
  if (Pos(' ', FileName) > 0) and (FileName[1] <> '"') then
    Result := Format('"%s"', [FileName])
  else
    Result := FileName;
end;

function NvlDate(DateValue, DefaultValue: TDateTime): TDateTime;
begin
  if DateValue = NullDate then
    Result := DefaultValue
  else
    Result := DateValue;
end;

{$IFDEF VisualCLX}

procedure DrawSelectedText(Canvas: TCanvas; const R: TRect; X, Y: Integer;
  const Text: WideString; SelStart, SelLength: Integer;
  HighlightColor, HighlightTextColor: TColor);
var
  w, h, Width: Integer;
  S: WideString;
  SelectionRect: TRect;
  Brush: TBrushRecall;
  PenMode: TPenMode;
  FontColor: TColor;
begin
  w := R.Right - R.Left;
  h := R.Bottom - R.Top;
  if (w <= 0) or (h <= 0) then
    Exit;

  S := Copy(Text, 1, SelStart);
  if S <> '' then
  begin
    Canvas.TextRect(R, X, Y, S);
    Inc(X, Canvas.TextWidth(S));
  end;

  S := Copy(Text, SelStart + 1, SelLength);
  if S <> '' then
  begin
    Width := Canvas.TextWidth(S);
    Brush := TBrushRecall.Create(Canvas.Brush);
    PenMode := Canvas.Pen.Mode;
    try
      SelectionRect := Rect(Max(X, R.Left), R.Top,
                            Min(X + Width, R.Right), R.Bottom);
      Canvas.Pen.Mode := pmCopy;
      Canvas.Brush.Color := HighlightColor;
      Canvas.FillRect(SelectionRect);
      FontColor := Canvas.Font.Color;
      Canvas.Font.Color := HighlightTextColor;
      Canvas.TextRect(R, X, Y, S);
      Canvas.Font.Color := FontColor;
    finally
      Canvas.Pen.Mode := PenMode;
      Brush.Free;
    end;
    Inc(X, Width);
  end;

  S := Copy(Text, SelStart + SelLength + 1, MaxInt);
  if S <> '' then
    Canvas.TextRect(R, X, Y, S);
end;

{$ENDIF VisualCLX}

{$IFDEF VCL}

procedure UnloadShlwapiDll;
begin
  SHAutoComplete := nil;
  if GShlwapiHandle > 0 then
    FreeLibrary(GShlwapiHandle);
  GShlwapiHandle := 0;
  if GNeedToUninitialize then
    CoUninitialize;
end;

procedure LoadShlwapiDll;
begin
  if not GTriedLoadShlwapiDll then
  begin
    GTriedLoadShlwapiDll := True;

    GShlwapiHandle := Windows.LoadLibrary(ShlwapiDLLName);
    if GShlwapiHandle > 0 then
    begin
      AddFinalizeProc(sUnitName, UnloadShlwapiDll);

      SHAutoComplete := GetProcAddress(GShlwapiHandle, SHAutoCompleteName);

      if Assigned(SHAutoComplete) then
        GNeedToUninitialize := Succeeded(CoInitialize(nil));
    end;
  end;
end;

{$ENDIF VCL}

//=== Global procedures ======================================================

procedure DateFormatChanged;
var
  I: Integer;

  procedure IterateControls(AControl: TWinControl);
  var
    I: Integer;
  begin
    with AControl do
      for I := 0 to ControlCount - 1 do
      begin
        if Controls[I] is TJvCustomDateEdit then
          TJvCustomDateEdit(Controls[I]).UpdateMask
        else
        if Controls[I] is TWinControl then
          IterateControls(TWinControl(Controls[I]));
      end;
  end;

begin
  if Screen <> nil then
    for I := 0 to Screen.FormCount - 1 do
      IterateControls(Screen.Forms[I]);
end;

{$IFDEF VisualCLX}
function EditorTextMargins(Editor: TCustomEdit): TPoint;
var
  I: Integer;
  ed: TCustomEditHack;
begin
  ed := TCustomEditHack(Editor);
  if ed.BorderStyle = bsNone then
    I := 0
  else
  if Supports(Editor, IComboEditHelper) then
  begin
    if (Editor as IComboEditHelper).GetFlat then
      I := 1
    else
      I := 2;
  end
  else
    I := 2;
  {if GetWindowLong(ed.Handle, GWL_STYLE) and ES_MULTILINE = 0 then
    Result.X := (SendMessage(ed.Handle, EM_GETMARGINS, 0, 0) and $0000FFFF) + I
  else}
    Result.X := I;
  Result.Y := I;
end;
{$ENDIF VisualCLX}

{$IFDEF VCL}
function EditorTextMargins(Editor: TCustomEdit): TPoint;
var
  DC: HDC;
  I: Integer;
  SaveFont: HFONT;
  SysMetrics, Metrics: TTextMetric;
  ed: TCustomEditHack;
begin
  ed := TCustomEditHack(Editor);
  if NewStyleControls then
  begin
    if ed.BorderStyle = bsNone then
      I := 0
    else
    if ed.Ctl3D then
      I := 1
    else
      I := 2;
    if GetWindowLong(ed.Handle, GWL_STYLE) and ES_MULTILINE = 0 then
      Result.X := (SendMessage(ed.Handle, EM_GETMARGINS, 0, 0) and $0000FFFF) + I
    else
      Result.X := I;
    Result.Y := I;
  end
  else
  begin
    if ed.BorderStyle = bsNone then
      I := 0
    else
    begin
      DC := GetDC(0);
      GetTextMetrics(DC, SysMetrics);
      SaveFont := SelectObject(DC, ed.Font.Handle);
      GetTextMetrics(DC, Metrics);
      SelectObject(DC, SaveFont);
      ReleaseDC(0, DC);
      I := SysMetrics.tmHeight;
      if I > Metrics.tmHeight then
        I := Metrics.tmHeight;
      I := I div 4;
    end;
    Result.X := I;
    Result.Y := I;
  end;
end;
{$ENDIF VCL}

function IsInWordArray(Value: Word; const A: array of Word): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to High(A) do
    if A[I] = Value then
      Exit;
  Result := False;
end;

function LoadDefaultBitmap(Bmp: TBitmap; Item: Integer): Boolean;
begin
  {$IFDEF VCL}
  Bmp.Handle := LoadBitmap(0, PChar(Item));
  Result := Bmp.Handle <> 0;
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  Result := True;
  case Item of
    OBM_COMBO:
      begin
        Bmp.Width := QStyle_sliderLength(Application.Style.Handle);
        Bmp.Height := Bmp.Width;
        Bmp.Canvas.Start;
        DrawFrameControl(Bmp.Canvas.Handle, Rect(0, 0, Bmp.Width, Bmp.Height),
          DFC_SCROLL, DFCS_SCROLLDOWN);
        Bmp.Canvas.Stop;
      end;
  else
    Bmp.Width := 0;
    Bmp.Height := 0;
    Result := False;
  end;
  {$ENDIF VisualCLX}
end;

{$IFDEF VCL}

function PaintComboEdit(Editor: TJvCustomComboEdit; const AText: string;
  AAlignment: TAlignment; StandardPaint: Boolean;
  var ACanvas: TControlCanvas; var Msg: TWMPaint): Boolean;
begin
  if not (csDestroying in Editor.ComponentState) then
  begin
    Result := PaintEdit(Editor, AText, AAlignment, Editor.PopupVisible,
      Editor.FDisabledTextColor, StandardPaint, ACanvas, Msg);
  end
  else
    Result := True;
end;

{$ENDIF VCL}

{$IFDEF VisualCLX}

function PaintComboEdit(Editor: TJvCustomComboEdit; const AText: string;
  AAlignment: TAlignment; StandardPaint: Boolean; Flat: Boolean;
  ACanvas: TCanvas): Boolean;
begin
  if not (csDestroying in Editor.ComponentState) then
  begin
    Result := PaintEdit(Editor, AText, AAlignment, Editor.PopupVisible,
      Editor.FDisabledTextColor, StandardPaint, Flat, ACanvas);
  end
  else
    Result := True;
end;

{$ENDIF VisualCLX}

{$IFDEF VCL}

function PaintEdit(Editor: TCustomEdit; const AText: string;
  AAlignment: TAlignment; PopupVisible: Boolean; 
  DisabledTextColor: TColor; StandardPaint: Boolean;
  var ACanvas: TControlCanvas; var Msg: TWMPaint): Boolean;
const
  AlignStyle: array [Boolean, TAlignment] of DWORD =
    ((WS_EX_LEFT, WS_EX_RIGHT, WS_EX_LEFT),
    (WS_EX_RIGHT, WS_EX_LEFT, WS_EX_LEFT));
var
  LTextWidth, X: Integer;
  EditRect: TRect;
  DC: HDC;
  PS: TPaintStruct;
  S: string;
  ExStyle: DWORD;
  ed: TCustomEditHack;
begin
  Result := True;
  if csDestroying in Editor.ComponentState then
    Exit;
  ed := TCustomEditHack(Editor);
  if ed.UseRightToLeftAlignment then
    ChangeBiDiModeAlignment(AAlignment);
  if StandardPaint and not (csPaintCopy in ed.ControlState) then
  begin
    if SysLocale.MiddleEast and ed.HandleAllocated and (ed.IsRightToLeft) then
    begin { This keeps the right aligned text, right aligned }
      ExStyle := DWORD(GetWindowLong(ed.Handle, GWL_EXSTYLE)) and (not WS_EX_RIGHT) and
        (not WS_EX_RTLREADING) and (not WS_EX_LEFTSCROLLBAR);
      if ed.UseRightToLeftReading then
        ExStyle := ExStyle or WS_EX_RTLREADING;
      if ed.UseRightToLeftScrollBar then
        ExStyle := ExStyle or WS_EX_LEFTSCROLLBAR;
      ExStyle := ExStyle or
        AlignStyle[ed.UseRightToLeftAlignment, AAlignment];
      if DWORD(GetWindowLong(ed.Handle, GWL_EXSTYLE)) <> ExStyle then
        SetWindowLong(ed.Handle, GWL_EXSTYLE, ExStyle);
    end;
    Result := False;
    { return false if we need to use standard paint handler }
    Exit;
  end;
  { Since edit controls do not handle justification unless multi-line (and
    then only poorly) we will draw right and center justify manually unless
    the edit has the focus. }
  if ACanvas = nil then
  begin
    ACanvas := TControlCanvas.Create;
    ACanvas.Control := Editor;
  end;
  DC := Msg.DC;
  if DC = 0 then
    DC := BeginPaint(ed.Handle, PS);
  ACanvas.Handle := DC;
  try
    ACanvas.Font := ed.Font;
    with ACanvas do
    begin
      SendMessage(Editor.Handle, EM_GETRECT, 0, Integer(@EditRect));
      if not (NewStyleControls and ed.Ctl3D) and (ed.BorderStyle = bsSingle) then
      begin
        Brush.Color := clWindowFrame;
        FrameRect(ed.ClientRect);
      end;
      S := AText;
      LTextWidth := TextWidth(S);
      if PopupVisible then
        X := EditRect.Left
      else
      begin
        case AAlignment of
          taLeftJustify:
            X := EditRect.Left;
          taRightJustify:
            X := EditRect.Right - LTextWidth;
        else
          X := (EditRect.Right + EditRect.Left - LTextWidth) div 2;
        end;
      end;
      if SysLocale.MiddleEast then
        UpdateTextFlags;
      if not ed.Enabled then
      begin
        // if PS.fErase then // (p3) fErase is not set to true when control is disabled
        ed.Perform(WM_ERASEBKGND, ACanvas.Handle, 0);

        SaveDC(ACanvas.Handle);
        try
          ACanvas.Brush.Style := bsClear;
          ACanvas.Font.Color := DisabledTextColor;
          ACanvas.TextRect(EditRect, X, EditRect.Top, S);
        finally
          RestoreDC(ACanvas.Handle, -1);
        end;
      end
      else
      begin
        Brush.Color := ed.Color;
        ACanvas.TextRect(EditRect, X, EditRect.Top, S);
      end;
    end;
  finally
    ACanvas.Handle := 0;
    if Msg.DC = 0 then
      EndPaint(ed.Handle, PS);
  end;
end;

{$ENDIF VCL}

{$IFDEF VisualCLX}

{ PaintEdit (CLX) needs an implemented EM_GETRECT message handler. If no
  EM_GETTEXT handler exists or the edit control does not implements
  IComboEditHelper, it uses the ClientRect of the edit control. }

function PaintEdit(Editor: TCustomEdit; const AText: WideString;
  AAlignment: TAlignment; PopupVisible: Boolean;
  DisabledTextColor: TColor; StandardPaint: Boolean; Flat: Boolean;
  ACanvas: TCanvas): Boolean;
var
  LTextWidth, X: Integer;
  EditRect: TRect;
  S: WideString;
  ed: TCustomEditHack;
  SavedFont: TFontRecall;
  SavedBrush: TBrushRecall;
  Offset: Integer;
  R: TRect;
  EditHelperIntf: IComboEditHelper;
begin
  Result := True;
  if csDestroying in Editor.ComponentState then
    Exit;
  ed := TCustomEditHack(Editor);
  if StandardPaint and not (csPaintCopy in ed.ControlState) then
  begin
    Result := False;
    { return false if we need to use standard paint handler }
    Exit;
  end;
  SavedFont := TFontRecall.Create(ACanvas.Font);
  SavedBrush := TBrushRecall.Create(ACanvas.Brush);
  try
    ACanvas.Font := ed.Font;

   // paint Border
    R := ed.ClientRect;
    Offset := 0;
    if (ed.BorderStyle = bsSingle) then
    begin
      ACanvas.Start;
      QStyle_drawPanel(QWidget_style(Editor.Handle), ACanvas.Handle,
        R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top, QWidget_colorGroup(Editor.Handle),
        True, 2, nil);
      ACanvas.Stop;
      //QGraphics.DrawEdge(ACanvas, R, esLowered, esLowered, ebRect)
    end
    else
    begin
      if Flat then
        QGraphics.DrawEdge(ACanvas, R, esNone, esLowered, ebRect);
      Offset := 2;
    end;

    with ACanvas do
    begin
      if Supports(Editor, IComboEditHelper, EditHelperIntf) then
      begin
        EditRect := EditHelperIntf.GetEditorRect;
        EditHelperIntf := nil;
      end
      else
      begin
        EditRect := Rect(0, 0, 0, 0);
        SendMessage(Editor.Handle, EM_GETRECT, 0, Integer(@EditRect));
      end;
      if IsRectEmpty(EditRect) then
      begin
        EditRect := ed.ClientRect;
        if ed.BorderStyle = bsSingle then
          InflateRect(EditRect, -2, -2);
      end
      else
        InflateRect(EditRect, -Offset, -Offset);
      if Flat and (ed.BorderStyle = bsSingle) then
      begin
        Brush.Color := clWindowFrame;
        FrameRect(ACanvas, ed.ClientRect);
      end;
      S := AText;
      LTextWidth := TextWidth(S);
      if PopupVisible then
        X := EditRect.Left
      else
      begin
        case AAlignment of
          taLeftJustify:
            X := EditRect.Left;
          taRightJustify:
            X := EditRect.Right - LTextWidth;
        else
          X := (EditRect.Right + EditRect.Left - LTextWidth) div 2;
        end;
      end;
      if not ed.Enabled then
      begin
        if Supports(ed, IJvWinControlEvents) then
          (ed as IJvWinControlEvents).DoPaintBackground(ACanvas, 0);
        ACanvas.Brush.Style := bsClear;
        ACanvas.Font.Color := DisabledTextColor;
        ACanvas.TextRect(EditRect, X, EditRect.Top + 1, S);
      end
      else
      begin
        Brush.Color := ed.Color;
        DrawSelectedText(ACanvas, EditRect, X, EditRect.Top + 1, S,
          ed.SelStart, ed.SelLength,
          clHighlight, clHighlightText);
      end;
    end;
  finally
    SavedFont.Free;
    SavedBrush.Free;
  end;
end;
{$ENDIF VisualCLX}

{$IFDEF VCL}
//=== TDateHook ==============================================================

procedure TDateHook.Add;
begin
  if FCount = 0 then
    Hook;
  Inc(FCount);
end;

procedure TDateHook.Delete;
begin
  if FCount > 0 then
    Dec(FCount);
  if FCount = 0 then
    UnHook;
end;

function TDateHook.FormatSettingsChange(var Msg: TMessage): Boolean;
begin
  Result := False;
  if (Msg.Msg = WM_WININICHANGE) and Application.UpdateFormatSettings then
  begin
    // Let the application obj do the changing; we receive the message
    // before the application obj, thus jump over it:
    PostMessage(Application.Handle, WM_NULL, 0, 0);
    FWinIniChangeReceived := True;
  end
  else
  if (Msg.Msg = WM_NULL) and FWinIniChangeReceived then
  begin
    FWinIniChangeReceived := False;
    DateFormatChanged;
  end;
end;

procedure TDateHook.Hook;
begin
  if FHooked then
    Exit;

  Application.HookMainWindow(FormatSettingsChange);
  FHooked := True;
end;

procedure TDateHook.UnHook;
begin
  if not FHooked then
    Exit;

  Application.UnhookMainWindow(FormatSettingsChange);
  FHooked := False;
end;

{$ENDIF VCL}

//=== TJvCustomComboEdit =====================================================

function TJvCustomComboEdit.AcceptPopup(var Value: Variant): Boolean;
begin
  Result := True;
end;

procedure TJvCustomComboEdit.AcceptValue(const Value: Variant);
begin
  if Text <> VarToStr(Value) then
  begin
    Text := Value;
    Modified := True;
    UpdatePopupVisible;
    DoChange;
  end;
end;

procedure TJvCustomComboEdit.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if not CheckDefaults or not Assigned(Self.Images) then
        Self.Images := ActionList.Images;
      if not CheckDefaults or Self.Enabled then
        Self.Enabled := Enabled;
      if not CheckDefaults or (Self.HelpContext = 0) then
        Self.HelpContext := HelpContext;
      if not CheckDefaults or (Self.Hint = '') then
        Self.ButtonHint := Hint;
      if not CheckDefaults or (Self.ImageIndex = -1) then
        Self.ImageIndex := ImageIndex;
      if not CheckDefaults or (Self.ClickKey = scNone) then
        Self.ClickKey := ShortCut;
      if not CheckDefaults or Self.Visible then
        Self.Visible := Visible;
      if not CheckDefaults or not Assigned(Self.OnButtonClick) then
        Self.OnButtonClick := OnExecute;
    end;
end;

procedure TJvCustomComboEdit.AdjustHeight;
var
  DC: HDC;
  SaveFont: HFONT;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  if NewStyleControls then
  begin
    {$IFDEF VCL}
    if Ctl3D then
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    if not Flat then
    {$ENDIF VisualCLX}
      I := 8
    else
      I := 6;
    I := GetSystemMetrics(SM_CYBORDER) * I;
  end
  else
  begin
    I := SysMetrics.tmHeight;
    if I > Metrics.tmHeight then
      I := Metrics.tmHeight;
    I := I div 4 + GetSystemMetrics(SM_CYBORDER) * 4;
  end;
  if Height < Metrics.tmHeight + I then
    Height := Metrics.tmHeight + I;
end;

function TJvCustomComboEdit.BtnWidthStored: Boolean;
begin
  if (FImageKind = ikDefault) and (DefaultImages <> nil) and (DefaultImageIndex >= 0) then
    Result := ButtonWidth <> Max(DefaultImages.Width + 6, DefEditBtnWidth)
  else
  if FImageKind = ikDropDown then
    Result := ButtonWidth <> GetSystemMetrics(SM_CXVSCROLL)
  else
    Result := ButtonWidth <> DefEditBtnWidth;
end;

procedure TJvCustomComboEdit.ButtonClick;
begin
  if Assigned(FOnButtonClick) then
    FOnButtonClick(Self);
  if FPopup <> nil then
  begin
    if FPopupVisible then
      PopupCloseUp(FPopup, True)
    else
      PopupDropDown(True);
  end;
end;

procedure TJvCustomComboEdit.Change;
begin
  if not PopupVisible then
    DoChange
  else
    PopupChange;
end;

{$IFDEF VCL}

procedure TJvCustomComboEdit.CMBiDiModeChanged(var Msg: TMessage);
begin
  inherited;
  if FPopup <> nil then
    FPopup.BiDiMode := BiDiMode;
end;

procedure TJvCustomComboEdit.CMCancelMode(var Msg: TCMCancelMode);
begin
  if (Msg.Sender <> Self) and (Msg.Sender <> FPopup) and
    (Msg.Sender <> FButton) and ((FPopup <> nil) and
    not FPopup.ContainsControl(Msg.Sender)) then
    PopupCloseUp(FPopup, False);
end;

procedure TJvCustomComboEdit.CMCtl3DChanged(var Msg: TMessage);
begin
  inherited;
  UpdateBtnBounds;
end;

procedure TJvCustomComboEdit.CNCtlColor(var Msg: TMessage);
var
  TextColor: Longint;
begin
  inherited;
  if NewStyleControls then
  begin
    TextColor := ColorToRGB(Font.Color);
    if not Enabled and (ColorToRGB(Color) <> ColorToRGB(clGrayText)) then
      TextColor := ColorToRGB(clGrayText);
    SetTextColor(Msg.WParam, TextColor);
  end;
end;

{$ENDIF VCL}

constructor TJvCustomComboEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csCaptureMouse];
  //  AutoSize := False;   // Polaris
  FDirectInput := True;
  FClickKey := scAltDown;
  FPopupAlign := epaRight;
  FBtnControl := TWinControl.Create(Self);
  with FBtnControl do
    ControlStyle := ControlStyle + [csReplicatable];
  FBtnControl.Width := DefEditBtnWidth;
  FBtnControl.Height := 17;
  FBtnControl.Visible := True;
  {$IFDEF VCL}
  FBtnControl.Parent := Self;
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  FBtnControl.Parent := Self.ClientArea;
  {$ENDIF VisualCLX}
  FButton := TJvEditButton.Create(Self);
  FButton.SetBounds(0, 0, FBtnControl.Width, FBtnControl.Height);
  FButton.Visible := True;
  FButton.Parent := FBtnControl;
  TJvEditButton(FButton).OnClick := EditButtonClick;
  Height := 21;
  (* ++ RDB ++ *)
  FDisabledColor := clWindow;
  FDisabledTextColor := clGrayText;
  FGroupIndex := -1;
  FStreamedButtonWidth := -1;
  FImageKind := ikCustom;
  FImageIndex := -1;
  FNumGlyphs := 1;
  inherited OnKeyDown := LocalKeyDown;
  (* -- RDB -- *)
end;

{$IFDEF VCL}
procedure TJvCustomComboEdit.CreateParams(var Params: TCreateParams);
const
  Alignments: array [TAlignment] of LongWord = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN
    or Alignments[FAlignment];
end;
{$ENDIF VCL}

{$IFDEF VisualCLX}
procedure TJvCustomComboEdit.CreateWidget;
begin
  inherited CreateWidget;
  SetEditRect;
end;
{$ENDIF VisualCLX}
{$IFDEF VCL}
procedure TJvCustomComboEdit.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
end;
{$ENDIF VCL}

class function TJvCustomComboEdit.DefaultImageIndex: TImageIndex;
begin
  Result := -1;
end;

class function TJvCustomComboEdit.DefaultImages: TCustomImageList;
begin
  if GDefaultComboEditImagesList = nil then
  begin
    GDefaultComboEditImagesList := TImageList.CreateSize(14, 12);
    AddFinalizeObjectNil(sUnitName, TObject(GDefaultComboEditImagesList));
  end;
  Result := GDefaultComboEditImagesList;
end;

procedure TJvCustomComboEdit.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('GlyphKind', ReadGlyphKind, nil, False);
end;

destructor TJvCustomComboEdit.Destroy;
begin
  FButton.OnClick := nil;
  inherited Destroy;
end;

procedure TJvCustomComboEdit.DoBoundsChanged;
var
  MinHeight: Integer;
begin
  inherited DoBoundsChanged;
  if not (csLoading in ComponentState) then
  begin
    MinHeight := GetMinHeight;
    { text edit bug: if size to less than MinHeight, then edit ctrl does
      not display the text }
    if Height < MinHeight then
    begin
      Height := MinHeight;
      Exit;
    end;
  end
  else
  begin
    if (FPopup <> nil) and (csDesigning in ComponentState) then
      FPopup.SetBounds(0, Height + 1, 10, 10);
  end;
  UpdateBtnBounds;
end;

procedure TJvCustomComboEdit.DoChange;
begin
  inherited Change;
end;

procedure TJvCustomComboEdit.DoClearText;
begin
  Text := '';
end;

procedure TJvCustomComboEdit.DoClick;
begin
  EditButtonClick(Self);
end;

procedure TJvCustomComboEdit.DoClipboardCut;
begin
  if FDirectInput and not ReadOnly then
    inherited DoClipboardCut;
end;

procedure TJvCustomComboEdit.DoClipboardPaste;
begin
  if FDirectInput and not ReadOnly then
    inherited DoClipboardPaste;
  UpdateEdit;
end;

procedure TJvCustomComboEdit.DoEnter;
begin
  if AutoSelect and not (csLButtonDown in ControlState) then
    SelectAll;
  inherited DoEnter;
end;

{$IFDEF VisualCLX}
procedure TJvCustomComboEdit.DoFlatChanged;
begin
  inherited DoFlatChanged;
  UpdateBtnBounds;
end;
{$ENDIF VisualCLX}

procedure TJvCustomComboEdit.DoKillFocus(FocusedWnd: HWND);
begin
  inherited DoKillFocus(FocusedWnd);
  FFocused := False;
  PopupCloseUp(FPopup, False);
end;

function TJvCustomComboEdit.DoPaintBackground(Canvas: TCanvas; Param: Integer): Boolean;
begin
  Result := True;
  if csDestroying in ComponentState then
    Exit;
  if Enabled then
    Result := inherited DoPaintBackground(Canvas, Param)
  else
  begin
    Canvas.Brush.Color := FDisabledColor;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(ClientRect);
  end;
end;

procedure TJvCustomComboEdit.DoSetFocus(FocusedWnd: HWND);
begin
  inherited DoSetFocus(FocusedWnd);
  FFocused := True;
  SetShowCaret;
end;

procedure TJvCustomComboEdit.EditButtonClick(Sender: TObject);
begin
  if (not FReadOnly) or AlwaysEnable then
    ButtonClick;
end;

function TJvCustomComboEdit.EditCanModify: Boolean;
begin
  Result := not FReadOnly;
end;

procedure TJvCustomComboEdit.EnabledChanged;
begin
  inherited EnabledChanged;
  Invalidate;
  FButton.Enabled := Enabled;
  if Assigned(FOnEnabledChanged) then
    FOnEnabledChanged(Self);
end;

procedure TJvCustomComboEdit.FontChanged;
begin
  inherited FontChanged;
  if HandleAllocated then
    SetEditRect;
end;

function TJvCustomComboEdit.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TJvCustomComboEditActionLink;
end;

function TJvCustomComboEdit.GetButtonFlat: Boolean;
begin
  Result := FButton.Flat;
end;

function TJvCustomComboEdit.GetButtonHint: string;
begin
  Result := FButton.Hint;
end;

function TJvCustomComboEdit.GetButtonWidth: Integer;
begin
  Result := FButton.Width;
end;

function TJvCustomComboEdit.GetDirectInput: Boolean;
begin
  Result := FDirectInput;
end;

function TJvCustomComboEdit.GetGlyph: TBitmap;
begin
  Result := FButton.Glyph;
end;

function TJvCustomComboEdit.GetGlyphKind: TGlyphKind;
begin
  Result := TGlyphKind(FImageKind);
end;

function TJvCustomComboEdit.GetMinHeight: Integer;
var
  I: Integer;
begin
  I := GetTextHeight;
  if BorderStyle = bsSingle then
    I := I + GetSystemMetrics(SM_CYBORDER) * 4 + 1;
  Result := I;
end;

function TJvCustomComboEdit.GetNumGlyphs: TNumGlyphs;
begin
  if ImageKind <> ikCustom then
    Result := FNumGlyphs
  else
    Result := FButton.NumGlyphs;
end;

function TJvCustomComboEdit.GetPopupValue: Variant;
begin
  if FPopup <> nil then
    Result := TJvPopupWindow(FPopup).GetValue
  else
    Result := '';
end;

function TJvCustomComboEdit.GetPopupVisible: Boolean;
begin
  Result := (FPopup <> nil) and FPopupVisible;
end;

function TJvCustomComboEdit.GetReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

function TJvCustomComboEdit.GetTextHeight: Integer;
var
  DC: HDC;
  SaveFont: HFONT;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  try
    GetTextMetrics(DC, SysMetrics);
    SaveFont := SelectObject(DC, Font.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
  finally
    ReleaseDC(0, DC);
  end;
  //  Result := Min(SysMetrics.tmHeight, Metrics.tmHeight);  // Polaris
  Result := Metrics.tmHeight; // Polaris
end;

procedure TJvCustomComboEdit.HidePopup;
begin
  TJvPopupWindow(FPopup).Hide;
end;

function TJvCustomComboEdit.IsCustomGlyph: Boolean;
begin
  Result := Assigned(Glyph) and (ImageKind = ikCustom);
end;

function TJvCustomComboEdit.IsImageIndexStored: Boolean;
begin
  Result :=
    not (ActionLink is TJvCustomComboEditActionLink) or
    not (ActionLink as TJvCustomComboEditActionLink).IsImageIndexLinked;
end;

procedure TJvCustomComboEdit.KeyDown(var Key: Word; Shift: TShiftState);
//Polaris
var
  Form: TCustomForm;
begin
  //Polaris
  Form := GetParentForm(Self);
  if (ssCtrl in Shift) then
    case Key of
      VK_RETURN:
        if (Form <> nil) {and Form.KeyPreview} then
        begin
          TWinControlHack(Form).KeyDown(Key, Shift);
          Key := 0;
        end;
      VK_TAB:
        if (Form <> nil) {and Form.KeyPreview} then
        begin
          TWinControlHack(Form).KeyDown(Key, Shift);
          Key := 0;
        end;
    end;
  //Original
  inherited KeyDown(Key, Shift);
  if (FClickKey = ShortCut(Key, Shift)) and (ButtonWidth > 0) then
  begin
    EditButtonClick(Self);
    Key := 0;
  end;
end;

procedure TJvCustomComboEdit.KeyPress(var Key: Char);
var
  Form: TCustomForm;
begin
  Form := GetParentForm(Self);

  //Polaris  if (Key = Char(VK_RETURN)) or (Key = Char(VK_ESCAPE)) then
//  if (Key = Char(VK_RETURN)) or (Key = Char(VK_ESCAPE)) or ((Key = #10) and PopupVisible) then
  if (Key = #13) or (Key = #27) or ((Key = #10) and PopupVisible) then
  begin
    if PopupVisible then
    begin
      //Polaris      PopupCloseUp(FPopup, Key = Char(VK_RETURN));
      PopupCloseUp(FPopup, Key <> #27);
      Key := #0;
    end
    else
    begin
      { must catch and remove this, since is actually multi-line }
      {$IFDEF VCL}
      GetParentForm(Self).Perform(CM_DIALOGKEY, Byte(Key), 0);
      {$ENDIF VCL}
      {$IFDEF VisualCLX}
      TCustomFormHack(GetParentForm(Self)).NeedKey(Integer(Key), [], WideChar(Key));
      {$ENDIF VisualCLX}
      if Key = #13 then
      begin
        inherited KeyPress(Key);
        Key := #0;
        Exit;
      end;
    end;
  end;
  //Polaris
  if Key in [#10, #9] then
  begin
    Key := #0;
    if (Form <> nil) {and Form.KeyPreview} then
      TWinControlHack(Form).KeyPress(Key);
  end;
  //Polaris
  inherited KeyPress(Key);
end;

procedure TJvCustomComboEdit.Loaded;
begin
  inherited Loaded;
  if FStreamedButtonWidth >= 0 then
    SetButtonWidth(FStreamedButtonWidth);
  DoBoundsChanged;
end;

procedure TJvCustomComboEdit.LocalKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateEdit;
  if Assigned(FOnKeyDown) then
    FOnKeyDown(Sender, Key, Shift);
end;

procedure TJvCustomComboEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if (FPopup <> nil) and (Button = mbLeft) then
  begin
    if CanFocus then
      SetFocus;
    if not FFocused then
      Exit;
    if FPopupVisible then
      PopupCloseUp(FPopup, False);
    {else
     if (not ReadOnly or AlwaysEnable) and (not DirectInput) then
       PopupDropDown(True);}
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TJvCustomComboEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FImages) then
    Images := nil;
end;

{$IFDEF VisualCLX}
procedure TJvCustomComboEdit.Paint;
begin
  if Enabled then
    inherited Paint
  else
  begin
    if not PaintEdit(Self, Text, FAlignment, PopupVisible,
      DisabledTextColor, Focused and not PopupVisible, {Flat:}False, Canvas) then
      inherited Paint;
  end;
end;
{$ENDIF VisualCLX}

procedure TJvCustomComboEdit.PopupChange;
begin
end;

procedure TJvCustomComboEdit.PopupCloseUp(Sender: TObject; Accept: Boolean);
var
  AValue: Variant;
begin
  if (FPopup <> nil) and FPopupVisible then
  begin
    {$IFDEF VCL}
    if GetCapture <> 0 then
      SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    if Mouse.Capture <> nil then
      Mouse.Capture := nil;
    {$ENDIF VisualCLX}
    AValue := GetPopupValue;
    HidePopup;
    try
      try
        if CanFocus then
        begin
          SetFocus;
          if GetFocus = Handle then
            SetShowCaret;
        end;
      except
        { ignore exceptions }
      end;
      SetDirectInput(DirectInput);
      Invalidate;
      if Accept and AcceptPopup(AValue) and EditCanModify then
      begin
        AcceptValue(AValue);
        if FFocused then
          inherited SelectAll;
      end;
    finally
      FPopupVisible := False;
    end;
  end;
end;

procedure TJvCustomComboEdit.PopupDropDown(DisableEdit: Boolean);
var
  P: TPoint;
  Y: Integer;
begin
  if (FPopup <> nil) and not (ReadOnly or FPopupVisible) then
  begin
    P := Parent.ClientToScreen(Point(Left, Top));
    Y := P.Y + Height;
    if Y + FPopup.Height > Screen.Height then
      Y := P.Y - FPopup.Height;
    case FPopupAlign of
      epaRight:
        begin
          Dec(P.X, FPopup.Width - Width);
          if P.X < 0 then
            Inc(P.X, FPopup.Width - Width);
        end;
      epaLeft:
        begin
          if P.X + FPopup.Width > Screen.Width then
            Dec(P.X, FPopup.Width - Width);
        end;
    end;
    if P.X < 0 then
      P.X := 0
    else
    if P.X + FPopup.Width > Screen.Width then
      P.X := Screen.Width - FPopup.Width;
    if Text <> '' then
      SetPopupValue(Text)
    else
      SetPopupValue(NULL);
    if CanFocus then
      SetFocus;
    ShowPopup(Point(P.X, Y));
    FPopupVisible := True;
    if DisableEdit then
    begin
      inherited ReadOnly := True;
      HideCaret(Handle);
    end;
  end;
end;

procedure TJvCustomComboEdit.ReadGlyphKind(Reader: TReader);
const
  sEnumValues: array [TGlyphKind] of string =
    ('gkCustom', 'gkDefault', 'gkDropDown', 'gkEllipsis');
var
  S: string;
  GlyphKind: TGlyphKind;
begin
  { No need to drag in TypInfo.pas }
  S := Reader.ReadIdent;
  for GlyphKind := Low(TGlyphKind) to High(TGlyphKind) do
    if SameText(S, sEnumValues[GlyphKind]) then
    begin
      ImageKind := TJvImageKind(GlyphKind);
      Break;
    end;
end;

procedure TJvCustomComboEdit.RecreateGlyph;
var
  NewGlyph: TBitmap;

  function CreateEllipsisGlyph: TBitmap;
  var
    W, g, I: Integer;
  begin
    Result := TBitmap.Create;
    with Result do
    try
      Monochrome := True;
      Width := Max(1, FButton.Width - 6);
      Height := 4;
      W := 2;
      g := (Result.Width - 3 * W) div 2;
      if g <= 0 then
        g := 1;
      if g > 3 then
        g := 3;
      I := (Width - 3 * W - 2 * g) div 2;
      PatBlt(Canvas.Handle, I, 1, W, W, BLACKNESS);
      PatBlt(Canvas.Handle, I + g + W, 1, W, W, BLACKNESS);
      PatBlt(Canvas.Handle, I + 2 * g + 2 * W, 1, W, W, BLACKNESS);
    except
      Free;
      raise;
    end;
  end;

begin
  if FImageKind in [ikDropDown, ikEllipsis] then
  begin
    FButton.ImageIndex := -1;
    FButton.NumGlyphs := 1;
  end;

  case FImageKind of
    ikDropDown:
      begin
        {$IFDEF JVCLThemesEnabled}
        { When XP Themes are enabled, ButtonFlat = False, GlyphKind = gkDropDown then
          the glyph is the default themed dropdown button. When ButtonFlat = True, we
          can't use that default dropdown button (because we then use toolbar buttons,
          and there is no themed dropdown toolbar button) }
        FButton.FDrawThemedDropDownBtn :=
          ThemeServices.ThemesEnabled and not ButtonFlat;
        if FButton.FDrawThemedDropDownBtn then
        begin
          TJvxButtonGlyph(FButton.ButtonGlyph).Glyph := nil;
          FButton.Invalidate;
        end
        else
        {$ENDIF JVCLThemesEnabled}
        begin
          LoadDefaultBitmap(TJvxButtonGlyph(FButton.ButtonGlyph).Glyph, OBM_COMBO);
          FButton.Invalidate;
        end;
      end;
    ikEllipsis:
      begin
        NewGlyph := CreateEllipsisGlyph;
        try
          TJvxButtonGlyph(FButton.ButtonGlyph).Glyph := NewGlyph;
          FButton.Invalidate;
        finally
          NewGlyph.Destroy;
        end;
      end;
  else
//    TJvxButtonGlyph(FButton.ButtonGlyph).Glyph := nil;
    FButton.Invalidate;
  end;
end;

procedure TJvCustomComboEdit.SelectAll;
begin
  if DirectInput then
    inherited SelectAll;
end;

procedure TJvCustomComboEdit.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    {$IFDEF VCL}
    RecreateWnd;
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    Invalidate;
    {$ENDIF VisualCLX}
  end;
end;

procedure TJvCustomComboEdit.SetButtonFlat(const Value: Boolean);
begin
  FButton.Flat := Value;
  {$IFDEF JVCLThemesEnabled}
  { When XP Themes are enabled, ButtonFlat = False, GlyphKind = gkDropDown then
    the glyph is the default themed dropdown button. When ButtonFlat = True, we
    can't use that default dropdown button, so we have to recreate the glyph
    in this special case }
  if ThemeServices.ThemesEnabled and (ImageKind = ikDropDown) then
    RecreateGlyph;
  {$ENDIF JVCLThemesEnabled}
end;

procedure TJvCustomComboEdit.SetButtonHint(const Value: string);
begin
  FButton.Hint := Value;
end;

procedure TJvCustomComboEdit.SetButtonWidth(Value: Integer);
begin
  if csLoading in ComponentState then
    FStreamedButtonWidth := Value
  else
  if ButtonWidth <> Value then
  begin
    FBtnControl.Visible := Value > 1;
    if csCreating in ControlState then
    begin
      FBtnControl.Width := Value;
      FButton.Width := Value;
      with FButton do
        ControlStyle := ControlStyle - [csFixedWidth];
      RecreateGlyph;
    end
      //else
      //if (Value <> ButtonWidth) and (Value < ClientWidth) then begin
      //Polaris
    else
    if (Value <> ButtonWidth) and
      ((Assigned(Parent) and (Value < ClientWidth)) or
      (not Assigned(Parent) and (Value < Width))) then
    begin
      FButton.Width := Value;
      with FButton do
        ControlStyle := ControlStyle - [csFixedWidth];
      if HandleAllocated then
        {$IFDEF VCL}
        RecreateWnd;
        {$ENDIF VCL}
        {$IFDEF VisualCLX}
        Invalidate;
        {$ENDIF VisualCLX}
      RecreateGlyph;
    end;
  end;
end;

procedure TJvCustomComboEdit.SetClipboardCommands(const Value: TJvClipboardCommands);
begin
  if ClipboardCommands <> Value then
  begin
    inherited SetClipboardCommands(Value);
    ReadOnly := ClipboardCommands <= [caCopy];
  end;
end;

procedure TJvCustomComboEdit.SetDirectInput(Value: Boolean);
begin
  inherited ReadOnly := not Value or FReadOnly;
  FDirectInput := Value;
end;

procedure TJvCustomComboEdit.SetDisabledColor(const Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    if not Enabled then
      Invalidate;
  end;
end;

procedure TJvCustomComboEdit.SetDisabledTextColor(const Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    if not Enabled then
      Invalidate;
  end;
end;

procedure TJvCustomComboEdit.SetEditRect;
const
  CPixelsBetweenEditAndButton = 2;
var
  Loc: TRect;
  LLeft: Integer;
  LTop: Integer;
  LRight: Integer;
begin
  AdjustHeight;

  LTop := 0;
  LLeft := 0;
  LRight := 0;

  {$IFDEF JVCLThemesEnabled}
  { If flat and themes are enabled, move the left edge of the edit rectangle
    to the right, otherwise the theme edge paints over the border }
  if ThemeServices.ThemesEnabled then
  begin
    if BorderStyle = bsSingle then
    begin
      if not Ctl3D then
        LLeft := 3
      else
      begin
        LLeft := 1;
        LTop := 1;
      end;
    end;
  end;
  {$ENDIF JVCLThemesEnabled}

  if NewStyleControls and (BorderStyle = bsSingle) then
  begin
    {$IFDEF VCL}
    if Ctl3D then
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    if not Flat then
    {$ENDIF VisualCLX}
      LRight := 1
    else
      LRight := 2;
  end;

  SetRect(Loc, LLeft, LTop, FBtnControl.Left + LRight - CPixelsBetweenEditAndButton, ClientHeight - 1);
  {$IFDEF VCL}
  SendMessage(Handle, EM_SETRECTNP, 0, Longint(@Loc));
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  SetEditorRect(@Loc);
  {$ENDIF VisualCLX}

  //Polaris
  //  SendMessage(Handle, EM_SETMARGINS, EC_RIGHTMARGIN, MakeLong(0, FBtnControl.Width));
end;

procedure TJvCustomComboEdit.SetGlyph(Value: TBitmap);
begin
  ImageKind := ikCustom;
  FButton.Glyph := Value;
  FNumGlyphs := FButton.NumGlyphs;
end;

procedure TJvCustomComboEdit.SetGlyphKind(Value: TGlyphKind);
begin
  ImageKind := TJvImageKind(Value);
end;

procedure TJvCustomComboEdit.SetGroupIndex(const Value: Integer);
begin
  FGroupIndex := Value;
  UpdateEdit;
end;

procedure TJvCustomComboEdit.SetImageIndex(const Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if FImageKind = ikCustom then
      FButton.ImageIndex := FImageIndex;
  end;
end;

procedure TJvCustomComboEdit.SetImageKind(const Value: TJvImageKind);
begin
  if FImageKind <> Value then
  begin
    FImageKind := Value;
    RecreateGlyph;
    case FImageKind of
      ikCustom:
        begin
          FButton.Images := FImages;
          FButton.ImageIndex := FImageIndex;
          FButton.NumGlyphs := FNumGlyphs;
        end;
      ikDefault:
        begin
          FButton.Images := DefaultImages;
          FButton.ImageIndex := DefaultImageIndex;
          { Default glyphs have a default width }
          if Assigned(FButton.Images) and (FButton.ImageIndex >= 0) then
            ButtonWidth := Max(FButton.Images.Width + 6, FButton.Width)
        end;
      ikDropDown:
        begin
          { Dropdown has a default width }
          ButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
          with FButton do
            ControlStyle := ControlStyle + [csFixedWidth];
        end;
      ikEllipsis: ;
    end;
  end;
end;

procedure TJvCustomComboEdit.SetImages(const Value: TCustomImageList);
begin
  FImages := Value;
  if FImages <> nil then
    FImages.FreeNotification(Self)
  else
    SetImageIndex(-1);
  if ImageKind = ikCustom then
  begin
    FButton.Images := FImages;
    FButton.ImageIndex := FImageIndex;
  end;
end;

procedure TJvCustomComboEdit.SetNumGlyphs(const Value: TNumGlyphs);
begin
  //if FGlyphKind in [gkDropDown, gkEllipsis] then
  //  FButton.NumGlyphs := 1
  //else
  //if FGlyphKind = gkDefault then
  //  FButton.NumGlyphs := FDefNumGlyphs
  //else
  FNumGlyphs := Value;
  if ImageKind = ikCustom then
    FButton.NumGlyphs := Value;
end;

procedure TJvCustomComboEdit.SetPopupValue(const Value: Variant);
begin
  if FPopup <> nil then
    TJvPopupWindow(FPopup).SetValue(Value);
end;

procedure TJvCustomComboEdit.SetReadOnly(Value: Boolean);
begin
  if Value <> FReadOnly then
  begin
    FReadOnly := Value;
    inherited ReadOnly := Value or not FDirectInput;
  end;
end;

procedure TJvCustomComboEdit.SetShowCaret;
const
  CaretWidth: array [Boolean] of Byte = (1, 2);
begin
  CreateCaret(Handle, 0, CaretWidth[fsBold in Font.Style], GetTextHeight);
  ShowCaret(Handle);
end;

procedure TJvCustomComboEdit.ShowPopup(Origin: TPoint);
begin
  TJvPopupWindow(FPopup).Show(Origin);
end;

procedure TJvCustomComboEdit.UpdateBtnBounds;
var
  BtnRect: TRect;
begin
  if NewStyleControls then
    {$IFDEF JVCLThemesEnabled}
    if ThemeServices.ThemesEnabled then
    begin
      if BorderStyle = bsSingle then
      begin
        if Ctl3D then
          BtnRect := Bounds(Width - FButton.Width - 2, 0,
            FButton.Width, Height - 2)
        else
          BtnRect := Bounds(Width - FButton.Width - 1, 1,
            FButton.Width, Height - 2);
      end
      else
        BtnRect := Bounds(Width - FButton.Width, 0,
          FButton.Width, Height);
    end
    else
    {$ENDIF JVCLThemesEnabled}
    begin
      if BorderStyle = bsSingle then
      begin
        {$IFDEF VCL}
        if Ctl3D then
        {$ENDIF VCL}
        {$IFDEF VisualCLX}
        if not Flat then
        {$ENDIF VisualCLX}
          BtnRect := Bounds(Width - FButton.Width - 4, 0,
            FButton.Width, Height - 4)
        else
          BtnRect := Bounds(Width - FButton.Width - 2, 2,
            FButton.Width, Height - 4)
      end
      else
        BtnRect := Bounds(Width - FButton.Width, 0,
          FButton.Width, Height);
    end
  else
    BtnRect := Bounds(Width - FButton.Width, 0, FButton.Width, Height);
  with BtnRect do
    FBtnControl.SetBounds(Left, Top, Right - Left, Bottom - Top);
  FButton.Height := FBtnControl.Height;
  SetEditRect;
end;

procedure TJvCustomComboEdit.UpdateEdit;
var
  I: Integer;
begin
  if Owner <> nil then
    for I := 0 to Owner.ComponentCount - 1 do
      if Owner.Components[I] is TJvCustomComboEdit then
        if ((Owner.Components[I].Name <> Self.Name) and
          ((Owner.Components[I] as TJvCustomComboEdit).FGroupIndex <> -1) and
          ((Owner.Components[I] as TJvCustomComboEdit).FGroupIndex = Self.FGroupIndex)) then
          (Owner.Components[I] as TJvCustomComboEdit).Caption := '';
end;

procedure TJvCustomComboEdit.UpdatePopupVisible;
begin
  FPopupVisible := (FPopup <> nil) and FPopup.Visible;
end;

{$IFDEF JVCLThemesEnabled}
procedure TJvCustomComboEdit.WMNCCalcSize(var Msg: TWMNCCalcSize);
begin
  if ThemeServices.ThemesEnabled and Ctl3D and (BorderStyle = bsSingle) then
    with Msg.CalcSize_Params^ do
      InflateRect(rgrc[0], 1, 1);
  inherited;
end;
{$ENDIF JVCLThemesEnabled}

{$IFDEF VCL}
procedure TJvCustomComboEdit.WMNCHitTest(var Msg: TWMNCHitTest);
var
  P: TPoint;
begin
  inherited;
  if Msg.Result = HTCLIENT then
  begin
    P := Point(FBtnControl.Left, FBtnControl.Top);
    Windows.ClientToScreen(Handle, P);
    if Msg.XPos > P.X then
      Msg.Result := HTCAPTION;
  end;
end;
{$ENDIF VCL}

{$IFDEF JVCLThemesEnabled}
procedure TJvCustomComboEdit.WMNCPaint(var Msg: TWMNCPaint);
var
  DC: HDC;
  DrawRect: TRect;
  Details: TThemedElementDetails;
begin
  if ThemeServices.ThemesEnabled and Ctl3D and (BorderStyle = bsSingle) then
  begin
    DC := GetWindowDC(Handle);
    try
      GetWindowRect(Handle, DrawRect);
      OffsetRect(DrawRect, -DrawRect.Left, -DrawRect.Top);
      with DrawRect do
        ExcludeClipRect(DC, Left + 1, Top + 1, Right - 1, Bottom - 1);

      Details := ThemeServices.GetElementDetails(teEditTextNormal);
      ThemeServices.DrawElement(DC, Details, DrawRect);
    finally
      ReleaseDC(Handle, DC);
    end;
    Msg.Result := 0;
  end
  else
    inherited;
end;
{$ENDIF JVCLThemesEnabled}

{$IFDEF VCL}
procedure TJvCustomComboEdit.WMPaint(var Msg: TWMPaint);
var
  Canvas: TControlCanvas;
begin
  if Enabled then
    inherited
  else
  begin
    Canvas := nil;
    if not PaintEdit(Self, Text, FAlignment, PopupVisible,
      DisabledTextColor, Focused and not PopupVisible, Canvas, Msg) then
      inherited;
    Canvas.Free;
  end;
end;
{$ENDIF VCL}

//=== TJvCustomComboEditActionLink ===========================================

function TJvCustomComboEditActionLink.IsCaptionLinked: Boolean;
begin
  Result := False;
end;

function TJvCustomComboEditActionLink.IsHintLinked: Boolean;
begin
  Result := (Action is TCustomAction) and (FClient is TJvCustomComboEdit) and
    ((FClient as TJvCustomComboEdit).ButtonHint = (Action as TCustomAction).Hint);
end;

function TJvCustomComboEditActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and (FClient is TJvCustomComboEdit) and
    ((FClient as TJvCustomComboEdit).ImageIndex = (Action as TCustomAction).ImageIndex);
end;

function TJvCustomComboEditActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := (Action is TCustomAction) and (FClient is TJvCustomComboEdit) and
    (@(FClient as TJvCustomComboEdit).OnButtonClick = @Action.OnExecute);
end;

function TJvCustomComboEditActionLink.IsShortCutLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and (FClient is TJvCustomComboEdit) and
    ((FClient as TJvCustomComboEdit).ClickKey = (Action as TCustomAction).ShortCut);
end;

procedure TJvCustomComboEditActionLink.SetHint(const Value: THintString);
begin
  if IsHintLinked then
    (FClient as TJvCustomComboEdit).ButtonHint := Value;
end;

procedure TJvCustomComboEditActionLink.SetImageIndex(Value: Integer);
begin
  if IsImageIndexLinked then
    (FClient as TJvCustomComboEdit).ImageIndex := Value;
end;

procedure TJvCustomComboEditActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then
    (FClient as TJvCustomComboEdit).OnButtonClick := Value;
end;

procedure TJvCustomComboEditActionLink.SetShortCut(Value: TShortCut);
begin
  if IsShortCutLinked then
    (FClient as TJvCustomComboEdit).ClickKey := Value;
end;

//=== TJvCustomDateEdit ======================================================

function TJvCustomDateEdit.AcceptPopup(var Value: Variant): Boolean;
var
  d: TDateTime;
begin
  Result := True;
  if Assigned(FOnAcceptDate) then
  begin
    if VarIsNull(Value) or VarIsEmpty(Value) then
      d := NullDate
    else
    try
      d := VarToDateTime(Value);
    except
      if DefaultToday then
        d := SysUtils.Date
      else
        d := NullDate;
    end;
    FOnAcceptDate(Self, d, Result);
    if Result then
      Value := VarFromDateTime(d);
  end;
end;

procedure TJvCustomDateEdit.AcceptValue(const Value: Variant);
begin
  SetDate(VarToDateTime(Value));
  UpdatePopupVisible;
  if Modified then
    inherited Change;
end;

procedure TJvCustomDateEdit.ApplyDate(Value: TDateTime);
begin
  SetDate(Value);
  SelectAll;
end;

procedure TJvCustomDateEdit.ButtonClick;
var
  d: TDateTime;
  Action: Boolean;
begin
  inherited ButtonClick;
  if CalendarStyle = csDialog then
  begin
    d := Self.Date;
    Action := SelectDate(Self, d, DialogTitle, StartOfWeek, Weekends, // Polaris (Self added)
      WeekendColor, CalendarHints,
      MinDate, MaxDate); // Polaris
    if CanFocus then
      SetFocus;
    if Action then
    begin
      if Assigned(FOnAcceptDate) then
        FOnAcceptDate(Self, d, Action);
      if Action then
      begin
        Self.Date := d;
        if FFocused then
          inherited SelectAll;
      end;
    end;
  end;
end;

procedure TJvCustomDateEdit.CalendarHintsChanged(Sender: TObject);
begin
  FCalendarHints.OnChange := nil;
  try
    while CalendarHints.Count > 4 do
      CalendarHints.Delete(CalendarHints.Count - 1);
  finally
    FCalendarHints.OnChange := CalendarHintsChanged;
  end;
  if not (csDesigning in ComponentState) then
    UpdatePopup;
end;

procedure TJvCustomDateEdit.Change;
begin
  if not FFormatting then
    inherited Change;
end;

// Polaris

procedure TJvCustomDateEdit.CheckValidDate;
var ADate:TDateTime;
begin
  if TextStored then
  try
    FFormatting := True;
    try
      SetDate(StrToDateFmt(FDateFormat, Text));
    finally
      FFormatting := False;
    end;
  except
    if CanFocus then
      SetFocus;
    ADate := Self.Date;
    if DoInvalidDate(Text,ADate) then
      Self.Date := ADate
    else
      raise;
  end;
end;

constructor TJvCustomDateEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Polaris
  FDateAutoBetween := True;
  FMinDate := NullDate;
  FMaxDate := NullDate;

  FBlanksChar := ' ';
  FTitle := RsDateDlgCaption;
  {$IFDEF VCL}
  FPopupColor := clMenu;
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  FPopupColor := clWindow;
  {$ENDIF VisualCLX}
  //  FDefNumGlyphs := 2;
  FStartOfWeek := Mon;
  FWeekends := [Sun];
  FWeekendColor := clRed;
  FYearDigits := dyDefault;
  FCalendarHints := TStringList.Create;
  FCalendarHints.OnChange := CalendarHintsChanged;
  {$IFDEF VCL}
  DateHook.Add;
  {$ENDIF VCL}

  ControlState := ControlState + [csCreating];
  try
    UpdateFormat;
    {$IFDEF DEFAULT_POPUP_CALENDAR}
    FPopup := TJvPopupWindow(CreatePopupCalendar(Self,
      {$IFDEF VCL}
      BiDiMode,
      {$ENDIF VCL}
      {$IFDEF VisualCLX}
      bdLeftToRight,
      {$ENDIF VisualCLX}
      // Polaris
      FMinDate, FMaxDate));
    TJvPopupWindow(FPopup).OnCloseUp := PopupCloseUp;
    TJvPopupWindow(FPopup).Color := FPopupColor;
    {$ENDIF DEFAULT_POPUP_CALENDAR}
    ImageKind := ikDefault; { force update }
  finally
    ControlState := ControlState - [csCreating];
  end;
end;

{$IFDEF VisualCLX}
procedure TJvCustomDateEdit.CreateWidget;
begin
  inherited CreateWidget;
  if HandleAllocated then
    UpdateMask;
end;
{$ENDIF VisualCLX}
{$IFDEF VCL}
procedure TJvCustomDateEdit.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited CreateWindowHandle(Params);
  if Handle <> 0 then
    UpdateMask;
end;
{$ENDIF VCL}

class function TJvCustomDateEdit.DefaultImageIndex: TImageIndex;
var
  Bmp: TBitmap;
begin
  if GDateImageIndex < 0 then
  begin
    Bmp := TBitmap.Create;
    try
      Bmp.LoadFromResourceName(HInstance, sDateBmp);
      GDateImageIndex := DefaultImages.AddMasked(Bmp, clFuchsia);
    finally
      Bmp.Free;
    end;
  end;

  Result := GDateImageIndex;
end;

destructor TJvCustomDateEdit.Destroy;
begin
  {$IFDEF VCL}
  DateHook.Delete;
  {$ENDIF VCL}

  if FPopup <> nil then
  begin
    TJvPopupWindow(FPopup).OnCloseUp := nil;
    FPopup.Parent := nil;
  end;
  FPopup.Free;
  FPopup := nil;
  FCalendarHints.OnChange := nil;
  FCalendarHints.Free;
  FCalendarHints := nil;
  inherited Destroy;
end;

procedure TJvCustomDateEdit.DoExit;
begin
  if not (csDesigning in ComponentState) and CheckOnExit then
    CheckValidDate;
  inherited DoExit;
end;

function TJvCustomDateEdit.DoInvalidDate(const DateString: string;
  var ANewDate: TDateTime): boolean;
begin
  Result := False;
  if Assigned(FOnInvalidDate) then
    FOnInvalidDate(Self, DateString, ANewDate, Result);
end;

function TJvCustomDateEdit.FourDigitYear: Boolean;
begin
  Result := (FYearDigits = dyFour) or ((FYearDigits = dyDefault) and
   IsFourDigitYear);
end;

function TJvCustomDateEdit.GetCalendarHints: TStrings;
begin
  Result := FCalendarHints;
end;

function TJvCustomDateEdit.GetCalendarStyle: TCalendarStyle;
begin
  if FPopup <> nil then
    Result := csPopup
  else
    Result := csDialog;
end;

function TJvCustomDateEdit.GetDate: TDateTime;
begin
  if DefaultToday then
    Result := SysUtils.Date
  else
    Result := NullDate;
  Result := StrToDateFmtDef(FDateFormat, Text, Result);
end;

function TJvCustomDateEdit.GetDateFormat: string;
begin
  Result := FDateFormat;
end;

function TJvCustomDateEdit.GetDateMask: string;
begin
  Result := DefDateMask(FBlanksChar, FourDigitYear);
end;

function TJvCustomDateEdit.GetDialogTitle: string;
begin
  Result := FTitle;
end;

function TJvCustomDateEdit.GetPopupColor: TColor;
begin
  if FPopup <> nil then
    Result := TJvPopupWindow(FPopup).Color
  else
    Result := FPopupColor;
end;

function TJvCustomDateEdit.IsCustomTitle: Boolean;
begin
  Result := (CompareStr(RsDateDlgCaption, DialogTitle) <> 0) and
    (DialogTitle <> EmptyStr); // Polaris
end;

procedure TJvCustomDateEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if IsInWordArray(Key, [VK_PRIOR, VK_NEXT, VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN,
    VK_ADD, VK_SUBTRACT, VK_RETURN]) and PopupVisible then
  begin
    TJvPopupWindow(FPopup).KeyDown(Key, Shift);
    Key := 0;
  end
  else
  if (Shift = []) and DirectInput then
  begin
    case Key of
      VK_ADD:
        begin
          ApplyDate(NvlDate(Date, Now) + 1);
          Key := 0;
        end;
      VK_SUBTRACT:
        begin
          ApplyDate(NvlDate(Date, Now) - 1);
          Key := 0;
        end;
    end;
  end;
  inherited KeyDown(Key, Shift);
end;

procedure TJvCustomDateEdit.KeyPress(var Key: Char);
begin
  if (Key in ['T', 't', '+', '-']) and PopupVisible then
  begin
    TJvPopupWindow(FPopup).KeyPress(Key);
    Key := #0;
  end
  else
  if DirectInput then
    case Key of
      'T', 't':
        begin
          ApplyDate(Trunc(Now));
          Key := #0;
        end;
      '+', '-':
        Key := #0;
    end;
  inherited KeyPress(Key);
end;

procedure TJvCustomDateEdit.SetBlanksChar(Value: Char);
begin
  if Value <> FBlanksChar then
  begin
    if Value < ' ' then
      Value := ' ';
    FBlanksChar := Value;
    UpdateMask;
  end;
end;

procedure TJvCustomDateEdit.SetCalendarHints(Value: TStrings);
begin
  FCalendarHints.Assign(Value);
end;

procedure TJvCustomDateEdit.SetCalendarStyle(Value: TCalendarStyle);
begin
  if Value <> CalendarStyle then
  begin
    case Value of
      csPopup:
        begin
          if FPopup = nil then
            FPopup := TJvPopupWindow(CreatePopupCalendar(Self,
              {$IFDEF VCL}
              BiDiMode,
              {$ENDIF VCL}
              {$IFDEF VisualCLX}
              bdLeftToRight,
              {$ENDIF VisualCLX}
              FMinDate, FMaxDate)); // Polaris
          TJvPopupWindow(FPopup).OnCloseUp := PopupCloseUp;
          TJvPopupWindow(FPopup).Color := FPopupColor;
          UpdatePopup;
        end;
      csDialog:
        begin
          FreeAndNil(FPopup);
        end;
    end;
  end;
end;

// Polaris

procedure TJvCustomDateEdit.SetDate(Value: TDateTime);
var
  d: TDateTime;
begin
  if not ValidDate(Value) or (Value = NullDate) then
  begin
    if DefaultToday then
      Value := SysUtils.Date
    else
      Value := NullDate;
  end;
  d := Self.Date;
  TestDateBetween(Value); // Polaris
  if Value = NullDate then
    Text := ''
  else
    Text := FormatDateTime(FDateFormat, Value);
  Modified := d <> Self.Date;
end;

procedure TJvCustomDateEdit.SetDateAutoBetween(Value: Boolean);
var
  d: TDateTime;
begin
  if Value <> FDateAutoBetween then
  begin
    FDateAutoBetween := Value;
    if Value then
    begin
      d := Date;
      TestDateBetween(d);
      if d <> Date then
        Date := d;
    end;
    Invalidate;
  end;
end;

procedure TJvCustomDateEdit.SetDialogTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TJvCustomDateEdit.SetMaxDate(Value: TDateTime);
begin
  if Value <> FMaxDate then
  begin
    //Check unacceptable MaxDate < MinDate
    if (Value <> NullDate) and (FMinDate <> NullDate) and (Value < FMinDate) then
      if FDateAutoBetween then
        SetMinDate(Value)
      else
        raise EJVCLException.CreateResFmt(@RsEDateMaxLimit, [DateToStr(FMinDate)]);
    FMaxDate := Value;
    UpdatePopup;
    if FDateAutoBetween then
      SetDate(Date);
  end;
end;

procedure TJvCustomDateEdit.SetMinDate(Value: TDateTime);
begin
  if Value <> FMinDate then
  begin
    //!!!!! Necessarily check

    // Check unacceptable MinDate > MaxDate [Translated]
    if (Value <> NullDate) and (FMaxDate <> NullDate) and (Value > FMaxDate) then
      if FDateAutoBetween then
        SetMaxDate(Value)
      else
        raise EJVCLException.CreateResFmt(@RsEDateMinLimit, [DateToStr(FMaxDate)]);
    FMinDate := Value;
    UpdatePopup;
    if FDateAutoBetween then
      SetDate(Date);
  end;
end;

procedure TJvCustomDateEdit.SetPopupColor(Value: TColor);
begin
  if Value <> PopupColor then
  begin
    if FPopup <> nil then
      TJvPopupWindow(FPopup).Color := Value;
    FPopupColor := Value;
  end;
end;

procedure TJvCustomDateEdit.SetPopupValue(const Value: Variant);
begin
  inherited SetPopupValue(StrToDateFmtDef(FDateFormat, VarToStr(Value),
    SysUtils.Date));
end;

procedure TJvCustomDateEdit.SetStartOfWeek(Value: TDayOfWeekName);
begin
  if Value <> FStartOfWeek then
  begin
    FStartOfWeek := Value;
    UpdatePopup;
  end;
end;

procedure TJvCustomDateEdit.SetWeekendColor(Value: TColor);
begin
  if Value <> FWeekendColor then
  begin
    FWeekendColor := Value;
    UpdatePopup;
  end;
end;

procedure TJvCustomDateEdit.SetWeekends(Value: TDaysOfWeek);
begin
  if Value <> FWeekends then
  begin
    FWeekends := Value;
    UpdatePopup;
  end;
end;

procedure TJvCustomDateEdit.SetYearDigits(Value: TYearDigits);
begin
  if FYearDigits <> Value then
  begin
    FYearDigits := Value;
    UpdateMask;
  end;
end;

function TJvCustomDateEdit.StoreMaxDate: Boolean;
begin
  Result := FMaxDate <> NullDate;
end;

function TJvCustomDateEdit.StoreMinDate: Boolean;
begin
  Result := FMinDate <> NullDate;
end;

procedure TJvCustomDateEdit.TestDateBetween(var Value: TDateTime);
begin
  if FDateAutoBetween then
  begin
    if (FMinDate <> NullDate) and (Value <> NullDate) and (Value < FMinDate) then
      Value := FMinDate;
    if (FMaxDate <> NullDate) and (Value <> NullDate) and (Value > FMaxDate) then
      Value := FMaxDate;
  end;
end;

function TJvCustomDateEdit.TextStored: Boolean;
begin
  Result := not IsEmptyStr(Text, [#0, ' ', DateSeparator, FBlanksChar]);
end;

procedure TJvCustomDateEdit.UpdateFormat;
begin
  FDateFormat := DefDateFormat(FourDigitYear);
end;

procedure TJvCustomDateEdit.UpdateMask;
var
  DateValue: TDateTime;
  OldFormat: string[10];
begin
  DateValue := GetDate;
  OldFormat := FDateFormat;
  UpdateFormat;
  if (GetDateMask <> EditMask) or (OldFormat <> FDateFormat) then
  begin
    { force update }
    EditMask := '';
    EditMask := GetDateMask;
  end;
  UpdatePopup;
  SetDate(DateValue);
end;

procedure TJvCustomDateEdit.UpdatePopup;
begin
  if FPopup <> nil then
    SetupPopupCalendar(FPopup, StartOfWeek,
      Weekends, WeekendColor, CalendarHints, FourDigitYear,
      MinDate, MaxDate); // Polaris
end;

procedure TJvCustomDateEdit.ValidateEdit;
begin
  if TextStored then
    CheckValidDate;
end;

{$IFDEF VCL}
procedure TJvCustomDateEdit.WMContextMenu(var Msg: TWMContextMenu);
begin
  if not PopupVisible then
    inherited;
end;
{$ENDIF VCL}

//=== TJvDateEdit ============================================================

// (rom) unusual not to have it implemented in the Custom base class

constructor TJvDateEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UpdateMask;
end;

procedure TJvDateEdit.SetDate(Value: TDateTime);
begin
  if not FDateAutoBetween then
    if Value <> NullDate then
    begin
      if ((FMinDate <> NullDate) and (FMaxDate <> NullDate) and
        ((Value < FMinDate) or (Value > FMaxDate))) then
        raise EJVCLException.CreateResFmt(@RsEDateOutOfRange, [FormatDateTime(FDateFormat, Value),
          FormatDateTime(FDateFormat, FMinDate), FormatDateTime(FDateFormat, FMaxDate)])
      else
      if (FMinDate <> NullDate) and (Value < FMinDate) then
        raise EJVCLException.CreateResFmt(@RsEDateOutOfMin, [FormatDateTime(FDateFormat, Value),
          FormatDateTime(FDateFormat, FMinDate)])
      else
      if (FMaxDate <> NullDate) and (Value > FMaxDate) then
        raise EJVCLException.CreateResFmt(@RsEDateOutOfMax, [FormatDateTime(FDateFormat, Value),
          FormatDateTime(FDateFormat, FMaxDate)]);
    end;
  inherited SetDate(Value);
end;

//=== TJvDirectoryEdit =======================================================

procedure TJvDirectoryEdit.ButtonClick;
var
  Temp: string;
  {$IFDEF VisualCLX}
  TempW: WideString;
  {$ENDIF VisualCLX}
  Action: Boolean;
begin
  inherited ButtonClick;
  Temp := Text;
  Action := True;
  DoBeforeDialog(Temp, Action);
  if not Action then
    Exit;
  if Temp = '' then
  begin
    if InitialDir <> '' then
      Temp := InitialDir
    else
      Temp := '\';
  end;
  if not DirectoryExists(Temp) then
    Temp := '\';
  DisableSysErrors;
  try
    {$IFDEF VCL}
    if NewStyleControls and (DialogKind = dkWin32) then
      Action := BrowseForFolder(FDialogText, True, Temp, Self.HelpContext)
        //BrowseDirectory(Temp, FDialogText, Self.HelpContext)
    else
      Action := SelectDirectory(Temp, FOptions, Self.HelpContext);
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    begin
      Action := SelectDirectory(FDialogText, Temp, TempW);
      Temp := TempW;
    end;
    {$ENDIF VisualCLX}
  finally
    EnableSysErrors;
  end;
  if CanFocus then
    SetFocus;
  DoAfterDialog(Temp, Action);
  if Action then
  begin
    SelText := '';
    if (Text = '') or not MultipleDirs then
      Text := Temp
    else
      Text := Text + ';' + Temp;
    if (Temp <> '') and DirectoryExists(Temp) then
      InitialDir := Temp;
  end;
end;

constructor TJvDirectoryEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF VCL}
  FOptions := [];
  FAutoCompleteOptions := [acoAutosuggestForceOn, acoFileSystem, acoFileSysDirs];
  {$ENDIF VCL}
end;

class function TJvDirectoryEdit.DefaultImageIndex: TImageIndex;
var
  Bmp: TBitmap;
begin
  {$IFDEF JVCLThemesEnabled}
  if ThemeServices.ThemesEnabled then
  begin
    if GDirImageIndexXP < 0 then
    begin
      Bmp := TBitmap.Create;
      try
        Bmp.LoadFromResourceName(HInstance, sDirXPBmp);
        GDirImageIndexXP := DefaultImages.AddMasked(Bmp, clFuchsia);
      finally
        Bmp.Free;
      end;
    end;
    Result := GDirImageIndexXP;
    Exit;
  end;
  {$ENDIF JVCLThemesEnabled}

  if GDirImageIndex < 0 then
  begin
    Bmp := TBitmap.Create;
    try
      Bmp.LoadFromResourceName(HInstance, sDirBmp);
      GDirImageIndex := DefaultImages.AddMasked(Bmp, clFuchsia);
    finally
      Bmp.Free;
    end;
  end;
  Result := GDirImageIndex;
end;

function TJvDirectoryEdit.GetLongName: string;
var
  Temp: string;
  Pos: Integer;
begin
  if not MultipleDirs then
    Result := ShortToLongPath(Text)
  else
  begin
    Result := '';
    Pos := 1;
    while Pos <= Length(Text) do
    begin
      Temp := ShortToLongPath(ExtractSubstr(Text, Pos, [';']));
      if (Result <> '') and (Temp <> '') then
        Result := Result + ';';
      Result := Result + Temp;
    end;
  end;
end;

function TJvDirectoryEdit.GetShortName: string;
var
  Temp: string;
  Pos: Integer;
begin
  if not MultipleDirs then
    Result := LongToShortPath(Text)
  else
  begin
    Result := '';
    Pos := 1;
    while Pos <= Length(Text) do
    begin
      Temp := LongToShortPath(ExtractSubstr(Text, Pos, [';']));
      if (Result <> '') and (Temp <> '') then
        Result := Result + ';';
      Result := Result + Temp;
    end;
  end;
end;

procedure TJvDirectoryEdit.ReceptFileDir(const AFileName: string);
var
  Temp: string;
begin
  if FileExists(AFileName) then
    Temp := ExtractFilePath(AFileName)
  else
    Temp := AFileName;
  if (Text = '') or not MultipleDirs then
    Text := Temp
  else
    Text := Text + ';' + Temp;
end;

//=== TJvEditButton ==========================================================

procedure TJvEditButton.Click;
begin
  if not FNoAction then
    inherited Click
  else
    FNoAction := False;
end;

constructor TJvEditButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStandard := True; // Polaris
  ControlStyle := ControlStyle + [csReplicatable];
  ParentShowHint := True;
end;

function TJvEditButton.GetGlyph: TBitmap;
begin
  Result := TJvxButtonGlyph(ButtonGlyph).Glyph;
end;

function TJvEditButton.GetNumGlyphs: TJvNumGlyphs;
begin
  Result := TJvxButtonGlyph(ButtonGlyph).NumGlyphs;
end;

function TJvEditButton.GetUseGlyph: Boolean;
begin
  Result := not Assigned(Images) or (ImageIndex < 0);
end;

procedure TJvEditButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and (Owner <> nil) then
    with TJvCustomComboEdit(Owner) do
    begin
      FNoAction := (FPopup <> nil) and FPopupVisible;
      if not FPopupVisible then
      begin
        if TabStop and CanFocus and (GetFocus <> Handle) then
          SetFocus;
      end
      else
        PopupCloseUp(FPopup, FStandard); // Polaris
    end;
end;

procedure TJvEditButton.Paint;
{$IFDEF JVCLThemesEnabled}
var
  ThemedState: TThemedComboBox;
  Details: TThemedElementDetails;
  R: TRect;
{$ENDIF JVCLThemesEnabled}
begin
  {$IFDEF JVCLThemesEnabled}
  if ThemeServices.ThemesEnabled then
  begin
    if FDrawThemedDropDownBtn then
    begin
      if not Enabled then
        ThemedState := tcDropDownButtonDisabled
      else
      if FState in [rbsDown, rbsExclusive] then
        ThemedState := tcDropDownButtonPressed
      else
      if MouseOver or IsDragging then
        ThemedState := tcDropDownButtonHot
      else
        ThemedState := tcDropDownButtonNormal;
      R := ClientRect;
      Details := ThemeServices.GetElementDetails(ThemedState);
      ThemeServices.DrawElement(Canvas.Handle, Details, R);
    end
    else
      inherited Paint;
  end
  else
  {$ENDIF JVCLThemesEnabled}
  begin
    inherited Paint;
    if FState <> rbsDown then
      with Canvas do
      begin
        if NewStyleControls then
          Pen.Color := clBtnFace
        else
          Pen.Color := clBtnShadow;
        MoveTo(0, 0);
        LineTo(0, Self.Height - 1);
        Pen.Color := clBtnHighlight;
        MoveTo(1, 1);
        LineTo(1, Self.Height - 2);
      end;
  end;
end;

procedure TJvEditButton.PaintImage(Canvas: TCanvas; ARect: TRect;
  const Offset: TPoint; AState: TJvButtonState; DrawMark: Boolean);
begin
  if UseGlyph then
    TJvxButtonGlyph(ButtonGlyph).Draw(Canvas, ARect, Offset, '', Layout,
      Margin, Spacing, False, AState, 0)
  else
    inherited PaintImage(Canvas, ARect, Offset, AState, DrawMark);
end;

procedure TJvEditButton.SetGlyph(const Value: TBitmap);
begin
  TJvxButtonGlyph(ButtonGlyph).Glyph := Value;
  Invalidate;
end;

procedure TJvEditButton.SetNumGlyphs(Value: TJvNumGlyphs);
begin
  if Value < 0 then
    Value := 1
  else
  if Value > Ord(High(TJvButtonState)) + 1 then
    Value := Ord(High(TJvButtonState)) + 1;
  if Value <> TJvxButtonGlyph(ButtonGlyph).NumGlyphs then
  begin
    TJvxButtonGlyph(ButtonGlyph).NumGlyphs := Value;
    Invalidate;
  end;
end;

{$IFDEF VCL}
procedure TJvEditButton.WMContextMenu(var Msg: TWMContextMenu);
begin
  { (rb) Without this, we get 2 context menu's (1 from the form, another from
         the combo edit; don't know exactly what is causing this. (I guess
         it's related to FBtnControl being a TWinControl) }
  Msg.Result := 1;
end;
{$ENDIF VCL}

//=== TJvFileDirEdit =========================================================

procedure TJvFileDirEdit.ClearFileList;
begin
end;

{$IFDEF JVCLThemesEnabled}
procedure TJvFileDirEdit.CMSysColorChange(var Msg: TMessage);
begin
  inherited;
  // We use this event to respond to theme changes (no WM_THEMECHANGED are broadcasted
  // to the components)
  // Note that there is a bug in TApplication.WndProc, so the application will not
  // change from non-themed to themed.
  if ImageKind = ikDefault then
    Button.ImageIndex := DefaultImageIndex;
end;
{$ENDIF JVCLThemesEnabled}

constructor TJvFileDirEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF VCL}
  OEMConvert := True;
  FAcceptFiles := True;
  FAutoComplete := True;
  {$ENDIF VCL}
  ControlState := ControlState + [csCreating];
  try
    ImageKind := ikDefault; { force update }
  finally
    ControlState := ControlState - [csCreating];
  end;
end;

{$IFDEF VCL}

procedure TJvFileDirEdit.CreateHandle;
begin
  inherited CreateHandle;

  if FAcceptFiles then
    SetDragAccept(True);
  if FAutoComplete then
    UpdateAutoComplete;
end;

procedure TJvFileDirEdit.DestroyWindowHandle;
begin
  SetDragAccept(False);
  inherited DestroyWindowHandle;
end;

{$ENDIF VCL}

procedure TJvFileDirEdit.DisableSysErrors;
begin
  {$IFDEF MSWINDOWS}
  FErrMode := SetErrorMode(SEM_NOOPENFILEERRORBOX or SEM_FAILCRITICALERRORS);
  {$ENDIF MSWINDOWS}
end;

procedure TJvFileDirEdit.DoAfterDialog(var FileName: string;
  var Action: Boolean);
begin
  if Assigned(FOnAfterDialog) then
    FOnAfterDialog(Self, FileName, Action);
end;

procedure TJvFileDirEdit.DoBeforeDialog(var FileName: string;
  var Action: Boolean);
begin
  if Assigned(FOnBeforeDialog) then
    FOnBeforeDialog(Self, FileName, Action);
end;

procedure TJvFileDirEdit.EnableSysErrors;
begin
  {$IFDEF MSWINDOWS}
  SetErrorMode(FErrMode);
  {$ENDIF MSWINDOWS}
  FErrMode := 0;
end;

{$IFDEF VCL}

procedure TJvFileDirEdit.SetAcceptFiles(Value: Boolean);
begin
  if FAcceptFiles <> Value then
  begin
    SetDragAccept(Value);
    FAcceptFiles := Value;
  end;
end;

procedure TJvFileDirEdit.SetAutoComplete(Value: Boolean);
begin
  if Value <> FAutoComplete then
  begin
    FAutoComplete := Value;
    if HandleAllocated and not (csDesigning in ComponentState) then
      if AutoComplete then
        UpdateAutoComplete
      else
        RecreateWnd;
  end;
end;

procedure TJvFileDirEdit.SetAutoCompleteOptions(
  const Value: TJvAutoCompleteOptions);
const
  cListFillMethods = [acoFileSystem, acoFileSysDirs, acoURLAll, acoURLHistory, acoURLMRU];
  cOptions = [acoAutoappendForceOff, acoAutoappendForceOn, acoAutosuggestForceOff,
    acoAutosuggestForceOn, acoUseTab];
var
  AddedOptions, RemovedOptions: TJvAutoCompleteOptions;
begin
  if FAutoCompleteOptions <> Value then
  begin
    AddedOptions := Value - (FAutoCompleteOptions * Value);
    RemovedOptions := FAutoCompleteOptions - (FAutoCompleteOptions * Value);

    FAutoCompleteOptions := Value;

    { Force correct options }
    if acoAutoappendForceOff in AddedOptions then
      Exclude(FAutoCompleteOptions, acoAutoappendForceOn)
    else
    if acoAutoappendForceOn in AddedOptions then
      Exclude(FAutoCompleteOptions, acoAutoappendForceOff);
    if acoAutosuggestForceOff in AddedOptions then
      Exclude(FAutoCompleteOptions, acoAutosuggestForceOn)
    else
    if acoAutosuggestForceOn in AddedOptions then
      Exclude(FAutoCompleteOptions, acoAutosuggestForceOff);
    if acoDefault in AddedOptions then
      FAutoCompleteOptions := [acoDefault]
    else
    if AddedOptions <> [] then
      Exclude(FAutoCompleteOptions, acoDefault);
    if (cListFillMethods * FAutoCompleteOptions = []) and
       (cListFillMethods * RemovedOptions <> []) then
       FAutoCompleteOptions := FAutoCompleteOptions - cOptions;

    { Last check }
    if (cOptions * FAutoCompleteOptions <> []) and
       (cListFillMethods * FAutoCompleteOptions = []) then
      FAutoCompleteOptions := FAutoCompleteOptions + [acoFileSystem];

    if HandleAllocated and AutoComplete and not (csDesigning in ComponentState) then
      RecreateWnd;
  end;
end;

procedure TJvFileDirEdit.SetDragAccept(Value: Boolean);
begin
  if not (csDesigning in ComponentState) and (Handle <> 0) then
    DragAcceptFiles(Handle, Value);
end;

procedure TJvFileDirEdit.UpdateAutoComplete;
const
  cAutoCompleteOptionValues: array [TJvAutoCompleteOption] of DWORD =
    (SHACF_AUTOAPPEND_FORCE_OFF, SHACF_AUTOAPPEND_FORCE_ON,
     SHACF_AUTOSUGGEST_FORCE_OFF, SHACF_AUTOSUGGEST_FORCE_ON, SHACF_DEFAULT, SHACF_FILESYSTEM,
     SHACF_FILESYS_DIRS, SHACF_URLALL, SHACF_URLHISTORY, SHACF_URLMRU, SHACF_USETAB);
var
  Flags: DWORD;
  AutoCompleteOption: TJvAutoCompleteOption;
begin
  if HandleAllocated and AutoComplete and not (csDesigning in ComponentState) then
  begin
    LoadShlwapiDll;

    if Assigned(SHAutoComplete) then
    begin
      Flags := 0;
      for AutoCompleteOption := Low(TJvAutoCompleteOption) to High(TJvAutoCompleteOption) do
        if AutoCompleteOption in AutoCompleteOptions then
          Inc(Flags, cAutoCompleteOptionValues[AutoCompleteOption]);

      SHAutoComplete(Handle, Flags);
    end;
  end;
end;

procedure TJvFileDirEdit.WMDropFiles(var Msg: TWMDropFiles);
var
  AFileName: array [0..255] of Char;
  I, Num: Cardinal;
begin
  Msg.Result := 0;
  try
    Num := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);
    if Num > 0 then
    begin
      ClearFileList;
      for I := 0 to Num - 1 do
      begin
        DragQueryFile(Msg.Drop, I, PChar(@AFileName), Pred(SizeOf(AFileName)));
        ReceptFileDir(StrPas(AFileName));
        if not FMultipleDirs then
          Break;
      end;
      if Assigned(FOnDropFiles) then
        FOnDropFiles(Self);
    end;
  finally
    DragFinish(Msg.Drop);
  end;
end;

{$ENDIF VCL}

//=== TJvFilenameEdit ========================================================

procedure TJvFilenameEdit.ButtonClick;
var
  Temp: string;
  Action: Boolean;
begin
  inherited ButtonClick;
  Temp := inherited Text;
  Action := True;
  Temp := ClipFilename(Temp);
  DoBeforeDialog(Temp, Action);
  if not Action then
    Exit;
  if ValidFileName(Temp) then
  try
    if DirectoryExists(ExtractFilePath(Temp)) then
      SetInitialDir(ExtractFilePath(Temp));
    if (ExtractFileName(Temp) = '') or
      not ValidFileName(ExtractFileName(Temp)) then
      Temp := '';
    FDialog.FileName := Temp;
  except
    { ignore any exceptions }
  end;
  FDialog.HelpContext := Self.HelpContext;
  DisableSysErrors;
  try
    Action := FDialog.Execute;
  finally
    EnableSysErrors;
  end;
  if Action then
    Temp := FDialog.FileName;
  if CanFocus then
    SetFocus;
  DoAfterDialog(Temp, Action);
  if Action then
  begin
    if AddQuotes then
      inherited Text := ExtFilename(Temp)
    else
      inherited Text := Temp;
    SetInitialDir(ExtractFilePath(FDialog.FileName));
  end;
end;

procedure TJvFilenameEdit.ClearFileList;
begin
  FDialog.Files.Clear;
end;

constructor TJvFilenameEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAddQuotes := True;
  {$IFDEF VCL}
  FAutoCompleteOptions := [acoAutosuggestForceOn, acoFileSystem];
  {$ENDIF VCL}
  CreateEditDialog;
end;

procedure TJvFilenameEdit.CreateEditDialog;
var
  NewDialog: TOpenDialog;
begin
  case FDialogKind of
    dkOpen:
      NewDialog := TOpenDialog.Create(Self);
    dkOpenPicture:
      NewDialog := TOpenPictureDialog.Create(Self);
    dkSavePicture:
      NewDialog := TSavePictureDialog.Create(Self);
  else { dkSave }
    NewDialog := TSaveDialog.Create(Self);
  end;
  try
    if FDialog <> nil then
    begin
      with NewDialog do
      begin
        DefaultExt := FDialog.DefaultExt;
        {$IFDEF VCL}
        FileEditStyle := FDialog.FileEditStyle;
        {$ENDIF VCL}
        FileName := FDialog.FileName;
        Filter := FDialog.Filter;
        FilterIndex := FDialog.FilterIndex;
        InitialDir := FDialog.InitialDir;
        HistoryList := FDialog.HistoryList;
        Files.Assign(FDialog.Files);
        Options := FDialog.Options;
        Title := FDialog.Title;
      end;
      FDialog.Free;
    end
    else
    begin
      NewDialog.Title := RsBrowseCaption;
      NewDialog.Filter := RsDefaultFilter;
      NewDialog.Options := [ofHideReadOnly];
    end;
  finally
    FDialog := NewDialog;
  end;
end;

class function TJvFilenameEdit.DefaultImageIndex: TImageIndex;
var
  Bmp: TBitmap;
begin
  {$IFDEF JVCLThemesEnabled}
  if ThemeServices.ThemesEnabled then
  begin
    if GFileImageIndexXP < 0 then
    begin
      Bmp := TBitmap.Create;
      try
        Bmp.LoadFromResourceName(HInstance, sFileXPBmp);
        GFileImageIndexXP := DefaultImages.AddMasked(Bmp, clFuchsia);
      finally
        Bmp.Free;
      end;
    end;
    Result := GFileImageIndexXP;
    Exit;
  end;
  {$ENDIF JVCLThemesEnabled}

  if GFileImageIndex < 0 then
  begin
    Bmp := TBitmap.Create;
    try
      Bmp.LoadFromResourceName(HInstance, sFileBmp);
      GFileImageIndex := DefaultImages.AddMasked(Bmp, clFuchsia);
    finally
      Bmp.Free;
    end;
  end;
  Result := GFileImageIndex;
end;

function TJvFilenameEdit.GetDefaultExt: TFileExt;
begin
  Result := FDialog.DefaultExt;
end;

function TJvFilenameEdit.GetDialogFiles: TStrings;
begin
  Result := FDialog.Files;
end;

function TJvFilenameEdit.GetDialogTitle: string;
begin
  Result := FDialog.Title;
end;

{$IFDEF VCL}
function TJvFilenameEdit.GetFileEditStyle: TFileEditStyle;
begin
  Result := FDialog.FileEditStyle;
end;
{$ENDIF VCL}

function TJvFilenameEdit.GetFileName: TFileName;
begin
  if AddQuotes then
    Result := ClipFilename(inherited Text)
  else
    Result := inherited Text;
end;

function TJvFilenameEdit.GetFilter: string;
begin
  Result := FDialog.Filter;
end;

function TJvFilenameEdit.GetFilterIndex: Integer;
begin
  Result := FDialog.FilterIndex;
end;

function TJvFilenameEdit.GetHistoryList: TStrings;
begin
  Result := FDialog.HistoryList;
end;

function TJvFilenameEdit.GetInitialDir: string;
begin
  Result := FDialog.InitialDir;
end;

function TJvFilenameEdit.GetLongName: string;
begin
  Result := ShortToLongFileName(FileName);
end;

function TJvFilenameEdit.GetOptions: TOpenOptions;
begin
  Result := FDialog.Options;
end;

function TJvFilenameEdit.GetShortName: string;
begin
  Result := LongToShortFileName(FileName);
end;

function TJvFilenameEdit.IsCustomFilter: Boolean;
begin
  Result := CompareStr(RsDefaultFilter, FDialog.Filter) <> 0;
end;

function TJvFilenameEdit.IsCustomTitle: Boolean;
begin
  Result := CompareStr(RsBrowseCaption, FDialog.Title) <> 0;
end;

procedure TJvFilenameEdit.ReceptFileDir(const AFileName: string);
begin
  if FMultipleDirs then
  begin
    if FDialog.Files.Count = 0 then
      SetFileName(AFileName);
    FDialog.Files.Add(AFileName);
  end
  else
    SetFileName(AFileName);
end;

procedure TJvFilenameEdit.SetDefaultExt(Value: TFileExt);
begin
  FDialog.DefaultExt := Value;
end;

procedure TJvFilenameEdit.SetDialogKind(Value: TFileDialogKind);
begin
  if FDialogKind <> Value then
  begin
    FDialogKind := Value;
    CreateEditDialog;
  end;
end;

procedure TJvFilenameEdit.SetDialogTitle(const Value: string);
begin
  FDialog.Title := Value;
end;

{$IFDEF VCL}
procedure TJvFilenameEdit.SetFileEditStyle(Value: TFileEditStyle);
begin
  FDialog.FileEditStyle := Value;
end;
{$ENDIF VCL}

procedure TJvFilenameEdit.SetFileName(const Value: TFileName);
begin
  if (Value = '') or ValidFileName(ClipFilename(Value)) then
  begin
    if AddQuotes then
      inherited Text := ExtFilename(Value)
    else
      inherited Text := Value;
    ClearFileList;
  end
  else
    raise EComboEditError.CreateResFmt(@SInvalidFilename, [Value]);
end;

procedure TJvFilenameEdit.SetFilter(const Value: string);
begin
  FDialog.Filter := Value;
end;

procedure TJvFilenameEdit.SetFilterIndex(Value: Integer);
begin
  FDialog.FilterIndex := Value;
end;

procedure TJvFilenameEdit.SetHistoryList(Value: TStrings);
begin
  FDialog.HistoryList := Value;
end;

procedure TJvFilenameEdit.SetInitialDir(const Value: string);
begin
  FDialog.InitialDir := Value;
end;

procedure TJvFilenameEdit.SetOptions(Value: TOpenOptions);
begin
  if Value <> FDialog.Options then
  begin
    FDialog.Options := Value;
    FMultipleDirs := ofAllowMultiSelect in FDialog.Options;
    if not FMultipleDirs then
      ClearFileList;
  end;
end;

//=== TJvPopupWindow =========================================================

procedure TJvPopupWindow.CloseUp(Accept: Boolean);
begin
  if Assigned(FCloseUp) then
    FCloseUp(Self, Accept);
end;

constructor TJvPopupWindow.Create(AOwner: TComponent);
begin
  // (p3) have to use CreateNew for VCL as well since there is no dfm
  inherited CreateNew(AOwner);
  FEditor := TWinControl(AOwner);
  ControlStyle := ControlStyle + [csNoDesignVisible, csReplicatable, csAcceptsControls];
  Visible := False;
  {$IFDEF VCL}
  Ctl3D := False;
  ParentCtl3D := False;
  Parent := FEditor;
  // use same size on small and large font:
  Scaled := False;
  {$ENDIF VCL}
end;

{$IFDEF VCL}
procedure TJvPopupWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP or WS_BORDER or WS_CLIPCHILDREN;
    ExStyle := WS_EX_TOOLWINDOW;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
  end;
end;
{$ENDIF VCL}

function TJvPopupWindow.GetPopupText: string;
begin
  Result := '';
end;

procedure TJvPopupWindow.Hide;
begin
  {$IFDEF VCL}
  SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
  {$ENDIF VCL}
  Visible := False;
end;

procedure TJvPopupWindow.InvalidateEditor;
var
  R: TRect;
begin
  if FEditor is TJvCustomComboEdit then
    with TJvCustomComboEdit(FEditor) do
      SetRect(R, 0, 0, ClientWidth - FBtnControl.Width {Polaris - 2}, ClientHeight + 1)
  else
    R := FEditor.ClientRect;
  {$IFDEF VCL}
  InvalidateRect(FEditor.Handle, @R, False);
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  FEditor.InvalidateRect(R, False);
  {$ENDIF VisualCLX}
  UpdateWindow(FEditor.Handle);
end;

procedure TJvPopupWindow.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button = mbLeft then
    CloseUp(PtInRect(ClientRect, Point(X, Y)));
end;

{$IFDEF VisualCLX}
procedure TJvPopupWindow.SetParent(const Value: TWidgetControl);
var
  Pt: TPoint;
  R: TRect;
begin
  Pt := Point(Left, Top);
  R := BoundsRect;
  inherited SetParent(Value);
  if not (csDestroying in ComponentState) then
  begin
    QWidget_reparent(Handle, nil, 0, @Pt, Showing);
    BoundsRect := R;
  end;
end;
{$ENDIF VisualCLX}

procedure TJvPopupWindow.Show(Origin: TPoint);
{$IFDEF VCL}
var
  Monitor: TMonitor;
{$ENDIF VCL}
begin
  {$IFDEF VCL}
  if GetParentForm(Self) = nil then
  begin
    if Screen.ActiveCustomForm <> nil then
      Monitor := Screen.ActiveCustomForm.Monitor
    else
      Monitor := Application.MainForm.Monitor;
    Inc(Origin.X, Monitor.Left);
    Inc(Origin.Y, Monitor.Top);
  end;
  SetWindowPos(Handle, HWND_TOP, Origin.X, Origin.Y, 0, 0,
    SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  Left := Origin.X;
  Top := Origin.Y;
  {$ENDIF VisualCLX}
  Visible := True;
end;

{$IFDEF VisualCLX}
function TJvPopupWindow.WidgetFlags: Integer;
begin
  Result := Integer(WidgetFlags_WType_Popup) or // WS_POPUP
    Integer(WidgetFlags_WStyle_NormalBorder) or // WS_BORDER
    Integer(WidgetFlags_WStyle_Tool);  // WS_EX_TOOLWINDOW
end;
{$ENDIF VisualCLX}

{$IFDEF VCL}
procedure TJvPopupWindow.WMMouseActivate(var Msg: TMessage);
begin
  Msg.Result := MA_NOACTIVATE;
end;
{$ENDIF VCL}

initialization

finalization
  FinalizeUnit(sUnitName);
end.
