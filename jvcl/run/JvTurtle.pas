{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvTurtle.PAS, released on 2002-06-15.

The Initial Developer of the Original Code is Jan Verhoeven [jan1.verhoeven@wxs.nl]
Portions created by Jan Verhoeven are Copyright (C) 2002 Jan Verhoeven.
All Rights Reserved.

Contributor(s): Robert Love [rlove@slcdug.org].

Last Modified: 2000-06-15

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvTurtle;

interface

uses
  Windows, Messages, Math, SysUtils, Classes, Graphics, Controls;

type
  TRequestBackGroundEvent = procedure(Sender: TObject; Background: string) of object;
  TRequestFilterEvent = procedure(Sender: TObject; Filter: string) of object;
  TRequestImageSizeEvent = procedure(Sender: TObject; var ARect: TRect) of object;

type
  TJvTurtle = class(TComponent)
  private
    FPosition: TPoint;
    FHeading: Real;
    FCanvas: TCanvas;
    FPenDown: Boolean;
    FMark: TPoint;
    FArea: TRect;
    FPot: TStringList;
    FScript: string;
    FIP: Integer;
    FIPMax: Integer;
    FSP: Integer;
    FNSP: Integer;
    FStack: array of Integer;
    FNStack: array of Integer;
    FBackground: string;
    FFilter: string;
    FAngleMark: Integer;
    FImageRect: TRect;
    FOnRepaintRequest: TNotifyEvent;
    FOnRequestBackGround: TRequestBackGroundEvent;
    FOnRequestImageSize: TRequestImageSizeEvent;
    FOnRequestFilter: TRequestFilterEvent;
    function GetToken(var Token: string): Boolean;
    function GetNum(var Num: Integer): Boolean;
    function InPot(Token: string; var Num: Integer): Boolean;
    function GetTex(var Tex: string): Boolean;
    function GetCol(var Col: TColor): Boolean;
    // function SkipBlock: Boolean;
    function Push(Num: Integer): Boolean;
    function Pop(var Num: Integer): Boolean;
    function NPush(var Msg: string; Num: Integer): Boolean;
    function NPop(var Msg: string; var Num: Integer): Boolean;
    function IsNum(Tex: string): Boolean;
    function IsCol(Tex: string): Boolean;
    function IsVar(Tex: string): Boolean;
    procedure SetPosition(const Value: TPoint);
    procedure SetHeading(const Value: Real);
    procedure SetCanvas(const Value: TCanvas);
    procedure SetPenDown(const Value: Boolean);
    procedure SetPenWidth(const Value: Integer);
    function GetWidth: Integer;
    procedure DoGo(Dest: TPoint);
    function txUser(Sym: string): string;
    function txComment: string;
    function txIn: string;
    function txInAdd: string;
    function txInSub: string;
    function txInMult: string;
    function txInDiv: string;
    function txInInc: string;
    function txInDec: string;
    function txBlock: string;
    function txReturn: string;
    function txPos: string;
    function txDefault: string;
    function txMove: string;
    function txLineTo: string;
    function txAngle: string;
    function txDown: string;
    function txUp: string;
    function txPenSize: string;
    function txPenColor: string;
    function txAddPenColor: string;
    function txAddBrushColor: string;
    function txTurn: string;
    function txLeft: string;
    function txRight: string;
    function txGo: string;
    function txText: string;
    function txTextOut: string;
    function txTextFont: string;
    function txTextSize: string;
    function txTextColor: string;
    function txTextBold: string;
    function txTextItalic: string;
    function txTextUnderline: string;
    function txTextNormal: string;
    function txBsSolid: string;
    function txBsClear: string;
    function txBrushColor: string;
    function txRectangle: string;
    function txRoundRect: string;
    function txEllipse: string;
    function txDiamond: string;
    function txPolygon: string;
    function txStar: string;
    function txCurve: string;
    function txMark: string;
    function txGoMark: string;
    function txMarkAngle: string;
    function txGoMarkAngle: string;
    function txArea: string;
    function txCopy: string;
    function txPenMode: string;
    function txCopyMode: string;
    function txFlood: string;
    function txDo: string;
    function txLoop: string;
    function txGoLeft: string;
    function txGoTop: string;
    function txGoRight: string;
    function txGoBottom: string;
    function txGoCenter: string;
    function txAdd: string;
    function txSub: string;
    function txMul: string;
    function txDiv: string;
    function txDup: string;
    function txDrop: string;
    function tx_PosX: string;
    function tx_PosY: string;
    function tx_PenColor: string;
    function tx_BrushColor: string;
    function tx_TextColor: string;
    function tx_PenSize: string;
    function tx_TextSize: string;
    function tx_Angle: string;
    function tx_MarkX: string;
    function tx_MarkY: string;
    function tx_Loop: string;
    function tx_Right: string;
    function tx_Left: string;
    function tx_Top: string;
    function tx_Bottom: string;
    function txIf: string;
    function txGt: string;
    function txGe: string;
    function txLt: string;
    function txLe: string;
    function txEq: string;
    function txNe: string;
    function txNot: string;
    function txAnd: string;
    function txOr: string;
    function txNeg: string;
    function txAbs: string;
    function txSwap: string;
    function txMax: string;
    function txMin: string;
    function txSqr: string;
    function txSqrt: string;
    function txInc: string;
    function txDec: string;
    function txBackground: string;
    function txFilter: string;
    function StrToPenMode(var Pm: TPenMode; S: string): Boolean;
    function StrToCopyMode(var Cm: TCopyMode; S: string): Boolean;
    procedure TextRotate(X, Y, Angle: Integer; AText: string; AFont: TFont);
    procedure SetOnRepaintRequest(const Value: TNotifyEvent);
    procedure SetMark(const Value: TPoint);
    procedure SetArea(const Value: TRect);
    procedure SetOnRequestBackGround(const Value: TRequestBackGroundEvent);
    procedure SetOnRequestImageSize(const Value: TRequestImageSizeEvent);
    procedure SetOnRequestFilter(const Value: TRequestFilterEvent);
  protected
    procedure DoRepaintRequest; virtual;
    procedure DoRequestBackground; virtual;
    procedure DoRequestFilter; virtual;
    function DoRequestImageSize: Boolean; virtual;
  public
    property Canvas: TCanvas read FCanvas write SetCanvas;
    property Position: TPoint read FPosition write SetPosition;
    property Mark: TPoint read FMark write SetMark;
    property Area: TRect read FArea write SetArea;
    property Heading: Real read FHeading write SetHeading;
    property PenDown: Boolean read FPenDown write SetPenDown;
    property PenWidth: Integer read GetWidth write SetPenWidth;
    function DoCom: string;
    procedure Turn(AAngle: Real);
    procedure Right(AAngle: Real);
    procedure MoveForward(ADistance: Real);
    procedure MoveBackward(ADistance: Real);
    function Interpret(out APos: Integer; S: string): string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnRepaintRequest: TNotifyEvent read FOnRepaintRequest write SetOnRepaintRequest;
    property OnRequestBackGround: TRequestBackGroundEvent read FOnRequestBackGround write SetOnRequestBackGround;
    property OnRequestFilter: TRequestFilterEvent read FOnRequestFilter write SetOnRequestFilter;
    property OnRequestImageSize: TRequestImageSizeEvent read FOnRequestImageSize write SetOnRequestImageSize;
  end;

resourcestring
  sErrorCanvasNotAssigned = '#Error: Canvas not assigned';
  sEmptyScript = 'empty script';
  sInvalidIntegerIns = 'invalid integer in %s';
  sInvalidColorIns = 'invalid color in %s';
  sInvalidCopyMode = 'invalid copy mode';
  sInvalidPenMode = 'invalid pen mode';
  sInvalidTextIns = 'invalid text in %s';
  sMissingFontname = 'missing fontname';
  sNumberExpectedIns = 'number expected in %s';
  sStackOverflow = 'stack overflow';
  sStackUnderflow = 'stack underflow';
  sNumberStackUnderflow = 'number stack underflow';
  sNumberStackOverflow = 'number stack overflow';
  sMissingAfterComment = 'missing } after comment';
  sErrorIns = 'error in %s';
  sDivisionByZero = 'division by zero';
  sInvalidParameterIns = 'invalid parameter in %s';
  sSymbolsIsNotDefined = 'symbol %s is not defined';
  sMissingAfterBlock = 'missing ] after block';
  sStackUnderflowIns = 'stack underflow in %s';
  sSymbolExpectedAfterIf = 'symbol expected after if';
  sCanNotTakeSqrtOf = 'can not take sqrt of 0';
  sNotAllowedIns = '0 not allowed in %s';
  sNeedMinimumOfSidesIns = 'need minimum of 3 sides in %s';
  sMaximumSidesExceededIns = 'maximum 12 sides exceeded in %s';
  sTokenExpected = 'token expected';
  ssDoesNotExist = '%s does not exist';
  sDivisionByZeroNotAllowedInIn = 'division by zero not allowed in in-';

implementation

uses
  JvConsts, JvTypes;

constructor TJvTurtle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPot := TStringList.Create;
  SetLength(FStack, 256);
  SetLength(FNStack, 256);
  txDefault;
end;

destructor TJvTurtle.Destroy;
begin
  FPot.Free;
  inherited Destroy;
end;

function TJvTurtle.DoCom: string;
const
  Mapper: array [0..101] of PChar =
   (
    '-',
    '*',
    '.and',
    '.eq',
    '.ge',
    '.gt',
    '.le',
    '.lt',
    '.ne',
    '.not',
    '.or',
    '/',
    '[',
    ']',
    '{',
    '+',
    '=angle',
    '=bottom',
    '=brushcolor',
    '=left',
    '=loop',
    '=markx',
    '=marky',
    '=pencolor',
    '=pensize',
    '=posx',
    '=posy',
    '=right',
    '=textcolor',
    '=textsize',
    '=top',
    'abs',
    'addbrushcolor',
    'addpencolor',
    'angle',
    'area',
    'background',
    'bold',
    'brushcolor',
    'bsclear',
    'bssolid',
    'copy',
    'copymode',
    'curve',
    'dec',
    'default',
    'diamond',
    'do',
    'down',
    'drop',
    'dup',
    'ellipse',
    'filter',
    'flood',
    'go',
    'gobottom',
    'gocenter',
    'goleft',
    'gomark',
    'gomarkangle',
    'goright',
    'gotop',
    'if',
    'in',
    'inadd',
    'inc',
    'indec',
    'indiv',
    'ininc',
    'inmul',
    'insub',
    'italic',
    'left',
    'lineto',
    'loop',
    'mark',
    'markangle',
    'max',
    'min',
    'move',
    'neg',
    'normal',
    'pencolor',
    'penmode',
    'pensize',
    'polygon',
    'pos',
    'rectangle',
    'right',
    'roundrect',
    'sqr',
    'sqrt',
    'star',
    'swap',
    'text',
    'textcolor',
    'textfont',
    'textout',
    'textsize',
    'turn',
    'underline',
    'up'
   );
var
  Com: string;
  I, N: Integer;
begin
  Result := 'ready';
  if not GetToken(Com) then
    Exit;

  N := -1;
  for I := Low(Mapper) to High(Mapper) do
    if Com = Mapper[I] then
    begin
      N := I;
      Break;
    end;

  case N of
    0:
      Result := txSub;
    1:
      Result := txMul;
    2:
      Result := txAnd;
    3:
      Result := txEq;
    4:
      Result := txGe;
    5:
      Result := txGt;
    6:
      Result := txLe;
    7:
      Result := txLt;
    8:
      Result := txNe;
    9:
      Result := txNot;
    10:
      Result := txOr;
    11:
      Result := txDiv;
    12:
      Result := txBlock;
    13:
      Result := txReturn;
    14:
      Result := txComment;
    15:
      Result := txAdd;
    16:
      Result := tx_Angle;
    17:
      Result := tx_Bottom;
    18:
      Result := tx_BrushColor;
    19:
      Result := tx_Left;
    20:
      Result := tx_Loop;
    21:
      Result := tx_MarkX;
    22:
      Result := tx_MarkY;
    23:
      Result := tx_PenColor;
    24:
      Result := tx_PenSize;
    25:
      Result := tx_PosX;
    26:
      Result := tx_PosY;
    27:
      Result := tx_Right;
    28:
      Result := tx_TextColor;
    29:
      Result := tx_TextSize;
    30:
      Result := tx_Top;
    31:
      Result := txAbs;
    32:
      Result := txAddBrushColor;
    33:
      Result := txAddPenColor;
    34:
      Result := txAngle;
    35:
      Result := txArea;
    36:
      Result := txBackground;
    37:
      Result := txTextBold;
    38:
      Result := txBrushColor;
    39:
      Result := txBsClear;
    40:
      Result := txBsSolid;
    41:
      Result := txCopy;
    42:
      Result := txCopyMode;
    43:
      Result := txCurve;
    44:
      Result := txDec;
    45:
      Result := txDefault;
    46:
      Result := txDiamond;
    47:
      Result := txDo;
    48:
      Result := txDown;
    49:
      Result := txDrop;
    50:
      Result := txDup;
    51:
      Result := txEllipse;
    52:
      Result := txFilter;
    53:
      Result := txFlood;
    54:
      Result := txGo;
    55:
      Result := txGoBottom;
    56:
      Result := txGoCenter;
    57:
      Result := txGoLeft;
    58:
      Result := txGoMark;
    59:
      Result := txGoMarkAngle;
    60:
      Result := txGoRight;
    61:
      Result := txGoTop;
    62:
      Result := txIf;
    63:
      Result := txIn;
    64:
      Result := txInAdd;
    65:
      Result := txInc;
    66:
      Result := txInDec;
    67:
      Result := txInDiv;
    68:
      Result := txInInc;
    69:
      Result := txInMult;
    70:
      Result := txInSub;
    71:
      Result := txTextItalic;
    72:
      Result := txLeft;
    73:
      Result := txLineTo;
    74:
      Result := txLoop;
    75:
      Result := txMark;
    76:
      Result := txMarkAngle;
    77:
      Result := txMax;
    78:
      Result := txMin;
    79:
      Result := txMove;
    80:
      Result := txNeg;
    81:
      Result := txTextNormal;
    82:
      Result := txPenColor;
    83:
      Result := txPenMode;
    84:
      Result := txPenSize;
    85:
      Result := txPolygon;
    86:
      Result := txPos;
    87:
      Result := txRectangle;
    88:
      Result := txRight;
    89:
      Result := txRoundRect;
    90:
      Result := txSqr;
    91:
      Result := txSqrt;
    92:
      Result := txStar;
    93:
      Result := txSwap;
    94:
      Result := txText;
    95:
      Result := txTextColor;
    96:
      Result := txTextFont;
    97:
      Result := txTextOut;
    98:
      Result := txTextSize;
    99:
      Result := txTurn;
    100:
      Result := txTextUnderline;
    101:
      Result := txUp;
  else
    if IsNum(Com) then
      Result := ''
    else
    if IsCol(Com) then
      Result := ''
    else
    if IsVar(Com) then
      Result := ''
    else
      Result := txUser(Com);
  end;
end;

procedure TJvTurtle.DoRepaintRequest;
begin
  if Assigned(FOnRepaintRequest) then
    FOnRepaintRequest(Self);
end;

function TJvTurtle.GetCol(var Col: TColor): Boolean;
var
  Token, Msg: string;
  Num: Integer;
begin
  Result := False;
  if GetToken(Token) then
    if Token = '=' then
    begin
      Result := True;
      if NPop(Msg, Num) then
        Col := Num
      else
        Result := False;
    end
    else
      try
        Col := StringToColor(Variant(Token));
        Result := True;
      except
        Result := False;
      end;
end;

function TJvTurtle.InPot(Token: string; var Num: Integer): Boolean;
var
  S: string;
begin
  Result := False;
  S := FPot.Values[Token];
  if S <> '' then
    try
      Num := StrToInt(S);
      Result := True;
    except
      Result := False;
    end;
end;

function TJvTurtle.GetNum(var Num: Integer): Boolean;
var
  Token, Msg: string;
begin
  Result := False;
  if GetToken(Token) then
    if Token = '=' then
      Result := NPop(Msg, Num)
    else
    if InPot(Token, Num) then
      Result := True
    else
      try
        Num := StrToInt(Token);
        Result := True;
      except
        Result := False;
      end;
end;

function TJvTurtle.GetTex(var Tex: string): Boolean;
begin
  Tex := '';
  Result := False;
  while (FIP <= FIPMax) and (FScript[FIP] <> '"') do
    Inc(FIP);
  if FIP > FIPMax then
    Exit;
  Inc(FIP);
  while (FIP <= FIPMax) and (FScript[FIP] <> '"') do
  begin
    Tex := Tex + FScript[FIP];
    Inc(FIP);
  end;
  if FIP > FIPMax then
    Exit;
  Inc(FIP);
  Result := Tex <> '';
end;

function TJvTurtle.GetToken(var Token: string): Boolean;
begin
  Token := '';
  while (FIP <= FIPMax) and (FScript[FIP] = ' ') do
    Inc(FIP);
  while (FIP <= FIPMax) and (FScript[FIP] <> ' ') do
  begin
    Token := Token + FScript[FIP];
    Inc(FIP);
  end;
  Result := Token <> '';
end;

function TJvTurtle.GetWidth: Integer;
begin
  if Assigned(FCanvas) then
    Result := FCanvas.Pen.Width
  else
    Result := 1;
end;

function TJvTurtle.Interpret(out APos: Integer; S: string): string;
var
  Msg: string;
begin
  Result := sErrorCanvasNotAssigned;
  if not Assigned(FCanvas) then
    Exit;
  S := StringReplace(S, Tab, ' ', [rfReplaceAll]);
  S := StringReplace(S, Cr,  ' ', [rfReplaceAll]);
  S := StringReplace(S, Lf,  ' ', [rfReplaceAll]);
  FScript := S;
  FSP := 0;
  FIP := 1;
  FIPMax := Length(FScript);
  if FIPMax > 0 then
  begin
    FPot.Clear;
    repeat
      Msg := DoCom;
    until Msg <> '';
    Result := Msg;
    APos := FIP;
  end
  else
    Result := sEmptyScript;
end;

procedure TJvTurtle.DoGo(Dest: TPoint);
begin
  Canvas.MoveTo(Position.X, Position.Y);
  if PenDown then
    Canvas.LineTo(Dest.X, Dest.Y)
  else
    Canvas.MoveTo(Dest.X, Dest.Y);
  Position := Dest;
end;

procedure TJvTurtle.Turn(AAngle: Real);
begin
  Heading := Heading + AAngle;
end;

procedure TJvTurtle.MoveBackward(ADistance: Real);
var
  RAngle: Real;
  dX, dY: Real;
  NewPoint: TPoint;
begin
  if not Assigned(FCanvas) then
    Exit;
  RAngle := Heading * 2 * Pi / 360;
  dX := ADistance * Cos(RAngle);
  dY := ADistance * Sin(RAngle);
  NewPoint := Point(Variant(Position.X - dX), Variant(Position.Y + dY));
  DoGo(NewPoint);
end;

procedure TJvTurtle.MoveForward(ADistance: Real);
var
  RAngle: Real;
  dX, dY: Real;
  NewPoint: TPoint;
begin
  if not Assigned(FCanvas) then
    Exit;
  RAngle := Heading * 2 * pi / 360;
  dX := ADistance * Cos(RAngle);
  dY := ADistance * Sin(RAngle);
  NewPoint := Point(Variant(Position.X + dX), Variant(Position.Y - dY));
  DoGo(NewPoint);
end;

function TJvTurtle.Pop(var Num: Integer): Boolean;
begin
  Result := FSP > 0;
  if Result then
  begin
    Dec(FSP);
    Num := FStack[FSP];
  end;
end;

function TJvTurtle.Push(Num: Integer): Boolean;
begin
  try
    if FSP >= Length(FStack) then
      SetLength(FStack, Length(FStack) + 256);
    FStack[FSP] := Num;
    Inc(FSP);
    Result := True;
  except
    Result := False;
  end;
end;

procedure TJvTurtle.Right(AAngle: Real);
begin
  Heading := Heading - AAngle;
end;

procedure TJvTurtle.SetArea(const Value: TRect);
begin
  FArea := Value;
end;

procedure TJvTurtle.SetCanvas(const Value: TCanvas);
begin
  FCanvas := Value;
end;

procedure TJvTurtle.SetHeading(const Value: Real);
begin
  FHeading := Value;
end;

procedure TJvTurtle.SetMark(const Value: TPoint);
begin
  FMark := Value;
end;

procedure TJvTurtle.SetOnRepaintRequest(const Value: TNotifyEvent);
begin
  FOnRepaintRequest := Value;
end;

procedure TJvTurtle.SetPenDown(const Value: Boolean);
begin
  FPenDown := Value;
end;

procedure TJvTurtle.SetPosition(const Value: TPoint);
begin
  FPosition := Value;
end;

procedure TJvTurtle.SetPenWidth(const Value: Integer);
begin
  if Assigned(FCanvas) then
    FCanvas.Pen.Width := Value;
end;

function TJvTurtle.StrToCopyMode(var Cm: TCopyMode; S: string): Boolean;
begin
  Result := True;
  if S = 'cmblackness' then
    Cm := cmBlackness
  else
  if S = 'cmdstinvert' then
    Cm := cmDstInvert
  else
  if S = 'cmmergecopy' then
    Cm := cmMergeCopy
  else
  if S = 'cmmergepaint' then
    Cm := cmMergePaint
  else
  if S = 'cmnotsrccopy' then
    Cm := cmNotSrcCopy
  else
  if S = 'cmnotsrcerase' then
    Cm := cmNotSrcErase
  else
  if S = 'cmpatcopy' then
    Cm := cmPatCopy
  else
  if S = 'cmpatinvert' then
    Cm := cmPatInvert
  else
  if S = 'cmpatpaint' then
    Cm := cmPatPaint
  else
  if S = 'cmsrcand' then
    Cm := cmSrcAnd
  else
  if S = 'cmsrccopy' then
    Cm := cmSrcCopy
  else
  if S = 'cmsrcerase' then
    Cm := cmSrcErase
  else
  if S = 'cmsrcinvert' then
    Cm := cmSrcInvert
  else
  if S = 'cmscrpaint' then
    Cm := cmSrcPaint
  else
  if S = 'cmwhiteness' then
    Cm := cmWhiteness
  else
    Result := False;
end;

function TJvTurtle.StrToPenMode(var Pm: TPenMode; S: string): Boolean;
begin
  Result := True;
  if S = 'pmBlack' then
    Pm := pmBlack
  else
  if S = 'pmwhite' then
    Pm := pmWhite
  else
  if S = 'pmnop' then
    Pm := pmNop
  else
  if S = 'pmnot' then
    Pm := pmNot
  else
  if S = 'pmcopy' then
    Pm := pmCopy
  else
  if S = 'pmnotcopy' then
    Pm := pmNotCopy
  else
  if S = 'pmmergepennot' then
    Pm := pmMergePenNot
  else
  if S = 'pmmaskpennot' then
    Pm := pmMaskPenNot
  else
  if S = 'pmmergenotpen' then
    Pm := pmMergeNotPen
  else
  if S = 'pmmasknotpen' then
    Pm := pmMaskNotPen
  else
  if S = 'pmmerge' then
    Pm := pmMerge
  else
  if S = 'pmnotmerge' then
    Pm := pmNotMerge
  else
  if S = 'pmmask' then
    Pm := pmMask
  else
  if S = 'pmnotmask' then
    Pm := pmNotMask
  else
  if S = 'pmxor' then
    Pm := pmXor
  else
  if S = 'pmnotxor' then
    Pm := pmNotXor
  else
    Result := False;
end;

procedure TJvTurtle.TextRotate(X, Y, Angle: Integer; AText: string;
  AFont: TFont);
var
  DC: HDC;
  Fnt: LOGFONT;
  HFnt, HFntPrev: HFONT;
  I: Integer;
  FontName: string;
begin
  if AText = '' then
    Exit;
  Fnt.lfEscapement := Angle * 10;
  Fnt.lfOrientation := Angle * 10;
  if fsBold in AFont.Style then
    Fnt.lfWeight := FW_BOLD
  else
    Fnt.lfWeight := FW_NORMAL;
  if fsItalic in AFont.Style then
    Fnt.lfItalic := 1
  else
    Fnt.lfItalic := 0;
  if fsUnderline in AFont.Style then
    Fnt.lfUnderline := 1
  else
    Fnt.lfUnderline := 0;
  Fnt.lfStrikeOut := 0;
  Fnt.lfHeight := Abs(AFont.Height);
  FontName := AFont.Name;
  for I := 1 to Length(FontName) do
    Fnt.lfFaceName[I - 1] := FontName[I];
  Fnt.lfFaceName[Length(FontName)] := #0;
  HFnt := CreateFontIndirect(Fnt);
  DC := Canvas.Handle;
  SetBkMode(DC, Transparent);
  SetTextColor(DC, AFont.Color);
  HFntPrev := SelectObject(DC, HFnt);
  TextOut(DC, X, Y, PChar(AText), Length(AText));
  SelectObject(DC, HFntPrev);
  DeleteObject(HFnt);
end;

function TJvTurtle.txAngle: string;
var
  X: Integer;
begin
  if GetNum(X) then
  begin
    SetHeading(X);
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['angle']);
end;

