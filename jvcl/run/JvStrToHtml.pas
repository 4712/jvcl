{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvStrToHtml.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is S�bastien Buysse [sbuysse@buypin.com]
Portions created by S�bastien Buysse are Copyright (C) 2001 S�bastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck@bigfoot.com].
                Andreas Hausladen [Andreas.Hausladen@gmx.de]

Last Modified: 2003-10-17

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvStrToHtml;

interface

uses
  SysUtils, Classes,
  JvComponent;

type
  TJvStrToHtml = class(TJvComponent)
  private
    FHtml: string;
    FValue: string;
    procedure SetHtml(const Value: string);
    procedure SetValue(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    function TextToHtml(const Text: string): string;
    function HtmlToText(const Text: string): string;
  published
    property Text: string read FValue write SetValue;
    property Html: string read FHtml write SetHtml;
  end;

function StringToHtml(const Value: string): string;
function HtmlToString(const Value: string): string;
function CharToHtml(Ch: Char): string;

implementation

type
  TJvHtmlCodeRec = packed record
    Ch: Char;
    Html: PChar;
  end;

const
  Conversions: array [1..79] of TJvHtmlCodeRec = (
    (Ch: '"'; Html: '&quot;'),
    (Ch: '�'; Html: '&agrave;'),
    (Ch: '�'; Html: '&ccedil;'),
    (Ch: '�'; Html: '&eacute;'),
    (Ch: '�'; Html: '&egrave;'),
    (Ch: '�'; Html: '&ecirc;'),
    (Ch: '�'; Html: '&ugrave;'),
    (Ch: '�'; Html: '&euml;'),
    (Ch: '<'; Html: '&lt;'),
    (Ch: '>'; Html: '&gt;'),
    (Ch: '^'; Html: '&#136;'),
    (Ch: '~'; Html: '&#152;'),
    (Ch: '�'; Html: '&#163;'),
    (Ch: '�'; Html: '&#167;'),
    (Ch: '�'; Html: '&#176;'),
    (Ch: '�'; Html: '&#178;'),
    (Ch: '�'; Html: '&#179;'),
    (Ch: '�'; Html: '&#181;'),
    (Ch: '�'; Html: '&#183;'),
    (Ch: '�'; Html: '&#188;'),
    (Ch: '�'; Html: '&#189;'),
    (Ch: '�'; Html: '&#191;'),
    (Ch: '�'; Html: '&#192;'),
    (Ch: '�'; Html: '&#193;'),
    (Ch: '�'; Html: '&#194;'),
    (Ch: '�'; Html: '&#195;'),
    (Ch: '�'; Html: '&#196;'),
    (Ch: '�'; Html: '&#197;'),
    (Ch: '�'; Html: '&#198;'),
    (Ch: '�'; Html: '&#199;'),
    (Ch: '�'; Html: '&#200;'),
    (Ch: '�'; Html: '&#201;'),
    (Ch: '�'; Html: '&#202;'),
    (Ch: '�'; Html: '&#203;'),
    (Ch: '�'; Html: '&#204;'),
    (Ch: '�'; Html: '&#205;'),
    (Ch: '�'; Html: '&#206;'),
    (Ch: '�'; Html: '&#207;'),
    (Ch: '�'; Html: '&#209;'),
    (Ch: '�'; Html: '&#210;'),
    (Ch: '�'; Html: '&#211;'),
    (Ch: '�'; Html: '&#212;'),
    (Ch: '�'; Html: '&#213;'),
    (Ch: '�'; Html: '&#214;'),
    (Ch: '�'; Html: '&#217;'),
    (Ch: '�'; Html: '&#218;'),
    (Ch: '�'; Html: '&#219;'),
    (Ch: '�'; Html: '&#220;'),
    (Ch: '�'; Html: '&#221;'),
    (Ch: '�'; Html: '&#223;'),
    (Ch: '�'; Html: '&#224;'),
    (Ch: '�'; Html: '&#225;'),
    (Ch: '�'; Html: '&#226;'),
    (Ch: '�'; Html: '&#227;'),
    (Ch: '�'; Html: '&#228;'),
    (Ch: '�'; Html: '&#229;'),
    (Ch: '�'; Html: '&#230;'),
    (Ch: '�'; Html: '&#231;'),
    (Ch: '�'; Html: '&#232;'),
    (Ch: '�'; Html: '&#233;'),
    (Ch: '�'; Html: '&#234;'),
    (Ch: '�'; Html: '&#235;'),
    (Ch: '�'; Html: '&#236;'),
    (Ch: '�'; Html: '&#237;'),
    (Ch: '�'; Html: '&#238;'),
    (Ch: '�'; Html: '&#239;'),
    (Ch: '�'; Html: '&#241;'),
    (Ch: '�'; Html: '&#242;'),
    (Ch: '�'; Html: '&#243;'),
    (Ch: '�'; Html: '&#244;'),
    (Ch: '�'; Html: '&#245;'),
    (Ch: '�'; Html: '&#246;'),
    (Ch: '�'; Html: '&#247;'),
    (Ch: '�'; Html: '&#249;'),
    (Ch: '�'; Html: '&#250;'),
    (Ch: '�'; Html: '&#251;'),
    (Ch: '�'; Html: '&#252;'),
    (Ch: '�'; Html: '&#253;'),
    (Ch: '�'; Html: '&#255;')
    );

constructor TJvStrToHtml.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FValue := '';
  FHtml := '';
end;

function TJvStrToHtml.HtmlToText(const Text: string): string;
begin
  Result := HtmlToString(Text);
end;

procedure TJvStrToHtml.SetHtml(const Value: string);
begin
  FValue := HtmlToText(Value);
end;

procedure TJvStrToHtml.SetValue(const Value: string);
begin
  FHtml := TextToHtml(Value);
end;

function TJvStrToHtml.TextToHtml(const Text: string): string;
begin
  Result := StringToHtml(Text);
end;

function StringToHtml(const Value: string): string;
var
  I, J: Integer;
  Len, AddLen, HtmlLen: Integer;
  P: PChar;
  Ch: Char;
begin
  Len := Length(Value);
 // number of chars to add
  AddLen := 0;
  for I := 1 to Len do
    for J := Low(Conversions) to High(Conversions) do
      if Value[I] = Conversions[J].Ch then
      begin
        Inc(AddLen, StrLen(Conversions[J].Html) - 1);
        Break;
      end;

  if AddLen = 0 then
    Result := Value
  else
  begin
    SetLength(Result, Len + AddLen);
    P := Pointer(Result);
    for I := 1 to Len do
    begin
      Ch := Value[I];
      for J := Low(Conversions) to High(Conversions) do
        if Ch = Conversions[J].Ch then
        begin
          HtmlLen := StrLen(Conversions[J].Html);
          Move(Conversions[J].Html[0], P[0], HtmlLen); // Conversions[].Html is a PChar
          Inc(P, HtmlLen);
          Ch := #0;
          Break;
        end;
      if Ch <> #0 then
      begin
        P[0] := Ch;
        Inc(P);
      end;
    end;
  end;
end;

function HtmlToString(const Value: string): string;
var
  I, Index, Len: Integer;
  Start, J: Integer;
  Ch: Char;
  ReplStr: string;
begin
  Len := Length(Value);
  SetLength(Result, Len); // worst case
  Index := 0;
  I := 1;
  while I <= Len do
  begin
    Ch := Value[I];
   // html entitiy
    if Ch = '&' then
    begin
      Start := I;
      Inc(I);
      while (I <= Len) and (Value[I] <> ';') and (I < Start + 20) do
        Inc(I);
      if Value[I] <> ';' then
        I := Start
      else
      begin
        Ch := #0;
        ReplStr := LowerCase(Copy(Value, Start, I - Start + 1));
        for J := Low(Conversions) to High(Conversions) do
          if Conversions[J].Html = ReplStr then
          begin
            Ch := Conversions[J].Ch;
            Break;
          end;
        if Ch = #0 then
        begin
          I := Start;
          Ch := Value[I];
        end;
      end;
    end;

    Inc(I);
    Inc(Index);
    Result[Index] := Ch;
  end;
  if Index <> Len then
    SetLength(Result, Index);
end;

function CharToHtml(Ch: Char): string;
var
  I: Integer;
begin
  for I := Low(Conversions) to High(Conversions) do
    if Conversions[I].Ch = Ch then
    begin
      Result := Conversions[I].Html;
      Exit;
    end;
  Result := Ch;
end;

end.

