{**************************************************************************************************}
{  WARNING:  JEDI preprocessor generated unit. Manual modifications will be lost on next release.  }
{**************************************************************************************************}

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvSystemReg.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is John Doe.
Portions created by John Doe are Copyright (C) 2003 John Doe.
All Rights Reserved.

Contributor(s):

Last Modified: 2003-11-09

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvQSystemReg;

interface

procedure Register;

implementation

uses
  Classes, QControls,

  DesignEditors, DesignIntf,

  JvQDsgnConsts,
  {$IFDEF MSWINDOWS}
  JvQJoystick, JvQSoundControl, JvQChangeNotifyEditor, JvQChangeNotify,
  JvQScreenSaver,
  {$ENDIF MSWINDOWS}
  JvQSystemColors,
  JvQSimpleXml, JvQXmlDatabase, JvQTimer, JvQFormPlacement,
  JvQMinMaxForm, JvQThread, JvQThreadTimer, {JvQTimerList,}
  JvQFormPropertiesForm, JvQDsgnEditors, JvQFormPlacementSelectList,
  JvQAppXMLStorage{, JvQTimerListEditor};

{$R ../Resources/JvSystemReg.dcr}

procedure Register;
begin
  RegisterComponents(RsPaletteSystem, [
      {$IFDEF MSWINDOWS}
      TJvScreenSaver, TJvJoystick, TJvSoundControl, TJvChangeNotify,
      {$ENDIF MSWINDOWS}
      TJvSystemColors]);
  RegisterComponents(RsPaletteInternetWork, [TJvSimpleXML, TJvXMLDatabase]);
  RegisterComponents(RsPaletteNonVisual, [TJvTimer, TJvThread , TJvThreadTimer{, TJvTimerList}]);
  RegisterComponents(RsPalettePersistence, [TJvFormStorage, TJvFormStorageSelectList,
      TJvAppXMLFileStorage]);

  {$IFDEF MSWINDOWS}
  RegisterPropertyEditor(TypeInfo(string), TJvChangeItem,
    'Directory', TJvDirectoryProperty);
  {$ENDIF}
  RegisterPropertyEditor(TypeInfo(TJvWinMinMaxInfo), TJvFormPlacement,
    'MinMaxInfo', TMinMaxProperty);
  RegisterPropertyEditor(TypeInfo(TStrings), TJvFormStorage,
    'StoredProps', TJvStoredPropsProperty);

  RegisterComponentEditor(TJvFormStorage, TJvFormStorageEditor);
{  RegisterComponentEditor(TJvTimerList, TJvTimerListDefaultEditor); }
  {$IFDEF MSWINDOWS}
  RegisterComponentEditor(TJvChangeNotify, TJvChangeNotifyEditor);
  {$ENDIF MSWINDOWS}
end;

end.

