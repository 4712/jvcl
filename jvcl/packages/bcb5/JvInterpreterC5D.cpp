//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("JvInterpreterC5D.res");
USEUNIT("..\..\design\JvInterpreterReg.pas");
USEPACKAGE("JvCoreC5D.bpi");
USEPACKAGE("JvCustomC5R.bpi");
USEPACKAGE("JvCtrlsC5R.bpi");
USEPACKAGE("JvStdCtrlsC5R.bpi");
USEPACKAGE("JvSystemC5R.bpi");
USEPACKAGE("JvInterpreterC5R.bpi");
USEPACKAGE("CJCL50.bpi");
USEPACKAGE("dclstd50.bpi");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcldb50.bpi");
USEPACKAGE("vclbde50.bpi");
USEPACKAGE("qrpt50.bpi");

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