function TJvTurtle.txArea: string;
var
  X1, Y1, X2, Y2: Integer;
begin
  if GetNum(X1) and GetNum(Y1) and GetNum(X2) and GetNum(Y2) then
  begin
    Area := Rect(X1, Y1, X2, Y2);
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['area']);
end;

function TJvTurtle.txBrushColor: string;
var
  Col: TColor;
begin
  if GetCol(Col) then
  begin
    Canvas.Brush.Color := Col;
    Result := '';
  end
  else
    Result := Format(sInvalidColorIns, ['brushcolor']);
end;

function TJvTurtle.txBsClear: string;
begin
  Canvas.Brush.Style := bsClear;
  Result := '';
end;

function TJvTurtle.txBsSolid: string;
begin
  Canvas.Brush.Style := bsSolid;
  Result := '';
end;

function TJvTurtle.txCopy: string;
var
  X, Y: Integer;
begin
  X := Position.X;
  Y := Position.Y;
  with Area do
    Canvas.CopyRect(Rect(X, Y, X + Right - Left, Y + Bottom - Top), Canvas, Area);
  Result := '';
end;

function TJvTurtle.txCopyMode: string;
var
  S: string;
  CopyMode: TCopyMode;
begin
  Result := sInvalidCopyMode;
  if GetToken(S) then
  begin
    S := 'cm' + LowerCase(S);
    if StrToCopyMode(CopyMode, S) then
    begin
      Canvas.CopyMode := CopyMode;
      Result := '';
    end;
  end;
