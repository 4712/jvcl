{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvCharMap.PAS, released on 2003-11-03.

The Initial Developer of the Original Code is Peter Thornqvist.
Portions created by Peter Thornqvist are Copyright (c) 2003 Peter Thornqvist
All Rights Reserved.

Contributor(s):

Last Modified: 2003-11-03

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
* CharRange.Filter only works with contiguous ranges, so ufPrivateUse and ufSpecials
  only shows the first subrange

-----------------------------------------------------------------------------}
{$I JVCL.INC}
unit JvCharMap;

interface
uses
  Windows, Messages, Controls, SysUtils, Classes, Grids,
  JVCLVer;

type
  TJvCharMapValidateEvent = procedure(Sender: TObject; AChar: WideChar; var
    Valid: boolean) of object;
  TJvCharMapSelectedEvent = procedure(Sender: TObject; AChar: WideChar) of
    object;
  TJvCharMapUnicodeFilter = (
    ufUndefined,
    ufBasicLatin,
    ufLatin1Supplement,
    ufLatinExtendedA,
    ufLatinExtendedB,
    ufIPAExtensions,
    ufSpacingModifierLetters,
    ufCombiningDiacriticalMarks,
    ufGreek,
    ufCyrillic,
    ufArmenian,
    ufHebrew,
    ufArabic,
    ufSyriac,
    ufThaana,
    ufDevanagari,
    ufBengali,
    ufGurmukhi,
    ufGujarati,
    ufOriya,
    ufTamil,
    ufTelugu,
    ufKannada,
    ufMalayalam,
    ufSinhala,
    ufThai,
    ufLao,
    ufTibetan,
    ufMyanmar,
    ufGeorgian,
    ufHangulJamo,
    ufEthiopic,
    ufCherokee,
    ufUnifiedCanadianAboriginalSyllabics,
    ufOgham,
    ufRunic,
    ufKhmer,
    ufMongolian,
    ufLatinExtendedAdditional,
    ufGreekExtended,
    ufGeneralPunctuation,
    ufSuperscriptsAndSubscripts,
    ufCurrencySymbols,
    ufCombiningMarksForSymbols,
    ufLetterlikeSymbols,
    ufNumberForms,
    ufArrows,
    ufMathematicalOperators,
    ufMiscellaneousTechnical,
    ufControlPictures,
    ufOpticalCharacterRecognition,
    ufEnclosedAlphanumerics,
    ufBoxDrawing,
    ufBlockElements,
    ufGeometricShapes,
    ufMiscellaneousSymbols,
    ufDingbats,
    ufBraillePatterns,
    ufCJKRadicalsSupplement,
    ufKangxiRadicals,
    ufIdeographicDescriptionCharacters,
    ufCJKSymbolsAndPunctuation,
    ufHiragana,
    ufKatakana,
    ufBopomofo,
    ufHangulCompatibilityJamo,
    ufKanbun,
    ufBopomofoExtended,
    ufEnclosedCJKLettersAndMonths,
    ufCJKCompatibility,
    ufCJKUnifiedIdeographsExtensionA,
    ufCJKUnifiedIdeographs,
    ufYiSyllables,
    ufYiRadicals,
    ufHangulSyllables,
    ufHighSurrogates,
    ufHighPrivateUseSurrogates,
    ufLowSurrogates,
    ufPrivateUse,
    ufCJKCompatibilityIdeographs,
    ufAlphabeticPresentationForms,
    ufArabicPresentationFormsA,
    ufCombiningHalfMarks,
    ufCJKCompatibilityForms,
    ufSmallFormVariants,
    ufArabicPresentationFormsB,
    ufSpecials,
    ufHalfwidthAndFullwidthForms,
    ufOldItalic,
    ufGothic,
    ufDeseret,
    ufByzantineMusicalSymbols,
    ufMusicalSymbols,
    ufMathematicalAlphanumericSymbols,
    ufCJKUnifiedIdeographsExtensionB,
    ufCJKCompatibilityIdeographsSupplement,
    ufTags
    );

  TJvCharMapRange = class(TPersistent)
  private
    FFilterStart, FFilterEnd, FStartChar, FEndChar: Cardinal;
    FOnChange: TNotifyEvent;
    FFilter: TJvCharMapUnicodeFilter;
    procedure SetFilter(const Value: TJvCharMapUnicodeFilter);
    procedure SetEndChar(const Value: Cardinal);
    procedure SetStartChar(const Value: Cardinal);
    procedure Change;
    procedure SetRange(AStart, AEnd: Cardinal);
    function GetEndChar: Cardinal;
    function GetStartChar: Cardinal;
  public
    constructor Create;
  published
    // Setting Filter to ufUndefined, resets StartChar and EndChar to their previous values
    property Filter: TJvCharMapUnicodeFilter read FFilter write SetFilter default
      ufUndefined;
    property StartChar: Cardinal read GetStartChar write SetStartChar default
      33;
    property EndChar: Cardinal read GetEndChar write SetEndChar default 255;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

