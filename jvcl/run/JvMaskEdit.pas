{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvMaskEdit.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is S�bastien Buysse [sbuysse@buypin.com]
Portions created by S�bastien Buysse are Copyright (C) 2001 S�bastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck@bigfoot.com],
                Rob den Braasem [rbraasem@xs4all.nl],
                Oliver Giesen [ogware@gmx.net],
                Peter Thornqvist [peter3@peter3.com].

Last Modified: 2002-12-27

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvMaskEdit;

interface

uses
  {$IFDEF MSWINDOWS}
  Windows, Messages,
  {$ENDIF MSWINDOWS}
  SysUtils, Classes,
  {$IFDEF VCL}
  Graphics, Controls, Mask, Forms,
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  Types, QGraphics, QControls, QMask, QForms, QWindows, QTypes,
  {$ENDIF VisualCLX}
  JvComponent, JvTypes, JvCaret, JvToolEdit, JvExMask;

type
  TJvCustomMaskEdit = class(TJvExPubCustomMaskEdit)
  private
    FOnEnabledChanged: TNotifyEvent;
    FOnParentColorChanged: TNotifyEvent;
    FOnSetFocus: TJvFocusChangeEvent;
    FOnKillFocus: TJvFocusChangeEvent;
    FSaved: TColor;
    FHintColor: TColor;
    FOver: Boolean;
    FHotTrack: Boolean;
    FCaret: TJvCaret;
    FEntering: Boolean;
    FLeaving: Boolean;
    FGroupIndex: Integer;
    FDisabledColor: TColor;
    FDisabledTextColor: TColor;
    FProtectPassword: Boolean;
    FLastNotifiedText: String;
    procedure SetHotTrack(Value: Boolean);
    function GetText: TCaption;
    {$IFDEF VCL}
    procedure SetPasswordChar(const Value: Char);
    function GetPasswordChar: Char;
    procedure SetText(const Value: TCaption);
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    {$ENDIF VCL}
  protected
    procedure UpdateEdit;
    procedure CaretChanged(Sender: TObject); dynamic;
    function DoPaintBackground(Canvas: TCanvas; Param: Integer): Boolean; override;
    procedure DoKillFocus(FocusedWnd: HWND); override;
    procedure DoSetFocus(FocusedWnd: HWND); override;
    procedure DoKillFocusEvent(const ANextControl: TWinControl); virtual;
    procedure DoSetFocusEvent(const APreviousControl: TWinControl); virtual;
    procedure DoClipboardPaste; override;
    {$IFDEF VisualCLX}
    procedure SetText(const Value: TCaption); override;
    procedure Paint; override;
    {$ENDIF VisualCLX}
    procedure EnabledChanged; override;
    procedure MouseEnter(Control :TControl); override;
    procedure MouseLeave(Control :TControl); override;
    procedure ParentColorChanged; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure SetCaret(const Value: TJvCaret);
    procedure SetDisabledColor(const Value: TColor); virtual;
    procedure SetDisabledTextColor(const Value: TColor); virtual;
    procedure SetClipboardCommands(const Value: TJvClipboardCommands); override;
    procedure SetGroupIndex(const Value: Integer);
    procedure NotifyIfChanged;
    procedure Change; override;
  public
    {$IFDEF VCL}
    procedure DefaultHandler(var Msg); override;
    {$ENDIF VCL}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Entering: Boolean read FEntering;
    property Leaving: Boolean read FLeaving;
  protected
    property Text: TCaption read GetText write SetText;
    {$IFDEF VCL}
    property PasswordChar: Char read GetPasswordChar write SetPasswordChar default #0;
    {$ENDIF VCL}
    // set to True to disable read/write of PasswordChar and read of Text
    property ProtectPassword: Boolean read FProtectPassword write FProtectPassword default False;
    property HotTrack: Boolean read FHotTrack write SetHotTrack default False;
    property HintColor: TColor read FHintColor write FHintColor default clInfoBk;
    property Caret: TJvCaret read FCaret write SetCaret;

    property DisabledTextColor: TColor read FDisabledTextColor write
      SetDisabledTextColor default clGrayText;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clWindow;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default -1;

    property OnEnabledChanged: TNotifyEvent read FOnEnabledChanged write FOnEnabledChanged;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
    property OnSetFocus: TJvFocusChangeEvent read FOnSetFocus write FOnSetFocus;
    property OnKillFocus: TJvFocusChangeEvent read FOnKillFocus write FOnKillFocus;
  end;

  TJvMaskEdit = class(TJvCustomMaskEdit)
  published
    property Caret;
    property ClipboardCommands;
    property DisabledTextColor;
    property DisabledColor;
    property GroupIndex;
    property HintColor;
    property HotTrack;
    property ProtectPassword;
    property OnEnabledChanged;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnParentColorChange;

    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property DragMode;
    property Enabled;
    property EditMask;
    property Font;
    {$IFDEF VCL}
    property ImeMode;
    property ImeName;
    {$ENDIF VCL}
    property MaxLength;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    {$IFDEF VCL}
    property PasswordChar;
    {$ENDIF VCL}
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
    {$IFDEF VCL}
    property OnSetFocus;
    property OnKillFocus;
    {$ENDIF VCL}
    property OnStartDrag;
  end;

