{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvTFGlance.PAS, released on 2003-08-01.

The Initial Developer of the Original Code is Unlimited Intelligence Limited.
Portions created by Unlimited Intelligence Limited are Copyright (C) 1999-2002 Unlimited Intelligence Limited.
All Rights Reserved.

Contributor(s):
Mike Kolter (original code)

Last Modified: 2003-08-01

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvTFGlance;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList,
  JvTFUtils, JvTFManager;

{$I JVCL.INC}

{$HPPEMIT '#define TDate Controls::TDate'}
type
  EJvTFGlanceError = class(Exception);
  EGlanceViewerError = class(EJvTFGlanceError);

  TJvTFGlanceCell = class;
  TJvTFGlanceCells = class;
  TJvTFCustomGlance = class;
  TJvTFGlanceViewer = class;
  TJvTFCellPics = class;

  TJvTFUpdateTitleEvent = procedure(Sender: TObject; var NewTitle: String)
    of object;

  TJvTFCellPic = class(TCollectionItem)
  private
    FPicName : String;
    FPicIndex : Integer;
    FPicPoint : TPoint;
    FHints : TStrings;
    procedure SetPicName(Value: String);
    procedure SetPicIndex(Value: Integer);
    procedure SetHints(Value: TStrings);
  protected
    function GetDisplayName: String; override;
    procedure Change; virtual;
    procedure SetPicPoint(X, Y: Integer);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function PicCollection: TJvTFCellPics;
    property PicPoint : TPoint read FPicPoint;
  published
    property PicName: String read FPicName write SetPicName;
    property PicIndex: Integer read FPicIndex write SetPicIndex;
    property Hints : TStrings read FHints write SetHints;
  end;

  TJvTFCellPics = class(TCollection)
  private
    function GetItem(Index: Integer): TJvTFCellPic;
    procedure SetItem(Index: Integer; Value: TJvTFCellPic);
  protected
    FGlanceCell : TJvTFGlanceCell;
    function GetOwner: TPersistent; override;
  public
    constructor Create(aGlanceCell: TJvTFGlanceCell);
    function Add: TJvTFCellPic;
    property GlanceCell : TJvTFGlanceCell read FGlanceCell;
    procedure Assign(Source: TPersistent); override;
    property Items[Index: Integer]: TJvTFCellPic read GetItem write SetItem; default;
    function PicByName(PicName: String) : TJvTFCellPic;
    function GetPicIndex(PicName: String) : Integer;
    function AddPic(PicName: String; PicIndex: Integer): TJvTFCellPic;
  end;

  TJvTFSplitOrientation = (soHorizontal, soVertical);

  TJvTFGlanceCell = class(TCollectionItem)
  private
    FColor : TColor;
    FCellDate : TDate;
    FColIndex : Integer;
    FRowIndex : Integer;
    FCellPics : TJvTFCellPics;
    FCanSelect : Boolean;
    FSchedules : TStringList;
    FTitleText : String;

    FSplitRef : TJvTFGlanceCell;
    FSplitOrientation : TJvTFSplitOrientation;
    FIsSubcell : Boolean;

    procedure SetColor(Value: TColor);
    procedure SeTJvTFCellPics(Value: TJvTFCellPics);
    procedure SetCanSelect(Value: Boolean);
    function GetSchedule(Index: Integer): TJvTFSched;
    procedure SeTJvTFSplitOrientation(Value: TJvTFSplitOrientation);
    function GetParentCell : TJvTFGlanceCell;
    function GetSubcell : TJvTFGlanceCell;
  protected
    FDestroying : Boolean;
    FCellCollection : TJvTFGlanceCells;
    function GetDisplayName: String; override;
    procedure InternalSetCellDate(Value: TDate);
    procedure SetCellDate(Value: TDate);
    procedure SetColIndex(Value: Integer);
    procedure SetRowIndex(Value: Integer);
    procedure Change; virtual;
    procedure SetTitleText(Value: String);
    procedure Split;
    procedure Combine;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property CellCollection : TJvTFGlanceCells read FCellCollection;

    function ScheduleCount : Integer;
    property Schedules[Index: Integer]: TJvTFSched read GetSchedule;
    function IndexOfSchedule(SchedName: String; SchedDate: TDate): Integer;
    function IndexOfSchedObj(aSched: TJvTFSched): Integer;
    procedure CheckConnections;
    function IsSchedUsed(aSched : TJvTFSched) : Boolean;
    property TitleText : String read FTitleText;
    property SplitOrientation : TJvTFSplitOrientation read FSplitOrientation
      write SeTJvTFSplitOrientation default soHorizontal;
    property SplitRef : TJvTFGlanceCell read FSplitRef;
    function IsParent : Boolean;
    function IsSubcell : Boolean;
    function IsSplit : Boolean;
    property ParentCell : TJvTFGlanceCell read GetParentCell;
    property Subcell : TJvTFGlanceCell read GetSubcell;
  published
    property Color: TColor read FColor write SetColor;
    property CellDate: TDate read FCellDate write SetCellDate;
    property ColIndex: Integer read FColIndex;
    property RowIndex: Integer read FRowIndex;
    property CellPics : TJvTFCellPics read FCellPics write SeTJvTFCellPics;
    property CanSelect : Boolean read FCanSelect write SetCanSelect;
  end;

{ TODO : Clean up AddError, DestroyError, etc. in TJvTFGlanceCells and TJvTFGlanceCell }
  TJvTFGlanceCells = class(TCollection)
  private
    FGlanceControl : TJvTFCustomGlance;
    FDestroying: Boolean;
    function GetItem(Index: Integer): TJvTFGlanceCell;
    procedure SetItem(Index: Integer; Value: TJvTFGlanceCell);
    function GetCell(ColIndex, RowIndex : Integer): TJvTFGlanceCell;
  protected
    FAllowAdd: Boolean;
    FAllowDestroy: Boolean;
    FCheckingAllConnections : Boolean;
    FConfiguring : Boolean;
    function GetOwner: TPersistent; override;
    function InternalAdd: TJvTFGlanceCell;
    procedure AddError; dynamic;
    procedure DestroyError; dynamic;
    procedure EnsureCellCount;
    procedure EnsureCells;
    procedure ConfigCells; virtual;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(aGlanceControl: TJvTFCustomGlance);
    destructor Destroy; override;
    function Add: TJvTFGlanceCell;
    property GlanceControl: TJvTFCustomGlance read FGlanceControl;
    procedure Assign(Source: TPersistent); override;
    property Items[Index: Integer]: TJvTFGlanceCell read GetItem write SetItem; default;
    property AllowAdd: Boolean read FAllowAdd;
    property AllowDestroy: Boolean read FAllowDestroy;
    property Cells[ColIndex, RowIndex: Integer]: TJvTFGlanceCell read GetCell;
    procedure CheckConnections;
    property Configuring : Boolean read FConfiguring;
    procedure ReconfigCells;

    function IsSchedUsed(aSched : TJvTFSched) : Boolean;
  end;

  TJvTFFrameStyle = (fs3DRaised, fs3DLowered, fsFlat, fsNone);
  TJvTFFrameAttr = class(TPersistent)
  private
    FStyle : TJvTFFrameStyle;
    FColor : TColor;
    FWidth : Integer;
    FControl : TJvTFControl;
    FOnChange : TNotifyEvent;
    procedure SetStyle(Value: TJvTFFrameStyle);
    procedure SetColor(Value: TColor);
    procedure SetWidth(Value: Integer);
  protected
    procedure Change; virtual;
  public
    constructor Create(AOwner: TJvTFControl);
    procedure Assign(Source: TPersistent); override;
    property Control: TJvTFControl read FControl;
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
  published
    property Style: TJvTFFrameStyle read FStyle write SetStyle default fsFlat;
    property Color: TColor read FColor write SetColor default clBlack;
    property Width: Integer read FWidth write SetWidth default 1;
  end;

  TJvTFGlanceFrameAttr = class(TJvTFFrameAttr)
  private
    FGlanceControl : TJvTFCustomGlance;
  protected
    procedure Change; override;
  public
    constructor Create(AOwner: TJvTFCustomGlance);
    property GlanceControl : TJvTFCustomGlance read FGlanceControl;
  end;

  TJvTFTextAttr = class(TPersistent)
  private
    FFont : TFont;
    FOnChange : TNotifyEvent;
    FRotation: Integer;
    FAlignH: TAlignment;
    FAlignV: TJvTFVAlignment;
    procedure SetFont(Value: TFont);
    procedure SetRotation(Value: Integer);
    procedure SetAlignH(Value: TAlignment);
    procedure SetAlignV(Value: TJvTFVAlignment);
  protected
    procedure FontChange(Sender: TObject);
    procedure DoChange; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Font : TFont read FFont write SetFont;
    property Rotation : Integer read FRotation write SetRotation default 0;
    property AlignH : TAlignment read FAlignH write SetAlignH
      default taLeftJustify;
    property AlignV : TJvTFVAlignment read FAlignV write SetAlignV default vaCenter;
  end;

  TJvTFGlanceTitlePicAttr = class(TPersistent)
  private
    FAlignH : TAlignment;
    FAlignV : TJvTFVAlignment;
    FOnChange : TNotifyEvent;
    procedure SetAlignH(Value: TAlignment);
    procedure SetAlignV(Value: TJvTFVAlignment);
  protected
    procedure DoChange;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property AlignH : TAlignment read FAlignH write SetAlignH
      default taLeftJustify;
    property AlignV : TJvTFVAlignment read FAlignV write SetAlignV default vaCenter;
  end;

  TJvTFTitleAlign = alTop..alRight;
  TJvTFGlanceTitleAttr = class(TPersistent)
  private
    FAlign : TJvTFTitleAlign;
    //FDayFormat : String;
    FColor : TColor;
    FHeight : Integer;
    FVisible : Boolean;
    FFrameAttr : TJvTFGlanceFrameAttr;
    FGlanceControl : TJvTFCustomGlance;
    FDayTxtAttr : TJvTFTextAttr;
    FPicAttr : TJvTFGlanceTitlePicAttr;
    procedure SetAlign(Value : TJvTFTitleAlign);
    //procedure SetDayFormat(Value : String);
    procedure SetColor(Value : TColor);
    procedure SetHeight(Value : Integer);
    procedure SetVisible(Value : Boolean);
    procedure SetFrameAttr(Value : TJvTFGlanceFrameAttr);
    procedure SetDayTxtAttr(Value : TJvTFTextAttr);
    procedure SetPicAttr(Value: TJvTFGlanceTitlePicAttr);
  protected
    procedure Change;
    procedure TxtAttrChange(Sender: TObject);
    procedure PicAttrChange(Sender: TObject);
  public
    constructor Create(AOwner : TJvTFCustomGlance);
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
    property GlanceControl : TJvTFCustomGlance read FGlanceControl;
  published
    property Align : TJvTFTitleAlign read FAlign write SetAlign default alTop;
    //property DayFormat : String read FDayFormat write SetDayFormat;
    property Color : TColor read FColor write SetColor default clBtnFace;
    property Height : Integer read FHeight write SetHeight default 20;
    property Visible : Boolean read FVisible write SetVisible default True;
    property FrameAttr : TJvTFGlanceFrameAttr read FFrameAttr write SetFrameAttr;
    property DayTxtAttr : TJvTFTextAttr read FDayTxtAttr
      write SetDayTxtAttr;
    property PicAttr : TJvTFGlanceTitlePicAttr read FPicAttr write SetPicAttr;
  end;

  TJvTFGlanceCellAttr = class(TPersistent)
  private
    FColor : TColor;
    FFrameAttr : TJvTFGlanceFrameAttr;
    FTitleAttr : TJvTFGlanceTitleAttr;
    FGlanceControl : TJvTFCustomGlance;
    FFont : TFont;
    FDrawBottomLine : boolean;
    procedure SetColor(Value: TColor);
    procedure SetFrameAttr(Value: TJvTFGlanceFrameAttr);
    procedure SetTitleAttr(Value: TJvTFGlanceTitleAttr);
    procedure SetFont(Value: TFont);
    procedure SetDrawBottomLine(Value : boolean);
  protected
    procedure FontChange(Sender: TObject);
    procedure Change;
  public
    constructor Create(AOwner: TJvTFCustomGlance);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property GlanceControl : TJvTFCustomGlance read FGlanceControl;
  published
    property Color : TColor read FColor write SetColor default clWhite;
    property Font : TFont read FFont write SetFont;
    property FrameAttr : TJvTFGlanceFrameAttr read FFrameAttr write SetFrameAttr;
    property TitleAttr : TJvTFGlanceTitleAttr read FTitleAttr write SetTitleAttr;
    property DrawBottomLine: boolean read FDrawBottomLine write SetDrawBottomLine;
  end;


  TJvTFGlanceTitle = class(TPersistent)
  private
    FColor : TColor;
    FHeight : Integer;
    FVisible : Boolean;
    FGlanceControl : TJvTFCustomGlance;
    FFrameAttr : TJvTFGlanceFrameAttr;
    FTxtAttr : TJvTFTextAttr;
    FOnChange : TNotifyEvent;
    procedure SetColor(Value: TColor);
    procedure SetHeight(Value: Integer);
    procedure SetVisible(Value: Boolean);
    procedure SetFrameAttr(Value : TJvTFGlanceFrameAttr);
    procedure SetTxtAttr(Value: TJvTFTextAttr);
  protected
    procedure Change;
    procedure TxtAttrChange(Sender: TObject);
  public
    constructor Create(AOwner: TJvTFCustomGlance);
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    property GlanceControl : TJvTFCustomGlance read FGlanceControl;
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
  published
    property Color: TColor read FColor write SetColor default clBtnFace;
    property FrameAttr : TJvTFGlanceFrameAttr read FFrameAttr write SetFrameAttr;
    property Height: Integer read FHeight write SetHeight default 40;
    property Visible: Boolean read FVisible write SetVisible default True;
    property TxtAttr: TJvTFTextAttr read FTxtAttr write SetTxtAttr;
  end;

  TJvTFGlanceMainTitle = class(TJvTFGlanceTitle)
  private
    FTitle : String;
    procedure SetTitle(Value: String);
  public
    constructor Create(AOwner: TJvTFCustomGlance);
    procedure Assign(Source: TPersistent); override;
  published
    property Title : String read FTitle write SetTitle;
  end;


  TJvTFGlanceCoord = record
    Col : Integer;
    Row : Integer;
    Cell : TJvTFGlanceCell;
    CellX : Integer;
    CellY : Integer;
    AbsX : Integer;
    AbsY : Integer;
    DragAccept : Boolean;
    InCellTitle : Boolean;
    CellTitlePic : TJvTFCellPic;
    Appt : TJvTFAppt;
  end;

  TJvTFGlanceSelOrder = (soColMajor, soRowMajor, soRect);

  TJvTFGlanceSelList = class(TJvTFDateList)
  private
    FGlanceControl : TJvTFCustomGlance;
  public
    constructor Create(AOwner : TJvTFCustomGlance);
    property GlanceControl : TJvTFCustomGlance read FGlanceControl;
  end;

  TJvTFGlanceDrawTitleEvent = procedure(Sender: TObject; aCanvas: TCanvas;
    aRect: TRect) of object;
  TJvTFGlanceDrawCellEvent = procedure(Sender: TObject; aCanvas: TCanvas;
    aCellRect, aTitleRect, aBodyRect: TRect; Attr: TJvTFGlanceCellAttr;
    Cell: TJvTFGlanceCell) of object;

  TJvTFGlanceDropApptEvent = procedure(Sender: TObject; Appt: TJvTFAppt;
    var NewStartDate, NewEndDate : TDate; var Confirm: Boolean) of object;

  TJvTFUpdateCellTitleTextEvent = procedure(Sender: TObject; Cell: TJvTFGlanceCell;
    var NewText : String) of object;

  TJvTFCustomGlance = class(TJvTFControl)
  private
    FGapSize: Integer;
    FBorderStyle : TBorderStyle;
    //FStartOfWeek : Word;
    FStartOfWeek : TTFDayOfWeek;

    FRowCount : Integer;
    FColCount : Integer;
    FCells : TJvTFGlanceCells;
    FStartDate: TDate;
    FOriginDate: TDate;
    FCellPics : TCustomImageList;

    FTitleAttr : TJvTFGlanceMainTitle;
    FAllowCustomDates : Boolean;

    FCellAttr : TJvTFGlanceCellAttr;
    FSelCellAttr : TJvTFGlanceCellAttr;
    FSelOrder : TJvTFGlanceSelOrder;
    FSel : TJvTFGlanceSelList;
    FUpdatingSel : Boolean;

    FViewer : TJvTFGlanceViewer;

    FOnConfigCells : TNotifyEvent;
    FOnDrawTitle : TJvTFGlanceDrawTitleEvent;
    FOnDrawCell : TJvTFGlanceDrawCellEvent;
    FOnSelChanged : TNotifyEvent;
    FOnDropAppt : TJvTFGlanceDropApptEvent;
    FOnUpdateCellTitleText : TJvTFUpdateCellTitleTextEvent;

    FHintProps : TJvTFHintProps;

    FSchedNames : TStrings;

    FSelAppt : TJvTFAppt;

    procedure SetBorderStyle(Value: TBorderStyle);

    procedure SetRowCount(Value: Integer);
    procedure SetCells(Value: TJvTFGlanceCells);
    procedure SetStartDate(Value: TDate);
    procedure SetOriginDate(Value: TDate);
    procedure SetTitleAttr(Value: TJvTFGlanceMainTitle);

    procedure SetCellAttr(Value : TJvTFGlanceCellAttr);
    procedure SeTJvTFSelCellAttr(Value : TJvTFGlanceCellAttr);
    procedure SetViewer(Value : TJvTFGlanceViewer);
    procedure SeTJvTFCellPics(Value: TCustomImageList);

    procedure SeTJvTFHintProps(Value: TJvTFHintProps);
    procedure SetSchedNames(Value: TStrings);

    procedure SetSelAppt(Value: TJvTFAppt);
  protected
    FCreatingControl : Boolean;

    FPaintBuffer : TBitmap;
    FSelAnchor : TJvTFGlanceCell;
    FMouseCell : TJvTFGlanceCell;
    FImageChangeLink : TChangeLink;
    FHint : TJvTFHint;

    procedure SetColCount(Value: Integer); virtual;
    procedure SetStartOfWeek(Value: TTFDayOfWeek); virtual;

    procedure EnsureCol(Col : Integer);
    procedure EnsureRow(Row : Integer);
    procedure EnsureCell(aCell: TJvTFGlanceCell);
    function ValidCol(Col : Integer) : Boolean;
    function ValidRow(Row : Integer) : Boolean;
    function ValidCell(Col, Row : Integer) : Boolean;

    procedure WMEraseBkgnd(var Message : TMessage); message WM_ERASEBKGND;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ImageListChange(Sender: TObject);
    procedure Notify(Sender : TObject; Code : TJvTFServNotifyCode); override;

    procedure GlanceTitleChange(Sender: TObject);

    // mouse routines
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState;
                        X, Y : Integer); override;
    procedure MouseMove(Shift : TShiftState; X, Y : Integer); override;
    procedure MouseUp(Button : TMouseButton; Shift : TShiftState;
                      X, Y : Integer); override;
    procedure DblClick; override;

    procedure CheckApptHint(Info : TJvTFGlanceCoord); virtual;

    // Drag/Drop routines
    procedure DoStartDrag(var DragObject : TDragObject); override;
    procedure DragOver(Source : TObject; X, Y : Integer; State : TDragState;
      var Accept : Boolean); override;
    procedure DoEndDrag(Target : TObject; X, Y : Integer); override;
    procedure DropAppt(DragInfo : TJvTFDragInfo; X, Y : Integer);

    // selection routines
    procedure UpdateSelection;
    procedure SelChange(Sender: TObject); virtual;
    property SelOrder : TJvTFGlanceSelOrder read FSelOrder write FSelOrder;
    procedure InternalSelectCell(aCell: TJvTFGlanceCell); virtual;
    procedure InternalDeselectCell(aCell: TJvTFGlanceCell); virtual;

    // Drawing routines
    procedure Paint; override;
    procedure DrawTitle(aCanvas : TCanvas); virtual;
    procedure DrawCells(aCanvas : TCanvas);
    procedure DrawCell(aCanvas : TCanvas; aCell: TJvTFGlanceCell);
    procedure DrawCellTitle(aCanvas : TCanvas; TheTitleRect: TRect;
      Attr: TJvTFGlanceCellAttr; Cell: TJvTFGlanceCell);
    procedure DrawCellTitleFrame(aCanvas: TCanvas; TheTitleRect: TRect;
      Attr: TJvTFGlanceCellAttr);
    procedure DrawCellFrame(aCanvas: TCanvas; aRect: TRect;
      Attr: TJvTFGlanceCellAttr; aCell: TJvTFGlanceCell);
    procedure Draw3DFrame(aCanvas : TCanvas; aRect : TRect; TLColor,
      BRColor : TColor);
    function PicsToDraw(aCell: TJvTFGlanceCell) : Boolean;
    procedure GetPicsWidthHeight(aCell: TJvTFGlanceCell; PicBuffer: Integer;
      Horz: Boolean; var PicsWidth, PicsHeight: Integer);
    function ValidPicIndex(PicIndex: Integer) : Boolean;

    // Drawing event dispatch methods
    procedure DoDrawTitle(aCanvas: TCanvas; aRect: TRect); virtual;
    procedure DoDrawCell(aCanvas: TCanvas; aCellRect, aTitleRect,
      aBodyRect: TRect; Attr: TJvTFGlanceCellAttr; Cell: TJvTFGlanceCell); virtual;

    procedure ConfigCells; virtual;
    procedure DoConfigCells; virtual;
    procedure SetCellDate(aCell: TJvTFGlanceCell; CellDate: TDate);
    procedure UpdateCellTitles;
    procedure UpdateCellTitleText(Cell : TJvTFGlanceCell);
    function GetCellTitleText(Cell : TJvTFGlanceCell) : String; virtual;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure SchedNamesChange(Sender: TObject);
    property SelAppt : TJvTFAppt read FSelAppt write SetSelAppt;

    property AllowCustomDates : Boolean read FAllowCustomDates
      write FAllowCustomDates;
    // configuration properties and events
    property RowCount: Integer read FRowCount write SetRowCount default 6;
    property ColCount: Integer read FColCount write SetColCount default 7;
    property StartDate: TDate read FStartDate write SetStartDate;
    property OriginDate: TDate read FOriginDate write SetOriginDate;
    property OnConfigCells : TNotifyEvent read FOnConfigCells
      write FOnConfigCells;
    property StartOfWeek : TTFDayOfWeek read FStartOfWeek write SetStartOfWeek
      default dowSunday;

  public
    function GeTJvTFHintClass : TJvTFHintClass; dynamic;

    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    procedure ReleaseSchedule(SchedName : String; SchedDate : TDate); override;
    procedure SafeReleaseSchedule(aSched : TJvTFSched);

    function GetDataTop : Integer; dynamic;
    function GetDataLeft : Integer; dynamic;
    function GetDataWidth : Integer; dynamic;
    function GetDataHeight : Integer; dynamic;

    procedure SplitRects(Col, Row: Integer; var ParentRect, SubRect: TRect);
    function CellRect(aCell: TJvTFGlanceCell) : TRect;
    function WholeCellRect(Col, Row : Integer) : TRect;
    function TitleRect : TRect;
    function CellTitleRect(aCell: TJvTFGlanceCell) : TRect;
    function CellBodyRect(aCell: TJvTFGlanceCell) : TRect;
    function CalcCellTitleRect(aCell: TJvTFGlanceCell; Selected,
      Full : Boolean) : TRect;
    function CalcCellBodyRect(aCell: TJvTFGlanceCell; Selected,
      Full : Boolean) : TRect;

    function PtToCell(X, Y : Integer) : TJvTFGlanceCoord;
    property Sel : TJvTFGlanceSelList read FSel write FSel;
    function DateIsSelected(aDate : TDate) : Boolean;
    function CellIsSelected(aCell: TJvTFGlanceCell) : Boolean;
    procedure SelectCell(aCell: TJvTFGlanceCell; Clear : Boolean = True); virtual;
    procedure DeselectCell(aCell: TJvTFGlanceCell); virtual;
    procedure BeginSelUpdate;
    procedure EndSelUpdate;
    property UpdatingSel : Boolean read FUpdatingSel;

    function GetCellAttr(aCell: TJvTFGlanceCell) : TJvTFGlanceCellAttr; virtual;
    procedure CheckViewerApptHint(X, Y : Integer);

    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    procedure ReconfigCells;
    procedure SplitCell(aCell: TJvTFGlanceCell);
    procedure CombineCell(aCell: TJvTFGlanceCell);
  published
    property Cells: TJvTFGlanceCells read FCells write SetCells;
    property BorderStyle : TBorderStyle read FBorderStyle write SetBorderStyle
      default bsSingle;

    property GapSize: Integer read FGapSize write FGapSize;
    property TitleAttr: TJvTFGlanceMainTitle read FTitleAttr write SetTitleAttr;
    property CellAttr : TJvTFGlanceCellAttr read FCellAttr write SetCellAttr;
    property SelCellAttr : TJvTFGlanceCellAttr read FSelCellAttr write SeTJvTFSelCellAttr;
    property CellPics : TCustomImageList read FCellPics write SeTJvTFCellPics;

    property Viewer : TJvTFGlanceViewer read FViewer write SetViewer;

    property HintProps : TJvTFHintProps read FHintProps
      write SeTJvTFHintProps;

    property SchedNames: TStrings read FSchedNames write SetSchedNames;

    property OnDrawTitle : TJvTFGlanceDrawTitleEvent read FOnDrawTitle
      write FOnDrawTitle;
    property OnDrawCell : TJvTFGlanceDrawCellEvent read FOnDrawCell
      write FOnDrawCell;
    property OnSelChanged : TNotifyEvent read FOnSelChanged write FOnSelChanged;

    property OnDropAppt : TJvTFGlanceDropApptEvent read FOnDropAppt
      write FOnDropAppt;

    property OnUpdateCellTitleText : TJvTFUpdateCellTitleTextEvent
      read FOnUpdateCellTitleText write FOnUpdateCellTitleText;

    //Inherited properties
    Property DateFormat; // from TJvTFControl
    Property TimeFormat; // from TJvTFControl

    Property Align;
    Property Color default clWindow;
    Property ParentColor default False;
    Property TabStop default True;
    Property TabOrder;
    property Anchors;
    property Constraints;
    property DragKind;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;

    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnEndDock;
    property OnStartDock;
    property OnStartDrag;
  end;

  TJvTFGlanceViewer = class(TComponent)
  private
    FGlanceControl : TJvTFCustomGlance;
    FVisible : Boolean;
    FCell : TJvTFGlanceCell;
    FPhysicalCell : TJvTFGlanceCell;
    FRepeatGrouped : Boolean;
    function GetRepeatAppt(Index : Integer) : TJvTFAppt;
    function GetSchedule(Index : Integer) : TJvTFSched;
    function GetDate : TDate;
    procedure SetRepeatGrouped(Value : Boolean);
    function GetDistinctAppt(Index : Integer) : TJvTFAppt;
    function GetAppt(Index : Integer) : TJvTFAppt;
  protected
    procedure SetVisible(Value: Boolean); virtual; abstract;
    procedure SetGlanceControl(Value: TJvTFCustomGlance); virtual;
    procedure ParentReconfig; virtual;
    procedure EnsureCol(aCol : Integer);
    procedure EnsureRow(aRow : Integer);
    procedure MouseAccel(X, Y: Integer); virtual;
    procedure GetDistinctAppts(ApptList : TStringList);

    procedure FinishEditAppt; virtual;
    function Editing : Boolean; virtual;
    function CanEdit : Boolean; virtual;
  public
    constructor Create(AOwner : TComponent); override;
    procedure Notify(Sender : TObject; Code : TJvTFServNotifyCode); virtual;

    procedure SetTo(aCell: TJvTFGlanceCell); virtual;
    procedure MoveTo(aCell: TJvTFGlanceCell); virtual;
    procedure Refresh; virtual; abstract;
    procedure Realign; virtual; abstract;
    procedure PaintTo(aCanvas: TCanvas; aCell: TJvTFGlanceCell); virtual; abstract;

    property GlanceControl : TJvTFCustomGlance read FGlanceControl;
    property Cell : TJvTFGlanceCell read FCell;
    property PhysicalCell : TJvTFGlanceCell read FPhysicalCell;
    property Date : TDate read GetDate;
    property Visible : Boolean read FVisible write SetVisible;
    function CalcBoundsRect(aCell: TJvTFGlanceCell) : TRect; virtual;

    function ApptCount : Integer;
    property Appts[Index : Integer] : TJvTFAppt read GetAppt;
    function ScheduleCount : Integer;
    property Schedules[Index : Integer] : TJvTFSched read GetSchedule;
    function GetApptAt(X, Y : Integer) : TJvTFAppt; virtual;
  published
    property RepeatGrouped : Boolean read FRepeatGrouped write SetRepeatGrouped
      default True;
  end;

  TJvTFGlance = class(TJvTFCustomGlance)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property RowCount;
    property ColCount;
    property OriginDate;
    property OnConfigCells;
  end;

