{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvColorForm.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is Peter Th�rnqvist [peter3@peter3.com]
Portions created by Peter Th�rnqvist are Copyright (C) 2002 Peter Th�rnqvist.
All Rights Reserved.

Contributor(s):dejoy(dejoy@ynl.gov.cn)

Last Modified: 2004-02-6

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Description:
  Color form for the @link(TJvColorButton) component

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvOfficeColorPanel;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF MSWINDOWS}
  SysUtils, Classes,
{$IFDEF VCL}
  Graphics, Controls, Forms, Buttons, ExtCtrls, Dialogs,
{$ENDIF VCL}
{$IFDEF VisualCLX}
  QWindows, Types, Qt, QGraphics, QControls, QForms, QButtons, QExtCtrls, QDialogs,
{$ENDIF VisualCLX}
  JvComponent, JvSpeedButton;

const

  MaxColorButtonNumber = 40;

  Tag_AutoCaption = 0;
  Tag_OtherCaption = 1;
  Tag_AutoHint = 2;
  Tag_OtherHint = 3;

{------------------------------------------------------------------------------}
const
  MinButtonHeight = 22;
  MinButtonWidth = 23;
  MinColorSize = 18;
  MinColorSpace = 0;
  MinColorSpaceTop = 4;
  MinColorSpaceBottom = 4;
  MinTopMargin = 2;
  MinBottomMargin = 4;
  MinHoriMargin = 7;

  Tag_ButtonHeight = 0;
  Tag_ButtonWidth = 1;
  Tag_ColorSize = 2;
  Tag_ColorSpace = 3;
  Tag_ColorSpaceTop = 4;
  Tag_ColorSpaceBottom = 5;
  Tag_TopMargin = 6;
  Tag_BottomMargin = 7;
  Tag_HoriMargin = 8;

  LineColorButtonCount = 8;

  SubColorButtonColors: array[0..MaxColorButtonNumber - 1] of TColor = (
    $000000, $003399, $003333, $003300, $663300, $800000, $993333, $333333,
    $000080, $0066FF, $008080, $008000, $808000, $FF0000, $996666, $808080,
    $0000FF, $0099FF, $00CC99, $669933, $CCCC33, $FF6633, $800080, $999999,
    $FF00FF, $00CCFF, $00FFFF, $00FF00, $FFFF00, $FFCC00, $663399, $C0C0C0,
    $CC99FF, $99CCFF, $99FFFF, $CCFFCC, $FFFFCC, $FFCC99, $FF99CC, $FFFFFF);

{------------------------------------------------------------------------------}

