{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvPlacemnt.PAS, released on 2002-07-04.

The Initial Developers of the Original Code are: Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 1997, 1998 Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 2001,2002 SGB Software
All Rights Reserved.

Last Modified: 2002-07-04

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvDynControlEngine_DevExpCx;

interface

uses
  Classes, Controls, StdCtrls, ExtCtrls, ComCtrls, Mask, Forms, Graphics,
  Buttons, Dialogs, FileCtrl,
  cxLookAndFeels, cxMaskEdit, cxLabel, cxButtons, cxListBox, cxDropDownEdit,
  cxButtonEdit, cxCalendar, cxCheckBox, cxMemo, cxRadioGroup, cxImage,
  cxEdit, cxCalc, cxSpinEdit, cxTimeEdit,
  JvDynControlEngine, JvDynControlEngine_Interface;

type
  TCxDynControlWrapper = class (TPersistent)
  private
    FLookAndFeel: TcxLookAndFeel;
    FStyleController: TcxEditStyleController;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  published
    property LookAndFeel: TcxLookAndFeel read FLookAndFeel write FLookAndFeel;
    property StyleController: TcxEditStyleController read FStyleController write FStyleController;
  end;

  IJvDynControlDevExpCx = interface
    ['{247D29CD-ABA4-4F87-A25D-4987BD950F0C}']
    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);
  end;

  TJvDynControlCxMaskEdit = class (TcxMaskEdit, IUnknown, IJvDynControl, IJvDynControlData,
    IJvDynControlDevExpCx)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: boolean);
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetValue(Value: variant);
    function ControlGetValue: variant;

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);
  end;

  TJvDynControlCxCalcEdit = class (TcxCalcEdit, IUnknown, IJvDynControl, IJvDynControlData,
    IJvDynControlDevExpCx)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: boolean);
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetValue(Value: variant);
    function ControlGetValue: variant;

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);
  end;

  TJvDynControlCxSpinEdit = class (TcxSpinEdit, IUnknown, IJvDynControl, IJvDynControlData,
    IJvDynControlDevExpCx, IJvDynControlSpin)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: boolean);
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetValue(Value: variant);
    function ControlGetValue: variant;

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);

    // IJvDynControlSpin
    procedure ControlSetIncrement(Value: integer);
    procedure ControlSetMinValue(Value: double);
    procedure ControlSetMaxValue(Value: double);
    procedure ControlSetUseForInteger(Value: boolean);
  end;

  TJvDynControlCxFileNameEdit = class (TcxButtonEdit, IUnknown, IJvDynControl,
    IJvDynControlData, IJvDynControlDevExpCx, IJvDynControlFileName)
  private
    FInitialDir: string;
    FFilterIndex: integer;
    FFilter: string;
    FDialogOptions: TOpenOptions;
    FDialogKind: TJvDynControlFileNameDialogKind;
    FDialogTitle: string;
    FDefaultExt: string;
  public
    procedure DefaultOnButtonClick(Sender: TObject; AButtonIndex: integer);

    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: boolean);
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetValue(Value: variant);
    function ControlGetValue: variant;

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);

    // IJvDynControlFileName
    procedure ControlSetInitialDir(Value: string);
    procedure ControlSetDefaultExt(Value: string);
    procedure ControlSetDialogTitle(Value: string);
    procedure ControlSetDialogOptions(Value: TOpenOptions);
    procedure ControlSetFilter(Value: string);
    procedure ControlSetFilterIndex(Value: integer);
    procedure ControlSetDialogKind(Value: TJvDynControlFileNameDialogKind);
  end;

  TJvDynControlCxDirectoryEdit = class (TcxButtonEdit, IUnknown, IJvDynControl,
    IJvDynControlData, IJvDynControlDevExpCx, IJvDynControlDirectory)
  private
    FInitialDir: string;
    FDialogOptions: TSelectDirOpts;
    FDialogTitle: string;
  public
    procedure DefaultOnButtonClick(Sender: TObject; AButtonIndex: integer);

    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: boolean);
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetValue(Value: variant);
    function ControlGetValue: variant;

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);

    // IJvDynControlDirectory
    procedure ControlSetInitialDir(Value: string);
    procedure ControlSetDialogTitle(Value: string);
    procedure ControlSetDialogOptions(Value: TSelectDirOpts);
  end;

  TJvDynControlCxDateTimeEdit = class (TcxDateEdit, IUnknown, IJvDynControl,
    IJvDynControlData, IJvDynControlDevExpCx, IJvDynControlDate)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: boolean);
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetValue(Value: variant);
    function ControlGetValue: variant;

    // IJvDynControlDate
    procedure ControlSetMinDate(Value: TDateTime);
    procedure ControlSetMaxDate(Value: TDateTime);
    procedure ControlSetFormat(Value: string);

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);
  end;

  TJvDynControlCxDateEdit = class (TcxDateEdit, IUnknown, IJvDynControl,
    IJvDynControlData, IJvDynControlDevExpCx, IJvDynControlDate)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: boolean);
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetValue(Value: variant);
    function ControlGetValue: variant;

    // IJvDynControlDate
    procedure ControlSetMinDate(Value: TDateTime);
    procedure ControlSetMaxDate(Value: TDateTime);
    procedure ControlSetFormat(Value: string);

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);
  end;

  TJvDynControlCxTimeEdit = class (TcxTimeEdit, IUnknown, IJvDynControl,
    IJvDynControlData, IJvDynControlDevExpCx, IJvDynControlTime)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: boolean);
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetValue(Value: variant);
    function ControlGetValue: variant;

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);

    procedure ControlSetFormat(Value: string);
  end;

  TJvDynControlCxCheckbox = class (TcxCheckBox, IUnknown, IJvDynControl,
    IJvDynControlData, IJvDynControlDevExpCx)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: boolean);
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetValue(Value: variant);
    function ControlGetValue: variant;

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);
  end;

  TJvDynControlCxMemo = class (TcxMemo, IUnknown, IJvDynControl, IJvDynControlData,
    IJvDynControlItems, IJvDynControlMemo, IJvDynControlDevExpCx)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: boolean);
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetValue(Value: variant);
    function ControlGetValue: variant;

    procedure ControlSetSorted(Value: boolean);
    procedure ControlSetItems(Value: TStrings);
    function ControlGetItems: TStrings;

    procedure ControlSetWantTabs(Value: boolean);
    procedure ControlSetWantReturns(Value: boolean);
    procedure ControlSetWordWrap(Value: boolean);
    procedure ControlSetScrollBars(Value: TScrollStyle);

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);
  end;

  TJvDynControlCxRadioGroup = class (TcxRadioGroup, IUnknown, IJvDynControl,
    IJvDynControlData, IJvDynControlItems, IJvDynControlDevExpCx,
    IJvDynControlRadioGroup)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: boolean);
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetValue(Value: variant);
    function ControlGetValue: variant;

    procedure ControlSetSorted(Value: boolean);
    procedure ControlSetItems(Value: TStrings);
    function ControlGetItems: TStrings;

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);

    procedure ControlSetColumns(Value: integer);
  end;

  TJvDynControlCxListBox = class (TcxListBox, IUnknown, IJvDynControl, IJvDynControlData,
    IJvDynControlItems, IJvDynControlDblClick, IJvDynControlDevExpCx)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: boolean);
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetValue(Value: variant);
    function ControlGetValue: variant;

    procedure ControlSetSorted(Value: boolean);
    procedure ControlSetItems(Value: TStrings);
    function ControlGetItems: TStrings;

    procedure ControlSetOnDblClick(Value: TNotifyEvent);

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);
  end;

  TJvDynControlCxComboBox = class (TcxComboBox, IUnknown, IJvDynControl, IJvDynControlData,
    IJvDynControlItems, IJvDynControlDevExpCx, IJvDynControlComboBox)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: boolean);
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetValue(Value: variant);
    function ControlGetValue: variant;

    procedure ControlSetSorted(Value: boolean);
    procedure ControlSetItems(Value: TStrings);
    function ControlGetItems: TStrings;

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);

    procedure ControlSetNewEntriesAllowed(Value: boolean);
  end;

  TJvDynControlCxPanel = class (TPanel, IUnknown, IJvDynControl, IJvDynControlPanel)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetBorder(ABevelInner: TPanelBevel; ABevelOuter: TPanelBevel; ABevelWidth: integer; ABorderStyle: TBorderStyle; ABorderWidth: integer);
  end;

  TJvDynControlCxImage = class (TcxImage, IUnknown, IJvDynControl,
    IJvDynControlImage, IJvDynControlDevExpCx)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetAutoSize(Value: boolean);
    procedure ControlSetIncrementalDisplay(Value: boolean);
    procedure ControlSetCenter(Value: boolean);
    procedure ControlSetProportional(Value: boolean);
    procedure ControlSetStretch(Value: boolean);
    procedure ControlSetTransparent(Value: boolean);
    procedure ControlSetPicture(Value: TPicture);
    procedure ControlSetGraphic(Value: TGraphic);
    function ControlGetPicture: TPicture;

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);
  end;

  // (rom) TScrollBox or TcxScrollBox?
  TJvDynControlCxScrollBox = class (TScrollBox, IJvDynControl)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

  end;

  // (rom) TLabel or TcxLabel?
  TJvDynControlCxLabel = class (TLabel, IUnknown, IJvDynControl, IJvDynControlLabel,
    IJvDynControlDevExpCx)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetFocusControl(Value: TWinControl);
    procedure ControlSetWordWrap(Value: boolean);

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);
  end;

  // (rom) Warning! TStaticText and TLabel are very different.
  TJvDynControlCxStaticText = class (TcxLabel, IUnknown, IJvDynControl, IJvDynControlDevExpCx)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);
  end;

  TJvDynControlCxButton = class (TcxButton, IUnknown, IJvDynControl, IJvDynControlButton,
    IJvDynControlDevExpCx)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetCaption(Value: string);
    procedure ControlSetTabOrder(Value: integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);

    procedure ControlSetGlyph(Value: TBitmap);
    procedure ControlSetNumGlyphs(Value: integer);
    procedure ControlSetLayout(Value: TButtonLayout);

    procedure ControlSetCxProperties(Value: TCxDynControlWrapper);
  end;

  TJvDynControlEngine_DevExpCx = class (TJvDynControlEngine)
  private
    FCxProperties: TCxDynControlWrapper;
  protected
    procedure SetcxProperties(Value: TCxDynControlWrapper);
  public
    constructor Create; override;
    destructor Destroy; override;
    function CreateControlClass(AControlClass: TControlClass; AOwner: TComponent; AParentControl: TWinControl; AControlName: string): TControl; override;
  published
    // (rom) please stay with your own casing. You chose "Cx".
    property CxProperties: TCxDynControlWrapper read FCxProperties write FCxProperties;
  end;

