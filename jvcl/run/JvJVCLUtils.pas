{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvJVCLUtils.PAS, released on 2002-09-24.

The Initial Developers of the Original Code are: Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 1997, 1998 Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 2001,2002 SGB Software
All Rights Reserved.

Last Modified: 2003-10-25

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvJVCLUtils;

interface

uses
  {$IFDEF COMPILER6_UP}
  RTLConsts, Variants,
  {$ENDIF COMPILER6_UP}
  {$IFDEF MSWINDOWS}
  Windows, Messages, ShellAPI, Registry,
  {$ENDIF MSWINDOWS}
  {$IFDEF LINUX}
  JvLinux,
  {$ENDIF LINUX}
  SysUtils, Classes,
  JvClxUtils,
  {$IFDEF VCL}
  Forms, Graphics, Controls, StdCtrls, ExtCtrls, Menus, Dialogs,
  ComCtrls, ImgList, Grids,
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  Qt, QTypes, Types, QForms, QGraphics, QControls, QStdCtrls, QExtCtrls, QMenus,
  QDialogs, QComCtrls, QImgList, QGrids, QWinCursors,
  {$ENDIF VisualCLX}
  IniFiles,
  JclBase, JclSysUtils, JclStrings, JvJCLUtils,
  JvAppStore, JvTypes;

{$IFDEF VCL}
// Transform an icon to a bitmap
function IconToBitmap(Ico: HICON): TBitmap;
// Transform an icon to a bitmap using an image list
function IconToBitmap2(Ico: HICON; Size: Integer = 32;
  TransparentColor: TColor = clNone): TBitmap;
function IconToBitmap3(Ico: HICON; Size: Integer = 32;
  TransparentColor: TColor = clNone): TBitmap;
{$ENDIF VCL}

// bitmap manipulation functions
// NOTE: returned bitmap must be freed by caller!
// get red channel bitmap
function GetRBitmap(Value: TBitmap): TBitmap;
// get green channel bitmap
function GetGBitmap(Value: TBitmap): TBitmap;
// get blue channel bitmap
function GetBBitmap(Value: TBitmap): TBitmap;
// get monochrome bitmap
function GetMonochromeBitmap(Value: TBitmap): TBitmap;
// get hue bitmap (h part of hsv)
function GetHueBitmap(Value: TBitmap): TBitmap;
// get saturation bitmap (s part of hsv)
function GetSaturationBitmap(Value: TBitmap): TBitmap;
// get value bbitmap (v part of hsv)
function GetValueBitmap(Value: TBitmap): TBitmap;

{$IFDEF MSWINDOWS}
// hides / shows the a forms caption area
procedure HideFormCaption(FormHandle: HWND; Hide: Boolean);

type
  TJvWallpaperStyle = (wpTile, wpCenter, wpStretch);

  // set the background wallpaper (two versions)
procedure SetWallpaper(const Path: string); overload;
procedure SetWallpaper(const Path: string; Style: TJvWallpaperStyle); overload;

{$IFDEF VCL}
// screen capture functions
function CaptureScreen(IncludeTaskBar: Boolean = True): TBitmap; overload;
function CaptureScreen(Rec: TRect): TBitmap; overload;
function CaptureScreen(WndHandle: Longword): TBitmap; overload;
{$ENDIF VCL}

{$ENDIF MSWINDOWS}
//Convert RGB Values to HSV
procedure RGBToHSV(r, g, b: Integer; var h, s, v: Integer);

{ from JvVCLUtils }

{$IFDEF VCL}
{ Windows resources (bitmaps and icons) VCL-oriented routines }
procedure DrawBitmapTransparent(Dest: TCanvas; DstX, DstY: Integer;
  Bitmap: TBitmap; TransparentColor: TColor);
procedure DrawBitmapRectTransparent(Dest: TCanvas; DstX, DstY: Integer;
  SrcRect: TRect; Bitmap: TBitmap; TransparentColor: TColor);
procedure StretchBitmapRectTransparent(Dest: TCanvas; DstX, DstY, DstW,
  DstH: Integer; SrcRect: TRect; Bitmap: TBitmap; TransparentColor: TColor);
function MakeBitmap(ResID: PChar): TBitmap;
function MakeBitmapID(ResID: Word): TBitmap;
function MakeModuleBitmap(Module: THandle; ResID: PChar): TBitmap;
procedure CopyParentImage(Control: TControl; Dest: TCanvas);
function CreateTwoColorsBrushPattern(Color1, Color2: TColor): TBitmap;
function CreateDisabledBitmap_NewStyle(FOriginal: TBitmap; BackColor: TColor):
  TBitmap;
function CreateDisabledBitmapEx(FOriginal: TBitmap; OutlineColor, BackColor,
  HighLightColor, ShadowColor: TColor; DrawHighlight: Boolean): TBitmap;
function CreateDisabledBitmap(FOriginal: TBitmap; OutlineColor: TColor):
  TBitmap;
function ChangeBitmapColor(Bitmap: TBitmap; Color, NewColor: TColor): TBitmap;
procedure AssignBitmapCell(Source: TGraphic; Dest: TBitmap; Cols, Rows,
  Index: Integer);
procedure ImageListDrawDisabled(Images: TCustomImageList; Canvas: TCanvas;
  X, Y, Index: Integer; HighLightColor, GrayColor: TColor; DrawHighlight:
    Boolean);
{$ENDIF VCL}

function MakeIcon(ResID: PChar): TIcon;
function MakeIconID(ResID: Word): TIcon;
function MakeModuleIcon(Module: THandle; ResID: PChar): TIcon;
function CreateBitmapFromIcon(Icon: TIcon; BackColor: TColor): TBitmap;
function CreateIconFromBitmap(Bitmap: TBitmap; TransparentColor: TColor): TIcon;
{$IFDEF VCL}
function CreateRotatedFont(Font: TFont; Angle: Integer): HFONT;
{$ENDIF VCL}

{ Execute executes other program and waiting for it
  terminating, then return its Exit Code }
function Execute(const CommandLine, WorkingDirectory: string): Integer;

// launches the specified CPL file
// format: <Filename> [,@n] or [,,m] or [,@n,m]
// where @n = zero-based index of the applet to start (if there is more than one
// m is the zero-based index of the tab to display
{$IFDEF VCL}
procedure LaunchCpl(FileName: string);

{
  GetControlPanelApplets retrieves information about all control panel applets in a specified folder.
  APath is the Path to the folder to search and AMask is the filename mask (containing wildcards if necessary) to use.

  The information is returned in the Strings and Images lists according to the following rules:
   The Display Name and Path to the CPL file is returned in Strings with the following format:
     '<displayname>=<Path>'
   You can access the DisplayName by using the Strings.Names array and the Path by accessing the Strings.Values array
   Strings.Objects can contain either of two values depending on if Images is nil or not:
     * If Images is nil then Strings.Objects contains the image for the applet as a TBitmap. Note that the caller (you)
     is responsible for freeing the bitmaps in this case
     * If Images <> nil, then the Strings.Objects array contains the index of the image in the Images array for the selected item.
       To access and use the ImageIndex, typecast Strings.Objects to an int:
         Tmp.Name := Strings.Name[I];
         Tmp.ImageIndex := Integer(Strings.Objects[I]);
  The function returns True if any Control Panel Applets were found (i.e Strings.Count is > 0 when returning)
}

function GetControlPanelApplets(const APath, AMask: string; Strings: TStrings;
  Images: TCustomImageList = nil): Boolean;
{ GetControlPanelApplet works like GetControlPanelApplets, with the difference that it only loads and searches one cpl file (according to AFilename).
  Note though, that some CPL's contains multiple applets, so the Strings and Images lists can contain multiple return values.
  The function returns True if any Control Panel Applets were found in AFilename (i.e if items were added to Strings)
}
function GetControlPanelApplet(const AFileName: string; Strings: TStrings;
  Images: TCustomImageList = nil): Boolean;
{$ENDIF VCL}

{$IFDEF MSWINDOWS}
function PointInPolyRgn(const P: TPoint; const Points: array of TPoint):
  Boolean;
function PaletteColor(Color: TColor): Longint;
procedure PaintInverseRect(const RectOrg, RectEnd: TPoint);
procedure DrawInvertFrame(ScreenRect: TRect; Width: Integer);
procedure ShowMDIClientEdge(ClientHandle: THandle; ShowEdge: Boolean);
{$ENDIF MSWINDOWS}
procedure Delay(MSecs: Longint);
procedure CenterControl(Control: TControl);

{$IFDEF LINUX}
const
  { MessageBox() Flags }
  MB_OK = $00000000;
  MB_OKCANCEL = $00000001;
  MB_ABORTRETRYIGNORE = $00000002;
  MB_YESNOCANCEL = $00000003;
  MB_YESNO = $00000004;
  MB_RETRYCANCEL = $00000005;

  MB_ICONHAND = $00000010;
  MB_ICONQUESTION = $00000020;
  MB_ICONEXCLAMATION = $00000030;
  MB_ICONASTERISK = $00000040;
  MB_USERICON = $00000080;
  MB_ICONWARNING = MB_ICONEXCLAMATION;
  MB_ICONERROR = MB_ICONHAND;
  MB_ICONINFORMATION = MB_ICONASTERISK;
  MB_ICONSTOP = MB_ICONHAND;

  MB_DEFBUTTON1 = $00000000;
  MB_DEFBUTTON2 = $00000100;
  MB_DEFBUTTON3 = $00000200;
  MB_DEFBUTTON4 = $00000300;

  MB_HELP = $00004000; { Help Button }

  IDOK = 1;
  ID_OK = IDOK;
  IDCANCEL = 2;
  ID_CANCEL = IDCANCEL;
  IDABORT = 3;
  ID_ABORT = IDABORT;
  IDRETRY = 4;
  ID_RETRY = IDRETRY;
  IDIGNORE = 5;
  ID_IGNORE = IDIGNORE;
  IDYES = 6;
  ID_YES = IDYES;
  IDNO = 7;
  ID_NO = IDNO;
  IDCLOSE = 8;
  ID_CLOSE = IDCLOSE;
  IDHELP = 9;
  ID_HELP = IDHELP;
  IDTRYAGAIN = 10;
  IDCONTINUE = 11;
{$ENDIF LINUX}

function MsgBox(const Caption, Text: string; Flags: Integer): Integer;
function MsgDlg(const Msg: string; AType: TMsgDlgType;
  AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;

procedure MergeForm(AControl: TWinControl; AForm: TForm; Align: TAlign;
  Show: Boolean);
function GetAveCharSize(Canvas: TCanvas): TPoint;

{ Gradient filling routine }

type
  TFillDirection = (fdTopToBottom, fdBottomToTop, fdLeftToRight, fdRightToLeft);

procedure GradientFillRect(Canvas: TCanvas; ARect: TRect; StartColor,
  EndColor: TColor; Direction: TFillDirection; Colors: byte);

procedure StartWait;
procedure StopWait;
function DefineCursor(Instance: THandle; ResID: PChar): TCursor;
function GetNextFreeCursorIndex(StartHint: Integer; PreDefined: Boolean):
  Integer;
function WaitCursor: IInterface;
function ScreenCursor(ACursor: TCursor): IInterface;
// loads the more modern looking drag cursors from OLE32.DLL
function LoadOLEDragCursors: Boolean;

{$IFDEF VCL}
function LoadAniCursor(Instance: THandle; ResID: PChar): HCURSOR;

{ Windows API level routines }

procedure StretchBltTransparent(DstDC: HDC; DstX, DstY, DstW, DstH: Integer;
  SrcDC: HDC; SrcX, SrcY, SrcW, Srch: Integer; Palette: HPALETTE;
  TransparentColor: TColorRef);
procedure DrawTransparentBitmap(DC: HDC; Bitmap: HBITMAP;
  DstX, DstY: Integer; TransparentColor: TColorRef);
function PaletteEntries(Palette: HPALETTE): Integer;
procedure ShadeRect(DC: HDC; const Rect: TRect);
{$ENDIF VCL}
function ScreenWorkArea: TRect;

{ Grid drawing }

type
  TVertAlignment = (vaTopJustify, vaCenter, vaBottomJustify);

procedure WriteText(ACanvas: TCanvas; ARect: TRect; DX, DY: Integer;
  const Text: string; Alignment: TAlignment; WordWrap: Boolean; ARightToLeft:
    Boolean = False);
procedure DrawCellText(Control: TCustomControl; ACol, ARow: Longint;
  const s: string; const ARect: TRect; Align: TAlignment;
  VertAlign: TVertAlignment); overload;
procedure DrawCellTextEx(Control: TCustomControl; ACol, ARow: Longint;
  const s: string; const ARect: TRect; Align: TAlignment;
  VertAlign: TVertAlignment; WordWrap: Boolean); overload;
procedure DrawCellText(Control: TCustomControl; ACol, ARow: Longint;
  const s: string; const ARect: TRect; Align: TAlignment;
  VertAlign: TVertAlignment; ARightToLeft: Boolean); overload;
procedure DrawCellTextEx(Control: TCustomControl; ACol, ARow: Longint;
  const s: string; const ARect: TRect; Align: TAlignment;
  VertAlign: TVertAlignment; WordWrap: Boolean; ARightToLeft: Boolean);
    overload;
procedure DrawCellBitmap(Control: TCustomControl; ACol, ARow: Longint;
  Bmp: TGraphic; Rect: TRect);

{$IFDEF VCL}
type
  TJvScreenCanvas = class(TCanvas)
  private
    FDeviceContext: HDC;
  protected
    procedure CreateHandle; override;
  public
    destructor Destroy; override;
    procedure SetOrigin(X, Y: Integer);
    procedure FreeHandle;
  end;
{$ENDIF VCL}

  { end from JvVCLUtils }

  { begin JvUtils }
  {**** other routines - }
  { FindByTag returns the control with specified class,
    ComponentClass, from WinContol.Controls property,
    having Tag property value, equaled to Tag parameter }
function FindByTag(WinControl: TWinControl; ComponentClass: TComponentClass;
  const Tag: Integer): TComponent;
{ ControlAtPos2 equal to TWinControl.ControlAtPos function,
  but works better }
function ControlAtPos2(Parent: TWinControl; X, Y: Integer): TControl;
{ RBTag searches WinControl.Controls for checked
  RadioButton and returns its Tag property value }
function RBTag(Parent: TWinControl): Integer;
{ FindFormByClass returns first form with specified
  class, FormClass, owned by Application global variable }
function FindFormByClass(FormClass: TFormClass): TForm;
function FindFormByClassName(FormClassName: string): TForm;
{ AppMinimized returns True, if Application is minimized }
function AppMinimized: Boolean;
{$IFDEF VCL}
{ MessageBox is Application.MessageBox with string (not PChar) parameters.
  if Caption parameter = '', it replaced with Application.Title }
function MessageBox(const Msg: string; Caption: string;
  const Flags: Integer): Integer;
function MsgDlg2(const Msg, ACaption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpContext: Integer; Control: TWinControl): Integer;
function MsgDlgDef(const Msg, ACaption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; DefButton: TMsgDlgBtn; HelpContext: Integer;
  Control: TWinControl): Integer;
{**** Windows routines }

{ LoadIcoToImage loads two icons from resource named NameRes,
  into two image lists ALarge and ASmall}
procedure LoadIcoToImage(ALarge, ASmall: TCustomImageList; const NameRes:
  string);
{$ENDIF VCL}

{ returns the sum of pc.Left, pc.Width and piSpace}
function ToRightOf(const pc: TControl; piSpace: Integer = 0): Integer;
{ sets the top of pc to be in the middle of pcParent }
procedure CenterHeight(const pc, pcParent: TControl);
procedure CenterHor(Parent: TControl; MinLeft: Integer; Controls: array of
  TControl);
procedure EnableControls(Control: TWinControl; const Enable: Boolean);
procedure EnableMenuItems(MenuItem: TMenuItem; const Tag: Integer; const Enable:
  Boolean);
procedure ExpandWidth(Parent: TControl; MinWidth: Integer; Controls: array of
  TControl);
function PanelBorder(Panel: TCustomPanel): Integer;
function Pixels(Control: TControl; APixels: Integer): Integer;

type
  TMenuAnimation = (maNone, maRandom, maUnfold, maSlide);

procedure ShowMenu(Form: TForm; MenuAni: TMenuAnimation);

{$IFDEF MSWINDOWS}
{ TargetFileName - if FileName is ShortCut returns filename ShortCut linked to }
function TargetFileName(const FileName: TFileName): TFileName;
{ return filename ShortCut linked to }
function ResolveLink(const HWND: HWND; const LinkFile: TFileName;
  var FileName: TFileName): HRESULT;

type
  TProcObj = procedure of object;

procedure ExecAfterPause(Proc: TProcObj; Pause: Integer);
{$ENDIF MSWINDOWS}

{ end JvUtils }

{ begin JvAppUtils}
function GetDefaultSection(Component: TComponent): string;
function GetDefaultIniName: string;

type
  TOnGetDefaultIniName = function: string;

const
  OnGetDefaultIniName: TOnGetDefaultIniName = nil;

var
  DefCompanyName: string = '';
  RegUseAppTitle: Boolean = False;

function GetDefaultIniRegKey: string;
function FindForm(FormClass: TFormClass): TForm;
function FindShowForm(FormClass: TFormClass; const Caption: string): TForm;
function ShowDialog(FormClass: TFormClass): Boolean;
function InstantiateForm(FormClass: TFormClass; var Reference): TForm;

procedure SaveFormPlacement(Form: TForm; const AppStore: TJvCustomAppStore;
  SaveState: Boolean = True; SavePosition: Boolean = True);
procedure RestoreFormPlacement(Form: TForm; const AppStore: TJvCustomAppStore;
  LoadState: Boolean = True; LoadPosition: Boolean = True);

procedure SaveMDIChildren(MainForm: TForm; const AppStore: TJvCustomAppStore);
procedure RestoreMDIChildren(MainForm: TForm; const AppStore:
  TJvCustomAppStore);
procedure RestoreGridLayout(Grid: TCustomGrid; const AppStore:
  TJvCustomAppStore);
procedure SaveGridLayout(Grid: TCustomGrid; const AppStore: TJvCustomAppStore);

function StrToIniStr(const Str: string): string;
function IniStrToStr(const Str: string): string;

function IniReadString(IniFile: TObject; const Section, Ident,
  Default: string): string;
procedure IniWriteString(IniFile: TObject; const Section, Ident,
  Value: string);
function IniReadInteger(IniFile: TObject; const Section, Ident: string;
  Default: Longint): Longint;
procedure IniWriteInteger(IniFile: TObject; const Section, Ident: string;
  Value: Longint);
function IniReadBool(IniFile: TObject; const Section, Ident: string;
  Default: Boolean): Boolean;
procedure IniWriteBool(IniFile: TObject; const Section, Ident: string;
  Value: Boolean);
procedure IniReadSections(IniFile: TObject; Strings: TStrings);
procedure IniEraseSection(IniFile: TObject; const Section: string);
procedure IniDeleteKey(IniFile: TObject; const Section, Ident: string);

{$IFDEF VCL}
procedure AppBroadcast(Msg, wParam: Longint; lParam: Longint);

procedure AppTaskbarIcons(AppOnly: Boolean);
{$ENDIF VCL}

{ Internal using utilities }

procedure InternalSaveFormPlacement(Form: TForm; const AppStore:
  TJvCustomAppStore;
  const StorePath: string; SaveState: Boolean = True; SavePosition: Boolean =
    True);
procedure InternalRestoreFormPlacement(Form: TForm; const AppStore:
  TJvCustomAppStore;
  const StorePath: string; LoadState: Boolean = True; LoadPosition: Boolean =
    True);
procedure InternalSaveGridLayout(Grid: TCustomGrid; const AppStore:
  TJvCustomAppStore;
  const StorePath: string);
procedure InternalRestoreGridLayout(Grid: TCustomGrid; const AppStore:
  TJvCustomAppStore;
  const StorePath: string);
procedure InternalSaveMDIChildren(MainForm: TForm; const AppStore:
  TJvCustomAppStore;
  const StorePath: string);
procedure InternalRestoreMDIChildren(MainForm: TForm; const AppStore:
  TJvCustomAppStore;
  const StorePath: string);

{ end JvAppUtils }
{ begin JvGraph }
type
  TMappingMethod = (mmHistogram, mmQuantize, mmTrunc784, mmTrunc666,
    mmTripel, mmGrayscale);

function GetBitmapPixelFormat(Bitmap: TBitmap): TPixelFormat;
{$IFDEF VCL}
function GetPaletteBitmapFormat(Bitmap: TBitmap): TPixelFormat;
procedure SetBitmapPixelFormat(Bitmap: TBitmap; PixelFormat: TPixelFormat;
  Method: TMappingMethod);
function BitmapToMemoryStream(Bitmap: TBitmap; PixelFormat: TPixelFormat;
  Method: TMappingMethod): TMemoryStream;
procedure GrayscaleBitmap(Bitmap: TBitmap);

function BitmapToMemory(Bitmap: TBitmap; Colors: Integer): TStream;
procedure SaveBitmapToFile(const FileName: string; Bitmap: TBitmap;
  Colors: Integer);

function ScreenPixelFormat: TPixelFormat;
function ScreenColorCount: Integer;

procedure TileImage(Canvas: TCanvas; Rect: TRect; Image: TGraphic);
function ZoomImage(ImageW, ImageH, MaxW, MaxH: Integer; Stretch: Boolean):
  TPoint;

var
  DefaultMappingMethod: TMappingMethod = mmHistogram;
{$ENDIF VCL}

type
  TJvGradientOptions = class(TPersistent)
  private
    FStartColor: TColor;
    FEndColor: TColor;
    FDirection: TFillDirection;
    FStepCount: byte;
    FVisible: Boolean;
    FOnChange: TNotifyEvent;
    procedure SetStartColor(Value: TColor);
    procedure SetEndColor(Value: TColor);
    procedure SetDirection(Value: TFillDirection);
    procedure SetStepCount(Value: byte);
    procedure SetVisible(Value: Boolean);
  protected
    procedure Changed; dynamic;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Draw(Canvas: TCanvas; Rect: TRect);
  published
    property Direction: TFillDirection read FDirection write SetDirection default
      fdTopToBottom;
    property EndColor: TColor read FEndColor write SetEndColor default clGray;
    property StartColor: TColor read FStartColor write SetStartColor default
      clSilver;
    property StepCount: byte read FStepCount write SetStepCount default 64;
    property Visible: Boolean read FVisible write SetVisible default False;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;
  { end JvGraph }

{ begin JvCtrlUtils }

//------------------------------------------------------------------------------
// ToolBarMenu
//------------------------------------------------------------------------------

procedure JvCreateToolBarMenu(AForm: TForm; AToolBar: TToolBar; AMenu: TMainMenu
  = nil);

//------------------------------------------------------------------------------
// ListView functions
//------------------------------------------------------------------------------

type
  PJvLVItemStateData = ^TJvLVItemStateData;
  TJvLVItemStateData = record
    Caption: string;
    Data: Pointer;
    Focused, Selected: Boolean;
  end;

  { listview functions }
function ConvertStates(const State: Integer): TItemStates;

function ChangeHasDeselect(const peOld, peNew: TItemStates): Boolean;
function ChangeHasSelect(const peOld, peNew: TItemStates): Boolean;

function ChangeHasDefocus(const peOld, peNew: TItemStates): Boolean;
function ChangeHasFocus(const peOld, peNew: TItemStates): Boolean;

function GetListItemColumn(const pcItem: TListItem; piIndex: Integer): string;

procedure JvListViewToStrings(ListView: TListView; Strings: TStrings;
  SelectedOnly: Boolean = False; Headers: Boolean = True);

function JvListViewSafeSubItemString(Item: TListItem; SubItemIndex: Integer):
  string;

procedure JvListViewSortClick(Column: TListColumn; AscendingSortImage: Integer =
  -1;
  DescendingSortImage: Integer = -1);

procedure JvListViewCompare(ListView: TListView; Item1, Item2: TListItem;
  var Compare: Integer);

procedure JvListViewSelectAll(ListView: TListView; Deselect: Boolean = False);

function JvListViewSaveState(ListView: TListView): TJvLVItemStateData;

function JvListViewRestoreState(ListView: TListView; Data: TJvLVItemStateData;
  MakeVisible: Boolean = True; FocusFirst: Boolean = False): Boolean;

{$IFDEF VCL}
function JvListViewGetOrderedColumnIndex(Column: TListColumn): Integer;

procedure JvListViewSetSystemImageList(ListView: TListView);
{$ENDIF VCL}

//------------------------------------------------------------------------------
// MessageBox
//------------------------------------------------------------------------------

function JvMessageBox(const Text, Caption: string; Flags: DWORD): Integer;
  overload;
function JvMessageBox(const Text: string; Flags: DWORD): Integer; overload;

{ end JvCtrlUtils }

procedure UpdateTrackFont(TrackFont, Font: TFont; TrackOptions:
  TJvTrackFontOptions);
// Returns the size of the image
// used for checkboxes and radiobuttons.
// Originally from Mike Lischke
function GetDefaultCheckBoxSize: TSize;

const
  crJVCLFirst = TCursor(100);
  crMultiDragLink = TCursor(100);
  crDragAlt = TCursor(101);
  crMultiDragAlt = TCursor(102);
  crMultiDragLinkAlt = TCursor(103);

implementation

uses
  Consts, SysConst, CommCtrl, MMSystem, ShlObj, ActiveX, Math,
  JclSysInfo,
  JvConsts, JvProgressUtils;

{$IFDEF MSWINDOWS}
{$R ..\resources\JvConsts.res}
{$ENDIF}
{$IFDEF LINUX}
{$R ../Resources/JvConsts.res}
{$ENDIF}

resourcestring
  RsNotForMdi = 'MDI forms are not allowed';
  SPixelFormatNotImplemented = 'BitmapToMemoryStream: pixel format not implemented';
  SBitCountNotImplemented = 'BitmapToMemoryStream: bit count not implemented';

const
  RC_ControlRegistry = 'Control Panel\Desktop';
  RC_WallPaperStyle = 'WallpaperStyle';
  RC_WallpaperRegistry = 'Wallpaper';
  RC_TileWallpaper = 'TileWallpaper';
  RC_RunCpl = 'rundll32.exe shell32,Control_RunDLL ';

type
  TWaitCursor = class(TInterfacedObject, IInterface)
  private
    FCUrsor: TCursor;
  public
    constructor Create(ACursor: TCursor);
    destructor Destroy; override;
  end;

constructor TWaitCursor.Create(ACursor: TCursor);
begin
  inherited Create;
  FCUrsor := Screen.Cursor;
  Screen.Cursor := ACursor;
end;

destructor TWaitCursor.Destroy;
begin
  Screen.Cursor := FCUrsor;
  inherited;
end;

{$IFDEF MSWINDOWS}
{$IFDEF VCL}

function IconToBitmap(Ico: HICON): TBitmap;
var
  Pic: TPicture;
begin
  Pic := TPicture.Create;
  try
    Pic.Icon.Handle := Ico;
    Result := TBitmap.Create;
    Result.Height := Pic.Icon.Height;
    Result.Width := Pic.Icon.Width;
    Result.Canvas.Draw(0, 0, Pic.Icon);
  finally
    Pic.Free;
  end;
end;

function IconToBitmap2(Ico: HICON; Size: Integer = 32; TransparentColor: TColor
  = clNone): TBitmap;
begin
  // (p3) this seems to generate "better" bitmaps...
  with TImageList.CreateSize(Size, Size) do
  try
    Masked := True;
    BkColor := TransparentColor;
    ImageList_AddIcon(Handle, Ico);
    Result := TBitmap.Create;
    Result.PixelFormat := pf24bit;
    if TransparentColor <> clNone then
      Result.TransparentColor := TransparentColor;
    Result.Transparent := TransparentColor <> clNone;
    GetBitmap(0, Result);
  finally
    Free;
  end;
end;

function IconToBitmap3(Ico: HICON; Size: Integer = 32; TransparentColor: TColor
  = clNone): TBitmap;
var
  Icon: TIcon;
  Tmp: TBitmap;
begin
  Icon := TIcon.Create;
  Tmp := TBitmap.Create;
  try
    Icon.Handle := CopyIcon(Ico);
    Result := TBitmap.Create;
    Result.Width := Icon.Width;
    Result.Height := Icon.Height;
    Result.PixelFormat := pf24bit;
    // fill the bitmap with the transparant color
    Result.Canvas.Brush.Color := TransparentColor;
    Result.Canvas.FillRect(Rect(0, 0, Result.Width, Result.Height));
    Result.Canvas.Draw(0, 0, Icon);
    Result.TransparentColor := TransparentColor;
    Tmp.Assign(Result);
    //    Result.Width := Size;
    //    Result.Height := Size;
    Result.Canvas.StretchDraw(Rect(0, 0, Result.Width, Result.Height), Tmp);
    Result.Transparent := True;
  finally
    Icon.Free;
    Tmp.Free;
  end;
end;
{$ENDIF VCL}

function GetMax(i, j, K: Integer): Integer;
begin
  if j > i then
    i := j;
  if K > i then
    i := K;
  Result := i;
end;

function GetMin(i, j, K: Integer): Integer;
begin
  if j < i then
    i := j;
  if K < i then
    i := K;
  Result := i;
end;

procedure RGBToHSV(r, g, b: Integer; var h, s, v: Integer);
var
  Delta: Integer;
  Min, Max: Integer;
begin
  Min := GetMin(r, g, b);
  Max := GetMax(r, g, b);
  v := Max;
  Delta := Max - Min;
  if Max = 0 then
    s := 0
  else
    s := (255 * Delta) div Max;
  if s = 0 then
    h := 0
  else
  begin
    if r = Max then
      h := (60 * (g - b)) div Delta
    else
      if g = Max then
        h := 120 + (60 * (b - r)) div Delta
      else
        h := 240 + (60 * (r - g)) div Delta;
    if h < 0 then
      h := h + 360;
  end;
end;

{$IFDEF VCL}

function CaptureScreen(Rec: TRect): TBitmap;
const
  NumColors = 256;
var
  r: TRect;
  C: TCanvas;
  LP: PLogPalette;
  TmpPalette: HPALETTE;
  Size: Integer;
begin
  Result := TBitmap.Create;
  Result.Width := Rec.Right - Rec.Left;
  Result.Height := Rec.Bottom - Rec.Top;
  r := Rec;
  C := TCanvas.Create;
  try
    C.Handle := GetDC(HWND_DESKTOP);
    Result.Canvas.CopyRect(Rect(0, 0, Rec.Right - Rec.Left, Rec.Bottom -
      Rec.Top), C, r);
    Size := SizeOf(TLogPalette) + (Pred(NumColors) * SizeOf(TPaletteEntry));
    LP := AllocMem(Size);
    try
      LP^.palVersion := $300;
      LP^.palNumEntries := NumColors;
      GetSystemPaletteEntries(C.Handle, 0, NumColors, LP^.palPalEntry);
      TmpPalette := CreatePalette(LP^);
      Result.Palette := TmpPalette;
      DeleteObject(TmpPalette);
    finally
      FreeMem(LP, Size);
    end
  finally
    ReleaseDC(HWND_DESKTOP, C.Handle);
    C.Free;
  end;
end;

function CaptureScreen(IncludeTaskBar: Boolean): TBitmap;
var
  r: TRect;
begin
  if IncludeTaskBar then
    r := Rect(0, 0, Screen.Width, Screen.Height)
  else
    SystemParametersInfo(SPI_GETWORKAREA, 0, Pointer(@r), 0);
  Result := CaptureScreen(r);
end;

function CaptureScreen(WndHandle: Longword): TBitmap;
var
  r: TRect;
  WP: TWindowPlacement;
begin
  if GetWindowRect(WndHandle, r) then
  begin
    GetWindowPlacement(WndHandle, @WP);
    if IsIconic(WndHandle) then
      ShowWindow(WndHandle, SW_RESTORE);
    BringWindowToTop(WndHandle);
    Result := CaptureScreen(r);
    SetWindowPlacement(WndHandle, @WP);
  end
  else
    Result := nil;
end;
{$ENDIF VCL}

procedure SetWallpaper(const Path: string);
begin
  SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, PChar(Path),
    SPIF_UPDATEINIFILE);
end;

procedure SetWallpaper(const Path: string; Style: TJvWallpaperStyle);
begin
  with TRegistry.Create do
  begin
    OpenKey(RC_ControlRegistry, False);
    case Style of
      wpTile:
        begin
          WriteString(RC_TileWallpaper, '1');
          WriteString(RC_WallPaperStyle, '0');
        end;
      wpCenter:
        begin
          WriteString(RC_TileWallpaper, '0');
          WriteString(RC_WallPaperStyle, '0');
        end;
      wpStretch:
        begin
          WriteString(RC_TileWallpaper, '0');
          WriteString(RC_WallPaperStyle, '2');
        end;
    end;
    WriteString(RC_WallpaperRegistry, Path);
    Free;
  end;
  SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, nil, SPIF_SENDWININICHANGE);
