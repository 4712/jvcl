{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvPanel.pas, released on 2001-02-28.

The Initial Developer of the Original Code is S�bastien Buysse [sbuysse@buypin.com]
Portions created by S�bastien Buysse are Copyright (C) 2001 S�bastien Buysse.
All Rights Reserved.

Contributor(s):
Michael Beck [mbeck@bigfoot.com].
pongtawat
Peter Thornqvist [peter3@peter3.com]
Jens Fudickar [jens.fudickar@oratool.de]

Last Modified: 2003-11-03

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvPanel;

interface

uses
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, ExtCtrls,
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  Types, QWindows, QGraphics, QControls, QForms, QExtCtrls,
  {$ENDIF VisualCLX}
  SysUtils, Classes,
  JvThemes, JvComponent, JvExControls;

type
  TJvPanelResizeParentEvent = procedure(Sender: TObject; nLeft, nTop, nWidth, nHeight: Integer) of object;
  TJvAutoSizePanel = (asNone, asWidth, asHeight, asBoth);

  TJvPanel = class;

  TJvArrangeSettings = class(TPersistent)
  private
    FPanel: TJvPanel;
    FAutoArrange: Boolean;
    FAutoSize: TJvAutoSizePanel;
    FWrapControls: Boolean;
    FBorderLeft: Integer;
    FBorderTop: Integer;
    FDistanceVertical: Integer;
    FDistanceHorizontal: Integer;
    FShowNotVisibleAtDesignTime: Boolean;

    procedure SetWrapControls(Value: Boolean);
    procedure SetAutoArrange(Value: Boolean);
    procedure SetAutoSize(Value: TJvAutoSizePanel);
    procedure SetBorderLeft(Value: Integer);
    procedure SetBorderTop(Value: Integer);
    procedure SetDistanceVertical(Value: Integer);
    procedure SetDistanceHorizontal(Value: Integer);

    procedure Rearrange;
  public
    constructor Create(APanel: TJvPanel);
    procedure Assign(Source: TPersistent); override;
  published
    property WrapControls: Boolean read FWrapControls write SetWrapControls default True;
    property BorderLeft: Integer read FBorderLeft write SetBorderLeft default 0;
    property BorderTop: Integer read FBorderTop write SetBorderTop default 0;
    property DistanceVertical: Integer read FDistanceVertical write SetDistanceVertical default 0;
    property DistanceHorizontal: Integer read FDistanceHorizontal write SetDistanceHorizontal default 0;
    property ShowNotVisibleAtDesignTime: Boolean read FShowNotVisibleAtDesignTime write FShowNotVisibleAtDesignTime default True;
    property AutoSize: TJvAutoSizePanel read FAutoSize write SetAutoSize default asNone;
    property AutoArrange: Boolean read FAutoArrange write SetAutoArrange default False;
  end;

  TJvPanel = class(TJvCustomPanel, IJvDenySubClassing)
  private
    FHintColor: TColor;
    FSaved: TColor;
    FOnParentColorChanged: TNotifyEvent;
    FOver: Boolean;
    FTransparent: Boolean;
    FFlatBorder: Boolean;
    FFlatBorderColor: TColor;
    FMultiLine: Boolean;
    FOldColor: TColor;
    FHotColor: TColor;
    FSizeable: Boolean;
    FDragging: Boolean;
    FLastPos: TPoint;

    FArrangeSettings: TJvArrangeSettings;
    FEnableArrangeCount: Integer;
    FArrangeControlActive: Boolean;
    FArrangeWidth: Integer;
    FArrangeHeight: Integer;
    FOnResizeParent: TJvPanelResizeParentEvent;

    function GetHeight: Integer;
    procedure SetHeight(Value: Integer);
    function GetWidth: Integer;
    procedure SetWidth(Value: Integer);
    procedure SetArrangeSettings(Value: TJvArrangeSettings);

    procedure SetTransparent(const Value: Boolean);
    procedure SetFlatBorder(const Value: Boolean);
    procedure SetFlatBorderColor(const Value: TColor);
    procedure DrawCaption;
    procedure DrawBorders;
    procedure SetMultiLine(const Value: Boolean);
    procedure SetHotColor(const Value: TColor);
    procedure SetSizeable(const Value: Boolean);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseEnter(Control: TControl); override;
    procedure MouseLeave(Control: TControl); override;
    procedure ParentColorChanged; override;
    procedure TextChanged; override;
    procedure Paint; override;
    procedure AdjustSize; override;
    function DoPaintBackground(Canvas: TCanvas; Param: Integer): Boolean; override;
    {$IFDEF VCL}
    procedure CreateParams(var Params: TCreateParams); override;
    {$ENDIF VCL}
    procedure Loaded; override;
    procedure Resize; override;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Invalidate; override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer;
      AHeight: Integer); override;

    procedure ArrangeControls;
    procedure EnableArrange;
    procedure DisableArrange;
    function ArrangeEnabled: Boolean;
    property ArrangeWidth: Integer read FArrangeWidth;
    property ArrangeHeight: Integer read FArrangeHeight;

    {$IFDEF VCL}
    property DockManager;
    {$ENDIF VCL}
  published
    property Sizeable: Boolean read FSizeable write SetSizeable default False;
    property HintColor: TColor read FHintColor write FHintColor default clInfoBk;
    property HotColor: TColor read FHotColor write SetHotColor default clBtnFace;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property MultiLine: Boolean read FMultiLine write SetMultiLine;
    property FlatBorder: Boolean read FFlatBorder write SetFlatBorder default False;
    property FlatBorderColor: TColor read FFlatBorderColor write SetFlatBorderColor default clBtnShadow;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;

    property ArrangeSettings: TJvArrangeSettings read FArrangeSettings write SetArrangeSettings;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property OnResizeParent: TJvPanelResizeParentEvent read FOnResizeParent write FOnResizeParent;

    property Align;
    property Alignment;
    property Anchors;
    {$IFDEF VCL}
    property AutoSize;
    property BiDiMode;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property FullRepaint;
    property Locked;
    property ParentBiDiMode;
    property OnCanResize;
    property OnDockDrop;
    property OnDockOver;
    property OnEndDock;
    property OnGetSiteInfo;
    property OnStartDock;
    property OnUnDock;
    {$ENDIF VCL}
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
    property Caption;
    property Color;
    property Constraints;
    property DragMode;
    property Enabled;
    property Font;
    {$IFDEF JVCLThemesEnabled}
    property ParentBackground default True;
    {$ENDIF JVCLThemesEnabled}
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
  end;