function DynControlEngine_DevExpCx: TJvDynControlEngine_DevExpCx;
procedure SetDynControlEngine_DevExpCxDefault;

implementation

uses
  SysUtils, ExtDlgs,
  {$IFDEF COMPILER6_UP}
  Variants,
  {$ENDIF COMPILER6_UP}
  cxControls;

var
  IntDynControlEngine_DevExpCx: TJvDynControlEngine_DevExpCx = nil;

//=== TCxDynControlWrapper ===================================================

constructor TCxDynControlWrapper.Create;
begin
  inherited Create;
  FLookAndFeel     := TcxLookAndFeel.Create(nil);
  FStyleController := TcxEditStyleController.Create(nil);
end;

destructor TCxDynControlWrapper.Destroy;
begin
  FreeAndNil(FLookAndFeel);
  FreeAndNil(FStyleController);
  inherited Destroy;
end;

//=== TJvDynControlCxMaskEdit ================================================

procedure TJvDynControlCxMaskEdit.ControlSetDefaultProperties;
begin
end;

procedure TJvDynControlCxMaskEdit.ControlSetReadOnly(Value: boolean);
begin
  Properties.ReadOnly := Value;
end;

procedure TJvDynControlCxMaskEdit.ControlSetCaption(Value: string);
begin
end;

