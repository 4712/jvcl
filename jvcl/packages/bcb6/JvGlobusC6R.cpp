//---------------------------------------------------------------------------

#include <basepch.h>
#pragma hdrstop
USEFORMNS("..\..\run\JvgAlignForm.pas", Jvgalignform, AlignForm);
USEFORMNS("..\..\run\JvgCheckVersionInfoForm.pas", Jvgcheckversioninfoform, JvgfCheckVersionInfo);
USEFORMNS("..\..\run\JvgQPrintPreviewForm.pas", Jvgqprintpreviewform, JvgfPrintPreview);
USEFORMNS("..\..\run\JvgQPrintSetupForm.pas", Jvgqprintsetupform, JvgPrintSetup);
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
