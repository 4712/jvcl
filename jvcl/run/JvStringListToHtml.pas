{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvStringListToHtml.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is S�bastien Buysse [sbuysse@buypin.com]
Portions created by S�bastien Buysse are Copyright (C) 2001 S�bastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck@bigfoot.com].

Last Modified: 2000-02-28

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvStringListToHtml;

interface

uses
  SysUtils, Classes,
  JvComponent;

type
  TJvStringListToHtml = class(TJvComponent)
  private
    FStrings, FHTML: TStrings;
    FHTMLTitle: string;
    FHTMLLineBreak: string;
    FIncludeHeader: boolean;
    function GetHTML: TStrings;
    procedure SetStrings(const Value: TStrings);
    procedure DoStringsChange(Sender: TObject);
    procedure SetHTML(const Value: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ConvertToHtml(Source: TStrings; const Filename: string);
    procedure ConvertToHTMLStrings(Source, Destination: TStrings);
  published
    property HTML: TStrings read GetHTML write SetHTML stored false;
    property Strings: TStrings read FStrings write SetStrings;
    property HTMLLineBreak: string read FHTMLLineBreak write FHTMLLineBreak;
    property HTMLTitle: string read FHTMLTitle write FHTMLTitle;
    property IncludeHeader: boolean read FIncludeHeader write FIncludeHeader default true;
  end;

implementation

procedure ConvertStringsToHTML(Source, Destination: TStrings; const HTMLTitle, HTMLLineBreak: string; IncludeHeader: boolean);
var
  I: integer;
begin
  if (Source = nil) or (Destination = nil) then Exit;
  Destination.BeginUpdate;
  Source.BeginUpdate;
  try
    if IncludeHeader then
    begin
      Destination.Add('<HTML><HEAD>');
      Destination.Add('<TITLE>' + HTMLTitle + '</TITLE></HEAD>');
      Destination.Add('<BODY>');
    end;
    for I := 0 to Source.Count - 1 do
      Destination.Add(Source[I] + HTMLLineBreak);
    if IncludeHeader then
    begin
      Destination.Add('</BODY>');
      Destination.Add('</HTML>');
    end;
  finally
    Source.EndUpdate;
    Destination.EndUpdate;
  end;
end;

procedure TJvStringListToHtml.ConvertToHtml(Source: TStrings; const Filename: string);
var
  Dest: TStringlist;
begin
  if Source = nil then Exit;
  Dest := TStringlist.Create;
  try
    ConvertStringsToHTML(Source, Dest, HTMLTitle, HTMLLineBreak, true);
    Dest.SaveToFile(Filename);
  finally
    Dest.Free;
  end;
end;

procedure TJvStringListToHtml.ConvertToHTMLStrings(Source, Destination: TStrings);
begin
  ConvertStringsToHTML(Source, Destination, HTMLTitle, HTMLLineBreak, IncludeHeader);
end;

constructor TJvStringListToHtml.Create(AOwner: TComponent);
begin
  inherited;
  FStrings := TStringlist.Create;
  FHTML := TStringlist.Create;
  TStringlist(FStrings).OnChange := DoStringsChange;
  FHTMLLineBreak := '<BR>';
  FHTMLTitle := 'Converted by TJvStringListToHtml';
  FIncludeHeader := true;
end;

destructor TJvStringListToHtml.Destroy;
begin
  FreeAndNil(FStrings);
  FreeAndNil(FHTML);
  inherited;
end;

procedure TJvStringListToHtml.DoStringsChange(Sender: TObject);
begin
  FreeAndNil(FHTML);
end;

function TJvStringListToHtml.GetHTML: TStrings;
begin
  if ComponentState * [csLoading, csDestroying] <> [] then
  begin
    if FHTML.Count = 0 then
      ConvertToHtmlStrings(Strings, FHTML);
  end;
  Result := FHTML;
end;

procedure TJvStringListToHtml.SetHTML(const Value: TStrings);
begin
  // do nothing
end;

procedure TJvStringListToHtml.SetStrings(const Value: TStrings);
begin
  FStrings.Assign(Value);
  FHTML.Clear;
end;

end.

