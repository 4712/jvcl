{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: FullColorFrm.pas, released on 2004-10-11.

The Initial Developer of the Original Code is Florent Ouchet [ouchet dott florent att laposte dott net]
Portions created by Florent Ouchet are Copyright (C) 2004 Florent Ouchet.
All Rights Reserved.

Contributor(s): -

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit FullColorFrm;

{$I jvcl.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Graphics,
  Dialogs, StdCtrls, Spin, ExtCtrls,
  ColorCtrls, ColorSpaces, ColorDialogs, ColorSpacesStd;

type
  TJvFullColorForm = class(TJvBaseFullColorForm)
    LabelColorSpace: TLabel;
    GroupBoxSettings: TGroupBox;
    ScrollBarAxis0: TScrollBar;
    ScrollBarAxis1: TScrollBar;
    ScrollBarAxis2: TScrollBar;
    SpinEditAxis0: TSpinEdit;
    SpinEditAxis1: TSpinEdit;
    SpinEditAxis2: TSpinEdit;
    LabelAxis0: TLabel;
    LabelAxis1: TLabel;
    LabelAxis2: TLabel;
    LabelPredefined: TLabel;
    PanelGraphic: TPanel;
    JvColorPanel: TJvColorPanel;
    JvFullColorTrackBar: TJvFullColorTrackBar;
    ButtonGraphics: TButton;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    LabelDrawOld: TLabel;
    LabelDrawNew: TLabel;
    LabelOld: TLabel;
    LabelNew: TLabel;
    LabelAxis: TLabel;
    ButtonApply: TButton;
    JvColorAxisConfigCombo: TJvColorAxisConfigCombo;
    JvColorSpaceCombo: TJvColorSpaceCombo;
    ColorBox: TColorBox;
    procedure ButtonGraphicsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxColorSpaceChange(Sender: TObject);
    procedure SpinEditChange(Sender: TObject);
    procedure ScrollBarChange(Sender: TObject);
    procedure JvColorPanelColorChange(Sender: TObject);
    procedure ComboBoxAxisChange(Sender: TObject);
    procedure ComboBoxPredefinedChange(Sender: TObject);
    procedure ButtonApplyClick(Sender: TObject);
    procedure LabelDrawOldClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FUpdating: Boolean;
    FExpanded: Boolean;
    FExpandedWidth: Integer;
    FScrollBarAxes: array [TJvAxisIndex] of TScrollBar;
    FSpinEditAxes: array [TJvAxisIndex] of TSpinEdit;
    FLabelAxes: array [TJvAxisIndex] of TLabel;
    FFilled: Boolean;
    procedure FillInternalArrays;
  protected
    procedure UpdateColorValue;
    procedure UpdateColorSpace;
    procedure SetFullColor(const Value: TJvFullColor); override;
    procedure SetOptions(const Value: TJvFullColorDialogOptions); override;
    procedure Loaded; override;
    property Expanded: Boolean read FExpanded;
  public
    procedure Expand;
    procedure Collapse;
  end;

implementation

{$IFDEF UNITVERSIONING}
uses
  JclUnitVersioning;
{$ENDIF UNITVERSIONING}

{$R *.dfm}

function AxisIndexFromTag(ATag: Integer): TJvAxisIndex;
begin
  Result := TJvAxisIndex(ATag and $03);
end;

procedure TJvFullColorForm.ButtonGraphicsClick(Sender: TObject);
begin
  if Expanded then
    Collapse
  else
    Expand;
end;

procedure TJvFullColorForm.FormCreate(Sender: TObject);
begin
  LabelDrawOld.Color := ColorSpaceManager.ConvertToID(FullColor, csRGB);
  SetFullColor(FullColor);
  SetOptions(Options);
end;

procedure TJvFullColorForm.FillInternalArrays;
begin
  if not FFilled then
  begin
    FScrollBarAxes[axIndex0] := ScrollBarAxis0;
    FScrollBarAxes[axIndex1] := ScrollBarAxis1;
    FScrollBarAxes[axIndex2] := ScrollBarAxis2;
    FSpinEditAxes[axIndex0] := SpinEditAxis0;
    FSpinEditAxes[axIndex1] := SpinEditAxis1;
    FSpinEditAxes[axIndex2] := SpinEditAxis2;
    FLabelAxes[axIndex0] := LabelAxis0;
    FLabelAxes[axIndex1] := LabelAxis1;
    FLabelAxes[axIndex2] := LabelAxis2;
    FFilled := True;
  end;
end;

procedure TJvFullColorForm.Loaded;
begin
  inherited Loaded;
  FExpandedWidth := Width;
end;

procedure TJvFullColorForm.Expand;
begin
  Width := FExpandedWidth;
  PanelGraphic.Visible := True;
  ButtonGraphics.Caption := RsExpandedCaption;
  FExpanded := True;
end;

procedure TJvFullColorForm.Collapse;
begin
  Width := PanelGraphic.Left - 1;
  PanelGraphic.Visible := False;
  ButtonGraphics.Caption := RsCollapsedCaption;
  FExpanded := False;
end;

procedure TJvFullColorForm.SpinEditChange(Sender: TObject);
begin
  if FUpdating then
    Exit;
  FUpdating := True;
  with Sender as TSpinEdit do
    FullColor := SetAxisValue(FullColor, AxisIndexFromTag(Tag), Value);
  FUpdating := False;
  UpdateColorValue;
end;

procedure TJvFullColorForm.ScrollBarChange(Sender: TObject);
begin
  if FUpdating then
    Exit;
  FUpdating := True;
  with Sender as TScrollBar do
    FullColor := SetAxisValue(FullColor, AxisIndexFromTag(Tag), Position);
  FUpdating := False;
  UpdateColorValue;
end;

procedure TJvFullColorForm.JvColorPanelColorChange(Sender: TObject);
begin
  if FUpdating then
    Exit;
  FUpdating := True;
  FullColor := (Sender as TJvColorPanel).FullColor;
  FUpdating := False;
  UpdateColorValue;
end;

procedure TJvFullColorForm.ComboBoxColorSpaceChange(Sender: TObject);
begin
  if FUpdating then
    Exit;
  FUpdating := True;
  with Sender as TJvColorSpaceCombo do
    FullColor := ColorSpaceManager.ConvertToID(FullColor, ColorSpaceID);
  FUpdating := False;
  UpdateColorSpace;
end;

procedure TJvFullColorForm.ComboBoxPredefinedChange(Sender: TObject);
var
  LColorID: TJvColorID;
begin
  if FUpdating then
    Exit;
  FUpdating := True;
  with Sender as TColorBox, ColorSpaceManager do
  begin
    LColorID := GetColorID(FullColor);
    if LColorID in [csRGB, csPredefined] then
      FullColor := Colors[ItemIndex]
    else
      FullColor := ConvertToID(Colors[ItemIndex], LColorID);
  end;
  FUpdating := False;
  UpdateColorSpace;
end;

procedure TJvFullColorForm.ComboBoxAxisChange(Sender: TObject);
begin
  JvColorPanel.AxisConfig := (Sender as TJvColorAxisConfigCombo).Selected;
end;

procedure TJvFullColorForm.UpdateColorValue;
var
  I: TJvAxisIndex;
  NewIndex: Integer;
  ValueAxes: array [TJvAxisIndex] of Byte;
  Index: Integer;
  LColorID: TJvColorID;
begin
  if FUpdating then
    Exit;
  FillInternalArrays;

  FUpdating := True;

  LabelDrawNew.Color := ColorSpaceManager.ConvertToID(FullColor, csRGB);
  LabelDrawNew.Update;

  LColorID := ColorSpaceManager.GetColorID(FullColor);

  if LColorID = csPredefined then
  begin
    JvColorPanel.FullColor := TJvFullColor(clWindowText);
    JvFullColorTrackBar.Visible := False;
    JvColorAxisConfigCombo.Enabled := False;
    for I := Low(TJvAxisIndex) to High(TJvAxisIndex) do
    begin
      FScrollBarAxes[I].Enabled := False;
      FScrollBarAxes[I].Position := 0;
      FSpinEditAxes[I].Enabled := False;
      FSpinEditAxes[I].Value := 0;
    end;
  end
  else
  begin
    JvFullColorTrackBar.Visible := True;
    JvColorAxisConfigCombo.Enabled := True;
    for I := Low(TJvAxisIndex) to High(TJvAxisIndex) do
    begin
      FScrollBarAxes[I].Enabled := True;
      FSpinEditAxes[I].Enabled := True;
      ValueAxes[I] := GetAxisValue(FullColor, I);
      FScrollBarAxes[I].Position := ValueAxes[I];
      FSpinEditAxes[I].Value := ValueAxes[I];
    end;

    JvColorPanel.FullColor := FullColor;
  end;

  JvColorSpaceCombo.ColorSpaceID := LColorID;

  NewIndex := -1;
  with ColorBox, Items, ColorSpaceManager do
  begin
    for Index := 0 to Count - 1 do
      if ConvertToID(Colors[Index], LColorID) = FullColor then
      begin
        NewIndex := Index;
        Break;
      end;
    ItemIndex := NewIndex;
  end;

  FUpdating := False;
end;

procedure TJvFullColorForm.UpdateColorSpace;
var
  I: TJvAxisIndex;
  AxisMin, AxisMax: Byte;
  LColorSpace: TJvColorSpace;
begin
  if FUpdating then
    Exit;
  FillInternalArrays;

  FUpdating := True;

  LColorSpace := JvColorSpaceCombo.SelectedSpace;

  if Assigned(LColorSpace) then
  begin
    JvColorAxisConfigCombo.ColorID := LColorSpace.ID;
    for I := Low(TJvAxisIndex) to High(TJvAxisIndex) do
    begin
      FLabelAxes[I].Caption := LColorSpace.AxisName[I];
      AxisMin := LColorSpace.AxisMin[I];
      AxisMax := LColorSpace.AxisMax[I];
      FScrollBarAxes[I].Min := AxisMin;
      FScrollBarAxes[I].Max := AxisMax;
      FSpinEditAxes[I].MinValue := AxisMin;
      FSpinEditAxes[I].MaxValue := AxisMax;
    end;
  end;

  FUpdating := False;

  UpdateColorValue;
end;

procedure TJvFullColorForm.ButtonApplyClick(Sender: TObject);
begin
  if Assigned(OnApply) then
    OnApply(Sender);
end;

procedure TJvFullColorForm.SetFullColor(const Value: TJvFullColor);
begin
  inherited SetFullColor(Value);
  if not FUpdating then
    UpdateColorSpace;
end;

procedure TJvFullColorForm.SetOptions(const Value: TJvFullColorDialogOptions);
var
  LVisible: Boolean;
  LColorRGB: Cardinal;
begin
  inherited SetOptions(Value);

  if foFullOpen in Options then
    Expand
  else
    Collapse;

  ButtonGraphics.Enabled := not (foPreventExpand in Options);

  ButtonApply.Visible := (foShowApply in Options);

  if foShowHelp in Options then
    BorderIcons := BorderIcons + [biHelp]
  else
    BorderIcons := BorderIcons - [biHelp];

  JvColorSpaceCombo.Enabled := foAllowSpaceChange in Options;

  LVisible := foShowOldPreview in Options;
  LabelDrawOld.Visible := LVisible;
  LabelOld.Visible := LVisible;

  LVisible := foShowNewPreview in Options;
  LabelDrawNew.Visible := LVisible;
  LabelNew.Visible := LVisible;

  LVisible := foShowPredefined in Options;
  ColorBox.Visible := LVisible;
  LabelPredefined.Visible := LVisible;

  JvColorSpaceCombo.AllowVariable := foAllowVariable in Options;
  if foAllowVariable in Options then
    ColorBox.Style := ColorBox.Style + [cbSystemColors]
  else
    ColorBox.Style := ColorBox.Style - [cbSystemColors];
  if foNoneAndDefault in Options then
    ColorBox.Style := ColorBox.Style + [cbIncludeNone, cbIncludeDefault]
  else
    ColorBox.Style := ColorBox.Style - [cbIncludeNone, cbIncludeDefault];

  UpdateColorSpace;

  with ColorSpaceManager do
    LColorRGB := ConvertToID(FullColor, csRGB);

  LabelDrawNew.Color := LColorRGB;
  LabelDrawOld.Color := LColorRGB;
end;

procedure TJvFullColorForm.LabelDrawOldClick(Sender: TObject);
begin
  FullColor := LabelDrawOld.Color;
end;

procedure TJvFullColorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    with Sender as TCustomForm do
      if not ((ActiveControl is TCustomComboBox) and
        TCustomComboBox(ActiveControl).DroppedDown) then
        Close;
end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$RCSfile$';
    Revision: '$Revision$';
    Date: '$Date$';
    LogPath: 'JVCL\run'
    );
{$ENDIF UNITVERSIONING}

initialization
  FullColorFormClass := TJvFullColorForm;
  {$IFDEF UNITVERSIONING}
  RegisterUnitVersion(HInstance, UnitVersioning);
  {$ENDIF UNITVERSIONING}

{$IFDEF UNITVERSIONING}
finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.

