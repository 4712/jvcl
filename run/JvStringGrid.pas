{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain A copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvStringGrid.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is S�bastien Buysse [sbuysse@buypin.com]
Portions created by S�bastien Buysse are Copyright (C) 2001 S�bastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck@bigfoot.com].

Last Modified: 2002-09-18

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvStringGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Grids,
  JvTypes, JVCLVer, JvJCLUtils;

const
  GM_ACTIVATECELL = WM_USER + 123;

type
  // (rom) renamed elements made packed
  TGMActivateCell = packed record
    Msg: Cardinal;
    Column: integer;
    Row: integer;
    Result: integer;
  end;

  TJvStringGrid = class;
  TExitCellEvent = procedure(Sender: TJvStringGrid; AColumn, ARow: integer;
    const EditText: string) of object;
  TGetCellAlignmentEvent = procedure(Sender: TJvStringGrid; AColumn, ARow: integer;
    State: TGridDrawState; var CellAlignment: TAlignment) of object;
  TCaptionClickEvent = procedure(Sender: TJvStringGrid; AColumn, ARow: integer) of object;
  TJvSortType = (stNone, stAutomatic, stClassic, stCaseSensitive, stNumeric, stDate, stCurrency);
  TProgress = procedure(Sender: TObject; Progression, Total: integer) of object;

  TJvStringGrid = class(TStringGrid)
  private
    FAboutJVCL: TJVCLAboutInfo;
    FAlignment: TAlignment;
    FSetCanvasProperties: TDrawCellEvent;
    FGetCellAlignment: TGetCellAlignmentEvent;
    FCaptionClick: TCaptionClickEvent;
    FCellOnMouseDown: TGridCoord;
    FOnMouseEnter: TNotifyEvent;
    FHintColor: TColor;
    FSaved: TColor;
    FOnMouseLeave: TNotifyEvent;
    FOnCtl3DChanged: TNotifyEvent;
    FOnParentColorChanged: TNotifyEvent;
    FOver: boolean;
    FOnExitCell: TExitCellEvent;
    FOnLoadProgress: TProgress;
    FOnSaveProgress: TProgress;
    FOnHorizontalScroll: TNotifyEvent;
    FOnVerticalScroll: TNotifyEvent;
    FFixedFont: TFont;
    procedure GMActivateCell(var Msg: TGMActivateCell); message GM_ACTIVATECELL;
    procedure SetAlignment(const Value: TAlignment);
    procedure WMCommand(var Msg: TWMCommand); message WM_COMMAND;
    procedure SetFixedFont(const Value: TFont);
    procedure DoFixedFontChange(Sender: TObject);
  protected
    function CreateEditor: TInplaceEdit; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure ExitCell(const EditText: string; AColumn, ARow: integer); virtual;
    procedure SetCanvasProperties(AColumn, ARow: Longint;
      Rect: TRect; State: TGridDrawState); virtual;
    procedure DrawCell(AColumn, ARow: Longint;
      Rect: TRect; State: TGridDrawState); override;
    procedure CaptionClick(AColumn, ARow: Longint); dynamic;
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure CMCtl3DChanged(var Msg: TMessage); message CM_CTL3DCHANGED;
    procedure CMParentColorChanged(var Msg: TMessage); message CM_PARENTCOLORCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetCellAlignment(AColumn, ARow: Longint;
      State: TGridDrawState): TAlignment; virtual;
    procedure DefaultDrawCell(AColumn, ARow: Longint;
      Rect: TRect; State: TGridDrawState); virtual;
    procedure ActivateCell(AColumn, ARow: integer);
    procedure InvalidateCell(AColumn, ARow: integer);
    procedure InvalidateCol(AColumn: integer);
    procedure InvalidateRow(ARow: integer);
    property InplaceEditor;
    // Calculates and sets the width of a specific column or all columns if Index < 0
    // based on the text in the affected Cells.
    // MinWidth is the minimum width of the column(s). If MinWidth is < 0,
    // DefaultColWidth is used instead
    procedure AutoSizeCol(Index, MinWidth: integer);
    // Inserts a new row at the specified Index and moves all existing rows >= Index down one step
    // Returns the inserted row as an empty TStrings
    function InsertRow(Index: integer): TStrings;
    // Inserts a new column at the specified Index and moves all existing columns >= Index to the right
    // Returns the inserted column as an empty TStrings
    function InsertCol(Index: integer): TStrings;
    // Removes the row at Index and moves all rows > Index up one step
    procedure RemoveRow(Index: integer);
    // Removes the column at Index and moves all cols > Index to the left
    procedure RemoveCol(Index: integer);
    // Hides the row at Index by setting it's height = -1
    // Calling this method repeatedly does nothing (the row retains it's Index even if it's hidden)
    procedure HideRow(Index: integer);
    // Shows the row at Index by setting it's height to AHeight
    // if AHeight <= 0, DefaultRowHeight is used instead
    procedure ShowRow(Index, AHeight: integer);
    // Hides the column at Index by setting it's ColWidth = -1
    // Calling this method repeatedly does nothing (the column retains it's Index even if it's hidden)
    procedure HideCol(Index: integer);
    // Returns true if the Cell at ACol/ARow is hidden, i.e if it's RowHeight or ColWidth < 0
    function IsHidden(ACol, ARow: integer): boolean;
    // Shows the column at Index by setting it's width to AWidth
    // If AWidth <= 0, DefaultColWidth is used instead
    procedure ShowCol(Index, AWidth: integer);
    // HideCell hides a cell by hiding the row and column that it belongs to.
    // This means that both a row and a column is hidden
    procedure HideCell(ACol, ARow: integer);
    // ShowCell shows a previously hidden cell by showing it's corresponding row and column and
    // using AWidth/AHeight to set it's size. If AWidth < 0, DefaultColWidth is used instead.
    // If AHeight < 0, DefaultRowHeight is used instead. If one dimension of the Cell wasn't
    // hidden, nothing happens to that dimension (i.e if ColWidth < 0 but RowHeight := 24, only ColWidth is
    // changed to AWidth
    procedure ShowCell(ACol, ARow, AWidth, AHeight: integer);
    // Removes the content in the Cells but does not remove any rows or columns
    procedure Clear;

    // Hides all rows and columns
    procedure HideAll;
    // Shows all hidden rows and columns, setting their width/height to AWidth/AHeight as necessary
    // If AWidth < 0, DefaultColWidth is used. If AHeight < 0, DefaultRowHeight is used
    procedure ShowAll(AWidth, AHeight: integer);

    procedure SortGrid(Column: integer; Ascending: boolean = true; Fixed: boolean = false;
      SortType: TJvSortType = stClassic; BlankTop: boolean = true);
    procedure SaveToFile(FileName: string);
    procedure LoadFromFile(FileName: string);
    procedure LoadFromCSV(FileName: string; Separator: char = ';'; QuoteChar: char = '"');
    procedure SaveToCSV(FileName: string; Separator: char = ';'; QuoteChar: char = '"');
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
  published
    property AboutJVCL: TJVCLAboutInfo read FAboutJVCL write FAboutJVCL stored false;
    property HintColor: TColor read FHintColor write FHintColor default clInfoBk;
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property FixedFont: TFont read FFixedFont write SetFixedFont;
    property OnExitCell: TExitCellEvent read FOnExitCell write FOnExitCell;
    property OnSetCanvasProperties: TDrawCellEvent read FSetCanvasProperties write FSetCanvasProperties;
    property OnGetCellAlignment: TGetCellAlignmentEvent read FGetCellAlignment write FGetCellAlignment;
    property OnCaptionClick: TCaptionClickEvent read FCaptionClick write FCaptionClick;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnCtl3DChanged: TNotifyEvent read FOnCtl3DChanged write FOnCtl3DChanged;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
    property OnLoadProgress: TProgress read FOnLoadProgress write FOnLoadProgress;
    property OnSaveProgress: TProgress read FOnSaveProgress write FOnSaveProgress;
    property OnVerticalScroll: TNotifyEvent read FOnVerticalScroll write FOnVerticalScroll;
    property OnHorizontalScroll: TNotifyEvent read FOnHorizontalScroll write FOnHorizontalScroll;
  end;

