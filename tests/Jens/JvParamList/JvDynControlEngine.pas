{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Initial Developer of the Original Code is Jens Fudickar [jens.fudickar@oratool.de]
All Rights Reserved.

Contributor(s):
Jens Fudickar [jens.fudickar@oratool.de]

Last Modified: 2003-11-03

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvDynControlEngine;

interface

uses
  Classes, Controls, Forms, StdCtrls, Graphics, Buttons,
  JvDynControlEngine_Interface;

type
  TJvDynControlType =
   (jctLabel,jctStaticText, jctPanel, jctScrollBox,
    jctEdit, jctCheckBox, jctComboBox, jctGroupBox, jctImage, jctRadioGroup,
    jctMemo, jctListBox, jctDateTimeEdit, jctDateEdit, jctTimeEdit,
    jctCalculateEdit, jctSpinEdit, jctDirectoryEdit, jctFileNameEdit,
    jctButton, jctForm);

  TJvDynControlEngine = class(TPersistent)
  private
    FRegisteredControlTypes: array [TJvDynControlType] of TControlClass;
    function GetPropName(Instance: TPersistent; Index: Integer): string;
    function GetPropCount(Instance: TPersistent): Integer;
  protected
    procedure SetPropertyValue(const APersistent: TPersistent; const APropertyName: string; const AValue: Variant);
    function GetPropertyValue(const APersistent: TPersistent; const APropertyName: string): Variant;
    procedure AfterCreateControl (aControl : TControl); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function CreateControl(AControlType: TJvDynControlType; AOwner: TComponent;
      AParentControl: TWinControl; AControlName: string): TControl; virtual;
    function CreateControlClass(AControlClass: TControlClass; AOwner: TComponent;
      AParentControl: TWinControl; AControlName: string): TControl; virtual;
    function CreateLabelControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string; ACaption: string; AFocusControl: TWinControl): TControl; virtual;
    function CreateStaticTextControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string; ACaption: string): TWinControl; virtual;
    function CreatePanelControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string; ACaption: string; AAlign: TAlign): TWinControl; virtual;
    function CreateScrollBoxControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string): TWinControl; virtual;
    function CreateEditControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string): TWinControl; virtual;
    function CreateCheckboxControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string; ACaption: string): TWinControl; virtual;
    function CreateComboBoxControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string; AItems: TStrings): TWinControl; virtual;
    function CreateGroupBoxControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string; ACaption: string): TWinControl; virtual;
    function CreateImageControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string): TWinControl; virtual;
    function CreateRadioGroupControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string; ACaption: string; AItems: TStrings;
      AItemIndex: Integer = 0): TWinControl; virtual;
    // function CreatePageControlControl(AOwner: TComponent; AParentControl: TWinControl; AControlName: string): TWinControl; virtual;
    function CreateMemoControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string): TWinControl; virtual;
    function CreateListBoxControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string; AItems: TStrings): TWinControl; virtual;
    function CreateDateTimeControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string): TWinControl; virtual;
    function CreateDateControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string): TWinControl; virtual;
    function CreateTimeControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string): TWinControl; virtual;
    function CreateCalculateControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string): TWinControl; virtual;
    function CreateSpinControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string): TWinControl; virtual;
    function CreateDirectoryControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string): TWinControl; virtual;
    function CreateFileNameControl(AOwner: TComponent; AParentControl: TWinControl;
      AControlName: string): TWinControl; virtual;
    function CreateButton(AOwner: TComponent; AParentControl: TWinControl;
      AButtonName: string; ACaption: string; AHint: string;
      AOnClick: TNotifyEvent; ADefault: Boolean = False;
      ACancel: Boolean = False): TButton; virtual;
    function CreateForm(ACaption: string; AHint: string): TCustomForm; virtual;

    function IsControlTypeRegistered (const ADynControlType: TJvDynControlType) : Boolean;

    procedure RegisterControl(const ADynControlType: TJvDynControlType;
      AControlClass: TControlClass); virtual;

    procedure SetControlCaption(AControl: IJvDynControl; Value: string);
    procedure SetControlTabOrder(AControl: IJvDynControl; Value: Integer);

    procedure SetControlOnEnter(AControl: IJvDynControl; Value: TNotifyEvent);
    procedure SetControlOnExit(AControl: IJvDynControl; Value: TNotifyEvent);
    procedure SetControlOnClick(AControl: IJvDynControl; Value: TNotifyEvent);
  end;

