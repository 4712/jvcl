{**************************************************************************************************}
{  WARNING:  JEDI preprocessor generated unit. Manual modifications will be lost on next release.  }
{**************************************************************************************************}

// No licence info because this should be merged with other Registration Unit

{$I jvcl.inc}

unit JvQJansReg;

interface

uses
  Classes,
  
  DesignIntf, DesignEditors, VCLEditors,
  
  JvQMarkupLabel, JvQMarkupViewer, JvQSAL, JvQSALCore, JvQSALMath,
  JvQYearGrid, JvQTracker, JvQAirBrush, JvQGridFilter, JvQGridPrinter,
  JvQArrayButton, JvQForth, JvQTurtle, JvQPaintFX, JvQDrawImage,
  JvQBitmapButton, JvQSimScope, JvQSimIndicator, JvQSimPID, JvQSIMPIDLinker,
  JvQSimLogic, JvQSpellerForm, JvQCSVBaseControls, JvQCSVBaseEditor;

procedure Register;

implementation

{$IFDEF MSWINDOWS}
{$R ..\Resources\JvJansReg.dcr}
{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
{$R ../Resources/JvJansReg.dcr}
{$ENDIF LINUX}

procedure Register;
const
  cCSVField = 'CSVField';
  cCSVFieldName = 'CSVFieldName';
begin
  //TODO: Register a TShortCut Property Editor on TTreeKeyMappings class in TJvJanTreeView
  RegisterComponents('Jv Jans', [TJvMarkupLabel, TJvMarkupViewer, TJvSAL,
    TJvSALCore, TJvSALMath, TJvYearGrid, TJvAirBrush, TJvTracker,
    TJvGridFilter, TJvGridPrinter, TJvPaintFX, TJvDrawImage,
    TJvArrayButton, TJvForthScript, TJvTurtle, TJvBitmapButton, TJvSpeller]);
  // Simulator Components
  RegisterComponents('Jv Jans SIM', [TJvSimScope, TJvSimIndicator, TJvSimPID,
    TJvSimPIDLinker, TJvSimConnector, TJvLogic, TJvSimButton, TJvSimLight,
    TJvSimLogicBox, TJvSimReverse]);
  // CSV Components
  RegisterComponents('Jv Jans CSV', [TJvCSVBase, TJvCSVEdit, TJvCSVComboBox,
    TJvCSVCheckBox, TJvCSVNavigator]);
  RegisterPropertyEditor(TypeInfo(string), TJvCSVBase, cCSVFieldName, TCSVFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvCSVEdit, cCSVField, TCSVFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvCSVComboBox, cCSVField, TCSVFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvCSVCheckBox, cCSVField, TCSVFieldProperty);

end;

end.
