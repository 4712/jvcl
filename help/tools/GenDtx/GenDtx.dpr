program GenDtx;

uses
  Forms,
  MainDlg in 'MainDlg.pas' {frmMain},
  DelphiParser in 'DelphiParser.pas',
  Settings in 'Settings.pas',
  SettingsDlg in 'SettingsDlg.pas' {frmSettings},
  ParserTypes in 'ParserTypes.pas',
  MainCtrl in 'MainCtrl.pas',
  InputDlg in 'InputDlg.pas' {frmInput},
  EditNiceNameDlg in 'EditNiceNameDlg.pas' {frmEditNiceName},
  UnitStatusDlg in 'UnitStatusDlg.pas' {frmUnitStatus},
  DirectoriesDlg in 'DirectoriesDlg.pas' {frmDirectories};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
