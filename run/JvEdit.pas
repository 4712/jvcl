{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvNewEdit.PAS, released on 2002-mm-dd.

The Initial Developer of the Original Code is S�bastien Buysse [sbuysse@buypin.com]
Portions created by S�bastien Buysse are Copyright (C) 2001 S�bastien Buysse.
All Rights Reserved.

This unit is a merging of the original TJvEdit, TJvExEdit, TJvCaretEdit,TJvAlignedEdit,
TJvSingleLineMemo.
Merging done 2002-06-05 by Peter Thornqvist [peter3@peter3.com]

  MERGE NOTES:
    * TJvCustomEdit has been removed from JvComponent and put here instead.
    * The HotTrack property only works if BorderStyle := bsSingle and BevelKind := bvNone
    * Added ClipboardCommands

Contributor(s):
  Anthony Steele [asteele@iafrica.com]
  Peter Below [100113.1101@compuserve.com]
  Rob den Braasem [rbraasem@xs4all.nl] (GroupIndex property - using several TJvEdits with the same GroupIndex
    will clear the text from the other edits when something is typed into one of them.
    To disable GroupIndex, set it to -1)
  Andr� Snepvangers [asn@xs4all.nl] ( clx compatible version )

Last Modified: 2003-10-28

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
{$I jvcl.inc}

unit JvEdit;

interface

uses
  SysUtils, Classes,
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, StdCtrls, Forms, Menus,
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  Qt, QTypes, QGraphics, QControls, QStdCtrls, QDialogs, QForms, QMenus, Types,
  QWindows,
  {$ENDIF VisualCLX}
  JvCaret, JvMaxPixel, JvTypes, JvComponent, JvToolEdit,
  JvExControls, JvExStdCtrls;

{$IFDEF VisualCLX}
const
  clGrayText = clDark; // (ahuser) This is wrong in QGraphics.
                       //          Since when is clGrayText = clLight = clWhite?
{$ENDIF VisualCLX}

type
  TJvCustomEdit = class(TJvExCustomEdit)
  private
    FOver: Boolean;
    FColor: TColor;
    FSaved: TColor;
    FFlat: Boolean;
    FOnParentColorChanged: TNotifyEvent;
    FMaxPixel: TJvMaxPixel;
    FGroupIndex: Integer;
    FAlignment: TAlignment;
    FCaret: TJvCaret;
    FHotTrack: Boolean;
    FDisabledColor: TColor;
    FDisabledTextColor: TColor;
    FProtectPassword: Boolean;
    FStreamedSelLength: Integer;
    FStreamedSelStart: Integer;
    FUseFixedPopup: Boolean;
    FAutoHint: boolean;
    FOldHint:string;
    {$IFDEF VisualCLX}
    FPasswordChar: Char;
    FNullPixmap: QPixmapH;
    {$ENDIF VisualCLX}
    function GetPasswordChar: Char;
    procedure SetAlignment(Value: TAlignment);
    procedure SetCaret(const Value: TJvCaret);
    procedure SetDisabledColor(const Value: TColor); virtual;
    procedure SetDisabledTextColor(const Value: TColor); virtual;
    procedure SetPasswordChar(Value: Char);
    procedure SetHotTrack(const Value: Boolean);
    {$IFDEF VCL}
    function GetText: TCaption;
    procedure SetText(const Value: TCaption);
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    {$ENDIF VCL}
    procedure SetGroupIndex(const Value: Integer);
    function GetFlat: Boolean;
    procedure SetAutoHint(const Value: boolean);
  protected
    procedure DoClipboardCut; override;
    procedure DoClipboardPaste; override;
    procedure DoClearText; override;
    procedure DoUndo; override;

    procedure UpdateEdit;
    procedure SetClipboardCommands(const Value: TJvClipboardCommands); override;
    procedure CaretChanged(Sender: TObject); dynamic;
    procedure Change; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MaxPixelChanged(Sender: TObject);
    procedure SetSelLength(Value: Integer); override;
    procedure SetSelStart(Value: Integer); override;
    function GetPopupMenu: TPopupMenu; override;

    {$IFDEF VisualCLX}
    procedure Paint; override;
    procedure TextChanged; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    {$ENDIF VisualCLX}
    procedure DoSetFocus(FocusedWnd: HWND); override;
    procedure DoKillFocus(FocusedWnd: HWND); override;
    function DoPaintBackground(Canvas: TCanvas; Param: Integer): Boolean; override;
    procedure EnabledChanged; override;
    procedure ParentColorChanged; override;
    procedure MouseEnter(AControl: TControl); override;
    procedure MouseLeave(AControl: TControl); override;
    procedure SetFlat(Value: Boolean); virtual;
    procedure UpdateAutoHint;dynamic;
    procedure Resize; override;
  public
    function IsEmpty: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {$IFDEF VCL}
    procedure DefaultHandler(var Msg); override;
    procedure CreateParams(var Params: TCreateParams); override;
    {$ENDIF VCL}
    procedure Loaded; override;
  protected
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property AutoHint:boolean read FAutoHint write SetAutoHint default false; 
    property Caret: TJvCaret read FCaret write SetCaret;
    property HotTrack: Boolean read FHotTrack write SetHotTrack default False;
    property PasswordChar: Char read GetPasswordChar write SetPasswordChar;
    // set to True to disable read/write of PasswordChar and read of Text
    property ProtectPassword: Boolean read FProtectPassword write FProtectPassword default False;
    property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor default clGrayText;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clWindow;
    {$IFDEF VCL}
    property Text: TCaption read GetText write SetText;
    {$ENDIF VCL}
    property UseFixedPopup: Boolean read FUseFixedPopup write FUseFixedPopup default True;
    property HintColor: TColor read FColor write FColor default clInfoBk;
    property MaxPixel: TJvMaxPixel read FMaxPixel write FMaxPixel;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
    property Flat: Boolean read GetFlat write SetFlat;
  end;

  TJvEdit = class(TJvCustomEdit)
  published
    {$IFDEF VCL}
    {$IFDEF COMPILER6_UP}
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    {$ENDIF COMPILER6_UP}
    property BiDiMode;
    property DragCursor;
    property DragKind;
    property ImeMode;
    property ImeName;
    property OEMConvert;
    property ParentBiDiMode;
    property UseFixedPopup; // asn: clx not implemented yet
    {$ENDIF VCL}
    property Caret;
    property DisabledTextColor;
    property DisabledColor;
    property HotTrack;
    property PasswordChar;
    property PopupMenu;
    property ProtectPassword;
    {$IFDEF VisualCLX}
    property EchoMode;
    property InputKeys;
    {$ENDIF VisualCLX}
    property Align;
    property Alignment;
    property ClipboardCommands;
    property HintColor;
    property GroupIndex;
    property MaxPixel;
    property Modified;
    // property SelStart; (p3) why published?
    // property SelText;
    // property SelLength; (p3) why published?
    property OnMouseEnter;
    property OnMouseLeave;
    property OnParentColorChange;

    property Anchors;
    property AutoSelect;
    property AutoSize;
    property AutoHint;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property MaxLength;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    {$IFDEF VCL}
    property OnEndDock;
    property OnStartDock;
    {$ENDIF VCL}
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
  end;

implementation

uses
  {$IFDEF VCL}
  JvFixedEditPopup,
  {$ENDIF VCL}
  Math;

constructor TJvCustomEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF VisualCLX}
  FNullPixmap := QPixmap_create(1, 1, 1, QPixmapOptimization_DefaultOptim);
  {$ENDIF VisualCLX}
  FColor := clInfoBk;
  FOver := False;
  FAlignment := taLeftJustify;
  // ControlStyle := ControlStyle + [csAcceptsControls];
  ClipboardCommands := [caCopy..caUndo];
  FDisabledColor := clWindow;
  FDisabledTextColor := clGrayText;
  FHotTrack := False;
  FCaret := TJvCaret.Create(Self);
  FCaret.OnChanged := CaretChanged;
  FStreamedSelLength := 0;
  FStreamedSelStart := 0;
  FUseFixedPopup := True;  // asn: clx not implemented yet
  FMaxPixel := TJvMaxPixel.Create(Self);
  FMaxPixel.OnChanged := MaxPixelChanged;
  FGroupIndex := -1;