type

  TJvPropertiesChangedEvent = procedure(Sender: TObject; PropName: string) of object;

  TJvColorSpeedButton = class(TJvSpeedButton);

  TJvSubColorButton = class(TJvColorSpeedButton)
  private
    procedure SetEdgeWidth(const Value: Integer);
  protected
    FEdgeWidth: Integer;
    procedure Paint; override;
    function GetEdgeWidth: integer; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    property Canvas;
    property EdgeWidth: Integer read GetEdgeWidth write SetEdgeWidth;
  published
    property Color;
  end;

 // (ahuser) TJvColorDialog is not registered as component
  TJvOfficeColorDialog = class(TColorDialog)
  published
    property OnShow;
    property OnClose;
  end;

  TJvOfficeColorPanelProperties = class(TPersistent)
  private
    FShowAutoButton: Boolean;
    FShowOtherButton: Boolean;
    FTopMargin: integer;
    FColorSpaceBottom: integer;
    FHoriMargin: integer;
    FColorSpace: integer;
    FColorSpaceTop: integer;
    FButtonHeight: integer;
    FColorSize: integer;
    FBottomMargin: integer;

    FAutoCaption: string;
    FOtherCaption: string;
    FAutoHint: string;
    FOtherHint: string;

    FOnPropertiesChanged: TJvPropertiesChangedEvent;
    procedure SetShowAutoButton(const Value: Boolean);
    procedure SetShowOtherButton(const Value: Boolean);
    procedure SetMeasure(const Index, Value: integer);
    function GetStringValue(const Index: Integer): string;
    procedure SetStringValue(const Index: Integer; const Value: string);
  protected
    procedure Changed(PropName: string); virtual;
    procedure CreateDefaultText; virtual;
  public
    constructor Create(); virtual;
    procedure Assign(Source: TPersistent); override;
    property OnPropertiesChanged: TJvPropertiesChangedEvent read FOnPropertiesChanged write FOnPropertiesChanged;
  published
    property ShowAutoButton: Boolean read FShowAutoButton write SetShowAutoButton default True;
    property ShowOtherButton: Boolean read FShowOtherButton write SetShowOtherButton default True;

    property TopMargin: integer index Tag_TopMargin read FTopMargin write SetMeasure default MinTopMargin;
    property BottomMargin: integer index Tag_BottomMargin read FBottomMargin write SetMeasure default MinBottomMargin;
    property HoriMargin: integer index Tag_HoriMargin read FHoriMargin write SetMeasure default MinHoriMargin;
    property ColorSpace: integer index Tag_ColorSpace read FColorSpace write SetMeasure default MinColorSpace;
    property ColorSpaceTop: integer index Tag_ColorSpaceTop read FColorSpaceTop write SetMeasure default
      MinColorSpaceTop;
    property ColorSpaceBottom: integer index Tag_ColorSpaceBottom read FColorSpaceBottom write SetMeasure default
      MinColorSpaceBottom;
    property ColorSize: integer index Tag_ColorSize read FColorSize write SetMeasure default MinColorSize;
    property ButtonHeight: integer index Tag_ButtonHeight read FButtonHeight write SetMeasure default MinButtonHeight;

    property AutoCaption: string index Tag_AutoCaption read GetStringValue write SetStringValue;
    property OtherCaption: string index Tag_OtherCaption read GetStringValue write SetStringValue;
    property AutoHint: string index Tag_AutoHint read GetStringValue write SetStringValue;
    property OtherHint: string index Tag_OtherHint read GetStringValue write SetStringValue;
  end;

  TJvCustomOfficeColorPanel = class(TJvCustomPanel)
  private

    FColorButtons: array[0..MaxColorButtonNumber - 1] of TJvSubColorButton;
    FAutoButton: TJvSubColorButton;
    FOtherButton: TJvColorSpeedButton;

    FProperties: TJvOfficeColorPanelProperties;

    FOwner: TControl;
    FColorDialog: TJvOfficeColorDialog;
    FSelectedColor: TColor;
    FWordStyle: Boolean;
    FFlat: boolean;
    Inited: boolean;
    FOnColorChange: TNotifyEvent;

{$IFDEF VCL}
    FColorDialogOptions: TColorDialogOptions;
    procedure SetColorDialogOptions(const Value: TColorDialogOptions);
{$ENDIF VCL}

    procedure ColorButtonClick(Sender: TObject);
    procedure SetFlat(const Value: boolean);
    procedure SetSelectedColor(const Value: TColor);
    function GetCustomColors: TStrings;
    procedure SetCustomColors(const Value: TStrings);

    function GetProperties: TJvOfficeColorPanelProperties; virtual;
    procedure SetProperties(const Value: TJvOfficeColorPanelProperties); virtual;

  protected
{$IFDEF VCL}
    procedure CreateWnd; override;
{$ENDIF VCL}
{$IFDEF VisualCLX}
    procedure InitWidget; override;
{$ENDIF VisualCLX}

    procedure Loaded; override;
    procedure Resize; override;
    procedure Paint; override;
    procedure ShowHintChanged; override;
    procedure PropertiesChanged(Sender: TObject; PropName: string); virtual;

    procedure SetWordStyle(const Value: boolean);
    procedure MakeColorButtons;
    procedure AdjustColorButtons();

    procedure SetEnabled({$IFDEF VisualCLX}const{$ENDIF}Value: Boolean); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetButton(Button: TControl);
    property ColorDialog: TJvOfficeColorDialog read FColorDialog write FColorDialog;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default clBlack;

    property Color: TColor read FSelectedColor write SetSelectedColor default clBlack;
    property Flat: boolean read FFlat write SetFlat default true;
    property CustomColors: TStrings read GetCustomColors write SetCustomColors;

    property Properties: TJvOfficeColorPanelProperties read GetProperties write SetProperties;
{$IFDEF VCL}
    property Options: TColorDialogOptions read FColorDialogOptions write SetColorDialogOptions default [];
{$ENDIF VCL}

    property OnColorChange: TNotifyEvent read FOnColorChange write FOnColorChange;

  end;

  TJvOfficeColorPanel = class(TJvCustomOfficeColorPanel)
  published
    property Flat;
    property Color;
    property CustomColors;
{$IFDEF VCL}
    property Options;
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

    property Properties;
    property OnColorChange;
  end;