{$IFNDEF COMPILER6_UP}
function Supports(Instance: TObject; const Intf: TGUID): Boolean; overload;
function Supports(AClass: TClass; const Intf: TGUID): Boolean; overload;
{$ENDIF COMPILER6_UP}
function IntfCast(Instance: TObject; const Intf: TGUID): IUnknown;
procedure SetDefaultDynControlEngine(AEngine: TJvDynControlEngine);
function DefaultDynControlEngine: TJvDynControlEngine;

resourcestring
  SIntfCastError = 'SIntfCastError';

implementation

uses
  TypInfo, SysUtils,
  {$IFDEF COMPILER6_UP}
  Variants,
  {$ENDIF COMPILER6_UP}
  JvTypes, JVDynControlEngine_VCL;

resourcestring
  SUnsupportedControlClass = 'TJvDynControlEngine.RegisterControl: Unsupported ControlClass';
  SNoRegisteredControlClass = 'TJvDynControlEngine.CreateControl: No Registered ControlClass';

var
  GlobalDefaultDynControlEngine: TJvDynControlEngine = nil;

{$IFNDEF COMPILER6_UP}

function Supports(Instance: TObject; const Intf: TGUID): Boolean;
begin
  Result := Instance.GetInterfaceEntry(Intf) <> nil;
end;

function Supports(AClass: TClass; const Intf: TGUID): Boolean;
begin
  Result := AClass.GetInterfaceEntry(Intf) <> nil;
end;

{$ENDIF COMPILER6_UP}

function IntfCast(Instance: TObject; const Intf: TGUID): IUnknown;
begin
  if not Supports(Instance, Intf, Result) then
    raise EIntfCastError.Create(SIntfCastError);
end;

constructor TJvDynControlEngine.Create;
begin
  inherited Create;
end;

destructor TJvDynControlEngine.Destroy;
begin
  inherited Destroy;
end;

function TJvDynControlEngine.IsControlTypeRegistered (const ADynControlType: TJvDynControlType) : Boolean;
begin
  Result := Assigned(FRegisteredControlTypes[ADynControlType]);
end;

procedure TJvDynControlEngine.RegisterControl(const ADynControlType: TJvDynControlType;
  AControlClass: TControlClass);
var
  Valid: Boolean;
begin
  FRegisteredControlTypes[ADynControlType] := nil;
  Valid := Supports(AControlClass, IJvDynControl);
  case ADynControlType of
    jctButton:
      Valid := Valid and Supports(AControlClass, IJvDynControlButton);
    jctPanel:
      Valid := Valid and Supports(AControlClass, IJvDynControlPanel);
    jctLabel:
      Valid := Valid and Supports(AControlClass, IJvDynControlLabel);
    jctMemo:
      Valid := Valid and
        Supports(AControlClass, IJvDynControlItems) and
        Supports(AControlClass, IJvDynControlData) and
        Supports(AControlClass, IJvDynControlMemo);
    jctRadioGroup, jctComboBox:
      Valid := Valid and
        Supports(AControlClass, IJvDynControlItems) and
        Supports(AControlClass, IJvDynControlData);
    jctEdit, jctCalculateEdit, jctSpinEdit, jctFilenameEdit, jctDirectoryEdit,
    jctCheckBox, jctDateTimeEdit, jctDateEdit, jctTimeEdit:
      Valid := Valid and Supports(AControlClass, IJvDynControlData);
  end;
  if Valid then
    FRegisteredControlTypes[ADynControlType] := AControlClass
  else
    raise EJVCLException.Create(SUnsupportedControlClass);
end;

function TJvDynControlEngine.GetPropCount(Instance: TPersistent): Integer;
var
  Data: PTypeData;
begin
  Data := GetTypeData(Instance.ClassInfo);
  Result := Data^.PropCount;
end;

function TJvDynControlEngine.GetPropName(Instance: TPersistent; Index: Integer): string;
var
  PropList: PPropList;
  PropInfo: PPropInfo;
  Data: PTypeData;
begin
  Result := '';
  Data := GetTypeData(Instance.ClassInfo);
  GetMem(PropList, Data^.PropCount * SizeOf(PPropInfo));
  try
    GetPropInfos(Instance.ClassInfo, PropList);
    PropInfo := PropList^[Index];
    Result := PropInfo^.Name;
  finally
    FreeMem(PropList, Data^.PropCount * SizeOf(PPropInfo));
  end;
