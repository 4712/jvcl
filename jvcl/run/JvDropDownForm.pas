{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvDropDownForm, released on 2002-10-04.

The Initial Developer of the Original Code is Oliver Giesen [giesen@lucatec.com]
Portions created by Oliver Giesen are Copyright (C) 2002 Lucatec GmbH.
All Rights Reserved.

Contributor(s): ______________________________________.

Last Modified: 2002-12-09

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Description:
  A generic container form to be displayed as dropdown below a TCustomEdit
  descendant.

  There's still plenty of room for improvement here.

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvDropDownForm;

interface

uses
  Classes,
  {$IFDEF VCL}
  Windows, Messages, Controls, StdCtrls, Forms,
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  QControls, QStdCtrls, QForms, Types, QWindows,
  {$ENDIF VisualCLX}
  JvTypes, JvExForms;

type
  TJvCustomDropDownForm = class(TJvExCustomForm)
  private
    FEntering: Boolean;
    FCloseOnLeave: Boolean;
    FLeaving: Boolean;
    FOnKillFocus: TJvFocusChangeEvent;
    FOnSetFocus: TJvFocusChangeEvent;
  protected
    function GetEdit: TCustomEdit;
    procedure DoSetFocus(FocusedWnd: HWND); override;
    procedure DoKillFocus(FocusedWnd: HWND); override;
    procedure DoSetFocusEvent(const APreviousControl: TWinControl); dynamic;
    procedure DoKillFocusEvent(const ANextControl: TWinControl); dynamic;
    procedure DoClose(var Action: TCloseAction); override;
    procedure DoShow; override;
    procedure CreateParams(var AParams: TCreateParams); override;
    property Edit: TCustomEdit read GetEdit;
  public
    constructor Create(AOwner: TComponent); override;
    property CloseOnLeave: Boolean read FCloseOnLeave write FCloseOnLeave;
    property Entering: Boolean read FEntering;
    property Leaving: Boolean read FLeaving;
    property OnSetFocus: TJvFocusChangeEvent read FOnSetFocus write FOnSetFocus;
    property OnKillFocus: TJvFocusChangeEvent read FOnKillFocus write FOnKillFocus;
  end;

{TODO : IsChildWindow should probably better be moved somewhere into the JCL}
function IsChildWindow(const AChild, AParent: HWND): Boolean;

implementation

uses
  SysUtils,
  JvConsts, JvResources;

function IsChildWindow(const AChild, AParent: HWND): Boolean;
var
  LParent: HWND;
begin
 {determines whether a window is the child (or grand^x-child) of another}
  LParent := AChild;
  // (rom) changed to while loop
  while (LParent <> AParent) and (LParent <> 0) do
    LParent := GetParent(LParent);
  Result := (LParent = AParent) and (LParent <> 0);
end;

type
  TCustomEditHack = class(TCustomEdit);

constructor TJvCustomDropDownForm.Create(AOwner: TComponent);
begin
  if not (AOwner is TCustomEdit) then
    raise EJVCLException.Create(RsETJvCustomDropDownFormCreateOwnerMus);

  inherited CreateNew(AOwner);

  BorderIcons := [];
  BorderStyle := bsNone;
  Font := TCustomEditHack(AOwner).Font;

  FEntering := True;
  FLeaving := False;
  FCloseOnLeave := True;

  with TWinControl(AOwner) do
  begin
    Self.Left := ClientOrigin.X;
    Self.Top := ClientOrigin.Y + Height;
  end;
end;

procedure TJvCustomDropDownForm.CreateParams(var AParams: TCreateParams);
begin
  inherited CreateParams(AParams);
  AParams.Style := AParams.Style or WS_BORDER;
end;

procedure TJvCustomDropDownForm.DoClose(var Action: TCloseAction);
begin
  Action := caFree;
  inherited DoClose(Action);
end;

procedure TJvCustomDropDownForm.DoShow;
var
  LScreenRect: TRect;
begin
  inherited DoShow;
  if (not SystemParametersInfo(SPI_GETWORKAREA, 0, @lScreenRect, 0)) then
    LScreenRect := Rect(0, 0, Screen.Width, Screen.Height);
  if (Left + Width > LScreenRect.Right) then
    Left := LScreenRect.Right - Width;
  if (Top + Height > LScreenRect.Bottom) then
    Top := Self.Edit.ClientOrigin.y - Height;
end;

function TJvCustomDropDownForm.GetEdit: TCustomEdit;
begin
  Result := TCustomEdit(Owner);
end;

procedure TJvCustomDropDownForm.DoKillFocus(FocusedWnd: HWND);
begin
  if IsChildWindow(FocusedWnd, Self.Handle) then
    inherited DoKillFocus(FocusedWnd)
  else
  begin
    FLeaving := True;
    try
      inherited DoKillFocus(FocusedWnd);
      DoKillFocusEvent(FindControl(FocusedWnd));
    finally
      FLeaving := False;
    end;
  end;
end;

procedure TJvCustomDropDownForm.DoKillFocusEvent(const ANextControl: TWinControl);
begin
  if Assigned(FOnKillFocus) then
    FOnKillFocus(Self, ANextControl);
  if CloseOnLeave then
    Close;
end;

procedure TJvCustomDropDownForm.DoSetFocus(FocusedWnd: HWND);
begin
  if IsChildWindow(FocusedWnd, Self.Handle) then
    inherited DoSetFocus(FocusedWnd)
  else
  begin
    FEntering := True;
    try
      inherited DoSetFocus(FocusedWnd);
      DoSetFocusEvent(FindControl(FocusedWnd));
    finally
      FEntering := False;
    end;
  end;
end;

procedure TJvCustomDropDownForm.DoSetFocusEvent(const APreviousControl: TWinControl);
begin
  if Assigned(FOnSetFocus) then
    FOnSetFocus(Self, APreviousControl);
end;

end.

