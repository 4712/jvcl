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

unit JvHMIReg;

interface

procedure Register;

implementation

{$R ..\..\Resources\JvHMIReg.dcr}

uses
  Classes,
  {$IFDEF COMPILER6_UP}
  DesignIntf, DesignEditors,
  {$ELSE}
  DsgnIntf,
  {$ENDIF COMPILER6_UP}
  ToolsAPI,
  JvConsts, JvSegmentedLEDDisplay, JvLED, JvDialButton,
  JvSegmentedLEDDisplayEditors, JvSegmentedLEDDisplayMapperFrame;

procedure Register;
begin
  RegisterComponents(SPaletteHMIIndicator, [TJvSegmentedLEDDisplay, TJvLED]);
  RegisterComponents(SPaletteHMIControls, [TJvDialButton]);
  RegisterPropertyEditor(TypeInfo(TJvSegmentedLEDDigitClassName), TPersistent, '', TJvSegmentedLEDDigitClassProperty);
  RegisterPropertyEditor(TypeInfo(TUnlitColor), TPersistent, '', TUnlitColorProperty);
  RegisterComponentEditor(TJvCustomSegmentedLEDDisplay, TJvSegmentedLEDDisplayEditor);
  RegisterCustomModule(TfmeJvSegmentedLEDDisplayMapper, TCustomModule);
end;

end.