implementation
uses
  JvMouseTimer;

const
  BkModeTransparent = TRANSPARENT;

{ TJvArrangeSettings }

constructor TJvArrangeSettings.Create(APanel: TJvPanel);
begin
  inherited Create;
  FPanel := APanel;
  WrapControls := True;
  ShowNotVisibleAtDesignTime := True;
  FAutoSize := asNone;
  AutoArrange := False;
end;

procedure TJvArrangeSettings.SetWrapControls(Value: Boolean);
begin
  if Value <> FWrapControls then
  begin
    FWrapControls := Value;
    Rearrange;
  end;
end;

procedure TJvArrangeSettings.SetAutoArrange(Value: Boolean);
begin
  if Value <> FAutoArrange then
  begin
    FAutoArrange := Value;
    if Value then
      Rearrange;
  end;
end;

procedure TJvArrangeSettings.SetAutoSize(Value: TJvAutoSizePanel);
begin
  if Value <> FAutoSize then
  begin
    FAutoSize := Value;
    if AutoSize <> asNone then
      Rearrange;
  end;
end;

procedure TJvArrangeSettings.SetBorderLeft(Value: Integer);
begin
  if Value <> FBorderLeft then
  begin
    FBorderLeft := Value;
    Rearrange;
  end;
end;

procedure TJvArrangeSettings.SetBorderTop(Value: Integer);
begin
  if Value <> FBorderTop then
  begin
    FBorderTop := Value;
    Rearrange;
  end;