implementation
uses
  Math;

const
  BufSize = 1024;
//=== TExInplaceEdit =========================================================

type
  TExInplaceEdit = class(TInplaceEdit)
  private
    FLastCol: integer;
    FLastRow: integer;
    procedure WMKillFocus(var Msg: TMessage); message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg: TMessage); message WM_SETFOCUS;
  public
    procedure CreateParams(var Params: TCreateParams); override;
  end;

procedure TExInplaceEdit.CreateParams(var Params: TCreateParams);
const
  Flags: array[TAlignment] of DWORD = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or Flags[TJvStringGrid(Grid).Alignment];
end;

procedure TExInplaceEdit.WMKillFocus(var Msg: TMessage);
begin
  TJvStringGrid(Grid).ExitCell(Text, FLastCol, FLastRow);
  inherited;
end;

procedure TExInplaceEdit.WMSetFocus(var Msg: TMessage);
begin
  FLastCol := TJvStringGrid(Grid).Col;
  FLastRow := TJvStringGrid(Grid).Row;
  inherited;
end;

//=== TJvStringGrid ==========================================================

constructor TJvStringGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFixedFont := TFont.Create;
  FFixedFont.Assign(Font);
  FFixedFont.OnChange := DoFixedFontChange;
  FHintColor := clInfoBk;
  FOver := false;
  ControlStyle := ControlStyle + [csAcceptsControls];
