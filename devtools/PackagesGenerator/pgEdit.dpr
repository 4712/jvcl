program pgEdit;

uses
  Forms,
  SysUtils,
  MainForm in 'MainForm.pas' {frmMain},
  FileUtils in 'FileUtils.pas',
  TargetDialog in 'TargetDialog.pas' {frmTargets},
  GenerateUtils in 'GenerateUtils.pas',
  KnownTagsForm in 'KnownTagsForm.pas' {frmKnownTags},
  FormTypeDialog in 'FormTypeDialog.pas' {frmFormType},
  AdvancedBCBForm in 'AdvancedBCBForm.pas' {frmAdvancedBCB},
  GenerationMessagesForm in 'GenerationMessagesForm.pas' {frmGenMessages};

{$R *.res}

begin
  Application.Initialize;

  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmTargets, frmTargets);
  Application.CreateForm(TfrmKnownTags, frmKnownTags);
  Application.CreateForm(TfrmFormType, frmFormType);
  Application.CreateForm(TfrmAdvancedBCB, frmAdvancedBCB);
  Application.CreateForm(TfrmGenMessages, frmGenMessages);
  Application.Run;
end.