end;

procedure TJvArrangeSettings.SetDistanceVertical(Value: Integer);
begin
  if Value <> FDistanceVertical then
  begin
    FDistanceVertical := Value;
    Rearrange;
  end;
end;

procedure TJvArrangeSettings.SetDistanceHorizontal(Value: Integer);
begin
  if Value <> FDistanceHorizontal then
  begin
    FDistanceHorizontal := Value;
    Rearrange;
  end;
end;

procedure TJvArrangeSettings.Assign(Source: TPersistent);
var A: TJvArrangeSettings;
begin
  if Source is TJvArrangeSettings then
  begin
    A := TJvArrangeSettings(Source);
    FAutoArrange := A.AutoArrange;
    FAutoSize := A.AutoSize;
    FWrapControls := A.WrapControls;
    FBorderLeft := A.BorderLeft;
    FBorderTop := A.BorderTop;
    FDistanceVertical := A.DistanceVertical;
    FDistanceHorizontal := A.DistanceHorizontal;
    FShowNotVisibleAtDesignTime := A.ShowNotVisibleAtDesignTime;

    Rearrange;
  end
  else
    inherited Assign(Source);
end;

procedure TJvArrangeSettings.Rearrange;
begin
  if (FPanel <> nil) and (AutoArrange) and
     not (csLoading in FPanel.ComponentState) then
    FPanel.ArrangeControls;
end;

{ TJvPanel }

constructor TJvPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF VCL}
  IncludeThemeStyle(Self, [csNeedsBorderPaint, csParentBackground]);
  {$ENDIF VCL}
  FHintColor := clInfoBk;
  FOver := False;
  FTransparent := False;
  FFlatBorder := False;
  FFlatBorderColor := clBtnShadow;
  FHotColor := clBtnFace;

  FArrangeSettings := TJvArrangeSettings.Create(Self);
end;

destructor TJvPanel.Destroy;
begin
  FArrangeSettings.Free;
  inherited Destroy;
end;

{$IFDEF VCL}
procedure TJvPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if Transparent then
  begin
    if not (csDesigning in ComponentState) then
      Params.ExStyle := Params.ExStyle or WS_EX_TRANSPARENT;
    ControlStyle := ControlStyle - [csOpaque];
  end
  else
  begin
    if not (csDesigning in ComponentState) then
      Params.ExStyle := Params.ExStyle and not WS_EX_TRANSPARENT;
    ControlStyle := ControlStyle + [csOpaque];
  end;
end;
{$ENDIF VCL}

procedure TJvPanel.Paint;
var
  X, Y: integer;
begin
  Canvas.Brush.Color := Color;
  if not Transparent then
    DrawThemedBackground(Self, Canvas, ClientRect)
  else
    Canvas.Brush.Style := bsClear;

  if FFlatBorder then
  begin
    Canvas.Brush.Color := FFlatBorderColor;
    {$IFDEF VCL}
    Canvas.FrameRect(ClientRect);
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    FrameRect(Canvas, ClientRect);
    {$ENDIF VisualCLX}
    Canvas.Brush.Color := Color;
  end
  else
    DrawBorders;
  Self.DrawCaption;
  if Sizeable then
    {$IFDEF JVCLThemesEnabled}
    if ThemeServices.ThemesEnabled then
    begin
      ThemeServices.DrawElement(Canvas.Handle, ThemeServices.GetElementDetails(tsGripper),
        Rect(ClientWidth - GetSystemMetrics(SM_CXVSCROLL) - BevelWidth - 2,
             ClientHeight - GetSystemMetrics(SM_CYHSCROLL) - BevelWidth - 2,
             ClientWidth - BevelWidth - 2, ClientHeight - BevelWidth - 2));
    end
    else
    {$ENDIF JVCLThemesEnabled}
    with Canvas do
    begin
      Font.Name := 'Marlett';
      Font.Charset := DEFAULT_CHARSET;
      Font.Size := 12;
      Canvas.Font.Style := [];
      Canvas.Font.Color := clBtnShadow;
      Brush.Style := bsClear;
      X := ClientWidth - GetSystemMetrics(SM_CXVSCROLL) - BevelWidth - 2;
      Y := ClientHeight - GetSystemMetrics(SM_CYHSCROLL) - BevelWidth - 2;
      if Transparent then
        SetBkMode(Handle, BkModeTransparent);
      TextOut(X, Y, 'o');
    end;