{$HPPEMIT '#undef TDate'}

implementation
{$IFDEF USEJVCL}
uses
  JvConsts, JvResources;
{$ENDIF}

{$IFNDEF USEJVCL}
resourcestring
  RsECellDatesCannotBeChanged = 'Cell Dates cannot be changed';
  RsECellMapHasBeenCorrupteds = 'Cell map has been corrupted %s';
  RsECellObjectNotAssigned = 'Cell object not assigned';
  RsEInvalidColIndexd = 'Invalid col index (%d)';
  RsEInvalidRowIndexd = 'Invalid row index (%d)';
  RsEApptIndexOutOfBoundsd = 'Appt index out of bounds (%d)';
  RsECellCannotBeSplit = 'Cell cannot be split';
  RsEASubcellCannotBeSplit = 'A subcell cannot be split';
{$ENDIF}

{ TJvTFGlanceCell }
{ TODO 3 -cMisc : Complete TGlance.Assign }
procedure TJvTFGlanceCell.Assign(Source: TPersistent);
begin
  If Source is TJvTFGlanceCell Then
    Begin
    End
  Else
    Inherited Assign(Source);
end;

procedure TJvTFGlanceCell.Change;
begin
  If Assigned(CellCollection.GlanceControl) Then
    CellCollection.GlanceControl.Invalidate;
end;

procedure TJvTFGlanceCell.CheckConnections;
var
  GlanceControl : TJvTFCustomGlance;
  I : Integer;
  aSched : TJvTFSched;
  aSchedName,
  aSchedID : String;
