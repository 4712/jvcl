{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvArrayButton.PAS, released on 2002-06-15.

The Initial Developer of the Original Code is Jan Verhoeven [jan1.verhoeven@wxs.nl]
Portions created by Jan Verhoeven are Copyright (C) 2002 Jan Verhoeven.
All Rights Reserved.

Contributor(s): Robert Love [rlove@slcdug.org].

Last Modified: 2003-10-25

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvArrayButton;

interface

uses
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, ExtCtrls, Buttons,
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  Types, QGraphics, QControls, QForms, QExtCtrls, QButtons,
  {$ENDIF VisualCLX}
  SysUtils, Classes,
  JvClxUtils, JvComponent;

type
  TArrayButtonClicked = procedure(ACol, ARow: Integer) of object;

  TJvArrayButton = class(TJvGraphicControl)
  private
    FPtDown: TPoint;
    FPushDown: boolean;
    FColor: TColor;
    FRows: Integer;
    FCols: Integer;
    FOnArrayButtonClicked: TArrayButtonClicked;
    FCaptions: TStringList;
    FColors: TStringList;
    FHints: TStringList;
    {$IFDEF JVCLThemesEnabled}
    FMouseOverBtn: TPoint;
    FThemed: Boolean;
    procedure SetThemed(Value: Boolean);
    {$ENDIF JVCLThemesEnabled}
    procedure SetCols(const Value: Integer);
    procedure SetRows(const Value: Integer);
    procedure SetCaptions(const Value: TStringList);
    procedure SetColors(const Value: TStringList);
    procedure MouseToCell(const X, Y: Integer; var ACol, ARow: Integer);
    function CellRect(ACol, ARow: Integer): TRect;
    procedure SetHints(const Value: TStringList);
  protected
    {$IFDEF VCL}
    procedure CMFontChanged(var Msg: TMessage); message CM_FONTCHANGED;
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    procedure FontChanged; override;
    {$ENDIF VisualCLX}
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    {$IFDEF JVCLThemesEnabled}
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseEnter(AControl: TControl); override;
    procedure MouseLeave(AControl: TControl); override;
    {$ENDIF JVCLThemesEnabled}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure DoShowHint(var HintStr: {$IFDEF VCL} string {$ELSE} WideString {$ENDIF};
      var CanShow: Boolean; var HintInfo: THintInfo);

    {this procedure can be used in response to a Application.OnShowHint event
     button hints are stored in the hints property from array top-left to array bottom right
     in your application create a seperate onshowhint event Handler
     within that Handler test HintInfo.HintControl is this object. If it is dispatch to this objects doShowHint.
     In the formcreate event handler include:
       Application.OnShowHint := DrawHint;

     procedure TDrawF.DrawHint(var HintStr: string; var CanShow: Boolean;
       var HintInfo: THintInfo);
     begin
       if HintInfo.HintControl = JvArrayButton1 then
          JvArrayButton1.DoShowHint(HintStr, CanShow, HintInfo);
     end;

     I could have set the Application.OnShowHint handler directly in this component,
     but if you have more components that do this then only the last one would work
     }
  published
    property Align;
    property Rows: Integer read FRows write SetRows;
    property Cols: Integer read FCols write SetCols;
    property Font;
    property Captions: TStringList read FCaptions write SetCaptions;
    property Height default 35;
    {A List of button captions from the top-left to the bottom-right button}
    property Hints: TStringList read FHints write SetHints;
    {A List of button hints from the top-left to the bottom-right button}
    property Colors: TStringList read FColors write SetColors;
    {A List of button Colors from the top-left to the bottom-right button
     values must standard Delphi Color names like clRed, clBlue or hex Color strings like $0000ff for red.
     please note the hex order in Delphi is BGR i.s.o. the RGB order you may know from HTML hex Color triplets}
    property Hint;
    property ShowHint default True;
    {$IFDEF JVCLThemesEnabled}
    property Themed: Boolean read FThemed write SetThemed default False;
    {$ENDIF JVCLThemesEnabled}
    property Width default 35;
    property OnArrayButtonClicked: TArrayButtonClicked read FOnArrayButtonClicked write FOnArrayButtonClicked;
    {provides you with the Column and Row of the clicked button
    the topleft button has Column=0 and Row=0}
  end;

implementation

uses
  JvThemes;

constructor TJvArrayButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 35;
  Height := 35;
  FColor := clSilver;
  FPushDown := False;
  FCols := 1;
  FRows := 1;
  ShowHint := True;
  FCaptions := TStringList.Create;
  FHints := TStringList.Create;
  FColors := TStringList.Create;
  {$IFDEF JVCLThemesEnabled}
  FThemed := False;
  FMouseOverBtn := Point(-1, -1);
  {$ENDIF JVCLThemesEnabled}
end;

destructor TJvArrayButton.Destroy;
begin
  FCaptions.Free;
  FHints.Free;
  FColors.Free;
  inherited Destroy;
end;

procedure TJvArrayButton.MouseToCell(const X, Y: Integer; var ACol, ARow: Integer);
var
  dh, dw: Integer;
begin
  dh := (Height - 2) div FRows;
  dw := (Width - 2) div FCols;
  ACol := X div dw;
  ARow := Y div dh;
end;

procedure TJvArrayButton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
begin
  if Button = mbLeft then
  begin
    FPushDown := True;
    MouseToCell(X, Y, Col, Row);
    FptDown := Point(Col, Row);
    Invalidate;
  end;
end;

procedure TJvArrayButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FPushDown := False;
    Invalidate;
    if Assigned(FOnArraybuttonClicked) then
      OnArrayButtonClicked(FptDown.X, FptDown.Y);
  end
end;

{$IFDEF JVCLThemesEnabled}

procedure TJvArrayButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Pt: TPoint;
begin
  inherited MouseMove(Shift, X, Y);
  MouseToCell(X, Y, Pt.X, Pt.Y);
  if (not FPushDown) and
    ((Pt.X <> FMouseOverBtn.X) or (Pt.Y <> FMouseOverBtn.Y)) then
  begin
    FMouseOverBtn := Pt;
    Invalidate;
  end;
end;

procedure TJvArrayButton.MouseEnter(AControl: TControl);
begin
  inherited MouseEnter(AControl);
  Repaint;
end;

procedure TJvArrayButton.MouseLeave(AControl: TControl);
begin
  inherited MouseLeave(AControl);
  Repaint;
end;

{$ENDIF JVCLThemesEnabled}

procedure TJvArrayButton.Paint;
var
  R: TRect;
  Col, Row: Integer;
  dh, dw: Integer;
  X0, Y0: Integer;
  Cap: string;
  BackColor: TColor;
  Index: Integer;

  procedure DrawBackground(AColor: TColor);
  begin
    Canvas.Brush.Color := AColor;
    DrawThemedBackground(Self, Canvas, R);
  end;

  procedure DrawUp;
  begin
    {$IFDEF JVCLThemesEnabled}
    if FThemed and ThemeServices.ThemesEnabled then
    begin
      R := DrawThemedButtonFace(Self, Canvas, R, 0, bsAutoDetect, False, False, False,
        PtInRect(R, ScreenToClient(Mouse.CursorPos)));
      {$IFDEF VCL}
      SetBkMode(Canvas.Handle, Windows.TRANSPARENT);
      {$ENDIF VCL}
    end
    else
    {$ENDIF JVCLThemesEnabled}
    begin
      DrawBackground(BackColor);
      Frame3D(Self.Canvas, R, clBtnHighlight, clBlack, 1);
    end;
    if Cap <> '' then
      ClxDrawText(Canvas, Cap, R, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
  end;

  procedure DrawDown;
  begin
    {$IFDEF JVCLThemesEnabled}
    if FThemed and ThemeServices.ThemesEnabled then
    begin
      R := DrawThemedButtonFace(Self, Canvas, R, 0, bsAutoDetect, False, True, False,
        PtInRect(R, ScreenToClient(Mouse.CursorPos)));
      {$IFDEF VCL}
      SetBkMode(Canvas.Handle, Windows.TRANSPARENT);
      {$ENDIF VCL}
    end
    else
    {$ENDIF JVCLThemesEnabled}
    begin
      DrawBackground(BackColor);
      Frame3D(Self.Canvas, R, clblack, clBtnHighlight, 1);
    end;
    if Cap <> '' then
      ClxDrawText(Canvas, Cap, R, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
  end;

begin
  dh := (Height - 2) div FRows;
  dw := (Width - 2) div FCols;
  for Row := 0 to FRows - 1 do
  begin
    Y0 := 1 + Row * dh;
    for Col := 0 to FCols - 1 do
    begin
      X0 := 1 + Col * dw;
      R := Rect(X0, Y0, X0 + dw, Y0 + dh);
      Index := Row * FCols + Col;
      if Index < FCaptions.Count then
        Cap := FCaptions[Index]
      else
        Cap := '';
      if Index < FColors.Count then
        try
          BackColor := StringToColor(FColors[Index]);
        except
          BackColor := clSilver;
        end
      else
        BackColor := clSilver;
      if (csDesigning in ComponentState) then
        DrawUp
      else
      if (FptDown.X = Col) and (FptDown.Y = Row) then
      begin
        if FPushDown then
          DrawDown
        else
          DrawUp;
      end
      else
        DrawUp;
    end;
  end;
end;

procedure TJvArrayButton.SetCols(const Value: Integer);
begin
  if FCols <> Value then
    if (Value >= 1) and (Value <= 10) then
    begin
      FCols := Value;
      Invalidate;
    end;
end;

procedure TJvArrayButton.SetRows(const Value: Integer);
begin
  if FRows <> Value then
    if (Value >= 1) and (Value <= 10) then
    begin
      FRows := Value;
      Invalidate;
    end;
end;

{$IFDEF JVCLThemesEnabled}
procedure TJvArrayButton.SetThemed(Value: Boolean);
begin
  if Value <> FThemed then
  begin
    FThemed := Value;
    if FThemed then
      IncludeThemeStyle(Self, [csParentBackground])
    else
      ExcludeThemeStyle(Self, [csParentBackground]);
    Invalidate;
  end;
end;
{$ENDIF JVCLThemesEnabled}

procedure TJvArrayButton.SetCaptions(const Value: TStringList);
begin
  FCaptions.Assign(Value);
  Invalidate;
end;

{$IFDEF VisualCLX}
procedure TJvArrayButton.FontChanged;
{$ENDIF VisualCLX}
{$IFDEF VCL}
procedure TJvArrayButton.CMFontChanged(var Msg: TMessage);
{$ENDIF VCL}
begin
  Canvas.Font.Assign(Font);
  Invalidate;
end;

procedure TJvArrayButton.SetColors(const Value: TStringList);
begin
  FColors.Assign(Value);
  Invalidate;
end;

function TJvArrayButton.CellRect(ACol, ARow: Integer): TRect;
var
  dh, dw, X0, Y0: Integer;
begin
  dh := (Height - 2) div FRows;
  dw := (Width - 2) div FCols;
  Y0 := 1 + ARow * dh;
  X0 := 1 + ACol * dw;
  //  pt1:=clienttoscreen(point(X0,Y0));
  //  pt2:=clienttoscreen(point(X0+dw,Y0+dh));
  //  result:=rect(pt1.X,pt1.Y,pt2.X,pt2.Y);
  Result := Rect(X0, Y0, X0 + dw, Y0 + dh);
end;

procedure TJvArrayButton.DoShowHint(var HintStr: {$IFDEF VCL} string {$ELSE} WideString {$ENDIF};
  var CanShow: Boolean; var HintInfo: THintInfo);
var
  ACol, ARow, X, Y: Integer;
  Index: Integer;
begin
  if HintInfo.HintControl = Self then
  begin
    X := HintInfo.CursorPos.X;
    Y := HintInfo.CursorPos.Y;
    MouseToCell(X, Y, ACol, ARow);
    if (ACol < 0) or (ARow < 0) then
      Exit;
    Index := ARow * FCols + ACol;
    if Index < FHints.Count then
      HintStr := FHints[Index]
    else
      HintStr := Hint;
    HintInfo.CursorRect := CellRect(ACol, ARow);
    CanShow := True;
  end;
end;

procedure TJvArrayButton.SetHints(const Value: TStringList);
begin
  FHints.Assign(Value);
end;

end.
