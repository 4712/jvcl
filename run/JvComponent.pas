{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvComponent.PAS, released on 2000-09-22.

The Initial Developer of the Original Code is Joe Doe .
Portions created by Joe Doe are Copyright (C) 1999 Joe Doe.
Portions created by XXXX Corp. are Copyright (C) 1998, 1999 XXXX Corp.
All Rights Reserved.

Contributor(s): -

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

{$I jvcl.inc}

unit JvComponent;

interface

uses
  Classes,
  {$IFDEF USE_DXGETTEXT}
  gnugettext,
  {$ENDIF USE_DXGETTEXT}
  {$IFDEF VCL}
  Windows, Messages, Controls,
  {$ENDIF VCL}
  JVCLVer, JvExControls, JvExExtCtrls, JvExComCtrls, JvExForms, JvExStdCtrls;

type
  TJvComponent = class(TComponent)
  private
    FAboutJVCL: TJVCLAboutInfo;
  published
    property {$IFDEF VCL}AboutJVCL{$ELSE}AboutJVCLX{$ENDIF}: TJVCLAboutInfo read FAboutJVCL write FAboutJVCL stored False;
  end;

  TJvGraphicControl = class(TJvExGraphicControl);
  TJvPubGraphicControl = class(TJvExPubGraphicControl);

  TJvCustomTreeView = class(TJvExCustomTreeView);
  TJvPubCustomTreeView = class(TJvExPubCustomTreeView);

  TJvCustomPanel = class(TJvExCustomPanel);
  TJvPubCustomPanel = class(TJvExPubCustomPanel);

  TJvCustomControl = class(TJvExCustomControl);
  TJvPubCustomControl = class(TJvExPubCustomControl);

  TJvWinControl = class(TJvExPubWinControl);
  TJvPubWinControl = class(TJvExPubWinControl);

  TJvForm = class(TJvExForm)
  {$IFDEF USE_DXGETTEXT}
  public
    constructor Create(AOwner: TComponent); override;
    procedure RefreshTranslation; virtual;
  {$ENDIF USE_DXGETTEXT}
  end;

//=== TJvPopupListBox ========================================================

{$IFDEF VCL}
type
  TJvPopupListBox = class(TJvExCustomListBox)
  private
    FSearchText: string;
    FSearchTickCount: Longint;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
	procedure KeyPress(var Key: Char); override;
  end;
{$ENDIF VCL}

implementation

//=== TJvForm ================================================================

{$IFDEF USE_DXGETTEXT}
constructor TJvForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TranslateComponent(Self, 'jvcl');
end;

procedure TJvForm.RefreshTranslation;
begin
  ReTranslateComponent(Self, 'jvcl');
end;

{$ENDIF USE_DXGETTEXT}

{$IFDEF VCL}

//=== TJvPopupListBox ========================================================
procedure TJvPopupListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_BORDER;
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    AddBiDiModeExStyle(ExStyle);
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TJvPopupListBox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;

procedure TJvPopupListBox.KeyPress(var Key: Char);
var
  TickCount: Int64;
begin
  case Word(Key) of
    VK_BACK, VK_ESCAPE:
      FSearchText := '';
    32..255:
      begin
        TickCount := GetTickCount;
        if TickCount < FSearchTickCount then
          Inc(TickCount, $100000000); // (ahuser) reduces the overflow
        if TickCount - FSearchTickCount >= 4000 then
          FSearchText := '';
        FSearchTickCount := TickCount;
        if Length(FSearchText) < 32 then
          FSearchText := FSearchText + Key;
        SendMessage(Handle, LB_SELECTSTRING, WORD(-1),
          Longint(PChar(FSearchText)));
        Key := #0;
      end;
  end;
  inherited KeyPress(Key);
end;

{$ENDIF VCL}

{$IFDEF USE_DXGETTEXT}

initialization
  AddDomainForResourceString('jvcl');

{$ENDIF USE_DXGETTEXT}

end.