end;

function TJvTurtle.txDown: string;
begin
  PenDown := True;
  Result := '';
end;

function TJvTurtle.txEllipse: string;
var
  X2, Y2: Integer;
begin
  if GetNum(X2) and GetNum(Y2) then
  begin
    X2 := Position.X + X2;
    Y2 := Position.Y + Y2;
    Canvas.Ellipse(Position.X, Position.Y, X2, Y2);
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['ellipse']);
end;

function TJvTurtle.txGo: string;
var
  X: Integer;
begin
  if GetNum(X) then
  begin
    MoveForward(X);
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['go']);
end;

function TJvTurtle.txGoMark: string;
begin
  DoGo(Mark);
  Result := '';
end;

function TJvTurtle.txTurn: string;
var
  X: Integer;
begin
  if GetNum(X) then
  begin
    Turn(X);
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['turn']);
end;

function TJvTurtle.txLeft: string;
var
  X: Integer;
begin
  if GetNum(X) then
  begin
    Heading := Heading + X;
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['left']);
end;

function TJvTurtle.txRight: string;
var
  X: Integer;
begin
  if GetNum(X) then
  begin
    Heading := Heading - X;
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['right']);
end;

function TJvTurtle.txMark: string;
begin
  Mark := Position;
  Result := '';
end;