end;

destructor TJvStringGrid.Destroy;
begin
  FreeAndNil(FFixedFont);
  inherited;
end;

procedure TJvStringGrid.CMCtl3DChanged(var Msg: TMessage);
begin
  inherited;
  if Assigned(FOnCtl3DChanged) then
    FOnCtl3DChanged(Self);
end;

procedure TJvStringGrid.CMParentColorChanged(var Msg: TMessage);
begin
  inherited;
  if Assigned(FOnParentColorChanged) then
    FOnParentColorChanged(Self);
end;

procedure TJvStringGrid.SortGrid(Column: integer; Ascending,
  Fixed: boolean; SortType: TJvSortType; BlankTop: boolean);
const
  cFloatDelta = 0.01;
var
  St: string;
  TmpC: Currency;
  TmpF: Extended;
  TmpD: TDateTime;
  LStart: integer;
  lEnd: integer;

  procedure ExchangeGridRows(i, j: integer);
  var
    K: integer;
  begin
    if Fixed then
      for K := 0 to ColCount - 1 do
        Cols[K].Exchange(i, j)
    else
      for K := FixedCols to ColCount - 1 do
        Cols[K].Exchange(i, j);
  end;

  function IsSmaller(First, Second: string): boolean;

    function DetectType(const S1, S2: string): TJvSortType;
    var
      ExtValue: Extended;
      CurrValue: Currency;
      DateValue: TDateTime;
    begin
      if TextToFloat(PChar(S1), ExtValue, fvExtended) and TextToFloat(PChar(S2), ExtValue, fvExtended) then
        Result := stNumeric
      else if TextToFloat(PChar(S1), CurrValue, fvCurrency) and TextToFloat(PChar(S2), CurrValue, fvCurrency) then
        Result := stCurrency
      else if TryStrToDateTime(S1, DateValue) and TryStrToDateTime(S2, DateValue) then
        Result := stDate
      else
        Result := stClassic;
    end;
  begin
    case DetectType(First, Second) of
      stNumeric:
        Result := StrToFloat(First) < StrToFloat(Second);
      stCurrency:
        Result := StrToCurr(First) < StrToCurr(Second);
      stDate:
        Result := StrToDateTime(First) < StrToDateTime(Second);
      stClassic:
        Result := CompareText(First, Second) < 0;
    else
      Result := First > Second;
    end;
  end;

  function IsBigger(First, Second: string): boolean;
  begin
    Result := IsSmaller(Second, First);
  end;
  // (rom) A HeapSort has no worst case for O(X)
  // (rom) I donated one a long time ago to JCL
  // (p3) maybe implemented a secondary sort index when items are equal?
  // (p3) ...or use another stable sort method, like heapsort

  procedure QuickSort(L, R: integer);
  var
    i, j, m: integer;
  begin
    repeat
      i := L;
      j := R;
      m := (L + R) div 2;
      St := Cells[Column, m];
      repeat
        case SortType of
          stClassic:
            begin
              while (CompareText(Cells[Column, i], St) < 0) do
                Inc(i);
              while (CompareText(Cells[Column, j], St) > 0) do
                Dec(j);
            end;
          stCaseSensitive:
            begin
              while (CompareStr(Cells[Column, i], St) < 0) do
                Inc(i);
              while (CompareStr(Cells[Column, j], St) > 0) do
                Dec(j);
            end;
          stNumeric:
            begin
              TmpF := StrToFloat(St);
              while StrToFloat(Cells[Column, i]) < TmpF do
                Inc(i);
              while StrToFloat(Cells[Column, j]) > TmpF do
                Dec(j);
            end;
          stDate:
            begin
              TmpD := StrToDateTime(St);
              while (StrToDateTime(Cells[Column, i]) < TmpD) do
                Inc(i);
              while (StrToDateTime(Cells[Column, j]) > TmpD) do
                Dec(j);
            end;
          stCurrency:
            begin
              TmpC := StrToCurr(St);
              while (StrToCurr(Cells[Column, i]) < TmpC) do
                Inc(i);
              while (StrToCurr(Cells[Column, j]) > TmpC) do
                Dec(j);
            end;
          stAutomatic:
            begin
              while (IsSmaller(Cells[Column, i], St)) do
                Inc(i);
              while IsBigger(Cells[Column, j], St) do
                Dec(j);
            end;
        end;
        if i <= j then
        begin
          if i <> j then
            ExchangeGridRows(i, j);
          Inc(i);
          Dec(j);
        end;
      until (i > j);
      if L < j then
        QuickSort(L, j);
      L := i;
    until i >= R;
  end;

  procedure InvertGrid;
  var
    i, j: integer;
  begin
    if Fixed then
      i := 0
    else
      i := FixedRows;
    j := RowCount - 1;
    while i < j do
    begin
      ExchangeGridRows(i, j);
      Inc(i);
      Dec(j);
    end;
  end;

  function MoveBlankTop: integer;
  var
    i, j: integer;
  begin
    if Fixed then
      i := 0
    else
      i := FixedRows;
    Result := i;
    j := RowCount - 1;
    while i <= j do
    begin
      if Trim(Cells[Column, i]) = '' then
      begin
        ExchangeGridRows(Result, i);
        Inc(Result);
      end;
      Inc(i);
    end;
  end;
  procedure MoveBlankBottom;
  var
    i, j: integer;
    DoSort: boolean;
  begin
    if Fixed then
      i := 0
    else
      i := FixedRows;
    DoSort := false;
    // avoid empty columns
    for j := i to RowCount - 1 do
      if Cells[Column, j] <> '' then
      begin
        DoSort := true;
        Break;
      end;
    if not DoSort then Exit;
    // this is already sorted, so blank items should be at top
    while Trim(Cells[Column, i]) = '' do
    begin
      InsertRow(RowCount).Assign(Rows[i]);
      DeleteRow(i);
      Inc(j);
      if j >= RowCount then Exit;
    end;
  end;