end;

{$ENDIF MSWINDOWS}

function GetRBitmap(Value: TBitmap): TBitmap;
var
  i, j: Integer;
  rowRGB, rowB: PRGBArray;
begin
  Value.PixelFormat := pf24bit;
  Result := TBitmap.Create;
  Result.PixelFormat := pf24bit;
  Result.Width := Value.Width;
  Result.Height := Value.Height;
  for j := Value.Height - 1 downto 0 do
  begin
    rowRGB := Value.ScanLine[j];
    rowB := Result.ScanLine[j];
    for i := Value.Width - 1 downto 0 do
    begin
      TRGBArray(rowB^)[i].rgbtRed := rowRGB[i].rgbtRed;
      TRGBArray(rowB^)[i].rgbtGreen := 0;
      TRGBArray(rowB^)[i].rgbtBlue := 0;
    end;
  end;
end;

function GetBBitmap(Value: TBitmap): TBitmap;
var
  i, j: Integer;
  rowRGB, rowB: PRGBArray;
begin
  Value.PixelFormat := pf24bit;
  Result := TBitmap.Create;
  Result.PixelFormat := pf24bit;
  Result.Width := Value.Width;
  Result.Height := Value.Height;
  for j := Value.Height - 1 downto 0 do
  begin
    rowRGB := Value.ScanLine[j];
    rowB := Result.ScanLine[j];
    for i := Value.Width - 1 downto 0 do
    begin
      TRGBArray(rowB^)[i].rgbtRed := 0;
      TRGBArray(rowB^)[i].rgbtGreen := 0;
      TRGBArray(rowB^)[i].rgbtBlue := rowRGB[i].rgbtBlue;
    end;
  end;
end;

function GetGBitmap(Value: TBitmap): TBitmap;
var
  i, j: Integer;
  rowRGB, rowB: PRGBArray;
begin
  Value.PixelFormat := pf24bit;
  Result := TBitmap.Create;
  Result.PixelFormat := pf24bit;
  Result.Width := Value.Width;
  Result.Height := Value.Height;
  for j := Value.Height - 1 downto 0 do
  begin
    rowRGB := Value.ScanLine[j];
    rowB := Result.ScanLine[j];
    for i := Value.Width - 1 downto 0 do
    begin
      TRGBArray(rowB^)[i].rgbtRed := 0;
      TRGBArray(rowB^)[i].rgbtGreen := rowRGB[i].rgbtGreen;
      TRGBArray(rowB^)[i].rgbtBlue := 0;
    end;
  end;
end;

function GetHueBitmap(Value: TBitmap): TBitmap;
var
  h, s, v, i, j: Integer;
  rowRGB, Rows: PRGBArray;
begin
  Value.PixelFormat := pf24bit;
  Result := TBitmap.Create;
  Result.PixelFormat := pf24bit;
  Result.Width := Value.Width;
  Result.Height := Value.Height;
  for j := Value.Height - 1 downto 0 do
  begin
    rowRGB := Value.ScanLine[j];
    Rows := Result.ScanLine[j];
    for i := Value.Width - 1 downto 0 do
    begin
      with rowRGB[i] do
        RGBToHSV(rgbtRed, rgbtGreen, rgbtBlue, h, s, v);
      Rows[i].rgbtBlue := h;
      Rows[i].rgbtGreen := h;
      Rows[i].rgbtRed := h;
    end;
  end;
end;

function GetMonochromeBitmap(Value: TBitmap): TBitmap;
begin
  Result := TBitmap.Create;
  Result.Assign(Value);
  Result.Monochrome := True;
end;

function GetSaturationBitmap(Value: TBitmap): TBitmap;
var
  h, s, v, i, j: Integer;
  rowRGB, Rows: PRGBArray;
begin
  Value.PixelFormat := pf24bit;
  Result := TBitmap.Create;
  Result.PixelFormat := pf24bit;
  Result.Width := Value.Width;
  Result.Height := Value.Height;
  for j := Value.Height - 1 downto 0 do
  begin
    rowRGB := Value.ScanLine[j];
    Rows := Result.ScanLine[j];
    for i := Value.Width - 1 downto 0 do
    begin
      with rowRGB[i] do
        RGBToHSV(rgbtRed, rgbtGreen, rgbtBlue, h, s, v);
      Rows[i].rgbtBlue := s;
      Rows[i].rgbtGreen := s;
      Rows[i].rgbtRed := s;
    end;
  end;
end;

function GetValueBitmap(Value: TBitmap): TBitmap;
var
  h, s, v, i, j: Integer;
  rowRGB, Rows: PRGBArray;
begin
  Value.PixelFormat := pf24bit;
  Result := TBitmap.Create;
  Result.PixelFormat := pf24bit;
  Result.Width := Value.Width;
  Result.Height := Value.Height;
  for j := Value.Height - 1 downto 0 do
  begin
    rowRGB := Value.ScanLine[j];
    Rows := Result.ScanLine[j];
    for i := Value.Width - 1 downto 0 do
    begin
      with rowRGB[i] do
        RGBToHSV(rgbtRed, rgbtGreen, rgbtBlue, h, s, v);
      Rows[i].rgbtBlue := v;
      Rows[i].rgbtGreen := v;
      Rows[i].rgbtRed := v;
    end;
  end;
end;

{$IFDEF MSWINDOWS}
{ (rb) Duplicate of JvAppUtils.AppTaskbarIcons }

procedure HideFormCaption(FormHandle: HWND; Hide: Boolean);
begin
  if Hide then
    SetWindowLong(FormHandle, GWL_STYLE, GetWindowLong(FormHandle, GWL_STYLE) and
      not WS_CAPTION)
  else
    SetWindowLong(FormHandle, GWL_STYLE, GetWindowLong(FormHandle, GWL_STYLE) or
      WS_CAPTION);
end;
{$ENDIF MSWINDOWS}

// (rom) a thread to wait would be more elegant, also JCL function available

function Execute(const CommandLine, WorkingDirectory: string): Integer;
{$IFDEF MSWINDOWS}
var
  r: Boolean;
  ProcessInformation: TProcessInformation;
  StartupInfo: TStartupInfo;
  ExCode: Cardinal;
begin
  Result := 0;
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_SHOW;
  end;
  r := CreateProcess(
    nil, // Pointer to name of executable module
    PChar(CommandLine), // Pointer to command line string
    nil, // Pointer to process security attributes
    nil, // Pointer to thread security attributes
    False, // handle inheritance flag
    0, // creation flags
    nil, // Pointer to new environment block
    PChar(WorkingDirectory), // Pointer to current directory name
    StartupInfo, // Pointer to STARTUPINFO
    ProcessInformation); // Pointer to PROCESS_INFORMATION
  if r then
    while (GetExitCodeProcess(ProcessInformation.hProcess, ExCode) and
      (ExCode = STILL_ACTIVE)) do
      Application.ProcessMessages
  else
    Result := GetLastError;
