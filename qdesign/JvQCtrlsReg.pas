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
  {JvQZoom,} JvQBehaviorLabel, JvQArrowButton,
  JvQaScrollText, JvQScrollPanel,

  {$IFDEF LINUX}
  JvQSpeedBar, JvQSpeedbarSetupForm, JvQSpeedbarForm,
  {$ENDIF LINUX}
  JvQClock, JvQContentScroller, JvQColorBox,
  JvQColorButton,
  JvQDice,
  JvQFooter, JvQGroupHeader, JvQHint,
  JvQHtControls,
  JvQItemsPanel,
  JvQRollOut, JvQRollOutEditor,
  JvQScrollText, JvQSpacer, JvQSplitter, JvQNetscapeSplitter,

  JvQSwitch,
  JvQTransparentButton,
  JvQColorForm, JvQDsgnIntf,
  JvQImageDrawThread, JvQWinampLabel, JvQComponentPanel,
  JvQButtons, JvQCaptionPanel, JvQMovableBevel
  ;

{$R ../Resources/JvCtrlsReg.dcr}

procedure Register;
begin
  RegisterComponents(RsPaletteButton, [TJvTransparentButton,
    TJvTransparentButton2, TJvArrowButton, TJvColorButton,
    TJvHTButton, TJvSpacer, TJvSwitch, {TJvColorBox, TJvColorSquare,
    TJvDropButton,} TJvOfficeColorButton, TJvOfficeColorPanel]);
  RegisterComponents(RsPaletteBarPanel, [{$IFDEF LINUX}TJvSpeedBar,{$ENDIF}
    TJvCaptionPanel, TJvItemsPanel, TJvMovableBevel, TJvRollOut,
    TJvFooter, TJvGroupHeader, TJvComponentPanel]);
  RegisterComponents(RsPaletteLabel, [TJvBehaviorLabel,
    TJvHTLabel, TJvWinampLabel]);
  RegisterComponents(RsPaletteListComboTree, [TJvHTListBox, TJvHTComboBox]);
  RegisterComponents(RsPaletteScrollerTracker, [TJvaScrollText,
    TJvContentScroller, TJvScrollingWindow, TJvScrollText]);
  RegisterComponents(RsPaletteSliderSplitter, [TJvSplitter, TJvNetscapeSplitter]);
  RegisterComponents(RsPaletteVisual, [TJvClock, {TJvZoom,} TJvDice]);
  RegisterComponents(RsPaletteNonVisual, [TJvHint {, TJvRegAuto}]);

  RegisterPropertyEditor(TypeInfo(TCaption), TJvHTLabel, 'Caption', TJvHintProperty);
  RegisterPropertyEditor(TypeInfo(TJvLabelBehaviorName), TJvBehaviorLabel, 'Behavior', TJvLabelBehaviorProperty);
//  RegisterPropertyEditor(TypeInfo(TCursor), TJvxSplitter, 'Cursor', nil);
  //RegisterPropertyEditor(TypeInfo(TDateTime), TJvAlarmInfo, 'Date', TJvDateTimeExProperty);
  //RegisterPropertyEditor(TypeInfo(TDateTime), TJvAlarmInfo, 'Date', TJvDateTimeExProperty);
//  RegisterPropertyEditor(TypeInfo(integer), TJvTransparentButton2, 'ActiveIndex', TJvTBImagesProperty);
//  RegisterPropertyEditor(TypeInfo(integer), TJvTransparentButton2, 'DisabledIndex', TJvTBImagesProperty);
//  RegisterPropertyEditor(TypeInfo(integer), TJvTransparentButton2, 'DownIndex', TJvTBImagesProperty);
//  RegisterPropertyEditor(TypeInfo(integer), TJvTransparentButton2, 'GrayIndex', TJvTBImagesProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TJvRollOutImageOptions, '', TJvRollOutOptionsImagesProperty);
  {$IFDEF LINUX}
  RegisterPropertyEditor(TypeInfo(TCaption), TJvSpeedItem, 'BtnCaption', TStringProperty);
  RegisterComponentEditor(TJvSpeedBar, TJvSpeedbarCompEditor);
  RegisterNoIcon([TJvSpeedItem, TJvSpeedbarSection]);
  {$ENDIF LINUX}

//  RegisterComponentEditor(TJvScrollMax, TJvScrollMaxEditor);
  RegisterComponentEditor(TJvRollOut, TJvRollOutDefaultEditor);
  RegisterComponentEditor(TJvGroupHeader, TJvGroupHeaderEditor);
  RegisterComponentEditor(TJvFooter, TJvFooterEditor);
//  RegisterComponentEditor(TJvImageListBox, TJvStringsEditor);
//  RegisterComponentEditor(TJvImageComboBox, TJvStringsEditor);
//  RegisterComponentEditor(TJvRegAuto, TJvRegAutoEditor);

//  RegisterClass(TJvScrollMaxBand);
  RegisterClass(TJvFooterBtn);
  RegisterActions(RsJVCLActionsCategory, [TJvRollOutAction], nil);
end;

end.