function TJvTurtle.txPenColor: string;
var
  Col: TColor;
begin
  if GetCol(Col) then
  begin
    Canvas.Pen.Color := Col;
    Result := '';
  end
  else
    Result := Format(sInvalidColorIns, ['pencolor']);
end;

function TJvTurtle.txPenMode: string;
var
  S: string;
  PenMode: TPenMode;
begin
  Result := sInvalidPenMode;
  if GetToken(S) then
  begin
    S := 'pm' + LowerCase(S);
    if StrToPenMode(PenMode, S) then
    begin
      Canvas.Pen.Mode := PenMode;
      Result := '';
    end;
  end;
end;

function TJvTurtle.txPenSize: string;
var
  Width: Integer;
begin
  if GetNum(Width) then
  begin
    Canvas.Pen.Width := Width;
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['pensize']);
end;

function TJvTurtle.txPos: string;
var
  X, Y: Integer;
begin
  if GetNum(X) and GetNum(Y) then
  begin
    Position := Point(X, Y);
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['pos']);
end;

function TJvTurtle.txRectangle: string;
var
  X2, Y2: Integer;
begin
  if GetNum(X2) and GetNum(Y2) then
  begin
    X2 := Position.X + X2;
    Y2 := Position.Y + Y2;
    Canvas.Rectangle(Position.X, Position.Y, X2, Y2);
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['rectangle']);
end;