begin
  // (p3) NB!! sorting might trigger the OnExitCell, OnGetEditText and OnSetEditText events!
  // make sure you don't do anything in these events
  if (Column >= 0) and (Column < ColCount) and (SortType <> stNone) then
  begin
    if Fixed then
      LStart := 0
    else
      LStart := FixedRows;
    lEnd := RowCount - 1;
    if BlankTop then
      LStart := MoveBlankTop;
    if LStart < LEnd then
    begin
      QuickSort(LStart, lEnd);
      if not BlankTop then
        MoveBlankBottom;
      if not Ascending then
        InvertGrid;
    end;
  end;
end;

procedure TJvStringGrid.LoadFromFile(FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  // (rom) secured
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TJvStringGrid.LoadFromCSV(FileName: string; Separator: char = ';'; QuoteChar: char = '"');
var
  St, st2: string;
  i, j, K, L, m, N: integer;
  fich: TextFile;
  FilePos, Count: integer;
  f: file of byte;
begin
  FilePos := 0;
  AssignFile(f, FileName);
  Reset(f);
  Count := FileSize(f);
  CloseFile(f);
  if Assigned(FOnLoadProgress) then
    FOnLoadProgress(Self, FilePos, Count);

  AssignFile(fich, FileName);
  Reset(fich);
  K := 0;
  while not EOF(fich) do
  begin
    ReadLn(fich, St);
    FilePos := FilePos + Length(St) + 2;
    if Assigned(FOnLoadProgress) then
      FOnLoadProgress(Self, FilePos, Count);

    //Analyse St
    j := 0;
    L := 1;
    for i := 1 to Length(St) do
      if St[i] = QuoteChar then
        j := (j + 1) mod 2
      else if St[i] = Separator then
        if j = 0 then
          Inc(L);
    if ColCount < L then
      ColCount := L;
    Inc(K);
    if RowCount < K then
      RowCount := K;

    j := 0;
    m := Pos(Separator, St);
    N := Pos(QuoteChar, St);
    while m <> 0 do
    begin
      if (N = 0) or (N > m) then
      begin
        Cells[j, K - 1] := Copy(St, 1, m - 1);
        St := Copy(St, m + 1, Length(St));
      end
      else
      begin
        St := Copy(St, N + 1, Length(St));
        N := Pos(QuoteChar, St);
        st2 := Copy(St, 1, N - 1);
        St := Copy(St, N + 1, Length(St));
        m := Pos(Separator, St);
        if m <> 0 then
          St := Copy(St, m + 1, Length(St))
        else
          St := '';
        Cells[j, K - 1] := st2;
      end;
      Inc(j);

      m := Pos(Separator, St);
      N := Pos(QuoteChar, St);
    end;
    if St <> '' then
      Cells[j, K - 1] := St;
  end;
  if Assigned(FOnLoadProgress) then
    FOnLoadProgress(Self, Count, Count);
  CloseFile(fich);
end;

procedure TJvStringGrid.LoadFromStream(Stream: TStream);
var
  Col, Rom, i, Count: integer;
  Buffer: array[0..BufSize - 1] of byte;
  St: string;
begin
  Col := 0;
  Rom := 1;
  if Assigned(FOnLoadProgress) then
    FOnLoadProgress(Self, 0, Stream.Size);
  while Stream.Position < Stream.Size do
  begin
    Count := Stream.Read(Buffer, 1024);
    if Assigned(FOnLoadProgress) then
      FOnLoadProgress(Self, Stream.Position, Stream.Size);
    for i := 0 to Count - 1 do
      case Buffer[i] of
        0:
          begin
            Inc(Col);
            if Rom > RowCount then
              RowCount := Rom;
            if Col > ColCount then
              ColCount := Col;
            Cells[Col - 1, Rom - 1] := St;
            St := '';
          end;
        1:
          begin
            Inc(Col);
            if Col > ColCount then
              ColCount := Col;
            Cells[Col - 1, Rom - 1] := St;
            Inc(Rom);
            if Rom > RowCount then
              RowCount := Row;
            Col := 0;
            St := '';
          end;
      else
        St := St + char(Buffer[i]);
      end;
  end;
  RowCount := RowCount - 1;
  if Assigned(FOnLoadProgress) then
    FOnLoadProgress(Self, Stream.Size, Stream.Size);
end;

procedure TJvStringGrid.WMHScroll(var Msg: TWMHScroll);
begin
  inherited;
  if Assigned(FOnHorizontalScroll) then
    FOnHorizontalScroll(Self);
end;

procedure TJvStringGrid.WMVScroll(var Msg: TWMVScroll);
begin
  inherited;
  if Assigned(FOnVerticalScroll) then
    FOnVerticalScroll(Self);
end;

procedure TJvStringGrid.CMMouseEnter(var Msg: TMessage);
begin
  if not FOver then
  begin
    FSaved := Application.HintColor;
    // for D7...
    if csDesigning in ComponentState then
      Exit;
    Application.HintColor := FHintColor;
    FOver := true;
  end;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;

procedure TJvStringGrid.CMMouseLeave(var Msg: TMessage);
begin
  if FOver then
  begin
    Application.HintColor := FSaved;
    FOver := false;
  end;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure TJvStringGrid.SaveToFile(FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyWrite);
  // (rom) secured
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TJvStringGrid.SaveToCSV(FileName: string; Separator: char = ';'; QuoteChar: char = '"');
var
  St: string;
  i, j: integer;
  fich: TextFile;
begin
  AssignFile(fich, FileName);
  Rewrite(fich);
  if Assigned(FOnSaveProgress) then
    FOnSaveProgress(Self, 0, RowCount * ColCount);
  for i := 0 to RowCount - 1 do
  begin
    St := '';
    for j := 0 to ColCount - 1 do
    begin
      if Assigned(FOnSaveProgress) then
        FOnSaveProgress(Self, i * ColCount + j, RowCount * ColCount);
      if Pos(Separator, Cells[j, i]) = 0 then
        St := St + Cells[j, i]
      else
        St := St + QuoteChar + Cells[j, i] + QuoteChar;
      if j <> ColCount - 1 then
        St := St + Separator
    end;
    Writeln(fich, St);
  end;
  CloseFile(fich);
  if Assigned(FOnSaveProgress) then
    FOnSaveProgress(Self, RowCount * ColCount, RowCount * ColCount);
end;

procedure TJvStringGrid.SaveToStream(Stream: TStream);
var
  i, j, K: integer;
  St: array[0..BufSize - 1] of char;
  Stt: string;
  A, B: byte;
begin
  A := 0;
  B := 1; // A for end of string, B for end of line
  if Assigned(FOnSaveProgress) then
    FOnSaveProgress(Self, 0, RowCount * ColCount);
  for i := 0 to RowCount - 1 do
  begin
    for j := 0 to ColCount - 1 do
    begin
      if Assigned(FOnSaveProgress) then
        FOnSaveProgress(Self, i * ColCount + j, RowCount * ColCount);
      Stt := Cells[j, i];
      for K := 1 to Length(Stt) do
        St[K - 1] := Stt[K];
      Stream.Write(St, Length(Cells[j, i]));
      if j <> ColCount - 1 then
        Stream.Write(A, 1);
    end;
    Stream.Write(B, 1);
  end;
  if Assigned(FOnSaveProgress) then
    FOnSaveProgress(Self, RowCount * ColCount, RowCount * ColCount);
end;

procedure TJvStringGrid.ActivateCell(AColumn, ARow: integer);
begin
  PostMessage(Handle, GM_ACTIVATECELL, AColumn, ARow);
end;

procedure TJvStringGrid.CaptionClick(AColumn, ARow: integer);
begin
  if Assigned(FCaptionClick) then
    FCaptionClick(Self, AColumn, ARow);
end;

function TJvStringGrid.CreateEditor: TInplaceEdit;
begin
  Result := TExInplaceEdit.Create(Self);
end;

procedure TJvStringGrid.DefaultDrawCell(AColumn, ARow: integer; Rect: TRect;
  State: TGridDrawState);
const
  Flags: array[TAlignment] of DWORD = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  S: string;
begin
  if RowHeights[ARow] < Canvas.TextHeight('Wq') then Exit;
  Canvas.FillRect(Rect);
  S := Cells[AColumn, ARow];
  if Length(S) > 0 then
  begin
    InflateRect(Rect, -2, -2);
    DrawText(Canvas.Handle, PChar(S), Length(S), Rect,
      DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER or
      Flags[GetCellAlignment(AColumn, ARow, State)]);
  end;
end;

procedure TJvStringGrid.DrawCell(AColumn, ARow: integer; Rect: TRect;
  State: TGridDrawState);
begin
  if (AColumn < FixedCols) or (ARow < FixedRows) then
    Canvas.Font := FixedFont;
  if Assigned(OnDrawCell) then
    inherited DrawCell(AColumn, ARow, Rect, State)
  else
  begin
    SetCanvasProperties(AColumn, ARow, Rect, State);
    DefaultDrawCell(AColumn, ARow, Rect, State);
    Canvas.Font := Font;
    Canvas.Brush := Brush;
  end;
end;

procedure TJvStringGrid.ExitCell(const EditText: string; AColumn,
  ARow: integer);
begin
  if Assigned(FOnExitCell) then
    FOnExitCell(Self, AColumn, ARow, EditText);
end;

function TJvStringGrid.GetCellAlignment(AColumn, ARow: integer;
  State: TGridDrawState): TAlignment;
begin
  Result := FAlignment;
  if Assigned(FGetCellAlignment) then
    FGetCellAlignment(Self, AColumn, ARow, State, Result);
end;

procedure TJvStringGrid.GMActivateCell(var Msg: TGMActivateCell);
begin
  Col := Msg.Column;
  Row := Msg.Row;
  EditorMode := true;
  InplaceEditor.SelectAll;
end;

procedure TJvStringGrid.InvalidateCell(AColumn, ARow: integer);
begin
  inherited InvalidateCell(AColumn, ARow);
end;

procedure TJvStringGrid.InvalidateCol(AColumn: integer);
begin
  inherited InvalidateCol(AColumn);
end;

procedure TJvStringGrid.InvalidateRow(ARow: integer);
begin
  inherited InvalidateRow(ARow);
end;

procedure TJvStringGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
    MouseToCell(X, Y, FCellOnMouseDown.X, FCellOnMouseDown.Y)
  else
    FCellOnMouseDown := TGridCoord(Point(-1, -1));
end;

procedure TJvStringGrid.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
var
  Cell: TGridCoord;
begin
  if Button = mbLeft then
    MouseToCell(X, Y, Cell.X, Cell.Y);
  if CompareMem(@Cell, @FCellOnMouseDown, sizeof(Cell)) and
    ((Cell.X < FixedCols) or (Cell.Y < FixedRows)) then
    CaptionClick(Cell.X, Cell.Y);
  FCellOnMouseDown := TGridCoord(Point(-1, -1));
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TJvStringGrid.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
    if Assigned(InplaceEditor) then
      TExInplaceEdit(InplaceEditor).RecreateWnd;
  end;
end;

procedure TJvStringGrid.SetCanvasProperties(AColumn, ARow: integer;
  Rect: TRect; State: TGridDrawState);
begin
  if Assigned(FSetCanvasProperties) then
    FSetCanvasProperties(Self, AColumn, ARow, Rect, State);
end;

procedure TJvStringGrid.WMCommand(var Msg: TWMCommand);
begin
  if EditorMode and (Msg.Ctl = InplaceEditor.Handle) then
    inherited
  else if Msg.Ctl <> 0 then
    Msg.Result := SendMessage(Msg.Ctl, CN_COMMAND, TMessage(Msg).wParam, TMessage(Msg).lParam);
end;

function TJvStringGrid.InsertCol(Index: integer): TStrings;
var
  i: integer;
  AStr: TStrings;
begin
  ColCount := ColCount + 1;
  if (Index < 0) then
    Index := 0;
  if Index >= ColCount then
    Index := ColCount - 1;
  Result := Cols[Index];
  if ColCount = 1 then Exit;
  for i := ColCount - 2 downto Index do
  begin
    AStr := Cols[i];
    Cols[i + 1] := AStr;
  end;
  Result := Cols[Index];
  Result.Clear;
end;

function TJvStringGrid.InsertRow(Index: integer): TStrings;
var
  i: integer;
  AStr: TStrings;
begin
  RowCount := RowCount + 1;
  if (Index < 0) then
    Index := 0;
  if Index >= RowCount then
    Index := RowCount - 1;
  Result := Rows[Index];
  if RowCount = 1 then Exit;
  for i := RowCount - 2 downto Index do
  begin
    AStr := Rows[i];
    Rows[i + 1] := AStr;
  end;
  Result.Clear;
end;

procedure TJvStringGrid.RemoveCol(Index: integer);
var
  i: integer;
  AStr: TStrings;
begin
  if (Index < 0) then
    Index := 0;
  if Index >= ColCount then
    Index := ColCount - 1;
  for i := Index + 1 to ColCount - 1 do
  begin
    AStr := Cols[i];
    Cols[i - 1] := AStr;
  end;
  if ColCount > 1 then
    ColCount := ColCount - 1;
end;

procedure TJvStringGrid.RemoveRow(Index: integer);
var
  i: integer;
  AStr: TStrings;
begin
  if (Index < 0) then
    Index := 0;
  if Index >= RowCount then
    Index := RowCount - 1;
  for i := Index + 1 to RowCount - 1 do
  begin
    AStr := Rows[i];
    Rows[i - 1] := AStr;
  end;
  if RowCount > 1 then
    RowCount := RowCount - 1;
end;

procedure TJvStringGrid.Clear;
var
  i: integer;
begin
  for i := 0 to ColCount - 1 do
    Cols[i].Clear;
end;

procedure TJvStringGrid.HideCol(Index: integer);
begin
  ColWidths[Index] := -1;
end;

procedure TJvStringGrid.HideRow(Index: integer);
begin
  RowHeights[Index] := -1;
end;

procedure TJvStringGrid.ShowCol(Index, AWidth: integer);
begin
  if AWidth <= 0 then
    AWidth := DefaultColWidth;
  ColWidths[Index] := AWidth;
end;

procedure TJvStringGrid.ShowRow(Index, AHeight: integer);
begin
  if AHeight <= 0 then
    AHeight := DefaultRowHeight;
  RowHeights[Index] := AHeight;

end;

procedure TJvStringGrid.SetFixedFont(const Value: TFont);
begin
  FFixedFont.Assign(Value);
end;

procedure TJvStringGrid.DoFixedFontChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TJvStringGrid.AutoSizeCol(Index, MinWidth: integer);
var
  i, j, AColWidth: integer;
  ASize: TSize;
begin
  if (Index >= 0) and (Index < ColCount) then
  begin
    if MinWidth < 0 then
      AColWidth := DefaultColWidth
    else
      AColWidth := MinWidth;
    for j := 0 to RowCount - 1 do
    begin
      if GetTextExtentPoint32(Canvas.Handle, PChar(Cells[Index, j]), Length(Cells[Index, j]), ASize) then
        AColWidth := Max(AColWidth, ASize.cx + 8);
    end;
    ColWidths[Index] := AColWidth;
  end
  else
  begin
    for i := 0 to ColCount - 1 do
    begin
      if MinWidth < 0 then
        AColWidth := DefaultColWidth
      else
        AColWidth := MinWidth;
      for j := 0 to RowCount - 1 do
      begin
        if GetTextExtentPoint32(Canvas.Handle, PChar(Cells[i, j]), Length(Cells[i, j]), ASize) then
          AColWidth := Max(AColWidth, ASize.cx + 8);
      end;
      ColWidths[i] := AColWidth;
    end;
  end;
end;

procedure TJvStringGrid.HideAll;
var
  i: integer;
begin
  if ColCount < RowCount then
    for i := 0 to ColCount - 1 do
      ColWidths[i] := -1
  else
    for i := 0 to RowCount - 1 do
      RowHeights[i] := -1;
end;

procedure TJvStringGrid.ShowAll(AWidth, AHeight: integer);
var
  i: integer;
begin
  if AWidth < 0 then AWidth := DefaultColWidth;
  if AHeight < 0 then AHeight := DefaultRowHeight;
  for i := 0 to ColCount - 1 do
    if ColWidths[i] < 0 then
      ColWidths[i] := AWidth;
  for i := 0 to RowCount - 1 do
    if RowHeights[i] < 0 then
      RowHeights[i] := AHeight;
end;

function TJvStringGrid.IsHidden(ACol, ARow: integer): boolean;
begin
  Result := (ColWidths[ACol] < 0) or (RowHeights[ARow] < 0);
end;

procedure TJvStringGrid.HideCell(ACol, ARow: integer);
begin
  ColWidths[ACol] := -1;
  RowHeights[ARow] := -1;
end;

procedure TJvStringGrid.ShowCell(ACol, ARow, AWidth, AHeight: integer);
begin
  if AWidth < 0 then AWidth := DefaultColWidth;
  if AHeight < 0 then AWidth := DefaultRowHeight;
  if ColWidths[ACol] < 0 then ColWidths[ACol] := AWidth;
  if RowHeights[ARow] < 0 then RowHeights[ARow] := AHeight;
end;

end.

