program JVCLTest;

uses
  Forms,
  TestFrameWork,
  GUITestRunner,
  SimpleFormU in 'SimpleFormU.pas' {SimpleFrm},
  JvOLBar_Test in 'JvOLBar_Test.pas',
  JvWndProcHook_Test in 'JvWndProcHook_Test.pas';

{$R *.res}

begin
  Application.Initialize;
  GUITestRunner.RunRegisteredTests;
end.
