{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvRichEd.PAS, released on 2002-07-04.

The Initial Developers of the Original Code are: Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 1997, 1998 Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 2001,2002 SGB Software
Portions created by S�bastien Buysse are Copyright (C) 2001 S�bastien Buysse.
All Rights Reserved.

Contributor(s):
  Polaris Software
  S�bastien Buysse [sbuysse@buypin.com] (original code in JvRichEdit.pas)
  Michael Beck [mbeck@bigfoot.com] (contributor to JvRichEdit.pas)
  Roman Kovbasiouk [roko@users.sourceforge.net] (merging JvRichEdit.pas)
  Remko Bonte [remkobonte@myrealbox.com] (insert image procedures, MS Text converters)
  Jacob Boerema [jgboerema@hotmail.com] (indentation style)

Last Modified: 2003-11-4

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvRichEdit;

{.$DEFINE RICHEDIT_VER_10}

{$R-}

interface

{$HPPEMIT '#define CHARFORMAT2A Richedit::CHARFORMAT2A'}

uses
  Windows,
  ActiveX, ComObj,
  CommCtrl, Messages, SysUtils, Classes, Controls, Forms, Graphics, StdCtrls,
  Dialogs, RichEdit, Menus, ComCtrls, JVCLVer, SyncObjs;

type
  TRichEditVersion = 1..3;

  // Polaris
  //  TCharFormat2 = TCharFormat2A;

type
  TJvCustomRichEdit = class;

  TJvAttributeType = (atDefaultText, atSelected, atWord);
  TJvConsistentAttribute = (caBold, caColor, caFace, caItalic, caSize,
    caStrikeOut, caUnderline, caProtected, caOffset, caHidden, caLink,
    caBackColor, caDisabled, caWeight, caSubscript, caRevAuthor);
  TJvConsistentAttributes = set of TJvConsistentAttribute;
  TSubscriptStyle = (ssNone, ssSubscript, ssSuperscript);
  TUnderlineType = (utNone, utSolid, utWord, utDouble, utDotted, utDash,
    utDashDot, utDashDotDot, utWave, utThick);
  TUnderlineColor = (ucBlack, ucBlue, ucAqua, ucLime, ucFuchsia, ucRed,
    ucYellow, ucWhite, ucNavy, ucTeal, ucGreen, ucPurple, ucMaroon, ucOlive,
    ucGray, ucSilver);

  TJvTextAttributes = class(TPersistent)
  private
    FRichEdit: TJvCustomRichEdit;
    FType: TJvAttributeType;
    procedure AssignFont(Font: TFont);
    procedure GetAttributes(var Format: TCharFormat2);
    procedure SetAttributes(var Format: RichEdit.TCharFormat2);
    function GetBackColor: TColor;
    function GetCharset: TFontCharset;
    function GetColor: TColor;
    function GetConsistentAttributes: TJvConsistentAttributes;
    function GetDisabled: Boolean;
    function GetHeight: Integer;
    function GetHidden: Boolean;
    function GetLink: Boolean;
    function GetName: TFontName;
    function GetOffset: Integer;
    function GetPitch: TFontPitch;
    function GetProtected: Boolean;
    function GetRevAuthorIndex: Byte;
    function GetSize: Integer;
    function GetStyle: TFontStyles;
    function GetSubscriptStyle: TSubscriptStyle;
    function GetUnderlineColor: TUnderlineColor;
    function GetUnderlineType: TUnderlineType;
    procedure SetBackColor(Value: TColor);
    procedure SetCharset(Value: TFontCharset);
    procedure SetColor(Value: TColor);
    procedure SetDisabled(Value: Boolean);
    procedure SetHeight(Value: Integer);
    procedure SetHidden(Value: Boolean);
    procedure SetLink(Value: Boolean);
    procedure SetName(Value: TFontName);
    procedure SetOffset(Value: Integer);
    procedure SetPitch(Value: TFontPitch);
    procedure SetProtected(Value: Boolean);
    procedure SetRevAuthorIndex(Value: Byte);
    procedure SetSize(Value: Integer);
    procedure SetStyle(Value: TFontStyles);
    procedure SetSubscriptStyle(Value: TSubscriptStyle);
    procedure SetUnderlineColor(const Value: TUnderlineColor);
    procedure SetUnderlineType(Value: TUnderlineType);
  protected
    procedure InitFormat(var Format: RichEdit.TCharFormat2);
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AOwner: TJvCustomRichEdit; AttributeType: TJvAttributeType);
    procedure Assign(Source: TPersistent); override;
    property BackColor: TColor read GetBackColor write SetBackColor;
    property Charset: TFontCharset read GetCharset write SetCharset;
    property Color: TColor read GetColor write SetColor;
    property ConsistentAttributes: TJvConsistentAttributes read GetConsistentAttributes;
    property Disabled: Boolean read GetDisabled write SetDisabled;
    property Height: Integer read GetHeight write SetHeight;
    property Hidden: Boolean read GetHidden write SetHidden;
    property Link: Boolean read GetLink write SetLink;
    property Name: TFontName read GetName write SetName;
    property Offset: Integer read GetOffset write SetOffset;
    property Pitch: TFontPitch read GetPitch write SetPitch;
    property Protected: Boolean read GetProtected write SetProtected;
    property RevAuthorIndex: Byte read GetRevAuthorIndex write SetRevAuthorIndex;
    property Size: Integer read GetSize write SetSize;
    property Style: TFontStyles read GetStyle write SetStyle;
    property SubscriptStyle: TSubscriptStyle read GetSubscriptStyle write SetSubscriptStyle;
    property UnderlineColor: TUnderlineColor read GetUnderlineColor write SetUnderlineColor;
    property UnderlineType: TUnderlineType read GetUnderlineType write SetUnderlineType;
  end;

  TJvNumbering = (nsNone, nsBullet, nsArabicNumbers, nsLoCaseLetter,
    nsUpCaseLetter, nsLoCaseRoman, nsUpCaseRoman);
  TJvNumberingStyle = (nsParenthesis, nsPeriod, nsEnclosed, nsSimple);
  TParaAlignment = (paLeftJustify, paRightJustify, paCenter, paJustify);
  TLineSpacingRule = (lsSingle, lsOneAndHalf, lsDouble, lsSpecifiedOrMore,
    lsSpecified, lsMultiple);
  THeadingStyle = 0..9;
  TParaTableStyle = (tsNone, tsTableRow, tsTableCellEnd, tsTableCell);

  TJvIndentationStyle = (isRichEdit, isOffice); // added by J.G. Boerema
  // TJvIndentationStyle: default is isRichEdit
  // - isRichEdit: LefIndent relative to FirstIndent
  // - isOffice: FirstIndent relative to LeftIndent (like MsWord and WordPad)
  // For example when FirstIndent=2 and LeftIndent=1 the effect is:
  // isRichEdit: first line starts at 2 and following lines at 3
  // isOffice: first line starts at 3 and following lines at 1

  TJvParaAttributes = class(TPersistent)
  private
    FRichEdit: TJvCustomRichEdit;
    FIndentationStyle: TJvIndentationStyle; // added by J.G. Boerema
    procedure GetAttributes(var Paragraph: TParaFormat2);
    function GetAlignment: TParaAlignment;
    function GetFirstIndent: Longint;
    function GetHeadingStyle: THeadingStyle;
    function GetLeftIndent: Longint;
    function GetLineSpacing: Longint;
    function GetLineSpacingRule: TLineSpacingRule;
    function GetNumbering: TJvNumbering;
    function GetNumberingStart: Integer;
    function GetNumberingStyle: TJvNumberingStyle;
    function GetNumberingTab: Word;
    function GetRightIndent: Longint;
    function GetSpaceAfter: Longint;
    function GetSpaceBefore: Longint;
    function GetTab(Index: Byte): Longint;
    function GetTabCount: Integer;
    function GetTableStyle: TParaTableStyle;
    procedure SetAlignment(Value: TParaAlignment);
    procedure SetAttributes(var Paragraph: TParaFormat2);
    procedure SetFirstIndent(Value: Longint);
    procedure SetHeadingStyle(Value: THeadingStyle);
    procedure SetLeftIndent(Value: Longint);
    procedure SetLineSpacing(Value: Longint);
    procedure SetLineSpacingRule(Value: TLineSpacingRule);
    procedure SetNumbering(Value: TJvNumbering);
    procedure SetNumberingStart(const Value: Integer);
    procedure SetNumberingStyle(Value: TJvNumberingStyle);
    procedure SetNumberingTab(Value: Word);
    procedure SetRightIndent(Value: Longint);
    procedure SetSpaceAfter(Value: Longint);
    procedure SetSpaceBefore(Value: Longint);
    procedure SetTab(Index: Byte; Value: Longint);
    procedure SetTabCount(Value: Integer);
    procedure SetTableStyle(Value: TParaTableStyle);
  protected
    procedure InitPara(var Paragraph: TParaFormat2);
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AOwner: TJvCustomRichEdit);
    procedure Assign(Source: TPersistent); override;
    property Alignment: TParaAlignment read GetAlignment write SetAlignment;
    property FirstIndent: Longint read GetFirstIndent write SetFirstIndent;
    property HeadingStyle: THeadingStyle read GetHeadingStyle write SetHeadingStyle;
    property IndentationStyle: TJvIndentationStyle read FIndentationStyle
      write FIndentationStyle; // added by J.G. Boerema
    property LeftIndent: Longint read GetLeftIndent write SetLeftIndent;
    property LineSpacing: Longint read GetLineSpacing write SetLineSpacing;
    property LineSpacingRule: TLineSpacingRule read GetLineSpacingRule write SetLineSpacingRule;
    property Numbering: TJvNumbering read GetNumbering write SetNumbering;
    property NumberingStart: Integer read GetNumberingStart write SetNumberingStart;
    property NumberingStyle: TJvNumberingStyle read GetNumberingStyle write SetNumberingStyle;
    property NumberingTab: Word read GetNumberingTab write SetNumberingTab;
    property RightIndent: Longint read GetRightIndent write SetRightIndent;
    property SpaceAfter: Longint read GetSpaceAfter write SetSpaceAfter;
    property SpaceBefore: Longint read GetSpaceBefore write SetSpaceBefore;
    property Tab[Index: Byte]: Longint read GetTab write SetTab;
    property TabCount: Integer read GetTabCount write SetTabCount;
    property TableStyle: TParaTableStyle read GetTableStyle write SetTableStyle;
  end;

  TJvConversionKind = (ckImport, ckExport);
  TJvConversionTextKind = (ctkText, ctkRTF, ctkBothPreferText, ctkBothPreferRTF);

  TJvConverter = class(TObject)
  private
    FOnProgress: TNotifyEvent;
  protected
    FProgress: Integer;
    procedure DoProgress(ANewProgress: Integer);
  public
    function CanHandle(const AExtension: string; const AKind: TJvConversionKind): Boolean; overload; virtual;
    function CanHandle(const AKind: TJvConversionKind): Boolean; overload; virtual;
    function Filter: string; virtual;
    function TextKind: TJvConversionTextKind; virtual;
    function IsFormatCorrect(const AFileName: string): Boolean; overload; virtual;
    function IsFormatCorrect(AStream: TStream): Boolean; overload; virtual;

    function Open(const AFileName: string; const AKind: TJvConversionKind): Boolean; overload; virtual;
    function Open(Stream: TStream; const AKind: TJvConversionKind): Boolean; overload; virtual;
    procedure Done; virtual;
    function Retry: Boolean; virtual;

    function ConvertRead(Buffer: PChar; BufSize: Integer): Integer; virtual;
    function ConvertWrite(Buffer: PChar; BufSize: Integer): Integer; virtual;

    function Error: Boolean; virtual;
    function ErrorStr: string; virtual;

    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    property Progress: Integer read FProgress;
  end;

  TJvStreamConversion = class(TJvConverter)
  private
    FStream: TStream;
    FSavedPosition: Int64;
    FStreamSize: Integer;
    FFreeStream: Boolean;
    FConvertByteCount: Integer;
  public
    function Open(const AFileName: string; const AKind: TJvConversionKind): Boolean; override;
    function Open(Stream: TStream; const AKind: TJvConversionKind): Boolean; override;
    procedure Done; override;
    function Retry: Boolean; override;
    function ConvertRead(Buffer: PChar; BufSize: Integer): Integer; override;
    function ConvertWrite(Buffer: PChar; BufSize: Integer): Integer; override;
    property Stream: TStream read FStream;
  end;

  TJvTextConversion = class(TJvStreamConversion)
  public
    function CanHandle(const AExtension: string; const AKind: TJvConversionKind): Boolean; override;
    function Filter: string; override;
    function TextKind: TJvConversionTextKind; override;
  end;

  TJvRTFConversion = class(TJvStreamConversion)
  public
    function CanHandle(const AExtension: string; const AKind: TJvConversionKind): Boolean; override;
    function Filter: string; override;
    function TextKind: TJvConversionTextKind; override;
    function IsFormatCorrect(const AFileName: string): Boolean; override;
    function IsFormatCorrect(AStream: TStream): Boolean; override;
  end;

  TJvOEMConversion = class(TJvStreamConversion)
  public
    function ConvertRead(Buffer: PChar; BufSize: Integer): Integer; override;
    function ConvertWrite(Buffer: PChar; BufSize: Integer): Integer; override;
    function TextKind: TJvConversionTextKind; override;
  end;

  FCE = SmallInt; // File Conversion Error

  { typedef long (PASCAL *PFN_RTF)(long, long); }
  PFN_RTF = function(I1, I2: LongInt): Longint; stdcall;
  { long PASCAL InitConverter32(HANDLE hWnd, char *szModule); }
  TInitConverter32 = function(hWnd: THandle; szModule: PChar): LongBool; stdcall;
  { void PASCAL UninitConverter(void); }
  TUninitConverter = procedure; stdcall;
  { void PASCAL GetReadNames(HANDLE haszClass, HANDLE haszDescrip, HANDLE haszExt); }
  TGetReadNames = procedure(haszClass, haszDescrip, haszExt: THandle); stdcall;
  { void PASCAL GetWriteNames(HANDLE haszClass, HANDLE haszDescrip, HANDLE haszExt); }
  TGetWriteNames = procedure(haszClass, haszDescrip, haszExt: THandle); stdcall;
  { HGLOBAL PASCAL RegisterApp(unsigned long lFlags, void FAR *lpFuture); }
  TRegisterApp = function(lFlags: DWORD; lpFuture: pointer): HGLOBAL; stdcall;
  { FCE  PASCAL IsFormatCorrect32(HANDLE ghszFile, HANDLE ghszClass); }
  TIsFormatCorrect32 = function(ghszFile, ghszClass: THandle): FCE; stdcall;
  { FCE  PASCAL ForeignToRtf32(HANDLE ghszFile, void *pstgForeign, HANDLE ghBuff, HANDLE ghszClass, HANDLE ghszSubset, PFN_RTF lpfnOut); }
  TForeignToRtf32 = function(ghszFile: THandle; pstgForeign: Pointer; ghBuff, ghszClass, ghszSubset: THandle;
    lpfnOut: PFN_RTF): FCE; stdcall;
  { FCE  PASCAL RtfToForeign32(HANDLE ghszFile, void *pstgForeign, HANDLE ghBuff, HANDLE ghshClass, PFN_RTF lpfnIn); }
  TRtfToForeign32 = function(ghszFile: THandle; pstgForeign: Pointer; ghBuff, ghshClass: THandle;
    lpfnIn: PFN_RTF): FCE; stdcall;
  { long PASCAL CchFetchLpszError(long fce, char FAR *lpszError, long cb); }
  TCchFetchLpszError = function(fce: LongInt; lpszError: PChar; cb: LongInt): LongInt stdcall;
  { long PASCAL FRegisterConverter(HANDLE hkeyRoot); }
  TFRegisterConverter = function(hkeyRoot: THandle): LongInt; stdcall;

  TJvMSTextConversion = class(TJvConverter)
  private
    FConverterFileName: string;
    FExtensions: TStringList;
    FDescription: string;
    FConverterKind: TJvConversionKind;

    FConverter: HMODULE;
    FInitConverter32: TInitConverter32;
    FUninitConverter: TUninitConverter;
    FIsFormatCorrect32: TIsFormatCorrect32;
    FForeignToRtf32: TForeignToRtf32;
    FRtfToForeign32: TRtfToForeign32;
    FCchFetchLpszError: TCchFetchLpszError;

    { Indicates whether the thread is done }
    FThreadDone: Boolean;
    { Indicates whether the conversion process has been cancelled by the
      main thread }
    FCancel: Boolean;

    FBytesAvailable: Integer;
    { Buffer accessable by the converter dll }
    FBuffer: HGLOBAL;
    FBufferPtr: PChar;
    FTempProgress: Integer;

    { Thread synchronization based on the source of Wordpad, see
      http://cvs.wndtabs.com/cgi-bin/viewcvs/viewcvs.cgi/BCG/WordPad/

      Import works as follows

      Thread                            RichEdit
      ------                            --------
      loop:                             loop:
        @@ Converter converts buffer1     @@ Copy buffer1 to buffer2
                                          richedit processes buffer2

      The @@ parts may not happen simultaneously, thus this is converted to:

      Thread                            RichEdit
      ------                            --------
      loop:                             loop:
        @@ Converter converts buffer1     [wait until thread ready]
        [thread ready]                    @@ Copy buffer1 to buffer2
        [wait until richedit ready]       [richedit ready]
                                          richedit retrieves data from buffer2

      Export works as follows:

      Thread                            RichEdit
      ------                            --------
      loop:                             loop:
        @@ Converter converts buffer1     richedit puts data in buffer2
                                          @@ Copy buffer2 to buffer1

      The @@ parts may not happen simultaneously, thus this is converted to:

      Thread                            RichEdit
      ------                            --------
      loop:                             loop:
        [thread ready]                    richedit puts data in buffer2
        [wait until richedit ready]       [wait until thread ready]
        @@ Converter converts buffer1     @@ Copy buffer2 to buffer1
                                          [richedit ready]

      - buffer1 is FBuffer
      - buffer2 is the Buffer param from ConvertRead or ConvertWrite

    }

    FRichEditReady: TEvent;
    FThreadReady: TEvent;
    FConversionError: FCE;
    FFileName: HMODULE;
    FInitDone: Boolean;
  protected
    procedure LoadConverter;
    procedure FreeConverter;
    procedure Check(Result: FCE);
    procedure DoError(ErrorCode: FCE);

    { Handled in the context of the thread: }
    procedure DoConversion;
    function HandleExportCallback(cchBuff, nPercent: Longint): Longint;
    function HandleImportCallback(cchBuff, nPercent: Longint): Longint;
    procedure WaitUntilThreadReady;
    procedure WaitUntilRichEditReady;

    procedure Lock;
    procedure Unlock;

    procedure Init;
  public
    constructor Create(const AConverterFileName, AExtensions, ADescription: string;
      const AKind: TJvConversionKind); virtual;
    destructor Destroy; override;

    function CanHandle(const AExtension: string; const AKind: TJvConversionKind): Boolean; override;
    function CanHandle(const AKind: TJvConversionKind): Boolean; override;

    function Open(const AFileName: string; const AKind: TJvConversionKind): Boolean; override;
    procedure Done; override;

    function TextKind: TJvConversionTextKind; override;
    function Filter: string; override;
    function IsFormatCorrect(const AFileName: string): Boolean; override;
    function TranslateError(ErrorCode: FCE): string;

    function ConvertRead(Buffer: PChar; BufSize: Integer): Integer; override;
    function ConvertWrite(Buffer: PChar; BufSize: Integer): Integer; override;

    function Error: Boolean; override;
    function ErrorStr: string; override;
  end;

  TUndoName = (unUnknown, unTyping, unDelete, unDragDrop, unCut, unPaste);
  TRichSearchType = (stWholeWord, stMatchCase, stBackward, stSetSelection);
  TRichSearchTypes = set of TRichSearchType;
  TRichSelection = (stText, stObject, stMultiChar, stMultiObject);
  TRichSelectionType = set of TRichSelection;
  TRichLangOption = (rlAutoKeyboard, rlAutoFont, rlImeCancelComplete,
    rlImeAlwaysSendNotify);
  TRichLangOptions = set of TRichLangOption;
  TRichStreamFormat = (sfDefault, sfRichText, sfPlainText);
  TRichStreamMode = (smSelection, smPlainRtf, smNoObjects, smUnicode);
  TRichStreamModes = set of TRichStreamMode;
  TRichEditURLClickEvent = procedure(Sender: TObject; const URLText: string;
    Button: TMouseButton) of object;
  TRichEditProtectChangeEx = procedure(Sender: TObject; const Msg: TMessage;
    StartPos, EndPos: Integer; var AllowChange: Boolean) of object;
  TRichEditFindErrorEvent = procedure(Sender: TObject; const FindText: string) of object;
  TRichEditFindCloseEvent = procedure(Sender: TObject; Dialog: TFindDialog) of object;
  TRichEditProgressEvent = procedure(Sender: TObject; NewProgress: Integer) of object;

  TJvCustomRichEdit = class(TCustomMemo)
  private
    FHideScrollBars: Boolean;
    FSelectionBar: Boolean;
    FAutoURLDetect: Boolean;
    FWordSelection: Boolean;
    FPlainText: Boolean;
    FSelAttributes: TJvTextAttributes;
    FDefAttributes: TJvTextAttributes;
    FWordAttributes: TJvTextAttributes;
    FParagraph: TJvParaAttributes;
    FOldParaAlignment: TParaAlignment;
    FScreenLogPixels: Integer;
    FUndoLimit: Integer;
    FRichEditStrings: TStrings;
    FMemStream: TMemoryStream;
    FHideSelection: Boolean;
    FLangOptions: TRichLangOptions;
    FModified: Boolean;
    FLinesUpdating: Boolean;
    FPageRect: TRect;
    FClickRange: TCharRange;
    FClickBtn: TMouseButton;
    FFindDialog: TFindDialog;
    FReplaceDialog: TReplaceDialog;
    FLastFind: TFindDialog;
    FAllowObjects: Boolean;
    FCallback: TObject;
    FRichEditOle: IUnknown;
    FPopupVerbMenu: TPopupMenu;
    FTitle: string;
    FAutoVerbMenu: Boolean;
    FAllowInPlace: Boolean;
    FDefaultConverter: TJvConverter;
    FImageRect: TRect;
    FOnSelChange: TNotifyEvent;
    FOnResizeRequest: TRichEditResizeEvent;
    FOnProtectChange: TRichEditProtectChange;
    FOnProtectChangeEx: TRichEditProtectChangeEx;
    FOnSaveClipboard: TRichEditSaveClipboard;
    FOnURLClick: TRichEditURLClickEvent;
    FOnTextNotFound: TRichEditFindErrorEvent;
    FOnCloseFindDialog: TRichEditFindCloseEvent;
    // From JvRichEdit.pas by S�bastien Buysse
    FAboutJVCL: TJVCLAboutInfo;
    FHintColor, FSavedHintColor: TColor;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnCtl3DChanged: TNotifyEvent;
    FOnParentColorChanged: TNotifyEvent;
    FOnHorizontalScroll: TNotifyEvent;
    FOnVerticalScroll: TNotifyEvent;
    FOnConversionProgress: TRichEditProgressEvent;

    function GetAutoURLDetect: Boolean;
    function GetWordSelection: Boolean;
    function GetLangOptions: TRichLangOptions;
    function GetCanRedo: Boolean;
    function GetCanPaste: Boolean;
    function GetRedoName: TUndoName;
    function GetUndoName: TUndoName;
    function GetStreamFormat: TRichStreamFormat;
    function GetStreamMode: TRichStreamModes;
    function GetSelectionType: TRichSelectionType;
    procedure PopupVerbClick(Sender: TObject);
    procedure ObjectPropsClick(Sender: TObject);
    procedure CloseObjects;
    procedure UpdateHostNames;
    procedure SetAllowObjects(Value: Boolean);
    procedure SetStreamFormat(Value: TRichStreamFormat);
    procedure SetStreamMode(Value: TRichStreamModes);
    procedure SetAutoURLDetect(Value: Boolean);
    procedure SetWordSelection(Value: Boolean);
    procedure SetHideScrollBars(Value: Boolean);
    procedure SetHideSelection(Value: Boolean);
    procedure SetTitle(const Value: string);
    procedure SetLangOptions(Value: TRichLangOptions);
    procedure SetRichEditStrings(Value: TStrings);
    procedure SetDefAttributes(Value: TJvTextAttributes);
    procedure SetSelAttributes(Value: TJvTextAttributes);
    procedure SetWordAttributes(Value: TJvTextAttributes);
    procedure SetSelectionBar(Value: Boolean);
    procedure SetUndoLimit(Value: Integer);
    procedure UpdateTextModes(Plain: Boolean);
    procedure AdjustFindDialogPosition(Dialog: TFindDialog);
    procedure SetupFindDialog(Dialog: TFindDialog; const SearchStr,
      ReplaceStr: string);
    function FindEditText(Dialog: TFindDialog; AdjustPos, Events: Boolean): Boolean;
    function GetCanFindNext: Boolean;
    procedure FindDialogFind(Sender: TObject);
    procedure ReplaceDialogReplace(Sender: TObject);
    procedure SetSelText(const Value: string);
    procedure FindDialogClose(Sender: TObject);
    procedure SetUIActive(Active: Boolean);
    procedure CMBiDiModeChanged(var Msg: TMessage); message CM_BIDIMODECHANGED;
    procedure CMColorChanged(var Msg: TMessage); message CM_COLORCHANGED;
    procedure CMDocWindowActivate(var Msg: TMessage); message CM_DOCWINDOWACTIVATE;
    procedure CMFontChanged(var Msg: TMessage); message CM_FONTCHANGED;
    procedure CMUIDeactivate(var Msg: TMessage); message CM_UIDEACTIVATE;
    procedure CNNotify(var Msg: TWMNotify); message CN_NOTIFY;
    procedure EMReplaceSel(var Msg: TMessage); message EM_REPLACESEL;
    procedure WMDestroy(var Msg: TWMDestroy); message WM_DESTROY;
    procedure WMMouseMove(var Msg: TMessage); message WM_MOUSEMOVE;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMRButtonUp(var Msg: TMessage); message WM_RBUTTONUP;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMSetFont(var Msg: TWMSetFont); message WM_SETFONT;
    // From JvRichEdit.pas by S�bastien Buysse
    procedure CMCtl3DChanged(var Msg: TMessage); message CM_CTL3DCHANGED;
    procedure CMParentColorChanged(var Msg: TMessage); message CM_PARENTCOLORCHANGED;
    procedure MouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    function GetPopupMenu: TPopupMenu; override;
    procedure TextNotFound(Dialog: TFindDialog); virtual;
    procedure RequestSize(const Rect: TRect); virtual;
    procedure SelectionChange; dynamic;
    function ProtectChange(const Msg: TMessage; StartPos,
      EndPos: Integer): Boolean; dynamic;
    function SaveClipboard(NumObj, NumChars: Integer): Boolean; dynamic;
    procedure URLClick(const URLText: string; Button: TMouseButton); dynamic;
    procedure SetPlainText(Value: Boolean); virtual;
    procedure CloseFindDialog(Dialog: TFindDialog); virtual;
    procedure DoSetMaxLength(Value: Integer); override;
    procedure DoConversionProgress(const AProgress: Integer);
    function GetSelLength: Integer; override;
    function GetSelStart: Integer; override;
    function GetSelText: string; override;
    procedure SetSelLength(Value: Integer); override;
    procedure SetSelStart(Value: Integer); override;
    property AllowInPlace: Boolean read FAllowInPlace write FAllowInPlace default True;
    property AboutJVCL: TJVCLAboutInfo read FAboutJVCL write FAboutJVCL stored False;
    property AllowObjects: Boolean read FAllowObjects write SetAllowObjects default True;
    property AutoURLDetect: Boolean read GetAutoURLDetect write SetAutoURLDetect default True;
    property AutoVerbMenu: Boolean read FAutoVerbMenu write FAutoVerbMenu default True;
    property HideSelection: Boolean read FHideSelection write SetHideSelection default True;
    property HideScrollBars: Boolean read FHideScrollBars
      write SetHideScrollBars default True;
    property HintColor: TColor read FHintColor write FHintColor default clInfoBk;
    property Title: string read FTitle write SetTitle;
    property LangOptions: TRichLangOptions read GetLangOptions write SetLangOptions default [rlAutoFont];
    property Lines: TStrings read FRichEditStrings write SetRichEditStrings;
    property PlainText: Boolean read FPlainText write SetPlainText default False;
    property SelectionBar: Boolean read FSelectionBar write SetSelectionBar default True;
    property StreamFormat: TRichStreamFormat read GetStreamFormat write SetStreamFormat default sfDefault;
    property StreamMode: TRichStreamModes read GetStreamMode write SetStreamMode default [];
    property UndoLimit: Integer read FUndoLimit write SetUndoLimit default 100;
    property WordSelection: Boolean read GetWordSelection write SetWordSelection default True;
    property ScrollBars default ssBoth;
    property TabStop default True;
    property SelText: string read GetSelText write SetSelText;
    property OnSaveClipboard: TRichEditSaveClipboard read FOnSaveClipboard
      write FOnSaveClipboard;
    property OnSelectionChange: TNotifyEvent read FOnSelChange write FOnSelChange;
    property OnProtectChange: TRichEditProtectChange read FOnProtectChange
      write FOnProtectChange; { obsolete }
    property OnProtectChangeEx: TRichEditProtectChangeEx read FOnProtectChangeEx
      write FOnProtectChangeEx;
    property OnResizeRequest: TRichEditResizeEvent read FOnResizeRequest
      write FOnResizeRequest;
    property OnURLClick: TRichEditURLClickEvent read FOnURLClick write FOnURLClick;
    property OnTextNotFound: TRichEditFindErrorEvent read FOnTextNotFound write FOnTextNotFound;
    property OnCloseFindDialog: TRichEditFindCloseEvent read FOnCloseFindDialog
      write FOnCloseFindDialog;
    property OnConversionProgress: TRichEditProgressEvent read FOnConversionProgress write FOnConversionProgress;
    // From JvRichEdit.pas by S�bastien Buysse
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnCtl3DChanged: TNotifyEvent read FOnCtl3DChanged write FOnCtl3DChanged;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
    property OnVerticalScroll: TNotifyEvent read FOnVerticalScroll write FOnVerticalScroll;
    property OnHorizontalScroll: TNotifyEvent read FOnHorizontalScroll write FOnHorizontalScroll;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure SaveToImage(Picture: TPicture);

    procedure InsertBitmap(ABitmap: TBitmap; const Sizeable: Boolean);
    // InsertFormatText inserts formatted text at the cursor position given by Index.
    // If Index < 0, the text is inserted at the current SelStart position.
    // S is the string to insert
    // AFont is the font to use. If AFont = nil, then the current attributes at the insertion point are used.
    // NOTE: this procedure does not reset the attributes after the call, i.e if you change the text color
    // it will remain that color until you change it again.
    procedure InsertFormatText(Index: Integer; const S: string; const AFont: TFont = nil);
    // AddFormatText works just like InsertFormatText but always moves the insertion
    // point to the end of the available text
    procedure AddFormatText(const S: string; const AFont: TFont = nil);

    procedure SetSelection(StartPos, EndPos: Longint; ScrollCaret: Boolean);
    function GetSelection: TCharRange;
    function GetTextRange(StartPos, EndPos: Longint): string;
    function LineFromChar(CharIndex: Integer): Integer;
    function GetLineIndex(LineNo: Integer): Integer;
    function GetLineLength(CharIndex: Integer): Integer;
    function WordAtCursor: string;
    function FindText(const SearchStr: string;
      StartPos, Length: Integer; Options: TRichSearchTypes): Integer;
    function GetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer; override;
    function GetCaretPos: TPoint; override;
    function GetCharPos(CharIndex: Integer): TPoint;
    function InsertObjectDialog: Boolean;
    function ObjectPropertiesDialog: Boolean;
    function PasteSpecialDialog: Boolean;
    function FindDialog(const SearchStr: string): TFindDialog;
    function ReplaceDialog(const SearchStr, ReplaceStr: string): TReplaceDialog;
    function FindNext: Boolean;
    procedure Print(const Caption: string); virtual;
    class procedure RegisterConversionFormat(AConverter: TJvConverter);
    class procedure RegisterMSTextConverters;
    class function Filter(const AKind: TJvConversionKind): string;
    procedure ClearUndo;
    procedure Redo;
    procedure StopGroupTyping;
    property CanFindNext: Boolean read GetCanFindNext;
    property CanRedo: Boolean read GetCanRedo;
    property CanPaste: Boolean read GetCanPaste;
    property RedoName: TUndoName read GetRedoName;
    property UndoName: TUndoName read GetUndoName;
    property DefaultConverter: TJvConverter read FDefaultConverter write FDefaultConverter;
    property DefAttributes: TJvTextAttributes read FDefAttributes write SetDefAttributes;
    property SelAttributes: TJvTextAttributes read FSelAttributes write SetSelAttributes;
    property WordAttributes: TJvTextAttributes read FWordAttributes write SetWordAttributes;
    property PageRect: TRect read FPageRect write FPageRect;
    property Paragraph: TJvParaAttributes read FParagraph;
    property SelectionType: TRichSelectionType read GetSelectionType;
  end;

  TJvRichEdit = class(TJvCustomRichEdit)
  published
    property AboutJVCL;
    property Align;
    property Alignment;
    property AutoURLDetect;
    property AutoVerbMenu;
    property AllowObjects;
    property AllowInPlace;
    property Anchors;
    property BiDiMode;
    property BorderWidth;
    property DragKind;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HideScrollBars;
    property HintColor;
    property Title;
    property ImeMode;
    property ImeName;
    property Constraints;
    property ParentBiDiMode;
    property LangOptions;
    property Lines;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PlainText;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property SelectionBar;
    property SelText;
    property ShowHint;
    property StreamFormat;
    property StreamMode;
    property TabOrder;
    property TabStop;
    property UndoLimit;
    property Visible;
    property WantTabs;
    property WantReturns;
    property WordSelection;
    property WordWrap;
    property OnChange;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnContextPopup;
    property OnConversionProgress;
    property OnEndDock;
    property OnStartDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnProtectChange; { obsolete }
    property OnProtectChangeEx;
    property OnResizeRequest;
    property OnSaveClipboard;
    property OnSelectionChange;
    property OnStartDrag;
    property OnTextNotFound;
    property OnCloseFindDialog;
    property OnURLClick;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnCtl3DChanged;
    property OnParentColorChange;
    property OnVerticalScroll;
    property OnHorizontalScroll;
  end;