{$IFDEF COMPILER6_UP}
  TJvCustomCharMap = class(TCustomDrawGrid)
{$ELSE}
  TJvCustomCharMap = class(TCustomGrid)
{$ENDIF}
  private
    FCharPanel: TCustomControl;
    FShowZoomPanel: boolean;
    FAboutJVCL: TJVCLAboutInfo;
    FMouseIsDown: boolean;
    FCharRange: TJvCharMapRange;
    procedure SetCharRange(const Value: TJvCharMapRange);
    procedure SetPanelVisible(const Value: boolean);
    function GetCharacter: WideChar;
    function GetColumns: integer;
    procedure SetColumns(const Value: integer);
    procedure SetShowZoomPanel(const Value: boolean);
    function GetPanelVisible: boolean;
  private
    FAutoSizeHeight,
    FAutoSizeWidth,
    FDrawing: boolean;
    FLocale: LCID;
    FOnValidateChar: TJvCharMapValidateEvent;
    FShowShadow: boolean;
    FShadowSize: integer;
    FOnSelectChar: TJvCharMapSelectedEvent;
    FHighlightInvalid: boolean;
    procedure SetAutoSizeHeight(const Value: boolean);
    procedure SetAutoSizeWidth(const Value: boolean);
    procedure SetLocale(const Value: LCID);
    procedure SetShowShadow(const Value: boolean);
    procedure SetShadowSize(const Value: integer);
    procedure SetHighlightInvalid(const Value: boolean);
  protected
    procedure ShowCharPanel(ACol, ARow: integer); virtual;
    procedure RecalcCells; virtual;
    procedure AdjustSize; reintroduce;
    procedure CreateHandle; override;
    procedure DrawCell(ACol, ARow: Integer; ARect: TRect; AState:
      TGridDrawState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y:
      Integer);
      override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
      override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
      override;
    function InGridRange(ACol, ARow:integer):boolean;virtual;
    function InCharRange(AChar:WideChar):boolean;virtual;
    function SelectCell(ACol, ARow: Longint): Boolean; override;

    function GetChar(ACol, ARow: integer): WideChar; virtual;
    function GetCharInfo(ACol, ARow: integer; InfoType: Cardinal): Cardinal;
      overload; virtual;
    function GetCharInfo(AChar: WideChar; InfoType: Cardinal): Cardinal;
      overload; virtual;
    function IsValidChar(AChar: WideChar): boolean; virtual;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;

    procedure CMFontchanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure DoRangeChange(Sender: TObject);
    procedure DoSelectChar(AChar: WideChar); virtual;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd);
      message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CellSize: TSize;
{$IFNDEF COMPILER6_UP}
    procedure MouseToCell(X, Y: Integer; var ACol, ARow: Longint);
{$ENDIF}

    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight:
      Integer); override;
  protected
    // The locale to use when looking up character info and translating codepages to Unicode.
    // Only effective on non-NT OS's (NT doesn't use codepages)
    property Locale: LCID read FLocale write SetLocale default
      LOCALE_USER_DEFAULT;
    // The currently selected character
    property Character: WideChar read GetCharacter;
    // Shows/Hides the zoom panel
    property PanelVisible: boolean read GetPanelVisible write SetPanelVisible
      stored false;
    // Determines whether the zoom panel is automatically shown when the user clicks a cell in the grid
    // To actually show the zoom panel, set PanelVisible := true at run-time (or click a cell in the grid)
    property ShowZoomPanel: boolean read FShowZoomPanel write SetShowZoomPanel
      default true;

    // Determines whether the zoom panel has a shadow or not
    property ShowShadow: boolean read FShowShadow write SetShowShadow default
      true;
    // Determines the number of pixels the shadow is offset from the zoom panel.
    // On W2k/XP and with D6+, the shadow is alpha blended (semi-transparent)
    property ShadowSize: integer read FShadowSize write SetShadowSize default 2;

    // The range of characters to dispay in the grid
    property CharRange: TJvCharMapRange read FCharRange write SetCharRange;
    // Determines whether the width of the grid is auto adjusted to it' s content
    property AutoSizeWidth: boolean read FAutoSizeWidth write SetAutoSizeWidth
      default false;
    // Determines whether the height of the grid is auto adjusted to it' s content
    property AutoSizeHeight: boolean read FAutoSizeHeight write SetAutoSizeHeight
      default false;
    // The number of columns in the grid. Rows are adjusted automatically. Min. value is 1
    property Columns: integer read GetColumns write SetColumns default 20;
    property HighlightInvalid:boolean read FHighlightInvalid write SetHighlightInvalid default true;
    // Event that is called every time the grid needs to check if a character is valid.
    // If the character is invalid, it won't be drawn
    property OnValidateChar: TJvCharMapValidateEvent read FOnValidateChar write
      FOnValidateChar;
    // Event that is called every time the selection has changed
    property OnSelectChar: TJvCharMapSelectedEvent read FOnSelectChar write
      FOnSelectChar;
  published
    property AboutJVCL: TJVCLAboutInfo read FAboutJVCL write FAboutJVCL stored
      False;
  end;

  TJvCharMap = class(TJvCustomCharMap)
  public
    property Character;
    property PanelVisible;
    property Locale;
  published
    property AutoSizeWidth;
    property AutoSizeHeight;
    property CharRange;
    property Col;
    property Columns;
    property HighlightInvalid;
    property Row;
    property ShowZoomPanel;
    property ShowShadow;
    property ShadowSize;

    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property DoubleBuffered default true;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property Visible;

    property OnValidateChar;
    property OnSelectChar;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
{$IFDEF COMPILER6_UP}
    property OnTopLeftChanged;
{$ENDIF}
    property OnEndDock;
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
    property OnStartDock;
    property OnStartDrag;
    property OnResize;
  end;

implementation
uses
  Forms, Graphics;

const
  cShadowAlpha = 100;

type
  TAccessCanvas = class(TCanvas);

procedure WideDrawText(Canvas: TCanvas; const Text: WideString; ARect: TRect;
  uFormat: Cardinal);
