{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvExControls.pas, released on 2004-01-04

The Initial Developer of the Original Code is Andreas Hausladen [Andreas dott Hausladen att gmx dott de]
Portions created by Andreas Hausladen are Copyright (C) 2004 Andreas Hausladen.
All Rights Reserved.

Contributor(s): -

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvExControls;

{$I jvcl.inc}

WARNINGHEADER

interface

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF MSWINDOWS}
  {$IFDEF HAS_UNIT_LIBC}
  Libc,
  {$ENDIF HAS_UNIT_LIBC}
  {$IFDEF VCL}
  Messages,
  {$ENDIF VCL}
  Graphics, Controls, Forms,
  {$IFDEF VisualCLX}
  Qt, QTypes, QStdCtrls, QMask, QClipbrd, QWindows,
  {$ENDIF VisualCLX}
  Classes, SysUtils,
  JvTypes, JvThemes, JVCLVer;

{$IFDEF VCL}
 {$DEFINE NeedMouseEnterLeave}
{$ENDIF VCL}
{$IFDEF VisualCLX}
 {$IF not declared(PatchedVCLX)}
  {$DEFINE NeedMouseEnterLeave}
 {$IFEND}
{$ENDIF VisualCLX}

type
  TDlgCode = (
    dcWantAllKeys, dcWantArrows, dcWantTab, dcWantChars,
    dcButton,
    dcNative // if dcNative is in the set the native functions are used and DoGetDlgCode is ignored
  );
  TDlgCodes = set of TDlgCode;

{$IFDEF VisualCLX}
  TAlignInfo = record
    AlignList: TList;
    ControlIndex: Integer;
    Align: TAlign;
    Scratch: Integer;
  end;
  HWND = QWindows.HWND;
  TClxWindowProc = procedure(var Msg: TMessage) of object;
const
  QEventType_FontChanged = QEventType(Integer(QEventType_User) + $70);
{$ENDIF VisualCLX}

const
  dcWantMessage = dcWantAllKeys;

type
  {$IFDEF VCL}
  IPerformControl = interface
    ['{B11AA73D-D7C2-43E5-BED8-8F82DE6152AB}']
    function Perform(Msg: Cardinal; WParam, LParam: Longint): Longint;
  end;
  {$ENDIF VCL}

  IJvControlEvents = interface(IPerformControl)
    ['{61FC57FF-D4DA-4840-B871-63DE804E9921}']
    procedure VisibleChanged;
    procedure EnabledChanged;
    procedure TextChanged;
    procedure FontChanged;
    procedure ColorChanged;
    procedure ParentFontChanged;
    procedure ParentColorChanged;
    procedure ParentShowHintChanged;
    function WantKey(Key: Integer; Shift: TShiftState;
      const KeyText: WideString): Boolean; // CM_DIALOGCHAR
    function HintShow(var HintInfo: THintInfo): Boolean;
    function HitTest(X, Y: Integer): Boolean; // CM_HITTEST
    procedure MouseEnter(AControl: TControl);
    procedure MouseLeave(AControl: TControl);
    procedure DoFocusChanged(Control: TWinControl);
    {$IFDEF VCL}
    procedure SetAutoSize(Value: Boolean);
    {$ENDIF VCL}
  end;

  IJvWinControlEvents = interface(IJvControlEvents)
    ['{B5F7FB62-78F0-481D-AFF4-7A24ED6776A0}']
    procedure DoBoundsChanged;
    procedure CursorChanged;
    procedure ShowingChanged;
    procedure ShowHintChanged;
    procedure ControlsListChanging(Control: TControl; Inserting: Boolean);
    procedure ControlsListChanged(Control: TControl; Inserting: Boolean);
    procedure DoGetDlgCode(var Code: TDlgCodes); // WM_GETDLGCODE
    procedure DoSetFocus(FocusedWnd: HWND);  // WM_SETFOCUS
    procedure DoKillFocus(FocusedWnd: HWND); // WM_KILLFOCUS
    function DoPaintBackground(Canvas: TCanvas; Param: Integer): Boolean; // WM_ERASEBKGND
    {$IFDEF VisualCLX}
    procedure DoFontChanged(Sender: TObject);  // CM_FONTCHANGED
    procedure Paint;
    {$ENDIF VisualCLX}
  end;

  IJvCustomControlEvents = interface(IJvWinControlEvents)
    ['{7804BD3A-D7A5-4314-9259-6DE08A0DC38A}']
    {$IFDEF VisualCLX}
    // implements doublebuffering for  TCustomControl derived classes and
    // TJvExWidgetControl.
    function GetDoubleBuffered: Boolean;
    {$ENDIF VisualCLX}
  end;

  IJvEditControlEvents = interface(IPerformControl)
    ['{C1AE5EF8-F6C4-4BD4-879E-17946FD0FBAB}']
    procedure DoClipboardPaste;
    procedure DoClipboardCopy;
    procedure DoClipboardCut;
    procedure DoUndo;
    procedure DoClearText;
  end;

{$IFDEF VCL}
const
  CM_DENYSUBCLASSING = JvThemes.CM_DENYSUBCLASSING;
{$ENDIF VCL}
{$IFDEF VisualCLX}
const
  CM_DENYSUBCLASSING = JvQThemes.CM_DENYSUBCLASSING;
{$ENDIF VisualCLX}

type
  { Add IJvDenySubClassing to the base class list if the control should not
    be themed by the ThemeManager (www.delphi-gems.de).
    This only works with JvExVCL derived classes. }
  IJvDenySubClassing = interface
    ['{76942BC0-2A6E-4DC4-BFC9-8E110DB7F601}']
  end;

{$IFDEF VisualCLX}
const
  CM_FOCUSCHANGED = CM_BASE + 17; // VCL Controls: CM_BASE + 7

type
  TCMFocusChanged = record
    Msg: Cardinal;
    Unused: Integer;
    Sender: TWinControl;
    Result: Longint;
  end;
{$ENDIF VisualCLX}

