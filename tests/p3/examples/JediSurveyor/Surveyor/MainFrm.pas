unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, JvScrollBox, ComCtrls, JvProgressBar,
  JvBevel, Buttons, JvBitBtn, JvFooter, JvComponent, JvSurveyIntf,
  JvDialogs, ImgList, JvImageWindow, ActnList, JvActions, JvLinkLabel,
  JvRadioButton, JvCheckBox;

type
  TfrmMain = class(TForm)
    pnlTop: TPanel;
    lblTitle: TLabel;
    JvFooter1: TJvFooter;
    btnPrev: TJvFooterBtn;
    btnNext: TJvFooterBtn;
    btnClose: TJvFooterBtn;
    sbSurvey: TJvScrollBox;
    OpenSurveyDialog: TJvOpenDialog;
    JediLogo: TJvImageSquare;
    il48: TImageList;
    alMain: TActionList;
    acStartPage: TAction;
    acPrevPage: TAction;
    acNextPage: TAction;
    acLoadSurvey: TAction;
    acSendMail: TJvSendMail;
    acGotoJVCL: TJvWebAction;
    acLastPage: TAction;
    acExit: TAction;
    JvBevel1: TJvBevel;
    lblProgress: TLabel;
    lblDescription: TJvLinkLabel;
    lblSurveyTitle: TLabel;
    btnOpen: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure acStartPageExecute(Sender: TObject);
    procedure acLastPageExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure acPrevPageExecute(Sender: TObject);
    procedure alMainUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure acNextPageExecute(Sender: TObject);
    procedure acLoadSurveyExecute(Sender: TObject);
    procedure lblDescriptionLinkClick(Sender: TObject; LinkNumber: Integer;
      LinkText: String);
  private
    FFilename: string;
    FCompletedSurvey:boolean;
  private
    { Private declarations }
    FSurvey: IJvSurvey;
    FPageIndex: integer;
    edUserName, edUserEMail: TEdit;

    procedure CreateEverything;
    procedure LoadSettings;
    procedure ReadCommandLine;
    procedure LoadSurvey(const AFilename: string);
    function GetTempSurveyFileName: string;
    procedure PromptForSurveyFile(const AFilename: string);
    procedure SaveSettings;
    procedure FreeEverything;
    procedure ClearScrollBox;

    function CheckPage(Index:integer): boolean;
    procedure StartPage;
    procedure EndPage;
    procedure CreateExclusivePage(Index:integer);
    procedure CreateMultiplePage(Index:integer);
    procedure CreateFreeFormPage(Index:integer);
    procedure SavePage;
    procedure UpdateProgress;
    procedure CreatePage(Index: integer);
    procedure DoSendMail(Sender: TObject);
    property Filename: string read FFilename write FFilename;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

resourcestring
  SMainFormCaptionFmt = 'JEDI Surveyor - (%s)';
  SDefaultSurveyName = 'No survey loaded!';
  SStartPageTitle = 'Welcome to the JEDI Surveyor';
  SStartPageDescription = 'The JEDI Surveyor is a tool to collect user input on various issues.' +
    ' Currently no survey is loaded. To load a survey, click the "Open" button and select a survey file from the dialog.';
  SEndPageTitle = 'Survey completed';
  SEndPageDescriptionFmt =
    'Click the "Send" button below to send an e-mail to %s with your answers. The results of the survey will be made available at the following location: <link>%s</link>. Enter a username and and e-mail address to help us keep track of participants (optional).';
  SExpiredSurveyCaption = 'Survey expired!';
  SExpiredSurveyTextFmt = 'This survey expired on %s, would you like to view it anyway?';
  SErrSurveyImplementationNotFound = 'Fatal Error: No IJvSurvey implementation found, cannot continue!';
  SUsername = '&Username:';
  SEmail = '&E-mail address:';
  SSend = '&Send';
  SSaveResponseCaption = 'Save responses';
  SSaveResponsePrompt = 'You haven''t completed the survey. Do you want to save your responses this far?';
  SPageOfPageFmt = 'Page %d of %d';

const
  cStartOffset = 24;
  cDefaultControlWidth = 125;

implementation
uses
  JclStrings, JclSysInfo, JvFunctions, JvSurveyUtils, Math;

{$R *.dfm}


function TextSize(Canvas: TCanvas; DefaultHeight:integer; const S: string): TSize;
var
  i: integer;
  T:TStringlist;
begin
  Result.cx := 0;
  Result.cy := 0;
  T := TStringlist.Create;
  try
    T.Text := S;
    for i := 0 to T.Count - 1 do
    begin
      Result.cx := Max(Result.cx, Canvas.TextWidth(T[i]));
      Inc(Result.cy, DefaultHeight);
    end;
  finally
    T.Free;
  end;
  if Result.cy <= 0 then Result.cy := DefaultHeight;