implementation

uses
  JvJCLUtils;

{ TJvOfficeColorPanelProperties }

procedure TJvOfficeColorPanelProperties.Assign(Source: TPersistent);
begin
  if Source is TJvOfficeColorPanelProperties then
    with TJvOfficeColorPanelProperties(Source) do
    begin
      self.ShowAutoButton := ShowAutoButton;
      self.ShowOtherButton := ShowOtherButton;
      Self.TopMargin := TopMargin;
      Self.ColorSpaceBottom := ColorSpaceBottom;
      Self.HoriMargin := HoriMargin;
      Self.ColorSpace := ColorSpace;
      Self.ColorSpaceTop := ColorSpaceTop;
      Self.ButtonHeight := ButtonHeight;
      Self.ColorSize := ColorSize;
      Self.BottomMargin := BottomMargin;

      Self.AutoCaption := AutoCaption;
      Self.OtherCaption := OtherCaption;
      Self.AutoHint := AutoHint;
      Self.OtherHint := OtherHint;

    end;
end;

procedure TJvOfficeColorPanelProperties.Changed(PropName: string);
begin
  if Assigned(FOnPropertiesChanged) then
    FOnPropertiesChanged(self, PropName);
end;

constructor TJvOfficeColorPanelProperties.Create;
begin
  inherited;
  FShowAutoButton := True;
  FShowOtherButton := True;

  FHoriMargin := MinHoriMargin;
  FTopMargin := MinTopMargin;
  FColorSpace := MinColorSize;
  FColorSpaceTop := MinColorSpaceTop;
  FColorSize := MinColorSize;
  FButtonHeight := MinButtonHeight;
  FColorSpaceBottom := MinColorSpaceBottom;
  FBottomMargin := MinBottomMargin;

  CreateDefaultText;
end;

procedure TJvOfficeColorPanelProperties.CreateDefaultText;
begin
  FAutoCaption := 'Automatic';
  FOtherCaption := 'Other Colors...';
end;

function TJvOfficeColorPanelProperties.GetStringValue(
  const Index: Integer): string;
begin
  case index of
    Tag_AutoCaption:
      Result := FAutoCaption;
    Tag_OtherCaption:
      Result := FOtherCaption;
    Tag_AutoHint:
      Result := FAutoHint;
    Tag_OtherHint:
      Result := FOtherHint;
  end;

end;

procedure TJvOfficeColorPanelProperties.SetMeasure(const Index, Value: integer);
var
  MeasureItem: PInteger;
  MeasureConst: integer;
  LName: string;