function TJvTurtle.txText: string;
var
  S: string;
  A: Integer;
begin
  if GetTex(S) then
  begin
    A := Variant(Heading);
    TextRotate(Position.X, Position.Y, A, S, Canvas.Font);
    Result := '';
    DoRepaintRequest;
  end
  else
    Result := Format(sInvalidTextIns, ['text']);
end;

function TJvTurtle.txTextBold: string;
begin
  Canvas.Font.Style := Canvas.Font.Style + [fsBold];
  Result := '';
end;

function TJvTurtle.txTextColor: string;
var
  Col: TColor;
begin
  if GetCol(Col) then
  begin
    Canvas.Font.Color := Col;
    Result := '';
  end
  else
    Result := Format(sInvalidColorIns, ['textcolor']);
end;

function TJvTurtle.txTextFont: string;
var
  FontName: string;
begin
  if GetTex(FontName) then
  begin
    Canvas.Font.Name := FontName;
    Result := '';
  end
  else
    Result := sMissingFontname;
end;

function TJvTurtle.txTextItalic: string;
begin
  Canvas.Font.Style := Canvas.Font.Style + [fsItalic];
  Result := '';
end;

function TJvTurtle.txTextNormal: string;
begin
  Canvas.Font.Style := [];
  Result := '';
end;

function TJvTurtle.txTextSize: string;
var
  FontSize: Integer;
begin
  if GetNum(FontSize) then
  begin
    Canvas.Font.Size := FontSize;
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['fontsize']);
end;

function TJvTurtle.txTextUnderline: string;
begin
  Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
  Result := '';
end;

function TJvTurtle.txUp: string;
begin
  PenDown := False;
  Result := '';
end;

function TJvTurtle.txDo: string;
var
  Num: Integer;
begin
  if GetNum(Num) then
  begin
    Result := sStackOverflow;
    if Push(FIP) then
      if not Push(Num) then
        Result := '';
  end
  else
    Result := Format(sNumberExpectedIns, ['do']);
end;

function TJvTurtle.txLoop: string;
var
  Reps, Ret: Integer;
begin
  if Pop(Reps) and Pop(Ret) then
  begin
    Dec(Reps);
    if Reps <> 0 then
    begin
      FIP := Ret;
      Push(Ret);
      Push(Reps);
    end;
    Result := '';
  end
  else
    Result := sStackUnderflow;
end;

function TJvTurtle.txFlood: string;
var
  X, Y, XF, YF: Integer;
begin
  if GetNum(X) and GetNum(Y) then
  begin
    XF := Position.X + X;
    YF := Position.Y + Y;
    Canvas.FloodFill(XF, YF, Canvas.Pixels[XF, YF], fsSurface);
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['flood']);
end;

procedure TJvTurtle.SetOnRequestBackGround(const Value: TRequestBackGroundEvent);
begin
  FOnRequestBackGround := Value;
end;

procedure TJvTurtle.DoRequestBackground;
begin
  if Assigned(FOnRequestBackGround) then
    FOnRequestBackground(Self, FBackground);
end;

function TJvTurtle.txBackground: string;
var
  Name: string;
begin
  if GetTex(Name) then
  begin
    FBackground := Name;
    DoRequestBackground;
    Result := '';
  end
  else
    Result := Format(sInvalidTextIns, ['background']);
end;

function TJvTurtle.txTextOut: string;
var
  Text: string;
begin
  if GetTex(Text) then
  begin
    Canvas.TextOut(Position.X, Position.Y, Text);
    Result := '';
  end
  else
    Result := Format(sInvalidTextIns, ['text']);
end;

function TJvTurtle.txAddBrushColor: string;
var
  Color: TColor;
