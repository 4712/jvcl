{ 
  								  
 		 Globus Delphi VCL Extensions Library		   
 			  ' GLOBUS LIB '			   
  			     Freeware				  
  	  Copyright (c) 2000 Chudin A.V, FidoNet: 1246.16	  
  								  
  
 ===================================================================
 gl3DCol Unit 05.2000 components TglMailSlotServer, TglMailSlotClient
 ===================================================================
}
unit glMSlots;

interface
{$I glDEF.INC}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, extctrls;

type
  TOnNewMessage = procedure (Sender: TObject; MessageText: string) of object;

  TglMailSlotServer = class(TComponent)
  private
    FMailSlotName, FLastMessage: string;
    FOnNewMessage: TOnNewMessage;

    Timer: TTimer;
    h : THandle;
    str : string[250];
    MsgNumber,MsgNext,Read : DWORD;
  public
    FEnabled: boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open;
    procedure Close;
  protected
    procedure Loaded; override;
    procedure OnTimer(Sender: TObject);
  published
    property MailSlotName: string read FMailSlotName write FMailSlotName;
    property OnNewMessage: TOnNewMessage read FOnNewMessage write FOnNewMessage;
  end;


  TglMailSlotClient = class(TComponent)
  private
    FMailSlotName, FServerName: string;
    FOnNewMessage: TOnNewMessage;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Send(str: string):boolean;
  protected
    procedure Loaded; override;
    procedure ErrorCatch(Sender : TObject; Exc : Exception);
  published
    property ServerName: string read FServerName write FServerName;
    property MailSlotName: string read FMailSlotName write FMailSlotName;
    property OnNewMessage: TOnNewMessage read FOnNewMessage write FOnNewMessage;
  end;

procedure Register;

implementation
uses glUtils, glTypes;
procedure Register;
begin
  RegisterComponents('Gl Components', [TglMailSlotServer, TglMailSlotClient]);
end;

constructor TglMailSlotServer.Create(AOwner: TComponent);
begin
  inherited;
  FEnabled := true;  
  FMailSlotName := 'MailSlot';
  Timer := TTimer.Create(nil);
  Timer.Enabled := false;
  Timer.OnTimer := OnTimer;
end;

destructor TglMailSlotServer.Destroy;
begin
  Timer.Free;
  // �������� ������
  Close;
  inherited;
end;

procedure TglMailSlotServer.Loaded;
begin
  inherited;
  Open;
end;

procedure TglMailSlotServer.Open;
begin
//  if not FEnabled then exit;
// �������� ������ � ������ MailSlotName - �� ����� ����� � ����
  // ����� ���������� �������
  h := CreateMailSlot(PChar('\\.\mailslot\' + MailSlotName), 0, MAILSLOT_WAIT_FOREVER,nil);
  //h:=CreateMailSlot('\\.\mailslot\MailSlot',0,MAILSLOT_WAIT_FOREVER,nil);

  if h = INVALID_HANDLE_VALUE then begin
    raise Exception.Create('TglMailSlotServer: ������ �������� ������ !');
  end;
  Timer.Enabled := true;
end;

procedure TglMailSlotServer.Close;
begin
  if h <> 0 then CloseHandle(h);
  h := 0;
end;

procedure TglMailSlotServer.OnTimer(Sender: TObject);
var
  MessageText: string;
begin
//  if not FEnabled then exit;

  MessageText := '';
// ����������� ������� ��������� � ������
  if not GetMailSlotInfo(h,nil,DWORD(MsgNext),@MsgNumber,nil) then
  begin
    raise Exception.Create('TglMailSlotServer: ������ ����� ����������!');
  end;
  if MsgNext <> MAILSLOT_NO_MESSAGE then begin
    beep;
    // ������ ��������� �� ������ � ���������� � ����� ���������
    if ReadFile(h,str,200,DWORD(Read),nil) then
      MessageText := str
    else
      raise Exception.Create('TglMailSlotServer: ������ ������ ��������� !');
  end;

  if (MessageText<>'')and Assigned(OnNewMessage) then OnNewMessage(self, MessageText);

  FLastMessage := MessageText;
end;
//------------------------------------------------------------------------------

constructor TglMailSlotClient.Create(AOwner: TComponent);
begin
  inherited;
  FMailSlotName := 'MailSlot';
  FServerName := '';
end;

destructor TglMailSlotClient.Destroy;
begin
  inherited;
end;

procedure TglMailSlotClient.Loaded;
begin
  inherited;
  Application.OnException := ErrorCatch;
end;

procedure TglMailSlotClient.ErrorCatch(Sender : TObject; Exc : Exception);
var
  UserName: array[0..99] of char;
  i: integer;
begin
  // ��������� ����� ������������
  i:=SizeOf(UserName);
  GetUserName(UserName,DWORD(i));

  Send('/'+UserName+'/'+FormatDateTime('hh:mm',Time)+'/'+Exc.Message);
  // ����� ��������� �� ������ ������������
  Application.ShowException(Exc);
end;

function TglMailSlotClient.Send(str: string):boolean;
var
  strMess: string[250];
  h: THandle;
  i: integer;
begin
  // �������� ������ : MyServer - ��� �������
  // (\\.\\mailslot\xxx - ������� �������� �� ���� �� ��)
  // xxx - ��� ������
  if FServerName = '' then FServerName := '.\';
  h:=CreateFile( PChar('\\' + FServerName + '\mailslot\' + FMailSlotName), GENERIC_WRITE,
                 FILE_SHARE_READ,nil,OPEN_EXISTING, 0, 0);
  if h <> INVALID_HANDLE_VALUE then
  begin
    strMess := str;
    // �������� ������ ������ (������ � ����� � �������� ������)
    WriteFile(h,strMess,Length(strMess)+1,DWORD(i),nil);
    CloseHandle(h);
  end;
  Result := h <> INVALID_HANDLE_VALUE;
end;

end.
