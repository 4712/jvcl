// $Id$
unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, CheckLst, JvComponent, JvNavigationPane, ImgList, Menus;

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    LargeImages: TImageList;
    HideAll1: TMenuItem;
    ShowAll1: TMenuItem;
    N1: TMenuItem;
    Dontallowresize1: TMenuItem;
    ChangeFont1: TMenuItem;
    SmallImages: TImageList;
    Colors1: TMenuItem;
    Standard1: TMenuItem;
    Blue1: TMenuItem;
    Silver1: TMenuItem;
    Olive1: TMenuItem;
    JvNavPaneStyleManager1: TJvNavPaneStyleManager;
    procedure FormCreate(Sender: TObject);
    procedure Dontallowresize1Click(Sender: TObject);
    procedure HideAll1Click(Sender: TObject);
    procedure ShowAll1Click(Sender: TObject);
    procedure ChangeFont1Click(Sender: TObject);
    procedure SchemaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NP:TJvNavigationPane;
  end;

var
  Form1: TForm1;

implementation
uses
  CommCtrl;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  Page:TJvNavPanelPage;
  GH:TJvNavPanelHeader;
  N:TTreeNode;
  R:TRect;
begin
  JvNavPaneStyleManager1.Theme := nptCustom;
  // this is how to create a NavPane at run-time
  // also shows how to create and insert pages as well as controls on pages
  NP := TJvNavigationPane.Create(Self);

  NP.Parent := Self;
  NP.Cursor := crHandPoint;
  NP.Width := 220;
//  NP.BorderWidth := 2;
  NP.Align := alClient;
  NP.DropDownMenu := PopupMenu1;
  NP.SmallImages := SmallImages;
  NP.LargeImages := LargeImages;
  NP.StyleManager := JvNavPaneStyleManager1;

  Page := TJvNavPanelPage.Create(Self);
  Page.Caption := 'Mail';
  Page.ImageIndex := 0;
  Page.PageList := NP;
  GH := TJvNavPanelHeader.Create(Self);
  GH.Parent := Page;
  GH.Align := alTop;
  GH.Images := SmallImages;
  GH.ImageIndex := -1;
  GH.Caption := Page.Caption;
  GH.StyleManager := JvNavPaneStyleManager1;
  // use a button here instad of the icon:
  with TJvNavIconButton.Create(Self) do
  begin
    Parent := GH;
    Align := alRight;
    ButtonType := nibImage;
