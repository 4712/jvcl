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

Contributor(s):

Last Modified: 2002-05-26

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Description:
  Color form for the @link(TJvColorButton) component

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvColorForm;

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
  Types, QGraphics, QControls, QForms, QButtons, QExtCtrls, QDialogs,
  {$ENDIF VisualCLX}
  JvColorBox;

const
  cButtonWidth = 22;

type
  TOpenColorDialog = class(TColorDialog);

  TJvColorForm = class(TForm)
    OtherBtn: TSpeedButton;
    procedure OtherBtnClick(Sender: TObject);
    procedure DoColorClick(Sender: TObject);
    procedure DoColorChange(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    FOwner: TControl;
    FCDVisible: Boolean;
    FCS: TJvColorSquare;
    FButtonSize: Integer;
    FColorDialog: TOpenColorDialog;
    FSelectedColor: TColor;
    procedure ShowCD(Sender: TObject);
    procedure HideCD(Sender: TObject);
    {$IFDEF VCL}
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
    {$ENDIF VCL}
    procedure SetButtonSize(const Value: Integer);
  protected
    {$IFDEF VCL}
    procedure CreateWnd; override;
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    procedure Deactivate; override;
    procedure DoShow; override;
    {$ENDIF VisualCLX}
  public
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    procedure MakeColorButtons;
    procedure SetButton(Button: TControl);
    property ButtonSize: Integer read FButtonSize write SetButtonSize default cButtonWidth;
    property ColorDialog: TOpenColorDialog read FColorDialog write FColorDialog;
    property SelectedColor: TColor read FSelectedColor write FSelectedColor default clBlack;
  end;

implementation

uses
  JvColorButton, JvConsts;

constructor TJvColorForm.CreateNew(AOwner: TComponent; Dummy: Integer);
begin
  inherited CreateNew(AOwner, Dummy);
  FButtonSize := cButtonWidth;
  FSelectedColor := clBlack;
  BorderIcons := [];
  {$IFDEF VCL}
  BorderStyle := bsDialog;
  {$ELSE}
  BorderStyle := fbsNone;
  {$ENDIF VCL}
  // (rom) this is not a standard Windows font
  Font.Name := 'MS Shell Dlg 2';
  FormStyle := fsStayOnTop;
  KeyPreview := True;
  OnActivate := FormActivate;
  OnClose := FormClose;
  OnKeyUp := FormKeyUp;

  FColorDialog := TOpenColorDialog.Create(Self);
  FCDVisible := False;
  FColorDialog.OnShow := ShowCD;
  FColorDialog.OnClose := HideCD;
  MakeColorButtons;
end;

procedure TJvColorForm.SetButton(Button: TControl);
begin
  FOwner := Button;
end;

procedure TJvColorForm.ShowCD(Sender: TObject);
begin
  FCDVisible := True;
end;

procedure TJvColorForm.HideCD(Sender: TObject);
begin
  FCDVisible := False;
end;

procedure TJvColorForm.OtherBtnClick(Sender: TObject);
begin
  if Assigned(FOwner) and (FOwner is TJvColorButton) then
    TJvColorButton(FOwner).Color := SelectedColor;
  FColorDialog.Color := SelectedColor;
  if FColorDialog.Execute then
  begin
    FCS.Color := FColorDialog.Color;
    if FOwner is TJvColorButton then
    begin
      TJvColorButton(FOwner).CustomColors.Assign(FColorDialog.CustomColors);
      TJvColorButton(FOwner).Color := SelectedColor;
    end;
    ModalResult := mrOK;
  end
  else
    ModalResult := mrCancel;
  Hide;
end;

{$IFDEF VCL}
procedure TJvColorForm.WMActivate(var Msg: TWMActivate);
begin
  inherited;
  if (Msg.Active = WA_INACTIVE) and not FCDVisible then
  begin
    Hide;
    ModalResult := mrCancel;
  end;
end;
{$ELSE}
procedure TJvColorForm.Deactivate;
begin
  inherited Deactivate;
  if (not FCDVisible) then
  begin
    Hide;
    ModalResult := mrCancel;
  end;
end;

procedure TJvColorForm.DoShow;
begin
  FormActivate(Self);
  inherited DoShow;
end;
{$ENDIF VCL}

procedure TJvColorForm.DoColorClick(Sender: TObject);
begin
  if Sender is TJvColorSquare then
    SelectedColor := (Sender as TJvColorSquare).Color;
  Hide;
  if Assigned(FOwner) and (FOwner is TJvColorButton) then
    TJvColorButton(FOwner).Color := SelectedColor;
  ModalResult := mrOK;
end;

procedure TJvColorForm.DoColorChange(Sender: TObject);
begin
  SelectedColor := FCS.Color;
  if Assigned(FOwner) and (FOwner is TJvColorButton) then
    TJvColorButton(FOwner).Color := SelectedColor;
end;

procedure TJvColorForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Hide;
    ModalResult := mrCancel;
  end;
end;

procedure TJvColorForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

{$IFDEF VCL}
procedure TJvColorForm.CreateWnd;
begin
  inherited CreateWnd;
//  Hide;
  SetWindowLong(Handle, GWL_STYLE,
    GetWindowLong(Handle, GWL_STYLE) and not WS_CAPTION);
//  Show;
end;
{$ENDIF VCL}

procedure TJvColorForm.FormActivate(Sender: TObject);
var
  R: TRect;
  Pt: TPoint;
begin
  { set placement }
  if Assigned(FOwner) then
  begin
    R := FOwner.ClientRect;
    Pt.X := R.Left;
    Pt.Y := R.Top + R.Bottom;
    Pt := FOwner.ClientToScreen(Pt);
    Left := Pt.X;
    Top := Pt.Y;
    if FOwner is TJvColorButton then
      SelectedColor := TJvColorButton(FOwner).Color;
  end;
  ClientWidth := FCS.Left + FCS.Width;
  Height := OtherBtn.Top + OtherBtn.Height + 8;
end;

procedure TJvColorForm.MakeColorButtons;
const
  cColorArray: array [0..19] of TColor =
   (clWhite, clBlack, clSilver, clGray,
    clRed, clMaroon, clYellow, clOlive,
    clLime, clGreen, clAqua, clTeal,
    clBlue, clNavy, clFuchsia, clPurple,
    clMoneyGreen, clSkyBlue, clCream, clMedGray);
var
  I, X, Y: Integer;
  ParentControl: TWinControl;
  Offset: Integer;
begin
  for I := ControlCount - 1 downto 0 do
    if (Controls[I] is TJvColorSquare) or (Controls[I] is TBevel) then
      Controls[I].Free;

  {$IFDEF VCL}
  ParentControl := Self;
  Offset := 0;
  {$ELSE}
  ParentControl := TPanel.Create(Self);
  ParentControl.Align := alClient;
  ParentControl.Parent := Self;
  TPanel(ParentControl).BevelInner := bvRaised;
  TPanel(ParentControl).BevelOuter := bvRaised;
  Offset := 2;
  {$ENDIF VCL}

  X := Offset;
  Y := Offset;
  for I := 0 to 19 do
  begin
    FCS := TJvColorSquare.Create(Self);
    FCS.SetBounds(X, Y, FButtonSize, FButtonSize);
    FCS.Color := cColorArray[I];
    FCS.OnClick := DoColorClick;
    FCS.Parent := ParentControl;
    FCS.BorderStyle := bsSingle;
    Inc(X, FButtonSize);
    if (I + 1) mod 4 = 0 then
    begin
      Inc(Y, FButtonSize);
      X := Offset;
    end;
  end;
  if OtherBtn = nil then
    OtherBtn := TSpeedButton.Create(Self);
  with OtherBtn do
  begin
    SetBounds(Offset, Y + 6, FButtonSize * 3, FButtonSize);
    Parent := ParentControl;
//    Caption := SOtherCaption;
    OnClick := OtherBtnClick;
  end;
  FCS := TJvColorSquare.Create(Self);
  FCS.Color := cColorArray[0];
  FCS.OnClick := DoColorClick;
  FCS.OnChange := DoColorChange;
  FCS.Parent := ParentControl;
  FCS.BorderStyle := bsSingle;
  FCS.SetBounds(Offset + FButtonSize * 3, Y + 6, FButtonSize, FButtonSize);
  Self.ClientWidth := FCS.Left + FCS.Width;
  Self.ClientHeight := OtherBtn.Top + OtherBtn.Height;
  with TBevel.Create(Self) do
  begin
    Parent := ParentControl;
    Shape := bsTopLine;
    {$IFDEF VisualCLX}
    Dec(Y, 6);
    {$ENDIF VisualCLX}
    SetBounds(2, Y, Self.Width - 4, 4);
    Anchors := [akLeft, akBottom, akRight];
  end;
end;

procedure TJvColorForm.SetButtonSize(const Value: Integer);
begin
  if FButtonSize <> Value then
  begin
    FButtonSize := Value;
    MakeColorButtons;
  end;
end;

end.

