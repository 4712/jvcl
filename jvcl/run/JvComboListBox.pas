{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvComboListBox.PAS, released on 2003-10-07.

The Initial Developer of the Original Code is Peter Thornqvist <peter3 at sourceforge.net>
Portions created by S�bastien Buysse are Copyright (C) 2003 Peter Thornqvist .
All Rights Reserved.

Contributor(s):

Last Modified: 2003-10-09

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:

Description:
  A listbox that displays a combo box overlay on the selected item. Assign a
  TPopupMenu to the DropdownMenu property and it will be shown when the user clicks the
  combobox button.
-----------------------------------------------------------------------------}

{$I JVCL.INC}
{$I WINDOWSONLY.INC}
unit JvComboListBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, StdCtrls, ExtCtrls, Menus, JvListBox, JvTypes;

type
  // (p3) these types should *not* be moved to JvTypes (they are only used here)!
  TJvComboListBoxDrawStyle = (dsOriginal, dsStretch, dsProportional);
  TJvComboListDropDownEvent = procedure(Sender: TObject; Index: integer; X,Y:integer; var AllowDrop:boolean) of object;
  TJvComboListDrawTextEvent = procedure(Sender: TObject; Index: integer; const AText: string; R: TRect; var DefaultDraw:
    boolean) of object;
  TJvComboListDrawImageEvent = procedure(Sender: TObject; Index: integer; const APicture: TPicture; R: TRect; var
    DefaultDraw: boolean) of object;
  TJvComboListBox = class(TJvCustomListBox)
  private
    FMouseOver, FPushed: boolean;
    FDropdownMenu: TPopupMenu;
    FDrawStyle: TJvComboListBoxDrawStyle;
    FOnDrawImage: TJvComboListDrawImageEvent;
    FOnDrawText: TJvComboListDrawTextEvent;
    FButtonWidth: integer;
    FHotTrackCombo: boolean;
    FLastHotTrack: integer;
    FOnDropDown: TJvComboListDropDownEvent;
    procedure SetDrawStyle(const Value: TJvComboListBoxDrawStyle);
    function DestRect(Picture: TPicture; ARect: TRect): TRect;
    function GetOffset(OrigRect, ImageRect: TRect): TRect;
    procedure SetButtonWidth(const Value: integer);
    procedure SetHotTrackCombo(const Value: boolean);
  protected
    procedure InvalidateItem(Index: integer);
    procedure DrawComboArrow(Canvas: TCanvas; R: TRect; Highlight, Pushed: boolean);
    procedure DrawItem(Index: integer; Rect: TRect;
      State: TOwnerDrawState); override;
    procedure CMMouseLeave(var Msg: TMessage); override;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X: integer; Y: integer);
      override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    function DoDrawImage(Index: integer; APicture: TPicture; R: TRect): boolean; virtual;
    function DoDrawText(Index: integer; const AText: string; R: TRect): boolean; virtual;
    function DoDropDown(Index,X,Y:integer):boolean;virtual;

  public
    constructor Create(AOwner: TComponent); override;
    function AddText(const S: string): integer;
    procedure InsertText(Index: integer; const S: string);
    // helper functions: makes sure the internal TPicture object is created and freed as necessary
    function AddImage(P: TPicture): integer;
    procedure InsertImage(Index: integer; P: TPicture);
    procedure Delete(Index: integer);
  published
    property ButtonWidth: integer read FButtonWidth write SetButtonWidth default 20;
    property HotTrackCombo: boolean read FHotTrackCombo write SetHotTrackCombo default false;
    property DropdownMenu: TPopupMenu read FDropdownMenu write FDropdownMenu;
    property DrawStyle: TJvComboListBoxDrawStyle read FDrawStyle write SetDrawStyle default dsOriginal;
    property OnDrawText: TJvComboListDrawTextEvent read FOnDrawText write FOnDrawText;
    property OnDrawImage: TJvComboListDrawImageEvent read FOnDrawImage write FOnDrawImage;
    property OnDropDown:TJvComboListDropDownEvent read FOnDropDown write FOnDropDown;

    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Columns;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Font;
    property ImeMode;
    property ImeName;
    property IntegralHeight;
    property ItemHeight default 17;
    property Items;

    property MultiSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TabWidth;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetText;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property HotTrack;
    property HintColor;

    property OnMouseEnter;
    property OnMouseLeave;
    property OnCtl3DChanged;
    property OnParentColorChange;
    property OnSelectCancel;
    property OnChange;
    property OnVerticalScroll;
    property OnHorizontalScroll;
  end;