begin
  case Index of
    Tag_TopMargin:
      begin
        MeasureItem := @FTopMargin;
        MeasureConst := MinTopMargin;
        LName := 'TopMargin';
      end;
    Tag_BottomMargin:
      begin
        MeasureItem := @FBottomMargin;
        MeasureConst := MinBottomMargin;
        LName := 'BottomMargin';
      end;
    Tag_HoriMargin:
      begin
        MeasureItem := @FHoriMargin;
        MeasureConst := MinHoriMargin;
        LName := 'HoriMargin';
      end;
    Tag_ColorSpace:
      begin
        MeasureItem := @FColorSpace;
        MeasureConst := MinColorSpace;
        LName := 'ColorSpace';
      end;
    Tag_ColorSpaceTop:
      begin
        MeasureItem := @FColorSpaceTop;
        MeasureConst := MinColorSpaceTop;
        LName := 'ColorSpaceTop';
      end;
    Tag_ColorSpaceBottom:
      begin
        MeasureItem := @FColorSpaceBottom;
        MeasureConst := MinColorSpaceBottom;
        LName := 'ColorSpaceBottom';
      end;
    Tag_ColorSize:
      begin
        MeasureItem := @FColorSize;
        MeasureConst := MinColorSize;
        LName := 'ColorSize';
      end;
    Tag_ButtonHeight:
      begin
        MeasureItem := @FButtonHeight;
        MeasureConst := MinButtonHeight;
        LName := 'ButtonHeight';
      end;
  else
    Exit;
  end;
  if MeasureItem^ = Value then Exit;

  MeasureItem^ := Value;
  if MeasureItem^ < MeasureConst then MeasureItem^ := MeasureConst;
  Changed(LName);
end;

procedure TJvOfficeColorPanelProperties.SetShowAutoButton(const Value: Boolean);
begin
  FShowAutoButton := Value;
  Changed('ShowAutoButton');
end;

procedure TJvOfficeColorPanelProperties.SetShowOtherButton(const Value: Boolean);
begin
  FShowOtherButton := Value;
  Changed('ShowOtherButton');
end;

procedure TJvOfficeColorPanelProperties.SetStringValue(const Index: Integer;
  const Value: string);
begin
  case index of
    Tag_AutoCaption:
      begin
        if FAutoCaption <> Value then
        begin
          FAutoCaption := Value;
          Changed('AutoCaption');
        end;
      end;
    Tag_OtherCaption:
      begin
        if FOtherCaption <> Value then
        begin
          FOtherCaption := Value;
          Changed('OtherCaption');
        end;
      end;
    Tag_AutoHint:
      if FAutoHint <> Value then
      begin
        FAutoHint := Value;
        Changed('AutoHint');
      end;
    Tag_OtherHint:
      if FAutoHint <> Value then
      begin
        FOtherHint := Value;
        Changed('OtherHint');
      end;
  end;
end;

{ TJvSubColorButton }

constructor TJvSubColorButton.Create(AOwner: TComponent);
begin
  inherited;
  FEdgeWidth := 4;
end;

function TJvSubColorButton.GetEdgeWidth: integer;
begin
  Result := Height div 5;
end;

procedure TJvSubColorButton.Paint;
var
  B, X, Y: integer;
  FColor: TColor;
begin
  inherited;
  if not Visible then Exit;

  if Enabled then
    FColor := Color
  else
    FColor := clGray;
  if EdgeWidth >= 0 then
    B := EdgeWidth
  else
    B := Height div 5;
  with Canvas do
  begin
    if (not Glyph.Empty) then
    begin
      Glyph.Transparent := true;
      X := (Width div 2) - 9 + Integer(FState in [TJvButtonState(bsDown)]);
      Y := (Height div 2) + 4 + Integer(FState in [TJvButtonState(bsDown)]);
      Pen.Color := FColor;
      Brush.Color := FColor;
      Brush.Style := bsSolid;
      Rectangle(X, Y, X + 17, Y + 4);
    end
    else
    begin
      if Caption = '' then
      begin
        Pen.Color := clgray;
        Brush.Color := FColor;
        Brush.Style := bsSolid;
        Rectangle(B, B, Width - B, Height - B);
      end
      else
      begin
        Pen.Color := clgray;
        Brush.Style := bsClear;
        Polygon([Point(B - 1, B - 1), Point(Width - (B - 1), B - 1),
          Point(Width - (B - 1), Height - (B - 1)), Point(B - 1, Height - (B - 1))]);
        Pen.Color := clgray;
        Brush.Color := FColor;
        Brush.Style := bsSolid;
        Rectangle(B + 1, B + 1, Height, Height - B);
      end;
    end;
  end;