end;

procedure TJvPanel.AdjustSize;
begin
  inherited AdjustSize;
  if Transparent then
  begin
   // (ahuser) That is the only way to draw the border of the contained controls.
    Width := Width + 1;
    Width := Width - 1;
  end;
end;

procedure TJvPanel.DrawBorders;
var
  Rect: TRect;
  TopColor, BottomColor: TColor;

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    TopColor := clBtnHighlight;
    if Bevel = bvLowered then
      TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = bvLowered then
      BottomColor := clBtnHighlight;
  end;

begin
  Rect := ClientRect;
  if BevelOuter <> bvNone then
  begin
    AdjustColors(BevelOuter);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;
  Frame3D(Canvas, Rect, Color, Color, BorderWidth);
  if BevelInner <> bvNone then
  begin
    AdjustColors(BevelInner);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;
end;

procedure TJvPanel.DrawCaption;
const
  Alignments: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWrap: array[Boolean] of Longint = (DT_SINGLELINE, DT_WORDBREAK);
var
  ATextRect: TRect;
  BevelSize: Integer;
  Flags: Longint;
begin
  with Self.Canvas do
  begin
    if Caption <> '' then
    begin
      SetBkMode(Handle, BkModeTransparent);
      Font := Self.Font;
      ATextRect := GetClientRect;
      InflateRect(ATextRect, -BorderWidth, -BorderWidth);
      BevelSize := 0;
      if BevelOuter <> bvNone then
        Inc(BevelSize, BevelWidth);
      if BevelInner <> bvNone then
        Inc(BevelSize, BevelWidth);
      InflateRect(ATextRect, -BevelSize, -BevelSize);
      Flags := DT_EXPANDTABS or WordWrap[MultiLine] or Alignments[Alignment];
      Flags := DrawTextBiDiModeFlags(Flags);
      //calculate required rectangle size
      {$IFDEF VCL}
      DrawText(Canvas.Handle, PChar(Caption), -1, ATextRect, Flags or DT_CALCRECT);
      {$ENDIF VCL}
      {$IFDEF VisualCLX}
      DrawTextW(Canvas.Handle, PWideChar(Caption), -1, ATextRect, Flags or DT_CALCRECT);
      {$ENDIF VisualCLX}
      // adjust the rectangle placement
      OffsetRect(ATextRect, 0, -ATextRect.Top + (Height - (ATextRect.Bottom - ATextRect.Top)) div 2);
      case Alignment of
        taRightJustify:
          OffsetRect(ATextRect, -ATextRect.Left + (Width - (ATextRect.Right - ATextRect.Left) - BorderWidth -
            BevelSize), 0);
        taCenter:
          OffsetRect(ATextRect, -ATextRect.Left + (Width - (ATextRect.Right - ATextRect.Left)) div 2, 0);
      end;
      if not Enabled then
        Font.Color := clGrayText;
      //draw text
      if Transparent then
        SetBkMode(Canvas.Handle, BkModeTransparent);
      {$IFDEF VCL}
      DrawText(Canvas.Handle, PChar(Caption), -1, ATextRect, Flags);
      {$ENDIF VCL}
      {$IFDEF VisualCLX}
      DrawTextW(Canvas.Handle, PWideChar(Caption), -1, ATextRect, Flags);
      {$ENDIF VisualCLX}
    end;
  end;
