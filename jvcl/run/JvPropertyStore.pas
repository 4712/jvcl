{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvPropertyStore.pas, released on 2003-11-13.

The Initial Developer of the Original Code is Jens Fudickar
Portions created by Marcel Bestebroer are Copyright (C) 2003 Jens Fudickar
All Rights Reserved.

Contributor(s):
  Marcel Bestebroer

Last Modified: 2003-11-13

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvPropertyStore;

interface

uses
  Classes, 
  JvAppStore, JvComponent;

type
  TJvCustomPropertyStore = class(TJvComponent)
  private
    FPath: string;
    FAppStore: TJvCustomAppStore;
    FEnabled: Boolean;
    FDeleteBeforeStore: Boolean;
    FClearBeforeLoad: Boolean;
    FIntIgnoreProperties: TStrings;
    FIgnoreProperties: TStrings;
    FAutoLoad: Boolean;
    FLastLoadTime: TDateTime;
    FIgnoreLastLoadTime: Boolean;
    FCombinedIgnoreList: TStrings;
    FOnBeforeLoadProperties: TNotifyEvent;
    FOnAfterLoadProperties: TNotifyEvent;
    FOnBeforeStoreProperties: TNotifyEvent;
    FOnAfterStoreProperties: TNotifyEvent;
    procedure SetAutoLoad(Value: Boolean);
    procedure SetIgnoreProperties(Value: TStrings);
    function GetPropCount(Instance: TPersistent): Integer;
    function GetPropName(Instance: TPersistent; Index: Integer): string;
    procedure CloneClass(Src, Dest: TPersistent);
    function GetLastSaveTime: TDateTime;
  protected
    procedure UpdateChildPaths(OldPath: string = ''); virtual;
    procedure SetPath(Value: string); virtual;
    procedure SetAppStore(Value: TJvCustomAppStore);
    procedure Loaded; override;
    procedure DisableAutoLoadDown;
    procedure LoadData; virtual;
    procedure StoreData; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property CombinedIgnoreList: TStrings read FCombinedIgnoreList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AppStore: TJvCustomAppStore Read FAppStore Write SetAppStore;
    procedure StoreProperties; virtual;
    procedure LoadProperties; virtual;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; virtual;
  published
    property AutoLoad: boolean read FAutoLoad write SetAutoLoad;
    property Path: string read FPath Write SetPath;
    property Enabled: Boolean read FEnabled write FEnabled default True;
    property DeleteBeforeStore: Boolean read FDeleteBeforeStore write FDeleteBeforeStore
      default False;
    property ClearBeforeLoad: Boolean read FClearBeforeLoad write fClearBeforeLoad default False;
    property IgnoreLastLoadTime: Boolean read FIgnoreLastLoadTime write fIgnoreLastLoadTime
      default False;
    property IgnoreProperties: TStrings read FIgnoreProperties write SetIgnoreProperties;
    property OnBeforeLoadProperties: TNotifyEvent read FOnBeforeLoadProperties
      write FOnBeforeLoadProperties;
    property OnAfterLoadProperties: TNotifyEvent read FOnAfterLoadProperties
      write FOnAfterLoadProperties;
    property OnBeforeStoreProperties: TNotifyEvent read FOnBeforeStoreProperties
      write FOnBeforeStoreProperties;
    property OnAfterStoreProperties: TNotifyEvent read FOnAfterStoreProperties
      write FOnAfterStoreProperties;

  end;

  TJvCustomPropertyListStore = class(TJvCustomPropertyStore)
  private
    FItems: TStrings;
    FFreeObjects: boolean;
    FCreateListEntries: boolean;
  protected
    function GetString(Index: Integer): string;
    function GetObject(Index: Integer): TObject;
    procedure SetString(Index: Integer; Value: string);
    procedure SetObject(Index: Integer; Value: TObject);
    function GetCount: Integer;
    procedure ReadSLOItem(Sender: TJvCustomAppStore; const Path: string; const Index: Integer);
    procedure WriteSLOItem(Sender: TJvCustomAppStore; const Path: string; const Index: Integer);
    procedure DeleteSLOItems(Sender: TJvCustomAppStore; const Path: string; const First,
      Last: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure StoreData; override;
    procedure LoadData; override;
    procedure Clear; override;
    function CreateObject: TObject; virtual;
    property Strings [Index: Integer]: string read GetString write SetString;
    property Objects[Index: Integer]: TObject read GetObject write SetObject;
    property Items: TStrings read FItems;
    property Count: Integer read GetCount;
  published
    { Defines if the Items.Objects- Objects will be freeded inside the clear procedure }
    property FreeObjects: Boolean read FFreeObjects Write FFreeObjects default True;
    { Defines it new List entries will be created if there are stored entries, which
      are not in the current object }
    property CreateListEntries: Boolean read FCreateListEntries write FCreateListEntries
      default True;
  end;

implementation

uses
  {$IFDEF COMPILER6_UP}
  RTLConsts,
  {$ENDIF}
  Consts, SysUtils, Typinfo;

const
  cLastSaveTime = 'Last Save Time';

type
  // Read-only TStrings combining multiple TStrings instances in a single list
  TCombinedStrings = class(TStrings)
  private
    FList: TList;
  protected
    function Get(Index: Integer): string; override;
    function GetObject(Index: Integer): TObject; override;
    function GetCount: Integer; override;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddStrings(Strings: TStrings); override;
//    procedure DeleteStrings(Strings: TStrings);
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
  end;

//===TCombinedStrings===============================================================================

function TCombinedStrings.Get(Index: Integer): string;
var
  OrgIndex: Integer;
  I: Integer;
begin
  OrgIndex := Index;
  I := 0;
  if Index < 0 then
    Error(SListIndexError, Index);
  while (I < FList.Count) and (Index >= TStrings(FList[I]).Count) do
  begin
    Dec(Index, TStrings(FList[I]).Count);
    Inc(I);
  end;
  if I >= FList.Count then
    Error(SListIndexError, OrgIndex);
  Result := TStrings(FList[I])[Index];
end;

function TCombinedStrings.GetObject(Index: Integer): TObject;
var
  OrgIndex: Integer;
  I: Integer;
begin
  OrgIndex := Index;
  I := 0;
  if Index < 0 then
    Error(SListIndexError, Index);
  while (Index < TStrings(FList[I]).Count) and (I < FList.Count) do
  begin
    Dec(Index, TStrings(FList[I]).Count);
    Inc(I);
  end;
  if I >= FList.Count then
    Error(SListIndexError, OrgIndex);
  Result := TStrings(FList[I]).Objects[Index];
end;

function TCombinedStrings.GetCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FList.Count - 1 do
    Inc(Result, TStrings(FList[I]).Count);
end;

constructor TCombinedStrings.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TCombinedStrings.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TCombinedStrings.AddStrings(Strings: TStrings);
begin
  if FList.IndexOf(Strings) = -1 then
    FList.Add(Strings);
end;

(*
procedure TCombinedStrings.DeleteStrings(Strings: TStrings);
begin
  FList.Remove(Strings);
end;
*)
procedure TCombinedStrings.Clear;
begin
  FList.Clear;
end;

procedure TCombinedStrings.Delete(Index: Integer);
begin
end;

procedure TCombinedStrings.Insert(Index: Integer; const S: string);
begin
end;

//===TJvCustomPropertyStore=========================================================================

constructor TJvCustomPropertyStore.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);
  FLastLoadTime := Now;
  FAppStore := nil;
  FEnabled := True;
  FDeleteBeforeStore := False;
  FAutoLoad := False;
  FIntIgnoreProperties := TStringList.Create;
  FIgnoreProperties := TStringList.Create;
  FIgnoreLastLoadTime := False;
  FCombinedIgnoreList := TCombinedStrings.Create;
  FCombinedIgnoreList.AddStrings(FIntIgnoreProperties);
  FCombinedIgnoreList.AddStrings(FIgnoreProperties);
  FIntIgnoreProperties.Add('AboutJVCL');
  FIntIgnoreProperties.Add('Path');
  FIntIgnoreProperties.Add('AutoLoad');
  FIntIgnoreProperties.Add('Name');
  FIntIgnoreProperties.Add('Tag');
  FIntIgnoreProperties.Add('Enabled');
  FIntIgnoreProperties.Add('DeleteBeforeStore');
  FIntIgnoreProperties.Add('IgnoreLastLoadTime');
  FIntIgnoreProperties.Add('IgnoreProperties');
end;

destructor TJvCustomPropertyStore.Destroy;
begin
  if not (csDesigning in ComponentState) then
    if AutoLoad then
      StoreProperties;
  FreeAndNil(FCombinedIgnoreList);
  FreeAndNil(FIntIgnoreProperties);
  FreeAndNil(FIgnoreProperties);
  Clear;
  inherited Destroy;
end;


procedure TJvCustomPropertyStore.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FAppStore) then
    FAppstore := nil;