end;

procedure TJvSubColorButton.SetEdgeWidth(const Value: Integer);
begin
  if FEdgeWidth <> Value then
  begin
    FEdgeWidth := Value;
    Repaint;
  end;
end;

//=== TJvCustomOfficeColorPanel ===========================================================

constructor TJvCustomOfficeColorPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Inited := false;
  FSelectedColor := clBlack;
{$IFDEF VCL}
  FColorDialogOptions := [];
{$ENDIF VCL}

  FProperties := TJvOfficeColorPanelProperties.Create;
  FProperties.OnPropertiesChanged := PropertiesChanged;

  FAutoButton := TJvSubColorButton.Create(self);

  with FAutoButton do
  begin
    Parent := self;
    GroupIndex := 1;
    Tag := MaxColorButtonNumber + 1;
    Down := true;
    AllowAllUp := true;
    Color := clDefault;
    Visible := False;
    OnClick := ColorButtonClick;
  end;

  FOtherButton := TJvSubColorButton.Create(self);
  with FOtherButton do
  begin
    Parent := self;
    GroupIndex := 1;
    Tag := MaxColorButtonNumber + 2;
    Color := clDefault;
    AllowAllUp := true;
    Visible := False;

    OnClick := ColorButtonClick;
  end;

  FColorDialog := TJvOfficeColorDialog.Create(Self);
{$IFDEF VCL}
  FColorDialog.Options := FColorDialogOptions;
{$ENDIF VCL}

  Font.Name := 'MS Shell Dlg 2';
  FAutoButton.Flat := True;
  FOtherButton.Flat := True;
  Flat := True;
  SetWordStyle(true);

  MakeColorButtons;

  Inited := True;

end;

destructor TJvCustomOfficeColorPanel.Destroy;
begin
  FProperties.Free;
  inherited;
end;

procedure TJvCustomOfficeColorPanel.SetButton(Button: TControl);
begin
  FOwner := Button;
end;

procedure TJvCustomOfficeColorPanel.MakeColorButtons;
var
  i: integer;
begin
  for I := 0 to MaxColorButtonNumber - 1 do
  begin
    if FColorButtons[I] <> nil then
      FColorButtons[I].Free;
    FColorButtons[I] := TJvSubColorButton.Create(self);
    with FColorButtons[I] do
    begin
      Parent := self;
      GroupIndex := 1;
      AllowAllUp := true;
      Color := SubColorButtonColors[I];
      Tag := I;
      Flat := True;
      OnClick := ColorButtonClick;
    end;
  end;
  Invalidate;
end;

procedure TJvCustomOfficeColorPanel.AdjustColorButtons();
var
  I: integer;
  ButtonLine: integer;
  TempHeight: integer;
  LButtonCount, LColorsButtonTop, LColorsButtonLeft: Integer;