//    Colors.SelectedColorFrom := clNone;
//    Colors.SelectedColorTo := clNone;
    Colors.ButtonHotColorFrom := clNone;
    Colors.ButtonHotColorTo := clNone;
    Images := SmallImages;
    DropDownMenu := PopupMenu1;
    ImageIndex := 0;
    StyleManager := JvNavPaneStyleManager1;
  end;

  with TJvNavPanelDivider.Create(Self) do
  begin
    Caption := 'Favorite Folders';
    Parent := Page;
    Top := 100;
    Align := alTop;
    Enabled := false;
    Cursor := crDefault;
    StyleManager := JvNavPaneStyleManager1;
  end;

  with TTreeView.Create(Self) do
  begin
    Parent := Page;
    Top := 200;
    Align := alTop;
    Font.Style := [];
    BorderStyle := bsNone;
    Items.Add(nil,'Inbox');
    Items.Add(nil,'Unread Mail');
    Items.Add(nil,'For Follow Up [4]');
    Items.Add(nil,'Sent Items');
    Height := 100;
  end;

  with TJvNavPanelDivider.Create(Self) do
  begin
    Caption := 'All Mail Folders';
    Parent := Page;
    Top := 100;
    Align := alTop;
    Cursor := crSizeNS;
    StyleManager := JvNavPaneStyleManager1;
  end;

  with TTreeView.Create(Self) do
  begin
    Parent := Page;
    Align := alClient;
    BorderStyle := bsNone;
    Font.Style := [];
    N := Items.Add(nil,'Mailbox - Chris Gray');
    Items.AddChild(N,'Deleted Items');
    Items.AddChild(N,'Drafts');
    Items.AddChild(N,'Inbox');
    Items.AddChild(N,'Junk E-mail');
    Items.AddChild(N,'Outbox');
    Items.AddChild(N,'Sent Items');
    N := Items.AddChild(N,'Search Folders');
    Items.AddChild(N,'For Follow Up [4]');
    Items.AddChild(N,'Large Mail');
    Items.AddChild(N,'Unread Mail');
    FullExpand;
  end;

  Page := TJvNavPanelPage.Create(Self);
  Page.Caption := 'Calendar';
  Page.ImageIndex := 1;
  Page.PageList := NP;
  GH := TJvNavPanelHeader.Create(Self);
  GH.Parent := Page;
  GH.Align := alTop;
  GH.Caption := Page.Caption;
  GH.Images := SmallImages;
  GH.ImageIndex := Page.ImageIndex;
  GH.StyleManager := JvNavPaneStyleManager1;
  // NB! TMonthCalendar messes up the form when you size the form smaller than one calendar width
  with TMonthCalendar.Create(Self) do
  begin
    Parent := Page;
    Align := alTop;
    AutoSize := true;
    AutoSize := false;
    Date := SysUtils.Date;
    MonthCal_GetMinReqRect(Handle, R);
  end;
  Constraints.MinHeight := R.Bottom - R.Top + 12;
  Constraints.MinWidth := R.Right - R.Left + 12;


  with TJvNavPanelDivider.Create(Self) do
  begin
    Caption := 'My Calendars';
    Parent := Page;
    Top := 1500;
    Align := alTop;
    Cursor := crDefault;
    Enabled := false;
    StyleManager := JvNavPaneStyleManager1;
  end;
  with TCheckListBox.Create(Self) do
  begin
    Parent := Page;
    Checked[Items.Add('Calendar')] := true;
    Items.Add('Project Schedule');
    Top := 1500;
    Height := 32;
    Align := alTop;
  end;
  with TJvNavPanelDivider.Create(Self) do
  begin
    Caption := 'Other Calendars';
    Parent := Page;
    Top := 1500;
    Align := alTop;
    Cursor := crSizeNS;
    StyleManager := JvNavPaneStyleManager1;
  end;
  with TCheckListBox.Create(Self) do
  begin
    Parent := Page;
    Checked[Items.Add('Alan Chong')] := Random(4) = 1;
    Checked[Items.Add('Andreas Hausladen')] := Random(4) = 1;
    Checked[Items.Add('Andr� Snepvangers')] := Random(4) = 1;
    Checked[Items.Add('Michael Beck')] := Random(4) = 1;
    Checked[Items.Add('Leroy Casterline')] := Random(4) = 1;
    Checked[Items.Add('Chris Latta')] := Random(4) = 1;
    Checked[Items.Add('Erwin Molendijk')] := Random(4) = 1;
    Checked[Items.Add('James Lan')] := Random(4) = 1;
    Checked[Items.Add('Ignacio Vazquez')] := Random(4) = 1;
    Checked[Items.Add('Marcel Bestebroer')] := Random(4) = 1;
    Checked[Items.Add('Jens Fudickar')] := Random(4) = 1;
    Checked[Items.Add('Jose Perez')] := Random(4) = 1;
    Checked[Items.Add('Marc Hoffmann')] := Random(4) = 1;
    Checked[Items.Add('Fernando Silva')] := Random(4) = 1;
    Checked[Items.Add('Robert Marquardt')] := Random(4) = 1;
    Checked[Items.Add('Matthias Thoma')] := Random(4) = 1;
    Checked[Items.Add('Olivier Sannier')] := Random(4) = 1;
    Checked[Items.Add('Oliver Giesen')] := Random(4) = 1;
    Checked[Items.Add('Dmitry Osinovsky')] := Random(4) = 1;
    Checked[Items.Add('Peter Thornqvist')] := Random(4) = 1;
    Checked[Items.Add('henri gourvest')] := Random(4) = 1;
    Checked[Items.Add('Rob den Braasem')] := Random(4) = 1;
    Checked[Items.Add('Remko Bonte')] := Random(4) = 1;
    Checked[Items.Add('Christian Vogt')] := Random(4) = 1;
    Checked[Items.Add('Warren Postma')] := Random(4) = 1;
    Top := 1500;
    Align := alClient;
  end;

  Page := TJvNavPanelPage.Create(Self);
  Page.Caption := 'Contacts';
  Page.ImageIndex := 2;
  Page.PageList := NP;
  GH := TJvNavPanelHeader.Create(Self);
  GH.Parent := Page;
  GH.Align := alTop;
  GH.Caption := Page.Caption;
  GH.Images := SmallImages;
  GH.ImageIndex := Page.ImageIndex;
  GH.StyleManager := JvNavPaneStyleManager1;
  with TListBox.Create(Self) do
  begin
    Parent := Page;
    Align := alClient;
    Items.Add('Alan Chong');
    Items.Add('Andreas Hausladen');
    Items.Add('Andr� Snepvangers');
    Items.Add('Michael Beck');
    Items.Add('Leroy Casterline');
    Items.Add('Chris Latta');
    Items.Add('Erwin Molendijk');
    Items.Add('James Lan');
    Items.Add('Ignacio Vazquez');
    Items.Add('Marcel Bestebroer');
    Items.Add('Jens Fudickar');
    Items.Add('Jose Perez');
    Items.Add('Marc Hoffmann');
    Items.Add('Fernando Silva');
    Items.Add('Robert Marquardt');
    Items.Add('Matthias Thoma');
    Items.Add('Olivier Sannier');
    Items.Add('Oliver Giesen');
    Items.Add('Dmitry Osinovsky');
    Items.Add('Peter Thornqvist');
    Items.Add('henri gourvest');
    Items.Add('Rob den Braasem');
    Items.Add('Remko Bonte');
    Items.Add('Christian Vogt');
    Items.Add('Warren Postma');
  end;


  Page := TJvNavPanelPage.Create(Self);
  Page.Caption := 'Tasks';
  Page.ImageIndex := 3;
  Page.PageList := NP;
  GH := TJvNavPanelHeader.Create(Self);
  GH.Parent := Page;
  GH.Align := alTop;
  GH.Caption := Page.Caption;
  GH.Images := SmallImages;
  GH.ImageIndex := Page.ImageIndex;
  GH.StyleManager := JvNavPaneStyleManager1;

  Page := TJvNavPanelPage.Create(Self);
  Page.Caption := 'Notes';
  Page.ImageIndex := 4;
  Page.PageList := NP;
  GH := TJvNavPanelHeader.Create(Self);
  GH.Parent := Page;
  GH.Align := alTop;
  GH.Caption := Page.Caption;
  GH.Images := SmallImages;
  GH.ImageIndex := Page.ImageIndex;
  GH.StyleManager := JvNavPaneStyleManager1;


  Page := TJvNavPanelPage.Create(Self);
  Page.Caption := 'Folder List';
  Page.ImageIndex := 5;
  Page.PageList := NP;
  GH := TJvNavPanelHeader.Create(Self);
  GH.Parent := Page;
  GH.Align := alTop;
  GH.Caption := Page.Caption;
  GH.Images := SmallImages;
  GH.ImageIndex := Page.ImageIndex;
  GH.StyleManager := JvNavPaneStyleManager1;

