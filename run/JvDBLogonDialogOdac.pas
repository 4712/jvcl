{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvDBLogonDialogOdac.pas, released on 2006-07-21.

The Initial Developer of the Original Code is Jens Fudickar
All Rights Reserved.

Contributor(s):
Jens Fudickar

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvDBLogonDialogOdac;

{$I jvcl.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  Classes, Forms, Controls, DBAccess, Ora,
  JvBaseDlg, JvAppStorage, JvBaseDBLogonDialog,
  JvDynControlEngine, JvBaseDBPasswordDialog, JvDynControlEngineIntf;

type
  TJvDBOdacLogonDialogOptions = class(TJvBaseDBOracleLogonDialogOptions)
  private
    FShowNetOption: Boolean;
    FShowOracleHome: Boolean;
  public
    constructor Create; override;
  published
    property AllowPasswordChange default True;
    property PasswordDialogOptions;
    property ShowNetOption: Boolean read FShowNetOption write FShowNetOption default True;
    property ShowOracleHome: Boolean read FShowOracleHome write FShowOracleHome default False;
  end;

  TJvDBOdacLogonDialog = class(TJvBaseDBOracleLogonDialog)
  private
    FOraSession: TOraSession;
    INetOptionCheckBox: IJvDynControlCheckBox;
    IOracleHomeEditData: IJvDynControlData;
    NetOptionCheckBox: TWinControl;
    OracleHomeEdit: TWinControl;
    OracleHomePanel: TWinControl;
    function GetOptions: TJvDBOdacLogonDialogOptions;
    function GetOraSession: TOraSession;
    function GetSession: TCustomDAConnection;
    procedure SetOptions(const Value: TJvDBOdacLogonDialogOptions);
    procedure SetSession(const Value: TCustomDAConnection); reintroduce;
  protected
    procedure CreateAdditionalConnectDialogControls(AOwner: TComponent;
      AParentControl: TWinControl); override;
    procedure CreateFormControls(AForm: TForm); override;
    function CreatePasswordChangeDialog: TJvBaseDBPasswordDialog; override;
    procedure FillDatabaseComboBoxDefaultValues(Items: TStrings); override;
    { Retrieve the class that holds the storage options and format settings. }
    class function GetDBLogonDialogOptionsClass: TJvBaseDBLogonDialogOptionsClass; override;
    procedure HandleExpiredPassword(const ErrorMessage: string);
    procedure ResizeFormControls; override;
    procedure TransferConnectionInfoFromDialog(ConnectionInfo: TJvBaseConnectionInfo); override;
    procedure TransferConnectionInfoToDialog(ConnectionInfo: TJvBaseConnectionInfo); override;
    procedure TransferSessionDataFromConnectionInfo(ConnectionInfo: TJvBaseConnectionInfo); override;
    procedure TransferSessionDataToConnectionInfo(ConnectionInfo: TJvBaseConnectionInfo); override;
    property OraSession: TOraSession read GetOraSession;
  public
    procedure ClearControlInterfaceObjects; override;
    procedure ConnectSession; override;
    function SessionIsConnected: Boolean; override;
  published
    property Options: TJvDBOdacLogonDialogOptions read GetOptions write SetOptions;
    property Session: TCustomDAConnection read GetSession write SetSession;
  end;

  TjvDBOdacConnectDialog = class(TCustomConnectDialog)
  private
    FLogonDialogInternal: TJvDBOdacLogonDialog;
    FOnFillDatabaseList: TJvLogonDialogFillListEvent;
    function GetAfterTransferSessionDataToConnectionInfo:
      TJvLogonDialogConnectionInfoEvent;
    function GetAppStorage: TJvCustomAppStorage;
    function GetAppStoragePath: string;
    function GetBeforeTransferConnectionInfoToSessionData:
      TJvLogonDialogConnectionInfoEvent;
    function GetDynControlEngine: TJvDynControlEngine;
    function GetOnDecryptPassword: TJvLogonDialogEncryptDecryptEvent;
    function GetOnEncryptPassword: TJvLogonDialogEncryptDecryptEvent;
    function GetOnFillShortcutList: TJvLogonDialogFillListEvent;
    function GetOptions: TJvDBOdacLogonDialogOptions;
    procedure SetAfterTransferSessionDataToConnectionInfo(const Value: TJvLogonDialogConnectionInfoEvent);
    procedure SetBeforeTransferConnectionInfoToSessionData(const Value: TJvLogonDialogConnectionInfoEvent);
    procedure SetDynControlEngine(const Value: TJvDynControlEngine);
    procedure SetOnDecryptPassword(const Value: TJvLogonDialogEncryptDecryptEvent);
    procedure SetOnEncryptPassword(const Value: TJvLogonDialogEncryptDecryptEvent);
    procedure SetOnFillShortcutList(const Value: TJvLogonDialogFillListEvent);
    procedure SetOptions(const Value: TJvDBOdacLogonDialogOptions);
  protected
    procedure SetAppStorage(Value: TJvCustomAppStorage);
    procedure SetAppStoragePath(Value: string); virtual;
    property LogonDialogInternal: TJvDBOdacLogonDialog read FLogonDialogInternal write FLogonDialogInternal;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
  published
    procedure InternalFillDatabaseList(List: TStringList);
    //1 This events gives you the possibility to modify the connection data after receiving the data from the current session
    property AfterTransferSessionDataToConnectionInfo: TJvLogonDialogConnectionInfoEvent read
      GetAfterTransferSessionDataToConnectionInfo write SetAfterTransferSessionDataToConnectionInfo;
    property AppStorage: TJvCustomAppStorage read GetAppStorage write SetAppStorage;
    property AppStoragePath: string read GetAppStoragePath write SetAppStoragePath;
    //1 This Event gives you the possibility to modify the connection data before it is transfered to the current session
    property BeforeTransferConnectionInfoToSessionData: TJvLogonDialogConnectionInfoEvent read
      GetBeforeTransferConnectionInfoToSessionData write SetBeforeTransferConnectionInfoToSessionData;
    property DynControlEngine: TJvDynControlEngine read GetDynControlEngine write
      SetDynControlEngine;
    property Options: TJvDBOdacLogonDialogOptions read GetOptions write SetOptions;
    property OnDecryptPassword: TJvLogonDialogEncryptDecryptEvent read
      GetOnDecryptPassword write SetOnDecryptPassword;
    property OnEncryptPassword: TJvLogonDialogEncryptDecryptEvent read
      GetOnEncryptPassword write SetOnEncryptPassword;
    //1 Event for filling the database list
    property OnFillDatabaseList: TJvLogonDialogFillListEvent read FOnFillDatabaseList write FOnFillDatabaseList;
    //1 Event for customizing the shortcut list
    property OnFillShortcutList: TJvLogonDialogFillListEvent read GetOnFillShortcutList write SetOnFillShortcutList;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL$';
    Revision: '$Revision$';
    Date: '$Date$';
    LogPath: 'JVCL\run'
    );
{$ENDIF UNITVERSIONING}

implementation

uses
  SysUtils, StdCtrls, Dialogs,
  OraClasses, OraError,
  JvDSADialogs, JvDBPasswordDialogOdac, JvResources;

//=== { TJvDBOdacLogonDialogOptions } ========================================

constructor TJvDBOdacLogonDialogOptions.Create;
begin
  inherited Create;
  FShowNetOption := True;
  AllowPasswordChange := True;
  FShowOracleHome := False;
end;

//=== { TjvDBOdacConnectDialog } =============================================

constructor TjvDBOdacConnectDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLogonDialogInternal := TJvDBOdacLogonDialog.Create(Self);
  FLogonDialogInternal.OnFillDatabaseList := InternalFillDatabaseList;
end;

destructor TjvDBOdacConnectDialog.Destroy;
begin
  FreeAndNil(FLogonDialogInternal);
  inherited Destroy;
end;

function TjvDBOdacConnectDialog.Execute: Boolean;
begin
  if Assigned(FLogonDialogInternal) then
  begin
    LogonDialogInternal.Session := Connection;
    Result := LogonDialogInternal.Execute;
  end
  else
    Result := False;
end;

function TjvDBOdacConnectDialog.GetAfterTransferSessionDataToConnectionInfo: TJvLogonDialogConnectionInfoEvent;
begin
  Result := LogonDialogInternal.AfterTransferSessionDataToConnectionInfo;
end;

function TjvDBOdacConnectDialog.GetAppStorage: TJvCustomAppStorage;
begin
  Result := LogonDialogInternal.AppStorage;
end;

function TjvDBOdacConnectDialog.GetAppStoragePath: string;
begin
  Result := LogonDialogInternal.AppStoragePath;
end;

function TjvDBOdacConnectDialog.GetBeforeTransferConnectionInfoToSessionData: TJvLogonDialogConnectionInfoEvent;
begin
  Result := LogonDialogInternal.BeforeTransferConnectionInfoToSessionData;
end;

function TjvDBOdacConnectDialog.GetDynControlEngine: TJvDynControlEngine;
begin
  Result := LogonDialogInternal.DynControlEngine
end;

function TjvDBOdacConnectDialog.GetOnDecryptPassword: TJvLogonDialogEncryptDecryptEvent;
begin
  Result := LogonDialogInternal.OnDecryptPassword;
end;

function TjvDBOdacConnectDialog.GetOnEncryptPassword: TJvLogonDialogEncryptDecryptEvent;
begin
  Result := LogonDialogInternal.OnEncryptPassword;
end;

function TjvDBOdacConnectDialog.GetOnFillShortcutList: TJvLogonDialogFillListEvent;
begin
  Result := LogonDialogInternal.OnFillShortcutList;
end;

function TjvDBOdacConnectDialog.GetOptions: TJvDBOdacLogonDialogOptions;
begin
  Result := LogonDialogInternal.Options
end;

procedure TjvDBOdacConnectDialog.InternalFillDatabaseList(List: TStringList);
begin
  GetServerList(List);
  if Assigned(OnFillDatabaseList) then
    OnFillDatabaseList(List);
end;

procedure TjvDBOdacConnectDialog.SetAfterTransferSessionDataToConnectionInfo(
  const Value: TJvLogonDialogConnectionInfoEvent);
begin
  LogonDialogInternal.AfterTransferSessionDataToConnectionInfo := Value;
end;

procedure TjvDBOdacConnectDialog.SetAppStorage(Value: TJvCustomAppStorage);
begin
  LogonDialogInternal.AppStorage := Value;
end;

procedure TjvDBOdacConnectDialog.SetAppStoragePath(Value: string);
begin
  LogonDialogInternal.AppStoragePath := Value;
end;

procedure TjvDBOdacConnectDialog.SetBeforeTransferConnectionInfoToSessionData(
  const Value: TJvLogonDialogConnectionInfoEvent);
begin
  LogonDialogInternal.BeforeTransferConnectionInfoToSessionData := Value;
end;

procedure TjvDBOdacConnectDialog.SetDynControlEngine(const Value: TJvDynControlEngine);
begin
  LogonDialogInternal.DynControlEngine := Value;
end;

procedure TjvDBOdacConnectDialog.SetOnDecryptPassword(const Value: TJvLogonDialogEncryptDecryptEvent);
begin
  LogonDialogInternal.OnDecryptPassword := Value;
end;

procedure TjvDBOdacConnectDialog.SetOnEncryptPassword(const Value: TJvLogonDialogEncryptDecryptEvent);
begin
  LogonDialogInternal.OnEncryptPassword := Value;
end;

procedure TjvDBOdacConnectDialog.SetOnFillShortcutList(const Value: TJvLogonDialogFillListEvent);
begin
  LogonDialogInternal.OnFillShortcutList := Value;
end;

procedure TjvDBOdacConnectDialog.SetOptions(const Value: TJvDBOdacLogonDialogOptions);
begin
  LogonDialogInternal.Options.Assign(Value);
end;

procedure TJvDBOdacLogonDialog.ClearControlInterfaceObjects;
begin
  inherited ClearControlInterfaceObjects;
  INetOptionCheckBox:= nil;
  IOracleHomeEditData:= nil;
end;

procedure TJvDBOdacLogonDialog.ConnectSession;
begin
  if Assigned(Session) then
  try
    Session.PerformConnect;
  except
    on E: EOraError do
    begin
      case E.ErrorCode of
        1005, 1017:
          ActivatePasswordControl;
        12203, 12154:
          ActivateDatabaseControl;
      end;
      if (E.ErrorCode = 28001) or (E.ErrorCode = 28002) or (E.ErrorCode = 28011) then
        HandleExpiredPassword(E.Message)
      else
        JVDsaDialogs.MessageDlg(E.Message, mtError, [mbok], 0, dckScreen,
          0, mbDefault, mbDefault, mbDefault, DynControlEngine);
    end;
  end;
end;

procedure TJvDBOdacLogonDialog.CreateAdditionalConnectDialogControls(AOwner: TComponent;
  AParentControl: TWinControl);
var
  LabelControl: TControl;
  IDynControlLabel: IJvDynControlLabel;
begin
  inherited CreateAdditionalConnectDialogControls (AOwner, AParentControl);
  OracleHomePanel := DynControlEngine.CreatePanelControl(AOwner, AParentControl, 'OracleHomePanel', '', alTop);
  OracleHomePanel.Align := alTop;
  LabelControl := DynControlEngine.CreateLabelControl(AOwner, OracleHomePanel, 'OracleHomeLabel', RsOracleHome, nil);
  LabelControl.Align := alTop;
  OracleHomeEdit := DynControlEngine.CreateEditControl(AOwner, OracleHomePanel, 'OracleHomeEdit');
  Supports(OracleHomeEdit, IJvDynControlData, IOracleHomeEditData);
  OracleHomeEdit.Align := alTop;
  if Supports(LabelControl, IJvDynControlLabel, IDynControlLabel) then
    IDynControlLabel.ControlSetFocusControl(OracleHomeEdit);
  OracleHomePanel.Visible := Options.ShowOracleHome;
  NetOptionCheckBox := DynControlEngine.CreateCheckboxControl(AOwner,AParentControl, 'NetOptionCheckBox',
    RsUseNetOptionForDirectConnect);
  NetOptionCheckBox.Align := alTop;
  NetOptionCheckBox.Visible := Options.ShowNetOption;
  Supports(NetOptionCheckBox, IJvDynControlCheckBox, INetOptionCheckBox);
  NetOptionCheckBox.Hint := RsNetOptionCheckBoxHint;
end;

procedure TJvDBOdacLogonDialog.CreateFormControls(AForm: TForm);
begin
  inherited CreateFormControls(AForm);
end;

function TJvDBOdacLogonDialog.CreatePasswordChangeDialog:
  TJvBaseDBPasswordDialog;
begin
  Result := TJvDBOdacPasswordDialog.Create(Self);
end;

procedure TJvDBOdacLogonDialog.FillDatabaseComboBoxDefaultValues(Items: TStrings);
begin
end;

class function TJvDBOdacLogonDialog.GetDBLogonDialogOptionsClass: TJvBaseDBLogonDialogOptionsClass;
begin
  Result := TJvDBOdacLogonDialogOptions;
end;

function TJvDBOdacLogonDialog.GetOptions: TJvDBOdacLogonDialogOptions;
begin
  Result := TJvDBOdacLogonDialogOptions(inherited Options);
end;

function TJvDBOdacLogonDialog.GetOraSession: TOraSession;
begin
  Result := FOraSession;
end;

function TJvDBOdacLogonDialog.GetSession: TCustomDAConnection;
begin
  Result := TCustomDAConnection(inherited Session);
end;

procedure TJvDBOdacLogonDialog.HandleExpiredPassword(const ErrorMessage: string);
begin
  if JVDsaDialogs.MessageDlg(ErrorMessage + #13#10 + RsDoYouWantToChangePassword,
    mtInformation, [mbYes, mbNo], 0, dckScreen,
    0, mbDefault, mbDefault, mbDefault, DynControlEngine) = mrYes then
    if ChangePassword then
      if not SessionIsConnected then
        Session.PerformConnect;
end;

procedure TJvDBOdacLogonDialog.ResizeFormControls;
begin
  inherited ResizeFormControls;
  OracleHomePanel.Height := CalculatePanelHeight(OracleHomeEdit);
end;

function TJvDBOdacLogonDialog.SessionIsConnected: Boolean;
begin
  Result := Session.Connected;
end;

procedure TJvDBOdacLogonDialog.SetOptions(const Value: TJvDBOdacLogonDialogOptions);
begin
  (inherited Options).Assign(Value);
end;

procedure TJvDBOdacLogonDialog.SetSession(const Value: TCustomDAConnection);
begin
  inherited SetSession(Value);
  if Value is TOraSession then
    FOraSession := TOraSession(Value)
  else
    FORaSession := nil;
end;

procedure TJvDBOdacLogonDialog.TransferConnectionInfoFromDialog(ConnectionInfo: TJvBaseConnectionInfo);
begin
  inherited TransferConnectionInfoFromDialog(ConnectionInfo);
end;

procedure TJvDBOdacLogonDialog.TransferConnectionInfoToDialog(ConnectionInfo: TJvBaseConnectionInfo);
begin
  inherited TransferConnectionInfoToDialog(ConnectionInfo);
end;

procedure TJvDBOdacLogonDialog.TransferSessionDataFromConnectionInfo(ConnectionInfo: TJvBaseConnectionInfo);
begin
  if Assigned(Session) then
  begin
    Session.Server := ConnectionInfo.Database;
    Session.Password := ConnectionInfo.Password;
    Session.Username := ConnectionInfo.Username;
    if Assigned(OraSession) and (ConnectionInfo is TJvBaseOracleConnectionInfo) then
    begin
      if TJvBaseOracleConnectionInfo(ConnectionInfo).ConnectAs = 'SYSDBA' then
        OraSession.ConnectMode := cmSYSDBA
      else
        if TJvBaseOracleConnectionInfo(ConnectionInfo).ConnectAs = 'SYSOPER' then
          OraSession.ConnectMode := cmSYSOper
        else
          OraSession.ConnectMode := cmNormal;
      if Options.ShowNetOption and Assigned(INetOptionCheckBox) then
        OraSession.Options.Net := INetOptionCheckBox.ControlState = cbChecked;
      if Options.ShowNetOption and Assigned(IOracleHomeEditData) then
        OraSession.HomeName := IOracleHomeEditData.ControlValue;
    end;
  end;
end;

procedure TJvDBOdacLogonDialog.TransferSessionDataToConnectionInfo(ConnectionInfo: TJvBaseConnectionInfo);
begin
  if Assigned(Session) then
  begin
    ConnectionInfo.Database := Session.Server;
    ConnectionInfo.Password := Session.Password;
    ConnectionInfo.Username := Session.Username;
    if Assigned(OraSession) and (ConnectionInfo is TJvBaseOracleConnectionInfo) then
    begin
      case OraSession.ConnectMode of
        cmSYSDBA:
          TJvBaseOracleConnectionInfo(ConnectionInfo).ConnectAs := 'SYSDBA';
        cmSYSOPER:
          TJvBaseOracleConnectionInfo(ConnectionInfo).ConnectAs := 'SYSOPER';
      else
        TJvBaseOracleConnectionInfo(ConnectionInfo).ConnectAs := 'NORMAL';
      end;
      if Options.ShowNetOption and Assigned (INetOptionCheckBox) then
        if OraSession.Options.Net then
          INetOptionCheckBox.ControlState := cbChecked
        else
          INetOptionCheckBox.ControlState := cbUnChecked;
      if Options.ShowNetOption and Assigned (IOracleHomeEditData) then
        IOracleHomeEditData.ControlValue := OraSession.HomeName;
    end;
  end;
end;

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.