begin
  GlanceControl := CellCollection.GlanceControl;

  If CellCollection.Configuring or not Assigned(GlanceControl.ScheduleManager) or
     (csLoading in GlanceControl.ComponentState) Then
    Exit;

  // First, disconnect any schedules that shouldn't be connected
  I := 0;
  While I < FSchedules.Count do
    Begin
      aSched := TJvTFSched(FSchedules.Objects[I]);
      If (GlanceControl.SchedNames.IndexOf(aSched.SchedName) = -1) or
         not EqualDates(aSched.SchedDate, CellDate) Then
        Begin
          FSchedules.Delete(I);
          GlanceControl.SafeReleaseSchedule(aSched);
        End
      Else
        Inc(I);
    End;

  // Now connect any schedules that are not connected and should be
  For I := 0 to GlanceControl.SchedNames.Count - 1 do
    Begin
      aSchedName := GlanceControl.SchedNames[I];
      aSchedID := TJvTFScheduleManager.GetScheduleID(aSchedName, CellDate);
      If FSchedules.IndexOf(aSchedID) = -1 Then
        Begin
          aSched := GlanceControl.RetrieveSchedule(aSchedName, CellDate);
          FSchedules.AddObject(aSchedID, aSched);
        End;
    End;

  If not CellCollection.FCheckingAllConnections Then
    GlanceControl.ScheduleManager.ProcessBatches;
end;

procedure TJvTFGlanceCell.Combine;
var
  TheSubcell : TJvTFGlanceCell;
begin
  If IsSplit Then
    Begin
      TheSubcell := Subcell;
      FSplitRef.FSplitRef := nil;
      FSplitRef := nil;
      CellCollection.ReconfigCells;
      If not FDestroying and (TheSubcell <> Self) Then
        TheSubcell.Free;
    End;
end;

constructor TJvTFGlanceCell.Create(Collection: TCollection);
begin
  inherited;
  FCellCollection := TJvTFGlanceCells(Collection);

  If Assigned(CellCollection) and not CellCollection.AllowAdd Then
    CellCollection.AddError;

  FCellPics := TJvTFCellPics.Create(Self);
  FCanSelect := True;

  FSchedules := TStringList.Create;
  FSplitOrientation := soHorizontal;
end;

destructor TJvTFGlanceCell.Destroy;
var
  DisconnectList : TStringList;
  I : Integer;
  aSched : TJvTFSched;
begin
  FDestroying := True;

  //If not CellCollection.AllowDestroy and not CellCollection.FDestroying Then
    //CellCollection.DestroyError;

  If not IsSubcell Then
    FSplitRef.Free
  Else If Assigned(FSplitRef) Then
    Begin
      FSplitRef.FSplitRef := nil;
      FSplitRef := nil;
    End;


  FCellPics.Free;

  DisconnectList := TStringList.Create;
  Try
    DisconnectList.Assign(FSchedules);
    FSchedules.Clear;

    For I := 0 to DisconnectList.Count - 1 do
      Begin
        aSched := TJvTFSched(DisconnectList.Objects[I]);
        CellCollection.GlanceControl.ReleaseSchedule(aSched.SchedName,
                                                     aSched.SchedDate);
      End;
  Finally
    DisconnectList.Free;
  End;
  FSchedules.Free;

  inherited;
end;

function TJvTFGlanceCell.GetDisplayName: String;
var
  Glance : TJvTFCustomGlance;
begin
  Glance := CellCollection.GlanceControl;
  If Assigned(Glance) Then
    Result := FormatDateTime(Glance.DateFormat, CellDate)
  Else
    Result := FormatDateTime('m/d/yyyy', CellDate);

end;

function TJvTFGlanceCell.GetParentCell: TJvTFGlanceCell;
begin
  If IsParent Then
    Result := Self
  Else
    Result := SplitRef;
end;

function TJvTFGlanceCell.GetSchedule(Index: Integer): TJvTFSched;
begin
  Result := TJvTFSched(FSchedules.Objects[Index]);
end;

function TJvTFGlanceCell.GetSubcell: TJvTFGlanceCell;
begin
  If IsSubcell Then
    Result := Self
  Else
    Result := SplitRef;
end;

function TJvTFGlanceCell.IndexOfSchedObj(aSched: TJvTFSched): Integer;
begin
  Result := FSchedules.IndexOfObject(aSched);
end;

function TJvTFGlanceCell.IndexOfSchedule(SchedName: String;
  SchedDate: TDate): Integer;
begin
  Result := FSchedules.IndexOf(TJvTFScheduleManager.GetScheduleID(SchedName, SchedDate));
end;

procedure TJvTFGlanceCell.InternalSetCellDate(Value: TDate);
begin
  If not EqualDates(Value, FCellDate) Then
    Begin
      FCellDate := Value;
      If not CellCollection.Configuring and
         not (csLoading in CellCollection.GlanceControl.ComponentState) Then
        Begin
          CellCollection.GlanceControl.UpdateCellTitleText(Self);
          CheckConnections;
        End;
    End;
end;

function TJvTFGlanceCell.IsParent: Boolean;
begin
  Result := not IsSubCell;
end;

function TJvTFGlanceCell.IsSchedUsed(aSched: TJvTFSched): Boolean;
begin
  Result := IndexOfSchedObj(aSched) <> -1;
end;

function TJvTFGlanceCell.IsSplit: Boolean;
begin
  //Result := Assigned(ParentCell.Subcell);
  Result := Assigned(FSplitRef);
end;

function TJvTFGlanceCell.IsSubcell: Boolean;
begin
  Result := FIsSubcell;
end;

function TJvTFGlanceCell.ScheduleCount: Integer;
begin
  Result := FSchedules.Count;
end;

procedure TJvTFGlanceCell.SetCanSelect(Value: Boolean);
begin
  FCanSelect := Value;
end;

procedure TJvTFGlanceCell.SetCellDate(Value: TDate);
begin
  If Assigned(CellCollection.GlanceControl) and
     (not CellCollection.GlanceControl.AllowCustomDates and
      not (csLoading in CellCollection.GlanceControl.ComponentState)) Then
    Raise EJvTFGlanceError.Create(RsECellDatesCannotBeChanged);

  InternalSetCellDate(Value);
end;

procedure TJvTFGlanceCell.SeTJvTFCellPics(Value: TJvTFCellPics);
begin
  FCellPics.Assign(Value);
  Change;
end;

procedure TJvTFGlanceCell.SetColIndex(Value: Integer);
begin
  FColIndex := Value;
end;

procedure TJvTFGlanceCell.SetColor(Value: TColor);
begin
  If Value <> FColor Then
    Begin
      FColor := Value;
      Change;
    End;
end;

procedure TJvTFGlanceCell.SetRowIndex(Value: Integer);
begin
  FRowIndex := Value;
end;

{ TJvTFGlanceCells }

function TJvTFGlanceCells.Add: TJvTFGlanceCell;
begin
  Result := nil;
  AddError;
end;

procedure TJvTFGlanceCells.AddError;
begin
  //If Assigned(GlanceControl) and not (csLoading in GlanceControl.ComponentState) Then
    //Raise EJvTFGlanceError.Create('Cells cannot be manually added');
end;

procedure TJvTFGlanceCells.Assign(Source: TPersistent);
var
  I : Integer;
begin
  If Source is TJvTFGlanceCells Then
    Begin
      BeginUpdate;
      Try
        FAllowDestroy := True;
        Try
          Clear;
        Finally
          FAllowDestroy := False;
        End;

        For I := 0 to TJvTFGlanceCells(Source).Count - 1 do
          InternalAdd.Assign(TJvTFGlanceCells(Source).Items[I]);
      Finally
        EndUpdate;
      End;
    End
  Else
    Inherited Assign(Source);
end;

procedure TJvTFGlanceCells.CheckConnections;
var
  I : Integer;
begin
  If (not Assigned(GlanceControl) or not Assigned(GlanceControl.ScheduleManager)) or
     (csLoading in GlanceControl.ComponentState) Then
    Exit;
    
  FCheckingAllConnections := True;
  Try
    {
    For I := 0 to Count - 1 do
      Items[I].CheckConnections;
    }
    For I := 0 to Count - 1 do
      With Items[I] do
        Begin
          CheckConnections;
          If IsSplit Then
            Subcell.CheckConnections;
        End;
  Finally
    FCheckingAllConnections := False;
    GlanceControl.ScheduleManager.ProcessBatches;
  End;
end;

procedure TJvTFGlanceCells.ConfigCells;
begin
  {
  If not Assigned(GlanceControl) or
     (csDesigning in GlanceControl.ComponentState) Then
    Exit;
  }
  If Configuring Then
    Exit;

  FConfiguring := True;
  Try
    GlanceControl.ConfigCells;
  Finally
    FConfiguring := False;
  End;

  // connect and release cells to/from schedule objects here.
  CheckConnections;

  If Assigned(GlanceControl.Viewer) Then
    GlanceControl.Viewer.ParentReconfig;
end;

constructor TJvTFGlanceCells.Create(aGlanceControl: TJvTFCustomGlance);
begin
  Inherited Create(TJvTFGlanceCell);
  FGlanceControl := aGlanceControl;
end;

destructor TJvTFGlanceCells.Destroy;
begin
  FDestroying := True;
  inherited;          
end;

procedure TJvTFGlanceCells.DestroyError;
begin
  //Raise EJvTFGlanceError.Create('Cells cannot be manually destroyed');
end;

procedure TJvTFGlanceCells.EnsureCellCount;
var
  I,
  DeltaCount : Integer;
begin
  {
  If not Assigned(GlanceControl) or
     (csDesigning in GlanceControl.ComponentState) Then
    Exit;
  }
  If not Assigned(GlanceControl) Then
    Exit;

  // Adjust the cell count
  DeltaCount := GlanceControl.RowCount * GlanceControl.ColCount - Count;

  For I := 1 to DeltaCount do
    InternalAdd;

  FAllowDestroy := True;
  Try
    For I := -1 downto DeltaCount do
      Items[Count - 1].Free;
  Finally
    FAllowDestroy := False;
  End;
end;

procedure TJvTFGlanceCells.EnsureCells;
var
  I, J, K : Integer;
  SaveConfiguring : Boolean;
begin
  SaveConfiguring := Configuring;
  FConfiguring := True;
  Try
    EnsureCellCount;

    K := 0;
    For I := 0 to GlanceControl.RowCount - 1 do
      For J := 0 to GlanceControl.ColCount - 1 do
        With Items[K] do
          Begin
            SetColIndex(J);
            SetRowIndex(I);
            CellPics.Clear;
            Combine;
            Inc(K);
          End;
  Finally
    FConfiguring := SaveConfiguring;
  End;
end;

function TJvTFGlanceCells.GetCell(ColIndex, RowIndex: Integer): TJvTFGlanceCell;
var
  AbsIndex : Integer;
  S : String;
begin
  Result := nil;
  If not Assigned(GlanceControl) Then
    Exit;

  AbsIndex := RowIndex * GlanceControl.ColCount + ColIndex;
  If (AbsIndex >= 0) and (AbsIndex < Count) Then
    Begin
      Result := Items[AbsIndex];
      If (Result.ColIndex <> ColIndex) or (Result.RowIndex <> RowIndex) Then
        Begin
          S := '(' + IntToStr(Result.ColIndex) + ':' + IntToStr(ColIndex) + ') ' +
               '(' + IntToStr(Result.RowIndex) + ':' + IntToStr(RowIndex) + ')';
          Raise EJvTFGlanceError.CreateFmt(RsECellMapHasBeenCorrupteds, [S]);
        End;
    End;
end;

function TJvTFGlanceCells.GetItem(Index: Integer): TJvTFGlanceCell;
begin
  Result := TJvTFGlanceCell(Inherited GetItem(Index));
end;

function TJvTFGlanceCells.GetOwner: TPersistent;
begin
  Result := GlanceControl;
end;

function TJvTFGlanceCells.InternalAdd: TJvTFGlanceCell;
begin
  FAllowAdd := True;
  Try
    Result := TJvTFGlanceCell(Inherited Add);
  Finally
    FAllowAdd := False;
  End;
end;

function TJvTFGlanceCells.IsSchedUsed(aSched: TJvTFSched): Boolean;
var
  I : Integer;
  aCell : TJvTFGlanceCell;
begin
  Result := False;
  I := 0;
  While (I < Count) and not Result do
    Begin
      aCell := Items[I];

      If aCell.IsSchedUsed(aSched) Then
        Result := True
      Else If aCell.IsSplit and aCell.Subcell.IsSchedUsed(aSched) Then
        Result := True
      Else
        Inc(I);
    End;
end;

procedure TJvTFGlanceCells.ReconfigCells;
var
  I : Integer;
begin
  If FConfiguring Then
    Exit;

  FConfiguring := True;
  Try
    For I := 0 to Count - 1 do
      With Items[I] do
        Begin
          CellPics.Clear;
          If IsSplit Then
            Subcell.CellPics.Clear;
        End;
    GlanceControl.ConfigCells;
  Finally
    FConfiguring := False;
  End;

  // connect and release cells to/from schedule objects here.
  CheckConnections;

  If Assigned(GlanceControl.Viewer) Then
    GlanceControl.Viewer.ParentReconfig;
  GlanceControl.Invalidate;
end;

procedure TJvTFGlanceCells.SetItem(Index: Integer; Value: TJvTFGlanceCell);
begin
  Inherited SetItem(Index, Value);
end;

procedure TJvTFGlanceCells.Update(Item: TCollectionItem);
begin
end;

{ TJvTFCustomGlance }

function TJvTFCustomGlance.CalcCellBodyRect(aCell: TJvTFGlanceCell; Selected,
  Full: Boolean): TRect;
var
  Attr : TJvTFGlanceCellAttr;
  Offset : Integer;
begin
  Windows.SubtractRect(Result, CellRect(aCell),
                       CalcCellTitleRect(aCell, Selected, True));
  If not Full Then
    Begin
      If Selected Then
        Attr := SelCellAttr
      Else
        Attr := CellAttr;

      Case Attr.FrameAttr.Style of
        fs3DRaised, fs3DLowered : Offset := 1;
        fsFlat                  : Offset := Attr.FrameAttr.Width;
      Else
        Offset := 0;
      End;

      // Col 0 has frame running down left side of cell, whereas others
      // do not.
      If aCell.ColIndex = 0 Then
        Inc(Result.Left, Offset);
        
      Dec(Result.Bottom, Offset);
      Dec(Result.Right, Offset);
    End;
end;

function TJvTFCustomGlance.CellIsSelected(aCell: TJvTFGlanceCell): Boolean;
begin
  Result := False;
  If Assigned(aCell) Then
    Result := DateIsSelected(aCell.CellDate);
end;

function TJvTFCustomGlance.CellRect(aCell: TJvTFGlanceCell): TRect;
var
  ParentRect,
  SubRect : TRect;
begin
  Result := EmptyRect;
  If Assigned(aCell) Then
    Begin
      SplitRects(aCell.ColIndex, aCell.RowIndex, ParentRect, SubRect);
      If aCell.IsParent Then
        Result := ParentRect
      Else
        Result := SubRect;
    End;
end;

function TJvTFCustomGlance.CalcCellTitleRect(aCell: TJvTFGlanceCell; Selected,
  Full: Boolean): TRect;
var
  Attr : TJvTFGlanceCellAttr;
begin
  If Selected Then
    Attr := SelCellAttr
  Else
    Attr := CellAttr;

  If not Attr.TitleAttr.Visible Then
    Begin
      Result := Rect(0, 0, 0, 0);
      Exit;
    End
  Else
    Result := CellRect(aCell);


  Case Attr.TitleAttr.Align of
    alTop    : Result.Bottom := Result.Top + Attr.TitleAttr.Height;
    alBottom : Result.Top := Result.Bottom - Attr.TitleAttr.Height;
    alLeft   : Result.Right := Result.Left + Attr.TitleAttr.Height;
    alRight  : Result.Left := Result.Right - Attr.TitleAttr.Height;
  End;

  If not Full Then
    Begin
      Case Attr.TitleAttr.FrameAttr.Style of
        fs3DLowered, fs3DRaised :
          Windows.InflateRect(Result, -1, -1);
        fsFlat :
          Case Attr.TitleAttr.Align of
            alTop : Dec(Result.Bottom, Attr.TitleAttr.FrameAttr.Width);
            alBottom : Inc(Result.Top, Attr.TitleAttr.FrameAttr.Width);
            alLeft : Dec(Result.Right, Attr.TitleAttr.FrameAttr.Width);
            alRight : Inc(Result.Left, Attr.TitleAttr.FrameAttr.Width);
          End;
      End;
    End;