end;

procedure TJvPanel.ParentColorChanged;
begin
  inherited ParentColorChanged;
  Invalidate;
  if Assigned(FOnParentColorChanged) then
    FOnParentColorChanged(Self);
end;

procedure TJvPanel.MouseEnter(Control: TControl);
begin
  if csDesigning in ComponentState then
    Exit;
  if not FOver then
  begin
    FSaved := Application.HintColor;
    FOldColor := Color;
    Application.HintColor := FHintColor;
    FOver := True;
    if not Transparent then
    begin
      Color := HotColor;
      MouseTimer.Attach(Self);
    end;
    inherited MouseEnter(Control);
  end;
end;

procedure TJvPanel.MouseLeave(Control: TControl);
begin
  if FOver then
  begin
    Application.HintColor := FSaved;
    FOver := False;
    if not Transparent then
    begin
      Color := FOldColor;
      MouseTimer.Detach(Self);
    end;
    inherited MouseLeave(Control);
  end;
end;

procedure TJvPanel.SetTransparent(const Value: Boolean);
begin
  if Value <> FTransparent then
  begin
    FTransparent := Value;
    {$IFDEF VCL}
    RecreateWnd;
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    Masked := FTransparent;
    {$ENDIF VisualCLX}
  end;
end;

procedure TJvPanel.SetFlatBorder(const Value: Boolean);
begin
  if Value <> FFlatBorder then
  begin
    FFlatBorder := Value;
    Invalidate;
  end;
end;

procedure TJvPanel.SetFlatBorderColor(const Value: TColor);
begin
  if Value <> FFlatBorderColor then
  begin
    FFlatBorderColor := Value;
    Invalidate;
  end;
end;

function TJvPanel.DoPaintBackground(Canvas: TCanvas; Param: Integer): Boolean;
begin
  if Transparent then
    Result := True
  else
    Result := inherited DoPaintBackground(Canvas, Param);
end;

procedure TJvPanel.SetMultiLine(const Value: Boolean);
begin
  if FMultiLine <> Value then
  begin
    FMultiLine := Value;
    Invalidate;
  end;
end;

procedure TJvPanel.TextChanged;
begin
  inherited TextChanged;
  Invalidate;
end;

procedure TJvPanel.Invalidate;
begin
{  if Transparent and Visible and Assigned(Parent) and Parent.HandleAllocated and HandleAllocated then
    RedrawWindow(Parent.Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INTERNALPAINT or RDW_INVALIDATE
      or RDW_ERASENOW or RDW_UPDATENOW or RDW_ALLCHILDREN); }
  inherited Invalidate;
end;

procedure TJvPanel.SetHotColor(const Value: TColor);
begin
  if FHotColor <> Value then
  begin
    FHotColor := Value;
    if not Transparent then
      Invalidate;
  end;
end;

procedure TJvPanel.SetSizeable(const Value: Boolean);
begin
  if FSizeable <> Value then
  begin
    FSizeable := Value;
    Invalidate;
  end;
end;

procedure TJvPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if Sizeable and (Button = mbLeft) and ((Width - X) < 12) and ((Height - Y) < 12) then
  begin
    FDragging := True;
    FLastPos := Point(X, Y);
    MouseCapture := True;
    Screen.Cursor := crSizeNWSE;
  end
  else
    inherited MouseDown(Button, Shift, X, Y);
end;

