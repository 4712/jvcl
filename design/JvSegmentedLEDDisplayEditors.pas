{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvAnimatedEditor.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is John Doe.
Portions created by John Doe are Copyright (C) 2003 John Doe.
All Rights Reserved.

Contributor(s):

Last Modified: 2003-11-09

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvSegmentedLEDDisplayEditors;

interface

uses
  Classes, Graphics, Menus, Windows,
  {$IFDEF COMPILER6_UP}
  DesignEditors, DesignIntf, DesignMenus, VCLEditors, 
  {$ELSE}
  DsgnIntf,
  {$ENDIF COMPILER6_UP}
  JvSegmentedLEDDisplay;

type
  TJvTClassProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetName: string; override;
  end;

  TJvSegmentedLEDDigitClassProperty = class(TJvTClassProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TJvSegmentedLEDDisplayEditor = class(TDefaultEditor)
  protected
    function Display: TJvCustomSegmentedLEDDisplay;
    procedure AddDigit;
    procedure RemoveDigit;
    function DigitCount: Integer;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    {$IFDEF COMPILER6_UP}
    procedure PrepareItem(Index: Integer; const AItem: IMenuItem); override;
    {$ELSE}
    procedure PrepareItem(Index: Integer; const AItem: TMenuItem); override;
    {$ENDIF COMPILER6_UP}
  end;

  TUnlitColorProperty = class(TColorProperty{$IFDEF COMPILER6_UP}, ICustomPropertyDrawing, ICustomPropertyListDrawing {$ENDIF})
  {$IFDEF COMPILER6_UP}
    procedure ICustomPropertyListDrawing.ListDrawValue = ListDrawValue;
    procedure ICustomPropertyDrawing.PropDrawValue = PropDrawValue;
  {$ENDIF COMPILER6_UP}
  public
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean); {$IFNDEF COMPILER6_UP} override; {$ENDIF}
    {$IFDEF COMPILER6_UP}
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
    {$ENDIF COMPILER6_UP}
  end;

implementation

uses
  SysUtils,
  JclRTTI,
  JvSegmentedLEDDisplayMappingForm, JvDsgnConsts;

//=== TJvTClassProperty ======================================================

function TJvTClassProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList, paRevertable];
end;

function TJvTClassProperty.GetName: string;
begin
  Result := inherited GetName;
  if AnsiSameStr(Copy(Result, Length(Result) - 3, 4), 'Name') then
    SetLength(Result, Length(Result) - 4);
end;

//=== TJvSegmentedLEDDigitClassProperty ======================================

procedure TJvSegmentedLEDDigitClassProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  with DigitClassList.LockList do
  try
    for I := 0 to Count - 1 do
      Proc(TClass(Items[I]).ClassName);
  finally
    DigitClassList.UnlockList
  end;
end;

//=== TJvSegmentedLEDDisplayEditor ===========================================

type
  TOpenDisplay = class(TJvCustomSegmentedLEDDisplay);

function TJvSegmentedLEDDisplayEditor.Display: TJvCustomSegmentedLEDDisplay;
begin
  Result := TJvCustomSegmentedLEDDisplay(Component);
end;

procedure TJvSegmentedLEDDisplayEditor.AddDigit;
begin
  TOpenDisplay(Display).Digits.Add;
  Designer.Modified;
end;

procedure TJvSegmentedLEDDisplayEditor.RemoveDigit;
begin
  TOpenDisplay(Display).Digits.Delete(DigitCount - 1);
  Designer.Modified;
end;

function TJvSegmentedLEDDisplayEditor.DigitCount: Integer;
begin
  Result := TOpenDisplay(Display).Digits.Count;
end;

procedure TJvSegmentedLEDDisplayEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0:
      AddDigit;
    1:
      RemoveDigit;
    3:
      EditSLDMapping(Display, Designer);
  end;
end;

function TJvSegmentedLEDDisplayEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0:
      Result := SAddDigit;
    1:
      Result := SRemoveDigit;
    2:
      Result := '-'; // do not localize
    3:
      Result := SEditMappingEllipsis;
  end;
end;

function TJvSegmentedLEDDisplayEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;

{$IFDEF COMPILER6_UP}
procedure TJvSegmentedLEDDisplayEditor.PrepareItem(Index: Integer; const AItem: IMenuItem);
{$ELSE}
procedure TJvSegmentedLEDDisplayEditor.PrepareItem(Index: Integer; const AItem: TMenuItem);
{$ENDIF COMPILER6_UP}
begin
  if (Index = 1) and (DigitCount = 0) then
    AItem.Enabled := False;
  if (Index = 0) and (TOpenDisplay(Display).DigitClass = nil) then
    AItem.Enabled := False;
end;

//=== TUnlitColorProperty ====================================================

function TUnlitColorProperty.GetValue: string;
begin
  case GetOrdValue of
    clDefaultBackground:
      Result := 'clDefaultBackground';
    clDefaultLitColor:
      Result := 'clDefaultLitColor';
  else
    Result := inherited GetValue;
  end;
end;

procedure TUnlitColorProperty.GetValues(Proc: TGetStrProc);
begin
  inherited GetValues(Proc);
  Proc('clDefaultBackground');
  Proc('clDefaultLitColor');
end;

procedure TUnlitColorProperty.SetValue(const Value: string);
var
  NewValue: Longint;
begin
  if IdentToUnlitColor(Value, NewValue) then
    SetOrdValue(NewValue)
  else
    inherited SetValue(Value);
end;

procedure TUnlitColorProperty.ListDrawValue(const Value: string; ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);

  function ColorToBorderColor(AColor: TColor): TColor;
  type
    TColorQuad = record
      Red: Byte;
      Green: Byte;
      Blue: Byte;
      Alpha: Byte;
    end;
  begin
    if (TColorQuad(AColor).Red > 192) or (TColorQuad(AColor).Green > 192) or
      (TColorQuad(AColor).Blue > 192) then
      Result := clBlack
    else
    if ASelected then
      Result := clWhite
    else
      Result := AColor;
  end;

var
  vRight: Integer;
  vOldPenColor, vOldBrushColor, TmpColor: TColor;
  TmpRect: TRect;
begin
  vRight := (ARect.Bottom - ARect.Top) + ARect.Left;
  with ACanvas do
  try
    vOldPenColor := Pen.Color;
    vOldBrushColor := Brush.Color;
    Pen.Color := Brush.Color;
    Rectangle(ARect.Left, ARect.Top, vRight, ARect.Bottom);
    IdentToUnlitColor(Value, Integer(TmpColor));
    Brush.Color := TMpColor;
    Pen.Color := ColorToBorderColor(ColorToRGB(Brush.Color));
    Rectangle(ARect.Left + 1, ARect.Top + 1, vRight - 1, ARect.Bottom - 1);
    Brush.Color := vOldBrushColor;
    Pen.Color := vOldPenColor;
  finally
    TmpRect := ARect;
    TmpRect.Left := vRight;
    ACanvas.TextRect(TmpRect, TmpRect.Left + 1, TmpRect.Top + 1, Value);
  end;
end;

{$IFDEF COMPILER6_UP}
procedure TUnlitColorProperty.PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
  ASelected: Boolean);
begin
  if GetVisualValue <> '' then
    ListDrawValue(GetVisualValue, ACanvas, ARect, True {ASelected})
  else
    DefaultPropertyDrawValue(Self, ACanvas, ARect);
end;
{$ENDIF COMPILER6_UP}

end.