end;

procedure TJvTFCustomGlance.CMCtl3DChanged(var Message: TMessage);
begin
  If NewStyleControls and (FBorderStyle = bsSingle) Then
    RecreateWnd;
  Inherited;
end;

constructor TJvTFCustomGlance.Create(AOwner: TComponent);
begin
  FCreatingControl := True;

  AllowCustomDates := False;
  Inherited;
  ControlStyle := ControlStyle + [csOpaque, csCaptureMouse, csClickEvents,
                                  csDoubleClicks];
  TabStop := True;
  Height := 300;
  Width := 300;

  //Color := clRed;
  FBorderStyle := bsSingle;
  FStartOfWeek := dowSunday;
  FGapSize := 0;
  FRowCount := 6;
  FColCount := 7;

  FPaintBuffer := TBitmap.Create;

  FSchedNames := TStringList.Create;
  TStringList(FSchedNames).OnChange := SchedNamesChange;

  FCells := TJvTFGlanceCells.Create(Self);
  StartDate := Date;

  FTitleAttr := TJvTFGlanceMainTitle.Create(Self);
  FTitleAttr.Visible := False;  // not visible by default. (Tim)
  FTitleAttr.OnChange := GlanceTitleChange;

  FCellAttr := TJvTFGlanceCellAttr.Create(Self);
  FCellAttr.TitleAttr.DayTxtAttr.AlignH := taLeftJustify;
  FSelCellAttr := TJvTFGlanceCellAttr.Create(Self);
  FSelCellAttr.TitleAttr.Color := clNavy;
  FSelCellAttr.TitleAttr.DayTxtAttr.Font.Color := clWhite;

  //FSelOrder := soColMajor;
  FSelOrder := soRowMajor;
  FSel := TJvTFGlanceSelList.Create(Self);
  FSel.OnChange := SelChange;

  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;

  FHintProps := TJvTFHintProps.Create(Self);
  //FHint := TJvTFHint.Create(Self);
  FHint := GeTJvTFHintClass.Create(Self);
  FHint.RefProps := FHintProps;

  FCreatingControl := False;

  Cells.EnsureCells;
  Cells.ConfigCells;
end;

procedure TJvTFCustomGlance.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or BorderStyles[FBorderStyle] or WS_CLIPCHILDREN;
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
  end;
end;

function TJvTFCustomGlance.DateIsSelected(aDate: TDate): Boolean;
begin
  Result := Sel.IndexOf(aDate) <> -1;
end;

procedure TJvTFCustomGlance.DblClick;
begin
  inherited;

end;

destructor TJvTFCustomGlance.Destroy;
begin
  FCells.Free;
  FTitleAttr.Free;
  FCellAttr.Free;
  FSelCellAttr.Free;
  FSel.OnChange := nil;
  FSel.Free;
  FPaintBuffer.Free;
  FImageChangeLink.Free;

  FHint.Free;
  FHintProps.Free;

  TStringList(FSchedNames).OnChange := nil;
  FSchedNames.Free;

  Viewer := nil;

  inherited;
end;

procedure TJvTFCustomGlance.DoConfigCells;
begin
  If Assigned(FOnConfigCells) Then
    FOnConfigCells(Self);
end;

procedure TJvTFCustomGlance.Draw3DFrame(aCanvas: TCanvas; aRect: TRect; TLColor,
  BRColor: TColor);
var
  OldPenColor : TColor;
begin
  With aCanvas do
    Begin
      OldPenColor := Pen.Color;
      Pen.Color := TLColor;
      MoveTo(aRect.Left, aRect.Top);
      LineTo(aRect.Right, aRect.Top);
      MoveTo(aRect.Left, aRect.Top);
      LineTo(aRect.Left, aRect.Bottom);

      Pen.Color := BRColor;
      MoveTo(aRect.Right - 1, aRect.Top);
      LineTo(aRect.Right - 1, aRect.Bottom);
      MoveTo(aRect.Left, aRect.Bottom - 1);
      LineTo(aRect.Right, aRect.Bottom - 1);
      Pen.Color := OldPenColor;
    End;
end;

procedure TJvTFCustomGlance.DrawCell(aCanvas: TCanvas; aCell: TJvTFGlanceCell);
var
  aRect,
  TheTitleRect,
  TheBodyRect : TRect;
  Attr : TJvTFGlanceCellAttr;
begin
  With aCanvas do
    Begin
      aRect := CellRect(aCell);
      Attr := GetCellAttr(aCell);
      TheTitleRect := CellTitleRect(aCell);

      // calc the body rect
      Windows.SubtractRect(TheBodyRect, aRect, TheTitleRect);

      // draw the cell title
      If Attr.TitleAttr.Visible Then
        DrawCellTitle(aCanvas, TheTitleRect, Attr, aCell);

      // shade the body of the cell
      Brush.Color := Attr.Color;
      FillRect(TheBodyRect);

      DrawCellFrame(aCanvas, aRect, Attr, aCell);

      // draw the cell data
      If Assigned(Viewer) and not (csDesigning in ComponentState) Then
        Viewer.PaintTo(aCanvas, aCell);

      DoDrawCell(aCanvas, aRect, TheTitleRect, TheBodyRect, Attr, aCell);
    End;
end;

procedure TJvTFCustomGlance.DrawCells(aCanvas: TCanvas);
var
  Col,
  Row : Integer;
  aCell : TJvTFGlanceCell;
begin
  For Col := 0 to ColCount - 1 do
    For Row := 0 to RowCount - 1 do
      Begin
        aCell := Cells.Cells[Col, Row];
        DrawCell(aCanvas, aCell);
        If Assigned(aCell.Subcell) Then
          DrawCell(aCanvas, aCell.Subcell);
      End;
end;

procedure TJvTFCustomGlance.DrawTitle(aCanvas: TCanvas);
var
  aRect,
  TxtRect : TRect;
  Flags : UINT;
  PTxt : PChar;
  Txt : String;
  OldPen : TPen;
  OldBrush : TBrush;
  OldFont : TFont;
  I,
  LineBottom : Integer;
begin
  If not TitleAttr.Visible Then
    Exit;

  aRect := TitleRect;
  TxtRect := aRect;
  Windows.InflateRect(TxtRect, -2, -2);

  With aCanvas do
    Begin
      OldPen := TPen.Create;
      OldPen.Assign(Pen);
      OldBrush := TBrush.Create;
      OldBrush.Assign(Brush);
      OldFont := TFont.Create;
      OldFont.Assign(Font);

      Brush.Color := TitleAttr.Color;
      FillRect(aRect);

      //Pen.Color := clBlack;
      //MoveTo(aRect.Left, aRect.Bottom - 1);
      //LineTo(aRect.Right, aRect.Bottom - 1);

      Case TitleAttr.FrameAttr.Style of
        fs3DRaised :
          Draw3DFrame(aCanvas, aRect, clBtnHighlight, clBtnShadow);
        fs3DLowered :
          Draw3DFrame(aCanvas, aRect, clBtnShadow, clBtnHighlight);
        {
        fs3DRaised, fs3DLowered :
          Begin
            If TitleAttr.FrameAttr.Style = fs3DRaised Then
              Pen.Color := clBtnHighlight
            Else
              Pen.Color := clBtnShadow;

            MoveTo(aRect.Left, aRect.Top);
            LineTo(aRect.Right, aRect.Top);
            MoveTo(aRect.Left, aRect.Top);
            LineTo(aRect.Left, aRect.Bottom);

            If TitleAttr.FrameAttr.Style = fs3DRaised Then
              Pen.Color := clBtnShadow
            Else
              Pen.Color := clBtnHighlight;

            MoveTo(aRect.Right - 1, aRect.Top);
            LineTo(aRect.Right - 1, aRect.Bottom);
            MoveTo(aRect.Left, aRect.Bottom - 1);
            LineTo(aRect.Right, aRect.Bottom - 1);
          End;
        }
        fsFlat :
          Begin
            Pen.Color := TitleAttr.FrameAttr.Color;
            {
            Pen.Width := TitleAttr.FrameAttr.Width;
            LineBottom := aRect.Bottom - Pen.Width div 2;
            If Odd(Pen.Width) Then
              Dec(LineBottom);
            MoveTo(aRect.Left, LineBottom);
            LineTo(aRect.Right, LineBottom);
            }
            Pen.Width := 1;
            LineBottom := aRect.Bottom - 1;
            For I := 1 to TitleAttr.FrameAttr.Width do
              Begin
                MoveTo(aRect.Left, LineBottom);
                LineTo(aRect.Right, LineBottom);
                Dec(LineBottom);
              End;
          End;
      End;

      //Font.Assign(TitleAttr.Font);
      Font.Assign(TitleAttr.TxtAttr.Font);
      Flags := DT_NOPREFIX or DT_CENTER or DT_SINGLELINE or DT_VCENTER;

      // Allocate length of Txt + 4 chars
      // (1 char for null terminator, 3 chars for ellipsis)
      Txt := TitleAttr.Title;
      PTxt := StrAlloc((Length(Txt) + 4) * SizeOf(Char));
      StrPCopy(PTxt, Txt);

      Windows.DrawText(aCanvas.Handle, PTxt, -1, TxtRect, Flags);
      StrDispose(PTxt);

      Pen.Assign(OldPen);
      Brush.Assign(OldBrush);
      Font.Assign(OldFont);
      OldPen.Free;
      OldBrush.Free;
      OldFont.Free;
    End;

  DoDrawTitle(aCanvas, aRect);
end;

procedure TJvTFCustomGlance.EnsureCell(aCell: TJvTFGlanceCell);
begin
  If not Assigned(aCell) Then
    Raise EJvTFGlanceError.Create(RsECellObjectNotAssigned);
end;

procedure TJvTFCustomGlance.EnsureCol(Col : Integer);
begin
  If (Col < 0) or (Col >= ColCount) Then
    Raise EJvTFGlanceError.CreateFmt(RsEInvalidColIndexd, [Col]);
end;

procedure TJvTFCustomGlance.EnsureRow(Row : Integer);
begin
  If (Row < 0) or (Row >= RowCount) Then
    Raise EJvTFGlanceError.CreateFmt(RsEInvalidRowIndexd, [Row]);
end;

function TJvTFCustomGlance.GetCellAttr(aCell: TJvTFGlanceCell): TJvTFGlanceCellAttr;
begin
  If CellIsSelected(aCell) Then
    Result := SelCellAttr
  Else
    Result := CellAttr;
end;

function TJvTFCustomGlance.GetDataHeight: Integer;
begin
  Result := ClientHeight - GetDataTop;
end;

function TJvTFCustomGlance.GetDataLeft: Integer;
begin
  Result := 0;
end;

function TJvTFCustomGlance.GetDataTop: Integer;
begin
  Result := 0;
  If TitleAttr.Visible Then
    Inc(Result, TitleAttr.Height);
end;

function TJvTFCustomGlance.GetDataWidth: Integer;
begin
  Result := ClientWidth - GetDataLeft;
end;

procedure TJvTFCustomGlance.ImageListChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TJvTFCustomGlance.InternalSelectCell(aCell: TJvTFGlanceCell);
begin
  If Assigned(aCell) and aCell.CanSelect Then
    Sel.Add(aCell.CellDate);
end;

procedure TJvTFCustomGlance.Loaded;
begin
  inherited;
  Cells.EnsureCells;
  Cells.ConfigCells;
end;

procedure TJvTFCustomGlance.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Info : TJvTFGlanceCoord;

begin
  inherited;

  If Enabled Then
    SetFocus;

  Info := PtToCell(X, Y);
  If Assigned(Viewer) and (Viewer.Cell <> Info.Cell) Then
    Viewer.Visible := False;

  If ssLeft in Shift Then
    Begin
      If ssShift in Shift Then
        Begin
          // contiguous selection
          If Info.Cell.CanSelect Then
            Begin
              FMouseCell := Info.Cell;
              UpdateSelection;
            End;
        End
      Else If ssCtrl in Shift Then
        Begin
          // non-contiguous selection
          If CellIsSelected(Info.Cell) Then
            DeselectCell(Info.Cell)
          Else
            SelectCell(Info.Cell, False);
        End
      Else
        Begin
          If Assigned(Info.Cell) and Info.Cell.CanSelect Then
            SelectCell(Info.Cell, True);
          SelAppt := Info.Appt;
          If Assigned(Info.Appt) Then
            BeginDrag(False);
        End;
    End;
end;

procedure TJvTFCustomGlance.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  //S : String;
  Info : TJvTFGlanceCoord;
  Hints: TStrings;
begin
  inherited;

  Info := PtToCell(X, Y);

  If not Focused and not (csDesigning in ComponentState) Then
    Exit;

  If Assigned(Info.CellTitlePic) Then
    Hints := Info.CellTitlePic.Hints
  Else
    Hints := nil;

  FHint.MultiLineObjHint(Info.CellTitlePic, X, Y, Hints);
  {
  If Assigned(Info.CellTitlePic) Then
    FHint.MultiLineObjHint(Info.CellTitlePic, X, Y, Info.CellTitlePic.Hints)
  Else
    FHint.ReleaseHandle;
  }

  If (Info.Col > -1) and (Info.Row > -1) and not Info.InCellTitle Then
    CheckApptHint(Info);

  // EXIT if we've already processed a mouse move for the current cell
  If Info.Cell = FMouseCell Then
    Exit;

  FMouseCell := Info.Cell;

  // TESTING ONLY!!!
  //S := IntToStr(Info.Col) + ', ' + IntToStr(Info.Row);
  //GetParentForm(Self).Caption := S;

  If ssLeft in Shift Then
    Begin
      UpdateSelection;
    End;
end;

procedure TJvTFCustomGlance.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  Info : TJvTFGlanceCoord;
begin
  inherited;

  If (Sel.Count = 1) and Assigned(Viewer) Then
    Begin
      Info := PtToCell(X, Y);
      Viewer.MoveTo(Info.Cell);
      Viewer.Visible := True;
      If not Info.InCellTitle Then
        Viewer.MouseAccel(X, Y);
    End;
end;

procedure TJvTFCustomGlance.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  If Operation = opRemove Then
    If AComponent = Viewer Then
      Viewer := nil
    Else If AComponent = CellPics Then
      CellPics := nil;
end;

procedure TJvTFCustomGlance.Paint;
begin
  With FPaintBuffer do
    Begin
      Height := ClientHeight;
      Width := ClientWidth;

      With Canvas do
        Begin
          Brush.Color := Color;
          FillRect(ClientRect);
        End;

      DrawTitle(Canvas);
      DrawCells(Canvas);
    End;

  If Enabled Then
    Windows.BitBlt(Canvas.Handle, 0, 0, ClientWidth, ClientHeight,
                   FPaintBuffer.Canvas.Handle, 0, 0, SRCCOPY)
  Else
    Windows.DrawState(Canvas.Handle, 0, nil, FPaintBuffer.Handle, 0,
                      0, 0, 0, 0, DST_BITMAP or DSS_UNION or DSS_DISABLED);
end;

function TJvTFCustomGlance.PtToCell(X, Y: Integer): TJvTFGlanceCoord;
var
  I,
  AdjX,
  AdjY,
  ViewerX,
  ViewerY : Integer;
  PicRect,
  ViewerBounds,
  ParentRect,
  SubRect : TRect;
  VCell : TJvTFGlanceCell;
  InSubRect : Boolean;