implementation

constructor TJvCustomMaskEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHotTrack := False;
  FHintColor := clInfoBk;
  FOver := False;
  FCaret := TJvCaret.Create(Self);
  FCaret.OnChanged := CaretChanged;
  FDisabledColor := clWindow;
  FDisabledTextColor := clGrayText;
  FGroupIndex := -1;
  FEntering := False;
  FLeaving := False;
end;

destructor TJvCustomMaskEdit.Destroy;
begin
  FCaret.OnChanged := nil;
  FreeAndNil(FCaret);
  inherited Destroy;
end;

procedure TJvCustomMaskEdit.ParentColorChanged;
begin
  inherited ParentColorChanged;
  if Assigned(FOnParentColorChanged) then
    FOnParentColorChanged(Self);
end;

procedure TJvCustomMaskEdit.EnabledChanged;
begin
  inherited EnabledChanged;
  Invalidate;
  if Assigned(FOnEnabledChanged) then
    FOnEnabledChanged(Self);
end;

procedure TJvCustomMaskEdit.MouseEnter(Control: TControl);
begin
  if csDesigning in ComponentState then
    Exit;
  if not FOver then
  begin
    FSaved := Application.HintColor;
    Application.HintColor := FHintColor;
    if HotTrack then
      {$IFDEF VCL}
      Ctl3D := True;
      {$ELSE}
      BorderStyle := bsSingle;
      {$ENDIF VCL}
    FOver := True;
  end;
  inherited MouseEnter(Control);
end;

procedure TJvCustomMaskEdit.MouseLeave(Control: TControl);
begin
  if csDesigning in ComponentState then
    Exit;
  if FOver then
  begin
    Application.HintColor := FSaved;
    if FHotTrack then
      {$IFDEF VCL}
      Ctl3D := False;
      {$ELSE}
      BorderStyle := bsSingle; // maybe bsNone
      {$ENDIF VCL}
    FOver := False;
  end;
  inherited MouseLeave(Control);
end;

procedure TJvCustomMaskEdit.SetHotTrack(Value: Boolean);
begin
  FHotTrack := Value;
  if Value then
    {$IFDEF VCL}
    Ctl3D := False;
    {$ELSE}
    BorderStyle := bsSingle; // maybe bsNone
    {$ENDIF VCL}
end;

procedure TJvCustomMaskEdit.CaretChanged(Sender: TObject);
begin
  FCaret.CreateCaret;
end;

procedure TJvCustomMaskEdit.SetCaret(const Value: TJvCaret);
begin
  FCaret.Assign(Value);
end;

procedure TJvCustomMaskEdit.SetClipboardCommands(const Value: TJvClipboardCommands);
begin
  if ClipboardCommands <> Value then
  begin
    inherited SetClipboardCommands(Value);
    ReadOnly := ClipboardCommands <= [caCopy];
  end;
end;

procedure TJvCustomMaskEdit.SetGroupIndex(const Value: Integer);
begin
  FGroupIndex := Value;
  UpdateEdit;
end;

procedure TJvCustomMaskEdit.UpdateEdit;
var
  I: Integer;
begin
  if Assigned(Owner) then
    for I := 0 to Owner.ComponentCount - 1 do
      if (Owner.Components[i] is TJvCustomMaskEdit) then
        with TJvCustomMaskEdit(Owner.Components[i]) do
          if (Name <> Self.Name) and (GroupIndex <> -1) and
            (GroupIndex = Self.GroupIndex) then
            Clear;
end;

