{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: CapExec.pas, released on 2003-11-28.

The Initial Developer of the Original Code is Andreas Hausladen [Andreas.Hausladen@gmx.de]
Portions created by Andreas Hausladen are Copyright (C) 2003 Andreas Hausladen.
All Rights Reserved.

Contributor(s): -

Last Modified: 2003-11-28

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
{.$I JVCL.INC}
{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$IFDEF VER150}
 // Delphi 7 .NET preview warnings
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

unit CapExec;
interface
uses
  Windows, SysUtils, Classes;
type
  TCaptureLine = procedure(const Line: string; var Aborted: Boolean) of object;

function CaptureExecute(const App, Args, Dir: string; CaptureLine: TCaptureLine): Integer;


implementation

function Oem2Ansi(const Text: string): string;
begin
  Result := Text;
  OemToCharBuff(PChar(Result), PChar(Result), Length(Result));
end;

function CaptureExecute(const App, Args, Dir: string; CaptureLine: TCaptureLine): Integer;
var
  ProcessInfo: TProcessInformation;
  StartupInfo: TStartupInfo;
  SecAttrib: TSecurityAttributes;
  hRead, hWrite: THandle;
  Line: string;
  Aborted: Boolean;

  procedure ProcessInput;
  var
    BytesInPipe, n: Cardinal;
    S: string;
    i: Integer;
    Found: Boolean;
  begin
    BytesInPipe := 0;
    if not PeekNamedPipe(hRead, nil, 0, nil, @BytesInPipe, nil) then
      BytesInPipe := 0;
    SetLength(S, BytesInPipe);
    if S <> '' then
    begin
      ReadFile(hRead, S[1], BytesInPipe, n, nil);
      SetLength(S, n);
      Line := Line + S;
      repeat
        Found := False;
        for i := 1 to Length(Line) do
          if Line[i] in [#10, #13] then
          begin
            CaptureLine(Oem2Ansi(Copy(Line, 1, i - 1)), Aborted);
            if (Line[i] = #13) and (Line[i + 1] = #10) then
            begin
              if Line[i + 2] = #13 then
                Delete(Line, 1, i + 2)
              else
                Delete(Line, 1, i + 1);
            end
            else
              Delete(Line, 1, i);
            Found := True;
            Break;
          end;
      until (Aborted) or (not Found);
    end;
  end;

begin
  Result := -2;
//  AllocConsole;
  if not Assigned(CaptureLine) then
    Exit;

  FillChar(SecAttrib, SizeOf(SecAttrib), 0);
  with SecAttrib do begin
    nLength := SizeOf(SecAttrib);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end; // with

  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  StartupInfo.cb := SizeOf(TStartupInfo);

  Aborted := False;
  if not CreatePipe(hRead, hWrite, @SecAttrib, 0) then
    Exit;
  try
    StartupInfo.wShowWindow := SW_HIDE;
    StartupInfo.hStdInput := GetStdHandle(STD_INPUT_HANDLE);
    StartupInfo.hStdOutput := hWrite;
    StartupInfo.hStdError := StartupInfo.hStdOutput; // redirect
    StartupInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;

    if CreateProcess(nil, PChar(App + ' ' + Args), @SecAttrib, nil, True, 0, nil,
      PChar(Dir), StartupInfo, ProcessInfo) then
    begin
      CloseHandle(ProcessInfo.hThread);
      try
        while (WaitForSingleObject(ProcessInfo.hProcess, 10) = WAIT_TIMEOUT) and (not Aborted) do
          ProcessInput;
        ProcessInput;
        if Line <> '' then
          CaptureLine(Line, Aborted);
        if Aborted then
          TerminateProcess(ProcessInfo.hProcess, Cardinal(-3));
        GetExitCodeProcess(ProcessInfo.hProcess, Cardinal(Result));
      finally
        CloseHandle(ProcessInfo.hProcess);
      end;
    end
    else
      Result := -1;
  finally
    CloseHandle(hRead);
    CloseHandle(hWrite);
  end;
end;

end.