end;

procedure TJvDynControlEngine.SetPropertyValue(const APersistent: TPersistent;
  const APropertyName: string; const AValue: Variant);
var
  Index: Integer;
  PropName: string;
  SubObj: TObject;
  P: Integer;
  SearchName: string;
  LastName: string;
begin
  SearchName := Trim(APropertyName);
  P := Pos('.', SearchName);
  if P > 0 then
  begin
    LastName := Trim(Copy(SearchName, P + 1, Length(SearchName) - P));
    SearchName := Trim(Copy(SearchName, 1, P - 1));
  end
  else
    LastName := '';
  for Index := 0 to GetPropCount(APersistent) - 1 do
  begin
    PropName := UpperCase(GetPropName(APersistent, Index));
    if not (UpperCase(SearchName) = PropName) then
      Continue;
    case PropType(APersistent, PropName) of
      tkLString, tkWString, tkString:
        SetStrProp(APersistent, PropName, VarToStr(AValue));
      tkEnumeration, tkSet, tkChar, tkInteger:
        SetOrdProp(APersistent, PropName, AValue);
//      tkInt64:
//        SetInt64Prop(APersistent, PropName, AValue);
      tkFloat:
        SetFloatProp(APersistent, PropName, AValue);
      tkClass:
        begin
          SubObj := GetObjectProp(APersistent, PropName);
          if SubObj is TStrings then
            TStrings(SubObj).Text := AValue
          else
          if (SubObj is TPersistent) and (LastName <> '') then
            SetPropertyValue(TPersistent(SubObj), LastName, AValue);
        end;
    end;
  end;
end;

function TJvDynControlEngine.GetPropertyValue(const APersistent: TPersistent;
  const APropertyName: string): Variant;
var
  Index: Integer;
  PropName: string;
  SubObj: TObject;
  P: Integer;
  SearchName: string;
  LastName: string;
begin
  SearchName := Trim(APropertyName);
  P := Pos('.', SearchName);
  if P > 0 then
  begin
    LastName := Trim(Copy(SearchName, P + 1, Length(SearchName) - P));
    SearchName := Trim(Copy(SearchName, 1, P - 1));
  end
  else
    LastName := '';
  for Index := 0 to GetPropCount(APersistent) - 1 do
  begin
    PropName := UpperCase(GetPropName(APersistent, Index));
    if not (UpperCase(SearchName) = PropName) then
      Continue;
    case PropType(APersistent, PropName) of
      tkLString, tkWString, tkString:
        Result := GetStrProp(APersistent, PropName);
      tkEnumeration, tkSet, tkChar, tkInteger:
        Result := GetOrdProp(APersistent, PropName);
      tkInt64:
        {$IFDEF COMPILER6_UP}
        Result := GetInt64Prop(APersistent, PropName);
       {$ELSE}
        Result := Null;
       {$ENDIF COMPILER6_UP}
      tkFloat:
        Result := GetFloatProp(APersistent, PropName);
      tkClass:
        begin
          SubObj := GetObjectProp(APersistent, PropName);
          if SubObj is TStrings then
            Result := TStrings(SubObj).Text
          else
          if (SubObj is TPersistent) and (LastName <> '') then
            Result := GetPropertyValue(TPersistent(SubObj), LastName);
        end;
    end;
  end;
end;

procedure TJvDynControlEngine.AfterCreateControl (aControl : TControl);
begin
end;

function TJvDynControlEngine.CreateControl(AControlType: TJvDynControlType;
  AOwner: TComponent; AParentControl: TWinControl; AControlName: string): TControl;
var
  Control: TControl;
begin
  if Assigned(FRegisteredControlTypes[AControlType]) then
    Result := CreateControlClass(FRegisteredControlTypes[AControlType], AOwner,
      AParentControl, AControlName)
  else
  if AControlType = jctForm then
  begin
    Result := TControl(TForm.Create(AOwner));
    if AControlName <> '' then
      Result.Name := AControlName;
  end
  else
    Result := nil;
  AfterCreateControl (Result);
  if Result = nil then
    raise EJVCLException.Create(SNoRegisteredControlClass);
end;

function TJvDynControlEngine.CreateControlClass(AControlClass: TControlClass;
  AOwner: TComponent; AParentControl: TWinControl; AControlName: string): TControl;
var
  DynCtrl: IJvDynControl;