begin
  if GetCol(Color) then
  begin
    Canvas.Brush.Color := Canvas.Brush.Color + Color;
    Result := '';
  end
  else
    Result := Format(sInvalidColorIns, ['addbrushcolor']);
end;

function TJvTurtle.txAddPenColor: string;
var
  Color: TColor;
begin
  if GetCol(Color) then
  begin
    Canvas.Pen.Color := Canvas.Pen.Color + Color;
    Result := '';
  end
  else
    Result := Format(sInvalidColorIns, ['addbrushcolor']);
end;

function TJvTurtle.txGoMarkAngle: string;
begin
  Heading := FAngleMark;
  Result := '';
end;

function TJvTurtle.txMarkAngle: string;
begin
  FAngleMark := Variant(Heading);
  Result := '';
end;

function TJvTurtle.IsCol(Tex: string): Boolean;
var
  Msg: string;
begin
  try
    Result := NPush(Msg, StringToColor(Tex));
  except
    Result := False;
  end;
end;

function TJvTurtle.IsNum(Tex: string): Boolean;
var
  Msg: string;
begin
  try
    Result := NPush(Msg, StrToInt(Tex));
  except
    Result := False;
  end;
end;

function TJvTurtle.NPop(var Msg: string; var Num: Integer): Boolean;
begin
  Result := FNSP > 0;
  if Result then
  begin
    Dec(FNSP);
    Num := FNStack[FNSP];
    Msg := '';
  end
  else
    Msg := sNumberStackUnderflow;
end;

function TJvTurtle.NPush(var Msg: string; Num: Integer): Boolean;
begin
  try
    if FNSP >= Length(FNStack) then
      SetLength(FNStack, Length(FNStack) + 256);
    FNStack[FNSP] := Num;
    Inc(FNSP);
    Msg := '';
    Result := True;
  except
    Msg := sNumberStackOverflow;
    Result := False;
  end;
end;

function TJvTurtle.txComment: string;
begin
  while (FIP <= FIPMax) and (FScript[FIP] <> '}') do
    Inc(FIP);
  if FIP <= FIPMax then
  begin
    Inc(FIP);
    Result := '';
  end
  else
    Result := sMissingAfterComment;
end;
(*)

function TJvTurtle.SkipBlock: Boolean;
begin
  Result := False;
  while (FIP <= FIPMax) and (FScript[FIP] <> '[') do
    Inc(FIP);
  if FIP > FIPMax then
    Exit;
  Inc(FIP);
  while (FIP <= FIPMax) and (FScript[FIP] <> ']') do
    Inc(FIP);
  if FIP > FIPMax then
    Exit;
  Inc(FIP);
  Result := True;
end;
(*)

procedure TJvTurtle.SetOnRequestImageSize(const Value: TRequestImageSizeEvent);
begin
  FOnRequestImageSize := Value;
end;

function TJvTurtle.DoRequestImageSize: Boolean;
begin
  Result := Assigned(FOnRequestImageSize);
  if Result then
    FOnRequestImageSize(Self, FImageRect);
end;

function TJvTurtle.txGoBottom: string;
var
  NewPoint: TPoint;
begin
  if DoRequestImageSize then
  begin
    NewPoint := Point(Position.X, FImageRect.Bottom);
    DoGo(NewPoint);
    Result := '';
  end
  else
    Result := Format(sErrorIns, ['gobottom']);
end;

function TJvTurtle.txGoLeft: string;
var
  NewPoint: TPoint;
begin
  if DoRequestImageSize then
  begin
    NewPoint := Point(FImageRect.Left, Position.Y);
    DoGo(NewPoint);
    Result := '';
  end
  else
    Result := Format(sErrorIns, ['goleft']);
end;

function TJvTurtle.txGoRight: string;
var
  NewPoint: TPoint;
begin
  if DoRequestImageSize then
  begin
    NewPoint := Point(FImageRect.Right, Position.Y);
    DoGo(NewPoint);
    Result := '';
  end
  else
    Result := Format(sErrorIns, ['goright']);
end;

function TJvTurtle.txGoTop: string;
var
  NewPoint: TPoint;
begin
  if DoRequestImageSize then
  begin
    NewPoint := Point(Position.X, FImageRect.Top);
    DoGo(NewPoint);
    Result := '';
  end
  else
    Result := Format(sErrorIns, ['gotop']);
end;

function TJvTurtle.txDiv: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    if B <> 0 then
      NPush(Result, A div B)
    else
      Result := sDivisionByZero;
end;

function TJvTurtle.txDrop: string;
var
  A: Integer;
begin
  NPop(Result, A);
end;

function TJvTurtle.txDup: string;
var
  A: Integer;
begin
  if NPop(Result, A) then
  begin
    NPush(Result, A);
    NPush(Result, A);
  end;
end;

function TJvTurtle.txMul: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    NPush(Result, A * B);
end;

function TJvTurtle.txSub: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    NPush(Result, A - B);
end;

function TJvTurtle.txAdd: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    NPush(Result, A + B);
end;

function TJvTurtle.txGoCenter: string;
var
  CX, CY: Integer;
begin
  if DoRequestImageSize then
  begin
    CX := (FImageRect.Right - FImageRect.Left) div 2;
    CY := (FImageRect.Bottom - FImageRect.Top) div 2;
    DoGo(Point(CX, CY));
    Result := '';
  end
  else
    Result := Format(sErrorIns, ['gocenter']);
end;

function TJvTurtle.txDiamond: string;
var
  I, X: Integer;
  OldDown: Boolean;
begin
  Result := Format(sInvalidIntegerIns, ['diamond']);
  if GetNum(X) then
  begin
    OldDown := PenDown;
    PenDown := True;
    Turn(45);
    for I := 1 to 4 do
    begin
      MoveForward(X);
      Turn(-90);
    end;
    Turn(-45);
    PenDown := OldDown;
    Result := '';
  end;
end;

function TJvTurtle.txCurve: string;
var
  Pts: array [0..3] of TPoint;
  I: Integer;
begin
  if GetNum(Pts[1].X) and GetNum(Pts[1].Y) and
    GetNum(Pts[2].X) and GetNum(Pts[2].Y) and
    GetNum(Pts[3].X) and GetNum(Pts[3].Y) then
  begin
    Pts[0].X := Position.X;
    Pts[0].Y := Position.Y;
    for I := 1 to 3 do
    begin
      Pts[I].X := Position.X + Pts[I].X;
      Pts[I].Y := Position.Y + Pts[I].Y;
    end;
    Canvas.PolyBezier(Pts);
    Position := Pts[3];
    Result := '';
  end
  else
    Result := Format(sInvalidParameterIns, ['curve']);
end;

function TJvTurtle.txMove: string;
var
  X, Y: Integer;