begin
  // (p3) TAccessCanvas bit stolen from Troy Wolbrink's TNT controls (not that it makes any difference AFAICS)
  with TAccessCanvas(Canvas) do
  begin
    Changing;
    RequiredState([csHandleValid, csFontValid, csBrushValid]);
    if CanvasOrientation = coRightToLeft then
      Inc(uFormat, DT_RTLREADING);
    DrawTextW(Handle, PWideChar(Text), Length(Text), ARect, uFormat);
    Changed;
  end;
end;

type
  TShadowWindow = class(TCustomControl)
  private
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;

  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateHandle; override;
    procedure CMVisiblechanged(var Message: TMessage);
      message CM_VISIBLECHANGED;
  public
    property Visible default false;
    property Color default clBlack;
    constructor Create(AOwner: TComponent); override;
  end;

  TCharZoomPanel = class(TCustomControl)
  private
    FShadow: TShadowWindow;
    FCharacter: WideChar;
    FEndChar: Cardinal;
    FOldWndProc: TWndMethod;
    FWasVisible: boolean;
    FShowShadow: boolean;
    FShadowSize: integer;
    procedure SetCharacter(const Value: WideChar);
    procedure FormWindowProc(var Message: TMessage);
    procedure HookWndProc;
    procedure UnhookWndProc;
    procedure UpdateShadow;
    procedure SetShowShadow(const Value: boolean);
    procedure SetShadowSize(const Value: integer);
  protected

    procedure Paint; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure CMVisiblechanged(var Message: TMessage); message
      CM_VISIBLECHANGED;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure CMFontchanged(var Message: TMessage); message CM_FONTCHANGED;

    procedure CreateHandle; override;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged);
      message WM_WINDOWPOSCHANGED;
    procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Character: WideChar read FCharacter write SetCharacter;
    property ShowShadow: boolean read FShowShadow write SetShowShadow default
      true;
    property ShadowSize: integer read FShadowSize write SetShadowSize;
  end;

  { TShadowWindow }

procedure TShadowWindow.CreateHandle;
begin
  inherited;
{$IFDEF COMPILER6_UP}
  if HandleAllocated then
  begin
    SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or
      WS_EX_LAYERED);
    SetLayeredWindowAttributes(Handle, 0, cShadowAlpha, LWA_ALPHA);
  end;
{$ENDIF COMPILER6_UP}
end;

constructor TShadowWindow.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := [csFixedHeight, csFixedWidth, csNoDesignVisible,
    csNoStdEvents];
  Color := clBlack;
  Visible := false;
end;

procedure TShadowWindow.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    Style := WS_POPUP;
    ExStyle := WS_EX_TOOLWINDOW;
  end;
end;

procedure TShadowWindow.WMNCHitTest(var Message: TWMNCHitTest);
begin
  Message.Result := HTTRANSPARENT;
end;

procedure TShadowWindow.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  // make sure shadow is beneath zoom panel
  if Visible and (Parent <> nil) then
    SetWindowPos(Handle, TWinControl(Owner).Handle, 0, 0, 0, 0, SWP_NOACTIVATE
      or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOOWNERZORDER);
end;

{ TJvCustomCharMap }

procedure TJvCustomCharMap.AdjustSize;
var
  AWidth, AHeight: integer;
begin
  if HandleAllocated and (ColCount > 0) and (RowCount > 0) then
  begin
    AWidth := DefaultColWidth * (ColCount) + ColCount;
    AHeight := DefaultRowHeight * (RowCount) + RowCount;
    if AutoSizeWidth and (ClientWidth <> AWidth) and (Align in [alNone, alLeft,
      alRight]) then
      ClientWidth := AWidth;
    if AutoSizeHeight and (ClientHeight <> AHeight) and (Align in [alNone,
      alTop, alBottom]) then
      ClientHeight := AHeight;
  end;
end;

function TJvCustomCharMap.CellSize: TSize;
begin
  Result.cx := DefaultColWidth;
  Result.cy := DefaultRowHeight;
end;

procedure TJvCustomCharMap.CMFontchanged(var Message: TMessage);
begin
  inherited;
  if AutoSize then AdjustSize;
  RecalcCells;
end;

constructor TJvCustomCharMap.Create(AOwner: TComponent);
begin
  inherited;
  DoubleBuffered := true;
  //  DefaultDrawing := false;
  //  VirtualView := true;

  FCharRange := TJvCharMapRange.Create;
  //  FCharRange.Filter := ufUndefined;
  //  FCharRange.SetRange($21,$FF);
  FCharRange.OnChange := DoRangeChange;
  FCharPanel := TCharZoomPanel.Create(self);
  FCharPanel.Visible := false;
  FCharPanel.Parent := self;

  Options := [goVertLine, goHorzLine, {goDrawFocusSelected, } goThumbTracking];
  FShowZoomPanel := true;
  DefaultRowHeight := abs(Font.Height) + 12;
  DefaultColWidth := DefaultRowHeight - 5;
  FLocale := LOCALE_USER_DEFAULT;
  FShowShadow := true;
  FShadowSize := 2;
  FHighlightInvalid := true;
  Columns := 20;
end;

procedure TJvCustomCharMap.CreateHandle;
begin
  inherited;
  RecalcCells;
end;

destructor TJvCustomCharMap.Destroy;
begin
  FCharRange.Free;
  inherited;
end;

function TJvCustomCharMap.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  // ignore the return value, because inherited always returns true
  inherited DoMouseWheelDown(Shift, MousePos);
  Result := PanelVisible and SelectCell(Col, Row);
  if Result then
    ShowCharPanel(Col, Row);
  Result := true;
end;

function TJvCustomCharMap.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  // ignore the return value, because inherited always returns true
  inherited DoMouseWheelUp(Shift, MousePos);
  Result := PanelVisible and SelectCell(Col, Row);
  if Result then
    ShowCharPanel(Col, Row);
  Result := true;
