{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvJCLUtils.PAS, released on 2002-07-04.

The Initial Developers of the Original Code are: Andrei Prygounkov <a.prygounkov@gmx.de>
Copyright (c) 1999, 2002 Andrei Prygounkov
All Rights Reserved.

Contributor(s):

Last Modified: 2003-10-24

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:

-----------------------------------------------------------------------------}
{$I JVCL.INC}

unit JvJCLUtils;
// (p3) note: this unit should only contain JCL compatible routines ( no Forms etc)

{ history:
3.0:
  2003-09-19: (changes by Andreas Hausladen)
    - GetXYByPos tests for #13. This does not work under Linux. Now it uses #10.
    - faster Spaces and AddSpaces
    - added FillWideChar, MoveWideChar, WideChangeCase, TrimW, TrimLeftW,
      TrimRightW
    - add unicode function for: GetWordOnPos, HasChar, CharInSet,
      Spaces, AddSpaces, GetXYByPos, MakeStr, FindNotBlankCharPos,
      GetWordOnPosEx, SubStr, ReplaceString

  2003-09-25: (andreas)
    - Added Linux version of the Windows related functions. (testing needed)
      The following functions are Windows only:
        LZFileExpand()
        TTFontSelected()
        KeyPressed()  [ maybe we can use XQueryKeymap ]
        ResSaveToFile(), ResSaveToFileEx(), ResSaveToString()
        CopyIconToClipboard(), AssignClipboardIcon(), CreateIconFromClipboard(),
          GetIconSize(), CreateRealSizeIcon(), DrawRealSizeIcon()
        HasAttr(), FileLock(), FileUnlock(), FileUnlock(), GetWindowsDir(),
          GetSystemDir(), CreateFileLink(), DeleteFileLink()
}

interface

uses
  {$IFDEF MSWINDOWS}
  Windows, ShlObj, ActiveX,
  {$ENDIF}
  {$IFDEF LINUX}
  Libc, Xlib,
  {$ENDIF}
  SysUtils, Classes,
  {$IFDEF COMPLIB_VCL}
  Graphics, Clipbrd,
  {$ENDIF}
  {$IFDEF COMPLIB_CLX}
  Qt, QGraphics, QClipbrd,
  {$ENDIF}
  JvTypes,
  {$IFDEF COMPILER6_UP}
  Variants,
  {$ENDIF}
  TypInfo, JvClxUtils;

{$IFNDEF COMPILER_6UP}
const
 // Delphi 1-5 do not support Linux
  PathDelim = '\';
  DriveDelim = ':';
  PathSep = ';';
{$ENDIF COMPILER6_UP}
  AllFilesMask = {$IFDEF MSWINDOWS}'*.*'{$ELSE}'*'{$ENDIF};
{$IFDEF LINUX}
type
  TFileTime = Integer;
{$ENDIF LINUX}

{ GetWordOnPos returns Word from string, S, on the cursor position, P}
function GetWordOnPos(const S: string; const P: Integer): string;
function GetWordOnPosW(const S: WideString; const P: Integer): WideString;
{ GetWordOnPosEx working like GetWordOnPos function, but
  also returns Word position in iBeg, iEnd variables }
function GetWordOnPosEx(const S: string; const P: Integer; var iBeg, iEnd: Integer): string;
function GetWordOnPosExW(const S: WideString; const P: Integer; var iBeg, iEnd: Integer): WideString;
{ SubStr returns substring from string, S, separated with Separator string}
function SubStr(const S: string; const Index: Integer; const Separator: string): string;
function SubStrW(const S: WideString; const Index: Integer; const Separator: WideString): WideString;
{ SubStrEnd same to previous function but Index numerated from the end of string }
function SubStrEnd(const S: string; const Index: Integer; const Separator: string): string;
{ SubWord returns next Word from string, P, and offsets Pointer to the end of Word, P2 }
function SubWord(P: PChar; var P2: PChar): string;
{ NumberByWord returns the text representation of
  the number, N, in normal russian language. Was typed from Monitor magazine }