end;

{ TfrmMain }

procedure TfrmMain.CreatePage(Index: integer);
begin
  if (Index < 0) then
    StartPage
  else if (FSurvey.Items.Count > 0) and (Index >= FSurvey.Items.Count) then
    EndPage
  else
  begin
    lblTitle.Caption := FSurvey.Items[Index].Title;
    lblDescription.Caption := FSurvey.Items[Index].Description;
    case FSurvey.Items[Index].SurveyType of
      stExclusive:
        CreateExclusivePage(Index);
      stMultiple:
        CreateMultiplePage(Index);
      stFreeForm:
        CreateFreeFormPage(Index);
    end;
  end;
  UpdateProgress;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  CreateEverything;
  LoadSettings;
  ReadCommandLine;
end;

procedure TfrmMain.CreateEverything;
begin
  FPageIndex := -1;
  if Assigned(CreateSurvey) then
    FSurvey := CreateSurvey
  else
  begin
    ShowMessage(SErrSurveyImplementationNotFound);
    Application.Terminate;
    Close;
  end;
end;

procedure TfrmMain.FreeEverything;
begin
  FSurvey := nil;
end;

procedure TfrmMain.LoadSettings;
begin
  JediLogo.Anchors := [akRight, akTop];
  JediLogo.Action := acGotoJVCL;
  // TODO:save additional properties
end;

procedure TfrmMain.ReadCommandLine;
var
  S:string;
  i: integer;
begin
  S := '';
  for i := 1 to ParamCount do
    if FileExists(ExpandUNCFileName(ParamStr(i))) then
    begin
      S := ExpandUNCFileName(ParamStr(i));
      Break;
    end;
  if S <> '' then
    LoadSurvey(S)
  else
    StartPage;
end;

procedure TfrmMain.SaveSettings;
begin
  // TODO: save settings
end;

procedure TfrmMain.PromptForSurveyFile(const AFilename: string);
begin
  OpenSurveyDialog.Filename := AFilename;
  acLoadSurvey.Execute;
end;

procedure TfrmMain.LoadSurvey(const AFilename: string);
begin
  if FileExists(AFilename) then
  begin
    FSurvey.LoadFromFile(AFilename);
    FFilename := AFilename;
    StartPage;
    if (FSurvey.ExpiryDate < Date) and not YesNo(SExpiredSurveyCaption, Format(SExpiredSurveyTextFmt,[DateToStr(FSurvey.ExpiryDate)])) then
      PromptForSurveyFile(AFilename)
  end
  else
    PromptForSurveyFile(AFilename);
  Caption := Format(SMainFormCaptionFmt, [ExtractFileName(Filename)]);
  lblSurveyTitle.Caption := FSurvey.Title;
end;

procedure TfrmMain.StartPage;
begin
  SavePage;
  ClearScrollBox;
  FPageIndex := -1;
  lblTitle.Caption := SStartPageTitle;
  if (FSurvey.Items.Count < 1) then
    lblDescription.Caption := SStartPageDescription
  else
    lblDescription.Caption := FSurvey.Description;
  lblProgress.Visible := false;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not FCompletedSurvey and (FSurvey.Items.Count > 0) and YesNo(SSaveResponseCaption,SSaveResponsePrompt) then
    FSurvey.SaveToFile(Filename);
  SaveSettings;
  FreeEverything;
end;

procedure TfrmMain.ClearScrollBox;
begin
  while sbSurvey.ControlCount > 0 do
    sbSurvey.Controls[0].Free;
  edUserName := nil;
  edUserEMail := nil;
end;

procedure TfrmMain.EndPage;
begin
  SavePage;
  ClearScrollBox;
  FPageIndex := FSurvey.Items.Count;
  lblTitle.Caption := SEndPageTitle;
  lblDescription.Caption := Format(SEndPageDescriptionFmt, [FSurvey.Recipient, FSurvey.ResultHRef]);
  // TODO: enable mail button
  edUserName := TEdit.Create(self);
  with edUserName do
  begin
    Parent := sbSurvey;
    SetBounds(18, 36, sbSurvey.ClientWidth - 36, Height);
    TabOrder := 0;
    Text := FSurvey.SurveyTaker.UserName;
  end;
  with TLabel.Create(self) do
  begin
    Parent := sbSurvey;
    SetBounds(18, 18, Width, Height);
    Caption := SUserName;
    FocusControl := edUserName;
  end;
  edUserEmail := TEdit.Create(self);
  with edUserEmail do
  begin
    Parent := sbSurvey;
    SetBounds(18, 84, sbSurvey.ClientWidth - 36, Height);
    TabOrder := 1;
    Text := FSurvey.SurveyTaker.MailAddress;
  end;
  with TLabel.Create(self) do
  begin
    Parent := sbSurvey;
    SetBounds(18, 66, Width, Height);
    Caption := SEMail;
    FocusControl := edUserEmail;
  end;

  with TButton.Create(self) do
  begin
    Parent := sbSurvey;
    SetBounds(sbSurvey.ClientWidth - 25 - Width, 126, Width, Height);
    Caption := SSend;
    OnClick := DoSendMail;
    TabOrder := 2;
    Enabled := FSurvey.ExpiryDate >= Date;
  end;
  UpdateProgress;