var
  RichEditVersion: TRichEditVersion;

  { Two procedures to construct RTF from a bitmap. You can use this to
    insert bitmaps in the rich edit control, for example:

      Stream := TMemoryStream.Create;
      try
        BitmapToRTF(SomeBitmap, Stream);
        Stream.Position := 0;

        JvRichEdit1.StreamFormat := sfRichText;
        JvRichEdit1.StreamMode := [smSelection, smPlainRtf];
        JvRichEdit1.Lines.LoadFromStream(Stream);
      finally
        Stream.Free;
      end;

    But:

    * if you stream out the RTF content of the rich edit control, the bitmaps
      are *not* included. Use TJvRichEdit.InsertBitmap if you want the bitmaps
      to be included in the RTF.
    * TJvRichEdit.AllowObjects must be set to True.
    * BitmapToRTF is the fastest, TJvRichEdit.InsertBitmap the slowest.
  }

{ uses the \dibitmap identifier }
procedure BitmapToRTF(ABitmap: TBitmap; AStream: TStream);
{ uses the \wmetafile identifier }
function BitmapToRTF2(ABitmap: TBitmap; AStream: TStream): Boolean;

implementation

uses
  OleCtnrs,
  Printers, ComStrs, OleConst, OleDlg, Math, Registry, Contnrs,
  JvThemes, JvTypes;

resourcestring
  SRTFFilter = 'Rich Text Format (*.rtf)|*.RTF';
  STextFilter = 'Plain text (*.txt)|*.TXT';

  SConversionError = 'Conversion error %.8x';
  SErr_ConversionBusy = 'Cannot execute multiple conversions';
  SErr_CouldNotInitConverter = 'Could not initialize converter';
  SErr_DiskFull = 'Out of space on output';
  SErr_DocTooLarge = 'Conversion document too large for target';
  SErr_InvalidDoc = 'Invalid document';
  SErr_InvalidFile = 'Invalid data in conversion file';
  SErr_NoMemory = 'Out of memory';
  SErr_OpenConvErr = 'Error opening conversion file';
  SErr_OpenExceptErr = 'Error opening exception file';
  SErr_OpenInFileErr = 'Could not open input file';
  SErr_OpenOutFileErr = 'Could not open output file';
  SErr_ReadErr = 'Error during read';
  SErr_UserCancel = 'Conversion cancelled by user';
  SErr_WriteErr = 'Error during write';
  SErr_WriteExceptErr = 'Error writing exception file';
  SErr_WrongFileType = 'Wrong file type for this converter';

type
  PENLink = ^TENLink;
  PENOleOpFailed = ^TENOleOpFailed;
  TFindTextEx = TFindTextExA;
  TTextRangeA = record
    chrg: TCharRange;
    lpstrText: PAnsiChar;
  end;

  TTextRangeW = record
    chrg: TCharRange;
    lpstrText: PWideChar;
  end;

  TTextRange = TTextRangeA;

  { OLE Extensions to the Rich Text Editor }
  { Converted from RICHOLE.H               }
  { Structure passed to GetObject and InsertObject }

  _ReObject = record
    cbStruct: DWORD;          { Size of structure                }
    cp: ULONG;                { Character position of object     }
    clsid: TCLSID;            { Class ID of object               }
    poleobj: IOleObject;      { OLE object interface             }
    pstg: IStorage;           { Associated storage interface     }
    polesite: IOleClientSite; { Associated client site interface }
    sizel: TSize;             { Size of object (may be 0,0)      }
    dvAspect: Longint;        { Display aspect to use            }
    dwFlags: DWORD;           { Object status flags              }
    dwUser: DWORD;            { DWORD for user's use             }
  end;
  TReObject = _ReObject;

  EMSTextConversionError = class(Exception)
  private
    FErrorCode: FCE;
  public
    constructor Create(const Msg: string; AErrorCode: FCE = 0);
    property ErrorCode: FCE read FErrorCode write FErrorCode;
  end;

  (*  make Delphi 5 compiler happy // andreas
    { RichEdit GUIDs }
    IID_IRichEditOle: TGUID = (
      D1: $00020D00; D2: $0000; D3: $0000; D4: ($C0, $00, $00, $00, $00, $00, $00, $46));
    IID_IRichEditOleCallback: TGUID = (
      D1: $00020D03; D2: $0000; D3: $0000; D4: ($C0, $00, $00, $00, $00, $00, $00, $46));
  *)

  {
   *  IRichEditOle
   *
   *  Purpose:
   *    Interface used by the client of RichEdit to perform OLE-related
   *    operations.
   *
   *    The methods herein may just want to be regular Windows messages.
  }

  IRichEditOle = interface(IUnknown)
    ['{00020d00-0000-0000-c000-000000000046}']
    function GetClientSite(out clientSite: IOleClientSite): HRESULT; stdcall;
    function GetObjectCount: HRESULT; stdcall;
    function GetLinkCount: HRESULT; stdcall;
    function GetObject(iob: Longint; out ReObject: TReObject;
      dwFlags: DWORD): HRESULT; stdcall;
    function InsertObject(var ReObject: TReObject): HRESULT; stdcall;
    function ConvertObject(iob: Longint; rclsidNew: TIID;
      lpstrUserTypeNew: LPCSTR): HRESULT; stdcall;
    function ActivateAs(rclsid: TIID; rclsidAs: TIID): HRESULT; stdcall;
    function SetHostNames(lpstrContainerApp: LPCSTR;
      lpstrContainerObj: LPCSTR): HRESULT; stdcall;
    function SetLinkAvailable(iob: Longint; fAvailable: BOOL): HRESULT; stdcall;
    function SetDvaspect(iob: Longint; dvAspect: DWORD): HRESULT; stdcall;
    function HandsOffStorage(iob: Longint): HRESULT; stdcall;
    function SaveCompleted(iob: Longint; const stg: IStorage): HRESULT; stdcall;
    function InPlaceDeactivate: HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(var chrg: TCharRange; reco: DWORD;
      out dataObj: IDataObject): HRESULT; stdcall;
    function ImportDataObject(dataObj: IDataObject; cf: TClipFormat;
      hMetaPict: HGLOBAL): HRESULT; stdcall;
  end;

  {
   *  IRichEditOleCallback
   *
   *  Purpose:
   *    Interface used by the RichEdit to get OLE-related stuff from the
   *    application using RichEdit.
  }

  IRichEditOleCallback = interface(IUnknown)
    ['{00020d03-0000-0000-c000-000000000046}']
    function GetNewStorage(out stg: IStorage): HRESULT; stdcall;
    function GetInPlaceContext(out Frame: IOleInPlaceFrame;
      out Doc: IOleInPlaceUIWindow;
      lpFrameInfo: POleInPlaceFrameInfo): HRESULT; stdcall;
    function ShowContainerUI(fShow: BOOL): HRESULT; stdcall;
    function QueryInsertObject(const clsid: TCLSID; const stg: IStorage;
      cp: Longint): HRESULT; stdcall;
    function DeleteObject(const oleobj: IOleObject): HRESULT; stdcall;
    function QueryAcceptData(const dataObj: IDataObject;
      var cfFormat: TClipFormat; reco: DWORD; fReally: BOOL;
      hMetaPict: HGLOBAL): HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD;
      out dataObj: IDataObject): HRESULT; stdcall;
    function GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD;
      var dwEffect: DWORD): HRESULT; stdcall;
    function GetContextMenu(seltype: Word; const oleobj: IOleObject;
      const chrg: TCharRange; out Menu: HMENU): HRESULT; stdcall;
  end;

  TConversionFormatList = class(TObjectList)
  private
    FRTFConvIndex: Integer;
    FTextConvIndex: Integer;

    function GetItem(Index: Integer): TJvConverter;
    procedure SetItem(Index: Integer; const Value: TJvConverter);
  public
    constructor Create; virtual;
    function GetConverterForFile(const AFileName: string; const Kind: TJvConversionKind): TJvConverter;
    function GetFilter(const AKind: TJvConversionKind): string;
    function DefaultConverter: TJvConverter;
    property Items[Index: Integer]: TJvConverter read GetItem write SetItem; default;
  end;

  TImageDataObject = class(TInterfacedObject, IDataObject)
  private
    FBitmap: TBitmap;
    function GetExtent(dwDrawAspect: Longint; out Size: TPoint): HResult; stdcall;
  public
    constructor Create(ABitmap: TBitmap); virtual;
    { IDataObject }
    function GetData(const formatetcIn: TFormatEtc;
      out medium: TStgMedium): HResult; stdcall;
    function GetDataHere(const formatetc: TFormatEtc;
      out medium: TStgMedium): HResult; stdcall;
    function QueryGetData(const formatetc: TFormatEtc): HResult; stdcall;
    function GetCanonicalFormatEtc(const formatetc: TFormatEtc;
      out formatetcOut: TFormatEtc): HResult; stdcall;
    function SetData(const formatetc: TFormatEtc; var medium: TStgMedium;
      fRelease: BOOL): HResult; stdcall;
    function EnumFormatEtc(dwDirection: Longint; out enumFormatEtc:
      IEnumFormatEtc): HResult; stdcall;
    function DAdvise(const formatetc: TFormatEtc; advf: Longint;
      const advSink: IAdviseSink; out dwConnection: Longint): HResult; stdcall;
    function DUnadvise(dwConnection: Longint): HResult; stdcall;
    function EnumDAdvise(out enumAdvise: IEnumStatData): HResult; stdcall;
  end;

  TJvRichEditStrings = class(TStrings)
  private
    FRichEdit: TJvCustomRichEdit;
    FFormat: TRichStreamFormat;
    FMode: TRichStreamModes;
    procedure EnableChange(const Value: Boolean);
  protected
    procedure ProgressCallback(Sender: TObject);
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
    procedure Put(Index: Integer; const S: string); override;
    procedure SetUpdateState(Updating: Boolean); override;
    procedure SetTextStr(const Value: string); override;

    procedure DoImport(AConverter: TJvConverter);
    procedure DoExport(AConverter: TJvConverter);
  public
    destructor Destroy; override;
    procedure Clear; override;
    procedure AddStrings(Strings: TStrings); override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure LoadFromFile(const FileName: string); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToFile(const FileName: string); override;
    procedure SaveToStream(Stream: TStream); override;
    property Format: TRichStreamFormat read FFormat write FFormat;
    property Mode: TRichStreamModes read FMode write FMode;
  end;

  TMSTextConversionThread = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create; virtual;
  end;

  { TOleUILinkInfo - helper interface for Object Properties dialog }

  TOleUILinkInfo = class(TInterfacedObject, IOleUILinkInfo)
  private
    FReObject: TReObject;
    FRichEdit: TJvCustomRichEdit;
    FOleLink: IOleLink;
  public
    constructor Create(ARichEdit: TJvCustomRichEdit; ReObject: TReObject);
    function GetNextLink(dwLink: Longint): Longint; stdcall;
    function SetLinkUpdateOptions(dwLink: Longint;
      dwUpdateOpt: Longint): HRESULT; stdcall;
    function GetLinkUpdateOptions(dwLink: Longint;
      var dwUpdateOpt: Longint): HRESULT; stdcall;
    function SetLinkSource(dwLink: Longint; pszDisplayName: PChar;
      lenFileName: Longint; var chEaten: Longint;
      fValidateSource: BOOL): HRESULT; stdcall;
    function GetLinkSource(dwLink: Longint; var pszDisplayName: PChar;
      var lenFileName: Longint; var pszFullLinkType: PChar;
      var pszShortLinkType: PChar; var fSourceAvailable: BOOL;
      var fIsSelected: BOOL): HRESULT; stdcall;
    function OpenLinkSource(dwLink: Longint): HRESULT; stdcall;
    function UpdateLink(dwLink: Longint; fErrorMessage: BOOL;
      fErrorAction: BOOL): HRESULT; stdcall;
    function CancelLink(dwLink: Longint): HRESULT; stdcall;
    function GetLastUpdate(dwLink: Longint;
      var LastUpdate: TFileTime): HRESULT; stdcall;
  end;

  { TOleUIObjInfo - helper interface for Object Properties dialog }

  TOleUIObjInfo = class(TInterfacedObject, IOleUIObjInfo)
  private
    FRichEdit: TJvCustomRichEdit;
    FReObject: TReObject;
  public
    constructor Create(ARichEdit: TJvCustomRichEdit; ReObject: TReObject);
    function GetObjectInfo(dwObject: Longint;
      var dwObjSize: Longint; var lpszLabel: PChar;
      var lpszType: PChar; var lpszShortType: PChar;
      var lpszLocation: PChar): HRESULT; stdcall;
    function GetConvertInfo(dwObject: Longint; var ClassID: TCLSID;
      var wFormat: Word; var ConvertDefaultClassID: TCLSID;
      var lpClsidExclude: PCLSID; var cClsidExclude: Longint): HRESULT; stdcall;
    function ConvertObject(dwObject: Longint;
      const clsidNew: TCLSID): HRESULT; stdcall;
    function GetViewInfo(dwObject: Longint; var hMetaPict: HGLOBAL;
      var dvAspect: Longint; var nCurrentScale: Integer): HRESULT; stdcall;
    function SetViewInfo(dwObject: Longint; hMetaPict: HGLOBAL;
      dvAspect: Longint; nCurrentScale: Integer;
      bRelativeToOrig: BOOL): HRESULT; stdcall;
  end;

  TRichEditOleCallback = class(TObject, IUnknown, IRichEditOleCallback)
  private
    FDocForm: IVCLFrameForm;
    FFrameForm: IVCLFrameForm;
    FAccelTable: HAccel;
    FAccelCount: Integer;
    FAutoScroll: Boolean;
    procedure CreateAccelTable;
    procedure DestroyAccelTable;
    procedure AssignFrame;
  private
    FRefCount: Longint;
    FRichEdit: TJvCustomRichEdit;
  public
    constructor Create(ARichEdit: TJvCustomRichEdit);
    destructor Destroy; override;
    function QueryInterface(const iid: TGUID; out Obj): HRESULT; stdcall;
    function _AddRef: Longint; stdcall;
    function _Release: Longint; stdcall;
    function GetNewStorage(out stg: IStorage): HRESULT; stdcall;
    function GetInPlaceContext(out Frame: IOleInPlaceFrame;
      out Doc: IOleInPlaceUIWindow;
      lpFrameInfo: POleInPlaceFrameInfo): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD;
      out dataObj: IDataObject): HRESULT; stdcall;
    function GetContextMenu(seltype: Word; const oleobj: IOleObject;
      const chrg: TCharRange; out Menu: HMENU): HRESULT; stdcall;
    function ShowContainerUI(fShow: BOOL): HRESULT; stdcall;
    function QueryInsertObject(const clsid: TCLSID; const stg: IStorage;
      cp: Longint): HRESULT; stdcall;
    function DeleteObject(const oleobj: IOleObject): HRESULT; stdcall;
    function QueryAcceptData(const dataObj: IDataObject; var cfFormat: TClipFormat;
      reco: DWORD; fReally: BOOL; hMetaPict: HGLOBAL): HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD;
      var dwEffect: DWORD): HRESULT; stdcall;
  end;

const
  { File Conversion Errors }

  fceTrue           = FCE(1);    // IsFormatCorrect32: recognized the input file.
  fceNoErr          = FCE(0);    // IsFormatCorrect32: Did not recognize the input file.
                                 // Operation completed successfully for other APIs
  fceOpenInFileErr  = FCE(-1);   // could not open input file
  fceReadErr        = FCE(-2);   // error during read
  fceOpenConvErr    = FCE(-3);   // error opening conversion file (obsolete)
  fceWriteErr       = FCE(-4);   // error during write
  fceInvalidFile    = FCE(-5);   // invalid data in conversion file
  fceOpenExceptErr  = FCE(-6);   // error opening exception file (obsolete)
  fceWriteExceptErr = FCE(-7);   // error writing exception file (obsolete)
  fceNoMemory       = FCE(-8);   // out of memory
  fceInvalidDoc     = FCE(-9);   // invalid document (obsolete)
  fceDiskFull       = FCE(-10);  // out of space on output (obsolete)
  fceDocTooLarge    = FCE(-11);  // conversion document too large for target (obsolete)
  fceOpenOutFileErr = FCE(-12);  // could not open output file
  fceUserCancel     = FCE(-13);  // conversion cancelled by user
  fceWrongFileType  = FCE(-14);  // wrong file type for this converter

  CTwipsPerInch = 1440;
  CTwipsPerPoint = 20;
  CHundredthMMPerInch = 2540;
  CPointsPerInch = 72;

  RichEdit10ModuleName = 'RICHED32.DLL';
  RichEdit20ModuleName = 'RICHED20.DLL';

  FT_DOWN = 1;

  // PARAFORMAT2 wNumberingStyle options
  PFNS_PAREN     = $0000;  // default, e.g., 1)
  PFNS_PARENS    = $0100;  // tomListParentheses/256, e.g., (1)
  PFNS_PERIOD    = $0200;  // tomListPeriod/256, e.g., 1.
  PFNS_PLAIN     = $0300;  // tomListPlain/256, e.g., 1
  PFNS_NONUMBER  = $0400;  // Used for continuation w/o number
  PFNS_NEWNUMBER = $8000;  // Start new number with wNumberingStart

  // (can be combined with other PFNS_xxx)

  EM_SETTYPOGRAPHYOPTIONS = (WM_USER + 202);
  EM_GETTYPOGRAPHYOPTIONS = (WM_USER + 203);

  // Options for EM_SETTYPOGRAPHYOPTIONS
  TO_ADVANCEDTYPOGRAPHY = 1;
  TO_SIMPLELINEBREAK = 2;
  TO_DISABLECUSTOMTEXTOUT = 4;
  TO_ADVANCEDLAYOUT = 8;

  // Underline types. RE 1.0 displays only CFU_UNDERLINE
  CFU_CF1UNDERLINE             = $FF; // Map charformat's bit underline to CF2
  CFU_INVERT                   = $FE; // For IME composition fake a selection
  CFU_UNDERLINETHICKLONGDASH   = 18;  // (*) display as dash
  CFU_UNDERLINETHICKDOTTED     = 17;  // (*) display as dot
  CFU_UNDERLINETHICKDASHDOTDOT = 16;  // (*) display as dash dot dot
  CFU_UNDERLINETHICKDASHDOT    = 15;  // (*) display as dash dot
  CFU_UNDERLINETHICKDASH       = 14;  // (*) display as dash
  CFU_UNDERLINELONGDASH        = 13;  // (*) display as dash
  CFU_UNDERLINEHEAVYWAVE       = 12;  // (*) display as wave
  CFU_UNDERLINEDOUBLEWAVE      = 11;  // (*) display as wave
  CFU_UNDERLINEHAIRLINE        = 10;  // (*) display as single
  CFU_UNDERLINETHICK           = 9;
  CFU_UNDERLINEWAVE            = 8;
  CFU_UNDERLINEDASHDOTDOT      = 7;
  CFU_UNDERLINEDASHDOT         = 6;
  CFU_UNDERLINEDASH            = 5;
  CFU_UNDERLINEDOTTED          = 4;
  CFU_UNDERLINEDOUBLE          = 3;  // (*) display as single
  CFU_UNDERLINEWORD            = 2;  // (*) display as single
  CFU_UNDERLINE                = 1;
  CFU_UNDERLINENONE            = 0;

  AttrFlags: array [TJvAttributeType] of Word =
    (0, SCF_SELECTION, SCF_WORD or SCF_SELECTION);

  CF_EMBEDDEDOBJECT = 'Embedded Object';
  CF_LINKSOURCE = 'Link Source';

  { Flags to specify which interfaces should be returned in the structure above }

  REO_GETOBJ_NO_INTERFACES  = $00000000;
  REO_GETOBJ_POLEOBJ        = $00000001;
  REO_GETOBJ_PSTG           = $00000002;
  REO_GETOBJ_POLESITE       = $00000004;
  REO_GETOBJ_ALL_INTERFACES = $00000007;

  { Place object at selection }

  REO_CP_SELECTION = ULONG(-1);

  { Use character position to specify object instead of index }

  REO_IOB_SELECTION = ULONG(-1);
  REO_IOB_USE_CP = ULONG(-2);

  { Object flags }

  REO_NULL            = $00000000;  { No flags                         }
  REO_READWRITEMASK   = $0000003F;  { Mask out RO bits                 }
  REO_DONTNEEDPALETTE = $00000020;  { Object doesn't need palette      }
  REO_BLANK           = $00000010;  { Object is blank                  }
  REO_DYNAMICSIZE     = $00000008;  { Object defines size always       }
  REO_INVERTEDSELECT  = $00000004;  { Object drawn all inverted if sel }
  REO_BELOWBASELINE   = $00000002;  { Object sits below the baseline   }
  REO_RESIZABLE       = $00000001;  { Object may be resized            }
  REO_LINK            = $80000000;  { Object is a link (RO)            }
  REO_STATIC          = $40000000;  { Object is static (RO)            }
  REO_SELECTED        = $08000000;  { Object selected (RO)             }
  REO_OPEN            = $04000000;  { Object open in its server (RO)   }
  REO_INPLACEACTIVE   = $02000000;  { Object in place active (RO)      }
  REO_HILITED         = $01000000;  { Object is to be hilited (RO)     }
  REO_LINKAVAILABLE   = $00800000;  { Link believed available (RO)     }
  REO_GETMETAFILE     = $00400000;  { Object requires metafile (RO)    }

  { Flags for IRichEditOle.GetClipboardData,   }
  { IRichEditOleCallback.GetClipboardData and  }
  { IRichEditOleCallback.QueryAcceptData       }

  RECO_PASTE = $00000000;  { paste from clipboard  }
  RECO_DROP  = $00000001;  { drop                  }
  RECO_COPY  = $00000002;  { copy to the clipboard }
  RECO_CUT   = $00000003;  { cut to the clipboard  }
  RECO_DRAG  = $00000004;  { drag                  }

  ReadError = $0001;
  WriteError = $0002;
  NoError = $0000;

  RichLangOptions: array [TRichLangOption] of DWORD = (IMF_AUTOKEYBOARD,
    IMF_AUTOFONT, IMF_IMECANCELCOMPLETE, IMF_IMEALWAYSSENDNOTIFY);

  CHex: array [0..$F] of Char =
    ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
     'A', 'B', 'C', 'D', 'E', 'F');

  { Converter API names }

  ForeignToRtf32Name = 'ForeignToRtf32';
  InitConverter32Name = 'InitConverter32';
  IsFormatCorrect32Name = 'IsFormatCorrect32';
  RtfToForeign32Name = 'RtfToForeign32';
  UninitConverterName = 'UninitConverter';
  CchFetchLpszErrorName = 'CchFetchLpszError';

  CConvertBufferSize = $1004;