type
  JV_CONTROL_EVENTS(Control)
  JV_WIDGETCONTROL_EVENTS(WinControl)
  JV_CONTROL_EVENTS_BEGIN(GraphicControl)
  JV_CONSTRUCTOR
  {$IFDEF VisualCLX}
  private
    FText: TCaption; // TControl does not save the Caption property
  protected
    function GetText: TCaption; override;
    procedure SetText(const Value: TCaption); override;
    procedure PaintRequest; override;
  {$ENDIF VisualCLX}
  JV_CONTROL_EVENTS_END(GraphicControl)

  {$UNDEF CONSTRUCTORCODE}
  {$DEFINE CONSTRUCTORCODE DoubleBuffered := True;}
  JV_CUSTOMCONTROL_EVENTS(CustomControl)
  {$UNDEF CONSTRUCTORCODE}
  {$DEFINE CONSTRUCTORCODE}

  JV_CUSTOMCONTROL_EVENTS(HintWindow)
  {$IFDEF VisualCLX}
  JV_WINCONTROL_EVENTS(FrameControl)
  {$ENDIF VisualCLX}


{$IFDEF VCL}

function ShiftStateToKeyData(Shift: TShiftState): Longint;

function InheritMsgEx(Instance: TControl; Msg: Integer; WParam, LParam: Integer): Integer; overload;
function InheritMsg(Instance: TControl; Msg: Integer): Integer; overload;
procedure InheritMessage(Instance: TControl; var Msg: TMessage); overload;
procedure DispatchMsg(Instance: TControl; var Msg);

// jump targets:

procedure Control_ControlsListChanging(Instance: TControl; Control: TControl;
  Inserting: Boolean);
procedure Control_ControlsListChanged(Instance: TControl; Control: TControl;
  Inserting: Boolean);

{$IFDEF COMPILER5}
procedure TOpenControl_SetAutoSize(Instance: TControl; Value: Boolean);
{$ENDIF COMPILER5}

{$ENDIF VCL}

{$IFDEF VCL}
procedure Control_MouseEnter(Instance, Control: TControl; var FMouseOver: Boolean;
  var FSavedHintColor: TColor; FHintColor: TColor; var Event: TNotifyEvent);
{$ENDIF VCL}
{$IFDEF VisualCLX}
procedure Control_MouseEnter(Instance, Control: TControl; var FMouseOver: Boolean;
  var FSavedHintColor: TColor; FHintColor: TColor);
{$ENDIF VisualCLX}

{$IFDEF VCL}
procedure Control_MouseLeave(Instance, Control: TControl; var FMouseOver: Boolean;
  var FSavedHintColor: TColor; var Event: TNotifyEvent);
{$ENDIF VCL}
{$IFDEF VisualCLX}
procedure Control_MouseLeave(Instance, Control: TControl; var FMouseOver: Boolean; FSavedHintColor: TColor);
{$ENDIF VisualCLX}

function DefaultDoPaintBackground(Instance: TWinControl; Canvas: TCanvas; Param: Integer): Boolean;

{$IFDEF VisualCLX}
// handles fontchanged & focuschanged
function WidgetControl_EventFilter(Instance: TWidgetControl; Sender: QObjectH; Event: QEventH): Boolean;

// Paint method for native Qt Controls
procedure WidgetControl_DefaultPaint(Instance: TWidgetControl; Canvas: TCanvas);
procedure WidgetControl_Painting(Instance: TWidgetControl; Canvas: TCanvas;
  EventRegion: QRegionH);

// - redirects Canvas.Handle to a Pixmap if Instance.DoubleBuffered is set
// - calls Instance.Paint
procedure CustomControl_Painting(Instance: TWidgetControl; Canvas: TCanvas;
  EventRegion: QRegionH);
procedure WidgetControl_ColorChanged(Instance: TWidgetControl);

// support for PaintTo & PaintWindow
procedure WidgetControl_PaintTo(Instance: TWidgetControl; PaintDevice: QPaintDeviceH; X, Y: integer);

function WidgetControl_NeedKey(Instance: TWidgetControl; Key: Integer;
  Shift: TShiftState; const KeyText: WideString; InheritedValue: Boolean): Boolean;

{$ENDIF VisualCLX}

procedure TCustomEdit_Undo(Instance: TWinControl);
procedure TCustomEdit_Copy(Instance: TWinControl);
procedure TCustomEdit_Paste(Instance: TWinControl);
procedure TCustomEdit_Cut(Instance: TWinControl);

implementation

{$IFDEF VCL}

function ShiftStateToKeyData(Shift: TShiftState): Longint;
const
  AltMask = $20000000;
begin
  Result := 0;
  if ssAlt in Shift then
    Result := Result or AltMask;
end;

type
  PInterface = ^IInterface;

  TFreeNotificationHelper = class(TComponent)
  private
    FInstance: TComponent;
    FIntfPtr: PInterface;
  protected
    procedure Notification(Component: TComponent; Operation: TOperation); override;
  public
    constructor Create(AInstance: TComponent; AIntfPtr: PInterface); reintroduce;
    destructor Destroy; override;
    function IsValid: Boolean;
  end;

constructor TFreeNotificationHelper.Create(AInstance: TComponent; AIntfPtr: PInterface);
begin
  inherited Create(nil);
  FIntfPtr := AIntfPtr;
  if csDestroying in AInstance.ComponentState then
    FInstance := nil
  else
  begin
    FInstance := AInstance;
    FInstance.FreeNotification(Self);
  end;
end;

destructor TFreeNotificationHelper.Destroy;
begin
  if Assigned(FInstance) then
    FInstance.RemoveFreeNotification(Self);
  inherited Destroy;
end;

function TFreeNotificationHelper.IsValid: Boolean;
begin
  Result := FIntfPtr <> nil;
end;