end;

procedure TJvCustomCharMap.DoRangeChange(Sender: TObject);
begin
  TCharZoomPanel(FCharPanel).FEndChar := CharRange.EndChar;
  RecalcCells;
end;

procedure TJvCustomCharMap.DoSelectChar(AChar: WideChar);
begin
  if Assigned(FOnSelectChar) then
    FOnSelectChar(self, AChar);
end;

procedure TJvCustomCharMap.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var
  AChar: WideChar;
  LineColor:TColor;
begin
  if FDrawing then Exit;
  FDrawing := true;
  try
{$IFDEF COMPILER6_UP}
  inherited;
{$ENDIF}
  AChar := GetChar(ACol, ARow);
  Canvas.Brush.Color := Color;
  Canvas.Font := Font;
  Canvas.Pen.Color := Font.Color;
  if SelectCell(ACol, ARow) and IsValidChar(AChar) then
  begin
    if AState * [gdSelected, gdFocused] <> [] then
    begin
      Canvas.Pen.Color := Font.Color;
      if not ShowZoomPanel then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.FillRect(ARect);
      end;
      InflateRect(ARect, -1, -1);
      Canvas.Rectangle(ARect);
      InflateRect(ARect, 1, 1);
    end
    else
      Canvas.FillRect(ARect);
    if not ShowZoomPanel and (AState * [gdSelected, gdFocused] <> []) then
      Canvas.Font.Color := clHighlightText;
    SetBkMode(Canvas.Handle, Windows.TRANSPARENT);
    WideDrawText(Canvas, AChar, ARect, DT_SINGLELINE or DT_CENTER or DT_VCENTER
      or DT_NOPREFIX);
  end
  else if HighlightInvalid then
  begin
    LineColor := clSilver;
    if ColorToRGB(Color) = clSilver then
      LineColor := clGray;
    Canvas.Pen.Color := Color;
    Canvas.Brush.Color := LineColor;
    Canvas.Brush.Style := bsBDiagonal;
//    InflateRect(ARect,1,1);
    Canvas.Rectangle(ARect);
    Canvas.Brush.Style := bsSolid;
  end;
  finally
    FDrawing := false;
  end;
end;

function TJvCustomCharMap.GetChar(ACol, ARow: integer): WideChar;
begin
  if (ARow < 0) or (ACol < 0) then
    Result := WideChar(0)
  else
    Result := WideChar(CharRange.StartChar + Cardinal(ARow) * Cardinal(ColCount)
      + Cardinal(ACol));
end;

function TJvCustomCharMap.GetCharacter: WideChar;
begin
  Result := GetChar(Col, Row);
end;

function TJvCustomCharMap.GetCharInfo(ACol, ARow: integer; InfoType: Cardinal):
  Cardinal;
begin
  Result := GetCharInfo(GetChar(ACol, ARow), InfoType);
end;

function TJvCustomCharMap.GetCharInfo(AChar: WideChar; InfoType: Cardinal):
  Cardinal;
var
  ACharInfo: Cardinal;
begin
  ACharInfo := 0;
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    // Locale is ignored on NT platforms
    if GetStringTypeExW(0, InfoType, @AChar, 1, ACharInfo) then
      Result := ACharInfo
    else
      Result := 0;
  end
  else
  begin
    if GetStringTypeEx(Locale, InfoType, @AChar, 1, ACharInfo) then
      Result := ACharInfo
    else
      Result := 0;
  end;
end;

function TJvCustomCharMap.GetColumns: integer;
begin
  Result := ColCount;
end;

function TJvCustomCharMap.GetPanelVisible: boolean;
begin
  if (FCharPanel <> nil) and (Parent <> nil) and not (csDesigning in
    ComponentState) then
    Result := FCharPanel.Visible
  else
    Result := false;
end;

function TJvCustomCharMap.IsValidChar(AChar: WideChar): boolean;
var
  ACharInfo: Cardinal;
begin
  Result := false;
  if (AChar >= WideChar(CharRange.StartChar)) and (AChar <=
    WideChar(CharRange.EndChar)) then
  begin
    ACharInfo := GetCharInfo(AChar, CT_CTYPE1);
    Result := (ACharInfo <> 0); //  and (ACharInfo and C1_CNTRL <> C1_CNTRL);
  end;

  if Assigned(FOnValidateChar) then
    FOnValidateChar(self, AChar, Result);
end;

procedure TJvCustomCharMap.KeyDown(var Key: Word; Shift: TShiftState);
var
  ACol, ARow: integer;
begin
  // store previous location
  ACol := Col;
  ARow := Row;
  // update new location
  inherited;
  case Key of
    VK_RETURN:
      ShowCharPanel(Col, Row);
    VK_SPACE:
      if not (ssAlt in Shift) then
        PanelVisible := not PanelVisible;
    VK_ESCAPE:
      PanelVisible := false;
    VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_HOME, VK_END:
      if PanelVisible then
        ShowCharPanel(Col, Row);
    VK_LEFT:
      begin
        if (ACol = 0) and (ARow > 0) then
        begin
          ACol := ColCount - 1;
          Dec(ARow);
        end
        else
        begin
          ACol := Col;
          ARow := Row;
        end;
        Col := ACol;
        Row := ARow;
        if PanelVisible then
          ShowCharPanel(ACol, ARow);
      end;
    VK_RIGHT:
      begin
        if (ACol = ColCount - 1) and (ARow < RowCount - 1) then
        begin
          ACol := 0;
          Inc(ARow);
        end
        else
        begin
          ACol := Col;
          ARow := Row;
        end;
        Col := ACol;
        Row := ARow;
        if PanelVisible then
          ShowCharPanel(ACol, ARow);
      end;
  end;