var
  { Clipboard formats }
  CFEmbeddedObject: Integer;
  CFLinkSource: Integer;
  CFRtf: Integer;
  CFRtfNoObjs: Integer;

  { Global converter vars }
  GConversionFormatList: TConversionFormatList;
  GCurrentConverter: TJvMSTextConversion;
  GMSTextConvertersRegistered: Boolean;

  Painting: Boolean = False;


//=== Local procedures =======================================================

{ OLE utility routines }

function WStrLen(Str: PWideChar): Integer;
begin
  Result := 0;
  while Str[Result] <> #0 do
    Inc(Result);
end;

procedure ReleaseObject(var Obj);
begin
  if IUnknown(Obj) <> nil then
  begin
    IUnknown(Obj) := nil;
  end;
end;

procedure CreateStorage(var Storage: IStorage);
var
  LockBytes: ILockBytes;
begin
  OleCheck(CreateILockBytesOnHGlobal(0, True, LockBytes));
  try
    OleCheck(StgCreateDocfileOnILockBytes(LockBytes, STGM_READWRITE
      or STGM_SHARE_EXCLUSIVE or STGM_CREATE, 0, Storage));
  finally
    ReleaseObject(LockBytes);
  end;
end;

procedure DestroyMetaPict(MetaPict: HGLOBAL);
begin
  if MetaPict <> 0 then
  begin
    DeleteMetaFile(PMetaFilePict(GlobalLock(MetaPict))^.hMF);
    GlobalUnlock(MetaPict);
    GlobalFree(MetaPict);
  end;
end;

function OleSetDrawAspect(OleObject: IOleObject; Iconic: Boolean;
  IconMetaPict: HGLOBAL; var DrawAspect: Longint): HRESULT;
var
  OleCache: IOleCache;
  EnumStatData: IEnumStatData;
  OldAspect, AdviseFlags, Connection: Longint;
  TempMetaPict: HGLOBAL;
  FormatEtc: TFormatEtc;
  Medium: TStgMedium;
  ClassID: TCLSID;
  StatData: TStatData;
begin
  Result := S_OK;
  OldAspect := DrawAspect;
  if Iconic then
  begin
    DrawAspect := DVASPECT_ICON;
    AdviseFlags := ADVF_NODATA;
  end
  else
  begin
    DrawAspect := DVASPECT_CONTENT;
    AdviseFlags := ADVF_PRIMEFIRST;
  end;
  if (DrawAspect <> OldAspect) or (DrawAspect = DVASPECT_ICON) then
  begin
    Result := OleObject.QueryInterface(IOleCache, OleCache);
    if Succeeded(Result) then
    try
      if DrawAspect <> OldAspect then
      begin
        { Setup new cache with the new aspect }
        FillChar(FormatEtc, SizeOf(FormatEtc), 0);
        FormatEtc.dwAspect := DrawAspect;
        FormatEtc.lIndex := -1;
        Result := OleCache.Cache(FormatEtc, AdviseFlags, Connection);
      end;
      if Succeeded(Result) and (DrawAspect = DVASPECT_ICON) then
      begin
        TempMetaPict := 0;
        if IconMetaPict = 0 then
        begin
          if Succeeded(OleObject.GetUserClassID(ClassID)) then
          begin
            TempMetaPict := OleGetIconOfClass(ClassID, nil, True);
            IconMetaPict := TempMetaPict;
          end;
        end;
        try
          FormatEtc.cfFormat := CF_METAFILEPICT;
          FormatEtc.ptd := nil;
          FormatEtc.dwAspect := DVASPECT_ICON;
          FormatEtc.lIndex := -1;
          FormatEtc.tymed := TYMED_MFPICT;
          Medium.tymed := TYMED_MFPICT;
          Medium.hMetaFilePict := IconMetaPict;
          Medium.unkForRelease := nil;
          Result := OleCache.SetData(FormatEtc, Medium, False);
        finally
          DestroyMetaPict(TempMetaPict);
        end;
      end;
      if Succeeded(Result) and (DrawAspect <> OldAspect) then
      begin
        { remove any existing caches that are set up for the old display aspect }
        OleCache.EnumCache(EnumStatData);
        if EnumStatData <> nil then
        try
          while EnumStatData.Next(1, StatData, nil) = 0 do
            if StatData.formatetc.dwAspect = OldAspect then
              OleCache.Uncache(StatData.dwConnection);
        finally
          ReleaseObject(EnumStatData);
        end;
      end;
    finally
      ReleaseObject(OleCache);
    end;
    if Succeeded(Result) and (DrawAspect <> DVASPECT_ICON) then
      OleObject.Update;
  end;
end;

function GetIconMetaPict(OleObject: IOleObject; DrawAspect: Longint): HGLOBAL;
var
  DataObject: IDataObject;
  FormatEtc: TFormatEtc;
  Medium: TStgMedium;
  ClassID: TCLSID;
begin
  Result := 0;
  if DrawAspect = DVASPECT_ICON then
  begin
    OleObject.QueryInterface(IDataObject, DataObject);
    if DataObject <> nil then
    begin
      FormatEtc.cfFormat := CF_METAFILEPICT;
      FormatEtc.ptd := nil;
      FormatEtc.dwAspect := DVASPECT_ICON;
      FormatEtc.lIndex := -1;
      FormatEtc.tymed := TYMED_MFPICT;
      if Succeeded(DataObject.GetData(FormatEtc, Medium)) then
        Result := Medium.hMetaFilePict;
      ReleaseObject(DataObject);
    end;
  end;
  if Result = 0 then
  begin
    OleCheck(OleObject.GetUserClassID(ClassID));
    Result := OleGetIconOfClass(ClassID, nil, True);
  end;
end;

{ Return the first piece of a moniker }

function OleStdGetFirstMoniker(Moniker: IMoniker): IMoniker;
var
  Mksys: Longint;
  EnumMoniker: IEnumMoniker;
begin
  Result := nil;
  if Moniker <> nil then
  begin
    if (Moniker.IsSystemMoniker(Mksys) = 0) and
      (Mksys = MKSYS_GENERICCOMPOSITE) then
    begin
      if Moniker.Enum(True, EnumMoniker) <> 0 then
        Exit;
      EnumMoniker.Next(1, Result, nil);
      ReleaseObject(EnumMoniker);
    end
    else
    begin
      Result := Moniker;
    end;
  end;
end;

{ Return length of file moniker piece of the given moniker }

function OleStdGetLenFilePrefixOfMoniker(Moniker: IMoniker): Integer;
var
  MkFirst: IMoniker;
  BindCtx: IBindCtx;
  Mksys: Longint;
  P: PWideChar;
begin
  Result := 0;
  if Moniker <> nil then
  begin
    MkFirst := OleStdGetFirstMoniker(Moniker);
    if MkFirst <> nil then
    begin
      if (MkFirst.IsSystemMoniker(Mksys) = 0) and
        (Mksys = MKSYS_FILEMONIKER) then
      begin
        if CreateBindCtx(0, BindCtx) = 0 then
        begin
          if (MkFirst.GetDisplayName(BindCtx, nil, P) = 0) and (P <> nil) then
          begin
            Result := WStrLen(P);
            CoTaskMemFree(P);
          end;
          ReleaseObject(BindCtx);
        end;
      end;
      ReleaseObject(MkFirst);
    end;
  end;
end;

function CoAllocCStr(const S: string): PChar;
begin
  Result := StrCopy(CoTaskMemAlloc(Length(S) + 1), PChar(S));
end;

function WStrToString(P: PWideChar): string;
begin
  Result := '';
  if P <> nil then
  begin
    Result := WideCharToString(P);
    CoTaskMemFree(P);
  end;
end;

function GetFullNameStr(OleObject: IOleObject): string;
var
  P: PWideChar;
begin
  OleObject.GetUserType(USERCLASSTYPE_FULL, P);
  Result := WStrToString(P);
end;

function GetShortNameStr(OleObject: IOleObject): string;
var
  P: PWideChar;
begin
  OleObject.GetUserType(USERCLASSTYPE_SHORT, P);
  Result := WStrToString(P);
end;

function GetDisplayNameStr(OleLink: IOleLink): string;
var
  P: PWideChar;
begin
  OleLink.GetSourceDisplayName(P);
  Result := WStrToString(P);
end;

function GetVCLFrameForm(Form: TCustomForm): IVCLFrameForm;
begin
  if Form.OleFormObject = nil then
    TOleForm.Create(Form);
  Result := Form.OleFormObject as IVCLFrameForm;
end;

function IsFormMDIChild(Form: TCustomForm): Boolean;
begin
  Result := (Form is TForm) and (TForm(Form).FormStyle = fsMDIChild);
end;

procedure LinkError(const Ident: string);
begin
  Application.MessageBox(PChar(Ident), PChar(SLinkProperties),
    MB_OK or MB_ICONSTOP);
end;

{ Get RichEdit OLE interface }

function GetRichEditOle(Wnd: HWND; var RichEditOle): Boolean;
begin
  Result := SendMessage(Wnd, EM_GETOLEINTERFACE, 0, Longint(@RichEditOle)) <> 0;
end;

// (rom) needs a Pascal equivalent

function AdjustLineBreaks(Dest, Source: PChar): Integer; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     EDI,EAX
        MOV     ESI,EDX
        MOV     EDX,EAX
        CLD
@@1:    LODSB
@@2:    OR      AL,AL
        JE      @@4
        CMP     AL,0AH
        JE      @@3
        STOSB
        CMP     AL,0DH
        JNE     @@1
        MOV     AL,0AH
        STOSB
        LODSB
        CMP     AL,0AH
        JE      @@1
        JMP     @@2
@@3:    MOV     EAX,0A0DH
        STOSW
        JMP     @@1
@@4:    STOSB
        LEA     EAX,[EDI-1]
        SUB     EAX,EDX
        POP     EDI
        POP     ESI
end;

function StreamSave(dwCookie: Longint; pbBuff: PByte;
  cb: Longint; var pcb: Longint): Longint; stdcall;
var
  Converter: TJvConverter;
begin
  Result := NoError;
  Converter := TJvConverter(dwCookie);
  try
    pcb := 0;
    if Converter <> nil then
      pcb := Converter.ConvertWrite(PChar(pbBuff), cb);
  except
    Result := WriteError;
  end;
end;

function StreamLoad(dwCookie: Longint; pbBuff: PByte;
  cb: Longint; var pcb: Longint): Longint; stdcall;
var
  Buffer, pBuff: PChar;
  Converter: TJvConverter;
begin
  Result := NoError;
  Converter := TJvConverter(dwCookie);
  Buffer := StrAlloc(cb + 1);
  try
    cb := cb div 2;
    pcb := 0;
    pBuff := Buffer + cb;
    try
      if Converter <> nil then
        pcb := Converter.ConvertRead(pBuff, cb);
      if pcb > 0 then
      begin
        pBuff[pcb] := #0;
        if pBuff[pcb - 1] = #13 then
          pBuff[pcb - 1] := #0;
        pcb := AdjustLineBreaks(Buffer, pBuff);
        Move(Buffer^, pbBuff^, pcb);
      end;
    except
      Result := ReadError;
    end;
  finally
    StrDispose(Buffer);
  end;
end;

function FileNameToHGLOBAL(const AFileName: string): HGLOBAL;
var
  DataPtr: Pointer;
  Buffer: array [0..MAX_PATH] of Char;
begin
  // DOC : Each entry point that accepts file names should expect all file name
  //       arguments from Word to be in the OEM character set (unless the character
  //       set is explicitly negotiated using RegisterApp).
  //
  //  For example: CharToOem will translate the copyright (c) symbol (=1 char)
  //  to C� (or something). Not doing so will result in errors.

  StrCopy(Buffer, PChar(AFileName));
  CharToOem(Buffer, Buffer);

  Result := GlobalAlloc(GHND, StrLen(Buffer) + 1); // with last #0, thus + 1
  try
    DataPtr := GlobalLock(Result);
    try
      StrCopy(DataPtr, Buffer);
    finally
      GlobalUnlock(Result);
    end;
  except
    GlobalFree(Result);
    raise;
  end;
end;

function StringToHGLOBAL(const S: string): HGLOBAL;
var
  DataPtr: Pointer;
begin
  Result := GlobalAlloc(GHND, Length(S) + 1); // with last #0, thus + 1
  try
    DataPtr := GlobalLock(Result);
    try
      Move(PChar(S)^, DataPtr^, Length(S));
    finally
      GlobalUnlock(Result);
    end;
  except
    GlobalFree(Result);
    raise;
  end;
end;

function ExportCallback(cchBuff, nPercent: Longint): Longint; stdcall;
begin
  Result := GCurrentConverter.HandleExportCallBack(cchBuff, nPercent);
end;

function ImportCallback(cchBuff, nPercent: Longint): Longint; stdcall;
begin
  Result := GCurrentConverter.HandleImportCallback(cchBuff, nPercent);
end;

function FCEToString(AErrorCode: FCE): string;
begin
  case AErrorCode of
    fceOpenInFileErr: Result := SErr_OpenInFileErr;
    fceReadErr: Result := SErr_ReadErr;
    fceOpenConvErr: Result := SErr_OpenConvErr;
    fceWriteErr: Result := SErr_WriteErr;
    fceInvalidFile: Result := SErr_InvalidFile;
    fceOpenExceptErr: Result := SErr_OpenExceptErr;
    fceWriteExceptErr: Result := SErr_WriteExceptErr;
    fceNoMemory: Result := SErr_NoMemory;
    fceInvalidDoc: Result := SErr_InvalidDoc;
    fceDiskFull: Result := SErr_DiskFull;
    fceDocTooLarge: Result := SErr_DocTooLarge;
    fceOpenOutFileErr: Result := SErr_OpenOutFileErr;
    fceUserCancel: Result := SErr_UserCancel;
    fceWrongFileType: Result := SErr_WrongFileType;
  else
    Result := '';
  end;
end;

//=== Global procedures ======================================================

procedure BitmapToRTF(ABitmap: TBitmap; AStream: TStream);
const
  CPrefix = '{\rtf1 {\pict\picw%d\pich%d\dibitmap0 ';
  CPostfix = ' }}';
var
  Header, Bits: PChar;
  HeaderSize, BitsSize: DWORD;
  P, Q: PChar;
  S: string;
begin
  GetDIBSizes(ABitmap.Handle, HeaderSize, BitsSize);
  GetMem(Header, 2 * (HeaderSize + BitsSize));
  try
    Bits := Header + HeaderSize;
    GetDIB(ABitmap.Handle, ABitmap.Palette, Header^, Bits^);

    { Example :

      HeaderSize = 2, BitsSize = 2

      Header = $AB, $00, $DE, $F8, ?? , ?? , ?? , ??
      ->
      Header = 'A', 'B', '0', '0', 'D', 'E', 'F', '8'
    }
    Q := Header + HeaderSize + BitsSize - 1;
    //P := Header + 2 * (HeaderSize + BitsSize) - 1;
    P := Q + HeaderSize + BitsSize;
    while Q >= Header do
    begin
      P^ := CHex[Byte(Q^) mod 16];
      Dec(P);
      P^ := CHex[Byte(Q^) div 16];
      Dec(P);
      Dec(Q);
    end;
    S := Format(CPrefix, [ABitmap.Width, ABitmap.Height]);
    AStream.Write(PChar(S)^, Length(S));
    AStream.Write(Header^, (HeaderSize + BitsSize) * 2);
    AStream.Write(CPostfix, Length(CPostfix));
  finally
    FreeMem(Header);
  end;
end;

function BitmapToRTF2(ABitmap: TBitmap; AStream: TStream): Boolean;

{

  \wmetafileN	 - Source of the picture is a Windows metafile. The N argument
                 identifies the metafile type (the default type is 1).
  \picwN       - xExt field if the picture is a Windows metafile; picture
                 width in pixels if the picture is a bitmap or from QuickDraw.
                 The N argument is a long integer.
  \pichN	     - yExt field if the picture is a Windows metafile; picture
                 height in pixels if the picture is a bitmap or from QuickDraw.
                 The N argument is a long integer.
  \picwgoalN   - Desired width of the picture in twips. The N argument is a
                 long integer.
  \pichgoalN   - Desired height of the picture in twips. The N argument is a
                 long integer.
}

const
  CPrefix = '{\rtf1 {\pict\wmetafile8\picw%d\pich%d\picwgoal%d\pichgoal%d ';
  CPostfix = ' }}';
var
  P, Q: PChar;
  S: string;
  DC: HDC;
  MetafileHandle: HMETAFILE;
  Size: TPoint;
  BitsLength: UINT;
  Bits: PChar;
begin
  Result := False;

  // Retrieve Extent
  Size.X := MulDiv(ABitmap.Width, CHundredthMMPerInch, Screen.PixelsPerInch);
  Size.Y := MulDiv(ABitmap.Height, CHundredthMMPerInch, Screen.PixelsPerInch);

  // Create Metafile DC and set it up
  DC := CreateMetafile(nil);

  SetWindowOrgEx(DC, 0, 0, nil);
  SetWindowExtEx(DC, Size.X, Size.Y, nil);

  StretchBlt(DC, 0, 0, Size.X, Size.Y,
    ABitmap.Canvas.Handle, 0, 0, ABitmap.Width, ABitmap.Height, SRCCOPY);

  MetafileHandle := CloseMetaFile(DC);

  if MetafileHandle = 0 then
    Exit;

  try
    BitsLength := GetMetaFileBitsEx(MetafileHandle, 0, nil);
    GetMem(Bits, BitsLength * 2);
    try
      if GetMetaFileBitsEx(MetafileHandle, BitsLength, Bits) < BitsLength then
        Exit;

      Q := Bits + BitsLength - 1;
      //P := Bits + 2 * BitsLength - 1;
      P := Q + BitsLength;
      while Q >= Bits do
      begin
        P^ := CHex[Byte(Q^) mod 16];
        Dec(P);
        P^ := CHex[Byte(Q^) div 16];
        Dec(P);
        Dec(Q);
      end;

      S := Format(CPrefix, [Size.X, Size.Y,
        MulDiv(ABitmap.Width, CTwipsPerInch, Screen.PixelsPerInch),
          MulDiv(ABitmap.Height, CTwipsPerInch, Screen.PixelsPerInch)]);
      AStream.Write(PChar(S)^, Length(S));
      AStream.Write(Bits^, BitsLength * 2);
      AStream.Write(CPostfix, Length(CPostfix));

      Result := True;
    finally
      FreeMem(Bits, BitsLength * 2);
    end;
  finally
    DeleteMetafile(MetafileHandle);
  end;
end;

//=== EMSTextConversionError =================================================

constructor EMSTextConversionError.Create(const Msg: string; AErrorCode: FCE);
var
  S: string;
begin
  S := Msg;
  if S = '' then
  begin
    S := FCEToString(AErrorCode);
    if S = '' then
      S := Format(SConversionError, [AErrorCode]);
  end;
  inherited Create(S);
  FErrorCode := AErrorCode;
end;

//=== TConversionFormatList ==================================================

constructor TConversionFormatList.Create;
begin
  inherited Create;
  FRTFConvIndex := Add(TJvRTFConversion.Create);
  FTextConvIndex := Add(TJvTextConversion.Create);
end;

function TConversionFormatList.DefaultConverter: TJvConverter;
begin
  Result := Items[FRTFConvIndex];
end;

function TConversionFormatList.GetConverterForFile(const AFileName: string;
  const Kind: TJvConversionKind): TJvConverter;
var
  Ext: string;
  I: Integer;

  function IsFormatCorrect(Converter: TJvConverter): Boolean;
  begin
    Result := False;
    try
      Result := Converter.IsFormatCorrect(AFileName);
    finally
      if not Result then
        Converter.Done;
    end;
  end;

begin
  Ext := AnsiLowerCaseFileName(ExtractFileExt(AFileName));
  System.Delete(Ext, 1, 1);

  Result := nil;
  for I := 0 to Count - 1 do
    if Items[i].CanHandle(Ext, Kind) and
      ((Kind <> ckImport) or IsFormatCorrect(Items[i])) then
    begin
      Result := Items[i];
      Break;
    end;
end;

function TConversionFormatList.GetFilter(const AKind: TJvConversionKind): string;
var
  I: Integer;
begin
  Result := '';

  for i := 0 to Count - 1 do
    if Items[i].CanHandle(AKind) then
      Result := Result + Items[i].Filter + '|';

  if Result > '' then
    System.Delete(Result, Length(Result), 1);
end;

function TConversionFormatList.GetItem(Index: Integer): TJvConverter;
begin
  Result := inherited Items[Index] as TJvConverter;
end;

procedure TConversionFormatList.SetItem(Index: Integer;
  const Value: TJvConverter);
begin
  inherited Items[Index] := Value;
end;

//=== TImageDataObject =======================================================

constructor TImageDataObject.Create(ABitmap: TBitmap);
begin
  inherited Create;

  FBitmap := ABitmap;
end;

function TImageDataObject.DAdvise(const formatetc: TFormatEtc;
  advf: Integer; const advSink: IAdviseSink;
  out dwConnection: Integer): HResult;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

function TImageDataObject.DUnadvise(dwConnection: Integer): HResult;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

function TImageDataObject.EnumDAdvise(
  out enumAdvise: IEnumStatData): HResult;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

function TImageDataObject.EnumFormatEtc(dwDirection: Integer;
  out enumFormatEtc: IEnumFormatEtc): HResult;
begin
  enumFormatEtc := nil;
  Result := E_NOTIMPL;
end;

function TImageDataObject.GetCanonicalFormatEtc(
  const formatetc: TFormatEtc; out formatetcOut: TFormatEtc): HResult;
begin
  formatetcOut.ptd := nil;
  Result := E_NOTIMPL;
end;

function TImageDataObject.GetData(const formatetcIn: TFormatEtc;
  out medium: TStgMedium): HResult;
var
  sizeMetric: TPoint;
  DC: HDC;
  hMF: HMETAFILE;
  hMem: THandle;
  pMFP: PMetafilePict;
begin
  { Basically the code from AxCtrls.pas TActiveXControl.GetData }

  // Handle only MetaFile
  if (formatetcin.tymed and TYMED_MFPICT) = 0 then
  begin
    Result := DV_E_FORMATETC;
    Exit;
  end;
  // Retrieve Extent
  GetExtent(DVASPECT_CONTENT, sizeMetric);
  // Create Metafile DC and set it up
  DC := CreateMetafile(nil);
  SetWindowOrgEx(DC, 0, 0, nil);
  SetWindowExtEx(DC, sizemetric.X, sizemetric.Y, nil);

  StretchBlt(DC, 0, 0, sizeMetric.X, sizeMetric.Y,
    FBitmap.Canvas.Handle, 0, 0, FBitmap.Width, FBitmap.Height, SRCCOPY);
  hMF := CloseMetaFile(DC);
  if hMF = 0 then
  begin
    Result := E_UNEXPECTED;
    Exit;
  end;

  // Get memory handle
  hMEM := GlobalAlloc(GMEM_SHARE or GMEM_MOVEABLE, SizeOf(METAFILEPICT));
  if hMEM = 0 then
  begin
    DeleteMetafile(hMF);
    Result := STG_E_MEDIUMFULL;
    Exit;
  end;
  pMFP := PMetaFilePict(GlobalLock(hMEM));
  pMFP^.hMF := hMF;
  pMFP^.mm := MM_ANISOTROPIC;
  pMFP^.xExt := sizeMetric.X;
  pMFP^.yExt := sizeMetric.Y;
  GlobalUnlock(hMEM);

  medium.tymed := TYMED_MFPICT;
  medium.hGlobal := hMEM;
  medium.unkForRelease := nil;

  Result := S_OK;
end;

function TImageDataObject.GetDataHere(const formatetc: TFormatEtc;
  out medium: TStgMedium): HResult;
begin
  Result := E_NOTIMPL;
end;

function TImageDataObject.GetExtent(dwDrawAspect: Integer;
  out Size: TPoint): HResult;
begin
  if dwDrawAspect <> DVASPECT_CONTENT then
  begin
    Result := DV_E_DVASPECT;
    Exit;
  end;
  Size.X := MulDiv(FBitmap.Width, CHundredthMMPerInch, Screen.PixelsPerInch);
  Size.Y := MulDiv(FBitmap.Height, CHundredthMMPerInch, Screen.PixelsPerInch);
  Result := S_OK;
end;

function TImageDataObject.QueryGetData(
  const formatetc: TFormatEtc): HResult;
begin
  Result := E_NOTIMPL;
end;

