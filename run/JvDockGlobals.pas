{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvDockGlobals.pas, released on 2003-12-31.

The Initial Developer of the Original Code is luxiaoban.
Portions created by luxiaoban are Copyright (C) 2002,2003 luxiaoban.
All Rights Reserved.

Contributor(s):

Last Modified: 2003-12-31

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvDockGlobals;

interface

uses
  Messages,
  JvDockControlForm, JvDockInfo, JvDockSupportControl;

resourcestring
  {$IFNDEF USEJVCL}
  RsPaletteDocking = 'Jv Docking';
  RsDockServerName = 'JVCL Dock Server Component';
  RsDockClientName = 'JVCL Dock Client Component';
  RsDockStyleName = 'JVCL Dock Style Component';

  RsDockManagerVersion = '1.0.0.0';
  RsDockStyleVersion = '1.0.0.0';

  RsDockManagerCopyrightBegin = '2002';
  RsDockManagerCopyrightEnd = '2003';
  RsDockStyleCopyRightBegin = '2002';
  RsDockStyleCopyRightEnd = '2003';

  RsDockAuthorName = 'zhouyibo';
  RsDockCompanyName = '';
  RsDockHomePage = 'http://jvcl.sourceforge.net';
  RsDockEmail = 'jvcl@jvcl.sf.net';

  RsDockAbout = 'About';
  RsDockManagerAbout = 'This is a %s, Version is %s,' + #13#10 +
    'Copyright: %s-%s, Author: %s %s,' + #13#10 +
    'Home Page: %s,' + #13#10 +
    'Email: %s';
  RsDockStyleAbout = 'This is a %s, Version is %s,' + #13#10 +
    'Copyright: %s-%s, Author: %s %s,' + #13#10 +
    'Home Page: %s,' + #13#10 +
    'Email: %s';
  {$ENDIF USEJVCL}

  RsDockStringSplitter = ' ';
  RsDockJvDockInfoSplitter = '@';

  RsDockJvDockTreeCloseBtnHint = 'Close';
  RsDockVCDockTreeExpandBtnHint = 'Expand';
  RsDockVSNETDockTreeAutoHideBtnHint = 'AutoHide';
  RsDockJvDockTreeVSplitterHint = 'Vertical Splitter';
  RsDockJvDockTreeHSplitterHint = 'Horizontal Splitter';

  RsDockTableIndexError = 'Table''s index out of range';
  RsDockNodeExistedError = 'Node already exist';
  RsDockComProcError = 'The function address is nil';

  RsDockControlCannotIsNil = 'Parameter Control can not be nil';
  RsDockCannotGetValueWithNoOrient = 'Cannot get data of control that has no dock orient';
  RsDockCannotSetValueWithNoOrient = 'Cannot set data of control that has no dock orient';

  RsDockCannotChangeDockStyleProperty = 'Changing DockStyle at runtime is not supported';
  RsDockCannotLayAnother = 'ONly one %s allowed on each form.Cannot add another %s';

  RsDockCannotSetTabPosition = 'Can not set TabPosition property to tpLeft or tpRight';
  RsDockTabPositionMustBetpBottom = 'TabPosition property must be tpBottom';

  RsDockLikeDelphiStyle = 'Similar to Delphi''s %s';
  RsDockLikeVCStyle = 'Similar to Visual C++''s %s';
  RsDockLikeVIDStyle = 'Similar to Visual InterDev''s %s';
  RsDockLikeVSNETStyle = 'Similar to Visual Studio.Net''s %s';
  RsDockLikeEclipseStyle = 'Similar to Java Eclipse''s %s';

  RsDockCannotFindWindow = 'Cannot find window';

const
  RsDockBaseDockTreeVersion = $00040000;

  RsDockVCDockTreeVersion = $00040010;

  DefExpandoRect = 10;

  WM_NCMOUSEFIRST = WM_NCMOUSEMOVE;
  WM_NCMOUSELAST = WM_NCMBUTTONDBLCLK;

var
  JvGlobalDockManager: TJvDockManager = nil;
  JvGlobalDockIsLoading: Boolean = False;
  JvGlobalDockClient: TJvDockClient = nil;

implementation

end.