begin
  With Result do
    Begin
      AbsX := X;
      AbsY := Y;

      AdjY := Y - GetDataTop;
      If AdjY < 0 Then
        Row := -1
      Else
        Row := GetDivNum(GetDataHeight, RowCount, AdjY);

      AdjX := X - GetDataLeft;
      If AdjX < 0 Then
        Col := -1
      Else
        Col := GetDivNum(GetDataWidth, ColCount, AdjX);

      If (Col >= 0) and (Row >= 0) Then
        Begin
          Cell := Cells.Cells[Col, Row];
          SplitRects(Col, Row, ParentRect, SubRect);
          InSubRect := Windows.PtInRect(SubRect, Point(X, Y));
          If InSubRect Then
            Cell := Cell.Subcell;
        End
      Else
        Begin
          InSubRect := False;
          Cell := nil;
        End;

      If Col < 0 Then
        CellX := X
      Else
        If InSubRect and (Cell.SplitOrientation = soVertical) Then
          CellX := X - SubRect.Left
        Else
          CellX := X - ParentRect.Left;

      If Row < 0 Then
        CellY := Y
      Else
        If InSubRect and (Cell.SplitOrientation = soHorizontal) Then
          CellY := Y - SubRect.Top
        Else
          CellY := Y - ParentRect.Top;

      DragAccept := (Col > -1) and (Row > -1) and Assigned(ScheduleManager);

      CellTitlePic := nil;
      InCellTitle := Windows.PtInRect(CellTitleRect(Cell), Point(X, Y));
      If InCellTitle and Assigned(Cell) and Assigned(CellPics) Then
        Begin
          I := 0;
          While (I < Cell.CellPics.Count) and not Assigned(CellTitlePic) do
            Begin
              PicRect.TopLeft := Cell.CellPics[I].PicPoint;
              PicRect.Right := PicRect.Left + CellPics.Width;
              PicRect.Bottom := PicRect.Top + CellPics.Height;
              If Windows.PtInRect(PicRect, Point(X, Y)) Then
                CellTitlePic := Cell.CellPics[I]
              Else
                Inc(I);
            End;
        End;

      Appt := nil;
      If Assigned(Viewer) and not InCellTitle and
         (Col > -1) and (Row > -1) Then
        Begin
          VCell := Viewer.Cell;

          Viewer.SetTo(Cell);
          ViewerBounds := Viewer.CalcBoundsRect(Cell);

          ViewerX := AbsX - ViewerBounds.Left;
          ViewerY := AbsY - ViewerBounds.Top;

          Appt := Viewer.GetApptAt(ViewerX, ViewerY);

          Viewer.SetTo(VCell);
        End;
    End;
end;

// Parameter Clear defaults to True for D4+ versions
procedure TJvTFCustomGlance.SelectCell(aCell: TJvTFGlanceCell; Clear: Boolean);
begin
  EnsureCell(aCell);

  BeginSelUpdate;
  Try
    If Clear Then
      Begin
        Sel.Clear;
        FSelAnchor := aCell;
      End;
    InternalSelectCell(aCell);
  Finally
    EndSelUpdate;
  End;
end;

procedure TJvTFCustomGlance.SetBorderStyle(Value: TBorderStyle);
begin
  If FBorderStyle <> Value Then
    Begin
      FBorderStyle := Value;
      RecreateWnd;
    End;
end;

procedure TJvTFCustomGlance.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  If Assigned(Viewer) Then
    Viewer.Realign;
end;

procedure TJvTFCustomGlance.SetCellAttr(Value: TJvTFGlanceCellAttr);
begin
  FCellAttr.Assign(Value);
end;

procedure TJvTFCustomGlance.SeTJvTFCellPics(Value: TCustomImageList);
begin
  If Value <> FCellPics Then
    Begin
      If Assigned(FCellPics) Then
        FCellPics.UnregisterChanges(FImageChangeLink);

      FCellPics := Value;

      If Assigned(FCellPics) Then
        Begin
          FCellPics.RegisterChanges(FImageChangeLink);
          FCellPics.FreeNotification(Self);
        End;

      Invalidate;
    End;
end;

procedure TJvTFCustomGlance.SetCells(Value: TJvTFGlanceCells);
begin
  FCells.Assign(Value);
end;

procedure TJvTFCustomGlance.SetColCount(Value: Integer);
begin
  Value := Greater(Value, 1);

  If Value <> FColCount Then
    Begin
      FColCount := Value;
      Cells.EnsureCells;
      Cells.ConfigCells;
      If Assigned(Viewer) Then
        Viewer.Realign;
      Invalidate;
    End;
end;

procedure TJvTFCustomGlance.SetOriginDate(Value: TDate);
begin
  If not EqualDates(Value, FOriginDate) Then
    Begin
      FOriginDate := Value;
      StartOfWeek := BorlToDOW(DayOfWeek(Value));
      If not FCreatingControl and not (csLoading in ComponentState) Then
        Cells.ConfigCells;
      Invalidate;
    End;
end;

procedure TJvTFCustomGlance.SetRowCount(Value: Integer);
begin
  Value := Greater(Value, 1);

  If Value <> FRowCount Then
    Begin
      FRowCount := Value;
      Cells.EnsureCells;
      Cells.ConfigCells;
      If Assigned(Viewer) Then
        Viewer.Realign;
      Invalidate;
    End;
end;

procedure TJvTFCustomGlance.SeTJvTFSelCellAttr(Value: TJvTFGlanceCellAttr);
begin
  FSelCellAttr.Assign(Value);
end;

procedure TJvTFCustomGlance.SetStartDate(Value: TDate);
begin
  If not EqualDates(Value, FStartDate) Then
    Begin
      FStartDate := Value;
      While BorlToDOW(DayOfWeek(Value)) <> StartOfWeek do
        Value := Value - 1;
      OriginDate := Value;
    End;
end;

procedure TJvTFCustomGlance.SetStartOfWeek(Value: TTFDayOfWeek);
var
  WorkDate : TDate;
begin
  If Value <> FStartOfWeek Then
    Begin
      FStartOfWeek := Value;

      WorkDate := StartDate;
      While BorlToDOW(DayOfWeek(WorkDate)) <> FStartOfWeek do
        WorkDate := WorkDate - 1;
      OriginDate := WorkDate;

      Invalidate;
    End;
end;

procedure TJvTFCustomGlance.SetTitleAttr(Value: TJvTFGlanceMainTitle);
begin
  FTitleAttr.Assign(Value);
  Invalidate;
end;

procedure TJvTFCustomGlance.SetViewer(Value: TJvTFGlanceViewer);
begin
  If Value <> FViewer Then
    Begin
      If Assigned(FViewer) Then
        FViewer.Notify(Self, sncDisconnectControl);
      If Assigned(Value) Then
        Value.Notify(Self, sncConnectControl);
      FViewer := Value;
      If Assigned(FViewer) Then
        Begin
          FViewer.MoveTo(Cells.Cells[0, 0]);
          FViewer.Visible := (csDesigning in ComponentState);
        End;
    End;
end;

function TJvTFCustomGlance.TitleRect: TRect;
begin
  Result := Rect(0, 0, ClientWidth, 0);
  If TitleAttr.Visible Then
    Result.Bottom := TitleAttr.Height;
end;

procedure TJvTFCustomGlance.UpdateSelection;
var
  Col,
  Row,
  StartCol,
  EndCol,
  StartRow,
  EndRow : Integer;
  aCell,
  aCell1,
  aCell2 : TJvTFGlanceCell;
begin
  BeginSelUpdate;

  Try
    If not Assigned(FMouseCell) or not Assigned(FSelAnchor) Then
      Exit;

    Sel.Clear;
    If SelOrder = soColMajor Then
      Begin
        // handle the first sel col
        If FMouseCell.ColIndex < FSelAnchor.ColIndex Then  // sel end is left of anchor
          Begin
            For Row := 0 to FSelAnchor.RowIndex do
              Begin
                aCell := Cells.Cells[FSelAnchor.ColIndex, Row];
                InternalSelectCell(aCell);
                InternalSelectCell(aCell.Subcell);
              End;
            If not FSelAnchor.IsSubcell Then
              InternalDeselectCell(FSelAnchor.Subcell);
          End
        Else If FMouseCell.ColIndex = FSelAnchor.ColIndex Then  // sel end is in same col as anchor
          Begin
            StartRow := Lesser(FSelAnchor.RowIndex, FMouseCell.RowIndex);
            EndRow := Greater(FSelAnchor.RowIndex, FMouseCell.RowIndex);
            For Row := StartRow to EndRow do
              Begin
                aCell := Cells.Cells[FSelAnchor.ColIndex, Row];
                InternalSelectCell(aCell);
                InternalSelectCell(aCell.Subcell);
              End;

            If (FMouseCell.RowIndex < FSelAnchor.RowIndex) Then
              Begin
                If FMouseCell.IsSubcell Then
                  InternalDeselectCell(FMouseCell.ParentCell);
                If FSelAnchor.IsParent Then
                  InternalDeselectCell(FSelAnchor.Subcell);
              End
            Else If FMouseCell = FSelAnchor Then
              InternalDeselectCell(FMouseCell.SplitRef)
            Else If (FMouseCell.RowIndex > FSelAnchor.RowIndex) Then
              Begin
                If FMouseCell.IsParent Then
                  InternalDeselectCell(FMouseCell.Subcell);
                If FSelAnchor.IsSubcell Then
                  InternalDeselectCell(FSelAnchor.ParentCell);
              End;
          End
        Else  // sel end is to the right of anchor
          Begin
            InternalSelectCell(FSelAnchor);
            If FSelAnchor.IsParent Then
              InternalSelectCell(FSelAnchor.Subcell);

            For Row := FSelAnchor.RowIndex + 1 to RowCount - 1 do
              Begin
                InternalSelectCell(FSelAnchor.ParentCell);
                InternalSelectCell(FSelAnchor.Subcell);
              End;
          End;

        // handle any intermediate cols (all rows in col will be selected)
        StartCol := Lesser(FSelAnchor.ColIndex, FMouseCell.ColIndex);
        EndCol := Greater(FSelAnchor.ColIndex, FMouseCell.ColIndex);
        For Col := StartCol + 1 to EndCol - 1 do
          For Row := 0 to RowCount - 1 do
            Begin
              aCell := Cells.Cells[Col, Row];
              InternalSelectCell(aCell);
              InternalSelectCell(aCell.Subcell);
            End;

        // handle the last sel col
        If FMouseCell.ColIndex < FSelAnchor.ColIndex Then
          Begin
            InternalSelectCell(FMouseCell);
            If FMouseCell.IsParent Then
              InternalSelectCell(FMouseCell.Subcell);

            For Row := FMouseCell.RowIndex + 1 to RowCount - 1 do
              Begin
                aCell := Cells.Cells[FMouseCell.ColIndex, Row];
                InternalSelectCell(aCell);
                InternalSelectCell(aCell.Subcell);
              End;
          End
        Else If FMouseCell.ColIndex > FSelAnchor.ColIndex Then
          Begin
            For Row := 0 to FMouseCell.RowIndex do
              Begin
                aCell := Cells.Cells[FMouseCell.ColIndex, Row];
                InternalSelectCell(aCell);
                InternalSelectCell(aCell.Subcell);
              End;
            If FMouseCell.IsParent Then
              InternalDeselectCell(FMouseCell.Subcell);
          End
      End
    Else If SelOrder = soRowMajor Then
      Begin
        // handle the first sel row
        If FMouseCell.RowIndex < FSelAnchor.RowIndex Then
          Begin
            For Col := 0 to FSelAnchor.ColIndex do
              Begin
                aCell := Cells.Cells[Col, FSelAnchor.RowIndex];
                InternalSelectCell(aCell);
                InternalSelectCell(aCell.Subcell);
              End;
            If FSelAnchor.IsParent Then
              InternalDeselectCell(FSelAnchor.Subcell);
          End
        Else If FMouseCell.RowIndex = FSelAnchor.RowIndex Then
          Begin
            If FMouseCell = FSelAnchor Then
              InternalSelectCell(FMouseCell)
            Else
              Begin
                If FMouseCell.ColIndex < FSelAnchor.ColIndex Then
                  Begin
                    aCell1 := FMouseCell;
                    aCell2 := FSelAnchor;
                  End
                Else
                  Begin
                    aCell1 := FSelAnchor;
                    aCell2 := FMouseCell;
                  End;

                InternalSelectCell(aCell1);
                If aCell1.IsParent Then
                  InternalSelectCell(aCell1.Subcell);

                InternalSelectCell(aCell2);
                If aCell2.IsSubcell Then
                  InternalSelectCell(aCell2.ParentCell);

                For Col := aCell1.ColIndex + 1 to aCell2.ColIndex - 1 do
                  Begin
                    aCell := Cells.Cells[Col, FMouseCell.RowIndex];
                    InternalSelectCell(aCell);
                    InternalSelectCell(aCell.Subcell);
                  End;
              End;
          End
        Else
          Begin
            InternalSelectCell(FSelAnchor);
            If FSelAnchor.IsParent Then
              InternalSelectCell(FSelAnchor.Subcell);

            For Col := FSelAnchor.ColIndex + 1 to ColCount - 1 do
              Begin
                aCell := Cells.Cells[Col, FSelAnchor.RowIndex];
                InternalSelectCell(aCell);
                InternalSelectCell(aCell.Subcell);
              End;
          End;

        // handle any intermediate rows (all cols in row will be selected)
        StartRow := Lesser(FSelAnchor.RowIndex, FMouseCell.RowIndex);
        EndRow := Greater(FSelAnchor.RowIndex, FMouseCell.RowIndex);
        For Col := 0 to ColCount - 1 do
          For Row := StartRow + 1 to EndRow - 1 do
            Begin
              aCell := Cells.Cells[Col, Row];
              InternalSelectCell(aCell);
              InternalSelectCell(aCell.Subcell);
            End;

        // handle last sel row
        If FMouseCell.RowIndex < FSelAnchor.RowIndex Then
          Begin
            InternalSelectCell(FMouseCell);
            If FMouseCell.IsParent Then
              InternalSelectCell(FMouseCell.Subcell);

            For Col := FMouseCell.ColIndex + 1 to ColCount - 1 do
              Begin
                aCell := Cells.Cells[Col, FMouseCell.RowIndex];
                InternalSelectCell(aCell);
                InternalSelectCell(aCell.Subcell);
              End;
          End
        Else If FMouseCell.RowIndex > FSelAnchor.RowIndex Then
          Begin
            For Col := 0 to FMouseCell.ColIndex do
              Begin
                aCell := Cells.Cells[Col, FMouseCell.RowIndex];
                InternalSelectCell(aCell);
                InternalSelectCell(aCell.Subcell);
              End;
            If FMouseCell.IsParent Then
              InternalDeselectCell(FMouseCell.Subcell);
          End
      End
    Else
      Begin
        StartRow := Lesser(FSelAnchor.RowIndex, FMouseCell.RowIndex);
        EndRow := Greater(FSelAnchor.RowIndex, FMouseCell.RowIndex);
        StartCol := Lesser(FSelAnchor.ColIndex, FMouseCell.ColIndex);
        EndCol := Greater(FSelAnchor.ColIndex, FMouseCell.ColIndex);

        // select all cells and subcells in square
        For Col := StartCol to EndCol do
          For Row := StartRow to EndRow do
            Begin
              aCell := Cells.Cells[Col, Row];
              InternalSelectCell(aCell);
              InternalSelectCell(aCell.Subcell);
            End;

        // for direction (anchor --> mouse)
        //  W, NW, N, NE: If anchor is parent, anchor subcell is NOT selected and
        //                If mouse is subcell, mouse parent is NOT selected
        If (FMouseCell.RowIndex < FSelAnchor.RowIndex) or // all northerly dir
           ((FMouseCell.RowIndex = FSelAnchor.RowIndex) and
            (FMouseCell.ColIndex < FSelAnchor.ColIndex)) Then // west
          Begin
            If FSelAnchor.IsParent Then
              InternalDeselectCell(FSelAnchor.Subcell);

            If FMouseCell.IsSubcell Then
              InternalDeselectCell(FMouseCell.ParentCell);
          End
        // for direction E, SE, S, SW:
        //   If anchor is subcell, anchor parent is NOT selected and
        //   If mouse is parent, mouse subcell is NOT selected
        Else
          Begin
            If FSelAnchor.IsSubcell Then
              InternalDeselectCell(FSelAnchor.ParentCell);

            If FMouseCell.IsParent Then
              InternalDeselectCell(FMouseCell.Subcell);
          End;
      End;
  Finally
    EndSelUpdate;
  End;
