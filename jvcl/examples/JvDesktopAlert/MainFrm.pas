// $Id$
unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, ImgList, Menus, StdCtrls, ComCtrls,
  ExtCtrls, JvDesktopAlert, JvAppStorage, JvAppIniStorage, JvComponent,
  JvFormPlacement, JvBaseDlg;

type
  TfrmMain = class(TForm)
    btnPreview: TButton;
    PopupMenu1: TPopupMenu;
    Examplemenu1: TMenuItem;
    N1: TMenuItem;
    Clickme1: TMenuItem;
    ImageList1: TImageList;
    Label1: TLabel;
    edHeader: TEdit;
    Label2: TLabel;
    edMessage: TEdit;
    Label3: TLabel;
    btnBrowse: TButton;
    Panel1: TPanel;
    Image1: TImage;
    Label4: TLabel;
    Edit1: TEdit;
    udButtons: TUpDown;
    chkClickable: TCheckBox;
    chkMovable: TCheckBox;
    chkClose: TCheckBox;
    Label5: TLabel;
    Edit2: TEdit;
    udWindowCount: TUpDown;
    OpenPictureDialog1: TOpenPictureDialog;
    chkShowDropDown: TCheckBox;
    Label6: TLabel;
    Edit3: TEdit;
    udFadeIn: TUpDown;
    Label7: TLabel;
    Edit4: TEdit;
    udWait: TUpDown;
    Label8: TLabel;
    Edit5: TEdit;
    udFadeOut: TUpDown;
    cbLocation: TComboBox;
    Label9: TLabel;
    JvFormStorage1: TJvFormStorage;
    JvAppIniFileStorage1: TJvAppIniFileStorage;
    procedure btnPreviewClick(Sender: TObject);
    procedure Clickme1Click(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
  private
    FCount:integer;
    procedure DoButtonClick(Sender: TObject);
    procedure DoMessageClick(Sender: TObject);
    procedure DoAlertClose(Sender: TObject);
    procedure DoAlertShow(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation


{$R *.dfm}

procedure TfrmMain.DoMessageClick(Sender:TObject);
begin
  ShowMessage('You clicked the message!');
end;

procedure TfrmMain.DoButtonClick(Sender:TObject);
begin
  with Sender as TControl do
    ShowMessageFmt('You clicked button %d!',[Tag]);
end;

procedure TfrmMain.DoAlertShow(Sender: TObject);
begin
  Inc(FCount);
  Caption := Format('JvDesktopAlert Demo: showing %d alerts',[FCount]);
end;

procedure TfrmMain.DoAlertClose(Sender: TObject);
begin
  Dec(FCount);
//  if FCount < 0 then FCount := 0;
  Caption := Format('JvDesktopAlert Demo: showing %d alerts',[FCount]);
end;

procedure TfrmMain.btnPreviewClick(Sender: TObject);
var
  i,j:integer;
  DA:TJvDesktopAlert;
  FOptions:TJvDesktopAlertOptions;
begin
  for i := 0 to udWindowCount.Position - 1 do
  begin
    DA := TJvDesktopAlert.Create(Self);
    DA.Images := ImageList1;
    DA.HeaderText := Format('%s (%d)', [edHeader.Text, FCount]);
    DA.MessageText := edMessage.Text;
    DA.Image := Image1.Picture;
    DA.OnMessageClick := DoMessageClick;
    DA.OnShow := DoAlertShow;
    DA.OnClose := DoAlertClose;
    FOptions := [daoCanFade];
    DA.Options := FOptions;
    DA.Location.AlwaysResetPosition := false;
    DA.Location.Position := TJvDesktopAlertPosition(cbLocation.ItemIndex);
    if DA.Location.Position = dapCustom then
    begin
      DA.Location.Left := Random(Screen.Width - 200);
      DA.Location.Top :=  Random(Screen.Height - 100);
    end;
    DA.FadeInTime := udFadeIn.Position;
    DA.WaitTime  := udWait.Position; //  + Random(WaitTime);
    DA.FadeOutTime := udFadeOut.Position;

    if chkClickable.Checked then
      Include(FOptions,daoCanClick);
    if chkMovable.Checked then
      Include(FOptions, daoCanMove);
    if chkClose.Checked then
      Include(FOptions, daoCanClose);
    DA.Options := FOptions;
    if chkShowDropDown.Checked then
      DA.DropDownMenu := PopupMenu1;
    for j := 0 to udButtons.Position do
    begin
      with DA.Buttons.Add do
      begin
        ImageIndex := Random(ImageList1.Count);
        Tag := j;
        OnClick := DoButtonClick;
      end;
    end;
    DA.Execute;
  end;
end;

procedure TfrmMain.Clickme1Click(Sender: TObject);
begin
  ShowMessage('You clicked the menu!');
end;

procedure TfrmMain.btnBrowseClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
    Image1.Picture.LoadFromFile(OpenPictureDialog1.Filename);
end;

end.