end;

function TJvCustomPropertyStore.GetPropCount(Instance: TPersistent): Integer;
var
  Data: PTypeData;
begin
  Data := GetTypeData(Instance.Classinfo);
  Result := Data^.PropCount;
end;

function TJvCustomPropertyStore.GetPropName(Instance: TPersistent; Index: Integer): string;
var
  PropList: PPropList;
  PropInfo: PPropInfo;
  Data: PTypeData;
begin
  Result := '';
  Data := GetTypeData(Instance.ClassInfo);
  GetMem(PropList, Data^.PropCount * Sizeof(PPropInfo));
  try
    GetPropInfos(Instance.ClassInfo, PropList);
    PropInfo := PropList^[Index];
    Result := PropInfo^.Name;
  finally
    FreeMem(PropList, Data^.PropCount * Sizeof(PPropInfo));
  end;
end;

procedure TJvCustomPropertyStore.CloneClass(Src, Dest: TPersistent);
var
  Index: Integer;
  SrcPropInfo: PPropInfo;
  DestPropInfo: PPropInfo;
begin
  for Index := 0 to GetPropCount(Src) - 1 do
  begin
    if (CompareText(GetPropName(Src, Index), 'Name') = 0) then
      Continue;
    SrcPropInfo  := GetPropInfo(Src.ClassInfo, GetPropName(Src, Index));
    DestPropInfo := GetPropInfo(Dest.ClassInfo, GetPropName(Src, Index));
    if (DestPropInfo <> nil) and (DestPropInfo^.PropType^.Kind = SrcPropInfo^.PropType^.Kind) then
      case DestPropInfo^.PropType^.Kind of
        tkLString,
        tkString:
          SetStrProp(Dest, DestPropInfo, GetStrProp(Src, SrcPropInfo));
        tkInteger,
        tkChar,
        tkEnumeration,
        tkSet:
          SetOrdProp(Dest, DestPropInfo, GetOrdProp(Src, SrcPropInfo));
        tkFloat:
          SetFloatProp(Dest, DestPropInfo, GetFloatProp(Src, SrcPropInfo));
        tkVariant:
          SetVariantProp(Dest, DestPropInfo, GetVariantProp(Src, SrcPropInfo));
        tkClass:
          TPersistent(GetOrdProp(Dest, DestPropInfo)).Assign(TPersistent(GetOrdProp(Src,
            SrcPropInfo)));
        tkMethod:
          SetMethodProp(Dest, DestPropInfo, GetMethodProp(Src, SrcPropInfo));
      end;
  end;