end;

destructor TJvCustomEdit.Destroy;
begin
  FMaxPixel.Free;
  FCaret.Free;
  {$IFDEF VisualCLX}
  QPixmap_destroy(FNullPixmap);
  {$ENDIF VisualCLX}
  inherited Destroy;
end;

procedure TJvCustomEdit.Loaded;
begin
  inherited Loaded;
  SelStart := FStreamedSelStart;
  SelLength := FStreamedSelLength;
end;

procedure TJvCustomEdit.Change;
var
  St: string;
begin
  inherited Change;
  if not HasParent then
    Exit;
  St := Text;
  FMaxPixel.Test(St, Font);
  if St <> Text then
  begin
    Text := St;
    SelStart := Min(SelStart, Length(Text));
  end;
end;

{$IFDEF VCL}
procedure TJvCustomEdit.CreateParams(var Params: TCreateParams);
const
  Styles: array [TAlignment] of DWORD = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or Styles[FAlignment];
  if (FAlignment <> taLeftJustify) and (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
    (Win32MajorVersion = 4) and (Win32MinorVersion = 0) then
    Params.Style := Params.Style or ES_MULTILINE; // needed for Win95
end;
{$ENDIF VCL}

procedure TJvCustomEdit.MouseEnter(AControl: TControl);
var
  I, J: Integer;
begin
  if csDesigning in ComponentState then
    Exit;
  if not FOver then
  begin
    FSaved := Application.HintColor;
    Application.HintColor := FColor;
    if FHotTrack then
    begin
      I := SelStart;
      J := SelLength;
      Flat := False;
      SelStart := I;
      SelLength := J;
    end;
    FOver := True;
//    UpdateAutoHint;
  end;
  inherited MouseEnter(AControl);
end;

procedure TJvCustomEdit.MouseLeave(AControl: TControl);
var
  I, J: Integer;
begin
  if csDesigning in ComponentState then
    Exit;
  if FOver then
  begin
    Application.HintColor := FSaved;
    if FHotTrack then
    begin
      I := SelStart;
      J := SelLength;
      Flat := True;
      SelStart := I;
      SelLength := J;
    end;
    FOver := False;
  end;
  inherited MouseLeave(AControl);
end;

procedure TJvCustomEdit.ParentColorChanged;
begin
  inherited ParentColorChanged;
  if Assigned(FOnParentColorChanged) then
    FOnParentColorChanged(Self);
end;

procedure TJvCustomEdit.SetHotTrack(const Value: Boolean);
begin
  FHotTrack := Value;
  Flat := FHotTrack;
end;

function TJvCustomEdit.IsEmpty: Boolean;
begin
  Result := (Length(Text) = 0);
end;

procedure TJvCustomEdit.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    {$IFDEF VCL}
    RecreateWnd;
    {$ELSE}
    inherited Alignment := FAlignment;
    Invalidate; // (ahuser) clx draws the edit control itself
    {$ENDIF VCL}
  end;
end;

procedure TJvCustomEdit.MaxPixelChanged(Sender: TObject);
var
  St: string;
begin
  St := Text;
  FMaxPixel.Test(St, Font);
  if St <> Text then
  begin
    Text := St;
    SelStart := Min(SelStart, Length(Text));
  end;
end;

procedure TJvCustomEdit.SetDisabledColor(const Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    if not Enabled then
      Invalidate;
  end;
end;

procedure TJvCustomEdit.SetDisabledTextColor(const Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    if not Enabled then
      Invalidate;
  end;
end;

function StrFillChar(Ch: Char; Length: Cardinal): string;
begin
  SetLength(Result, Length);
  if Length > 0 then
    FillChar(Result[1], Length, Ch);
end;

function TJvCustomEdit.DoPaintBackground(Canvas: TCanvas; Param: Integer): Boolean;
var
  R: TRect;
begin
  if Enabled then
    Result := inherited DoPaintBackground(Canvas, Param)
  else
  begin
    SaveDC(Canvas.Handle);
    try
      Canvas.Brush.Color := FDisabledColor;
      Canvas.Brush.Style := bsSolid;
      R := ClientRect;
      Canvas.FillRect(R);
      Result := True;
      {$IFDEF VisualCLX}
     // paint Border
      if (BorderStyle = bsSingle) then
        QGraphics.DrawEdge(Canvas, R, esLowered, esLowered, ebRect);
      {$ENDIF VisualCLX}
    finally
      RestoreDC(Canvas.Handle, -1);
    end;
  end;
end;

{$IFDEF VCL}
procedure TJvCustomEdit.WMPaint(var Msg: TWMPaint);
var
  Canvas: TControlCanvas;
  S: TCaption;
begin
  if csDestroying in ComponentState then
    Exit;
  if Enabled then
    inherited
  else
  begin
    if PasswordChar = #0 then
      S := Text
    else
      S := StrFillChar(PasswordChar, Length(Text));
    Canvas := nil;
    try
      if not PaintEdit(Self, S, FAlignment, False, {0,} FDisabledTextColor,
         Focused, Canvas, Msg) then
        inherited;
    finally
      Canvas.Free;
    end;
  end;
end;
{$ENDIF VCL}
{$IFDEF VisualCLX}
procedure TJvCustomEdit.Paint;
var
  S: TCaption;
begin
  if csDestroying in ComponentState then
    Exit;
  if Enabled then
    inherited Paint
  else
  begin
    if PasswordChar = #0 then
      S := Text
    else
      S := StrFillChar(PasswordChar, Length(Text));
    if not PaintEdit(Self, S, FAlignment, False, {0,} FDisabledTextColor,
       Focused, Flat, Canvas) then
      inherited Paint;
  end;
end;

procedure TJvCustomEdit.TextChanged;
begin
  //Update;
  inherited TextChanged;
  UpdateAutoHint;
end;

procedure TJvCustomEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
end;
{$ENDIF VisualCLX}

procedure TJvCustomEdit.CaretChanged(Sender: TObject);
begin
  FCaret.CreateCaret;
end;

procedure TJvCustomEdit.SetCaret(const Value: TJvCaret);
begin
  FCaret.Assign(Value);
end;

procedure TJvCustomEdit.DoSetFocus(FocusedWnd: HWND);
begin
  inherited DoSetFocus(FocusedWnd);
  FCaret.CreateCaret;
end;

procedure TJvCustomEdit.DoKillFocus(FocusedWnd: HWND);
begin
  FCaret.DestroyCaret;
  inherited DoKillFocus(FocusedWnd);
end;

procedure TJvCustomEdit.EnabledChanged;
begin
  inherited EnabledChanged;
  Invalidate;
end;

procedure TJvCustomEdit.DoClearText;
begin
  if not ReadOnly then
    inherited DoClearText;
end;

procedure TJvCustomEdit.DoUndo;
begin
  if not ReadOnly then
    inherited DoUndo;
end;

procedure TJvCustomEdit.DoClipboardCut;
begin
  if not ReadOnly then
    inherited DoClipboardCut;
end;

procedure TJvCustomEdit.DoClipboardPaste;
begin
  if not ReadOnly then
    inherited DoClipboardPaste;
  UpdateEdit;
end;

procedure TJvCustomEdit.SetGroupIndex(const Value: Integer);
begin
  FGroupIndex := Value;
  UpdateEdit;
end;

procedure TJvCustomEdit.UpdateEdit;
var
  I: Integer;
begin
  for I := 0 to Self.Owner.ComponentCount - 1 do
    if Self.Owner.Components[I] is TJvCustomEdit then
      if ({(Self.Owner.Components[I].Name <> Self.Name)}
         (Self.Owner.Components[I] <> Self) and // (ahuser) this is better 
        ((Self.Owner.Components[I] as TJvCustomEdit).GroupIndex <> -1) and
        ((Self.Owner.Components[I] as TJvCustomEdit).fGroupIndex = Self.FGroupIndex)) then
        (Self.Owner.Components[I] as TJvCustomEdit).Caption := '';
end;

{$IFDEF VCL}
// (ahuser) ProtectPassword has no function under CLX
procedure TJvCustomEdit.SetText(const Value: TCaption);
begin
  inherited Text := Value;
  UpdateAutoHint;
end;

function TJvCustomEdit.GetText: TCaption;
var
  Tmp: Boolean;
begin
  Tmp := ProtectPassword;
  try
    ProtectPassword := False;
    Result := inherited Text;
  finally
    ProtectPassword := Tmp;
  end;
end;
{$ENDIF VCL}

procedure TJvCustomEdit.SetPasswordChar(Value: Char);
var
  Tmp: Boolean;
begin
  Tmp := ProtectPassword;
  try
    ProtectPassword := False;
    {$IFDEF VCL}
    if HandleAllocated then
      inherited PasswordChar := Char(SendMessage(Handle, EM_GETPASSWORDCHAR, 0, 0));
    inherited PasswordChar := Value;
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    FPasswordChar := Value;
    Invalidate;
    {$ENDIF VisualCLX}
  finally
    ProtectPassword := Tmp;
  end;
end;

{$IFDEF VCL}
procedure TJvCustomEdit.DefaultHandler(var Msg);
begin
  if ProtectPassword then
    with TMessage(Msg) do
      case Msg of
        WM_CUT, WM_COPY, WM_GETTEXT, WM_GETTEXTLENGTH, EM_SETPASSWORDCHAR:
          Result := 0;
      else
        inherited
      end
  else
    inherited;
end;
{$ENDIF VCL}

function TJvCustomEdit.GetPasswordChar: Char;
begin
  {$IFDEF VCL}
  if HandleAllocated then
    Result := Char(SendMessage(Handle, EM_GETPASSWORDCHAR, 0, 0))
  else
    Result := inherited PasswordChar;
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  Result := FPasswordChar;
  {$ENDIF VisualCLX}
end;

procedure TJvCustomEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  UpdateEdit;
  inherited KeyDown(Key, Shift);
end;

procedure TJvCustomEdit.SetSelLength(Value: Integer);
begin
  if csReading in ComponentState then
    FStreamedSelLength := Value
  else
    inherited SetSelLength(Value);
end;

procedure TJvCustomEdit.SetSelStart(Value: Integer);
begin
  if csReading in ComponentState then
    FStreamedSelStart := Value
  else
    inherited SetSelStart(Value);
end;

function TJvCustomEdit.GetPopupMenu: TPopupMenu;
begin
  Result := inherited GetPopupMenu;
  {$IFDEF VCL}
 // user has not assigned his own popup menu, so use fixed default
  if (Result = nil) and UseFixedPopup then
    Result := FixedDefaultEditPopUp(self);
  {$ENDIF VCL}
end;

function TJvCustomEdit.GetFlat: Boolean;
begin
  {$IFDEF VCL}
  FFlat := Ctl3D; // update
  {$ENDIF VCL}
  Result := FFlat;
end;

procedure TJvCustomEdit.SetFlat(Value: Boolean);
begin
  if Value <> FFlat then
  begin
    FFlat := Value;
    {$IFDEF VCL}
    Ctl3D := FFlat;
    {$ELSE}
    if FFlat then
      BorderStyle := bsNone
    else
      BorderStyle := bsSingle;
    Invalidate;
    {$ENDIF VCL}
  end;
end;

procedure TJvCustomEdit.SetClipboardCommands(const Value: TJvClipboardCommands);
begin
  if ClipboardCommands <> Value then
  begin
    inherited SetClipboardCommands(Value);
    ReadOnly := ClipboardCommands <= [caCopy];
  end;
end;

procedure TJvCustomEdit.UpdateAutoHint;
var
  C:TControlCanvas;
  Size:TSize;
begin
  if AutoHint and HandleAllocated then
  begin
    // (p3) empty original Hint indicates that we always want to replace Hint with Text
    if FOldHint = '' then
    begin
      Hint := Text;
      Exit;
    end;
    C := TControlCanvas.Create;
    try
      C.Control := self;
      if GetTextExtentPoint32(C.Handle, PChar(Text), Length(Text),Size) then
      begin
        if (ClientWidth <= Size.cx) then
          Hint := Text
        else 
          Hint := FOldHint;
      end
      else
        Hint := FOldHint;
    finally
      C.Free;
    end;
  end;
end;

procedure TJvCustomEdit.SetAutoHint(const Value: boolean);
begin
  if FAutoHint <> Value then
  begin
    if Value then
      FOldHint := Hint
    else
      Hint := FOldHint;
    FAutoHint := Value;
    UpdateAutoHint;
  end;
end;

procedure TJvCustomEdit.Resize;
begin
  inherited;
  UpdateAutoHint;
end;

end.