implementation

{ TJvComboListBox }

function TJvComboListBox.AddImage(P: TPicture): integer;
begin
  Result := Items.Count;
  InsertImage(Result, P);
end;

function TJvComboListBox.AddText(const S: string): integer;
begin
  Result := Items.Add(S);
end;

procedure TJvComboListBox.CMMouseLeave(var Msg: TMessage);
begin
  inherited;
  if FMouseOver then
  begin
    InvalidateItem(ItemIndex);
    FMouseOver := false;
  end;
  if HotTrackCombo and (FLastHotTrack > -1) then
  begin
    InvalidateItem(FLastHotTrack);
    FLastHotTrack := -1;
  end;
end;

constructor TJvComboListBox.Create(AOwner: TComponent);
begin
  inherited;
  Style := lbOwnerDrawFixed;
  ScrollBars := ssVertical;
  FDrawStyle := dsOriginal;
  FButtonWidth := 20;
  FLastHotTrack := -1;
  ItemHeight := 17;
//  ControlStyle := ControlStyle + [csCaptureMouse];
end;

procedure TJvComboListBox.Delete(Index: integer);
var
  P: TPicture;
begin
  P := TPicture(Items.Objects[Index]);
  Items.Delete(Index);
  P.Free;
end;

function TJvComboListBox.DestRect(Picture: TPicture; ARect: TRect): TRect;
var
  W, H, CW, CH: integer;
  xyaspect: Double;

begin
  W := Picture.Width;
  H := Picture.Height;
  CW := ARect.Right - ARect.Left;
  CH := ARect.Bottom - ARect.Top;
  if (DrawStyle = dsStretch) or ((DrawStyle = dsProportional) and ((W > CW) or (H > CH))) then
  begin
    if (DrawStyle = dsProportional) and (W > 0) and (H > 0) then
    begin
      xyaspect := W / H;
      if W > H then
      begin
        W := CW;
        H := trunc(CW / xyaspect);
        if H > CH then // woops, too big
        begin
          H := CH;
          W := trunc(CH * xyaspect);
        end;
      end
      else
      begin
        H := CH;
        W := trunc(CH * xyaspect);
        if W > CW then // woops, too big
        begin
          W := CW;
          H := trunc(CW / xyaspect);
        end;
      end;
    end
    else
    begin
      W := CW;
      H := CH;
    end;
  end;

  with Result do
  begin
    Left := 0;
    Top := 0;
    Right := W;
    Bottom := H;
  end;

  OffsetRect(Result, (CW - W) div 2, (CH - H) div 2);
end;

function TJvComboListBox.DoDrawImage(Index: integer; APicture: TPicture; R: TRect): boolean;
begin
  Result := true;
  if Assigned(FOnDrawImage) then FOnDrawImage(Self, Index, APicture, R, Result);
end;

function TJvComboListBox.DoDrawText(Index: integer; const AText: string; R: TRect): boolean;
begin
  Result := true;
  if Assigned(FOnDrawText) then FOnDrawText(Self, Index, AText, R, Result);
end;

function TJvComboListBox.DoDropDown(Index, X, Y: integer): boolean;
begin
  Result := true;
  if Assigned(FOnDropDown) then
    FOnDropDown(self, Index, X,Y,Result);
end;

procedure TJvComboListBox.DrawComboArrow(Canvas: TCanvas; R: TRect; Highlight, Pushed: boolean);
var
  uState: Cardinal;
begin
//  Canvas.Font.Style := [];
  (*
  Canvas.Font.Name := 'Marlett';
  if ButtonWidth > Font.Size + 5 then
    Canvas.Font.Size := Font.Size + 3
  else
    Canvas.Font.Size := ButtonWidth;
  Canvas.Font.Color := clWindowText;
  S := 'u';
  SetBkMode(Canvas.Handle, Transparent);
  DrawText(Canvas.Handle, PChar(S), Length(S), R, DT_VCENTER or DT_CENTER or DT_SINGLELINE);
  *)
  uState := DFCS_SCROLLDOWN;
  if not Highlight then
    Inc(uState, DFCS_FLAT);
  if Pushed then
    Inc(uState, DFCS_PUSHED);
  DrawFrameControl(Canvas.Handle, R, DFC_SCROLL, uState or DFCS_ADJUSTRECT);
end;

