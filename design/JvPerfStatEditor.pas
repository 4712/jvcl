{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvPerfStatEditor.PAS, released on YYYY-MM-DD.

The Initial Developer of the Original Code is ?
Portions created by ? are Copyright (C) 2001 ?.
All Rights Reserved.

Contributor(s): 

Last Modified: 

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
{$I JVCL.INC}
{$I WINDOWSONLY.INC}

unit JvPerfStatEditor;

interface
uses
  Windows, SysUtils, Classes, Dlgs, Dialogs,
  {$IFDEF COMPILER5}
  DsgnIntf,
  {$ENDIF}
  {$IFDEF COMPILER6_UP}
  DesignEditors, DesignIntf,
  {$ENDIF}
  JvPerfMon95;

type
  TJvPerfStatProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

implementation

//=== TJvPerfStatProperty ====================================================

function TJvPerfStatProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

procedure TJvPerfStatProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    JvGetPerfStatItems(Values);
    for I := 0 to Values.Count - 1 do
      Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

end.