procedure TJvPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  X1, Y1: Integer;
begin
  if FDragging and Sizeable then
  begin
    R := BoundsRect;
    X1 := R.Right - R.Left + X - FLastPos.X;
    Y1 := R.Bottom - R.Top + Y - FLastPos.Y;
    if (X1 > 1) and (Y1 > 1) then
    begin
      if (X1 >= 0) then
        FLastPos.X := X;
      if (Y1 >= 0) then
        FLastPos.Y := Y;
      SetBounds(Left, Top, X1, Y1);
      Refresh;
    end;
  end
  else
  begin
    inherited MouseMove(Shift, X, Y);
    if Sizeable and ((Width - X) < 12) and ((Height - Y) < 12) then
      Cursor := crSizeNWSE
    else
      Cursor := crDefault;
  end;
end;

procedure TJvPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if FDragging and Sizeable then
  begin
    FDragging := False;
    MouseCapture := False;
    Screen.Cursor := crDefault;
    Refresh;
  end
  else
    inherited MouseUp(Button, Shift, X, Y);
end;

procedure TJvPanel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if Transparent then Invalidate;
end;

procedure TJvPanel.Resize;
begin
  {$IFDEF VisualCLX}
  if Assigned(FArrangeSettings) then
  {$ENDIF VisualCLX}
  if FArrangeSettings.AutoArrange then
    ArrangeControls;
  inherited Resize;
end;

procedure TJvPanel.EnableArrange;
begin
  EnableAlign;
  if FEnableArrangeCount > 0 then
    Dec(FEnableArrangeCount);
end;

procedure TJvPanel.DisableArrange;
begin
  Inc(FEnableArrangeCount);
  DisableAlign;
end;

function TJvPanel.ArrangeEnabled: Boolean;
begin
  Result := FEnableArrangeCount <= 0;
end;

procedure TJvPanel.Loaded;
begin
  inherited Loaded;
  if FArrangeSettings.AutoArrange then
    ArrangeControls;
end;

procedure TJvPanel.AlignControls(AControl: TControl; var Rect: TRect);
begin
  inherited AlignControls(AControl, Rect);
  if FArrangeSettings.AutoArrange then
    ArrangeControls;
end;

procedure TJvPanel.ArrangeControls;
var
  AktX, AktY, NewX, NewY, MaxY: Integer;
  ControlMaxX, ControlMaxY: Integer;
  LastTabOrder: Integer;
  LastControlCount, CurrControlCount: Integer;
  CurrControl: TWinControl;
  i: Integer;
  OldHeight: Integer;
