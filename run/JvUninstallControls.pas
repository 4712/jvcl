{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvUCB.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is Peter Th�rnqvist [peter3@peter3.com]
Portions created by Peter Th�rnqvist are Copyright (C) 2002 Peter Th�rnqvist.
All Rights Reserved.

Contributor(s):

Last Modified: 2002-05-26

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvUninstallControls;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, StdCtrls,
  JvComponent, JvTypes;

type
  TJvUCBDisplayMode = (hkCurrentUser, hkLocalMachine); // subset of TJvRegKey
  TJvUCBDisplayModes = set of TJvUCBDisplayMode;

  TJvUninstallComboBox = class(TCustomComboBox)
  private
    FDisplayMode: TJvUCBDisplayModes;
    FShowAll: Boolean;
    function GetItems: TStrings;
    function GetDisplayName: string;
    function GetSection: string;
    function GetUninstallString: string;
    procedure SetShowAll(const Value: Boolean);
    procedure SetDisplayMode(const Value: TJvUCBDisplayModes);
    procedure Rebuild;
    function GetProperties: TStrings;
    function GetHKey: HKEY;
  protected
    procedure CreateHandle; override;
  public
    constructor Create(AComponent: TComponent); override;
    destructor Destroy; override;
    procedure Clear; {$IFDEF COMPILER6_UP} override; {$ENDIF}
    property Items: TStrings read GetItems;
    property Section: string read GetSection;
    property HKey: HKEY read GetHKey;
    property UninstallString: string read GetUninstallString;
    property DisplayName: string read GetDisplayName;
    property Properties: TStrings read GetProperties;
  published
    property ShowAll: Boolean read FShowAll write SetShowAll;
    property DisplayMode: TJvUCBDisplayModes read FDisplayMode write SetDisplayMode
      default [hkCurrentUser, hkLocalMachine];
    property Color;
    property DragCursor;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property Style;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDrag;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
  end;

  TJvUninstallListBox = class(TCustomListBox)
  private
    FShowAll: Boolean;
    FDisplayMode: TJvUCBDisplayModes;
    function GetItems: TStrings;
    function GetDisplayName: string;
    function GetSection: string;
    function GetUninstallString: string;
    procedure SetShowAll(const Value: Boolean);
    procedure SetDisplayMode(const Value: TJvUCBDisplayModes);
    function GetProperties: TStrings;
    function GetHKey: HKEY;
  protected
    procedure CreateHandle; override;
  public
    constructor Create(AComponent: TComponent); override;
    destructor Destroy; override;
    procedure Clear; {$IFDEF COMPILER6_UP} override; {$ENDIF}
    procedure Rebuild;
    property Items: TStrings read GetItems;
    property Section: string read GetSection;
    property UninstallString: string read GetUninstallString;
    property DisplayName: string read GetDisplayName;
    property Properties: TStrings read GetProperties;
    property HKey: HKEY read GetHKey;
  published
    property Align;
    property ShowAll: Boolean read FShowAll write SetShowAll;
    property DisplayMode: TJvUCBDisplayModes read FDisplayMode write SetDisplayMode
      default [hkCurrentUser, hkLocalMachine];
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDrag;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
  end;

implementation

uses
  Registry;

const
  cUninstallPath = 'Software\Microsoft\Windows\CurrentVersion\Uninstall';
  cUninstallString = 'UninstallString';
  cDisplayName = 'DisplayName';

  FKey: array [TJvUCBDisplayMode] of DWORD =
    (HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE);

type
  TUninstallInfo = class(TObject)
  private
    FSection: string;
    FHKey: HKEY;
    FProperties: TStringList;
    function GetProperties: TStrings;
//    procedure SetProperties(const Value: TStrings); make Delphi 5 compiler happy // andreas
  public
    destructor Destroy; override;
    property HKey: HKEY read FHKey write FHKey;
    property Section: string read FSection write FSection;
    property Properties: TStrings read GetProperties {write SetProperties // make Delphi 5 compiler happy // andreas};
  end;

procedure GetUninstallApps(DisplayModes: TJvUCBDisplayModes; Strings: TStrings; ShowAll: Boolean);
var
  I: Integer;
  FFolders, FItems: TStringList;
  Tmp: string;
  Reg: TRegIniFile;
  Dm: TJvUCBDisplayMode;
  UI: TUninstallInfo;

  function ExpandEnvVar(const S: string): string;
  begin
    SetLength(Result, ExpandEnvironmentStrings(PChar(S), nil, 0));
    ExpandEnvironmentStrings(PChar(S), PChar(Result), Length(Result));
  end;

  procedure MakeProps(Reg: TRegIniFile; const Section: string; Items, Props: TStrings);
  var
    I: Integer;
    Tmp: string;
    Buf: PChar;
    BufSize: Integer;
    DValue: Cardinal;
  begin
    Reg.OpenKeyReadOnly(Section);
    for I := 0 to Items.Count - 1 do
    begin
      case Reg.GetDataType(Items[I]) of
        rdString:
          Tmp := Reg.ReadString('', Items[I], '');
        rdExpandString:
          Tmp := ExpandEnvVar(Reg.ReadString('', Items[I], ''));
        rdInteger:
          begin
            BufSize := SizeOf(DValue);
            RegQueryValueEx(Reg.CurrentKey, PChar(Items[I]), nil, nil, PByte(@DValue), @BufSize);
            Tmp := IntToStr(DValue);
          end;
        rdBinary:
          begin
            BufSize := Reg.GetDataSize(Items[I]);
            if BufSize > 0 then
            begin
              GetMem(Buf, BufSize);
              Reg.ReadBinaryData(Items[I], Buf, BufSize);
              SetLength(Tmp, BufSize * 2);
              BinToHex(PChar(Tmp), Buf, BufSize);
              FreeMem(Buf);
            end;
          end;
      end;
      if Tmp <> '' then
        Props.Add(Format('%s=%s', [Items[I], Tmp]));
    end;
    Reg.CloseKey;
  end;

begin
  FFolders := TStringList.Create;
  FItems := TStringList.Create;
  Reg := TRegIniFile.Create('');
//  FFolders.Sorted := True;
  Strings.BeginUpdate;
  with Reg do
  try
    for Dm := Low(FKey) to High(FKey) do
      if Dm in DisplayModes then
      begin
        RootKey := FKey[Dm];
        if OpenKeyReadOnly(cUninstallPath) then
        begin
          ReadSections(FFolders);
          for I := FFolders.Count - 1 downto 0 do
          begin
            Tmp := ReadString(FFolders[I], cDisplayName, '');
            if (Tmp = '') and not ShowAll then
              FFolders.Delete(I)
            else
            begin
              UI := TUninstallInfo.Create;
              if Tmp = '' then
                Tmp := FFolders[I];
              UI.HKey := RootKey;
              UI.Section := cUninstallPath + FFolders[I];
              ReadSection(FFolders[I], FItems);
              MakeProps(Reg, FFolders[I], FItems, UI.Properties);
              Strings.AddObject(Tmp, UI);
              OpenKeyReadOnly(cUninstallPath);
            end;
          end;
        end;
      end;
  finally
    Free;
    FFolders.Free;
    FITems.Free;
    Strings.EndUpdate;
  end;
end;

//=== TJvUninstallComboBox ===================================================

constructor TJvUninstallComboBox.Create(AComponent: TComponent);
begin
  inherited Create(AComponent);
  Style := csDropDownList;
  FDisplayMode := [hkCurrentUser, hkLocalMachine];
end;

destructor TJvUninstallComboBox.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TJvUninstallComboBox.Rebuild;
var
  I: Integer;
begin
  if ([csLoading, csDestroying] * ComponentState) <> [] then
    Exit;
  I := ItemIndex;
  Clear;
  GetUninstallApps(DisplayMode, Items, ShowAll);
  ItemIndex := I;
  if (Items.Count > 0) and (ItemIndex < 0) then
    ItemIndex := 0;
end;

function TJvUninstallComboBox.GetDisplayName: string;
begin
  if ItemIndex > -1 then
    Result := TUninstallInfo(Items.Objects[ItemIndex]).Properties.Values[cDisplayName]
  else
    Result := '';
end;

function TJvUninstallComboBox.GetItems: TStrings;
begin
  Result := inherited Items;
end;

function TJvUninstallComboBox.GetSection: string;
begin
  if ItemIndex > -1 then
    Result := TUninstallInfo(Items.Objects[ItemIndex]).Section
  else
    Result := '';
end;

function TJvUninstallComboBox.GetUninstallString: string;
begin
  if ItemIndex > -1 then
    Result := TUninstallInfo(Items.Objects[ItemIndex]).Properties.Values[cUninstallString]
  else
    Result := '';
end;

procedure TJvUninstallComboBox.SetDisplayMode(const Value: TJvUCBDisplayModes);
begin
  if FDisplayMode <> Value then
  begin
    FDisplayMode := Value;
    Rebuild;
  end;
end;

procedure TJvUninstallComboBox.SetShowAll(const Value: Boolean);
begin
  if FShowAll <> Value then
  begin
    FShowAll := Value;
    Rebuild;
  end;
end;

procedure TJvUninstallComboBox.Clear;
var
  I: Integer;
begin
  if Parent = nil then
    Exit;
  for I := 0 to Items.Count - 1 do
    Items.Objects[I].Free;
  inherited Clear;
end;

procedure TJvUninstallComboBox.CreateHandle;
begin
  inherited CreateHandle;
  if ItemIndex < 0 then
    Rebuild;
end;

function TJvUninstallComboBox.GetProperties: TStrings;
begin
  Result := nil;
  if ItemIndex > -1 then
    Result := TUninstallInfo(Items.Objects[ItemIndex]).Properties;
end;

function TJvUninstallComboBox.GetHKey: HKEY;
begin
  Result := 0;
  if ItemIndex > -1 then
    Result := TUninstallInfo(Items.Objects[ItemIndex]).HKey;
end;

//=== TJvUninstallListBox ====================================================

constructor TJvUninstallListBox.Create(AComponent: TComponent);
begin
  inherited Create(AComponent);
  FDisplayMode := [hkCurrentUser, hkLocalMachine];
end;

destructor TJvUninstallListBox.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TJvUninstallListBox.GetDisplayName: string;
begin
  if ItemIndex > -1 then
    Result := TUninstallInfo(Items.Objects[ItemIndex]).Properties.Values[cDisplayName]
  else
    Result := '';
end;

function TJvUninstallListBox.GetUninstallString: string;
begin
  if ItemIndex > -1 then
    Result := TUninstallInfo(Items.Objects[ItemIndex]).Properties.Values[cUninstallString]
  else
    Result := '';
end;

function TJvUninstallListBox.GetItems: TStrings;
begin
  Result := inherited Items;
end;

function TJvUninstallListBox.GetSection: string;
begin
  if ItemIndex > -1 then
    Result := TUninstallInfo(Items.Objects[ItemIndex]).Section
  else
    Result := '';
end;

procedure TJvUninstallListBox.SetDisplayMode(const Value: TJvUCBDisplayModes);
begin
  if FDisplayMode <> Value then
  begin
    FDisplayMode := Value;
    Rebuild;
  end;
end;

procedure TJvUninstallListBox.SetShowAll(const Value: Boolean);
begin
  if FShowAll <> Value then
  begin
    FShowAll := Value;
    Rebuild;
  end;
end;

procedure TJvUninstallListBox.Clear;
var
  I: Integer;
begin
  if Parent = nil then
    Exit;
  for I := 0 to Items.Count - 1 do
    Items.Objects[I].Free;
  Items.Clear;
  inherited Clear;
end;

procedure TJvUninstallListBox.Rebuild;
var
  I: Integer;
begin
  if ([csLoading, csDestroying] * ComponentState) <> [] then
    Exit;
  I := ItemIndex;
  Clear;
  GetUninstallApps(DisplayMode, Items, ShowAll);
  ItemIndex := I;
  if (Items.Count > 0) and (ItemIndex < 0) then
    ItemIndex := 0;
end;

procedure TJvUninstallListBox.CreateHandle;
begin
  inherited CreateHandle;
  if ItemIndex < 0 then
    Rebuild;
end;

function TJvUninstallListBox.GetProperties: TStrings;
begin
  Result := nil;
  if ItemIndex > -1 then
    Result := TUninstallInfo(Items.Objects[ItemIndex]).Properties;
end;

function TJvUninstallListBox.GetHKey: HKEY;
begin
  Result := 0;
  if ItemIndex > -1 then
    Result := TUninstallInfo(Items.Objects[ItemIndex]).HKey;
end;

//=== TUninstallInfo ====================================================

destructor TUninstallInfo.Destroy;
begin
  FProperties.Free;
  inherited Destroy;
end;

function TUninstallInfo.GetProperties: TStrings;
begin
  if FProperties = nil then
    FProperties := TStringList.Create;
  Result := FProperties;
end;

{ make Delphi 5 compiler happy // andreas
procedure TUninstallInfo.SetProperties(const Value: TStrings);
begin
  if FProperties = nil then
    FProperties := TStringlist.Create;
  FProperties.Assign(Value);
end;}

end.