begin
  if (not Inited) or (Parent = nil) then Exit;
  DisableAlign;
  TempHeight := 0;
  LButtonCount := 0;
  ButtonLine := (MaxColorButtonNumber + LineColorButtonCount - 1) div LineColorButtonCount;

  if Properties.ShowAutoButton then
    inc(LButtonCount);
  if Properties.ShowOtherButton then
    inc(LButtonCount);

  with Properties do
  begin
    Width := HoriMargin * 2 + ColorSize * LineColorButtonCount + ColorSpace * (LineColorButtonCount - 1);
    Height := TopMargin + BottomMargin + ColorSpaceTop + ColorSpaceBottom + ColorSize * ButtonLine + ColorSpace *
      (ButtonLine - 1) + ButtonHeight * LButtonCount + TempHeight;
  end;

  with Properties do
    if not Properties.ShowAutoButton then
    begin
      FAutoButton.Visible := False;
      LColorsButtonTop := 0;
      LColorsButtonLeft := HoriMargin;
    end
    else
    begin
      FAutoButton.Visible := True;
      FAutoButton.Caption := AutoCaption;
      LColorsButtonTop := FAutoButton.Top + FAutoButton.Height;
      FAutoButton.SetBounds(HoriMargin, TopMargin + TempHeight, ClientWidth - HoriMargin * 2, ButtonHeight);
      LColorsButtonLeft := FAutoButton.Left;
    end;

  with Properties do
    for I := 0 to MaxColorButtonNumber - 1 do
      FColorButtons[I].SetBounds(LColorsButtonLeft + (I mod LineColorButtonCount) * (ColorSpace + ColorSize),
        LColorsButtonTop + ColorSpaceTop + (I div LineColorButtonCount) * (ColorSpace + ColorSize),
        ColorSize,
        ColorSize);

  with Properties do
    if not Properties.ShowOtherButton then
      FOtherButton.Visible := False
    else
    begin
      FOtherButton.Visible := True;
      FOtherButton.Caption := OtherCaption;
      FOtherButton.SetBounds(FAutoButton.Left,
        FColorButtons[MaxColorButtonNumber - 1].Top + ColorSize + ColorSpaceBottom,
        FAutoButton.Width,
        ButtonHeight);
    end;

end;

procedure TJvCustomOfficeColorPanel.ColorButtonClick(Sender: TObject);
{$IFDEF VisualCLX}
var
  i: integer;
{$ENDIF VisualCLX}
begin
  if TComponent(Sender).Tag = FOtherButton.Tag then
  begin
{$IFDEF VCL}
    FColorDialog.Options := FColorDialogOptions;
{$ENDIF VCL}
    FColorDialog.Color := FSelectedColor;
    if FColorDialog.Execute then
    begin
      SetSelectedColor(FColorDialog.Color);
      FOtherButton.Color := FSelectedColor;
    end
    else
      Exit;
  end
  else
  begin
    TJvSubColorButton(Sender).Down := true;
{$IFDEF VisualCLX}
  //in clx have bug
    FAutoButton.Down := FAutoButton = Sender;
    FOtherButton.Down := FOtherButton = Sender;
    for I := 0 to MaxColorButtonNumber - 1 do
    begin
      FColorButtons[I].Down := FColorButtons[I] = Sender;
    end;
{$ENDIF VisualCLX}
    SetSelectedColor(TJvSubColorButton(Sender).Color);
  end;
end;

procedure TJvCustomOfficeColorPanel.SetWordStyle(const Value: boolean);
begin
  if FWordStyle <> Value then
  begin
    FWordStyle := Value;
    with Properties do
      if FWordStyle then
      begin
        SetFlat(true);

        ButtonHeight := MinButtonHeight;
        ColorSize := MinColorSize;
        ColorSpace := MinColorSpace;
        ColorSpaceTop := MinColorSpaceTop;
        ColorSpaceBottom := MinColorSpaceBottom;
        TopMargin := MinTopMargin;
        BottomMargin := MinBottomMargin;
        HoriMargin := MinHoriMargin;

      end;
  end;
end;

procedure TJvCustomOfficeColorPanel.SetFlat(const Value: boolean);
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    Invalidate;
  end;
end;

procedure TJvCustomOfficeColorPanel.SetSelectedColor(const Value: TColor);
var
  I: integer;
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;
    Color := Value;
    if FAutoButton.Color = Value then
      FAutoButton.Down := true
    else
    begin
      FAutoButton.Down := false;
      for I := 0 to MaxColorButtonNumber - 1 do
        if FColorButtons[I].Color = Value then
        begin
          FColorButtons[I].Down := true;
          Break;
        end
        else
          FColorButtons[I].Down := false;
    end;

    if Assigned(FOnColorChange) then
      FOnColorChange(Self);
  end;