begin
  Result := TControl(AControlClass.Create(AOwner));
  if not Supports(Result, IJvDynControl, DynCtrl) then
    raise EIntfCastError.Create(SIntfCastError);
  with DynCtrl do
    ControlSetDefaultProperties;
  if Assigned(AParentControl) then
    Result.Parent := AParentControl;
  if AControlName <> '' then
    Result.Name := AControlName;
end;

function TJvDynControlEngine.CreateLabelControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string; ACaption: string;
  AFocusControl: TWinControl): TControl;
var
  DynCtrl: IJvDynControl;
begin
  Result := CreateControl(jctLabel, AOwner, AParentControl, AControlName);
  if not Supports(Result, IJvDynControl, DynCtrl) then
    raise EIntfCastError.Create(SIntfCastError);
  with DynCtrl do
    ControlSetCaption(ACaption);
  with DynCtrl as IJvDynControlLabel do
    ControlSetFocusControl(AFocusControl);
end;

function TJvDynControlEngine.CreateStaticTextControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string; ACaption: string): TWinControl;
var
  DynCtrl: IJvDynControl;
begin
  Result := TWinControl(CreateControl(jctStaticText, AOwner, AParentControl, AControlName));
  if not Supports(Result, IJvDynControl, DynCtrl) then
    raise EIntfCastError.Create(SIntfCastError);
  with DynCtrl do
    ControlSetCaption(ACaption);
end;

function TJvDynControlEngine.CreatePanelControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string;
  ACaption: string; AAlign: TAlign): TWinControl;
var
  DynCtrl: IJvDynControl;
begin
  Result := TWinControl(CreateControl(jctPanel, AOwner, AParentControl, AControlName));
  if not Supports(Result, IJvDynControl, DynCtrl) then
    raise EIntfCastError.Create(SIntfCastError);
  with DynCtrl do
    ControlSetCaption(ACaption);
  Result.Align := AAlign;
end;

function TJvDynControlEngine.CreateScrollBoxControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string): TWinControl;
begin
  Result := TWinControl(CreateControl(jctScrollBox, AOwner, AParentControl, AControlName));
end;

function TJvDynControlEngine.CreateEditControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string): TWinControl;
begin
  Result := TWinControl(CreateControl(jctEdit, AOwner, AParentControl, AControlName));
end;

function TJvDynControlEngine.CreateCheckboxControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string; ACaption: string): TWinControl;
var
  DynCtrl: IJvDynControl;
begin
  Result := TWinControl(CreateControl(jctCheckBox, AOwner, AParentControl, AControlName));
  if not Supports(Result, IJvDynControl, DynCtrl) then
    raise EIntfCastError.Create(SIntfCastError);
  with DynCtrl do
    ControlSetCaption(ACaption);
end;

function TJvDynControlEngine.CreateComboBoxControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string; AItems: TStrings): TWinControl;
var
  DynCtrl: IJvDynControl;
  DynCtrlItems: IJvDynControlItems;
begin
  Result := TWinControl(CreateControl(jctComboBox, AOwner, AParentControl, AControlName));
  if not Supports(Result, IJvDynControl, DynCtrl) then
    raise EIntfCastError.Create(SIntfCastError);
  if not Supports(Result, IJvDynControlItems, DynCtrlItems) then
    raise EIntfCastError.Create(SIntfCastError);
  DynCtrlItems.ControlSetItems(AItems);
end;

function TJvDynControlEngine.CreateGroupBoxControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string; ACaption: string): TWinControl;
var
  DynCtrl: IJvDynControl;
begin
  Result := TWinControl(CreateControl(jctGroupBox, AOwner, AParentControl, AControlName));
  if not Supports(Result, IJvDynControl, DynCtrl) then
    raise EIntfCastError.Create(SIntfCastError);
  with DynCtrl do
    ControlSetCaption(ACaption);
end;

function TJvDynControlEngine.CreateImageControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string): TWinControl;
begin
  Result := TWinControl(CreateControl(jctImage, AOwner, AParentControl, AControlName));
end;

function TJvDynControlEngine.CreateRadioGroupControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string;
  ACaption: string; AItems: TStrings; AItemIndex: Integer = 0): TWinControl;
var
  DynCtrl: IJvDynControl;
begin
  Result := TWinControl(CreateControl(jctRadioGroup, AOwner, AParentControl, AControlName));
  if not Supports(Result, IJvDynControl, DynCtrl) then
    raise EIntfCastError.Create(SIntfCastError);
  with DynCtrl do
    ControlSetCaption(ACaption);
  with DynCtrl as IJvDynControlItems do
    ControlItems := AItems;
  with DynCtrl as IJvDynControlData do
    ControlValue := AItemIndex;