end;
{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
begin
  if WorkingDirectory = '' then WorkingDirectory := GetCurrentDirectory;
  Result := Libc.system(PChar(Format('cd "%s" ; %s',
    [WorkingDirectory, CommandLine])));
end;
{$ENDIF LINUX}

{$IFDEF VCL}

procedure LaunchCpl(FileName: string);
begin
  // rundll32.exe shell32,Control_RunDLL ';
  RunDLL32('shell32.dll', 'Control_RunDLL', FileName, True);
  //  WinExec(PChar(RC_RunCpl + FileName), SW_SHOWNORMAL);
end;

const
{$EXTERNALSYM WM_CPL_LAUNCH}
  WM_CPL_LAUNCH = (WM_USER + 1000);
{$EXTERNALSYM WM_CPL_LAUNCHED}
  WM_CPL_LAUNCHED = (WM_USER + 1001);

  { (p3) just define enough to make the Cpl unnecessary for us (for the benefit of PE users) }
  cCplAddress = 'CPlApplet';
  CPL_INIT = 1;
{$EXTERNALSYM CPL_INIT}
  CPL_GETCOUNT = 2;
{$EXTERNALSYM CPL_GETCOUNT}
  CPL_INQUIRE = 3;
{$EXTERNALSYM CPL_INQUIRE}
  CPL_EXIT = 7;
{$EXTERNALSYM CPL_EXIT}
  CPL_NEWINQUIRE = 8;
{$EXTERNALSYM CPL_NEWINQUIRE}

type
  TCPLApplet = function(hwndCPl: THandle; uMsg: DWORD;
    lParam1, lParam2: Longint): Longint; stdcall;

  TCPLInfo = packed record
    idIcon: Integer;
    idName: Integer;
    idInfo: Integer;
    lData: Longint;
  end;

  TNewCPLInfoA = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwHelpContext: DWORD;
    lData: Longint;
    HICON: HICON;
    szName: array[0..31] of AnsiChar;
    szInfo: array[0..63] of AnsiChar;
    szHelpFile: array[0..127] of AnsiChar;
  end;
  TNewCPLInfoW = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwHelpContext: DWORD;
    lData: Longint;
    HICON: HICON;
    szName: array[0..31] of WideChar;
    szInfo: array[0..63] of WideChar;
    szHelpFile: array[0..127] of WideChar;
  end;

function GetControlPanelApplet(const AFileName: string; Strings: TStrings;
  Images: TCustomImageList = nil): Boolean;
var
  hLib: HMODULE; // Library Handle to *.cpl file
  hIco: HICON;
  CplCall: TCPLApplet; // Pointer to CPlApplet() function
  i: Longint;
  TmpCount, Count: Longint;
  s: WideString;
  // the three types of information that can be returned
  CPLInfo: TCPLInfo;
  InfoW: TNewCPLInfoW;
  InfoA: TNewCPLInfoA;
  HWND: THandle;
begin
  Result := False;
  hLib := SafeLoadLibrary(AFileName);
  if hLib = 0 then
    Exit;
  HWND := GetForegroundWindow;
  TmpCount := Strings.Count;
  try
    @CplCall := GetProcAddress(hLib, PChar(cCplAddress));
    if @CplCall = nil then
      Exit;
    CplCall(HWND, CPL_INIT, 0, 0); // Init the *.cpl file
    try
      Count := CplCall(HWND, CPL_GETCOUNT, 0, 0);
      for i := 0 to Count - 1 do
      begin
        FillChar(InfoW, SizeOf(InfoW), 0);
        FillChar(InfoA, SizeOf(InfoA), 0);
        FillChar(CPLInfo, SizeOf(CPLInfo), 0);
        s := '';
        CplCall(HWND, CPL_NEWINQUIRE, i, Longint(@InfoW));
        if InfoW.dwSize = SizeOf(InfoW) then
        begin
          hIco := InfoW.HICON;
          s := WideString(InfoW.szName);
        end
        else
        begin
          if InfoW.dwSize = SizeOf(InfoA) then
          begin
            Move(InfoW, InfoA, SizeOf(InfoA));
            hIco := CopyIcon(InfoA.HICON);
            s := string(InfoA.szName);
          end
          else
          begin
            CplCall(HWND, CPL_INQUIRE, i, Longint(@CPLInfo));
            LoadStringA(hLib, CPLInfo.idName, InfoA.szName,
              SizeOf(InfoA.szName));
            hIco := LoadImage(hLib, PChar(CPLInfo.idIcon), IMAGE_ICON, 16, 16,
              LR_DEFAULTCOLOR);
            s := string(InfoA.szName);
          end;
        end;
        if s <> '' then
        begin
          s := Format('%s=%s,@%d', [s, AFileName, i]);
          if Images <> nil then
          begin
            hIco := CopyIcon(hIco);
            ImageList_AddIcon(Images.Handle, hIco);
            Strings.AddObject(s, TObject(Images.Count - 1));
          end
          else
            Strings.AddObject(s, IconToBitmap2(hIco, 16, clMenu));
          // (p3) not sure this is really needed...
          // DestroyIcon(hIco);
        end;
      end;
      Result := TmpCount < Strings.Count;
    finally
      CplCall(HWND, CPL_EXIT, 0, 0);
    end;
  finally
    FreeLibrary(hLib);
  end;
end;

function GetControlPanelApplets(const APath, AMask: string; Strings: TStrings;
  Images: TCustomImageList = nil): Boolean;
var
  h: THandle;
  F: TSearchRec;
begin
  h := FindFirst(IncludeTrailingPathDelimiter(APath) + AMask, faAnyFile, F);
  if Images <> nil then
  begin
    Images.Clear;
    Images.BkColor := clMenu;
  end;
  if Strings <> nil then
    Strings.Clear;
  while h = 0 do
  begin
    if F.Attr and faDirectory = 0 then
      //    if (F.Name <> '.') and (F.Name <> '..') then
      GetControlPanelApplet(APath + F.Name, Strings, Images);
    h := FindNext(F);
  end;
  SysUtils.FindClose(F);
  Result := Strings.Count > 0;
end;
{$ENDIF VCL}

{ imported from VCLFunctions }

procedure CenterHeight(const pc, pcParent: TControl);
begin
  pc.Top := //pcParent.Top +
  ((pcParent.Height - pc.Height) div 2);
end;

function ToRightOf(const pc: TControl; piSpace: Integer): Integer;
begin
  if pc <> nil then
    Result := pc.Left + pc.Width + piSpace
  else
    Result := piSpace;
end;

{ compiled from ComCtrls.pas's implmentation section }

function HasFlag(a, b: Integer): Boolean;
begin
  Result := (a and b) <> 0;
end;

function ConvertStates(const State: Integer): TItemStates;
begin
  Result := [];
  if HasFlag(State, LVIS_ACTIVATING) then
    Include(Result, isActivating);
{$IFDEF VCL}
  if HasFlag(State, LVIS_CUT) then
    Include(Result, isCut);
  if HasFlag(State, LVIS_DROPHILITED) then
    Include(Result, isDropHilited);
{$ENDIF}
  if HasFlag(State, LVIS_FOCUSED) then
    Include(Result, IsFocused);
  if HasFlag(State, LVIS_SELECTED) then
    Include(Result, isSelected);
end;

function ChangeHasSelect(const peOld, peNew: TItemStates): Boolean;
begin
  Result := (not (isSelected in peOld)) and (isSelected in peNew);
end;

function ChangeHasDeselect(const peOld, peNew: TItemStates): Boolean;
begin
  Result := (isSelected in peOld) and (not (isSelected in peNew));
end;

function ChangeHasFocus(const peOld, peNew: TItemStates): Boolean;
begin
  Result := (not (IsFocused in peOld)) and (IsFocused in peNew);
end;

function ChangeHasDefocus(const peOld, peNew: TItemStates): Boolean;
begin
  Result := (IsFocused in peOld) and (not (IsFocused in peNew));
end;

function GetListItemColumn(const pcItem: TListItem; piIndex: Integer): string;
begin
  if pcItem = nil then
  begin
    Result := '';
    Exit;
  end;

  if (piIndex < 0) or (piIndex > pcItem.SubItems.Count) then
  begin
    Result := '';
    Exit;
  end;

  if piIndex = 0 then
    Result := pcItem.Caption
  else
    Result := pcItem.SubItems[piIndex - 1];
end;

{from JvVCLUtils }

{ Bitmaps }

{$IFDEF VCL}

function MakeModuleBitmap(Module: THandle; ResID: PChar): TBitmap;
begin
  Result := TBitmap.Create;
  try
    if Module <> 0 then
    begin
      if LongRec(ResID).Hi = 0 then
        Result.LoadFromResourceID(Module, LongRec(ResID).Lo)
      else
        Result.LoadFromResourceName(Module, StrPas(ResID));
    end
    else
    begin
      Result.Handle := LoadBitmap(Module, ResID);
      if Result.Handle = 0 then
        ResourceNotFound(ResID);
    end;
  except
    Result.Free;
    Result := nil;
  end;
end;

function MakeBitmap(ResID: PChar): TBitmap;
begin
  Result := MakeModuleBitmap(HInstance, ResID);
end;

function MakeBitmapID(ResID: Word): TBitmap;
begin
  Result := MakeModuleBitmap(HInstance, MakeIntResource(ResID));
end;

procedure AssignBitmapCell(Source: TGraphic; Dest: TBitmap;
  Cols, Rows, Index: Integer);
var
  CellWidth, CellHeight: Integer;
begin
  if (Source <> nil) and (Dest <> nil) then
  begin
    if Cols <= 0 then
      Cols := 1;
    if Rows <= 0 then
      Rows := 1;
    if Index < 0 then
      Index := 0;
    CellWidth := Source.Width div Cols;
    CellHeight := Source.Height div Rows;
    with Dest do
    begin
      Width := CellWidth;
      Height := CellHeight;
    end;
    if Source is TBitmap then
    begin
      Dest.Canvas.CopyRect(Bounds(0, 0, CellWidth, CellHeight),
        TBitmap(Source).Canvas, Bounds((Index mod Cols) * CellWidth,
        (Index div Cols) * CellHeight, CellWidth, CellHeight));
      Dest.TransparentColor := TBitmap(Source).TransparentColor;
    end
    else
    begin
      Dest.Canvas.Brush.Color := clSilver;
      Dest.Canvas.FillRect(Bounds(0, 0, CellWidth, CellHeight));
      Dest.Canvas.Draw(-(Index mod Cols) * CellWidth,
        -(Index div Cols) * CellHeight, Source);
    end;
    Dest.Transparent := Source.Transparent;
  end;
end;

type
  TJvParentControl = class(TWinControl);

procedure CopyParentImage(Control: TControl; Dest: TCanvas);
var
  i, Count, X, Y, SaveIndex: Integer;
  DC: HDC;
  r, SelfR, CtlR: TRect;
begin
  if (Control = nil) or (Control.Parent = nil) then
    Exit;
  Count := Control.Parent.ControlCount;
  DC := Dest.Handle;
  with Control.Parent do
    ControlState := ControlState + [csPaintCopy];
  try
    with Control do
    begin
      SelfR := Bounds(Left, Top, Width, Height);
      X := -Left;
      Y := -Top;
    end;
    { Copy parent control image }
    SaveIndex := SaveDC(DC);
    try
      SetViewPortOrgEx(DC, X, Y, nil);
      IntersectClipRect(DC, 0, 0, Control.Parent.ClientWidth,
        Control.Parent.ClientHeight);
      with TJvParentControl(Control.Parent) do
      begin
        Perform(WM_ERASEBKGND, DC, 0);
        PaintWindow(DC);
      end;
    finally
      RestoreDC(DC, SaveIndex);
    end;
    { Copy images of graphic controls }
    for i := 0 to Count - 1 do
    begin
      if Control.Parent.Controls[i] = Control then
        break
      else
        if (Control.Parent.Controls[i] <> nil) and
        (Control.Parent.Controls[i] is TGraphicControl) then
        begin
          with TGraphicControl(Control.Parent.Controls[i]) do
          begin
            CtlR := Bounds(Left, Top, Width, Height);
            if BOOL(InterSectRect(r, SelfR, CtlR)) and Visible then
            begin
              ControlState := ControlState + [csPaintCopy];
              SaveIndex := SaveDC(DC);
              try
                SaveIndex := SaveDC(DC);
                SetViewPortOrgEx(DC, Left + X, Top + Y, nil);
                IntersectClipRect(DC, 0, 0, Width, Height);
                Perform(WM_PAINT, DC, 0);
              finally
                RestoreDC(DC, SaveIndex);
                ControlState := ControlState - [csPaintCopy];
              end;
            end;
          end;
        end;
    end;
  finally
    with Control.Parent do
      ControlState := ControlState - [csPaintCopy];
  end;
end;

{ Transparent bitmap }

procedure StretchBltTransparent(DstDC: HDC; DstX, DstY, DstW, DstH: Integer;
  SrcDC: HDC; SrcX, SrcY, SrcW, Srch: Integer; Palette: HPALETTE;
  TransparentColor: TColorRef);
var
  Color: TColorRef;
  bmAndBack, bmAndObject, bmAndMem, bmSave: HBITMAP;
  bmBackOld, bmObjectOld, bmMemOld, bmSaveOld: HBITMAP;
  MemDC, BackDC, ObjectDC, SaveDC: HDC;
  palDst, palMem, palSave, palObj: HPALETTE;
begin
  { Create some DCs to hold temporary data }
  BackDC := CreateCompatibleDC(DstDC);
  ObjectDC := CreateCompatibleDC(DstDC);
  MemDC := CreateCompatibleDC(DstDC);
  SaveDC := CreateCompatibleDC(DstDC);
  { Create a bitmap for each DC }
  bmAndObject := CreateBitmap(SrcW, Srch, 1, 1, nil);
  bmAndBack := CreateBitmap(SrcW, Srch, 1, 1, nil);
  bmAndMem := CreateCompatibleBitmap(DstDC, DstW, DstH);
  bmSave := CreateCompatibleBitmap(DstDC, SrcW, Srch);
  { Each DC must select a bitmap object to store pixel data }
  bmBackOld := SelectObject(BackDC, bmAndBack);
  bmObjectOld := SelectObject(ObjectDC, bmAndObject);
  bmMemOld := SelectObject(MemDC, bmAndMem);
  bmSaveOld := SelectObject(SaveDC, bmSave);
  { Select palette }
  palDst := 0;
  palMem := 0;
  palSave := 0;
  palObj := 0;
  if Palette <> 0 then
  begin
    palDst := SelectPalette(DstDC, Palette, True);
    RealizePalette(DstDC);
    palSave := SelectPalette(SaveDC, Palette, False);
    RealizePalette(SaveDC);
    palObj := SelectPalette(ObjectDC, Palette, False);
    RealizePalette(ObjectDC);
    palMem := SelectPalette(MemDC, Palette, True);
    RealizePalette(MemDC);
  end;
  { Set proper mapping mode }
  SetMapMode(SrcDC, GetMapMode(DstDC));
  SetMapMode(SaveDC, GetMapMode(DstDC));
  { Save the bitmap sent here }
  BitBlt(SaveDC, 0, 0, SrcW, Srch, SrcDC, SrcX, SrcY, SRCCOPY);
  { Set the background color of the source DC to the color,         }
  { contained in the parts of the bitmap that should be transparent }
  Color := SetBkColor(SaveDC, PaletteColor(TransparentColor));
  { Create the object mask for the bitmap by performing a BitBlt()  }
  { from the source bitmap to a monochrome bitmap                   }
  BitBlt(ObjectDC, 0, 0, SrcW, Srch, SaveDC, 0, 0, SRCCOPY);
  { Set the background color of the source DC back to the original  }
  SetBkColor(SaveDC, Color);
  { Create the inverse of the object mask }
  BitBlt(BackDC, 0, 0, SrcW, Srch, ObjectDC, 0, 0, NOTSRCCOPY);
  { Copy the background of the main DC to the destination }
  BitBlt(MemDC, 0, 0, DstW, DstH, DstDC, DstX, DstY, SRCCOPY);
  { Mask out the places where the bitmap will be placed }
  StretchBlt(MemDC, 0, 0, DstW, DstH, ObjectDC, 0, 0, SrcW, Srch, SRCAND);
  { Mask out the transparent colored pixels on the bitmap }
  BitBlt(SaveDC, 0, 0, SrcW, Srch, BackDC, 0, 0, SRCAND);
  { XOR the bitmap with the background on the destination DC }
  StretchBlt(MemDC, 0, 0, DstW, DstH, SaveDC, 0, 0, SrcW, Srch, SRCPAINT);
  { Copy the destination to the screen }
  BitBlt(DstDC, DstX, DstY, DstW, DstH, MemDC, 0, 0, SRCCOPY);
  { Restore palette }
  if Palette <> 0 then
  begin
    SelectPalette(MemDC, palMem, False);
    SelectPalette(ObjectDC, palObj, False);
    SelectPalette(SaveDC, palSave, False);
    SelectPalette(DstDC, palDst, True);
  end;
  { Delete the memory bitmaps }
  DeleteObject(SelectObject(BackDC, bmBackOld));
  DeleteObject(SelectObject(ObjectDC, bmObjectOld));
  DeleteObject(SelectObject(MemDC, bmMemOld));
  DeleteObject(SelectObject(SaveDC, bmSaveOld));
  { Delete the memory DCs }
  DeleteDC(MemDC);
  DeleteDC(BackDC);
  DeleteDC(ObjectDC);
  DeleteDC(SaveDC);
end;

procedure DrawTransparentBitmapRect(DC: HDC; Bitmap: HBITMAP; DstX, DstY,
  DstW, DstH: Integer; SrcRect: TRect; TransparentColor: TColorRef);
var
  hdcTemp: HDC;
begin
  hdcTemp := CreateCompatibleDC(DC);
  try
    SelectObject(hdcTemp, Bitmap);
    with SrcRect do
      StretchBltTransparent(DC, DstX, DstY, DstW, DstH, hdcTemp,
        Left, Top, Right - Left, Bottom - Top, 0, TransparentColor);
  finally
    DeleteDC(hdcTemp);
  end;
end;

procedure DrawTransparentBitmap(DC: HDC; Bitmap: HBITMAP;
  DstX, DstY: Integer; TransparentColor: TColorRef);
var
  BM: Windows.TBitmap;
begin
  GetObject(Bitmap, SizeOf(BM), @BM);
  DrawTransparentBitmapRect(DC, Bitmap, DstX, DstY, BM.bmWidth, BM.bmHeight,
    Rect(0, 0, BM.bmWidth, BM.bmHeight), TransparentColor);
end;

procedure StretchBitmapTransparent(Dest: TCanvas; Bitmap: TBitmap;
  TransparentColor: TColor; DstX, DstY, DstW, DstH, SrcX, SrcY,
  SrcW, Srch: Integer);
var
  CanvasChanging: TNotifyEvent;
begin
  if DstW <= 0 then
    DstW := Bitmap.Width;
  if DstH <= 0 then
    DstH := Bitmap.Height;
  if (SrcW <= 0) or (Srch <= 0) then
  begin
    SrcX := 0;
    SrcY := 0;
    SrcW := Bitmap.Width;
    Srch := Bitmap.Height;
  end;
  if not Bitmap.Monochrome then
    SetStretchBltMode(Dest.Handle, STRETCH_DELETESCANS);
  CanvasChanging := Bitmap.Canvas.OnChanging;
  Bitmap.Canvas.Lock;
  try
    Bitmap.Canvas.OnChanging := nil;
    if TransparentColor = clNone then
    begin
      StretchBlt(Dest.Handle, DstX, DstY, DstW, DstH, Bitmap.Canvas.Handle,
        SrcX, SrcY, SrcW, Srch, Dest.CopyMode);
    end
    else
    begin
      if TransparentColor = clDefault then
        TransparentColor := Bitmap.Canvas.Pixels[0, Bitmap.Height - 1];
      if Bitmap.Monochrome then
        TransparentColor := clWhite
      else
        TransparentColor := ColorToRGB(TransparentColor);
      StretchBltTransparent(Dest.Handle, DstX, DstY, DstW, DstH,
        Bitmap.Canvas.Handle, SrcX, SrcY, SrcW, Srch, Bitmap.Palette,
        TransparentColor);
    end;
  finally
    Bitmap.Canvas.OnChanging := CanvasChanging;
    Bitmap.Canvas.Unlock;
  end;
end;

procedure StretchBitmapRectTransparent(Dest: TCanvas; DstX, DstY,
  DstW, DstH: Integer; SrcRect: TRect; Bitmap: TBitmap;
  TransparentColor: TColor);
begin
  with SrcRect do
    StretchBitmapTransparent(Dest, Bitmap, TransparentColor,
      DstX, DstY, DstW, DstH, Left, Top, Right - Left, Bottom - Top);
end;

procedure DrawBitmapRectTransparent(Dest: TCanvas; DstX, DstY: Integer;
  SrcRect: TRect; Bitmap: TBitmap; TransparentColor: TColor);
begin
  with SrcRect do
    StretchBitmapTransparent(Dest, Bitmap, TransparentColor,
      DstX, DstY, Right - Left, Bottom - Top, Left, Top, Right - Left,
      Bottom - Top);
end;

procedure DrawBitmapTransparent(Dest: TCanvas; DstX, DstY: Integer;
  Bitmap: TBitmap; TransparentColor: TColor);
begin
  StretchBitmapTransparent(Dest, Bitmap, TransparentColor, DstX, DstY,
    Bitmap.Width, Bitmap.Height, 0, 0, Bitmap.Width, Bitmap.Height);
end;

{ ChangeBitmapColor. This function create new TBitmap object.
  You must destroy it outside by calling TBitmap.Free method. }

function ChangeBitmapColor(Bitmap: TBitmap; Color, NewColor: TColor): TBitmap;
var
  r: TRect;
begin
  Result := TBitmap.Create;
  try
    with Result do
    begin
      Height := Bitmap.Height;
      Width := Bitmap.Width;
      r := Bounds(0, 0, Width, Height);
      Canvas.Brush.Color := NewColor;
      Canvas.FillRect(r);
      Canvas.BrushCopy(r, Bitmap, r, Color);
    end;
  except
    Result.Free;
    raise;
  end;
end;

{ CreateDisabledBitmap. Creating TBitmap object with disable button glyph
  image. You must destroy it outside by calling TBitmap.Free method. }

const
  ROP_DSPDxax = $00E20746;

function CreateDisabledBitmap_NewStyle(FOriginal: TBitmap; BackColor: TColor):
  TBitmap;
var
  MonoBmp: TBitmap;
  r: TRect;
  DestDC, SrcDC: HDC;
begin
  r := Rect(0, 0, FOriginal.Width, FOriginal.Height);
  Result := TBitmap.Create;
  try
    Result.Width := FOriginal.Width;
    Result.Height := FOriginal.Height;
    Result.Canvas.Brush.Color := BackColor;
    Result.Canvas.FillRect(r);

    MonoBmp := TBitmap.Create;
    try
      MonoBmp.Width := FOriginal.Width;
      MonoBmp.Height := FOriginal.Height;
      MonoBmp.Canvas.Brush.Color := clWhite;
      MonoBmp.Canvas.FillRect(r);
      DrawBitmapTransparent(MonoBmp.Canvas, 0, 0, FOriginal, BackColor);
      MonoBmp.Monochrome := True;

      SrcDC := MonoBmp.Canvas.Handle;
      { Convert Black to clBtnHighlight }
      Result.Canvas.Brush.Color := clBtnHighlight;
      DestDC := Result.Canvas.Handle;
      Windows.SetTextColor(DestDC, clWhite);
      Windows.SetBkColor(DestDC, clBlack);
      BitBlt(DestDC, 1, 1, FOriginal.Width, FOriginal.Height, SrcDC, 0, 0,
        ROP_DSPDxax);
      { Convert Black to clBtnShadow }
      Result.Canvas.Brush.Color := clBtnShadow;
      DestDC := Result.Canvas.Handle;
      Windows.SetTextColor(DestDC, clWhite);
      Windows.SetBkColor(DestDC, clBlack);
      BitBlt(DestDC, 0, 0, FOriginal.Width, FOriginal.Height, SrcDC, 0, 0,
        ROP_DSPDxax);
    finally
      MonoBmp.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function CreateDisabledBitmapEx(FOriginal: TBitmap; OutlineColor, BackColor,
  HighLightColor, ShadowColor: TColor; DrawHighlight: Boolean): TBitmap;
var
  MonoBmp: TBitmap;
  IRect: TRect;
begin
  IRect := Rect(0, 0, FOriginal.Width, FOriginal.Height);
  Result := TBitmap.Create;
  try
    Result.Width := FOriginal.Width;
    Result.Height := FOriginal.Height;
    MonoBmp := TBitmap.Create;
    try
      with MonoBmp do
      begin
        Width := FOriginal.Width;
        Height := FOriginal.Height;
        Canvas.CopyRect(IRect, FOriginal.Canvas, IRect);
        HandleType := bmDDB;
        Canvas.Brush.Color := OutlineColor;
        if Monochrome then
        begin
          Canvas.Font.Color := clWhite;
          Monochrome := False;
          Canvas.Brush.Color := clWhite;
        end;
        Monochrome := True;
      end;
      with Result.Canvas do
      begin
        Brush.Color := BackColor;
        FillRect(IRect);
        if DrawHighlight then
        begin
          Brush.Color := HighLightColor;
          SetTextColor(Handle, clBlack);
          SetBkColor(Handle, clWhite);
          BitBlt(Handle, 1, 1, RectWidth(IRect), RectHeight(IRect),
            MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
        end;
        Brush.Color := ShadowColor;
        SetTextColor(Handle, clBlack);
        SetBkColor(Handle, clWhite);
        BitBlt(Handle, 0, 0, RectWidth(IRect), RectHeight(IRect),
          MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
      end;
    finally
      MonoBmp.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function CreateDisabledBitmap(FOriginal: TBitmap; OutlineColor: TColor):
  TBitmap;
begin
  Result := CreateDisabledBitmapEx(FOriginal, OutlineColor,
    clBtnFace, clBtnHighlight, clBtnShadow, True);
end;

procedure ImageListDrawDisabled(Images: TCustomImageList; Canvas: TCanvas;
  X, Y, Index: Integer; HighLightColor, GrayColor: TColor; DrawHighlight:
    Boolean);
var
  Bmp: TBitmap;
  SaveColor: TColor;
begin
  SaveColor := Canvas.Brush.Color;
  Bmp := TBitmap.Create;
  try
    Bmp.Width := Images.Width;
    Bmp.Height := Images.Height;
    with Bmp.Canvas do
    begin
      Brush.Color := clWhite;
      FillRect(Rect(0, 0, Images.Width, Images.Height));
      ImageList_Draw(Images.Handle, Index, Handle, 0, 0, ILD_MASK);
    end;
    Bmp.Monochrome := True;
    if DrawHighlight then
    begin
      Canvas.Brush.Color := HighLightColor;
      SetTextColor(Canvas.Handle, clWhite);
      SetBkColor(Canvas.Handle, clBlack);
      BitBlt(Canvas.Handle, X + 1, Y + 1, Images.Width,
        Images.Height, Bmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
    end;
    Canvas.Brush.Color := GrayColor;
    SetTextColor(Canvas.Handle, clWhite);
    SetBkColor(Canvas.Handle, clBlack);
    BitBlt(Canvas.Handle, X, Y, Images.Width,
      Images.Height, Bmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
  finally
    Bmp.Free;
    Canvas.Brush.Color := SaveColor;
  end;
end;
{$ENDIF VCL}

{ Brush Pattern }

function CreateTwoColorsBrushPattern(Color1, Color2: TColor): TBitmap;
var
  X, Y: Integer;
begin
  Result := TBitmap.Create;
  Result.Width := 8;
  Result.Height := 8;
  with Result.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Color1;
    FillRect(Rect(0, 0, Result.Width, Result.Height));
    for Y := 0 to 7 do
      for X := 0 to 7 do
        if (Y mod 2) = (X mod 2) then { toggles between even/odd pixles }
          Pixels[X, Y] := Color2; { on even/odd rows }
  end;
end;

{ Icons }

function MakeIcon(ResID: PChar): TIcon;
begin
  Result := MakeModuleIcon(HInstance, ResID);
end;

function MakeIconID(ResID: Word): TIcon;
begin
  Result := MakeModuleIcon(HInstance, MakeIntResource(ResID));
end;

function MakeModuleIcon(Module: THandle; ResID: PChar): TIcon;
begin
  Result := TIcon.Create;
{$IFDEF VCL}
  Result.Handle := LoadIcon(Module, ResID);
  if Result.Handle = 0 then
  begin
    Result.Free;
    Result := nil;
  end;
{$ENDIF VCL}
{$IFDEF VisualCLX}
  try
    Result.LoadFromResourceName(HInstance, ResID);
  except
    Result.Free;
    Result := nil;
  end;
{$ENDIF VisualCLX}
end;

{ Create TBitmap object from TIcon }

function CreateBitmapFromIcon(Icon: TIcon; BackColor: TColor): TBitmap;
var
  IWidth, IHeight: Integer;
begin
  IWidth := Icon.Width;
  IHeight := Icon.Height;
  Result := TBitmap.Create;
  try
    Result.Width := IWidth;
    Result.Height := IHeight;
    with Result.Canvas do
    begin
      Brush.Color := BackColor;
      FillRect(Rect(0, 0, IWidth, IHeight));
      Draw(0, 0, Icon);
    end;
    Result.TransparentColor := BackColor;
    Result.Transparent := True;
  except
    Result.Free;
    raise;
  end;
end;

function CreateIconFromBitmap(Bitmap: TBitmap; TransparentColor: TColor): TIcon;
{$IFDEF VisualCLX}
var
  Bmp: TBitmap;
{$ENDIF}
begin
  with TImageList.CreateSize(Bitmap.Width, Bitmap.Height) do
  try
    if TransparentColor = clDefault then
      TransparentColor := Bitmap.TransparentColor;
{$IFDEF VCL}
    AllocBy := 1;
{$ENDIF}
    AddMasked(Bitmap, TransparentColor);
    Result := TIcon.Create;
    try
{$IFDEF VCL}
      GetIcon(0, Result);
{$ENDIF}
{$IFDEF VisualCLX}
      Bmp := TBitmap.Create;
      try
        GetBitmap(0, Bmp);
        Result.Assign(Bmp);
      finally
        Bmp.Free;
      end;
{$ENDIF}
    except
      Result.Free;
      raise;
    end;
  finally
    Free;
  end;
end;

type
  TJvHack = class(TCustomControl);

{
procedure NotImplemented;
begin
  Screen.Cursor := crDefault;
  MessageDlg(SNotImplemented, mtInformation, [mbOK], 0);
  SysUtils.Abort;
end;
}

{$IFDEF MSWINDOWS}

procedure PaintInverseRect(const RectOrg, RectEnd: TPoint);
var
  DC: HDC;
  r: TRect;
begin
  DC := GetDC(0);
  try
    r := Rect(RectOrg.X, RectOrg.Y, RectEnd.X, RectEnd.Y);
    InvertRect(DC, r);
  finally
    ReleaseDC(0, DC);
  end;
end;

procedure DrawInvertFrame(ScreenRect: TRect; Width: Integer);
var
  DC: HDC;
  i: Integer;
begin
  DC := GetDC(0);
  try
    for i := 1 to Width do
    begin
      DrawFocusRect(DC, ScreenRect);
      InflateRect(ScreenRect, -1, -1);
    end;
  finally
    ReleaseDC(0, DC);
  end;
end;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function PointInPolyRgn(const P: TPoint; const Points: array of TPoint):
  Boolean;
type
  PPoints = ^TPoints;
  TPoints = array[0..0] of TPoint;
var
  Rgn: HRGN;
begin
  Rgn := CreatePolygonRgn(PPoints(@Points)^, High(Points) + 1, WINDING);
  try
    Result := PtInRegion(Rgn, P.X, P.Y);
  finally
    DeleteObject(Rgn);
  end;
end;

function PaletteColor(Color: TColor): Longint;
begin
  Result := ColorToRGB(Color) or PaletteMask;
end;

{$IFDEF VCL}

function CreateRotatedFont(Font: TFont; Angle: Integer): HFONT;
var
  LogFont: TLogFont;
begin
  FillChar(LogFont, SizeOf(LogFont), 0);
  with LogFont do
  begin
    lfHeight := Font.Height;
    lfWidth := 0;
    lfEscapement := Angle * 10;
    lfOrientation := 0;
    if fsBold in Font.Style then
      lfWeight := FW_BOLD
    else
      lfWeight := FW_NORMAL;
    lfItalic := Ord(fsItalic in Font.Style);
    lfUnderline := Ord(fsUnderline in Font.Style);
    lfStrikeOut := byte(fsStrikeOut in Font.Style);
    lfCharSet := byte(Font.CharSet);
    if AnsiCompareText(Font.Name, 'Default') = 0 then
      StrPCopy(lfFaceName, DefFontData.Name)
    else
      StrPCopy(lfFaceName, Font.Name);
    lfQuality := DEFAULT_QUALITY;
    lfOutPrecision := OUT_TT_PRECIS;
    lfClipPrecision := CLIP_DEFAULT_PRECIS;
    case Font.Pitch of
      fpVariable:
        lfPitchAndFamily := VARIABLE_PITCH;
      fpFixed:
        lfPitchAndFamily := FIXED_PITCH;
    else
      lfPitchAndFamily := DEFAULT_PITCH;
    end;
  end;
  Result := CreateFontIndirect(LogFont);
end;
{$ENDIF VCL}

function PaletteEntries(Palette: HPALETTE): Integer;
begin
  GetObject(Palette, SizeOf(Integer), @Result);
end;
{$ENDIF MSWINDOWS}

procedure Delay(MSecs: Longint);
var
  FirstTickCount, Now: Longint;
begin
  FirstTickCount := GetTickCount;
  repeat
    Application.ProcessMessages;
    { allowing access to other controls, etc. }
    Now := GetTickCount;
  until (Now - FirstTickCount >= MSecs) or (Now < FirstTickCount);
end;

procedure CenterControl(Control: TControl);
var
  X, Y: Integer;
begin
  X := Control.Left;
  Y := Control.Top;
  if Control is TForm then
  begin
    with Control do
    begin
      if (TForm(Control).FormStyle = fsMDIChild) and
        (Application.MainForm <> nil) then
      begin
        X := (Application.MainForm.ClientWidth - Width) div 2;
        Y := (Application.MainForm.ClientHeight - Height) div 2;
      end
      else
      begin
        X := (Screen.Width - Width) div 2;
        Y := (Screen.Height - Height) div 2;
      end;
    end;
  end
  else
    if Control.Parent <> nil then
    begin
      with Control do
      begin
        Parent.HandleNeeded;
        X := (Parent.ClientWidth - Width) div 2;
        Y := (Parent.ClientHeight - Height) div 2;
      end;
    end;
  if X < 0 then
    X := 0;
  if Y < 0 then
    Y := 0;
  with Control do
    SetBounds(X, Y, Width, Height);
end;

procedure MergeForm(AControl: TWinControl; AForm: TForm; Align: TAlign;
  Show: Boolean);
var
  r: TRect;
  AutoScroll: Boolean;
begin
  AutoScroll := AForm.AutoScroll;
  AForm.Hide;
  TJvHack(AForm).DestroyHandle;
  with AForm do
  begin
    BorderStyle := {$IFDEF VCL}bsNone{$ELSE}fbsNone{$ENDIF};
    BorderIcons := [];
    Parent := AControl;
  end;
  AControl.DisableAlign;
  try
    if Align <> alNone then
      AForm.Align := Align
    else
    begin
      r := AControl.ClientRect;
      AForm.SetBounds(r.Left + AForm.Left, r.Top + AForm.Top, AForm.Width,
        AForm.Height);
    end;
    AForm.AutoScroll := AutoScroll;
    AForm.Visible := Show;
  finally
    AControl.EnableAlign;
  end;
end;

{$IFDEF MSWINDOWS}
{ ShowMDIClientEdge function has been copied from Inprise's FORMS.PAS unit,
  Delphi 4 version }

procedure ShowMDIClientEdge(ClientHandle: THandle; ShowEdge: Boolean);
var
  Style: Longint;
begin
  if ClientHandle <> 0 then
  begin
    Style := GetWindowLong(ClientHandle, GWL_EXSTYLE);
    if ShowEdge then
      if Style and WS_EX_CLIENTEDGE = 0 then
        Style := Style or WS_EX_CLIENTEDGE
      else
        Exit
    else
      if Style and WS_EX_CLIENTEDGE <> 0 then
        Style := Style and not WS_EX_CLIENTEDGE
      else
        Exit;
    SetWindowLong(ClientHandle, GWL_EXSTYLE, Style);
    SetWindowPos(ClientHandle, 0, 0, 0, 0, 0, SWP_FRAMECHANGED or SWP_NOACTIVATE
      or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);
  end;
end;
{$ENDIF}

{ Shade rectangle }

procedure ShadeRect(DC: HDC; const Rect: TRect);
const
  HatchBits: array[0..7] of Word = ($11, $22, $44, $88, $11, $22, $44, $88);
var
  Bitmap: HBITMAP;
  SaveBrush: HBRUSH;
  SaveTextColor, SaveBkColor: TColorRef;
begin
  Bitmap := CreateBitmap(8, 8, 1, 1, @HatchBits);
  SaveBrush := SelectObject(DC, CreatePatternBrush(Bitmap));
  try
    SaveTextColor := SetTextColor(DC, clWhite);
    SaveBkColor := SetBkColor(DC, clBlack);
    with Rect do
      PatBlt(DC, Left, Top, Right - Left, Bottom - Top, $00A000C9);
    SetBkColor(DC, SaveBkColor);
    SetTextColor(DC, SaveTextColor);
  finally
    DeleteObject(SelectObject(DC, SaveBrush));
    DeleteObject(Bitmap);
  end;
end;

function ScreenWorkArea: TRect;
begin
  if not SystemParametersInfo(SPI_GETWORKAREA, 0, @Result, 0) then
    with Screen do
      Result := Bounds(0, 0, Width, Height);
end;

{ Standard Windows MessageBox function }

function MsgBox(const Caption, Text: string; Flags: Integer): Integer;
{$IFDEF VisualCLX}
var
  mbs: TMessageButtons;
  def: TMessageButton;
  Style: TMessageStyle;
  DefFlags: Integer;
{$ENDIF}
begin
{$IFDEF VCL}
  Result := Application.MessageBox(PChar(Text), PChar(Caption), Flags);
{$ENDIF}
{$IFDEF VisualCLX}
  mbs := [];
  DefFlags := Flags and $00000F00;
  case Flags and $0000000F of
    MB_OK:
      begin
        mbs := [smbOk];
        def := smbOk;
      end;
    MB_OKCANCEL:
      begin
        mbs := [smbOk, smbCancel];
        def := smbOk;
        if DefFlags <> MB_DEFBUTTON1 then
          def := smbCancel;
      end;
    MB_ABORTRETRYIGNORE:
      begin
        mbs := [smbAbort, smbRetry, smbIgnore];
        def := smbAbort;
        case DefFlags of
          MB_DEFBUTTON2: def := smbRetry;
          MB_DEFBUTTON3: def := smbIgnore;
        end;
      end;
    MB_YESNOCANCEL:
      begin
        mbs := [smbYes, smbNo, smbCancel];
        def := smbYes;
        case DefFlags of
          MB_DEFBUTTON2: def := smbNo;
          MB_DEFBUTTON3: def := smbCancel;
        end;
      end;
    MB_YESNO:
      begin
        mbs := [smbYes, smbNo];
        def := smbYes;
        if DefFlags <> MB_DEFBUTTON1 then
          def := smbNo;
      end;
    MB_RETRYCANCEL:
      begin
        mbs := [smbRetry, smbCancel];
        def := smbRetry;
        if DefFlags <> MB_DEFBUTTON1 then
          def := smbCancel;
      end;
  else
    mbs := [smbOk];
    def := smbOk;
  end;

  case Flags and $000000F0 of
    MB_ICONWARNING: Style := smsWarning;
    MB_ICONERROR: Style := smsCritical;
  else
    Style := smsInformation;
  end;

  case Application.MessageBox(Text, Caption, mbs, Style, def) of
    smbOk: Result := IDOK;
    smbCancel: Result := IDCANCEL;
    smbAbort: Result := IDABORT;
    smbRetry: Result := IDRETRY;
    smbIgnore: Result := IDIGNORE;
    smbYes: Result := IDYES;
    smbNo: Result := IDNO;
  else
    Result := IDOK;
  end;
{$ENDIF}
end;

function MsgDlg(const Msg: string; AType: TMsgDlgType; AButtons: TMsgDlgButtons;
  HelpCtx: Longint): Word;
begin
  Result := MessageDlg(Msg, AType, AButtons, HelpCtx);
end;

{ Gradient fill procedure - displays a gradient beginning with a chosen    }
{ color and ending with another chosen color. Based on TGradientFill       }
{ component source code written by Curtis White, cwhite@teleport.com.      }

procedure GradientFillRect(Canvas: TCanvas; ARect: TRect; StartColor,
  EndColor: TColor; Direction: TFillDirection; Colors: byte);
var
  StartRGB: array[0..2] of byte; { Start RGB values }
  RGBDelta: array[0..2] of Integer;
    { Difference between start and end RGB values }
  ColorBand: TRect; { Color band rectangular coordinates }
  i, Delta: Integer;
{$IFDEF VCL}
  Brush: HBRUSH;
{$ENDIF VCL}
begin
  if IsRectEmpty(ARect) then
    Exit;
  if Colors < 2 then
  begin
{$IFDEF VCL}
    Brush := CreateSolidBrush(ColorToRGB(StartColor));
    FillRect(Canvas.Handle, ARect, Brush);
    DeleteObject(Brush);
{$ENDIF VCL}
{$IFDEF VisualCLX}
    Canvas.Brush.Color := StartColor;
    Canvas.FillRect(ARect);
{$ENDIF VisualCLX}
    Exit;
  end;
  StartColor := ColorToRGB(StartColor);
  EndColor := ColorToRGB(EndColor);
  case Direction of
    fdTopToBottom, fdLeftToRight:
      begin
        { Set the Red, Green and Blue colors }
        StartRGB[0] := GetRValue(StartColor);
        StartRGB[1] := GetGValue(StartColor);
        StartRGB[2] := GetBValue(StartColor);
        { Calculate the difference between begin and end RGB values }
        RGBDelta[0] := GetRValue(EndColor) - StartRGB[0];
        RGBDelta[1] := GetGValue(EndColor) - StartRGB[1];
        RGBDelta[2] := GetBValue(EndColor) - StartRGB[2];
      end;
    fdBottomToTop, fdRightToLeft:
      begin
        { Set the Red, Green and Blue colors }
        { Reverse of TopToBottom and LeftToRight directions }
        StartRGB[0] := GetRValue(EndColor);
        StartRGB[1] := GetGValue(EndColor);
        StartRGB[2] := GetBValue(EndColor);
        { Calculate the difference between begin and end RGB values }
        { Reverse of TopToBottom and LeftToRight directions }
        RGBDelta[0] := GetRValue(StartColor) - StartRGB[0];
        RGBDelta[1] := GetGValue(StartColor) - StartRGB[1];
        RGBDelta[2] := GetBValue(StartColor) - StartRGB[2];
      end;
  end;
  { Calculate the color band's coordinates }
  ColorBand := ARect;
  if Direction in [fdTopToBottom, fdBottomToTop] then
  begin
    Colors := Max(2, Min(Colors, RectHeight(ARect)));
    Delta := RectHeight(ARect) div Colors;
  end
  else
  begin
    Colors := Max(2, Min(Colors, RectWidth(ARect)));
    Delta := RectWidth(ARect) div Colors;
  end;
  with Canvas.Pen do
  begin { Set the pen style and mode }
    Style := psSolid;
    Mode := pmCopy;
  end;
  { Perform the fill }
  if Delta > 0 then
  begin
    for i := 0 to Colors do
    begin
      case Direction of
        { Calculate the color band's top and bottom coordinates }
        fdTopToBottom, fdBottomToTop:
          begin
            ColorBand.Top := ARect.Top + i * Delta;
            ColorBand.Bottom := ColorBand.Top + Delta;
          end;
        { Calculate the color band's left and right coordinates }
        fdLeftToRight, fdRightToLeft:
          begin
            ColorBand.Left := ARect.Left + i * Delta;
            ColorBand.Right := ColorBand.Left + Delta;
          end;
      end;
      { Calculate the color band's color }
{$IFDEF VCL}
      Brush := CreateSolidBrush(RGB(
        StartRGB[0] + MulDiv(i, RGBDelta[0], Colors - 1),
        StartRGB[1] + MulDiv(i, RGBDelta[1], Colors - 1),
        StartRGB[2] + MulDiv(i, RGBDelta[2], Colors - 1)));
      FillRect(Canvas.Handle, ColorBand, Brush);
      DeleteObject(Brush);
{$ENDIF VCL}
{$IFDEF VisualCLX}
      Canvas.Brush.Color := RGB(
        StartRGB[0] + MulDiv(i, RGBDelta[0], Colors - 1),
        StartRGB[1] + MulDiv(i, RGBDelta[1], Colors - 1),
        StartRGB[2] + MulDiv(i, RGBDelta[2], Colors - 1));
      Canvas.FillRect(ColorBand);
{$ENDIF VisualCLX}
    end;
  end;
  if Direction in [fdTopToBottom, fdBottomToTop] then
    Delta := RectHeight(ARect) mod Colors
  else
    Delta := RectWidth(ARect) mod Colors;
  if Delta > 0 then
  begin
    case Direction of
      { Calculate the color band's top and bottom coordinates }
      fdTopToBottom, fdBottomToTop:
        begin
          ColorBand.Top := ARect.Bottom - Delta;
          ColorBand.Bottom := ColorBand.Top + Delta;
        end;
      { Calculate the color band's left and right coordinates }
      fdLeftToRight, fdRightToLeft:
        begin
          ColorBand.Left := ARect.Right - Delta;
          ColorBand.Right := ColorBand.Left + Delta;
        end;
    end;
{$IFDEF VCL}
    case Direction of
      fdTopToBottom, fdLeftToRight:
        Brush := CreateSolidBrush(EndColor);
    else {fdBottomToTop, fdRightToLeft }
      Brush := CreateSolidBrush(StartColor);
    end;
    FillRect(Canvas.Handle, ColorBand, Brush);
    DeleteObject(Brush);
{$ENDIF VCL}
{$IFDEF VisualCLX}
    case Direction of
      fdTopToBottom, fdLeftToRight:
        Canvas.Brush.Color := EndColor;
    else {fdBottomToTop, fdRightToLeft }
      Canvas.Brush.Color := StartColor;
    end;
    Canvas.FillRect(ColorBand);
{$ENDIF VisualCLX}
  end;
end;

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  i: Integer;
  Buffer: array[0..51] of char;
begin
  for i := 0 to 25 do
    Buffer[i] := Chr(i + Ord('A'));
  for i := 0 to 25 do
    Buffer[i + 26] := Chr(i + Ord('a'));
{$IFDEF VisualCLX}
  Result.X := Canvas.TextWidth(Buffer);
  Result.Y := Canvas.TextHeight(Buffer);
{$ENDIF}
{$IFDEF VCL}
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
{$ENDIF}
  Result.X := Result.X div 52;
end;

{ Cursor routines }

{$IFDEF MSWINDOWS}

function LoadAniCursor(Instance: THandle; ResID: PChar): HCURSOR;
{ Unfortunately I don't know how we can load animated cursor from
  executable resource directly. So I write this routine using temporary
  file and LoadCursorFromFile function. }
var
  s: TFileStream;
  Path, FileName: array[0..MAX_PATH] of char;
  RSrc: HRSRC;
  Res: THandle;
  Data: Pointer;
begin
  Integer(Result) := 0;
  RSrc := FindResource(Instance, ResID, RT_ANICURSOR);
  if RSrc <> 0 then
  begin
    OSCheck(GetTempPath(MAX_PATH, Path) <> 0);
    OSCheck(GetTempFileName(Path, 'ANI', 0, FileName) <> 0);
    try
      Res := LoadResource(Instance, RSrc);
      try
        Data := LockResource(Res);
        if Data <> nil then
        try
          s := TFileStream.Create(StrPas(FileName), fmCreate);
          try
            s.WriteBuffer(Data^, SizeOfResource(Instance, RSrc));
          finally
            s.Free;
          end;
          Result := LoadCursorFromFile(FileName);
        finally
          UnlockResource(Res);
        end;
      finally
        FreeResource(Res);
      end;
    finally
      Windows.DeleteFile(FileName);
    end;
  end;
end;
{$ENDIF MSWINDOWS}

function GetNextFreeCursorIndex(StartHint: Integer; PreDefined: Boolean):
  Integer;
begin
  Result := StartHint;
  if PreDefined then
  begin
    if Result >= crSizeAll then Result := crSizeAll - 1;
  end
  else
    if Result <= crDefault then
      Result := crDefault + 1;
  while (Screen.Cursors[Result] <> Screen.Cursors[crDefault]) do
  begin
    if PreDefined then
      Dec(Result)
    else
      Inc(Result);
    if (Result < Low(TCursor)) or (Result > High(TCursor)) then
      raise EOutOfResources.Create(SOutOfResources);
  end;
end;

function DefineCursor(Instance: THandle; ResID: PChar): TCursor;
var
  Handle: HCURSOR;
begin
  Handle := LoadCursor(Instance, ResID);
{$IFDEF VCL}
  if Handle = 0 then
    Handle := LoadAniCursor(Instance, ResID);
{$ENDIF}
  if Integer(Handle) = 0 then
    ResourceNotFound(ResID);
  try
    Result := GetNextFreeCursorIndex(crJVCLFirst, False);
    Screen.Cursors[Result] := Handle;
  except
{$IFDEF VCL}
    DestroyCursor(Handle);
{$ENDIF}
    raise;
  end;
end;

// (rom) changed to var
var
  WaitCount: Integer = 0;
  SaveCursor: TCursor = crDefault;

const
  FWaitCursor: TCursor = crHourGlass;

procedure StartWait;
begin
  if WaitCount = 0 then
  begin
    SaveCursor := Screen.Cursor;
    Screen.Cursor := FWaitCursor;
  end;
  Inc(WaitCount);
end;

procedure StopWait;
begin
  if WaitCount > 0 then
  begin
    Dec(WaitCount);
    if WaitCount = 0 then
      Screen.Cursor := SaveCursor;
  end;
end;

function WaitCursor: IInterface;
begin
  Result := ScreenCursor(crHourGlass);
end;

function ScreenCursor(ACursor: TCursor): IInterface;
begin
  Result := TWaitCursor.Create(ACursor);
end;

function LoadOLEDragCursors: Boolean;
const
  cOle32DLL: PChar = 'ole32.dll';
var
  Handle: Cardinal;
begin
  Result := False;
  Handle := GetModuleHandle(cOle32DLL);
  if Handle = 0 then
    Handle := LoadLibraryEx(cOle32DLL, 0, LOAD_LIBRARY_AS_DATAFILE);
  if Handle <> 0 then // (p3) don't free the lib handle!
  begin
    Screen.Cursors[crNoDrop] := LoadCursor(Handle, PChar(1));
    Screen.Cursors[crDrag] := LoadCursor(Handle, PChar(2));
    Screen.Cursors[crMultiDrag] := LoadCursor(Handle, PChar(3));
    Screen.Cursors[crMultiDragLink] := LoadCursor(Handle, PChar(4));
    Screen.Cursors[crDragAlt] := LoadCursor(Handle, PChar(5));
    Screen.Cursors[crMultiDragAlt] := LoadCursor(Handle, PChar(6));
    Screen.Cursors[crMultiDragLinkAlt] := LoadCursor(Handle, PChar(7));
    Result := True;
  end;
end;

{ Grid drawing }

// (rom) changed to var
var
  DrawBitmap: TBitmap = nil;

procedure UsesBitmap;
begin
  if DrawBitmap = nil then
    DrawBitmap := TBitmap.Create;
end;

procedure ReleaseBitmap;
begin
  if DrawBitmap <> nil then
    DrawBitmap.Free;
  DrawBitmap := nil;
end;

procedure WriteText(ACanvas: TCanvas; ARect: TRect; DX, DY: Integer;
  const Text: string; Alignment: TAlignment; WordWrap: Boolean; ARightToLeft:
    Boolean = False);
const
  AlignFlags: array[TAlignment] of Integer =
  (DT_LEFT or DT_EXPANDTABS or DT_NOPREFIX,
    DT_RIGHT or DT_EXPANDTABS or DT_NOPREFIX,
    DT_CENTER or DT_EXPANDTABS or DT_NOPREFIX);
  WrapFlags: array[Boolean] of Integer = (0, DT_WORDBREAK);
{$IFDEF VCL}
  RTL: array[Boolean] of Integer = (0, DT_RTLREADING);
var
  b, r: TRect;
  i, Left: Integer;
begin
  UsesBitmap;
  i := ColorToRGB(ACanvas.Brush.Color);
  if not WordWrap and (Integer(GetNearestColor(ACanvas.Handle, i)) = i) and
    (Pos(#13, Text) = 0) then
  begin { Use ExtTextOut for solid colors }
    { In BiDi, because we changed the window origin, the text that does not
    change alignment, actually gets its alignment changed. }
    if (ACanvas.CanvasOrientation = coRightToLeft) and (not ARightToLeft) then
      ChangeBiDiModeAlignment(Alignment);
    case Alignment of
      taLeftJustify:
        Left := ARect.Left + DX;
      taRightJustify:
        Left := ARect.Right - ACanvas.TextWidth(Text) - 3;
    else { taCenter }
      Left := ARect.Left + (ARect.Right - ARect.Left) shr 1
        - (ACanvas.TextWidth(Text) shr 1);
    end;
    ACanvas.TextRect(ARect, Left, ARect.Top + DY, Text);
  end
  else
  begin { Use FillRect and DrawText for dithered colors }
    DrawBitmap.Canvas.Lock;
    try
      with DrawBitmap, ARect do { Use offscreen bitmap to eliminate flicker and }
      begin { brush origin tics in painting / scrolling.    }
        Width := Max(Width, Right - Left);
        Height := Max(Height, Bottom - Top);
        r := Rect(DX, DY, Right - Left - 1,
          Bottom - Top - 1);
        b := Rect(0, 0, Right - Left, Bottom - Top);
      end;
      with DrawBitmap.Canvas do
      begin
        Font := ACanvas.Font;
        Font.Color := ACanvas.Font.Color;
        Brush := ACanvas.Brush;
        Brush.Style := bsSolid;
        FillRect(b);
        SetBkMode(Handle, Transparent);
        if (ACanvas.CanvasOrientation = coRightToLeft) then
          ChangeBiDiModeAlignment(Alignment);
        DrawText(Handle, PChar(Text), Length(Text), r, AlignFlags[Alignment]
          or RTL[ARightToLeft] or WrapFlags[WordWrap]);
      end;
      ACanvas.CopyRect(ARect, DrawBitmap.Canvas, b);
    finally
      DrawBitmap.Canvas.Unlock;
    end;
  end;
end;
{$ENDIF VCL}
{$IFDEF VisualCLX}
begin
  ACanvas.TextRect(ARect, ARect.Left + DX, ARect.Top + DY,
    Text, AlignFlags[Alignment] or WrapFlags[WordWrap]);
end;
{$ENDIF VisualCLX}

procedure DrawCellTextEx(Control: TCustomControl; ACol, ARow: Longint;
  const s: string; const ARect: TRect; Align: TAlignment;
  VertAlign: TVertAlignment; WordWrap: Boolean; ARightToLeft: Boolean);
    overload;
const
  MinOffs = 2;
var
  h: Integer;
begin
  case VertAlign of
    vaTopJustify:
      h := MinOffs;
    vaCenter:
      with TJvHack(Control) do
        h := Max(1, (ARect.Bottom - ARect.Top -
          Canvas.TextHeight('W')) div 2);
  else {vaBottomJustify}
    begin
      with TJvHack(Control) do
        h := Max(MinOffs, ARect.Bottom - ARect.Top -
          Canvas.TextHeight('W'));
    end;
  end;
  WriteText(TJvHack(Control).Canvas, ARect, MinOffs, h, s, Align, WordWrap,
    ARightToLeft);
end;

procedure DrawCellText(Control: TCustomControl; ACol, ARow: Longint;
  const s: string; const ARect: TRect; Align: TAlignment;
  VertAlign: TVertAlignment; ARightToLeft: Boolean); overload;
begin
  DrawCellTextEx(Control, ACol, ARow, s, ARect, Align, VertAlign,
    Align = taCenter, ARightToLeft);
end;

procedure DrawCellTextEx(Control: TCustomControl; ACol, ARow: Longint;
  const s: string; const ARect: TRect; Align: TAlignment;
  VertAlign: TVertAlignment; WordWrap: Boolean); overload;
const
  MinOffs = 2;
var
  h: Integer;
begin
  case VertAlign of
    vaTopJustify:
      h := MinOffs;
    vaCenter:
      with TJvHack(Control) do
        h := Max(1, (ARect.Bottom - ARect.Top -
          Canvas.TextHeight('W')) div 2);
  else {vaBottomJustify}
    begin
      with TJvHack(Control) do
        h := Max(MinOffs, ARect.Bottom - ARect.Top -
          Canvas.TextHeight('W'));
    end;
  end;
  WriteText(TJvHack(Control).Canvas, ARect, MinOffs, h, s, Align, WordWrap);
end;

procedure DrawCellText(Control: TCustomControl; ACol, ARow: Longint;
  const s: string; const ARect: TRect; Align: TAlignment;
  VertAlign: TVertAlignment); overload;
begin
  DrawCellTextEx(Control, ACol, ARow, s, ARect, Align, VertAlign,
    Align = taCenter);
end;

procedure DrawCellBitmap(Control: TCustomControl; ACol, ARow: Longint;
  Bmp: TGraphic; Rect: TRect);
begin
  Rect.Top := (Rect.Bottom + Rect.Top - Bmp.Height) div 2;
  Rect.Left := (Rect.Right + Rect.Left - Bmp.Width) div 2;
  TJvHack(Control).Canvas.Draw(Rect.Left, Rect.Top, Bmp);
end;

{$IFDEF VCL}

destructor TJvScreenCanvas.Destroy;
begin
  FreeHandle;
  inherited Destroy;
end;

procedure TJvScreenCanvas.CreateHandle;
begin
  if FDeviceContext = 0 then
    FDeviceContext := GetDC(0);
  Handle := FDeviceContext;
end;

procedure TJvScreenCanvas.FreeHandle;
begin
  if FDeviceContext <> 0 then
  begin
    Handle := 0;
    ReleaseDC(0, FDeviceContext);
    FDeviceContext := 0;
  end;
end;

procedure TJvScreenCanvas.SetOrigin(X, Y: Integer);
var
  FOrigin: TPoint;
begin
  SetWindowOrgEx(Handle, -X, -Y, @FOrigin);
end;
{$ENDIF VCL}

// (rom) moved to file end to minimize W- switch impact at end of function

{ end JvVCLUtils }
{ begin JvUtils }

function FindByTag(WinControl: TWinControl; ComponentClass: TComponentClass;
  const Tag: Integer): TComponent;
var
  i: Integer;
begin
  for i := 0 to WinControl.ControlCount - 1 do
  begin
    Result := WinControl.Controls[i];
    if (Result is ComponentClass) and (Result.Tag = Tag) then
      Exit;
  end;
  Result := nil;
end;

function ControlAtPos2(Parent: TWinControl; X, Y: Integer): TControl;
var
  i: Integer;
  P: TPoint;
begin
  P := Point(X, Y);
  for i := Parent.ControlCount - 1 downto 0 do
  begin
    Result := Parent.Controls[i];
    with Result do
      if PtInRect(BoundsRect, P) then
        Exit;
  end;
  Result := nil;
end;

function RBTag(Parent: TWinControl): Integer;
var
  RB: TRadioButton;
  i: Integer;
begin
  RB := nil;
  with Parent do
    for i := 0 to ControlCount - 1 do
      if (Controls[i] is TRadioButton) and
        (Controls[i] as TRadioButton).Checked then
      begin
        RB := Controls[i] as TRadioButton;
        break;
      end;
  if RB <> nil then
    Result := RB.Tag
  else
    Result := 0;
end;

function FindFormByClass(FormClass: TFormClass): TForm;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Application.ComponentCount - 1 do
    if Application.Components[i].ClassName = FormClass.ClassName then
    begin
      Result := Application.Components[i] as TForm;
      break;
    end;
end;

function FindFormByClassName(FormClassName: string): TForm;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Application.ComponentCount - 1 do
    if Application.Components[i].ClassName = FormClassName then
    begin
      Result := Application.Components[i] as TForm;
      break;
    end;
end;

function AppMinimized: Boolean;
begin
{$IFDEF VCL}
  Result := IsIconic(Application.Handle);
{$ENDIF}
{$IFDEF VisualCLX}
  Result := QWidget_isMinimized(Application.AppWidget);
{$ENDIF}
end;

{$IFDEF VCL}

function MessageBox(const Msg: string; Caption: string; const Flags: Integer):
  Integer;
begin
  if Caption = '' then
    Caption := Application.Title;
  Result := Application.MessageBox(PChar(Msg), PChar(Caption), Flags);
end;

const
  NoHelp = 0; { for MsgDlg2 }
  MsgDlgCharSet: Integer = DEFAULT_CHARSET;

function MsgDlgDef1(const Msg, ACaption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; DefButton: TMsgDlgBtn; UseDefButton: Boolean;
  AHelpContext: Integer; Control: TWinControl): Integer;
const
  ButtonNames: array[TMsgDlgBtn] of PChar =
  ('Yes', 'No', 'OK', 'Cancel', 'Abort', 'Retry', 'Ignore', 'All', 'NoToAll',
    'YesToAll', 'Help');
var
  P: TPoint;
  i: Integer;
  Btn: TButton;
  StayOnTop: Boolean;
begin
  if AHelpContext <> 0 then
    Buttons := Buttons + [mbHelp];
  StayOnTop := False;
  with CreateMessageDialog(Msg, DlgType, Buttons) do
  try
    Font.CharSet := MsgDlgCharSet;
    if (Screen.ActiveForm <> nil) and
      (Screen.ActiveForm.FormStyle = fsStayOnTop) then
    begin
      StayOnTop := True;
      SetWindowTop(Screen.ActiveForm.Handle, False);
    end;
    if ACaption <> '' then
      Caption := ACaption;
    if Control = nil then
    begin
      Left := (Screen.Width - Width) div 2;
      Top := (Screen.Height - Height) div 2;
    end
    else
    begin
      P := Point((Control.Width - Width) div 2,
        (Control.Height - Height) div 2);
      P := Control.ClientToScreen(P);
      Left := P.X;
      Top := P.Y
    end;
    if Left < 0 then
      Left := 0
    else
      if Left > Screen.Width then
        Left := Screen.Width - Width;
    if Top < 0 then
      Top := 0
    else
      if Top > Screen.Height then
        Top := Screen.Height - Height;
    HelpContext := AHelpContext;

    Btn := FindComponent(ButtonNames[DefButton]) as TButton;
    if UseDefButton and (Btn <> nil) then
    begin
      for i := 0 to ComponentCount - 1 do
        if Components[i] is TButton then
          (Components[i] as TButton).Default := False;
      Btn.Default := True;
      ActiveControl := Btn;
    end;
    Btn := FindComponent(ButtonNames[mbIgnore]) as TButton;
    if Btn <> nil then
    begin
      // Btn.Width := Btn.Width * 5 div 4; {To shift the Help button Help [translated] }
    end;
    Result := ShowModal;
  finally
    Free;
    if (Screen.ActiveForm <> nil) and StayOnTop then
      SetWindowTop(Screen.ActiveForm.Handle, True);
  end;
end;

function MsgDlgDef(const Msg, ACaption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; DefButton: TMsgDlgBtn; HelpContext: Integer;
  Control: TWinControl): Integer;
begin
  Result := MsgDlgDef1(Msg, ACaption, DlgType, Buttons, DefButton, True,
    HelpContext, Control);
end;

function MsgDlg2(const Msg, ACaption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpContext: Integer;
  Control: TWinControl): Integer;
begin
  Result := MsgDlgDef1(Msg, ACaption, DlgType, Buttons, mbHelp, False,
    HelpContext, Control);
end;

procedure LoadIcoToImage(ALarge, ASmall: TCustomImageList; const NameRes:
  string);
var
  Ico: TIcon;
begin
  Ico := TIcon.Create;
  if ALarge <> nil then
  begin
    Ico.Handle := LoadImage(HInstance, PChar(NameRes), IMAGE_ICON, 32, 32, 0);
    ALarge.AddIcon(Ico);
  end;
  if ASmall <> nil then
  begin
    Ico.Handle := LoadImage(HInstance, PChar(NameRes), IMAGE_ICON, 16, 16, 0);
    ASmall.AddIcon(Ico);
  end;
  Ico.Free;
end;
{$ENDIF VCL}

procedure CenterHor(Parent: TControl; MinLeft: Integer; Controls: array of
  TControl);
var
  i: Integer;
begin
  for i := Low(Controls) to High(Controls) do
    Controls[i].Left := Max(MinLeft, (Parent.Width - Controls[i].Width) div 2)
end;

procedure EnableControls(Control: TWinControl; const Enable: Boolean);
var
  i: Integer;
begin
  for i := 0 to Control.ControlCount - 1 do
    Control.Controls[i].Enabled := Enable;
end;

procedure EnableMenuItems(MenuItem: TMenuItem; const Tag: Integer; const Enable:
  Boolean);
var
  i: Integer;
begin
  for i := 0 to MenuItem.Count - 1 do
    if MenuItem[i].Tag <> Tag then
      MenuItem[i].Enabled := Enable;
end;

procedure ExpandWidth(Parent: TControl; MinWidth: Integer; Controls: array of
  TControl);
var
  i: Integer;
begin
  for i := Low(Controls) to High(Controls) do
    Controls[i].Width := Max(MinWidth, Parent.ClientWidth - 2 *
      Controls[i].Left);
end;

function PanelBorder(Panel: TCustomPanel): Integer;
begin
  Result := TPanel(Panel).BorderWidth;
  if TPanel(Panel).BevelOuter <> bvNone then
    Inc(Result, TPanel(Panel).BevelWidth);
  if TPanel(Panel).BevelInner <> bvNone then
    Inc(Result, TPanel(Panel).BevelWidth);
end;

function Pixels(Control: TControl; APixels: Integer): Integer;
var
  Form: TForm;
begin
  Result := APixels;
  if Control is TForm then
    Form := TForm(Control)
  else
    Form := TForm(GetParentForm(Control));
  if Form.Scaled then
    Result := Result * Form.PixelsPerInch div 96;
end;

procedure ShowMenu(Form: TForm; MenuAni: TMenuAnimation);
var
  i: Integer;
  h: Integer;
  w: Integer;
begin
  case MenuAni of
    maNone:
      Form.Show;
    maRandom:
      ;
    maUnfold:
      begin
        h := Form.Height;
        Form.Height := 0;
        Form.Show;
        for i := 0 to h div 10 do
          if Form.Height < h then
            Form.Height := Form.Height + 10;
      end;
    maSlide:
      begin
        h := Form.Height;
        w := Form.Width;
        Form.Height := 0;
        Form.Width := 0;
        Form.Show;
        for i := 0 to Max(h div 5, w div 5) do
        begin
          if Form.Height < h then
            Form.Height := Form.Height + 5;
          if Form.Width < w then
            Form.Width := Form.Width + 5;
        end;
        //      CS_SAVEBITS
      end;
  end;
end;

{$IFDEF MSWINDOWS}

function TargetFileName(const FileName: TFileName): TFileName;
begin
  Result := FileName;
  if CompareText(ExtractFileExt(FileName), '.lnk') = 0 then
{$IFDEF VCL}
    if ResolveLink(Application.Handle, FileName, Result) <> 0 then
{$ENDIF}
{$IFDEF VisualCLX}
      if ResolveLink(QWidget_winId(Application.AppWidget), FileName, Result) <> 0
        then
{$ENDIF}
        raise Exception.CreateFmt(SCantGetShortCut, [FileName]);
end;

function ResolveLink(const HWND: HWND; const LinkFile: TFileName;
  var FileName: TFileName): HRESULT;
var
  psl: IShellLink;
  WLinkFile: array[0..MAX_PATH] of WideChar;
  wfd: TWin32FindData;
  ppf: IPersistFile;
begin
  Pointer(psl) := nil;
  Pointer(ppf) := nil;
  Result := CoInitialize(nil);
  if Succeeded(Result) then
  begin
    // Get a Pointer to the IShellLink interface.
    Result := CoCreateInstance(CLSID_ShellLink, nil,
      CLSCTX_INPROC_SERVER, IShellLink, psl);
    if Succeeded(Result) then
    begin

      // Get a Pointer to the IPersistFile interface.
      Result := psl.QueryInterface(IPersistFile, ppf);
      if Succeeded(Result) then
      begin
        StringToWideChar(LinkFile, WLinkFile, SizeOf(WLinkFile) - 1);
        // Load the shortcut.
        Result := ppf.Load(WLinkFile, STGM_READ);
        if Succeeded(Result) then
        begin
          // Resolve the link.
          Result := psl.Resolve(HWND, SLR_ANY_MATCH);
          if Succeeded(Result) then
          begin
            // Get the path to the link target.
            SetLength(FileName, MAX_PATH);
            Result := psl.GetPath(PChar(FileName), MAX_PATH, wfd,
              SLGP_UNCPRIORITY);
            if not Succeeded(Result) then
              Exit;
            SetLength(FileName, Length(PChar(FileName)));
          end;
        end;
        // Release the Pointer to the IPersistFile interface.
        ppf._Release;
      end;
      // Release the Pointer to the IShellLink interface.
      psl._Release;
    end;
    CoUninitialize;
  end;
  Pointer(psl) := nil;
  Pointer(ppf) := nil;
end;

var
  ProcList: TList = nil;
type
  TJvProcItem = class(TObject)
  private
    FProcObj: TProcObj;
  public
    constructor Create(AProcObj: TProcObj);
  end;

constructor TJvProcItem.Create(AProcObj: TProcObj);
begin
  FProcObj := AProcObj;
end;

procedure TmrProc(HWND: HWND; uMsg: Integer; idEvent: Integer; dwTime: Integer);
  stdcall;
var
  Pr: TProcObj;
begin
  if ProcList[idEvent] <> nil then
  begin
    Pr := TJvProcItem(ProcList[idEvent]).FProcObj;
    TJvProcItem(ProcList[idEvent]).Free;
  end
  else
    Pr := nil;
  ProcList.Delete(idEvent);
  KillTimer(HWND, idEvent);
  if ProcList.Count <= 0 then
  begin
    ProcList.Free;
    ProcList := nil;
  end;
  if Assigned(Pr) then
    Pr;
end;

procedure ExecAfterPause(Proc: TProcObj; Pause: Integer);
var
  Num: Integer;
  i: Integer;
begin
  if ProcList = nil then
    ProcList := TList.Create;
  Num := -1;
  for i := 0 to ProcList.Count - 1 do
    if @TJvProcItem(ProcList[i]).FProcObj = @Proc then
    begin
      Num := i;
      break;
    end;
  if Num <> -1 then
{$IFDEF VCL}
    KillTimer(Application.Handle, Num)
{$ENDIF}
{$IFDEF VisualCLX}
    KillTimer(QWidget_winId(Application.AppWidget), Num)
{$ENDIF}
  else
    Num := ProcList.Add(TJvProcItem.Create(Proc));
{$IFDEF VCL}
  SetTimer(Application.Handle, Num, Pause, @TmrProc);
{$ENDIF}
{$IFDEF VisualCLX}
  SetTimer(QWidget_winId(Application.AppWidget), Num, Pause, @TmrProc);
{$ENDIF}
end;
{$ENDIF MSWINDOWS}

{ end JvUtils }

{ begin JvApputils }

function GetDefaultSection(Component: TComponent): string;
var
  F: TCustomForm;
  Owner: TComponent;
begin
  if Component <> nil then
  begin
    if Component is TCustomForm then
      Result := Component.ClassName
    else
    begin
      Result := Component.Name;
      if Component is TControl then
      begin
        F := GetParentForm(TControl(Component));
        if F <> nil then
          Result := F.ClassName + Result
        else
        begin
          if TControl(Component).Parent <> nil then
            Result := TControl(Component).Parent.Name + Result;
        end;
      end
      else
      begin
        Owner := Component.Owner;
        if Owner is TForm then
          Result := Format('%s.%s', [Owner.ClassName, Result]);
      end;
    end;
  end
  else
    Result := '';
end;

function GetDefaultIniName: string;
begin
  if Assigned(OnGetDefaultIniName) then
    Result := OnGetDefaultIniName
  else
{$IFDEF LINUX}
    Result := GetEnvironmentVariable('HOME') + PathDelim +
      '.' + ExtractFileName(Application.ExeName);
{$ENDIF}
{$IFDEF WINDOWS}
  Result := ExtractFileName(ChangeFileExt(Application.ExeName, '.ini'));
{$ENDIF}
end;

function GetDefaultIniRegKey: string;
begin
  if RegUseAppTitle and (Application.Title <> '') then
    Result := Application.Title
  else
    Result := ExtractFileName(ChangeFileExt(Application.ExeName, ''));
  if DefCompanyName <> '' then
    Result := DefCompanyName + '\' + Result;
  Result := 'Software\' + Result;
end;

function FindForm(FormClass: TFormClass): TForm;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Screen.FormCount - 1 do
  begin
    if Screen.Forms[i] is FormClass then
    begin
      Result := Screen.Forms[i];
      break;
    end;
  end;
end;

function InternalFindShowForm(FormClass: TFormClass;
  const Caption: string; Restore: Boolean): TForm;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Screen.FormCount - 1 do
  begin
    if Screen.Forms[i] is FormClass then
      if (Caption = '') or (Caption = Screen.Forms[i].Caption) then
      begin
        Result := Screen.Forms[i];
        break;
      end;
  end;
  if Result = nil then
  begin
    Application.CreateForm(FormClass, Result);
    if Caption <> '' then
      Result.Caption := Caption;
  end;
  with Result do
  begin
    if Restore and (WindowState = wsMinimized) then
      WindowState := wsNormal;
    Show;
  end;
end;

function FindShowForm(FormClass: TFormClass; const Caption: string): TForm;
begin
  Result := InternalFindShowForm(FormClass, Caption, True);
end;

function ShowDialog(FormClass: TFormClass): Boolean;
var
  Dlg: TForm;
begin
  Application.CreateForm(FormClass, Dlg);
  try
    Result := Dlg.ShowModal in [mrOK, mrYes];
  finally
    Dlg.Free;
  end;
end;

function InstantiateForm(FormClass: TFormClass; var Reference): TForm;
begin
  if TForm(Reference) = nil then
    Application.CreateForm(FormClass, Reference);
  Result := TForm(Reference);
end;

// (rom) use StrStringToEscaped, StrEscapedToString from JclStrings.pas

function StrToIniStr(const Str: string): string;
var
  N: Integer;
begin
  Result := Str;
  repeat
    N := Pos(CRLF, Result);
    if N > 0 then
      Result := Copy(Result, 1, N - 1) + '\n' + Copy(Result, N + 2,
        Length(Result));
  until N = 0;
  repeat
    N := Pos(#10#13, Result);
    if N > 0 then
      Result := Copy(Result, 1, N - 1) + '\n' + Copy(Result, N + 2,
        Length(Result));
  until N = 0;
end;

function IniStrToStr(const Str: string): string;
var
  N: Integer;
begin
  Result := Str;
  repeat
    N := Pos('\n', Result);
    if N > 0 then
      Result := Copy(Result, 1, N - 1) + CRLF + Copy(Result, N + 2,
        Length(Result));
  until N = 0;
end;

{ The following strings should not be localized }
const
  siFlags = 'Flags';
  siShowCmd = 'ShowCmd';
  siMinMaxPos = 'MinMaxPos';
  siNormPos = 'NormPos';
  siPixels = 'PixelsPerInch';
  siMDIChild = 'MDI Children';
  siListCount = 'Count';
  siItem = 'Item%d';

function IniReadString(IniFile: TObject; const Section, Ident,
  Default: string): string;
begin
{$IFDEF MSWINDOWS}
  if IniFile is TRegIniFile then
    Result := TRegIniFile(IniFile).ReadString(Section, Ident, Default)
  else
{$ENDIF}
    if IniFile is TCustomIniFile then
      Result := TCustomIniFile(IniFile).ReadString(Section, Ident, Default)
    else
      Result := Default;
end;

procedure IniWriteString(IniFile: TObject; const Section, Ident,
  Value: string);
var
  s: string;
begin
{$IFDEF MSWINDOWS}
  if IniFile is TRegIniFile then
    TRegIniFile(IniFile).WriteString(Section, Ident, Value)
  else
{$ENDIF}
  begin
    s := Value;
    if s <> '' then
    begin
      if ((s[1] = '"') and (s[Length(s)] = '"')) or
      ((s[1] = '''') and (s[Length(s)] = '''')) then
        s := '"' + s + '"';
    end;
    if IniFile is TCustomIniFile then
      TCustomIniFile(IniFile).WriteString(Section, Ident, s);
  end;
end;

function IniReadInteger(IniFile: TObject; const Section, Ident: string;
  Default: Longint): Longint;
begin
{$IFDEF MSWINDOWS}
  if IniFile is TRegIniFile then
    Result := TRegIniFile(IniFile).ReadInteger(Section, Ident, Default)
  else
{$ENDIF}
    if IniFile is TCustomIniFile then
      Result := TCustomIniFile(IniFile).ReadInteger(Section, Ident, Default)
    else
      Result := Default;
end;

procedure IniWriteInteger(IniFile: TObject; const Section, Ident: string;
  Value: Longint);
begin
{$IFDEF MSWINDOWS}
  if IniFile is TRegIniFile then
    TRegIniFile(IniFile).WriteInteger(Section, Ident, Value)
  else
{$ENDIF}
    if IniFile is TCustomIniFile then
      TCustomIniFile(IniFile).WriteInteger(Section, Ident, Value);
end;

function IniReadBool(IniFile: TObject; const Section, Ident: string;
  Default: Boolean): Boolean;
begin
{$IFDEF MSWINDOWS}
  if IniFile is TRegIniFile then
    Result := TRegIniFile(IniFile).ReadBool(Section, Ident, Default)
  else
{$ENDIF}
    if IniFile is TCustomIniFile then
      Result := TCustomIniFile(IniFile).ReadBool(Section, Ident, Default)
    else
      Result := Default;
end;

procedure IniWriteBool(IniFile: TObject; const Section, Ident: string;
  Value: Boolean);
begin
{$IFDEF MSWINDOWS}
  if IniFile is TRegIniFile then
    TRegIniFile(IniFile).WriteBool(Section, Ident, Value)
  else
{$ENDIF}
    if IniFile is TCustomIniFile then
      TCustomIniFile(IniFile).WriteBool(Section, Ident, Value);
end;

procedure IniEraseSection(IniFile: TObject; const Section: string);
begin
{$IFDEF MSWINDOWS}
  if IniFile is TRegIniFile then
    TRegIniFile(IniFile).EraseSection(Section)
  else
{$ENDIF}
    if IniFile is TCustomIniFile then
      TCustomIniFile(IniFile).EraseSection(Section);
end;

procedure IniDeleteKey(IniFile: TObject; const Section, Ident: string);
begin
{$IFDEF MSWINDOWS}
  if IniFile is TRegIniFile then
    TRegIniFile(IniFile).DeleteKey(Section, Ident)
  else
{$ENDIF}
    if IniFile is TCustomIniFile then
      TCustomIniFile(IniFile).DeleteKey(Section, Ident);
end;

procedure IniReadSections(IniFile: TObject; Strings: TStrings);
begin
  if IniFile is TCustomIniFile then
    TCustomIniFile(IniFile).ReadSections(Strings)
{$IFDEF MSWINDOWS}
  else
    if IniFile is TRegIniFile then
      TRegIniFile(IniFile).ReadSections(Strings);
{$ENDIF}
end;

{$HINTS OFF}
type

  {*******************************************************}
  { !! ATTENTION Nasty implementation                     }
  {*******************************************************}
  {                                                       }
  { This class definition was copied from FORMS.PAS.      }
  { It is needed to access some private fields of TForm.  }
  {                                                       }
  { Any changes in the underlying classes may cause       }
  { errors in this implementation!                        }
  {                                                       }
  {*******************************************************}

  TJvNastyForm = class(TScrollingWinControl)
  private
    FActiveControl: TWinControl;
    FFocusedControl: TWinControl;
    FBorderIcons: TBorderIcons;
    FBorderStyle: TFormBorderStyle;
    FSizeChanging: Boolean;
    FWindowState: TWindowState; { !! }
  end;

  TJvHackComponent = class(TComponent);
{$HINTS ON}

function CrtResString: string;
begin
  Result := Format('(%dx%d)', [GetSystemMetrics(SM_CXSCREEN),
    GetSystemMetrics(SM_CYSCREEN)]);
end;

function ReadPosStr(AppStore: TJvCustomAppStore; const Path: string): string;
begin
  if AppStore.ValueStored(Path + CrtResString) then
    Result := AppStore.ReadString(Path + CrtResString)
  else
    Result := AppStore.ReadString(Path);
end;

procedure WritePosStr(AppStore: TJvCustomAppStore; const Path, Value: string);
begin
  AppStore.WriteString(Path + CrtResString, Value);
  AppStore.WriteString(Path, Value);
end;

procedure InternalSaveMDIChildren(MainForm: TForm; const AppStore:
  TJvCustomAppStore;
  const StorePath: string);
var
  i: Integer;
begin
  if (MainForm = nil) or (MainForm.FormStyle <> fsMDIForm) then
    raise EInvalidOperation.Create(SNoMDIForm);
  AppStore.DeleteSubTree(AppStore.ConcatPaths([StorePath, siMDIChild]));
  if MainForm.MDIChildCount > 0 then
  begin
    AppStore.WriteInteger(AppStore.ConcatPaths([StorePath, siMDIChild,
      siListCount]),
      MainForm.MDIChildCount);
    for i := 0 to MainForm.MDIChildCount - 1 do
      AppStore.WriteString(AppStore.ConcatPaths([StorePath, siMDIChild,
        Format(siItem, [i])]),
        MainForm.MDIChildren[i].ClassName);
  end;
end;

procedure InternalRestoreMDIChildren(MainForm: TForm; const AppStore:
  TJvCustomAppStore;
  const StorePath: string);
var
  i: Integer;
  Count: Integer;
  FormClass: TFormClass;
begin
  if (MainForm = nil) or (MainForm.FormStyle <> fsMDIForm) then
    raise EInvalidOperation.Create(SNoMDIForm);
  StartWait;
  try
    Count := AppStore.ReadInteger(AppStore.ConcatPaths([StorePath, siMDIChild,
      siListCount]), 0);
    if Count > 0 then
    begin
      for i := 0 to Count - 1 do
      begin
        FormClass :=
          TFormClass(GetClass(AppStore.ReadString(AppStore.ConcatPaths([StorePath,
          siMDIChild, Format(siItem, [i])]), '')));
        if FormClass <> nil then
          InternalFindShowForm(FormClass, '', False);
      end;
    end;
  finally
    StopWait;
  end;
end;

procedure SaveMDIChildren(MainForm: TForm; const AppStore: TJvCustomAppStore);
begin
  InternalSaveMDIChildren(MainForm, AppStore, '');
end;

procedure RestoreMDIChildren(MainForm: TForm; const AppStore:
  TJvCustomAppStore);
begin
  InternalRestoreMDIChildren(MainForm, AppStore, '');
end;

procedure InternalSaveFormPlacement(Form: TForm; const AppStore:
  TJvCustomAppStore;
  const StorePath: string; SaveState: Boolean = True; SavePosition: Boolean =
    True);
var
  Placement: TWindowPlacement;
begin
  if not (SaveState or SavePosition) then
    Exit;
  Placement.Length := SizeOf(TWindowPlacement);
  GetWindowPlacement(Form.Handle, @Placement);
  with Placement, TForm(Form) do
  begin
    if (Form = Application.MainForm) and AppMinimized then
      ShowCmd := SW_SHOWMINIMIZED;
{$IFDEF VCL}
    if (FormStyle = fsMDIChild) and (WindowState = wsMinimized) then
      Flags := Flags or WPF_SETMINPOSITION;
{$ENDIF}
    if SaveState then
      AppStore.WriteInteger(StorePath + '\' + siShowCmd, ShowCmd);
    if SavePosition then
    begin
      AppStore.WriteInteger(StorePath + '\' + siFlags, Flags);
      AppStore.WriteInteger(StorePath + '\' + siPixels, Screen.PixelsPerInch);
      WritePosStr(AppStore, StorePath + '\' + siMinMaxPos, Format('%d,%d,%d,%d',
        [ptMinPosition.X, ptMinPosition.Y, ptMaxPosition.X, ptMaxPosition.Y]));
      WritePosStr(AppStore, StorePath + '\' + siNormPos, Format('%d,%d,%d,%d',
        [rcNormalPosition.Left, rcNormalPosition.Top, rcNormalPosition.Right,
        rcNormalPosition.Bottom]));
    end;
  end;
end;

procedure InternalRestoreFormPlacement(Form: TForm; const AppStore:
  TJvCustomAppStore;
  const StorePath: string; LoadState: Boolean = True; LoadPosition: Boolean =
    True);
const
  Delims = [',', ' '];
var
  PosStr: string;
  Placement: TWindowPlacement;
  WinState: TWindowState;
  DataFound: Boolean;
begin
  if not (LoadState or LoadPosition) then
    Exit;
  Placement.Length := SizeOf(TWindowPlacement);
  GetWindowPlacement(Form.Handle, @Placement);
  with Placement, TForm(Form) do
  begin
    if not IsWindowVisible(Form.Handle) then
      ShowCmd := SW_HIDE;
    if LoadPosition then
    begin
      DataFound := False;
      AppStore.ReadInteger(StorePath + '\' + siFlags, Flags);
      PosStr := ReadPosStr(AppStore, StorePath + '\' + siMinMaxPos);
      if PosStr <> '' then
      begin
        DataFound := True;
        ptMinPosition.X := StrToIntDef(ExtractWord(1, PosStr, Delims), 0);
        ptMinPosition.Y := StrToIntDef(ExtractWord(2, PosStr, Delims), 0);
        ptMaxPosition.X := StrToIntDef(ExtractWord(3, PosStr, Delims), 0);
        ptMaxPosition.Y := StrToIntDef(ExtractWord(4, PosStr, Delims), 0);
      end;
      PosStr := ReadPosStr(AppStore, StorePath + '\' + siNormPos);
      if PosStr <> '' then
      begin
        DataFound := True;
        rcNormalPosition.Left := StrToIntDef(ExtractWord(1, PosStr, Delims),
          Left);
        rcNormalPosition.Top := StrToIntDef(ExtractWord(2, PosStr, Delims),
          Top);
        rcNormalPosition.Right := StrToIntDef(ExtractWord(3, PosStr, Delims),
          Left + Width);
        rcNormalPosition.Bottom := StrToIntDef(ExtractWord(4, PosStr, Delims),
          Top + Height);
      end;
      DataFound := DataFound and (Screen.PixelsPerInch = AppStore.ReadInteger(
        StorePath + '\' + siPixels, Screen.PixelsPerInch));
      if DataFound then
      begin
{$IFDEF VCL}
        if not (BorderStyle in [bsSizeable, bsSizeToolWin]) then
{$ENDIF}
{$IFDEF VisualCLX}
          if not (BorderStyle in [fbsSizeable, fbsSizeToolWin]) then
{$ENDIF}
            rcNormalPosition := Rect(rcNormalPosition.Left,
              rcNormalPosition.Top,
              rcNormalPosition.Left + Width, rcNormalPosition.Top + Height);
        if rcNormalPosition.Right > rcNormalPosition.Left then
        begin
          if (Position in [poScreenCenter, poDesktopCenter]) and
            not (csDesigning in ComponentState) then
          begin
            TJvHackComponent(Form).SetDesigning(True);
            try
              Position := poDesigned;
            finally
              TJvHackComponent(Form).SetDesigning(False);
            end;
          end;
          SetWindowPlacement(Handle, @Placement);
        end;
      end;
    end;
    if LoadState then
    begin
      WinState := wsNormal;
      { default maximize MDI main form }
      if ((Application.MainForm = Form) or
        (Application.MainForm = nil)) and ((FormStyle = fsMDIForm) or
        ((FormStyle = fsNormal) and (Position = poDefault))) then
        WinState := wsMaximized;
      ShowCmd := AppStore.ReadInteger(StorePath + '\' + siShowCmd, SW_HIDE);
      case ShowCmd of
        SW_SHOWNORMAL, SW_RESTORE, SW_SHOW:
          WinState := wsNormal;
        SW_MINIMIZE, SW_SHOWMINIMIZED, SW_SHOWMINNOACTIVE:
          WinState := wsMinimized;
        SW_MAXIMIZE:
          WinState := wsMaximized;
      end;
{$IFDEF VCL}
      if (WinState = wsMinimized) and ((Form = Application.MainForm)
        or (Application.MainForm = nil)) then
      begin
        TJvNastyForm(Form).FWindowState := wsNormal;
        PostMessage(Application.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
        Exit;
      end;
      if FormStyle in [fsMDIChild, fsMDIForm] then
        TJvNastyForm(Form).FWindowState := WinState
      else
{$ENDIF}
        WindowState := WinState;
    end;
    Update;
  end;
end;

procedure InternalSaveGridLayout(Grid: TCustomGrid; const AppStore:
  TJvCustomAppStore;
  const StorePath: string);
var
  i: Longint;
begin
  for i := 0 to TDrawGrid(Grid).ColCount - 1 do
    AppStore.WriteInteger(AppStore.ConcatPaths([StorePath, Format(siItem,
      [i])]),
      TDrawGrid(Grid).ColWidths[i]);
end;

procedure InternalRestoreGridLayout(Grid: TCustomGrid; const AppStore:
  TJvCustomAppStore;
  const StorePath: string);
var
  i: Longint;
begin
  for i := 0 to TDrawGrid(Grid).ColCount - 1 do
    TDrawGrid(Grid).ColWidths[i] :=
      AppStore.ReadInteger(AppStore.ConcatPaths([StorePath,
      Format(siItem, [i])]), TDrawGrid(Grid).ColWidths[i]);
end;

procedure RestoreGridLayout(Grid: TCustomGrid; const AppStore:
  TJvCustomAppStore);
begin
  InternalRestoreGridLayout(Grid, AppStore, GetDefaultSection(Grid));
end;

procedure SaveGridLayout(Grid: TCustomGrid; const AppStore: TJvCustomAppStore);
begin
  InternalSaveGridLayout(Grid, AppStore, GetDefaultSection(Grid));
end;

procedure SaveFormPlacement(Form: TForm; const AppStore: TJvCustomAppStore;
  SaveState,
  SavePosition: Boolean);
begin
  InternalSaveFormPlacement(Form, AppStore, GetDefaultSection(Form), SaveState,
    SavePosition);
end;

procedure RestoreFormPlacement(Form: TForm; const AppStore: TJvCustomAppStore;
  LoadState,
  LoadPosition: Boolean);
begin
  InternalRestoreFormPlacement(Form, AppStore, GetDefaultSection(Form),
    LoadState, LoadPosition);
end;

{$IFDEF VCL}

procedure AppBroadcast(Msg, wParam: Longint; lParam: Longint);
var
  i: Integer;
begin
  for i := 0 to Screen.FormCount - 1 do
    SendMessage(Screen.Forms[i].Handle, Msg, wParam, lParam);
end;

procedure AppTaskbarIcons(AppOnly: Boolean);
var
  Style: Longint;
begin
  Style := GetWindowLong(Application.Handle, GWL_STYLE);
  if AppOnly then
    Style := Style or WS_CAPTION
  else
    Style := Style and not WS_CAPTION;
  SetWindowLong(Application.Handle, GWL_STYLE, Style);
  if AppOnly then
    SwitchToWindow(Application.Handle, False);
end;
{$ENDIF VCL}
{ end JvAppUtils }
{ begin JvGraph }
// (rom) moved here to make JvMaxMin obsolete

function MaxFloat(const Values: array of Extended): Extended;
var
  i: Cardinal;
begin
  Result := Values[Low(Values)];
  for i := Low(Values) + 1 to High(Values) do
    if Values[i] > Result then
      Result := Values[i];
end;

procedure InvalidBitmap;
begin
  raise EInvalidGraphic.Create(SInvalidBitmap);
end;

type
  PRGBPalette = ^TRGBPalette;
  TRGBPalette = array[byte] of TRGBQuad;

function WidthBytes(i: Longint): Longint;
begin
  Result := ((i + 31) div 32) * 4;
end;

function PixelFormatToColors(PixelFormat: TPixelFormat): Integer;
begin
  case PixelFormat of
    pf1bit:
      Result := 2;
{$IFDEF VCL}
    pf4bit:
      Result := 16;
{$ENDIF}
    pf8bit:
      Result := 256;
  else
    Result := 0;
  end;
end;

{$IFDEF VCL}

function ScreenPixelFormat: TPixelFormat;
var
  DC: HDC;
begin
  DC := GetDC(0);
  try
    case (GetDeviceCaps(DC, Planes) * GetDeviceCaps(DC, BITSPIXEL)) of
      1:
        Result := pf1bit;
      4:
        Result := pf4bit;
      8:
        Result := pf8bit;
      24:
        Result := pf24bit;
    else
      Result := pfDevice;
    end;
  finally
    ReleaseDC(0, DC);
  end;
end;

function ScreenColorCount: Integer;
begin
  Result := PixelFormatToColors(ScreenPixelFormat);
end;
{$ENDIF VCL}

{ Quantizing }
{ Quantizing procedures based on free C source code written by
  Joe C. Oliphant, CompuServe 71742, 1451, joe_oliphant@csufresno.edu }

const
  MAX_COLORS = 4096;

type
  PQColor = ^TQColor;
  TQColor = record
    RGB: array[0..2] of byte;
    NewColorIndex: byte;
    Count: Longint;
    PNext: PQColor;
  end;

  PQColorArray = ^TQColorArray;
  TQColorArray = array[0..MAX_COLORS - 1] of TQColor;

  PQColorList = ^TQColorList;
  TQColorList = array[0..MaxListSize - 1] of PQColor;

  PNewColor = ^TNewColor;
  TNewColor = record
    RGBMin, RGBWidth: array[0..2] of byte;
    NumEntries: Longint;
    Count: Longint;
    QuantizedColors: PQColor;
  end;

  PNewColorArray = ^TNewColorArray;
  TNewColorArray = array[byte] of TNewColor;

procedure PInsert(ColorList: PQColorList; Number: Integer;
  SortRGBAxis: Integer);
var
  Q1, Q2: PQColor;
  i, j: Integer;
  Temp: PQColor;
begin
  for i := 1 to Number - 1 do
  begin
    Temp := ColorList^[i];
    j := i - 1;
    while j >= 0 do
    begin
      Q1 := Temp;
      Q2 := ColorList^[j];
      if Q1^.RGB[SortRGBAxis] - Q2^.RGB[SortRGBAxis] > 0 then
        break;
      ColorList^[j + 1] := ColorList^[j];
      Dec(j);
    end;
    ColorList^[j + 1] := Temp;
  end;
end;

procedure PSort(ColorList: PQColorList; Number: Integer;
  SortRGBAxis: Integer);
var
  Q1, Q2: PQColor;
  i, j, N, Nr: Integer;
  Temp, Part: PQColor;
begin
  if Number < 8 then
  begin
    PInsert(ColorList, Number, SortRGBAxis);
    Exit;
  end;
  Part := ColorList^[Number div 2];
  i := -1;
  j := Number;
  repeat
    repeat
      Inc(i);
      Q1 := ColorList^[i];
      Q2 := Part;
      N := Q1^.RGB[SortRGBAxis] - Q2^.RGB[SortRGBAxis];
    until N >= 0;
    repeat
      Dec(j);
      Q1 := ColorList^[j];
      Q2 := Part;
      N := Q1^.RGB[SortRGBAxis] - Q2^.RGB[SortRGBAxis];
    until N <= 0;
    if i >= j then
      break;
    Temp := ColorList^[i];
    ColorList^[i] := ColorList^[j];
    ColorList^[j] := Temp;
  until False;
  Nr := Number - i;
  if i < Number div 2 then
  begin
    PSort(ColorList, i, SortRGBAxis);
    PSort(PQColorList(@ColorList^[i]), Nr, SortRGBAxis);
  end
  else
  begin
    PSort(PQColorList(@ColorList^[i]), Nr, SortRGBAxis);
    PSort(ColorList, i, SortRGBAxis);
  end;
end;

function DivideMap(NewColorSubdiv: PNewColorArray; ColorMapSize: Integer;
  var NewColormapSize: Integer; LPSTR: Pointer): Integer;
var
  i, j: Integer;
  MaxSize, Index: Integer;
  NumEntries, MinColor,
    MaxColor: Integer;
  Sum, Count: Longint;
  QuantizedColor: PQColor;
  SortArray: PQColorList;
  SortRGBAxis: Integer;
begin
  Index := 0;
  SortRGBAxis := 0;
  while ColorMapSize > NewColormapSize do
  begin
    MaxSize := -1;
    for i := 0 to NewColormapSize - 1 do
    begin
      for j := 0 to 2 do
      begin
        if (NewColorSubdiv^[i].RGBWidth[j] > MaxSize) and
          (NewColorSubdiv^[i].NumEntries > 1) then
        begin
          MaxSize := NewColorSubdiv^[i].RGBWidth[j];
          Index := i;
          SortRGBAxis := j;
        end;
      end;
    end;
    if MaxSize = -1 then
    begin
      Result := 1;
      Exit;
    end;
    SortArray := PQColorList(LPSTR);
    j := 0;
    QuantizedColor := NewColorSubdiv^[Index].QuantizedColors;
    while (j < NewColorSubdiv^[Index].NumEntries) and
      (QuantizedColor <> nil) do
    begin
      SortArray^[j] := QuantizedColor;
      Inc(j);
      QuantizedColor := QuantizedColor^.PNext;
    end;
    PSort(SortArray, NewColorSubdiv^[Index].NumEntries, SortRGBAxis);
    for j := 0 to NewColorSubdiv^[Index].NumEntries - 2 do
      SortArray^[j]^.PNext := SortArray^[j + 1];
    SortArray^[NewColorSubdiv^[Index].NumEntries - 1]^.PNext := nil;
    NewColorSubdiv^[Index].QuantizedColors := SortArray^[0];
    QuantizedColor := SortArray^[0];
    Sum := NewColorSubdiv^[Index].Count div 2 - QuantizedColor^.Count;
    NumEntries := 1;
    Count := QuantizedColor^.Count;
    Dec(Sum, QuantizedColor^.PNext^.Count);
    while (Sum >= 0) and (QuantizedColor^.PNext <> nil) and
      (QuantizedColor^.PNext^.PNext <> nil) do
    begin
      QuantizedColor := QuantizedColor^.PNext;
      Inc(NumEntries);
      Inc(Count, QuantizedColor^.Count);
      Dec(Sum, QuantizedColor^.PNext^.Count);
    end;
    MaxColor := (QuantizedColor^.RGB[SortRGBAxis]) shl 4;
    MinColor := (QuantizedColor^.PNext^.RGB[SortRGBAxis]) shl 4;
    NewColorSubdiv^[NewColormapSize].QuantizedColors := QuantizedColor^.PNext;
    QuantizedColor^.PNext := nil;
    NewColorSubdiv^[NewColormapSize].Count := Count;
    Dec(NewColorSubdiv^[Index].Count, Count);
    NewColorSubdiv^[NewColormapSize].NumEntries :=
      NewColorSubdiv^[Index].NumEntries - NumEntries;
    NewColorSubdiv^[Index].NumEntries := NumEntries;
    for j := 0 to 2 do
    begin
      NewColorSubdiv^[NewColormapSize].RGBMin[j] :=
        NewColorSubdiv^[Index].RGBMin[j];
      NewColorSubdiv^[NewColormapSize].RGBWidth[j] :=
        NewColorSubdiv^[Index].RGBWidth[j];
    end;
    NewColorSubdiv^[NewColormapSize].RGBWidth[SortRGBAxis] :=
      NewColorSubdiv^[NewColormapSize].RGBMin[SortRGBAxis] +
      NewColorSubdiv^[NewColormapSize].RGBWidth[SortRGBAxis] -
      MinColor;
    NewColorSubdiv^[NewColormapSize].RGBMin[SortRGBAxis] := MinColor;
    NewColorSubdiv^[Index].RGBWidth[SortRGBAxis] :=
      MaxColor - NewColorSubdiv^[Index].RGBMin[SortRGBAxis];
    Inc(NewColormapSize);
  end;
  Result := 1;
end;

function Quantize(const Bmp: TBitmapInfoHeader; gptr, Data8: Pointer;
  var ColorCount: Integer; var OutputColormap: TRGBPalette): Integer;
type
  PWord = ^Word;
var
  P: PByteArray;
  LineBuffer, Data: Pointer;
  LineWidth: Longint;
  TmpLineWidth, NewLineWidth: Longint;
  i, j: Longint;
  Index: Word;
  NewColormapSize, NumOfEntries: Integer;
  Mems: Longint;
  cRed, cGreen, cBlue: Longint;
  LPSTR, Temp, Tmp: Pointer;
  NewColorSubdiv: PNewColorArray;
  ColorArrayEntries: PQColorArray;
  QuantizedColor: PQColor;
begin
  LineWidth := WidthBytes(Longint(Bmp.biWidth) * Bmp.biBitCount);
  Mems := (Longint(SizeOf(TQColor)) * (MAX_COLORS)) +
    (Longint(SizeOf(TNewColor)) * 256) + LineWidth +
    (Longint(SizeOf(PQColor)) * (MAX_COLORS));
  LPSTR := AllocMemo(Mems);
  try
    Temp := AllocMemo(Longint(Bmp.biWidth) * Longint(Bmp.biHeight) *
      SizeOf(Word));
    try
      ColorArrayEntries := PQColorArray(LPSTR);
      NewColorSubdiv := PNewColorArray(HugeOffset(LPSTR,
        Longint(SizeOf(TQColor)) * (MAX_COLORS)));
      LineBuffer := HugeOffset(LPSTR, (Longint(SizeOf(TQColor)) * (MAX_COLORS))
        +
        (Longint(SizeOf(TNewColor)) * 256));
      for i := 0 to MAX_COLORS - 1 do
      begin
        ColorArrayEntries^[i].RGB[0] := i shr 8;
        ColorArrayEntries^[i].RGB[1] := (i shr 4) and $0F;
        ColorArrayEntries^[i].RGB[2] := i and $0F;
        ColorArrayEntries^[i].Count := 0;
      end;
      Tmp := Temp;
      for i := 0 to Bmp.biHeight - 1 do
      begin
        HMemCpy(LineBuffer, HugeOffset(gptr, (Bmp.biHeight - 1 - i) *
          LineWidth), LineWidth);
        P := LineBuffer;
        for j := 0 to Bmp.biWidth - 1 do
        begin
          Index := (Longint(P^[2] and $F0) shl 4) +
            Longint(P^[1] and $F0) + (Longint(P^[0] and $F0) shr 4);
          Inc(ColorArrayEntries^[Index].Count);
          P := HugeOffset(P, 3);
          PWord(Tmp)^ := Index;
          Tmp := HugeOffset(Tmp, 2);
        end;
      end;
      for i := 0 to 255 do
      begin
        NewColorSubdiv^[i].QuantizedColors := nil;
        NewColorSubdiv^[i].Count := 0;
        NewColorSubdiv^[i].NumEntries := 0;
        for j := 0 to 2 do
        begin
          NewColorSubdiv^[i].RGBMin[j] := 0;
          NewColorSubdiv^[i].RGBWidth[j] := 255;
        end;
      end;
      i := 0;
      while i < MAX_COLORS do
      begin
        if ColorArrayEntries^[i].Count > 0 then
          break;
        Inc(i);
      end;
      QuantizedColor := @ColorArrayEntries^[i];
      NewColorSubdiv^[0].QuantizedColors := @ColorArrayEntries^[i];
      NumOfEntries := 1;
      Inc(i);
      while i < MAX_COLORS do
      begin
        if ColorArrayEntries^[i].Count > 0 then
        begin
          QuantizedColor^.PNext := @ColorArrayEntries^[i];
          QuantizedColor := @ColorArrayEntries^[i];
          Inc(NumOfEntries);
        end;
        Inc(i);
      end;
      QuantizedColor^.PNext := nil;
      NewColorSubdiv^[0].NumEntries := NumOfEntries;
      NewColorSubdiv^[0].Count := Longint(Bmp.biWidth) * Longint(Bmp.biHeight);
      NewColormapSize := 1;
      DivideMap(NewColorSubdiv, ColorCount, NewColormapSize,
        HugeOffset(LPSTR, Longint(SizeOf(TQColor)) * (MAX_COLORS) +
        Longint(SizeOf(TNewColor)) * 256 + LineWidth));
      if NewColormapSize < ColorCount then
      begin
        for i := NewColormapSize to ColorCount - 1 do
          FillChar(OutputColormap[i], SizeOf(TRGBQuad), 0);
      end;
      for i := 0 to NewColormapSize - 1 do
      begin
        j := NewColorSubdiv^[i].NumEntries;
        if j > 0 then
        begin
          QuantizedColor := NewColorSubdiv^[i].QuantizedColors;
          cRed := 0;
          cGreen := 0;
          cBlue := 0;
          while QuantizedColor <> nil do
          begin
            QuantizedColor^.NewColorIndex := i;
            Inc(cRed, QuantizedColor^.RGB[0]);
            Inc(cGreen, QuantizedColor^.RGB[1]);
            Inc(cBlue, QuantizedColor^.RGB[2]);
            QuantizedColor := QuantizedColor^.PNext;
          end;
          with OutputColormap[i] do
          begin
            rgbRed := (Longint(cRed shl 4) or $0F) div j;
            rgbGreen := (Longint(cGreen shl 4) or $0F) div j;
            rgbBlue := (Longint(cBlue shl 4) or $0F) div j;
            rgbReserved := 0;
            if (rgbRed <= $10) and (rgbGreen <= $10) and (rgbBlue <= $10) then
              FillChar(OutputColormap[i], SizeOf(TRGBQuad), 0); { clBlack }
          end;
        end;
      end;
      TmpLineWidth := Longint(Bmp.biWidth) * SizeOf(Word);
      NewLineWidth := WidthBytes(Longint(Bmp.biWidth) * 8);
      FillChar(Data8^, NewLineWidth * Bmp.biHeight, #0);
      for i := 0 to Bmp.biHeight - 1 do
      begin
        LineBuffer := HugeOffset(Temp, (Bmp.biHeight - 1 - i) * TmpLineWidth);
        Data := HugeOffset(Data8, i * NewLineWidth);
        for j := 0 to Bmp.biWidth - 1 do
        begin
          PByte(Data)^ := ColorArrayEntries^[PWord(LineBuffer)^].NewColorIndex;
          LineBuffer := HugeOffset(LineBuffer, 2);
          Data := HugeOffset(Data, 1);
        end;
      end;
    finally
      FreeMemo(Temp);
    end;
  finally
    FreeMemo(LPSTR);
  end;
  ColorCount := NewColormapSize;
  Result := 0;
end;

{
  Procedures to truncate to lower bits-per-pixel, grayscale, tripel and
  histogram conversion based on freeware C source code of GBM package by
  Andy Key (nyangau@interalpha.co.uk). The home page of GBM author is
  at http://www.interalpha.net/customer/nyangau/.
}

{ Truncate to lower bits per pixel }

type
  TTruncLine = procedure(Src, Dest: Pointer; CX: Integer);

  { For 6Rx6Gx6B, 7Rx8Gx4B palettes etc. }

const
  Scale04: array[0..3] of byte = (0, 85, 170, 255);
  Scale06: array[0..5] of byte = (0, 51, 102, 153, 204, 255);
  Scale07: array[0..6] of byte = (0, 43, 85, 128, 170, 213, 255);
  Scale08: array[0..7] of byte = (0, 36, 73, 109, 146, 182, 219, 255);

  { For 6Rx6Gx6B, 7Rx8Gx4B palettes etc. }

var
  TruncIndex04: array[byte] of byte;
  TruncIndex06: array[byte] of byte;
  TruncIndex07: array[byte] of byte;
  TruncIndex08: array[byte] of byte;

  { These functions initialises this module }

procedure InitTruncTables;

  function NearestIndex(Value: byte; const Bytes: array of byte): byte;
  var
    b, i: byte;
    Diff, DiffMin: Word;
  begin
    Result := 0;
    b := Bytes[0];
    DiffMin := Abs(Value - b);
    for i := 1 to High(Bytes) do
    begin
      b := Bytes[i];
      Diff := Abs(Value - b);
      if Diff < DiffMin then
      begin
        DiffMin := Diff;
        Result := i;
      end;
    end;
  end;

var
  i: Integer;
begin
  { For 7 Red X 8 Green X 4 Blue palettes etc. }
  for i := 0 to 255 do
  begin
    TruncIndex04[i] := NearestIndex(byte(i), Scale04);
    TruncIndex06[i] := NearestIndex(byte(i), Scale06);
    TruncIndex07[i] := NearestIndex(byte(i), Scale07);
    TruncIndex08[i] := NearestIndex(byte(i), Scale08);
  end;
end;

procedure trunc(const Header: TBitmapInfoHeader; Src, Dest: Pointer;
  DstBitsPerPixel: Integer; TruncLineProc: TTruncLine);
var
  SrcScanline, DstScanline: Longint;
  Y: Integer;
begin
  SrcScanline := (Header.biWidth * 3 + 3) and not 3;
  DstScanline := ((Header.biWidth * DstBitsPerPixel + 31) div 32) * 4;
  for Y := 0 to Header.biHeight - 1 do
    TruncLineProc(HugeOffset(Src, Y * SrcScanline),
      HugeOffset(Dest, Y * DstScanline), Header.biWidth);
end;

{ return 6Rx6Gx6B palette
  This function makes the palette for the 6 red X 6 green X 6 blue palette.
  216 palette entrys used. Remaining 40 Left blank.
}

procedure TruncPal6R6G6B(var Colors: TRGBPalette);
var
  i, r, g, b: byte;
begin
  FillChar(Colors, SizeOf(TRGBPalette), $80);
  i := 0;
  for r := 0 to 5 do
    for g := 0 to 5 do
      for b := 0 to 5 do
      begin
        Colors[i].rgbRed := Scale06[r];
        Colors[i].rgbGreen := Scale06[g];
        Colors[i].rgbBlue := Scale06[b];
        Colors[i].rgbReserved := 0;
        Inc(i);
      end;
end;

{ truncate to 6Rx6Gx6B one line }

procedure TruncLine6R6G6B(Src, Dest: Pointer; CX: Integer);
var
  X: Integer;
  r, g, b: byte;
begin
  for X := 0 to CX - 1 do
  begin
    b := TruncIndex06[byte(Src^)];
    Src := HugeOffset(Src, 1);
    g := TruncIndex06[byte(Src^)];
    Src := HugeOffset(Src, 1);
    r := TruncIndex06[byte(Src^)];
    Src := HugeOffset(Src, 1);
    PByte(Dest)^ := 6 * (6 * r + g) + b;
    Dest := HugeOffset(Dest, 1);
  end;
end;

{ truncate to 6Rx6Gx6B }

procedure Trunc6R6G6B(const Header: TBitmapInfoHeader;
  const Data24, Data8: Pointer);
begin
  trunc(Header, Data24, Data8, 8, TruncLine6R6G6B);
end;

{ return 7Rx8Gx4B palette
  This function makes the palette for the 7 red X 8 green X 4 blue palette.
  224 palette entrys used. Remaining 32 Left blank.
  Colours calculated to match those used by 8514/A PM driver.
}

procedure TruncPal7R8G4B(var Colors: TRGBPalette);
var
  i, r, g, b: byte;
begin
  FillChar(Colors, SizeOf(TRGBPalette), $80);
  i := 0;
  for r := 0 to 6 do
    for g := 0 to 7 do
      for b := 0 to 3 do
      begin
        Colors[i].rgbRed := Scale07[r];
        Colors[i].rgbGreen := Scale08[g];
        Colors[i].rgbBlue := Scale04[b];
        Colors[i].rgbReserved := 0;
        Inc(i);
      end;
end;

{ truncate to 7Rx8Gx4B one line }

procedure TruncLine7R8G4B(Src, Dest: Pointer; CX: Integer);
var
  X: Integer;
  r, g, b: byte;
begin
  for X := 0 to CX - 1 do
  begin
    b := TruncIndex04[byte(Src^)];
    Src := HugeOffset(Src, 1);
    g := TruncIndex08[byte(Src^)];
    Src := HugeOffset(Src, 1);
    r := TruncIndex07[byte(Src^)];
    Src := HugeOffset(Src, 1);
    PByte(Dest)^ := 4 * (8 * r + g) + b;
    Dest := HugeOffset(Dest, 1);
  end;
end;

{ truncate to 7Rx8Gx4B }

procedure Trunc7R8G4B(const Header: TBitmapInfoHeader;
  const Data24, Data8: Pointer);
begin
  trunc(Header, Data24, Data8, 8, TruncLine7R8G4B);
end;

{ Grayscale support }

procedure GrayPal(var Colors: TRGBPalette);
var
  i: byte;
begin
  FillChar(Colors, SizeOf(TRGBPalette), 0);
  for i := 0 to 255 do
    FillChar(Colors[i], 3, i);
end;

procedure GrayScale(const Header: TBitmapInfoHeader; Data24, Data8: Pointer);
var
  SrcScanline, DstScanline: Longint;
  Y, X: Integer;
  Src, Dest: PByte;
  r, g, b: byte;
begin
  SrcScanline := (Header.biWidth * 3 + 3) and not 3;
  DstScanline := (Header.biWidth + 3) and not 3;
  for Y := 0 to Header.biHeight - 1 do
  begin
    Src := Data24;
    Dest := Data8;
    for X := 0 to Header.biWidth - 1 do
    begin
      b := Src^;
      Src := HugeOffset(Src, 1);
      g := Src^;
      Src := HugeOffset(Src, 1);
      r := Src^;
      Src := HugeOffset(Src, 1);
      Dest^ := byte(Longint(Word(r) * 77 + Word(g) * 150 + Word(b) * 29) shr 8);
      Dest := HugeOffset(Dest, 1);
    end;
    Data24 := HugeOffset(Data24, SrcScanline);
    Data8 := HugeOffset(Data8, DstScanline);
  end;
end;

{ Tripel conversion }

procedure TripelPal(var Colors: TRGBPalette);
var
  i: byte;
begin
  FillChar(Colors, SizeOf(TRGBPalette), 0);
  for i := 0 to $40 do
  begin
    Colors[i].rgbRed := i shl 2;
    Colors[i + $40].rgbGreen := i shl 2;
    Colors[i + $80].rgbBlue := i shl 2;
  end;
end;

procedure Tripel(const Header: TBitmapInfoHeader; Data24, Data8: Pointer);
var
  SrcScanline, DstScanline: Longint;
  Y, X: Integer;
  Src, Dest: PByte;
  r, g, b: byte;
begin
  SrcScanline := (Header.biWidth * 3 + 3) and not 3;
  DstScanline := (Header.biWidth + 3) and not 3;
  for Y := 0 to Header.biHeight - 1 do
  begin
    Src := Data24;
    Dest := Data8;
    for X := 0 to Header.biWidth - 1 do
    begin
      b := Src^;
      Src := HugeOffset(Src, 1);
      g := Src^;
      Src := HugeOffset(Src, 1);
      r := Src^;
      Src := HugeOffset(Src, 1);
      case ((X + Y) mod 3) of
        0: Dest^ := byte(r shr 2);
        1: Dest^ := byte($40 + (g shr 2));
        2: Dest^ := byte($80 + (b shr 2));
      end;
      Dest := HugeOffset(Dest, 1);
    end;
    Data24 := HugeOffset(Data24, SrcScanline);
    Data8 := HugeOffset(Data8, DstScanline);
  end;
end;

{ Histogram/Frequency-of-use method of color reduction }

const
  MAX_N_COLS = 2049;
  MAX_N_HASH = 5191;

function Hash(r, g, b: byte): Word;
begin
  Result := Word(Longint(Longint(r + g) * Longint(g + b) *
    Longint(b + r)) mod MAX_N_HASH);
end;

type
  PFreqRecord = ^TFreqRecord;
  TFreqRecord = record
    b: byte;
    g: byte;
    r: byte;
    Frequency: Longint;
    Nearest: byte;
  end;

  PHist = ^THist;
  THist = record
    ColCount: Longint;
    Rm: byte;
    Gm: byte;
    BM: byte;
    Freqs: array[0..MAX_N_COLS - 1] of TFreqRecord;
    HashTable: array[0..MAX_N_HASH - 1] of Word;
  end;

function CreateHistogram(r, g, b: byte): PHist;
{ create empty histogram }
begin
  GetMem(Result, SizeOf(THist));
  with Result^ do
  begin
    Rm := r;
    Gm := g;
    BM := b;
    ColCount := 0;
  end;
  FillChar(Result^.HashTable, MAX_N_HASH * SizeOf(Word), 255);
end;

procedure ClearHistogram(var Hist: PHist; r, g, b: byte);
begin
  with Hist^ do
  begin
    Rm := r;
    Gm := g;
    BM := b;
    ColCount := 0;
  end;
  FillChar(Hist^.HashTable, MAX_N_HASH * SizeOf(Word), 255);
end;

procedure DeleteHistogram(var Hist: PHist);
begin
  FreeMem(Hist, SizeOf(THist));
  Hist := nil;
end;

function AddToHistogram(var Hist: THist; const Header: TBitmapInfoHeader;
  Data24: Pointer): Boolean;
{ add bitmap data to histogram }
var
  Step24: Integer;
  HashColor, Index: Word;
  Rm, Gm, BM, r, g, b: byte;
  X, Y, ColCount: Longint;
begin
  Step24 := ((Header.biWidth * 3 + 3) and not 3) - Header.biWidth * 3;
  Rm := Hist.Rm;
  Gm := Hist.Gm;
  BM := Hist.BM;
  ColCount := Hist.ColCount;
  for Y := 0 to Header.biHeight - 1 do
  begin
    for X := 0 to Header.biWidth - 1 do
    begin
      b := byte(Data24^) and BM;
      Data24 := HugeOffset(Data24, 1);
      g := byte(Data24^) and Gm;
      Data24 := HugeOffset(Data24, 1);
      r := byte(Data24^) and Rm;
      Data24 := HugeOffset(Data24, 1);
      HashColor := Hash(r, g, b);
      repeat
        Index := Hist.HashTable[HashColor];
        if (Index = $FFFF) or ((Hist.Freqs[Index].r = r) and
          (Hist.Freqs[Index].g = g) and (Hist.Freqs[Index].b = b)) then
          break;
        Inc(HashColor);
        if HashColor = MAX_N_HASH then
          HashColor := 0;
      until False;
      { Note: loop will always be broken out of }
      { We don't allow HashTable to fill up above half full }
      if Index = $FFFF then
      begin
        { Not found in Hash table }
        if ColCount = MAX_N_COLS then
        begin
          Result := False;
          Exit;
        end;
        Hist.Freqs[ColCount].Frequency := 1;
        Hist.Freqs[ColCount].b := b;
        Hist.Freqs[ColCount].g := g;
        Hist.Freqs[ColCount].r := r;
        Hist.HashTable[HashColor] := ColCount;
        Inc(ColCount);
      end
      else
      begin
        { Found in Hash table, update index }
        Inc(Hist.Freqs[Index].Frequency);
      end;
    end;
    Data24 := HugeOffset(Data24, Step24);
  end;
  Hist.ColCount := ColCount;
  Result := True;
end;

procedure PalHistogram(var Hist: THist; var Colors: TRGBPalette;
  ColorsWanted: Integer);
{ work out a palette from Hist }
var
  i, j: Longint;
  MinDist, Dist: Longint;
  MaxJ, MinJ: Longint;
  DeltaB, DeltaG, DeltaR: Longint;
  MaxFreq: Longint;
begin
  i := 0;
  MaxJ := 0;
  MinJ := 0;
  { Now find the ColorsWanted most frequently used ones }
  while (i < ColorsWanted) and (i < Hist.ColCount) do
  begin
    MaxFreq := 0;
    for j := 0 to Hist.ColCount - 1 do
      if Hist.Freqs[j].Frequency > MaxFreq then
      begin
        MaxJ := j;
        MaxFreq := Hist.Freqs[j].Frequency;
      end;
    Hist.Freqs[MaxJ].Nearest := byte(i);
    Hist.Freqs[MaxJ].Frequency := 0; { Prevent later use of Freqs[MaxJ] }
    Colors[i].rgbBlue := Hist.Freqs[MaxJ].b;
    Colors[i].rgbGreen := Hist.Freqs[MaxJ].g;
    Colors[i].rgbRed := Hist.Freqs[MaxJ].r;
    Colors[i].rgbReserved := 0;
    Inc(i);
  end;
  { Unused palette entries will be medium grey }
  while i <= 255 do
  begin
    Colors[i].rgbRed := $80;
    Colors[i].rgbGreen := $80;
    Colors[i].rgbBlue := $80;
    Colors[i].rgbReserved := 0;
    Inc(i);
  end;
  { For the rest, find the closest one in the first ColorsWanted }
  for i := 0 to Hist.ColCount - 1 do
  begin
    if Hist.Freqs[i].Frequency <> 0 then
    begin
      MinDist := 3 * 256 * 256;
      for j := 0 to ColorsWanted - 1 do
      begin
        DeltaB := Hist.Freqs[i].b - Colors[j].rgbBlue;
        DeltaG := Hist.Freqs[i].g - Colors[j].rgbGreen;
        DeltaR := Hist.Freqs[i].r - Colors[j].rgbRed;
        Dist := Longint(DeltaR * DeltaR) + Longint(DeltaG * DeltaG) +
          Longint(DeltaB * DeltaB);
        if Dist < MinDist then
        begin
          MinDist := Dist;
          MinJ := j;
        end;
      end;
      Hist.Freqs[i].Nearest := byte(MinJ);
    end;
  end;
end;

procedure MapHistogram(var Hist: THist; const Header: TBitmapInfoHeader;
  Data24, Data8: Pointer);
{ map bitmap data to Hist palette }
var
  Step24: Integer;
  Step8: Integer;
  HashColor, Index: Longint;
  Rm, Gm, BM, r, g, b: byte;
  X, Y: Longint;
begin
  Step24 := ((Header.biWidth * 3 + 3) and not 3) - Header.biWidth * 3;
  Step8 := ((Header.biWidth + 3) and not 3) - Header.biWidth;
  Rm := Hist.Rm;
  Gm := Hist.Gm;
  BM := Hist.BM;
  for Y := 0 to Header.biHeight - 1 do
  begin
    for X := 0 to Header.biWidth - 1 do
    begin
      b := byte(Data24^) and BM;
      Data24 := HugeOffset(Data24, 1);
      g := byte(Data24^) and Gm;
      Data24 := HugeOffset(Data24, 1);
      r := byte(Data24^) and Rm;
      Data24 := HugeOffset(Data24, 1);
      HashColor := Hash(r, g, b);
      repeat
        Index := Hist.HashTable[HashColor];
        if (Hist.Freqs[Index].r = r) and (Hist.Freqs[Index].g = g) and
          (Hist.Freqs[Index].b = b) then
          break;
        Inc(HashColor);
        if HashColor = MAX_N_HASH then
          HashColor := 0;
      until False;
      PByte(Data8)^ := Hist.Freqs[Index].Nearest;
      Data8 := HugeOffset(Data8, 1);
    end;
    Data24 := HugeOffset(Data24, Step24);
    Data8 := HugeOffset(Data8, Step8);
  end;
end;

procedure Histogram(const Header: TBitmapInfoHeader; var Colors: TRGBPalette;
  Data24, Data8: Pointer; ColorsWanted: Integer; Rm, Gm, BM: byte);
{ map single bitmap to frequency optimised palette }
var
  Hist: PHist;
begin
  Hist := CreateHistogram(Rm, Gm, BM);
  try
    repeat
      if AddToHistogram(Hist^, Header, Data24) then
        break
      else
      begin
        if Gm > Rm then
          Gm := Gm shl 1
        else
          if Rm > BM then
            Rm := Rm shl 1
          else
            BM := BM shl 1;
        ClearHistogram(Hist, Rm, Gm, BM);
      end;
    until False;
    { Above loop will always be exited as if masks get rough   }
    { enough, ultimately number of unique colours < MAX_N_COLS }
    PalHistogram(Hist^, Colors, ColorsWanted);
    MapHistogram(Hist^, Header, Data24, Data8);
  finally
    DeleteHistogram(Hist);
  end;
end;

{ expand to 24 bits-per-pixel }

(*
procedure ExpandTo24Bit(const Header: TBitmapInfoHeader; Colors: TRGBPalette;
  Data, NewData: Pointer);
var
  Scanline, NewScanline: Longint;
  Y, X: Integer;
  Src, Dest: Pointer;
  C: Byte;
begin
  if Header.biBitCount = 24 then begin
    Exit;
  end;
  Scanline := ((Header.biWidth * Header.biBitCount + 31) div 32) * 4;
  NewScanline := ((Header.biWidth * 3 + 3) and not 3);
  for Y := 0 to Header.biHeight - 1 do begin
    Src := HugeOffset(Data, Y * Scanline);
    Dest := HugeOffset(NewData, Y * NewScanline);
    case Header.biBitCount of
      1:
      begin
        C := 0;
        for X := 0 to Header.biWidth - 1 do begin
          if (X and 7) = 0 then begin
            C := Byte(Src^);
            Src := HugeOffset(Src, 1);
          end
          else C := C shl 1;
          PByte(Dest)^ := Colors[C shr 7].rgbBlue;
          Dest := HugeOffset(Dest, 1);
          PByte(Dest)^ := Colors[C shr 7].rgbGreen;
          Dest := HugeOffset(Dest, 1);
          PByte(Dest)^ := Colors[C shr 7].rgbRed;
          Dest := HugeOffset(Dest, 1);
        end;
      end;
      4:
      begin
        X := 0;
        while X < Header.biWidth - 1 do begin
          C := Byte(Src^);
          Src := HugeOffset(Src, 1);
          PByte(Dest)^ := Colors[C shr 4].rgbBlue;
          Dest := HugeOffset(Dest, 1);
          PByte(Dest)^ := Colors[C shr 4].rgbGreen;
          Dest := HugeOffset(Dest, 1);
          PByte(Dest)^ := Colors[C shr 4].rgbRed;
          Dest := HugeOffset(Dest, 1);
          PByte(Dest)^ := Colors[C and 15].rgbBlue;
          Dest := HugeOffset(Dest, 1);
          PByte(Dest)^ := Colors[C and 15].rgbGreen;
          Dest := HugeOffset(Dest, 1);
          PByte(Dest)^ := Colors[C and 15].rgbRed;
          Dest := HugeOffset(Dest, 1);
          Inc(X, 2);
        end;
        if X < Header.biWidth then begin
          C := Byte(Src^);
          PByte(Dest)^ := Colors[C shr 4].rgbBlue;
          Dest := HugeOffset(Dest, 1);
          PByte(Dest)^ := Colors[C shr 4].rgbGreen;
          Dest := HugeOffset(Dest, 1);
          PByte(Dest)^ := Colors[C shr 4].rgbRed;
          {Dest := HugeOffset(Dest, 1);}
        end;
      end;
      8:
      begin
        for X := 0 to Header.biWidth - 1 do begin
          C := Byte(Src^);
          Src := HugeOffset(Src, 1);
          PByte(Dest)^ := Colors[C].rgbBlue;
          Dest := HugeOffset(Dest, 1);
          PByte(Dest)^ := Colors[C].rgbGreen;
          Dest := HugeOffset(Dest, 1);
          PByte(Dest)^ := Colors[C].rgbRed;
          Dest := HugeOffset(Dest, 1);
        end;
      end;
    end;
  end;
end;
*)

{$IFDEF VCL}
{ DIB utility routines }

function GetPaletteBitmapFormat(Bitmap: TBitmap): TPixelFormat;
var
  PalSize: Integer;
begin
  Result := pfDevice;
  if Bitmap.Palette <> 0 then
  begin
    GetObject(Bitmap.Palette, SizeOf(Integer), @PalSize);
    if PalSize > 0 then
    begin
      if PalSize <= 2 then
        Result := pf1bit
      else
        if PalSize <= 16 then
          Result := pf4bit
        else
          if PalSize <= 256 then
            Result := pf8bit;
    end;
  end;
end;
{$ENDIF VCL}

function GetBitmapPixelFormat(Bitmap: TBitmap): TPixelFormat;
begin
  Result := Bitmap.PixelFormat;
end;

function BytesPerScanLine(PixelsPerScanline, BitsPerPixel,
  Alignment: Longint): Longint;
begin
  Dec(Alignment);
  Result := ((PixelsPerScanline * BitsPerPixel) + Alignment) and
    not Alignment;
  Result := Result div 8;
end;

{$IFDEF VCL}

procedure InitializeBitmapInfoHeader(Bitmap: HBITMAP; var BI: TBitmapInfoHeader;
  PixelFormat: TPixelFormat);
var
  DS: TDIBSection;
  Bytes: Integer;
begin
  DS.dsbmih.biSize := 0;
  Bytes := GetObject(Bitmap, SizeOf(DS), @DS);
  if Bytes = 0 then
    InvalidBitmap
  else
    if (Bytes >= (SizeOf(DS.dsbm) + SizeOf(DS.dsbmih))) and
    (DS.dsbmih.biSize >= DWORD(SizeOf(DS.dsbmih))) then
      BI := DS.dsbmih
    else
    begin
      FillChar(BI, SizeOf(BI), 0);
      with BI, DS.dsbm do
      begin
        biSize := SizeOf(BI);
        biWidth := bmWidth;
        biHeight := bmHeight;
      end;
    end;
  case PixelFormat of
    pf1bit: BI.biBitCount := 1;
    pf4bit: BI.biBitCount := 4;
    pf8bit: BI.biBitCount := 8;
    pf24bit: BI.biBitCount := 24;
  else
    BI.biBitCount := DS.dsbm.bmBitsPixel * DS.dsbm.bmPlanes;
  end;
  BI.biPlanes := 1;
  if BI.biSizeImage = 0 then
    BI.biSizeImage := BytesPerScanLine(BI.biWidth, BI.biBitCount, 32) *
      Abs(BI.biHeight);
end;

procedure InternalGetDIBSizes(Bitmap: HBITMAP; var InfoHeaderSize: Integer;
  var ImageSize: Longint; BitCount: TPixelFormat);
var
  BI: TBitmapInfoHeader;
begin
  InitializeBitmapInfoHeader(Bitmap, BI, BitCount);
  if BI.biBitCount > 8 then
  begin
    InfoHeaderSize := SizeOf(TBitmapInfoHeader);
    if (BI.biCompression and BI_BITFIELDS) <> 0 then
      Inc(InfoHeaderSize, 12);
  end
  else
    InfoHeaderSize := SizeOf(TBitmapInfoHeader) + SizeOf(TRGBQuad) *
      (1 shl BI.biBitCount);
  ImageSize := BI.biSizeImage;
end;

function InternalGetDIB(Bitmap: HBITMAP; Palette: HPALETTE;
  var BitmapInfo; var Bits; PixelFormat: TPixelFormat): Boolean;
var
  OldPal: HPALETTE;
  DC: HDC;
begin
  InitializeBitmapInfoHeader(Bitmap, TBitmapInfoHeader(BitmapInfo),
    PixelFormat);
  with TBitmapInfoHeader(BitmapInfo) do
    biHeight := Abs(biHeight);
  OldPal := 0;
  DC := CreateCompatibleDC(0);
  try
    if Palette <> 0 then
    begin
      OldPal := SelectPalette(DC, Palette, False);
      RealizePalette(DC);
    end;
    Result := GetDIBits(DC, Bitmap, 0, TBitmapInfoHeader(BitmapInfo).biHeight,
      @Bits, TBitmapInfo(BitmapInfo), DIB_RGB_COLORS) <> 0;
  finally
    if OldPal <> 0 then
      SelectPalette(DC, OldPal, False);
    DeleteDC(DC);
  end;
end;

function DIBFromBit(Src: HBITMAP; Pal: HPALETTE; PixelFormat: TPixelFormat;
  var Length: Longint): Pointer;
var
  HeaderSize: Integer;
  ImageSize: Longint;
  FileHeader: PBitmapFileHeader;
  BI: PBitmapInfoHeader;
  Bits: Pointer;
begin
  if Src = 0 then
    InvalidBitmap;
  InternalGetDIBSizes(Src, HeaderSize, ImageSize, PixelFormat);
  Length := SizeOf(TBitmapFileHeader) + HeaderSize + ImageSize;
  Result := AllocMemo(Length);
  try
    FillChar(Result^, Length, 0);
    FileHeader := Result;
    with FileHeader^ do
    begin
      bfType := $4D42;
      bfSize := Length;
      bfOffBits := SizeOf(FileHeader^) + HeaderSize;
    end;
    BI := PBitmapInfoHeader(Longint(FileHeader) + SizeOf(FileHeader^));
    Bits := Pointer(Longint(BI) + HeaderSize);
    InternalGetDIB(Src, Pal, BI^, Bits^, PixelFormat);
  except
    FreeMemo(Result);
    raise;
  end;
end;

{ Change bits per pixel in a General Bitmap }

function BitmapToMemoryStream(Bitmap: TBitmap; PixelFormat: TPixelFormat;
  Method: TMappingMethod): TMemoryStream;
var
  FileHeader: PBitmapFileHeader;
  BI, NewBI: PBitmapInfoHeader;
  Bits: Pointer;
  NewPalette: PRGBPalette;
  NewHeaderSize: Integer;
  ImageSize, Length, Len: Longint;
  P, InitData: Pointer;
  ColorCount: Integer;
begin
  Result := nil;
  if Bitmap.Handle = 0 then
    InvalidBitmap;
  if (GetBitmapPixelFormat(Bitmap) = PixelFormat) and
    (Method <> mmGrayscale) then
  begin
    Result := TMemoryStream.Create;
    try
      Bitmap.SaveToStream(Result);
      Result.Position := 0;
    except
      Result.Free;
      raise;
    end;
    Exit;
  end;
  if not (PixelFormat in [pf1bit, pf4bit, pf8bit, pf24bit]) then
    raise EJVCLException.Create(SPixelFormatNotImplemented)
  else
    if PixelFormat in [pf1bit, pf4bit] then
    begin
      P := DIBFromBit(Bitmap.Handle, Bitmap.Palette, PixelFormat, Length);
      try
        Result := TMemoryStream.Create;
        try
          Result.Write(P^, Length);
          Result.Position := 0;
        except
          Result.Free;
          raise;
        end;
      finally
        FreeMemo(P);
      end;
      Exit;
    end;
  { pf8bit - expand to 24bit first }
  InitData := DIBFromBit(Bitmap.Handle, Bitmap.Palette, pf24bit, Len);
  try
    BI := PBitmapInfoHeader(Longint(InitData) + SizeOf(TBitmapFileHeader));
    if BI^.biBitCount <> 24 then
      raise EJVCLException.Create(SBitCountNotImplemented);
    Bits := Pointer(Longint(BI) + SizeOf(TBitmapInfoHeader));
    InternalGetDIBSizes(Bitmap.Handle, NewHeaderSize, ImageSize, PixelFormat);
    Length := SizeOf(TBitmapFileHeader) + NewHeaderSize;
    P := AllocMemo(Length);
    try
      FillChar(P^, Length, #0);
      NewBI := PBitmapInfoHeader(Longint(P) + SizeOf(TBitmapFileHeader));
      NewPalette := PRGBPalette(Longint(NewBI) + SizeOf(TBitmapInfoHeader));
      FileHeader := PBitmapFileHeader(P);
      InitializeBitmapInfoHeader(Bitmap.Handle, NewBI^, PixelFormat);
      case Method of
        mmQuantize:
          begin
            ColorCount := 256;
            Quantize(BI^, Bits, Bits, ColorCount, NewPalette^);
            NewBI^.biClrImportant := ColorCount;
          end;
        mmTrunc784:
          begin
            TruncPal7R8G4B(NewPalette^);
            Trunc7R8G4B(BI^, Bits, Bits);
            NewBI^.biClrImportant := 224;
          end;
        mmTrunc666:
          begin
            TruncPal6R6G6B(NewPalette^);
            Trunc6R6G6B(BI^, Bits, Bits);
            NewBI^.biClrImportant := 216;
          end;
        mmTripel:
          begin
            TripelPal(NewPalette^);
            Tripel(BI^, Bits, Bits);
          end;
        mmHistogram:
          begin
            Histogram(BI^, NewPalette^, Bits, Bits,
              PixelFormatToColors(PixelFormat), 255, 255, 255);
          end;
        mmGrayscale:
          begin
            GrayPal(NewPalette^);
            GrayScale(BI^, Bits, Bits);
          end;
      end;
      with FileHeader^ do
      begin
        bfType := $4D42;
        bfSize := Length;
        bfOffBits := SizeOf(FileHeader^) + NewHeaderSize;
      end;
      Result := TMemoryStream.Create;
      try
        Result.Write(P^, Length);
        Result.Write(Bits^, ImageSize div 3);
        Result.Position := 0;
      except
        Result.Free;
        raise;
      end;
    finally
      FreeMemo(P);
    end;
  finally
    FreeMemo(InitData);
  end;
end;

function BitmapToMemory(Bitmap: TBitmap; Colors: Integer): TStream;
var
  PixelFormat: TPixelFormat;
begin
  if Colors <= 2 then
    PixelFormat := pf1bit
  else
    if Colors <= 16 then
      PixelFormat := pf4bit
    else
      if Colors <= 256 then
        PixelFormat := pf8bit
      else
        PixelFormat := pf24bit;
  Result := BitmapToMemoryStream(Bitmap, PixelFormat, DefaultMappingMethod);
end;

procedure SaveBitmapToFile(const FileName: string; Bitmap: TBitmap;
  Colors: Integer);
var
  Memory: TStream;
begin
  if Bitmap.Monochrome then
    Colors := 2;
  Memory := BitmapToMemory(Bitmap, Colors);
  try
    TMemoryStream(Memory).SaveToFile(FileName);
  finally
    Memory.Free;
  end;
end;

procedure SetBitmapPixelFormat(Bitmap: TBitmap; PixelFormat: TPixelFormat;
  Method: TMappingMethod);
var
  M: TMemoryStream;
begin
  if (Bitmap.Handle = 0) or (GetBitmapPixelFormat(Bitmap) = PixelFormat) then
    Exit;
  M := BitmapToMemoryStream(Bitmap, PixelFormat, Method);
  try
    Bitmap.LoadFromStream(M);
  finally
    M.Free;
  end;
end;

procedure GrayscaleBitmap(Bitmap: TBitmap);
begin
  SetBitmapPixelFormat(Bitmap, pf8bit, mmGrayscale);
end;

function ZoomImage(ImageW, ImageH, MaxW, MaxH: Integer; Stretch: Boolean):
  TPoint;
var
  Zoom: Double;
begin
  Result := Point(0, 0);
  if (MaxW <= 0) or (MaxH <= 0) or (ImageW <= 0) or (ImageH <= 0) then
    Exit;
  with Result do
    if Stretch then
    begin
      Zoom := MaxFloat([ImageW / MaxW, ImageH / MaxH]);
      if Zoom > 0 then
      begin
        X := round(ImageW * 0.98 / Zoom);
        Y := round(ImageH * 0.98 / Zoom);
      end
      else
      begin
        X := ImageW;
        Y := ImageH;
      end;
    end
    else
    begin
      X := MaxW;
      Y := MaxH;
    end;
end;

procedure TileImage(Canvas: TCanvas; Rect: TRect; Image: TGraphic);
var
  X, Y: Integer;
  SaveIndex: Integer;
begin
  if (Image.Width = 0) or (Image.Height = 0) then
    Exit;
  SaveIndex := SaveDC(Canvas.Handle);
  try
    with Rect do
      IntersectClipRect(Canvas.Handle, Left, Top, Right, Bottom);
    for X := 0 to (RectWidth(Rect) div Image.Width) do
      for Y := 0 to (RectHeight(Rect) div Image.Height) do
        Canvas.Draw(Rect.Left + X * Image.Width,
          Rect.Top + Y * Image.Height, Image);
  finally
    RestoreDC(Canvas.Handle, SaveIndex);
  end;
end;
{$ENDIF VCL}

//=== TJvGradientOptions ============================================================

constructor TJvGradientOptions.Create;
begin
  inherited Create;
  FStartColor := clSilver;
  FEndColor := clGray;
  FStepCount := 64;
  FDirection := fdTopToBottom;
end;

procedure TJvGradientOptions.Assign(Source: TPersistent);
begin
  if Source is TJvGradientOptions then
  begin
    with TJvGradientOptions(Source) do
    begin
      Self.FStartColor := StartColor;
      Self.FEndColor := EndColor;
      Self.FStepCount := StepCount;
      Self.FDirection := Direction;
      Self.FVisible := Visible;
    end;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TJvGradientOptions.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TJvGradientOptions.Draw(Canvas: TCanvas; Rect: TRect);
begin
  GradientFillRect(Canvas, Rect, FStartColor, FEndColor, FDirection,
    FStepCount);
end;

procedure TJvGradientOptions.SetStartColor(Value: TColor);
begin
  if Value <> FStartColor then
  begin
    FStartColor := Value;
    Changed;
  end;
end;

procedure TJvGradientOptions.SetEndColor(Value: TColor);
begin
  if Value <> FEndColor then
  begin
    FEndColor := Value;
    Changed;
  end;
end;

procedure TJvGradientOptions.SetDirection(Value: TFillDirection);
begin
  if Value <> FDirection then
  begin
    FDirection := Value;
    Changed;
  end;
end;

procedure TJvGradientOptions.SetStepCount(Value: byte);
begin
  if Value <> FStepCount then
  begin
    FStepCount := Value;
    Changed;
  end;
end;

procedure TJvGradientOptions.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed;
  end;
end;
{ end JvGraph }

{ begin JvCtrlUtils }

//==============================================================================
// ToolBarMenu
//==============================================================================

procedure JvCreateToolBarMenu(AForm: TForm; AToolBar: TToolBar; AMenu:
  TMainMenu);
var
  i, TotalWidth: Integer;
  Button: TToolButton;
begin
  if AForm.FormStyle = fsMDIForm then
    raise EJclError.CreateResRec(@RsNotForMdi);
  if AMenu = nil then
    AMenu := AForm.Menu;
  if AMenu = nil then
    Exit;
  with AToolBar do
  begin
    TotalWidth := BorderWidth;
{$IFDEF VCL}
    for i := ButtonCount - 1 downto 0 do
      Buttons[i].Free;
{$ENDIF}
{$IFDEF VisualCLX}
    for i := ControlCount - 1 downto 0 do
      if Controls[i] is TToolButton then
        Controls[i].Free;
{$ENDIF}
    ShowCaptions := True;
  end;
  with AMenu do
    for i := Items.Count - 1 downto 0 do
    begin
      Button := TToolButton.Create(AToolBar);
      Button.Parent := AToolBar;
      Button.AutoSize := True;
      Button.Caption := Items[i].Caption;
      Button.Grouped := True;
{$IFDEF VCL}
      Button.MenuItem := Items[i];
{$ENDIF}
{$IFDEF VisualCLX}
      if Items[i].Action <> nil then
        Button.Action := Items[i].Action
      else
      begin
        Button.Caption := Items[i].Caption;
        Button.Enabled := Items[i].Enabled;
        Button.ImageIndex := Items[i].ImageIndex;
        Button.OnClick := Items[i].OnClick;
      end;
{$ENDIF}
      Inc(TotalWidth, Button.Width + AToolBar.BorderWidth);
    end;
  AToolBar.Width := TotalWidth;
  AForm.Menu := nil;
end;

//==============================================================================
// ListView functions
//==============================================================================

procedure JvListViewToStrings(ListView: TListView; Strings: TStrings;
  SelectedOnly: Boolean; Headers: Boolean);
var
  r, C: Integer;
  ColWidths: array of Word;
  s: string;

  procedure AddLine;
  begin
    Strings.Add(TrimRight(s));
  end;

  function MakeCellStr(const Text: string; Index: Integer): string;
  begin
    with ListView.Columns[Index] do
      if Alignment = taLeftJustify then
        Result := StrPadRight(Text, ColWidths[Index] + 1)
      else
        Result := StrPadLeft(Text, ColWidths[Index]) + ' ';
  end;

begin
  SetLength(s, 256);
  with ListView do
  begin
    SetLength(ColWidths, Columns.Count);
    if Headers then
      for C := 0 to Columns.Count - 1 do
        ColWidths[C] := Length(Trim(Columns[C].Caption));
    for r := 0 to Items.Count - 1 do
      if not SelectedOnly or Items[r].Selected then
      begin
        ColWidths[0] := Max(ColWidths[0], Length(Trim(Items[r].Caption)));
        for C := 0 to Items[r].SubItems.Count - 1 do
          ColWidths[C + 1] := Max(ColWidths[C + 1],
            Length(Trim(Items[r].SubItems[C])));
      end;
    Strings.BeginUpdate;
    try
      if Headers then
        with Columns do
        begin
          s := '';
          for C := 0 to Count - 1 do
            s := s + MakeCellStr(Items[C].Caption, C);
          AddLine;
          s := '';
          for C := 0 to Count - 1 do
            s := s + StringOfChar('-', ColWidths[C]) + ' ';
          AddLine;
        end;
      for r := 0 to Items.Count - 1 do
        if not SelectedOnly or Items[r].Selected then
          with Items[r] do
          begin
            s := MakeCellStr(Caption, 0);
            for C := 0 to Min(SubItems.Count, Columns.Count - 1) - 1 do
              s := s + MakeCellStr(SubItems[C], C + 1);
            AddLine;
          end;
    finally
      Strings.EndUpdate;
    end;
  end;
end;

function JvListViewSafeSubItemString(Item: TListItem; SubItemIndex: Integer):
  string;
begin
  if Item.SubItems.Count > SubItemIndex then
    Result := Item.SubItems[SubItemIndex]
  else
    Result := ''
end;

procedure JvListViewSortClick(Column: TListColumn; AscendingSortImage: Integer;
  DescendingSortImage: Integer);
var
  ListView: TListView;
{$IFDEF VCL}
  i: Integer;
{$ENDIF}
begin
  ListView := TListColumns(Column.Collection).Owner as TListView;
  ListView.Columns.BeginUpdate;
  try
    with ListView.Columns do
{$IFDEF VCL}
      for i := 0 to Count - 1 do
        Items[i].ImageIndex := -1;
{$ENDIF}
    if ListView.Tag and $FF = Column.Index then
      ListView.Tag := ListView.Tag xor $100
    else
      ListView.Tag := Column.Index;
{$IFDEF VCL}
    if ListView.Tag and $100 = 0 then
      Column.ImageIndex := AscendingSortImage
    else
      Column.ImageIndex := DescendingSortImage;
{$ENDIF}
  finally
    ListView.Columns.EndUpdate;
  end;
end;

procedure JvListViewCompare(ListView: TListView; Item1, Item2: TListItem;
  var Compare: Integer);
var
  ColIndex: Integer;

  function FmtStrToInt(s: string): Integer;
  var
    i: Integer;
  begin
    i := 1;
    while i <= Length(s) do
      if not (s[i] in (DigitChars + ['-'])) then
        Delete(s, i, 1)
      else
        Inc(i);
    Result := StrToInt(s);
  end;

begin
  with ListView do
  begin
    ColIndex := Tag and $FF - 1;
    if Columns[ColIndex + 1].Alignment = taLeftJustify then
    begin
      if ColIndex = -1 then
        Compare := AnsiCompareText(Item1.Caption, Item2.Caption)
      else
        Compare := AnsiCompareText(Item1.SubItems[ColIndex],
          Item2.SubItems[ColIndex]);
    end
    else
    begin
      if ColIndex = -1 then
        Compare := FmtStrToInt(Item1.Caption) - FmtStrToInt(Item2.Caption)
      else
        Compare := FmtStrToInt(Item1.SubItems[ColIndex]) -
          FmtStrToInt(Item2.SubItems[ColIndex]);
    end;
    if Tag and $100 <> 0 then
      Compare := -Compare;
  end;
end;

procedure JvListViewSelectAll(ListView: TListView; Deselect: Boolean);
var
  i: Integer;
{$IFDEF VCL}
  h: THandle;
  Data: Integer;
{$ENDIF}
  SaveOnSelectItem: TLVSelectItemEvent;
begin
  with ListView do
    if MultiSelect then
    begin
      Items.BeginUpdate;
      SaveOnSelectItem := OnSelectItem;
      WaitCursor;
      try
{$IFDEF VCL}
        h := Handle;
        OnSelectItem := nil;
        if Deselect then
          Data := 0
        else
          Data := LVIS_SELECTED;
        for i := 0 to Items.Count - 1 do
          ListView_SetItemState(h, i, Data, LVIS_SELECTED);
{$ENDIF}
{$IFDEF VisualCLX}
        for i := 0 to Items.Count - 1 do
          Items[i].Selected := not Deselect;
{$ENDIF}
      finally
        OnSelectItem := SaveOnSelectItem;
        Items.EndUpdate;
      end;
    end;
end;

function JvListViewSaveState(ListView: TListView): TJvLVItemStateData;
var
  TempItem: TListItem;
begin
  with Result do
  begin
    Focused := Assigned(ListView.ItemFocused);
    Selected := Assigned(ListView.Selected);
    if Focused then
      TempItem := ListView.ItemFocused
    else
      if Selected then
        TempItem := ListView.Selected
      else
        TempItem := nil;
    if TempItem <> nil then
    begin
      Caption := TempItem.Caption;
      Data := TempItem.Data;
    end
    else
    begin
      Caption := '';
      Data := nil;
    end;
  end;
end;

function JvListViewRestoreState(ListView: TListView; Data: TJvLVItemStateData;
  MakeVisible: Boolean; FocusFirst: Boolean): Boolean;
var
  TempItem: TListItem;
begin
  with ListView do
  begin
    TempItem := FindCaption(0, Data.Caption, False, True, False);
    Result := TempItem <> nil;
    if Result then
    begin
      TempItem.Focused := Data.Focused;
      TempItem.Selected := Data.Selected;
    end
    else
      if FocusFirst and (Items.Count > 0) then
      begin
        TempItem := Items[0];
        TempItem.Focused := True;
        TempItem.Selected := True;
      end;
    if MakeVisible and (TempItem <> nil) then
{$IFDEF VCL}
      TempItem.MakeVisible(True);
{$ENDIF}
{$IFDEF VisualCLX}
    TempItem.MakeVisible;
{$ENDIF}
  end;
end;

{$IFDEF VCL}

function JvListViewGetOrderedColumnIndex(Column: TListColumn): Integer;
var
  ColumnOrder: array of Integer;
  Columns: TListColumns;
  i: Integer;
begin
  Result := -1;
  Columns := TListColumns(Column.Collection);
  SetLength(ColumnOrder, Columns.Count);
  ListView_GetColumnOrderArray(Columns.Owner.Handle, Columns.Count,
    PInteger(ColumnOrder));
  for i := 0 to High(ColumnOrder) do
    if ColumnOrder[i] = Column.Index then
    begin
      Result := i;
      break;
    end;
end;

procedure JvListViewSetSystemImageList(ListView: TListView);
var
  FileInfo: TSHFileInfo;
  ImageListHandle: THandle;
begin
  FillChar(FileInfo, SizeOf(FileInfo), #0);
  ImageListHandle := SHGetFileInfo('', 0, FileInfo, SizeOf(FileInfo),
    SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
  SendMessage(ListView.Handle, LVM_SETIMAGELIST, LVSIL_SMALL, ImageListHandle);
  FillChar(FileInfo, SizeOf(FileInfo), #0);
  ImageListHandle := SHGetFileInfo('', 0, FileInfo, SizeOf(FileInfo),
    SHGFI_SYSICONINDEX or SHGFI_LARGEICON);
  SendMessage(ListView.Handle, LVM_SETIMAGELIST, LVSIL_NORMAL, ImageListHandle);
end;
{$ENDIF VCL}

//==============================================================================
// MessageBox
//==============================================================================

function JvMessageBox(const Text, Caption: string; Flags: DWORD): Integer;
begin
  Result := MsgBox(Text, Caption, Flags);
end;

function JvMessageBox(const Text: string; Flags: DWORD): Integer;
begin
  Result := MsgBox(Text, Application.Title, Flags);
end;

procedure UpdateTrackFont(TrackFont, Font: TFont; TrackOptions:
  TJvTrackFontOptions);
begin
  if hoFollowFont in TrackOptions then
  begin
    if not (hoPreserveCharSet in TrackOptions) then
      TrackFont.CharSet := Font.CharSet;
    if not (hoPreserveColor in TrackOptions) then
      TrackFont.Color := Font.Color;
    if not (hoPreserveHeight in TrackOptions) then
      TrackFont.Height := Font.Height;
    if not (hoPreserveName in TrackOptions) then
      TrackFont.Name := Font.Name;
    if not (hoPreservePitch in TrackOptions) then
      TrackFont.Pitch := Font.Pitch;
    if not (hoPreserveStyle in TrackOptions) then
      TrackFont.Style := Font.Style;
  end;
end;

{ end JvCtrlUtils }

function GetDefaultCheckBoxSize: TSize;
begin
{$IFDEF VCL}
  with TBitmap.Create do
  try
    Handle := LoadBitmap(0, PChar(OBM_CHECKBOXES));
    Result.cx := Width div 4;
    Result.cy := Height div 3;
  finally
    Free;
  end;
{$ELSE}
  Result.cx := 12;
  Result.cy := 12;
{$ENDIF}
end;

initialization
  { begin JvGraph }
  InitTruncTables;
  { end JvGraph }
  if Screen <> nil then
  begin
    { begin RxLib }
    Screen.Cursors[crHand] := LoadCursor(hInstance, 'JV_HANDCUR');
    Screen.Cursors[crDragHand] := LoadCursor(hInstance, 'JV_DRAGCUR');
    { end RxLib }
    Screen.Cursors[crMultiDragLink] := Screen.Cursors[crMultiDrag];
    Screen.Cursors[crDragAlt] := Screen.Cursors[crDrag];
    Screen.Cursors[crMultiDragAlt] := Screen.Cursors[crMultiDrag];
    Screen.Cursors[crMultiDragLinkAlt] := Screen.Cursors[crMultiDrag];
  end;

{ begin JvVCLUtils }
finalization
  ReleaseBitmap;
{ end from JvVCLUtils }

end.