begin
  if (not ArrangeEnabled) or FArrangeControlActive or (ControlCount = 0) then
    Exit;
  if [csLoading, csReading] * ComponentState <> [] then
    Exit;
  FArrangeWidth := 0;
  FArrangeHeight := 0;
  FArrangeControlActive := True;
  try
    OldHeight := Height;
    LastControlCount := 0;
    CurrControlCount := 0;
    AktY := FArrangeSettings.BorderTop;
    AktX := FArrangeSettings.BorderLeft;
    LastTabOrder := -1;
    MaxY := -1;
    if (FArrangeSettings.AutoSize in [asWidth, asBoth]) and (Align in [alLeft, alRight]) then
      ControlMaxX := Width - 2 * FArrangeSettings.BorderLeft
    else
      ControlMaxX := -1;
    if (FArrangeSettings.AutoSize in [asHeight, asBoth]) and (Align in [alTop, alBottom]) then
      ControlMaxY := Height - 2 * FArrangeSettings.BorderTop
    else
      ControlMaxY := -1;

    for i := 0 to ControlCount - 1 do
      if Controls[i] is TWinControl then
      begin
        if Controls[i] is TJvPanel then
          TJvPanel(Controls[i]).ArrangeSettings.Rearrange;
        if Controls[i].Width + 2 * FArrangeSettings.BorderLeft > Width then
          Width := Controls[i].Width + 2 * FArrangeSettings.BorderLeft;
      end;    {*** if Controls[i] is TWinControl then ***}

    while CurrControlCount < ControlCount do
    begin
      for i := 0 to ControlCount - 1 do
      begin
        if Controls[i] is TWinControl then
        begin
          CurrControl := TWinControl(Controls[i]);
          if CurrControl.TabOrder = (LastTabOrder + 1) then
          begin
            LastTabOrder := CurrControl.TabOrder;
            Inc(CurrControlCount);
            if CurrControl.Visible or
              ((csDesigning in ComponentState) and FArrangeSettings.ShowNotVisibleAtDesignTime) then
            begin
              NewX := AktX;
              NewY := AktY;
              if ((AktX + CurrControl.Width + FArrangeSettings.DistanceHorizontal + FArrangeSettings.BorderLeft) > Width) and
                 (AktX > FArrangeSettings.BorderLeft) and
                 FArrangeSettings.WrapControls then
              begin
                AktX := FArrangeSettings.BorderLeft;
                AktY := AktY + MaxY + FArrangeSettings.DistanceVertical;
                MaxY := -1;
                NewX := AktX;
                NewY := AktY;
              end;   {*** if ... ***}
              AktX := AktX + CurrControl.Width;
              if AktX > ControlMaxX then
                ControlMaxX := AktX;
              AktX := AktX + FArrangeSettings.DistanceHorizontal;
              CurrControl.Left := NewX;
              CurrControl.Top := NewY;
              if CurrControl.Height > MaxY then
                MaxY := CurrControl.Height;
              ControlMaxY := AktY + MaxY;
            end;   {*** if CurrControl.Visible then ***}
          end;   {*** if CurrControl.TabOrder > LastTabOrder then ***}
        end;   {*** if Controls[i] is TWinControl then ***}
      end;   {*** for i := 0 to ControlCount do ***}
      if CurrControlCount = LastControlCOunt then
        Break;
      LastControlCount := CurrControlCount;
    end;  {*** while CurrControlCount < ControlCount do ***}

    if not (csLoading in ComponentState) then
    begin
      if FArrangeSettings.AutoSize in [asWidth, asBoth] then
        if ControlMaxX >= 0 then
          Width := ControlMaxX + FArrangeSettings.BorderLeft
        else
          Width := 0;
      if FArrangeSettings.AutoSize in [asHeight, asBoth] then
        if ControlMaxY >=0  then
          Height := ControlMaxY + FArrangeSettings.BorderTop
        else
          Height := 0;
    end;   {*** if not (csLoading in ComponentState) then ***}
    FArrangeWidth := ControlMaxX + 2 * FArrangeSettings.BorderLeft;
    FArrangeHeight := ControlMaxY + 2 * FArrangeSettings.BorderTop;
    if OldHeight <> Height then
      {$IFDEF VCL}
      SendMessage(GetFocus, WM_PAINT, 0, 0);
      {$ENDIF VCL}
      {$IFDEF VisualCLX}
      UpdateWindow(GetFocus);
      {$ENDIF VisualCLX}
  finally
    FArrangeControlActive := False;
  end;
end;

procedure TJvPanel.SetWidth(Value: Integer);
begin
  if inherited Width <> Value then
    if Assigned(FOnResizeParent) then
      FOnResizeParent(Self, Left, Top, Value, Height)
    else
    if Parent is TJvPanel then
       TJvPanel(Parent).ArrangeSettings.Rearrange;
  inherited Width := Value;
end;

function TJvPanel.GetWidth: Integer;
begin
  Result := inherited Width;
end;

procedure TJvPanel.SetHeight(Value: Integer);
begin
  if inherited Height <> Value then
    if Assigned(FOnResizeParent) then
      FOnResizeParent(Self, Left, Top, Width, Value)
    else
    if Parent is TJvPanel then
       TJvPanel(Parent).ArrangeSettings.Rearrange;
  inherited Height := Value;
end;

function TJvPanel.GetHeight: Integer;
begin
  Result := inherited Height;
end;

procedure TJvPanel.SetArrangeSettings(Value: TJvArrangeSettings);
begin
  if (Value <> nil) and (Value <> FArrangeSettings) then
    FArrangeSettings.Assign(Value);
end;

end.