function NumberByWord(const N: Longint): string;
//  function CurrencyByWord(Value : Currency) : string;
{ GetLineByPos returns the Line number, there
  the symbol Pos is pointed. Lines separated with #13 symbol }
function GetLineByPos(const S: string; const Pos: Integer): Integer;
{ GetXYByPos is same to previous function, but returns X position in line too}
procedure GetXYByPos(const S: string; const Pos: Integer; var X, Y: Integer);
procedure GetXYByPosW(const S: WideString; const Pos: Integer; var X, Y: Integer);
{ ReplaceString searches for all substrings, OldPattern,
  in a string, S, and replaces them with NewPattern }
function ReplaceString(S: string; const OldPattern, NewPattern: string): string;
function ReplaceStringW(S: WideString; const OldPattern, NewPattern: WideString): WideString;
{ ConcatSep concatenate S and S2 strings with Separator.
  if S = '', separator don't included }
function ConcatSep(const S, S2, Separator: string): string;
{ ConcatLeftSep is same to previous function, but
  strings concatenate right to left }
function ConcatLeftSep(const S, S2, Separator: string): string;
{ MinimizeString trunactes long string, S, and appends
  '...' symbols, if Length of S is more than MaxLen }
function MinimizeString(const S: string; const MaxLen: Integer): string;

{ Next 4 function for russian chars transliterating.
  This functions are needed because Oem2Ansi and Ansi2Oem functions
  sometimes works sucks }
procedure Dos2Win(var S: string);
procedure Win2Dos(var S: string);
function Dos2WinRes(const S: string): string;
function Win2DosRes(const S: string): string;
function Win2Koi(const S: string): string;

{ FillWideChar fills Buffer with Count WideChars (2 Bytes) }
procedure FillWideChar(var Buffer; Count: Integer; const Value: WideChar);
{ MoveWideChar copies Count WideChars from Source to Dest }
procedure MoveWideChar(const Source; var Dest; Count: Integer);

{ Spaces returns string consists on N space chars }
function Spaces(const N: Integer): string;
function SpacesW(const N: Integer): WideString;
{ AddSpaces add spaces to string, S, if it Length is smaller than N }
function AddSpaces(const S: string; const N: Integer): string;
function AddSpacesW(const S: WideString; const N: Integer): WideString;
{ function LastDate for russian users only }
//  { returns date relative to current date: '��� ��� �����' }
function LastDate(const Dat: TDateTime): string;
{ CurrencyToStr format currency, Cur, using ffCurrency float format}
function CurrencyToStr(const Cur: currency): string;
{ Cmp compares two strings and returns True if they
  are equal. Case-insensitive.}
function Cmp(const S1, S2: string): Boolean;
{ StringCat add S2 string to S1 and returns this string }
function StringCat(var S1: string; S2: string): string;
{ HasChar returns True, if Char, Ch, contains in string, S }
function HasChar(const Ch: Char; const S: string): Boolean;
function HasCharW(const Ch: WideChar; const S: WideString): Boolean;
function HasAnyChar(const Chars: string; const S: string): Boolean;
function CharInSet(const Ch: Char; const SetOfChar: TSysCharSet): Boolean;
function CharInSetW(const Ch: WideChar; const SetOfChar: TSysCharSet): Boolean;
function CountOfChar(const Ch: Char; const S: string): Integer;
function DefStr(const S: string; Default: string): string;

{ StrLICompW2 is a faster replacement for JclUnicode.StrLICompW }
function StrLICompW2(S1, S2: PWideChar; MaxLen: Integer): Integer;
function StrPosW(S, SubStr: PWideChar): PWideChar;
function StrLenW(S: PWideChar): Integer;
{$IFNDEF COMPILER6_UP}
function WideCompareText(const S1, S2: WideString): Integer;
function WideUpperCase(const S: WideString): WideString;
function WideLowerCase(const S: WideString): WideString;
{$ENDIF COMPILER6_UP}
function TrimW(const S: WideString): WideString;
function TrimLeftW(const S: WideString): WideString;
function TrimRightW(const S: WideString): WideString;
{**** files routines}
procedure SetDelimitedText(List: TStrings; const Text: string; Delimiter: Char);

{$IFDEF MSWINDOWS}
{ GetWinDir returns Windows folder name }
function GetWinDir: TFileName;
{$ENDIF MSWINDOWS}
{ GetTempDir returns Windows temporary folder name }
function GetTempDir: string;
{ GenTempFileName returns temporary file name on
  drive, there FileName is placed }
function GenTempFileName(FileName: string): string;
{ GenTempFileNameExt same to previous function, but
  returning filename has given extension, FileExt }
function GenTempFileNameExt(FileName: string; const FileExt: string): string;
{ ClearDir clears folder Dir }
function ClearDir(const Dir: string): Boolean;
{ DeleteDir clears and than delete folder Dir }
function DeleteDir(const Dir: string): Boolean;
{ FileEquMask returns True if file, FileName,
  is compatible with given dos file mask, Mask }
function FileEquMask(FileName, Mask: TFileName;
  CaseSensitive: Boolean = {$IFDEF WINDOWS}False{$ELSE}True{$ENDIF}): Boolean;
{ FileEquMasks returns True if file, FileName,
  is compatible with given Masks.
  Masks must be separated with SepPath (MSW: ';' / LINUX: ':') }
function FileEquMasks(FileName, Masks: TFileName;
  CaseSensitive: Boolean = {$IFDEF WINDOWS}False{$ELSE}True{$ENDIF}): Boolean;
function DeleteFiles(const Folder: TFileName; const Masks: string):boolean;

{$IFDEF MSWINDOWS}
{ LZFileExpand expand file, FileSource,
  into FileDest. Given file must be compressed, using MS Compress program }
function LZFileExpand(const FileSource, FileDest: string): Boolean;
{$ENDIF MSWINDOWS}

{ FileGetInfo fills SearchRec record for specified file attributes}
function FileGetInfo(FileName: TFileName; var SearchRec: TSearchRec): Boolean;
{ HasSubFolder returns True, if folder APath contains other folders }
function HasSubFolder(APath: TFileName): Boolean;
{ IsEmptyFolder returns True, if there are no files or
  folders in given folder, APath}
function IsEmptyFolder(APath: TFileName): Boolean;
{ AddSlash add slash Char to Dir parameter, if needed }
procedure AddSlash(var Dir: TFileName);
{ AddSlash returns string with added slash Char to Dir parameter, if needed }
function AddSlash2(const Dir: TFileName): string;
{ AddPath returns FileName with Path, if FileName not contain any path }
function AddPath(const FileName, Path: TFileName): TFileName;
function AddPaths(const PathList, Path: string): string;
function ParentPath(const Path: TFileName): TFileName;
function FindInPath(const FileName, PathList: string): TFileName;
{ DeleteReadOnlyFile clears R/O file attribute and delete file }
function DeleteReadOnlyFile(const FileName: TFileName): Boolean;
{ HasParam returns True, if program running with specified parameter, Param }
function HasParam(const Param: string): Boolean;
function HasSwitch(const Param: string): Boolean;
function Switch(const Param: string): string;
{ ExePath returns ExtractFilePath(ParamStr(0)) }
function ExePath: TFileName;
function CopyDir(const SourceDir, DestDir: TFileName): Boolean;
function FileTimeToDateTime(const FT: TFileTime): TDateTime;
function MakeValidFileName(const FileName: TFileName; const ReplaceBadChar: Char): TFileName;

{**** Graphic routines }

{$IFDEF MSWINDOWS}
{ TTFontSelected returns True, if True Type font
  is selected in specified device context }
function TTFontSelected(const DC: HDC): Boolean;
{$ENDIF}
{ TrueInflateRect inflates rect in other method, than InflateRect API function }
function TrueInflateRect(const R: TRect; const I: Integer): TRect;
{$IFDEF LINUX}
procedure SetRect(out R: TRect; Left, Top, Right, Bottom: Integer);
{$ENDIF}

{**** other routines }
{$IFDEF MSWINDOWS}
{ KeyPressed returns True, if Key VK is now pressed }
function KeyPressed(VK: Integer): Boolean;
{$ENDIF}
procedure SwapInt(var Int1, Int2: Integer);
function IntPower(Base, Exponent: Integer): Integer;
function ChangeTopException(E: TObject): TObject;
function StrToBool(const S: string): Boolean;

function Var2Type(V: Variant; const VarType: Integer): Variant;
function VarToInt(V: Variant): Integer;
function VarToFloat(V: Variant): Double;
{ following functions are not documented
  because they are don't work properly sometimes, so don't use them }
function ReplaceStrings1(S: string; const Word, Frase: string): string;
{ ReplaceStrings1 is full equal to ReplaceString function
  - only for compatibility - don't use }
{ GetSubStr is full equal to SubStr function
  - only for compatibility - don't use }
function GetSubStr(const S: string; const Index: Integer; const Separator: Char): string;
function GetParameter: string;
function GetLongFileName(FileName: string): string;
{* from unit FileCtrl}
function DirectoryExists(const Name: string): Boolean;
procedure ForceDirectories(Dir: string);
{# from unit FileCtrl}
function FileNewExt(const FileName, NewExt: TFileName): TFileName;
function GetComputerID: string;
function GetComputerName: string;

{**** string routines }

{ ReplaceAllStrings searches for all substrings, Words,
  in a string, S, and replaces them with Frases with the same Index.
  Also see RAUtilsW.ReplaceStrings1 function }
function ReplaceAllStrings(S: string; Words, Frases: TStrings): string;
{ ReplaceStrings searches the Word in a string, S, on PosBeg position,
  in the list, Words, and if founds, replaces this Word
  with string from another list, Frases, with the same Index,
  and then update NewSelStart variable }
function ReplaceStrings(S: string; PosBeg, Len: Integer; Words, Frases: TStrings; var NewSelStart: Integer): string;
{ CountOfLines calculates the lines count in a string, S,
  each line must be separated from another with CrLf sequence }
function CountOfLines(const S: string): Integer;
{ DeleteEmptyLines deletes all empty lines from strings, Ss.
  Lines contained only spaces also deletes. }
procedure DeleteEmptyLines(Ss: TStrings);
{ SQLAddWhere addes or modifies existing where-statement, where,
  to the strings, SQL.
  Note: If strings SQL allready contains where-statement,
  it must be started on the begining of any line }
procedure SQLAddWhere(SQL: TStrings; const Where: string);

{**** files routines - }

{$IFDEF MSWINDOWS}
{ ResSaveToFile save resource named as Name with Typ type into file FileName.
  Resource can be compressed using MS Compress program}
function ResSaveToFile(const Typ, Name: string; const Compressed: Boolean; const FileName: string): Boolean;
function ResSaveToFileEx(Instance: HINST; Typ, Name: PChar;
  const Compressed: Boolean; const FileName: string): Boolean;
function ResSaveToString(Instance: HINST; const Typ, Name: string;
  var S: string): Boolean;
{$ENDIF}
{ IniReadSection read section, Section, from ini-file,
  IniFileName, into strings, Ss.
  This function reads ALL strings from specified section.
  Note: TIninFile.ReadSection function reads only strings with '=' symbol.}
function IniReadSection(const IniFileName: TFileName; const Section: string; Ss: TStrings): Boolean;
{ LoadTextFile load text file, FileName, into string }
function LoadTextFile(const FileName: TFileName): string;
procedure SaveTextFile(const FileName: TFileName; const Source: string);
{ ReadFolder reads files list from disk folder, Folder,
  that are equal to mask, Mask, into strings, FileList}
function ReadFolder(const Folder, Mask: TFileName; FileList: TStrings): Integer;
function ReadFolders(const Folder: TFileName; FolderList: TStrings): Integer;


{ RATextOut same with TCanvas.TextOut procedure, but
  can clipping drawing with rectangle, RClip. }
procedure RATextOut(Canvas: TCanvas; const R, RClip: TRect; const S: string);
{ RATextOutEx same with RATextOut function, but
  can calculate needed height for correct output }
function RATextOutEx(Canvas: TCanvas; const R, RClip: TRect; const S: string; const CalcHeight: Boolean): Integer;
{ RATextCalcHeight calculate needed height for
  correct output, using RATextOut or RATextOutEx functions }
function RATextCalcHeight(Canvas: TCanvas; const R: TRect; const S: string): Integer;
{ Cinema draws some visual effect }
procedure Cinema(Canvas: TCanvas; rS {Source}, rD {Dest}: TRect);
{ Roughed fills rect with special 3D pattern }
procedure Roughed(ACanvas: TCanvas; const ARect: TRect; const AVert: Boolean);
{ BitmapFromBitmap creates new small bitmap from part
  of source bitmap, SrcBitmap, with specified width and height,
  AWidth, AHeight and placed on a specified Index, Index in the
  source bitmap }
function BitmapFromBitmap(SrcBitmap: TBitmap; const AWidth, AHeight, Index: Integer): TBitmap;
{ TextWidth calculate text with for writing using standard desktop font }
function TextWidth(const AStr: string): Integer;

procedure SetChildPropOrd(Owner: TComponent; const PropName: string; Value: Longint);
procedure Error(const Msg: string);
procedure ItemHtDrawEx(Canvas: TCanvas; Rect: TRect;
  const State: TOwnerDrawState; const Text: string;
  const HideSelColor: Boolean; var PlainItem: string;
  var Width: Integer; CalcWidth: Boolean);
  { example for Text parameter :
    'Item 1 <b>bold</b> <i>italic ITALIC <c:Red>red <c:Green>green <c:blue>blue </i>' }
function ItemHtDraw(Canvas: TCanvas; Rect: TRect;
  const State: TOwnerDrawState; const Text: string;
  const HideSelColor: Boolean): string;
function ItemHtWidth(Canvas: TCanvas; Rect: TRect;
  const State: TOwnerDrawState; const Text: string;
  const HideSelColor: Boolean): Integer;
function ItemHtPlain(const Text: string): string;
{ ClearList - clears list of TObject }
procedure ClearList(List: TList);

procedure MemStreamToClipBoard(MemStream: TMemoryStream; const Format: Word);
procedure ClipBoardToMemStream(MemStream: TMemoryStream; const Format: Word);

{ RTTI support }
function GetPropType(Obj: TObject; const PropName: string): TTypeKind;
function GetPropStr(Obj: TObject; const PropName: string): string;
function GetPropOrd(Obj: TObject; const PropName: string): Integer;
function GetPropMethod(Obj: TObject; const PropName: string): TMethod;

procedure PrepareIniSection(SS: TStrings);
{ following functions are not documented because
  they are don't work properly, so don't use them }

// (rom) from JvBandWindows to make it obsolete
function PointL(const X, Y: Longint): TPointL;
// (rom) from JvBandUtils to make it obsolete
function iif(const Test: Boolean; const ATrue, AFalse: Variant): Variant;

{$IFDEF COMPLIB_VCL}
{ begin JvIconClipboardUtils }

{ Icon clipboard routines }
function CF_ICON: Word;
procedure CopyIconToClipboard(Icon: TIcon; BackColor: TColor);
procedure AssignClipboardIcon(Icon: TIcon);
function CreateIconFromClipboard: TIcon;

{ Real-size icons support routines (32-bit only) }

procedure GetIconSize(Icon: HIcon; var W, H: Integer);
function CreateRealSizeIcon(Icon: TIcon): HIcon;
procedure DrawRealSizeIcon(Canvas: TCanvas; Icon: TIcon; X, Y: Integer);

{end JvIconClipboardUtils }
{$ENDIF COMPLIB_VCL}

{ begin JvRLE }

// (rom) changed API for inclusion in JCL

procedure RleCompress(Stream: TStream);
procedure RleDecompress(Stream: TStream);
{ end JvRLE }

{ begin JvDateUtil }
function CurrentYear: Word;
function IsLeapYear(AYear: Integer): Boolean;
function DaysPerMonth(AYear, AMonth: Integer): Integer;
function FirstDayOfPrevMonth: TDateTime;
function LastDayOfPrevMonth: TDateTime;
function FirstDayOfNextMonth: TDateTime;
function ExtractDay(ADate: TDateTime): Word;
function ExtractMonth(ADate: TDateTime): Word;
function ExtractYear(ADate: TDateTime): Word;
function IncDate(ADate: TDateTime; Days, Months, Years: Integer): TDateTime;
function IncDay(ADate: TDateTime; Delta: Integer): TDateTime;
function IncMonth(ADate: TDateTime; Delta: Integer): TDateTime;
function IncYear(ADate: TDateTime; Delta: Integer): TDateTime;
function ValidDate(ADate: TDateTime): Boolean;
procedure DateDiff(Date1, Date2: TDateTime; var Days, Months, Years: Word);
function MonthsBetween(Date1, Date2: TDateTime): Double;
function DaysInPeriod(Date1, Date2: TDateTime): Longint;
{ Count days between Date1 and Date2 + 1, so if Date1 = Date2 result = 1 }
function DaysBetween(Date1, Date2: TDateTime): Longint;
{ The same as previous but if Date2 < Date1 result = 0 }
function IncTime(ATime: TDateTime; Hours, Minutes, Seconds, MSecs: Integer): TDateTime;
function IncHour(ATime: TDateTime; Delta: Integer): TDateTime;
function IncMinute(ATime: TDateTime; Delta: Integer): TDateTime;
function IncSecond(ATime: TDateTime; Delta: Integer): TDateTime;
function IncMSec(ATime: TDateTime; Delta: Integer): TDateTime;
function CutTime(ADate: TDateTime): TDateTime; { Set time to 00:00:00:00 }


{ String to date conversions }
function GetDateOrder(const DateFormat: string): TDateOrder;
function MonthFromName(const S: string; MaxLen: Byte): Byte;
function StrToDateDef(const S: string; Default: TDateTime): TDateTime;
function StrToDateFmt(const DateFormat, S: string): TDateTime;
function StrToDateFmtDef(const DateFormat, S: string; Default: TDateTime): TDateTime;
function DefDateFormat(FourDigitYear: Boolean): string;
function DefDateMask(BlanksChar: Char; FourDigitYear: Boolean): string;

function FormatLongDate(Value: TDateTime): string;
function FormatLongDateTime(Value: TDateTime): string;

{ end JvDateUtil }

{ begin JvStrUtils }

  { ** Common string handling routines ** }

{$IFDEF LINUX}
function iconversion(InP: PChar; OutP: Pointer; InBytes, OutBytes: Cardinal;
  const ToCode, FromCode: string): Boolean;
function iconvString(const S, ToCode, FromCode: string): string;
function iconvWideString(const S: WideString; const ToCode, FromCode: string): WideString;
function OemStrToAnsi(const S: string): string;
function AnsiStrToOem(const S: string): string;
{$ENDIF}

function StrToOem(const AnsiStr: string): string;
{ StrToOem translates a string from the Windows character set into the
  OEM character set. }
function OemToAnsiStr(const OemStr: string): string;
{ OemToAnsiStr translates a string from the OEM character set into the
  Windows character set. }
function IsEmptyStr(const S: string; const EmptyChars: TCharSet): Boolean;
{ EmptyStr returns true if the given string contains only character
  from the EmptyChars. }
function ReplaceStr(const S, Srch, Replace: string): string;
{ Returns string with every occurrence of Srch string replaced with
  Replace string. }
function DelSpace(const S: string): string;
{ DelSpace return a string with all white spaces removed. }
function DelChars(const S: string; Chr: Char): string;
{ DelChars return a string with all Chr characters removed. }
function DelBSpace(const S: string): string;
{ DelBSpace trims leading spaces from the given string. }
function DelESpace(const S: string): string;
{ DelESpace trims trailing spaces from the given string. }
function DelRSpace(const S: string): string;
{ DelRSpace trims leading and trailing spaces from the given string. }
function DelSpace1(const S: string): string;
{ DelSpace1 return a string with all non-single white spaces removed. }
function Tab2Space(const S: string; Numb: Byte): string;
{ Tab2Space converts any tabulation character in the given string to the
  Numb spaces characters. }
function NPos(const C: string; S: string; N: Integer): Integer;
{ NPos searches for a N-th position of substring C in a given string. }
function MakeStr(C: Char; N: Integer): string; overload;
function MakeStr(C: WideChar; N: Integer): WideString; overload;
function MS(C: Char; N: Integer): string;
{ MakeStr return a string of length N filled with character C. }
function AddChar(C: Char; const S: string; N: Integer): string;
{ AddChar return a string left-padded to length N with characters C. }
function AddCharR(C: Char; const S: string; N: Integer): string;
{ AddCharR return a string right-padded to length N with characters C. }
function LeftStr(const S: string; N: Integer): string;
{ LeftStr return a string right-padded to length N with blanks. }
function RightStr(const S: string; N: Integer): string;
{ RightStr return a string left-padded to length N with blanks. }
function CenterStr(const S: string; Len: Integer): string;
{ CenterStr centers the characters in the string based upon the
  Len specified. }
function CompStr(const S1, S2: string): Integer;
{ CompStr compares S1 to S2, with case-sensitivity. The return value is
  -1 if S1 < S2, 0 if S1 = S2, or 1 if S1 > S2. }
function CompText(const S1, S2: string): Integer;
{ CompText compares S1 to S2, without case-sensitivity. The return value
  is the same as for CompStr. }
function Copy2Symb(const S: string; Symb: Char): string;
{ Copy2Symb returns a substring of a string S from begining to first
  character Symb. }
function Copy2SymbDel(var S: string; Symb: Char): string;
{ Copy2SymbDel returns a substring of a string S from begining to first
  character Symb and removes this substring from S. }
function Copy2Space(const S: string): string;
{ Copy2Symb returns a substring of a string S from begining to first
  white space. }
function Copy2SpaceDel(var S: string): string;
{ Copy2SpaceDel returns a substring of a string S from begining to first
  white space and removes this substring from S. }
function AnsiProperCase(const S: string; const WordDelims: TCharSet): string;
{ Returns string, with the first letter of each word in uppercase,
  all other letters in lowercase. Words are delimited by WordDelims. }
function WordCount(const S: string; const WordDelims: TCharSet): Integer;
{ WordCount given a set of word delimiters, returns number of words in S. }
function WordPosition(const N: Integer; const S: string;
  const WordDelims: TCharSet): Integer;
{ Given a set of word delimiters, returns start position of N'th word in S. }
function ExtractWord(N: Integer; const S: string;
  const WordDelims: TCharSet): string;
function ExtractWordPos(N: Integer; const S: string;
  const WordDelims: TCharSet; var Pos: Integer): string;
function ExtractDelimited(N: Integer; const S: string;
  const Delims: TCharSet): string;
{ ExtractWord, ExtractWordPos and ExtractDelimited given a set of word
  delimiters, return the N'th word in S. }
function ExtractSubstr(const S: string; var Pos: Integer;
  const Delims: TCharSet): string;
{ ExtractSubstr given a set of word delimiters, returns the substring from S,
  that started from position Pos. }
function IsWordPresent(const W, S: string; const WordDelims: TCharSet): Boolean;
{ IsWordPresent given a set of word delimiters, returns True if word W is
  present in string S. }
function QuotedString(const S: string; Quote: Char): string;
{ QuotedString returns the given string as a quoted string, using the
  provided Quote character. }
function ExtractQuotedString(const S: string; Quote: Char): string;
{ ExtractQuotedString removes the Quote characters from the beginning and
  end of a quoted string, and reduces pairs of Quote characters within
  the quoted string to a single character. }
function FindPart(const HelpWilds, InputStr: string): Integer;
{ FindPart compares a string with '?' and another, returns the position of
  HelpWilds in InputStr. }
function IsWild(InputStr, Wilds: string; IgnoreCase: Boolean): Boolean;
{ IsWild compares InputString with WildCard string and returns True
  if corresponds. }
function XorString(const Key, Src: ShortString): ShortString;
function XorEncode(const Key, Source: string): string;
function XorDecode(const Key, Source: string): string;

{ ** Command line routines ** }

function GetCmdLineArg(const Switch: string; ASwitchChars: TCharSet): string;

{ ** Numeric string handling routines ** }

function Numb2USA(const S: string): string;
{ Numb2USA converts numeric string S to USA-format. }
function Dec2Hex(N: Longint; A: Byte): string;
function D2H(N: Longint; A: Byte): string;
{ Dec2Hex converts the given value to a hexadecimal string representation
  with the minimum number of digits (A) specified. }
function Hex2Dec(const S: string): Longint;
function H2D(const S: string): Longint;
{ Hex2Dec converts the given hexadecimal string to the corresponding integer
  value. }
function Dec2Numb(N: Longint; A, B: Byte): string;
{ Dec2Numb converts the given value to a string representation with the
  base equal to B and with the minimum number of digits (A) specified. }
function Numb2Dec(S: string; B: Byte): Longint;
{ Numb2Dec converts the given B-based numeric string to the corresponding
  integer value. }
function IntToBin(Value: Longint; Digits, Spaces: Integer): string;
{ IntToBin converts the given value to a binary string representation
  with the minimum number of digits specified. }
function IntToRoman(Value: Longint): string;
{ IntToRoman converts the given value to a roman numeric string
  representation. }
function RomanToInt(const S: string): Longint;
{ RomanToInt converts the given string to an integer value. If the string
  doesn't contain a valid roman numeric value, the 0 value is returned. }

function FindNotBlankCharPos(const S: string): Integer;
function FindNotBlankCharPosW(const S: WideString): Integer;
function AnsiChangeCase(const S: string): string; 
function WideChangeCase(const S: string): string;
function StringEndsWith(const Str, SubStr: string): Boolean;
function ExtractFilePath2(const FileName: string): string;
{end JvStrUtils}

{$IFDEF LINUX}
function GetTempFileName(const Prefix: string);
{$ENDIF LINUX}

{ begin JvFileUtil }
function GetFileSize(const FileName: string): Int64;
function FileDateTime(const FileName: string): TDateTime;
{$IFDEF MSWINDOWS}
function HasAttr(const FileName: string; Attr: Integer): Boolean;
{$ENDIF}
function DeleteFilesEx(const FileMasks: array of string): Boolean;
function NormalDir(const DirName: string): string;
function RemoveBackSlash(const DirName: string): string; // only for Windows/DOS Paths
function ValidFileName(const FileName: string): Boolean;
function DirExists(Name: string): Boolean;

{$IFDEF MSWINDOWS}
function FileLock(Handle: Integer; Offset, LockSize: Longint): Integer; overload;
function FileLock(Handle: Integer; Offset, LockSize: Int64): Integer; overload;
function FileUnlock(Handle: Integer; Offset, LockSize: Longint): Integer;overload;
function FileUnlock(Handle: Integer; Offset, LockSize: Int64): Integer; overload;
function GetWindowsDir: string;
function GetSystemDir: string;
{$ENDIF}

function ShortToLongFileName(const ShortName: string): string;
function ShortToLongPath(const ShortName: string): string;
function LongToShortFileName(const LongName: string): string;
function LongToShortPath(const LongName: string): string;
{$IFDEF MSWINDOWS}
procedure CreateFileLink(const FileName, DisplayName: string; Folder: Integer);
procedure DeleteFileLink(const DisplayName: string; Folder: Integer);
{$ENDIF}

{ end JvFileUtil }

{$IFNDEF COMPILER6_UP}
{ begin JvXMLDatabase D5 compatiblility functions }
function StrToDateTimeDef(const S:string;Default:TDateTime):TDateTime;
function CompareDateTime(const A, B:TDateTime):integer;
function StrToFloatDef(const S:String;Default:Extended):Extended;
{ end JvXMLDatabase D5 compatiblility functions }

{ D5 compatibility functions }
procedure RaiseLastOSError;
function IncludeTrailingPathDelimiter(const APath: string): string;
function ExcludeTrailingPathDelimiter(const APath: string): string;

{$ENDIF}


implementation

uses
  Math, Consts, SysConst, JvConsts, ComObj;

function GetLineByPos(const S: string; const Pos: Integer): Integer;
var
  I: Integer;
begin
  if Length(S) < Pos then
    Result := -1
  else
  begin
    I := 1;
    Result := 0;
    while I <= Pos do
    begin
      if S[I] = #13 then
        Inc(Result);
      Inc(I);
    end;
  end;
end;

procedure GetXYByPos(const S: string; const Pos: Integer; var X, Y: Integer);
var
  I, iB: Integer;
begin
  X := -1;
  Y := -1;
  iB := 0;
  if (Length(S) >= Pos) and (Pos >= 0) then
  begin
    I := 1;
    Y := 0;
    while I <= Pos do
    begin
      if S[I] = #10 then
      begin
        Inc(Y);
        iB := I + 1;
      end;
      Inc(I);
    end;
    X := Pos - iB;
  end;
end;

procedure GetXYByPosW(const S: WideString; const Pos: Integer; var X, Y: Integer);
var
  I, iB: Integer;
begin
  X := -1;
  Y := -1;
  iB := 0;
  if (Length(S) >= Pos) and (Pos >= 0) then
  begin
    I := 1;
    Y := 0;
    while I <= Pos do
    begin
      if S[I] = #10 then
      begin
        Inc(Y);
        iB := I + 1;
      end;
      Inc(I);
    end;
    X := Pos - iB;
  end;
end;

function GetWordOnPos(const S: string; const P: Integer): string; 
var
  I, Beg: Integer;
begin
  Result := '';
  if (P > Length(S)) or (P < 1) then
    Exit;
  for I := P downto 1 do
    if S[I] in Separators then
      Break;
  Beg := I + 1;
  for I := P to Length(S) do
    if S[I] in Separators then
      Break;
  if I > Beg then
    Result := Copy(S, Beg, I - Beg)
  else
    Result := S[P];
end;

function GetWordOnPosW(const S: WideString; const P: Integer): WideString;
var
  I, Beg: Integer;
begin
  Result := '';
  if (P > Length(S)) or (P < 1) then
    Exit;
  for I := P downto 1 do
    if CharInSetW(S[I], Separators) then
      Break;
  Beg := I + 1;
  for I := P to Length(S) do
    if CharInSetW(S[I], Separators) then
      Break;
  if I > Beg then
    Result := Copy(S, Beg, I - Beg)
  else
    Result := S[P];
end;

function GetWordOnPosEx(const S: string; const P: Integer; var iBeg, iEnd: Integer): string;
begin
  Result := '';
  if (P > Length(S)) or (P < 1) then
    Exit;
  iBeg := P;
  if P > 1 then
    if S[P] in Separators then
      if (P < 1) or ((P - 1 > 0) and (S[P - 1] in Separators)) then
        Inc(iBeg)
      else
      if not ((P - 1 > 0) and (S[P - 1] in Separators)) then
        Dec(iBeg);
  while iBeg >= 1 do
    if S[iBeg] in Separators then
      Break
    else
      Dec(iBeg);
  Inc(iBeg);
  iEnd := P;
  while iEnd <= Length(S) do
    if S[iEnd] in Separators then
      Break
    else
      Inc(iEnd);
  if iEnd > iBeg then
    Result := Copy(S, iBeg, iEnd - iBeg)
  else
    Result := S[P];
end;

function GetWordOnPosExW(const S: WideString; const P: Integer; var iBeg, iEnd: Integer): WideString;
begin
  Result := '';
  if (P > Length(S)) or (P < 1) then
    Exit;
  iBeg := P;
  if P > 1 then
    if CharInSetW(S[P], Separators) then
      if (P < 1) or ((P - 1 > 0) and CharInSetW(S[P - 1], Separators)) then
        Inc(iBeg)
      else
      if not ((P - 1 > 0) and CharInSetW(S[P - 1], Separators)) then
        Dec(iBeg);
  while iBeg >= 1 do
    if CharInSetW(S[iBeg], Separators) then
      Break
    else
      Dec(iBeg);
  Inc(iBeg);
  iEnd := P;
  while iEnd <= Length(S) do
    if CharInSetW(S[iEnd], Separators) then
      Break
    else
      Inc(iEnd);
  if iEnd > iBeg then
    Result := Copy(S, iBeg, iEnd - iBeg)
  else
    Result := S[P];
end;

{ (rb) This function seems to translate a number to a russian string, but is
       half translated (only const part), need to roll back to an all russian
       version or tranlate (and change it's logic) to a english version }
function NumberByWord(const N: Longint): string;
const
  Ten: array [0..9] of string =
    ('zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine');
  Hun: array [1..9] of string =
    ('onehundred', 'twohundred', 'threehundred', 'fourhundred', 'fivehundred',
     'sixhundred', 'sevenhundred', 'eighthundred', 'ninehundred');
  OnTen: array [10..19] of string =
    ('ten', 'eleven', 'twelve', 'thirteen', 'fourteen',
     'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen');
  HunIn: array [2..9] of string =
    ('twothousand', 'threethousand', 'fourthousand', 'fivethousand',
     'sixthousand', 'seventhousand', 'eightthousand', 'ninethousand');
var
  StrVsp: string;
  NumStr: string;
  StrVsp2: string;
  I: Byte;

  function IndNumber(Stri: string; Place: Byte): Byte;
  begin
    IndNumber := Ord(Stri[Place]) - 48;
  end;

  function Back(Stri: string): Longint;
  var
    Code: Integer;
    LI: Longint;
  begin
    Result := 0;
    Val(Stri, LI, Code);
    if Code = 0 then
      Result := LI;
  end;

begin
  NumStr := IntToStr(N);
  if Length(NumStr) > 9 then
  begin
    Result := '*****';
    Exit;
  end;
  case Length(NumStr) of
    1:
      StrVsp := Ten[N];
    2: case NumStr[1] of
        '1':
          StrVsp := OnTen[N];
        '0':
          StrVsp := NumberByWord(IndNumber(NumStr, 2));
        '2'..'9':
          begin
            StrVsp := HunIn[IndNumber(NumStr, 1)];
            if NumStr[2] <> '0' then
              StrVsp := StrVsp + ' ' + NumberByWord(IndNumber(NumStr, 2));
          end;
      end;
    3:
      begin
        StrVsp := Hun[IndNumber(NumStr, 1)];
        StrVsp := StrVsp + ' ' + NumberByWord(Back(Copy(NumStr, 2, 2)));
      end;
    4:
      begin
        StrVsp := Ten[IndNumber(NumStr, 1)];
        // (rom) needs translation
        case NumStr[1] of
          '1':
            StrVsp := '���� ������'; // 'one thousand'
          '2':
            StrVsp := '��� ������'; // 'two thousands'
          '3', '4':
            StrVsp := StrVsp + ' ������'; // ' thousands'
          '5'..'9':
            StrVsp := StrVsp + ' �����'; // ' of thousands'
        end;
        StrVsp := StrVsp + ' ' + NumberByWord(Back(Copy(NumStr, 2, 3)));
      end;
    5:
      begin
        StrVsp2 := NumberByWord(Back(Copy(NumStr, 1, 2)));
        I := Pos(' ���', StrVsp2);
        if Pos(' ���', StrVsp2) = I then
          I := 0;
        if I <> 0 then
          StrVsp2[I + 3] := 'e';
        I := Pos(' ����', StrVsp2);
        if Pos(' �����', StrVsp2) = I then
          I := 0;
        if I <> 0 then
        begin
          StrVsp2[I + 3] := '�';
          StrVsp2[I + 4] := '�';
        end;
        if NumStr[1] <> '1' then
          case NumStr[2] of
            '1':
              StrVsp := ' ������ ';
            '2'..'4':
              StrVsp := ' ������ ';
            '5'..'9':
              StrVsp := ' ����� ';
          end
        else
          StrVsp := ' ����� ';
        StrVsp := StrVsp2 + StrVsp + NumberByWord(Back(Copy(NumStr, 3, 3)));
      end;
    6:
      begin
        StrVsp2 := NumberByWord(Back(Copy(NumStr, 1, 3)));
        I := Pos(' ���', StrVsp2);
        if Pos(' ����', StrVsp2) = I then
          I := 0;
        if I <> 0 then
          StrVsp2[I + 3] := '�';
        I := Pos(' ����', Strvsp2);
        if Pos(' �����', StrVsp2) = I then
          I := 0;
        if I <> 0 then
        begin
          StrVsp2[I + 3] := '�';
          StrVsp2[I + 4] := '�';
        end;
        if NumStr[2] <> '1' then
          case NumStr[3] of
            '1':
              StrVsp := ' ������ ';
            '2'..'4':
              StrVsp := ' ������ ';
            '5'..'9':
              StrVsp := ' ����� ';
          end
        else
          StrVsp := ' ����� ';
        StrVsp := StrVsp2 + StrVsp + NumberByWord(Back(Copy(NumStr, 4, 3)));
      end;
    7:
      begin
        StrVsp := Ten[IndNumber(NumStr, 1)];
        case NumStr[1] of
          '1':
            StrVsp := '���� �������';
          '2'..'4':
            StrVsp := StrVsp + ' ��������';
          '5'..'9':
            StrVsp := StrVsp + ' ���������';
        end;
        StrVsp := StrVsp + ' ' + NumberByWord(Back(Copy(NumStr, 2, 6)));
      end;
    8:
      begin
        StrVsp := NumberByWord(Back(Copy(NumStr, 1, 2)));
        StrVsp := StrVsp + ' �������';
        if NumStr[1] <> '1' then
          case NumStr[2] of
            '2'..'4':
              StrVsp := StrVsp + '�';
            '0', '5'..'9':
              StrVsp := StrVsp + '��';
          end
        else
          StrVsp := StrVsp + '��';
        StrVsp := StrVsp + ' ' + NumberByWord(Back(Copy(NumStr, 3, 6)));
      end;
    9:
      begin
        StrVsp := NumberByWord(Back(Copy(Numstr, 1, 3)));
        StrVsp := StrVsp + ' �������';
        if NumStr[2] <> '1' then
          case NumStr[3] of
            '2'..'4':
              StrVsp := StrVsp + '�';
            '0', '5'..'9':
              StrVsp := StrVsp + '��';
          end
        else
          StrVsp := StrVsp + '��';
        StrVsp := StrVsp + ' ' + NumberByWord(Back(Copy(NumStr, 4, 6)));
      end;
  end;
  if (Length(StrVsp) > 4) and (Copy(StrVsp, Length(StrVsp) - 3, 4) = Ten[0]) then
    StrVsp := Copy(StrVsp, 1, Length(StrVsp) - 4);
  Result := StrVsp;
end;

function GetSubStr(const S: string; const Index: Integer; const Separator: Char): string;
begin
  Result := SubStr(S, Index, Separator);
end;

function SubStr(const S: string; const Index: Integer; const Separator: string): string;
{ Returns a substring. Substrings are divided by Sep character [translated] }
var
  I: Integer;
  pB, pE: PChar;
begin
  Result := '';
  if ((Index < 0) or ((Index = 0) and (Length(S) > 0) and (S[1] = Separator))) or
    (Length(S) = 0) then
    Exit;
  pB := PChar(S);
  for I := 1 to Index do
  begin
    pB := StrPos(pB, PChar(Separator));
    if pB = nil then
      Exit;
    pB := pB + Length(Separator);
    if pB[0] = #0 then
      Exit;
  end;
  pE := StrPos(pB + 1, PChar(Separator));
  if pE = nil then
    pE := PChar(S) + Length(S);
  if not (AnsiStrLIComp(pB, PChar(Separator), Length(Separator)) = 0) then
    SetString(Result, pB, pE - pB);
end;

function SubStrW(const S: WideString; const Index: Integer; const Separator: WideString): WideString; 
{ Returns a substring. Substrings are divided by Sep character [translated] }
var
  I: Integer;
  pB, pE: PWideChar;
begin
  Result := '';
  if ((Index < 0) or ((Index = 0) and (Length(S) > 0) and (S[1] = Separator))) or
    (Length(S) = 0) then
    Exit;
  pB := PWideChar(S);
  for I := 1 to Index do
  begin
    pB := StrPosW(pB, PWideChar(Separator));
    if pB = nil then
      Exit;
    pB := pB + Length(Separator);
    if pB[0] = #0 then
      Exit;
  end;
  pE := StrPosW(pB + 1, PWideChar(Separator));
  if pE = nil then
    pE := PWideChar(S) + Length(S);
  if not (StrLICompW2(pB, PWideChar(Separator), Length(Separator)) = 0) then
    SetString(Result, pB, pE - pB);
end;

function SubStrEnd(const S: string; const Index: Integer; const Separator: string): string;
{ The same as SubStr, but substrings are numbered from the end [translated]}
var
  MaxIndex: Integer;
  pB: PChar;
begin
  { Not optimal implementation [translated] }
  MaxIndex := 0;
  pB := StrPos(PChar(S), PChar(Separator));
  while pB <> nil do
  begin
    Inc(MaxIndex);
    pB := StrPos(pB + Length(Separator), PChar(Separator));
  end;
  Result := SubStr(S, MaxIndex - Index, Separator);
end;

function TTFontSelected(const DC: HDC): Boolean;
var
  TM: TTEXTMETRIC;
begin
  GetTextMetrics(DC, TM);
  Result := TM.tmPitchAndFamily and TMPF_TRUETYPE <> 0;
end;

function SubWord(P: PChar; var P2: PChar): string;
var
  I: Integer;
begin
  I := 0;
  while not (P[I] in Separators) do
    Inc(I);
  SetString(Result, P, I);
  P2 := P + I;
end;

function ReplaceString(S: string; const OldPattern, NewPattern: string): string; 
var
  LW: Integer;
  P: PChar;
  Sm: Integer;
begin
  LW := Length(OldPattern);
  P := StrPos(PChar(S), PChar(OldPattern));
  while P <> nil do
  begin
    Sm := P - PChar(S);
    S := Copy(S, 1, Sm) + NewPattern + Copy(S, Sm + LW + 1, Length(S));
    P := StrPos(PChar(S) + Sm + Length(NewPattern), PChar(OldPattern));
  end;
  Result := S;
end;

function ReplaceStringW(S: WideString; const OldPattern, NewPattern: WideString): WideString;
var
  LW: Integer;
  P: PWideChar;
  Sm: Integer;
begin
  LW := Length(OldPattern);
  P := StrPosW(PWideChar(S), PWideChar(OldPattern));
  while P <> nil do
  begin
    Sm := P - PWideChar(S);
    S := Copy(S, 1, Sm) + NewPattern + Copy(S, Sm + LW + 1, Length(S));
    P := StrPosW(PWideChar(S) + Sm + Length(NewPattern), PWideChar(OldPattern));
  end;
  Result := S;
end;

function ReplaceStrings1(S: string; const Word, Frase: string): string;
begin
  Result := ReplaceString(S, Word, Frase);
end;

function ConcatSep(const S, S2, Separator: string): string;
begin
  Result := S;
  if Result <> '' then
    Result := Result + Separator;
  Result := Result + S2;
end;

function ConcatLeftSep(const S, S2, Separator: string): string;
begin
  Result := S;
  if Result <> '' then
    Result := Separator + Result;
  Result := S2 + Result;
end;

function MinimizeString(const S: string; const MaxLen: Integer): string;
begin
  if Length(S) > MaxLen then
    if MaxLen < 3 then
      Result := Copy(S, 1, MaxLen)
    else
      Result := Copy(S, 1, MaxLen - 3) + '...'
  else
    Result := S;
end;

function TrueInflateRect(const R: TRect; const I: Integer): TRect;
begin
  with R do
    SetRect(Result, Left - I, Top - I, Right + I, Bottom + I);
end;

{$IFDEF LINUX}
procedure SetRect(out R: TRect; Left, Top, Right, Bottom: Integer);
begin
  R.Left := Left;
  R.Top := Top;
  R.Right := Right;
  R.Bottom := Bottom;
end;
{$ENDIF}


function FileGetInfo(FileName: TFileName; var SearchRec: TSearchRec): Boolean;
var
  DosError: Integer;
  Path: TFileName;
begin
  Result := False;
  Path := ExtractFilePath(ExpandFileName(FileName)) + AllFilesMask;
{$IFDEF MSWINDOWS}
  FileName := AnsiUpperCase(ExtractFileName(FileName));
{$ENDIF}
{$IFDEF LINUX}
  FileName := ExtactFileName(FileName);
{$ENDIF}
  DosError := FindFirst(Path, faAnyFile, SearchRec);
  while DosError = 0 do
  begin
{$IFDEF MSWINDOWS}
   {$WARNINGS OFF}
    if (AnsiCompareText(SearchRec.FindData.cFileName, FileName) = 0) or
      (AnsiCompareText(SearchRec.FindData.cAlternateFileName, FileName) = 0) then
   {$WARNINGS ON}
{$ENDIF}
{$IFDEF LINUX}
    if AnsiCompareStr(SearchRec.Name, FileName) = 0 then
{$ENDIF}
    begin
      Result := True;
      Break;
    end;
    DosError := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end;

function HasSubFolder(APath: TFileName): Boolean;
var
  SearchRec: TSearchRec;
  DosError: Integer;
begin
  Result := False;
  AddSlash(APath);
  APath := Concat(APath, AllFilesMask);
  DosError := FindFirst(APath, faDirectory, SearchRec);
  while DosError = 0 do
  begin
    if (SearchRec.Attr and faDirectory = faDirectory) and
       (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
    begin
      Result := True;
      Break;
    end;
    DosError := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end;

function IsEmptyFolder(APath: TFileName): Boolean;
var
  SearchRec: TSearchRec;
  DosError: Integer;
begin
  Result := True;
  AddSlash(APath);
  APath := Concat(APath, AllFilesMask);
  DosError := FindFirst(APath, faDirectory, SearchRec);
  while DosError = 0 do
  begin
    if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
    begin
      Result := False;
      Break;
    end;
    DosError := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end;

function DirectoryExists(const Name: string): Boolean;
{$IFDEF COMPILER6_UP}
begin
  Result := SysUtils.DirectoryExists(Name);
end;
{$ELSE}
var Code: Cardinal;
begin
  Code := Integer(GetFileAttributes(PChar(Name)));
  Result := (Code <> $FFFFFFFF) and (Code and FILE_ATTRIBUTE_DIRECTORY <> 0);
end;
{$ENDIF COMPILER6_UP}

procedure ForceDirectories(Dir: string);
begin
  if Dir[Length(Dir)] = PathDelim then
    Delete(Dir, Length(Dir), 1);
{$IFDEF MSWINDOWS}
  if (Length(Dir) < 3) or DirectoryExists(Dir) or (ExtractFilePath(Dir) = Dir) then
    Exit; { avoid 'xyz:\' problem.}
{$ENDIF}
  ForceDirectories(ExtractFilePath(Dir));
  CreateDir(Dir);
end;

{$IFDEF MSWINDOWS}
{# from unit FileCtrl}

function LZFileExpand(const FileSource, FileDest: string): Boolean;
type
  TLZCopy = function(Source, Dest: Integer): Longint; stdcall;
  TLZOpenFile = function(Filename: PChar; var ReOpenBuff: TOFStruct; Style: Word): Integer; stdcall;
  TLZClose = procedure(hFile: Integer); stdcall;
var
  Source, Dest: Integer;
  OSSource, OSDest: TOFSTRUCT;
  Res: Integer;
  Ins: Integer;
  LZCopy: TLZCopy;
  LZOpenFile: TLZOpenFile;
  LZClose: TLZClose;
begin
  Result := False;
  Ins := LoadLibrary('LZ32.dll');
  try
    LZCopy := GetProcAddress(Ins, 'LZCopy');
    LZOpenFile := GetProcAddress(Ins, 'LZOpenFileA');
    LZClose := GetProcAddress(Ins, 'LZClose');
    OSSource.cBytes := SizeOf(TOFSTRUCT);
    OSDest.cBytes := SizeOf(TOFSTRUCT);
    Source := LZOpenFile(
      PChar(FileSource), // address of name of file to be opened
      OSSource, // address of open file structure
      OF_READ or OF_SHARE_DENY_NONE);// action to take
    if Source < 0 then
    begin
      DeleteFile(FileDest);
      Dest := LZOpenFile(
        PChar(FileDest), // address of name of file to be opened
        OSDest, // address of open file structure
        OF_CREATE or OF_WRITE or OF_SHARE_EXCLUSIVE); // action to take
      if Dest >= 0 then
      begin
        Res := LZCopy(Source, Dest);
        if Res >= 0 then
          Result := True;
      end;
      LZClose(Source);
      LZClose(Dest);
    end;
  finally
    FreeLibrary(Ins);
  end;
end;
{$ENDIF}

procedure Dos2Win(var S: string);
var
  I: Integer;
begin
  for I := 1 to Length(S) do
    case S[I] of
      #$80..#$AF:
        S[I] := Char(Byte(S[I]) + (192 - $80));
      #$E0..#$EF:
        S[I] := Char(Byte(S[I]) + (240 - $E0));
    end;
end;

procedure Win2Dos(var S: string);
var
  I: Integer;
begin
  for I := 1 to Length(S) do
    case S[I] of
      #$C0..#$EF:
        S[I] := Char(Byte(S[I]) - (192 - $80));
      #$F0..#$FF:
        S[I] := Char(Byte(S[I]) - (240 - $E0));
    end;
end;

function Dos2WinRes(const S: string): string;
begin
  Result := S;
  Dos2Win(Result);
end;

function Win2DosRes(const S: string): string;
begin
  Result := S;
  Win2Dos(Result);
end;

function Win2Koi(const S: string): string;
const
  W = '�������������������������������������Ũ��������������������������';
  K = '�����ţ����������������������������������������������������������';
var
  I, J: Integer;
begin
  Result := S;
  for I := 1 to Length(Result) do
  begin
    J := Pos(Result[I], W);
    if J > 0 then
      Result[I] := K[J];
  end;
end;

procedure FillWideChar(var Buffer; Count: Integer; const Value: WideChar);
var
  P: PLongint;
  Value2: Cardinal;
  CopyWord: Boolean;
begin
  Value2 := (Cardinal(Value) shl 16) or Cardinal(Value);
  CopyWord := Count and $1 <> 0;
  Count := Count div 2;
  P := @Buffer;
  while Count > 0 do
  begin
    P^ := Value2;
    Inc(P);
    Dec(Count);
  end;
  if CopyWord then
    PWideChar(P)^ := Value;
end;

procedure MoveWideChar(const Source; var Dest; Count: Integer);
begin
  Move(Source, Dest, Count * SizeOf(WideChar));
end;

function Spaces(const N: Integer): string;
begin
  if N > 0 then
  begin
    SetLength(Result, N);
    FillChar(Result[1], N, ' ');
  end
  else
    Result := '';
end;

function SpacesW(const N: Integer): WideString;
begin
  if N > 0 then
  begin
    SetLength(Result, N);
    FillWideChar(Result[1], N, ' ');
  end
  else
    Result := '';
end;

function AddSpaces(const S: string; const N: Integer): string;
var
  Len: Integer;
begin
  Len := Length(S);
  if (Len < N) and (N > 0) then
  begin
    SetLength(Result, N);
    Move(S[1], Result[1], Len * SizeOf(Char));
    FillChar(Result[Len + 1], N - Len, ' ');
  end
  else
    Result := S;
end;

function AddSpacesW(const S: WideString; const N: Integer): WideString;
var
  Len: Integer;
begin
  Len := Length(S);
  if (Len < N) and (N > 0) then
  begin
    SetLength(Result, N);
    MoveWideChar(S[1], Result[1], Len);
    FillWideChar(Result[Len + 1], N - Len, ' ');
  end
  else
    Result := S;
end;

{$IFDEF MSWINDOWS}
function KeyPressed(VK: Integer): Boolean;
begin
  Result := GetKeyState(VK) and $8000 = $8000;
end;
{$ENDIF}

{ (rb) maybe construct a english variant, change name to indicate it's a russian
       function? }
function LastDate(const Dat: TDateTime): string;
const
  D2D: array [0..9] of 1..3 = (3, 1, 2, 2, 2, 3, 3, 3, 3, 3);
  Day: array [1..3] of string = ('����', '���', '����'); // Day, Days, Days
  Month: array [1..3] of string = ('�����', '������', '�������'); // Month, Months, Months
  Year: array [1..3] of string = ('���', '����', '���'); // Year, Years, Years
  Week: array [1..4] of string = ('������', '2 ������', '3 ������', '�����'); // Week, 2 Weeks, 3 Weeks, Month
var
  Y, M, D: Integer;
begin
  if Date = Dat then
    Result := '�������' // Today
  else
  if Dat = Date - 1 then
    Result := '�����' // Yesterday
  else
  if Dat = Date - 2 then
    Result := '���������' // Day before yesterday
  else
  if Dat > Date then
    Result := '� �������' // In the future
  else
  begin
    D := Trunc(Date - Dat);
    Y := Round(D / 365);
    M := Round(D / 30);
    if Y > 0 then
      Result := IntToStr(Y) + ' ' + Year[D2D[StrToInt(IntToStr(Y)[Length(IntToStr(Y))])]] + ' �����' // ago
    else
    if M > 0 then
      Result := IntToStr(M) + ' ' + Month[D2D[StrToInt(IntToStr(M)[Length(IntToStr(M))])]] + ' �����' // ago
    else
    if D > 6 then
      Result := Week[D div 7] + ' �����' // ago
    else
    if D > 0 then
      Result := IntToStr(D) + ' ' + Day[D2D[StrToInt(IntToStr(D)[Length(IntToStr(D))])]] + ' �����' // ago
  end;
end;

procedure AddSlash(var Dir: TFileName);
begin
  if (Length(Dir) > 0) and (Dir[Length(Dir)] <> PathDelim) then
    Dir := Dir + PathDelim;
end;

function AddSlash2(const Dir: TFileName): string;
begin
  Result := Dir;
  if (Length(Dir) > 0) and (Dir[Length(Dir)] <> PathDelim) then
    Result := Dir + PathDelim;
end;

function AddPath(const FileName, Path: TFileName): TFileName;
begin
  if ExtractFileDrive(FileName) = '' then
    Result := AddSlash2(Path) + FileName
  else
    Result := FileName;
end;

function AddPaths(const PathList, Path: string): string;
var
  I: Integer;
  S: string;
begin
  Result := '';
  I := 0;
  S := SubStr(PathList, I, PathSep);
  while S <> '' do
  begin
    Result := ConcatSep(Result, AddPath(S, Path), PathSep);
    Inc(I);
    S := SubStr(PathList, I, PathSep);
  end;
end;

function ParentPath(const Path: TFileName): TFileName;
begin
  Result := Path;
  if (Length(Result) > 0) and (Result[Length(Result)] = PathDelim) then
    Delete(Result, Length(Result), 1);
  Result := ExtractFilePath(Result);
end;

function FindInPath(const FileName, PathList: string): TFileName;
var
  I: Integer;
  S: string;
begin
  I := 0;
  S := SubStr(PathList, I, PathSep);
  while S <> '' do
  begin
    Result := AddSlash2(S) + FileName;
    if FileExists(Result) then
      Exit;
    Inc(I);
    S := SubStr(PathList, I, PathSep);
  end;
  Result := '';
end;

function GetComputerID: string;
{$IFDEF MSWINDOWS}
var
  SN: DWORD;
  Nul: DWORD;
  WinDir: array [0..MAX_PATH] of Char;
begin
  GetWindowsDirectory(WinDir, MAX_PATH);
  WinDir[3] := #0;
  if GetVolumeInformation(
    WinDir, // address of root directory of the file system
    nil, // address of name of the volume
    0, // Length of lpVolumeNameBuffer
    @SN, // address of volume serial number
    Nul, // address of system's maximum filename Length
    Nul, // address of file system flags
    nil, // address of name of file system
    0) // Length of lpFileSystemNameBuffer
    then
    Result := IntToHex(SN, 8)
  else
    Result := 'None';
end;
{$ENDIF}
{$IFDEF LINUX}
begin
  Result := 'None';
end;
{$ENDIF}

function CurrencyToStr(const Cur: currency): string;
begin
  Result := CurrToStrF(Cur, ffCurrency, CurrencyDecimals)
end;

function Cmp(const S1, S2: string): Boolean;
begin
  //Result := AnsiCompareText(S1, S2) = 0;
  Result := AnsiStrIComp(PChar(S1), PChar(S2)) = 0;
end;

function StringCat(var S1: string; S2: string): string;
begin
  S1 := S1 + S2;
  Result := S1;
end;

function HasChar(const Ch: Char; const S: string): Boolean; 
begin
  Result := Pos(Ch, S) > 0;
end;

function HasCharW(const Ch: WideChar; const S: WideString): Boolean;
begin
  Result := Pos(Ch, S) > 0;
end;

function HasAnyChar(const Chars: string; const S: string): Boolean;
var
  I: Integer;
begin
  for I := 1 to Length(Chars) do
    if HasChar(Chars[I], S) then
    begin
      Result := True;
      Exit;
    end;
  Result := False;
end;

function CountOfChar(const Ch: Char; const S: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
    if S[I] = Ch then
      Inc(Result);
end;

procedure SwapInt(var Int1, Int2: Integer);
var
  Tmp: Integer;
begin
  Tmp := Int1;
  Int1 := Int2;
  Int2 := Tmp;
end;

function DeleteReadOnlyFile(const FileName: TFileName): Boolean;
begin
{$IFDEF MSWINDOWS}
  {$WARNINGS OFF}
  FileSetAttr(FileName, 0); {clear Read Only Flag}
  {$WARNINGS ON}
{$ENDIF}
{$IFDEF LINUX}
  FileSetReadOnly(FileName, False);
{$ENDIF}  
  Result := DeleteFile(FileName);
end;

function HasParam(const Param: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to ParamCount do
  begin
    Result := Cmp(ParamStr(I), Param);
    if Result then
      Exit;
  end;
end;

function HasSwitch(const Param: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to ParamCount do
    if HasChar(ParamStr(I)[1], '-/') then
    begin
      Result := Cmp(Copy(ParamStr(I), 2, Length(Param)), Param);
      if Result then
        Exit;
    end;
end;

function Switch(const Param: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to ParamCount do
    if HasChar(ParamStr(I)[1], '-/\') and
      Cmp(Copy(ParamStr(I), 2, Length(Param)), Param) then
    begin
      Result := Copy(ParamStr(I), 2 + Length(Param), 260);
      Exit;
    end;
end;

function ExePath: TFileName;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

function FileNewExt(const FileName, NewExt: TFileName): TFileName;
begin
  Result := Copy(FileName, 1, Length(FileName) - Length(ExtractFileExt(FileName))) + NewExt;
end;

function CharInSet(const Ch: Char; const SetOfChar: TSysCharSet): Boolean;
begin
  Result := Ch in SetOfChar;
end;

function CharInSetW(const Ch: WideChar; const SetOfChar: TSysCharSet): Boolean;
begin
  if Word(Ch) > 255 then
    Result := False
  else
    Result := Char(Ch) in SetOfChar;
end;

function IntPower(Base, Exponent: Integer): Integer;
begin
  if Exponent > 0 then
  begin
    Result := Base;
    Dec(Exponent);
    while Exponent > 0 do
    begin
      Result := Result * Base;
      Dec(Exponent);
    end;
  end
  else
  if Exponent < 0 then
  begin
    Result := 1;
    Inc(Exponent);
    while Exponent < 0 do
    begin
      Result := Result div Base;
      Inc(Exponent);
    end;
  end
  else
    Result := Base;
end;

function ChangeTopException(E: TObject): TObject;
type
  PRaiseFrame = ^TRaiseFrame;
  TRaiseFrame = record
    NextRaise: PRaiseFrame;
    ExceptAddr: Pointer;
    ExceptObject: TObject;
    ExceptionRecord: PExceptionRecord;
  end;
begin
  { CBuilder 3 Warning !}
  { if linker error occured with message "unresolved external 'System::RaiseList'" try
    comment this function implementation, compile,
    then uncomment and compile again. }
  {$IFDEF COMPILER6_UP}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$ENDIF}
  if RaiseList <> nil then
  begin
    Result := PRaiseFrame(RaiseList)^.ExceptObject;
    PRaiseFrame(RaiseList)^.ExceptObject := E
  end
  else
    Result := nil;
//    raise Exception.Create('Not in exception');
end;

function MakeValidFileName(const FileName: TFileName;
  const ReplaceBadChar: Char): TFileName;
var
  I: Integer;
begin
  Result := FileName;
  for I := 1 to Length(Result) do
    if HasChar(Result[I], '''":?*\/') then
      Result[I] := ReplaceBadChar;
end;

function Var2Type(V: Variant; const VarType: Integer): Variant;
begin
  if TVarData(V).VType in [varEmpty, varNull] then
  begin
    case VarType of
      varString, varOleStr:
        Result := '';
      varInteger, varSmallint, varByte:
        Result := 0;
      varBoolean:
        Result := False;
      varSingle, varDouble, varCurrency, varDate:
        Result := 0.0;
      varVariant:
        Result := Null;
    else
      Result := VarAsType(V, VarType);
    end;
  end
  else
    Result := VarAsType(V, VarType);
  if (VarType = varInteger) and (TVarData(V).VType = varBoolean) then
    Result := Integer(V = True);
end;

function VarToInt(V: Variant): Integer;
begin
  Result := Var2Type(V, varInteger);
end;

function VarToFloat(V: Variant): Double;
begin
  Result := Var2Type(V, varDouble);
end;

function CopyDir(const SourceDir, DestDir: TFileName): Boolean;
var
  SearchRec: TSearchRec;
  DosError: Integer;
  Path, DestPath: TFileName;
begin
  Result := False;
  if not CreateDir(DestDir) then
    Exit;
  Path := SourceDir;
  DestPath := AddSlash2(DestDir);
  AddSlash(Path);
  DosError := FindFirst(Path + AllFilesMask, faAnyFile, SearchRec);
  while DosError = 0 do
  begin
    if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
    begin
      if (SearchRec.Attr and faDirectory) = faDirectory then
        Result := CopyDir(Path + SearchRec.Name, AddSlash2(DestDir) + SearchRec.Name)
      else
        Result := CopyFile(PChar(Path + SearchRec.Name),
          PChar(DestPath + SearchRec.Name), True);
      if not Result then
        Exit;
    end;
    DosError := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
  Result := True;
end;

function FileTimeToDateTime(const FT: TFileTime): TDateTime;
{$IFDEF MSWINDOWS}
var
  LocalFileTime: TFileTime;
  FileDate: Integer;
begin
  FileTimeToLocalFileTime(FT, LocalFileTime);
  FileTimeToDosDateTime(LocalFileTime, LongRec(FileDate).Hi, LongRec(FileDate).Lo);
  Result := FileDateToDateTime(FileDate);
end;
{$ENDIF}
{$IFDEF LINUX}
begin
  Result := FileDateToDateTime(FT);
end;
{$ENDIF}

function DefStr(const S: string; Default: string): string;
begin
  if S <> '' then
    Result := S
  else
    Result := Default;
end;

function StrLICompW2(S1, S2: PWideChar; MaxLen: Integer): Integer;
 // faster than the JclUnicode.StrLICompW function
var
  P1, P2: WideString;
begin
  SetString(P1, S1, Min(MaxLen, StrLenW(S1)));
  SetString(P2, S2, Min(MaxLen, StrLenW(S2)));
{$IFDEF COMPILER6_UP}
  Result := SysUtils.WideCompareText(P1, P2);
{$ELSE}
  Result := WideCompareText(P1, P2);
{$ENDIF}
end;

function StrPosW(S, SubStr: PWideChar): PWideChar;
var
  P: PWideChar;
  I: Integer;
begin
  Result := nil;
  if (S = nil) or (SubStr = nil) or
     (S[0] = #0) or (SubStr[0] = #0) then Exit;
  Result := S;
  while Result[0] <> #0 do
  begin
    if Result[0] <> SubStr[0] then
      Inc(Result)
    else
    begin
      P := Result + 1;
      I := 0;
      while (P[0] <> #0) and (P[0] = SubStr[I]) do
      begin
        Inc(I);
        Inc(P);
      end;
      if SubStr[I] = #0 then
        Exit
      else
        Inc(Result);
    end;
  end;
  Result := nil;
end;

function StrLenW(S: PWideChar): Integer;
begin
  Result := 0;
  if S <> nil then
    while S[Result] <> #0 do
      Inc(Result);
end;

{$IFNDEF COMPILER6_UP}
function WideCompareText(const S1, S2: WideString): Integer;
begin
  if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) then
    Result := CompareText(string(S1), string(S2))
  else
    Result := CompareStringW(LOCALE_USER_DEFAULT, NORM_IGNORECASE,
      PWideChar(S1), Length(S1), PWideChar(S2), Length(S2)) - 2;
end;

function WideUpperCase(const S: WideString): WideString;
begin
  Result := S;
  if Result <> '' then
    CharUpperBuffW(Pointer(Result), Length(Result));
end;

function WideLowerCase(const S: WideString): WideString;
begin
  Result := S;
  if Result <> '' then
    CharLowerBuffW(Pointer(Result), Length(Result));
end;
{$ENDIF !COMPILER6_UP}

function TrimW(const S: WideString): WideString;
{$IFDEF COMPILER6_UP}
begin
  Result := Trim(S);
end;
{$ELSE}
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do Inc(I);
  if I > L then
    Result := ''
  else
  begin
    while S[L] <= ' ' do Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;
{$ENDIF}

function TrimLeftW(const S: WideString): WideString;
{$IFDEF COMPILER6_UP}
begin
  Result := TrimLeft(S);
end;
{$ELSE}
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do Inc(I);
  Result := Copy(S, I, Maxint);
end;
{$ENDIF}

function TrimRightW(const S: WideString): WideString;
{$IFDEF COMPILER6_UP}
begin
  Result := TrimRight(S);
end;
{$ELSE}
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] <= ' ') do Dec(I);
  Result := Copy(S, 1, I);
end;
{$ENDIF}

procedure SetDelimitedText(List: TStrings; const Text: string; Delimiter: Char);
var
{$IFDEF COMPILER6_UP}
  Ch: Char;
{$ELSE}
  S: string;
  F, P: PChar;
{$ENDIF}
begin
{$IFDEF COMPILER6_UP}
  Ch := List.Delimiter;
  try
    List.Delimiter := Delimiter;
    List.DelimitedText := Text;
  finally
    List.Delimiter := Ch;
  end;
{$ELSE}
begin
  List.BeginUpdate;
  try
    List.Clear;
    P := PChar(Text);
    while P^ in [#1..#32] do Inc(P);
    while P^ <> #0 do
    begin
      if P^ = '"' then
      begin
        F := P;
        while (P[0] <> #0) and (P[0] <> '"') do Inc(P);
        SetString(S, F, P - F);
      end
      else
      begin
        F := P;
        while not (P[0] < #32) and (P[0] <> Delimiter) do Inc(P);
        SetString(S, F, P - F);
      end;
      List.Add(S);
      while P[0] in [#1..#32] do Inc(P);
      if P[0] = Delimiter then
      begin
        F := P;
        Inc(F);
        if F[0] = #0 then List.Add('');
        repeat
          Inc(P);
        until not (P[0] in [#1..#32]);
      end;
    end;
  finally
    List.EndUpdate;
  end;
end;
{$ENDIF}
end;

function GetComputerName: string;
{$IFDEF MSWINDOWS}
var
  nSize: DWORD;
begin
  nSize := MAX_COMPUTERNAME_LENGTH + 1;
  SetLength(Result, nSize);
  if Windows.GetComputerName(
    PChar(Result), // address of name buffer
    nSize) then // address of size of name buffer
    SetLength(Result, nSize)
  else
    Result := '';
end;
{$ENDIF}
{$IFDEF LINUX}
begin
  SetLength(Result, 255);
  if gethostname(PChar(Result), Length(Result)) = -1 then
    Result := ''
  else
    SetLength(Result, StrLen(PChar(Result)));
end;
{$ENDIF}

function StrToBool(const S: string): Boolean;
begin
  Result := (S = '1') or Cmp(S, 'True') or Cmp(S, 'yes');
end;

procedure WordBreak(Canvas: TCanvas; const S: string; Ss: TStrings);
begin
  Ss.Text := S;
end;

procedure RATextOut(Canvas: TCanvas; const R, RClip: TRect; const S: string);
begin
  RATextOutEx(Canvas, R, RClip, S, False);
end;

function RATextCalcHeight(Canvas: TCanvas; const R: TRect; const S: string): Integer;
begin
  Result := RATextOutEx(Canvas, R, R, S, True);
end;

function RATextOutEx(Canvas: TCanvas; const R, RClip: TRect; const S: string; const CalcHeight: Boolean): Integer;
var
  Ss: TStrings;
  I: Integer;
  H: Integer;
begin
  Ss := TStringList.Create;
  try
    WordBreak(Canvas, S, Ss);
    H := Canvas.TextHeight('A');
    Result := H * Ss.Count;
    if not CalcHeight then
      for I := 0 to Ss.Count - 1 do
        ClxExtTextOut(
          Canvas, // handle of device context
          R.Left, // X-coordinate of reference point
          R.Top + H * I, // Y-coordinate of reference point
          ETO_CLIPPED, // text-output options
          @RClip, // optional clipping and/or opaquing rectangle
          Ss[I],
          nil); // address of array of intercharacter spacing values
  finally
    Ss.Free;
  end;
end;

procedure Cinema(Canvas: TCanvas; rS, rD: TRect);
const
  Pause = 30; {milliseconds}
  Steps = 7;
  Width = 1;
var
  R: TRect;
  I: Integer;
  PenOld: TPen;

  procedure FrameR(R: TRect);
  begin
    with Canvas do
    begin
      MoveTo(R.Left, R.Top);
      LineTo(R.Left, R.Bottom);
      LineTo(R.Right, R.Bottom);
      LineTo(R.Right, R.Top);
      LineTo(R.Left, R.Top);
    end;
  end;

  procedure Frame;
  begin
    FrameR(R);
    with Canvas do
    begin
      MoveTo(rS.Left, rS.Top);
      LineTo(R.Left, R.Top);
      if R.Top <> rS.Top then
      begin
        MoveTo(rS.Right, rS.Top);
        LineTo(R.Right, R.Top);
      end;
      if R.Left <> rS.Left then
      begin
        MoveTo(rS.Left, rS.Bottom);
        LineTo(R.Left, R.Bottom);
      end;
      if (R.Bottom <> rS.Bottom) and (R.Right <> rS.Right) then
      begin
        MoveTo(rS.Right, rS.Bottom);
        LineTo(R.Right, R.Bottom);
      end;
    end;
  end;

begin
  PenOld := TPen.Create;
  PenOld.Assign(Canvas.Pen);
  Canvas.Pen.Mode := pmNot;
  Canvas.Pen.Width := Width;
  Canvas.Pen.Style := psDot;
  FrameR(rS);
  R := rS;
  for I := 1 to Steps do
  begin
    R.Left := rS.Left + (rD.Left - rS.Left) div Steps * I;
    R.Top := rS.Top + (rD.Top - rS.Top) div Steps * I;
    R.Bottom := rS.Bottom + (rD.Bottom - rS.Bottom) div Steps * I;
    R.Right := rS.Right + (rD.Right - rS.Right) div Steps * I;
    Frame;
    Sleep(Pause);
    Frame;
  end;
  FrameR(rS);
  Canvas.Pen.Assign(PenOld);
end;


function IniReadSection(const IniFileName: TFileName; const Section: string; Ss: TStrings): Boolean;
var
  F: Integer;
  S: string;
begin
  with TStringList.Create do
  try
    LoadFromFile(IniFileName);
    F := IndexOf('[' + Section + ']');
    Result := F > -1;
    if Result then
    begin
      Ss.Clear;
      Inc(F);
      while F < Count do
      begin
        S := Strings[F];
        if (Length(S) > 0) and (Trim(S[1]) = '[') then
          Break;
        Ss.Add(S);
        Inc(F);
      end;
    end;
  finally
    Free;
  end;
end;

procedure SaveTextFile(const FileName: TFileName; const Source: string);
begin
  with TStringList.Create do
  try
    Text := Source;
    SaveToFile(FileName);
  finally
    Free;
  end;
end;

function LoadTextFile(const FileName: TFileName): string;
begin
  with TStringList.Create do
  try
    LoadFromFile(FileName);
    Result := Text;
  finally
    Free;
  end;
end;

function ReadFolder(const Folder, Mask: TFileName; FileList: TStrings): Integer;
var
  SearchRec: TSearchRec;
  DosError: Integer;
begin
  FileList.Clear;
  Result := FindFirst(AddSlash2(Folder) + Mask, faAnyFile, SearchRec);
  DosError := Result;
  while DosError = 0 do
  begin
    if not ((SearchRec.Attr and faDirectory) = faDirectory) then
      FileList.Add(SearchRec.Name);
    DosError := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end;

function ReadFolders(const Folder: TFileName; FolderList: TStrings): Integer;
var
  SearchRec: TSearchRec;
  DosError: Integer;
begin
  FolderList.Clear;
  Result := FindFirst(AddSlash2(Folder) + AllFilesMask, faAnyFile, SearchRec);
  DosError := Result;
  while DosError = 0 do
  begin
    if ((SearchRec.Attr and faDirectory) = faDirectory) and
      (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
      FolderList.Add(SearchRec.Name);
    DosError := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end;



{
    with memEdit do begin
      Text := ReplaceStrings(Text, SelStart+1, SelLength, memWords.Lines, memFrases.Lines, NewSelStart);
      SelStart := NewSelStart-1;
    end; }

function ReplaceStrings(S: string; PosBeg, Len: Integer; Words, Frases: TStrings;
  var NewSelStart: Integer): string;
var
  I, Beg, Ent, LS, F: Integer;
  Word: string;
begin
  NewSelStart := PosBeg;
  Result := S;
  LS := Length(S);
  if Len = 0 then
  begin
    if PosBeg < 1 then
      Exit;
    if PosBeg = 1 then
      PosBeg := 2;
    for I := PosBeg - 1 downto 1 do
      if S[I] in Separators then
        Break;
    Beg := I + 1;
    for Ent := PosBeg to LS do
      if S[Ent] in Separators then
        Break;
    if Ent > Beg then
      Word := Copy(S, Beg, Ent - Beg)
    else
      Word := S[PosBeg];
  end
  else
  begin
    Word := Copy(S, PosBeg, Len);
    Beg := PosBeg;
    Ent := PosBeg + Len;
  end;
  if Word = '' then
    Exit;
  F := Words.IndexOf(Word);
  if (F > -1) and (F < Frases.Count) then
  begin
    Result := Copy(S, 1, Beg - 1) + Frases[F] + Copy(S, Ent, LS);
    NewSelStart := Beg + Length(Frases[F]);
  end;
end;

{
    with memEdit do
      Text := ReplaceAllStrings(Text, memWords.Lines, memFrases.Lines);
}

function ReplaceAllStrings(S: string; Words, Frases: TStrings): string;
var
  I, LW: Integer;
  P: PChar;
  Sm: Integer;
begin
  for I := 0 to Words.Count - 1 do
  begin
    LW := Length(Words[I]);
    P := StrPos(PChar(S), PChar(Words[I]));
    while P <> nil do
    begin
      Sm := P - PChar(S);
      S := Copy(S, 1, Sm) + Frases[I] + Copy(S, Sm + LW + 1, Length(S));
      P := StrPos(PChar(S) + Sm + Length(Frases[I]), PChar(Words[I]));
    end;
  end;
  Result := S;
end;

function CountOfLines(const S: string): Integer;
begin
  with TStringList.Create do
  try
    Text := S;
    Result := Count;
  finally
    Free;
  end;
end;

procedure DeleteEmptyLines(Ss: TStrings);
var
  I: Integer;
begin
  I := 0;
  while I < Ss.Count do
    if Trim(Ss[I]) = '' then
      Ss.Delete(I)
    else
      Inc(I);
end;

procedure SQLAddWhere(SQL: TStrings; const Where: string);
var
  I, J: Integer;
begin
  J := SQL.Count - 1;
  for I := 0 to SQL.Count - 1 do
    // (rom) does this always work? Think of a fieldname "grouporder"
    if StrLIComp(PChar(SQL[I]), 'where ', 6) = 0 then
    begin
      J := I + 1;
      while J < SQL.Count do
      begin
        if (StrLIComp(PChar(SQL[J]), 'order ', 6) = 0) or
          (StrLIComp(PChar(SQL[J]), 'group ', 6) = 0) then
          Break;
        Inc(J);
      end;
    end;
  SQL.Insert(J, 'and ' + Where);
end;

procedure InternalFrame3D(Canvas: TCanvas; var Rect: TRect; TopColor, BottomColor: TColor;
  Width: Integer);

  procedure DoRect;
  var
    TopRight, BottomLeft: TPoint;
  begin
    with Canvas, Rect do
    begin
      TopRight.X := Right;
      TopRight.Y := Top;
      BottomLeft.X := Left;
      BottomLeft.Y := Bottom;
      Pen.Color := TopColor;
      PolyLine([BottomLeft, TopLeft, TopRight]);
      Pen.Color := BottomColor;
      Dec(BottomLeft.X);
      PolyLine([TopRight, BottomRight, BottomLeft]);
    end;
  end;

begin
  Canvas.Pen.Width := 1;
  Dec(Rect.Bottom); Dec(Rect.Right);
  while Width > 0 do
  begin
    Dec(Width);
    DoRect;
    InflateRect(Rect, -1, -1);
  end;
  Inc(Rect.Bottom); Inc(Rect.Right);
end;

procedure Roughed(ACanvas: TCanvas; const ARect: TRect; const AVert: Boolean);
var
  I: Integer;
  J: Integer;
  R: TRect;
  V: Boolean;
  H: Boolean;
begin
  H := True;
  V := True;
  for I := 0 to (ARect.Right - ARect.Left) div 4 do
  begin
    for J := 0 to (ARect.Bottom - ARect.Top) div 4 do
    begin
      if AVert then
      begin
        if V then
          R := Bounds(ARect.Left + I * 4 + 2, ARect.Top + J * 4, 2, 2)
        else
          R := Bounds(ARect.Left + I * 4, ARect.Top + J * 4, 2, 2);
      end
      else
      begin
        if H then
          R := Bounds(ARect.Left + I * 4, ARect.Top + J * 4 + 2, 2, 2)
        else
          R := Bounds(ARect.Left + I * 4, ARect.Top + J * 4, 2, 2);
      end;

      InternalFrame3D(ACanvas, R, clBtnHighlight, clBtnShadow, 1);
      V := not V;
    end;
    H := not H;
  end;
end;

function BitmapFromBitmap(SrcBitmap: TBitmap; const AWidth, AHeight, Index: Integer): TBitmap;
begin
  Result := TBitmap.Create;
  Result.Width := AWidth;
  Result.Height := AHeight;
  Result.Canvas.CopyRect(Rect(0, 0, AWidth, AHeight), SrcBitmap.Canvas, Bounds(AWidth * Index, 0, AWidth, AHeight));
end;

{$IFDEF MSWINDOWS}
function ResSaveToFileEx(Instance: HINST; Typ, Name: PChar;
  const Compressed: Boolean; const FileName: string): Boolean;
var
  RhRsrc: HRSRC;
  RhGlobal: HGLOBAL;
  RAddr: Pointer;
  RLen: DWORD;
  Stream: TFileStream;
  FileDest: string;
begin
  Result := False;
  RhRsrc := FindResource(
    Instance, // resource-module handle
    Name, // address of resource name
    Typ); // address of resource type
  if RhRsrc = 0 then
    Exit;
  RhGlobal := LoadResource(
    Instance, // resource-module handle
    RhRsrc); // resource handle
  if RhGlobal = 0 then
    Exit;
  RAddr := LockResource(
    RhGlobal); // handle to resource to lock
  FreeResource(RhGlobal);
  if RAddr = nil then
    Exit;
  RLen := SizeofResource(
    Instance, // resource-module handle
    RhRsrc); // resource handle
  if RLen = 0 then
    Exit;
  { And now it is possible to duplicate [translated] }
  Stream := nil; { for Free [translated] }
  if Compressed then
    FileDest := GenTempFileName(FileName)
  else
    FileDest := FileName;
  try
    try
      Stream := TFileStream.Create(FileDest, fmCreate or fmOpenWrite or fmShareExclusive);
      Stream.WriteBuffer(RAddr^, RLen);
    finally
      Stream.Free;
    end;
    if Compressed then
    begin
      Result := LZFileExpand(FileDest, FileName);
      DeleteFile(FileDest);
    end
    else
      Result := True;
  except
  end;
end;

function ResSaveToFile(const Typ, Name: string; const Compressed: Boolean;
  const FileName: string): Boolean;
begin
  Result := ResSaveToFileEx(hInstance, PChar(Typ), PChar(Name), Compressed, FileName);
end;

function ResSaveToString(Instance: HINST; const Typ, Name: string;
  var S: string): Boolean;
var
  RhRsrc: HRSRC;
  RhGlobal: HGLOBAL;
  RAddr: Pointer;
  RLen: DWORD;
begin
  Result := False;
  RhRsrc := FindResource(
    Instance, // resource-module handle
    PChar(Name), // address of resource name
    PChar(Typ)); // address of resource type
  if RhRsrc = 0 then
    Exit;
  RhGlobal := LoadResource(
    Instance, // resource-module handle
    RhRsrc); // resource handle
  if RhGlobal = 0 then
    Exit;
  RAddr := LockResource(
    RhGlobal); // handle to resource to lock
  FreeResource(RhGlobal);
  if RAddr = nil then
    Exit;
  RLen := SizeofResource(
    Instance, // resource-module handle
    RhRsrc); // resource handle
  if RLen = 0 then
    Exit;
  { And now it is possible to duplicate [translated] }
  SetString(S, PChar(RAddr), RLen);
end;
{$ENDIF}


function TextWidth(const AStr: string): Integer;
{$IFDEF COMPLIB_VCL}
var
  Canvas: TCanvas;
  DC: HDC;
begin
  DC := GetDC(HWND_DESKTOP);
  Canvas := TCanvas.Create;
  // (rom) secured
  try
    Canvas.Handle := DC;
    Result := Canvas.TextWidth(AStr);
    Canvas.Handle := 0;
    Canvas.Free;
  finally
    ReleaseDC(HWND_DESKTOP, DC);
  end;
end;
{$ENDIF}
{$IFDEF COMPLIB_CLX}
var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  try
    Result := Bmp.Canvas.TextWidth(AStr);
  finally
    Bmp.Free;
  end;
end;
{$ENDIF}


procedure SetChildPropOrd(Owner: TComponent; const PropName: string; Value: Longint);
var
  I: Integer;
  PropInfo: PPropInfo;
begin
  for I := 0 to Owner.ComponentCount - 1 do
  begin
    PropInfo := GetPropInfo(Owner.Components[I].ClassInfo, PropName);
    if PropInfo <> nil then
      SetOrdProp(Owner.Components[I], PropInfo, Value);
  end;
end;

procedure Error(const Msg: string);
begin
  raise Exception.Create(Msg);
end;

procedure ItemHtDrawEx(Canvas: TCanvas; Rect: TRect;
  const State: TOwnerDrawState; const Text: string;
  const HideSelColor: Boolean; var PlainItem: string;
  var Width: Integer; CalcWidth: Boolean);
var
  CL: string;
  I: Integer;
  M1: string;
  OriRect: TRect; // it's added
  oldFontStyles: TFontStyles;
  oldFontColor: TColor;

  function Cmp(M1: string): Boolean;
  begin
    Result := AnsiStrLIComp(PChar(Text) + I, PChar(M1), Length(M1)) = 0;
  end;

  function Cmp1(M1: string): Boolean;
  begin
    Result := AnsiStrLIComp(PChar(Text) + I, PChar(M1), Length(M1)) = 0;
    if Result then
      Inc(I, Length(M1));
  end;

  function CmpL(M1: string): Boolean;
  begin
    Result := Cmp(M1 + '>');
  end;

  function CmpL1(M1: string): Boolean;
  begin
    Result := Cmp1(M1 + '>');
  end;

  procedure Draw(const M: string);
  begin
    if not Assigned(Canvas) then
      Exit;
    if not CalcWidth then
      Canvas.TextOut(Rect.Left, Rect.Top, M);
    Rect.Left := Rect.Left + Canvas.TextWidth(M);
  end;

  procedure Style(const Style: TFontStyle; const Include: Boolean);
  begin
    if not Assigned(Canvas) then
      Exit;
    if Include then
      Canvas.Font.Style := Canvas.Font.Style + [Style]
    else
      Canvas.Font.Style := Canvas.Font.Style - [Style];
  end;

begin
  PlainItem := '';
  oldFontColor := 0; { satisfy compiler }
  if Canvas <> nil then
  begin
    oldFontStyles := Canvas.Font.Style;
    oldFontColor := Canvas.Font.Color;
  end;
  try
    if HideSelColor and Assigned(Canvas) then
    begin
      Canvas.Brush.Color := clWindow;
      Canvas.Font.Color := clWindowText;
    end;
    if Assigned(Canvas) then
      Canvas.FillRect(Rect);

    Width := Rect.Left;
    Rect.Left := Rect.Left + 2;

    OriRect := Rect; //save origin rectangle

    M1 := '';
    I := 1;
    while I <= Length(Text) do
    begin
      if (Text[I] = '<') and
        (CmpL('b') or CmpL('/b') or
        CmpL('i') or CmpL('/i') or
        CmpL('u') or CmpL('/u') or
        Cmp('c:')) then
      begin
        Draw(M1);
        PlainItem := PlainItem + M1;

        if CmpL1('b') then
          Style(fsBold, True)
        else
        if CmpL1('/b') then
          Style(fsBold, False)
        else
        if CmpL1('i') then
          Style(fsItalic, True)
        else
        if CmpL1('/i') then
          Style(fsItalic, False)
        else
        if CmpL1('u') then
          Style(fsUnderline, True)
        else
        if CmpL1('/u') then
          Style(fsUnderline, False)
        else
        if Cmp1('c:') then
        begin
          CL := SubStr(PChar(Text) + I, 0, '>');
          if (HideSelColor or not (odSelected in State)) and Assigned(Canvas) then
          try
            if (Length(CL) > 0) and (CL[1] <> '$') then
              Canvas.Font.Color := StringToColor('cl' + CL)
            else
              Canvas.Font.Color := StringToColor(CL);
          except
          end;
          Inc(I, Length(CL) + 1 {'>'});
        end;

        M1 := '';
      end
      else
      // next lines were added
      if (Text[I] = Chr(13)) and Cmp1(string(Chr(10))) then
      begin
                        // new line
        Draw(M1);
        PlainItem := PlainItem + M1;
        Rect.Left := OriRect.Left;
        Rect.Top := Rect.Top + Canvas.TextHeight(M1);
        M1 := '';
      end
      else
                        // add text
        M1 := M1 + Text[I];
      Inc(I);
    end; { for }
    Draw(M1);
    PlainItem := PlainItem + M1;
  finally
    if Canvas <> nil then
    begin
      Canvas.Font.Style := oldFontStyles;
      Canvas.Font.Color := oldFontColor;
    end;
  end;
  Width := Rect.Left - Width + 2;
end;

function ItemHtDraw(Canvas: TCanvas; Rect: TRect;
  const State: TOwnerDrawState; const Text: string;
  const HideSelColor: Boolean): string;
var
  S: string;
  W: Integer;
begin
  ItemHtDrawEx(Canvas, Rect, State, Text, HideSelColor, S, W, False);
end;

function ItemHtPlain(const Text: string): string;
var
  S: string;
  W: Integer;
begin
  ItemHtDrawEx(nil, Rect(0, 0, -1, -1), [], Text, False, S, W, False);
  Result := S;
end;

function ItemHtWidth(Canvas: TCanvas; Rect: TRect;
  const State: TOwnerDrawState; const Text: string;
  const HideSelColor: Boolean): Integer;
var
  S: string;
  W: Integer;
begin
  ItemHtDrawEx(Canvas, Rect, State, Text, HideSelColor, S, W, True);
  Result := W;
end;

procedure ClearList(List: TList);
var
  I: Integer;
begin
  if not Assigned(List) then
    Exit;
  for I := 0 to List.Count - 1 do
    TObject(List[I]).Free;
  List.Clear;
end;

procedure MemStreamToClipBoard(MemStream: TMemoryStream; const Format: Word);
{$IFDEF COMPLIB_VCL}
var
  Data: THandle;
  DataPtr: Pointer;
begin
  Clipboard.Open;
  try
    Data := GlobalAlloc(GMEM_MOVEABLE, MemStream.Size);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(MemStream.Memory^, DataPtr^, MemStream.Size);
        Clipboard.Clear;
        SetClipboardData(Format, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  finally
    Clipboard.Close;
  end;
end;
{$ENDIF}
{$IFDEF COMPLIB_CLX}
var
  Position: Integer;
begin
  Position := MemStream.Position;
  try
    MemStream.Position := 0;
    Clipboard.SetFormat(SysUtils.Format('Stream#%d', [Format]), MemStream);
  finally
    MemStream.Position := Position;
  end;
end;
{$ENDIF}

procedure ClipBoardToMemStream(MemStream: TMemoryStream; const Format: Word);
{$IFDEF COMPLIB_VCL}
var
  Data: THandle;
  DataPtr: Pointer;
begin
  Clipboard.Open;
  try
    Data := GetClipboardData(Format);
    if Data = 0 then
      Exit;
    DataPtr := GlobalLock(Data);
    if DataPtr = nil then
      Exit;
    try
      MemStream.WriteBuffer(DataPtr^, GlobalSize(Data));
      MemStream.Position := 0;
    finally
      GlobalUnlock(Data);
    end;
  finally
    Clipboard.Close;
  end;
end;
{$ENDIF}
{$IFDEF COMPLIB_CLX}
begin
  if Clipboard.Provides(SysUtils.Format('Stream#%d', [Format])) then
  begin
    Clipboard.GetFormat(SysUtils.Format('Stream#%d', [Format]), MemStream);
    MemStream.Position := 0;
  end;
end;
{$ENDIF}

function GetPropType(Obj: TObject; const PropName: string): TTypeKind;
var
  PropInf: PPropInfo;
begin
  PropInf := GetPropInfo(Obj.ClassInfo, PropName);
  if PropInf = nil then
    Result := tkUnknown
  else
    Result := PropInf^.PropType^.Kind;
end;

function GetPropStr(Obj: TObject; const PropName: string): string;
var
  PropInf: PPropInfo;
begin
  PropInf := GetPropInfo(Obj.ClassInfo, PropName);
  if PropInf = nil then
    raise Exception.CreateFmt(SPropertyNotExists, [PropName]);
  if not (PropInf^.PropType^.Kind in
    [tkString, tkLString, tkWString]) then
    raise Exception.CreateFmt(SInvalidPropertyType, [PropName]);
  Result := GetStrProp(Obj, PropInf);
end;

function GetPropOrd(Obj: TObject; const PropName: string): Integer;
var
  PropInf: PPropInfo;
begin
  PropInf := GetPropInfo(Obj.ClassInfo, PropName);
  if PropInf = nil then
    raise Exception.CreateFmt(SPropertyNotExists, [PropName]);
  if not (PropInf^.PropType^.Kind in
    [tkInteger, tkChar, tkWChar, tkEnumeration, tkClass]) then
    raise Exception.CreateFmt(SInvalidPropertyType, [PropName]);
  Result := GetOrdProp(Obj, PropInf);
end;

function GetPropMethod(Obj: TObject; const PropName: string): TMethod;
var
  PropInf: PPropInfo;
begin
  PropInf := GetPropInfo(Obj.ClassInfo, PropName);
  if PropInf = nil then
    raise Exception.CreateFmt(SPropertyNotExists, [PropName]);
  if not (PropInf^.PropType^.Kind = tkMethod) then
    raise Exception.CreateFmt(SInvalidPropertyType, [PropName]);
  Result := GetMethodProp(Obj, PropInf);
end;

procedure PrepareIniSection(SS: TStrings);
var
  I: Integer;
  S: string;
begin
  I := 0;
  while I < Ss.Count do
  begin
    S := Trim(Ss[I]);
    if (Length(S) = 0) or (S[1] in [';', '#']) then
      Ss.Delete(I)
    else
      Inc(I);
  end;
end;

{:Creates a TPointL structure from a pair of coordinates.
Call PointL to create a TPointL structure that represents the specified
coordinates. Use PointL to construct parameters for functions
that require a TPointL, rather than setting up local variables
for each parameter.
@param  X    The X coordinate.
@param  Y    The Y coordinate.
@return      A TPointL structure for coordinates X and Y.
@example        <Code>
var
  p: TPointL;
begin
  p := PointL(100, 100);
end;
</Code>
}

function PointL(const X, Y: Longint): TPointL;
begin
  Result.X := X;
  Result.Y := Y;
end;

{:Conditional assignment.
Returns the value in True or False depending on the condition Test.
@param  Test    The test condition.
@param  True    Returns this value if Test is True.
@param  False   Returns this value if Test is False.
@return         Value in True or False depending on Test.
@example        <Code>
bar := iif(foo, 1, 0);
</Code>
<br>has the same effects as:<br>
<Code>
if foo then
  bar := 1
else
  bar := 0;
</Code>
}

function iif(const Test: Boolean; const ATrue, AFalse: Variant): Variant;
begin
  if Test then
    Result := ATrue
  else
    Result := AFalse;
end;

{$IFDEF COMPLIB_VCL}
{ begin JvIconClipboardUtils}
{ Icon clipboard routines }

{$IFDEF COMPILER6_UP}
var
{$ELSE}
const
{$ENDIF COMPILER6_UP}
  Private_CF_ICON: Word = 0;

function CF_ICON: Word;
begin
  if Private_CF_ICON = 0 then
  begin
    { The following string should not be localized }
    Private_CF_ICON := RegisterClipboardFormat('Delphi Icon');
    TPicture.RegisterClipboardFormat(Private_CF_ICON, TIcon);
  end;
  Result := Private_CF_ICON;
end;

function CreateBitmapFromIcon(Icon: TIcon; BackColor: TColor): TBitmap;
var
  Ico: HIcon;
  W, H: Integer;
begin
  Ico := CreateRealSizeIcon(Icon);
  try
    GetIconSize(Ico, W, H);
    Result := TBitmap.Create;
    try
      Result.Width := W; Result.Height := H;
      with Result.Canvas do
      begin
        Brush.Color := BackColor;
        FillRect(Rect(0, 0, W, H));
        DrawIconEx(Handle, 0, 0, Ico, W, H, 0, 0, DI_NORMAL);
      end;
    except
      Result.Free;
      raise;
    end;
  finally
    DestroyIcon(Ico);
  end;
end;

procedure CopyIconToClipboard(Icon: TIcon; BackColor: TColor);
var
  Bmp: TBitmap;
  Stream: TStream;
  Data: THandle;
  Format: Word;
  Palette: HPalette;
  Buffer: Pointer;
begin
  Bmp := CreateBitmapFromIcon(Icon, BackColor);
  try
    Stream := TMemoryStream.Create;
    try
      Icon.SaveToStream(Stream);
      Palette := 0;
      with Clipboard do
      begin
        Open;
        try
          Clear;
          Bmp.SaveToClipboardFormat(Format, Data, Palette);
          SetClipboardData(Format, Data);
          if Palette <> 0 then
            SetClipboardData(CF_PALETTE, Palette);
          {$WARNINGS OFF}
          Data := GlobalAlloc(HeapAllocFlags, Stream.Size);
          {$WARNINGS ON}
          try
            if Data <> 0 then
            begin
              Buffer := GlobalLock(Data);
              try
                Stream.Seek(0, 0);
                Stream.Read(Buffer^, Stream.Size);
                SetClipboardData(CF_ICON, Data);
              finally
                GlobalUnlock(Data);
              end;
            end;
          except
            GlobalFree(Data);
            raise;
          end;
        finally
          Close;
        end;
      end;
    finally
      Stream.Free;
    end;
  finally
    Bmp.Free;
  end;
end;

procedure AssignClipboardIcon(Icon: TIcon);
var
  Stream: TStream;
  Data: THandle;
  Buffer: Pointer;
begin
  if not Clipboard.HasFormat(CF_ICON) then
    Exit;
  with Clipboard do
  begin
    Open;
    try
      Data := GetClipboardData(CF_ICON);
      Buffer := GlobalLock(Data);
      try
        Stream := TMemoryStream.Create;
        try
          Stream.Write(Buffer^, GlobalSize(Data));
          Stream.Seek(0, 0);
          Icon.LoadFromStream(Stream);
        finally
          Stream.Free;
        end;
      finally
        GlobalUnlock(Data);
      end;
    finally
      Close;
    end;
  end;
end;

function CreateIconFromClipboard: TIcon;
begin
  Result := nil;
  if not Clipboard.HasFormat(CF_ICON) then
    Exit;
  Result := TIcon.Create;
  try
    AssignClipboardIcon(Result);
  except
    Result.Free;
    raise;
  end;
end;

{ Real-size icons support routines }

const
  rc3_StockIcon = 0;
  rc3_Icon = 1;
  rc3_Cursor = 2;

type
  PCursorOrIcon = ^TCursorOrIcon;
  TCursorOrIcon = packed record
    Reserved: Word;
    wType: Word;
    Count: Word;
  end;

  PIconRec = ^TIconRec;
  TIconRec = packed record
    Width: Byte;
    Height: Byte;
    Colors: Word;
    Reserved1: Word;
    Reserved2: Word;
    DIBSize: Longint;
    DIBOffset: Longint;
  end;

function WidthBytes(I: Longint): Longint;
begin
  Result := ((I + 31) div 32) * 4;
end;

function GetDInColors(BitCount: Word): Integer;
begin
  case BitCount of
    1, 4, 8:
      Result := 1 shl BitCount;
    else
      Result := 0;
  end;
end;

procedure OutOfResources;
begin
  raise EOutOfResources.Create(SOutOfResources);
end;

function DupBits(Src: HBITMAP; Size: TPoint; Mono: Boolean): HBITMAP;
var
  DC, Mem1, Mem2: HDC;
  Old1, Old2: HBITMAP;
  Bitmap: Windows.TBitmap;
begin
  Mem1 := CreateCompatibleDC(0);
  Mem2 := CreateCompatibleDC(0);
  GetObject(Src, SizeOf(Bitmap), @Bitmap);
  if Mono then
    Result := CreateBitmap(Size.X, Size.Y, 1, 1, nil)
  else
  begin
    DC := GetDC(0);
    if DC = 0 then
      OutOfResources;
    try
      Result := CreateCompatibleBitmap(DC, Size.X, Size.Y);
      if Result = 0 then
        OutOfResources;
    finally
      ReleaseDC(0, DC);
    end;
  end;
  if Result <> 0 then
  begin
    Old1 := SelectObject(Mem1, Src);
    Old2 := SelectObject(Mem2, Result);
    StretchBlt(Mem2, 0, 0, Size.X, Size.Y, Mem1, 0, 0, Bitmap.bmWidth,
      Bitmap.bmHeight, SrcCopy);
    if Old1 <> 0 then
      SelectObject(Mem1, Old1);
    if Old2 <> 0 then
      SelectObject(Mem2, Old2);
  end;
  DeleteDC(Mem1);
  DeleteDC(Mem2);
end;

procedure TwoBitsFromDIB(var BI: TBitmapInfoHeader; var XorBits, AndBits: HBITMAP);
type
  PLongArray = ^TLongArray;
  TLongArray = array [0..1] of Longint;
var
  Temp: HBITMAP;
  NumColors: Integer;
  DC: HDC;
  Bits: Pointer;
  Colors: PLongArray;
  IconSize: TPoint;
  BM: Windows.TBitmap;
begin
  IconSize.X := GetSystemMetrics(SM_CXICON);
  IconSize.Y := GetSystemMetrics(SM_CYICON);
  with BI do
  begin
    biHeight := biHeight shr 1; { Size in record is doubled }
    biSizeImage := WidthBytes(Longint(biWidth) * biBitCount) * biHeight;
    NumColors := GetDInColors(biBitCount);
  end;
  DC := GetDC(0);
  if DC = 0 then
    OutOfResources;
  try
    Bits := Pointer(Longint(@BI) + SizeOf(BI) + NumColors * SizeOf(TRGBQuad));
    Temp := CreateDIBitmap(DC, BI, CBM_INIT, Bits, PBitmapInfo(@BI)^, DIB_RGB_COLORS);
    if Temp = 0 then
      OutOfResources;
    try
      GetObject(Temp, SizeOf(BM), @BM);
      IconSize.X := BM.bmWidth;
      IconSize.Y := BM.bmHeight;
      XorBits := DupBits(Temp, IconSize, False);
    finally
      DeleteObject(Temp);
    end;
    with BI do
    begin
      Inc(Longint(Bits), biSizeImage);
      biBitCount := 1;
      biSizeImage := WidthBytes(Longint(biWidth) * biBitCount) * biHeight;
      biClrUsed := 2;
      biClrImportant := 2;
    end;
    Colors := Pointer(Longint(@BI) + SizeOf(BI));
    Colors^[0] := 0;
    Colors^[1] := $FFFFFF;
    Temp := CreateDIBitmap(DC, BI, CBM_INIT, Bits, PBitmapInfo(@BI)^, DIB_RGB_COLORS);
    if Temp = 0 then
      OutOfResources;
    try
      AndBits := DupBits(Temp, IconSize, True);
    finally
      DeleteObject(Temp);
    end;
  finally
    ReleaseDC(0, DC);
  end;
end;

procedure ReadIcon(Stream: TStream; var Icon: HICON; ImageCount: Integer;
  StartOffset: Integer);
type
  PIconRecArray = ^TIconRecArray;
  TIconRecArray = array [0..300] of TIconRec;
var
  List: PIconRecArray;
  HeaderLen, Length: Integer;
  Colors, BitsPerPixel: Word;
  C1, C2, N, Index: Integer;
  IconSize: TPoint;
  DC: HDC;
  BI: PBitmapInfoHeader;
  ResData: Pointer;
  XorBits, AndBits: HBITMAP;
  XorInfo, AndInfo: Windows.TBitmap;
  XorMem, AndMem: Pointer;
  XorLen, AndLen: Integer;
begin
  HeaderLen := SizeOf(TIconRec) * ImageCount;
  List := AllocMem(HeaderLen);
  try
    Stream.Read(List^, HeaderLen);
    IconSize.X := GetSystemMetrics(SM_CXICON);
    IconSize.Y := GetSystemMetrics(SM_CYICON);
    DC := GetDC(0);
    if DC = 0 then
      OutOfResources;
    try
      BitsPerPixel := GetDeviceCaps(DC, PLANES) * GetDeviceCaps(DC, BITSPIXEL);
      if BitsPerPixel = 24 then
        Colors := 0
      else
        Colors := 1 shl BitsPerPixel;
    finally
      ReleaseDC(0, DC);
    end;
    Index := -1;
    { the following code determines which image most closely matches the
      current device. It is not meant to absolutely match Windows
      (known broken) algorithm }
    C2 := 0;
    for N := 0 to ImageCount - 1 do
    begin
      C1 := List^[N].Colors;
      if C1 = Colors then
      begin
        Index := N;
        Break;
      end
      else
      if Index = -1 then
      begin
        if C1 <= Colors then
        begin
          Index := N;
          C2 := List^[N].Colors;
        end;
      end
      else
      if C1 > C2 then
        Index := N;
    end;
    if Index = -1 then
      Index := 0;
    with List^[Index] do
    begin
      BI := AllocMem(DIBSize);
      try
        Stream.Seek(DIBOffset  - (HeaderLen + StartOffset), 1);
        Stream.Read(BI^, DIBSize);
        TwoBitsFromDIB(BI^, XorBits, AndBits);
        GetObject(AndBits, SizeOf(Windows.TBitmap), @AndInfo);
        GetObject(XorBits, SizeOf(Windows.TBitmap), @XorInfo);
        IconSize.X := AndInfo.bmWidth;
        IconSize.Y := AndInfo.bmHeight;
        with AndInfo do
          AndLen := bmWidthBytes * bmHeight * bmPlanes;
        with XorInfo do
          XorLen :=  bmWidthBytes * bmHeight * bmPlanes;
        Length := AndLen + XorLen;
        ResData := AllocMem(Length);
        try
          AndMem := ResData;
          with AndInfo do
            XorMem := Pointer(Longint(ResData) + AndLen);
          GetBitmapBits(AndBits, AndLen, AndMem);
          GetBitmapBits(XorBits, XorLen, XorMem);
          DeleteObject(XorBits);
          DeleteObject(AndBits);
          Icon := CreateIcon(HInstance, IconSize.X, IconSize.Y,
            XorInfo.bmPlanes, XorInfo.bmBitsPixel, AndMem, XorMem);
          if Icon = 0 then
            OutOfResources;
        finally
          FreeMem(ResData, Length);
        end;
      finally
        FreeMem(BI, DIBSize);
      end;
    end;
  finally
    FreeMem(List, HeaderLen);
  end;
end;

procedure GetIconSize(Icon: HIcon; var W, H: Integer);
var
  IconInfo: TIconInfo;
  BM: Windows.TBitmap;
begin
  if GetIconInfo(Icon, IconInfo) then
  begin
    try
      if IconInfo.hbmColor <> 0 then
      begin
        GetObject(IconInfo.hbmColor, SizeOf(BM), @BM);
        W := BM.bmWidth;
        H := BM.bmHeight;
      end
      else
      if IconInfo.hbmMask <> 0 then
      begin { Monochrome icon }
        GetObject(IconInfo.hbmMask, SizeOf(BM), @BM);
        W := BM.bmWidth;
        H := BM.bmHeight shr 1; { Size in record is doubled }
      end
      else
      begin
        W := GetSystemMetrics(SM_CXICON);
        H := GetSystemMetrics(SM_CYICON);
      end;
    finally
      if IconInfo.hbmColor <> 0 then
        DeleteObject(IconInfo.hbmColor);
      if IconInfo.hbmMask <> 0 then
        DeleteObject(IconInfo.hbmMask);
    end;
  end
  else
  begin
    W := GetSystemMetrics(SM_CXICON);
    H := GetSystemMetrics(SM_CYICON);
  end;
end;

function CreateRealSizeIcon(Icon: TIcon): HIcon;
var
  Mem: TMemoryStream;
  CI: TCursorOrIcon;
begin
  Result := 0;
  Mem := TMemoryStream.Create;
  try
    Icon.SaveToStream(Mem);
    Mem.Position := 0;
    Mem.ReadBuffer(CI, SizeOf(CI));
    case CI.wType of
      RC3_STOCKICON: Result := LoadIcon(0, IDI_APPLICATION);
      RC3_ICON: ReadIcon(Mem, Result, CI.Count, SizeOf(CI));
      else Result := CopyIcon(Icon.Handle);
    end;
  finally
    Mem.Free;
  end;
end;
procedure DrawRealSizeIcon(Canvas: TCanvas; Icon: TIcon; X, Y: Integer);
var
  Ico: HIcon;
  W, H: Integer;
begin
  Ico := CreateRealSizeIcon(Icon);
  try
    GetIconSize(Ico, W, H);
    DrawIconEx(Canvas.Handle, X, Y, Ico, W, H, 0, 0, DI_NORMAL);
  finally
    DestroyIcon(Ico);
  end;
end;
{ end JvIconClipboardUtils }
{$ENDIF COMPLIB_VCL}


{ begin JvRLE }
procedure RleCompress(Stream: TStream);
var
  Count, Count2, Count3, I: Integer;
  Buf1: array [0..1024] of Byte;
  Buf2: array [0..60000] of Byte;
  B: Byte;
  Tmp: TMemoryStream;
begin
  Tmp := TMemoryStream.Create;
  Stream.Position := 0;

  Count := 1024;
  while Count = 1024 do
  begin
    Count := Stream.Read(Buf1, 1024);
    Count2 := 0;
    I := 0;
    while I < Count do
    begin
      B := Buf1[I];
      Count3 := 0;
      while (Buf1[I] = B) and (I < Count) and (Count3 < $30) do
      begin
        Inc(I);
        Inc(Count3);
      end;
      if (I = Count) and (Count3 in [2..$2F]) and (Count = 1024) then
        Stream.Position := Stream.Position - Count3
      else
      begin
        if Count3 = 1 then
        begin
          if (B and $C0) = $C0 then
          begin
            Buf2[Count2] := $C1;
            Buf2[Count2 + 1] := B;
            Inc(Count2, 2);
          end
          else
          begin
            Buf2[Count2] := B;
            Inc(Count2);
          end;
        end
        else
        begin
          Buf2[Count2] := Count3 or $C0;
          Buf2[Count2 + 1] := B;
          Inc(Count2, 2);
        end;
      end;
    end;
    Tmp.Write(Buf2, Count2);
  end;

  Tmp.Position := 0;
  Stream.Size := 0;
  Stream.CopyFrom(Tmp, Tmp.Size);
  Tmp.Free;
end;

procedure RleDecompress(Stream: TStream);
var
  Count, Count2, Count3, I: Integer;
  Buf1: array [0..1024] of Byte;
  Buf2: array [0..60000] of Byte;
  B: Byte;
  Tmp: TMemoryStream;
begin
  Tmp := TMemoryStream.Create;
  Stream.Position := 0;

  Count := 1024;
  while Count = 1024 do
  begin
    Count := Stream.Read(Buf1, 1024);
    Count2 := 0;
    I := 0;
    while I < Count do
    begin
      if (Buf1[I] and $C0) = $C0 then
      begin
        if I = Count - 1 then
          Stream.Position := Stream.Position - 1
        else
        begin
          B := Buf1[I] and $3F;
          Inc(I);
          for Count3 := Count2 to Count2 + B - 1 do
            Buf2[Count3] := Buf1[I];
          Count2 := Count2 + B;
        end;
      end
      else
      begin
        Buf2[Count2] := Buf1[I];
        Inc(Count2);
      end;
      Inc(I);
    end;
    Tmp.Write(Buf2, Count2);
  end;

  Tmp.Position := 0;
  Stream.Size := 0;
  Stream.CopyFrom(Tmp, Tmp.Size);
  Tmp.Free;
end;
{ end JvRLE }

{ begin JvDateUtil }
function IsLeapYear(AYear: Integer): Boolean;
begin
  Result := (AYear mod 4 = 0) and ((AYear mod 100 <> 0) or (AYear mod 400 = 0));
end;

function DaysPerMonth(AYear, AMonth: Integer): Integer;
const
  DaysInMonth: array[1..12] of Integer =
  (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  Result := DaysInMonth[AMonth];
  if (AMonth = 2) and IsLeapYear(AYear) then
    Inc(Result); { leap-year Feb is special }
end;

function FirstDayOfNextMonth: TDateTime;
var
  Year, Month, Day: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  Day := 1;
  if Month < 12 then
    Inc(Month)
  else
  begin
    Inc(Year);
    Month := 1;
  end;
  Result := EncodeDate(Year, Month, Day);
end;

function FirstDayOfPrevMonth: TDateTime;
var
  Year, Month, Day: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  Day := 1;
  if Month > 1 then
    Dec(Month)
  else
  begin
    Dec(Year);
    Month := 12;
  end;
  Result := EncodeDate(Year, Month, Day);
end;

function LastDayOfPrevMonth: TDateTime;
var
  D: TDateTime;
  Year, Month, Day: Word;
begin
  D := FirstDayOfPrevMonth;
  DecodeDate(D, Year, Month, Day);
  Day := DaysPerMonth(Year, Month);
  Result := EncodeDate(Year, Month, Day);
end;

function ExtractDay(ADate: TDateTime): Word;
var
  M, Y: Word;
begin
  DecodeDate(ADate, Y, M, Result);
end;

function ExtractMonth(ADate: TDateTime): Word;
var
  D, Y: Word;
begin
  DecodeDate(ADate, Y, Result, D);
end;

function ExtractYear(ADate: TDateTime): Word;
var
  D, M: Word;
begin
  DecodeDate(ADate, Result, M, D);
end;

function IncDate(ADate: TDateTime; Days, Months, Years: Integer): TDateTime;
var
  D, M, Y: Word;
  Day, Month, Year: Longint;
begin
  DecodeDate(ADate, Y, M, D);
  Year := Y;
  Month := M;
  Day := D;
  Inc(Year, Years);
  Inc(Year, Months div 12);
  Inc(Month, Months mod 12);
  if Month < 1 then
  begin
    Inc(Month, 12);
    Dec(Year);
  end
  else if Month > 12 then
  begin
    Dec(Month, 12);
    Inc(Year);
  end;
  if Day > DaysPerMonth(Year, Month) then
    Day := DaysPerMonth(Year, Month);
  Result := EncodeDate(Year, Month, Day) + Days + Frac(ADate);
end;

procedure DateDiff(Date1, Date2: TDateTime; var Days, Months, Years: Word);
{ Corrected by Anatoly A. Sanko (2:450/73) }
var
  DtSwap: TDateTime;
  Day1, Day2, Month1, Month2, Year1, Year2: Word;
begin
  if Date1 > Date2 then
  begin
    DtSwap := Date1;
    Date1 := Date2;
    Date2 := DtSwap;
  end;
  DecodeDate(Date1, Year1, Month1, Day1);
  DecodeDate(Date2, Year2, Month2, Day2);
  Years := Year2 - Year1;
  Months := 0;
  Days := 0;
  if Month2 < Month1 then
  begin
    Inc(Months, 12);
    Dec(Years);
  end;
  Inc(Months, Month2 - Month1);
  if Day2 < Day1 then
  begin
    Inc(Days, DaysPerMonth(Year1, Month1));
    if Months = 0 then
    begin
      Dec(Years);
      Months := 11;
    end
    else
      Dec(Months);
  end;
  Inc(Days, Day2 - Day1);
end;

function IncDay(ADate: TDateTime; Delta: Integer): TDateTime;
begin
  Result := ADate + Delta;
end;

function IncMonth(ADate: TDateTime; Delta: Integer): TDateTime;
begin
  Result := IncDate(ADate, 0, Delta, 0);
end;

function IncYear(ADate: TDateTime; Delta: Integer): TDateTime;
begin
  Result := IncDate(ADate, 0, 0, Delta);
end;

function MonthsBetween(Date1, Date2: TDateTime): Double;
var
  D, M, Y: Word;
begin
  DateDiff(Date1, Date2, D, M, Y);
  Result := 12 * Y + M;
  if (D > 1) and (D < 7) then
    Result := Result + 0.25
  else if (D >= 7) and (D < 15) then
    Result := Result + 0.5
  else if (D >= 15) and (D < 21) then
    Result := Result + 0.75
  else if D >= 21 then
    Result := Result + 1;
end;

function IsValidDate(Y, M, D: Word): Boolean;
begin
  Result := (Y >= 1) and (Y <= 9999) and (M >= 1) and (M <= 12) and
    (D >= 1) and (D <= DaysPerMonth(Y, M));
end;

function ValidDate(ADate: TDateTime): Boolean;
var
  Year, Month, Day: Word;
begin
  try
    DecodeDate(ADate, Year, Month, Day);
    Result := IsValidDate(Year, Month, Day);
  except
    Result := False;
  end;
end;

function DaysInPeriod(Date1, Date2: TDateTime): Longint;
begin
  if ValidDate(Date1) and ValidDate(Date2) then
    Result := Abs(Trunc(Date2) - Trunc(Date1)) + 1
  else
    Result := 0;
end;

{ // wrong implementation (ahuser)
function DaysBetween(Date1, Date2: TDateTime): Longint;
begin
  Result := Trunc(Date2) - Trunc(Date1) + 1;
  if Result < 0 then
    Result := 0;
end;}

function DaysBetween(Date1, Date2: TDateTime): Longint;
begin
  if Date1 < Date2 then
    Result := Trunc(Date2 - Date1)
  else
    Result := Trunc(Date1 - Date2);
end;

function IncTime(ATime: TDateTime; Hours, Minutes, Seconds,
  MSecs: Integer): TDateTime;
begin
  Result := ATime + (Hours div 24) + (((Hours mod 24) * 3600000 +
    Minutes * 60000 + Seconds * 1000 + MSecs) / MSecsPerDay);
  if Result < 0 then
    Result := Result + 1;
end;

function IncHour(ATime: TDateTime; Delta: Integer): TDateTime;
begin
  Result := IncTime(ATime, Delta, 0, 0, 0);
end;

function IncMinute(ATime: TDateTime; Delta: Integer): TDateTime;
begin
  Result := IncTime(ATime, 0, Delta, 0, 0);
end;

function IncSecond(ATime: TDateTime; Delta: Integer): TDateTime;
begin
  Result := IncTime(ATime, 0, 0, Delta, 0);
end;

function IncMSec(ATime: TDateTime; Delta: Integer): TDateTime;
begin
  Result := IncTime(ATime, 0, 0, 0, Delta);
end;

function CutTime(ADate: TDateTime): TDateTime;
begin
  Result := Trunc(ADate);
end;

function CurrentYear: Word;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.wYear;
end;

{ String to date conversions. Copied from SYSUTILS.PAS unit. }

procedure ScanBlanks(const S: string; var Pos: Integer);
var
  I: Integer;
begin
  I := Pos;
  while (I <= Length(S)) and (S[I] = ' ') do
    Inc(I);
  Pos := I;
end;

function ScanNumber(const S: string; MaxLength: Integer; var Pos: Integer;
  var Number: Longint): Boolean;
var
  I: Integer;
  N: Word;
begin
  Result := False;
  ScanBlanks(S, Pos);
  I := Pos;
  N := 0;
  while (I <= Length(S)) and (Longint(I - Pos) < MaxLength) and
    (S[I] in ['0'..'9']) and (N < 1000) do
  begin
    N := N * 10 + (Ord(S[I]) - Ord('0'));
    Inc(I);
  end;
  if I > Pos then
  begin
    Pos := I;
    Number := N;
    Result := True;
  end;
end;

function ScanChar(const S: string; var Pos: Integer; Ch: Char): Boolean;
begin
  Result := False;
  ScanBlanks(S, Pos);
  if (Pos <= Length(S)) and (S[Pos] = Ch) then
  begin
    Inc(Pos);
    Result := True;
  end;
end;

procedure ScanToNumber(const S: string; var Pos: Integer);
begin
  while (Pos <= Length(S)) and not (S[Pos] in ['0'..'9']) do
  begin
    if S[Pos] in LeadBytes then
      Inc(Pos);
    Inc(Pos);
  end;
end;

function GetDateOrder(const DateFormat: string): TDateOrder;
var
  I: Integer;
begin
  Result := DefaultDateOrder;
  I := 1;
  while I <= Length(DateFormat) do
  begin
    case Chr(Ord(DateFormat[I]) and $DF) of
      'E':
        Result := doYMD;
      'Y':
        Result := doYMD;
      'M':
        Result := doMDY;
      'D':
        Result := doDMY;
    else
      Inc(I);
      Continue;
    end;
    Exit;
  end;
  Result := DefaultDateOrder; { default }
end;

function CurrentMonth: Word;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.wMonth;
end;

{Modified}

function ExpandYear(Year: Integer): Integer;
var
  N: Longint;
begin
  if Year = -1 then
    Result := CurrentYear
  else
  begin
    Result := Year;
    if Result < 100 then
    begin
      N := CurrentYear - CenturyOffset;
      Inc(Result, N div 100 * 100);
      if (CenturyOffset > 0) and (Result < N) then
        Inc(Result, 100);
    end;
  end;
end;

function ScanDate(const S, DateFormat: string; var Pos: Integer;
  var Y, M, D: Integer): Boolean;
var
  DateOrder: TDateOrder;
  N1, N2, N3: Longint;
begin
  Result := False;
  Y := 0;
  M := 0;
  D := 0;
  DateOrder := GetDateOrder(DateFormat);
  if ShortDateFormat[1] = 'g' then { skip over prefix text }
    ScanToNumber(S, Pos);
  if not (ScanNumber(S, MaxInt, Pos, N1) and ScanChar(S, Pos, DateSeparator) and
    ScanNumber(S, MaxInt, Pos, N2)) then
    Exit;
  if ScanChar(S, Pos, DateSeparator) then
  begin
    if not ScanNumber(S, MaxInt, Pos, N3) then
      Exit;
    case DateOrder of
      doMDY:
        begin
          Y := N3;
          M := N1;
          D := N2;
        end;
      doDMY:
        begin
          Y := N3;
          M := N2;
          D := N1;
        end;
      doYMD:
        begin
          Y := N1;
          M := N2;
          D := N3;
        end;
    end;
    Y := ExpandYear(Y);
  end
  else
  begin
    Y := CurrentYear;
    if DateOrder = doDMY then
    begin
      D := N1;
      M := N2;
    end
    else
    begin
      M := N1;
      D := N2;
    end;
  end;
  ScanChar(S, Pos, DateSeparator);
  ScanBlanks(S, Pos);
  if SysLocale.FarEast and (System.Pos('ddd', ShortDateFormat) <> 0) then
  begin { ignore trailing text }
    if ShortTimeFormat[1] in ['0'..'9'] then { stop at time digit }
      ScanToNumber(S, Pos)
    else { stop at time prefix }
      repeat
        while (Pos <= Length(S)) and (S[Pos] <> ' ') do
          Inc(Pos);
        ScanBlanks(S, Pos);
      until (Pos > Length(S)) or
        (AnsiCompareText(TimeAMString, Copy(S, Pos, Length(TimeAMString))) = 0) or
        (AnsiCompareText(TimePMString, Copy(S, Pos, Length(TimePMString))) = 0);
  end;
  Result := IsValidDate(Y, M, D) and (Pos > Length(S));
end;

function MonthFromName(const S: string; MaxLen: Byte): Byte;
begin
  if Length(S) > 0 then
    for Result := 1 to 12 do
    begin
      if (Length(LongMonthNames[Result]) > 0) and
        (AnsiCompareText(Copy(S, 1, MaxLen),
        Copy(LongMonthNames[Result], 1, MaxLen)) = 0) then
        Exit;
    end;
  Result := 0;
end;

procedure ExtractMask(const Format, S: string; Ch: Char; Cnt: Integer;
  var I: Integer; Blank, Default: Integer);
var
  Tmp: string[20];
  J, L: Integer;
begin
  I := Default;
  Ch := UpCase(Ch);
  L := Length(Format);
  if Length(S) < L then
    L := Length(S)
  else if Length(S) > L then
    Exit;
  J := Pos(MakeStr(Ch, Cnt), AnsiUpperCase(Format));
  if J <= 0 then
    Exit;
  Tmp := '';
  while (UpCase(Format[J]) = Ch) and (J <= L) do
  begin
    if S[J] <> ' ' then
      Tmp := Tmp + S[J];
    Inc(J);
  end;
  if Tmp = '' then
    I := Blank
  else if Cnt > 1 then
  begin
    I := MonthFromName(Tmp, Length(Tmp));
    if I = 0 then
      I := -1;
  end
  else
    I := StrToIntDef(Tmp, -1);
end;

function ScanDateStr(const Format, S: string; var D, M, Y: Integer): Boolean;
var
  Pos: Integer;
begin
  ExtractMask(Format, S, 'm', 3, M, -1, 0); { short month name? }
  if M = 0 then ExtractMask(Format, S, 'm', 1, M, -1, 0);
  ExtractMask(Format, S, 'd', 1, D, -1, 1);
  ExtractMask(Format, S, 'y', 1, Y, -1, CurrentYear);
  if M = -1 then
    M := CurrentMonth;
  Y := ExpandYear(Y);
  Result := IsValidDate(Y, M, D);
  if not Result then
  begin
    Pos := 1;
    Result := ScanDate(S, Format, Pos, Y, M, D);
  end;
end;

function InternalStrToDate(const DateFormat, S: string;
  var Date: TDateTime): Boolean;
var
  D, M, Y: Integer;
begin
  if S = '' then
  begin
    Date := NullDate;
    Result := True;
  end
  else
  begin
    Result := ScanDateStr(DateFormat, S, D, M, Y);
    if Result then
    try
      Date := EncodeDate(Y, M, D);
    except
      Result := False;
    end;
  end;
end;

function StrToDateFmt(const DateFormat, S: string): TDateTime;
begin
  if not InternalStrToDate(DateFormat, S, Result) then
    raise EConvertError.CreateFmt(SInvalidDate, [S]);
end;

function StrToDateDef(const S: string; Default: TDateTime): TDateTime;
begin
  if not InternalStrToDate(ShortDateFormat, S, Result) then
    Result := Trunc(Default);
end;

function StrToDateFmtDef(const DateFormat, S: string; Default: TDateTime): TDateTime;
begin
  if not InternalStrToDate(DateFormat, S, Result) then
    Result := Trunc(Default);
end;

function DefDateFormat(FourDigitYear: Boolean): string;
begin
  if FourDigitYear then
  begin
    case GetDateOrder(ShortDateFormat) of
      doMDY:
        Result := 'MM/DD/YYYY';
      doDMY:
        Result := 'DD/MM/YYYY';
      doYMD:
        Result := 'YYYY/MM/DD';
    end;
  end
  else
  begin
    case GetDateOrder(ShortDateFormat) of
      doMDY:
        Result := 'MM/DD/YY';
      doDMY:
        Result := 'DD/MM/YY';
      doYMD:
        Result := 'YY/MM/DD';
    end;
  end;
end;

function DefDateMask(BlanksChar: Char; FourDigitYear: Boolean): string;
begin
  if FourDigitYear then
  begin
    case GetDateOrder(ShortDateFormat) of
      doMDY, doDMY:
        Result := '!99/99/9999;1;';
      doYMD:
        Result := '!9999/99/99;1;';
    end;
  end
  else
  begin
    case GetDateOrder(ShortDateFormat) of
      doMDY, doDMY:
        Result := '!99/99/99;1;';
      doYMD:
        Result := '!99/99/99;1;';
    end;
  end;
  if Result <> '' then
    Result := Result + BlanksChar;
end;

function FormatLongDate(Value: TDateTime): string;
var
  Buffer: array[0..1023] of Char;
  SystemTime: TSystemTime;
begin
  DateTimeToSystemTime(Value, SystemTime);
  SetString(Result, Buffer, GetDateFormat(GetThreadLocale, DATE_LONGDATE,
    @SystemTime, nil, Buffer, SizeOf(Buffer) - 1));
  Result := TrimRight(Result);
end;

function FormatLongDateTime(Value: TDateTime): string;
begin
  if Value <> NullDate then
    Result := FormatLongDate(Value) + FormatDateTime(' tt', Value)
  else
    Result := '';
end;

{$IFNDEF USE_FOUR_DIGIT_YEAR}

function FourDigitYear: Boolean;
begin
  Result := Pos('YYYY', AnsiUpperCase(ShortDateFormat)) > 0;
end;
{$ENDIF}
{ end JvDateUtil }

{ begin JvStrUtils }
{$IFDEF LINUX}
function iconversion(InP: PChar; OutP: Pointer; InBytes, OutBytes: Cardinal;
  const ToCode, FromCode: string): Boolean;
var
  conv: iconv_t;
begin
  Result := False;
  if (InBytes > 0) and (OutBytes > 0) and (InP <> nil) and (OutP <> nil) then
  begin
    conv := iconv_open(PChar(ToCode), PChar(FromCode));
    if Integer(conv) <> -1 then
    begin
      if Integer(iconv(conv, InP, InBytes, OutP, OutBytes)) <> -1 then
        Result := True;
      iconv_close(conv);
    end;
  end;
end;

function iconvString(const S, ToCode, FromCode: string): string;
begin
  SetLength(Result, Length(S));
  if not iconversion(PChar(S), Pointer(Result),
                     Length(S), Length(Result),
                     ToCode, FromCode) then
    Result := S;
end;

function iconvWideString(const S: WideString; const ToCode, FromCode: string): WideString;
begin
  SetLength(Result, Length(S));
  if not iconversion(PChar(S), Pointer(Result),
                     Length(S) * 2, Length(Result) * 2,
                     ToCode, FromCode) then
    Result := S;
end;

function OemStrToAnsi(const S: string): string;
begin
  Result := iconvString(S, 'WINDOWS-1252', 'CP850');
end;

function AnsiStrToOem(const S: string): string;
begin
  Result := iconvString(S, 'CP850', 'WINDOWS-1250');
end;
{$ENDIF}

function StrToOem(const AnsiStr: string): string;
begin
{$IFDEF MSWINDOWS}
  SetLength(Result, Length(AnsiStr));
  if Length(Result) > 0 then
    CharToOemBuff(PChar(AnsiStr), PChar(Result), Length(Result));
{$ENDIF}
{$IFDEF LINUX}
  Result := AnsiStrToOem(AnsiStr);
{$ENDIF}
end;

function OemToAnsiStr(const OemStr: string): string;
begin
{$IFDEF MSWINDOWS}
  SetLength(Result, Length(OemStr));
  if Length(Result) > 0 then
    OemToCharBuff(PChar(OemStr), PChar(Result), Length(Result));
{$ENDIF}
{$IFDEF LINUX}
  Result := OemStrToAnsi(OemStr);
{$ENDIF}
end;

function IsEmptyStr(const S: string; const EmptyChars: TCharSet): Boolean;
var
  I, SLen: Integer;
begin
  SLen := Length(S);
  I := 1;
  while I <= SLen do
  begin
    if not (S[I] in EmptyChars) then
    begin
      Result := False;
      Exit;
    end
    else
      Inc(I);
  end;
  Result := True;
end;

function ReplaceStr(const S, Srch, Replace: string): string;
var
  I: Integer;
  Source: string;
begin
  Source := S;
  Result := '';
  repeat
    I := Pos(Srch, Source);
    if I > 0 then
    begin
      Result := Result + Copy(Source, 1, I - 1) + Replace;
      Source := Copy(Source, I + Length(Srch), MaxInt);
    end
    else
      Result := Result + Source;
  until I <= 0;
end;

function DelSpace(const S: string): string;
begin
  Result := DelChars(S, ' ');
end;

function DelChars(const S: string; Chr: Char): string;
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do
  begin
    if Result[I] = Chr then
      Delete(Result, I, 1);
  end;
end;

function DelBSpace(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] = ' ') do
    Inc(I);
  Result := Copy(S, I, MaxInt);
end;

function DelESpace(const S: string): string;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] = ' ') do
    Dec(I);
  Result := Copy(S, 1, I);
end;

function DelRSpace(const S: string): string;
begin
  Result := DelBSpace(DelESpace(S));
end;

function DelSpace1(const S: string): string;
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 2 do
  begin
    if (Result[I] = ' ') and (Result[I - 1] = ' ') then
      Delete(Result, I, 1);
  end;
end;

function Tab2Space(const S: string; Numb: Byte): string;
var
  I: Integer;
begin
  I := 1;
  Result := S;
  while I <= Length(Result) do
  begin
    if Result[I] = Chr(9) then
    begin
      Delete(Result, I, 1);
      Insert(MakeStr(' ', Numb), Result, I);
      Inc(I, Numb);
    end
    else
      Inc(I);
  end;
end;

function MakeStr(C: Char; N: Integer): string;
begin
  if N < 1 then
    Result := ''
  else
  begin
    SetLength(Result, N);
    FillChar(Result[1], Length(Result), C);
  end;
end;

function MakeStr(C: WideChar; N: Integer): WideString;
begin
  if N < 1 then
    Result := ''
  else
  begin
    SetLength(Result, N);
    FillWideChar(Result[1], Length(Result), C);
  end;
end;

function MS(C: Char; N: Integer): string;
begin
  Result := MakeStr(C, N);
end;

function NPos(const C: string; S: string; N: Integer): Integer;
var
  I, P, K: Integer;
begin
  Result := 0;
  K := 0;
  for I := 1 to N do
  begin
    P := Pos(C, S);
    Inc(K, P);
    if (I = N) and (P > 0) then
    begin
      Result := K;
      Exit;
    end;
    if P > 0 then
      Delete(S, 1, P)
    else
      Exit;
  end;
end;

function AddChar(C: Char; const S: string; N: Integer): string;
begin
  if Length(S) < N then
    Result := MakeStr(C, N - Length(S)) + S
  else
    Result := S;
end;

function AddCharR(C: Char; const S: string; N: Integer): string;
begin
  if Length(S) < N then
    Result := S + MakeStr(C, N - Length(S))
  else
    Result := S;
end;

function LeftStr(const S: string; N: Integer): string;
begin
  Result := AddCharR(' ', S, N);
end;

function RightStr(const S: string; N: Integer): string;
begin
  Result := AddChar(' ', S, N);
end;

function CompStr(const S1, S2: string): Integer;
begin
  Result := CompareString(GetThreadLocale, SORT_STRINGSORT, PChar(S1),
    Length(S1), PChar(S2), Length(S2)) - 2;
end;

function CompText(const S1, S2: string): Integer;
begin
  Result := CompareString(GetThreadLocale, SORT_STRINGSORT or NORM_IGNORECASE,
    PChar(S1), Length(S1), PChar(S2), Length(S2)) - 2;
end;

function Copy2Symb(const S: string; Symb: Char): string;
var
  P: Integer;
begin
  P := Pos(Symb, S);
  if P = 0 then
    P := Length(S) + 1;
  Result := Copy(S, 1, P - 1);
end;

function Copy2SymbDel(var S: string; Symb: Char): string;
begin
  Result := Copy2Symb(S, Symb);
  S := DelBSpace(Copy(S, Length(Result) + 1, Length(S)));
end;

function Copy2Space(const S: string): string;
begin
  Result := Copy2Symb(S, ' ');
end;

function Copy2SpaceDel(var S: string): string;
begin
  Result := Copy2SymbDel(S, ' ');
end;

function AnsiProperCase(const S: string; const WordDelims: TCharSet): string;
var
  SLen, I: Cardinal;
begin
  Result := AnsiLowerCase(S);
  I := 1;
  SLen := Length(Result);
  while I <= SLen do
  begin
    while (I <= SLen) and (Result[I] in WordDelims) do
      Inc(I);
    if I <= SLen then
      Result[I] := AnsiUpperCase(Result[I])[1];
    while (I <= SLen) and not (Result[I] in WordDelims) do
      Inc(I);
  end;
end;

function WordCount(const S: string; const WordDelims: TCharSet): Integer;
var
  SLen, I: Cardinal;
begin
  Result := 0;
  I := 1;
  SLen := Length(S);
  while I <= SLen do
  begin
    while (I <= SLen) and (S[I] in WordDelims) do
      Inc(I);
    if I <= SLen then
      Inc(Result);
    while (I <= SLen) and not (S[I] in WordDelims) do
      Inc(I);
  end;
end;

function WordPosition(const N: Integer; const S: string;
  const WordDelims: TCharSet): Integer;
var
  Count, I: Integer;
begin
  Count := 0;
  I := 1;
  Result := 0;
  while (I <= Length(S)) and (Count <> N) do
  begin
    { skip over delimiters }
    while (I <= Length(S)) and (S[I] in WordDelims) do
      Inc(I);
    { if we're not beyond end of S, we're at the start of a word }
    if I <= Length(S) then
      Inc(Count);
    { if not finished, find the end of the current word }
    if Count <> N then
      while (I <= Length(S)) and not (S[I] in WordDelims) do
        Inc(I)
    else
      Result := I;
  end;
end;

function ExtractWord(N: Integer; const S: string;
  const WordDelims: TCharSet): string;
var
  I: Integer;
  Len: Integer;
begin
  Len := 0;
  I := WordPosition(N, S, WordDelims);
  if I <> 0 then
    { find the end of the current word }
    while (I <= Length(S)) and not (S[I] in WordDelims) do
    begin
      { add the I'th character to result }
      Inc(Len);
      SetLength(Result, Len);
      Result[Len] := S[I];
      Inc(I);
    end;
  SetLength(Result, Len);
end;

function ExtractWordPos(N: Integer; const S: string;
  const WordDelims: TCharSet; var Pos: Integer): string;
var
  I, Len: Integer;
begin
  Len := 0;
  I := WordPosition(N, S, WordDelims);
  Pos := I;
  if I <> 0 then
    { find the end of the current word }
    while (I <= Length(S)) and not (S[I] in WordDelims) do
    begin
      { add the I'th character to result }
      Inc(Len);
      SetLength(Result, Len);
      Result[Len] := S[I];
      Inc(I);
    end;
  SetLength(Result, Len);
end;

function ExtractDelimited(N: Integer; const S: string;
  const Delims: TCharSet): string;
var
  CurWord: Integer;
  I, Len, SLen: Integer;
begin
  CurWord := 0;
  I := 1;
  Len := 0;
  SLen := Length(S);
  SetLength(Result, 0);
  while (I <= SLen) and (CurWord <> N) do
  begin
    if S[I] in Delims then
      Inc(CurWord)
    else
    begin
      if CurWord = N - 1 then
      begin
        Inc(Len);
        SetLength(Result, Len);
        Result[Len] := S[I];
      end;
    end;
    Inc(I);
  end;
end;

function ExtractSubstr(const S: string; var Pos: Integer;
  const Delims: TCharSet): string;
var
  I: Integer;
begin
  I := Pos;
  while (I <= Length(S)) and not (S[I] in Delims) do
    Inc(I);
  Result := Copy(S, Pos, I - Pos);
  if (I <= Length(S)) and (S[I] in Delims) then
    Inc(I);
  Pos := I;
end;

function IsWordPresent(const W, S: string; const WordDelims: TCharSet): Boolean;
var
  Count, I: Integer;
begin
  Result := False;
  Count := WordCount(S, WordDelims);
  for I := 1 to Count do
    if ExtractWord(I, S, WordDelims) = W then
    begin
      Result := True;
      Exit;
    end;
end;

// (rom) something for JVCL.INC

{$DEFINE MBCS}

function QuotedString(const S: string; Quote: Char): string;
begin
  Result := AnsiQuotedStr(S, Quote);
end;

function ExtractQuotedString(const S: string; Quote: Char): string;
var
  P: PChar;
begin
  P := PChar(S);
  if P^ = Quote then
    Result := AnsiExtractQuotedStr(P, Quote)
  else
    Result := S;
end;

function Numb2USA(const S: string): string;
var
  I, NA: Integer;
begin
  I := Length(S);
  Result := S;
  NA := 0;
  while (I > 0) do
  begin
    if ((Length(Result) - I + 1 - NA) mod 3 = 0) and (I <> 1) then
    begin
      Insert(',', Result, I);
      Inc(NA);
    end;
    Dec(I);
  end;
end;

function CenterStr(const S: string; Len: Integer): string;
begin
  if Length(S) < Len then
  begin
    Result := MakeStr(' ', (Len div 2) - (Length(S) div 2)) + S;
    Result := Result + MakeStr(' ', Len - Length(Result));
  end
  else
    Result := S;
end;

function Dec2Hex(N: LongInt; A: Byte): string;
begin
  Result := IntToHex(N, A);
end;

function D2H(N: LongInt; A: Byte): string;
begin
  Result := IntToHex(N, A);
end;

function Hex2Dec(const S: string): Longint;
var
  HexStr: string;
begin
  if Pos('$', S) = 0 then
    HexStr := '$' + S
  else
    HexStr := S;
  Result := StrToIntDef(HexStr, 0);
end;

function H2D(const S: string): Longint;
begin
  Result := Hex2Dec(S);
end;

function Dec2Numb(N: Longint; A, B: Byte): string;
var
  C: Integer;
  Number: Cardinal;
begin
  if N = 0 then
    Result := '0'
  else
  begin
    Number := Cardinal(N);
    Result := '';
    while Number > 0 do
    begin
      C := Number mod B;
      if C > 9 then
        C := C + 55
      else
        C := C + 48;
      Result := Chr(C) + Result;
      Number := Number div B;
    end;
  end;
  if Result <> '' then
    Result := AddChar('0', Result, A);
end;

function Numb2Dec(S: string; B: Byte): Longint;
var
  I, P: Longint;
begin
  I := Length(S);
  Result := 0;
  S := UpperCase(S);
  P := 1;
  while (I >= 1) do
  begin
    if S[I] > '@' then
      Result := Result + (Ord(S[I]) - 55) * P
    else
      Result := Result + (Ord(S[I]) - 48) * P;
    Dec(I);
    P := P * B;
  end;
end;

function RomanToInt(const S: string): Longint;
const
  RomanChars = ['C', 'D', 'I', 'L', 'M', 'V', 'X'];
  RomanValues: array['C'..'X'] of Word =
  (100, 500, 0, 0, 0, 0, 1, 0, 0, 50, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 10);
var
  Index, Next: Char;
  I: Integer;
  Negative: Boolean;
begin
  Result := 0;
  I := 0;
  Negative := (Length(S) > 0) and (S[1] = '-');
  if Negative then
    Inc(I);
  while (I < Length(S)) do
  begin
    Inc(I);
    Index := UpCase(S[I]);
    if Index in RomanChars then
    begin
      if Succ(I) <= Length(S) then
        Next := UpCase(S[I + 1])
      else
        Next := #0;
      if (Next in RomanChars) and (RomanValues[Index] < RomanValues[Next]) then
      begin
        Inc(Result, RomanValues[Next]);
        Dec(Result, RomanValues[Index]);
        Inc(I);
      end
      else
        Inc(Result, RomanValues[Index]);
    end
    else
    begin
      Result := 0;
      Exit;
    end;
  end;
  if Negative then
    Result := -Result;
end;

function IntToRoman(Value: Longint): string;
label
  A500, A400, A100, A90, A50, A40, A10, A9, A5, A4, A1;
begin
  Result := '';
  while Value >= 1000 do
  begin
    Dec(Value, 1000);
    Result := Result + 'M';
  end;
  if Value < 900 then
    goto A500
  else
  begin
    Dec(Value, 900);
    Result := Result + 'CM';
  end;
  goto A90;
  A400:
  if Value < 400 then
    goto A100
  else
  begin
    Dec(Value, 400);
    Result := Result + 'CD';
  end;
  goto A90;
  A500:
  if Value < 500 then
    goto A400
  else
  begin
    Dec(Value, 500);
    Result := Result + 'D';
  end;
  A100:
  while Value >= 100 do
  begin
    Dec(Value, 100);
    Result := Result + 'C';
  end;
  A90:
  if Value < 90 then
    goto A50
  else
  begin
    Dec(Value, 90);
    Result := Result + 'XC';
  end;
  goto A9;
  A40:
  if Value < 40 then
    goto A10
  else
  begin
    Dec(Value, 40);
    Result := Result + 'XL';
  end;
  goto A9;
  A50:
  if Value < 50 then
    goto A40
  else
  begin
    Dec(Value, 50);
    Result := Result + 'L';
  end;
  A10:
  while Value >= 10 do
  begin
    Dec(Value, 10);
    Result := Result + 'X';
  end;
  A9:
  if Value < 9 then
    goto A5
  else
    Result := Result + 'IX';
  Exit;
  A4:
  if Value < 4 then
    goto A1
  else
    Result := Result + 'IV';
  Exit;
  A5:
  if Value < 5 then
    goto A4
  else
  begin
    Dec(Value, 5);
    Result := Result + 'V';
  end;
  goto A1;
  A1:
  while Value >= 1 do
  begin
    Dec(Value);
    Result := Result + 'I';
  end;
end;

function IntToBin(Value: Longint; Digits, Spaces: Integer): string;
begin
  Result := '';
  if Digits > 32 then
    Digits := 32;
  while Digits > 0 do
  begin
    if (Digits mod Spaces) = 0 then
      Result := Result + ' ';
    Dec(Digits);
    Result := Result + IntToStr((Value shr Digits) and 1);
  end;
end;

function FindPart(const HelpWilds, InputStr: string): Integer;
var
  I, J: Integer;
  Diff: Integer;
begin
  I := Pos('?', HelpWilds);
  if I = 0 then
  begin
    { if no '?' in HelpWilds }
    Result := Pos(HelpWilds, InputStr);
    Exit;
  end;
  { '?' in HelpWilds }
  Diff := Length(InputStr) - Length(HelpWilds);
  if Diff < 0 then
  begin
    Result := 0;
    Exit;
  end;
  { now move HelpWilds over InputStr }
  for I := 0 to Diff do
  begin
    for J := 1 to Length(HelpWilds) do
    begin
      if (InputStr[I + J] = HelpWilds[J]) or
        (HelpWilds[J] = '?') then
      begin
        if J = Length(HelpWilds) then
        begin
          Result := I + 1;
          Exit;
        end;
      end
      else
        Break;
    end;
  end;
  Result := 0;
end;

function IsWild(InputStr, Wilds: string; IgnoreCase: Boolean): Boolean;

  function SearchNext(var Wilds: string): Integer;
    { looking for next *, returns position and string until position }
  begin
    Result := Pos('*', Wilds);
    if Result > 0 then
      Wilds := Copy(Wilds, 1, Result - 1);
  end;

var
  CWild, CInputWord: Integer; { counter for positions }
  I, LenHelpWilds: Integer;
  MaxInputWord, MaxWilds: Integer; { Length of InputStr and Wilds }
  HelpWilds: string;
begin
  if Wilds = InputStr then
  begin
    Result := True;
    Exit;
  end;
  repeat { delete '**', because '**' = '*' }
    I := Pos('**', Wilds);
    if I > 0 then
      Wilds := Copy(Wilds, 1, I - 1) + '*' + Copy(Wilds, I + 2, MaxInt);
  until I = 0;
  if Wilds = '*' then
  begin { for fast end, if Wilds only '*' }
    Result := True;
    Exit;
  end;
  MaxInputWord := Length(InputStr);
  MaxWilds := Length(Wilds);
  if IgnoreCase then
  begin { upcase all letters }
    InputStr := AnsiUpperCase(InputStr);
    Wilds := AnsiUpperCase(Wilds);
  end;
  if (MaxWilds = 0) or (MaxInputWord = 0) then
  begin
    Result := False;
    Exit;
  end;
  CInputWord := 1;
  CWild := 1;
  Result := True;
  repeat
    if InputStr[CInputWord] = Wilds[CWild] then
    begin { equal letters }
      { goto next letter }
      Inc(CWild);
      Inc(CInputWord);
      Continue;
    end;
    if Wilds[CWild] = '?' then
    begin { equal to '?' }
      { goto next letter }
      Inc(CWild);
      Inc(CInputWord);
      Continue;
    end;
    if Wilds[CWild] = '*' then
    begin { handling of '*' }
      HelpWilds := Copy(Wilds, CWild + 1, MaxWilds);
      I := SearchNext(HelpWilds);
      LenHelpWilds := Length(HelpWilds);
      if I = 0 then
      begin
        { no '*' in the rest, compare the ends }
        if HelpWilds = '' then
          Exit; { '*' is the last letter }
        { check the rest for equal Length and no '?' }
        for I := 0 to LenHelpWilds - 1 do
        begin
          if (HelpWilds[LenHelpWilds - I] <> InputStr[MaxInputWord - I]) and
            (HelpWilds[LenHelpWilds - I] <> '?') then
          begin
            Result := False;
            Exit;
          end;
        end;
        Exit;
      end;
      { handle all to the next '*' }
      Inc(CWild, 1 + LenHelpWilds);
      I := FindPart(HelpWilds, Copy(InputStr, CInputWord, MaxInt));
      if I = 0 then
      begin
        Result := False;
        Exit;
      end;
      CInputWord := I + LenHelpWilds;
      Continue;
    end;
    Result := False;
    Exit;
  until (CInputWord > MaxInputWord) or (CWild > MaxWilds);
  { no completed evaluation }
  if CInputWord <= MaxInputWord then
    Result := False;
  if (CWild <= MaxWilds) and (Wilds[MaxWilds] <> '*') then
    Result := False;
end;

function XorString(const Key, Src: ShortString): ShortString;
var
  I: Integer;
begin
  Result := Src;
  if Length(Key) > 0 then
    for I := 1 to Length(Src) do
      Result[I] := Chr(Byte(Key[1 + ((I - 1) mod Length(Key))]) xor Ord(Src[I]));
end;

function XorEncode(const Key, Source: string): string;
var
  I: Integer;
  C: Byte;
begin
  Result := '';
  for I := 1 to Length(Source) do
  begin
    if Length(Key) > 0 then
      C := Byte(Key[1 + ((I - 1) mod Length(Key))]) xor Byte(Source[I])
    else
      C := Byte(Source[I]);
    Result := Result + AnsiLowerCase(IntToHex(C, 2));
  end;
end;

function XorDecode(const Key, Source: string): string;
var
  I: Integer;
  C: Char;
begin
  Result := '';
  for I := 0 to Length(Source) div 2 - 1 do
  begin
    C := Chr(StrToIntDef('$' + Copy(Source, (I * 2) + 1, 2), Ord(' ')));
    if Length(Key) > 0 then
      C := Chr(Byte(Key[1 + (I mod Length(Key))]) xor Byte(C));
    Result := Result + C;
  end;
end;

function GetCmdLineArg(const Switch: string; ASwitchChars: TCharSet): string;
var
  I: Integer;
  S: string;
begin
  I := 1;
  while I <= ParamCount do
  begin
    S := ParamStr(I);
    if (ASwitchChars = []) or ((S[1] in ASwitchChars) and (Length(S) > 1)) then
    begin
      if AnsiCompareText(Copy(S, 2, MaxInt), Switch) = 0 then
      begin
        Inc(I);
        if I <= ParamCount then
        begin
          Result := ParamStr(I);
          Exit;
        end;
      end;
    end;
    Inc(I);
  end;
  Result := '';
end;

{ begin JvStrUtil }
function FindNotBlankCharPos(const S: string): Integer;
begin
  for Result := 1 to Length(S) do
    if S[Result] <> ' ' then
      Exit;
  Result := Length(S) + 1;
end;

function FindNotBlankCharPosW(const S: WideString): Integer;
begin
  for Result := 1 to Length(S) do
    if S[Result] <> ' ' then
      Exit;
  Result := Length(S) + 1;
end;

// (rom) reimplemented

function AnsiChangeCase(const S: string): string;
var
  I: Integer;
  Up: string;
  Down: string;
begin
  Result := S;
  Up := AnsiUpperCase(S);
  Down := AnsiLowerCase(S);
  for I := 1 to Length(Result) do
    if Result[I] = Up[I] then
      Result[I] := Down[I]
    else
      Result[I] := Up[I];
end;

function WideChangeCase(const S: string): string; 
var
  I: Integer;
  Up: string;
  Down: string;
begin
  Result := S;
  Up := WideUpperCase(S);
  Down := WideLowerCase(S);
  for I := 1 to Length(Result) do
    if Result[I] = Up[I] then
      Result[I] := Down[I]
    else
      Result[I] := Up[I];
end;

function StringEndsWith(const Str, SubStr: string): Boolean;
begin
  Result := Copy(Str, Length(Str) - Length(SubStr) + 1, Length(SubStr)) = SubStr;
end;

function ExtractFilePath2(const FileName: string): string;
var
  P, P1, P2, PP: PChar;
begin
  P := PChar(FileName);
  P1 := StrRScan(P, '\');
  P2 := StrRScan(P, '/');
  if P1 <> nil then
    if P2 <> nil then
      if P2 > P1 then
        PP := P2
      else
        PP := P1
    else
      PP := P1
  else
    PP := P2;

  if PP = nil then
    Result := ''
  else
    SetString(Result, P, PP - P + 1);
end;
{ end JvStrUtil }
{ end JvStrUtils }

{ begin JvFileUtil }

function NormalDir(const DirName: string): string;
begin
  Result := DirName;
{$IFDEF MSWINDOWS}
  if (Result <> '') and
    not (AnsiLastChar(Result)^ in [':', '\']) then
    if (Length(Result) = 1) and (UpCase(Result[1]) in ['A'..'Z']) then
      Result := Result + ':\'
    else
      Result := Result + '\';
{$ENDIF}
end;

function RemoveBackSlash(const DirName: string): string;
begin
  Result := DirName;
  if (Length(Result) > 1) and
    (AnsiLastChar(Result)^ = '\') then
    if not ((Length(Result) = 3) and (UpCase(Result[1]) in ['A'..'Z']) and
      (Result[2] = ':')) then
      Delete(Result, Length(Result), 1);
end;

function DirExists(Name: string): Boolean;
begin
  Result := DirectoryExists(Name);
end;

function GetFileSize(const FileName: string): Int64;
{$IFDEF MSWINDOWS}
var
  Handle: THandle;
  FindData: TWin32FindData;
begin
  Handle := FindFirstFile(PChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      Int64Rec(Result).Lo := FindData.nFileSizeLow;
      Int64Rec(Result).Hi := FindData.nFileSizeHigh;
      Exit;
    end;
  end;
  Result := -1;
end;
{$ENDIF}
{$IFDEF LINUX}
var
  st: TStatBuf;
begin
  if stat(PChar(FileName), st) = 0 then
    Result := st.st_size
  else
    Result := -1;
end;
{$ENDIF}

function FileDateTime(const FileName: string): TDateTime;
var
  Age: Longint;
begin
  Age := FileAge(FileName);
  {$IFDEF MSWINDOWS}
  // [roko] -1 is valid FileAge value on Linux
  if Age = -1 then
    Result := NullDate
  else
  {$ENDIF}
    Result := FileDateToDateTime(Age);
end;

{$IFDEF MSWINDOWS}
function HasAttr(const FileName: string; Attr: Integer): Boolean;
var
  FileAttr: Integer;
begin
  {$WARNINGS OFF}
  FileAttr := FileGetAttr(FileName);
  {$WARNINGS ON}
  Result := (FileAttr >= 0) and (FileAttr and Attr = Attr);
end;
{$ENDIF}

function DeleteFilesEx(const FileMasks: array of string): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := Low(FileMasks) to High(FileMasks) do
    Result := Result and DeleteFiles(ExtractFilePath(FileMasks[I]), ExtractFileName(FileMasks[I]));
end;

{$IFDEF MSWINDOWS}
function GetWindowsDir: string;
var
  Buffer: array [0..MAX_PATH] of Char;
begin
  SetString(Result, Buffer, GetWindowsDirectory(Buffer, SizeOf(Buffer)));
end;

function GetSystemDir: string;
var
  Buffer: array [0..MAX_PATH] of Char;
begin
  SetString(Result, Buffer, GetSystemDirectory(Buffer, SizeOf(Buffer)));
end;

function GetWinDir: TFileName;
begin
  Result := GetWindowsDir;
end;
{$ENDIF MSWINDOWS}

{$IFDEF LINUX}
function GetTempFileName(const Prefix: string);
var
  P: PChar;
begin
  P := tempnam(nil, Pointer(Prefix));
  Result := P;
  if P <> nil then
    Libc.free(P);
end;
{$ENDIF LINUX}

function GenTempFileName(FileName: string): string;
var
  TempDir: string;
  TempFile: array [0..MAX_PATH] of Char;
  STempDir: TFileName;
  Res: Integer;
begin
  TempDir := GetTempDir;
  if FileName <> '' then
  begin
    if Length(FileName) < 4 then
      FileName := ExpandFileName(FileName);
    if (Length(FileName) > 4) and (FileName[2] = ':') and
      (Length(TempDir) > 4) and
      (AnsiCompareText(TempDir, FileName) <> 0) then
    begin
      STempDir := ExtractFilePath(FileName);
      Move(STempDir[1], TempDir, Length(STempDir) + 1);
    end;
  end;
{$IFDEF MSWINDOWS}
  Res := GetTempFileName(
    PChar(TempDir), { address of directory name for temporary file}
    '~JV', { address of filename prefix}
    0, { number used to create temporary filename}
    TempFile); { address of buffer that receives the new filename}
{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
  TempFile := GetTempFileName('~JV');
{$ENDIF LINUX}
  if Res <> 0 then
    Result := TempFile
  else
    Result := '~JVCLTemp.tmp';
  DeleteFile(Result);
end;

function GenTempFileNameExt(FileName: string; const FileExt: string): string;
begin
  Result := ChangeFileExt(GenTempFileName(FileName), FileExt);
end;

function GetTempDir: string;
{$IFDEF MSWINDOWS}
var
  TempDir: array [0..MAX_PATH] of Char;
begin
  TempDir[GetTempPath(260, TempDir)] := #0;
  Result := TempDir;
end;
{$ENDIF}
{$IFDEF LINUX}
begin
  Result := ExtractFileDir(GetTempFileName(''));
  if Result = '' then
    Result := '/tmp'; // hard coded
end;
{$ENDIF}

function ClearDir(const Dir: string): Boolean;
var
  SearchRec: TSearchRec;
  DosError: Integer;
  Path: TFileName;
begin
  Result := True;
  Path := Dir;
  AddSlash(Path);
  DosError := FindFirst(Path + AllFilesMask, faAnyFile, SearchRec);
  while DosError = 0 do
  begin
    if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
    begin
      if (SearchRec.Attr and faDirectory) = faDirectory then
        Result := Result and DeleteDir(Path + SearchRec.Name)
      else
        Result := Result and DeleteFile(Path + SearchRec.Name);
      // if not Result then Exit;
    end;
    DosError := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end;

function DeleteDir(const Dir: string): Boolean;
begin
  ClearDir(Dir);
  Result := RemoveDir(Dir);
end;

function DeleteFiles(const Folder: TFileName; const Masks: string):boolean;
var
  SearchRec: TSearchRec;
  DosError: Integer;
  Path: TFileName;
begin
  Result := false;
  Path := AddSlash2(Folder);
  DosError := FindFirst(Path + AllFilesMask, faAnyFile and not faDirectory, SearchRec);
  while DosError = 0 do
  begin
    if FileEquMasks(Path + SearchRec.Name, Masks) then
      Result := DeleteFile(Path + SearchRec.Name);
    DosError := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end;

function GetParameter: string;
var
  FN, FN1: PChar;
begin
  if ParamCount = 0 then
  begin
    Result := '';
    Exit
  end;
{$WARNINGS OFF}
  FN := CmdLine;
{$WARNINGS ON}
  if FN[0] = '"' then
  begin
    FN := StrScan(FN + 1, '"');
    if (FN[0] = #0) or (FN[1] = #0) then
      Result := ''
    else
    begin
      Inc(FN, 2);
      if FN[0] = '"' then
      begin
        Inc(FN, 1);
        FN1 := StrScan(FN + 1, '"');
        if FN1[0] <> #0 then
          FN1[0] := #0;
      end;
      Result := FN;
    end;
  end
  else
{$WARNINGS OFF}
    Result := Copy(CmdLine, Length(ParamStr(0)) + 1, 260);
{$WARNINGS ON}
  while (Length(Result) > 0) and (Result[1] = ' ') do
    Delete(Result, 1, 1);
  Result := ReplaceString(Result, '"', '');
  if FileExists(Result) then
    Result := GetLongFileName(Result);
end;

function GetLongFileName(FileName: string): string;
{$IFDEF MSWINDOWS}
var
  SearchRec: TSearchRec;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  if FileGetInfo(FileName, SearchRec) then
    {$WARNINGS OFF}
    Result := ExtractFilePath(ExpandFileName(FileName)) + SearchRec.FindData.cFileName
    {$WARNINGS ON}
  else
    Result := FileName;
{$ENDIF}
{$IFDEF LINUX}
  Result := ExpandFileName(FileName);
{$ENDIF}
end;

function FileEquMask(FileName, Mask: TFileName;
  CaseSensitive: Boolean = {$IFDEF WINDOWS}False{$ELSE}True{$ENDIF}): Boolean;
var
  I: Integer;
  C: Char;
  P: PChar;
begin
  if not CaseSensitive then
  begin
    FileName := AnsiUpperCase(ExtractFileName(FileName));
    Mask := AnsiUpperCase(Mask);
  end;
  Result := False;
{$IFDEF MSWINDOWS}
  if Pos('.', FileName) = 0 then
    FileName := FileName + '.';
{$ENDIF}
  I := 1;
  P := PChar(FileName);
  while I <= Length(Mask) do
  begin
    C := Mask[I];
    if (P[0] = #0) and (C <> '*') then
      Exit;
    case C of
      '*':
        if I = Length(Mask) then
        begin
          Result := True;
          Exit;
        end
        else
        begin
          P := StrScan(P, Mask[I + 1]);
          if P = nil then
            Exit;
        end;
      '?':
        Inc(P);
    else
      if C = P[0] then
        Inc(P)
      else
        Exit;
    end;
    Inc(I);
  end;
  if P[0] = #0 then
    Result := True;
end;

function FileEquMasks(FileName, Masks: TFileName;
  CaseSensitive: Boolean = {$IFDEF WINDOWS}False{$ELSE}True{$ENDIF}): Boolean;
var
  I: Integer;
  Mask: string;
begin
  Result := False;
  I := 0;
  Mask := Trim(GetSubStr(Masks, I, PathSep));
  while Length(Mask) <> 0 do
    if FileEquMask(FileName, Mask, CaseSensitive) then
    begin
      Result := True;
      Break;
    end
    else
    begin
      Inc(I);
      Mask := Trim(GetSubStr(Masks, I, PathSep));
    end;
end;

function ValidFileName(const FileName: string): Boolean;

  function HasAny(const Str, Substr: string): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 1 to Length(Substr) do
    begin
      if Pos(Substr[I], Str) > 0 then
      begin
        Result := True;
        Break;
      end;
    end;
  end;

begin
  Result := (FileName <> '') and
{$IFDEF MSWINDOWS}
    (not HasAny(FileName, '/<>"?*|'));
{$ENDIF}
{$IFDEF LINUX}
    (not HasAny(FileName, '<>"?*|'));
{$ENDIF}
  if Result then
    Result := Pos(PathDelim, ExtractFileName(FileName)) = 0;
end;

{$IFDEF MSWINDOWS}
function FileLock(Handle: Integer; Offset, LockSize: Longint): Integer;
begin
  if LockFile(Handle, Offset, 0, LockSize, 0) then
    Result := 0
  else
    Result := GetLastError;
end;

function FileUnlock(Handle: Integer; Offset, LockSize: Longint): Integer;
begin
  if UnlockFile(Handle, Offset, 0, LockSize, 0) then
    Result := 0
  else
    Result := GetLastError;
end;

function FileLock(Handle: Integer; Offset, LockSize: Int64): Integer;
begin
  if LockFile(Handle, Int64Rec(Offset).Lo, Int64Rec(Offset).Hi,
    Int64Rec(LockSize).Lo, Int64Rec(LockSize).Hi) then
    Result := 0
  else
    Result := GetLastError;
end;

function FileUnlock(Handle: Integer; Offset, LockSize: Int64): Integer;
begin
  if UnlockFile(Handle, Int64Rec(Offset).Lo, Int64Rec(Offset).Hi,
    Int64Rec(LockSize).Lo, Int64Rec(LockSize).Hi) then
    Result := 0
  else
    Result := GetLastError;
end;
{$ENDIF}

function ShortToLongFileName(const ShortName: string): string;
{$IFDEF MSWINDOWS}
var
  Temp: TWin32FindData;
  SearchHandle: THandle;
begin
  SearchHandle := FindFirstFile(PChar(ShortName), Temp);
  if SearchHandle <> INVALID_HANDLE_VALUE then
  begin
    Result := Temp.cFileName;
    if Result = '' then
      Result := Temp.cAlternateFileName;
  end
  else
    Result := '';
  Windows.FindClose(SearchHandle);
end;
{$ENDIF}
{$IFDEF LINUX}
begin
  if FileExists(ShortName) then
    Result := ShortName
  else
    Result := '';
end;
{$ENDIF}

function LongToShortFileName(const LongName: string): string;
{$IFDEF MSWINDOWS}
var
  Temp: TWin32FindData;
  SearchHandle: THandle;
begin
  SearchHandle := FindFirstFile(PChar(LongName), Temp);
  if SearchHandle <> INVALID_HANDLE_VALUE then
  begin
    Result := Temp.cAlternateFileName;
    if Result = '' then
      Result := Temp.cFileName;
  end
  else
    Result := '';
  Windows.FindClose(SearchHandle);
end;
{$ENDIF}
{$IFDEF LINUX}
begin
  if FileExists(LongtName) then
    Result := LongName
  else
    Result := '';
end;
{$ENDIF}

function ShortToLongPath(const ShortName: string): string;
var
  LastSlash: PChar;
  TempPathPtr: PChar;
begin
  Result := '';
  TempPathPtr := PChar(ShortName);
  LastSlash := StrRScan(TempPathPtr, PathDelim);
  while LastSlash <> nil do
  begin
    Result := PathDelim + ShortToLongFileName(TempPathPtr) + Result;
    if LastSlash <> nil then
    begin
      LastSlash^ := #0;
      LastSlash := StrRScan(TempPathPtr, PathDelim);
    end;
  end;
  Result := TempPathPtr + Result;
end;

function LongToShortPath(const LongName: string): string;
var
  LastSlash: PChar;
  TempPathPtr: PChar;
begin
  Result := '';
  TempPathPtr := PChar(LongName);
  LastSlash := StrRScan(TempPathPtr, PathDelim);
  while LastSlash <> nil do
  begin
    Result := PathDelim + LongToShortFileName(TempPathPtr) + Result;
    if LastSlash <> nil then
    begin
      LastSlash^ := #0;
      LastSlash := StrRScan(TempPathPtr, PathDelim);
    end;
  end;
  Result := TempPathPtr + Result;
end;

{$IFDEF MSWINDOWS}
const
  IID_IPersistFile: TGUID =
    (D1: $0000010B; D2: $0000; D3: $0000; D4: ($C0, $00, $00, $00, $00, $00, $00, $46));

const
  LinkExt = '.lnk';

procedure CreateFileLink(const FileName, DisplayName: string; Folder: Integer);
var
  ShellLink: IShellLink;
  PersistFile: IPersistFile;
  ItemIDList: PItemIDList;
  FileDestPath: array [0..MAX_PATH] of Char;
  FileNameW: array [0..MAX_PATH] of WideChar;
begin
  CoInitialize(nil);
  try
    OleCheck(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_SERVER,
      IID_IShellLinkA, ShellLink));
    try
      OleCheck(ShellLink.QueryInterface(IID_IPersistFile, PersistFile));
      try
        OleCheck(SHGetSpecialFolderLocation(0, Folder, ItemIDList));
        SHGetPathFromIDList(ItemIDList, FileDestPath);
        StrCat(FileDestPath, PChar('\' + DisplayName + LinkExt));
        ShellLink.SetPath(PChar(FileName));
        ShellLink.SetIconLocation(PChar(FileName), 0);
        MultiByteToWideChar(CP_ACP, 0, FileDestPath, -1, FileNameW, MAX_PATH);
        OleCheck(PersistFile.Save(FileNameW, True));
      finally
        PersistFile := nil;
      end;
    finally
      ShellLink := nil;
    end;
  finally
    CoUninitialize;
  end;
end;

procedure DeleteFileLink(const DisplayName: string; Folder: Integer);
var
  ShellLink: IShellLink;
  ItemIDList: PItemIDList;
  FileDestPath: array [0..MAX_PATH] of Char;
begin
  CoInitialize(nil);
  try
    OleCheck(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_SERVER,
      IID_IShellLinkA, ShellLink));
    try
      OleCheck(SHGetSpecialFolderLocation(0, Folder, ItemIDList));
      SHGetPathFromIDList(ItemIDList, FileDestPath);
      StrCat(FileDestPath, PChar('\' + DisplayName + LinkExt));
      DeleteFile(FileDestPath);
    finally
      ShellLink := nil;
    end;
  finally
    CoUninitialize;
  end;
end;
{$ENDIF}

{ end JvFileUtil }


{$IFNDEF COMPILER6_UP}
{ begin JvXMLDatabase D5 compatiblility functions }

{ TODO -oJVCL -cTODO : Implement these better for D5! }
function StrToDateTimeDef(const S:string;Default:TDateTime):TDateTime;
begin
  // stupid and slow but at least simple
  try
    Result := StrToDateTime(S);
  except
    Result := Default;
  end;
end;

const
  OneMillisecond = 1/24/60/60/1000;

function CompareDateTime(const A, B:TDateTime):integer;
begin
  if Abs(A - B) < OneMillisecond then
    Result := 0
  else if A < B then
    Result := -1
  else
    Result := 1;
end;

function StrToFloatDef(const S:String;Default:Extended):Extended;
begin
  // stupid and slow but at least simple
  try
    Result := StrToFloat(S);
  except
    Result := Default;
  end;
end;

{ end JvXMLDatabase D5 compatiblility functions }

procedure RaiseLastOSError;
begin
  RaiseLastWin32Error;
end;

function IncludeTrailingPathDelimiter(const APath: string): string;
begin
  if (Length(APath) > 0) and (APath[Length(APath)] <> PathDelim) then
    Result := APath + PathDelim
  else
    Result := APath;
end;

function ExcludeTrailingPathDelimiter(const APath: string): string;
var I: Integer;
begin
  Result := APath;
  I := Length(Result);
  while (I > 0) and (Result[I] = PathDelim) do Dec(I);
  SetLength(Result, I - 1);
end;

{$ENDIF}

initialization
  { begin JvDateUtil }
{$IFDEF USE_FOUR_DIGIT_YEAR}
  FourDigitYear := Pos('YYYY', AnsiUpperCase(ShortDateFormat)) > 0;
{$ENDIF}
  { end JvDateUtil }
end.