begin
  if GetNum(X) and GetNum(Y) then
  begin
    Position := Point(Position.X + X, Position.Y + Y);
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['move']);
end;

procedure TJvTurtle.SetOnRequestFilter(const Value: TRequestFilterEvent);
begin
  FOnRequestFilter := Value;
end;

procedure TJvTurtle.DoRequestFilter;
begin
  if Assigned(FOnRequestFilter) then
    FOnRequestFilter(Self, FFilter);
end;

function TJvTurtle.txFilter: string;
var
  AName: string;
begin
  if GetTex(AName) then
  begin
    FFilter := AName;
    DoRequestFilter;
    Result := '';
  end
  else
    Result := Format(sInvalidTextIns, ['filter']);
end;

function TJvTurtle.txUser(Sym: string): string;
var
  P: Integer;
begin
  P := Pos(Sym, FScript);
  if P <> 0 then
  begin
    if Push(FIP) then
    begin
      FIP := P + Length(Sym);
      Result := '';
    end
    else
      Result := sStackOverflow;
  end
  else
    Result := Format(sSymbolsIsNotDefined, [Sym]);
end;

function TJvTurtle.txBlock: string;
begin
  while (FIP <= FIPMax) and (FScript[FIP] <> ']') do
    Inc(FIP);
  if FIP <= FIPMax then
  begin
    Inc(FIP);
    Result := '';
  end
  else
    Result := sMissingAfterBlock;
end;

function TJvTurtle.txReturn: string;
var
  Num: Integer;
begin
  if Pop(Num) then
  begin
    FIP := Num;
    Result := '';
  end
  else
    Result := sStackUnderflow;
end;

function TJvTurtle.tx_Angle: string;
var
  Num: Integer;
begin
  Num := Variant(Heading);
  NPush(Result, Num);
end;

function TJvTurtle.tx_Bottom: string;
begin
  if DoRequestImageSize then
    NPush(Result, FImageRect.Bottom)
  else
    Result := Format(sErrorIns, ['=bottom']);
end;

function TJvTurtle.tx_BrushColor: string;
begin
  NPush(Result, Canvas.Brush.Color);
end;

function TJvTurtle.tx_Left: string;
begin
  if DoRequestImageSize then
    NPush(Result, FImageRect.Left)
  else
    Result := Format(sErrorIns, ['=left']);
end;

function TJvTurtle.tx_Loop: string;
var
  Num: Integer;
begin
  if Pop(Num) then
  begin
    Push(Num);
    NPush(Result, Num);
  end
  else
    Result := Format(sStackUnderflowIns, ['=loop']);
end;

function TJvTurtle.tx_MarkX: string;
begin
  NPush(Result, Mark.X);
end;

function TJvTurtle.tx_MarkY: string;
begin
  NPush(Result, Mark.Y);
end;

function TJvTurtle.tx_PenColor: string;
begin
  NPush(Result, Canvas.Pen.Color);
end;

function TJvTurtle.tx_PosX: string;
begin
  NPush(Result, Position.X);
end;

function TJvTurtle.tx_PosY: string;
begin
  NPush(Result, Position.Y);
end;

function TJvTurtle.tx_Right: string;
begin
  if DoRequestImageSize then
    NPush(Result, FImageRect.Right)
  else
    Result := Format(sErrorIns, ['=right']);
end;

function TJvTurtle.tx_Top: string;
begin
  if DoRequestImageSize then
    NPush(Result, FImageRect.Top)
  else
    Result := Format(sErrorIns, ['=top']);
end;

function TJvTurtle.tx_PenSize: string;
begin
  NPush(Result, Canvas.Pen.Width);
end;

function TJvTurtle.tx_TextColor: string;
begin
  NPush(Result, Canvas.Font.Color);
end;

function TJvTurtle.tx_TextSize: string;
begin
  NPush(Result, Canvas.Font.Size);
end;

function TJvTurtle.txIf: string;
var
  Num: Integer;
  Token: string;
begin
  if NPop(Result, Num) then
    if Num = 0 then
      if GetToken(Token) then
        Result := ''
      else
        Result := sSymbolExpectedAfterIf;
end;

function TJvTurtle.txAnd: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    NPush(Result, Ord((A <> 0) and (B <> 0)));
end;

function TJvTurtle.txEq: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    NPush(Result, Ord(A = B));
end;

function TJvTurtle.txGe: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    NPush(Result, Ord(A >= B));
end;

function TJvTurtle.txGt: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    NPush(Result, Ord(A > B));
end;

function TJvTurtle.txLe: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    NPush(Result, Ord(A <= B));
end;

function TJvTurtle.txLt: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    NPush(Result, Ord(A < B));
end;

function TJvTurtle.txNe: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    NPush(Result, Ord(A <> B));
end;

function TJvTurtle.txNot: string;
var
  A: Integer;
begin
  if NPop(Result, A) then
    NPush(Result, Ord(A = 0))
end;

function TJvTurtle.txOr: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    NPush(Result, Ord((A <> 0) or (B <> 0)));
end;

function TJvTurtle.txAbs: string;
var
  A: Integer;
begin
  if NPop(Result, A) then
    NPush(Result, Abs(A))
end;

function TJvTurtle.txNeg: string;
var
  A: Integer;
begin
  if NPop(Result, A) then
    NPush(Result, -A);
end;

function TJvTurtle.txSwap: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
  begin
    NPush(Result, B);
    NPush(Result, A);
  end;
end;

function TJvTurtle.txMax: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    NPush(Result, Max(A, B));
end;

function TJvTurtle.txMin: string;
var
  A, B: Integer;
begin
  if NPop(Result, B) and NPop(Result, A) then
    NPush(Result, Min(A, B));
end;

function TJvTurtle.txSqr: string;
var
  A: Integer;
begin
  if NPop(Result, A) then
    NPush(Result, Variant(Sqr(A)));
end;

function TJvTurtle.txSqrt: string;
var
  A: Integer;
begin
  if NPop(Result, A) then
    if A <> 0 then
      NPush(Result, Variant(Sqrt(A)))
    else
      Result := sCanNotTakeSqrtOf;
end;

function TJvTurtle.txDec: string;
var
  A: Integer;
begin
  if NPop(Result, A) then
    NPush(Result, A-1);
end;

function TJvTurtle.txInc: string;
var
  A: Integer;
begin
  if NPop(Result, A) then
    NPush(Result, A+1);
end;

function TJvTurtle.txPolygon: string;
var
  I, S, N: Integer;
  OldDown: Boolean;
  OldHeading, A: Real;
  Pt: TPoint;
