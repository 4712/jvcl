{******************************************************************************}
{* WARNING:  JEDI VCL To CLX Converter generated unit.                        *}
{*           Manual modifications will be lost on next release.               *}
{******************************************************************************}

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvColors.PAS, released on 2002-07-04.

The Initial Developers of the Original Code are: Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 1997, 1998 Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 2001,2002 SGB Software
All Rights Reserved.

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

{$I jvcl.inc}

unit JvQColorEditor;

interface

uses
  SysUtils, Classes,
  Types, QWindows, QGraphics, 
  RTLConsts, DesignIntf, DesignEditors,
  CLXEditors, 

  QDialogs,
  {$IFDEF MSWINDOWS}
  Registry,
  {$ENDIF MSWINDOWS}
  {$IFDEF LINUX}
  JvQRegistryIniFile,
  {$ENDIF LINUX}

  JvQConsts, JvQJVCLUtils;


const
  SCustomColors = 'JVCLX Custom Colors';


type
  TJvColorProperty = class(TColorProperty) 
  protected
    function GetRegKey: string; dynamic; 
  public
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;  
    procedure Edit; override; 
  end;

function JvIdentToColor(const Ident: string; var Color: Longint): Boolean;
function JvColorToString(Color: TColor): string;
function JvStringToColor(S: string): TColor;
procedure JvGetColorValues(Proc: TGetStrProc);
function JvColorToBorderColor(AColor: TColor; ASelected: Boolean): TColor;

implementation

type
  TColorEntry = record
    Value: TColor;
    Name: PChar;
  end;

const
  clInfoBk16 = TColor($02E1FFFF);
  clNone16 = TColor($02FFFFFF);
  ColorCount = 3;
  Colors: array [0..ColorCount - 1] of TColorEntry = (
    (Value: clCream; Name: 'clCream'),
    (Value: clMoneyGreen; Name: 'clMoneyGreen'),
    (Value: clSkyBlue; Name: 'clSkyBlue'));

function JvColorToString(Color: TColor): string;
var
  I: Integer;
begin
  if not ColorToIdent(Color, Result) then
  begin
    for I := Low(Colors) to High(Colors) do
      if Colors[I].Value = Color then
      begin
        Result := Colors[I].Name;
        Exit;
      end;
    Result := Format('$%.8x', [Color]);
  end;
end;

function JvIdentToColor(const Ident: string; var Color: Longint): Boolean;
var
  I: Integer;
  Text: array [0..63] of Char;
begin
  StrPLCopy(Text, Ident, SizeOf(Text) - 1);
  for I := Low(Colors) to High(Colors) do
    if StrIComp(Colors[I].Name, Text) = 0 then
    begin
      Color := Colors[I].Value;
      Result := True;
      Exit;
    end;
  Result := IdentToColor(Ident, Color);
end;

function JvStringToColor(S: string): TColor;
begin
  if not JvIdentToColor(S, Longint(Result)) then
    Result := StringToColor(S);
end;

procedure JvGetColorValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  GetColorValues(Proc);
  for I := Low(Colors) to High(Colors) do
    Proc(StrPas(Colors[I].Name));
end;

function JvColorToBorderColor(AColor: TColor; ASelected: Boolean): TColor;
const
  cBlackLevel = 192;
type
  TColorQuad = record
    Red: Byte;
    Green: Byte;
    Blue: Byte;
    Alpha: Byte;
  end;
begin
  // (rom) > or >= ?
  if (TColorQuad(AColor).Red > cBlackLevel) or
    (TColorQuad(AColor).Green > cBlackLevel) or
    (TColorQuad(AColor).Blue > cBlackLevel) then
    Result := clBlack
  else
  if ASelected then
    Result := clWhite
  else
    Result := AColor;
end;

//=== { TJvColorProperty } ===================================================

function TJvColorProperty.GetValue: string;
var
  Color: TColor;
begin
  Color := TColor(GetOrdValue);
  if Color = clNone16 then
    Color := clNone
  else
    if Color = clInfoBk16 then
      Color := clInfoBk;
  Result := JvColorToString(Color);
end;

procedure TJvColorProperty.GetValues(Proc: TGetStrProc);
begin
  JvGetColorValues(Proc);
end;

procedure TJvColorProperty.SetValue(const Value: string);
begin
  SetOrdValue(JvStringToColor(Value));
end;


//
// TColorProperty.Edit uses TColorDialog, but it does not store the
// customcolors. For design time non volatile customcolors are
// implemented stored in the Registry under windows and in
// Linux in an IniFile.
//
function TJvColorProperty.GetRegKey: String;
begin
  Result := SDelphiKey + PathDelim + SCustomColors;
end;

procedure TJvColorProperty.Edit;
var
  ColorDialog: TColorDialog;

  procedure GetCustomColors;
  var
    KeyName: string;
    KeyValue: string;
    Suffix: Char;
  begin
    with TRegistry.Create do
    try
      LazyWrite := False;
      if OpenKey(GetRegKey, True) then
      try
        with ColorDialog.CustomColors do
        begin
          Clear;
          for Suffix := 'A' to 'P' do
          begin
            KeyName := 'Color' + Suffix;
            KeyValue := ReadString(KeyName);
            Add(KeyName + '=' + KeyValue);
          end;
        end;
      finally
        CloseKey;
      end;
    finally
      Free;
    end;
  end;

  procedure SaveCustomColors;
  var
    I: Integer;
    KeyName: string;
    KeyValue: string;
    Suffix: Char;
  begin
    with TRegistry.Create do
    try
      LazyWrite := False;
      if OpenKey(GetRegKey, True) then
      try
        I := 0;
        with ColorDialog.CustomColors do
          for Suffix := 'A' to 'P' do
          begin
            KeyName := 'Color' + Suffix;
            KeyValue := StringReplace(Strings[I], Keyname + '=', '', []);
            WriteString(KeyName, KeyValue);
            inc(I);
          end;
      finally
        CloseKey;
      end;
    finally
      Free;
    end;
  end;

begin
  ColorDialog := TColorDialog.Create(nil); //Application);
  try
    ColorDialog.Color := ColorFromColormap(GetOrdValue);
//    ColorDialog.HelpContext := hcDColorEditor;
//    ColorDialog.HelpType := htContext;
    GetCustomColors;
    if ColorDialog.Execute then
    begin
      SetOrdValue(ColorDialog.Color);
      SaveCustomColors;
    end;
  finally
    ColorDialog.Free;
  end;
end;



end.

