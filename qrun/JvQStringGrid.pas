{**************************************************************************************************}
{  WARNING:  JEDI preprocessor generated unit. Manual modifications will be lost on next release.  }
{**************************************************************************************************}

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain A copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvStringGrid.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is S�bastien Buysse [sbuysse att buypin dott com]
Portions created by S�bastien Buysse are Copyright (C) 2001 S�bastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck att bigfoot dott com].

Last Modified: 2002-09-18

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvQStringGrid;

interface

uses
  SysUtils, Classes,
  
  
  Types, QGraphics, QControls, QForms, QGrids, QWindows,
  
  JvQTypes, JvQJCLUtils, JvQExGrids;

const
  GM_ACTIVATECELL = WM_USER + 123;

type
  // (rom) renamed elements made packed
  TGMActivateCell = packed record
    Msg: Cardinal;
    Column: Integer;
    Row: Integer;
    Result: Integer;
  end;

  TJvStringGrid = class;
  TExitCellEvent = procedure(Sender: TJvStringGrid; AColumn, ARow: Integer;
    const EditText: string) of object;
  TGetCellAlignmentEvent = procedure(Sender: TJvStringGrid; AColumn, ARow: Integer;
    State: TGridDrawState; var CellAlignment: TAlignment) of object;
  TCaptionClickEvent = procedure(Sender: TJvStringGrid; AColumn, ARow: Integer) of object;
  TJvSortType = (stNone, stAutomatic, stClassic, stCaseSensitive, stNumeric, stDate, stCurrency);
  TProgress = procedure(Sender: TObject; Progression, Total: Integer) of object;

  TJvStringGrid = class(TJvExStringGrid)
  private
    FAlignment: TAlignment;
    FSetCanvasProperties: TDrawCellEvent;
    FGetCellAlignment: TGetCellAlignmentEvent;
    FCaptionClick: TCaptionClickEvent;
    FCellOnMouseDown: TGridCoord;
    FOnExitCell: TExitCellEvent;
    FOnLoadProgress: TProgress;
    FOnSaveProgress: TProgress;
    FOnHorizontalScroll: TNotifyEvent;
    FOnVerticalScroll: TNotifyEvent;
    FFixedFont: TFont;
//    procedure GMActivateCell(var Msg: TGMActivateCell); message GM_ACTIVATECELL;
    procedure SetAlignment(const Value: TAlignment);
//    procedure WMCommand(var Msg: TWMCommand); message WM_COMMAND;
    procedure SetFixedFont(const Value: TFont);
    procedure DoFixedFontChange(Sender: TObject);
  protected
    function CreateEditor: TInplaceEdit; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure ExitCell(const EditText: string; AColumn, ARow: Integer); virtual;
    procedure SetCanvasProperties(AColumn, ARow: Longint;
      Rect: TRect; State: TGridDrawState); virtual;
    procedure DrawCell(AColumn, ARow: Longint;
      Rect: TRect; State: TGridDrawState); override;
    procedure CaptionClick(AColumn, ARow: Longint); dynamic;
//    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
//    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    
    function SelectCell(ACol, ARow: Longint): Boolean; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetCellAlignment(AColumn, ARow: Longint;
      State: TGridDrawState): TAlignment; virtual;
    procedure DefaultDrawCell(AColumn, ARow: Longint;
      Rect: TRect; State: TGridDrawState); virtual;