procedure TJvComboListBox.DrawItem(Index: integer; Rect: TRect;
  State: TOwnerDrawState);
var
  P: TPicture;
  B: TBitmap;
  aPoints: array[0..4] of TPoint;
  TmpRect: TRect;
  Pt: TPoint;
  i: integer;
begin
  if (Index < 0) or (Index >= Items.Count) or Assigned(OnDrawItem) then Exit;
  Canvas.Lock;
  try
    Canvas.Brush.Color := Self.Color;

    if (Items.Objects[Index] is TPicture) then
      P := TPicture(Items.Objects[Index])
    else
      P := nil;
    if (P = nil) or (DrawStyle <> dsStretch) then
      Canvas.FillRect(Rect);
    if (P <> nil) and (P.Graphic <> nil) then
    begin
      TmpRect := Classes.Rect(0, 0, P.Graphic.Width, P.Graphic.Height);
      if DoDrawImage(Index, P, Rect) then
      begin
        case DrawStyle of
          dsOriginal:
            begin
              B := TBitmap.Create;
              try
                B.Assign(P.Bitmap);
                TmpRect := GetOffset(Rect, Classes.Rect(0, 0, B.Width, B.Height));
                B.Width := Rect.Right - Rect.Left;
                B.Height := Rect.Bottom - Rect.Top;
                Canvas.Draw(TmpRect.Left, TmpRect.Top, B);
              finally
                B.Free;
              end;
            end;
          dsStretch, dsProportional:
            begin
              TmpRect := DestRect(P, Rect);
              OffsetRect(TmpRect, Rect.Left, Rect.Top);
              Canvas.StretchDraw(TmpRect, P.Graphic);
            end;
        end;
      end;
    end
    else
    begin
      Canvas.Font.Color := clWindowText;
      TmpRect := Rect;
      InflateRect(TmpRect, -2, -2);
      if DoDrawText(Index, Items[Index], TmpRect) then
        DrawText(Canvas.Handle, PChar(Items[Index]), Length(Items[Index]),
          TmpRect, DT_WORDBREAK or DT_LEFT or DT_TOP or DT_EDITCONTROL or DT_NOPREFIX or DT_END_ELLIPSIS);
    end;

  // draw the combo button
    GetCursorPos(Pt);
    Pt := ScreenToClient(Pt);
    i := ItemAtPos(Pt, true);
    if (not HotTrackCombo and (State * [odSelected, odFocused] <> [])) or (HotTrackCombo and (i = Index)) then
    begin
    // draw frame
      Canvas.Brush.Style := bsClear;
      if HotTrackCombo then
      begin
        Canvas.Pen.Color := clHighlight;
        Canvas.Pen.Width := 1;
      end
      else
      begin
        Canvas.Pen.Color := clHighlight;
        Canvas.Pen.Width := 2;
      end;

      aPoints[0] := Point(Rect.Left, Rect.Top);
      aPoints[1] := Point(Rect.Right - 2, Rect.Top);
      aPoints[2] := Point(Rect.Right - 2, Rect.Bottom - 2);
      aPoints[3] := Point(Rect.Left, Rect.Bottom - 2);
      aPoints[4] := Point(Rect.Left, Rect.Top);
      Canvas.Polygon(aPoints);

    // draw button body
      if ButtonWidth > 2 then // 2 because Pen.Width is 2
      begin
        TmpRect := Classes.Rect(Rect.Right - ButtonWidth - 1,
          Rect.Top + 1, Rect.Right - 2 - Ord(FPushed), Rect.Bottom - 2 - Ord(FPushed));
        DrawComboArrow(Canvas, TmpRect, FMouseOver and Focused, FPushed);
      end;
    end;
    Canvas.Pen.Color := clBtnShadow;
    Canvas.Pen.Width := 1;
    Canvas.MoveTo(Rect.Left, Rect.Bottom - 1);
    Canvas.LineTo(Rect.Right, Rect.Bottom - 1);
    Canvas.MoveTo(Rect.Right - 1, Rect.Top);
    Canvas.LineTo(Rect.Right - 1, Rect.Bottom - 1);
  finally
    Canvas.Unlock;
  end;
end;

function TJvComboListBox.GetOffset(OrigRect, ImageRect: TRect): TRect;
var
  W, H, W2, H2: integer;
