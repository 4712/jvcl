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

The Original Code is: JvBandsReg.PAS, released on 2002-05-26.

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

unit JvQCtrlsReg;

interface

procedure Register;

implementation

uses
  Classes,
  
  
  QControls, QImgList, QActnList, QTypes,
  
  
  DesignEditors, DesignIntf,

  JvQBehaviorLabelEditor, JvQHTHintForm, JvQFooterEditor,
  JvQGroupHeaderEditor, 

  JvQDsgnConsts,
  JvQOfficeColorButton, JvQOfficeColorPanel,
  JvQZoom, JvQBehaviorLabel, JvQArrowButton,
  JvQaScrollText,

  JvQClock, JvQContentScroller, JvQColorBox,
  JvQColorButton,
  JvQDice,
  JvQFooter, JvQGroupHeader, JvQHint,
  JvQHtControls,
  JvQItemsPanel,
  JvQRollOut, JvQRollOutEditor,
  JvQScrollText, JvQSpacer, JvQSplitter, JvQNetscapeSplitter,
  JvQSwitch,
  JvQColorForm, JvQDsgnIntf,
  JvQImageDrawThread, JvQWinampLabel, JvQComponentPanel,
  JvQButtons, JvQCaptionPanel, JvQMovableBevel
  ;

{$IFDEF MSWINDOWS}
{$R ..\Resources\JvCtrlsReg.dcr}
{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
{$R ../Resources/JvCtrlsReg.dcr}
{$ENDIF LINUX}

procedure Register;
begin
  RegisterComponents(RsPaletteButton, [TJvArrowButton, TJvColorButton,
    TJvHTButton, TJvSpacer, TJvSwitch, TJvColorBox, TJvColorSquare,
    TJvDropButton, TJvOfficeColorButton, TJvOfficeColorPanel]);
  RegisterComponents(RsPaletteBarPanel, [TJvCaptionPanel,
    TJvItemsPanel, TJvMovableBevel, TJvRollOut, TJvFooter, TJvGroupHeader,
    TJvComponentPanel]);
  RegisterComponents(RsPaletteLabel, [TJvBehaviorLabel,
    TJvHTLabel, TJvWinampLabel]);
  RegisterComponents(RsPaletteListComboTree, [TJvHTListBox, TJvHTComboBox]);
  RegisterComponents(RsPaletteScrollerTracker, [TJvaScrollText,
    TJvContentScroller, TJvScrollText]);
  RegisterComponents(RsPaletteSliderSplitter, [TJvSplitter, TJvNetscapeSplitter]);
  RegisterComponents(RsPaletteVisual, [TJvClock, TJvZoom, TJvDice]);
  RegisterComponents(RsPaletteNonVisual, [TJvHint {, TJvRegAuto}]);

  RegisterPropertyEditor(TypeInfo(TCaption), TJvHTLabel, 'Caption', TJvHintProperty);
  RegisterPropertyEditor(TypeInfo(TJvLabelBehaviorName), TJvBehaviorLabel, 'Behavior', TJvLabelBehaviorProperty);
//  RegisterPropertyEditor(TypeInfo(TCursor), TJvxSplitter, 'Cursor', nil);
  //RegisterPropertyEditor(TypeInfo(TDateTime), TJvAlarmInfo, 'Date', TJvDateTimeExProperty);
  //RegisterPropertyEditor(TypeInfo(TDateTime), TJvAlarmInfo, 'Date', TJvDateTimeExProperty);
//  RegisterPropertyEditor(TypeInfo(TCaption), TJvSpeedItem, 'BtnCaption', TStringProperty);

//  RegisterPropertyEditor(TypeInfo(integer), TJvTransparentButton2, 'ActiveIndex', TJvTBImagesProperty);
//  RegisterPropertyEditor(TypeInfo(integer), TJvTransparentButton2, 'DisabledIndex', TJvTBImagesProperty);
//  RegisterPropertyEditor(TypeInfo(integer), TJvTransparentButton2, 'DownIndex', TJvTBImagesProperty);
//  RegisterPropertyEditor(TypeInfo(integer), TJvTransparentButton2, 'GrayIndex', TJvTBImagesProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TJvRollOutImageOptions, '', TJvRollOutOptionsImagesProperty);

//  RegisterComponentEditor(TJvScrollMax, TJvScrollMaxEditor);
  RegisterComponentEditor(TJvRollOut, TJvRollOutDefaultEditor);
  RegisterComponentEditor(TJvGroupHeader, TJvGroupHeaderEditor);
  RegisterComponentEditor(TJvFooter, TJvFooterEditor);
//  RegisterComponentEditor(TJvImageListBox, TJvStringsEditor);
//  RegisterComponentEditor(TJvImageComboBox, TJvStringsEditor);
//  RegisterComponentEditor(TJvSpeedBar, TJvSpeedbarCompEditor);
//  RegisterComponentEditor(TJvRegAuto, TJvRegAutoEditor);

//  RegisterNoIcon([TJvSpeedItem, TJvSpeedbarSection]);
//  RegisterClass(TJvScrollMaxBand);
  RegisterClass(TJvFooterBtn);
  RegisterActions(RsJVCLActionsCategory, [TJvRollOutAction], nil);
end;

end.