begin
  Result := Format(sInvalidIntegerIns, ['polygon']);
  if not (GetNum(N) and GetNum(S)) then
    Exit;
  Result := Format(sNotAllowedIns, ['polygon']);
  if (N = 0) or (S = 0) then
    Exit;
  Result := Format(sNeedMinimumOfSidesIns, ['polygon']);
  if N < 3 then
    Exit;
  OldHeading := Heading;
  Pt := Position;
  OldDown := PenDown;
  PenDown := True;
  A := 360 / N;
  for I := 1 to N - 1 do
  begin
    MoveForward(S);
    Turn(A);
  end;
  Canvas.LineTo(Pt.X, Pt.Y);
  PenDown := OldDown;
  Heading := OldHeading;
  Position := Pt;
  Result := '';
end;

function TJvTurtle.txStar: string;
var
  I, S, am, N: Integer;
  OldDown: Boolean;
  A, OldHeading: Real;
  Pt: TPoint;
begin
  Result := Format(sInvalidIntegerIns, ['star']);
  if not (GetNum(N) and GetNum(S)) then
    Exit;
  Result := Format(sNotAllowedIns, ['star']);
  if (N = 0) or (S = 0) then
    Exit;
  Result := Format(sNeedMinimumOfSidesIns, ['star']);
  if N < 3 then
    Exit;
  Result := Format(sMaximumSidesExceededIns, ['star']);
  if N > 12 then
    Exit;
  case N of
    5:
      am := 2;
    7:
      am := 3;
    9:
      am := 4;
    11:
      am := 5;
  else
    am := 1;
  end;
  OldHeading := Heading;
  Pt := Position;
  OldDown := PenDown;
  PenDown := True;
  A := am * 360 / N;
  for I := 1 to N - 1 do
  begin
    MoveForward(S);
    Turn(A);
  end;
  Canvas.LineTo(Pt.X, Pt.Y);
  PenDown := OldDown;
  Heading := OldHeading;
  Position := Pt;
  Result := '';
end;

function TJvTurtle.txLineTo: string;
var
  X, Y: Integer;
begin
  if GetNum(X) and GetNum(Y) then
  begin
    Canvas.MoveTo(Position.X, Position.Y);
    Canvas.LineTo(Position.X + X, Position.Y + Y);
    Position := Point(Position.X + X, Position.Y + Y);
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['lineto']);
end;

function TJvTurtle.txRoundRect: string;
var
  X2, Y2, RX, RY: Integer;
begin
  if GetNum(X2) and GetNum(Y2) and GetNum(RX) and GetNum(RY) then
  begin
    X2 := Position.X + X2;
    Y2 := Position.Y + Y2;
    Canvas.RoundRect(Position.X, Position.Y, X2, Y2, RX, RY);
    Result := '';
  end
  else
    Result := Format(sInvalidIntegerIns, ['roundrect']);
end;

function TJvTurtle.txDefault: string;
begin
  Result := '';
  Heading := 0;
  Position := Point(0, 0);
  PenDown := False;
  Canvas.Pen.Color := clWindowText;  // (rom) from clBlack
  Canvas.Brush.Color := clWindow;    // (rom) from clWhite
  Canvas.Font.Color := clWindowText; // (rom) added
  Canvas.CopyMode := cmSrcCopy;
  Mark := Position;
  Area := Rect(0, 0, 0, 0);
end;

function TJvTurtle.txIn: string;
var
  Token: string;
  Num: Integer;
begin
  if NPop(Result, Num) then
    if GetToken(Token) then
    begin
      if FPot.IndexOfName(Token) < 0 then
        FPot.Add(Token + '=' + IntToStr(Num))
      else
        FPot.Values[Token] := IntToStr(Num);
      Result := '';
    end
    else
      Result := sTokenExpected;
end;

function TJvTurtle.IsVar(Tex: string): Boolean;
var
  Num: Integer;
  Msg, S: string;
begin
  S := FPot.Values[Tex];
  if S <> '' then
    try
      Num := StrToInt(S);
      Result := NPush(Msg, Num);
    except
      Result := False;
    end
  else
    Result := False;
end;

function TJvTurtle.txInAdd: string;
var
  Token: string;
  Index, Num: Integer;
begin
  if NPop(Result, Num) then
    if GetToken(Token) then
    begin
      Index := FPot.IndexOfName(Token);
      if Index >= 0 then
      begin
        FPot.Values[Token] := IntToStr(StrToInt(FPot.Values[Token]) + Num);
        Result := '';
      end
      else
        Result := Format(ssDoesNotExist, [Token]);
    end
    else
      Result := sTokenExpected;
end;

function TJvTurtle.txInDiv: string;
var
  Token: string;
  Num: Integer;
begin
  if NPop(Result, Num) then
    if GetToken(Token) then
    begin
      if FPot.IndexOfName(Token) >= 0 then
      begin
        FPot.Values[Token] := IntToStr(StrToInt(FPot.Values[Token]) - Num);
        Result := '';
      end
      else
        Result := Format(ssDoesNotExist, [Token]);
    end
    else
      Result := sTokenExpected;
end;

function TJvTurtle.txInMult: string;
var
  Token: string;
  Num: Integer;
begin
  if NPop(Result, Num) then
    if GetToken(Token) then
    begin
      if FPot.IndexOfName(Token) >= 0 then
      begin
        FPot.Values[Token] := IntToStr(StrToInt(FPot.Values[Token]) * Num);
        Result := '';
      end
      else
        Result := Format(ssDoesNotExist, [Token]);
    end
    else
      Result := sTokenExpected;
end;

function TJvTurtle.txInSub: string;
var
  Token: string;
  Num: Integer;
begin
  if NPop(Result, Num) then
  begin
    if Num = 0 then
      Result := sDivisionByZeroNotAllowedInIn
    else
    if GetToken(Token) then
    begin
      if FPot.IndexOfName(Token) >= 0 then
      begin
        FPot.Values[Token] := IntToStr(StrToInt(FPot.Values[Token]) div Num);
        Result := '';
      end
      else
        Result := Format(ssDoesNotExist, [Token]);
    end
    else
      Result := sTokenExpected;
  end;
end;

function TJvTurtle.txInDec: string;
var
  Token: string;
begin
  if GetToken(Token) then
  begin
    if FPot.IndexOfName(Token) >= 0 then
    begin
      FPot.Values[Token] := IntToStr(StrToInt(FPot.Values[Token]) - 1);
      Result := '';
    end
    else
      Result := Format(ssDoesNotExist, [Token]);
  end
  else
    Result := sTokenExpected;
end;

function TJvTurtle.txInInc: string;
var
  Token: string;
begin
  if GetToken(Token) then
  begin
    if FPot.IndexOfName(Token) >= 0 then
    begin
      FPot.Values[Token] := IntToStr(StrToInt(FPot.Values[Token]) + 1);
      Result := '';
    end
    else
      Result := Format(ssDoesNotExist, [Token]);
  end
  else
    Result := sTokenExpected;
end;

end.