function TImageDataObject.SetData(const formatetc: TFormatEtc;
  var medium: TStgMedium; fRelease: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;

//=== TJvConverter ===========================================================

function TJvConverter.CanHandle(const AKind: TJvConversionKind): Boolean;
begin
  Result := True;
end;

function TJvConverter.CanHandle(const AExtension: string;
  const AKind: TJvConversionKind): Boolean;
begin
  Result := True;
end;

function TJvConverter.ConvertRead(Buffer: PChar;
  BufSize: Integer): Integer;
begin
  Result := -1;
end;

function TJvConverter.ConvertWrite(Buffer: PChar;
  BufSize: Integer): Integer;
begin
  Result := -1;
end;

procedure TJvConverter.Done;
begin
end;

procedure TJvConverter.DoProgress(ANewProgress: Integer);
begin
  if ANewProgress < 0 then
    ANewProgress := 0
  else
  if ANewProgress > 100 then
    ANewProgress := 100;
  if ANewProgress <> FProgress then
  begin
    FProgress := ANewProgress;
    if Assigned(FOnProgress) then
      FOnProgress(Self);
  end;
end;

function TJvConverter.Error: Boolean;
begin
  Result := False;
end;

function TJvConverter.ErrorStr: string;
begin
  Result := '';
end;

function TJvConverter.Filter: string;
begin
  Result := '';
end;

function TJvConverter.IsFormatCorrect(const AFileName: string): Boolean;
begin
  Result := True;
end;

function TJvConverter.IsFormatCorrect(AStream: TStream): Boolean;
begin
  Result := True;
end;

function TJvConverter.Open(const AFileName: string;
  const AKind: TJvConversionKind): Boolean;
begin
  Result := False;
end;

function TJvConverter.Open(Stream: TStream;
  const AKind: TJvConversionKind): Boolean;
begin
  Result := False;
end;

function TJvConverter.Retry: Boolean;
begin
  Result := False;
end;

function TJvConverter.TextKind: TJvConversionTextKind;
begin
  Result := ctkRTF;
end;

//=== TJvCustomRichEdit ======================================================

procedure TJvCustomRichEdit.AddFormatText(const S: string; const AFont: TFont);
begin
  InsertFormatText(GetTextLen, S, AFont);
end;

procedure TJvCustomRichEdit.AdjustFindDialogPosition(Dialog: TFindDialog);
var
  TextRect, R: TRect;
begin
  if Dialog.Handle = 0 then
    Exit;
  with TextRect do
  begin
    TopLeft := ClientToScreen(GetCharPos(SelStart));
    BottomRight := ClientToScreen(GetCharPos(SelStart + SelLength));
    Inc(Bottom, 20);
  end;
  with Dialog do
  begin
    GetWindowRect(Handle, R);
    if PtInRect(R, TextRect.TopLeft) or PtInRect(R, TextRect.BottomRight) then
    begin
      if TextRect.Top > R.Bottom - R.Top + 20 then
        OffsetRect(R, 0, TextRect.Top - R.Bottom - 20)
      else
      begin
        if TextRect.Top + R.Bottom - R.Top < GetSystemMetrics(SM_CYSCREEN) then
          OffsetRect(R, 0, 40 + TextRect.Top - R.Top);
      end;
      Position := R.TopLeft;
    end;
  end;
end;

procedure TJvCustomRichEdit.Clear;
begin
  CloseObjects;
  inherited Clear;
  Modified := False;
end;

procedure TJvCustomRichEdit.ClearUndo;
begin
  SendMessage(Handle, EM_EMPTYUNDOBUFFER, 0, 0);
end;

procedure TJvCustomRichEdit.CloseFindDialog(Dialog: TFindDialog);
begin
  if Assigned(FOnCloseFindDialog) then
    FOnCloseFindDialog(Self, Dialog);
end;

procedure TJvCustomRichEdit.CloseObjects;
var
  I: Integer;
  ReObject: TReObject;
begin
  if Assigned(FRichEditOle) then
  begin
    FillChar(ReObject, SizeOf(ReObject), 0);
    ReObject.cbStruct := SizeOf(ReObject);
    with IRichEditOle(FRichEditOle) do
    begin
      for I := GetObjectCount - 1 downto 0 do
        if Succeeded(GetObject(I, ReObject, REO_GETOBJ_POLEOBJ)) then
        begin
          if ReObject.dwFlags and REO_INPLACEACTIVE <> 0 then
            IRichEditOle(FRichEditOle).InPlaceDeactivate;
          ReObject.poleobj.Close(OLECLOSE_NOSAVE);
          ReleaseObject(ReObject.poleobj);
        end;
    end;
  end;
end;

procedure TJvCustomRichEdit.CMBiDiModeChanged(var Msg: TMessage);
var
  AParagraph: TParaFormat2;
begin
  HandleNeeded; { we REALLY need the handle for BiDi }
  inherited;
  Paragraph.GetAttributes(AParagraph);
  AParagraph.dwMask := PFM_ALIGNMENT;
  AParagraph.wAlignment := Ord(Alignment) + 1;
  Paragraph.SetAttributes(AParagraph);
end;

procedure TJvCustomRichEdit.CMColorChanged(var Msg: TMessage);
begin
  inherited;
  SendMessage(Handle, EM_SETBKGNDCOLOR, 0, ColorToRGB(Color))
end;

// From JvRichEdit.pas by S�bastien Buysse

procedure TJvCustomRichEdit.CMCtl3DChanged(var Msg: TMessage);
begin
  inherited;
  if Assigned(FOnCtl3DChanged) then
    FOnCtl3DChanged(Self);
end;

procedure TJvCustomRichEdit.CMDocWindowActivate(var Msg: TMessage);
begin
  if Assigned(FCallback) then
    with TRichEditOleCallback(FCallback) do
      if Assigned(FDocForm) and IsFormMDIChild(FDocForm.Form) then
      begin
        if Msg.WParam = 0 then
        begin
          FFrameForm.SetMenu(0, 0, 0);
          FFrameForm.ClearBorderSpace;
        end;
      end;
end;

procedure TJvCustomRichEdit.CMFontChanged(var Msg: TMessage);
begin
  inherited;
  FDefAttributes.Assign(Font);
end;

procedure TJvCustomRichEdit.CMParentColorChanged(var Msg: TMessage);
begin
  inherited;
  if Assigned(FOnParentColorChanged) then
    FOnParentColorChanged(Self);
end;

procedure TJvCustomRichEdit.CMUIDeactivate(var Msg: TMessage);
begin
  if (GetParentForm(Self) <> nil) and Assigned(FRichEditOle) and
    (GetParentForm(Self).ActiveOleControl = Self) then
    {IRichEditOle(FRichEditOle).InPlaceDeactivate};
end;

procedure TJvCustomRichEdit.CNNotify(var Msg: TWMNotify);
var
  AMsg: TMessage;
begin
  with Msg do
    case NMHdr^.code of
      EN_SELCHANGE:
        SelectionChange;
      EN_REQUESTRESIZE:
        RequestSize(PReqSize(NMHdr)^.RC);
      EN_SAVECLIPBOARD:
        with PENSaveClipboard(NMHdr)^ do
          if not SaveClipboard(cObjectCount, cch) then
            Result := 1;
      EN_PROTECTED:
        with PENProtected(NMHdr)^ do
        begin
          AMsg.Msg := Msg;
          AMsg.WParam := WParam;
          AMsg.LParam := LParam;
          AMsg.Result := 0;
          if not ProtectChange(AMsg, chrg.cpMin, chrg.cpMax) then
            Result := 1;
        end;
      EN_LINK:
        with PENLink(NMHdr)^ do
        begin
          case Msg of
            WM_RBUTTONDOWN:
              begin
                FClickRange := chrg;
                FClickBtn := mbRight;
              end;
            WM_RBUTTONUP:
              begin
                if (FClickBtn = mbRight) and (FClickRange.cpMin = chrg.cpMin) and
                  (FClickRange.cpMax = chrg.cpMax) then
                  URLClick(GetTextRange(chrg.cpMin, chrg.cpMax), mbRight);
                with FClickRange do
                begin
                  cpMin := -1;
                  cpMax := -1;
                end;
              end;
            WM_LBUTTONDOWN:
              begin
                FClickRange := chrg;
                FClickBtn := mbLeft;
              end;
            WM_LBUTTONUP:
              begin
                if (FClickBtn = mbLeft) and (FClickRange.cpMin = chrg.cpMin) and
                  (FClickRange.cpMax = chrg.cpMax) then
                  URLClick(GetTextRange(chrg.cpMin, chrg.cpMax), mbLeft);
                with FClickRange do
                begin
                  cpMin := -1;
                  cpMax := -1;
                end;
              end;
          end;
        end;
      EN_STOPNOUNDO:
        begin
          { cannot allocate enough memory to maintain the undo state }
        end;
    end;
end;

constructor TJvCustomRichEdit.Create(AOwner: TComponent);
var
  DC: HDC;
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls] - [csSetCaption];
  IncludeThemeStyle(Self, [csNeedsBorderPaint]);
  FHintColor := clInfoBk;
  FSelAttributes := TJvTextAttributes.Create(Self, atSelected);
  FDefAttributes := TJvTextAttributes.Create(Self, atDefaultText);
  FWordAttributes := TJvTextAttributes.Create(Self, atWord);
  FParagraph := TJvParaAttributes.Create(Self);
  FRichEditStrings := TJvRichEditStrings.Create;
  TJvRichEditStrings(FRichEditStrings).FRichEdit := Self;
  TabStop := True;
  Width := 185;
  Height := 89;
  AutoSize := False;
  DoubleBuffered := False;
  FAllowObjects := True;
  FAllowInPlace := True;
  FAutoVerbMenu := True;
  FHideSelection := True;
  FHideScrollBars := True;
  ScrollBars := ssBoth;
  FSelectionBar := True;
  FLangOptions := [rlAutoFont];
  DC := GetDC(0);
  FScreenLogPixels := GetDeviceCaps(DC, LOGPIXELSY);
  ReleaseDC(0, DC);
  DefaultConverter := nil;
  FOldParaAlignment := TParaAlignment(Alignment);
  FUndoLimit := 100;
  FAutoURLDetect := True;
  FWordSelection := True;
  with FClickRange do
  begin
    cpMin := -1;
    cpMax := -1;
  end;
  FCallback := TRichEditOleCallback.Create(Self);
  Perform(CM_PARENTBIDIMODECHANGED, 0, 0);
end;

procedure TJvCustomRichEdit.CreateParams(var Params: TCreateParams);
const
  HideScrollBars: array [Boolean] of DWORD = (ES_DISABLENOSCROLL, 0);
  HideSelections: array [Boolean] of DWORD = (ES_NOHIDESEL, 0);
  WordWraps: array [Boolean] of DWORD = (0, ES_AUTOHSCROLL);
  SelectionBars: array [Boolean] of DWORD = (0, ES_SELECTIONBAR);
begin
  inherited CreateParams(Params);
  case RichEditVersion of
    1:
      CreateSubClass(Params, RICHEDIT_CLASS10A);
  else
    CreateSubClass(Params, RICHEDIT_CLASS);
  end;
  with Params do
  begin
    Style := (Style and not (WS_HSCROLL or WS_VSCROLL)) or ES_SAVESEL or
      (WS_CLIPSIBLINGS or WS_CLIPCHILDREN);
    { NOTE: WS_CLIPCHILDREN and WS_CLIPSIBLINGS are essential otherwise }
    { once the object is inserted you see some painting problems.       }
    Style := Style and not (WS_HSCROLL or WS_VSCROLL);
    if ScrollBars in [ssVertical, ssBoth] then
      Style := Style or WS_VSCROLL;
    if (ScrollBars in [ssHorizontal, ssBoth]) and not WordWrap then
      Style := Style or WS_HSCROLL;
    Style := Style or HideScrollBars[FHideScrollBars] or
      SelectionBars[FSelectionBar] or HideSelections[FHideSelection] and
      not WordWraps[WordWrap];
    WindowClass.Style := WindowClass.Style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TJvCustomRichEdit.CreateWindowHandle(const Params: TCreateParams);
var
  Bounds: TRect;
begin
  Bounds := BoundsRect;
  inherited CreateWindowHandle(Params);
  if HandleAllocated then
    BoundsRect := Bounds;
end;

procedure TJvCustomRichEdit.CreateWnd;
var
  StreamFmt: TRichStreamFormat;
  Mode: TRichStreamModes;
  DesignMode: Boolean;
  Mask: Longint;
begin
  StreamFmt := TJvRichEditStrings(Lines).Format;
  Mode := TJvRichEditStrings(Lines).Mode;
  inherited CreateWnd;
  if (SysLocale.FarEast) and not (SysLocale.PriLangID = LANG_JAPANESE) then
    Font.Charset := GetDefFontCharSet;
  Mask := ENM_CHANGE or ENM_SELCHANGE or ENM_REQUESTRESIZE or ENM_PROTECTED;
  if RichEditVersion >= 2 then
    Mask := Mask or ENM_LINK;
  SendMessage(Handle, EM_SETEVENTMASK, 0, Mask);
  SendMessage(Handle, EM_SETBKGNDCOLOR, 0, ColorToRGB(Color));
  DoSetMaxLength(MaxLength);
  SetWordSelection(FWordSelection);
  if RichEditVersion >= 2 then
  begin
    SendMessage(Handle, EM_AUTOURLDETECT, Longint(FAutoURLDetect), 0);
    FUndoLimit := SendMessage(Handle, EM_SETUNDOLIMIT, FUndoLimit, 0);
    UpdateTextModes(PlainText);
    SetLangOptions(FLangOptions);
  end;
  if FAllowObjects then
  begin
    SendMessage(Handle, EM_SETOLECALLBACK, 0,
      LParam(TRichEditOleCallback(FCallback) as IRichEditOleCallback));
    GetRichEditOle(Handle, FRichEditOle);
    UpdateHostNames;
  end;
  if FMemStream <> nil then
  begin
    FMemStream.ReadBuffer(DesignMode, SizeOf(DesignMode));
    if DesignMode then
    begin
      TJvRichEditStrings(Lines).Format := sfPlainText;
      TJvRichEditStrings(Lines).Mode := [];
    end;
    try
      Lines.LoadFromStream(FMemStream);
      FMemStream.Free;
      FMemStream := nil;
    finally
      TJvRichEditStrings(Lines).Format := StreamFmt;
      TJvRichEditStrings(Lines).Mode := Mode;
    end;
  end;
  if RichEditVersion < 2 then
    SendMessage(Handle, WM_SETFONT, 0, 0);
  Modified := FModified;
end;

destructor TJvCustomRichEdit.Destroy;
begin
  FLastFind := nil;
  FSelAttributes.Free;
  FDefAttributes.Free;
  FWordAttributes.Free;
  FParagraph.Free;
  FRichEditStrings.Free;
  FMemStream.Free;
  FPopupVerbMenu.Free;
  FFindDialog.Free;
  FReplaceDialog.Free;
  inherited Destroy;
  { be sure that callback object is destroyed after inherited Destroy }
  TRichEditOleCallback(FCallback).Free;
end;

procedure TJvCustomRichEdit.DestroyWnd;
var
  StreamFmt: TRichStreamFormat;
  Mode: TRichStreamModes;
  DesignMode: Boolean;
begin
  FModified := Modified;
  FMemStream := TMemoryStream.Create;
  StreamFmt := TJvRichEditStrings(Lines).Format;
  Mode := TJvRichEditStrings(Lines).Mode;
  DesignMode := (csDesigning in ComponentState);
  FMemStream.WriteBuffer(DesignMode, SizeOf(DesignMode));
  if DesignMode then
  begin
    TJvRichEditStrings(Lines).Format := sfPlainText;
    TJvRichEditStrings(Lines).Mode := [];
  end;
  try
    Lines.SaveToStream(FMemStream);
    FMemStream.Position := 0;
  finally
    TJvRichEditStrings(Lines).Format := StreamFmt;
    TJvRichEditStrings(Lines).Mode := Mode;
  end;
  inherited DestroyWnd;
end;

procedure TJvCustomRichEdit.DoConversionProgress(const AProgress: Integer);
begin
  if Assigned(FOnConversionProgress) then
    FOnConversionProgress(Self, AProgress);
end;