procedure TFreeNotificationHelper.Notification(Component: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (Component = FInstance) then
  begin
   // (ahuser) The component destroys the whole list so the following line could
   //          be removed (but who knowns what the Delphi IDE will do without
   //          this line.
    FInstance.RemoveFreeNotification(Self);
    FInstance := nil;
    FIntfPtr^ := nil;
    FIntfPtr := nil;
  end;
end;


function InheritMsgEx(Instance: TControl; Msg: Integer; WParam, LParam: Integer): Integer;
var
  Mesg: TMessage;
begin
  Mesg.Msg := Msg;
  Mesg.WParam := WParam;
  Mesg.LParam := LParam;
  Mesg.Result := 0;
  InheritMessage(Instance, Mesg);
  Result := Mesg.Result;
end;

function InheritMsg(Instance: TControl; Msg: Integer): Integer;
begin
  Result := InheritMsgEx(Instance, Msg, 0, 0);
end;

procedure InheritMessage(Instance: TControl; var Msg: TMessage);
type
  TDispatchMethod = procedure(Self: TObject; var Msg: TMessage);
var
  Proc: TDispatchMethod;
begin
  Proc := @TObject.Dispatch;
  Proc(Instance, Msg);
end;

procedure DispatchMsg(Instance: TControl; var Msg);
var
  Temp: IJvDenySubClassing;
  IntfControl: IJvControlEvents;
  IntfWinControl: IJvWinControlEvents;
  IntfEditControl: IJvEditControlEvents;
  PMsg: PMessage;
  CallInherited: Boolean;
  Canvas: TCanvas;
  DlgCodes: TDlgCodes;
  IdSaveDC: Integer;
  Helper: TFreeNotificationHelper;
begin
  CallInherited := True;
  PMsg := @Msg;

  if PMsg^.Msg = CM_DENYSUBCLASSING then
  begin
    PMsg^.Result := Ord(Instance.GetInterface(IJvDenySubClassing, Temp));
    Temp := nil; // does not destroy the control because it is derived from TComponent
   // Let the control handle CM_DENYSUBCLASSING the old way, too.
  end;

  { GetInterface is no problem because Instance is a TComponent derived class that
    is not released by an interface "Release". }
  if Instance.GetInterface(IJvControlEvents, IntfControl) then
  begin
    CallInherited := False;
    try
      with IntfControl do
        case PMsg^.Msg of
          CM_VISIBLECHANGED:
            VisibleChanged;
          CM_ENABLEDCHANGED:
            EnabledChanged;
          CM_FONTCHANGED:
            FontChanged;
          CM_COLORCHANGED:
            ColorChanged;
          CM_PARENTFONTCHANGED:
            ParentFontChanged;
          CM_PARENTCOLORCHANGED:
            ParentColorChanged;
          CM_PARENTSHOWHINTCHANGED:
            ParentShowHintChanged;
          CM_TEXTCHANGED:
            TextChanged;
          CM_HINTSHOW:
            PMsg^.Result := Integer(HintShow(TCMHintShow(PMsg^).HintInfo^));
          CM_HITTEST:
            with TCMHitTest(PMsg^) do
              Result := Integer(HitTest(XPos, YPos));
          CM_MOUSEENTER:
              MouseEnter(TControl(PMsg^.LParam));
          CM_MOUSELEAVE:
              MouseLeave(TControl(PMsg^.LParam));
          CM_DIALOGCHAR:
            with TCMDialogChar(PMsg^) do
              Result := Ord(WantKey(CharCode, KeyDataToShiftState(KeyData), WideChar(CharCode)));
          // CM_FOCUSCHANGED: handled by a message handler in the JvExVCL classes
        else
          CallInherited := True;
        end;
    finally
      IntfControl := nil;
    end;
  end;

  if CallInherited then
  begin
    if Instance.GetInterface(IJvWinControlEvents, IntfWinControl) then
    begin
      CallInherited := False;
      try
        with IntfWinControl do
          case PMsg^.Msg of
            CM_CURSORCHANGED:
              CursorChanged;
            CM_SHOWINGCHANGED:
              ShowingChanged;
            CM_SHOWHINTCHANGED:
              ShowHintChanged;
            CM_CONTROLLISTCHANGE:
              if PMsg^.LParam <> 0 then
                ControlsListChanging(TControl(PMsg^.WParam), True)
              else
                ControlsListChanged(TControl(PMsg^.WParam), False);
            CM_CONTROLCHANGE:
              if PMsg^.LParam = 0 then
                ControlsListChanging(TControl(PMsg^.WParam), False)
              else
                ControlsListChanged(TControl(PMsg^.WParam), True);
            WM_GETDLGCODE:
              begin
                Helper := TFreeNotificationHelper.Create(Instance, @IntfWinControl);
                try
                  InheritMessage(Instance, PMsg^);

                  DlgCodes := [dcNative];
                  if PMsg^.Result and DLGC_WANTARROWS <> 0 then
                    Include(DlgCodes, dcWantArrows);
                  if PMsg^.Result and DLGC_WANTTAB <> 0 then
                    Include(DlgCodes, dcWantTab);
                  if PMsg^.Result and DLGC_WANTALLKEYS <> 0 then
                    Include(DlgCodes, dcWantAllKeys);
                  if PMsg^.Result and DLGC_WANTCHARS <> 0 then
                    Include(DlgCodes, dcWantChars);
                  if PMsg^.Result and DLGC_BUTTON <> 0 then
                    Include(DlgCodes, dcButton);

                  if Helper.IsValid then
                  begin
                    DoGetDlgCode(DlgCodes);

                    if not (dcNative in DlgCodes) then
                    begin
                      PMsg^.Result := 0;
                      if dcWantAllKeys in DlgCodes then
                        PMsg^.Result := PMsg^.Result or DLGC_WANTALLKEYS;
                      if dcWantArrows in DlgCodes then
                        PMsg^.Result := PMsg^.Result or DLGC_WANTARROWS;
                      if dcWantTab in DlgCodes then
                        PMsg^.Result := PMsg^.Result or DLGC_WANTTAB;
                      if dcWantChars in DlgCodes then
                        PMsg^.Result := PMsg^.Result or DLGC_WANTCHARS;
                      if dcButton in DlgCodes then
                        PMsg^.Result := PMsg^.Result or DLGC_BUTTON;
                    end;
                  end;
                finally
                  Helper.Free;
                end;
              end;
            WM_SETFOCUS:
              begin
                Helper := TFreeNotificationHelper.Create(Instance, @IntfWinControl);
                try
                  InheritMessage(Instance, PMsg^);
                  if Helper.IsValid then
                    DoSetFocus(HWND(PMsg^.WParam));
                finally
                  Helper.Free;
                end;
              end;
            WM_KILLFOCUS:
              begin
                Helper := TFreeNotificationHelper.Create(Instance, @IntfWinControl);
                try
                  InheritMessage(Instance, PMsg^);
                  if Helper.IsValid then
                    DoKillFocus(HWND(PMsg^.WParam));
                finally
                  Helper.Free;
                end;
              end;
            WM_SIZE:
              begin
                DoBoundsChanged;
                IntfWinControl := nil;
                InheritMessage(Instance, PMsg^);
              end;
            WM_ERASEBKGND:
              begin
                IdSaveDC := SaveDC(HDC(PMsg^.WParam)); // protect DC against Stock-Objects from Canvas
                Canvas := TCanvas.Create;
                try
                  Canvas.Handle := HDC(PMsg^.WParam);
                  PMsg^.Result := Ord(DoPaintBackground(Canvas, PMsg^.LParam));
                finally
                  Canvas.Handle := 0;
                  Canvas.Free;
                  RestoreDC(HDC(PMsg^.WParam), IdSaveDC);
                end;
              end;
            WM_PRINTCLIENT,
            WM_PRINT:
              begin
                IdSaveDC := SaveDC(HDC(PMsg^.WParam)); // protect DC against changes
                try
                  InheritMessage(Instance, PMsg^);
                finally
                  RestoreDC(HDC(PMsg^.WParam), IdSaveDC);
                end;
              end;
          else
            CallInherited := True;
        end;
      finally
        IntfWinControl := nil;
      end;
    end;
  end;

  if CallInherited then
  begin
    if Instance.GetInterface(IJvEditControlEvents, IntfEditControl) then
    begin
      CallInherited := False;
      try
        with IntfEditControl do
          case PMsg^.Msg of
            WM_PASTE:
              begin
                DoClipboardPaste;
                PMsg^.Result := 1;
              end;
            WM_COPY:
              begin
                // The PSDK documentation says that WM_COPY does not has a result
                // value. This is wrong. WM_COPY returns the number of chars that
                // were copied to the clipboard. Unfortunatelly does the CLX methods
                // have no return value and so return 1. If we do not do this
                // WM_CUT will not work.
                DoClipboardCopy;
                PMsg^.Result := 1;
              end;
            WM_CUT:
              begin
                DoClipboardCut;
                PMsg^.Result := 1;
              end;
            WM_UNDO, EM_UNDO:
              begin
                DoUndo;
                PMsg^.Result := 1;
              end;
            WM_CLEAR:
              begin
                DoClearText;
                PMsg^.Result := 1;
              end;
          else
            CallInherited := True;
          end;
      finally
        IntfEditControl := nil;
      end;
    end;
  end;

  if CallInherited then
    InheritMessage(Instance, PMsg^);
end;

{ VCL sends CM_CONTROLLISTCHANGE and CM_CONTROLCHANGE in an other order than
  the CLX methods are used. So we must correct it by evaluating "Inserting". }
procedure Control_ControlsListChanging(Instance: TControl; Control: TControl;
  Inserting: Boolean);
begin
  if Inserting then
    InheritMsgEx(Instance, CM_CONTROLLISTCHANGE, Integer(Control), Integer(Inserting))
  else
    InheritMsgEx(Instance, CM_CONTROLCHANGE, Integer(Control), Integer(Inserting))
end;

procedure Control_ControlsListChanged(Instance: TControl; Control: TControl;
  Inserting: Boolean);
begin
  if not Inserting then
    InheritMsgEx(Instance, CM_CONTROLLISTCHANGE, Integer(Control), Integer(Inserting))
  else
    InheritMsgEx(Instance, CM_CONTROLCHANGE, Integer(Control), Integer(Inserting))
end;

{$ENDIF VCL}

{$IFDEF VCL}
procedure Control_MouseEnter(Instance, Control: TControl; var FMouseOver: Boolean;
  var FSavedHintColor: TColor; FHintColor: TColor; var Event: TNotifyEvent);
{$ENDIF VCL}
{$IFDEF VisualCLX}
procedure Control_MouseEnter(Instance, Control: TControl; var FMouseOver: Boolean;
  var FSavedHintColor: TColor; FHintColor: TColor);
{$ENDIF VisualCLX}
begin
  // (HEG) VCL: Control is nil iff Instance is the control that the mouse has left.
  // Otherwise this is just a notification that the mouse entered
  // one of its child controls
  if {$IFDEF VCL} (Control = nil) and {$ENDIF} not FMouseOver and not (csDesigning in Instance.ComponentState) then
  begin
    FMouseOver := True;
    FSavedHintColor := Application.HintColor;
    if FHintColor <> clNone then
      Application.HintColor := FHintColor;
    {$IFDEF VCL}
    if Assigned(Event) then
      Event(Instance);
    {$ENDIF VCL}
  end;
  {$IFDEF VCL}
  InheritMsgEx(Instance, CM_MOUSEENTER, 0, Integer(Control));
  {$ENDIF VCL}
end;

{$IFDEF VCL}
procedure Control_MouseLeave(Instance, Control: TControl; var FMouseOver: Boolean;
  var FSavedHintColor: TColor; var Event: TNotifyEvent);
{$ENDIF VCL}
{$IFDEF VisualCLX}
procedure Control_MouseLeave(Instance, Control: TControl; var FMouseOver: Boolean; FSavedHintColor: TColor);
{$ENDIF VisualCLX}
begin
  // (HEG) Control is nil iff Instance is the control that the mouse has left.
  // Otherwise this is just a notification that the mouse left
  // one of its child controls
  if {$IFDEF VCL} (Control = nil) and {$ENDIF} FMouseOver and not (csDesigning in Instance.ComponentState) then
  begin
    FMouseOver := False;
    Application.HintColor := FSavedHintColor;
    {$IFDEF VCL}
    if Assigned(Event) then
      Event(Instance);
    {$ENDIF VCL}
  end;
  {$IFDEF VCL}
  InheritMsgEx(Instance, CM_MOUSELEAVE, 0, Integer(Control));
  {$ENDIF VCL}
end;

function DefaultDoPaintBackground(Instance: TWinControl; Canvas: TCanvas; Param: Integer): Boolean;
begin
  {$IFDEF VCL}
  Result := InheritMsgEx(Instance, WM_ERASEBKGND, Canvas.Handle, Param) <> 0;
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  Result := False;
  {$ENDIF VisualCLX}
end;

type
  TControlAccessProtected = class(TControl);
{$IFDEF VisualCLX}
  TWidgetControlAccessProtected = class(TWidgetControl);
  TCustomControlAccessProtected = class(TCustomControl);
  TCustomEditAccessProtected = class(TCustomEdit);
  TCustomMaskEditAccessProtected = class(TCustomMaskEdit);

procedure WidgetControl_PaintTo(Instance: TWidgetControl; PaintDevice: QPaintDeviceH; X, Y: integer);
var
  PixMap: QPixmapH;
begin
  PixMap := QPixmap_create;
  try
    with Instance do
    begin
      QPixmap_grabWidget(PixMap, Handle, 0, 0, Width, Height);
      Qt.BitBlt(PaintDevice, X, Y, PixMap, 0, 0, Width, Height, RasterOp_CopyROP, True);
    end;
  finally
    QPixMap_destroy(PixMap);
  end;
end;

function WidgetControl_EventFilter(Instance: TWidgetControl; Sender: QObjectH; Event: QEventH): Boolean;
var
  Intf: IJvWinControlEvents;
  Wnd: QWidgetH;
begin
  Result := false;
  try
    case QEvent_type(Event) of
      QEventType_FocusIn, QEventType_FocusOut:
        begin
          if Supports(Instance, IJvWinControlEvents, Intf) then
          begin
            if Screen.ActiveControl <> nil then
              Wnd := Screen.ActiveControl.Handle
            else
              Wnd := nil;
            if QEvent_type(Event) = QEventType_FocusIn then
              Intf.DoSetFocus(Wnd)
            else
              Intf.DoKillFocus(Wnd);
          end;
        end;
      QEventType_FontChanged:
        begin
          if Supports(Instance, IJvWinControlEvents, Intf) then
          begin
            Intf.DoFontChanged(Instance);
            Result := true;
          end;
        end;
    end;
  except
    on E: Exception do
    begin
      Application.ShowException(E);
      Result := False;
    end;
  end;
end;

procedure CustomControl_Painting(Instance: TWidgetControl; Canvas: TCanvas;
  EventRegion: QRegionH);
var
  HasBackground: Boolean;
  Pixmap: QPixmapH;
  OriginalPainter: QPainterH;
  Intf: IJvCustomControlEvents;
  IsDoubleBuffered: Boolean;
  R: TRect;
begin
  if (csDestroying in Instance.ComponentState) or not Assigned(Instance.Parent) then
    Exit;

  R := Rect(0, 0, 0, 0);
  QRegion_boundingRect(EventRegion, @R);
  if IsRectEmpty(R) then
    Exit;

  Instance.GetInterface(IJvCustomControlEvents, Intf);
  IsDoubleBuffered := Intf.GetDoubleBuffered;
  Pixmap := nil;
  OriginalPainter := nil;

  with TWidgetControlAccessProtected(Instance) do
  begin

    TControlCanvas(Canvas).StartPaint;

    if IsDoubleBuffered then
    begin
      Pixmap := QPixmap_create(Instance.Width, Instance.Height, -1, QPixmapOptimization_DefaultOptim);
      // fill with parent's background if the control has a parent
      if Instance.Parent <> nil then
        QPixmap_fill(Pixmap, Instance.Parent.Handle, QWidget_x(Instance.Handle), QWidget_y(Instance.Handle));
      OriginalPainter := Canvas.Handle;
      Canvas.Handle := QPainter_create(Pixmap);
      TControlCanvas(Canvas).StartPaint;
      QPainter_setClipRegion(Canvas.Handle, EventRegion);
      QPainter_setClipping(Canvas.Handle, True);
    end;
    try
      Canvas.Brush.Assign(Brush);
      Canvas.Font.Assign(Font);
      QPainter_setFont(Canvas.Handle, Canvas.Font.Handle);
      QPainter_setPen(Canvas.Handle, Canvas.Font.FontPen);
      QPainter_setBrush(Canvas.Handle, Canvas.Brush.Handle);

      HasBackground := (Instance as IJvWinControlEvents).DoPaintBackground(Canvas, 0);

      if IsDoubleBuffered then
      begin
        if not HasBackground then
        begin
          // fill with control's background
          if (QWidget_backgroundPixmap(Handle) <> nil) and
             not QPixmap_isNull(QWidget_backgroundPixmap(Handle)) then
            QPixmap_fill(Pixmap, Handle, 0, 0)
          else
          begin
            Canvas.FillRect(Rect( 0, 0, Width, Height));
          end;
        end;
      end;
      if Instance is TCustomForm then
        // TCustomForm calls Paint in it's EventFilter
      else
      if Instance is TCustomControl then
        TCustomControlAccessProtected(Instance).Paint
      else
        (Instance as IJvWinControlEvents).Paint;
    finally
      if Pixmap <> nil then
      begin
        TControlCanvas(Canvas).StopPaint;
        QPainter_destroy(Canvas.Handle);
        Canvas.Handle := OriginalPainter;
        bitBlt(QPainter_device(Canvas.Handle), R.Left, R.Top,
          Pixmap, R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top,
          RasterOp_CopyROP, True);
        QPixmap_destroy(Pixmap);
      end;
      TControlCanvas(Canvas).StopPaint;
    end;
  end;
end;

procedure WidgetControl_Painting(Instance: TWidgetControl; Canvas: TCanvas;
  EventRegion: QRegionH);
var
  R: TRect;
begin
  if (csDestroying in Instance.ComponentState) or not Assigned(Instance.Parent) then
    Exit;

  R := Rect(0, 0, 0, 0);
  QRegion_boundingRect(EventRegion, @R);
  if IsRectEmpty(R) then
    exit;
  with TWidgetControlAccessProtected(Instance) do
  begin
    TControlCanvas(Canvas).StartPaint;
    try
      Canvas.Brush.Assign(Brush);
      Canvas.Font.Assign(Font);
      QPainter_setFont(Canvas.Handle, Canvas.Font.Handle);
      QPainter_setPen(Canvas.Handle, Canvas.Font.FontPen);
      QPainter_setBrush(Canvas.Handle, Canvas.Brush.Handle);

      if Instance is TCustomForm then
        // TCustomForm calls Paint in it's EventFilter
      else
        (Instance as IJvWinControlEvents).Paint;
    finally
      TControlCanvas(Canvas).StopPaint;
    end;
  end;
end;

procedure WidgetControl_DefaultPaint(Instance: TWidgetControl; Canvas: TCanvas);
var
  PaintDevice: QPaintDeviceH;
  IsActive: Boolean;
  Painting: procedure(Instance: TWidgetControl; Sender: QObjectH; EventRegion: QRegionH);
  Painter: QPainterH;
begin
  if not (csDestroying in Instance.ComponentState) and
     (not Supports(Instance, IJvCustomControlEvents)) then
       { TCustomControls do not have a Qt paint method. }
  begin
   // Canvas.StopPaint uses a counter, but we must garantee the Stop.
    PaintDevice := nil;
    Painter := Canvas.Handle;
    IsActive := QPainter_isActive(Painter);
    if IsActive then
    begin
      PaintDevice := QPainter_device(Painter);
      QPainter_end(Painter);
    end;
    try
      Painting := @TWidgetControlAccessProtected.Painting;
     // default painting
      Painting(Instance, Instance.Handle, QPainter_clipRegion(Painter));
    finally
      // restore
      if IsActive then
        QPainter_begin(Painter, PaintDevice); // restart
    end;
  end;
end;

function WidgetControl_NeedKey(Instance: TWidgetControl; Key: Integer;
  Shift: TShiftState; const KeyText: WideString; InheritedValue: Boolean): Boolean;

  function IsTabKey: Boolean;
  begin
    Result := (Key = Key_Tab) or (Key = Key_BackTab);
  end;

  function IsArrowKey: Boolean;
  begin
    Result := (Key = Key_Left) or (Key = Key_Right) or (Key = Key_Down) or (Key = Key_Up);
  end;

var
  DlgCodes: TDlgCodes;
  Value: TInputKeys;
begin
  Result := InheritedValue;
  Value := TWidgetControlAccessProtected(Instance).InputKeys;

  DlgCodes := [dcNative];
  if ikAll in Value then
    Include(DlgCodes, dcWantAllKeys);
  if ikArrows in Value then
    Include(DlgCodes, dcWantArrows);
  if ikTabs in Value then
    Include(DlgCodes, dcWantTab);
  if ikChars in Value then
    Include(DlgCodes, dcWantChars);

  (Instance as IJvWinControlEvents).DoGetDlgCode(DlgCodes);

  if not (dcNative in DlgCodes) then
  begin
    Result := False;
    if dcWantAllKeys in DlgCodes then
      Result := True;
    if (not Result) and (dcWantTab in DlgCodes) then
      Result := IsTabKey;
    if (not Result) and (dcWantArrows in DlgCodes) then
      Result := IsArrowKey;
    if (not Result) and (dcWantChars in DlgCodes) then
      Result := ((Shift * [ssCtrl, ssAlt] = []) and
        ((Hi(Word(Key)) = 0) or (Length(KeyText) > 0))) and
        not (IsTabKey or IsArrowKey);
  end;
end;

procedure WidgetControl_ColorChanged(Instance: TWidgetControl);
var
  TC: QColorH;
  Intf: IJvCustomControlEvents;
begin
  with TWidgetControlAccessProtected(Instance) do
  begin
    HandleNeeded;
    Instance.GetInterface(IJvCustomControlEvents, Intf);
    if Bitmap.Empty then
    begin
      Palette.Color := Brush.Color;
      if not Intf.GetDoubleBuffered then
      begin
        TC := QColor(Color);
        QWidget_setBackgroundColor(Handle, TC);
        QColor_destroy(TC);
      end;
    end;
    NotifyControls(CM_PARENTCOLORCHANGED);
    Invalidate;
  end;
end;

procedure QClxLineEdit_undo(handle: QLineEditH);
var
  W: WideString;
  Event: QKeyEventH;
begin
  W := 'Z';
  Event := QKeyEvent_create(QEventType_KeyPress, KEY_Z, Ord('Z'),
    Integer(ButtonState_ControlButton), @W, False, 1);
  try
    QApplication_sendEvent(handle, Event);
  finally
    QKeyEvent_destroy(Event);
  end;
end;

{$ENDIF VisualCLX}

procedure TCustomEdit_Undo(Instance: TWinControl);
begin
  {$IFDEF VCL}
  InheritMsg(Instance, WM_UNDO);
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  if Instance is TCustomMemo then
    QMultiLineEdit_undo(QMultiLineEditH(Instance.Handle))
  else
  if Instance is TCustomEdit then
    QClxLineEdit_undo(QClxLineEditH(Instance.Handle));
  {$ENDIF VisualCLX}
end;

procedure TCustomEdit_Copy(Instance: TWinControl);
begin
  {$IFDEF VCL}
  InheritMsg(Instance, WM_COPY);
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  if Instance is TCustomMemo then
    QMultiLineEdit_copy(QMultiLineEditH(Instance.Handle))
  else
  if Instance is TCustomEdit then
    QClxLineEdit_copy(QClxLineEditH(Instance.Handle));
  {$ENDIF VisualCLX}
end;

procedure TCustomEdit_Cut(Instance: TWinControl);
begin
  {$IFDEF VCL}
  InheritMsg(Instance, WM_CUT);
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  if Instance is TCustomMemo then
    QMultiLineEdit_cut(QMultiLineEditH(Instance.Handle))
  else
  if Instance is TCustomMaskEdit then
  begin
    if not (TCustomMaskEdit(Instance).IsMasked) then  // CutToClipboard would call "inherited"
      QClxLineEdit_cut(QClxLineEditH(Instance.Handle))
    else
      TCustomMaskEdit(Instance).CutToClipboard;
  end
  else
  if Instance is TCustomEdit then
    QClxLineEdit_cut(QClxLineEditH(Instance.Handle));
  {$ENDIF VisualCLX}
end;

procedure TCustomEdit_Paste(Instance: TWinControl);
  {$IFDEF VisualCLX}
  procedure LineEditPaste;
  var
    WValue: WideString;
  begin
    WValue := Clipboard.AsText;
    case TCustomEditAccessProtected(Instance).CharCase of
      ecUpperCase:
        WValue := WideUpperCase(WValue);
      ecLowerCase:
        WValue := WideLowerCase(WValue);
    end;
    QClxLineEdit_insert(QClxLineEditH(Instance.Handle), PWideString(@WValue));
    QClxLineEdit_resetSelection(QClxLineEditH(Instance.Handle));
  end;
  {$ENDIF VisualCLX}
begin
  {$IFDEF VCL}
  InheritMsg(Instance, WM_PASTE);
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  if Instance is TCustomMemo then
    QMultiLineEdit_paste(QMultiLineEditH(Instance.Handle))
  else
  if Instance is TCustomMaskEdit then
  begin
    if not TCustomMaskEdit(Instance).IsMasked or
       TCustomMaskEditAccessProtected(Instance).ReadOnly then  // PasteFromClipboard would call "inherited"
      QClxLineEdit_cut(QClxLineEditH(Instance.Handle))
    else
      TCustomMaskEdit(Instance).CutToClipboard;
  end
  else
  if Instance is TCustomEdit then
    LineEditPaste;
  {$ENDIF VisualCLX}
end;

// *****************************************************************************

JV_CONTROL_EVENTS_IMPL(Control)

JV_WIDGETCONTROL_EVENTS_IMPL(WinControl)

JV_CONTROL_EVENTS_IMPL_BEGIN(GraphicControl)
{$IFDEF VisualCLX}
function TJvExGraphicControl.GetText: TCaption;
begin
  Result := FText;
end;

procedure TJvExGraphicControl.SetText(const Value: TCaption);
begin
  if Value <> FText then
  begin
    FText := Value;
    TextChanged;
  end;
end;

procedure TJvExGraphicControl.PaintRequest;
begin
  if not Assigned(Parent) then
    Exit;
  Canvas.Start;
  try
    Canvas.Brush.Color := Color;
    Canvas.Brush.Style := bsSolid;
    Canvas.Font.Assign(Font);
    QPainter_setFont(Canvas.Handle, Canvas.Font.Handle);
    QPainter_setPen(Canvas.Handle, Canvas.Font.FontPen);
    QPainter_setBrush(Canvas.Handle, Canvas.Brush.Handle);
    inherited PaintRequest;
  finally
    Canvas.Stop;
  end;
end;
{$ENDIF VisualCLX}

JV_CONTROL_EVENTS_IMPL_END(GraphicControl)
JV_CUSTOMCONTROL_EVENTS_IMPL(CustomControl)
JV_CUSTOMCONTROL_EVENTS_IMPL(HintWindow)
{$IFDEF VisualCLX}
JV_WINCONTROL_EVENTS_IMPL(FrameControl)
{$ENDIF VisualCLX}


// *****************************************************************************

type
  PBoolean = ^Boolean;
  PPointer = ^Pointer;

function ReadProtectedMemory(Address: Pointer; var Buffer; Count: Cardinal): Boolean;
var
  n: Cardinal;
begin
  Result := ReadProcessMemory(GetCurrentProcess, Address, @Buffer, Count, n);
  Result := Result and (n = Count);
end;

function WriteProtectedMemory(Address: Pointer; const Buffer; Count: Cardinal): Boolean;
var
  n: Cardinal;
begin
  Result := WriteProcessMemory(GetCurrentProcess, Address, @Buffer, Count, n);
  Result := Result and (n = Count);
end;

type
  TJumpCode = packed record
    Pop: Byte; // pop xxx
    Jmp: Byte; // jmp Offset
    Offset: Integer;
  end;

  TOrgCallCode = packed record
    Push: Byte; // push ebx/ebp
    InjectedCode: TJumpCode;
    Jmp: Byte; // jmp Offset
    Offset: Integer;
    Address: Pointer;
  end;

function GetRelocAddress(ProcAddress: Pointer): Pointer;
type
  TRelocationRec = packed record
    Jump: Word;
    Address: PPointer;
  end;
var
  Relocation: TRelocationRec;
  Data: Byte;
begin
  Result := ProcAddress;
 // the relocation table meight be protected
  if ReadProtectedMemory(ProcAddress, Data, SizeOf(Data)) then
  begin
    if Data = $FF then // ProcAddress is in a dll or package
      if ReadProtectedMemory(ProcAddress, Relocation, SizeOf(Relocation)) then
        Result := Relocation.Address^;
  end;
end;

function InstallProcHook(ProcAddress, HookProc, OrgCallProc: Pointer): Boolean;
var
  Code: TJumpCode;
  OrgCallCode: TOrgCallCode;
begin
  ProcAddress := GetRelocAddress(ProcAddress);
  Result := False;
  if Assigned(ProcAddress) and Assigned(HookProc) then
  begin
    if OrgCallProc <> nil then
    begin
      if ReadProtectedMemory(ProcAddress, OrgCallCode, SizeOf(OrgCallCode) - (1 + SizeOf(Integer))) then
      begin
        OrgCallCode.Jmp := $E9;
        OrgCallCode.Offset := (Integer(ProcAddress) + 1 + SizeOf(Code)) -
          Integer(OrgCallProc) -
          (SizeOf(OrgCallCode) - SizeOf(OrgCallCode.Address));
        OrgCallCode.Address := ProcAddress;

        WriteProtectedMemory(OrgCallProc, OrgCallCode, SizeOf(OrgCallCode));
        FlushInstructionCache(GetCurrentProcess, OrgCallProc, SizeOf(OrgCallCode));
      end;
    end;

    if PByte(ProcAddress)^ = $53 then // push ebx
      Code.Pop := $5B // pop ebx
    else
    if PByte(ProcAddress)^ = $55 then // push ebp
      Code.Pop := $5D // pop ebp
    else
      Exit;
    Code.Jmp := $E9;
    Code.Offset := Integer(HookProc) - (Integer(ProcAddress) + 1) - SizeOf(Code);

   { The strange thing is that something overwrites the $e9 with a "PUSH xxx" }
    if WriteProtectedMemory(Pointer(Cardinal(ProcAddress) + 1), Code,
         SizeOf(Code)) then
    begin
      FlushInstructionCache(GetCurrentProcess, ProcAddress, SizeOf(Code));
      Result := True;
    end;
  end;
end;

function UninstallProcHook(OrgCallProc: Pointer): Boolean;
var
  OrgCallCode: TOrgCallCode;
  ProcAddress: Pointer;
begin
  Result := False;
  if Assigned(OrgCallProc) then
  begin
    if OrgCallProc <> nil then
    begin
      if ReadProtectedMemory(OrgCallProc, OrgCallCode, SizeOf(OrgCallCode)) then
      begin
        ProcAddress := OrgCallCode.Address;

        Result := WriteProtectedMemory(ProcAddress, OrgCallCode, 1 + SizeOf(TJumpCode));
        FlushInstructionCache(GetCurrentProcess, ProcAddress, SizeOf(OrgCallCode));
      end;
    end;
  end;
end;

{$IFDEF COMPILER5}
var
  AutoSizeOffset: Cardinal;
  TControl_SetAutoSize: Pointer;

procedure OrgSetAutoSize(Instance: TControl; Value: Boolean);
asm
  dd    0, 0, 0, 0  // 16 Bytes
end;

procedure TOpenControl_SetAutoSize(Instance: TControl; Value: Boolean);
begin
  with TControlAccessProtected(Instance) do
  begin
    if AutoSize <> Value then
    begin
      PBoolean(Cardinal(Instance) + AutoSizeOffset)^ := Value;
      if Value then
        AdjustSize;
    end;
  end;
  // same as OrgSetAutoSize(Instance, Value); but secure
end;

procedure SetAutoSizeHook(Instance: TControl; Value: Boolean);
var
  IntfControl: IJvControlEvents;
begin
  if Instance.GetInterface(IJvControlEvents, IntfControl) then
    IntfControl.SetAutoSize(Value)
  else
    TOpenControl_SetAutoSize(Instance, Value);
end;

{$OPTIMIZATION ON} // be sure to have optimization activated
function GetCode(Instance: TControlAccessProtected): Boolean; register;
begin
  { generated code:
      8A40xx       mov al,[eax+Byte(Offset)]
  }
  Result := Instance.AutoSize;
end;

procedure SetCode(Instance: TControlAccessProtected); register;
begin
  { generated code:
      B201         mov dl,$01
      E8xxxxxxxx   call TControl.SetAutoSize
  }
  Instance.AutoSize := True;
end;

type
  PGetCodeRec = ^TGetCodeRec;
  TGetCodeRec = packed record
    Sign: Word; // $408a   bytes swapped
    Offset: Byte;
  end;

type
  PSetCodeRec = ^TSetCodeRec;
  TSetCodeRec = packed record
    Sign1: Word; // $01b2  bytes swapped
    Sign2: Byte; // $e8
    Offset: Integer;
  end;

const
  GetCodeSign = $408a;
  SetCodeSign1 = $01b2;
  SetCodeSign2 = $e8;

procedure InitHookVars;
var
  PGetCode: PGetCodeRec;
  PSetCode: PSetCodeRec;
begin
  TControl_SetAutoSize := nil;
  AutoSizeOffset := 0;

  PGetCode := @GetCode;
  PSetCode := @SetCode;

  if (PGetCode^.Sign = GetCodeSign) and
     (PSetCode^.Sign1 = SetCodeSign1) and (PSetCode^.Sign2 = SetCodeSign2) then
  begin
    AutoSizeOffset := PGetCode^.Offset;
    TControl_SetAutoSize := GetRelocAddress(
      Pointer(Integer(@SetCode) + SizeOf(TSetCodeRec) + PSetCode^.Offset));
  end;
end;

{$ENDIF COMPILER5}

{$IFDEF VISUALCLX}

function CallSetFocusedControl(Instance: TCustomForm; Control: TWidgetControl): Boolean;
asm
  dd    0, 0, 0, 0  // 16 Bytes
end;

function SetFocusedControlHook(Instance: TCustomForm; Control: TWidgetControl): Boolean;
var
  Msg: TCMFocusChanged;
begin
  if csFocusing in Instance.ControlState then
    Result := CallSetFocusedControl(Instance, Control)
  else
  begin
    Result := CallSetFocusedControl(Instance, Control);
    if Result then
    begin
      Instance.ControlState := Instance.ControlState + [csFocusing]; // lock
      try
        Msg.Msg := CM_FOCUSCHANGED;
        Msg.Unused := 0;
        Msg.Sender := Control;
        Msg.Result := 0;
        Instance.Broadcast(Msg);
      finally
        Instance.ControlState := Instance.ControlState - [csFocusing];
      end;
    end;
  end;
end;

procedure CutToClipboardHook(Instance: TWidgetControl);
var
  Intf: IJvEditControlEvents;
begin
  if Supports(Instance, IJvEditControlEvents, Intf) then
    Intf.DoClipboardCut
  else
    TCustomEdit_Cut(Instance);
end;

procedure CopyToClipboardHook(Instance: TWidgetControl);
var
  Intf: IJvEditControlEvents;
begin
  if Supports(Instance, IJvEditControlEvents, Intf) then
    Intf.DoClipboardCopy
  else
    TCustomEdit_Copy(Instance);
end;

procedure PasteFromClipboardHook(Instance: TWidgetControl);
var
  Intf: IJvEditControlEvents;
begin
  if Supports(Instance, IJvEditControlEvents, Intf) then
    Intf.DoClipboardPaste
  else
    TCustomEdit_Paste(Instance);
end;

procedure UndoHook(Instance: TWidgetControl);
var
  Intf: IJvEditControlEvents;
begin
  if Supports(Instance, IJvEditControlEvents, Intf) then
    Intf.DoUndo
  else
    TCustomEdit_Undo(Instance);
end;

var
  CallCutToClipboard, CallPasteFromClipboard,
    CallCopyToClipboard, CallUndo: TOrgCallCode;


initialization
  {$IFDEF COMPILER5}
  InitHookVars;
  InstallProcHook(TControl_SetAutoSize, @SetAutoSizeHook, @OrgSetAutoSize);
  {$ENDIF COMPILER5}

  {$IFDEF VisualCLX}
  
//  InstallProcHook(@TCustomForm.SetFocusedControl, @SetFocusedControlHook,
//    @CallSetFocusedControl);
  InstallProcHook(@TCustomEdit.CutToClipboard, @CutToClipboardHook,
    @CallCutToClipboard);
  InstallProcHook(@TCustomEdit.CopyToClipboard, @CopyToClipboardHook,
    @CallCopyToClipboard);
  InstallProcHook(@TCustomEdit.PasteFromClipboard, @PasteFromClipboardHook,
    @CallPasteFromClipboard);
  {$IFDEF COMPILER7}
  InstallProcHook(@TCustomEdit.Undo, @UndoHook,
    @CallUndo);
  {$ELSE}
  {$IF declared(PatchedVCLX)}
  InstallProcHook(@TCustomEdit.Undo, @UndoHook,
    @CallUndo);
  {$IFEND}
  {$ENDIF COMPILER7}

  {$ENDIF VisualCLX}

finalization
  {$IFDEF COMPILER5}
  UninstallProcHook(@OrgSetAutoSize);
  {$ENDIF COMPILER5}

  {$IFDEF VisualCLX}

  UninstallProcHook(@CallCutToClipboard);
  UninstallProcHook(@CallCopyToClipboard);
  UninstallProcHook(@CallPasteFromClipboard);
  {$IFDEF COMPILER7}
  UninstallProcHook(@CallUndo);
  {$ELSE}
  {$IF declared(PatchedVCLX)}
  UninstallProcHook(@CallUndo);
  {$IFEND}
  {$ENDIF COMPILER7}
//  UninstallProcHook(@CallSetFocusedControl);

  {$ENDIF VisualCLX}

end.

