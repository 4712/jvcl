{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Initial Developers of the Original Code is: Jens Fudickar
All Rights Reserved.

Last Modified: 2003-12-17

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvFormPlacementSelectList;

interface

uses
  SysUtils, Classes,
  JvAppStore, JvFormPlacement, JvAppStoreSelectList;

type
  TJvFormStorageSelectList = class (TJvAppStoreSelectList)
  private
    FFormStorage: TJvFormStorage;
  protected
    function GetFormStorage: TJvFormStorage; virtual;
    procedure SetFormStorage(Value: TJvFormStorage); virtual;
    function GetAppStore: TJvCustomAppStore; override;
    procedure SetAppStore(Value: TJvCustomAppStore); override;
    function GetStoragePath : string; override;
  public
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function RestoreFormStorage(ACaption: string = '') : Boolean;
    function SaveFormStorage(ACaption: string = '') : Boolean;
  published
    property FormStorage: TJvFormStorage read GetFormStorage write SetFormStorage;
  end;

implementation

uses
  JvConsts;

function TJvFormStorageSelectList.GetFormStorage: TJvFormStorage;
begin
  Result := FFormStorage;
end;

procedure TJvFormStorageSelectList.SetFormStorage(Value: TJvFormStorage);
begin
  FFormStorage := Value;
end;

function TJvFormStorageSelectList.GetAppStore: TJvCustomAppStore;
begin
  if Assigned(FFormStorage) then
    Result := FFormStorage.AppStorage
  else
    Result := nil;
end;

procedure TJvFormStorageSelectList.SetAppStore(Value: TJvCustomAppStore);
begin
  if Assigned(FFormStorage) then
    FFormStorage.AppStorage := Value;
end;

function  TJvFormStorageSelectList.GetStoragePath : string;
begin
  if Assigned(AppStore) then
    Result := AppStore.ConcatPaths([FormStorage.AppStoragePath, SelectPath])
  else
    Result := FormStorage.AppStoragePath + PathDelim + SelectPath;
end;

procedure TJvFormStorageSelectList.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFormStorage) then
    FFormStorage := nil;
end;

function TJvFormStorageSelectList.RestoreFormStorage(ACaption: string = '') : Boolean;
var
  OldPath : string;
begin
  if Assigned(FormStorage) then
  begin
    OldPath := FormStorage.AppStoragePath;
    FormStorage.AppStoragePath := GetSelectListPath(sloLoad, ACaption);
    Result := FormStorage.AppStoragePath <> '';
    if Result then
      FormStorage.RestoreFormPlacement;
    FormStorage.AppStoragePath := OldPath;
  end
  else
    Result := false;
end;

function TJvFormStorageSelectList.SaveFormStorage(ACaption: string = '') : Boolean;
var
  OldPath : string;
begin
  if Assigned(FormStorage) then
  begin
    OldPath := FormStorage.AppStoragePath;
    FormStorage.AppStoragePath := GetSelectListPath(sloStore, ACaption);
    Result := FormStorage.AppStoragePath <> '';
    if Result then
      FormStorage.SaveFormPlacement;
    FormStorage.AppStoragePath := OldPath;
  end
  else
    Result := false;
end;

end.
