{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvExGrids.pas, released on 2004-01-04

The Initial Developer of the Original Code is Andreas Hausladen [Andreas dott Hausladen att gmx dott de]
Portions created by Andreas Hausladen are Copyright (C) 2004 Andreas Hausladen.
All Rights Reserved.

Contributor(s): Andr� Snepvangers [asn dott att xs4all.nl] (Redesign)

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvExGrids;

{$I jvcl.inc}
{MACROINCLUDE JvExControls.macros}

WARNINGHEADER

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Grids,
  Classes, SysUtils,
  JvTypes, JvThemes, JVCLVer, JvExControls;


type
{$IFDEF COMPILER6_UP}
  {$DEFINE HAS_GRID_EDITSTYLE}
{$ENDIF COMPILER6_UP}

  {$IFNDEF HAS_GRID_EDITSTYLE}
  // Compiler 5 and VisualCLX do not have TEditStyle
  TEditStyle = (esSimple, esEllipsis, esPickList);
  {$ENDIF HAS_GRID_EDITSTYLE}

  {$DEFINE HASBOUNDSCHANGED}
  JV_WINCONTROL(InplaceEdit)
  {$UNDEF HASBOUNDSCHANGED}
  JV_WINCONTROL(CustomGrid)
  {$IFDEF COMPILER6_UP}
  JV_WINCONTROL(CustomDrawGrid)
  {$DEFINE HASBOUNDSCHANGED}
  JV_WINCONTROL(InplaceEditList)
  {$UNDEF HASBOUNDSCHANGED}
  {$ENDIF COMPILER6_UP}

  JV_WINCONTROL_BEGIN(DrawGrid)
  {$IFNDEF HAS_GRID_EDITSTYLE}
  protected
    function GetEditStyle(ACol, ARow: Longint): TEditStyle; dynamic;
  {$ENDIF !HAS_GRID_EDITSTYLE}
  JV_WINCONTROL_END(DrawGrid)

  JV_WINCONTROL_BEGIN(StringGrid)
  {$IFNDEF HAS_GRID_EDITSTYLE}
  protected
    function GetEditStyle(ACol, ARow: Longint): TEditStyle; dynamic;
  {$ENDIF !HAS_GRID_EDITSTYLE}
  JV_WINCONTROL_END(StringGrid)

implementation

{$DEFINE HASBOUNDSCHANGED}
JV_WINCONTROL_IMPL(InplaceEdit)
{$UNDEF HASBOUNDSCHANGED}

JV_WINCONTROL_IMPL(CustomGrid)

{$IFDEF COMPILER6_UP}
JV_WINCONTROL_IMPL(CustomDrawGrid)

{$DEFINE HASBOUNDSCHANGED}
JV_WINCONTROL_IMPL(InplaceEditList)
{$UNDEF HASBOUNDSCHANGED}

{$ENDIF COMPILER6_UP}

{$IFNDEF HAS_GRID_EDITSTYLE}
function TJvExDrawGrid.GetEditStyle(ACol, ARow: Longint): TEditStyle;
begin
  Result := esSimple;
end;
{$ENDIF !HAS_GRID_EDITSTYLE}

JV_WINCONTROL_IMPL(DrawGrid)

{$IFNDEF HAS_GRID_EDITSTYLE}
function TJvExStringGrid.GetEditStyle(ACol, ARow: Longint): TEditStyle;
begin
  Result := esSimple;
end;
{$ENDIF !HAS_GRID_EDITSTYLE}

JV_WINCONTROL_IMPL(StringGrid)

end.