procedure TJvDynControlCxMaskEdit.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxMaskEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxMaskEdit.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxMaskEdit.ControlSetOnChange(Value: TNotifyEvent);
begin
  Properties.OnChange := Value;
end;

procedure TJvDynControlCxMaskEdit.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TJvDynControlCxMaskEdit.ControlSetValue(Value: variant);
begin
  Text := Value;
end;

function TJvDynControlCxMaskEdit.ControlGetValue: variant;
begin
  Result := Text;
end;

procedure TJvDynControlCxMaskEdit.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;

//=== TJvDynControlCxCalcEdit ================================================

procedure TJvDynControlCxCalcEdit.ControlSetDefaultProperties;
begin
end;

procedure TJvDynControlCxCalcEdit.ControlSetReadOnly(Value: boolean);
begin
  Properties.ReadOnly := Value;
end;

procedure TJvDynControlCxCalcEdit.ControlSetCaption(Value: string);
begin
end;

procedure TJvDynControlCxCalcEdit.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxCalcEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxCalcEdit.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxCalcEdit.ControlSetOnChange(Value: TNotifyEvent);
begin
  Properties.OnChange := Value;
end;

procedure TJvDynControlCxCalcEdit.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TJvDynControlCxCalcEdit.ControlSetValue(Value: variant);
begin
  Self.Value := Value;
end;

function TJvDynControlCxCalcEdit.ControlGetValue: variant;
begin
  Result := Text;
end;

procedure TJvDynControlCxCalcEdit.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;

//=== TJvDynControlCxSpinEdit ================================================

procedure TJvDynControlCxSpinEdit.ControlSetDefaultProperties;
begin
  Text := '0';
end;

procedure TJvDynControlCxSpinEdit.ControlSetReadOnly(Value: boolean);
begin
  Properties.ReadOnly := Value;
end;

procedure TJvDynControlCxSpinEdit.ControlSetCaption(Value: string);
begin
end;

procedure TJvDynControlCxSpinEdit.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxSpinEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxSpinEdit.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxSpinEdit.ControlSetOnChange(Value: TNotifyEvent);
begin
  Properties.OnChange := Value;
end;

procedure TJvDynControlCxSpinEdit.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TJvDynControlCxSpinEdit.ControlSetValue(Value: variant);
begin
  Self.Value := Value;
end;

function TJvDynControlCxSpinEdit.ControlGetValue: variant;
begin
  Result := Value;
end;

procedure TJvDynControlCxSpinEdit.ControlSetIncrement(Value: integer);
begin
  Properties.Increment := Value;
end;

procedure TJvDynControlCxSpinEdit.ControlSetMinValue(Value: double);
begin
  Properties.MinValue := Value;
end;

procedure TJvDynControlCxSpinEdit.ControlSetMaxValue(Value: double);
begin
  Properties.MaxValue := Value;
end;

procedure TJvDynControlCxSpinEdit.ControlSetUseForInteger(Value: boolean);
begin
  if Value then
    Properties.ValueType := vtInt
  else
    Properties.ValueType := vtFloat;
end;

procedure TJvDynControlCxSpinEdit.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;

//=== TJvDynControlCxFileNameEdit ============================================

