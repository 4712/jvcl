{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvAppStore.pas, released on --.

The Initial Developer of the Original Code is Marcel Bestebroer
Portions created by Marcel Bestebroer are Copyright (C) 2002 - 2003 Marcel
Bestebroer
All Rights Reserved.

Contributor(s):

Last Modified: 2003-09-05

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}
{$I WINDOWSONLY.INC}

unit JvAppRegistryStore;

interface

uses
  Classes, Windows,
  JvAppStore, JvTypes;

type
  TJvAppRegistryStore = class(TJvCustomAppStore)
  private
    FRegHKEY: HKEY;
  protected
    function GetRegRoot: TJvRegKey;
    procedure SetRegRoot(Value: TJvRegKey);
    { Create the registry key path if it doesn't exist yet. Any key in the path that doesn't exist
      is created. }
    procedure CreateKey(Key: string);
    procedure EnumFolders(const Path: string; const Strings: TStrings;
      const ReportListAsValue: Boolean = True); override;
    procedure EnumValues(const Path: string; const Strings: TStrings;
      const ReportListAsValue: Boolean = True); override;
  public
    constructor Create(AOwner: TComponent); override;
    function IsFolder(Path: string; ListIsValue: Boolean = True): Boolean; override;
    function PathExists(const Path: string): boolean; override;
    function ValueStored(const Path: string): Boolean; override;
    procedure DeleteValue(const Path: string); override;
    procedure DeleteSubTree(const Path: string); override;
    function ReadBooleanInt(const Path: string; Default: Boolean = True): Boolean; override;
    procedure WriteBooleanInt(const Path: string; Value: Boolean); override;
    function ReadIntegerInt(const Path: string; Default: Integer = 0): Integer; override;
    procedure WriteIntegerInt(const Path: string; Value: Integer); override;
    function ReadFloatInt(const Path: string; Default: Extended = 0): Extended; override;
    procedure WriteFloatInt(const Path: string; Value: Extended); override;
    function ReadStringInt(const Path: string; Default: string = ''): string; override;
    procedure WriteStringInt(const Path: string; Value: string); override;
    function ReadBinaryInt(const Path: string; var Buf; BufSize: Integer): Integer; override;
    procedure WriteBinaryInt(const Path: string; const Buf; BufSize: Integer); override;
  published
    property Root;
    property RegRoot: TJvRegKey read GetRegRoot write SetRegRoot;
  end;

implementation

uses
  SysUtils,
  JclRegistry, JclResources, JclStrings;

const
  cCount = 'Count';

resourcestring
  SUnableToCreateKey = 'Unable to create key ''%s''';
  SErrorEnumeratingRegistry = 'Error enumerating registry.';

{ (rom) disabled unused
const
  HKEY_Names: array [HKEY_CLASSES_ROOT..HKEY_DYN_DATA, 0..1] of PChar =
   (
    ('HKEY_CLASSES_ROOT', 'HKCR'),
    ('HKEY_CURRENT_USER', 'HKCU'),
    ('HKEY_LOCAL_MACHINE', 'HKLM'),
    ('HKEY_USERS', 'HKU'),
    ('HKEY_PERFORMANCE_DATA', 'HKPD'),
    ('HKEY_CURRENT_CONFIG', 'HKCC'),
    ('HKEY_DYN_DATA', 'HKDD')
   );
}

//=== TJvAppRegistryStore ====================================================

constructor TJvAppRegistryStore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRegHKEY := HKEY_CURRENT_USER;
end;

function TJvAppRegistryStore.GetRegRoot: TJvRegKey;
begin
  Result := TJvRegKey(FRegHKEY - HKEY_CLASSES_ROOT);
end;

procedure TJvAppRegistryStore.SetRegRoot(Value: TJvRegKey);
begin
  if Value <> RegRoot then
    FRegHKEY := HKEY_CLASSES_ROOT + Longword(Ord(Value));
end;

procedure TJvAppRegistryStore.CreateKey(Key: string);
var
  ResKey: HKEY;
begin
  if not RegKeyExists(FRegHKEY, Key) then
    if Windows.RegCreateKey(FRegHKEY, PChar(Key), ResKey) = ERROR_SUCCESS then
      RegCloseKey(ResKey)
    else
      raise Exception.CreateFmt(SUnableToCreateKey, [Key]);
