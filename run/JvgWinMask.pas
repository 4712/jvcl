{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvgWinMask.PAS, released on 2003-01-15.

The Initial Developer of the Original Code is Andrey V. Chudin,  [chudin@yandex.ru]
Portions created by Andrey V. Chudin are Copyright (C) 2003 Andrey V. Chudin.
All Rights Reserved.

Contributor(s):
Michael Beck [mbeck@bigfoot.com].

Last Modified:  2003-01-15

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvgWinMask;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, CommCtrl, ImgList,
  JvgTypes, JvComponent, JvgCommClasses;

//const

type

  TJvgWinMask = class(TJvCustomPanel)
  private
    FMask: TBitmap;
    FMaskBuff: TBitmap;
    fIgnorePaint: boolean;
  public
    Control: TWinControl;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    procedure Loaded; override;
    procedure Paint; override;
    procedure SetParent(Value: TWinControl); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    property Mask: TBitmap read FMask write FMask; // stored fDontUseDefaultImage;
  end;

procedure Register;

implementation
uses JvgUtils;
{~~~~~~~~~~~~~~~~~~~~~~~~~}

procedure Register;
begin
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~}
//___________________________________________________ TJvgWinMask Methods _

constructor TJvgWinMask.Create(AOwner: TComponent);
begin
  inherited;
  Height := 50;
  Width := 100;
  FMask := TBitmap.Create;
  FMaskBuff := TBitmap.Create;
  fIgnorePaint := false;
end;

destructor TJvgWinMask.Destroy;
begin
  FMask.Free;
  FMaskBuff.Free;
  inherited;
end;

procedure TJvgWinMask.Loaded;
begin
  inherited;
end;

procedure TJvgWinMask.Paint;
var
  r: TRect;
  Message: TMessage;

  procedure CreateMaskBuff(R: TRect);
  begin
    FMaskBuff.Width := Width;
    FMaskBuff.Height := Height;

    FMaskBuff.Canvas.Brush.Color := clBlue;
    FMaskBuff.Canvas.FillRect(R);

    Message.Msg := WM_PAINT;
    SendMessage(Control.Handle, WM_PAINT, FMaskBuff.Canvas.handle, 0);
    //    GetWindowImageFrom(Control, 0, 0, true, false, FMaskBuff.Canvas.handle);
    //    GetParentImageRect( self, Bounds(Left,Top,Width,Height),
    //			  FMaskBuff.Canvas.Handle );

    //    BitBlt( FMaskBuff.Canvas.Handle, 0, 0, Width, Height,
    //            FMask.Canvas.Handle, 0, 0, SRCPAINT );

    BitBlt(Canvas.Handle, R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top,
      FMaskBuff.Canvas.Handle, 0, 0, SRCCOPY);
    //    FMaskBuff
  end;
begin
  if fIgnorePaint then
    exit;
  fIgnorePaint := true;

  r := ClientRect;
  if Enabled then
  begin
    CreateMaskBuff(R);

    //    BitBlt( Canvas.Handle, R.Left, R.Top, R.Right-R.Left, R.Bottom-R.Top,
    //            FMaskBuff.Canvas.Handle, 0, 0, SRCCOPY );
  end;
  //  if Assigned(FAfterPaint) then FAfterPaint(self);
  fIgnorePaint := false;
end;

procedure TJvgWinMask.SetParent(Value: TWinControl);
begin
  inherited;
end;

procedure TJvgWinMask.Notification(AComponent: TComponent; Operation:
  TOperation);
begin
  inherited Notification(AComponent, Operation);
end;

end.