procedure TJvDynControlCxFileNameEdit.DefaultOnButtonClick(Sender: TObject; AButtonIndex: integer);
begin
  case FDialogKind of
    jdkOpen:
      with TOpenDialog.Create(Self) do
        try
          Options    := FDialogOptions;
          Title      := FDialogTitle;
          Filter     := FFilter;
          FilterIndex := FFilterIndex;
          InitialDir := FInitialDir;
          DefaultExt := FDefaultExt;
          FileName   := ControlGetValue;
          if Execute then
            ControlSetValue(FileName);
        finally
          Free;
        end;
    jdkOpenPicture:
      with TOpenPictureDialog.Create(Self) do
        try
          Options    := FDialogOptions;
          Title      := FDialogTitle;
          Filter     := FFilter;
          FilterIndex := FFilterIndex;
          InitialDir := FInitialDir;
          DefaultExt := FDefaultExt;
          FileName   := ControlGetValue;
          if Execute then
            ControlSetValue(FileName);
        finally
          Free;
        end;
    jdkSave:
      with TSaveDialog.Create(Self) do
        try
          Options    := FDialogOptions;
          Title      := FDialogTitle;
          Filter     := FFilter;
          FilterIndex := FFilterIndex;
          InitialDir := FInitialDir;
          DefaultExt := FDefaultExt;
          FileName   := ControlGetValue;
          if Execute then
            ControlSetValue(FileName);
        finally
          Free;
        end;
    jdkSavePicture:
      with TSavePictureDialog.Create(Self) do
        try
          Options    := FDialogOptions;
          Title      := FDialogTitle;
          Filter     := FFilter;
          FilterIndex := FFilterIndex;
          InitialDir := FInitialDir;
          DefaultExt := FDefaultExt;
          FileName   := ControlGetValue;
          if Execute then
            ControlSetValue(FileName);
        finally
          Free;
        end;
  end;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetDefaultProperties;
begin
  Properties.OnButtonClick := DefaultOnButtonClick;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetReadOnly(Value: boolean);
begin
  Properties.ReadOnly := Value;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetCaption(Value: string);
begin
end;