end;

procedure TJvCustomPropertyStore.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
    if AutoLoad then
      LoadProperties;
end;

procedure TJvCustomPropertyStore.Assign(Source: TPersistent);
begin
  if Source is Self.ClassType then
    CloneClass(Source, Self)
  else
    inherited Assign(Source);
end;

procedure TJvCustomPropertyStore.Clear;
begin
end;

procedure TJvCustomPropertyStore.SetAutoLoad(Value: Boolean);
begin
  if not Assigned(Owner) then
    Exit;
  if Owner is tJvCustomPropertyStore then
    FAutoLoad := False
  else
  if Value <> AutoLoad then
    FAutoLoad := Value;
end;

procedure tJvCustomPropertyStore.DisableAutoLoadDown;
var
  Index: Integer;
  PropName: string;
begin
  for Index := 0 to GetPropCount(Self) - 1 do
  begin
    PropName := GetPropName(Self, Index);
    if (FIgnoreProperties.IndexOf(Propname) >= 0) then
      Continue;
    if (FIntIgnoreProperties.IndexOf(Propname) >= 0) then
      Continue;
    if PropType(Self, GetPropName(Self, Index)) = tkClass then
      if (TPersistent(GetOrdProp(Self, PropName)) is tJvCustomPropertyStore) then
        TJvCustomPropertyStore(TPersistent(GetOrdProp(Self, PropName))).AutoLoad := False;
  end;
end;

procedure TJvCustomPropertyStore.UpdateChildPaths(OldPath: string);
var
  Index: Integer;
  VisPropName: string;
  PropName: string;
begin
  if OldPath = '' then
    OldPath := Path;
  for Index := 0 to GetPropCount(Self) - 1 do
  begin
    PropName := GetPropName(Self, Index);
    VisPropName := AppStore.TranslatePropertyName(Self, PropName, False);
    if (FIgnoreProperties.Indexof(PropName) >= 0) then
      Continue;
    if (FIntIgnoreProperties.Indexof(PropName) >= 0) then
      Continue;
    if PropType(Self, GetPropName(Self, Index)) = tkClass then
      if (TPersistent(GetOrdProp(Self, PropName)) is TJvCustomPropertyStore) then
        if (TJvCustomPropertyStore(TPersistent(GetOrdProp(Self, PropName))).Path =
          AppStore.ConcatPaths([OldPath, VisPropName])) or
          (TJvCustomPropertyStore(TPersistent(GetOrdProp(Self, PropName))).Path = '') then
            TJvCustomPropertyStore(TPersistent(GetOrdProp(Self, PropName))).Path :=
            AppStore.ConcatPaths([Path, VisPropName]);
  end;
