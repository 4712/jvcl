{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvResources.PAS, released on 2003-12-10.

The Initial Developer of the Original Code is: Robert Marquardt (robert_marquardt@gmx.de)
Copyright (c) 2003 Robert Marquardt
All Rights Reserved.

Contributor(s):

Last Modified: 2003-12-10

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Description:
  unit to centralize all resourcestrings of the JVCL for easier translation

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvResources;

interface

uses
  JvConsts;

//=== used in several files ==================================================
resourcestring
  RsButtonOKCaption = '&OK';
  RsButtonCancelCaption = 'Cancel';
  RsBackButtonCaption = '< &Back';
  RsPrevButtonCaption = '< &Prev';
  RsNextButtonCaption = '&Next >';
  RsDateDlgCaption = 'Select a Date';
  RsDetailsLeftCaption = '<< &Details';
  RsDetailsRightCaption = '&Details >>';
  RsNoneCaption = '(none)';

  RsUndoItem = '&Undo';
  RsCutItem = 'Cu&t';
  RsCopyItem = '&Copy';
  RsPasteItem = '&Paste';
  RsDeleteItem = '&Delete';
  RsSelectAllItem = 'Select &All';
  {
  SWEDISH:
  RsUndoItem = '&�ngra';
  RsCutItem = '&Klipp ut';
  RsCopyItem = 'K&opiera';
  RsPasteItem = 'Kl&istra in';
  RsDeleteItem = '&Ta bort';
  RsSelectAllItem = '&Markera allt';

  GERMAN:
  RsUndoItem = '&R�ckg�ngig';
  RsCutItem = '&Ausschneiden';
  RsCopyItem = '&Kopieren';
  RsPasteItem = 'E&inf�gen';
  RsDeleteItem = '&L�schen';
  RsSelectAllItem = 'Alles &markieren';
  }

  RsEmptyItem = '<Empty>';

  RsDatabaseName = 'Database name: %s';
  RsDataItemRenderHasNoText = '(item does not support the IJvDataItemText interface)';
  RsError = 'Error';
  RsFalse = 'False';
  RsTrue = 'True';

  RsEErrorSetupDll = 'Unable to find SetupApi.dll';
  RsEInternalError = 'internal error';
  RsEUnterminatedStringNears = 'unterminated string near %s';
  RsEStackOverflow = 'stack overflow';
  RsEStackUnderflow = 'stack underflow';
  RsEReturnStackUnderflow = 'return stack underflow';
  RsENotImplemented = 'not implemented';
  RsEDelSubTreeNotImplemented = 'DeleteSubTreeInt has not been implemented yet';
  { Polaris patch }
  RsEDateOutOfRange = '%s - Enter a date between "%s" and "%s"';
  RsEDateOutOfMin = '%s - Enter a date after "%s"';
  RsEDateOutOfMax = '%s - Enter a date before "%s"';
  RsEID3NoController = 'No controller specified';
  RsEReturnStackOverflow = 'return stack overflow';
  RsESorryForOneDimensionalArraysOnly = 'Sorry, for one-dimensional arrays only';
  RsELocalDatabase = 'Cannot perform this operation on a local database';

//=== JvAni.pas ==============================================================
resourcestring
  RsAniExtension = 'ani';
  RsAniFilterName = 'ANI Image';

  RsEInvalidAnimatedIconImage = 'Invalid animated icon image';

//=== JvAniFile.pas ==========================================================
resourcestring
  RsAniCurFilter = 'Animated Cursors (*.ani)|*.ani|Any files (*.*)|*.*';
  RsEWriteStreamNotImplemented = 'TJvAnimatedCursorImage.WriteStream not implemented';

//=== JvAppInfo.pas ==========================================================
resourcestring
  RsEInvalidPropertyFmt = 'Invalid property: %s';
  RsENoPathSpecified = 'No path specified';

//=== JvAppIniStore.pas ======================================================
resourcestring
  RsEReadValueFailed = 'TJvAppINIFileStore.ReadValue: Section undefined';
  RsEWriteValueFailed = 'TJvAppINIFileStore.WriteValue: Section undefined';

//=== JvAppRegistryStore.pas =================================================
resourcestring
  RsEUnableToCreateKey = 'Unable to create key ''%s''';
  RsEEnumeratingRegistry = 'Error enumerating registry';

//=== JvAppStore.pas =========================================================
resourcestring
  RsEInvalidType = 'Invalid type';
  RsEUnknownBaseType = 'Unknown base type for given set';
  RsEInvalidPath = 'Invalid path';
  RsENotAUniqueRootPath = '''%s'' is not a unique root path';
  RsECircularReferenceOfStorages = 'Circular reference of storages';

//=== JvAppStoreSelectList.pas ===============================================
resourcestring
  RsLoadSettings = 'Load Settings';
  RsSaveSettings = 'Save Settings';
  RsDeleteSettings = 'Delete Settings';
  RsLoadCaption = '&Load';
  RsSaveCaption = '&Save';
  RsDeleteCaption = '&Delete';

  RsEDynControlEngineNotDefined = 'TJvAppStoreSelectList.CreateDialog: DynControlEngine not defined!';

//=== JvAppXmlStore.pas ======================================================
resourcestring
  RsENodeCannotBeEmpty = 'The node must be given a name';

//=== JvAVICapture.pas =======================================================
resourcestring
  RsNotConnected = 'Not connected';
  RsErrorMessagePrefix = 'Error #';

  RsEInvalidDriverIndex = '%d is an invalid driver index. The maximum value is %d';

//=== JvBalloonHint.pas ======================================================
resourcestring
  RsEParentRequired = 'Control ''%s'' has no parent window';
  RsEParentGivenNotAParent = 'Parent given is not a parent of ''%s''';

//=== JvBaseEdits.pas ========================================================
resourcestring
  RsEOutOfRangeXFloat = 'Value must be between %.*f and %.*f';

//=== JvBDECheckPasswordForm.pas =============================================
resourcestring
  RsChangePassword = 'Change password';
  RsOldPasswordLabel = '&Old password:';
  RsNewPasswordLabel = '&New password:';
  RsConfirmPasswordLabel = '&Confirm password:';
  RsPasswordChanged = 'Password has been changed';
  RsPasswordNotChanged = 'Password has not been changed';
  RsPasswordsMismatch = 'The new and confirmed passwords do not match';

//=== JvBDEFilter.pas ========================================================
resourcestring
  RsECaptureFilter = 'Cannot perform this operation when controls are captured';
  RsENotCaptureFilter = 'Cannot perform this operation when controls are not captured';

//=== JvBDEExceptionForm.pas =================================================
resourcestring
  RsDBExceptCaption = 'Database Engine Error';
  RsBDEErrorLabel = 'BDE Error';
  RsServerErrorLabel = 'Server Error';
  RsErrorMsgLabel = 'Error message';

//=== JvBDELoginDialog.pas ===================================================
resourcestring
  RsEInvalidUserName = 'Invalid user name or password';

//=== JvBDEMove.pas ==========================================================
resourcestring
  RsEInvalidReferenceDescriptor = 'Invalid reference descriptor';

//=== JvBdeUtils.pas =========================================================
resourcestring
  RsRetryLogin = 'Do you wish to retry the connect to database?';

  RsETableNotInExclusiveMode = 'Table must be opened in exclusive mode to add passwords';
  RsETableNotOpen = 'Table must be opened to pack';
  RsETableNotOpenExclusively = 'Table must be opened exclusively to pack';
  RsENoParadoxDBaseTable = 'Table must be either of Paradox or dBASE type to pack';

//=== JvBehaviorLabel.pas ====================================================
resourcestring
  RsENeedBehaviorLabel = 'Cannot call %s.Create with ALabel = nil';
  RsENoOwnerLabelParent = 'OwnerLabel.Parent is nil in %s.Start';

//=== JvBrowseFolder.pas =====================================================
resourcestring
  RsEShellNotCompatible = 'Shell not compatible with BrowseForFolder';

//=== JvButtons.pas ==========================================================
resourcestring
  RsEOwnerMustBeForm = '%s owner must be a TForm';

//=== JvCalc.pas =============================================================
resourcestring
  RsCalculatorCaption = 'Calculator';

//=== JvCalendar.pas =========================================================
resourcestring
  RsEInvalidDateStr = 'Invalid date specification to TMonthCalStrings (%s)';
  RsECannotAssign = 'Cannot assign %s to a %s';
  RsEInvalidArgumentToSetDayStates = 'Invalid argument to SetDayStates';
  RsEInvalidAppearance = 'TJvCustomMonthCalendar.CreateWithAppearance: cannot be created without valid Appearance';

//=== JvCaptionButton.pas ====================================================
resourcestring
  RsEOwnerMustBeTCustomForm = 'TJvCaptionButton owner must be a TCustomForm';

//=== JvCaret.pas ============================================================
resourcestring
  RsEInvalidCaretOwner = '%s: cannot be created without a valid Owner';

//=== JvChangeNotify.pas =====================================================
resourcestring
  RsFileNameChange = 'Filename Change';
  RsDirectoryNameChange = 'Directory Name Change';
  RsAttributesChange = 'Attributes Change';
  RsSizeChange = 'Size Change';
  RsWriteChange = 'Write Change';
  RsSecurityChange = 'Security Change';

  RsEFmtCannotChangeName = 'Cannot change %s when active';
  RsEFmtInvalidPath = 'Invalid or empty path (%s)';
  RsEFmtMaxCountExceeded = 'Maximum of %d items exceeded';
  RsEFmtInvalidPathAtIndex = 'Invalid or empty path ("%s") at index %d';
  RsENotifyErrorFmt = '%s:' + sLineBreak + '%s';

//=== JvChart.pas ============================================================
resourcestring
  RsNoData = 'No data.';
  RsGraphHeader = 'Graph Header';
  RsCurrentHeaders = 'Current Header: %s';
  RsXAxisHeaders = 'X Axis Header: %s';
  RsGraphScale = 'Graph Scale';
  RsYAxisScales = 'Y Axis Scale: %s';
  RsNoValuesHere = 'No values here!';

  RsEDataIndexCannotBeNegative = 'Data: index cannot be negative';
  RsEDataIndexTooLargeProbablyAnInternal = 'Data: index too large. Probably an internal error';
  RsEGetAverageValueIndexNegative = 'GetAverageValue: Index negative';
  RsESetAverageValueIndexNegative = 'SetAverageValue: Index negative';
  RsEChartOptionsPenCountPenCountOutOf = 'JvChart.Options.PenCount - PenCount out of range';
  RsEChartOptionsXStartOffsetValueOutO = 'JvChart.Options.XStartOffset  - value out of range';
  RsEUnableToGetCanvas = 'Unable to get canvas';

//=== JvCheckedMaskEdit.pas ==================================================
resourcestring
  RsEBeginUnsupportedNestedCall = 'TJvCustomCheckedMaskEdit.BeginInternalChange: Unsupported nested call!';
  RsEEndUnsupportedNestedCall = 'TJvCustomCheckedMaskEdit.EndInternalChange: Unsupported nested call!';

//=== JvClipboardViewer.pas ==================================================
  RsClipboardUnknown = 'Cannot display. Data in Clipboard is in an unknown format.';
  RsClipboardEmpty = 'Clipboard is empty';

//=== JvClipbrd.pas ==========================================================
resourcestring
  RsENoRenderFormatEventGiven = 'No OnRenderFormat was given';

//=== JvColorButton.pas ======================================================
resourcestring
  RsOtherCaption = '&Other...';

//=== JvColorCombo.pas =======================================================
resourcestring
  RsCustomCaption = 'Custom...';
  RsNewColorPrefix = 'Custom';

//=== JvColorProvider.pas ====================================================
resourcestring
  RsDelphiConstantNames = 'Delphi constant names';
  RsEnglishNames = 'English names';
  RsCustomColors = 'Custom colors';
  RsStandardColors = 'Standard colors';
  RsSystemColors = 'System colors';
  RsNoSettings = '(no settings)';

  RsESpecifiedMappingError = 'Specified mapping does not belong to the current provider';
  RsEAlreadyRegistered = '''%s'' is already registered';
  RsENoICR = 'Component does not support IInterfaceComponentReference';
  RsENoColProv = 'Component does not support IJvColorProvider';
  RsEMappingCollectionExpected = 'Mapping collection expected';
  RsEExpectedMappingName = 'Expected mapping name';
  RsEExpectedNameMappings = 'Expected name mappings';
  RsEInvalidNameMappingSpecification = 'Invalid name mapping specification';
  RsEUnknownColor = 'Unknown color ''%s''';
  RsEInvalidColor = 'Invalid color (%d)';
  RsEItemNotForList = 'Item does not belong to this list';

//=== JvContextProvider.pas ==================================================
resourcestring
  RsContextItemEmptyCaption = '(no context assigned to this item)';
  RsENoContextAssigned = 'No context has been assigned to this item';

  RsENoContextItem = 'Specified item is not a context item';
  RsENotSupportedIInterfaceComponentReference = 'Component does not support IInterfaceComponentReference';
  RsENotSupportedIJvDataProvider = 'Component does not support IJvDataProvider';

//=== JvCreateProcess.pas ====================================================
resourcestring
  RsIdle = 'Idle';
  RsNormal = 'Normal';
  RsHigh = 'High';
  RsRealTime = 'RealTime';

  RsEProcessIsRunning = 'Cannot perform this operation when process is running';
  RsEProcessNotRunning = 'Process is not running';

//=== JvCSVBaseControls.pas ==================================================
resourcestring
  RsReplaceExistingDatabase = 'Replace existing database?';
  RsNoFieldsDefined = 'no fields defined';
  RsCVSDatabase = 'CSV Database';
  RsFindText = 'Find Text:';
  RsFirstHint = 'First';
  RsPreviousHint = 'Previous';
  RsFindHint = 'Find';
  RsNextHint = 'Next';
  RsLastHint = 'Last';
  RsAddHint = 'Add';
  RsDeleteHint = 'Delete';
  RsPostHint = 'Post';
  RsRefreshHint = 'Refresh';

//=== JvCsvData.pas ==========================================================
resourcestring
  RsErrorRowItem = '<ERROR>';

  RsECsvErrFormat = '%s: %s';
  RsEProblemReadingRow = 'Problem reading row %d';
  RsENoRecord = 'No records';
  RsETimeTConvError = 'SetFieldData Error - TimeT-to-DateTime conversion error';
  RsEFieldTypeNotHandled = 'SetFieldData Error - Field type not handled';
  RsEUnableToLocateCSVFileInfo = 'Unable to locate CSV file information for field %s';
  RsEPhysicalLocationOfCSVField = 'Physical location of CSV field %s unknown';
  RsEInvalidFieldTypeCharacter = 'Invalid field type character: %s';
  RsEUnexpectedError = 'Unexpected error parsing CSV Field Definitions';
  RsEFieldDefinitionError = 'Field Definition Error. CsvFieldDef, FieldDefs, and file contents must match';
  RsEInvalidCsvKeyDef = 'Invalid CsvKeyDef property. InternalInitFieldDefs failed';
  RsEInternalErrorParsingCsvKeyDef = 'Internal Error parsing CsvKeyDef. InternalInitFieldDefs failed';
  RsEContainsField = 'CsvKeyDef contains field ''%s'' which is not defined. InternalInitFieldDefs failed';
  RsEInsertBlocked = 'InternalAddRecord cannot Add. Insert blocked';
  RsEPostingHasBeenBlocked = 'Posting to this database has been blocked';
  RsEKeyNotUnique = '%s - Key is not unique ';
  RsECannotInsertNewRow = 'Cannot insert new row. Insert blocked';
  RsECannotPost = 'Cannot post. Not in dsEdit or dsInsert mode';
  RsESortFailedCommaSeparated = 'Sort failed. You must give a comma separated list of field names';
  RsESortFailedFieldNames = 'Sort failed. Unable to parse field names. ';
  RsESortFailedInvalidFieldNameInList = 'Sort failed. Invalid field name in list: %s';
  RsEDataSetNotOpen = 'AppendRowString: DataSet is not open (active not set to true)';
  RsEErrorProcessingFirstLine = 'Error processing first line of CSV file';
  RsEFieldInFileButNotInDefinition = 'ProcessCsvHeaderRow: Field %s found in file, but not in field definitions';
  RsECsvFieldLocationError = 'CSV field location error: %s';
  RsEFieldNotFound = 'Field %s not found in the data file';
  RsECsvStringTooLong = 'CSV string is too long: %s...';
  RsEInternalLimit = 'JvCsvData - Internal Limit of MAXCOLUMNS (%d) reached. CSV Data has too many columns';
  RsETableNameNotSet = 'TJvCsvCustomInMemorYDataSet.FTableName is not set';
  RsEGetMode = 'GetMode???';
  RsENoTableName = 'noTableName';
  RsETableNameRequired = 'LoadFromFile=True, so a TableName is required';
  RsEInternalCompare = 'InternalCompare. Nil value detected';

//=== JvCsvParse.pas =========================================================
resourcestring
  RsEInvalidHexLiteral = 'HexStrToInt: Invalid hex literal';

//=== JvDataProvider.pas =====================================================
resourcestring
  RsEItemsMayNotBeMovedInTheMainTree = 'Items may not be moved in the main tree';
  RsEInvalidIndex = 'Invalid index';
  RsEItemCanNotBeDeleted = 'Item cannot be deleted';
  RsEContextNameExpected = 'Context name expected';
  RsEConsumerStackIsEmpty = 'Consumer stack is empty';
  RsEContextStackIsEmpty = 'Context stack is empty';
  RsEAContextWithThatNameAlreadyExists = 'A context with that name already exists';
  RsECannotCreateAContextWithoutAContext = 'Cannot create a context without a context list owner';
  RsEComponentDoesNotSupportTheIJvDataPr = 'Component does not support the IJvDataProvider interface';
  RsEComponentDoesNotSupportTheIInterfac = 'Component does not support the IInterfaceComponentReference interface';
  RsEYouMustSpecifyAProviderBeforeSettin = 'You must specify a provider before setting the context';
  RsEProviderHasNoContextNameds = 'Provider has no context named "%s"';
  RsEProviderDoesNotSupportContexts = 'Provider does not support contexts';
  RsETheSpecifiedContextIsNotPartOfTheSa = 'The specified context is not part of the same provider';
  RsEYouMustSpecifyAProviderBeforeSettin_ = 'You must specify a provider before setting the item';
  RsEItemNotFoundInTheSelectedContext = 'Item not found in the selected context';
  RsEViewListOutOfSync = 'ViewList out of sync';

  RsEProviderIsNoIJvDataConsumer = 'Provider property of ''%s'' does not point to a IJvDataConsumer';
  RsEComponentIsNotDataConsumer = 'Component ''%s'' is not a data consumer';
  RsECannotAddNil = 'Cannot add a nil pointer';
  RsEConsumerNoSupportIJvDataConsumerClientNotify =
    'Consumer does not support the ''IJvDataConsumerClientNotify'' interface';
  RsENotifierNoSupprtIJvDataConsumer = 'Notifier does not support the ''IJvDataConsumer'' interface';

  RsEExtensibleIntObjDuplicateClass = 'Implementation of that class already exists';
  RsEExtensibleIntObjCollectionExpected = 'Expected collection';
  RsEExtensibleIntObjClassNameExpected = 'Missing ClassName property';
  RsEExtensibleIntObjInvalidClass = 'Invalid class type';
  RsEDataProviderNeedsItemsImpl = 'Cannot create a data provider without an IJvDataItems implementation';

//=== JvDatePickerEdit.pas ===================================================
resourcestring
  RsDefaultNoDateShortcut = 'Alt+Del';

  RsEMustHaveADate = '%s must have a date!';

//=== JvDBControls.pas =======================================================
resourcestring
  RsInactiveData = 'Closed';
  RsBrowseData = 'Browse';
  RsEditData = 'Edit';
  RsInsertData = 'Insert';
  RsSetKeyData = 'Search';
  RsCalcFieldsData = 'Calculate';

//=== JvDBLookup.pas =========================================================
resourcestring
  RsEInvalidFormatNotAllowed = 'Invalid format: % not allowed';
  RsEInvalidFormatsNotAllowed = 'Invalid format: %s not allowed';

//=== JvDBQueryParamsForm.pas ================================================
resourcestring
  // (p3) copied from bdeconst so we don't have to include the entire BDE for three strings...
  RsDataTypes =
    ';String;SmallInt;Integer;Word;Boolean;Float;Currency;BCD;Date;Time;DateTime;;;;Blob;Memo;Graphic;;;;;Cursor;';
  RsParamEditor = '%s%s%s Parameters';

  RsEInvalidParamFieldType = 'Must have a valid field type selected';

//=== JvDBRemoteLogin.pas ====================================================
resourcestring
  RsKeyLoginSection = 'Remote Login';
  RsKeyLastLoginUserName = 'Last User';

//=== JvDBTreeView.pas =======================================================
resourcestring
  RsDeleteNode = 'Delete %s ?';
  RsDeleteNode2 = 'Delete %s (with all children) ?';
  RsMasterFieldError = '"MasterField" must be integer type';
  RsDetailFieldError = '"DetailField" must be integer type';
  RsItemFieldError = '"ItemField" must be string, date or integer type';
  RsIconFieldError = '"IconField" must be integer type';
  RsMasterFieldEmpty = '"MasterField" property must be filled';
  RsDetailFieldEmpty = '"DetailField" property must be filled';
  RsItemFieldEmpty = '"ItemField" property must be filled';

  RsEMoveToModeError = 'Invalid move mode for JvDBTreeNode';
  RsMasterDetailFieldError = '"MasterField" and "DetailField" must be of same type';
  RsEDataSetNotActive = 'DataSet not active';
  RsEErrorValueForDetailValue = 'error value for DetailValue';

//=== JvDBUtils.pas ==========================================================
resourcestring
  RsConfirmSave = 'The data has changed. Save it?';

//=== JvDdeCmd.pas ===========================================================
resourcestring
  RsEErrorCommandStart = 'Invalid command start format';
  RsEErrorCommandFormat = 'Invalid command format: %s';

//=== JvDrawImage.pas ========================================================
resourcestring
  RsImageMustBeSquare = 'image must be square for Spirographs';
  RsSumOfRadiTolarge = 'sum of radi too large';
  RsBothRadiMustBeGr = 'both radi must be >%d';

//=== JvDropDownForm.pas =====================================================
resourcestring
  RsETJvCustomDropDownFormCreateOwnerMus = 'TJvCustomDropDownForm.Create: Owner must be a TCustomEdit';

//=== JvDSADialogs.pas =======================================================
resourcestring
  RsInTheCurrentQueue = 'in the current queue';

  RsDSActkShowText = 'Do not show this dialog again';
  RsDSActkAskText = 'Do not ask me again';
  RsDSActkWarnText = 'Do not warn me again';

  RsCntdownText = 'This dialog is closing in %d %s.';
  RsCntdownSecText = 'second';
  RsCntdownSecsText = 'seconds';

  RsECannotEndCustomReadIfNotInCustomRea = 'Cannot end custom read if not in custom read mode';
  RsECannotEndCustomWriteIfNotInCustomWr = 'Cannot end custom write if not in custom write mode';
  RsECannotEndReadIfNotInReadMode = 'Cannot end read if not in read mode';
  RsECannotEndWriteIfNotInWriteMode = 'Cannot end write if not in write mode';
  RsEJvDSADialogPatchErrorJvDSADialogCom = 'JvDSADialog patch error: JvDSADialog component not found';

  RsEDSARegKeyCreateError = 'Unable to create key %s';
  RsEDSADuplicateID = 'DSA dialog with ID ''%d'' is already assigned to another dialog name';
  RsEDSADuplicateName = 'DSA dialog named ''%s'' is already assigned to another dialog ID';
  RsEDSADialogIDNotFound = 'DSA dialog %d does not exist';
  RsEDSADuplicateCTK_ID = 'CheckMarkText ID %d already registered';
  RsEDSADialogIDNotStored = 'DSA dialog %d has not been stored';
  RsEDSAKeyNotFound = 'Key %s does not exist';
  RsEDSAKeyNoAccessAs = 'Key %s cannot be accessed as %s';

  RsECtrlHasNoCheckedProp = 'The specified control has no "Checked" property';
  RsECtrlHasNoCaptionProp = 'The specified control has no "Caption" property';
  RsEDialogIDChangeOnlyInDesign = 'The dialog ID can only be changed at design time';
  RsEOnlyAllowedOnForms = 'TJvDSADialog is only allowed on forms';
  RsEAlreadyDSADialog = 'The form already has a TJvDSADialog component';

  RsEDSAAccessBool = 'Boolean';
  RsEDSAAccessFloat = 'Float';
  RsEDSAAccessInt64 = 'Int64';
  RsEDSAAccessInt = 'Integer';
  RsEDSAAccessString = 'string';

//=== JvDualList.pas =========================================================
resourcestring
  RsDualListSrcCaption = '&Source';
  RsDualListDestCaption = '&Destination';

//=== JvDynControlEngine.pas =================================================
resourcestring
  RsEIntfCastError = 'SIntfCastError';
  RsEUnsupportedControlClass = 'TJvDynControlEngine.RegisterControl: Unsupported ControlClass';
  RsENoRegisteredControlClass = 'TJvDynControlEngine.CreateControl: No Registered ControlClass';

//=== JvEditor.pas, JvUnicodeEditor.pas ======================================
resourcestring
  RsERedoNotYetImplemented = 'Redo not yet implemented';
  RsEInvalidCompletionMode = 'Invalid JvEditor Completion Mode';

//=== JvErrorIndicator.pas ===================================================
resourcestring
  RsEControlNotFoundInGetError = 'Control not found in GetError';
  RsEControlNotFoundInGetImageAlignment = 'Control not found in GetImageAlignment';
  RsEControlNotFoundInGetImagePadding = 'Control not found in GetImagePadding';
  RsEUnableToAddControlInSetError = 'Unable to add control in SetError';
  RsEUnableToAddControlInSetImageAlignme = 'Unable to add control in SetImageAlignment';
  RsEUnableToAddControlInSetImagePadding = 'Unable to add control in SetImagePadding';

//=== JvExceptionForm.pas ====================================================
resourcestring
  RsCodeError = '%s.' + sLineBreak + 'Error Code: %.8x (%1:d).';
  RsModuleError = 'Exception in module %s.' + sLineBreak + '%s';

//=== JvFindReplace.pas ======================================================
resourcestring
  RsNotFound = 'Search string ''%s'' not found';
  RsReplaceCaption = 'Replace';
  RsFindCaption = 'Find';

  RsENoEditAssigned = 'No edit control assigned!';

//=== JvFooter.pas ===========================================================
resourcestring
  RsETJvFooterBtnCanOnlyBePlacedOnATJvFo = 'TJvFooterBtn can only be placed on a TJvFooter';

//=== JvForth.pas ============================================================
resourcestring
  RsEInvalidNumbers = 'invalid number %s';
  RsEUnrecognizedDataTypeInSetOperation = 'unrecognized data type in set operation';
  RsEUnterminatedBlockNear = 'unterminated block near ';
  RsEParserTimedOutAfterdSecondsYouMayHa = 'parser timed out after %d seconds; you may have circular includes';
  RsEUnterminatedIncludeNears = 'unterminated include near %s';
  RsEIllegalSpaceCharacterInTheIncludeFi = 'illegal space character in the include file: %s';
  RsECanNotFindIncludeFiles = 'Can not find include file: %s';
  RsEOnIncludeHandlerNotAssignedCanNotHa = 'OnInclude handler not assigned, can not handle include file: %s';
  RsEMissingCommentTerminatorNears = 'missing "}" comment terminator near %s';
  RsEMissingXmlMethodSpecifierNears = 'missing XML method specifier near %s';
  RsEMissingDataSourceMethodSpecifierNea = 'missing data source method specifier near %s';
  RsEMissingSystemMethodSpecifierNears = 'missing system method specifier near %s';
  RsEMissingExternalVariableMethodSpecif = 'missing external variable method specifier near %s';
  RsEMissingInternalVariableMethodSpecif = 'missing internal variable method specifier near %s';
  RsEUndefinedWordsNears = 'undefined word "%s" near %s';
  RsEScriptTimedOutAfterdSeconds = 'Script timed out after %d seconds';
  RsECanNotAssignVariables = 'can not assign variable %s';
  RsEVariablesNotDefined = 'Variable %s not defined';
  RsEProceduresNotDefined = 'procedure %s not defined';
  RsEVariablesNotDefined_ = 'variable %s not defined';
  RsESystemsNotDefined = 'System %s not defined';
  RsECanNotAssignSystems = 'can not assign System %s';
  RsEUnrecognizeExternalVariableMethodss = 'unrecognize external variable method %s.%s';
  RsEUnrecognizeInternalVariableMethodss = 'unrecognize internal variable method %s.%s';
  RsEUnrecognizeSystemMethodss = 'unrecognize system method %s.%s';
  RsEFilesDoesNotExist = 'File %s does not exist';
  RsECanNotSaveToFiles = 'Can not save to file %s';
  RsEXMLSelectionIsEmpty = 'XML selection is empty';
  RsENoXMLSelectionSelected = 'no XML selection selected';
  RsEXMLSelectionOutOfRange = 'XML selection out of range';
  RsEInvalidXmlMethodSpecifiers = 'invalid XML method specifier %s';
  RsEIncrementIndexExpectedIns = 'Increment Index: "[" expected in %s';
  RsEIncrementIndexExpectedIns_ = 'Increment Index: "]" expected in %s';
  RsEIncrementIndexExpectedIntegerBetwee = 'Increment Index: expected integer between "[..]" in %s';
  RsEDSOIndexOutOfRanged = 'DSO index out of range %d';
  RsEDSOUnknownKeys = 'DSO unknown key %s';

//=== Jvg3DColors.pas ========================================================
{$IFDEF USEJVCL}
resourcestring
  RsEOnlyOneInstanceOfTJvg3DLocalColors = 'Cannot create more than one instance of TJvg3DLocalColors component';
{$ENDIF USEJVCL}

//=== JvGammaPanel.pas =======================================================
resourcestring
  RsRedFormat = 'R : %3D';
  RsGreenFormat = 'G : %3D';
  RsBlueFormat = 'B : %3D';

  RsHint1 = 'Background Color';
  RsHint2 = 'Foreground Color';
  RsLabelCaption = 'X';
  RsLabelHint = 'Exchange colors';

  RsDefaultB = 'B : ---';
  RsDefaultG = 'G : ---';
  RsDefaultR = 'R : ---';

//=== JvgAskListBox.pas ======================================================
{$IFDEF USEJVCL}
resourcestring
  RsYes = 'yes';
  RsNo = 'no';
{$ENDIF USEJVCL}

//=== JvgButton.pas ==========================================================
{$IFDEF USEJVCL}
resourcestring
  RsEErrorDuringAccessGlyphsListOrGlyphP = 'Error during access GlyphsList or Glyph property';
{$ENDIF USEJVCL}

//=== JvgCaption.pas =========================================================
{$IFDEF USEJVCL}
resourcestring
  RsEOnlyOneInstanceOfTJvgCaption = 'Cannot create more than one instance of TJvgCaption component';
{$ENDIF USEJVCL}

//=== JvgCheckVersionInfoForm.pas ============================================
{$IFDEF USEJVCL}
resourcestring
  RsNoNewerVersionOfProgramAvailable = 'No newer version of program available';
{$ENDIF USEJVCL}

//=== JvgConstSysRequirements.pas ============================================
{$IFDEF USEJVCL}
resourcestring
  { RUSSIAN
  RsVideoVRefreshRate = '������� ���������� ������ ������ ���� %d ���� ��� ����. �������� ������� ���������� � ��������� ������.';
  RsGraphicResolution = '���������� ������ ������ ���� %s ����� ��� ����. �������� ���������� � ��������� ������.';
  RsColorDepth = '���������� ������ ������ ������ ���� %s ������ ��� ����. �������� ����� ������ � ��������� ������.';
  RsSystemFont = '� ������� ������ ���� ���������� %s �����. �������� ��� ������ � ��������� ������.';
  RsOSPlatform = '��� ������ ��������� ���������� ������������ ������� %s.';
  }
  RsVideoVRefreshRate =
    'The monitor refresh rate should be %d Hertz or higher. Change monitor refresh rate in Monitor Control Panel.';
  RsGraphicResolution =
    'The screen resolution should be equal %s pixels or higher. Change screen resolution in Monitor Control Panel.';
  RsColorDepth =
    'The number of colors of the screen should be equal to %s colors or higher. Change screen colors in Monitor Control Panel.';
  RsSystemFont = 'In system small fonts should be established. Change to small fonts in Monitor Control Panel.';
  RsOSPlatform = 'The program requires %s or better.';
{$ENDIF USEJVCL}

//=== JvGenetic.pas ==========================================================
resourcestring
  RsENoTest = 'TJvGenetic: OnTestMember must be assigned';

//=== JvgExportComponents.pas ================================================
{$IFDEF USEJVCL}
resourcestring
  RsEDataSetIsUnassigned = 'DataSet is unassigned';
  RsESaveToFileNamePropertyIsEmpty = 'SaveToFileName property is empty';
{$ENDIF USEJVCL}

//=== JvgHelpPanel.pas =======================================================
{$IFDEF USEJVCL}
resourcestring
  RsHelp = ' help ';
  RsOpenContextMenuToLoadRTFTextControl = 'Open context menu to load RTF text. Control shows text at runtime only.';
{$ENDIF USEJVCL}

//=== JvgHint.pas ============================================================
{$IFDEF USEJVCL}
resourcestring
  RsEOnlyOneInstanceOfTJvgHint = 'Cannot create more than one instance of TJvgHint component';
{$ENDIF USEJVCL}

//=== JvgHTTPVersionInfo.pas =================================================
{$IFDEF USEJVCL}
resourcestring
  RsEUnknownURLPropertyVersionDataURLIs = 'Unknown URL: property VersionDataURL is empty';
{$ENDIF USEJVCL}

//=== JvGIF.pas ==============================================================
resourcestring
  RsGIFImage = 'CompuServe GIF Image';

  RsEChangeGIFSize = 'Cannot change the Size of a GIF image';
  RsENoGIFData = 'No GIF Data to write';
  RsEUnrecognizedGIFExt = 'Unrecognized extension block: %.2x';
  RsEWrongGIFColors = 'Wrong number of colors; must be a power of 2';
  RsEBadGIFCodeSize = 'GIF code size not in range 2 to 9';
  RsEGIFDecodeError = 'GIF encoded data is corrupt';
  RsEGIFEncodeError = 'GIF image encoding error';
  RsEGIFVersion = 'Unknown GIF version';

//=== JvgLogics.pas ==========================================================
{$IFDEF USEJVCL}
resourcestring
  RsEqualTo = 'equal to';
  RsStartingWith = 'starting with';
  RsEndsWith = 'ends with';
  RsContains = 'contains';
  RsIsContainedWithin = 'is contained within';
  RsNotEmpty = 'not empty';
  RsStep = 'Step ';
  RsComments = 'Comments';
{$ENDIF USEJVCL}

//=== JvgMailSlots.pas =======================================================
{$IFDEF USEJVCL}
resourcestring
  RsETJvgMailSlotServerErrorCreatingChan = 'TJvgMailSlotServer: Error creating channel!';
  RsETJvgMailSlotServerErrorGatheringInf = 'TJvgMailSlotServer: Error gathering information!';
  RsETJvgMailSlotServerErrorReadingMessa = 'TJvgMailSlotServer: Error reading message!';
{$ENDIF USEJVCL}

//=== JvgProgress.pas ========================================================
{$IFDEF USEJVCL}
resourcestring
  RsProgressCaption = 'Progress...[%d%%]';
{$ENDIF USEJVCL}

//=== JvgQPrintPreviewForm.pas ===============================================
{$IFDEF USEJVCL}
resourcestring
  RsPageOfPages = 'Page %d of %d';
{$ENDIF USEJVCL}

//=== JvGradientHeaderPanel.pas ==============================================
resourcestring
  RsYourTextHereCaption = 'Put your text here ...';

//=== JvgReport.pas ==========================================================
{$IFDEF USEJVCL}
resourcestring
  RsOLELinkedObjectNotFound = 'OLE: Linked object not found.';
  RsErrorText = 'Error';
  RsErrorReadingComponent = 'Error reading component';
{$ENDIF USEJVCL}

//=== JvGridPreviewForm.pas ==================================================
resourcestring
  RsOfd = 'of %d';
  RsPaged = 'Page %d';
  RsNoPrinterIsInstalled = 'No Printer is installed';

//=== JvGridPrinter.pas ======================================================
resourcestring
  RsPrintOptionsPageFooter = 'date|time|page';
  RsPrintOptionsDateFormat = 'd-mmm-yyyy';
  RsPrintOptionsTimeFormat = 'h:nn am/pm';

//=== JvgSingleInstance.pas ==================================================
{$IFDEF USEJVCL}
resourcestring
  RsOneInstanceOfThisProgramIsAlreadyRu =
    'One instance of this program is already running. A second instance launch is not allowed.';
  RsSecondInstanceLaunchOfs = 'Second instance launch of %s';
{$ENDIF USEJVCL}

//=== JvgSmallFontsDefense.pas ===============================================
{$IFDEF USEJVCL}
resourcestring
  RsTJvgSmallFontsDefenseCannotBeUsedWi = 'TJvgSmallFontsDefense cannot be used with large fonts.';
{$ENDIF USEJVCL}

//=== JvgUtils.pas ===========================================================
{$IFDEF USEJVCL}
resourcestring
  RsERightBracketsNotFound = 'Right brackets not found';
  RsERightBracketHavntALeftOnePosd = 'Right bracket does not have a left one. Pos: %d';
  RsEDivideBy = 'Divide by 0';
  RsEDuplicateSignsAtPos = 'Duplicate signs at Pos: %d';
  RsEExpressionStringIsEmpty = 'Expression string is empty';
  RsEObjectMemoryLeak = 'object memory leak';
{$ENDIF USEJVCL}

//=== JvgXMLSerializer.pas ===================================================
{$IFDEF USEJVCL}
resourcestring
  { RUSSIAN
  RsOpenXMLTagNotFound = '����������� ��� �� ������: <%s>';
  RsCloseXMLTagNotFound = '����������� ��� �� ������: </%s>';
  RsUncknownProperty = 'Uncknown property: %s'
  }
  RsOpenXMLTagNotFound = 'Open tag not found: <%s>';
  RsCloseXMLTagNotFound = 'Close tag not found: </%s>';
  RsUnknownProperty = 'Unknown property: %s';
{$ENDIF USEJVCL}

//=== JvHint.pas =============================================================
resourcestring
  RsHintCaption = 'Hint';

//=== JvHidControllerClass.pas ===============================================
{$IFDEF USEJVCL}
resourcestring
  RsUnknownLocaleIDFmt = 'unknown Locale ID $%.4x';
  RsHIDP_STATUS_NULL = 'device not plugged in';
  RsHIDP_STATUS_INVALID_PREPARSED_DATA = 'invalid preparsed data';
  RsHIDP_STATUS_INVALID_REPORT_TYPE = 'invalid report type';
  RsHIDP_STATUS_INVALID_REPORT_LENGTH = 'invalid report length';
  RsHIDP_STATUS_USAGE_NOT_FOUND = 'usage not found';
  RsHIDP_STATUS_VALUE_OUT_OF_RANGE = 'value out of range';
  RsHIDP_STATUS_BAD_LOG_PHY_VALUES = 'bad logical or physical values';
  RsHIDP_STATUS_BUFFER_TOO_SMALL = 'buffer too small';
  RsHIDP_STATUS_INTERNAL_ERROR = 'internal error';
  RsHIDP_STATUS_I8042_TRANS_UNKNOWN = '8042 key translation impossible';
  RsHIDP_STATUS_INCOMPATIBLE_REPORT_ID = 'incompatible report ID';
  RsHIDP_STATUS_NOT_VALUE_ARRAY = 'not a value array';
  RsHIDP_STATUS_IS_VALUE_ARRAY = 'is a value array';
  RsHIDP_STATUS_DATA_INDEX_NOT_FOUND = 'data index not found';
  RsHIDP_STATUS_DATA_INDEX_OUT_OF_RANGE = 'data index out of range';
  RsHIDP_STATUS_BUTTON_NOT_PRESSED = 'button not pressed';
  RsHIDP_STATUS_REPORT_DOES_NOT_EXIST = 'report does not exist';
  RsHIDP_STATUS_NOT_IMPLEMENTED = 'not implemented';
  RsUnknownHIDFmt = 'unknown HID error %x';
  RsHIDErrorPrefix = 'HID Error: ';

  RsEDirectThreadCreationNotAllowed = 'Direct creation of a TJvDeviceReadThread object is not allowed';
  RsEDirectHidDeviceCreationNotAllowed = 'Direct creation of a TJvHidDevice object is not allowed';
  RsEDeviceCannotBeIdentified = 'device cannot be identified';
  RsEDeviceCannotBeOpened = 'device cannot be opened';
  RsEOnlyOneControllerPerProgram = 'Only one TJvHidDeviceController allowed per program';
  RsEHIDBooleanError = 'HID Error: a boolean function failed';
{$ENDIF USEJVCL}

//=== JvHLEditorPropertyForm.pas =============================================
resourcestring
  RsHLEdPropDlg_Caption = 'Editor Properties';
  RsHLEdPropDlg_tsEditor = 'Editor';
  RsHLEdPropDlg_tsColors = 'Colors';
  RsHLEdPropDlg_lblEditorSpeedSettings = 'Editor SpeedSettings';
  RsHLEdPropDlg_cbKeyboardLayoutDefault = 'Default keymapping';
  RsHLEdPropDlg_gbEditor = 'Editor options:';
  RsHLEdPropDlg_cbAutoIndent = '&Auto indent mode';
  RsHLEdPropDlg_cbSmartTab = 'S&mart tab';
  RsHLEdPropDlg_cbBackspaceUnindents = 'Backspace &unindents';
  RsHLEdPropDlg_cbGroupUndo = '&Group undo';
  RsHLEdPropDlg_cbCursorBeyondEOF = 'Cursor beyond &EOF';
  RsHLEdPropDlg_cbUndoAfterSave = '&Undo after sa&ve';
  RsHLEdPropDlg_cbKeepTrailingBlanks = '&Keep trailing blanks';
  RsHLEdPropDlg_cbDoubleClickLine = '&Double click line';
  RsHLEdPropDlg_cbSytaxHighlighting = 'Use &syntax highlight';
  RsHLEdPropDlg_lblTabStops = '&Tab stops:';
  RsHLEdPropDlg_lblColorSpeedSettingsFor = 'Color SpeedSettings for';
  RsHLEdPropDlg_lblElement = '&Element:';
  RsHLEdPropDlg_lblColor = '&Color:';
  RsHLEdPropDlg_gbTextAttributes = 'Text attributes:';
  RsHLEdPropDlg_gbUseDefaultsFor = 'Use defaults for:';
  RsHLEdPropDlg_cbBold = '&Bold';
  RsHLEdPropDlg_cbItalic = '&Italic';
  RsHLEdPropDlg_cbUnderline = '&Underline';
  RsHLEdPropDlg_cbDefForeground = '&Foreground';
  RsHLEdPropDlg_cbDefBackground = '&Background';
  RsHLEdPropDlg_OptionCantBeChanged = 'This option cannot be changed. Sorry.';

  RsEHLEdPropDlg_RAHLEditorNotAssigned = 'JvHLEditor property is not assigned';
  RsEHLEdPropDlg_RegAutoNotAssigned = 'RegAuto property is not assigned';
  RsEHLEdPropDlg_GridCellNotFound = 'Grid cell not found';

//=== JvId3v1.pas ============================================================
resourcestring
  RsENotActive = 'Not active';

//=== JvID3v2Base.pas ========================================================
resourcestring
  RsENameMsgFormat = '%s: %s';
  RsEAllowedEncodingsIsEmpty = 'FAllowedEncodings is empty';
  RsEAlreadyReadingWriting = 'Already reading or writing';
  RsEAlreadyReadingWritingFrame = 'Already reading/writing frame';
  RsEAlreadyUsingTempStream = 'Already using temp stream';
  RsECannotCallCanRead = 'Cannot call CanRead while writing';
  RsEControllerDoesNotSupportCompression = 'Controller does not support compression';
  RsEControllerDoesNotSupportCRC = 'Controller does not support CRC';
  RsEControllerDoesNotSupportEncryption = 'Controller does not support encryption';
  RsEControllerDoesNotSupportFooter = 'Controller does not support footer';
  RsECouldNotFindAllowableEncoding = 'Could not find allowable encoding';
  RsECouldNotReadData = 'Could not read data from stream';
  RsEErrorInFrame = 'Error in frame %s (%s), %s';
  RsEFrameSizeDiffers = 'Frame size differs from actually amount of data written';
  RsEFrameSizeTooBig = 'Frame size is too big';
  RsELanguageNotOfLength3 = 'Language is not of length 3';
  RsENoTempStream = 'No temp stream';
  RsENotReadingFrame = 'Not reading frame';
  RsENotUsingTempStream = 'Not using temp stream';
  RsENotWriting = 'Not writing';
  RsENotWritingFrame = 'Not writing frame';
  RsETagTooBig = 'Tag is too big';
  RsEValueTooBig = 'Cannot write value in v2.2; too big';
  RsENotReading = 'Not reading';

  RsEID3FrameNotFound = 'Frame not found';
  RsEID3UnknownEncoding = 'Unknown encoding';
  RsEID3UnknownVersion = 'Unknown version';
  RsEID3DuplicateFrame = 'Frame is a duplicate of another frame in the tag';
  RsEID3AlreadyContainsFrame = 'Tag already contains a ''%s'' frame';
  RsEID3ControllerNotActive = 'Controller is not active';
  RsEID3EncodingNotSupported = 'Encoding not supported in this version';
  RsEID3VersionNotSupported = 'Version not supported';
  RsEID3InvalidLanguageValue = '''%s'' is an invalid language value';
  RsEID3InvalidPartInSetValue = '''%s'' is an invalid ''part in set'' value';
  RsEID3InvalidTimeValue = '''%s'' is an invalid time value.'#13'Value must be of format ''HHMM''';
  RsEID3InvalidDateValue = '''%s'' is an invalid date value.'#13'Value must be of format ''DDMM''';
  RsEID3ValueTooBig = '''%d'' is an invalid value. Value is too big';
  RsEID3StringTooLong = '''%s'' is an invalid value. String is too long';
  RsEID3InvalidCharinList = 'Invalid char ''%s'' in string ''%s'' in list';
  RsEID3InvalidFrameClass = 'Frame class ''%s'' cannot be used to represent frame ID ''%s''';
  RsEID3FrameIDNotSupported = 'Frame ID ''%s'' not supported by this frame';
  RsEID3FrameIDStrNotSupported = 'Frame ID string ''%s'' not supported by this frame';

//=== JvId3v2Types.pas =======================================================
resourcestring
  RsEFrameIDSizeCanOnlyBe34 = 'Frame ID size can only be 3 or 4';

//=== JvImageDlg.pas =========================================================
resourcestring
  RsImageTitle = 'Image Viewer';

//=== JvImageWindow.pas ======================================================
resourcestring
  RsEImagesNotAssigned = 'Images not Assigned!';

//=== JvInspector.pas ========================================================
resourcestring
  RsJvInspItemValueException = 'Exception ';
  RsJvInspItemUnInitialized = '(uninitialized)';
  RsJvInspItemUnassigned = '(unassigned)';
  RsJvInspItemNoValue = '(no value)';

  RsStringListEditorCaption = 'String list editor';
  RsXLinesCaption = ' lines';
  RsOneLineCaption = '1 line';

  RsEJvInspItemHasParent = 'Item already assigned to another parent';
  RsEJvInspItemNotAChild = 'Specified Item is not a child of this item';
  RsEJvInspItemColNotFound = 'Specified column does not belong to this compound item';
  RsEJvInspItemItemIsNotCol = 'Specified item is not a column of this compound item';
  RsEJvInspItemInvalidPropValue = 'Invalid property value %s';
  RsEJvInspDataNoAccessAs = 'Data cannot be accessed as %s';
  RsEJvInspDataNotInit = 'Data not initialized';
  RsEJvInspDataNotAssigned = 'Data not assigned';
  RsEJvInspDataNoValue = 'Data has no value';
  RsEJvInspDataStrTooLong = 'String too long';
  RsEJvInspRegNoCompare = 'Cannot compare %s to %s';
  RsEJvInspNoGenReg = 'Unable to create generic item registration list';
  RsEJvInspPaintNotActive = 'Painter is not the active painter of the specified inspector';
  RsEJvInspPaintOnlyUsedOnce = 'Inspector painter can only be linked to one inspector';

  RsEInspectorInternalError = 'Internal error: two data instances pointing to the same data are registered';
  RsESpecifierBeforeSeparator = 'A specifier should be placed before and after a separator';
  RsEDOrDDOnlyOnce = '''d'' or ''dd'' should appear only once';
  RsEMOrMMOnlyOnce = '''m'' or ''mm'' should appear only once';
  RsEYYOrYYYYOnlyOnce = '''yy'' or ''yyyy'' should appear only once';
  RsEOnlyDOrDDAllowed = 'Only ''d'' or ''dd'' are allowed';
  RsEOnlyMOrMMAllowed = 'Only ''m'' or ''mm'' are allowed';
  RsEOnlyYYOrYYYYAllowed = 'Only ''yy'' or ''yyyy'' are allowed';
  RsEOnlyTwoSeparators = 'Only two separators are allowed';
  RsEOnlyDMYSAllowed = 'Only ''d'', ''m'', ''y'' and ''%s'' are allowed';
  RsEDOrDDRequired = '''d'' or ''dd'' are required';
  RsEMOrMMRequired = '''m'' or ''mm'' are required';
  RsEYYOrYYYYRequired = '''yy'' or ''yyyy'' are required';
  RsEInstanceAlreadyExists = 'Instance already exists with another name';
  RsENameAlreadyExistsForInstance = 'Name already exists for another instance';
  RsEInstanceNonexistent = 'Instance does not exist';
  RsEMethodAlreadyExists = 'Method already exists with another name';
  RsENameAlreadyExistsForMethod = 'Name already exists for another method';
  RsENamedInstanceNonexistent = 'Instance named ''%s'' does not exist';
  RsEMethodNonexistent = 'Method does not exist';
  RsENamedMethodNonexistent = 'Method named ''%s'' does not exist';
  RsENotSeparately = '%s cannot be created separately';
  RsENoNewInstance = '%s does not allow a new instance to be created';

  // (rom) converted assertions
  RsEJvAssertSetTopIndex = 'TJvCustomInspector.SetTopIndex: unexpected MaxIdx <= -1';
  RsEJvAssertInspectorPainter = 'TJvInspectorCustomCompoundItem.DivideRect: unexpected Inspector.Painter = nil';
  RsEJvAssertDataParent = 'TJvInspectorSetMemberData.New: unexpected ADataParent = nil';
  RsEJvAssertParent = 'TJvInspectorSetMemberData.New: unexpected AParent = nil';
  RsEJvAssertPropInfo = 'TJvInspectorPropData.New: unexpected PropInfo = nil';
  RsEJvAssertINIFile = 'TJvInspectorINIFileData.New: unexpected AINIFile = nil';

//=== JvInspXVCL.pas =========================================================
resourcestring
  RsENoNodeSpecified = 'TJvInspectorxNodeData.New: No node specified';

//=== JvInstallLabel.pas =====================================================
resourcestring
  RsEListOutOfBounds = 'List index out of bounds (%d)';

//=== JvInterpreter.pas ======================================================
resourcestring
  RsNotImplemented = 'Function not yet implemented';

  RsESorryDynamicArraysSupportIsMadeForO = 'Sorry. Dynamic arrays support is made for one-dimensional arrays only';
  RsEUnknownRecordType = 'Unknown RecordType';
  RsERangeCheckError = 'range check error';

//=== JvInterpreter_Quickrpt.pas =============================================
resourcestring
  RsENoQuickReportFound = 'TQuickRep component not found on the form';

//=== JvInterpreter_System.pas ===============================================
resourcestring
  RsESizeMustBeEven = 'The size of bounds array must be even!';

//=== JvInterpreterConst.pas =================================================

//=== JvInterpreterFm.pas ====================================================
resourcestring
  RsENoReportProc = 'Procedure "JvInterpreterRunReportPreview" not found';
  RsENoReportProc2 = 'Procedure "JvInterpreterRunReportPreview2" not found';

//=== JvJanTreeView.pas ======================================================
resourcestring
  RsSaveCurrentTree = 'Save Current Tree';
  RsSearch = 'Search';
  RsSearchFor = 'Search for:';
  RsNoMoresFound = 'No more %s found';

  RsEInvalidReduction = 'Invalid reduction';
  RsEBadTokenState = 'Bad token state';
  RsTreeViewFiles = 'TreeView Files';

//=== JvJoystick.pas =========================================================
resourcestring
  RsNoJoystickDriver = 'The joystick driver is not present.';
  RsCannotCaptureJoystick = 'Cannot capture the joystick';
  RsJoystickUnplugged = 'The specified joystick is not connected to the system.';
  RsJoystickErrorParam = 'The specified joystick device identifier is invalid.';

  RsEJoystickError = 'Unable to initialize joystick driver';

//=== JvJVCLUtils.pas ========================================================
resourcestring
  RsNotForMdi = 'MDI forms are not allowed';

  RsEPixelFormatNotImplemented = 'BitmapToMemoryStream: pixel format not implemented';
  RsEBitCountNotImplemented = 'BitmapToMemoryStream: bit count not implemented';
  RsECantGetShortCut = 'Target FileName for ShortCut %s not available';

//=== JvLinkLabel.pas ========================================================
resourcestring
  RsEUnableToLocateMode = 'Unable to locate specified node';
  RsETagNotFound = 'TJvCustomLinkLabel.UpdateDynamicTag: Tag not found';

//=== JvLinkLabelParser.pas ==================================================
resourcestring
  RsENoMoreElementsToReturn = 'TElementEnumerator.GetNextElement: No more elements to return';
  RsEUnsupportedState = 'TDefaultParser.ParseNode: Unsupported state';

//=== JvLinkLabelTextHandler.pas =============================================
resourcestring
  RsENoMoreWords = 'TWordEnumerator.GetNext: No more words to return';
  RsEUnsupported = 'TTextHandler.EmptyBuffer: Unsupported TParentTextElement descendant encountered';

//=== JvLinkLabelTools.pas ===================================================
resourcestring
  RsECannotBeInstantiated = 'This class cannot be instantiated';

//=== JvLinkLabelTree.pas ====================================================
resourcestring
  RsETNodeGetNodeTypeUnknownClass = 'TNode.GetNodeType: Unknown class';
  RsENoMoreNodesToReturn = 'No more nodes to return';
  RsENoMoreRecordsToReturn = 'No more records to return';
  RsEWordInfoIndexOutOfBounds = 'TStringNode.GetWordInfo: Index out of bounds';

//=== JvListView.pas =========================================================
resourcestring
  RsETooManyColumns = 'TJvListView.GetColumnsOrder: too many columns';

//=== JvLoginForm.pas ========================================================
resourcestring
  RsRegistrationCaption = 'Registration';
  RsAppTitleLabel = 'Application "%s"';
  RsHintLabel = 'Type your user name and password';
  RsUserNameLabel = '&User name:';
  RsPasswordLabel = '&Password:';
  RsUnlockCaption = 'Unlock application';
  RsUnlockHint = 'Type your password';

//=== JvMail.pas =============================================================
resourcestring
  RsAttachmentNotFound = 'Attached file "%s" not found';
  RsRecipNotValid = 'Recipient %s has invalid address';
  RsNoClientInstalled = 'There is no MAPI-enabled client on the machine';
  RsNoUserLogged = 'There must be a user logged before call this function';

//=== JvMemoryDataset.pas ====================================================
resourcestring
  RsEMemNoRecords = 'No data found';

//=== JvMouseGesture.pas =====================================================
resourcestring
  RsECannotHookTwice = 'JvMouseGesture Fatal: You cannot hook this event twice';

//=== JvMRUList.pas ==========================================================
resourcestring
  RsEErrorMRUCreating = 'Unable to create MRU';
  RsEErrorMRUUnicode = 'Windows NT required for Unicode in MRU';

//=== JvMRUManager.pas =======================================================
resourcestring
  RsEDuplicatesNotAllowedInMRUList = 'Duplicates not allowed in MRU list';

//=== JvMTComponents.pas =====================================================
resourcestring
  RsENoThreadManager = 'No ThreadManager specified';
  RsEOperatorNotAvailable = 'Operation not available while thread is active';
  RsECannotChangePropertySection = 'Cannot change property of active section';
  RsECannotChangePropertyBuffer = 'Cannot change property of active buffer';

//=== JvMTData.pas ===========================================================
resourcestring
  RsEMethodOnlyForMainThread = '%s method can only be used by the main VCL thread';

//=== JvMTSync.pas ===========================================================
resourcestring
  RsESemaphoreFailure = 'Semaphore failure (%d)';
  RsESemaphoreAbandoned = 'Semaphore was abandoned';
  RsEThreadAbandoned = 'Thread was abandoned';

//=== JvMTThreading.pas ======================================================
resourcestring
  RsECurThreadIsPartOfManager = 'Current MTThread is part of the MTManager';
  RsECheckTerminateCalledByWrongThread = 'CheckTerminate can only be called by the same thread';
  RsEThreadNotInitializedOrWaiting = 'Cannot run: thread is not Initializing or Waiting';
  RsECannotChangeNameOfOtherActiveThread = 'Cannot change name of other active thread';
  RsEReleaseOfUnusedTicket = 'Release of unused ticket';

//=== JvMultiHttpGrabber.pas =================================================
resourcestring
  RsErrorConnection = 'Unable to connect';
  RsAgent = 'TJvMultiHTTPGrabber Delphi Component';

//=== JvObjectPickerDialog.pas ===============================================
resourcestring
  RsAttributeIndexOutOfBounds = '%d is not a valid attribute index';
  RsSelectionIndexOutOfBounds = '%d is not a valid selection index';

//=== JvPageListTreeView.pas =================================================
{$IFNDEF COMPILER6_UP}
{ (ahuser) redefined in JvValidators.pas }
{ resourcestring
  RsEInterfaceNotSupported = '%s does not support the %s interface';
}
{$ENDIF COMPILER6_UP}

//=== JvPageSetup.pas ========================================================
resourcestring
  RsEInvalidValue = 'Value must be greater than zero';

//=== JvPainterQBForm.pas ====================================================
resourcestring
  RsPainterQuickBackdrops = 'Painter Quick Backdrops';
  RsEnterName = 'Enter Name:';
  RsNoItemSelected = 'No item selected!';
  RsErrorInPresets = 'Error in Presets';

//=== JvParameterList.pas ====================================================
resourcestring
  RsErrParameterMustBeEntered = 'Parameter "%s" must be entered!';

  RsHistorySelectPath = 'History';

  RsDialogCaption = '';
  RsOkButton = '&Ok';
  RsCancelButton = '&Cancel';
  RsHistoryLoadButton = '&Load';
  RsHistorySaveButton = '&Save';
  RsHistoryClearButton = 'Cl&ear';
  RsHistoryLoadCaption = 'Load Parameter Settings';
  RsHistorySaveCaption = 'Save Parameter Settings';
  RsHistoryClearCaption = 'Manage Parameter Settings';

  RsENoParametersDefined = 'TJvParameterList.ShowParameterDialog: No Parameters defined';
  RsEAddObjectWrongObjectType = 'TJvParameterList.AddObject: Wrong object type';
  RsEAddObjectSearchNameNotDefined = 'TJvParameterList.AddObject: SearchName not defined';
  RsEAddObjectDuplicateSearchNamesNotAllowed = 'TJvParameterList.AddObject: Duplicate SearchNames ("%s") not allowed';

//=== JvParameterListParameter.pas ====================================================
resourcestring
//  RsErrParameterMustBeEntered = 'Parameter %s must be entered!';
  RsErrParameterIsNotAValidNumber = 'Parameter %s: %s is not a valid number value!';
  RsErrParameterMustBeBetween = 'Parameter %s: %s must be between %s and %s!';
  RsErrParameterFileDoesNotExist = 'Parameter %s: The file "%s" does not exist!';
  RsErrParameterFileExistOverwrite = 'Parameter %s: The file "%s" exists! Overwrite?';
  RsErrParameterDirectoryNotExist = 'Parameter %s: The directory "%s" does not exist!';

//=== JvPatchForm.pas ========================================================
resourcestring
  RsJvPatcherEditorComparingFilesd = 'Jv - Patcher Editor: Comparing files %d%%';
  RsJvPatcherEditorEndStep = 'Jv - Patcher Editor: end step ...';

//=== JvPcx.pas ==============================================================
resourcestring
  RsPcxExtension = 'pcx';
  RsPcxFilterName = 'PCX Image';

  RsEPcxUnknownFormat = 'PCX: Unknown format';
  RsEPcxPaletteProblem = 'PCX: Unable to retrieve palette';
  RsEPcxInvalid = 'PCX: Invalid PCX file';

//=== JvPerfMon95.pas ========================================================
resourcestring
  RsWrongOS = 'TJvPerfMon95 component is intended for Win95/98 only';

  RsECantOpenPerfKey = 'Performance registry key not found';
  RsECantStart = 'Cannot start performance statistics (%s)';
  RsECantStop = 'Cannot stop performance statistics (%s)';
  RsEKeyNotExist = 'Specified key "%s" does not exist';

//=== JvPickDate.pas =========================================================
resourcestring
  RsNextYearHint = 'Next Year|';
  RsNextMonthHint = 'Next Month|';
  RsPrevYearHint = 'Previous Year|';
  RsPrevMonthHint = 'Previous Month|';

//=== JvPlugin.pas ===========================================================
resourcestring
  RsEFmtResNotFound = 'Resource not found: %s';

//=== JvPluginManager.pas ====================================================
resourcestring
  RsEErrEmptyExt = 'Extension may not be empty';
  RsEPluginPackageNotFound = 'Plugin package not found: %s';
  RsERegisterPluginNotFound = 'Plugin function %s not found in %s';
  RsERegisterPluginFailed = 'Calling %s in %s failed';

//=== JvProfilerForm.pas =====================================================
resourcestring
  RsTotalElapsedTimedms = '%s -  total elapsed time: %d (ms)';
  RsTextFormatsasctxtinfdocAllFiles = 'Text formats|*.asc;*.txt;*.inf;*.doc|All files|*.*';
  RsDefCaption = 'Profiler 32 Report';
  RsDefHeader = 'Profiler 32 run %s by "%s" (machine %s).';

  RsEMaxNumberOfIDsExceededd = 'Max number of ID''s exceeded (%d)';
  RsEMaxStackSizeExceededd = 'Max stack size exceeded (%d)';

//=== JvPrvwRender.pas =======================================================
resourcestring
  RsEAPrintPreviewComponentMustBeAssigne = 'A PrintPreview component must be assigned in CreatePreview!';
  RsEARichEditComponentMustBeAssignedInC = 'A RichEdit component must be assigned in CreatePreview!';
  RsECannotPerfromThisOperationWhilePrin = 'Cannot perfrom this operation while printing!';
  RsEPrinterNotAssigned = 'Printer not assigned!';
  RsENoPrintPreviewAssigned = 'No PrintPreview assigned!';

//=== JvRas32.pas ============================================================
resourcestring
  RsRasDllName = 'RASAPI32.DLL';

  RsERasError = 'RAS: Unable to find RasApi32.dll';

//=== JvRegistryTreeview.pas =================================================
resourcestring
  RsDefaultCaption = '(Default)';
  RsMyComputer = 'My Computer';
  RsDefaultNoValue = '(value not set)';
  RsUnknownCaption = '(Unknown)';

//=== JvResample.pas =========================================================
resourcestring
  RsESourceBitmapTooSmall = 'Source bitmap too small';

//=== JvRichEdit.pas =========================================================
resourcestring
  RsRTFFilter = 'Rich Text Format (*.rtf)|*.rtf';
  RsTextFilter = 'Plain text (*.txt)|*.txt';

  RsEConversionError = 'Conversion error %.8x';
  RsEConversionBusy = 'Cannot execute multiple conversions';
  RsECouldNotInitConverter = 'Could not initialize converter';
  RsEDiskFull = 'Out of space on output';
  RsEDocTooLarge = 'Conversion document too large for target';
  RsEInvalidDoc = 'Invalid document';
  RsEInvalidFile = 'Invalid data in conversion file';
  RsENoMemory = 'Out of memory';
  RsEOpenConvErr = 'Error opening conversion file';
  RsEOpenExceptErr = 'Error opening exception file';
  RsEOpenInFileErr = 'Could not open input file';
  RsEOpenOutFileErr = 'Could not open output file';
  RsEReadErr = 'Error during read';
  RsEUserCancel = 'Conversion cancelled by user';
  RsEWriteErr = 'Error during write';
  RsEWriteExceptErr = 'Error writing exception file';
  RsEWrongFileType = 'Wrong file type for this converter';

//=== JvSAL.pas ==============================================================
resourcestring
  RsEBooleanStackOverflow = 'boolean stack overflow';
  RsEBooleanStackUnderflow = 'boolean stack underflow';
  RsEProgramStopped = 'program stopped';
  RsEUnterminatedIncludeDirectiveNears = 'unterminated include directive near %s';
  RsEOngetUnitEventHandlerIsNotAssigned = 'ongetUnit event handler is not assigned';
  RsECouldNotIncludeUnits = 'could not include unit %s';
  RsEUnterminatedCommentNears = 'unterminated comment near %s';
  RsEUnterminatedProcedureNears = 'unterminated procedure near %s';
  RsEVariablesAllreadyDefineds = 'variable %s allready defined;%s';
  RsEVariablesIsNotYetDefineds = 'variable %s is not yet defined;%s';
  RsEProceduresNears = 'procedure %s near %s';
  RsEUndefinedProcedures = 'undefined procedure %s';
  RsECouldNotFindEndOfProcedure = 'could not find end of procedure';

//=== JvSALCore.pas ==========================================================
resourcestring
  RsEVariablesIsNotInitialized = 'variable %s is not initialized';
  RsEDivisionByZeroError = 'division by zero error';
  RsEMissingendselect = 'missing "endselect"';

//=== JvSchedEvtStore.pas ====================================================
resourcestring
  RsEStructureStackIsEmpty = 'Structure stack is empty';
  RsEScheduleIsActiveReadingANewSchedule =
    'Schedule is active. Reading a new schedule can only be done on inactive schedules';
  RsEScheduleIsActiveStoringOfAScheduleC =
    'Schedule is active. Storing of a schedule can only be done on inactive schedules';
  RsENotImplemented_ = 'not implemented';
  RsENotASchedule = 'Not a schedule';
  RsEUnknownScheduleVersions = 'Unknown schedule version ($%s)';
  RsEUnexpectedStructure = 'Unexpected structure';
  RsEIncorrectIdentifierFound = 'Incorrect identifier found';
  RsEIncorrectStructure = 'Incorrect structure found';

//=== JvScheduledEvents.pas ==================================================
resourcestring
  RsECannotRestart = 'Cannot restart: Event is being triggered or is executing';

//=== JvScrollMax.pas ========================================================
resourcestring
  RsRightClickAndChooseAddBand = 'Right click and choose "Add band"';

  { (rom) deactivated  see DefineCursor in JvScrollMax.pas
  RsECannotLoadCursorResource = 'Cannot load cursor resource';
  RsETooManyUserdefinedCursors = 'Too many user-defined cursors';
  }
  RsETJvScrollMaxBandCanBePutOnlyIntoTJv = 'TJvScrollMaxBand can be put only into TJvScrollMax component';
  RsETJvScrollMaxCanContainOnlyTJvScroll = 'TJvScrollMax can contain only TJvScrollMaxBand components';
  RsEControlsNotAChildOfs = 'Control %s not a child of %s';

//=== JvSegmentedLEDDisplay.pas ==============================================
resourcestring
  RsEInvalidClass = 'Invalid class';
  RsEInvalidMappingFile = 'Invalid mapping file';
  RsEDuplicateDigitClass = 'Duplicate DigitClass registered';

//=== JvSegmentedLEDDisplayMapperFrame.pas ===================================
resourcestring
  RsTheCurrentCharacterHasBeenModifiedA = 'The current character has been modified. Apply changes?';
  RsTheCurrentMappingHasBeenModifiedSav = 'The current mapping has been modified. Save changes to file?';
  RsSegmentedLEDDisplayMappingFilessdms = 'Segmented LED display mapping files (*.sdm)|*.sdm|All files (*.*)|*.*';
  RsSelectCharacter = 'Select character...';
  RsSpecifyANewCharacter = 'Specify a new character';

//=== JvSHFileOperation.pas ==================================================
resourcestring
  RsENoFilesSpecifiedToTJvSHFileOperatio = 'No files specified to TJvSHFileOperation Execute function';

//=== JvSimpleXml.pas ========================================================
resourcestring
  {$IFNDEF COMPILER6_UP}
  // RsEInvalidBoolean = '''%s'' is not a valid Boolean value'; make Delphi 5 compiler happy // andreas
  {$ENDIF COMPILER6_UP}
  RsEInvalidXMLElementUnexpectedCharacte =
    'Invalid XML Element: Unexpected character in property declaration ("%s" found)';
  RsEInvalidXMLElementUnexpectedCharacte_ =
    'Invalid XML Element: Unexpected character in property declaration. Expecting " or '' but "%s"  found';
  RsEUnexpectedValueForLPos = 'Unexpected value for lPos';
  RsEInvalidXMLElementExpectedBeginningO = 'Invalid XML Element: Expected beginning of tag but "%s" found';
  RsEInvalidXMLElementExpectedEndOfTagBu = 'Invalid XML Element: Expected end of tag but "%s" found';
  RsEInvalidXMLElementMalformedTagFoundn = 'Invalid XML Element: malformed tag found (no valid name)';
  RsEInvalidXMLElementErroneousEndOfTagE =
    'Invalid XML Element: Erroneous end of tag, expecting </%s> but </%s> found';
  RsEInvalidCommentExpectedsButFounds = 'Invalid Comment: expected "%s" but found "%s"';
  RsEInvalidCommentNotAllowedInsideComme = 'Invalid Comment: "--" not allowed inside comments';
  RsEInvalidCommentUnexpectedEndOfData = 'Invalid Comment: Unexpected end of data';
  RsEInvalidCDATAExpectedsButFounds = 'Invalid CDATA: expected "%s" but found "%s"';
  RsEInvalidCDATAUnexpectedEndOfData = 'Invalid CDATA: Unexpected end of data';
  RsEInvalidHeaderExpectedsButFounds = 'Invalid Header: expected "%s" but found "%s"';
  RsEInvalidStylesheetExpectedsButFounds = 'Invalid Stylesheet: expected "%s" but found "%s"';
  RsEInvalidStylesheetUnexpectedEndOfDat = 'Invalid Stylesheet: Unexpected end of data';
  RsEInvalidDocumentUnexpectedTextInFile = 'Invalid Document: Unexpected text in file prolog';

//=== JvSpeedbar.pas =========================================================
resourcestring
  RsEAutoSpeedbarMode = 'Cannot set this property value while Position is bpAuto';

//=== JvSpeedbarSetupForm.pas ================================================
resourcestring
  RsCustomizeSpeedbar = 'Customize Speedbar';
  RsAvailButtons = '&Available buttons:';
  RsSpeedbarCategories = '&Categories:';
  RsSpeedbarEditHint = 'To add command buttons, drag and drop buttons onto the SpeedBar.' +
    ' To remove command buttons, drag them off the SpeedBar.';

//=== JvSpellChecker.pas =====================================================
resourcestring
  RsENoSpellCheckerAvailable = 'No IJvSpellChecker implementation available!';

//=== JvSpellerForm.pas ======================================================
resourcestring
  RsENoDictionaryLoaded = 'No dictionary loaded';

//=== JvSpin.pas =============================================================
resourcestring
  RsEOutOfRangeFloat = 'Value must be between %g and %g';

//=== JvStatusBar.pas ========================================================
resourcestring
  RsEInvalidControlSelection = 'Invalid control selection';

//=== JvSticker.pas ==========================================================
resourcestring
  RsEditStickerCaption = 'Edit sticker';

//=== JvStrings.pas ==========================================================
resourcestring
  RsECannotLoadResource = 'Cannot load resource: %s';
  RsEIncorrectStringFormat = 'Base64: Incorrect string format';

//=== JvSyncSplitter.pas =====================================================
resourcestring
  RsEInvalidPartner = 'TJvSyncSplitter.SetPartner: cannot set Partner to Self!';

//=== JvSystemPopup.pas ======================================================
resourcestring
  RsEAlreadyHooked = 'TJvSystemPopup.Hook: already hooked';

//=== JvTFDays.pas ===========================================================
resourcestring
  RsEInvalidPrimeTimeStartTime = 'Invalid PrimeTime StartTime';
  RsEInvalidPrimeTimeEndTime = 'Invalid PrimeTime EndTime';
  RsEColumnIndexOutOfBounds = 'Column index out of bounds';
  RsERowIndexOutOfBounds = 'Row index out of bounds';
  RsEMapColNotFoundForAppointment = 'Map column not found for appointment';
  RsECorruptAppointmentMap = 'Corrupt appointment map';
  RsEGridGranularityCannotBeGreater = 'Grid granularity cannot be greater ' +
    'than the time block granularity';
  RsETimeBlockGranularityMustBeEvenly = 'Time block granularity must be evenly ' +
    'divisible by the grid granularity';
  RsETimeBlocksMustBeginExactlyOn = 'Time blocks must begin exactly on ' +
    'a grid time division';
  RsEGridEndTimeCannotBePriorToGridStart = 'GridEndTime cannot be prior to GridStartTime';
  RsEGridStartTimeCannotBeAfterGridEndTi = 'GridStartTime cannot be after GridEndTime';
  RsEInvalidRowd = 'Invalid row (%d)';
  RsEThereIsNoDataToPrint = 'There is no data to print';
  RsENoPageInfoExists = 'No page info exists.  ' +
    'Document must be prepared';
  RsEATimeBlockNameCannotBeNull = 'A time block name cannot be null';
  RsEAnotherTimeBlockWithTheName = 'Another time block with the name ' +
    '"%s" already exists';
  RsEATimeBlockWithTheNamesDoesNotExist = 'A time block with the name "%s" does not exist';

//=== JvTFGantt.pas ==========================================================
resourcestring
  RsThisIsTheMajorScale = 'This is the Major Scale';
  RsThisIsTheMinorScale = 'This is the Minor Scale';

//=== JvTFGlance.pas =========================================================
resourcestring
  RsECellDatesCannotBeChanged = 'Cell Dates cannot be changed';
  RsECellMapHasBeenCorrupteds = 'Cell map has been corrupted %s';
  RsECellObjectNotAssigned = 'Cell object not assigned';
  RsEInvalidColIndexd = 'Invalid col index (%d)';
  RsEInvalidRowIndexd = 'Invalid row index (%d)';
  RsEApptIndexOutOfBoundsd = 'Appt index out of bounds (%d)';
  RsECellCannotBeSplit = 'Cell cannot be split';
  RsEASubcellCannotBeSplit = 'A subcell cannot be split';

//=== JvTFGlanceTextViewer.pas ===============================================
resourcestring
  RsEGlanceControlNotAssigned = 'GlanceControl not assigned';

//=== JvTFManager.pas ========================================================
resourcestring
  RsECouldNotCreateCustomImageMap = 'Could not create CustomImageMap.  ' +
    'Appointment not assigned';
  RsECouldNotCreateAppointmentObject = 'Could not create Appointment object.  ' +
    'ScheduleManager not assigned';
  RsEScheduleManagerNotificationFailedSc = 'ScheduleManager notification failed.  ScheduleManager not assigned';
  RsEScheduleNotificationFailed = 'Schedule notification failed.  ' +
    'Schedule not assigned';
  RsEInvalidStartAndEndTimes = 'Invalid start and end times';
  RsEInvalidStartAndEndDates = 'Invalid start and end dates';
  RsEAppointmentNotificationFailed = 'Appointment notification failed.  ' +
    'Appointment not assigned';
  RsECouldNotCreateNewAppointment = 'Could not create new appointment. ' +
    'Appointment with given ID already exists';
  RsEInvalidTriggerForRefreshControls = 'Invalid Trigger for RefreshControls';
  RsEInvalidScopeInReconcileRefresh = 'Invalid Scope in ReconcileRefresh';
  RsECouldNotRetrieveSchedule = 'Could not retrieve schedule.  ' +
    'ScheduleManager not assigned';
  RsECouldNotReleaseSchedule = 'Could not release schedule.  ' +
    'ScheduleManager not assigned';
  RsECouldNotCreateADocumentBecauseA = 'Could not create a document because a ' +
    'document already exists';
  RsECouldNotFinishDocumentBecauseNo = 'Could not finish document because no ' +
    'document has been created';
  RsEDocumentDoesNotExist = 'Document does not exist';
  RsEDocumentPagesCannotBeAccessedIf = 'Document pages cannot be accessed if ' +
    'printing directly to the printer';
  RsEDocumentPagesAreInaccessibleUntil = 'Document pages are inaccessible until ' +
    'the document has been finished';
  RsECouldNotRetrievePageCount = 'Could not retrieve page count ' +
    'because document does not exist';
  RsEOnlyAFinishedDocumentCanBePrinted = 'Only a finished document can be printed';
  RsEThereAreNoPagesToPrint = 'There are no pages to print';
  RsEDocumentMustBeFinishedToSaveToFile = 'Document must be Finished to save to file';
  RsEThisPropertyCannotBeChangedIfA = 'This property cannot be changed if a ' +
    'document exists';
  RsECouldNotCreateTJvTFPrinterPageLayou = 'Could not create TJvTFPrinterPageLayout ' +
    'because aPrinter must be assigned';
  RsEInvalidFooterHeightd = 'Invalid Footer Height (%d)';
  RsEInvalidHeaderHeightd = 'Invalid Header Height (%d)';

//=== JvTFSparseMatrix.pas ===================================================
resourcestring
  RsEMatrixMustBeEmpty = 'Matrix must be empty before setting null value';

//=== JvTFUtils.pas ==========================================================
resourcestring
  RsEResultDoesNotFallInMonth = 'Result does not fall in given month';
  RsEInvalidMonthValue = 'Invalid Month Value (%d)';
  RsEInvalidDayOfWeekValue = 'Invalid value for day of week (%d)';

//=== JvTFWeeks.pas ==========================================================
resourcestring
  RsWeekOf = 'Week of %s';

//=== JvThumbImage.pas =======================================================
resourcestring
  RsEUnknownFileExtension = 'Unknown file extension %s';
  RsFileFilters = '|PCX Files(*.pcx)|*.pcx|Targa Files(*.tga)|*.tga';
  RsPcxTga = '*.pcx;*.tga;';

//=== JvThumbnails.pas =======================================================
resourcestring
  RsUnknown = 'Unknown';

//=== JvTimeLimit.pas ========================================================
resourcestring
  RsExpired = 'The test period has expired, please register this application';

//=== JvTimeList.pas =========================================================
resourcestring
  RsEOwnerMustBeTJvTimerList = 'Owner of TJvTimerEvents must be a TJvTimerList';

//=== JvTipOfDay.pas =========================================================
resourcestring
  RsCloseCaption = '&Close';
  RsNextCaption = '&Next Tip';
  RsTipsTitle = 'Tips and Tricks';
  RsTipsHeaderText = 'Did you know...';
  RsTipsCheckBoxText = '&Show Tips on Startup';
  RsStoreShowOnStartUp = 'Show On Startup';

//=== JvToolEdit.pas =========================================================
resourcestring
  RsBrowseCaption = 'Browse';
  {$IFDEF MSWINDOWS}
  RsDefaultFilter = 'All files (*.*)|*.*';
  {$ENDIF MSWINDOWS}
  {$IFDEF LINUX}
  RsDefaultFilter = 'All files (*)|*';
  {$ENDIF LINUX}

  { Polaris patch }
  RsEDateMinLimit = 'Enter a date before "%s"';
  RsEDateMaxLimit = 'Enter a date after "%s"';

//=== JvTurtle.pas ===========================================================
resourcestring
  RsErrorCanvasNotAssigned = '#Error: Canvas not assigned';
  RsEmptyScript = 'empty script';
  RsInvalidIntegerIns = 'invalid integer in %s';
  RsInvalidColorIns = 'invalid color in %s';
  RsInvalidCopyMode = 'invalid copy mode';
  RsInvalidPenMode = 'invalid pen mode';
  RsInvalidTextIns = 'invalid text in %s';
  RsMissingFontname = 'missing fontname';
  RsNumberExpectedIns = 'number expected in %s';
  RsNumberStackUnderflow = 'number stack underflow';
  RsNumberStackOverflow = 'number stack overflow';
  RsMissingAfterComment = 'missing } after comment';
  RsErrorIns = 'error in %s';
  RsDivisionByZero = 'division by zero';
  RsInvalidParameterIns = 'invalid parameter in %s';
  RsSymbolsIsNotDefined = 'symbol %s is not defined';
  RsMissingAfterBlock = 'missing ] after block';
  RsStackUnderflowIns = 'stack underflow in %s';
  RsSymbolExpectedAfterIf = 'symbol expected after if';
  RsCanNotTakeSqrtOf = 'can not take sqrt of 0';
  RsNotAllowedIns = '0 not allowed in %s';
  RsNeedMinimumOfSidesIns = 'need minimum of 3 sides in %s';
  RsMaximumSidesExceededIns = 'maximum 12 sides exceeded in %s';
  RsTokenExpected = 'token expected';
  RssDoesNotExist = '%s does not exist';
  RsDivisionByZeroNotAllowedInIn = 'division by zero not allowed in in-';
  RsStackOverflow = 'stack overflow';
  RsStackUnderflow = 'stack underflow';

//=== JvTypes.pas ============================================================
resourcestring
  RsClBlack = 'Black';
  RsClMaroon = 'Maroon';
  RsClGreen = 'Green';
  RsClOlive = 'Olive green';
  RsClNavy = 'Navy blue';
  RsClPurple = 'Purple';
  RsClTeal = 'Teal';
  RsClGray = 'Gray';
  RsClSilver = 'Silver';
  RsClRed = 'Red';
  RsClLime = 'Lime';
  RsClYellow = 'Yellow';
  RsClBlue = 'Blue';
  RsClFuchsia = 'Fuchsia';
  RsClAqua = 'Aqua';
  RsClWhite = 'White';
  RsClMoneyGreen = 'Money green';
  RsClSkyBlue = 'Sky blue';
  RsClCream = 'Cream';
  RsClMedGray = 'Medium gray';

  RsClScrollBar = 'Scrollbar';
  RsClBackground = 'Desktop background';
  RsClActiveCaption = 'Active window title bar';
  RsClInactiveCaption = 'Inactive window title bar';
  RsClMenu = 'Menu background';
  RsClWindow = 'Window background';
  RsClWindowFrame = 'Window frame';
  RsClMenuText = 'Menu text';
  RsClWindowText = 'Window text';
  RsClCaptionText = 'Active window title bar text';
  RsClActiveBorder = 'Active window border';
  RsClInactiveBorder = 'Inactive window border';
  RsClAppWorkSpace = 'Application workspace';
  RsClHighlight = 'Selection background';
  RsClHighlightText = 'Selection text';
  RsClBtnFace = 'Button face';
  RsClBtnShadow = 'Button shadow';
  RsClGrayText = 'Dimmed text';
  RsClBtnText = 'Button text';
  RsClInactiveCaptionText = 'Inactive window title bar text';
  RsClBtnHighlight = 'Button highlight';
  RsCl3DDkShadow = 'Dark shadow 3D elements';
  RsCl3DLight = 'Highlight 3D elements';
  RsClInfoText = 'Tooltip text';
  RsClInfoBk = 'Tooltip background';

//=== JvUrlListGrabber.pas ===================================================
resourcestring
  RsENoGrabberForUrl = 'There is no grabber capable of handling URL: %s';

//=== JvValidators.pas =======================================================
resourcestring
  RsEInterfaceNotSupported = '%s does not support the %s interface';
  RsECircularReference = 'Circular reference not allowed';
  RsEInsertNilValidator = 'Cannot insert nil validator';
  RsERemoveNilValidator = 'Cannot remove nil validator';
  RsEValidatorNotChild = 'Validator is not owned by this component';
  RsEInvalidIndexd = 'Invalid index (%d)';

//=== JvVirtualKeySelectionFrame.pas =========================================
resourcestring
  RsNoValidKeyCode = 'This is not a valid key code';
  RsInvalidKeyCode = 'Invalid key code';

//=== JvWinampLabel.pas ======================================================
resourcestring
  RsWinampRC = 'WINAMP1';

  RsEInvalidSkin = 'Invalid skin';

//=== JvWinDialogs.pas =======================================================
resourcestring
  //SDiskFullError =
  //  'TJvDiskFullDialog does not support removable media or network drives.';
  RsENotSupported = 'This function is not supported by your version of Windows';
  RsEInvalidDriveChar = 'Invalid drive (%s)';
  { make Delphi 5 compiler happy // andreas
    RsEUnsupportedDisk = 'Unsupported drive (%s): JvDiskFullDialog only supports fixed drives';}

//=== JvWinHelp.pas ==========================================================
resourcestring
  RsEOwnerForm = 'Owner must be of type TCustomForm';

//=== JvWizard.pas ===========================================================
resourcestring
  RsFirstButtonCaption = 'To &Start Page';
  RsLastButtonCaption = 'To &Last Page';
  RsFinishButtonCaption = '&Finish';
  RsWelcome = 'Welcome';
  RsTitle = 'Title';
  RsSubtitle = 'Subtitle';

  RsEInvalidParentControl = 'The Parent should be TJvWizard or a descendant';
  RsEInvalidWizardPage = 'The pages belong to another wizard';

//=== JvWizardCommon.pas =====================================================
resourcestring
  RsETilingError = 'Tiling only works on images with dimensions > 0';

//=== JvWizardRouteMapSteps.pas ==============================================
resourcestring
  RsActiveStepFormat = 'Step %d of %d';
  RsBackTo = 'Back to';
  RsNextStep = 'Next Step';

//=== JvXmlDatabase.pas ======================================================
resourcestring
  RsEUnknownInstruction = 'Unknown Instruction %s';
  RsEUnexpectedEndOfQuery = 'Unexpected end of query';
  RsEUnexpectedStatement = 'Unexpected statement %s';

//=== JvYearGrid.pas =========================================================
resourcestring
  RsYearGrid = 'YearGrid';
  RsEnterYear = 'Enter year (1999-2050):';
  RsInvalidYear = 'invalid year';
  RsYear = '&Year...';
  RsEdit = '&Edit';
  RsColor = '&Color...';
  RsNoColor = '&No Color';
  RsSaveAllInfo = '&Save All Info';
  RsSaveFoundInfo = 'Save Found Info';
  RsBorderColor = '&Border Color...';
  RsBookMarkColor = 'Book&Mark Color...';
  RsFindItem = '&Find...';
  RsClearFind = 'Clear Find';
  RsYearGridFind = 'YearGrid Find';
  RsEnterSeachText = 'Enter seach text:';
  RsFounds = 'Found %s';
  RsToday = 'Today ';

//=== not taken into JVCL ====================================================
{
resourcestring
  // MathParser
  SParseSyntaxError = 'Syntax error';
  SParseNotCramp = 'Invalid condition (no cramp)';
  SParseDivideByZero = 'Divide by zero';
  SParseSqrError = 'Invalid floating operation';
  SParseLogError = 'Invalid floating operation';
  SParseInvalidFloatOperation = 'Invalid floating operation';
  // JvDBFilter
  SExprNotBoolean = 'Field ''%s'' is not of type Boolean';
  SExprBadNullTest = 'NULL only allowed with ''='' and ''<>''';
  SExprBadField = 'Field ''%s'' cannot be used in a filter expression';
  // JvDBFilter expression parser
  SExprIncorrect = 'Incorrectly formed filter expression';
  SExprTermination = 'Filter expression incorrectly terminated';
  SExprNameError = 'Unterminated field name';
  SExprStringError = 'Unterminated string constant';
  SExprInvalidChar = 'Invalid filter expression character: ''%s''';
  SExprNoRParen = ''')'' expected but %s found';
  SExprExpected = 'Expression expected but %s found';
  SExprBadCompare = 'Relational operators require a field and a constant';
}

implementation

end.