//    procedure ActivateCell(AColumn, ARow: Integer);
    procedure InvalidateCell(AColumn, ARow: Integer);
    procedure InvalidateCol(AColumn: Integer);
    procedure InvalidateRow(ARow: Integer);
    property InplaceEditor;
    // Calculates and sets the width of a specific column or all columns if Index < 0
    // based on the text in the affected Cells.
    // MinWidth is the minimum width of the column(s). If MinWidth is < 0,
    // DefaultColWidth is used instead
    procedure AutoSizeCol(Index, MinWidth: Integer);
    // Inserts a new row at the specified Index and moves all existing rows >= Index down one step
    // Returns the inserted row as an empty TStrings
    function InsertRow(Index: Integer): TStrings;
    // Inserts a new column at the specified Index and moves all existing columns >= Index to the right
    // Returns the inserted column as an empty TStrings
    function InsertCol(Index: Integer): TStrings;
    // Removes the row at Index and moves all rows > Index up one step
    procedure RemoveRow(Index: Integer);
    // Removes the column at Index and moves all cols > Index to the left
    procedure RemoveCol(Index: Integer);
    // Hides the row at Index by setting it's height = -1
    // Calling this method repeatedly does nothing (the row retains it's Index even if it's hidden)
    procedure HideRow(Index: Integer);
    // Shows the row at Index by setting it's height to AHeight
    // if AHeight <= 0, DefaultRowHeight is used instead
    procedure ShowRow(Index, AHeight: Integer);
    // Hides the column at Index by setting it's ColWidth = -1
    // Calling this method repeatedly does nothing (the column retains it's Index even if it's hidden)
    procedure HideCol(Index: Integer);
    // Returns true if the Cell at ACol/ARow is hidden, i.e if it's RowHeight or ColWidth < 0
    function IsHidden(ACol, ARow: Integer): boolean;
    // Shows the column at Index by setting it's width to AWidth
    // If AWidth <= 0, DefaultColWidth is used instead
    procedure ShowCol(Index, AWidth: Integer);
    // HideCell hides a cell by hiding the row and column that it belongs to.
    // This means that both a row and a column is hidden
    procedure HideCell(ACol, ARow: Integer);
    // ShowCell shows a previously hidden cell by showing it's corresponding row and column and
    // using AWidth/AHeight to set it's size. If AWidth < 0, DefaultColWidth is used instead.
    // If AHeight < 0, DefaultRowHeight is used instead. If one dimension of the Cell wasn't
    // hidden, nothing happens to that dimension (i.e if ColWidth < 0 but RowHeight := 24, only ColWidth is
    // changed to AWidth
    procedure ShowCell(ACol, ARow, AWidth, AHeight: Integer);
    // Removes the content in the Cells but does not remove any rows or columns
    procedure Clear;

    // Hides all rows and columns
    procedure HideAll;
    // Shows all hidden rows and columns, setting their width/height to AWidth/AHeight as necessary
    // If AWidth < 0, DefaultColWidth is used. If AHeight < 0, DefaultRowHeight is used
    procedure ShowAll(AWidth, AHeight: Integer);

    procedure SortGrid(Column: Integer; Ascending: boolean = true; Fixed: boolean = false;
      SortType: TJvSortType = stClassic; BlankTop: boolean = true);
    procedure SaveToFile(FileName: string);
    procedure LoadFromFile(FileName: string);
    procedure LoadFromCSV(FileName: string; Separator: char = ';'; QuoteChar: char = '"');
    procedure SaveToCSV(FileName: string; Separator: char = ';'; QuoteChar: char = '"');
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
  published
    property HintColor;
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property FixedFont: TFont read FFixedFont write SetFixedFont;
    property OnExitCell: TExitCellEvent read FOnExitCell write FOnExitCell;
    property OnSetCanvasProperties: TDrawCellEvent read FSetCanvasProperties write FSetCanvasProperties;
    property OnGetCellAlignment: TGetCellAlignmentEvent read FGetCellAlignment write FGetCellAlignment;
    property OnCaptionClick: TCaptionClickEvent read FCaptionClick write FCaptionClick;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnParentColorChange;
    property OnLoadProgress: TProgress read FOnLoadProgress write FOnLoadProgress;
    property OnSaveProgress: TProgress read FOnSaveProgress write FOnSaveProgress;
    property OnVerticalScroll: TNotifyEvent read FOnVerticalScroll write FOnVerticalScroll;
    property OnHorizontalScroll: TNotifyEvent read FOnHorizontalScroll write FOnHorizontalScroll;
  end;

implementation

uses
  Math,
  JvQJVCLUtils;