end;

procedure TJvCustomPropertyStore.SetPath(Value: string);
var
  OldPath: string;
begin
  OldPath := FPath;
  if Value <> Path then
    FPath := Value;
  UpdateChildPaths(OldPath);
end;

procedure TJvCustomPropertyStore.SetAppStore(Value: TJvCustomAppStore);
var
  Index: Integer;
begin
  if Value = FAppStore then
    Exit;
  for Index := 0 to ComponentCount - 1 do
    if Components[Index] is TJvCustomPropertyStore then
      TJvCustomPropertyStore(Components[Index]).AppStore := Value;
  FAppStore := Value;
end;

procedure TJvCustomPropertyStore.SetIgnoreProperties(Value: TStrings);
begin
  FIgnoreProperties.Assign(Value);
end;

function TJvCustomPropertyStore.GetLastSaveTime: TDateTime;
begin
  Result := 0;
  if not Enabled then
    Exit;
  if Path = '' then
    Exit;
  if Appstore.ValueStored(AppStore.ConcatPaths([Path, cLastSaveTime])) then
    Result := Appstore.ReadDateTime(AppStore.ConcatPaths([Path, cLastSaveTime]))
  else
    Result := 0;
end;

procedure TJvCustomPropertyStore.LoadProperties;
begin
  if not Enabled then
    Exit;
  if not Assigned(AppStore) then
    Exit;
  UpdateChildPaths;
  FLastLoadTime := Now;
  if ClearBeforeLoad then
    Clear;
  if Assigned(FOnBeforeLoadProperties) then
    OnBeforeLoadProperties(Self);
  LoadData;
  AppStore.ReadPersistent(Path, Self, True, False);
  if Assigned(FOnAfterLoadProperties) then
    OnAfterLoadProperties(self);
end;

procedure TJvCustomPropertyStore.StoreProperties;
var
  SaveProperties: Boolean;
begin
  if not Enabled then
    Exit;
  if not Assigned(AppStore) then
    Exit;
  UpdateChildPaths;
  DisableAutoLoadDown;
  SaveProperties := IgnoreLastLoadTime or (GetLastSaveTime < FLastLoadTime);
  if DeleteBeforeStore then
    AppStore.DeleteSubTree(Path);
  if not IgnoreLastLoadTime then
    Appstore.WriteString(AppStore.ConcatPaths([Path, cLastSaveTime]), DateTimeToStr(Now));
  if Assigned(FOnBeforeStoreProperties) then
    OnBeforeStoreProperties(self);
  if SaveProperties then
    StoreData;
  AppStore.WritePersistent(Path, Self, True, CombinedIgnoreList);
  if Assigned(FOnAfterStoreProperties) then
    OnAfterStoreProperties(self);
end;

procedure TJvCustomPropertyStore.LoadData;
begin
end;

procedure TJvCustomPropertyStore.StoreData;
begin
end;

//===TJvCustomPropertyListStore=====================================================================

constructor TJvCustomPropertyListStore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TStringList.Create;
  CreateListEntries := True;
  FreeObjects := True;
  FIntIgnoreProperties.Add('FreeObjects');
  FIntIgnoreProperties.Add('CreateListEntries');
end;

destructor TJvCustomPropertyListStore.Destroy;
begin
  Clear;
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TJvCustomPropertyListStore.StoreData;
begin
  inherited StoreData;
  AppStore.WriteList(Path, Count, WriteSLOItem, DeleteSLOItems);
end;

procedure TJvCustomPropertyListStore.LoadData;
begin
  inherited LoadData;
  AppStore.ReadList(Path, ReadSLOItem);
end;

procedure TJvCustomPropertyListStore.Clear;
var
  I: Integer;
begin
  if Assigned(FItems) then
  begin
    if FreeObjects then
      for I := 0 to Count - 1 do
        if Assigned(Objects[I]) then
          Objects[I].Free;
    Items.Clear;
  end;
  inherited Clear;
end;

function TJvCustomPropertyListStore.CreateObject: TObject;
begin
  Result := nil;
end;

function TJvCustomPropertyListStore.GetString(Index: Integer): string;
begin
  Result := Items.Strings[Index];
end;

