{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvDatePickerEdit, released on 2002-10-04.

The Initial Developer of the Original Code is Oliver Giesen [giesen att lucatec dott de]
Portions created by Oliver Giesen are Copyright (C) 2002 Lucatec GmbH.
All Rights Reserved.

Contributor(s): Peter Th�rnqvist.

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

{$I jvcl.inc}

{ A replacement for TDateTimePicker which is better suited for keyboard-input by
 ultimately descending from TCustomMaskEdit.

 Other notable features (especially in comparison to the native DATETIMEPICKER):

 - The control is able to construct a suitable EditMask from a valid date format
  string such as the global ShortDateFormat (the default) which should make it
  adapt well to regional settings / individual requirements.

 - It is possible to specify a NoDateText which will be displayed when no date
  is selected. The original datetimepicker would display 1899-12-31 in such
  cases. This feature could be further controlled by the AllowNoDate and
  NoDateShortcut properties.

 Known issues / not (yet) implemented features:

 -there is no real support for DateFormats containing any literal characters
   other than the defined DateSeparator, especially spaces. it /might/ work in
   some cases but in the majority of cases it will not.
   TODO: simply disallow such characters or implement proper handling?

 -as the embedded MS-calendar does not support dates prior to 1752-09-14,
   neither does this control. this is not yet handled gracefully in absolutely
   all situations though.

 -the Min/MaxYear contstraints are currently commented out as they are not
   functional in the current state. they would still require some work to make
   up for two-digit year entries.

 -the control does (currently) not allow for time entry
  - it really is a control for date entry only.
}

unit JvDatePickerEdit;

interface
                                                                       
uses
  Classes, Controls, Graphics, Messages, ComCtrls, Buttons,
  JvTypes, JvCalendar, JvDropDownForm, JvCheckedMaskEdit, JvButton;

type
  {Types used to handle and convert between date format strings and EditMasks:}
  TJvDateFigure = (dfNone, dfYear, dfMonth, dfDay);
  TJvDateFigureInfo = record
    Figure: TJvDateFigure;
    Start: Byte;
    Length: Byte;
    Index: Byte;
  end;
  TJvDateFigures = array[0..2] of TJvDateFigureInfo;

  {A dropdown form with an embedded calendar control.}
  TJvDropCalendar = class(TJvCustomDropDownForm)
  private
    FCal: TJvCustomMonthCalendar;
    FWithBeep: Boolean;
    FOnChange: TNotifyEvent;
    FOnSelect: TNotifyEvent;
    FOnCancel: TNotifyEvent;
    procedure CalSelChange(Sender: TObject; StartDate, EndDate: TDateTime);
    procedure CalSelect(Sender: TObject; StartDate, EndDate: TDateTime);
    procedure CalKeyPress(Sender: TObject; var Key: Char);
    procedure CalKillFocus(const ASender: TObject; const ANextControl: TWinControl);
  protected
    procedure DoCancel;
    procedure DoChange;
    procedure DoSelect;
    procedure DoShow; override;
    function GetSelDate: TDateTime;
    procedure SetSelDate(const AValue: TDateTime);
  public
    constructor CreateWithAppearance(AOwner: TComponent;
      const AAppearance: TJvMonthCalAppearance);
    destructor Destroy; override;
    procedure SetFocus; override;
    property SelDate: TDateTime read GetSelDate write SetSelDate;
    property WithBeep: Boolean read FWithBeep write FWithBeep;
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnSelect: TNotifyEvent read FOnSelect write FOnSelect;
  end;

  TJvCustomDatePickerEdit = class(TJvCustomCheckedMaskEdit)
  private
    FAllowNoDate: Boolean;
    FDropButton: TJvDropDownButton;
    FButtonHolder:TWinControl;
    FCalAppearance: TJvMonthCalAppearance;
    FDate: TDateTime;
    FDateError: Boolean;
    FDeleting: Boolean;
    FCalLostFocus: Boolean;
    FDateFigures: TJvDateFigures;
    FInternalDateFormat,
    FDateFormat: string;
    FDropFo: TJvDropCalendar;
    FEnableValidation: Boolean;
    FMask: string;
    FNoDateShortcut: TShortcut;
    FNoDateText: string;
    FStoreDate: Boolean;
    FAlwaysReturnEditDate: Boolean;
    FEmptyMaskText: string;
    FStoreDateFormat: Boolean;
    FDateSeparator: Char;
    //    FMinYear: Word;
    //    FMaxYear: Word;
    procedure ButtonClick(Sender: TObject);
    procedure CalChange(Sender: TObject);
    procedure CalDestroy(Sender: TObject);
    procedure CalSelect(Sender: TObject);
    procedure CalCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CalKillFocus(const ASender: TObject; const ANextControl: TWinControl);
    function AttemptTextToDate(const AText: string; var ADate: TDateTime;
      const AForce: Boolean = False; const ARaise: Boolean = False): Boolean;
    function DateFormatToEditMask(var ADateFormat: string): string;
    function DateToText(const ADate: TDateTime): string;
    function DetermineDateSeparator(AFormat: string): Char;
    procedure ResetDateFormat;
    procedure FindSeparators(var AFigures: TJvDateFigures; const AText: string; const AGetLengths: Boolean = True);
    procedure ParseFigures(var AFigures: TJvDateFigures; AFormat: string; const AMask: string);
    procedure RaiseNoDate;
    procedure SetAllowNoDate(const AValue: Boolean);
    procedure SetCalAppearance(const AValue: TJvMonthCalAppearance);
    function GetDate: TDateTime;
    procedure SetDate(const AValue: TDateTime);
    procedure SetDateFormat(const AValue: string);
    function GetDropped: Boolean;
    procedure SetNoDateText(const AValue: string);
    procedure SetDateSeparator(const AValue: Char);
    function GetEditMask: string;
    procedure SetEditMask(const AValue: string);
    function GetText: TCaption;
    procedure SetText(const AValue: TCaption);
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  protected
    function IsNoDateShortcutStored: Boolean;
    function IsNoDateTextStored: Boolean;
    procedure Change; override;
    procedure Loaded; override;
    procedure CreateWnd; override;
    procedure DoKillFocusEvent(const ANextControl: TWinControl); override;
    procedure KeyDown(var AKey: Word; AShift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure GetInternalMargins(var ALeft, ARight: Integer); override;
    procedure DoCtl3DChanged; override;
    procedure EnabledChanged; override;
    function GetChecked: Boolean; override;
    procedure SetChecked(const AValue: Boolean); override;
    procedure SetShowCheckBox(const AValue: Boolean); override;
    function GetEnableValidation: Boolean; virtual;
    procedure UpdateDisplay; virtual;
    function ValidateDate(const ADate: TDateTime): Boolean; virtual;
    function ActiveFigure: TJvDateFigureInfo;
    procedure CloseUp; virtual;
    procedure DropDown; virtual;
    procedure ClearMask;
    procedure RestoreMask;
    function IsEmptyMaskText(const AText: string): Boolean;
    property AllowNoDate: Boolean read FAllowNoDate write SetAllowNoDate;
    property AlwaysReturnEditDate: Boolean read FAlwaysReturnEditDate write FAlwaysReturnEditDate default True;
    property CalendarAppearance: TJvMonthCalAppearance read FCalAppearance write SetCalAppearance;
    property Date: TDateTime read GetDate write SetDate stored FStoreDate;
    property DateFormat: string read FDateFormat write SetDateFormat stored FStoreDateFormat;
    property DateSeparator: Char read FDateSeparator write SetDateSeparator stored FStoreDateFormat;
    property Dropped: Boolean read GetDropped;
    property EnableValidation: Boolean read GetEnableValidation write FEnableValidation default True;
    //    property MaxYear: Word read FMaxYear write FMaxYear;
    //    property MinYear: Word read FMinYear write FMinYear;
    property NoDateShortcut: TShortcut read FNoDateShortcut write FNoDateShortcut stored IsNoDateShortcutStored;
    property NoDateText: string read FNoDateText write SetNoDateText stored IsNoDateTextStored;
    property StoreDate: Boolean read FStoreDate write FStoreDate default False;
    property StoreDateFormat: Boolean read FStoreDateFormat write FStoreDateFormat default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; virtual;
    property EditMask: string read GetEditMask write SetEditMask;
    property Text: TCaption read GetText write SetText;
  end;

  TJvDatePickerEdit = class(TJvCustomDatePickerEdit)
  public
    property Dropped;
  published
    property AllowNoDate;
    property AlwaysReturnEditDate;
    property Anchors;
    property AutoSelect;
    property AutoSize default False;
    property BorderStyle;
    property CalendarAppearance;
    property Caret;
    property CharCase;
    property Checked;
    property ClipboardCommands;
    property Color;
    property Constraints;
    property Cursor;
    property Date;
    property DateFormat;
    property DateSeparator;
    property DisabledColor;
    property DisabledTextColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EnableValidation;
    property Font;
    property GroupIndex;
    property HintColor;
    property HotTrack;
    //    property MaxYear default 2900;
    //    property MinYear default 1900;
    property NoDateShortcut;
    property NoDateText;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowCheckBox;
    property ShowHint;
    property StoreDate;
    property StoreDateFormat;
    property TabOrder;
    property Visible;
    property OnChange;
    property OnClick;
    property OnCheckClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEnabledChanged;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnKillFocus;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnParentColorChange;
    property OnSetFocus;
    property OnStartDrag;
  end;

implementation

uses
  Windows, Menus, SysUtils,
  JclStrings, JclGraphUtils,
  JvResources;

//=== TJvCustomDatePickerEdit ================================================

const
  DateMaskSuffix = '!;1;_';

constructor TJvCustomDatePickerEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAllowNoDate := True;
  FAlwaysReturnEditDate := True;
  FDate := SysUtils.Date;
  FDateError := False;
  FDeleting := False;
  FCalLostFocus := False;
  FDropFo := nil;
  FEnableValidation := True;
  //  FMaxYear := 2900;
  //  FMinYear := 1800;
  FNoDateShortcut := TextToShortCut(RsDefaultNoDateShortcut);
  FNoDateText := '';
  FStoreDate := False;
  FStoreDateFormat := False;

  FButtonHolder := TWinControl.Create(Self);
  with FButtonHolder do
  begin
    Parent := Self;
    Align := alRight;
    Width := GetSystemMetrics(SM_CXVSCROLL) + 1;
  end;
  FDropButton := TJvDropDownButton.Create(Self);
  with FDropButton do
  begin
    Align := alClient;
    Parent := FButtonHolder;
    Cursor := crArrow;
    Flat := True;
//    Width := GetSystemMetrics(SM_CXVSCROLL) + 1;
    OnClick := ButtonClick;
    Visible := True;
  end;

  FCalAppearance := TJvMonthCalAppearance.Create;
end;

destructor TJvCustomDatePickerEdit.Destroy;
begin
  CloseUp;
  FDropButton.OnClick := nil;
  FreeAndNil(FCalAppearance);
  inherited Destroy;
end;

procedure TJvCustomDatePickerEdit.Loaded;
begin
  inherited Loaded;
  UpdateDisplay;
end;

procedure TJvCustomDatePickerEdit.ButtonClick(Sender: TObject);
begin
  if Dropped then
    CloseUp
  else
    DropDown;
end;

procedure TJvCustomDatePickerEdit.CalChange(Sender: TObject);
begin
  Text := DateToText(FDropFo.SelDate);
end;

procedure TJvCustomDatePickerEdit.CalSelect(Sender: TObject);
begin
  Self.Date := FDropFo.SelDate;
  NotifyIfChanged;
end;

procedure TJvCustomDatePickerEdit.CalKillFocus(const ASender: TObject;
  const ANextControl: TWinControl);
begin
  {We've got to catch the case where the user moves the focus somewhere else
   while the calendar is visible. Otherwise the control might erroneously try
   to refocus itself in method CloseUp where this could not be tested as the
   calendar will no longer be "leaving" by that time already.}
  if (ANextControl = nil) or ((ANextControl <> Self) and (ANextControl.Owner <> Self)) then
    FCalLostFocus := True;
end;

procedure TJvCustomDatePickerEdit.CalCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  P: TPoint;
begin
  {If we would let the calendar close itself while clicking the button, the
   ButtonClick method would simply reopen it again as it would find the
   calendar closed.}
  GetCursorPos(P);
  CanClose := not PtInRect(FButtonHolder.BoundsRect, ScreenToClient(P));
end;

procedure TJvCustomDatePickerEdit.CalDestroy(Sender: TObject);
begin
  CloseUp;
  FDropFo := nil;
  FCalLostFocus := False;
end;

procedure TJvCustomDatePickerEdit.Clear;
begin
  Checked := False;
end;

procedure TJvCustomDatePickerEdit.CloseUp;
begin
  if Dropped then
  begin
    Date := FDropFo.SelDate;
    FreeAndNil(FDropFo);
  end;
  if not (Leaving or (csDestroying in ComponentState) or FCalLostFocus) then
    SetFocus;
//  FDropButton.Repaint;
end;

procedure TJvCustomDatePickerEdit.SetCalAppearance(
  const AValue: TJvMonthCalAppearance);
begin
  FCalAppearance.Assign(AValue);
end;

procedure TJvCustomDatePickerEdit.DropDown;
begin
  if not Dropped then
  begin
    if IsEmpty then
      Self.Date := SysUtils.Date;

    FDropFo := TJvDropCalendar.CreateWithAppearance(Self, FCalAppearance);
    with FDropFo do
    begin
      SelDate := Self.Date;
      OnChange := Self.CalChange;
      OnSelect := Self.CalSelect;
      OnDestroy := Self.CalDestroy;
      OnCloseQuery := Self.CalCloseQuery;
      OnKillFocus := Self.CalKillFocus;
      Show;
      SetFocus;
    end;
  end;
end;

function TJvCustomDatePickerEdit.DateToText(const ADate: TDateTime): string;
var
  OldSep: Char;
begin
  OldSep := SysUtils.DateSeparator;
  // without this a slash would always be converted to SysUtils.DateSeparator
  SysUtils.DateSeparator := Self.DateSeparator;
  try
    Result := FormatDateTime(FInternalDateFormat, ADate);
  finally
    SysUtils.DateSeparator := OldSep;
  end;
end;

function TJvCustomDatePickerEdit.GetDate: TDateTime;
begin
  Result := FDate;
end;

function TJvCustomDatePickerEdit.GetDropped: Boolean;
begin
  Result := Assigned(FDropFo) and not (csDestroying in FDropFo.ComponentState);
end;

procedure TJvCustomDatePickerEdit.GetInternalMargins(var ALeft, ARight: Integer);
begin
  inherited GetInternalMargins(ALeft, ARight);
  ARight := ARight + FButtonHolder.Width;
end;

function TJvCustomDatePickerEdit.IsEmpty: Boolean;
begin
  Result := (FDate = 0);
end;

function TJvCustomDatePickerEdit.IsNoDateTextStored: Boolean;
begin
  Result := (NoDateText <> EmptyStr);
end;

procedure TJvCustomDatePickerEdit.RaiseNoDate;
begin
  raise EJVCLException.CreateFmt(RsEMustHaveADate, [Name]);
end;

procedure TJvCustomDatePickerEdit.SetAllowNoDate(const AValue: Boolean);
begin
  if AllowNoDate <> AValue then
  begin
    FAllowNoDate := AValue;

    if AValue and IsEmpty then
      if csDesigning in ComponentState then
        Self.Date := SysUtils.Date
      else
        RaiseNoDate;

    if not AValue then
      ShowCheckBox := False;
  end;
end;

function TJvCustomDatePickerEdit.ValidateDate(const ADate: TDateTime): Boolean;
begin
  if (not AllowNoDate) and (ADate = 0) then
    RaiseNoDate;
  if (ADate < EncodeDate(1752, 09, 14)) or ((ADate > EncodeDate(1752, 09, 19)) and (ADate < EncodeDate(1752, 10, 1))) then
    { For historical/political reasons the days 1752-09-03 - 1752-09-13 do not
      exist in the Gregorian calendar - for some unknown reason the Microsoft
      calendar treats the period between 1752-09-20 and 1752-09-30 as missing
      instead, even though dates before 1752-09-14 are considered invalid as
      well (MS' offical explanation saying they only support the Gregorian
      calendar as of British adoption of it is not accurate: Britain adopted the
      Gregorian calendar starting 1752-01-01).}
    Result := False
  else
    Result := True;
end;

procedure TJvCustomDatePickerEdit.SetDate(const AValue: TDateTime);
begin
  if ValidateDate(AValue) then
    FDate := AValue;
  UpdateDisplay;
end;

procedure TJvCustomDatePickerEdit.SetNoDateText(const AValue: string);
begin
  FNoDateText := AValue;
  UpdateDisplay;
end;

procedure TJvCustomDatePickerEdit.SetShowCheckBox(const AValue: Boolean);
begin
  inherited SetShowCheckBox(AValue);
  if AValue then
    AllowNoDate := True;
  UpdateDisplay;
end;

function TJvCustomDatePickerEdit.AttemptTextToDate(const AText: string;
  var ADate: TDateTime; const AForce: Boolean; const ARaise: Boolean): Boolean;
var
  OldFormat: string;
  OldSeparator: Char;
  OldDate: TDateTime;
  Dummy: Integer;
begin
  {only attempt to convert, if at least the Mask is matched
  - otherwise we'd be swamped by exceptions during input}
  if AForce or Validate(AText, Dummy) then
  begin
    OldDate := ADate;
    OldFormat := ShortDateFormat;
    OldSeparator := SysUtils.DateSeparator;
    try
      SysUtils.DateSeparator := FDateSeparator;
      ShortDateFormat := FInternalDateFormat;
      try
        if AllowNoDate and IsEmptyMaskText(AText) then
          ADate := 0.0
        else
          ADate := StrToDate(StrRemoveChars(AText, [' ']));
        Result := True;
      except
        Result := False;
        if (ARaise) then
          raise
        else
          ADate := OldDate;
      end;
    finally
      SysUtils.DateSeparator := OldSeparator;
      ShortDateFormat := OldFormat;
    end;
  end
  else
    Result := False;
end;

procedure TJvCustomDatePickerEdit.UpdateDisplay;
begin
  if InternalChanging then
    Exit;

  BeginInternalChange;
  try
    inherited SetChecked(not IsEmpty);
    if IsEmpty then
    begin
      if not (csDesigning in ComponentState) then
      begin
        ClearMask;
        Text := NoDateText;
      end;
    end
    else
    begin
      RestoreMask;
      Text := DateToText(Self.Date)
    end;
  finally
    EndInternalChange;
  end;
end;

procedure TJvCustomDatePickerEdit.Change;
var
  lDate: TDateTime;
  lFigVal: Word;
  lActFig: TJvDateFigureInfo;

  procedure SetActiveFigVal(const AValue: Word);
  begin
    BeginInternalChange;
    try
      SelStart := lActFig.Start - 1;
      SelLength := lActFig.Length;
      SelText := Format('%.*d', [lActFig.Length, AValue]);
    finally
      EndInternalChange;
    end;
  end;

  procedure EnforceRange(const AMin, AMax: Word);
  begin
    if lFigVal > AMax then
      SetActiveFigVal(AMax)
    else
    if lFigVal < AMin then
      SetActiveFigVal(AMin);
  end;

begin
  if InternalChanging then
    Exit;

  FDateError := False;

  if [csDesigning, csDestroying] * ComponentState <> [] then
    Exit;

  try
    if Text <> NoDateText then
    begin
      lDate := Self.Date;
      if AttemptTextToDate(Text, lDate) then
      begin
        BeginInternalChange;
        try
          Self.Date := lDate
        finally
          EndInternalChange;
        end;
      end
      else
      if (not FDeleting) and EnableValidation then
      begin
        lActFig := ActiveFigure;

        if lActFig.Figure <> dfNone then
        begin
          lFigVal := StrToIntDef(Trim(Copy(Text, lActFig.Start, lActFig.Length)), 0);
          //only enforce range if the cursor is at the end of the current figure:
          if SelStart = lActFig.Start + lActFig.Length - 1 then
            case lActFig.Figure of
              dfDay:
                EnforceRange(1, 31);
              dfMonth:
                EnforceRange(1, 12);
              dfYear:
                {EnforceRange( MinYear, MaxYear)}; //year-validation still under development
            end;
        end;
        {make sure querying the date in an OnChange event handler always reflects
         the current contents of the control and not just the last valid value.}
        lDate := 0;
        AttemptTextToDate(Text, lDate, lActFig.Index = High(TJvDateFigures));
        if AlwaysReturnEditDate then
          FDate := lDate;
      end;
    end;
  finally
    FDeleting := False;
  end;
  inherited Change;
end;

function TJvCustomDatePickerEdit.IsNoDateShortcutStored: Boolean;
begin
  Result := (NoDateShortcut <> TextToShortCut(RsDefaultNoDateShortcut));
end;

procedure TJvCustomDatePickerEdit.ClearMask;
begin
  if EditMask <> '' then
  begin
    FMask := EditMask;
    if not (csDesigning in ComponentState) then
      EditMask := EmptyStr;
  end;
end;

procedure TJvCustomDatePickerEdit.RestoreMask;
begin
  if EditMask = EmptyStr then
    EditMask := FMask;
end;

procedure TJvCustomDatePickerEdit.KeyDown(var AKey: Word; AShift: TShiftState);
begin
  if Text = NoDateText then
  begin
    Text := EmptyStr;
    RestoreMask;
  end;

  if AllowNoDate and (Shortcut(AKey, AShift) = NoDateShortcut) then
  begin
    Date := 0;
  end
  else
    case AKey of
      VK_ESCAPE:
        begin
          CloseUp;
          Reset;
        end;
      VK_DOWN:
        if AShift = [ssAlt] then
          DropDown;
      VK_BACK, VK_CLEAR, VK_DELETE, VK_EREOF, VK_OEM_CLEAR:
        FDeleting := True;
    end;
  inherited KeyDown(AKey, AShift);
end;

procedure TJvCustomDatePickerEdit.SetChecked(const AValue: Boolean);
begin
  if Checked <> AValue then
  begin
    if AValue then
    begin
      if Self.Date = 0 then
        Self.Date := SysUtils.Date;
    end
    else
    begin
      Self.Date := 0;
    end;
    Change;
  end;
end;

function TJvCustomDatePickerEdit.GetChecked: Boolean;
begin
  Result := not IsEmpty;
end;

function TJvCustomDatePickerEdit.DateFormatToEditMask(
  var ADateFormat: string): string;
begin
  StrReplace(ADateFormat, 'dddddd', LongDateFormat, []);
  StrReplace(ADateFormat, 'ddddd', ShortDateFormat, []);
  StrReplace(ADateFormat, 'dddd', '', []); // unsupported: DoW as full name
  StrReplace(ADateFormat, 'ddd', '', []); // unsupported: DoW as abbrev
  StrReplace(ADateFormat, 'MMMM', 'MM', []);
  StrReplace(ADateFormat, 'MMM', 'M', []);
  Result := ADateFormat;
  StrReplace(Result, 'dd', '00', []);
  StrReplace(Result, 'd', '99', []);
  StrReplace(Result, 'MM', '00', []);
  StrReplace(Result, 'M', '99', []);
  StrReplace(Result, 'yyyy', '0099', []);
  StrReplace(Result, 'yy', '00', []);
  StrReplace(Result, ' ', '_', []);
  Result := Trim(Result) + DateMaskSuffix;
end;

function TJvCustomDatePickerEdit.DetermineDateSeparator(AFormat: string): Char;
begin
  AFormat := StrRemoveChars(Trim(AFormat), ['d', 'M', 'y']);
  if Length(AFormat) > 0 then
    Result := AFormat[1]
  else
    Result := SysUtils.DateSeparator;
end;

procedure TJvCustomDatePickerEdit.SetDateFormat(const AValue: string);
begin
  FDateFormat := AValue;
  if FDateFormat = EmptyStr then
    FDateFormat := ShortDateFormat;
  DateSeparator := DetermineDateSeparator(FDateFormat); //calls ResetDateFormat implicitly
  if FDateFormat <> ShortDateFormat then
    FStoreDateFormat := True;
end;

procedure TJvCustomDatePickerEdit.SetDateSeparator(const AValue: Char);
begin
  FDateSeparator := AValue;
  ResetDateFormat;
end;

procedure TJvCustomDatePickerEdit.ResetDateFormat;
begin
  FInternalDateFormat := FDateFormat;
  FMask := DateFormatToEditMask(FInternalDateFormat);
  ParseFigures(FDateFigures, FInternalDateFormat, FMask);
  BeginInternalChange;
  try
    EditMask := EmptyStr;
    Text := EmptyStr;
    EditMask := FMask;
    FEmptyMaskText := Text;
  finally
    EndInternalChange;
  end;
  UpdateDisplay;
end;

function TJvCustomDatePickerEdit.ActiveFigure: TJvDateFigureInfo;
var
  I: Integer;
begin
  for I := 2 downto 0 do
    if SelStart >= FDateFigures[I].Start then
    begin
      Result := FDateFigures[I];
      Exit;
    end;
  Result.Figure := dfNone;
end;

procedure TJvCustomDatePickerEdit.FindSeparators(var AFigures: TJvDateFigures;
  const AText: string; const AGetLengths: Boolean);
begin
  //TODO 3 : make up for escaped characters in EditMask
  AFigures[0].Start := 1;
  AFigures[1].Start := Pos(DateSeparator, AText) + 1;
  AFigures[2].Start := StrLastPos(DateSeparator, AText) + 1;

  if AGetLengths then
  begin
    AFigures[0].Length := AFigures[1].Start - 2;
    AFigures[1].Length := AFigures[2].Start - AFigures[1].Start - 1;
    AFigures[2].Length := Length(AText) - AFigures[2].Start + 1;
  end;
end;

procedure TJvCustomDatePickerEdit.ParseFigures(var AFigures: TJvDateFigures;
  AFormat: string; const AMask: string);
var
  i: Integer;
  DummyFigures: TJvDateFigures;
begin
  {Determine the position of the individual figures in the mask string.}
  FindSeparators(AFigures, AMask);
  AFigures[2].Length := AFigures[2].Length - Length(DateMaskSuffix);

  AFormat := UpperCase(AFormat);

  {Determine the order of the individual figures in the format string.}
  FindSeparators(DummyFigures, AFormat, False);

  for I := 0 to 2 do
  begin
    case AFormat[DummyFigures[I].Start] of
      'D':
        AFigures[I].Figure := dfDay;
      'M':
        AFigures[I].Figure := dfMonth;
      'Y':
        AFigures[I].Figure := dfYear;
    end;
    AFigures[I].Index := I;
  end;
end;

procedure TJvCustomDatePickerEdit.DoKillFocusEvent(const ANextControl: TWinControl);
var
  lDate: TDateTime;
begin
  if (ANextControl = nil) or ((ANextControl <> FDropFo) and
    (ANextControl.Owner <> FDropFo)) then
    if not FDateError then
    begin
      CloseUp;
      inherited DoKillFocusEvent(ANextControl);
      if EnableValidation then
      try
        lDate := Self.Date;
        if (Text <> NoDateText) and AttemptTextToDate(Text, lDate, True, True) then
          Self.Date := lDate;
      except
        on EConvertError do
          if not (csDestroying in ComponentState) then
          begin
            FDateError := True;
            SetFocus;
            raise;
          end
          else
            Self.Date := 0;
      end;
    end
    else
      inherited DoKillFocusEvent(ANextControl);
end;

function TJvCustomDatePickerEdit.GetEnableValidation: Boolean;
begin
  Result := FEnableValidation;
end;

procedure TJvCustomDatePickerEdit.DoCtl3DChanged;
begin
  inherited DoCtl3DChanged;
  FDropButton.Flat := not Self.Ctl3D;
end;

procedure TJvCustomDatePickerEdit.EnabledChanged;
begin
  inherited EnabledChanged;
  if not (Self.Enabled) and Dropped then
    CloseUp;
  FDropButton.Enabled := Self.Enabled;
end;

procedure TJvCustomDatePickerEdit.CreateWnd;
begin
  inherited CreateWnd;
  SetDateFormat(ShortDateFormat);
end;

function TJvCustomDatePickerEdit.IsEmptyMaskText(const AText: string): Boolean;
begin
  Result := AnsiSameStr(AText, FEmptyMaskText);
end;


function TJvCustomDatePickerEdit.GetEditMask: string;
begin
  Result := inherited EditMask;
end;

{ The only purpose of the following overrides is to overcome a known issue in
  Mask.pas where it is impossible to use the slash character in an EditMask if
  SysUtils.DateSeparator is set to something else even if the slash was escaped
  as a literal. By inheritance the following methods all end up eventually in
  Mask.MaskIntlLiteralToChar which performs the unwanted conversion. By
  temporarily setting SysUtils.DateSeparator we could circumvent this. }

procedure TJvCustomDatePickerEdit.SetEditMask(const AValue: string);
var
  OldSep: Char;
begin
  OldSep := SysUtils.DateSeparator;
  SysUtils.DateSeparator := Self.DateSeparator;
  try
    inherited EditMask := AValue;
  finally
    SysUtils.DateSeparator := OldSep;
  end;
end;

function TJvCustomDatePickerEdit.GetText: TCaption;
var
  OldSep: Char;
begin
  OldSep := SysUtils.DateSeparator;
  SysUtils.DateSeparator := Self.DateSeparator;
  try
    Result := inherited Text;
  finally
    SysUtils.DateSeparator := OldSep;
  end;
end;

procedure TJvCustomDatePickerEdit.SetText(const AValue: TCaption);
var
  OldSep: Char;
begin
  OldSep := SysUtils.DateSeparator;
  SysUtils.DateSeparator := Self.DateSeparator;
  try
    inherited Text := AValue;
  finally
    SysUtils.DateSeparator := OldSep;
  end;
end;

procedure TJvCustomDatePickerEdit.KeyPress(var Key: Char);
var
  OldSep: Char;
begin
  { this makes the transition easier for users used to non-mask-aware edit controls 
    as they could continue typing the separator character without the cursor 
    auto-advancing to the next figure when they don't expect it : }
  if (Key = Self.DateSeparator) and (Text[SelStart] = Self.DateSeparator) then
  begin
    Key := #0;
    Exit;
  end;

  OldSep := SysUtils.DateSeparator;
  SysUtils.DateSeparator := Self.DateSeparator;
  try
    inherited KeyPress(Key);
  finally
    SysUtils.DateSeparator := OldSep;
  end;
end;

procedure TJvCustomDatePickerEdit.WMPaste(var Message: TMessage);
var
  OldSep: Char;
begin
  OldSep := SysUtils.DateSeparator;
  SysUtils.DateSeparator := Self.DateSeparator;
  try
    inherited;
  finally
    SysUtils.DateSeparator := OldSep;
  end;
end;


//=== TJvDropCalendar ========================================================

constructor TJvDropCalendar.CreateWithAppearance(AOwner: TComponent;
  const AAppearance: TJvMonthCalAppearance);
begin
  inherited Create(AOwner);
  FWithBeep := False;
  FCal := TJvMonthCalendar2.CreateWithAppearance(Self, AAppearance);
  with TJvMonthCalendar2(FCal) do
  begin
    Parent := Self;
    ParentFont := True;
    OnSelChange := CalSelChange;
    OnSelect := CalSelect;
    OnKillFocus := CalKillFocus;
    OnKeyPress := CalKeyPress;
    Visible := True;
    AutoSize := True;
  end;
end;

destructor TJvDropCalendar.Destroy;
begin
  if Assigned(FCal) then
    with TJvMonthCalendar2(FCal) do
    begin
      OnSelChange := nil;
      OnSelect := nil;
      OnKeyPress := nil;
    end;
  inherited Destroy;
end;

procedure TJvDropCalendar.CalSelChange(Sender: TObject;
  StartDate, EndDate: TDateTime);
begin
  DoChange;
end;

procedure TJvDropCalendar.DoChange;
begin
  if Assigned(OnChange) then
    OnChange(Self);
end;

procedure TJvDropCalendar.CalSelect(Sender: TObject;
  StartDate, EndDate: TDateTime);
begin
  DoSelect;
end;

procedure TJvDropCalendar.DoSelect;
begin
  if Assigned(OnSelect) then
    OnSelect(Self);
  Release;
end;

procedure TJvDropCalendar.CalKeyPress(Sender: TObject; var Key: Char);
begin
  if WithBeep then
    SysUtils.Beep;
  case Word(Key) of
    VK_RETURN:
      DoSelect;
    VK_ESCAPE:
      DoCancel;
  else
    DoChange;
  end;
end;

procedure TJvDropCalendar.DoCancel;
begin
  if Assigned(OnCancel) then
    OnCancel(Self)
  else
    Release;
end;

procedure TJvDropCalendar.DoShow;
begin
  {
   In the constructor the calendar will sometimes report
   the wrong size, so we do this here.
  }
  AutoSize := True;
  inherited DoShow;
end;

function TJvDropCalendar.GetSelDate: TDateTime;
begin
  Result := TJvMonthCalendar2(FCal).DateFirst;
end;

procedure TJvDropCalendar.SetSelDate(const AValue: TDateTime);
begin
  TJvMonthCalendar2(FCal).DateFirst := AValue;
end;

procedure TJvDropCalendar.CalKillFocus(const ASender: TObject;
  const ANextControl: TWinControl);
var
  P: TPoint;
begin
  GetCursorPos(P);
  if PtInRect(BoundsRect, P) then
    Exit;
  if Assigned(ANextControl) then
    Self.DoKillFocus(ANextControl.Handle)
  else
    Self.DoKillFocus(0);
end;

procedure TJvDropCalendar.SetFocus;
begin
  if FCal.CanFocus then
    FCal.SetFocus
  else
    inherited SetFocus;
end;

end.