end;

function TJvTFCustomGlance.ValidCell(Col, Row: Integer): Boolean;
begin
  Result := False;
  If ValidCol(Col) and ValidRow(Row) Then
    Result := Assigned(Cells.Cells[Col, Row]);
end;

function TJvTFCustomGlance.ValidCol(Col: Integer): Boolean;
begin
  Result := (Col >= 0) and (Col < ColCount);
end;

function TJvTFCustomGlance.ValidRow(Row: Integer): Boolean;
begin
  Result := (Row >= 0) and (Row < RowCount);
end;

procedure TJvTFCustomGlance.WMEraseBkgnd(var Message: TMessage);
begin
  Message.Result := LRESULT(False);
end;

function TJvTFCustomGlance.CellBodyRect(aCell: TJvTFGlanceCell): TRect;
begin
  Result := CalcCellBodyRect(aCell, CellIsSelected(aCell), True);
end;

function TJvTFCustomGlance.CellTitleRect(aCell: TJvTFGlanceCell): TRect;
begin
  Result := CalcCellTitleRect(aCell, CellIsSelected(aCell), True);
end;

procedure TJvTFCustomGlance.DrawCellTitle(aCanvas: TCanvas; TheTitleRect: TRect;
  Attr: TJvTFGlanceCellAttr; Cell: TJvTFGlanceCell);
const
  PicBuffer = 2;
var
  Txt : String;
  DayRect,
  PicRect,
  AdjTitleRect,
  TextBounds : TRect;
  HorzLayout : Boolean;
  I,
  PicIndex,
  PicLeft,
  PicTop,
  PicsHeight,
  PicsWidth : Integer;
begin
  // shade the title
  aCanvas.Brush.Color := Attr.TitleAttr.Color;
  aCanvas.FillRect(TheTitleRect);

  HorzLayout := (Attr.TitleAttr.Align = alTop) or
                (Attr.TitleAttr.Align = alBottom);

  If Assigned(Cell) Then
    Begin
      //Txt := FormatDateTime(Attr.TitleAttr.DayFormat, Cell.CellDate);
      Txt := Cell.TitleText;
      AdjTitleRect := TheTitleRect;
      Windows.InflateRect(AdjTitleRect, -2, -2);

      // Draw the day text and Calc the rects
      If Txt <> '' Then
        Begin
          aCanvas.Font := Attr.TitleAttr.DayTxtAttr.Font;
          DrawAngleText(aCanvas, AdjTitleRect, TextBounds,
                        Attr.TitleAttr.DayTxtAttr.Rotation,
                        Attr.TitleAttr.DayTxtAttr.AlignH,
                        Attr.TitleAttr.DayTxtAttr.AlignV, Txt);

          DayRect := AdjTitleRect;
          Case Attr.TitleAttr.Align of
            alTop, alBottom :
              Case Attr.TitleAttr.DayTxtAttr.AlignH of
                taLeftJustify : DayRect.Right := TextBounds.Right;
                taRightJustify : DayRect.Left := TextBounds.Left;
              End;
            alLeft, alRight :
              Case Attr.TitleAttr.DayTxtAttr.AlignV of
                vaTop : DayRect.Bottom := TextBounds.Bottom;
                vaBottom : DayRect.Top := TextBounds.Top;
              End;
          End;
          Windows.SubtractRect(PicRect, AdjTitleRect, DayRect);
        End
      Else
        Begin
          DayRect := Rect(0, 0, 0, 0);
          PicRect := AdjTitleRect;
        End;

      // draw the pics
      If PicsToDraw(Cell) Then
        Begin
          GetPicsWidthHeight(Cell, PicBuffer, HorzLayout, PicsWidth, PicsHeight);

          // find PicLeft of first pic
          Case Attr.TitleAttr.PicAttr.AlignH of
            taLeftJustify :
              PicLeft := PicRect.Left;
            taCenter :
              PicLeft := PicRect.Left + RectWidth(PicRect) div 2 - PicsWidth div 2;
          Else
            PicLeft := PicRect.Right - PicsWidth;
          End;

          // find PicTop of first pic
          Case Attr.TitleAttr.PicAttr.AlignV of
            vaTop :
              PicTop := PicRect.Top;
            vaCenter :
              PicTop := PicRect.Top + RectHeight(PicRect) div 2 - PicsHeight div 2;
          Else
            PicTop := PicRect.Bottom - PicsHeight;
          End;

          For I := 0 to Cell.CellPics.Count - 1 do
            Begin
              PicIndex := Cell.CellPics[I].PicIndex;
              If ValidPicIndex(PicIndex) Then
                Begin
                  Cell.CellPics[I].SetPicPoint(PicLeft, PicTop);
                  CellPics.Draw(aCanvas, PicLeft, PicTop, PicIndex);
                  If HorzLayout Then
                    Inc(PicLeft, CellPics.Width + PicBuffer)
                  Else
                    Inc(PicTop, CellPics.Height + PicBuffer);
                End;
            End;
        End;
    End;

  // draw the title frame
  DrawCellTitleFrame(aCanvas, TheTitleRect, Attr);
end;


procedure TJvTFCustomGlance.DrawCellFrame(aCanvas: TCanvas; aRect: TRect;
  Attr: TJvTFGlanceCellAttr; aCell: TJvTFGlanceCell);
var
  I,
  LineBottom : Integer;
begin
  With aCanvas do
    Begin
      // draw the cell frame
      Case Attr.FrameAttr.Style of
        fs3DRaised : Draw3DFrame(aCanvas, aRect, clBtnHighlight, clBtnShadow);
        fs3DLowered : Draw3DFrame(aCanvas, aRect, clBtnShadow, clBtnHighlight);
        fsFlat :
          Begin
            Pen.Color := Attr.FrameAttr.Color;
            Pen.Width := 1;

            // draw the bottom line
            LineBottom := aRect.Bottom - 1;
            For I := 1 to Attr.FrameAttr.Width do
              Begin
                MoveTo(aRect.Left, LineBottom);
                LineTo(aRect.Right, LineBottom);
                Dec(LineBottom);
              End;

            // draw the right line
            LineBottom := aRect.Right - 1;
            For I := 1 to Attr.FrameAttr.Width do
              Begin
                MoveTo(LineBottom, aRect.Top);
                LineTo(LineBottom, aRect.Bottom);
                Dec(LineBottom);
              End;

            // draw the left line only for col 0 cells
            If aCell.ColIndex = 0 Then
              Begin
                LineBottom := aRect.Left;
                For I := 1 to Attr.FrameAttr.Width do
                  Begin
                    MoveTo(LineBottom, aRect.Top);
                    LineTo(LineBottom, aRect.Bottom);
                    Inc(LineBottom);
                  End;
              End;
          End;
      End;
  End;
end;

procedure TJvTFCustomGlance.DrawCellTitleFrame(aCanvas: TCanvas; TheTitleRect: TRect;
  Attr: TJvTFGlanceCellAttr);
var
  I,
  LineBottom : Integer;
begin
  With aCanvas do
    Begin
      // draw the title frame
      Case Attr.TitleAttr.FrameAttr.Style of
        fs3DRaised :
          Draw3DFrame(aCanvas, TheTitleRect, clBtnHighlight, clBtnShadow);
        fs3DLowered :
          Draw3DFrame(aCanvas, TheTitleRect, clBtnShadow, clBtnHighlight);
        fsFlat :
          Begin
            Pen.Color := Attr.TitleAttr.FrameAttr.Color;
            Case Attr.TitleAttr.Align of
              alTop :
                Begin
                  if Attr.DrawBottomLine then
                  begin
                    LineBottom := TheTitleRect.Bottom - 1;
                    For I := 1 to Attr.TitleAttr.FrameAttr.Width do
                      Begin
                        MoveTo(TheTitleRect.Left + FGapSize, LineBottom);
                        LineTo(TheTitleRect.Right - FGapSize, LineBottom);
                        Dec(LineBottom);
                      End;
                  end;
                End;
              alBottom :
                Begin
                  LineBottom := TheTitleRect.Top;
                  For I := 1 to Attr.TitleAttr.FrameAttr.Width do
                    Begin
                      MoveTo(TheTitleRect.Left + 4, LineBottom);
                      LineTo(TheTitleRect.Right - 4, LineBottom);
                      Inc(LineBottom);
                    End;
                End;
              alLeft :
                Begin
                  LineBottom := TheTitleRect.Right - 1;
                  For I := 1 to Attr.TitleAttr.FrameAttr.Width do
                    Begin
                      MoveTo(LineBottom, TheTitleRect.Top);
                      LineTo(LineBottom, TheTitleRect.Bottom);
                      Dec(LineBottom);
                    End;
                End;
              alRight :
                Begin
                  LineBottom := TheTitleRect.Left;
                  For I := 1 to Attr.TitleAttr.FrameAttr.Width do
                    Begin
                      MoveTo(LineBottom, TheTitleRect.Top);
                      LineTo(LineBottom, TheTitleRect.Bottom);
                      Inc(LineBottom);
                    End;
                End;
            End;
          End;
      End;
    End;
end;

function TJvTFCustomGlance.PicsToDraw(aCell: TJvTFGlanceCell): Boolean;
var
  I : Integer;
begin
  Result := False;
  If Assigned(CellPics) and (CellPics.Count > 0) Then
    Begin
      I := 0;
      While (I < aCell.CellPics.Count) and not Result do
        If aCell.CellPics[I].PicIndex > -1 Then
          Result := True
        Else
          Inc(I);
    End;
end;

procedure TJvTFCustomGlance.GetPicsWidthHeight(aCell: TJvTFGlanceCell;
  PicBuffer: Integer; Horz: Boolean; var PicsWidth, PicsHeight: Integer);
var
  I,
  PicIndex : Integer;
begin
  If Horz Then
    Begin
      PicsWidth := 0;
      PicsHeight := CellPics.Height;
    End
  Else
    Begin
      PicsWidth := CellPics.Width;
      PicsHeight := 0;
    End;

  For I := 0 to aCell.CellPics.Count - 1 do
    Begin
      PicIndex := aCell.CellPics[I].PicIndex;
      If ValidPicIndex(PicIndex) Then
        If Horz Then
          Inc(PicsWidth, CellPics.Width + PicBuffer)
        Else
          Inc(PicsHeight, CellPics.Height + PicBuffer);
    End;

  If Horz and (PicsWidth > 0) Then
    Dec(PicsWidth, PicBuffer);

  If not Horz and (PicsHeight > 0) Then
    Dec(PicsHeight, PicBuffer);
end;

function TJvTFCustomGlance.ValidPicIndex(PicIndex: Integer): Boolean;
begin
  Result := (PicIndex >= 0) and (PicIndex < CellPics.Count);
end;

procedure TJvTFCustomGlance.SeTJvTFHintProps(Value: TJvTFHintProps);
begin
  FHintProps.Assign(Value);
end;

procedure TJvTFCustomGlance.DoDrawCell(aCanvas: TCanvas; aCellRect, aTitleRect,
  aBodyRect: TRect; Attr: TJvTFGlanceCellAttr; Cell: TJvTFGlanceCell);
begin
  If Assigned(FOnDrawCell) Then
    FOnDrawCell(Self, aCanvas, aCellRect, aTitleRect, aBodyRect, Attr, Cell);
end;

procedure TJvTFCustomGlance.DoDrawTitle(aCanvas: TCanvas; aRect: TRect);
begin
  If Assigned(FOnDrawTitle) Then
    FOnDrawTitle(Self, aCanvas, aRect);
end;

procedure TJvTFCustomGlance.InternalDeselectCell(aCell: TJvTFGlanceCell);
var
  I : Integer;
begin
  If Assigned(aCell) Then
    Begin
      I := Sel.IndexOf(aCell.CellDate);
      If I > -1 Then
        Sel.Delete(I);
    End;
end;

procedure TJvTFCustomGlance.DeselectCell(aCell: TJvTFGlanceCell);
begin
  EnsureCell(aCell);
  InternalDeselectCell(aCell);
end;

procedure TJvTFCustomGlance.BeginSelUpdate;
begin
  FUpdatingSel := True;
end;

procedure TJvTFCustomGlance.EndSelUpdate;
begin
  FUpdatingSel := False;
  SelChange(Self);
end;

procedure TJvTFCustomGlance.SelChange(Sender: TObject);
//var
//  SchedNameList : TStringList;
//  DateList : TJvTFDateList;
//  I : Integer;
begin
  If not UpdatingSel Then
    Begin
      If Assigned(FOnSelChanged) Then
        FOnSelChanged(Self);

      // DoNavigate
//      If Assigned(Navigator) Then
//        Begin
//          SchedNameList := TStringList.Create;
//          DateList := TJvTFDateList.Create;
//          Try
//            SchedNameList.Assign(SchedNames);
//
//            For I := 0 to Sel.Count - 1 do
//              DateList.Add(Sel[I]);
//
//            Navigator.Navigate(Self, SchedNameList, DateList);
//          Finally
//            SchedNameList.Free;
//            DateList.Free;
//          End;
//        End;

      Invalidate;
    End;
end;

procedure TJvTFCustomGlance.ReleaseSchedule(SchedName: String;
  SchedDate: TDate);
begin
  // ALWAYS RELEASE SCHEDULE HERE
  inherited;
end;

procedure TJvTFCustomGlance.SetSchedNames(Value: TStrings);
begin
  FSchedNames.Assign(Value);
  // SchedNamesChange will run
end;

procedure TJvTFCustomGlance.SafeReleaseSchedule(aSched: TJvTFSched);
begin
  If not Cells.IsSchedUsed(aSched) Then
    ReleaseSchedule(aSched.SchedName, aSched.SchedDate);
end;

procedure TJvTFCustomGlance.SchedNamesChange(Sender: TObject);
begin
  If not (csDesigning in ComponentState) and not (csCreating in ControlState) Then
    Cells.CheckConnections;
end;

procedure TJvTFCustomGlance.Notify(Sender: TObject; Code: TJvTFServNotifyCode);
begin
  Inherited;

  // WHAT IS THIS CODE FOR ??!!?!!
  If Assigned(Viewer) Then
    Viewer.Refresh;
end;

procedure TJvTFCustomGlance.CheckApptHint(Info : TJvTFGlanceCoord);
begin
  FHint.ApptHint(Info.Appt, Info.AbsX + 8, Info.AbsY + 8, True, True, False);
end;

procedure TJvTFCustomGlance.CheckViewerApptHint(X, Y: Integer);
var
  Info : TJvTFGlanceCoord;
begin
  Info := PtToCell(X, Y);
  CheckApptHint(Info);
end;

procedure TJvTFCustomGlance.DoEndDrag(Target: TObject; X, Y: Integer);
begin
  inherited;
end;

procedure TJvTFCustomGlance.DoStartDrag(var DragObject: TDragObject);
begin
  If Assigned(Viewer) and Viewer.Editing Then
    Viewer.FinishEditAppt;

  inherited;

  FDragInfo.Appt := SelAppt;
end;

procedure TJvTFCustomGlance.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  SrcDragInfo : TJvTFDragInfo;
  PtInfo : TJvTFGlanceCoord;
  //Appt : TJvTFAppt;