end;

procedure TfrmMain.acStartPageExecute(Sender: TObject);
begin
  CreatePage(-1);
end;

procedure TfrmMain.acLastPageExecute(Sender: TObject);
begin
  CreatePage(FSurvey.Items.Count);
end;

procedure TfrmMain.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.acPrevPageExecute(Sender: TObject);
begin
  SavePage;
  Dec(FPageIndex);
  CreatePage(FPageIndex);
  UpdateProgress;
end;

procedure TfrmMain.acNextPageExecute(Sender: TObject);
begin
  SavePage;
  Inc(FPageIndex);
  CreatePage(FPageIndex);
  UpdateProgress;
end;

procedure TfrmMain.alMainUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  acPrevPage.Enabled := (FPageIndex >= 0);
  acNextPage.Enabled := (Filename <> '') and (FSurvey.Items.Count > 0) 
    and (FPageIndex < FSurvey.Items.Count) and CheckPage(FPageIndex);
  lblProgress.Visible := (FPageIndex >= 0) and (FPageIndex <= FSurvey.Items.Count);

  acLoadSurvey.Visible := FPageIndex = -1;
  acLoadSurvey.Enabled := acLoadSurvey.Visible;
  lblSurveyTitle.Visible := not acLoadSurvey.Visible;
end;

function TfrmMain.CheckPage(Index:integer): boolean;

  function HasCheckedItems: boolean;
  var
    i: integer;
  begin
    if (FSurvey.Items[Index].SurveyType = stFreeForm) or not FSurvey.Items[Index].Required then
      Result := true
    else
    begin
      with sbSurvey do
        for i := 0 to ControlCount - 1 do
          if ((Controls[i] is TRadioButton) and TRadioButton(Controls[i]).Checked) or
            ((Controls[i] is TCheckBox) and TCheckBox(Controls[i]).Checked) then
          begin
            Result := true;
            Exit;
          end;
      Result := false;
    end;
  end;
begin
  Result := (Index < 0) or (Index >= FSurvey.Items.Count) or HasCheckedItems;
end;

procedure TfrmMain.CreateExclusivePage(Index:integer);
var
  i, j, X, Y, AWidth: integer;
  ASize: TSize;
  RB: TJvRadioButton;
  S: TStringlist;
begin
  ClearScrollBox;
  X := cStartOffset;
  Y := cStartOffset;
  AWidth := cDefaultControlWidth;
  S := TStringlist.Create;
  try
//    S.CommaText := FSurvey.Items[Index].Choices;
    S.Text := DecodeChoice(FSurvey.Items[Index].Choices,stExclusive);
    j := 0;
    for i := 0 to S.Count - 1 do
    begin
      if S[i] = '' then Continue;
      RB := TJvRadioButton.Create(Self);
      RB.Caption := DecodeString(S[i]);
      ASize := TextSize(Canvas, RB.Height, RB.Caption);
      AWidth := Max(AWidth, ASize.cx + 32);
      RB.SetBounds(X, Y, AWidth, ASize.cy);
      RB.Checked := IsChecked(FSurvey.Items[Index], j);
      Inc(Y, ASize.cy + 4);
      if Y >= sbSurvey.ClientHeight - ASize.cy - cStartOffset then
      begin
        Y := cStartOffset;
        Inc(X, AWidth + cStartOffset);
      end;
      RB.Parent := sbSurvey;
      Inc(j);
    end;
  finally
    S.Free;
  end;
end;

procedure TfrmMain.CreateFreeFormPage(Index:integer);
begin
  ClearScrollBox;
  with TRichEdit.Create(self) do
  begin
    Parent := sbSurvey;
    SetBounds(cStartOffset, cStartOffset,
      sbSurvey.ClientWidth - cStartOffset * 2, sbSurvey.ClientHeight - cStartOffset * 2);
    Anchors := [akLeft..akBottom];
    PlainText := true;
    ScrollBars := ssBoth;
    if FSurvey.Items[FPageIndex].Responses = '' then
      Lines.Text := DecodeChoice(FSurvey.Items[Index].Choices,stFreeForm)
    else
      Lines.Text := DecodeResponse(FSurvey.Items[Index].Responses,stFreeForm);
  end;