end;

procedure TJvCustomCharMap.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X,
  Y: Integer);
var
  GC: TGridCoord;
  ACol, ARow: integer;
begin
  inherited;
  //  MouseCapture := true;
  if Button = mbLeft then
  begin
    FMouseIsDown := true;
    GC := MouseCoord(X, Y);
    MouseToCell(X, Y, ACol, ARow);
    if SelectCell(ACol, ARow) then
      ShowCharPanel(ACol, ARow)
    else
      if SelectCell(Col, Row) then
        ShowCharPanel(Col, Row);
  end;
end;

procedure TJvCustomCharMap.MouseMove(Shift: TShiftState; X, Y: Integer);
//var
//  ACol, ARow: integer;
begin
  inherited;
  {  if (csLButtonDown in ControlState) then
    begin
      MouseToCell(X, Y, ACol, ARow);
      if SelectCell(ACol, ARow) then
        ShowCharPanel(ACol, ARow);
    end;}
end;

{$IFNDEF COMPILER6_UP}

procedure TJvCustomCharMap.MouseToCell(X, Y: Integer; var ACol,
  ARow: Integer);
var
  Coord: TGridCoord;
begin
  Coord := MouseCoord(X, Y);
  ACol := Coord.X;
  ARow := Coord.Y;
end;
{$ENDIF}

procedure TJvCustomCharMap.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  ACol, ARow: integer;
begin
  inherited;
  if (Button = mbLeft) and FMouseIsDown then
  begin
    FMouseIsDown := false;
    MouseToCell(X, Y, ACol, ARow);
    if SelectCell(ACol, ARow) then
      ShowCharPanel(ACol, ARow)
    else
      if SelectCell(Col, Row) then
        ShowCharPanel(Col, Row);
  end;
end;

function TJvCustomCharMap.InCharRange(AChar: WideChar): boolean;
begin
  Result := (AChar >= WideChar(CharRange.StartChar)) and (AChar <= WideChar(CharRange.EndChar));
end;

function TJvCustomCharMap.InGridRange(ACol, ARow: integer): boolean;
begin
  Result := (ACol >= 0) and (ARow >= 0) and (ACol < ColCount) and (ARow < RowCount);
end;

procedure TJvCustomCharMap.RecalcCells;
var
  ACells, ARows: integer;
begin
  if not HandleAllocated then Exit;
  FixedCols := 0;
  FixedRows := 0;
  ACells := Ord(CharRange.EndChar) - Ord(CharRange.StartChar);
  //  ColCount := 20;
  ARows := ACells div ColCount + 1;
  RowCount := ARows;
  DefaultRowHeight := abs(Font.Height) + 12;
  DefaultColWidth := DefaultRowHeight - 5;
  if AutoSizeWidth or AutoSizeHeight then
    AdjustSize;
  if PanelVisible then
    ShowCharPanel(Col, Row);
end;

function TJvCustomCharMap.SelectCell(ACol, ARow: Integer): Boolean;
var
  AChar, ANewChar: WideChar;
begin
  // get currently selected character
  AChar := GetChar(Col, Row);
  // can't use IsValidChar here since we need to be able to select invalid cells as well to be able to scroll
  ANewChar := WideChar(CharRange.StartChar + Cardinal(ARow) * Cardinal(ColCount) + Cardinal(ACol));
  Result := InGridRange(ACol,ARow) and InCharRange(ANewChar);

  if Result and not FDrawing then
  begin
    ANewChar := GetChar(ACol, ARow);
    if AChar <> ANewChar then
      DoSelectChar(ANewChar);
  end;
end;

procedure TJvCustomCharMap.SetAutoSizeHeight(const Value: boolean);
begin
  if FAutoSizeHeight <> Value then
  begin
    FAutoSizeHeight := Value;
    if FAutoSizeHeight then
      AdjustSize;
  end;
end;

procedure TJvCustomCharMap.SetAutoSizeWidth(const Value: boolean);
begin
  if FAutoSizeWidth <> Value then
  begin
    FAutoSizeWidth := Value;
    if FAutoSizeWidth then
      AdjustSize;
  end;
end;

procedure TJvCustomCharMap.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  RecalcCells;
  if HandleAllocated and PanelVisible and ((ClientHeight < DefaultRowHeight) or
    (ClientWidth < DefaultColWidth)) then
    PanelVisible := false;
end;

procedure TJvCustomCharMap.SetCharRange(const Value: TJvCharMapRange);
begin
  //  FCharRange := Value;
end;

procedure TJvCustomCharMap.SetColumns(const Value: integer);
begin
  if Value > 0 then
  begin
    ColCount := Value;
    RecalcCells;
  end;
end;

procedure TJvCustomCharMap.SetHighlightInvalid(const Value: boolean);
begin
  if FHighlightInvalid <> Value then
  begin
    FHighlightInvalid := Value;
    Invalidate;
  end;
end;

procedure TJvCustomCharMap.SetLocale(const Value: LCID);
begin
  if (FLocale <> Value) and IsValidLocale(Value, LCID_SUPPORTED) then
  begin
    FLocale := Value;
    Invalidate;
  end;
end;

procedure TJvCustomCharMap.SetPanelVisible(const Value: boolean);
begin
  if (PanelVisible <> Value) and not (csDesigning in ComponentState) then
  begin
    FCharPanel.Visible := Value;
  end;
end;

procedure TJvCustomCharMap.SetShadowSize(const Value: integer);
begin
  if FShadowSize <> Value then
  begin
    FShadowSize := Value;
    if FCharPanel <> nil then
      TCharZoomPanel(FCharPanel).ShadowSize := Value;
  end;
