{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvNetReg.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is John Doe.
Portions created by John Doe are Copyright (C) 2003 John Doe.
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

{$I jvcl.inc}

unit JvNetReg;

interface

procedure Register;

implementation

uses
  Classes,
  {$IFDEF COMPILER6_UP}
  DesignEditors, DesignIntf,
  {$ELSE}
  DsgnIntf,
  {$ENDIF COMPILER6_UP}
  {$IFDEF MSWINDOWS}
  JvHTMLParser, JvMail,  JvMailEditor, JvHTMLParserEditor,
  JvUrlListGrabber, JvUrlGrabbers, JvUrlListGrabberEditors,
  {$ENDIF MSWINDOWS}
  {$IFDEF VCL}
  JvRichEditToHTML,
  {$ENDIF VCL}
  JvTypes, JvDsgnConsts,
  JvStringListToHTML, JvFormToHTML, JvRGBToHTML,  JvStrToHTML;

{$IFDEF VCL}
{$R ..\Resources\JvNetReg.dcr}
{$ENDIF VCL}
{$IFDEF VisualCLX}
{$R ../Resources/JvNetReg.dcr}
{$ENDIF VisualCLX}

procedure Register;
begin
  RegisterComponents(RsPaletteInterNetWork, [
    {$IFDEF MSWINDOWS}
    TJvFTPURLGrabber, TJvHTTPURLGrabber,
    TJvLocalFileURLGrabber, TJvMail, TJvHTMLParser,
    {$ENDIF MSWINDOWS}
    TJvStrToHTML, TJvStringListToHTML, TJvFormToHTML, TJvRGBToHTML
    {$IFDEF VCL}
    ,TJvRichEditToHTML
    {$ENDIF VCL}
    {$IFDEF MSWINDOWS}
    ,TJvUrlListGrabber
    {$ENDIF MSWINDOWS}
    ]);
  {$IFDEF MSWINDOWS}
  RegisterPropertyEditor(TypeInfo(TJvParserInfoList),
    TJvHTMLParser, 'Parser', TJvHTMLParserEditor);
  RegisterPropertyEditor(TypeInfo(TJvUrlGrabberIndex),
    TJvUrlListGrabber, '', TJvUrlGrabberIndexProperty);
  RegisterPropertyEditor(TypeInfo(TJvUrlGrabberDefaultPropertiesList),
    TJvUrlListGrabber, '', TJvUrlGrabberDefaultPropertiesListEditor);
  RegisterPropertyEditor(TypeInfo(TJvCustomUrlGrabberDefaultProperties),
    TJvUrlGrabberDefPropEdTrick, '', TJvUrlGrabberDefaultPropertiesEditor);
  {$IFDEF VCL}
  RegisterComponentEditor(TJvMail, TJvMailEditor);
  {$ENDIF VCL}
  {$ENDIF MSWINDOWS}
end;

end.