end;

procedure TJvAppRegistryStore.EnumFolders(const Path: string; const Strings: TStrings;
  const ReportListAsValue: Boolean);
var
  Key: string;
  TmpHKEY: HKEY;
  I: Integer;
  SubKeyName: array [0..255] of Char;
  EnumRes: Longint;
begin
  Key := GetAbsPath(Path);
  if RegKeyExists(FRegHKEY, Key) then
    if RegOpenKey(FRegHKEY, PChar(Key), TmpHKEY) = ERROR_SUCCESS then
      try
        I := 0;
        repeat
          EnumRes := RegEnumKey(TmpHKEY, I, SubKeyName, 255);
          if (EnumRes = ERROR_SUCCESS) and (not ReportListAsValue or
              not ListStored(Path + '\' + SubKeyName)) then
            Strings.Add(SubKeyName);
          Inc(I);
        until EnumRes <> ERROR_SUCCESS;
        if EnumRes <> ERROR_NO_MORE_ITEMS then
          raise EJclRegistryError.Create(SErrorEnumeratingRegistry);
      finally
        RegCloseKey(TmpHKEY);
      end;
end;

procedure TJvAppRegistryStore.EnumValues(const Path: string; const Strings: TStrings;
  const ReportListAsValue: Boolean);
var
  PathIsList: Boolean;
  Key: string;
  TmpHKEY: HKEY;
  I: Integer;
  Name: array [0..511] of Char;
  NameLen: Cardinal;
  EnumRes: Longint;
begin
  PathIsList := ReportListAsValue and ListStored(Path);
  if PathIsList then
    Strings.Add('');
  Key := GetAbsPath(Path);
  if RegKeyExists(FRegHKEY, Key) then
    if RegOpenKey(FRegHKEY, PChar(Key), TmpHKEY) = ERROR_SUCCESS then
      try
        I := 0;
        repeat
          NameLen := 511;
          EnumRes := RegEnumValue(TmpHKEY, I, Name, NameLen, nil, nil, nil, nil);
          if (EnumRes = ERROR_SUCCESS) and (not PathIsList or (not AnsiSameText(cCount, Name) and
              not NameIsListItem(Name))) then
            Strings.Add(Name);
          Inc(I);
        until EnumRes <> ERROR_SUCCESS;
        if EnumRes <> ERROR_NO_MORE_ITEMS then
          raise EJclRegistryError.Create(SErrorEnumeratingRegistry);
      finally
        RegCloseKey(TmpHKEY);
      end;
end;

function TJvAppRegistryStore.IsFolder(Path: string; ListIsValue: Boolean): Boolean;
var
  RefPath: string;
  PathHKEY: HKEY;
  I: Integer;
  Name: array [0..511] of Char;
  NameLen: Cardinal;
  EnumRes: Longint;
begin
  Result := False;
  RefPath := GetAbsPath(Path);
  if RegOpenKey(FRegHKEY, PChar(RefPath), PathHKEY) = ERROR_SUCCESS then
    try
      Result := True;
      if ListIsValue and (RegQueryValueEx(PathHKey, cCount, nil, nil, nil, nil) = ERROR_SUCCESS) then
      begin
        Result := False;
        I := 0;
        repeat
          NameLen := 511;
          EnumRes := RegEnumValue(PathHKEY, I, Name, NameLen, nil, nil, nil, nil);
          Result := (EnumRes = ERROR_SUCCESS) and not AnsiSameText(cCount, Name) and
            not NameIsListItem(Name);
          Inc(I);
        until (EnumRes <> ERROR_SUCCESS) or Result;
        if EnumRes <> ERROR_NO_MORE_ITEMS then
          raise EJclRegistryError.Create(SErrorEnumeratingRegistry);
      end;
    finally
      RegCloseKey(PathHKEY);
    end;
end;

function TJvAppRegistryStore.PathExists(const Path: string): boolean;
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  Result := RegKeyExists(FRegHKEY, SubKey+'\'+ValueName);
end;

function TJvAppRegistryStore.ValueStored(const Path: string): Boolean;
var
  SubKey: string;
  ValueName: string;
  TmpKey: HKEY;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  Result := RegKeyExists(FRegHKEY, SubKey);
  if Result then
    if RegOpenKey(FRegHKEY, PChar(SubKey), TmpKey) = ERROR_SUCCESS then
      try
        Result := RegQueryValueEx(TmpKey, PChar(ValueName), nil, nil, nil, nil) = ERROR_SUCCESS;
      finally
        RegCloseKey(TmpKey);
      end
    else
      raise EJclRegistryError.CreateResRecFmt(@RsUnableToOpenKeyRead, [SubKey]);
end;

procedure TJvAppRegistryStore.DeleteValue(const Path: string);
var
  SubKey: string;
  ValueName: string;
begin
  if ValueStored(Path) then
  begin
    SplitKeyPath(Path, SubKey, ValueName);
    RegDeleteEntry(FRegHKEY, SubKey, ValueName);
  end;
end;

procedure TJvAppRegistryStore.DeleteSubTree(const Path: string);
var
  KeyRoot: string;
begin
  KeyRoot := GetAbsPath(Path);
  if RegKeyExists(FRegHKEY, KeyRoot) then
    RegDeleteKeyTree(FRegHKEY, KeyRoot);
end;

function TJvAppRegistryStore.ReadIntegerInt(const Path: string; Default: Integer = 0): Integer;
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  try
    Result := RegReadIntegerDef(FRegHKEY, SubKey, ValueName, Default);
  except
    on E: EJclRegistryError do
      if StoreOptions.DefaultIfReadConvertError then
        Result := Default
      else
        raise;
  end;
end;

procedure TJvAppRegistryStore.WriteIntegerInt(const Path: string; Value: Integer);
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  CreateKey(SubKey);
  RegWriteInteger(FRegHKEY, SubKey, ValueName, Value);
end;

function TJvAppRegistryStore.ReadBooleanInt(const Path: string; Default: Boolean = True): Boolean;
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  try
    Result := RegReadBoolDef(FRegHKEY, SubKey, ValueName, Default);
  except
    on E: EJclRegistryError do
      if StoreOptions.DefaultIfReadConvertError then
        Result := Default
      else
        raise;
  end;
end;

procedure TJvAppRegistryStore.WriteBooleanInt(const Path: string; Value: Boolean);
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  CreateKey(SubKey);
  RegWriteBool(FRegHKEY, SubKey, ValueName, Value);
end;


function TJvAppRegistryStore.ReadFloatInt(const Path: string; Default: Extended = 0): Extended;
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  Result := Default;
  try
    RegReadBinary(FRegHKEY, SubKey, ValueName, Result, SizeOf(Result));
  except
    on E: EJclRegistryError do
      if StoreOptions.DefaultIfReadConvertError then
        Result := Default
      else
        raise;
  end;
end;

procedure TJvAppRegistryStore.WriteFloatInt(const Path: string; Value: Extended);
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  CreateKey(SubKey);
  RegWriteBinary(FRegHKEY, SubKey, ValueName, Value, SizeOf(Value));
end;

function TJvAppRegistryStore.ReadStringInt(const Path: string; Default: string = ''): string;
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  try
    Result := RegReadStringDef(FRegHKEY, SubKey, ValueName, Default);
  except
    on E: EJclRegistryError do
      if StoreOptions.DefaultIfReadConvertError then
        Result := Default
      else
        raise;
  end;
end;

procedure TJvAppRegistryStore.WriteStringInt(const Path: string; Value: string);
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  CreateKey(SubKey);
  RegWriteString(FRegHKEY, SubKey, ValueName, Value);
end;

function TJvAppRegistryStore.ReadBinaryInt(const Path: string; var Buf; BufSize: Integer): Integer;
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  Result := RegReadBinary(FRegHKEY, SubKey, ValueName, Buf, BufSize);
end;

procedure TJvAppRegistryStore.WriteBinaryInt(const Path: string; const Buf; BufSize: Integer);
var
  SubKey: string;
  ValueName: string;
  TmpBuf: Byte;
begin
  TmpBuf := Byte(Buf);
  SplitKeyPath(Path, SubKey, ValueName);
  CreateKey(SubKey);
  RegWriteBinary(FRegHKEY, SubKey, ValueName, TmpBuf, BufSize);
end;

end.