begin
  //Viewer.Visible := False;

  Inherited;

  If Source is TJvTFControl Then
    Begin
      SrcDragInfo := TJvTFControl(Source).DragInfo;
      PtInfo := PtToCell(X, Y);
      Accept := PtInfo.DragAccept;
      //Appt := SrcDragInfo.Appt;

      Case State of
        dsDragEnter :
          Begin
            If not Assigned(FDragInfo) Then
              FDragInfo := SrcDragInfo;
            //BeginDragging(GridCoord, agsMoveAppt, Appt);
          End;
        dsDragLeave :
          Begin
            //EndDragging(GridCoord, Appt);
            If FDragInfo.ApptCtrl <> Self Then
              FDragInfo := nil;
          End;
        //dsDragMove  : ContinueDragging(GridCoord, Appt);
      End;
    End;
end;

procedure TJvTFCustomGlance.SetSelAppt(Value: TJvTFAppt);
begin
  If Value <> FSelAppt Then
    Begin
      FSelAppt := Value;
      Invalidate;
    End;
end;

procedure TJvTFCustomGlance.DragDrop(Source: TObject; X, Y: Integer);
begin
  If Source is TJvTFControl Then
    DropAppt(TJvTFControl(Source).DragInfo, X, Y);

  Inherited;
end;

procedure TJvTFCustomGlance.DropAppt(DragInfo: TJvTFDragInfo; X, Y: Integer);
var
  NewStart,
  NewEnd : TDate;
  Appt : TJvTFAppt;
  PtInfo : TJvTFGlanceCoord;
  Confirm : Boolean;
begin
  FHint.ReleaseHandle;
  Appt := DragInfo.Appt;

  // calc new info
  // Schedule(s) do not change
  PtInfo := PtToCell(X, Y);
  NewStart := PtInfo.Cell.CellDate;
  NewEnd := Trunc(Appt.EndDate) - Trunc(Appt.StartDate) + NewStart;

  Confirm := True;
  If Assigned(FOnDropAppt) Then
    FOnDropAppt(Self, Appt, NewStart, NewEnd, Confirm);

  If Confirm Then
    Begin
      {
      DateChange := (Trunc(Appt.StartDate) <> Trunc(NewStart)) or
                    (Trunc(Appt.EndDate) <> Trunc(NewEnd));

      If DateChange Then
        Begin
        End;
      }

      Appt.SetStartEnd(NewStart, Appt.StartTime, NewEnd, Appt.EndTime);
      ScheduleManager.RefreshConnections(Appt);
    End;
end;

procedure TJvTFCustomGlance.ConfigCells;
begin
  // DO NOT CALL DIRECTLY CALL THIS ROUTINE!
  // This routine is called by TJvTFGlanceCells.ConfigCells.
  // Use this routine to set the cell dates by calling
  // TJvTFCustomGlance.SetCellDate.
  // Override this routine in successors to customize
  // cell/date configuration.

  { Example:
  CellDate := OriginDate;
  For Row := 0 to RowCount - 1 do
    For Col := 0 to ColCount - 1 do
      Begin
        SetCellDate(Col, Row, CellDate);
        CellDate := CellDate + 1;
      End;
  }
  DoConfigCells;
  UpdateCellTitles;
end;

procedure TJvTFCustomGlance.SetCellDate(aCell: TJvTFGlanceCell;
  CellDate: TDate);
begin
  aCell.InternalSetCellDate(CellDate);
end;

procedure TJvTFCustomGlance.ReconfigCells;
begin
  Cells.ReconfigCells;
end;

procedure TJvTFCustomGlance.GlanceTitleChange(Sender: TObject);
begin
  If Assigned(Viewer) Then
    Viewer.Realign;
  Invalidate;
end;

procedure TJvTFCustomGlance.UpdateCellTitleText(Cell : TJvTFGlanceCell);
var
  NewTitleText : String;
begin
  NewTitleText := GetCellTitleText(Cell);
  If Assigned(FOnUpdateCellTitleText) Then
    FOnUpdateCellTitleText(Self, Cell, NewTitleText);
  Cell.SetTitleText(NewTitleText);
end;

function TJvTFCustomGlance.GetCellTitleText(Cell: TJvTFGlanceCell): String;
begin
  Result := FormatDateTime('mm/d/yyyy', Cell.CellDate);
end;

function TJvTFCustomGlance.WholeCellRect(Col, Row: Integer): TRect;
begin
  Result.Left := GetDataLeft + GetDivStart(GetDataWidth, ColCount, Col);
  Result.Right := Result.Left + GetDivLength(GetDataWidth, ColCount, Col);
  Result.Top := GetDataTop + GetDivStart(GetDataHeight, RowCount, Row);
  Result.Bottom := Result.Top + GetDivLength(GetDataHeight, RowCount, Row);
end;

procedure TJvTFCustomGlance.SplitRects(Col, Row: Integer; var ParentRect,
  SubRect: TRect);
var
  aCell : TJvTFGlanceCell;
  WorkRect : TRect;
begin
  ParentRect := EmptyRect;
  SubRect := EmptyRect;
  If not (ValidCol(Col) and ValidRow(Row)) Then
    Exit;

  WorkRect := WholeCellRect(Col, Row);
  ParentRect := WorkRect;

  aCell := Cells.Cells[Col, Row];
  If aCell.IsSplit Then
    Begin
      If aCell.SplitOrientation = soHorizontal Then
        ParentRect.Bottom := ParentRect.Top + RectHeight(ParentRect) div 2
      Else
        ParentRect.Right := ParentRect.Left + RectWidth(ParentRect) div 2;
      Windows.SubtractRect(SubRect, WorkRect, ParentRect);
    End;
end;

procedure TJvTFCustomGlance.UpdateCellTitles;
var
  I : Integer;
  aCell : TJvTFGlanceCell;
begin
  For I := 0 to Cells.Count - 1 do
    Begin
      aCell := Cells[I];
      UpdateCellTitleText(aCell);
      If Assigned(aCell.Subcell) Then
        UpdateCellTitleText(aCell.Subcell);
    End;
end;

procedure TJvTFCustomGlance.SplitCell(aCell: TJvTFGlanceCell);
begin
  aCell.Split;
end;

procedure TJvTFCustomGlance.CombineCell(aCell: TJvTFGlanceCell);
begin
  aCell.Combine;
end;

function TJvTFCustomGlance.GeTJvTFHintClass: TJvTFHintClass;
begin
  Result := TJvTFHint;
end;

{ TJvTFGlanceTitle }

procedure TJvTFGlanceTitle.Assign(Source: TPersistent);
begin
  If Source is TJvTFGlanceTitle Then
    Begin
      FColor := TJvTFGlanceTitle(Source).Color;
      FHeight := TJvTFGlanceTitle(Source).Height;
      FVisible := TJvTFGlanceTitle(Source).Visible;
      FFrameAttr.Assign(TJvTFGlanceTitle(Source).FrameAttr);
      FTxtAttr.Assign(TJvTFGlanceTitle(Source).TxtAttr);
      Change;
    End
  Else
    Inherited Assign(Source);
end;

procedure TJvTFGlanceTitle.Change;
begin
  If Assigned(FOnChange) Then
    FOnChange(Self);
end;

constructor TJvTFGlanceTitle.Create(AOwner: TJvTFCustomGlance);
begin
  Inherited Create;
  FGlanceControl := AOwner;

  FTxtAttr := TJvTFTextAttr.Create;
  FTxtAttr.Font.Size := 16;
  FTxtAttr.Font.Style := FTxtAttr.Font.Style + [fsBold];
  FTxtAttr.OnChange := TxtAttrChange;

  FFrameAttr := TJvTFGlanceFrameAttr.Create(AOwner);

  FColor := clBtnFace;
  FHeight := 40;
  FVisible := True;
end;

destructor TJvTFGlanceTitle.Destroy;
begin
  FFrameAttr.Free;
  FTxtAttr.OnChange := nil;
  FTxtAttr.Free;

  inherited;
end;

procedure TJvTFGlanceTitle.SetColor(Value: TColor);
begin
  If Value <> FColor Then
    Begin
      FColor := Value;
      Change;
    End;
end;

procedure TJvTFGlanceTitle.SetFrameAttr(Value: TJvTFGlanceFrameAttr);
begin
  FFrameAttr.Assign(Value);
end;

procedure TJvTFGlanceTitle.SetHeight(Value: Integer);
begin
  Value := Greater(Value, 0);
  If Assigned(GlanceControl) Then
    Value := Lesser(Value, GlanceControl.Height - 5);

  If Value <> FHeight Then
    Begin
      FHeight := Value;
      Change;
    End;
end;

procedure TJvTFGlanceTitle.SetTxtAttr(Value: TJvTFTextAttr);
begin
  FTxtAttr.Assign(Value);
  Change;
end;

procedure TJvTFGlanceTitle.SetVisible(Value: Boolean);
begin
  If Value <> FVisible Then
    Begin
      FVisible := Value;
      Change;
    End;
end;

procedure TJvTFGlanceTitle.TxtAttrChange(Sender: TObject);
begin
  Change;
end;

{ TJvTFFrameAttr }

procedure TJvTFFrameAttr.Assign(Source: TPersistent);
begin
  If Source is TJvTFFrameAttr Then
    Begin
      FStyle := TJvTFFrameAttr(Source).Style;
      FColor := TJvTFFrameAttr(Source).Color;
      FWidth := TJvTFFrameAttr(Source).Width;
      Change;
    End
  Else
    Inherited Assign(Source);
end;

procedure TJvTFFrameAttr.Change;
begin
  If Assigned(FOnChange) Then
    FOnChange(Self);
    
  If Assigned(Control) Then
    Control.Invalidate;
end;

constructor TJvTFFrameAttr.Create(AOwner: TJvTFControl);
begin
  Inherited Create;
  FControl := AOwner;

  FStyle := fsFlat;
  FColor := clBlack;
  FWidth := 1;
end;

procedure TJvTFFrameAttr.SetColor(Value: TColor);
begin
  If Value <> FColor Then
    Begin
      FColor := Value;
      Change;
    End;
end;

procedure TJvTFFrameAttr.SetStyle(Value: TJvTFFrameStyle);
begin
  If Value <> FStyle Then
    Begin
      FStyle := Value;
      Change;
    End;
end;

procedure TJvTFFrameAttr.SetWidth(Value: Integer);
begin
  Value := Greater(Value, 1);

  If Value <> FWidth Then
    Begin
      FWidth := Value;
      Change;
    End;
end;

{ TJvTFGlanceCellAttr }

procedure TJvTFGlanceCellAttr.Assign(Source: TPersistent);
begin
  If Source is TJvTFGlanceCellAttr Then
    Begin
      FColor := TJvTFGlanceCellAttr(Source).Color;
      FFrameAttr.Assign(TJvTFGlanceCellAttr(Source).FrameAttr);
      FTitleAttr.Assign(TJvTFGlanceCellAttr(Source).TitleAttr);
      FFont.Assign(TJvTFGlanceCellAttr(Source).Font);
      Change;
    End
  Else
    Inherited Assign(Source);
end;

procedure TJvTFGlanceCellAttr.Change;
begin
  If Assigned(GlanceControl) Then
    GlanceControl.Invalidate;
end;

constructor TJvTFGlanceCellAttr.Create(AOwner: TJvTFCustomGlance);
begin
  Inherited Create;
  FGlanceControl := AOwner;

  FColor := clWhite;
  FFrameAttr := TJvTFGlanceFrameAttr.Create(AOwner);
  FTitleAttr := TJvTFGlanceTitleAttr.Create(AOwner);

  FFont := TFont.Create;
  FFont.OnChange := FontChange;
end;

destructor TJvTFGlanceCellAttr.Destroy;
begin
  FFrameAttr.Free;
  FTitleAttr.Free;
  FFont.Free;

  inherited;
end;

procedure TJvTFGlanceCellAttr.FontChange(Sender: TObject);
begin
  Change;
end;

procedure TJvTFGlanceCellAttr.SetDrawBottomLine(Value: boolean);
begin
   if Value <> FDrawBottomLine then
   begin
      FDrawBottomLine := Value;
      Change;
   end;
end;

procedure TJvTFGlanceCellAttr.SetColor(Value: TColor);
begin
  If Value <> FColor Then
    Begin
      FColor := Value;
      Change;
    End;
end;

procedure TJvTFGlanceCellAttr.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TJvTFGlanceCellAttr.SetFrameAttr(Value: TJvTFGlanceFrameAttr);
begin
  FFrameAttr.Assign(Value);
end;

procedure TJvTFGlanceCellAttr.SetTitleAttr(Value: TJvTFGlanceTitleAttr);
begin
  FTitleAttr.Assign(Value);
end;

{ TJvTFGlanceTitleAttr }

procedure TJvTFGlanceTitleAttr.Assign(Source: TPersistent);
begin
  If Source is TJvTFGlanceTitleAttr Then
    Begin
      FAlign := TJvTFGlanceTitleAttr(Source).Align;
      //FDayFormat := TJvTFGlanceTitleAttr(Source).DayFormat;
      FColor := TJvTFGlanceTitleAttr(Source).Color;
      FHeight := TJvTFGlanceTitleAttr(Source).Height;
      FVisible := TJvTFGlanceTitleAttr(Source).Visible;
      FFrameAttr.Assign(TJvTFGlanceTitleAttr(Source).FrameAttr);
      FDayTxtAttr.Assign(TJvTFGlanceTitleAttr(Source).DayTxtAttr);
      Change;
    End
  Else
    Inherited Assign(Source);
end;

procedure TJvTFGlanceTitleAttr.Change;
begin
  If Assigned(GlanceControl) Then
    Begin
      If Assigned(GlanceControl.Viewer) Then
        GlanceControl.Viewer.Realign;
      GlanceControl.Invalidate;
    End;
end;

constructor TJvTFGlanceTitleAttr.Create(AOwner: TJvTFCustomGlance);
begin
  Inherited Create;
  FGlanceControl := AOwner;

  FAlign := alTop;

  FColor := clBtnFace;
  FHeight := 20;
  FVisible := True;
  //FDayFormat := 'd';

  FFrameAttr := TJvTFGlanceFrameAttr.Create(AOwner);

  FDayTxtAttr := TJvTFTextAttr.Create;
  FDayTxtAttr.OnChange := TxtAttrChange;

  FPicAttr := TJvTFGlanceTitlePicAttr.Create;
  FPicAttr.OnChange := PicAttrChange;
end;

destructor TJvTFGlanceTitleAttr.Destroy;
begin
  FFrameAttr.Free;
  FDayTxtAttr.OnChange := nil;
  FDayTxtAttr.Free;
  FPicAttr.OnChange := nil;
  FPicAttr.Free;

  inherited;
end;

procedure TJvTFGlanceTitleAttr.PicAttrChange(Sender: TObject);
begin
  Change;
end;

procedure TJvTFGlanceTitleAttr.SetAlign(Value: TJvTFTitleAlign);
begin
  If Value <> FAlign Then
    Begin
      FAlign := Value;
      Change;
    End;
end;

procedure TJvTFGlanceTitleAttr.SetColor(Value: TColor);
begin
  If Value <> FColor Then
    Begin
      FColor := Value;
      Change;
    End;
end;

{
procedure TJvTFGlanceTitleAttr.SetDayFormat(Value: String);
begin
  If Value <> FDayFormat Then
    Begin
      FDayFormat := Value;
      Change;
    End;
end;
}

procedure TJvTFGlanceTitleAttr.SetDayTxtAttr(Value: TJvTFTextAttr);
begin
  FDayTxtAttr.Assign(Value);
  Change;
end;

procedure TJvTFGlanceTitleAttr.SetFrameAttr(Value: TJvTFGlanceFrameAttr);
begin
  FFrameAttr.Assign(Value);
  Change;
end;

