//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("JvCtrlsC5D.res");
USEUNIT("..\..\design\JvSpeedbarForm.pas");
USEUNIT("..\..\design\JvBehaviorLabelEditor.pas");
USEUNIT("..\..\design\JvCtrlsReg.pas");
USEUNIT("..\..\design\JvFooterEditor.pas");
USEUNIT("..\..\design\JvHTHintForm.pas");
USEUNIT("..\..\design\JvScrollMaxEditor.pas");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("JvCtrlsC5R.bpi");
USEPACKAGE("dclstd50.bpi");
USEPACKAGE("CJCL50.bpi");
USEPACKAGE("bcbie50.bpi");
USEPACKAGE("bcbsmp50.bpi");
USEPACKAGE("JvCoreC5D.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
