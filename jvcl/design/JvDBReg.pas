{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvDBReg.PAS, released on 2002-05-26.

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

unit JvDBReg;

interface

procedure Register;

implementation

uses
  Classes,
  {$IFDEF COMPILER6_UP}
  DesignEditors, DesignIntf,
  {$ELSE}
  DsgnIntf,
  {$ENDIF COMPILER6_UP}
  JvDsgnConsts,
  JvMemoryDataset, JvDBDatePickerEdit, JvDBDateTimePicker, JvDBLookupTreeView,
  JvDBProgressBar, JvDBRichEdit, JvDBSpinEdit, JvDBTreeView, JvDBLookup,
  JvCsvData, JvDBCombobox, JvDBControls, JvDBGrid, JvDBRadioPanel, JvDBGridExport,
  JvDBLookupComboEdit,

  {$IFDEF JV_MIDAS}
  JvDBRemoteLogin,
  {$ENDIF JV_MIDAS}
  JvDBEditors, JvDBMemDatasetEditor, JvDBGridExportEditors;

{$R ..\resources\JvDBReg.dcr}

procedure Register;
const
  cKeyField = 'KeyField';
  cListField = 'ListField';
  cMasterField = 'MasterField';
  cDetailField = 'DetailField';
  cIconField = 'IconField';
  cItemField = 'ItemField';
  cLookupField = 'LookupField';
  cRowsHeight = 'RowsHeight';
  //cStartMasterValue = 'StartMasterValue';
begin
  RegisterComponents(RsPaletteDBNonVisual, [TJvMemoryData,
    TJvCSVDataSet {$IFDEF JV_MIDAS}, TJvDBRemoteLogin {$ENDIF},
    TJvDBGridWordExport, TJvDBGridExcelExport, TJvDBGridHTMLExport, TJvDBGridCSVExport, TJvDBGridXMLExport]);

  RegisterComponents(RsPaletteDBVisual, [TJvDBDatePickerEdit,
    TJvDBDateTimePicker, TJvDBProgressBar, TJvDBRichEdit, TJvDBSpinEdit,
    TJvDBLookupList, TJvDBLookupCombo, TJvDBLookupEdit, TJvDBRadioPanel,
    TJvDBCombobox, TJvDBTreeView, TJvDBLookupTreeViewCombo, TJvDBLookupTreeView,
    TJvDBGrid, TJvDBComboEdit, TJvDBDateEdit, TJvDBCalcEdit, TJvDBMaskEdit,
    TJvDBStatusLabel, TJvDBLookupComboEdit]);

  RegisterPropertyEditor(TypeInfo(Integer), TJvDBGrid, cRowsHeight, nil);
  RegisterPropertyEditor(TypeInfo(string), TJvLookupControl, cLookupField, TJvLookupSourceProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupEdit, cLookupField, TJvLookupSourceProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBTreeView, cItemField, TJvDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBTreeView, cMasterField, TJvDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBTreeView, cDetailField, TJvDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBTreeView, cIconField, TJvDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeViewCombo, cKeyField, TJvListFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeViewCombo, cListField, TJvListFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeViewCombo, cMasterField, TJvListFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeViewCombo, cDetailField, TJvListFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeViewCombo, cIconField, TJvListFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeView, cKeyField, TJvListFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeView, cListField, TJvListFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeView, cMasterField, TJvListFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeView, cDetailField, TJvListFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeView, cIconField, TJvListFieldProperty);
  RegisterPropertyEditor(TypeInfo(TWordGridFormat), TJvDBGridWordExport, '', TDBGridExportWordFormatProperty);

  RegisterComponentEditor(TJvMemoryData, TJvMemDataSetEditor);
end;

end.