end;

//function TJvDynControlEngine.CreatePageControlControl(AOwner : TComponent; AParentControl : TWinControl; AControlName : string) : TWinControl;
//begin
//  Result := TWinControl(CreateControl (jctPageControl, AOwner, AParentControl, AControlName));
//end;

function TJvDynControlEngine.CreateMemoControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string): TWinControl;
begin
  Result := TWinControl(CreateControl(jctMemo, AOwner, AParentControl, AControlName));
end;

function TJvDynControlEngine.CreateListBoxControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string; AItems: TStrings): TWinControl;
var
  DynCtrl: IJvDynControl;
begin
  Result := TWinControl(CreateControl(jctListBox, AOwner, AParentControl, AControlName));
  if not Supports(Result, IJvDynControl, DynCtrl) then
    raise EIntfCastError.Create(SIntfCastError);
  with DynCtrl as IJvDynControlItems do
    ControlSetItems(AItems);
end;

function TJvDynControlEngine.CreateDateTimeControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string): TWinControl;
begin
  Result := TWinControl(CreateControl(jctDateTimeEdit, AOwner, AParentControl, AControlName));
end;

function TJvDynControlEngine.CreateDateControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string): TWinControl;
begin
  Result := TWinControl(CreateControl(jctDateEdit, AOwner, AParentControl, AControlName));
end;

function TJvDynControlEngine.CreateTimeControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string): TWinControl;
begin
  Result := TWinControl(CreateControl(jctTimeEdit, AOwner, AParentControl, AControlName));
end;

function TJvDynControlEngine.CreateCalculateControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string): TWinControl;
begin
  Result := TWinControl(CreateControl(jctCalculateEdit, AOwner, AParentControl, AControlName));
end;

function TJvDynControlEngine.CreateSpinControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string): TWinControl;
begin
  Result := TWinControl(CreateControl(jctSpinEdit, AOwner, AParentControl, AControlName));
end;

function TJvDynControlEngine.CreateDirectoryControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string): TWinControl;
begin
  Result := TWinControl(CreateControl(jctDirectoryEdit, AOwner, AParentControl, AControlName));
end;

function TJvDynControlEngine.CreateFileNameControl(AOwner: TComponent;
  AParentControl: TWinControl; AControlName: string): TWinControl;
begin
  Result := TWinControl(CreateControl(jctFileNameEdit, AOwner, AParentControl, AControlName));
end;

function TJvDynControlEngine.CreateButton(AOwner: TComponent;
  AParentControl: TWinControl; AButtonName: string; ACaption: string;
  AHint: string; AOnClick: TNotifyEvent; ADefault: Boolean = False;
  ACancel: Boolean = False): TButton;
begin
  Result := TButton(CreateControl(jctButton, AOwner, AParentControl, AButtonName));
  Result.Hint := AHint;
  Result.Caption := ACaption;
  Result.Default := ADefault;
  Result.Cancel := ACancel;
  Result.OnClick := AOnClick;
end;

function TJvDynControlEngine.CreateForm(ACaption: string; AHint: string): TCustomForm;
begin
  Result := TCustomForm(CreateControl(jctForm, Application, nil, ''));
  Result.Hint := AHint;
end;

procedure TJvDynControlEngine.SetControlCaption(AControl: IJvDynControl; Value: string);
begin
end;

procedure TJvDynControlEngine.SetControlTabOrder(AControl: IJvDynControl; Value: Integer);
begin
end;

procedure TJvDynControlEngine.SetControlOnEnter(AControl: IJvDynControl; Value: TNotifyEvent);
begin
end;

procedure TJvDynControlEngine.SetControlOnExit(AControl: IJvDynControl; Value: TNotifyEvent);
begin
end;

procedure TJvDynControlEngine.SetControlOnClick(AControl: IJvDynControl; Value: TNotifyEvent);
begin
end;

procedure SetDefaultDynControlEngine(AEngine: TJvDynControlEngine);
begin
  if AEngine is TJvDynControlEngine then
    GlobalDefaultDynControlEngine := AEngine;
end;

function DefaultDynControlEngine: TJvDynControlEngine;
begin
  Result := GlobalDefaultDynControlEngine;
end;

end.

