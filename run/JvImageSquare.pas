{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvImageWindow.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is Peter Th�rnqvist [peter3@peter3.com]
Portions created by Peter Th�rnqvist are Copyright (C) 2002 Peter Th�rnqvist.
All Rights Reserved.

Contributor(s):

Last Modified: 2003-12-15

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvImageSquare;

interface
uses
  Windows, Messages, SysUtils, Graphics, Classes, Controls, ImgList, Forms,
  JvComponent;

type
  TJvImageSquare = class(TJvGraphicControl)
  private
    FHiColor, TmpColor, FBackColor: TColor;
    FBorderStyle: TBorderStyle;
    FImageList: TCustomImageList;
    FIndex: Integer;
    FOnEnter: TNotifyEvent;
    FOnExit: TNotifyEvent;
    FDown: Boolean;
    FShowClick: Boolean;
    FImageChangeLink: TChangeLink;
    procedure SetHiColor(Value: TColor);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetIndex(Value: Integer);
    procedure SetImageList(Value: TCustomImageList);
    procedure ImageListChange(Sender: Tobject);
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
  protected
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure PaintFrame; virtual;
    procedure Paint; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Color default clWindow;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property HiColor: TColor read FHiColor write SetHiColor default clActiveCaption;
    property Images: TCustomImageList read FImageList write SetImageList;
    property ImageIndex: Integer read FIndex write SetIndex default 0;
    property ShowClick: Boolean read FShowClick write FShowClick default False;
    property Width default 36;
    property Height default 36;

    property Align;
    property Anchors;
    property Action;
    property Text;
    property Visible;
    property Enabled;
    property DragCursor;
    property DragMode;
    property PopupMenu;
    property ParentShowHint;
    property Hint;
    property ShowHint;
    property OnMouseEnter: TNotifyEvent read FOnEnter write FOnEnter;
    property OnMouseLeave: TNotifyEvent read FOnExit write FOnExit;
    property OnClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnStartDrag;
  end;

implementation
uses
  ExtCtrls, CommCtrl,
  JvThemes, JvResources;


//=== TJvImageSquare =========================================================

constructor TJvImageSquare.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHiColor := clActiveCaption;
  Color := clWindow;
  TmpColor := clWindow;
  FBackColor := clWindow;
  FIndex := 0;
  FDown := False;
  FShowClick := False;
  Width := 36;
  Height := 36;
  FBorderStyle := bsSingle;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
end;

destructor TJvImageSquare.Destroy;
begin
  FImageChangeLink.Free;
  inherited Destroy;
end;

procedure TJvImageSquare.ImageListChange(Sender: Tobject);
begin
  Repaint;
end;

procedure TJvImageSquare.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (aComponent = FImageList) and (Operation = opRemove) then
    FImageList := nil;
end;

procedure TJvImageSquare.PaintFrame;
var
  R: TRect;
begin
  R := GetClientRect;
  if FDown and FShowClick then
  begin
    Frame3d(Canvas, R, cl3DDkShadow, cl3DDkShadow, 1);
    Frame3d(Canvas, R, clBtnHighLight, clBtnHighLight, 1);
    Frame3d(Canvas, R, cl3DDkShadow, cl3DDkShadow, 1);
  end
  else
{$IFDEF JVCLThemesEnabled}
  if (FBorderStyle = bsSingle) and ThemeServices.ThemesEnabled then
    DrawThemedBorder(Self)
  else
{$ENDIF}
  if FBorderStyle = bsSingle then
  begin
    Frame3d(Canvas, R, clBtnFace, clBtnFace, 1);
    Frame3d(Canvas, R, clBtnShadow, clBtnHighLight, 1);
    Frame3d(Canvas, R, cl3DDkShadow, clBtnFace, 1);
  end
  else
    Frame3d(Canvas, R, FHiColor, FHiColor, 3);
end;

procedure TJvImageSquare.Paint;
var
  R: TRect;
  dX, dY: Integer;
begin
  R := Rect(0, 0, Width, Height);

  if FBorderStyle = bsSingle then
  begin
    PaintFrame;
    InflateRect(R, -3, -3);
  end;

  { fill in the rest }
  with Canvas do
  begin
    Brush.Color := TmpColor;
    Brush.Style := bsSolid;
    FillRect(R);
  end;

  if Assigned(FImageList) then
  begin
    { draw in middle }
    dX := (Width - FImageList.Width) div 2;
    dY := (Height - FImageList.Height) div 2;
    ImageList_DrawEx(Fimagelist.Handle, FIndex, Canvas.Handle, dx, dy, 0, 0, CLR_NONE, CLR_NONE, ILD_TRANSPARENT);
    //    FImageList.Draw(Canvas,dX,dY,FIndex);
  end;
end;

procedure TJvImageSquare.SetHiColor(Value: TColor);
begin
  if FHiColor <> Value then
  begin
    FHiColor := Value;
    Repaint;
  end;
end;

procedure TJvImageSquare.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    Repaint;
  end;
end;

procedure TJvImageSquare.SetIndex(Value: Integer);
begin
  if FIndex <> Value then
  begin
    FIndex := Value;
    Repaint;
  end;
end;

procedure TJvImageSquare.SetImageList(Value: TCustomImageList);
begin
  if Images <> nil then
    Images.UnRegisterChanges(FImageChangeLink);
  FImageList := Value;
  if Images <> nil then
    FImageList.RegisterChanges(FImageChangeLink);
  Repaint;
end;

procedure TJvImageSquare.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, y);
  FDown := False;
  if FShowClick then
    PaintFrame;
end;

procedure TJvImageSquare.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  FDown := True;
  if FShowClick then
    PaintFrame;
end;

procedure TJvImageSquare.CMMouseEnter(var Msg: TMessage);
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  if Assigned(FOnEnter) then
    FOnEnter(Self);
  if ColorToRGB(TmpColor) <> ColorToRGB(FHiColor) then
  begin
    TmpColor := FHiColor;
    Repaint;
  end;
end;

procedure TJvImageSquare.CMMouseLeave(var Msg: TMessage);
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  FDown := False;
  if Assigned(FOnExit) then
    FOnExit(Self);
  if ColorToRGB(TmpColor) <> ColorToRGB(FBackColor) then
  begin
    TmpColor := FBackColor;
    Repaint;
  end;
end;

procedure TJvImageSquare.CMColorChanged(var Message: TMessage);
begin
  inherited;
  FBackColor := Color;
  TmpColor := Color;
  Repaint;
end;

end.

