{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvAppIniStorage.pas, released on --.

The Initial Developer of the Original Code is Marcel Bestebroer
Portions created by Marcel Bestebroer are Copyright (C) 2002 - 2003 Marcel
Bestebroer
All Rights Reserved.

Contributor(s):
  Jens Fudickar
  Olivier Sannier

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvAppIniStorage;

{$I jvcl.inc}

interface

uses
  Windows, Classes, IniFiles,
  JvAppStorage;

type
  // Storage to INI file, all in memory. This is the base class
  // for INI type storage, descendents will actually implement
  // the writing to a file or anything else
  TJvCustomAppIniStorage = class(TJvCustomAppMemoryFileStorage)
  private
    FIniFile: TMemIniFile;
    FDefaultSection: string;
    function CalcDefaultSection(Section: string): string;
  protected
    function GetAsString: string; override;
    procedure SetAsString(const Value: string); override;
    function DefaultExtension : string; override;

    procedure EnumFolders(const Path: string; const Strings: TStrings;
      const ReportListAsValue: Boolean = True); override;
    procedure EnumValues(const Path: string; const Strings: TStrings;
      const ReportListAsValue: Boolean = True); override;
    function PathExistsInt(const Path: string): Boolean; override;
    function ValueExists(const Section, Key: string): Boolean;
    function IsFolderInt(const Path: string; ListIsValue: Boolean = True): Boolean; override;
    function ReadValue(const Section, Key: string): string;
    procedure WriteValue(const Section, Key, Value: string); virtual;
    procedure RemoveValue(const Section, Key: string); virtual;
    procedure DeleteSubTreeInt(const Path: string); override;
    procedure SplitKeyPath(const Path: string; out Key, ValueName: string); override;
    function ValueStoredInt(const Path: string): Boolean; override;
    procedure DeleteValueInt(const Path: string); override;
    function DoReadInteger(const Path: string; Default: Integer): Integer; override;
    procedure DoWriteInteger(const Path: string; Value: Integer); override;
    function DoReadFloat(const Path: string; Default: Extended): Extended; override;
    procedure DoWriteFloat(const Path: string; Value: Extended); override;
    function DoReadString(const Path: string; const Default: string): string; override;
    procedure DoWriteString(const Path: string; const Value: string); override;
    function DoReadBinary(const Path: string; var Buf; BufSize: Integer): Integer; override;
    procedure DoWriteBinary(const Path: string; const Buf; BufSize: Integer); override;
    property DefaultSection: string read FDefaultSection write FDefaultSection;
    property IniFile: TMemIniFile read FIniFile;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  // This class handles the flushing into a disk file
  // and publishes a few properties for them to be
  // used by the user in the IDE
  TJvAppIniFileStorage = class(TJvCustomAppIniStorage)
  public
    procedure Flush; override;
    procedure Reload; override;
    property AsString;
    property IniFile;
  published
    property AutoFlush;
    property AutoReload;
    property FileName;
    property Location;
    property DefaultSection;
    property SubStorages;
    property OnGetFileName;
  end;

implementation

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  SysUtils,
  JvTypes, JvConsts, JvResources; // JvConsts or PathDelim under D5 and BCB5

const
  cNullDigit = '0';
  cCount = 'Count';
  cSectionHeaderStart = '[';
  cSectionHeaderEnd = ']';
  cKeyValueSeparator = '=';

function BinStrToBuf(Value: string; var Buf; BufSize: Integer): Integer;
var
  P: PChar;
begin
  if Odd(Length(Value)) then
    Value := cNullDigit + Value;
  if (Length(Value) div 2) < BufSize then
    BufSize := Length(Value) div 2;
  Result := 0;
  Dec(BufSize); // adjust for PChar
  P := PChar(Value);
  while BufSize >= 0 do
  begin
    PChar(@Buf)[Result] := Chr(StrToInt('$' + P[0] + P[1]));
    Inc(Result);
    Dec(BufSize);
    Inc(P, 2);
  end;
end;

function BufToBinStr(const Buf; BufSize: Integer): string;
var
  P: PChar;
  S: string;
begin
  SetLength(Result, BufSize * 2);
  P := PChar(Result);
  Dec(BufSize); // adjust for PChar
  Inc(P, BufSize * 2); // Point to end of string ^
  while BufSize >= 0 do
  begin
    S := IntToHex(Ord(PChar(@Buf)[BufSize]), 2);
    P[0] := S[1];
    P[1] := S[2];
    Dec(P, 2);
    Dec(BufSize);
  end;
end;

//=== { TJvCustomAppIniStorage } =============================================

constructor TJvCustomAppIniStorage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIniFile := TMemIniFile.Create(Name);
end;

destructor TJvCustomAppIniStorage.Destroy;
begin
  inherited Destroy;
  // Has to be done AFTER inherited, see comment in
  // TJvCustomAppMemoryFileStorage
  FIniFile.Free;
end;

procedure TJvCustomAppIniStorage.SplitKeyPath(const Path: string; out Key, ValueName: string);
begin
  inherited SplitKeyPath(Path, Key, ValueName);
  if Key = '' then
    Key := DefaultSection;
end;

function TJvCustomAppIniStorage.ValueStoredInt(const Path: string): Boolean;
var
  Section: string;
  Key: string;
begin
  SplitKeyPath(Path, Section, Key);
  Result := ValueExists(Section, Key);
end;

procedure TJvCustomAppIniStorage.DeleteValueInt(const Path: string);
var
  Section: string;
  Key: string;
begin
  SplitKeyPath(Path, Section, Key);
  RemoveValue(Section, Key);
end;

function TJvCustomAppIniStorage.DoReadInteger(const Path: string; Default: Integer): Integer;
var
  Section: string;
  Key: string;
  Value: string;
begin
  SplitKeyPath(Path, Section, Key);
  if ValueExists(Section, Key) then
  begin
    Value := ReadValue(Section, Key);
    if Value = '' then
      Value := cNullDigit;
    Result := StrToInt(Value);
  end
  else
    Result := Default;
end;

procedure TJvCustomAppIniStorage.DoWriteInteger(const Path: string; Value: Integer);
var
  Section: string;
  Key: string;
begin
  SplitKeyPath(Path, Section, Key);
  WriteValue(Section, Key, IntToStr(Value));
end;

function TJvCustomAppIniStorage.DoReadFloat(const Path: string; Default: Extended): Extended;
var
  Section: string;
  Key: string;
//  Value: string;
  Value: Extended;
begin
  SplitKeyPath(Path, Section, Key);
  if ValueExists(Section, Key) then
  begin
    Value := 0.0;
    ReadBinary(Path, Value, Sizeof(Value));
    Result := Value;
//    Value := ReadValue(Section, Key);
//    if Value = '' then
//      Value := cNullDigit;
//    Result := StrToFloat(Value);
  end
  else
    Result := Default;
end;

procedure TJvCustomAppIniStorage.DoWriteFloat(const Path: string; Value: Extended);
begin
  WriteBinary(Path, Value, SizeOf(Value));
end;

function TJvCustomAppIniStorage.DoReadString(const Path: string; const Default: string): string;
var
  Section: string;
  Key: string;
begin
  SplitKeyPath(Path, Section, Key);
  if ValueExists(Section, Key) then
    Result := ReadValue(Section, Key)
  else
    Result := Default;
end;

procedure TJvCustomAppIniStorage.DoWriteString(const Path: string; const Value: string);
var
  Section: string;
  Key: string;
begin
  SplitKeyPath(Path, Section, Key);
  WriteValue(Section, Key, Value);
end;

function TJvCustomAppIniStorage.DoReadBinary(const Path: string; var Buf; BufSize: Integer): Integer;
var
  Section: string;
  Key: string;
  Value: string;
begin
  SplitKeyPath(Path, Section, Key);
  if ValueExists(Section, Key) then
  begin
    Value := ReadValue(Section, Key);
    Result := BinStrToBuf(Value, Buf, BufSize);
  end
  else
    Result := 0;
end;

procedure TJvCustomAppIniStorage.DoWriteBinary(const Path: string; const Buf; BufSize: Integer);
var
  Section: string;
  Key: string;
begin
  SplitKeyPath(Path, Section, Key);
  WriteValue(Section, Key, BufToBinStr(Buf, BufSize));
end;

procedure TJvCustomAppIniStorage.EnumFolders(const Path: string; const Strings: TStrings;
  const ReportListAsValue: Boolean);
var
  RefPath: string;
  I: Integer;
begin
  Strings.BeginUpdate;
  try
    RefPath := GetAbsPath(Path);
    if RefPath = '' then
      RefPath := DefaultSection;
    if AutoReload and not IsUpdating then
      Reload;
    IniFile.ReadSections(Strings);
    I := Strings.Count - 1;
    while I >= 0 do
    begin
      if (RefPath <> '') and ((Copy(Strings[I], 1, Length(RefPath) + 1) <> RefPath + PathDelim) or
        (Pos(PathDelim, Copy(Strings[I], 2 + Length(RefPath), Length(Strings[I]) - Length(RefPath))) > 0)) then
        Strings.Delete(I)
      else
      if ReportListAsValue and ValueExists(Strings[I], cCount) then
        Strings.Delete(I)
      else
      if RefPath <> '' then
        Strings[I] := Copy(Strings[I], 1 + Length(RefPath), Length(Strings[I]) - Length(RefPath));
      Dec(I);
    end;
  finally
    Strings.EndUpdate;
  end;
end;

procedure TJvCustomAppIniStorage.EnumValues(const Path: string; const Strings: TStrings;
  const ReportListAsValue: Boolean);
var
  PathIsList: Boolean;
  RefPath: string;
  I: Integer;
begin
  Strings.BeginUpdate;
  try
    PathIsList := ReportListAsValue and ListStored(Path);
    RefPath := GetAbsPath(Path);
    if RefPath = '' then
      RefPath := DefaultSection;
    if AutoReload and not IsUpdating then
      Reload;
    IniFile.ReadSectionValues(RefPath, Strings);
    for I := Strings.Count - 1 downto 0 do
    begin
      Strings[I] := Copy(Strings[I], 1, Pos(cKeyValueSeparator, Strings[I]) - 1);
      if PathIsList and (AnsiSameText(cCount, Strings[I]) or NameIsListItem(Strings[I])) then
        Strings.Delete(I);
    end;
    if PathIsList then
      Strings.Add('');
  finally
    Strings.EndUpdate;
  end;
end;


function TJvCustomAppIniStorage.CalcDefaultSection(Section: string): string;
begin
  // Changed by Jens Fudickar to support DefaultSections; Similar to ReadValue
  // (rom) made it a private method
  if (Section = '') or (Section[1] = '.') then
    Result := DefaultSection + Section
  else
    Result := Section;
  if (Result = '') or (Result[1] = '.') then
    raise EJVCLAppStorageError.CreateRes(@RsEReadValueFailed);
end;

function TJvCustomAppIniStorage.ValueExists(const Section, Key: string): Boolean;
begin
  if IniFile <> nil then
  begin
    if AutoReload and not IsUpdating then
      Reload;
    Result := IniFile.ValueExists(CalcDefaultSection(Section), Key);
  end
  else
    Result := False;
end;

function TJvCustomAppIniStorage.ReadValue(const Section, Key: string): string;
begin
  if IniFile <> nil then
  begin
    if AutoReload and not IsUpdating then
      Reload;
    Result := IniFile.ReadString(CalcDefaultSection(Section), Key, '');
  end
  else
    Result := '';
end;

procedure TJvCustomAppIniStorage.WriteValue(const Section, Key, Value: string);
begin
  if IniFile <> nil then
  begin
    IniFile.WriteString(CalcDefaultSection(Section), Key, Value);
    if AutoFlush and not IsUpdating then
      Flush;
  end;
end;

procedure TJvCustomAppIniStorage.DeleteSubTreeInt(const Path: string);
var
  TopSection: string;
  Sections: TStringList;
  I: Integer;
begin
  if IniFile <> nil then
  begin
    TopSection := GetAbsPath(Path);
    Sections := TStringList.Create;
    try
      if AutoReload and not IsUpdating then
        Reload;
      IniFile.ReadSections(Sections);
      if TopSection = '' then
        for I := 0 to Sections.Count - 1 do
          IniFile.EraseSection(Sections[I])
      else
        for I := 0 to Sections.Count - 1 do
          if Pos(TopSection, Sections[I]) = 1 then
            IniFile.EraseSection(Sections[I]);
      if AutoFlush and not IsUpdating then
        Flush;
    finally
      Sections.Free;
    end;
  end;
end;

procedure TJvCustomAppIniStorage.RemoveValue(const Section, Key: string);
var
  LSection: string;
begin
  if IniFile <> nil then
  begin
    if AutoReload and not IsUpdating then
      Reload;
    LSection := CalcDefaultSection(Section);
    if IniFile.ValueExists(LSection, Key) then
    begin
      IniFile.DeleteKey(LSection, Key);
      if AutoFlush and not IsUpdating then
        Flush;
    end
    else
    if IniFile.SectionExists(LSection + '\' + Key) then
    begin
      IniFile.EraseSection(LSection + '\' + Key);
      if AutoFlush and not IsUpdating then
        Flush;
    end;
  end;
end;

function TJvCustomAppIniStorage.PathExistsInt(const Path: string): Boolean;
var
  Section: string;
  Key: string;
begin
  if AutoReload and not IsUpdating then
    Reload;
  SplitKeyPath(Path, Section, Key);
  Result := IniFile.SectionExists(Section + '\' + Key);
end;

function TJvCustomAppIniStorage.IsFolderInt(const Path: string; ListIsValue: Boolean): Boolean;
var
  RefPath: string;
  ValueNames: TStrings;
  I: Integer;
begin
  RefPath := GetAbsPath(Path);
  if RefPath = '' then
    RefPath := DefaultSection;
  if AutoReload and not IsUpdating then
    Reload;
  Result := IniFile.SectionExists(RefPath);
  if Result and ListIsValue and IniFile.ValueExists(RefPath, cCount) then
  begin
    Result := False;
    ValueNames := TStringList.Create;
    try
      EnumValues(Path, ValueNames, True);
      I := ValueNames.Count - 1;
      while Result and (I >= 0) do
      begin
        Result := not AnsiSameText(ValueNames[I], cCount) and not NameIsListItem(ValueNames[I]);
        Dec(I);
      end;
    finally
      ValueNames.Free;
    end;
  end;
end;

function TJvCustomAppIniStorage.GetAsString: string;
var
  TmpList : TStringList;
begin
  TmpList := TStringList.Create;
  try
    IniFile.GetStrings(TmpList);
    Result := TmpList.Text;
  finally
    TmpList.Free;
  end;
end;

procedure TJvCustomAppIniStorage.SetAsString(const Value: string);
var
  TmpList: TStringList;
begin
  TmpList := TStringList.Create;
  try
    TmpList.Text := Value;
    IniFile.SetStrings(TmpList);
  finally
    TmpList.Free;
  end;
end;

function TJvCustomAppIniStorage.DefaultExtension : string;
begin
  Result := 'ini';
end;

//=== { TJvAppIniFileStorage } ===============================================

procedure TJvAppIniFileStorage.Flush;
begin
  if FullFileName <> '' then
  begin
    IniFile.Rename(FullFileName, False);
    IniFile.UpdateFile;
  end;
end;

procedure TJvAppIniFileStorage.Reload;
begin
  if FileExists(FullFileName) and not IsUpdating then
    IniFile.Rename(FullFileName, True);
end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$RCSfile$';
    Revision: '$Revision$';
    Date: '$Date$';
    LogPath: 'JVCL\run'
  );

initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.