const
  BufSize = 1024;

//=== TExInplaceEdit =========================================================

type
  TExInplaceEdit = class(TJvExInplaceEdit)
  private
    FLastCol: Integer;
    FLastRow: Integer;
  protected
    procedure DoKillFocus(FocusedWnd: HWND); override;
    procedure DoSetFocus(FocusedWnd: HWND); override;
  public
//    procedure CreateParams(var Params: TCreateParams); override;
  end;



procedure TExInplaceEdit.DoKillFocus(FocusedWnd: HWND);
begin
  TJvStringGrid(Grid).ExitCell(Text, FLastCol, FLastRow);
  inherited DoKillFocus(FocusedWnd);
end;

procedure TExInplaceEdit.DoSetFocus(FocusedWnd: HWND);
begin
  FLastCol := TJvStringGrid(Grid).Col;
  FLastRow := TJvStringGrid(Grid).Row;
  inherited DoSetFocus(FocusedWnd);
end;

//=== TJvStringGrid ==========================================================

constructor TJvStringGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFixedFont := TFont.Create;
  FFixedFont.Assign(Font);
  FFixedFont.OnChange := DoFixedFontChange;
  // ControlStyle := ControlStyle + [csAcceptsControls];
end;

destructor TJvStringGrid.Destroy;
begin
  FreeAndNil(FFixedFont);
  inherited;
end;

procedure TJvStringGrid.SortGrid(Column: Integer; Ascending,
  Fixed: boolean; SortType: TJvSortType; BlankTop: boolean);
const
  cFloatDelta = 0.01;
var
  St: string;
  TmpC: Currency;
  TmpF: Extended;
  TmpD: TDateTime;
  LStart: Integer;
  lEnd: Integer;

  procedure ExchangeGridRows(i, j: Integer);
  var
    K: Integer;
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

  procedure QuickSort(L, R: Integer);
  var
    i, j, m: Integer;
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
    i, j: Integer;
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

  function MoveBlankTop: Integer;
  var
    i, j: Integer;
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
    i, j: Integer;
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
  i, j, K, L, m, N: Integer;
  fich: TextFile;
  FilePos, Count: Integer;
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
  Col, Rom, i, Count: Integer;
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

(*)
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
(*)

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
  i, j: Integer;
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
  i, j, K: Integer;
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

(*)
procedure TJvStringGrid.ActivateCell(AColumn, ARow: Integer);
begin
  PostMessage(Handle, GM_ACTIVATECELL, AColumn, ARow);
end;
(*)
procedure TJvStringGrid.CaptionClick(AColumn, ARow: Integer);
begin
  if Assigned(FCaptionClick) then
    FCaptionClick(Self, AColumn, ARow);
end;

function TJvStringGrid.CreateEditor: TInplaceEdit;
begin
  Result := TExInplaceEdit.Create(Self);
end;

