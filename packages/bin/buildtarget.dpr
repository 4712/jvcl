{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: BuildTarget.pas, released on 2004-03-25.

The Initial Developer of the Original Code is Andreas Hausladen
Portions created by Andreas Hausladen are Copyright (C) 2004 Andreas Hausladen
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

program buildtarget;
{$APPTYPE CONSOLE}
uses
  Windows;

type
  TTarget = record
    Name: string;
    PerName: string;
    PerDir: string;
  end;

var
  Version: string;
  Edition: string;
  Root: string;
  JVCLRoot: string;
  PkgDir: string;
  UnitOutDir: string;
  MakeOptions: string;

  Editions: array of string = nil;
  Targets: array of TTarget = nil;


function ExtractFileDir(const S: string): string;
var
  ps: Integer;
begin
  ps := Length(S);
  while (ps > 1) and (S[ps] <> '\') do
    Dec(ps);
  Result := Copy(S, 1, ps - 1);
end;

function StrLen(P: PChar): Integer;
begin
  Result := 0;
  while P[Result] <> #0 do
    Inc(Result);
end;

function SameText(const S1, S2: string): Boolean;
var
  i, len: Integer;
begin
  Result := False;
  len := Length(S1);
  if len = Length(S2) then
  begin
    for i := 1 to len do
      if UpCase(S1[i]) <> UpCase(S2[i]) then
        Exit;
    Result := True;
  end;
end;

function StartsText(const SubStr, S: string): Boolean;
var
  i, len: Integer;
begin
  Result := False;
  len := Length(SubStr);
  if len <= Length(S) then
  begin
    for i := 1 to len do
      if UpCase(SubStr[i]) <> UpCase(S[i]) then
        Exit;
    Result := True;
  end;
end;

function FileExists(const Filename: string): Boolean;
var
  attr: Cardinal;
begin
  attr := GetFileAttributes(PChar(Filename));
  Result := (attr <> $FFFFFFFF) and (attr and FILE_ATTRIBUTE_DIRECTORY = 0);
end;

type
  IAttr = interface
    function Name: string;
    function Value: string;
  end;

  ITag = interface
    function Name: string;
    function Attrs(const Name: string): IAttr;
  end;

  TXmlFile = class(TObject)
  private
    FText: string;
    FPosition: Integer;
  public
    constructor Create(const Filename: string);

    function NextTag: ITag;
  end;

  TTag = class(TInterfacedObject, ITag)
  private
    FText: string;
  public
    constructor Create(const AText: string);
    function Name: string;
    function Attrs(const Name: string): IAttr;
  end;

  TAttr = class(TInterfacedObject, IAttr)
  private
    FText: string;
  public
    constructor Create(const AText: string);
    function Name: string;
    function Value: string;
  end;


constructor TXmlFile.Create(const Filename: string);
var
  f: file of Byte;
begin
  inherited Create;
  AssignFile(f, Filename);
  Reset(f);
  SetLength(FText, FileSize(f));
  BlockRead(f, FText[1], FileSize(f));
  CloseFile(f);
  FPosition := 0;
end;

function TXmlFile.NextTag: ITag;
var
  F, P: PChar;
  InStr1, InStr2: Boolean;
  S: string;
begin
  InStr1 := False;
  InStr2 := False;
  if FPosition >= Length(FText) then
  begin
    Result := nil;
    Exit;
  end;

  P := PChar(FText) + FPosition;
  while (P[0] <> #0) and (P[0] <> '<') do
    Inc(P);
  if P[0] <> #0 then
  begin
    if P[1] = '!' then // comment
    begin
      while (P[0] <> #0) do
      begin
        if (P[0] = '-') and (P[1] = '-') and (P[2] = '>') then
          Break;
        Inc(P);
      end;
      FPosition := P - PChar(FText);
      Result := NextTag;
      Exit;
    end;
    F := P;
    while True do
    begin
      case P[0] of
        #0:
          Break;
        '>':
          if not (InStr1 or InStr2) then
          begin
            SetString(S, F + 1, P - F - 1);
            Result := TTag.Create(S);
            Inc(P);
            Break;
          end;
        '''':
          InStr1 := not InStr1;
        '"':
          InStr2 := not InStr2;
      end;
      Inc(P);
    end;
  end;
  FPosition := P - PChar(FText);
end;

{ TTag }

constructor TTag.Create(const AText: string);
begin
  inherited Create;
  FText := AText;
end;

function TTag.Name: string;
var
  ps: Integer;
begin
  ps := Pos(' ', FText);
  if ps = 0 then
    Result := FText
  else
    Result := Copy(FText, 1, ps - 1);
end;

function TTag.Attrs(const Name: string): IAttr;
var
  ps: Integer;
  InStr1, InStr2: Boolean;
  F, P: PChar;
  S: string;
begin
  Result := TAttr.Create('');
  ps := Pos(' ', FText);
  if ps = 0 then
    Exit;
  P := PChar(FText) + ps;
  while P[0] <> #0 do
  begin
    while P[0] in [#1..#32] do
      Inc(P);
    if P[0] = #0 then
      Break;
    F := P;
    InStr1 := False;
    InStr2 := False;
    while True do
    begin
      case P[0] of
        #0, #9, #32, '/':
          if not (InStr1 or InStr2) or (P[0] = #0) then
          begin
            SetString(S, F, P - F);
            Result := TAttr.Create(S);
            if SameText(Result.Name, Name) then
              Exit;
            Inc(P);
            Break;
          end;
        '''':
          InStr1 := not InStr1;
        '"':
          InStr2 := not InStr2;
      end;
      Inc(P);
    end;
  end;
  Result := TAttr.Create('');
end;

{ TAttr }

constructor TAttr.Create(const AText: string);
begin
  inherited Create;
  FText := AText;
end;

function TAttr.Name: string;
var
  ps: Integer;
begin
  ps := Pos('=', FText);
  if ps = 0 then
    Result := FText
  else
    Result := Copy(FText, 1, ps - 1);
end;

function TAttr.Value: string;
var
  ps: Integer;
begin
  ps := Pos('=', FText);
  if ps = 0 then
    Result := ''
  else
  begin
    Result := Copy(FText, ps + 1, MaxInt);
    if (Result <> '') and (Result[1] in ['''', '"']) then
    begin
      Delete(Result, 1, 1);
      Delete(Result, Length(Result), 1);
    end;
  end;
end;


procedure LoadTargetNames;
var
  xml: TXmlFile;
  tg: ITag;
begin
  xml := TXmlFile.Create(JVCLRoot + '\devtools\bin\pgEdit.xml');
  try
    tg := xml.NextTag;
    while tg <> nil do
    begin
      if SameText(tg.Name, 'model') and SameText(tg.Attrs('name').Value, 'JVCL') then
      begin
        tg := xml.NextTag;
        while not SameText(tg.Name, 'targets') do
          tg := xml.NextTag;
        while not SameText(tg.Name, '/targets') do
        begin
          if SameText(tg.Name, 'target') then
          begin
            if FileExists(JVCLRoot + '\packages\' + tg.Attrs('name').Value + ' Packages.bpg') then
            begin
              SetLength(Targets, Length(Targets) + 1); // I know that I should not do this, but it is that easier
              with Targets[High(Targets)] do
              begin
                Name := tg.Attrs('name').Value;
                PerName := tg.Attrs('pname').Value;
                PerDir := tg.Attrs('pdir').Value;
              end;
            end;
          end;
          tg := xml.NextTag;
        end;

        Break; // we do only want the JVCL part
      end;
      tg := xml.NextTag;
    end;
  finally
    xml.Free;
  end;
end;

function IndexOfEdition(const ed: string): Integer;
begin
  for Result := 0 to High(Targets) do
    if SameText(Targets[Result].Name, ed) or SameText(Targets[Result].PerName, ed) then
      Exit;
  Result := -1;
end;

procedure AddEdition(const ed: string);
var
  i: Integer;
begin
  if ed = '' then
    Exit;
{$IFDEF MSWINDOWS}
  if SameText(ed, 'k3') then
    Exit;
{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
  if not SameText(ed, 'k3') then
    Exit;
{$ENDIF LINUX}
  for i := 0 to High(Editions) do
    if SameText(Editions[i], ed) then
      Exit;
  SetLength(Editions, Length(Editions) + 1);
  Editions[High(Editions)] := ed;
end;

procedure AddAllEditions(AddPersonal: Boolean);
var
  i: Integer;
begin
  Editions := nil;
  for i := 0 to High(Targets) do
  begin
    AddEdition(Targets[i].Name);
    if AddPersonal then
      AddEdition(Targets[i].PerName);
  end;
end;

function Execute(const Cmd: string): Integer;
var
  ProcessInfo: TProcessInformation;
  StartupInfo: TStartupInfo;
begin
  StartupInfo.cb := SizeOf(StartupInfo);
  GetStartupInfo(StartupInfo);
  if CreateProcess(nil, PChar(Cmd), nil, nil, True, 0, nil, nil, StartupInfo, ProcessInfo) then
  begin
    CloseHandle(ProcessInfo.hThread);
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Cardinal(Result));
    CloseHandle(ProcessInfo.hProcess);
  end
  else
    Result := -1;
end;

procedure Help;
var
  i: Integer;
begin
  AddAllEditions(True);
  WriteLn('buildtarget.exe setups the environment for the given targets and executes the');
  WriteLn('make file that does the required actions.');
  WriteLn;
  WriteLn('buildtarget.exe [TARGET] [OPTIONS]');
  WriteLn('  targets:');

  Write('    ');
  for i := 0 to High(Editions) - 1 do
    Write(Editions[i], ', ');
  if Length(Editions) > 0 then
    WriteLn(Editions[High(Editions)]);
  //WriteLn('    c5, c6, c6p, d5, d5s, d6, d6p, d7, d7p, d7clx');

  WriteLn;
  WriteLn('  OPTIONS:');
  WriteLn('    --make=X        X will be added to the make command line.');
  WriteLn('    --jcl-path=X    sets the JCLROOT environment variable to X.');
  WriteLn('    --bpl-path=X    sets the BPLDIR and DCPDIR environment variable to X.');
  WriteLn('    --lib-path=X    sets the LIBDIR environment variable to X (BCB only).');
  WriteLn('    --build         forces the Delphi compiler to build instead the targets.');
  WriteLn('    --targets=X     sets the TARGET environment variable to X. Only these .bpl');
  WriteLn('                    files will be compiled.');
  WriteLn('                    (Example:');
  WriteLn('                      buildtarget "--targets=JvCoreD7R.bpl JvCoreD7R.bpl" )');
  WriteLn;
end;

procedure ProcessArgs;
var
  i, Count: Integer;
  S: string;
begin
  i := 1;
  Count := ParamCount;
  while i <= Count do
  begin
    S := ParamStr(i);
    if S[1] = '-' then
    begin
      if StartsText('--make=', S) then
      begin
        Delete(S, 1, 7);
        if S <> '' then
          MakeOptions := MakeOptions + ' "' + S + '"';
      end
      else if StartsText('--jcl-path=', S) then
      begin
        Delete(S, 1, 11);
        SetEnvironmentVariable('JCLROOT', Pointer(S));
      end
      else if StartsText('--bpl-path=', S) then
      begin
        Delete(S, 1, 11);
        SetEnvironmentVariable('BPLDIR', Pointer(S));
        SetEnvironmentVariable('DCPDIR', Pointer(S));
      end
      else if StartsText('--lib-path=', S) then
      begin
        Delete(S, 1, 11);
        SetEnvironmentVariable('LIBDIR', Pointer(S));
      end
      else if SameText(S, '--build') then
      begin
        SetEnvironmentVariable('DCCOPT', '-Q -M -B');
      end
      else if StartsText('--targets=', S) then
      begin
        Delete(S, 1, 10);
        SetEnvironmentVariable('TARGETS', Pointer(S));
      end;
    end
    else
    begin
      if SameText(S, 'all') then
      begin
        AddAllEditions(False);
      end
      else if IndexOfEdition(S) = -1 then
      begin
        WriteLn('Unknown edition: ', S);
        Halt(1);
      end
      else
        AddEdition(S);
    end;
    Inc(i);
  end;
end;


var
  KeyName: string;
  reg: HKEY;
  len: Longint;
  RegTyp: LongWord;
  i: Integer;
begin
  JVCLRoot := ExtractFileDir(ParamStr(0)); // $(JVCL)\Packages\bin
  JVCLRoot := ExtractFileDir(JVCLRoot); // $(JVCL)\Packages
  JVCLRoot := ExtractFileDir(JVCLRoot); // $(JVCL)

  LoadTargetNames;
  ProcessArgs;

  if Length(Editions) = 0 then
  begin
    Help;
    Halt(1);
  end;

  for i := 0 to High(Editions) do
  begin
    Edition := Editions[i];
    if Length(Editions) > 1 then
      WriteLn('################################ ' + Edition + ' #########################################');

    Version := Edition[2];

    if UpCase(Edition[1]) = 'D' then
      KeyName := 'Software\Borland\Delphi\' + Version + '.0'
    else
      KeyName := 'Software\Borland\C++Builder\' + Version + '.0';

    if RegOpenKeyEx(HKEY_LOCAL_MACHINE, PChar(KeyName), 0, KEY_QUERY_VALUE or KEY_READ, reg) <> ERROR_SUCCESS then
    begin
      WriteLn('Delphi/BCB version not installed.');
      Continue;
    end;
    SetLength(Root, MAX_PATH);
    len := MAX_PATH;
    RegQueryValueEx(reg, 'RootDir', nil, @RegTyp, PByte(Root), @len);
    SetLength(Root, StrLen(PChar(Root)));
    RegCloseKey(reg);

    PkgDir := Edition;
    if (UpCase(PkgDir[3]) = 'P') or (UpCase(PkgDir[3]) = 'S') then
      if PkgDir[2] = '5' then
        PkgDir := Copy(PkgDir, 1, 2) + 'std'
      else
        PkgDir := Copy(PkgDir, 1, 2) + 'per';

    UnitOutDir := JVCLRoot + '\lib\' + Copy(Edition, 1, 2);

   // setup environment and execute build.bat
    SetEnvironmentVariable('PERSONALEDITION_OPTION', nil);
    SetEnvironmentVariable('ROOT', PChar(Root));
    SetEnvironmentVariable('JVCLROOT', PChar(JVCLRoot));
    SetEnvironmentVariable('VERSION', PChar(Version));
    SetEnvironmentVariable('UNITOUTDIR', PChar(UnitOutDir));

    if (UpCase(PkgDir[3]) = 'P') or (UpCase(PkgDir[3]) = 'S') then
    begin
      SetEnvironmentVariable('PERSONALEDITION_OPTION', '-DDelphiPersonalEdition');
      SetEnvironmentVariable('PKGDIR', PChar(Copy(PkgDir, 1, 2)));
      SetEnvironmentVariable('EDITION', PChar(Copy(Edition, 1, 2)));
      Execute('"' + Root + '\bin\make.exe" -f makefile.mak pg.exe');
    end;

    SetEnvironmentVariable('EDITION', PChar(Edition));
    SetEnvironmentVariable('PKGDIR', PChar(PkgDir));

    ExitCode := Execute('"' + Root + '\bin\make.exe" -f makefile.mak' + MakeOptions);
    if ExitCode <> 0 then
    begin
      WriteLn('Press ENTER to continue');
      ReadLn;
    end;
  end;
end.