end;

procedure TJvCustomCharMap.SetShowShadow(const Value: boolean);
begin
  if FShowShadow <> Value then
  begin
    FShowShadow := Value;
    if FCharPanel <> nil then
      TCharZoomPanel(FCharPanel).ShowShadow := Value;
  end;
end;

procedure TJvCustomCharMap.SetShowZoomPanel(const Value: boolean);
begin
  if FShowZoomPanel <> Value then
  begin
    FShowZoomPanel := Value;
    if not FShowZoomPanel then
      PanelVisible := false;
  end;
end;

procedure TJvCustomCharMap.ShowCharPanel(ACol, ARow: integer);
var
  R: TRect;
  P: TPoint;
begin
  if not ShowZoomPanel or not SelectCell(ACol, ARow) then
  begin
    PanelVisible := false;
    Exit;
  end;
  R := CellRect(ACol, ARow);
  Selection := TGridRect(Rect(ACol, ARow, ACol, ARow));
{$IFDEF COMPILER6_UP}
  FocusCell(ACol, ARow, false);
{$ELSE}
  Col := ACol;
  Row := ARow;
{$ENDIF}
  TCharZoomPanel(FCharPanel).Character := GetChar(ACol, ARow);
  P.X := R.Left - (FCharPanel.Width - DefaultColWidth) div 2;
  P.Y := R.Top - (FCharPanel.Height - DefaultRowHeight) div 2;
  P := ClientToScreen(P);

  FCharPanel.Left := P.X;
  FCharPanel.Top := P.Y;
  if not PanelVisible then
    PanelVisible := true;
end;

procedure TJvCustomCharMap.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TJvCustomCharMap.WMHScroll(var Message: TWMHScroll);
begin
  inherited;
  if PanelVisible then
  begin
    if (Col < LeftCol) then
      ShowCharPanel(LeftCol, Row)
    else
      if Col >= LeftCol + VisibleColCount then
        ShowCharPanel(LeftCol + VisibleColCount - 1, Row)
      else
        ShowCharPanel(Col, Row);
  end;
end;

procedure TJvCustomCharMap.WMVScroll(var Message: TWMVScroll);
begin
  inherited;
  if PanelVisible then
  begin
    if (Row < TopRow) then
      ShowCharPanel(Col, TopRow)
    else
      if Row >= TopRow + VisibleRowCount then
        ShowCharPanel(Col, TopRow + VisibleRowCount - 1)
      else
        ShowCharPanel(Col, Row);
  end;
end;

{ TCharZoomPanel }

procedure TCharZoomPanel.CMFontchanged(var Message: TMessage);
begin
  inherited;
  // (p3) height should be quite larger than Font.Height and Width a little more than that
  Height := abs(Font.Height) * 4;
  Width := MulDiv(Height, 110, 100);
end;

procedure TCharZoomPanel.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  if Visible and CanFocus then
    SetFocus;
  if ShowShadow then
    FShadow.Visible := Visible
  else
    FShadow.Visible := false;
end;

constructor TCharZoomPanel.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csNoDesignVisible, csOpaque];
  SetBounds(0, 0, 52, 48);
  FShadow := TShadowWindow.Create(AOwner);
  ShowShadow := true;
  FShadowSize := 2;
end;

procedure TCharZoomPanel.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    Style := WS_BORDER or WS_POPUP;
    ExStyle := WS_EX_TOOLWINDOW;
  end;
end;

destructor TCharZoomPanel.Destroy;
begin
  UnHookWndProc;
  inherited;
end;

procedure TCharZoomPanel.HookWndProc;
var
  F: TCustomForm;
begin
  if not (csDesigning in ComponentState) and not Assigned(FOldWndProc) then
  begin
    F := GetParentForm(self);
    if F <> nil then
    begin
      FOldWndProc := F.WindowProc;
      F.WindowProc := FormWindowProc;
    end;
  end;
end;

procedure TCharZoomPanel.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      begin
        Visible := false;
        if Parent.CanFocus then Parent.SetFocus;
      end;
    VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN:
      TJvCustomCharMap(Parent).KeyDown(Key, Shift);
  else
    inherited;
  end;
end;

procedure TCharZoomPanel.FormWindowProc(var Message: TMessage);
begin
  FOldWndProc(Message);
  if not (csDestroying in ComponentState) then
  begin
    case Message.Msg of
      WM_MOVE:
        if Visible or FWasVisible then
          with TJvCharMap(Parent) do
            ShowCharPanel(Col, Row);
      WM_SYSCOMMAND:
        case Message.WParam and $FFF0 of
          SC_MINIMIZE:
            begin
              FWasVisible := Visible;
              Visible := false;
            end;
          SC_RESTORE, SC_MAXIMIZE:
            if (Visible or FWasVisible) and
              IsWindowVisible(GetParentForm(self).Handle) then
              with TJvCharMap(Parent) do
                ShowCharPanel(Col, Row);
        end;
      WM_WINDOWPOSCHANGED:
        if (Visible or FWasVisible) and
          IsWindowVisible(GetParentForm(self).Handle) then
          with TJvCharMap(Parent) do
            ShowCharPanel(Col, Row);
    end;
  end;
end;

procedure TCharZoomPanel.Paint;
var
  R: TRect;
  AChar: WideChar;
