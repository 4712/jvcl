{******************************************************************************}
{* WARNING:  JEDI VCL To CLX Converter generated unit.                        *}
{*           Manual modifications will be lost on next release.               *}
{******************************************************************************}

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvDlgsReg.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is John Doe.
Portions created by John Doe are Copyright (C) 2003 John Doe.
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

{$I jvcl.inc}

unit JvQDlgsReg;

interface

procedure Register;

implementation

uses
  Classes, QDialogs, QActnList, 
  DesignEditors, DesignIntf, 
  JvQDsgnConsts, 
  {$IFDEF MSWINDOWS}
  JvQWinDialogs, JvQAddPrinter, JvQCommonDialogD, JvQConnectNetwork, JvQCopyError,
  JvQDeleteError, JvQRenameError, JvQDiskPrompt, JvQFindFiles,
  JvQObjectPickerDialog, JvQCommonDialogDEditor,
  {$ENDIF MSWINDOWS}
  JvQBaseDlg, JvQFindReplace, JvQDSADialogs, JvQTipOfDay, JvQCommonExecDlg,
  JvQDesktopAlert, JvQProgressComponent, JvQSelectDirectory, JvQImageDlg,
  JvQLoginForm, JvQDualList, JvQProgressDialog, JvQBaseDlgEditor,
  JvQTipOfDayEditor;

{$IFDEF MSWINDOWS}
{$R ..\Resources\JvDlgsReg.dcr}
{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
{$R ../Resources/JvDlgsReg.dcr}
{$ENDIF LINUX}

procedure Register;
const
  cAppletName = 'AppletName';
  cAppletIndex = 'AppletIndex';
begin 
  RegisterComponents(RsPaletteDialog, [TJvSelectDirectory,  TJvTipOfDay,
    TJvFindReplace, TJvDSADialog]); 
  {$IFDEF MSWINDOWS}
  RegisterComponents(RsPaletteDialog, [TJvConnectNetwork,
    TJvDisconnectNetwork, TJvAddPrinterDialog, TJvFindFilesDialog,
    TJvFormatDriveDialog, TJvOrganizeFavoritesDialog,
    TJvComputerNameDialog, TJvChangeIconDialog,
    TJvShellAboutDialog, TJvRunDialog, TJvObjectPropertiesDialog,
    TJvNewLinkDialog, TJvAddHardwareDialog, TJvOpenWithDialog,
    TJvDiskFullDialog, TJvExitWindowsDialog, TJvOutOfMemoryDialog,
    TJvObjectPickerDialog, TJvDualListDialog, TJvImageDialog, TJvLoginDialog,
    TJvProgressDialog, TJvProgressComponent, TJvDiskPrompt, TJvCopyError,
    TJvDeleteError, TJvRenameError, TJvDesktopAlert, TJvDesktopAlertStack]);
  {$ENDIF MSWINDOWS}
 

  {$IFDEF JVCL_REGISTER_GLOBAL_DESIGNEDITORS}
  RegisterComponentEditor(TCommonDialog, TJvBaseDlgEditor);
  {$ENDIF JVCL_REGISTER_GLOBAL_DESIGNEDITORS}
  RegisterComponentEditor(TJvCommonDialog, TJvBaseDlgEditor); 
  RegisterComponentEditor(TJvCommonDialogP, TJvBaseDlgEditor);
  RegisterComponentEditor(TJvCommonDialogF, TJvBaseDlgEditor);
  {$IFDEF MSWINDOWS}
  RegisterComponentEditor(TJvCommonDialogD, TJvCommonDialogDEditor);
  {$ENDIF MSWINDOWS}
  RegisterComponentEditor(TJvTipOfDay, TJvTipOfDayEditor);   // removed because BCB5 cannot compile/link JvDialogActns  
end;

end.