end;

procedure TfrmMain.CreateMultiplePage(Index:integer);
var
  i, j, X, Y, AWidth: integer;
  CB: TJvCheckBox;
  ASize: TSize;
  S: TStringlist;
begin
  ClearScrollBox;
  X := cStartOffset;
  Y := cStartOffset;
  AWidth := cDefaultControlWidth;
  S := TStringlist.Create;
  try
//    S.CommaText := FSurvey.Items[Index].Choices;
    S.Text := DecodeChoice(FSurvey.Items[Index].Choices,stMultiple);
    j := 0;
    for i := 0 to S.Count - 1 do
    begin
      if S[i] = '' then Continue;
      CB := TJvCheckBox.Create(Self);
      CB.Caption := S[i];
      ASize := TextSize(Canvas, CB.Height, CB.Caption);
      AWidth := Max(AWidth, ASize.cx + 32);
      CB.SetBounds(X, Y, AWidth, ASize.cy);
      CB.Checked := IsChecked(FSurvey.Items[Index], j);
      Inc(Y, ASize.cy + 4);
      if Y >= sbSurvey.ClientHeight - ASize.cy - cStartOffset then
      begin
        Y := cStartOffset;
        Inc(X, AWidth + cStartOffset);
      end;
      CB.Parent := sbSurvey;
      Inc(j);
    end;
  finally
    S.Free;
  end;
end;

procedure TfrmMain.acLoadSurveyExecute(Sender: TObject);
begin
  if OpenSurveyDialog.Execute then
    LoadSurvey(OpenSurveyDialog.Filename)
  else
    StartPage;
end;

function TfrmMain.GetTempSurveyFileName: string;

  function DefaultStr(const S, Default: string): string;
  begin
    Result := S;
    if Result = '' then
      Result := Default;
  end;
begin
  // create a file name from the input filename, username, current date and time
  // and add a path
  Result := ExtractFilePath(Application.ExeName) + ChangeFileExt(ExtractFileName(Filename), '') +
    DefaultStr(FSurvey.SurveyTaker.UserName, GetLocalUserName) +
    FormatDateTime('yyyyMMddhhnnss', Now) + cResponseFileExt;
  //  ShowMessage(Result);
end;

procedure TfrmMain.SavePage;
var
  i: integer;S:string;
begin
  if (FPageIndex < 0) or (FPageIndex >= FSurvey.Items.Count) then Exit;
  S := '';
  with sbSurvey do
    for i := 0 to ControlCount - 1 do
    begin
      if Controls[i] is TRadioButton then
        S := S + Format('%d', [Ord(TRadioButton(Controls[i]).Checked)]) + cRecordSeparator
      else if Controls[i] is TCheckBox then
        S := S + Format('%d', [Ord(TCheckBox(Controls[i]).Checked)]) + cRecordSeparator
      else if Controls[i] is TCustomMemo then
        S := TCustomMemo(Controls[i]).Lines.Text
      else if Controls[i] is TCustomEdit then
        S := TCustomEdit(Controls[i]).Text;
    end;
  if MyAnsiLastChar(S) = cRecordSeparator then SetLength(S,Length(S)-1);
  FSurvey.Items[FPageIndex].Responses := S;
end;

procedure TfrmMain.UpdateProgress;
begin
  if FPageIndex >= 0 then
    lblProgress.Caption := Format(SPageOfPageFmt, [FPageIndex + 1, FSurvey.Items.Count + 1])
  else
    lblProgress.Caption := '';
end;

procedure TfrmMain.DoSendMail(Sender: TObject);
var S:string;
begin
  acSendMail.Mail.Recipients := FSurvey.RecipientMail;
  acSendMail.Mail.Subject := FSurvey.Title;
  if edUserName <> nil then
    FSurvey.SurveyTaker.UserName := edUserName.Text;
  if edUserEMail <> nil then
    FSurvey.SurveyTaker.MailAddress := edUserEMail.Text;
  // create and attach response file
  acSendMail.Mail.Attachments.Clear;
  S := GetTempSurveyFileName;
  FSurvey.SaveToFile(S);
  acSendMail.Mail.Attachments.Add(S);

  acSendMail.Mail.ShowDialogs := true; // not acSendMail.Mail.UserLogged;
  if acSendMail.Mail.Execute then
    FCompletedSurvey := true;
end;

procedure TfrmMain.lblDescriptionLinkClick(Sender: TObject;
  LinkNumber: Integer; LinkText: String);
begin
  OpenObject(LinkText);
end;

end.