begin
  //  inherited;
  Canvas.Font := Font;
  Canvas.Font.Height := ClientHeight - 4;
  //  Canvas.Font.Style := [fsBold];
  Canvas.Brush.Color := Color;
  Canvas.Pen.Color := Font.Color;
  R := ClientRect;
  Canvas.Rectangle(R);

  //  R := Rect(0,0,Width,Height);
  SetBkMode(Canvas.Handle, Windows.TRANSPARENT);
  AChar := Character;
  if TJvCustomCharMap(Parent).IsValidChar(AChar) then
    WideDrawText(Canvas, AChar, R, DT_SINGLELINE or DT_CENTER or DT_VCENTER or
      DT_NOPREFIX);
end;

procedure TCharZoomPanel.SetCharacter(const Value: WideChar);
begin
  if FCharacter <> Value then
  begin
    FCharacter := Value;
    Invalidate;
  end;
end;

procedure TCharZoomPanel.UnhookWndProc;
var
  F: TCustomForm;
begin
  if not (csDesigning in ComponentState) and Assigned(FOldWndProc) then
  begin
    F := GetParentForm(self);
    if (F <> nil) then
      F.WindowProc := FOldWndProc;
  end;
end;

procedure TCharZoomPanel.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TCharZoomPanel.WMNCHitTest(var Message: TWMNCHitTest);
begin
  // pass mouse clicks to parent (the grid)
  Message.Result := HTTRANSPARENT;
end;

procedure TCharZoomPanel.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  Message.Result := 1;
  if not (csDestroying in ComponentState) and Parent.CanFocus then
    Parent.SetFocus;
end;

procedure TCharZoomPanel.CreateHandle;
begin
  inherited;
  HookWndProc;
end;

procedure TCharZoomPanel.WMWindowPosChanged(
  var Message: TWMWindowPosChanged);
begin
  inherited;
  UpdateShadow;
end;

procedure TCharZoomPanel.SetParent(AParent: TWinControl);
begin
  inherited;
  if not (csDestroying in ComponentState) then
  begin
    if FShadow <> nil then
      FShadow.Parent := AParent;
    UpdateShadow;
  end;
end;

procedure TCharZoomPanel.SetShowShadow(const Value: boolean);
begin
  if FShowShadow <> Value then
  begin
    FShowShadow := Value;
    UpdateShadow;
  end;
end;

procedure TCharZoomPanel.UpdateShadow;
var
  R: TRect;
begin
  if HandleAllocated and (FShadow <> nil) and (FShadow.Parent <> nil) then
  begin
    if ShowShadow then
    begin
      R := BoundsRect;
      OffsetRect(R, ShadowSize, ShadowSize);
      FShadow.BoundsRect := R;
      FShadow.Visible := Visible;
    end
    else
      FShadow.Visible := false;
  end;
end;

procedure TCharZoomPanel.SetShadowSize(const Value: integer);
begin
  if FShadowSize <> Value then
  begin
    FShadowSize := Value;
    UpdateShadow;
  end;
end;

{ TJvCharMapRange }

procedure TJvCharMapRange.Change;
begin
  if Assigned(FOnChange) then FOnChange(self);
end;

constructor TJvCharMapRange.Create;
begin
  inherited;
  FFilter := ufUndefined;
  FStartChar := 33;
  FEndChar := 255;
end;

function TJvCharMapRange.GetEndChar: Cardinal;
begin
  if Filter = ufUndefined then
    Result := FEndChar
  else
    Result := FFilterEnd;
end;

function TJvCharMapRange.GetStartChar: Cardinal;
begin
  if Filter = ufUndefined then
    Result := FStartChar
  else
    Result := FFilterStart;
end;

procedure TJvCharMapRange.SetEndChar(const Value: Cardinal);
begin
  if FEndChar <> Value then
  begin
    FEndChar := Value;
    if Filter = ufUndefined then
      Change;
  end;
end;