function TJvCustomPropertyListStore.GetObject(Index: Integer): TObject;
begin
  Result := Items.Objects[Index];
end;

procedure TJvCustomPropertyListStore.SetString(Index: Integer; Value: string);
begin
  Items.Strings[Index] := Value;
end;

procedure TJvCustomPropertyListStore.SetObject(Index: Integer; Value: TObject);
begin
  Items.Objects[Index] := Value;
end;

function TJvCustomPropertyListStore.GetCount: Integer;
begin
  Result := Items.Count;
end;

procedure TJvCustomPropertyListStore.ReadSLOItem(Sender: TJvCustomAppStore; const Path: string;
  const Index: Integer);
var
  NewObject:  TObject;
  ObjectName: string;
begin
  if Index >= Count then
  begin
    if not CreateListEntries then
      Exit;
    if Sender.PathExists(Sender.ConcatPaths([Path, 'Object' + IntToStr(Index)])) then
    begin
      NewObject := CreateObject;
      if Assigned(NewObject) then
      begin
        if NewObject is TJvCustomPropertyStore then
        begin
          TJvCustomPropertyStore(NewObject).Path := Sender.ConcatPaths([Path, 'Object' +
            IntToStr(Index)]);
          TJvCustomPropertyStore(NewObject).LoadProperties;
        end
        else
        if NewObject is TPersistent then
          Sender.ReadPersistent(Sender.ConcatPaths([Path, 'Object' + IntToStr(Index)]),
            TPersistent(NewObject), True, True);
      end;
      if Sender.ValueStored(Sender.ConcatPaths([Path, 'Item' + IntToStr(Index)])) then
        ObjectName := Sender.ReadString(Sender.ConcatPaths([Path, 'Item' + IntToStr(Index)]))
      else
        ObjectName := '';
      Items.AddObject(ObjectName, NewObject);
    end
    else
      Items.Add(Sender.ReadString(Sender.ConcatPaths([Path, 'Item' + IntToStr(Index)])))
  end
  else
  if Sender.ValueStored(Sender.ConcatPaths([Path, 'Object' + IntToStr(Index)])) then
  begin
    if Assigned(Objects[Index]) then
    begin
      if Objects[Index] is tJvCustomPropertyStore then
      begin
        TJvCustomPropertyStore(Objects[Index]).Path := Sender.ConcatPaths([Path, 'Object' +
          IntToStr(Index)]);
        TJvCustomPropertyStore(Objects[Index]).LoadProperties;
      end
      else
      if Objects[Index] is TPersistent then
        Sender.ReadPersistent(Sender.ConcatPaths([Path, 'Object' + IntToStr(Index)]),
          TPersistent(Objects[Index]), True, True);
    end;
    if Sender.ValueStored(Sender.ConcatPaths([Path, 'Item' + IntToStr(Index)])) then
      Strings[Index] := Sender.ReadString(Sender.ConcatPaths([Path, 'Item' + IntToStr(Index)]))
    else
      Strings[Index] := '';
  end
  else
    Strings[Index] := Sender.ReadString(Sender.ConcatPaths([Path, 'Item' + IntToStr(Index)]));
end;

procedure TJvCustomPropertyListStore.WriteSLOItem(Sender: TJvCustomAppStore; const Path: string;
  const Index: integer);
begin
  if Assigned(Objects[Index]) then
  begin
    if Objects[Index] is TJvCustomPropertyStore then
    begin
      TJvCustomPropertyStore(Objects[Index]).Path := Sender.ConcatPaths([Path, 'Object' +
        IntToStr(Index)]);
      TJvCustomPropertyStore(Objects[Index]).StoreProperties;
    end
    else
    if Objects[Index] is TPersistent then
      Sender.WritePersistent(Sender.ConcatPaths([Path, 'Object' + IntToStr(Index)]),
        TPersistent(Objects[Index]), True, CombinedIgnoreList);
    if Strings[Index] <> '' then
      Sender.WriteString(Sender.ConcatPaths([Path, 'Item' + IntToStr(Index)]), Strings[Index]);
  end
  else
    Sender.WriteString(Sender.ConcatPaths([Path, 'Item' + IntToStr(Index)]), Strings[Index]);
end;

procedure TJvCustomPropertyListStore.DeleteSLOItems(Sender: TJvCustomAppStore; const Path: string;
  const First, Last: Integer);
var
  I: Integer;
begin
  for I := First to Last do
  begin
    Sender.DeleteValue(Sender.ConcatPaths([Path, 'Item' + IntToStr(I)]));
    Sender.DeleteValue(Sender.ConcatPaths([Path, 'Object' + IntToStr(I)]));
  end;
end;

end.