begin
  Result := OrigRect;
  W := ImageRect.Right - ImageRect.Left;
  H := ImageRect.Bottom - ImageRect.Top;
  W2 := OrigRect.Right - OrigRect.Left;
  H2 := OrigRect.Bottom - OrigRect.Top;
  if W2 > W then
    OffsetRect(Result, (W2 - W) div 2, 0);
  if H2 > H then
    OffsetRect(Result, 0, (H2 - H) div 2);
end;

procedure TJvComboListBox.InsertImage(Index: integer; P: TPicture);
var
  P2: TPicture;
begin
  P2 := TPicture.Create;
  P2.Assign(P);
  Items.InsertObject(Index, '', P2);
end;

procedure TJvComboListBox.InsertText(Index: integer; const S: string);
begin
  Items.Insert(Index, S);
end;

procedure TJvComboListBox.InvalidateItem(Index: integer);
var
  R, R2: TRect;
begin
  if Index < 0 then
    Index := ItemIndex;
  R := ItemRect(Index);
  R2 := R;
  // we only want to redraw the combo button
  if not IsRectEmpty(R) then
  begin
    R.Right := R.Right - ButtonWidth;
    // don't redraw content, just button
    ExcludeClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
    InvalidateRect(Handle, @R2, false);
  end;
end;

procedure TJvComboListBox.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  i: integer;
  R: TRect;
  P: TPoint;
  Msg: TMsg;
begin
  inherited;
  if (ItemIndex > -1) then
  begin
    P := Point(X, Y);
    i := ItemAtPos(P, true);
    R := ItemRect(i);
    if (i = ItemIndex) and (X >= R.Right - ButtonWidth)
      and (X <= R.Right) then
    begin
      FMouseOver := true;
      FPushed := true;
      InvalidateItem(i);
      if (DropdownMenu <> nil) and DoDropDown(i, X, Y) then
      begin
        case DropdownMenu.Alignment of
          paRight:
            P.X := R.Right;
          paLeft:
            P.X := R.Left;
          paCenter:
            P.X := R.Left + (R.Right - R.Left) div 2;
        end;
        P.Y := R.Top + ItemHeight;
        P := ClientToScreen(P);
        DropdownMenu.PopupComponent := Self;
        DropdownMenu.Popup(P.X, P.Y);
        // wait for popup to disappear
        while PeekMessage(Msg, 0, WM_MOUSEFIRST, WM_MOUSELAST, PM_REMOVE) do
          ;
      end;
      MouseUp(Button, Shift, X, Y);
    end;
  end;
end;

procedure TJvComboListBox.MouseMove(Shift: TShiftState; X,
  Y: integer);
var
  P: TPoint;
  i: integer;
  R: TRect;
begin
  if (DropdownMenu <> nil) or HotTrackCombo then
  begin
    P := Point(X, Y);
    i := ItemAtPos(P, true);
    R := ItemRect(i);
    if HotTrackCombo and (i <> FLastHotTrack) then
    begin
      if FLastHotTrack > -1 then
        InvalidateItem(FLastHotTrack);
      FLastHotTrack := i;
      if FLastHotTrack > -1 then
        InvalidateItem(FLastHotTrack);
    end;
    if ((i = ItemIndex) or HotTrackCombo) and (X >= R.Right - ButtonWidth) and (X <= R.Right) then
    begin
      if not FMouseOver then
      begin
        FMouseOver := true;
        InvalidateItem(i);
      end;
    end
    else if FMouseOver then
    begin
      FMouseOver := false;
      InvalidateItem(i);
    end;
  end;
  inherited;
end;

procedure TJvComboListBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if FPushed then
  begin
    FPushed := false;
    InvalidateItem(ItemIndex);
  end;
end;

procedure TJvComboListBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = DropdownMenu) then
    DropdownMenu := nil;
end;

procedure TJvComboListBox.SetButtonWidth(const Value: integer);
begin
  if FButtonWidth <> Value then
  begin
    FButtonWidth := Value;
    Invalidate;
  end;
end;

procedure TJvComboListBox.SetDrawStyle(const Value: TJvComboListBoxDrawStyle);
begin
  if FDrawStyle <> Value then
  begin
    FDrawStyle := Value;
    Invalidate;
  end;
end;

procedure TJvComboListBox.SetHotTrackCombo(const Value: boolean);
begin
  if FHotTrackCombo <> Value then
  begin
    FHotTrackCombo := Value;
    Invalidate;
  end;
end;

procedure TJvComboListBox.WMSize(var Message: TWMSize);
begin
  inherited;
  Invalidate;
end;

end.