procedure TJvCharMapRange.SetFilter(const Value: TJvCharMapUnicodeFilter);
begin
  if FFilter <> Value then
  begin
    FFilter := Value;
    case Value of
      ufBasicLatin:
        SetRange($0000, $007F);
      ufLatin1Supplement:
        SetRange($0080, $00FF);
      ufLatinExtendedA:
        SetRange($0100, $017F);
      ufLatinExtendedB:
        SetRange($0180, $024F);
      ufIPAExtensions:
        SetRange($0250, $02AF);
      ufSpacingModifierLetters:
        SetRange($02B0, $02FF);
      ufCombiningDiacriticalMarks:
        SetRange($0300, $036F);
      ufGreek:
        SetRange($0370, $03FF);
      ufCyrillic:
        SetRange($0400, $04FF);
      ufArmenian:
        SetRange($0530, $058F);
      ufHebrew:
        SetRange($0590, $05FF);
      ufArabic:
        SetRange($0600, $06FF);
      ufSyriac:
        SetRange($0700, $074F);
      ufThaana:
        SetRange($0780, $07BF);
      ufDevanagari:
        SetRange($0900, $097F);
      ufBengali:
        SetRange($0980, $09FF);
      ufGurmukhi:
        SetRange($0A00, $0A7F);
      ufGujarati:
        SetRange($0A80, $0AFF);
      ufOriya:
        SetRange($0B00, $0B7F);
      ufTamil:
        SetRange($0B80, $0BFF);
      ufTelugu:
        SetRange($0C00, $0C7F);
      ufKannada:
        SetRange($0C80, $0CFF);
      ufMalayalam:
        SetRange($0D00, $0D7F);
      ufSinhala:
        SetRange($0D80, $0DFF);
      ufThai:
        SetRange($0E00, $0E7F);
      ufLao:
        SetRange($0E80, $0EFF);
      ufTibetan:
        SetRange($0F00, $0FFF);
      ufMyanmar:
        SetRange($1000, $109F);
      ufGeorgian:
        SetRange($10A0, $10FF);
      ufHangulJamo:
        SetRange($1100, $11FF);
      ufEthiopic:
        SetRange($1200, $137F);
      ufCherokee:
        SetRange($13A0, $13FF);
      ufUnifiedCanadianAboriginalSyllabics:
        SetRange($1400, $167F);
      ufOgham:
        SetRange($1680, $169F);
      ufRunic:
        SetRange($16A0, $16FF);
      ufKhmer:
        SetRange($1780, $17FF);
      ufMongolian:
        SetRange($1800, $18AF);
      ufLatinExtendedAdditional:
        SetRange($1E00, $1EFF);
      ufGreekExtended:
        SetRange($1F00, $1FFF);
      ufGeneralPunctuation:
        SetRange($2000, $206F);
      ufSuperscriptsAndSubscripts:
        SetRange($2070, $209F);
      ufCurrencySymbols:
        SetRange($20A0, $20CF);
      ufCombiningMarksForSymbols:
        SetRange($20D0, $20FF);
      ufLetterlikeSymbols:
        SetRange($2100, $214F);
      ufNumberForms:
        SetRange($2150, $218F);
      ufArrows:
        SetRange($2190, $21FF);
      ufMathematicalOperators:
        SetRange($2200, $22FF);
      ufMiscellaneousTechnical:
        SetRange($2300, $23FF);
      ufControlPictures:
        SetRange($2400, $243F);
      ufOpticalCharacterRecognition:
        SetRange($2440, $245F);
      ufEnclosedAlphanumerics:
        SetRange($2460, $24FF);
      ufBoxDrawing:
        SetRange($2500, $257F);
      ufBlockElements:
        SetRange($2580, $259F);
      ufGeometricShapes:
        SetRange($25A0, $25FF);
      ufMiscellaneousSymbols:
        SetRange($2600, $26FF);
      ufDingbats:
        SetRange($2700, $27BF);
      ufBraillePatterns:
        SetRange($2800, $28FF);
      ufCJKRadicalsSupplement:
        SetRange($2E80, $2EFF);
      ufKangxiRadicals:
        SetRange($2F00, $2FDF);
      ufIdeographicDescriptionCharacters:
        SetRange($2FF0, $2FFF);
      ufCJKSymbolsAndPunctuation:
        SetRange($3000, $303F);
      ufHiragana:
        SetRange($3040, $309F);
      ufKatakana:
        SetRange($30A0, $30FF);
      ufBopomofo:
        SetRange($3100, $312F);
      ufHangulCompatibilityJamo:
        SetRange($3130, $318F);
      ufKanbun:
        SetRange($3190, $319F);
      ufBopomofoExtended:
        SetRange($31A0, $31BF);
      ufEnclosedCJKLettersAndMonths:
        SetRange($3200, $32FF);
      ufCJKCompatibility:
        SetRange($3300, $33FF);
      ufCJKUnifiedIdeographsExtensionA:
        SetRange($3400, $4DB5);
      ufCJKUnifiedIdeographs:
        SetRange($4E00, $9FFF);
      ufYiSyllables:
        SetRange($A000, $A48F);
      ufYiRadicals:
        SetRange($A490, $A4CF);
      ufHangulSyllables:
        SetRange($AC00, $D7A3);
      ufHighSurrogates:
        SetRange($D800, $DB7F);
      ufHighPrivateUseSurrogates:
        SetRange($DB80, $DBFF);
      ufLowSurrogates:
        SetRange($DC00, $DFFF);
      ufPrivateUse:
        SetRange($E000, $F8FF);
      //      $E000..$F8FF, $F0000..$FFFFD, $100000..$10FFFD;
      ufCJKCompatibilityIdeographs:
        SetRange($F900, $FAFF);
      ufAlphabeticPresentationForms:
        SetRange($FB00, $FB4F);
      ufArabicPresentationFormsA:
        SetRange($FB50, $FDFF);
      ufCombiningHalfMarks:
        SetRange($FE20, $FE2F);
      ufCJKCompatibilityForms:
        SetRange($FE30, $FE4F);
      ufSmallFormVariants:
        SetRange($FE50, $FE6F);
      ufArabicPresentationFormsB:
        SetRange($FE70, $FEFE);
      ufSpecials:
        //      $FEFF..$FEFF, $FFF0..$FFFD;
        SetRange($FFF0, $FFFD);
      ufHalfwidthAndFullwidthForms:
        SetRange($FF00, $FFEF);
      ufOldItalic:
        SetRange($10300, $1032F);
      ufGothic:
        SetRange($10330, $1034F);
      ufDeseret:
        SetRange($10400, $1044F);
      ufByzantineMusicalSymbols:
        SetRange($1D000, $1D0FF);
      ufMusicalSymbols:
        SetRange($1D100, $1D1FF);
      ufMathematicalAlphanumericSymbols:
        SetRange($1D400, $1D7FF);
      ufCJKUnifiedIdeographsExtensionB:
        SetRange($20000, $2A6D6);
      ufCJKCompatibilityIdeographsSupplement:
        SetRange($2F800, $2FA1F);
      ufTags:
        SetRange($E0000, $E007F);
    else
      SetRange(StartChar, EndChar);
    end;
  end;
end;

procedure TJvCharMapRange.SetRange(AStart, AEnd: Cardinal);
begin
  FFilterStart := AStart;
  FFilterEnd := AEnd;
  Change;
end;

procedure TJvCharMapRange.SetStartChar(const Value: Cardinal);
begin
  if FStartChar <> Value then
  begin
    FStartChar := Value;
    if Filter = ufUndefined then
      Change;
  end;
end;

end.

