{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvConst.PAS, released on 2002-07-04.

The Initial Developers of the Original Code are: Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 1997, 1998 Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 2001,2002 SGB Software          
All Rights Reserved.

Last Modified: 2002-07-04

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvConsts;

interface

uses
  SysUtils,
  {$IFDEF VCL}
  Controls, Graphics, Windows;
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  QControls, QGraphics;
  {$ENDIF VisualCLX}

const
  { JvEditor }
  JvEditorCompletionChars = #8+'0123456789QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm';

  { various units }
  DigitSymbols = ['0'..'9'];
  IdentifierUppercaseLetters = ['A'..'Z'];
  IdentifierLowercaseLetters = ['a'..'z'];
  HexadecimalUppercaseLetters = ['A'..'F'];
  HexadecimalLowercaseLetters = ['a'..'f'];
  IdentifierLetters = IdentifierUppercaseLetters + IdentifierLowercaseLetters;
  IdentifierFirstSymbols = ['_'] + IdentifierLetters;
  IdentifierSymbols = IdentifierFirstSymbols + DigitSymbols;
  HexadecimalSymbols = DigitSymbols + HexadecimalUppercaseLetters + HexadecimalLowercaseLetters;

  {$IFDEF RAINTER}
  {RAInter}
  RAIIdSymbols      = StIdSymbols;
  RAIIdFirstSymbols = StIdFirstSymbols;
  {$ENDIF RAINTER}

  { Menu Designer }
  { (rom) disabled unused
  SMDMenuDesigner       = 'Menu &Designer';
  SMDInsertItem         = '&Insert';
  SMDDeleteItem         = '&Delete';
  SMDCreateSubmenuItem  = 'Create &SubMenu';
  }

  { RALib 1.23 }
  // (rom) now in JvJCLUtils.pas

  { RALib 1.55 }

  {$IFDEF DELPHI2}
  SDelphiKey = 'Software\Borland\Delphi\2.0';
  {$ENDIF}
  {$IFDEF BCB1}
  SDelphiKey = 'Software\Borland\C++Builder\1.0';
  {$ENDIF}
  {$IFDEF DELPHI3}
  SDelphiKey = 'Software\Borland\Delphi\3.0';
  {$ENDIF}
  {$IFDEF BCB3}
  SDelphiKey = 'Software\Borland\C++Builder\3.0';
  {$ENDIF}
  {$IFDEF DELPHI4}
  SDelphiKey = 'Software\Borland\Delphi\4.0';
  {$ENDIF}
  {$IFDEF BCB4}
  SDelphiKey = 'Software\Borland\C++Builder\4.0';
  {$ENDIF}
  {$IFDEF DELPHI5}
  SDelphiKey = 'Software\Borland\Delphi\5.0';
  {$ENDIF}
  {$IFDEF BCB5}
  SDelphiKey = 'Software\Borland\C++Builder\5.0';
  {$ENDIF}
  {$IFDEF DELPHI6}
  SDelphiKey = 'Software\Borland\Delphi\6.0';
  {$ENDIF}
  {$IFDEF BCB6}
  SDelphiKey = 'Software\Borland\C++Builder\6.0';
  {$ENDIF}
  {$IFDEF DELPHI7}
  SDelphiKey = 'Software\Borland\Delphi\7.0';
  {$ENDIF}
  {$IFDEF BCB7} // will it ever be released?
  SDelphiKey = 'Software\Borland\C++Builder\7.0';
  {$ENDIF}
  {$IFDEF DELPHI8}
  SDelphiKey = 'Software\Borland\Delphi\8.0';
  {$ENDIF}

  { JvDataProvider constants }
  { Consumer attributes }
  DPA_RenderDisabledAsGrayed = 1;
  DPA_RendersSingleItem      = 2;
  DPA_ConsumerDisplaysList   = 3;

  crHand     = TCursor(14000);
  crDragHand = TCursor(14001);

  CM_JVBASE = CM_BASE + 80;
  { Command message for JvSpeedbar editor }
  CM_SPEEDBARCHANGED = CM_JVBASE + 0;
  { Command message for TJvSpeedButton }
  CM_JVBUTTONPRESSED = CM_JVBASE + 1;
  // (rom) disabled unused
  { Command messages for TJvWindowHook }
  //CM_RECREATEWINDOW  = CM_JVBASE + 2;
  //CM_DESTROYHOOK     = CM_JVBASE + 3;
  { Notify message for TJvxTrayIcon }
  //CM_TRAYICON        = CM_JVBASE + 4;

  { Values for WParam for CM_SPEEDBARCHANGED message }
  SBR_CHANGED = 0;        { change buttons properties  }
  SBR_DESTROYED = 1;      { destroy SpeedBar           }
  SBR_BTNSELECT = 2;      { select button in SpeedBar  }
  SBR_BTNSIZECHANGED = 3; { button size changed        }

  { TBitmap.GetTransparentColor from GRAPHICS.PAS use this value }
  PaletteMask = $02000000;

  // (rom) unused
  {$IFDEF COMPILER7_UP}
  DEFAULT_SYSCOLOR_MASK = $000000FF;
  {$ELSE}
  DEFAULT_SYSCOLOR_MASK = $80000000;
  {$ENDIF COMPILER7_UP}

  {$IFNDEF COMPILER6_UP}
  { Standard Windows colors that are not defined in Delphi 5}
  COLOR_MENUHILIGHT = 29;
  {$EXTERNALSYM COLOR_MENUHILIGHT}
  COLOR_MENUBAR = 30;
  {$EXTERNALSYM COLOR_MENUBAR}

  clMoneyGreen = TColor($C0DCC0);
  clSkyBlue = TColor($F0CAA6);
  clCream = TColor($F0FBFF);
  clMedGray = TColor($A4A0A0);
  clGradientActiveCaption = TColor(COLOR_GRADIENTACTIVECAPTION or $80000000);
  clGradientInactiveCaption = TColor(COLOR_GRADIENTINACTIVECAPTION or $80000000);
  clHotLight = TColor(COLOR_HOTLIGHT or $80000000);
  clMenuHighlight = TColor(COLOR_MENUHILIGHT or $80000000);
  clMenuBar = TColor(COLOR_MENUBAR or $80000000);
  {$ENDIF COMPILER6_UP}

  {$IFNDEF COMPILER6_UP}
  {$IFDEF MSWINDOWS}
  sLineBreak = #13#10;
  {$ENDIF MSWINDOWS}
  {$IFDEF LINUX}
  sLineBreak = #10;
  {$ENDIF LINUX}
  {$ENDIF COMPILER6_UP}
  sLineBreakLen = Length(sLineBreak);

  CrLf = #13#10;
  Cr = #13;
  Lf = #10;
  Tab = #9;
  {$IFDEF MSWINDOWS}
  RegPathDelim = '\';
  PathDelim = '\';
  DriveDelim = ':';
  PathSep = ';';
  {$ENDIF MSWINDOWS}
  {$IFDEF LINUX}
  PathDelim = '/';
  {$ENDIF LINUX}

 {const Separators is used in GetWordOnPos, JvUtils.ReplaceStrings and SubWord}
  Separators: TSysCharSet = [#00, ' ', '-', #13, #10, '.', ',', '/', '\', '#', '"', '''',
    ':', '+', '%', '*', '(', ')', ';', '=', '{', '}', '[', ']', '{', '}', '<', '>'];

  DigitChars = ['0'..'9'];
  // (rom) disabled unused
  //Brackets = ['(', ')', '[', ']', '{', '}'];
  //StdWordDelims = [#0..' ', ',', '.', ';', '/', '\', ':', '''', '"', '`'] + Brackets;
 
const
  crJVCLFirst = TCursor(100);
  crMultiDragLink = TCursor(100);
  crDragAlt = TCursor(101);
  crMultiDragAlt = TCursor(102);
  crMultiDragLinkAlt = TCursor(103);

const
  ROP_DSPDxax = $00E20746;

implementation

end.