procedure TJvStringGrid.DefaultDrawCell(AColumn, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
const
  Flags: array[TAlignment] of DWORD = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  S: string;
begin
  if RowHeights[ARow] < CanvasMaxTextHeight(Canvas) then Exit;
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

procedure TJvStringGrid.DrawCell(AColumn, ARow: Integer; Rect: TRect;
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
  ARow: Integer);
begin
  if Assigned(FOnExitCell) then
    FOnExitCell(Self, AColumn, ARow, EditText);
end;

function TJvStringGrid.GetCellAlignment(AColumn, ARow: Integer;
  State: TGridDrawState): TAlignment;
begin
  Result := FAlignment;
  if Assigned(FGetCellAlignment) then
    FGetCellAlignment(Self, AColumn, ARow, State, Result);
end;


function TJvStringGrid.SelectCell(ACol, ARow: Longint): Boolean;
begin
  Result := inherited SelectCell(ACol, ARow);
  if Result then
  begin
    Col := ACol;
    Row := ARow;
    EditorMode := true;
    InplaceEditor.SelectAll;
  end;
end;




procedure TJvStringGrid.InvalidateCell(AColumn, ARow: Integer);
begin
  inherited InvalidateCell(AColumn, ARow);
end;

procedure TJvStringGrid.InvalidateCol(AColumn: Integer);
begin
  inherited InvalidateCol(AColumn);
end;

procedure TJvStringGrid.InvalidateRow(ARow: Integer);
begin
  inherited InvalidateRow(ARow);
end;

procedure TJvStringGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
    MouseToCell(X, Y, FCellOnMouseDown.X, FCellOnMouseDown.Y)
  else
    FCellOnMouseDown := TGridCoord(Point(-1, -1));
end;

procedure TJvStringGrid.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Cell: TGridCoord;
begin
  if Button = mbLeft then
    MouseToCell(X, Y, Cell.X, Cell.Y);
  if CompareMem(@Cell, @FCellOnMouseDown, SizeOf(Cell)) and
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
      TExInplaceEdit(InplaceEditor).RecreateWidget;
  end;
end;

procedure TJvStringGrid.SetCanvasProperties(AColumn, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if Assigned(FSetCanvasProperties) then
    FSetCanvasProperties(Self, AColumn, ARow, Rect, State);
end;



function TJvStringGrid.InsertCol(Index: Integer): TStrings;
var
  i: Integer;
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

function TJvStringGrid.InsertRow(Index: Integer): TStrings;
var
  i: Integer;
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

procedure TJvStringGrid.RemoveCol(Index: Integer);
var
  i: Integer;
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

procedure TJvStringGrid.RemoveRow(Index: Integer);
var
  i: Integer;
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
  i: Integer;
begin
  for i := 0 to ColCount - 1 do
    Cols[i].Clear;
end;

procedure TJvStringGrid.HideCol(Index: Integer);
begin
  ColWidths[Index] := -1;
end;

procedure TJvStringGrid.HideRow(Index: Integer);
begin
  RowHeights[Index] := -1;
end;

procedure TJvStringGrid.ShowCol(Index, AWidth: Integer);
begin
  if AWidth <= 0 then
    AWidth := DefaultColWidth;
  ColWidths[Index] := AWidth;
end;

procedure TJvStringGrid.ShowRow(Index, AHeight: Integer);
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

procedure TJvStringGrid.AutoSizeCol(Index, MinWidth: Integer);
var
  i, j, AColWidth: Integer;
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
      if GetTextExtentPoint32W(Canvas.Handle, PWideChar(Cells[Index, j]), Length(Cells[Index, j]), ASize) then
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
        if GetTextExtentPoint32W(Canvas.Handle, PWideChar(Cells[i, j]), Length(Cells[i, j]), ASize) then
          AColWidth := Max(AColWidth, ASize.cx + 8);
      end;
      ColWidths[i] := AColWidth;
    end;
  end;
end;

procedure TJvStringGrid.HideAll;
var
  i: Integer;
begin
  if ColCount < RowCount then
    for i := 0 to ColCount - 1 do
      ColWidths[i] := -1
  else
    for i := 0 to RowCount - 1 do
      RowHeights[i] := -1;
end;

procedure TJvStringGrid.ShowAll(AWidth, AHeight: Integer);
var
  i: Integer;
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

function TJvStringGrid.IsHidden(ACol, ARow: Integer): boolean;
begin
  Result := (ColWidths[ACol] < 0) or (RowHeights[ARow] < 0);
end;

procedure TJvStringGrid.HideCell(ACol, ARow: Integer);
begin
  ColWidths[ACol] := -1;
  RowHeights[ARow] := -1;
end;

procedure TJvStringGrid.ShowCell(ACol, ARow, AWidth, AHeight: Integer);
begin
  if AWidth < 0 then AWidth := DefaultColWidth;
  if AHeight < 0 then AWidth := DefaultRowHeight;
  if ColWidths[ACol] < 0 then ColWidths[ACol] := AWidth;
  if RowHeights[ARow] < 0 then RowHeights[ARow] := AHeight;
end;

end.