procedure TJvDynControlCxFileNameEdit.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetOnChange(Value: TNotifyEvent);
begin
  Properties.OnChange := Value;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetOnClick(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxFileNameEdit.ControlSetValue(Value: variant);
begin
  Text := Value;
end;

function TJvDynControlCxFileNameEdit.ControlGetValue: variant;
begin
  Result := Text;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetInitialDir(Value: string);
begin
  FInitialDir := Value;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetDefaultExt(Value: string);
begin
  FDefaultExt := Value;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetDialogTitle(Value: string);
begin
  FDialogTitle := Value;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetDialogOptions(Value: TOpenOptions);
begin
  FDialogOptions := Value;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetFilter(Value: string);
begin
  FFilter := Value;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetFilterIndex(Value: integer);
begin
  FFilterIndex := Value;
end;

procedure TJvDynControlCxFileNameEdit.ControlSetDialogKind(Value: TJvDynControlFileNameDialogKind);
begin
  FDialogKind := Value;
end;

//=== TJvDynControlCxDirectoryEdit ===========================================

procedure TJvDynControlCxDirectoryEdit.DefaultOnButtonClick(Sender: TObject; AButtonIndex: integer);
var
  Dir: string;
  Opt: TSelectDirOpts;
begin
  Dir := FInitialDir;
  if SelectDirectory(Dir, FDialogOptions, HelpContext) then
    ControlSetValue(Dir);
end;

procedure TJvDynControlCxDirectoryEdit.ControlSetDefaultProperties;
begin
  Properties.OnButtonClick := DefaultOnButtonClick;
end;

procedure TJvDynControlCxDirectoryEdit.ControlSetReadOnly(Value: boolean);
begin
  Properties.ReadOnly := Value;
end;

procedure TJvDynControlCxDirectoryEdit.ControlSetCaption(Value: string);
begin
end;

procedure TJvDynControlCxDirectoryEdit.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxDirectoryEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxDirectoryEdit.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxDirectoryEdit.ControlSetOnChange(Value: TNotifyEvent);
begin
  Properties.OnChange := Value;
end;

procedure TJvDynControlCxDirectoryEdit.ControlSetOnClick(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxDirectoryEdit.ControlSetValue(Value: variant);
begin
  Text := Value;
end;

function TJvDynControlCxDirectoryEdit.ControlGetValue: variant;
begin
  Result := Text;
end;

procedure TJvDynControlCxDirectoryEdit.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;

procedure TJvDynControlCxDirectoryEdit.ControlSetInitialDir(Value: string);
begin
  FInitialDir := Value;
end;

procedure TJvDynControlCxDirectoryEdit.ControlSetDialogTitle(Value: string);
begin
  FDialogTitle := Value;
end;

procedure TJvDynControlCxDirectoryEdit.ControlSetDialogOptions(Value: TSelectDirOpts);
begin
  FDialogOptions := Value;
end;

//=== TJvDynControlCxDateTimeEdit ============================================

procedure TJvDynControlCxDateTimeEdit.ControlSetDefaultProperties;
begin
  Properties.ShowTime  := true;
  Properties.SaveTime  := true;
  Properties.InputKind := ikStandard;
end;

procedure TJvDynControlCxDateTimeEdit.ControlSetReadOnly(Value: boolean);
begin
  Properties.ReadOnly := Value;
end;

procedure TJvDynControlCxDateTimeEdit.ControlSetCaption(Value: string);
begin
end;

procedure TJvDynControlCxDateTimeEdit.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxDateTimeEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxDateTimeEdit.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxDateTimeEdit.ControlSetOnChange(Value: TNotifyEvent);
begin
  Properties.OnChange := Value;
end;

procedure TJvDynControlCxDateTimeEdit.ControlSetOnClick(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxDateTimeEdit.ControlSetValue(Value: variant);
begin
  Text := Value;
end;

function TJvDynControlCxDateTimeEdit.ControlGetValue: variant;
begin
  Result := Text;
end;

// IJvDynControlDate
procedure TJvDynControlCxDateTimeEdit.ControlSetMinDate(Value: TDateTime);
begin
  Properties.MinDate := Value;
end;

procedure TJvDynControlCxDateTimeEdit.ControlSetMaxDate(Value: TDateTime);
begin
  Properties.MaxDate := Value;
end;

procedure TJvDynControlCxDateTimeEdit.ControlSetFormat(Value: string);
begin
//  Format := Value;
end;

procedure TJvDynControlCxDateTimeEdit.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;

//=== TJvDynControlCxDateEdit ============================================

procedure TJvDynControlCxDateEdit.ControlSetDefaultProperties;
begin
  Properties.ShowTime  := false;
  Properties.SaveTime  := false;
  Properties.InputKind := ikStandard;
end;

procedure TJvDynControlCxDateEdit.ControlSetReadOnly(Value: boolean);
begin
  Properties.ReadOnly := Value;
end;

procedure TJvDynControlCxDateEdit.ControlSetCaption(Value: string);
begin
end;

procedure TJvDynControlCxDateEdit.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxDateEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxDateEdit.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxDateEdit.ControlSetOnChange(Value: TNotifyEvent);
begin
  Properties.OnChange := Value;
end;

procedure TJvDynControlCxDateEdit.ControlSetOnClick(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxDateEdit.ControlSetValue(Value: variant);
begin
  Text := Value;
end;

function TJvDynControlCxDateEdit.ControlGetValue: variant;
begin
  Result := Text;
end;

// IJvDynControlDate
procedure TJvDynControlCxDateEdit.ControlSetMinDate(Value: TDateTime);
begin
  Properties.MinDate := Value;
end;

procedure TJvDynControlCxDateEdit.ControlSetMaxDate(Value: TDateTime);
begin
  Properties.MaxDate := Value;
end;

procedure TJvDynControlCxDateEdit.ControlSetFormat(Value: string);
begin
//  Format := Value;
end;

procedure TJvDynControlCxDateEdit.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;


//=== TJvDynControlCxTimeEdit ============================================

procedure TJvDynControlCxTimeEdit.ControlSetDefaultProperties;
begin
  Properties.ShowDate := false;
  Properties.UseCtrlIncrement := true;
end;

procedure TJvDynControlCxTimeEdit.ControlSetReadOnly(Value: boolean);
begin
  Properties.ReadOnly := Value;
end;

procedure TJvDynControlCxTimeEdit.ControlSetCaption(Value: string);
begin
end;

procedure TJvDynControlCxTimeEdit.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxTimeEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxTimeEdit.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxTimeEdit.ControlSetOnChange(Value: TNotifyEvent);
begin
  Properties.OnChange := Value;
end;

procedure TJvDynControlCxTimeEdit.ControlSetOnClick(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxTimeEdit.ControlSetValue(Value: variant);
begin
  Text := Value;
end;

function TJvDynControlCxTimeEdit.ControlGetValue: variant;
begin
  Result := Text;
end;

procedure TJvDynControlCxTimeEdit.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;

procedure TJvDynControlCxTimeEdit.ControlSetFormat(Value: string);
begin
//  Properties.Format := Value;
  Properties.Use24HourFormat := (Pos('H', Value) > 0);
  if (Pos('s', Value) > 0) then
    Properties.TimeFormat := tfHourMinSec
  else if (Pos('m', Value) > 0) then
    Properties.TimeFormat := tfHourMin
  else
    Properties.TimeFormat := tfHour;
end;


//=== TJvDynControlCxCheckBox ================================================

procedure TJvDynControlCxCheckBox.ControlSetDefaultProperties;
begin
end;

procedure TJvDynControlCxCheckbox.ControlSetReadOnly(Value: boolean);
begin
end;

procedure TJvDynControlCxCheckbox.ControlSetCaption(Value: string);
begin
  Caption := Value;
end;

procedure TJvDynControlCxCheckbox.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxCheckbox.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxCheckbox.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxCheckbox.ControlSetOnChange(Value: TNotifyEvent);
begin
  Properties.OnChange := Value;
end;

procedure TJvDynControlCxCheckbox.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TJvDynControlCxCheckbox.ControlSetValue(Value: variant);
begin
  if VarType(Value) = varBoolean then
    Checked := Value
  else
    Checked := UpperCase(Value) = 'TRUE';
end;

function TJvDynControlCxCheckbox.ControlGetValue: variant;
begin
  Result := Checked;
end;

procedure TJvDynControlCxCheckbox.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;

//=== TJvDynControlCxMemo ====================================================

procedure TJvDynControlCxMemo.ControlSetDefaultProperties;
begin
end;

procedure TJvDynControlCxMemo.ControlSetReadOnly(Value: boolean);
begin
  Properties.ReadOnly := Value;
end;

procedure TJvDynControlCxMemo.ControlSetCaption(Value: string);
begin
end;

procedure TJvDynControlCxMemo.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxMemo.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxMemo.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxMemo.ControlSetOnChange(Value: TNotifyEvent);
begin
  Properties.OnChange := Value;
end;

procedure TJvDynControlCxMemo.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TJvDynControlCxMemo.ControlSetValue(Value: variant);
begin
  Text := Value;
end;

function TJvDynControlCxMemo.ControlGetValue: variant;
begin
  Result := Text;
end;

procedure TJvDynControlCxMemo.ControlSetSorted(Value: boolean);
begin
end;

procedure TJvDynControlCxMemo.ControlSetItems(Value: TStrings);
begin
  Lines.Assign(Value);
end;

function TJvDynControlCxMemo.ControlGetItems: TStrings;
begin
  Result := Lines;
end;

procedure TJvDynControlCxMemo.ControlSetWantTabs(Value: boolean);
begin
  Properties.WantTabs := Value;
end;

procedure TJvDynControlCxMemo.ControlSetWantReturns(Value: boolean);
begin
  Properties.WantReturns := Value;
end;

procedure TJvDynControlCxMemo.ControlSetWordWrap(Value: boolean);
begin
  Properties.WordWrap := Value;
end;

procedure TJvDynControlCxMemo.ControlSetScrollBars(Value: TScrollStyle);
begin
  Properties.ScrollBars := Value;
end;

procedure TJvDynControlCxMemo.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;

//=== TJvDynControlCxRadioGroup ==============================================

procedure TJvDynControlCxRadioGroup.ControlSetDefaultProperties;
begin
end;

procedure TJvDynControlCxRadioGroup.ControlSetReadOnly(Value: boolean);
begin
  Properties.ReadOnly := Value;
end;

procedure TJvDynControlCxRadioGroup.ControlSetCaption(Value: string);
begin
end;

procedure TJvDynControlCxRadioGroup.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxRadioGroup.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxRadioGroup.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxRadioGroup.ControlSetOnChange(Value: TNotifyEvent);
begin
  Properties.OnChange := Value;
end;

procedure TJvDynControlCxRadioGroup.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TJvDynControlCxRadioGroup.ControlSetValue(Value: variant);
begin
  if VarType(Value) in [varSmallint, varInteger] then
    ItemIndex := Value
  else
    try
      ItemIndex := Value
    except
        // on E: Exception do
        // ItemIndex := Properties.Items. IndexOf(Value);
    end;
end;

function TJvDynControlCxRadioGroup.ControlGetValue: variant;
begin
  Result := ItemIndex;
end;

procedure TJvDynControlCxRadioGroup.ControlSetSorted(Value: boolean);
begin
end;

procedure TJvDynControlCxRadioGroup.ControlSetItems(Value: TStrings);
var
  I:    integer;
  Item: TcxRadioGroupItem;
begin
  Properties.Items.Clear;
  for I := 0 to Value.Count - 1 do
  begin
    Item := TcxRadioGroupItem(Properties.Items.Add);
    Item.Caption := Value[I];
  end;
end;

function TJvDynControlCxRadioGroup.ControlGetItems: TStrings;
begin
//  Result := TStrings(Properties.Items);
end;

procedure TJvDynControlCxRadioGroup.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;

procedure TJvDynControlCxRadioGroup.ControlSetColumns(Value: integer);
begin
  Properties.Columns := Value;
end;

//=== TJvDynControlCxListBox =================================================

procedure TJvDynControlCxListBox.ControlSetDefaultProperties;
begin
end;

procedure TJvDynControlCxListBox.ControlSetReadOnly(Value: boolean);
begin
//  Properties.ReadOnly := Value;
end;

procedure TJvDynControlCxListBox.ControlSetCaption(Value: string);
begin
end;

procedure TJvDynControlCxListBox.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxListBox.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxListBox.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxListBox.ControlSetOnChange(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxListBox.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TJvDynControlCxListBox.ControlSetValue(Value: variant);
begin
  if VarType(Value) in [varSmallint, varInteger] then
    ItemIndex := Value
  else
    try
      ItemIndex := Value
    except
      on E: Exception do
        ItemIndex := Items.IndexOf(Value);
    end;
end;

function TJvDynControlCxListBox.ControlGetValue: variant;
begin
  Result := ItemIndex;
end;

procedure TJvDynControlCxListBox.ControlSetSorted(Value: boolean);
begin
  Sorted := Value;
end;

procedure TJvDynControlCxListBox.ControlSetItems(Value: TStrings);
begin
  Items.Assign(Value);
end;

function TJvDynControlCxListBox.ControlGetItems: TStrings;
begin
  Result := Items;
end;

procedure TJvDynControlCxListBox.ControlSetOnDblClick(Value: TNotifyEvent);
begin
  OnDblClick := Value;
end;

procedure TJvDynControlCxListBox.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;

//=== TJvDynControlCxComboBox ================================================

procedure TJvDynControlCxComboBox.ControlSetDefaultProperties;
begin
end;

procedure TJvDynControlCxComboBox.ControlSetReadOnly(Value: boolean);
begin
  Properties.ReadOnly := Value;
end;

procedure TJvDynControlCxComboBox.ControlSetCaption(Value: string);
begin
end;

procedure TJvDynControlCxComboBox.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxComboBox.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxComboBox.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxComboBox.ControlSetOnChange(Value: TNotifyEvent);
begin
  Properties.OnChange := Value;
end;

procedure TJvDynControlCxComboBox.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TJvDynControlCxComboBox.ControlSetValue(Value: variant);
begin
  Text := Value;
end;

function TJvDynControlCxComboBox.ControlGetValue: variant;
begin
  Result := Text;
end;

procedure TJvDynControlCxComboBox.ControlSetSorted(Value: boolean);
begin
  Properties.Sorted := Value;
end;

procedure TJvDynControlCxComboBox.ControlSetItems(Value: TStrings);
begin
  Properties.Items.Assign(Value);
end;

function TJvDynControlCxComboBox.ControlGetItems: TStrings;
begin
  Result := Properties.Items;
end;

procedure TJvDynControlCxComboBox.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;

procedure TJvDynControlCxComboBox.ControlSetNewEntriesAllowed(Value: boolean);
begin
  if Value then
    Properties.DropDownListStyle := lsEditList
  else
    Properties.DropDownListStyle := lsEditFixedList;
end;

//=== TJvDynControlCxPanel ===================================================

procedure TJvDynControlCxPanel.ControlSetDefaultProperties;
begin
end;

procedure TJvDynControlCxPanel.ControlSetCaption(Value: string);
begin
  Caption := Value;
end;

procedure TJvDynControlCxPanel.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxPanel.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxPanel.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxPanel.ControlSetOnClick(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxPanel.ControlSetBorder(ABevelInner: TPanelBevel; ABevelOuter: TPanelBevel; ABevelWidth: integer; ABorderStyle: TBorderStyle; ABorderWidth: integer);
begin
  BorderWidth := ABorderWidth;
  BorderStyle := ABorderStyle;
  BevelInner  := ABevelInner;
  BevelOuter  := ABevelOuter;
  BevelWidth  := ABevelWidth;
end;

//=== TJvDynControlCxImage ===================================================

procedure TJvDynControlCxImage.ControlSetDefaultProperties;
begin
  //Properties.GraphicTransparency := gtOpaque;
  ParentColor := true;
end;

procedure TJvDynControlCxImage.ControlSetCaption(Value: string);
begin
  Properties.Caption := Value;
end;

procedure TJvDynControlCxImage.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxImage.ControlSetOnEnter(Value: TNotifyEvent);
begin
//  OnEnter := Value;
end;

procedure TJvDynControlCxImage.ControlSetOnExit(Value: TNotifyEvent);
begin
//  OnExit := Value;
end;

procedure TJvDynControlCxImage.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TJvDynControlCxImage.ControlSetAutoSize(Value: boolean);
begin
  AutoSize := Value;
end;

procedure TJvDynControlCxImage.ControlSetIncrementalDisplay(Value: boolean);
begin
//  Properties.IncrementalDisplay := Value;
end;

procedure TJvDynControlCxImage.ControlSetCenter(Value: boolean);
begin
  Properties.Center := Value;
end;

procedure TJvDynControlCxImage.ControlSetProportional(Value: boolean);
begin
//  Properties.Proportional := Value;
end;

procedure TJvDynControlCxImage.ControlSetStretch(Value: boolean);
begin
  Properties.Stretch := Value;
end;

procedure TJvDynControlCxImage.ControlSetTransparent(Value: boolean);
begin
  if Value then
    Properties.GraphicTransparency := gtDefault
  else
    Properties.GraphicTransparency := gtTransparent;
end;

procedure TJvDynControlCxImage.ControlSetPicture(Value: TPicture);
begin
  Picture.Assign(Value);
end;

procedure TJvDynControlCxImage.ControlSetGraphic(Value: TGraphic);
begin
  Picture.Assign(Value);
end;

function TJvDynControlCxImage.ControlGetPicture: TPicture;
begin
  Result := Picture;
end;

procedure TJvDynControlCxImage.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
  Style.StyleController.Style.BorderStyle := ebsNone;
end;

//=== TJvDynControlCxScrollBox ===============================================

procedure TJvDynControlCxScrollBox.ControlSetDefaultProperties;
begin
end;

procedure TJvDynControlCxScrollBox.ControlSetCaption(Value: string);
begin
  Caption := Value;
end;

procedure TJvDynControlCxScrollBox.ControlSetTabOrder(Value: integer);
begin
  TabOrder := Value;
end;

procedure TJvDynControlCxScrollBox.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TJvDynControlCxScrollBox.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TJvDynControlCxScrollBox.ControlSetOnClick(Value: TNotifyEvent);
begin
end;

//=== TJvDynControlCxLabel ===================================================

procedure TJvDynControlCxLabel.ControlSetDefaultProperties;
begin
end;

procedure TJvDynControlCxLabel.ControlSetCaption(Value: string);
begin
  Caption := Value;
end;

procedure TJvDynControlCxLabel.ControlSetTabOrder(Value: integer);
begin
end;

procedure TJvDynControlCxLabel.ControlSetOnEnter(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxLabel.ControlSetOnExit(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxLabel.ControlSetOnClick(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxLabel.ControlSetFocusControl(Value: TWinControl);
begin
  FocusControl := Value;
end;

procedure TJvDynControlCxLabel.ControlSetWordWrap(Value: boolean);
begin
//  Properties.WordWrap := Value;
  WordWrap := Value;
end;

procedure TJvDynControlCxLabel.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
//  LookAndFeel.Assign(Value.LookandFeel);
end;

//=== TJvDynControlCxStaticText ==============================================

procedure TJvDynControlCxStaticText.ControlSetDefaultProperties;
begin
end;

procedure TJvDynControlCxStaticText.ControlSetCaption(Value: string);
begin
  Caption := Value;
end;

procedure TJvDynControlCxStaticText.ControlSetTabOrder(Value: integer);
begin
end;

procedure TJvDynControlCxStaticText.ControlSetOnEnter(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxStaticText.ControlSetOnExit(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxStaticText.ControlSetOnClick(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxStaticText.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  Style.LookAndFeel.Assign(Value.LookAndFeel);
  Style.StyleController := Value.StyleController;
end;

//=== TJvDynControlCxButton ==================================================

procedure TJvDynControlCxButton.ControlSetDefaultProperties;
begin
end;

procedure TJvDynControlCxButton.ControlSetCaption(Value: string);
begin
  Caption := Value;
end;

procedure TJvDynControlCxButton.ControlSetTabOrder(Value: integer);
begin
end;

procedure TJvDynControlCxButton.ControlSetOnEnter(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxButton.ControlSetOnExit(Value: TNotifyEvent);
begin
end;

procedure TJvDynControlCxButton.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TJvDynControlCxButton.ControlSetGlyph(Value: TBitmap);
begin
  Glyph.Assign(Value);
end;

procedure TJvDynControlCxButton.ControlSetNumGlyphs(Value: integer);
begin
  NumGlyphs := Value;
end;

procedure TJvDynControlCxButton.ControlSetLayout(Value: TButtonLayout);
begin
  Layout := Value;
end;

procedure TJvDynControlCxButton.ControlSetCxProperties(Value: TCxDynControlWrapper);
begin
  LookAndFeel.Assign(Value.LookAndFeel);
end;

//=== TJvDynControlEngine_DevExpCx ===========================================

constructor TJvDynControlEngine_DevExpCx.Create;
begin
  inherited Create;
  FCxProperties := TCxDynControlWrapper.Create;
end;

destructor TJvDynControlEngine_DevExpCx.Destroy;
begin
  FreeAndNil(FCxProperties);
  inherited Destroy;
end;

procedure TJvDynControlEngine_DevExpCx.SetcxProperties(Value: TCxDynControlWrapper);
begin
  if Value is TCxDynControlWrapper then
    FCxProperties.LookAndFeel.Assign(Value.LookAndFeel);
end;

function TJvDynControlEngine_DevExpCx.CreateControlClass(AControlClass: TControlClass; AOwner: TComponent; AParentControl: TWinControl; AControlName: string): TControl;
var
  //cx: IJvDynControlDevExpCx;
  C: TControl;
begin
  C := inherited CreateControlClass(AControlClass, AOwner, AParentControl, AControlName);
  if Supports(C, IJvDynControlDevExpCx) then
    with C as IJvDynControlDevExpCx do
      ControlSetCxProperties(cxProperties);
  Result := C;
//    cx.ControlSetLookAndFeel(LookAndFeel);
end;

//=== DynControlEngine_DevExpCx ==============================================

function DynControlEngine_DevExpCx: TJvDynControlEngine_DevExpCx;
begin
  Result := IntDynControlEngine_DevExpCx;
end;

procedure SetDynControlEngine_DevExpCxDefault;
begin
  SetDefaultDynControlEngine(IntDynControlEngine_DevExpCx);
end;

initialization
  IntDynControlEngine_DevExpCx := TJvDynControlEngine_DevExpCx.Create;
  IntDynControlEngine_DevExpCx.RegisterControl(jctLabel, TJvDynControlCxLabel);
  IntDynControlEngine_DevExpCx.RegisterControl(jctStaticText, TJvDynControlCxStaticText);
  IntDynControlEngine_DevExpCx.RegisterControl(jctButton, TJvDynControlCxButton);
  IntDynControlEngine_DevExpCx.RegisterControl(jctScrollBox, TJvDynControlCxScrollBox);
  IntDynControlEngine_DevExpCx.RegisterControl(jctPanel, TJvDynControlCxPanel);
  IntDynControlEngine_DevExpCx.RegisterControl(jctImage, TJvDynControlCxImage);
  IntDynControlEngine_DevExpCx.RegisterControl(jctCheckBox, TJvDynControlCxCheckBox);
  IntDynControlEngine_DevExpCx.RegisterControl(jctComboBox, TJvDynControlCxComboBox);
  IntDynControlEngine_DevExpCx.RegisterControl(jctListBox, TJvDynControlCxListBox);
  IntDynControlEngine_DevExpCx.RegisterControl(jctRadioGroup, TJvDynControlCxRadioGroup);
  IntDynControlEngine_DevExpCx.RegisterControl(jctDateTimeEdit, TJvDynControlCxDateTimeEdit);
  IntDynControlEngine_DevExpCx.RegisterControl(jctTimeEdit, TJvDynControlCxTimeEdit);
  IntDynControlEngine_DevExpCx.RegisterControl(jctDateEdit, TJvDynControlCxDateEdit);
  IntDynControlEngine_DevExpCx.RegisterControl(jctEdit, TJvDynControlCxMaskEdit);
  IntDynControlEngine_DevExpCx.RegisterControl(jctCalculateEdit, TJvDynControlCxCalcEdit);
  IntDynControlEngine_DevExpCx.RegisterControl(jctSpinEdit, TJvDynControlCxSpinEdit);
  IntDynControlEngine_DevExpCx.RegisterControl(jctDirectoryEdit, TJvDynControlCxDirectoryEdit);
  IntDynControlEngine_DevExpCx.RegisterControl(jctFileNameEdit, TJvDynControlCxFileNameEdit);
  IntDynControlEngine_DevExpCx.RegisterControl(jctMemo, TJvDynControlCxMemo);
  SetDefaultDynControlEngine(IntDynControlEngine_DevExpCx);

finalization
  FreeAndNil(IntDynControlEngine_DevExpCx);

end.