procedure TJvTFGlanceTitleAttr.SetHeight(Value: Integer);
begin
  If Value <> FHeight Then
    Begin
      FHeight := Value;
      Change;
    End;
end;

procedure TJvTFGlanceTitleAttr.SetPicAttr(Value: TJvTFGlanceTitlePicAttr);
begin
  FPicAttr.Assign(Value);
  Change;
end;

procedure TJvTFGlanceTitleAttr.SetVisible(Value: Boolean);
begin
  If Value <> FVisible Then
    Begin
      FVisible := Value;
      Change;
    End;
end;

procedure TJvTFGlanceTitleAttr.TxtAttrChange(Sender: TObject);
begin
  Change;
end;

{ TJvTFGlanceSelList }

constructor TJvTFGlanceSelList.Create(AOwner : TJvTFCustomGlance);
begin
  Inherited Create;
  FGlanceControl := AOwner;
end;

{ TJvTFGlanceViewer }

function TJvTFGlanceViewer.ApptCount: Integer;
var
  I : Integer;
  ApptList : TStringList;
begin
  If RepeatGrouped Then
    Begin
      Result := 0;
      For I := 0 to ScheduleCount - 1 do
        Inc(Result, Schedules[I].ApptCount);
    End
  Else
    Begin
      ApptList := TStringList.Create;
      Try
        GetDistinctAppts(ApptList);
        Result := ApptList.Count;
      Finally
        ApptList.Free;
      End;
    End;
end;

constructor TJvTFGlanceViewer.Create(AOwner: TComponent);
begin
  inherited;
  FRepeatGrouped := True;
end;

procedure TJvTFGlanceViewer.EnsureCol(aCol: Integer);
begin
  GlanceControl.EnsureCol(aCol);
end;

procedure TJvTFGlanceViewer.EnsureRow(aRow: Integer);
begin
  GlanceControl.EnsureRow(aRow);
end;

function TJvTFGlanceViewer.GetRepeatAppt(Index: Integer): TJvTFAppt;
var
  I,
  AbsIndex : Integer;
begin
  If (Index < 0) or (Index > ApptCount - 1) Then
    Raise EGlanceViewerError.CreateFmt(RsEApptIndexOutOfBoundsd, [Index]);

  AbsIndex := 0;
  I := -1;

  Repeat
    Inc(I);
    Inc(AbsIndex, Schedules[I].ApptCount);
  Until AbsIndex - 1 >= Index;

  Result := Schedules[I].Appts[Schedules[I].ApptCount - (AbsIndex - Index)];
end;

function TJvTFGlanceViewer.GetDate: TDate;
begin
  Result := Cell.CellDate;
end;

function TJvTFGlanceViewer.GetDistinctAppt(Index: Integer): TJvTFAppt;
var
  ApptList : TStringList;
begin
  Result := nil;
  ApptList := TStringList.Create;
  Try
    GetDistinctAppts(ApptList);
    If (Index < 0) or (Index >= ApptList.Count) Then
      Raise EGlanceViewerError.CreateFmt(RsEApptIndexOutOfBoundsd, [Index]);

    Result := TJvTFAppt(ApptList.Objects[Index]);
  Finally
    ApptList.Free;
  End;
end;

procedure TJvTFGlanceViewer.GetDistinctAppts(ApptList: TStringList);
var
  I,
  J : Integer;
  Sched : TJvTFSched;
  Appt : TJvTFAppt;
begin
  ApptList.Clear;

  For I := 0 to ScheduleCount - 1 do
    Begin
      Sched := Schedules[I];
      For J := 0 to Sched.ApptCount - 1 do
        Begin
          Appt := Sched.Appts[J];
          If ApptList.IndexOf(Appt.ID) = -1 Then
            ApptList.AddObject(Appt.ID, Appt);
        End;
    End;
end;

function TJvTFGlanceViewer.GetSchedule(Index: Integer): TJvTFSched;
begin
  Result := Cell.Schedules[Index];
end;

procedure TJvTFGlanceViewer.MouseAccel(X, Y: Integer);
begin
  // do nothing, leave implemenation to successors
end;

procedure TJvTFGlanceViewer.MoveTo(aCell: TJvTFGlanceCell);
begin
  SetTo(aCell);
  FPhysicalCell := aCell;
  Realign;
end;

procedure TJvTFGlanceViewer.Notify(Sender: TObject;
  Code: TJvTFServNotifyCode);
begin
  Case Code of
    sncConnectControl :
      SetGlanceControl(TJvTFCustomGlance(Sender));
    sncDisconnectControl :
      If GlanceControl = Sender Then
        SetGlanceControl(nil);
  end;
end;

procedure TJvTFGlanceViewer.ParentReconfig;
begin
  // do nothing, leave implementation to successors
end;

function TJvTFGlanceViewer.ScheduleCount: Integer;
begin
  if Assigned(Cell) then
    Result := Cell.ScheduleCount
  else
    Result := 0;
end;

procedure TJvTFGlanceViewer.SetGlanceControl(Value: TJvTFCustomGlance);
begin
  FGlanceControl := Value;
end;


procedure TJvTFGlanceViewer.SetRepeatGrouped(Value: Boolean);
begin
  If Value <> FRepeatGrouped Then
    Begin
      FRepeatGrouped := Value;
      Refresh;
    End;
end;

procedure TJvTFGlanceViewer.SetTo(aCell: TJvTFGlanceCell);
begin
  FCell := aCell;
end;

function TJvTFGlanceViewer.GetAppt(Index: Integer): TJvTFAppt;
begin
  If RepeatGrouped Then
    Result := GetRepeatAppt(Index)
  Else
    Result := GetDistinctAppt(Index);
end;

function TJvTFGlanceViewer.CalcBoundsRect(aCell: TJvTFGlanceCell): TRect;
begin
  If Assigned(GlanceControl) and Assigned(aCell) Then
    With GlanceControl do
      Result := CalcCellBodyRect(aCell, CellIsSelected(aCell), False)
  Else
    Result := Rect(0, 0, 0, 0);
end;

function TJvTFGlanceViewer.GetApptAt(X, Y: Integer): TJvTFAppt;
begin
  Result := nil;
end;

function TJvTFGlanceViewer.CanEdit: Boolean;
begin
  Result := False;
end;

function TJvTFGlanceViewer.Editing: Boolean;
begin
  Result := False;
end;

procedure TJvTFGlanceViewer.FinishEditAppt;
begin
  // do nothing, leave implementation to successors
end;

{ TJvTFGlanceFrameAttr }

procedure TJvTFGlanceFrameAttr.Change;
begin
  inherited;
  If Assigned(GlanceControl) and Assigned(GlanceControl.Viewer) Then
    GlanceControl.Viewer.Realign;
end;

constructor TJvTFGlanceFrameAttr.Create(AOwner: TJvTFCustomGlance);
begin
  Inherited Create(AOwner);
  FGlanceControl := AOwner;
end;

{ TJvTFTextAttr }

procedure TJvTFTextAttr.Assign(Source: TPersistent);
begin
  If Source is TJvTFTextAttr Then
    Begin
      FFont.Assign(TJvTFTextAttr(Source).Font);
      FRotation := TJvTFTextAttr(Source).Rotation;
      FAlignH := TJvTFTextAttr(Source).AlignH;
      FAlignV := TJvTFTextAttr(Source).AlignV;
      DoChange;
    End
  Else
    Inherited Assign(Source);
end;

constructor TJvTFTextAttr.Create;
begin
  Inherited;
  
  FFont := TFont.Create;
  FFont.OnChange := FontChange;
  FAlignH := taLeftJustify;
  FAlignV := vaCenter;
end;

destructor TJvTFTextAttr.Destroy;
begin
  FFont.OnChange := nil;
  FFont.Free;
  inherited;
end;

procedure TJvTFTextAttr.DoChange;
begin
  If Assigned(FOnChange) Then
    FOnChange(Self);
end;

procedure TJvTFTextAttr.FontChange(Sender: TObject);
begin
  DoChange;
end;

procedure TJvTFTextAttr.SetAlignH(Value: TAlignment);
begin
  If Value <> FAlignH Then
    Begin
      FAlignH := Value;
      DoChange;
    End;
end;

procedure TJvTFTextAttr.SetAlignV(Value: TJvTFVAlignment);
begin
  If Value <> FAlignV Then
    Begin
      FAlignV := Value;
      DoChange;
    End;
end;

procedure TJvTFTextAttr.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  DoChange;
end;

procedure TJvTFTextAttr.SetRotation(Value: Integer);
begin
  If Value <> FRotation Then
    Begin
      FRotation := Value;
      DoChange;
    End;
end;

{ TJvTFCellPics }

function TJvTFCellPics.Add: TJvTFCellPic;
begin
  Result := TJvTFCellPic(Inherited Add);
end;

function TJvTFCellPics.AddPic(PicName: String; PicIndex: Integer): TJvTFCellPic;
begin
  Result := Add;
  Result.PicName := PicName;
  Result.PicIndex := PicIndex;
end;

procedure TJvTFCellPics.Assign(Source: TPersistent);
var
  I : Integer;
begin
  If Source is TJvTFCellPics Then
    Begin
      BeginUpdate;
      Try
        Clear;
        For I := 0 to TJvTFCellPics(Source).Count - 1 do
          Add.Assign(TJvTFCellPics(Source).Items[I]);
      Finally
        EndUpdate;
      End
    End
  Else
    Inherited Assign(Source);
end;

constructor TJvTFCellPics.Create(aGlanceCell: TJvTFGlanceCell);
begin
  Inherited Create(TJvTFCellPic);
  FGlanceCell := aGlanceCell;
end;

function TJvTFCellPics.GetItem(Index: Integer): TJvTFCellPic;
begin
  Result := TJvTFCellPic(Inherited GetItem(Index));
end;

function TJvTFCellPics.GetOwner: TPersistent;
begin
  Result := GlanceCell;
end;

function TJvTFCellPics.GetPicIndex(PicName: String): Integer;
var
  aCellPic : TJvTFCellPic;
begin
  Result := -1;
  aCellPic := PicByName(PicName);
  If Assigned(aCellPic) Then
    Result := aCellPic.PicIndex;
end;

function TJvTFCellPics.PicByName(PicName: String): TJvTFCellPic;
var
  I : Integer;
begin
  Result := nil;
  I := 0;
  While (I < Count) and not Assigned(Result) do
    Begin
      If Items[I].PicName = PicName Then
        Result := Items[I];
      Inc(I);
    End;
end;

procedure TJvTFCellPics.SetItem(Index: Integer; Value: TJvTFCellPic);
begin
  Inherited SetItem(Index, Value);
end;

{ TJvTFCellPic }

procedure TJvTFCellPic.Assign(Source: TPersistent);
begin
  If Source is TJvTFCellPic Then
    Begin
      FPicName := TJvTFCellPic(Source).PicName;
      FPicIndex := TJvTFCellPic(Source).PicIndex;
      Change;
    End
  Else
    inherited Assign(Source);
end;

procedure TJvTFCellPic.Change;
begin
  If Assigned(PicCollection.GlanceCell.CellCollection.GlanceControl) Then
    PicCollection.GlanceCell.CellCollection.GlanceControl.Invalidate;
end;

constructor TJvTFCellPic.Create(Collection: TCollection);
begin
  inherited;
  FPicIndex := -1;
  FHints := TStringList.Create;
end;

destructor TJvTFCellPic.Destroy;
begin
  FHints.Free;
  inherited;
end;

function TJvTFCellPic.GetDisplayName: String;
begin
  If PicName <> '' Then
    Result := PicName
  Else
    Result := Inherited GetDisplayName;
end;

function TJvTFCellPic.PicCollection: TJvTFCellPics;
begin
  Result := TJvTFCellPics(Collection);
end;

procedure TJvTFCellPic.SetHints(Value: TStrings);
begin
  FHints.Assign(Value);
end;

procedure TJvTFCellPic.SetPicIndex(Value: Integer);
begin
  If Value <> FPicIndex Then
    Begin
      FPicIndex := Value;
      Change;
    End;
end;

procedure TJvTFCellPic.SetPicName(Value: String);
begin
  If Value <> FPicName Then
    Begin
      FPicName := Value;
      Change;
    End;
end;

procedure TJvTFCellPic.SetPicPoint(X, Y: Integer);
begin
  FPicPoint := Point(X, Y);
end;

{ TJvTFGlanceTitlePicAttr }

procedure TJvTFGlanceTitlePicAttr.Assign(Source: TPersistent);
begin
  If Source is TJvTFGlanceTitlePicAttr Then
    Begin
      FAlignH := TJvTFGlanceTitlePicAttr(Source).AlignH;
      FAlignV := TJvTFGlanceTitlePicAttr(Source).AlignV;
      DoChange;
    End
  Else
    inherited Assign(Source);
end;

constructor TJvTFGlanceTitlePicAttr.Create;
begin
  Inherited;
  FAlignH := taLeftJustify;
  FAlignV := vaCenter;
end;

procedure TJvTFGlanceTitlePicAttr.DoChange;
begin
  If Assigned(FOnChange) Then
    FOnChange(Self);
end;

procedure TJvTFGlanceTitlePicAttr.SetAlignH(Value: TAlignment);
begin
  If Value <> FAlignH Then
    Begin
      FAlignH := Value;
      DoChange;
    End;
end;

procedure TJvTFGlanceTitlePicAttr.SetAlignV(Value: TJvTFVAlignment);
begin
  If Value <> FAlignV Then
    Begin
      FAlignV := Value;
      DoChange;
    End;
end;

{ TJvTFGlance }

constructor TJvTFGlance.Create(AOwner: TComponent);
begin
  inherited;
  AllowCustomDates := True;
end;

{ TJvTFGlanceMainTitle }

procedure TJvTFGlanceMainTitle.Assign(Source: TPersistent);
begin
  If Source is TJvTFGlanceMainTitle Then
    FTitle := TJvTFGlanceMainTitle(Source).Title;

  inherited Assign(Source);
end;

constructor TJvTFGlanceMainTitle.Create(AOwner: TJvTFCustomGlance);
begin
  Inherited Create(AOwner);
  FTitle := '(Title)';
end;

procedure TJvTFGlanceMainTitle.SetTitle(Value: String);
begin
  If Value <> FTitle Then
    Begin
      FTitle := Value;
      Change;
    End;
end;

procedure TJvTFGlanceCell.SeTJvTFSplitOrientation(Value: TJvTFSplitOrientation);
begin
  If Value <> FSplitOrientation Then
    Begin
      FSplitOrientation := Value;
      If IsSubCell Then
        ParentCell.SplitOrientation := Value
      Else If IsSplit Then
        Begin
          SubCell.SplitOrientation := Value;
          Change;
        End;
    End;
end;

procedure TJvTFGlanceCell.SetTitleText(Value: String);
begin
  FTitleText := Value;
end;

procedure TJvTFGlanceCell.Split;
begin
  If Assigned(CellCollection.GlanceControl) and
     not CellCollection.GlanceControl.AllowCustomDates and
     not CellCollection.Configuring Then
    Raise EJvTFGlanceError.Create(RsECellCannotBeSplit);

  If IsSubCell Then
    Raise EJvTFGlanceError.Create(RsEASubcellCannotBeSplit);

  If not IsSplit Then
    Begin
      FSplitRef := TJvTFGlanceCell.Create(nil);
      //FSplitRef := TJvTFGlanceCell.Create(CellCollection);
      FSplitRef.FCellCollection := CellCollection;
      FSplitRef.SetColIndex(ColIndex);
      FSplitRef.SetRowIndex(RowIndex);
      FSplitRef.FSplitOrientation := SplitOrientation;
      FSplitRef.FSplitRef := Self;
      FSplitRef.FIsSubcell := True;
      If not CellCollection.Configuring Then
        CellCollection.ReconfigCells;
    End;
end;

end.
