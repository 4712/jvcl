//---------------------------------------------------------------------------

#include <basepch.h>
#pragma hdrstop
USEFORMNS("..\..\design\JvVirtualKeyEditorForm.pas", Jvvirtualkeyeditorform, frmJvVirtualKeyEditor);
USEFORMNS("..\..\design\JvDirectoryListForm.pas", Jvdirectorylistform, JvDirectoryListDialog);
USEFORMNS("..\..\design\JvIconListForm.pas", Jviconlistform, IconListDialog);
USEFORMNS("..\..\design\JvID3v2DefineForm.pas", Jvid3v2defineform, JvID3DefineDlg);
USEFORMNS("..\..\design\JvID3v2EditorForm.pas", Jvid3v2editorform, JvID3FramesEditor);
USEFORMNS("..\..\design\JvImagePreviewForm.pas", Jvimagepreviewform, ImageForm);
USEFORMNS("..\..\design\JvPictureEditForm.pas", Jvpictureeditform, PictureEditDialog);
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