procedure TJvCustomMaskEdit.SetDisabledColor(const Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    if not Enabled then
      Invalidate;
  end;
end;

procedure TJvCustomMaskEdit.SetDisabledTextColor(const Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    if not Enabled then
      Invalidate;
  end;
end;

procedure TJvCustomMaskEdit.DoClipboardPaste;
begin
  inherited DoClipboardPaste;
  UpdateEdit;
end;

{$IFDEF VCL}

procedure TJvCustomMaskEdit.WMPaint(var Msg: TWMPaint);
const
  AlignmentValues: array [False..True, TAlignment] of TAlignment =
    ((taLeftJustify, taRightJustify, taCenter),
     (taRightJustify, taLeftJustify, taCenter));
var
  Canvas: TControlCanvas;
  Style: Integer;
  AAlignment: TAlignment;
  //R: TRect;
  //ButtonWidth: Integer;
begin
  if csDestroying in ComponentState then
    Exit;
  if Enabled then
    inherited
  else
  begin
    { (rb) Alignment switching is already in PaintEdit ?? }
    { (rb) implementation VCL <> VisualCLX }
    Style := GetWindowLong(Handle, GWL_STYLE);
    if (Style and ES_RIGHT) <> 0 then
      AAlignment := AlignmentValues[UseRightToLeftAlignment, taRightJustify]
    else
    if (Style and ES_CENTER) <> 0 then
      AAlignment := taCenter
    else
      AAlignment := AlignmentValues[UseRightToLeftAlignment, taLeftJustify];

    {SendMessage(Handle, EM_GETRECT, 0, Integer(@R));
    if BiDiMode = bdRightToLeft then
      ButtonWidth := R.Left - 1
    else
      ButtonWidth := ClientWidth - R.Right - 2;
    if ButtonWidth < 0 then ButtonWidth := 0;}

    Canvas := nil;
    if not PaintEdit(Self, Text, AAlignment, False, {ButtonWidth,}
       FDisabledTextColor, Focused, Canvas, Msg) then
      inherited;
    Canvas.Free;
  end;
end;

{$ENDIF VCL}

{$IFDEF VisualCLX}
procedure TJvCustomMaskEdit.Paint;
begin
  with Canvas do
  begin
   // Paint
    if Enabled then
      inherited Paint
    else
    begin
      if not PaintEdit(Self, Text, taLeftJustify, False, {0,}
         FDisabledTextColor, Focused, false, Canvas) then
        inherited Paint;
    end;
  end;
end;
{$ENDIF VisualCLX}

function TJvCustomMaskEdit.DoPaintBackground(Canvas: TCanvas; Param: Integer): Boolean;
begin
  Result := False;
  if csDestroying in ComponentState then
    Exit;
  if Enabled then
    Result := inherited DoPaintBackground(Canvas, Param)
  else
  begin
    Canvas.Brush.Color := FDisabledColor;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(ClientRect);
    Result := True;
  end;
end;

procedure TJvCustomMaskEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  UpdateEdit;
  inherited KeyDown(Key, Shift);
end;

{$IFDEF VCL}
function TJvCustomMaskEdit.GetPasswordChar: Char;
begin
  Result := inherited PasswordChar;
end;
{$ENDIF VCL}

function TJvCustomMaskEdit.GetText: TCaption;
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

{$IFDEF VCL}
procedure TJvCustomMaskEdit.SetPasswordChar(const Value: Char);
var
  Tmp: Boolean;
begin
  Tmp := ProtectPassword;
  try
    ProtectPassword := False;
    inherited PasswordChar := Value;
  finally
    ProtectPassword := Tmp;
  end;
end;
{$ENDIF VCL}
procedure TJvCustomMaskEdit.SetText(const Value: TCaption);
begin
  {$IFDEF VCL}
  inherited Text := Value;
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  inherited SetText(Value);
  {$ENDIF VisualCLX}
end;

{$IFDEF VCL}

procedure TJvCustomMaskEdit.DefaultHandler(var Msg);
begin
  case TMessage(Msg).Msg of
    WM_CUT, WM_PASTE, EM_SETPASSWORDCHAR, WM_GETTEXT, WM_GETTEXTLENGTH:
      if not ProtectPassword then
        inherited DefaultHandler(Msg);
  else
    inherited DefaultHandler(Msg);
  end;
end;

{$ENDIF VCL}

procedure TJvCustomMaskEdit.DoKillFocus(FocusedWnd: HWND);
begin
  FLeaving := True;
  try
    FCaret.DestroyCaret;
    inherited DoKillFocus(FocusedWnd);
    DoKillFocusEvent(FindControl(FocusedWnd));
  finally
    FLeaving := False;
  end;
end;

procedure TJvCustomMaskEdit.DoSetFocus(FocusedWnd: HWND);
begin
  FEntering := True;
  try
    inherited DoSetFocus(FocusedWnd);
    FCaret.CreateCaret;
    DoSetFocusEvent(FindControl(FocusedWnd));
  finally
    FEntering := False;
  end;
end;

procedure TJvCustomMaskEdit.DoKillFocusEvent(const ANextControl: TWinControl);
begin
  NotifyIfChanged;
  if Assigned(FOnKillFocus) then
    FOnKillFocus(Self, ANextControl);
end;

procedure TJvCustomMaskEdit.DoSetFocusEvent(const APreviousControl: TWinControl);
begin
  NotifyIfChanged;
  if Assigned(FOnSetFocus) then
    FOnSetFocus(Self, APreviousControl);
end;

procedure TJvCustomMaskEdit.Change;
begin
  FLastNotifiedText := Text;
  inherited Change;
end;

procedure TJvCustomMaskEdit.NotifyIfChanged;
begin
  if FLastNotifiedText <> Text then
  begin
    { (ahuser) same code as in Change()
    FLastNotifiedText := Text;
    inherited Change;}
    Change;
  end;
end;

end.