{  with TJvOutlookSplitter.Create(Self) do
  begin
    Align := alNone;
    Parent := Self;
    Left := NP.Width + 100;
    Align := alLeft;
    Width := 7;
    Cursor := crSizeWE;
  end;
  }
  NP.ActivePageIndex := 0;
  // now, set the real start theme:
  JvNavPaneStyleManager1.Theme := nptStandard;
end;

procedure TForm1.Dontallowresize1Click(Sender: TObject);
begin
  Dontallowresize1.Checked := not Dontallowresize1.Checked;
  NP.Resizable := not Dontallowresize1.Checked;
end;

procedure TForm1.HideAll1Click(Sender: TObject);
begin
  NP.MaximizedCount := 0;
end;

procedure TForm1.ShowAll1Click(Sender: TObject);
begin
  NP.MaximizedCount := NP.PageCount;
end;

procedure TForm1.ChangeFont1Click(Sender: TObject);
begin
 if NP.NavPanelFont.Style = [fsBold] then
   NP.NavPanelFont.Style := [fsItalic, fsBold]
 else
   NP.NavPanelFont.Style := [fsBold];
end;

procedure TForm1.SchemaClick(Sender: TObject);
begin
  JvNavPaneStyleManager1.Theme := TJvNavPanelTheme((Sender as TMenuItem).Tag);
  (Sender as TMenuItem).Checked := true;
end;

end.