end;

function TJvCustomOfficeColorPanel.GetCustomColors: TStrings;
begin
  Result := FColorDialog.CustomColors;
end;

procedure TJvCustomOfficeColorPanel.SetCustomColors(const Value: TStrings);
begin
  FColorDialog.CustomColors.Assign(Value);
end;

procedure TJvCustomOfficeColorPanel.Resize;
begin
  inherited;
  if Inited then
    AdjustColorButtons();
end;

procedure TJvCustomOfficeColorPanel.Paint;
begin
  inherited;
  if FFlat then
  begin
    Canvas.Brush.Color := clBtnFace;
{$IFDEF VCL}
    Canvas.FrameRect(ClientRect);
{$ENDIF VCL}
{$IFDEF VisualCLX}
    FrameRect(Canvas, ClientRect);
{$ENDIF VisualCLX}
    Canvas.Brush.Color := Color;
  end;
  if Inited then
    AdjustColorButtons();

end;

procedure TJvCustomOfficeColorPanel.SetEnabled({$IFDEF VisualCLX}const{$ENDIF}Value: Boolean);
var
  i: integer;
begin
  inherited SetEnabled(Value);
  FAutoButton.Enabled := Value;
  FOtherButton.Enabled := Value;
  for I := 0 to MaxColorButtonNumber - 1 do
    FColorButtons[I].Enabled := Value;
end;

procedure TJvCustomOfficeColorPanel.ShowHintChanged;
var
  i: integer;
begin
  inherited;
  FAutoButton.ShowHint := ShowHint;
  FOtherButton.ShowHint := ShowHint;
  for I := 0 to MaxColorButtonNumber - 1 do
  begin
    FColorButtons[I].ShowHint := ShowHint;
  end;
end;

{$IFDEF VCL}

procedure TJvCustomOfficeColorPanel.SetColorDialogOptions(const Value: TColorDialogOptions);
begin
  if FColorDialogOptions <> Value then
    FColorDialogOptions := Value;
end;
{$ENDIF VCL}

procedure TJvCustomOfficeColorPanel.Loaded;
begin
  inherited;
end;

{$IFDEF VCL}

procedure TJvCustomOfficeColorPanel.CreateWnd;
begin
  inherited CreateWnd;
  AdjustColorButtons;
end;
{$ENDIF VCL}

{$IFDEF VisualCLX}

procedure TJvCustomOfficeColorPanel.InitWidget;
begin
  inherited;
  AdjustColorButtons;
end;
{$ENDIF VisualCLX}

function TJvCustomOfficeColorPanel.GetProperties: TJvOfficeColorPanelProperties;
begin
  Result := FProperties;
end;

procedure TJvCustomOfficeColorPanel.SetProperties(
  const Value: TJvOfficeColorPanelProperties);
begin
  if FProperties <> Value then
    FProperties.Assign(Value);
end;

procedure TJvCustomOfficeColorPanel.PropertiesChanged(Sender: TObject;
  PropName: string);
var
  LFlag: Boolean;
begin
  LFlag := False;
  if cmp(PropName, 'ShowAutoButton') or cmp(PropName, 'ShowOtherButton') then
    LFlag := True
  else if cmp(PropName, 'AutoCaption') then
  begin
    if Properties.AutoCaption = '' then
      Properties.ShowAutoButton := False;
  end
  else if cmp(PropName, 'OtherCaption') then
  begin
    if Properties.OtherCaption = '' then
      Properties.ShowOtherButton := False;
  end
  else if cmp(PropName, 'AutoHint') then
  begin
    FAutoButton.Hint := Properties.AutoHint;
  end
  else if cmp(PropName, 'OtherHint') then
  begin
    FOtherButton.Hint := Properties.OtherHint;
  end
  else
    LFlag := True
      ;
  if LFlag then
    AdjustColorButtons;

end;

end.

