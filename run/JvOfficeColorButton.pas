{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvColorBtn.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is Peter Th�rnqvist [peter3@peter3.com]
Portions created by Peter Th�rnqvist are Copyright (C) 2002 Peter Th�rnqvist.
All Rights Reserved.

Contributor(s):
dejoy(dejoy@ynl.gov.cn)

Last Modified: 2004-02-26

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Description:
  A color selection button that mimicks the one on the 'Display Properties' page in Win95/NT4

Known Issues:
    If the OtherCaption is set to an empty string, the default '&Other..' magically appears.
    Solution: Set OtherCaption to ' ' instead
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvOfficeColorButton;

interface

uses
{$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, StdCtrls, Dialogs, ExtCtrls,
{$ENDIF VCL}
{$IFDEF VisualCLX}
  Types, QGraphics, QWindows, QControls, QForms, QStdCtrls, QDialogs, QExtCtrls,
{$ENDIF VisualCLX}
  JvComponent, JvSpeedButton, JvOfficeColorForm, JvOfficeColorPanel, SysUtils, Classes;

const
  MinArrowWidth = 9 + 4;
  Tag_ArrowWidth = 11;

type
  TJvOfficeColorButtonProperties = class(TJvOfficeColorPanelProperties)
  private
    FShowDragBar: Boolean;
    FDragCaption: string;
    FEdgeWidth: Integer;
    FArrowWidth: integer;
    FDragBarHeight: integer;
    FDragBarSpace: integer;
    procedure SetShowDragBar(const Value: Boolean);
    procedure SetDragCaption(const Value: string);
    procedure SetArrowWidth(const Value: integer);
    procedure SetEdgeWidth(const Value: Integer);
    procedure SetDragBarHeight(const Value: integer);
    procedure SetDragBarSpace(const Value: integer);
  public
    constructor Create(); override;
    procedure Assign(Source: TPersistent); override;
  published
    property EdgeWidth: Integer read FEdgeWidth write SetEdgeWidth default 4;
    property ArrowWidth: integer read FArrowWidth write SetArrowWidth default MinArrowWidth;
    property ShowDragBar: Boolean read FShowDragBar write SetShowDragBar default True;
    property DragCaption: string read FDragCaption write SetDragCaption;
    property DragBarHeight: integer read FDragBarHeight write SetDragBarHeight default MinDragBarHeight;
    property DragBarSpace: integer read FDragBarSpace write SetDragBarSpace default MinDragBarSpace;
  end;

  TJvCustomOfficeColorButton = class(TJvCustomPanel)
  private

    FMainButton: TJvSubColorButton;
    FArrowButton: TJvColorSpeedButton;

    FColorsForm: TJvOfficeColorForm;

    FProperties: TJvOfficeColorButtonProperties;

    FFlat: boolean;
    FCurrentColor: TColor;

    FColorFormDropDown: boolean;

    FOnColorChange: TNotifyEvent;
    FInited: boolean;

    FOnDropDown: TNotifyEvent;
    procedure SetFlat(const Value: boolean);
    procedure SetColor(const Value: TColor);
    function GetCustomColors: TStrings;
    procedure SetCustomColors(const Value: TStrings);
    function GetColor: TColor;

    function GetGlyph: TBitmap;
    procedure SetGlyph(const Value: TBitmap);
    function GetProperties: TJvOfficeColorButtonProperties;
    procedure SetProperties(const Value: TJvOfficeColorButtonProperties);
{$IFDEF VCL}
    function GetColorDialogOptions: TColorDialogOptions;
    procedure SetColorDialogOptions(const Value: TColorDialogOptions);
{$ENDIF VCL}

    procedure ReadArrowWidth(Reader: TReader);
    procedure ReadEdgeWidth(Reader: TReader);
    procedure ReadOtherCaption(Reader: TReader);

    procedure DoOnColorChange(sender: Tobject);

    procedure OnFormShowingChanged(Sender: TObject);
    procedure OnFormKillFocus(Sender: TObject);
    procedure OnFormClose(Sender: TObject; var Action: TCloseAction);
    procedure OnFormWindowStyleChanged(Sender: TObject);

    procedure OnButtonMouseEnter(Sender: TObject);
    procedure OnButtonMouseLeave(Sender: TObject);

    procedure ColorButtonClick(Sender: TObject);

  protected
    procedure AdjustColorForm(X: Integer = 0; Y: Integer = 0); //Screen postion
    procedure ShowColorForm(X: Integer = 0; Y: Integer = 0); virtual; //Screen postion

{$IFDEF VCL}
    procedure CreateWnd; override;
{$ELSE}
    procedure InitWidget; override;
{$ENDIF VCL}
    procedure SetEnabled({$IFDEF VisualCLX}const{$ENDIF}Value: Boolean); override;

    procedure FontChanged; override;
    procedure DefineProperties(Filer: TFiler); override;

    procedure PropertiesChanged(Sender: TObject; PropName: string); virtual;

  public
    procedure AdjustSize; override;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Flat: boolean read FFlat write SetFlat default True;
    property Color: TColor read GetColor write SetColor default clBlack;
    property CustomColors: TStrings read GetCustomColors write SetCustomColors;
    property Properties: TJvOfficeColorButtonProperties read GetProperties write SetProperties;
{$IFDEF VCL}
    property Options: TColorDialogOptions read GetColorDialogOptions write SetColorDialogOptions default [];
{$ENDIF VCL}

    property Glyph: TBitmap read GetGlyph write SetGlyph;

    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnColorChange: TNotifyEvent read FOnColorChange write FOnColorChange;

  end;

  TJvOfficeColorButton = class(TJvCustomOfficeColorButton)
  published
{$IFDEF VCL}
    property BiDiMode;
    property DragCursor;
    property DragKind;
    property ParentBiDiMode;
    property OnCanResize;
    property OnEndDock;
    property OnGetSiteInfo;
{$ENDIF VCL}

    property Align;
    property Anchors;
    property Constraints;
    property DragMode;
    property Enabled;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnConstrainedResize;
    property OnContextPopup;
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

    property Flat;
    property Color;
    property CustomColors;
{$IFDEF VCL}
    property Options;
{$ENDIF VCL}

    property Glyph;

    property Properties;
    property OnDropDown;
    property OnColorChange;

  end;

implementation

uses TypInfo, JvJCLUtils, JvExExtCtrls, JvThemes;

type

  THackColorSpeedButton = class(TJvColorSpeedButton);

  TJvColorMainButton = class(TJvSubColorButton)
  protected
    function GetEdgeWidth: integer; override;
  end;

  TJvColorArrowButton = class(TJvColorSpeedButton)
  protected
    procedure Paint; override;
  end;

{ TJvColorMainButton }

function TJvColorMainButton.GetEdgeWidth: integer;
begin
  Result := FEdgeWidth;
end;

{ TJvCustomOfficeColorButton }

procedure TJvCustomOfficeColorButton.AdjustSize;
begin
  if FInited then
    with Properties do
    begin
      if ArrowWidth < MinArrowWidth then
        ArrowWidth := MinArrowWidth;
      if (Width - ArrowWidth) < MinButtonWidth then
        Width := MinButtonWidth + ArrowWidth;
      if Height < MinButtonHeight then
        Height := MinButtonHeight;

      FMainButton.SetBounds(0, 0, Width - FArrowWidth, Height);

      FArrowButton.SetBounds(FMainButton.Width, 0, ArrowWidth, Height);
    end;
  inherited AdjustSize;
end;

type
  THackJvColorForm = class(TJvOfficeColorForm);

constructor TJvCustomOfficeColorButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInited := False;

  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] + [csOpaque];
  BevelOuter := bvNone;
{$IFDEF VCL}
  Locked := true;
{$ENDIF VCL}
  Width := MinButtonWidth + MinArrowWidth;
  Height := MinButtonHeight;

  FCurrentColor := clDefault;

  FMainButton := TJvColorMainButton.Create(Self);
  with FMainButton do
  begin
    Parent := Self;
    NumGlyphs := 2;
    Color := clDefault;
    Tag := MaxColorButtonNumber + 3;
  end;

  FArrowButton := TJvColorArrowButton.Create(Self);
  with FArrowButton do
  begin
    Parent := Self;
    GroupIndex := 2;
    AllowAllUp := true;
    Tag := MaxColorButtonNumber + 4;
    OnClick := ColorButtonClick;
  end;

  FColorsForm := TJvOfficeColorForm.CreateNew(Self);
  with THackJvColorForm(FColorsForm) do
  begin
    FormStyle := fsStayOnTop;
    ToolWindowStyle := False;
    OnShowingChanged := OnFormShowingChanged;
    OnKillFocus := OnFormKillFocus;
    OnClose := OnFormClose;
    OnWindowStyleChanged := OnFormWindowStyleChanged;

    ColorPanel.OnColorChange := DoOnColorChange;
  end;

  FProperties := TJvOfficeColorButtonProperties.Create;
  FProperties.Assign(FColorsForm.ColorPanel.Properties);
  FProperties.OnPropertiesChanged := PropertiesChanged;
  FColorsForm.ColorPanel.Properties.OnPropertiesChanged := nil;

  Font.Name := 'MS Shell Dlg 2';
  Flat := True;
{$IFDEF VisualCLX}
  //in CLX and a bug not fix when drag the colors form
  Properties.ShowDragBar := False;

{$ENDIF VisualCLX}
  FMainButton.OnMouseEnter := OnButtonMouseEnter;
  FArrowButton.OnMouseEnter := OnButtonMouseEnter;
  FMainButton.OnMouseLeave := OnButtonMouseLeave;
  FArrowButton.OnMouseLeave := OnButtonMouseLeave;

  FInited := True;

end;

{$IFDEF VCL}

procedure TJvCustomOfficeColorButton.CreateWnd;
begin
  inherited;
  AdjustSize;
end;
{$ELSE}

procedure TJvCustomOfficeColorButton.InitWidget;
begin
  inherited;
  AdjustSize;
end;
{$ENDIF VCL}

destructor TJvCustomOfficeColorButton.Destroy;
begin
  if FColorsForm.Visible then FColorsForm.Hide; //because we replaced message handler, we have to hide the form at here.
  Action.Free;
  FProperties.Free;
  inherited Destroy;
end;

procedure TJvCustomOfficeColorButton.SetEnabled({$IFDEF VisualCLX}const{$ENDIF}Value: Boolean);
begin
  inherited SetEnabled(Value);
  FMainButton.Enabled := Value;
  FArrowButton.Enabled := Value;
  FColorsForm.ColorPanel.Enabled := Value;
end;

procedure TJvCustomOfficeColorButton.FontChanged;
begin
  inherited;
  FColorsForm.Font.Assign(Font);
end;

procedure TJvCustomOfficeColorButton.ColorButtonClick(Sender: TObject);
begin
  if TJvColorSpeedButton(Sender).Tag = FArrowButton.Tag then
  begin
    if (FColorsForm.Visible) or (FColorFormDropDown) then
    begin
      FColorsForm.Hide;
      FColorFormDropDown := False;
      FArrowButton.Down := False;
    end
    else
    begin
      if Assigned(FOnDropDown) then
        FOnDropDown(FArrowButton);
      ShowColorForm;
      FColorFormDropDown := True;
    end
  end
  else
  begin
    TJvSubColorButton(Sender).Down := true;
    SetColor(TJvSubColorButton(Sender).Color);
  end;
end;

function TJvCustomOfficeColorButton.GetCustomColors: TStrings;
begin
  Result := FColorsForm.ColorPanel.CustomColors;
end;

function TJvCustomOfficeColorButton.GetColor: TColor;
begin
  Result := FColorsForm.ColorPanel.Color;
end;

procedure TJvCustomOfficeColorButton.DoOnColorChange(sender: Tobject);
begin
  FMainButton.Color := FColorsForm.ColorPanel.SelectedColor;
  if not THackJvColorForm(FColorsForm).DropDownMoved then
    FColorsForm.Hide;
  if Assigned(FOnColorChange) then
    FOnColorChange(sender);
end;

procedure TJvCustomOfficeColorButton.SetCustomColors(const Value: TStrings);
begin
  FColorsForm.ColorPanel.CustomColors.Assign(Value);
end;

procedure TJvCustomOfficeColorButton.SetFlat(const Value: boolean);
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    FMainButton.Flat := Value;
    FArrowButton.Flat := Value;
    FColorsForm.Flat := Value;
  end;
end;

procedure TJvCustomOfficeColorButton.SetColor(const Value: TColor);
begin
  if FColorsForm.ColorPanel.SelectedColor <> Value then
  begin
    FColorsForm.ColorPanel.SelectedColor := Value;
    FMainButton.Color := Value;
  end;
end;

procedure TJvCustomOfficeColorButton.AdjustColorForm(X: Integer = 0; Y: Integer = 0);
var
  pt: TPoint;
begin
  if (x = 0) and (y = 0) then
    pt := ClientToScreen(Point(FMainButton.Left, FMainButton.Top))
  else
    pt := Point(X, Y);

  FColorsForm.Left := pt.X;
  if (FColorsForm.Left + FColorsForm.Width) > Screen.Width then
    FColorsForm.Left := Screen.Width - FColorsForm.Width;
  FColorsForm.Top := pt.Y + Height;
  if (FColorsForm.Top + FColorsForm.Height) > Screen.Height then
    FColorsForm.Top := pt.Y - FColorsForm.Height;

end;

procedure TJvCustomOfficeColorButton.ShowColorForm(X: Integer = 0; Y: Integer = 0);
begin
  AdjustColorForm(X, Y);

  FColorsForm.Show;
  FColorFormDropDown := True;
end;

procedure DrawTriangle(Canvas: TCanvas; Top, Left, Width: Integer);

begin
  if Odd(Width) then Inc(Width);
  Canvas.Polygon([Point(Left, Top),
    Point(Left + Width, Top),
      Point(Left + Width div 2, Top + Width div 2)]);
end;

procedure TJvCustomOfficeColorButton.OnFormShowingChanged(Sender: TObject);
begin
  if not FColorsForm.Visible then
  begin
    FArrowButton.Down := false;
    THackColorSpeedButton(FArrowButton).MouseLeave(FArrowButton);
    THackColorSpeedButton(FMainButton).MouseLeave(FMainButton);
  end
end;

procedure TJvCustomOfficeColorButton.OnFormKillFocus(Sender: TObject);
var
  rec: TRect;
  p: TPoint;
begin
  Rec := FArrowButton.ClientRect;
  GetCursorPos(P);
  P := FArrowButton.ScreenToClient(p);
  if (not FColorsForm.ToolWindowStyle) and
    (not PtInRect(rec, p)) then //mouse in ArrowButton
  begin
    FColorsForm.Hide;
    FColorsForm.ToolWindowStyle := False;
    if FArrowButton.Down then
      FArrowButton.Down := False;
    FColorFormDropDown := False;
  end;

end;

procedure TJvCustomOfficeColorButton.OnFormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FColorsForm.ToolWindowStyle then
    FColorFormDropDown := False;
  Action := caHide;
end;

procedure TJvCustomOfficeColorButton.OnFormWindowStyleChanged(Sender: TObject);
begin
  if FColorsForm.ToolWindowStyle then
  begin
    FArrowButton.Down := False;
    THackColorSpeedButton(FArrowButton).MouseLeave(FArrowButton);
    THackColorSpeedButton(FMainButton).MouseLeave(FMainButton);

  end;
end;

procedure TJvCustomOfficeColorButton.OnButtonMouseEnter(Sender: TObject);
begin
  if FFlat and Enabled then
  begin
    THackColorSpeedButton(FMainButton).MouseEnter(FMainButton);
    THackColorSpeedButton(FArrowButton).MouseEnter(FArrowButton);
  end;
end;

procedure TJvCustomOfficeColorButton.OnButtonMouseLeave(Sender: TObject);
begin
  if FFlat and Enabled then
  begin
    if (Sender = FMainButton) then
    begin
      if FColorsForm.Visible then
        THackColorSpeedButton(FMainButton).MouseEnter(FMainButton)
      else
        THackColorSpeedButton(FArrowButton).MouseLeave(FArrowButton);
    end
    else if (Sender = FArrowButton) then
    begin
      if not FColorsForm.Visible then
        THackColorSpeedButton(FMainButton).MouseLeave(FMainButton)
      else
        THackColorSpeedButton(FArrowButton).MouseEnter(FArrowButton);
    end;

  end;

end;

function TJvCustomOfficeColorButton.GetGlyph: TBitmap;
begin
  Result := FMainButton.Glyph;
end;

procedure TJvCustomOfficeColorButton.SetGlyph(const Value: TBitmap);
begin
  FMainButton.Glyph := Value;
end;

{$IFDEF VCL}

function TJvCustomOfficeColorButton.GetColorDialogOptions: TColorDialogOptions;
begin
  Result := FColorsForm.ColorPanel.Options;
end;

procedure TJvCustomOfficeColorButton.SetColorDialogOptions(
  const Value: TColorDialogOptions);
begin
  FColorsForm.ColorPanel.Options := Value;
end;
{$ENDIF VCL}

function TJvCustomOfficeColorButton.GetProperties: TJvOfficeColorButtonProperties;
begin
  Result := FProperties;
end;

procedure TJvCustomOfficeColorButton.SetProperties(const Value: TJvOfficeColorButtonProperties);
begin
  if FProperties <> Value then
  begin
    FProperties.Assign(Value);
    FColorsForm.ColorPanel.Properties.Assign(Value);
  end;
end;

type
  THackColorPanel = class(TJvOfficeColorPanel);

procedure TJvCustomOfficeColorButton.PropertiesChanged(Sender: TObject;
  PropName: string);
begin
  if cmp(PropName, 'ShowDragBar') then
  begin
    if FColorsForm.ShowDragBar <> Properties.ShowDragBar then
      FColorsForm.ShowDragBar := Properties.ShowDragBar;
    if not Properties.ShowDragBar and
      THackJvColorForm(FColorsForm).DropDownMoved then
      AdjustColorForm;
  end
  else if cmp(PropName, 'DragCaption') then
  begin
    FColorsForm.Caption := Properties.DragCaption;
  end
  else if cmp(PropName, 'DragBarHeight') then
  begin
    FColorsForm.DragBarHeight := Properties.DragBarHeight;
    AdjustColorForm;
  end
  else if cmp(PropName, 'DragBarSpace') then
  begin
    FColorsForm.DragBarSpace := Properties.DragBarSpace;
    AdjustColorForm;
  end
  else if cmp(PropName, 'ArrowWidth') then
  begin
    AdjustSize;
  end
  else if cmp(PropName, 'EdgeWidth') then
  begin
    FMainButton.EdgeWidth := Properties.EdgeWidth;
  end
  else
  begin
    FColorsForm.ColorPanel.Properties.Assign(Properties);
    THackColorPanel(FColorsForm.ColorPanel).PropertiesChanged(Properties, PropName);
    THackJvColorForm(FColorsForm).AdjustColorForm;
  end;
end;

procedure TJvCustomOfficeColorButton.DefineProperties(Filer: TFiler);
begin
  inherited;
 //Hint:next 3  for compatible old version
  Filer.DefineProperty('ArrowWidth', ReadArrowWidth, nil, True);
  Filer.DefineProperty('EdgeWidth', ReadEdgeWidth, nil, True);
  Filer.DefineProperty('OtherCaption', ReadOtherCaption, nil, True);

end;

procedure TJvCustomOfficeColorButton.ReadArrowWidth(Reader: TReader);
begin
  Properties.ArrowWidth := Reader.ReadInteger;
end;

procedure TJvCustomOfficeColorButton.ReadEdgeWidth(Reader: TReader);
begin
  Properties.EdgeWidth := Reader.ReadInteger;
end;

procedure TJvCustomOfficeColorButton.ReadOtherCaption(Reader: TReader);
begin
  Properties.OtherCaption := Reader.ReadString;
end;

{ TJvColorArrowButton }

procedure TJvColorArrowButton.Paint;
const
  DownStyles: array[Boolean] of Integer = (BDR_RAISEDINNER, BDR_SUNKENOUTER);
  FillStyles: array[Boolean] of Integer = (BF_MIDDLE, 0);
  FArrowWidth = 6;
var
  PaintRect: TRect;
  DrawFlags: Integer;
  Offset: TPoint;
  Push: Boolean;
begin
  inherited;

  { calculate were to put arrow part }
  PaintRect := Rect(0, 0,
    Width, Height);
{$IFDEF JVCLThemesEnabled}
  if ThemeServices.ThemesEnabled then
    Dec(PaintRect.Left);
{$ENDIF JVCLThemesEnabled}

  Push := Down or (FState in [rbsDown, rbsExclusive]);
  if Push then
  begin
    Offset.X := 1;
    Offset.Y := 1;
  end
  else
  begin
    Offset.X := 0;
    Offset.Y := 0;
  end;

  if not Flat then
  begin
    DrawFlags := DFCS_BUTTONPUSH; // or DFCS_ADJUSTRECT;
    if Push then
      DrawFlags := DrawFlags or DFCS_PUSHED;
    if IsMouseOver(self) then
      DrawFlags := DrawFlags or DFCS_HOT;
    DrawThemedFrameControl(self, Canvas.Handle, PaintRect, DFC_BUTTON, DrawFlags);
  end
  else if MouseInControl and Enabled or (csDesigning in ComponentState) then
    DrawEdge(Canvas.Handle, PaintRect, DownStyles[Push],
      FillStyles[Flat] or BF_RECT);

  { Draw arrow }
  if Enabled then
  begin
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Color := clBlack;
  end
  else
  begin
    Canvas.Pen.Color := clBtnShadow;
  end;
  Canvas.Brush.Style := bsSolid;
  DrawTriangle(Canvas, (Height div 2) - 2, (Width - FArrowWidth) div 2, FArrowWidth);
end;

{ TJvOfficeColorButtonProperties }

procedure TJvOfficeColorButtonProperties.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TJvOfficeColorButtonProperties then
    with TJvOfficeColorButtonProperties(Source) do
    begin
      self.ShowDragBar := ShowDragBar;
      self.DragCaption := DragCaption;
      self.EdgeWidth := EdgeWidth;
      self.ArrowWidth := ArrowWidth;
      self.DragBarHeight := DragBarHeight;
      self.DragBarSpace := DragBarSpace;
    end;
end;

constructor TJvOfficeColorButtonProperties.Create;
begin
  inherited;
  FShowDragBar := True;
  FEdgeWidth := 4;
  FArrowWidth := MinArrowWidth;
  FDragBarHeight := MinDragBarHeight;
  FDragBarSpace := MinDragBarSpace;
end;

procedure TJvOfficeColorButtonProperties.SetArrowWidth(const Value: integer);
begin
  if FArrowWidth <> Value then
  begin
    FArrowWidth := Value;
    Changed('ArrowWidth');
  end;
end;

procedure TJvOfficeColorButtonProperties.SetDragBarHeight(const Value: integer);
begin
  if FDragBarHeight <> Value then
  begin
    FDragBarHeight := Value;
    Changed('DragBarHeight');
  end;
end;

procedure TJvOfficeColorButtonProperties.SetDragBarSpace(const Value: integer);
begin
  if FDragBarSpace <> Value then
  begin
    FDragBarSpace := Value;
    Changed('DragBarSpace');
  end;
end;

procedure TJvOfficeColorButtonProperties.SetDragCaption(const Value: string);
begin
  if FDragCaption <> Value then
  begin
    FDragCaption := Value;
    Changed('DragCaption');
  end;
end;

procedure TJvOfficeColorButtonProperties.SetEdgeWidth(const Value: Integer);
begin
  if FEdgeWidth <> Value then
  begin
    FEdgeWidth := Value;
    Changed('EdgeWidth');
  end;
end;

procedure TJvOfficeColorButtonProperties.SetShowDragBar(const Value: Boolean);
begin
  if FShowDragBar <> Value then
  begin
    FShowDragBar := Value;
    Changed('ShowDragBar');
  end;
end;

end.