procedure TJvCustomRichEdit.DoSetMaxLength(Value: Integer);
begin
  { The rich edit control's default maximum amount of text is 32K }
  { Let's set it at 16M by default }
  if Value = 0 then
    Value := $FFFFFF;
  SendMessage(Handle, EM_EXLIMITTEXT, 0, Value);
end;

procedure TJvCustomRichEdit.EMReplaceSel(var Msg: TMessage);
var
  CharRange: TCharRange;
begin
  Perform(EM_EXGETSEL, 0, Longint(@CharRange));
  with CharRange do
    cpMax := cpMin + Integer(StrLen(PChar(Msg.LParam)));
  if (FUndoLimit > 1) and (RichEditVersion >= 2) and not FLinesUpdating then
    Msg.WParam := 1; { allow Undo }
  inherited;
  if FLinesUpdating then
    CharRange.cpMin := CharRange.cpMax;
  Perform(EM_EXSETSEL, 0, Longint(@CharRange));
  Perform(EM_SCROLLCARET, 0, 0);
end;

class function TJvCustomRichEdit.Filter(
  const AKind: TJvConversionKind): string;
begin
  Result := GConversionFormatList.GetFilter(AKind);
end;

function TJvCustomRichEdit.FindDialog(const SearchStr: string): TFindDialog;
begin
  if FFindDialog = nil then
  begin
    FFindDialog := TFindDialog.Create(Self);
    if FReplaceDialog <> nil then
      FFindDialog.FindText := FReplaceDialog.FindText;
  end;
  Result := FFindDialog;
  SetupFindDialog(FFindDialog, SearchStr, '');
  FFindDialog.Execute;
end;

procedure TJvCustomRichEdit.FindDialogClose(Sender: TObject);
begin
  CloseFindDialog(Sender as TFindDialog);
end;

procedure TJvCustomRichEdit.FindDialogFind(Sender: TObject);
begin
  FindEditText(TFindDialog(Sender), True, True);
end;

function TJvCustomRichEdit.FindEditText(Dialog: TFindDialog; AdjustPos, Events: Boolean): Boolean;
var
  Length, StartPos: Integer;
  SrchOptions: TRichSearchTypes;
begin
  with TFindDialog(Dialog) do
  begin
    SrchOptions := [stSetSelection];
    if frDown in Options then
    begin
      StartPos := Max(SelStart, SelStart + SelLength);
      Length := System.Length(Text) - StartPos + 1;
    end
    else
    begin
      SrchOptions := SrchOptions + [stBackward];
      StartPos := Min(SelStart, SelStart + SelLength);
      Length := StartPos + 1;
    end;
    if frMatchCase in Options then
      SrchOptions := SrchOptions + [stMatchCase];
    if frWholeWord in Options then
      SrchOptions := SrchOptions + [stWholeWord];
    Result := Self.FindText(FindText, StartPos, Length, SrchOptions) >= 0;
    if FindText <> '' then
      FLastFind := Dialog;
    if Result then
    begin
      if AdjustPos then
        AdjustFindDialogPosition(Dialog);
    end
    else
    if Events then
      TextNotFound(Dialog);
  end;
end;

function TJvCustomRichEdit.FindNext: Boolean;
begin
  if CanFindNext then
    Result := FindEditText(FLastFind, False, True)
  else
    Result := False;
end;

function TJvCustomRichEdit.FindText(const SearchStr: string;
  StartPos, Length: Integer; Options: TRichSearchTypes): Integer;
var
  Find: TFindTextEx;
  Flags: Integer;
begin
  with Find.chrg do
  begin
    cpMin := StartPos;
    cpMax := cpMin + Abs(Length);
  end;
  if RichEditVersion >= 2 then
  begin
    if not (stBackward in Options) then
      Flags := FT_DOWN
    else
      Flags := 0;
  end
  else
  begin
    Options := Options - [stBackward];
    Flags := 0;
  end;
  if stWholeWord in Options then
    Flags := Flags or FT_WHOLEWORD;
  if stMatchCase in Options then
    Flags := Flags or FT_MATCHCASE;
  Find.lpstrText := PChar(SearchStr);
  Result := SendMessage(Handle, EM_FINDTEXTEX, Flags, Longint(@Find));
  if (Result >= 0) and (stSetSelection in Options) then
  begin
    SendMessage(Handle, EM_EXSETSEL, 0, Longint(@Find.chrgText));
    SendMessage(Handle, EM_SCROLLCARET, 0, 0);
  end;
end;

function TJvCustomRichEdit.GetAutoURLDetect: Boolean;
begin
  Result := FAutoURLDetect;
  if HandleAllocated and not (csDesigning in ComponentState) then
  begin
    if RichEditVersion >= 2 then
      Result := Boolean(SendMessage(Handle, EM_GETAUTOURLDETECT, 0, 0));
  end;
end;

function TJvCustomRichEdit.GetCanFindNext: Boolean;
begin
  Result := HandleAllocated and (FLastFind <> nil) and
    (FLastFind.FindText <> '');
end;

function TJvCustomRichEdit.GetCanPaste: Boolean;
begin
  Result := False;
  if HandleAllocated then
    Result := SendMessage(Handle, EM_CANPASTE, 0, 0) <> 0;
end;

function TJvCustomRichEdit.GetCanRedo: Boolean;
begin
  Result := False;
  if HandleAllocated and (RichEditVersion >= 2) then
    Result := SendMessage(Handle, EM_CANREDO, 0, 0) <> 0;
end;

function TJvCustomRichEdit.GetCaretPos: TPoint;
var
  CharRange: TCharRange;
begin
  SendMessage(Handle, EM_EXGETSEL, 0, Longint(@CharRange));
  Result.X := CharRange.cpMax;
  Result.Y := LineFromChar(Result.X);
  Dec(Result.X, GetLineIndex(-1));
end;

function TJvCustomRichEdit.GetCharPos(CharIndex: Integer): TPoint;
var
  Res: Longint;
begin
  Result.X := 0;
  Result.Y := 0;
  //  FillChar(Result, SizeOf(Result), 0);
  if HandleAllocated then
  begin
    if RichEditVersion = 2 then
    begin
      Res := SendMessage(Handle, Messages.EM_POSFROMCHAR, CharIndex, 0);
      Result.X := LoWord(Res);
      Result.Y := HiWord(Res);
    end
    else { RichEdit 1.0 and 3.0 }
      SendMessage(Handle, Messages.EM_POSFROMCHAR, WParam(@Result), CharIndex);
  end;
end;

function TJvCustomRichEdit.GetLangOptions: TRichLangOptions;
var
  Flags: Longint;
  I: TRichLangOption;
begin
  Result := FLangOptions;
  if HandleAllocated and not (csDesigning in ComponentState) and
    (RichEditVersion >= 2) then
  begin
    Result := [];
    Flags := SendMessage(Handle, EM_GETLANGOPTIONS, 0, 0);
    for I := Low(TRichLangOption) to High(TRichLangOption) do
      if Flags and RichLangOptions[I] <> 0 then
        Include(Result, I);
  end;
end;

function TJvCustomRichEdit.GetLineIndex(LineNo: Integer): Integer;
begin
  Result := SendMessage(Handle, EM_LINEINDEX, LineNo, 0);
end;

function TJvCustomRichEdit.GetLineLength(CharIndex: Integer): Integer;
begin
  Result := SendMessage(Handle, EM_LINELENGTH, CharIndex, 0);
end;

function TJvCustomRichEdit.GetPopupMenu: TPopupMenu;
var
  EnumOleVerb: IEnumOleVerb;
  OleVerb: TOleVerb;
  Item: TMenuItem;
  ReObject: TReObject;
begin
  FPopupVerbMenu.Free;
  FPopupVerbMenu := nil;
  Result := inherited GetPopupMenu;
  if FAutoVerbMenu and (SelectionType = [stObject]) and
    Assigned(FRichEditOle) then
  begin
    FillChar(ReObject, SizeOf(ReObject), 0);
    ReObject.cbStruct := SizeOf(ReObject);
    if Succeeded(IRichEditOle(FRichEditOle).GetObject(
      Longint(REO_IOB_SELECTION), ReObject, REO_GETOBJ_POLEOBJ)) then
    try
      if Assigned(ReObject.poleobj) and
        (ReObject.dwFlags and REO_INPLACEACTIVE = 0) then
      begin
        FPopupVerbMenu := TPopupMenu.Create(Self);
        if ReObject.poleobj.EnumVerbs(EnumOleVerb) = 0 then
        try
          while (EnumOleVerb.Next(1, OleVerb, nil) = 0) and
            (OleVerb.lVerb >= 0) and
            (OleVerb.grfAttribs and OLEVERBATTRIB_ONCONTAINERMENU <> 0) do
          begin
            Item := TMenuItem.Create(FPopupVerbMenu);
            Item.Caption := WideCharToString(OleVerb.lpszVerbName);
            Item.Tag := OleVerb.lVerb;
            Item.Default := (OleVerb.lVerb = OLEIVERB_PRIMARY);
            Item.OnClick := PopupVerbClick;
            FPopupVerbMenu.Items.Add(Item);
          end;
        finally
          ReleaseObject(EnumOleVerb);
        end;
        if (Result <> nil) and (Result.Items.Count > 0) then
        begin
          Item := TMenuItem.Create(FPopupVerbMenu);
          Item.Caption := '-';
          Result.Items.Add(Item);
          Item := TMenuItem.Create(FPopupVerbMenu);
          Item.Caption := Format(SPropDlgCaption, [GetFullNameStr(ReObject.poleobj)]);
          Item.OnClick := ObjectPropsClick;
          Result.Items.Add(Item);
          if FPopupVerbMenu.Items.Count > 0 then
          begin
            FPopupVerbMenu.Items.Caption := GetFullNameStr(ReObject.poleobj);
            Result.Items.Add(FPopupVerbMenu.Items);
          end;
        end
        else
        if FPopupVerbMenu.Items.Count > 0 then
        begin
          Item := TMenuItem.Create(FPopupVerbMenu);
          Item.Caption := Format(SPropDlgCaption, [GetFullNameStr(ReObject.poleobj)]);
          Item.OnClick := ObjectPropsClick;
          FPopupVerbMenu.Items.Insert(0, Item);
          Result := FPopupVerbMenu;
        end;
      end;
    finally
      ReleaseObject(ReObject.poleobj);
    end;
  end;
end;

function TJvCustomRichEdit.GetRedoName: TUndoName;
begin
  Result := unUnknown;
  if (RichEditVersion >= 2) and HandleAllocated then
    Result := TUndoName(SendMessage(Handle, EM_GETREDONAME, 0, 0));
end;

function TJvCustomRichEdit.GetSelection: TCharRange;
begin
  SendMessage(Handle, EM_EXGETSEL, 0, Longint(@Result));
end;

function TJvCustomRichEdit.GetSelectionType: TRichSelectionType;
const
  SelTypes: array [TRichSelection] of Integer =
  (SEL_TEXT, SEL_OBJECT, SEL_MULTICHAR, SEL_MULTIOBJECT);
var
  Selection: Integer;
  I: TRichSelection;
begin
  Result := [];
  if HandleAllocated then
  begin
    Selection := SendMessage(Handle, EM_SELECTIONTYPE, 0, 0);
    for I := Low(TRichSelection) to High(TRichSelection) do
      if SelTypes[I] and Selection <> 0 then
        Include(Result, I);
  end;
end;

function TJvCustomRichEdit.GetSelLength: Integer;
begin
  with GetSelection do
    Result := cpMax - cpMin;
end;

function TJvCustomRichEdit.GetSelStart: Integer;
begin
  Result := GetSelection.cpMin;
end;

function TJvCustomRichEdit.GetSelText: string;
begin
  with GetSelection do
    Result := GetTextRange(cpMin, cpMax);
end;

function TJvCustomRichEdit.GetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer;
var
  S: string;
begin
  S := SelText;
  Result := Length(S);
  if BufSize < Length(S) then
    Result := BufSize;
  StrPLCopy(Buffer, S, Result);
end;

function TJvCustomRichEdit.GetStreamFormat: TRichStreamFormat;
begin
  Result := TJvRichEditStrings(Lines).Format;
end;

function TJvCustomRichEdit.GetStreamMode: TRichStreamModes;
begin
  Result := TJvRichEditStrings(Lines).Mode;
end;

function TJvCustomRichEdit.GetTextRange(StartPos, EndPos: Longint): string;
var
  TextRange: TTextRange;
begin
  SetLength(Result, EndPos - StartPos + 1);
  TextRange.chrg.cpMin := StartPos;
  TextRange.chrg.cpMax := EndPos;
  TextRange.lpstrText := PAnsiChar(Result);
  SetLength(Result, SendMessage(Handle, EM_GETTEXTRANGE, 0, Longint(@TextRange)));
end;

function TJvCustomRichEdit.GetUndoName: TUndoName;
begin
  Result := unUnknown;
  if (RichEditVersion >= 2) and HandleAllocated then
    Result := TUndoName(SendMessage(Handle, EM_GETUNDONAME, 0, 0));
end;

function TJvCustomRichEdit.GetWordSelection: Boolean;
begin
  Result := FWordSelection;
  if HandleAllocated then
    Result := (SendMessage(Handle, EM_GETOPTIONS, 0, 0) and
      ECO_AUTOWORDSELECTION) <> 0;
end;

procedure TJvCustomRichEdit.InsertBitmap(ABitmap: TBitmap; const Sizeable: Boolean);
var
  OleClientSite: IOleClientSite;
  Storage: IStorage;
  OleObject: IOleObject;
  ReObject: TReObject;
  DataObject: IDataObject;
  Selection: TCharRange;
  FormatEtc: TFormatEtc;
begin
  if HandleAllocated and Assigned(FRichEditOle) then
  begin
    DataObject := TImageDataObject.Create(ABitmap);

    FillChar(ReObject, SizeOf(TReObject), 0);
    IRichEditOle(FRichEditOle).GetClientSite(OleClientSite);
    Storage := nil;
    OleObject := nil;
    try
      CreateStorage(Storage);

      FormatEtc.cfFormat := CF_METAFILEPICT;
      FormatEtc.ptd := nil;
      FormatEtc.dwAspect := DVASPECT_CONTENT;
      FormatEtc.lindex := -1;
      FormatEtc.tymed := TYMED_MFPICT;

      OleCheck(OleCreateStaticFromData(DataObject, IOleObject, OLERENDER_FORMAT,
        @FormatEtc, OleClientSite, Storage, OleObject));
      OleSetContainedObject(OleObject, True);
      try
        FillChar(ReObject, SizeOf(TReObject), #0);
        with ReObject do
        begin
          cbStruct := SizeOf(TReObject);
          cp := REO_CP_SELECTION;
          poleobj := OleObject;
          OleObject.GetUserClassID(clsid);
          pstg := Storage;
          polesite := OleClientSite;
          dvAspect := DVASPECT_CONTENT;
          if Sizeable then
            dwFlags := REO_RESIZABLE;
          //OleCheck(OleSetDrawAspect(OleObject,
          //  Data.dwFlags and PSF_CHECKDISPLAYASICON <> 0,
          //  Data.hMetaPict, dvAspect));
        end;
        SendMessage(Handle, EM_EXGETSEL, 0, Longint(@Selection));
        Selection.cpMax := Selection.cpMin + 1;
        OleCheck(IRichEditOle(FRichEditOle).InsertObject(ReObject));
        SendMessage(Handle, EM_EXSETSEL, 0, Longint(@Selection));
        IRichEditOle(FRichEditOle).SetDvaspect(
          Longint(REO_IOB_SELECTION), ReObject.dvAspect);
      finally
        ReleaseObject(OleObject);
      end;
    finally
      ReleaseObject(OleClientSite);
      ReleaseObject(Storage);
    end;
  end;
end;

{ Conversion formats }
//procedure AppendConversionFormat(const ADesc, Ext, AAddData: string; Plain: Boolean;
//  AClass: TJvConversionClass);
//var
//  NewRec: PRichConversionFormat;
//begin
//  New(NewRec);
//  with NewRec^ do
//  begin
//    //    ConversionClass := AClass;
//    //    Extension := AnsiLowerCaseFileName(Ext);
//    //    PlainText := Plain;
//    //    Description := ADesc;
//    //    AddData := AAddData;
//    Next := ConversionFormatList;
//  end;
//  ConversionFormatList := NewRec;
//end;

procedure TJvCustomRichEdit.InsertFormatText(Index: Integer; const S: string; const AFont: TFont = nil);
var
  ASelStart, ASelLength: Integer;
begin
  ASelStart := SelStart;
  ASelLength := SelLength;
  try
    if Index > -1 then
      SelStart := Index;
    SelLength := 0;
    if AFont <> nil then
      SelAttributes.Assign(AFont);
    SelText := S;
  finally
    SelStart := ASelStart;
    SelLength := ASelLength;
  end;
end;

function TJvCustomRichEdit.InsertObjectDialog: Boolean;
var
  Data: TOleUIInsertObject;
  NameBuffer: array [0..255] of Char;
  OleClientSite: IOleClientSite;
  Storage: IStorage;
  OleObject: IOleObject;
  ReObject: TReObject;
  IsNewObject: Boolean;
  Selection: TCharRange;
begin
  FillChar(Data, SizeOf(Data), 0);
  FillChar(NameBuffer, SizeOf(NameBuffer), 0);
  FillChar(ReObject, SizeOf(TReObject), 0);
  if Assigned(FRichEditOle) then
  begin
    IRichEditOle(FRichEditOle).GetClientSite(OleClientSite);
    Storage := nil;
    try
      CreateStorage(Storage);
      with Data do
      begin
        cbStruct := SizeOf(Data);
        dwFlags := IOF_SELECTCREATENEW or IOF_VERIFYSERVERSEXIST or
          IOF_CREATENEWOBJECT or IOF_CREATEFILEOBJECT or IOF_CREATELINKOBJECT;
        hWndOwner := Handle;
        lpszFile := NameBuffer;
        cchFile := SizeOf(NameBuffer);
        iid := IOleObject;
        oleRender := OLERENDER_DRAW;
        lpIOleClientSite := OleClientSite;
        lpIStorage := Storage;
        ppvObj := @OleObject;
      end;
      try
        Result := OleUIInsertObject(Data) = OLEUI_OK;
        if Result then
        try
          IsNewObject := Data.dwFlags and IOF_SELECTCREATENEW = IOF_SELECTCREATENEW;
          with ReObject do
          begin
            cbStruct := SizeOf(TReObject);
            cp := REO_CP_SELECTION;
            clsid := Data.clsid;
            poleobj := OleObject;
            pstg := Storage;
            polesite := OleClientSite;
            dvAspect := DVASPECT_CONTENT;
            dwFlags := REO_RESIZABLE;
            if IsNewObject then
              dwFlags := dwFlags or REO_BLANK;
            OleCheck(OleSetDrawAspect(OleObject,
              Data.dwFlags and IOF_CHECKDISPLAYASICON <> 0,
              Data.hMetaPict, dvAspect));
          end;
          SendMessage(Handle, EM_EXGETSEL, 0, Longint(@Selection));
          Selection.cpMax := Selection.cpMin + 1;
          OleCheck(IRichEditOle(FRichEditOle).InsertObject(ReObject));
          SendMessage(Handle, EM_EXSETSEL, 0, Longint(@Selection));
          SendMessage(Handle, EM_SCROLLCARET, 0, 0);
          IRichEditOle(FRichEditOle).SetDvaspect(
            Longint(REO_IOB_SELECTION), ReObject.dvAspect);
          if IsNewObject then
            OleObject.DoVerb(OLEIVERB_SHOW, nil,
              OleClientSite, 0, Handle, ClientRect);
        finally
          ReleaseObject(OleObject);
        end;
      finally
        DestroyMetaPict(Data.hMetaPict);
      end;
    finally
      ReleaseObject(OleClientSite);
      ReleaseObject(Storage);
    end;
  end
  else
    Result := False;
end;

function TJvCustomRichEdit.LineFromChar(CharIndex: Integer): Integer;
begin
  Result := SendMessage(Handle, EM_EXLINEFROMCHAR, 0, CharIndex);
end;

procedure TJvCustomRichEdit.MouseEnter(var Msg: TMessage);
begin
  FSavedHintColor := Application.HintColor;
  // for D7...
  if csDesigning in ComponentState then
    Exit;
  Application.HintColor := FHintColor;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;

procedure TJvCustomRichEdit.MouseLeave(var Msg: TMessage);
begin
  Application.HintColor := FSavedHintColor;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

function TJvCustomRichEdit.ObjectPropertiesDialog: Boolean;
var
  ObjectProps: TOleUIObjectProps;
  PropSheet: TPropSheetHeader;
  GeneralProps: TOleUIGnrlProps;
  ViewProps: TOleUIViewProps;
  LinkProps: TOleUILinkProps;
  DialogCaption: string;
  ReObject: TReObject;
begin
  Result := False;
  if not Assigned(FRichEditOle) or (SelectionType <> [stObject]) then
    Exit;
  FillChar(ObjectProps, SizeOf(ObjectProps), 0);
  FillChar(PropSheet, SizeOf(PropSheet), 0);
  FillChar(GeneralProps, SizeOf(GeneralProps), 0);
  FillChar(ViewProps, SizeOf(ViewProps), 0);
  FillChar(LinkProps, SizeOf(LinkProps), 0);
  FillChar(ReObject, SizeOf(ReObject), 0);
  ReObject.cbStruct := SizeOf(ReObject);
  if Succeeded(IRichEditOle(FRichEditOle).GetObject(Longint(REO_IOB_SELECTION),
    ReObject, REO_GETOBJ_POLEOBJ or REO_GETOBJ_POLESITE)) then
  try
    if ReObject.dwFlags and REO_INPLACEACTIVE = 0 then
    begin
      ObjectProps.cbStruct := SizeOf(ObjectProps);
      ObjectProps.dwFlags := OPF_DISABLECONVERT;
      ObjectProps.lpPS := @PropSheet;
      ObjectProps.lpObjInfo := TOleUIObjInfo.Create(Self, ReObject);
      if (ReObject.dwFlags and REO_LINK) <> 0 then
      begin
        ObjectProps.dwFlags := ObjectProps.dwFlags or OPF_OBJECTISLINK;
        ObjectProps.lpLinkInfo := TOleUILinkInfo.Create(Self, ReObject);
      end;
      ObjectProps.lpGP := @GeneralProps;
      ObjectProps.lpVP := @ViewProps;
      ObjectProps.lpLP := @LinkProps;
      PropSheet.dwSize := SizeOf(PropSheet);
      PropSheet.hWndParent := Handle;
      PropSheet.HInstance := MainInstance;
      DialogCaption := Format(SPropDlgCaption, [GetFullNameStr(ReObject.poleobj)]);
      PropSheet.pszCaption := PChar(DialogCaption);
      GeneralProps.cbStruct := SizeOf(GeneralProps);
      ViewProps.cbStruct := SizeOf(ViewProps);
      ViewProps.dwFlags := VPF_DISABLESCALE;
      LinkProps.cbStruct := SizeOf(LinkProps);
      LinkProps.dwFlags := ELF_DISABLECANCELLINK;
      Result := OleUIObjectProperties(ObjectProps) = OLEUI_OK;
    end;
  finally
  end;
end;

procedure TJvCustomRichEdit.ObjectPropsClick(Sender: TObject);
begin
  ObjectPropertiesDialog;
end;

function TJvCustomRichEdit.PasteSpecialDialog: Boolean;

  procedure SetPasteEntry(var Entry: TOleUIPasteEntry; Format: TClipFormat;
    tymed: DWORD; const FormatName, ResultText: string; Flags: DWORD);
  begin
    with Entry do
    begin
      fmtetc.cfFormat := Format;
      fmtetc.dwAspect := DVASPECT_CONTENT;
      fmtetc.lIndex := -1;
      fmtetc.tymed := tymed;
      if FormatName <> '' then
        lpstrFormatName := PChar(FormatName)
      else
        lpstrFormatName := '%s';
      if ResultText <> '' then
        lpstrResultText := PChar(ResultText)
      else
        lpstrResultText := '%s';
      dwFlags := Flags;
    end;
  end;

const
  PasteFormatCount = 6;
var
  Data: TOleUIPasteSpecial;
  PasteFormats: array [0..PasteFormatCount - 1] of TOleUIPasteEntry;
  Format: Integer;
  OleClientSite: IOleClientSite;
  Storage: IStorage;
  OleObject: IOleObject;
  ReObject: TReObject;
  Selection: TCharRange;
begin
  Result := False;
  if not CanPaste or not Assigned(FRichEditOle) then
    Exit;
  FillChar(Data, SizeOf(Data), 0);
  FillChar(PasteFormats, SizeOf(PasteFormats), 0);
  with Data do
  begin
    cbStruct := SizeOf(Data);
    hWndOwner := Handle;
    arrPasteEntries := @PasteFormats[0];
    cPasteEntries := PasteFormatCount;
    arrLinkTypes := @CFLinkSource;
    cLinkTypes := 1;
    dwFlags := PSF_SELECTPASTE;
  end;
  SetPasteEntry(PasteFormats[0], CFEmbeddedObject, TYMED_ISTORAGE, '', '',
    OLEUIPASTE_PASTE or OLEUIPASTE_ENABLEICON);
  SetPasteEntry(PasteFormats[1], CFLinkSource, TYMED_ISTREAM, '', '',
    OLEUIPASTE_LINKTYPE1 or OLEUIPASTE_ENABLEICON);
  SetPasteEntry(PasteFormats[2], CFRtf, TYMED_ISTORAGE,
    CF_RTF, CF_RTF, OLEUIPASTE_PASTE);
  SetPasteEntry(PasteFormats[3], CFRtfNoObjs, TYMED_ISTORAGE,
    CF_RTFNOOBJS, CF_RTFNOOBJS, OLEUIPASTE_PASTE);
  SetPasteEntry(PasteFormats[4], CF_TEXT, TYMED_HGLOBAL,
    'Unformatted text', 'text without any formatting', OLEUIPASTE_PASTE);
  SetPasteEntry(PasteFormats[5], CF_BITMAP, TYMED_GDI,
    'Windows Bitmap', 'bitmap image', OLEUIPASTE_PASTE);
  try
    if OleUIPasteSpecial(Data) = OLEUI_OK then
    begin
      Result := True;
      if Data.nSelectedIndex in [0, 1] then
      begin
        { CFEmbeddedObject, CFLinkSource }
        FillChar(ReObject, SizeOf(TReObject), 0);
        IRichEditOle(FRichEditOle).GetClientSite(OleClientSite);
        Storage := nil;
        try
          CreateStorage(Storage);
          case Data.nSelectedIndex of
            0:
              OleCheck(OleCreateFromData(Data.lpSrcDataObj, IOleObject,
                OLERENDER_DRAW, nil, OleClientSite, Storage, OleObject));
            1:
              OleCheck(OleCreateLinkFromData(Data.lpSrcDataObj, IOleObject,
                OLERENDER_DRAW, nil, OleClientSite, Storage, OleObject));
          end;
          try
            with ReObject do
            begin
              cbStruct := SizeOf(TReObject);
              cp := REO_CP_SELECTION;
              poleobj := OleObject;
              OleObject.GetUserClassID(clsid);
              pstg := Storage;
              polesite := OleClientSite;
              dvAspect := DVASPECT_CONTENT;
              dwFlags := REO_RESIZABLE;
              OleCheck(OleSetDrawAspect(OleObject,
                Data.dwFlags and PSF_CHECKDISPLAYASICON <> 0,
                Data.hMetaPict, dvAspect));
            end;
            SendMessage(Handle, EM_EXGETSEL, 0, Longint(@Selection));
            Selection.cpMax := Selection.cpMin + 1;
            OleCheck(IRichEditOle(FRichEditOle).InsertObject(ReObject));
            SendMessage(Handle, EM_EXSETSEL, 0, Longint(@Selection));
            IRichEditOle(FRichEditOle).SetDvaspect(
              Longint(REO_IOB_SELECTION), ReObject.dvAspect);
          finally
            ReleaseObject(OleObject);
          end;
        finally
          ReleaseObject(OleClientSite);
          ReleaseObject(Storage);
        end;
      end
      else
      begin
        Format := PasteFormats[Data.nSelectedIndex].fmtetc.cfFormat;
        OleCheck(IRichEditOle(FRichEditOle).ImportDataObject(
          Data.lpSrcDataObj, Format, Data.hMetaPict));
      end;
      SendMessage(Handle, EM_SCROLLCARET, 0, 0);
    end;
  finally
    DestroyMetaPict(Data.hMetaPict);
    ReleaseObject(Data.lpSrcDataObj);
  end;
end;

procedure TJvCustomRichEdit.PopupVerbClick(Sender: TObject);
var
  ReObject: TReObject;
begin
  if Assigned(FRichEditOle) then
  begin
    FillChar(ReObject, SizeOf(ReObject), 0);
    ReObject.cbStruct := SizeOf(ReObject);
    if Succeeded(IRichEditOle(FRichEditOle).GetObject(
      Longint(REO_IOB_SELECTION), ReObject, REO_GETOBJ_POLEOBJ or
      REO_GETOBJ_POLESITE)) then
    try
      if ReObject.dwFlags and REO_INPLACEACTIVE = 0 then
        OleCheck(ReObject.poleobj.DoVerb((Sender as TMenuItem).Tag, nil,
          ReObject.polesite, 0, Handle, ClientRect));
    finally
      ReleaseObject(ReObject.polesite);
      ReleaseObject(ReObject.poleobj);
    end;
  end;
end;

procedure TJvCustomRichEdit.Print(const Caption: string);
var
  Range: TFormatRange;
  LastChar, MaxLen, LogX, LogY, OldMap: Integer;
  SaveRect: TRect;
  TextLenEx: TGetTextLengthEx;
begin
  FillChar(Range, SizeOf(TFormatRange), 0);
  with Printer, Range do
  begin
    Title := Caption;
    BeginDoc;
    HDC := Handle;
    hdcTarget := HDC;
    LogX := GetDeviceCaps(Handle, LOGPIXELSX);
    LogY := GetDeviceCaps(Handle, LOGPIXELSY);
    if IsRectEmpty(PageRect) then
    begin
      RC.Right := PageWidth * CTwipsPerInch div LogX;
      RC.Bottom := PageHeight * CTwipsPerInch div LogY;
    end
    else
    begin
      RC.Left := PageRect.Left * CTwipsPerInch div LogX;
      RC.Top := PageRect.Top * CTwipsPerInch div LogY;
      RC.Right := PageRect.Right * CTwipsPerInch div LogX;
      RC.Bottom := PageRect.Bottom * CTwipsPerInch div LogY;
    end;
    rcPage := RC;
    SaveRect := RC;
    LastChar := 0;
    if RichEditVersion >= 2 then
    begin
      with TextLenEx do
      begin
        Flags := GTL_DEFAULT;
        codepage := CP_ACP;
      end;
      MaxLen := Perform(EM_GETTEXTLENGTHEX, WParam(@TextLenEx), 0);
    end
    else
      MaxLen := GetTextLen;
    chrg.cpMax := -1;
    { ensure printer DC is in text map mode }
    OldMap := SetMapMode(HDC, MM_TEXT);
    SendMessage(Self.Handle, EM_FORMATRANGE, 0, 0); { flush buffer }
    try
      repeat
        RC := SaveRect;
        chrg.cpMin := LastChar;
        LastChar := SendMessage(Self.Handle, EM_FORMATRANGE, 1, Longint(@Range));
        if (LastChar < MaxLen) and (LastChar <> -1) then
          NewPage;
      until (LastChar >= MaxLen) or (LastChar = -1);
      EndDoc;
    finally
      SendMessage(Self.Handle, EM_FORMATRANGE, 0, 0); { flush buffer }
      SetMapMode(HDC, OldMap); { restore previous map mode }
    end;
  end;
end;

function TJvCustomRichEdit.ProtectChange(const Msg: TMessage; StartPos,
  EndPos: Integer): Boolean;
begin
  Result := False;
  if Assigned(OnProtectChangeEx) then
    OnProtectChangeEx(Self, Msg, StartPos, EndPos, Result)
  else
  if Assigned(OnProtectChange) then
    OnProtectChange(Self, StartPos, EndPos, Result);
end;

procedure TJvCustomRichEdit.Redo;
begin
  SendMessage(Handle, EM_REDO, 0, 0);
end;

class procedure TJvCustomRichEdit.RegisterConversionFormat(
  AConverter: TJvConverter);
begin
  if Assigned(AConverter) then
    GConversionFormatList.Add(AConverter);
end;

class procedure TJvCustomRichEdit.RegisterMSTextConverters;
{ http://support.microsoft.com/support/kb/articles/q212/2/65.asp
  http://www.microsoft.com/office/ork/2003/tools/BoxA07.htm
}
const
  SKey = '\Software\Microsoft\Shared Tools\Text Converters\';
  SImportExportKey: array [TJvConversionKind] of string = ('Import\', 'Export\');
var
  KeyNames: TStringList;
  Registry: TRegistry;

  procedure RegisterConverters(const AKind: TJvConversionKind);
  var
    I: Integer;
  begin
    with Registry do
    begin
      if not OpenKey(SKey + SImportExportKey[AKind], False) then
        Exit;

      GetKeyNames(KeyNames);
      for I := 0 to KeyNames.Count - 1 do
        if OpenKey(SKey + SImportExportKey[AKind] + KeyNames[i], False) then
        begin
          RegisterConversionFormat(TJvMSTextConversion.Create(
            ReadString('Path'),
            ReadString('Extensions'),
            ReadString('Name'),
            AKind
            ));
        end;
    end;
  end;

begin
  if GMSTextConvertersRegistered then
    Exit;
  GMSTextConvertersRegistered := True;

  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;

    KeyNames := TStringList.Create;
    try
      RegisterConverters(ckImport);
      RegisterConverters(ckExport);
    finally
      KeyNames.Free;
    end;
  finally
    Registry.Free;
  end;
end;

function TJvCustomRichEdit.ReplaceDialog(const SearchStr,
  ReplaceStr: string): TReplaceDialog;
begin
  if FReplaceDialog = nil then
  begin
    FReplaceDialog := TReplaceDialog.Create(Self);
    if FFindDialog <> nil then
      FReplaceDialog.FindText := FFindDialog.FindText;
  end;
  Result := FReplaceDialog;
  SetupFindDialog(FReplaceDialog, SearchStr, ReplaceStr);
  FReplaceDialog.Execute;
end;

procedure TJvCustomRichEdit.ReplaceDialogReplace(Sender: TObject);
var
  Cnt: Integer;
  SaveSelChange: TNotifyEvent;
begin
  with TReplaceDialog(Sender) do
  begin
    if frReplaceAll in Options then
    begin
      Cnt := 0;
      SaveSelChange := FOnSelChange;
      TJvRichEditStrings(Lines).EnableChange(False);
      try
        FOnSelChange := nil;
        while FindEditText(TFindDialog(Sender), False, False) do
        begin
          SelText := ReplaceText;
          Inc(Cnt);
        end;
        if Cnt = 0 then
          TextNotFound(TFindDialog(Sender))
        else
          AdjustFindDialogPosition(TFindDialog(Sender));
      finally
        TJvRichEditStrings(Lines).EnableChange(True);
        FOnSelChange := SaveSelChange;
        if Cnt > 0 then
        begin
          Change;
          SelectionChange;
        end;
      end;
    end
    else
    if frReplace in Options then
    begin
      if FindEditText(TFindDialog(Sender), True, True) then
        SelText := ReplaceText;
    end;
  end;
end;

procedure TJvCustomRichEdit.RequestSize(const Rect: TRect);
begin
  if Assigned(OnResizeRequest) then
    OnResizeRequest(Self, Rect);
  FImageRect := Rect;
end;

function TJvCustomRichEdit.SaveClipboard(NumObj, NumChars: Integer): Boolean;
begin
  Result := True;
  if Assigned(OnSaveClipboard) then
    OnSaveClipboard(Self, NumObj, NumChars, Result);
end;

procedure TJvCustomRichEdit.SaveToImage(Picture: TPicture);
var
  ABmp: TBitmap;
  Range: TFormatRange;
  R: TRect;
begin
  if (Picture = nil) or (ClientWidth = 0) or (ClientHeight = 0) or not HandleAllocated then
    Exit;
  ABmp := TBitmap.Create;
  try
    if IsRectEmpty(FImageRect) then
    begin
      FImageRect.Right := ClientWidth;
      FImageRect.Bottom := ClientHeight;
    end;
    ABmp.Width := FImageRect.Right;
    ABmp.Height := FImageRect.Bottom;
    R.Top := 0;
    R.Left := 0;
    R.Right := FImageRect.Right * Screen.PixelsPerInch;
    R.Bottom := FImageRect.Bottom * Screen.PixelsPerInch;
    Range.hdc := ABmp.Canvas.Handle;
    Range.hdcTarget := ABmp.Canvas.Handle;
    Range.rc := R;
    Range.rcPage := R;
    Range.chrg.cpMin := 0;
    Range.chrg.cpMax := -1;
    SendMessage(Handle, EM_FORMATRANGE, 1, Integer(@Range));
    Picture.Assign(ABmp);
  finally
    ABmp.Free;
  end;

end;

procedure TJvCustomRichEdit.SelectionChange;
begin
  if Assigned(OnSelectionChange) then
    OnSelectionChange(Self);
end;

procedure TJvCustomRichEdit.SetAllowObjects(Value: Boolean);
begin
  if FAllowObjects <> Value then
  begin
    FAllowObjects := Value;
    RecreateWnd;
  end;
end;

procedure TJvCustomRichEdit.SetAutoURLDetect(Value: Boolean);
begin
  if Value <> FAutoURLDetect then
  begin
    FAutoURLDetect := Value;
    if HandleAllocated and (RichEditVersion >= 2) then
      SendMessage(Handle, EM_AUTOURLDETECT, Longint(FAutoURLDetect), 0);
  end;
end;

procedure TJvCustomRichEdit.SetDefAttributes(Value: TJvTextAttributes);
begin
  FDefAttributes.Assign(Value);
end;

procedure TJvCustomRichEdit.SetHideScrollBars(Value: Boolean);
begin
  if HideScrollBars <> Value then
  begin
    FHideScrollBars := Value;
    RecreateWnd;
  end;
end;

procedure TJvCustomRichEdit.SetHideSelection(Value: Boolean);
begin
  if HideSelection <> Value then
  begin
    FHideSelection := Value;
    SendMessage(Handle, EM_HIDESELECTION, Ord(HideSelection), LParam(True));
  end;
end;

procedure TJvCustomRichEdit.SetLangOptions(Value: TRichLangOptions);
var
  Flags: DWORD;
  I: TRichLangOption;
begin
  FLangOptions := Value;
  if HandleAllocated and (RichEditVersion >= 2) then
  begin
    Flags := 0;
    for I := Low(TRichLangOption) to High(TRichLangOption) do
      if I in Value then
        Flags := Flags or RichLangOptions[I];
    SendMessage(Handle, EM_SETLANGOPTIONS, 0, LParam(Flags));
  end;
end;

procedure TJvCustomRichEdit.SetPlainText(Value: Boolean);
var
  MemStream: TStream;
  StreamFmt: TRichStreamFormat;
  Mode: TRichStreamModes;
begin
  if PlainText <> Value then
  begin
    if HandleAllocated and (RichEditVersion >= 2) then
    begin
      MemStream := TMemoryStream.Create;
      try
        StreamFmt := TJvRichEditStrings(Lines).Format;
        Mode := TJvRichEditStrings(Lines).Mode;
        try
          if (csDesigning in ComponentState) or Value then
            TJvRichEditStrings(Lines).Format := sfPlainText
          else
            TJvRichEditStrings(Lines).Format := sfRichText;
          TJvRichEditStrings(Lines).Mode := [];
          Lines.SaveToStream(MemStream);
          MemStream.Position := 0;
          TJvRichEditStrings(Lines).EnableChange(False);
          try
            SendMessage(Handle, WM_SETTEXT, 0, 0);
            UpdateTextModes(Value);
            FPlainText := Value;
          finally
            TJvRichEditStrings(Lines).EnableChange(True);
          end;
          Lines.LoadFromStream(MemStream);
        finally
          TJvRichEditStrings(Lines).Format := StreamFmt;
          TJvRichEditStrings(Lines).Mode := Mode;
        end;
      finally
        MemStream.Free;
      end;
    end;
    FPlainText := Value;
  end;
end;

procedure TJvCustomRichEdit.SetRichEditStrings(Value: TStrings);
begin
  FRichEditStrings.Assign(Value);
end;

procedure TJvCustomRichEdit.SetSelAttributes(Value: TJvTextAttributes);
begin
  FSelAttributes.Assign(Value);
end;

procedure TJvCustomRichEdit.SetSelection(StartPos, EndPos: Longint;
  ScrollCaret: Boolean);
var
  CharRange: TCharRange;
begin
  with CharRange do
  begin
    cpMin := StartPos;
    cpMax := EndPos;
  end;
  SendMessage(Handle, EM_EXSETSEL, 0, Longint(@CharRange));
  if ScrollCaret then
    SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TJvCustomRichEdit.SetSelectionBar(Value: Boolean);
begin
  if FSelectionBar <> Value then
  begin
    FSelectionBar := Value;
    RecreateWnd;
  end;
end;

procedure TJvCustomRichEdit.SetSelLength(Value: Integer);
begin
  with GetSelection do
    SetSelection(cpMin, cpMin + Value, True);
end;

procedure TJvCustomRichEdit.SetSelStart(Value: Integer);
begin
  SetSelection(Value, Value, False);
end;

procedure TJvCustomRichEdit.SetSelText(const Value: string);
begin
  FLinesUpdating := True;
  inherited SelText := Value;
  FLinesUpdating := False;
end;

procedure TJvCustomRichEdit.SetStreamFormat(Value: TRichStreamFormat);
begin
  TJvRichEditStrings(Lines).Format := Value;
end;

procedure TJvCustomRichEdit.SetStreamMode(Value: TRichStreamModes);
begin
  TJvRichEditStrings(Lines).Mode := Value;
end;

procedure TJvCustomRichEdit.SetTitle(const Value: string);
begin
  if FTitle <> Value then
  begin
    FTitle := Value;
    UpdateHostNames;
  end;
end;

procedure TJvCustomRichEdit.SetUIActive(Active: Boolean);
var
  Form: TCustomForm;
begin
  try
    Form := GetParentForm(Self);
    if Form <> nil then
      if Active then
      begin
        if (Form.ActiveOleControl <> nil) and
          (Form.ActiveOleControl <> Self) then
          Form.ActiveOleControl.Perform(CM_UIDEACTIVATE, 0, 0);
        Form.ActiveOleControl := Self;
        if AllowInPlace and CanFocus then
          SetFocus;
      end
      else
      begin
        if Form.ActiveOleControl = Self then
          Form.ActiveOleControl := nil;
        if (Form.ActiveControl = Self) and AllowInPlace then
        begin
          Windows.SetFocus(Handle);
          SelectionChange;
        end;
      end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TJvCustomRichEdit.SetUndoLimit(Value: Integer);
begin
  if Value <> FUndoLimit then
  begin
    FUndoLimit := Value;
    if (RichEditVersion >= 2) and HandleAllocated then
      FUndoLimit := SendMessage(Handle, EM_SETUNDOLIMIT, Value, 0);
  end;
end;

{ Find & Replace Dialogs }

procedure TJvCustomRichEdit.SetupFindDialog(Dialog: TFindDialog;
  const SearchStr, ReplaceStr: string);
begin
  with Dialog do
  begin
    if SearchStr <> '' then
      FindText := SearchStr;
    if RichEditVersion = 1 then
      Options := Options + [frHideUpDown, frDown];
    OnFind := FindDialogFind;
    OnClose := FindDialogClose;
  end;
  if Dialog is TReplaceDialog then
    with TReplaceDialog(Dialog) do
    begin
      if ReplaceStr <> '' then
        ReplaceText := ReplaceStr;
      OnReplace := ReplaceDialogReplace;
    end;
end;

procedure TJvCustomRichEdit.SetWordAttributes(Value: TJvTextAttributes);
begin
  FWordAttributes.Assign(Value);
end;

procedure TJvCustomRichEdit.SetWordSelection(Value: Boolean);
var
  Options: LParam;
begin
  FWordSelection := Value;
  if HandleAllocated then
  begin
    Options := SendMessage(Handle, EM_GETOPTIONS, 0, 0);
    if Value then
      Options := Options or ECO_AUTOWORDSELECTION
    else
      Options := Options and not ECO_AUTOWORDSELECTION;
    SendMessage(Handle, EM_SETOPTIONS, ECOOP_SET, Options);
  end;
end;

procedure TJvCustomRichEdit.StopGroupTyping;
begin
  if (RichEditVersion >= 2) and HandleAllocated then
    SendMessage(Handle, EM_STOPGROUPTYPING, 0, 0);
end;

procedure TJvCustomRichEdit.TextNotFound(Dialog: TFindDialog);
begin
  with Dialog do
    if Assigned(FOnTextNotFound) then
      FOnTextNotFound(Self, FindText);
end;

procedure TJvCustomRichEdit.UpdateHostNames;
var
  AppName: string;
begin
  if HandleAllocated and Assigned(FRichEditOle) then
  begin
    AppName := Application.Title;
    if Trim(AppName) = '' then
      AppName := ExtractFileName(Application.ExeName);
    if Trim(Title) = '' then
      IRichEditOle(FRichEditOle).SetHostNames(PChar(AppName), PChar(AppName))
    else
      IRichEditOle(FRichEditOle).SetHostNames(PChar(AppName), PChar(Title));
  end;
end;

procedure TJvCustomRichEdit.UpdateTextModes(Plain: Boolean);
const
  TextModes: array [Boolean] of DWORD = (TM_RICHTEXT, TM_PLAINTEXT);
  UndoModes: array [Boolean] of DWORD = (TM_SINGLELEVELUNDO, TM_MULTILEVELUNDO);
begin
  if (RichEditVersion >= 2) and HandleAllocated then
  begin
    SendMessage(Handle, EM_SETTEXTMODE, TextModes[Plain] or
      UndoModes[FUndoLimit > 1], 0);
  end;
end;

procedure TJvCustomRichEdit.URLClick(const URLText: string; Button: TMouseButton);
begin
  if Assigned(OnURLClick) then
    OnURLClick(Self, URLText, Button);
end;

procedure TJvCustomRichEdit.WMDestroy(var Msg: TWMDestroy);
begin
  CloseObjects;
  ReleaseObject(FRichEditOle);
  inherited;
end;

procedure TJvCustomRichEdit.WMHScroll(var Msg: TWMHScroll);
begin
  inherited;
  if Assigned(FOnHorizontalScroll) then
    FOnHorizontalScroll(Self);
end;

procedure TJvCustomRichEdit.WMMouseMove(var Msg: TMessage);
begin
  inherited;
end;

procedure TJvCustomRichEdit.WMPaint(var Msg: TWMPaint);
var
  R, R1: TRect;
begin
  if RichEditVersion >= 2 then
    inherited
  else
  begin
    if GetUpdateRect(Handle, R, True) then
    begin
      with ClientRect do
        R1 := Rect(Right - 3, Top, Right, Bottom);
      if IntersectRect(R, R, R1) then
        InvalidateRect(Handle, @R1, True);
    end;
    if Painting then
      Invalidate
    else
    begin
      Painting := True;
      try
        inherited;
      finally
        Painting := False;
      end;
    end;
  end;
end;

procedure TJvCustomRichEdit.WMRButtonUp(var Msg: TMessage);
begin
  { RichEd20 does not pass the WM_RBUTTONUP message to defwndproc, }
  { so we get no WM_CONTEXTMENU message. Simulate message here.    }
  if (RichEditVersion <> 1) or (Win32MajorVersion < 5) then
    Perform(WM_CONTEXTMENU, Handle, LParam(PointToSmallPoint(
      ClientToScreen(SmallPointToPoint(TWMMouse(Msg).Pos)))));
  inherited;
end;

procedure TJvCustomRichEdit.WMSetCursor(var Msg: TWMSetCursor);
begin
  inherited;
end;

procedure TJvCustomRichEdit.WMSetFont(var Msg: TWMSetFont);
begin
  FDefAttributes.Assign(Font);
end;

procedure TJvCustomRichEdit.WMVScroll(var Msg: TWMVScroll);
begin
  inherited;
  if Assigned(FOnVerticalScroll) then
    FOnVerticalScroll(Self);
end;

function TJvCustomRichEdit.WordAtCursor: string;
var
  Range: TCharRange;
begin
  Result := '';
  if HandleAllocated then
  begin
    Range.cpMax := SelStart;
    if Range.cpMax = 0 then
      Range.cpMin := 0
    else
    if SendMessage(Handle, EM_FINDWORDBREAK, WB_ISDELIMITER, Range.cpMax) <> 0 then
      Range.cpMin := SendMessage(Handle, EM_FINDWORDBREAK, WB_MOVEWORDLEFT, Range.cpMax)
    else
      Range.cpMin := SendMessage(Handle, EM_FINDWORDBREAK, WB_LEFT, Range.cpMax);
    while SendMessage(Handle, EM_FINDWORDBREAK, WB_ISDELIMITER, Range.cpMin) <> 0 do
      Inc(Range.cpMin);
    Range.cpMax := SendMessage(Handle, EM_FINDWORDBREAK, WB_RIGHTBREAK, Range.cpMax);
    Result := Trim(GetTextRange(Range.cpMin, Range.cpMax));
  end;
end;

//=== TJvMSTextConversion ====================================================

function TJvMSTextConversion.CanHandle(
  const AKind: TJvConversionKind): Boolean;
begin
  Result := AKind = FConverterKind;
end;

function TJvMSTextConversion.CanHandle(const AExtension: string;
  const AKind: TJvConversionKind): Boolean;
var
  I: Integer;
begin
  Result := CanHandle(AKind);
  if not Result then
    Exit;

  for I := 0 to FExtensions.Count - 1 do
    if (FExtensions[i] = '*') or (FExtensions[i] = AExtension) then
    begin
      Result := True;
      Exit;
    end;

  Result := False;
end;

procedure TJvMSTextConversion.Check(Result: FCE);
begin
  if Result <> fceNoErr then
    DoError(Result);
end;

function TJvMSTextConversion.ConvertRead(Buffer: PChar;
  BufSize: Integer): Integer;
var
  AvailableBufferSize: Integer;
  DestBufferPtr: PChar;
  ByteCount: Integer;
begin
  { Fill Buffer with BufSize bytes data from FBuffer }

  if not Assigned(FForeignToRtf32) then
    DoError(fceReadErr);

  AvailableBufferSize := BufSize;
  DestBufferPtr := Buffer;

  repeat
    if FBytesAvailable = 0 then
    begin
      Unlock;
      FRichEditReady.SetEvent;

      WaitUntilThreadReady;
      FThreadReady.ResetEvent;
      { Thread can have set FConversionError & FThreadDone so check those: }

      if FConversionError <> fceNoErr then
        DoError(FConversionError);

      if FThreadDone then
      begin
        Result := BufSize - AvailableBufferSize;
        Exit;
      end;
    end;

    Lock;

    ByteCount := Min(AvailableBufferSize, FBytesAvailable);
    Move(FBufferPtr^, DestBufferPtr^, ByteCount);
    Inc(DestBufferPtr, ByteCount);
    Inc(FBufferPtr, ByteCount);
    Dec(FBytesAvailable, ByteCount);
    Dec(AvailableBufferSize, ByteCount);

    DoProgress(FTempProgress);
  until AvailableBufferSize = 0;

  Result := BufSize;
end;

{ TODO : Remove }
//{ Works }
//function TJvMSTextConversion.ConvertRead(Buffer: PChar;
//  BufSize: Integer): Integer;
//var
//  AvailableBufferSize: Integer;
//  DestBufferPtr: PChar;
//  ByteCount: Integer;
//begin
//  { Fill Buffer with BufSize bytes data from FBuffer
//    NOTE: Be very careful to optimize this function
//
//  if not Assigned(FForeignToRtf32) then
//    DoError(fceReadErr);
//
//  AvailableBufferSize := BufSize;
//  DestBufferPtr := Buffer;
//
//  repeat
//    if FBytesAvailable = 0 then
//    begin
//      WaitUntilThreadReady;
//      FThreadReady.ResetEvent;
//      { Thread can have set FConversionError & FThreadDone so check those: }
//
//      if FConversionError <> fceNoErr then
//        DoError(FConversionError);
//
//      if FThreadDone then
//      begin
//        Result := BufSize - AvailableBufferSize;
//        Exit;
//      end;
//    end;
//
//    Lock;
//
//    ByteCount := Min(AvailableBufferSize, FBytesAvailable);
//    Move(FBufferPtr^, DestBufferPtr^, ByteCount);
//    Inc(DestBufferPtr, ByteCount);
//    Inc(FBufferPtr, ByteCount);
//    Dec(FBytesAvailable, ByteCount);
//    Dec(AvailableBufferSize, ByteCount);
//
//    DoProgress(FTempProgress);
//
//    { FBytesAvailable = 0 or AvailableBufferSize = 0 (can be both) }
//    if FBytesAvailable = 0 then
//    begin
//      Unlock;
//      FRichEditReady.SetEvent;
//    end;
//  until AvailableBufferSize = 0;
//
//  Result := BufSize;
//end;

function TJvMSTextConversion.ConvertWrite(Buffer: PChar;
  BufSize: Integer): Integer;
var
  DestBufferPtr: PChar;
begin
  if not Assigned(FForeignToRtf32) then
    DoError(fceWriteErr);

  { Result = bytes actually written }
  Result := BufSize;

  while BufSize <> 0 do
  begin
    { wait until thread is ready to export more data.. }
    WaitUntilThreadReady;
    FThreadReady.ResetEvent;

    if FConversionError <> fceNoErr then
      DoError(FConversionError);

    { FBytesAvailable indicates here how many bytes of data are available for
      the converter dll to convert. }
    FBytesAvailable := Min(BufSize, CConvertBufferSize);
    Dec(BufSize, FBytesAvailable);

    DestBufferPtr := GlobalLock(FBuffer);
    if not Assigned(DestBufferPtr) then
      DoError(fceNoMemory);
    Move(Buffer^, DestBufferPtr^, FBytesAvailable);
    GlobalUnlock(FBuffer);

    DoProgress(FTempProgress);

    { Signal that data is ready to be exported }
    FRichEditReady.SetEvent;
  end;
end;

constructor TJvMSTextConversion.Create(const AConverterFileName, AExtensions,
  ADescription: string; const AKind: TJvConversionKind);
begin
  inherited Create;
  FExtensions := TStringList.Create;
  FExtensions.Delimiter := ' ';
  FExtensions.DelimitedText := AExtensions;
  FConverterFileName := AConverterFileName;
  FDescription := ADescription;
  FConverterKind := AKind;
  FThreadDone := True;
  FCancel := False;
end;

destructor TJvMSTextConversion.Destroy;
begin
  Done;
  FExtensions.Free;
  inherited Destroy;
end;

procedure TJvMSTextConversion.DoConversion;
{ This procedure is called in the context of the thread }
var
  hDesc: HGLOBAL;
  hSubset: HGLOBAL;
  LConversionError: FCE;
begin
  { insanity check }
  if (FBuffer = 0) or (GCurrentConverter <> Self) then
  begin
    FConversionError := fceNoMemory;
    FThreadDone := True;
    FThreadReady.SetEvent;

    Exit;
  end;

  hDesc := StringToHGLOBAL('');
  hSubset := StringToHGLOBAL('');

  if FConverterKind = ckImport then
  begin
    WaitUntilRichEditReady;
    FRichEditReady.ResetEvent;

    LConversionError := FForeignToRtf32(FFileName, nil, FBuffer,
      hDesc, hSubSet, ImportCallback);

    { This ensures that the ConvertRead picks up the last bytes before FThreadDone is set }
    FThreadReady.SetEvent;
    WaitUntilRichEditReady;
  end
  else
    LConversionError := FRtfToForeign32(FFileName, nil, FBuffer,
      hDesc, ExportCallback);

  GlobalFree(hDesc);
  GlobalFree(hSubset);

  if FConversionError = fceNoErr then
    FConversionError := LConversionError;

  FThreadDone := True;
  FThreadReady.SetEvent;
end;

procedure TJvMSTextConversion.DoError(ErrorCode: FCE);
begin
  FConversionError := ErrorCode;
  raise EMSTextConversionError.Create(TranslateError(ErrorCode), ErrorCode);
end;

procedure TJvMSTextConversion.Done;
begin
  if Error then
    FCancel := True;

  while not FThreadDone do
  begin
    FRichEditReady.SetEvent;
    WaitUntilThreadReady;

    FBytesAvailable := 0;

    FThreadReady.ResetEvent;
  end;

  Unlock;
  if FBuffer <> 0 then
    GlobalFree(FBuffer);
  FBuffer := 0;

  FreeAndNil(FThreadReady);
  FreeAndNil(FRichEditReady);

  if Assigned(FUninitConverter) then
    FUninitConverter;

  FreeConverter;

  if FFileName <> 0 then
    GlobalFree(FFileName);
  FFileName := 0;

  if GCurrentConverter = Self then
    GCurrentConverter := nil;
  FInitDone := False;
end;

function TJvMSTextConversion.Error: Boolean;
begin
  Result := FConversionError <> fceNoErr;
end;

function TJvMSTextConversion.ErrorStr: string;
begin
  if not Error then
  begin
    Result := '';
    Exit;
  end;

  Result := TranslateError(FConversionError);
  if Result = '' then
  begin
    Result := FCEToString(FConversionError);
    if Result = '' then
      Result := Format(SConversionError, [FConversionError]);
  end;
end;

function TJvMSTextConversion.Filter: string;
var
  I: Integer;
  LFilter: string;
begin
  //'Text files (*.txt)|*.TXT'
  //'Description (*.htm; *.html)|*.HTM;*.HTML'

  LFilter := '';
  Result := '';
  for I := 0 to FExtensions.Count - 1 do
  begin
    Result := Result + '*.' + FExtensions[i] + '; ';
    LFilter := LFilter + '*.' + FExtensions[i] + ';';
  end;
  if Result > '' then
    Delete(Result, Length(Result) - 1, 2);
  if LFilter > '' then
    Delete(LFilter, Length(LFilter), 1);
  if Result > '' then
    Result := FDescription + ' (' + Result + ')|' + LFilter
  else
    Result := FDescription;
end;

procedure TJvMSTextConversion.FreeConverter;
begin
  if FConverter <> 0 then
    FreeLibrary(FConverter);

  FConverter := 0;

  FInitConverter32 := nil;
  FIsFormatCorrect32 := nil;
  FForeignToRtf32 := nil;
  FRtfToForeign32 := nil;
  FUninitConverter := nil;
  FCchFetchLpszError := nil;
end;

function TJvMSTextConversion.HandleExportCallback(cchBuff,
  nPercent: Integer): Longint;
begin
  if FBuffer = 0 then
  begin
    Result := fceNoMemory;
    Exit;
  end;

  FTempProgress := nPercent;

  { Signal that we're ready to convert data.. }
  FThreadReady.SetEvent;
  { ..and wait until the richedit has data available to convert }
  WaitUntilRichEditReady;
  FRichEditReady.ResetEvent;

  { Result = 0 indicates that we're done
    Result < 0 indicates error or user cancel
    Result > 0 indicates # of bytes put in FBuffer
  }
  if FCancel then
    Result := fceUserCancel
  else
    Result := FBytesAvailable;
end;

function TJvMSTextConversion.HandleImportCallback(cchBuff,
  nPercent: Integer): Longint;
begin
  // cchBuff = a count of the bytes of RTF data that the converter has placed in
  //           ghBuff.
  // nPercent can range between 0 and 100, representing the estimate made by
  // the converter of how much of the conversion process has been completed.

  if FBuffer = 0 then
  begin
    Result := fceNoMemory;
    Exit;
  end;

  FTempProgress := nPercent;
  FBytesAvailable := cchBuff;

  { Signal that data is ready.. }
  FThreadReady.SetEvent;
  { ..and wait until additional data is wanted }
  WaitUntilRichEditReady;
  FRichEditReady.ResetEvent;

  { Result = 0 indicates that we're done
    Result < 0 indicates error or user cancel
    Result > 0 indicates # of bytes put in FBuffer
  }

  if FCancel then
    Result := fceUserCancel
  else
    { FBytesAvailable should be 0 by now }
    Result := FBytesAvailable;
end;

procedure TJvMSTextConversion.Init;
begin
  if FInitDone then
    Exit;
  FInitDone := True;

  LoadConverter;
  if not Assigned(FInitConverter32) or
     not FInitConverter32(Application.Handle, PChar(AnsiUpperCaseFileName(Application.ExeName))) then

    raise EMSTextConversionError.Create(SErr_CouldNotInitConverter);
end;

function TJvMSTextConversion.IsFormatCorrect(
  const AFileName: string): Boolean;
var
  hFile: THandle;
  hClass: THandle;
begin
  Init;

  Result := Assigned(FIsFormatCorrect32);
  if not Result then
    Exit;

  hFile := FileNameToHGLOBAL(AFileName);
  hClass := StringToHGLOBAL('');
  try
    Result := FIsFormatCorrect32(hFile, hClass) = fceTrue;
  finally
    GlobalFree(hClass);
    GlobalFree(hFile);
  end;
end;

procedure TJvMSTextConversion.LoadConverter;
begin
  if FConverter <> 0 then
    Exit;

  FConverter := LoadLibrary(PChar(FConverterFileName));
  if FConverter <> 0 then
  begin
    @FInitConverter32 := GetProcAddress(FConverter, InitConverter32Name);
    @FIsFormatCorrect32 := GetProcAddress(FConverter, IsFormatCorrect32Name);
    @FForeignToRtf32 := GetProcAddress(FConverter, ForeignToRtf32Name);
    @FRtfToForeign32 := GetProcAddress(FConverter, RtfToForeign32Name);
    @FUninitConverter := GetProcAddress(FConverter, UninitConverterName);
    @FCchFetchLpszError := GetProcAddress(FConverter, CchFetchLpszErrorName);
  end;
end;

procedure TJvMSTextConversion.Lock;
begin
  if FBufferPtr = nil then
    FBufferPtr := GlobalLock(FBuffer);

  if FBufferPtr = nil then
    DoError(fceNoMemory);
end;

function TJvMSTextConversion.Open(const AFileName: string;
  const AKind: TJvConversionKind): Boolean;
var
  Sa: TSecurityAttributes;
begin
  { Note: cleanup is done in method Done; method Done is always called
          after Open is called }

  Result := (AKind <> ckImport) or FileExists(AFileName);
  if not Result then
    Exit;

  if GCurrentConverter <> nil then
    raise EMSTextConversionError.Create(SErr_ConversionBusy);
  GCurrentConverter := Self;

  Init;

  FFileName := FileNameToHGLOBAL(AFileName);
  if FFileName = 0 then
    DoError(fceNoMemory);

  FBuffer := GlobalAlloc(GHND, CConvertBufferSize);
  if FBuffer = 0 then
    DoError(fceNoMemory);

  Sa.nLength := SizeOf(TSecurityAttributes);
  Sa.lpSecurityDescriptor := nil;
  Sa.bInheritHandle := True;

  FThreadReady := TEvent.Create(@Sa, True, False, '');
  FRichEditReady := TEvent.Create(@Sa, True, False, '');

  FConversionError := fceNoErr;
  FThreadDone := False;
  FCancel := False;
  FBufferPtr := nil;

  FProgress := -1;
  DoProgress(0);

  TMSTextConversionThread.Create;

  Result := True;
end;

function TJvMSTextConversion.TextKind: TJvConversionTextKind;
begin
  Result := ctkRTF;
end;

function TJvMSTextConversion.TranslateError(ErrorCode: FCE): string;
const
  CMaxErrorStrSize = 1024; { arbitrary value }
var
  Data: THandle;
  DataPtr: PChar;
  Size: Longint;
begin
  Init;

  if not Assigned(FCchFetchLpszError) then
  begin
    Result := FCEToString(ErrorCode);
    Exit;
  end;

  Data := GlobalAlloc(GHND, CMaxErrorStrSize + 1); // with last #0, thus + 1
  try
    DataPtr := GlobalLock(Data);
    try
      Size := FCchFetchLpszError(ErrorCode, DataPtr, CMaxErrorStrSize);
      if Size > 0 then
        SetString(Result, DataPtr, Size)
      else
        Result := '';
    finally
      GlobalUnlock(Data);
    end;
  finally
    GlobalFree(Data);
  end;
end;

procedure TJvMSTextConversion.Unlock;
begin
  if FBufferPtr <> nil then
    GlobalUnlock(FBuffer);
  FBufferPtr := nil;
end;

procedure TJvMSTextConversion.WaitUntilRichEditReady;
var
  Msg: TMsg;
  H: THandle;
begin
  H := FRichEditReady.Handle;

  while MsgWaitForMultipleObjects(1, H, False, INFINITE,
    QS_SENDMESSAGE) <> WAIT_OBJECT_0 do
  begin
    PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE);
  end;
end;

procedure TJvMSTextConversion.WaitUntilThreadReady;
var
  Msg: TMsg;
  H: THandle;
begin
  H := FThreadReady.Handle;

  while MsgWaitForMultipleObjects(1, H, False, INFINITE,
    QS_SENDMESSAGE) <> WAIT_OBJECT_0 do
  begin
    PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE);
  end;
end;

//=== TJvOEMConversion =======================================================

function TJvOEMConversion.ConvertRead(Buffer: PChar;
  BufSize: Integer): Integer;
var
  Mem: TMemoryStream;
begin
  Mem := TMemoryStream.Create;
  try
    Mem.SetSize(BufSize);
    Result := inherited ConvertRead(PChar(Mem.Memory), BufSize);
    OemToCharBuff(PChar(Mem.Memory), Buffer, Result);
  finally
    Mem.Free;
  end;
end;

function TJvOEMConversion.ConvertWrite(Buffer: PChar;
  BufSize: Integer): Integer;
var
  Mem: TMemoryStream;
begin
  Mem := TMemoryStream.Create;
  try
    Mem.SetSize(BufSize);
    CharToOemBuff(Buffer, PChar(Mem.Memory), BufSize);
    Result := inherited ConvertWrite(PChar(Mem.Memory), BufSize);
  finally
    Mem.Free;
  end;
end;

function TJvOEMConversion.TextKind: TJvConversionTextKind;
begin
  Result := ctkBothPreferRTF;
end;

//=== TJvParaAttributes ======================================================

procedure TJvParaAttributes.Assign(Source: TPersistent);
var
  I: Integer;
  Paragraph: TParaFormat2;
begin
  if Source is TParaAttributes then
  begin
    Alignment := TParaAlignment(TParaAttributes(Source).Alignment);
    FirstIndent := TParaAttributes(Source).FirstIndent;
    LeftIndent := TParaAttributes(Source).LeftIndent;
    RightIndent := TParaAttributes(Source).RightIndent;
    Numbering := TJvNumbering(TParaAttributes(Source).Numbering);
    for I := 0 to MAX_TAB_STOPS - 1 do
      Tab[I] := TParaAttributes(Source).Tab[I];
  end
  else
  if Source is TJvParaAttributes then
  begin
    TJvParaAttributes(Source).GetAttributes(Paragraph);
    SetAttributes(Paragraph);
  end
  else
    inherited Assign(Source);
end;

procedure TJvParaAttributes.AssignTo(Dest: TPersistent);
var
  I: Integer;
begin
  if Dest is TParaAttributes then
  begin
    with TParaAttributes(Dest) do
    begin
      if Self.Alignment = paJustify then
        Alignment := taLeftJustify
      else
        Alignment := TAlignment(Self.Alignment);
      FirstIndent := Self.FirstIndent;
      LeftIndent := Self.LeftIndent;
      RightIndent := Self.RightIndent;
      if Self.Numbering <> nsNone then
        Numbering := TNumberingStyle(nsBullet)
      else
        Numbering := TNumberingStyle(nsNone);
      for I := 0 to MAX_TAB_STOPS - 1 do
        Tab[I] := Self.Tab[I];
    end;
  end
  else
    inherited AssignTo(Dest);
end;

constructor TJvParaAttributes.Create(AOwner: TJvCustomRichEdit);
begin
  inherited Create;
  FRichEdit := AOwner;
  // FIndentationStyle := isRichEdit; // = 0 so not needed; added by J.G. Boerema
end;

function TJvParaAttributes.GetAlignment: TParaAlignment;
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := TParaAlignment(Paragraph.wAlignment - 1);
end;

procedure TJvParaAttributes.GetAttributes(var Paragraph: TParaFormat2);
begin
  InitPara(Paragraph);
  if FRichEdit.HandleAllocated then
    SendMessage(FRichEdit.Handle, EM_GETPARAFORMAT, 0, LParam(@Paragraph));
end;

function TJvParaAttributes.GetFirstIndent: Longint;
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  if IndentationStyle = isRichEdit then
    Result := Paragraph.dxStartIndent div CTwipsPerPoint
  else // isOffice
    Result := -Paragraph.dxOffset div CTwipsPerPoint;
end;

function TJvParaAttributes.GetHeadingStyle: THeadingStyle;
var
  Paragraph: TParaFormat2;
begin
  if RichEditVersion < 3 then
    Result := 0
  else
  begin
    { See MSDN, ITextPara.GetStyle documentation:

      -1  : StyleNormal
      -2  : StyleHeading1
      -3  : StyleHeading2
      ..
      -10 : StyleHeading9

    }
    GetAttributes(Paragraph);
    Paragraph.sStyle := -Paragraph.sStyle + 1;
    if (Paragraph.sStyle >= Low(THeadingStyle)) and (Paragraph.sStyle <= Low(THeadingStyle)) then
      Result := THeadingStyle(Paragraph.sStyle)
    else
      Result := 0;
  end;
end;

function TJvParaAttributes.GetLeftIndent: Longint;
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  if IndentationStyle = isRichEdit then
    Result := Paragraph.dxOffset div CTwipsPerPoint
  else // isOffice
    Result := (Paragraph.dxStartIndent + Paragraph.dxOffset) div CTwipsPerPoint;
end;

function TJvParaAttributes.GetLineSpacing: Longint;
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dyLineSpacing div CTwipsPerPoint;
end;

function TJvParaAttributes.GetLineSpacingRule: TLineSpacingRule;
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := TLineSpacingRule(Paragraph.bLineSpacingRule);
end;

function TJvParaAttributes.GetNumbering: TJvNumbering;
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := TJvNumbering(Paragraph.wNumbering);
  if RichEditVersion = 1 then
    if Result <> nsNone then
      Result := nsBullet;
end;

function TJvParaAttributes.GetNumberingStart: Integer;
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.wNumberingStart;
end;

function TJvParaAttributes.GetNumberingStyle: TJvNumberingStyle;
var
  Paragraph: TParaFormat2;
begin
  if RichEditVersion < 2 then
    Result := nsSimple
  else
  begin
    GetAttributes(Paragraph);
    case Paragraph.wNumberingStyle of
      PFNS_PERIOD: Result := nsPeriod;
      PFNS_PARENS: Result := nsEnclosed;
      PFNS_PLAIN: Result := nsSimple;
    else
      Result := nsParenthesis;
    end;
  end;
end;

function TJvParaAttributes.GetNumberingTab: Word;
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.wNumberingTab div CTwipsPerPoint;
end;

function TJvParaAttributes.GetRightIndent: Longint;
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dxRightIndent div CTwipsPerPoint;
end;

function TJvParaAttributes.GetSpaceAfter: Longint;
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dySpaceAfter div CTwipsPerPoint;
end;

function TJvParaAttributes.GetSpaceBefore: Longint;
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dySpaceBefore div CTwipsPerPoint;
end;

function TJvParaAttributes.GetTab(Index: Byte): Longint;
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.rgxTabs[Index] div CTwipsPerPoint;
end;

function TJvParaAttributes.GetTabCount: Integer;
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.cTabCount;
end;

function TJvParaAttributes.GetTableStyle: TParaTableStyle;
var
  Paragraph: TParaFormat2;
begin
  Result := tsNone;
  if RichEditVersion < 2 then
    Exit;
  GetAttributes(Paragraph);
  with Paragraph do
  begin
    if (wReserved and PFE_TABLEROW) <> 0 then
      Result := tsTableRow
    else
    if (wReserved and PFE_TABLECELLEND) <> 0 then
      Result := tsTableCellEnd
    else
    if (wReserved and PFE_TABLECELL) <> 0 then
      Result := tsTableCell;
  end;
end;

procedure TJvParaAttributes.InitPara(var Paragraph: TParaFormat2);
begin
  FillChar(Paragraph, SizeOf(Paragraph), 0);
  if RichEditVersion >= 2 then
    Paragraph.cbSize := SizeOf(Paragraph)
  else
    Paragraph.cbSize := SizeOf(TParaFormat);
end;

procedure TJvParaAttributes.SetAlignment(Value: TParaAlignment);
var
  Paragraph: TParaFormat2;
begin
  InitPara(Paragraph);
  if (Value = paJustify) and (RichEditVersion >= 3) then
  begin
    { -> function }
    FRichEdit.HandleNeeded;
    if FRichEdit.HandleAllocated then
      { MSDN: Advanced and normal line breaking may also be turned on automatically
        by the rich edit control if it is needed for certain languages }
      SendMessage(FRichEdit.Handle, EM_SETTYPOGRAPHYOPTIONS, TO_ADVANCEDTYPOGRAPHY,
        TO_ADVANCEDTYPOGRAPHY);
  end;
  with Paragraph do
  begin
    dwMask := PFM_ALIGNMENT;
    wAlignment := Ord(Value) + 1;
  end;
  SetAttributes(Paragraph);
end;

procedure TJvParaAttributes.SetAttributes(var Paragraph: TParaFormat2);
begin
  FRichEdit.HandleNeeded; { we REALLY need the handle for BiDi }
  if FRichEdit.HandleAllocated then
  begin
    if FRichEdit.UseRightToLeftAlignment then
      if Paragraph.wAlignment = PFA_LEFT then
        Paragraph.wAlignment := PFA_RIGHT
      else
      if Paragraph.wAlignment = PFA_RIGHT then
        Paragraph.wAlignment := PFA_LEFT;
    SendMessage(FRichEdit.Handle, EM_SETPARAFORMAT, 0, LParam(@Paragraph));
  end;
end;

procedure TJvParaAttributes.SetFirstIndent(Value: Longint);
var
  Paragraph: TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do
  begin
    if IndentationStyle = isRichEdit then
    begin
      dwMask := PFM_STARTINDENT;
      dxStartIndent := Value * CTwipsPerPoint;
    end
    else // isOffice
    begin
      dwMask := PFM_STARTINDENT + PFM_OFFSET;
      dxStartIndent := (Value + LeftIndent) * CTwipsPerPoint;
      dxOffset := (LeftIndent * CTwipsPerPoint) - dxStartIndent;
    end;
  end;
  SetAttributes(Paragraph);
end;

procedure TJvParaAttributes.SetHeadingStyle(Value: THeadingStyle);
var
  Paragraph: TParaFormat2;
begin
  if RichEditVersion < 3 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_STYLE;
    sStyle := -Value - 1;
  end;
  SetAttributes(Paragraph);
end;

procedure TJvParaAttributes.SetLeftIndent(Value: Longint);
var
  Paragraph: TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do
  begin
    if IndentationStyle = isRichEdit then
    begin
      dwMask := PFM_OFFSET;
      dxOffset := Value * CTwipsPerPoint;
    end
    else // isOffice
    begin
      dwMask := PFM_STARTINDENT + PFM_OFFSET;
      dxStartIndent := (FirstIndent + Value) * CTwipsPerPoint;
      dxOffset := (Value * CTwipsPerPoint) - dxStartIndent;
    end;
  end;
  SetAttributes(Paragraph);
end;

procedure TJvParaAttributes.SetLineSpacing(Value: Longint);
var
  Paragraph: TParaFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  GetAttributes(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_LINESPACING;
    dyLineSpacing := Value * CTwipsPerPoint;
  end;
  SetAttributes(Paragraph);
end;

procedure TJvParaAttributes.SetLineSpacingRule(Value: TLineSpacingRule);
var
  Paragraph: TParaFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  GetAttributes(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_LINESPACING;
    bLineSpacingRule := Ord(Value);
  end;
  SetAttributes(Paragraph);
end;

procedure TJvParaAttributes.SetNumbering(Value: TJvNumbering);
var
  Paragraph: TParaFormat2;
begin
  if RichEditVersion = 1 then
    if Value <> nsNone then
      Value := TJvNumbering(PFN_BULLET);
  case Value of
    nsNone:
      LeftIndent := 0;
  else
  if LeftIndent < 10 then
      LeftIndent := 10;
  end;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_NUMBERING;
    wNumbering := Ord(Value);
  end;
  SetAttributes(Paragraph);
end;

procedure TJvParaAttributes.SetNumberingStart(const Value: Integer);
var
  Paragraph: TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_NUMBERINGSTART;
    wNumberingStart := Value
  end;
  SetAttributes(Paragraph);
end;

procedure TJvParaAttributes.SetNumberingStyle(Value: TJvNumberingStyle);
const
  CNumberingStyle: array [TJvNumberingStyle] of Word = (PFNS_PAREN, PFNS_PERIOD, PFNS_PARENS, PFNS_PLAIN);
var
  Paragraph: TParaFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_NUMBERINGSTYLE;
    wNumberingStyle := CNumberingStyle[Value];
  end;
  SetAttributes(Paragraph);
end;

procedure TJvParaAttributes.SetNumberingTab(Value: Word);
var
  Paragraph: TParaFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_NUMBERINGTAB;
    wNumberingTab := Value * CTwipsPerPoint;
  end;
  SetAttributes(Paragraph);
end;

procedure TJvParaAttributes.SetRightIndent(Value: Longint);
var
  Paragraph: TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_RIGHTINDENT;
    dxRightIndent := Value * CTwipsPerPoint;
  end;
  SetAttributes(Paragraph);
end;

procedure TJvParaAttributes.SetSpaceAfter(Value: Longint);
var
  Paragraph: TParaFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_SPACEAFTER;
    dySpaceAfter := Value * CTwipsPerPoint;
  end;
  SetAttributes(Paragraph);
end;

procedure TJvParaAttributes.SetSpaceBefore(Value: Longint);
var
  Paragraph: TParaFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_SPACEBEFORE;
    dySpaceBefore := Value * CTwipsPerPoint;
  end;
  SetAttributes(Paragraph);
end;

procedure TJvParaAttributes.SetTab(Index: Byte; Value: Longint);
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  with Paragraph do
  begin
    rgxTabs[Index] := Value * CTwipsPerPoint;
    dwMask := PFM_TABSTOPS;
    if cTabCount < Index then
      cTabCount := Index;
    SetAttributes(Paragraph);
  end;
end;

procedure TJvParaAttributes.SetTabCount(Value: Integer);
var
  Paragraph: TParaFormat2;
begin
  GetAttributes(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_TABSTOPS;
    cTabCount := Value;
    SetAttributes(Paragraph);
  end;
end;

procedure TJvParaAttributes.SetTableStyle(Value: TParaTableStyle);
var
  Paragraph: TParaFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_TABLE;
    case Value of
      tsTableRow:
        wReserved := PFE_TABLEROW;
      tsTableCellEnd:
        wReserved := PFE_TABLECELLEND;
      tsTableCell:
        wReserved := PFE_TABLECELL;
    end;
  end;
  SetAttributes(Paragraph);
end;

//=== TJvRichEditStrings =====================================================

procedure TJvRichEditStrings.AddStrings(Strings: TStrings);
var
  SelChange: TNotifyEvent;
begin
  SelChange := FRichEdit.OnSelectionChange;
  FRichEdit.OnSelectionChange := nil;
  try
    inherited AddStrings(Strings);
  finally
    FRichEdit.OnSelectionChange := SelChange;
  end;
end;

procedure TJvRichEditStrings.Clear;
begin
  FRichEdit.Clear;
end;

procedure TJvRichEditStrings.Delete(Index: Integer);
const
  Empty: PChar = '';
var
  Selection: TCharRange;
begin
  if Index < 0 then
    Exit;
  Selection.cpMin := FRichEdit.GetLineIndex(Index);
  if Selection.cpMin <> -1 then
  begin
    Selection.cpMax := FRichEdit.GetLineIndex(Index + 1);
    if Selection.cpMax = -1 then
      Selection.cpMax := Selection.cpMin +
        FRichEdit.GetLineLength(Selection.cpMin);
    SendMessage(FRichEdit.Handle, EM_EXSETSEL, 0, Longint(@Selection));
    FRichEdit.FLinesUpdating := True;
    try
      SendMessage(FRichEdit.Handle, EM_REPLACESEL, 0, Longint(Empty));
    finally
      FRichEdit.FLinesUpdating := False;
    end;
  end;
end;

destructor TJvRichEditStrings.Destroy;
begin
  //  FConverter.Free;
  inherited Destroy;
end;

procedure TJvRichEditStrings.DoExport(AConverter: TJvConverter);
var
  EditStream: TEditStream;
  TextType: Longint;
begin
  with EditStream do
  begin
    dwCookie := Longint(AConverter);
    pfnCallBack := StreamSave;
    dwError := 0;
  end;
  case FFormat of
    sfDefault:
      if FRichEdit.PlainText then
        TextType := SF_TEXT
      else
        TextType := SF_RTF;
    sfRichText:
      TextType := SF_RTF;
  else {sfPlainText}
    TextType := SF_TEXT;
  end;
  if TextType = SF_RTF then
  begin
    if smNoObjects in Mode then
      TextType := SF_RTFNOOBJS;
    if smPlainRtf in Mode then
      TextType := TextType or SFF_PLAINRTF;
  end
  else
  if TextType = SF_TEXT then
  begin
    if (smUnicode in Mode) and (RichEditVersion > 1) then
      TextType := TextType or SF_UNICODE;
  end;
  if smSelection in Mode then
    TextType := TextType or SFF_SELECTION;
  SendMessage(FRichEdit.Handle, EM_STREAMOUT, TextType, Longint(@EditStream));
  if EditStream.dwError <> 0 then
    raise EOutOfResources.Create(sRichEditSaveFail);
end;

procedure TJvRichEditStrings.DoImport(AConverter: TJvConverter);
var
  EditStream: TEditStream;
  TextType: Longint;
begin
  with EditStream do
  begin
    dwCookie := Longint(AConverter);
    pfnCallBack := StreamLoad;
    dwError := 0;
  end;
  case FFormat of
    sfDefault:
      if FRichEdit.PlainText then
        TextType := SF_TEXT
      else
        TextType := SF_RTF;
    sfRichText:
      TextType := SF_RTF;
  else {sfPlainText}
    TextType := SF_TEXT;
  end;
  if TextType = SF_RTF then
  begin
    if smPlainRtf in Mode then
      TextType := TextType or SFF_PLAINRTF;
  end;
  if TextType = SF_TEXT then
  begin
    if (smUnicode in Mode) and (RichEditVersion > 1) then
      TextType := TextType or SF_UNICODE;
  end;
  if smSelection in Mode then
    TextType := TextType or SFF_SELECTION;
  SendMessage(FRichEdit.Handle, EM_STREAMIN, TextType, Longint(@EditStream));

  if (EditStream.dwError <> 0) and AConverter.Retry then
  begin
    if (TextType and SF_RTF) = SF_RTF then
      TextType := SF_TEXT
    else
      TextType := SF_RTF;
    SendMessage(FRichEdit.Handle, EM_STREAMIN, TextType, Longint(@EditStream));
  end;

  if AConverter.Error then
    raise EOutOfResources.Create(AConverter.ErrorStr)
  else
  if EditStream.dwError <> 0 then
    raise EOutOfResources.Create(sRichEditLoadFail);

  FRichEdit.SetSelection(0, 0, True);
end;

procedure TJvRichEditStrings.EnableChange(const Value: Boolean);
var
  EventMask: Longint;
begin
  with FRichEdit do
  begin
    EventMask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0);
    if Value then
      EventMask := EventMask or ENM_CHANGE
    else
      EventMask := EventMask and not ENM_CHANGE;
    SendMessage(Handle, EM_SETEVENTMASK, 0, EventMask);
  end;
end;

function TJvRichEditStrings.Get(Index: Integer): string;
var
  Text: array [0..4095] of Char;
  L: Integer;
  W: Word;
begin
  // (rom) reimplemented as Move
  W := SizeOf(Text);
  System.Move(W, Text[0], SizeOf(Word));
  L := SendMessage(FRichEdit.Handle, EM_GETLINE, Index, Longint(@Text));
  if (Text[L - 2] = #13) and (Text[L - 1] = #10) then
    Dec(L, 2)
  else
  if (RichEditVersion >= 2) and (Text[L - 1] = #13) then
    Dec(L);
  SetString(Result, Text, L);
end;

function TJvRichEditStrings.GetCount: Integer;
begin
  with FRichEdit do
  begin
    Result := SendMessage(Handle, EM_GETLINECOUNT, 0, 0);
    if GetLineLength(GetLineIndex(Result - 1)) = 0 then
      Dec(Result);
  end;
end;

procedure TJvRichEditStrings.Insert(Index: Integer; const S: string);
var
  L: Integer;
  Selection: TCharRange;
  Fmt: PChar;
  Str: string;
begin
  if Index >= 0 then
  begin
    Selection.cpMin := FRichEdit.GetLineIndex(Index);
    if Selection.cpMin >= 0 then
    begin
      if RichEditVersion = 1 then
        Fmt := '%s' + sLineBreak
      else
        Fmt := '%s' + Cr;
    end
    else
    begin
      Selection.cpMin := FRichEdit.GetLineIndex(Index - 1);
      if Selection.cpMin < 0 then
      begin
        Selection.cpMin :=
          SendMessage(FRichEdit.Handle, EM_LINEINDEX, Index - 1, 0);
        if Selection.cpMin < 0 then
          Exit;
        L := SendMessage(FRichEdit.Handle, EM_LINELENGTH, Selection.cpMin, 0);
        if L = 0 then
          Exit;
        Inc(Selection.cpMin, L);
        if RichEditVersion = 1 then
          Fmt := sLineBreak + '%s'
        else
          Fmt := Cr + '%s';
      end
      else
      begin
        L := FRichEdit.GetLineLength(Selection.cpMin);
        if L = 0 then
          Exit;
        Inc(Selection.cpMin, L);
        if RichEditVersion = 1 then
          Fmt := '%s' + sLineBreak
        else
          Fmt := '%s' + Cr;
      end;
    end;
    Selection.cpMax := Selection.cpMin;
    SendMessage(FRichEdit.Handle, EM_EXSETSEL, 0, Longint(@Selection));
    Str := SysUtils.Format(Fmt, [S]);
    FRichEdit.FLinesUpdating := True;
    try
      SendMessage(FRichEdit.Handle, EM_REPLACESEL, 0, Longint(PChar(Str)));
    finally
      FRichEdit.FLinesUpdating := False;
    end;
    if RichEditVersion = 1 then
      if FRichEdit.SelStart <> (Selection.cpMax + Length(Str)) then
        raise EOutOfResources.Create(sRichEditInsertError);
  end;
end;

procedure TJvRichEditStrings.LoadFromFile(const FileName: string);
var
  SaveFormat: TRichStreamFormat;
  Converter: TJvConverter;
begin
  Converter := GConversionFormatList.GetConverterForFile(FileName, ckImport);
  if Converter = nil then
    Converter := FRichEdit.DefaultConverter;
  if Converter = nil then
    Converter := GConversionFormatList.DefaultConverter;
  Converter.OnProgress := ProgressCallback;
  try
    SaveFormat := Format;
    try
      if Converter.TextKind in [ctkText, ctkBothPreferText] then
        FFormat := sfPlainText
      else
        FFormat := sfRichText;

      if not Converter.Open(FileName, ckImport) then
        raise EOutOfResources.Create(sRichEditLoadFail);

      DoImport(Converter);
    finally
      FFormat := SaveFormat;
    end;
  finally
    Converter.Done;
    Converter.OnProgress := nil;
  end;
end;

procedure TJvRichEditStrings.LoadFromStream(Stream: TStream);
var
  SaveFormat: TRichStreamFormat;
  Converter: TJvConverter;
begin
  Converter := FRichEdit.DefaultConverter;
  if Converter = nil then
    Converter := GConversionFormatList.DefaultConverter;
  try
    SaveFormat := Format;
    try
      if Converter.TextKind in [ctkText, ctkBothPreferText] then
        FFormat := sfPlainText
      else
        FFormat := sfRichText;

      if not Converter.Open(Stream, ckImport) then
        raise EOutOfResources.Create(sRichEditLoadFail);

      DoImport(Converter)
    finally
      FFormat := SaveFormat;
    end;
  finally
    Converter.Done;
  end;
end;

procedure TJvRichEditStrings.ProgressCallback(Sender: TObject);
begin
  if Sender is TJvConverter then
    FRichEdit.DoConversionProgress(TJvConverter(Sender).Progress);
end;

procedure TJvRichEditStrings.Put(Index: Integer; const S: string);
var
  Selection: TCharRange;
begin
  if Index >= 0 then
  begin
    Selection.cpMin := FRichEdit.GetLineIndex(Index);
    if Selection.cpMin <> -1 then
    begin
      Selection.cpMax := Selection.cpMin +
        FRichEdit.GetLineLength(Selection.cpMin);
      SendMessage(FRichEdit.Handle, EM_EXSETSEL, 0, Longint(@Selection));
      FRichEdit.FLinesUpdating := True;
      try
        SendMessage(FRichEdit.Handle, EM_REPLACESEL, 0, Longint(PChar(S)));
      finally
        FRichEdit.FLinesUpdating := False;
      end;
    end;
  end;
end;

procedure TJvRichEditStrings.SaveToFile(const FileName: string);
var
  SaveFormat: TRichStreamFormat;
  Converter: TJvConverter;
begin
  Converter := GConversionFormatList.GetConverterForFile(FileName, ckExport);
  if Converter = nil then
    Converter := FRichEdit.DefaultConverter;
  if Converter = nil then
    Converter := GConversionFormatList.DefaultConverter;
  try
    SaveFormat := Format;
    try
      if Converter.TextKind in [ctkText, ctkBothPreferText] then
        FFormat := sfPlainText
      else
        FFormat := sfRichText;

      if not Converter.Open(FileName, ckExport) then
        raise EOutOfResources.Create(sRichEditSaveFail);

      DoExport(Converter)
    finally
      FFormat := SaveFormat;
    end;
  finally
    Converter.Done;
  end;
end;

procedure TJvRichEditStrings.SaveToStream(Stream: TStream);
var
  SaveFormat: TRichStreamFormat;
  Converter: TJvConverter;
begin
  Converter := FRichEdit.DefaultConverter;
  if Converter = nil then
    Converter := GConversionFormatList.DefaultConverter;
  try
    SaveFormat := Format;
    try
      if Converter.TextKind in [ctkText, ctkBothPreferText] then
        FFormat := sfPlainText
      else
        FFormat := sfRichText;

      if not Converter.Open(Stream, ckExport) then
        raise EOutOfResources.Create(sRichEditSaveFail);

      DoExport(Converter)
    finally
      FFormat := SaveFormat;
    end;
  finally
    Converter.Done;
  end;
end;

procedure TJvRichEditStrings.SetTextStr(const Value: string);
begin
  EnableChange(False);
  try
    inherited SetTextStr(Value);
  finally
    EnableChange(True);
  end;
end;

procedure TJvRichEditStrings.SetUpdateState(Updating: Boolean);
begin
  if FRichEdit.Showing then
    SendMessage(FRichEdit.Handle, WM_SETREDRAW, Ord(not Updating), 0);
  if not Updating then
  begin
    FRichEdit.Refresh;
    FRichEdit.Perform(CM_TEXTCHANGED, 0, 0);
  end;
end;

//=== TJvRTFConversion =======================================================

function TJvRTFConversion.CanHandle(const AExtension: string;
  const AKind: TJvConversionKind): Boolean;
begin
  Result := AExtension = 'rtf';
end;

function TJvRTFConversion.Filter: string;
begin
  Result := SRTFFilter;
end;

function TJvRTFConversion.IsFormatCorrect(AStream: TStream): Boolean;
const
  CRTFHeader = '{\rtf';
  CRTFHeaderSize = Length(CRTFHeader);
var
  SavedPosition: Int64;
  Buffer: array [0..CRTFHeaderSize - 1] of Char;
begin
  SavedPosition := AStream.Position;
  try
    Result :=
      (AStream.Read(Buffer, CRTFHeaderSize) = CRTFHeaderSize) and
      (StrIComp(CRTFHeader, Buffer) = 0);
  finally
    AStream.Position := SavedPosition;
  end;
end;

function TJvRTFConversion.IsFormatCorrect(
  const AFileName: string): Boolean;
var
  LStream: TStream;
begin
  Result := FileExists(AFileName);
  if not Result then
    Exit;

  LStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := IsFormatCorrect(LStream);
  finally
    LStream.Free;
  end;
end;

function TJvRTFConversion.TextKind: TJvConversionTextKind;
begin
  Result := ctkBothPreferRTF;
end;

//=== TJvStreamConversion ====================================================

function TJvStreamConversion.ConvertRead(Buffer: PChar;
  BufSize: Integer): Integer;
begin
  Result := FStream.Read(Buffer^, BufSize);
  if FStreamSize > 0 then
  begin
    Inc(FConvertByteCount, Result);
    DoProgress((FConvertByteCount * 100 + FStreamSize div 2) div FStreamSize);
  end;
end;

function TJvStreamConversion.ConvertWrite(Buffer: PChar;
  BufSize: Integer): Integer;
begin
  Result := FStream.Write(Buffer^, BufSize);
  if FStreamSize > 0 then
  begin
    Inc(FConvertByteCount, Result);
    DoProgress((FConvertByteCount * 100 + FStreamSize div 2) div FStreamSize);
  end;
end;

procedure TJvStreamConversion.Done;
begin
  if FFreeStream then
    FStream.Free;
  FStream := nil;
end;

function TJvStreamConversion.Open(Stream: TStream;
  const AKind: TJvConversionKind): Boolean;
begin
  FFreeStream := False;
  FStream := Stream;

  FSavedPosition := FStream.Seek(0, soCurrent);
  FStreamSize := FStream.Seek(0, soEnd);
  FStream.Seek(FSavedPosition, soBeginning);
  FConvertByteCount := 0;

  Result := True;
end;

function TJvStreamConversion.Open(const AFileName: string;
  const AKind: TJvConversionKind): Boolean;
begin
  FFreeStream := True;
  if AKind = ckImport then
    FStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite)
  else
    FStream := TFileStream.Create(AFileName, fmCreate);

  FSavedPosition := 0;
  FStreamSize := FStream.Size;
  FConvertByteCount := 0;

  Result := True;
end;

function TJvStreamConversion.Retry: Boolean;
begin
  Result := TextKind in [ctkBothPreferText, ctkBothPreferRTF];
  if Result then
  begin
    FStream.Position := FSavedPosition;
    FConvertByteCount := 0;
  end;
end;

//=== TJvTextAttributes ======================================================

procedure TJvTextAttributes.Assign(Source: TPersistent);
var
  Format: TCharFormat2;
begin
  if Source is TFont then
    AssignFont(TFont(Source))
  else
  if Source is TTextAttributes then
  begin
    Name := TTextAttributes(Source).Name;
    Charset := TTextAttributes(Source).Charset;
    Style := TTextAttributes(Source).Style;
    Pitch := TTextAttributes(Source).Pitch;
    Color := TTextAttributes(Source).Color;
  end
  else
  if Source is TJvTextAttributes then
  begin
    TJvTextAttributes(Source).GetAttributes(Format);
    SetAttributes(Format);
  end
  else
    inherited Assign(Source);
end;

procedure TJvTextAttributes.AssignFont(Font: TFont);
var
  LogFont: TLogFont;
  Format: TCharFormat2;
begin
  InitFormat(Format);
  with Format do
  begin
    case Font.Pitch of
      fpVariable:
        bPitchAndFamily := VARIABLE_PITCH;
      fpFixed:
        bPitchAndFamily := FIXED_PITCH;
    else
      bPitchAndFamily := DEFAULT_PITCH;
    end;
    dwMask := dwMask or CFM_SIZE or CFM_BOLD or CFM_ITALIC or
      CFM_UNDERLINE or CFM_STRIKEOUT or CFM_FACE or CFM_COLOR;
    { Font.Size is in points; yHeight is in twips }
    yHeight := Font.Size * CTwipsPerPoint;
    if (Font.Color = clWindowText) or (Font.Color = clDefault) then
      dwEffects := CFE_AUTOCOLOR
    else
      crTextColor := ColorToRGB(Font.Color);
    if fsBold in Font.Style then
      dwEffects := dwEffects or CFE_BOLD;
    if fsItalic in Font.Style then
      dwEffects := dwEffects or CFE_ITALIC;
    if fsUnderline in Font.Style then
      dwEffects := dwEffects or CFE_UNDERLINE;
    if fsStrikeOut in Font.Style then
      dwEffects := dwEffects or CFE_STRIKEOUT;
    StrPLCopy(szFaceName, Font.Name, SizeOf(szFaceName));
    dwMask := dwMask or CFM_CHARSET;
    bCharSet := Font.Charset;
    if GetObject(Font.Handle, SizeOf(LogFont), @LogFont) <> 0 then
    begin
      dwMask := dwMask or DWORD(CFM_WEIGHT);
      wWeight := Word(LogFont.lfWeight);
    end;
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.AssignTo(Dest: TPersistent);
begin
  if Dest is TFont then
  begin
    TFont(Dest).Color := Color;
    TFont(Dest).Name := Name;
    TFont(Dest).Charset := Charset;
    TFont(Dest).Style := Style;
    TFont(Dest).Size := Size;
    TFont(Dest).Pitch := Pitch;
  end
  else
  if Dest is TTextAttributes then
  begin
    TTextAttributes(Dest).Color := Color;
    TTextAttributes(Dest).Name := Name;
    TTextAttributes(Dest).Charset := Charset;
    TTextAttributes(Dest).Style := Style;
    TTextAttributes(Dest).Pitch := Pitch;
  end
  else
    inherited AssignTo(Dest);
end;

constructor TJvTextAttributes.Create(AOwner: TJvCustomRichEdit;
  AttributeType: TJvAttributeType);
begin
  inherited Create;
  FRichEdit := AOwner;
  FType := AttributeType;
end;

procedure TJvTextAttributes.GetAttributes(var Format: TCharFormat2);
begin
  InitFormat(Format);
  if FRichEdit.HandleAllocated then
    SendMessage(FRichEdit.Handle, EM_GETCHARFORMAT, AttrFlags[FType],
      LParam(@Format));
end;

function TJvTextAttributes.GetBackColor: TColor;
var
  Format: TCharFormat2;
begin
  if RichEditVersion < 2 then
  begin
    Result := clWindow;
    Exit;
  end;
  GetAttributes(Format);
  with Format do
    if (dwEffects and CFE_AUTOBACKCOLOR) <> 0 then
      Result := clWindow
    else
      Result := crBackColor;
end;

function TJvTextAttributes.GetCharset: TFontCharset;
var
  Format: TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.bCharset;
end;

function TJvTextAttributes.GetColor: TColor;
var
  Format: TCharFormat2;
begin
  GetAttributes(Format);
  with Format do
    if (dwEffects and CFE_AUTOCOLOR) <> 0 then
      Result := clWindowText
    else
      Result := crTextColor;
end;

function TJvTextAttributes.GetConsistentAttributes: TJvConsistentAttributes;
var
  Format: TCharFormat2;
begin
  Result := [];
  if FRichEdit.HandleAllocated and (FType <> atDefaultText) then
  begin
    InitFormat(Format);
    SendMessage(FRichEdit.Handle, EM_GETCHARFORMAT,
      AttrFlags[FType], LParam(@Format));
    with Format do
    begin
      if (dwMask and CFM_BOLD) <> 0 then
        Include(Result, caBold);
      if (dwMask and CFM_COLOR) <> 0 then
        Include(Result, caColor);
      if (dwMask and CFM_FACE) <> 0 then
        Include(Result, caFace);
      if (dwMask and CFM_ITALIC) <> 0 then
        Include(Result, caItalic);
      if (dwMask and CFM_SIZE) <> 0 then
        Include(Result, caSize);
      if (dwMask and CFM_STRIKEOUT) <> 0 then
        Include(Result, caStrikeOut);
      if (dwMask and CFM_UNDERLINE) <> 0 then
        Include(Result, caUnderline);
      if (dwMask and CFM_PROTECTED) <> 0 then
        Include(Result, caProtected);
      if (dwMask and CFM_OFFSET) <> 0 then
        Include(Result, caOffset);
      if (dwMask and CFM_HIDDEN) <> 0 then
        Include(Result, caHidden);
      if RichEditVersion >= 2 then
      begin
        if (dwMask and CFM_LINK) <> 0 then
          Include(Result, caLink);
        if (dwMask and CFM_BACKCOLOR) <> 0 then
          Include(Result, caBackColor);
        if (dwMask and CFM_DISABLED) <> 0 then
          Include(Result, caDisabled);
        if (dwMask and CFM_WEIGHT) <> 0 then
          Include(Result, caWeight);
        if (dwMask and CFM_SUBSCRIPT) <> 0 then
          Include(Result, caSubscript);
        if (dwMask and CFM_REVAUTHOR) <> 0 then
          Include(Result, caRevAuthor);
      end;
    end;
  end;
end;

function TJvTextAttributes.GetDisabled: Boolean;
var
  Format: TCharFormat2;
begin
  Result := False;
  if RichEditVersion < 2 then
    Exit;
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_DISABLED <> 0;
end;

function TJvTextAttributes.GetHeight: Integer;
begin
  { Points -> Logical pixels }
  Result := MulDiv(Size, FRichEdit.FScreenLogPixels, CPointsPerInch);
end;

function TJvTextAttributes.GetHidden: Boolean;
var
  Format: TCharFormat2;
begin
  Result := False;
  if RichEditVersion < 2 then
    Exit;
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_HIDDEN <> 0;
end;

function TJvTextAttributes.GetLink: Boolean;
var
  Format: TCharFormat2;
begin
  Result := False;
  if RichEditVersion < 2 then
    Exit;
  GetAttributes(Format);
  with Format do
    Result := (dwEffects and CFE_LINK) <> 0;
end;

function TJvTextAttributes.GetName: TFontName;
var
  Format: TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.szFaceName;
end;

function TJvTextAttributes.GetOffset: Integer;
var
  Format: TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.yOffset div CTwipsPerPoint;
end;

function TJvTextAttributes.GetPitch: TFontPitch;
var
  Format: TCharFormat2;
begin
  GetAttributes(Format);
  case Format.bPitchAndFamily and $03 of
    DEFAULT_PITCH:
      Result := fpDefault;
    VARIABLE_PITCH:
      Result := fpVariable;
    FIXED_PITCH:
      Result := fpFixed;
  else
    Result := fpDefault;
  end;
end;

function TJvTextAttributes.GetProtected: Boolean;
var
  Format: TCharFormat2;
begin
  GetAttributes(Format);
  with Format do
    Result := (dwEffects and CFE_PROTECTED) <> 0;
end;

function TJvTextAttributes.GetRevAuthorIndex: Byte;
var
  Format: TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.bRevAuthor;
end;

function TJvTextAttributes.GetSize: Integer;
var
  Format: TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.yHeight div CTwipsPerPoint;
end;

function TJvTextAttributes.GetStyle: TFontStyles;
var
  Format: TCharFormat2;
begin
  Result := [];
  GetAttributes(Format);
  with Format do
  begin
    if (dwEffects and CFE_BOLD) <> 0 then
      Include(Result, fsBold);
    if (dwEffects and CFE_ITALIC) <> 0 then
      Include(Result, fsItalic);
    if (dwEffects and CFE_UNDERLINE) <> 0 then
      Include(Result, fsUnderline);
    if (dwEffects and CFE_STRIKEOUT) <> 0 then
      Include(Result, fsStrikeOut);
  end;
end;

function TJvTextAttributes.GetSubscriptStyle: TSubscriptStyle;
var
  Format: TCharFormat2;
begin
  Result := ssNone;
  if RichEditVersion < 2 then
    Exit;
  GetAttributes(Format);
  with Format do
  begin
    if (dwEffects and CFE_SUBSCRIPT) <> 0 then
      Result := ssSubscript
    else
    if (dwEffects and CFE_SUPERSCRIPT) <> 0 then
      Result := ssSuperscript;
  end;
end;

function TJvTextAttributes.GetUnderlineColor: TUnderlineColor;
var
  Format: TCharFormat2;
begin
  Result := ucBlack;
  if RichEditVersion < 3 then
    Exit;
  GetAttributes(Format);
  with Format do
  begin
    if (dwEffects and CFE_UNDERLINE <> 0) and
      (dwMask and CFM_UNDERLINETYPE = CFM_UNDERLINETYPE) then
      Result := TUnderlineColor(bUnderlineType div $10);
  end;
end;

function TJvTextAttributes.GetUnderlineType: TUnderlineType;
var
  Format: TCharFormat2;
begin
  Result := utNone;
  if RichEditVersion < 2 then
    Exit;
  GetAttributes(Format);
  with Format do
  begin
    if (dwEffects and CFE_UNDERLINE <> 0) and
      (dwMask and CFM_UNDERLINETYPE = CFM_UNDERLINETYPE) then
      Result := TUnderlineType(bUnderlineType mod $10);
  end;
end;

procedure TJvTextAttributes.InitFormat(var Format: TCharFormat2);
begin
  FillChar(Format, SizeOf(Format), 0);
  if RichEditVersion >= 2 then
    Format.cbSize := SizeOf(Format)
  else
    Format.cbSize := SizeOf(TCharFormat);
end;

procedure TJvTextAttributes.SetAttributes(var Format: TCharFormat2);
begin
  if FRichEdit.HandleAllocated then
    SendMessage(FRichEdit.Handle, EM_SETCHARFORMAT, AttrFlags[FType],
      LParam(@Format));
end;

procedure TJvTextAttributes.SetBackColor(Value: TColor);
var
  Format: TCharFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_BACKCOLOR;
    if (Value = clWindow) or (Value = clDefault) then
      dwEffects := CFE_AUTOBACKCOLOR
    else
      crBackColor := ColorToRGB(Value);
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetCharset(Value: TFontCharset);
var
  Format: TCharFormat2;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_CHARSET;
    bCharSet := Value;
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetColor(Value: TColor);
var
  Format: TCharFormat2;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_COLOR;
    if (Value = clWindowText) or (Value = clDefault) then
      dwEffects := CFE_AUTOCOLOR
    else
      crTextColor := ColorToRGB(Value);
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetDisabled(Value: Boolean);
var
  Format: TCharFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_DISABLED;
    if Value then
      dwEffects := CFE_DISABLED;
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetHeight(Value: Integer);
begin
  { Logical pixels -> Points }
  Size := MulDiv(Value, CPointsPerInch, FRichEdit.FScreenLogPixels);
end;

procedure TJvTextAttributes.SetHidden(Value: Boolean);
var
  Format: TCharFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_HIDDEN;
    if Value then
      dwEffects := CFE_HIDDEN;
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetLink(Value: Boolean);
var
  Format: TCharFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_LINK;
    if Value then
      dwEffects := CFE_LINK;
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetName(Value: TFontName);
var
  Format: TCharFormat2;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_FACE;
    StrPLCopy(szFaceName, Value, SizeOf(szFaceName));
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetOffset(Value: Integer);
var
  Format: TCharFormat2;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := DWORD(CFM_OFFSET);
    yOffset := Value * CTwipsPerPoint;
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetPitch(Value: TFontPitch);
var
  Format: TCharFormat2;
begin
  InitFormat(Format);
  with Format do
  begin
    case Value of
      fpVariable:
        bPitchAndFamily := VARIABLE_PITCH;
      fpFixed:
        bPitchAndFamily := FIXED_PITCH;
    else
      bPitchAndFamily := DEFAULT_PITCH;
    end;
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetProtected(Value: Boolean);
var
  Format: TCharFormat2;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_PROTECTED;
    if Value then
      dwEffects := CFE_PROTECTED;
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetRevAuthorIndex(Value: Byte);
var
  Format: TCharFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_REVAUTHOR;
    bRevAuthor := Value;
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetSize(Value: Integer);
var
  Format: TCharFormat2;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := DWORD(CFM_SIZE);
    yHeight := Value * CTwipsPerPoint;
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetStyle(Value: TFontStyles);
var
  Format: TCharFormat2;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_BOLD or CFM_ITALIC or CFM_UNDERLINE or CFM_STRIKEOUT;
    if fsBold in Value then
      dwEffects := dwEffects or CFE_BOLD;
    if fsItalic in Value then
      dwEffects := dwEffects or CFE_ITALIC;
    if fsUnderline in Value then
      dwEffects := dwEffects or CFE_UNDERLINE;
    if fsStrikeOut in Value then
      dwEffects := dwEffects or CFE_STRIKEOUT;
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetSubscriptStyle(Value: TSubscriptStyle);
var
  Format: TCharFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := DWORD(CFM_SUBSCRIPT);
    case Value of
      ssSubscript:
        dwEffects := CFE_SUBSCRIPT;
      ssSuperscript:
        dwEffects := CFE_SUPERSCRIPT;
    end;
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetUnderlineColor(
  const Value: TUnderlineColor);
var
  Format: TCharFormat2;
  LUnderlineType: TUnderlineType;
begin
  if RichEditVersion < 3 then
    Exit;

  LUnderlineType := UnderlineType;
  if LUnderlineType = utNone then
    Exit;

  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_UNDERLINETYPE or CFM_UNDERLINE;
    bUnderlineType := Ord(LUnderlineType) + $10 * Ord(Value);
    dwEffects := dwEffects or CFE_UNDERLINE;
  end;
  SetAttributes(Format);
end;

procedure TJvTextAttributes.SetUnderlineType(Value: TUnderlineType);
var
  Format: TCharFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_UNDERLINETYPE or CFM_UNDERLINE;
    bUnderlineType := Ord(Value);
    if Value <> utNone then
    begin
      Inc(bUnderlineType, $10 * Ord(UnderlineColor));
      dwEffects := dwEffects or CFE_UNDERLINE;
    end;
  end;
  SetAttributes(Format);
end;

//=== TJvTextConversion ======================================================

function TJvTextConversion.CanHandle(const AExtension: string;
  const AKind: TJvConversionKind): Boolean;
begin
  Result := AExtension = 'txt';
end;

function TJvTextConversion.Filter: string;
begin
  Result := STextFilter;
end;

function TJvTextConversion.TextKind: TJvConversionTextKind;
begin
  Result := ctkBothPreferText;
end;

//=== TMSTextConversionThread ================================================

constructor TMSTextConversionThread.Create;
begin
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TMSTextConversionThread.Execute;
begin
  if GCurrentConverter <> nil then
    GCurrentConverter.DoConversion;
end;

//=== TOleUILinkInfo =========================================================

function TOleUILinkInfo.CancelLink(dwLink: Longint): HRESULT;
begin
  LinkError(SCannotBreakLink);
  Result := E_NOTIMPL;
end;

constructor TOleUILinkInfo.Create(ARichEdit: TJvCustomRichEdit;
  ReObject: TReObject);
begin
  inherited Create;
  FReObject := ReObject;
  FRichEdit := ARichEdit;
  OleCheck(FReObject.poleobj.QueryInterface(IOleLink, FOleLink));
end;

function TOleUILinkInfo.GetLastUpdate(dwLink: Longint;
  var LastUpdate: TFileTime): HRESULT;
begin
  Result := S_OK;
end;

function TOleUILinkInfo.GetLinkSource(dwLink: Longint; var pszDisplayName: PChar;
  var lenFileName: Longint; var pszFullLinkType: PChar;
  var pszShortLinkType: PChar; var fSourceAvailable: BOOL;
  var fIsSelected: BOOL): HRESULT;
var
  Moniker: IMoniker;
begin
  if @pszDisplayName <> nil then
    pszDisplayName := CoAllocCStr(GetDisplayNameStr(FOleLink));
  if @lenFileName <> nil then
  begin
    lenFileName := 0;
    FOleLink.GetSourceMoniker(Moniker);
    if Moniker <> nil then
    begin
      lenFileName := OleStdGetLenFilePrefixOfMoniker(Moniker);
      ReleaseObject(Moniker);
    end;
  end;
  if @pszFullLinkType <> nil then
    pszFullLinkType := CoAllocCStr(GetFullNameStr(FReObject.poleobj));
  if @pszShortLinkType <> nil then
    pszShortLinkType := CoAllocCStr(GetShortNameStr(FReObject.poleobj));
  Result := S_OK;
end;

function TOleUILinkInfo.GetLinkUpdateOptions(dwLink: Longint;
  var dwUpdateOpt: Longint): HRESULT;
begin
  Result := FOleLink.GetUpdateOptions(dwUpdateOpt);
end;

function TOleUILinkInfo.GetNextLink(dwLink: Longint): Longint;
begin
  if dwLink = 0 then
    Result := Longint(FRichEdit)
  else
    Result := 0;
end;

function TOleUILinkInfo.OpenLinkSource(dwLink: Longint): HRESULT;
begin
  try
    OleCheck(FReObject.poleobj.DoVerb(OLEIVERB_SHOW, nil, FReObject.polesite,
      0, FRichEdit.Handle, FRichEdit.ClientRect));
  except
    Application.HandleException(FRichEdit);
  end;
  Result := S_OK;
end;

function TOleUILinkInfo.SetLinkSource(dwLink: Longint; pszDisplayName: PChar;
  lenFileName: Longint; var chEaten: Longint;
  fValidateSource: BOOL): HRESULT;
var
  DisplayName: string;
  Buffer: array [0..255] of WideChar;
begin
  Result := E_FAIL;
  if fValidateSource then
  begin
    DisplayName := pszDisplayName;
    if Succeeded(FOleLink.SetSourceDisplayName(StringToWideChar(DisplayName,
      Buffer, SizeOf(Buffer) div 2))) then
    begin
      chEaten := Length(DisplayName);
      try
        OleCheck(FReObject.poleobj.Update);
      except
        Application.HandleException(FRichEdit);
      end;
      Result := S_OK;
    end;
  end
  else
    LinkError(SInvalidLinkSource);
end;

function TOleUILinkInfo.SetLinkUpdateOptions(dwLink: Longint;
  dwUpdateOpt: Longint): HRESULT;
begin
  Result := FOleLink.SetUpdateOptions(dwUpdateOpt);
  if Succeeded(Result) then
    FRichEdit.Modified := True;
end;

function TOleUILinkInfo.UpdateLink(dwLink: Longint; fErrorMessage: BOOL;
  fErrorAction: BOOL): HRESULT;
begin
  try
    OleCheck(FReObject.poleobj.Update);
  except
    Application.HandleException(FRichEdit);
  end;
  Result := S_OK;
end;

//=== TOleUIObjInfo ==========================================================

function TOleUIObjInfo.ConvertObject(dwObject: Longint;
  const clsidNew: TCLSID): HRESULT;
begin
  Result := E_NOTIMPL;
end;

constructor TOleUIObjInfo.Create(ARichEdit: TJvCustomRichEdit;
  ReObject: TReObject);
begin
  inherited Create;
  FRichEdit := ARichEdit;
  FReObject := ReObject;
end;

function TOleUIObjInfo.GetConvertInfo(dwObject: Longint; var ClassID: TCLSID;
  var wFormat: Word; var ConvertDefaultClassID: TCLSID;
  var lpClsidExclude: PCLSID; var cClsidExclude: Longint): HRESULT;
begin
  FReObject.poleobj.GetUserClassID(ClassID);
  Result := S_OK;
end;

function TOleUIObjInfo.GetObjectInfo(dwObject: Longint;
  var dwObjSize: Longint; var lpszLabel: PChar;
  var lpszType: PChar; var lpszShortType: PChar;
  var lpszLocation: PChar): HRESULT;
begin
  if @dwObjSize <> nil then
    dwObjSize := -1; { Unknown size }
  if @lpszLabel <> nil then
    lpszLabel := CoAllocCStr(GetFullNameStr(FReObject.poleobj));
  if @lpszType <> nil then
    lpszType := CoAllocCStr(GetFullNameStr(FReObject.poleobj));
  if @lpszShortType <> nil then
    lpszShortType := CoAllocCStr(GetShortNameStr(FReObject.poleobj));
  if @lpszLocation <> nil then
  begin
    if Trim(FRichEdit.Title) <> '' then
      lpszLocation := CoAllocCStr(Format('%s - %s',
        [FRichEdit.Title, Application.Title]))
    else
      lpszLocation := CoAllocCStr(Application.Title);
  end;
  Result := S_OK;
end;

function TOleUIObjInfo.GetViewInfo(dwObject: Longint; var hMetaPict: HGLOBAL;
  var dvAspect: Longint; var nCurrentScale: Integer): HRESULT;
begin
  if @hMetaPict <> nil then
    hMetaPict := GetIconMetaPict(FReObject.poleobj, FReObject.dvAspect);
  if @dvAspect <> nil then
    dvAspect := FReObject.dvAspect;
  if @nCurrentScale <> nil then
    nCurrentScale := 0;
  Result := S_OK;
end;

function TOleUIObjInfo.SetViewInfo(dwObject: Longint; hMetaPict: HGLOBAL;
  dvAspect: Longint; nCurrentScale: Integer;
  bRelativeToOrig: BOOL): HRESULT;
var
  Iconic: Boolean;
begin
  if Assigned(FRichEdit.FRichEditOle) then
  begin
    case dvAspect of
      DVASPECT_CONTENT:
        Iconic := False;
      DVASPECT_ICON:
        Iconic := True;
    else
      Iconic := FReObject.dvAspect = DVASPECT_ICON;
    end;
    IRichEditOle(FRichEdit.FRichEditOle).InPlaceDeactivate;
    Result := OleSetDrawAspect(FReObject.poleobj, Iconic, hMetaPict,
      FReObject.dvAspect);
    if Succeeded(Result) then
      IRichEditOle(FRichEdit.FRichEditOle).SetDvaspect(
        Longint(REO_IOB_SELECTION), FReObject.dvAspect);
  end
  else
    Result := E_NOTIMPL;
end;

//=== TRichEditOleCallback ===================================================

procedure TRichEditOleCallback.AssignFrame;
begin
  if (GetParentForm(FRichEdit) <> nil) and not Assigned(FFrameForm) and
    FRichEdit.AllowInPlace then
  begin
    FDocForm := GetVCLFrameForm(ValidParentForm(FRichEdit));
    FFrameForm := FDocForm;
    if IsFormMDIChild(FDocForm.Form) then
      FFrameForm := GetVCLFrameForm(Application.MainForm);
  end;
end;

function TRichEditOleCallback.ContextSensitiveHelp(fEnterMode: BOOL): HRESULT;
begin
  Result := NOERROR;
end;

constructor TRichEditOleCallback.Create(ARichEdit: TJvCustomRichEdit);
begin
  inherited Create;
  FRichEdit := ARichEdit;
end;

procedure TRichEditOleCallback.CreateAccelTable;
var
  Menu: TMainMenu;
begin
  if (FAccelTable = 0) and Assigned(FFrameForm) then
  begin
    Menu := FFrameForm.Form.Menu;
    if Menu <> nil then
      Menu.GetOle2AcceleratorTable(FAccelTable, FAccelCount, [0, 2, 4]);
  end;
end;

function TRichEditOleCallback.DeleteObject(const oleobj: IOleObject): HRESULT;
begin
  if Assigned(oleobj) then
    oleobj.Close(OLECLOSE_NOSAVE);
  Result := NOERROR;
end;

destructor TRichEditOleCallback.Destroy;
begin
  DestroyAccelTable;
  FFrameForm := nil;
  FDocForm := nil;
  inherited Destroy;
end;

procedure TRichEditOleCallback.DestroyAccelTable;
begin
  if FAccelTable <> 0 then
  begin
    DestroyAcceleratorTable(FAccelTable);
    FAccelTable := 0;
    FAccelCount := 0;
  end;
end;

function TRichEditOleCallback.GetClipboardData(const chrg: TCharRange; reco: DWORD;
  out dataObj: IDataObject): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TRichEditOleCallback.GetContextMenu(seltype: Word;
  const oleobj: IOleObject; const chrg: TCharRange; out Menu: HMENU): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TRichEditOleCallback.GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD;
  var dwEffect: DWORD): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TRichEditOleCallback.GetInPlaceContext(out Frame: IOleInPlaceFrame; out Doc: IOleInPlaceUIWindow;
  lpFrameInfo: POleInPlaceFrameInfo): HRESULT;
begin
  AssignFrame;
  if Assigned(FFrameForm) and FRichEdit.AllowInPlace then
  begin
    Frame := FFrameForm;
    Doc := FDocForm;
    CreateAccelTable;
    with lpFrameInfo^ do
    begin
      fMDIApp := False;
      FFrameForm.GetWindow(hWndFrame);
      hAccel := FAccelTable;
      cAccelEntries := FAccelCount;
    end;
    Result := S_OK;
  end
  else
    Result := E_NOTIMPL;
end;

function TRichEditOleCallback.GetNewStorage(out stg: IStorage): HRESULT;
begin
  try
    CreateStorage(stg);
    Result := S_OK;
  except
    Result := E_OUTOFMEMORY;
  end;
end;

function TRichEditOleCallback.QueryAcceptData(const dataObj: IDataObject;
  var cfFormat: TClipFormat; reco: DWORD; fReally: BOOL;
  hMetaPict: HGLOBAL): HRESULT;
begin
  Result := S_OK;
end;

function TRichEditOleCallback.QueryInsertObject(const clsid: TCLSID; const stg: IStorage;
  cp: Longint): HRESULT;
begin
  Result := NOERROR;
end;

function TRichEditOleCallback.QueryInterface(const iid: TGUID; out Obj): HRESULT;
begin
  if GetInterface(iid, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TRichEditOleCallback.ShowContainerUI(fShow: BOOL): HRESULT;
begin
  if not fShow then
    AssignFrame;
  if Assigned(FFrameForm) then
  begin
    if fShow then
    begin
      FFrameForm.SetMenu(0, 0, 0);
      FFrameForm.ClearBorderSpace;
      FRichEdit.SetUIActive(False);
      DestroyAccelTable;
      TForm(FFrameForm.Form).AutoScroll := FAutoScroll;
      FFrameForm := nil;
      FDocForm := nil;
    end
    else
    begin
      FAutoScroll := TForm(FFrameForm.Form).AutoScroll;
      TForm(FFrameForm.Form).AutoScroll := False;
      FRichEdit.SetUIActive(True);
    end;
    Result := S_OK;
  end
  else
    Result := E_NOTIMPL;
end;

function TRichEditOleCallback._AddRef: Longint;
begin
  Inc(FRefCount);
  Result := FRefCount;
end;

function TRichEditOleCallback._Release: Longint;
begin
  Dec(FRefCount);
  Result := FRefCount;
end;

{ Initialization part }

var
  FLibHandle: THandle;
  OldError: Longint;
  Ver: TOsVersionInfo;

initialization
  RichEditVersion := 1;
  OldError := SetErrorMode(SEM_NOOPENFILEERRORBOX);
  try
    {$IFNDEF RICHEDIT_VER_10}
    FLibHandle := LoadLibrary(RichEdit20ModuleName);
    if (FLibHandle > 0) and (FLibHandle < HINSTANCE_ERROR) then
      FLibHandle := 0;
    {$ELSE}
    FLibHandle := 0;
    {$ENDIF}
    if FLibHandle = 0 then
    begin
      FLibHandle := LoadLibrary(RichEdit10ModuleName);
      if (FLibHandle > 0) and (FLibHandle < HINSTANCE_ERROR) then
        FLibHandle := 0;
    end
    else
    begin
      RichEditVersion := 2;
      Ver.dwOSVersionInfoSize := SizeOf(Ver);
      GetVersionEx(Ver);
      with Ver do
      begin
        if (dwPlatformId = VER_PLATFORM_WIN32_NT) and
          (dwMajorVersion >= 5) then
          RichEditVersion := 3;
      end;
    end;
  finally
    SetErrorMode(OldError);
  end;

  GConversionFormatList := TConversionFormatList.Create;

  CFEmbeddedObject := RegisterClipboardFormat(CF_EMBEDDEDOBJECT);
  CFLinkSource := RegisterClipboardFormat(CF_LINKSOURCE);
  CFRtf := RegisterClipboardFormat(CF_RTF);
  CFRtfNoObjs := RegisterClipboardFormat(CF_RTFNOOBJS);

finalization
  if FLibHandle <> 0 then
    FreeLibrary(FLibHandle);
  FreeAndNil(GConversionFormatList);
end.
