{-----------------------------------------------------------------------------
JvChart - TJvChart Component

The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvChart.PAS, released on 2003-09-30.

The Initial Developers of the Original Code are
    Warren Postma (TJvChart which was originally based on TAABGraph)
    M�rten Henrichson (TAABGraph)

Contributor(s):
    Warren Postma (warrenpstma@hotmail.com)
    M�rten Henrichson/AABSoft (no email known)

    Contains some code which is
        (C) 1996-1998 AABsoft and M�rten Henrichson

    The rest is
        (C) 2003 Warren Postma
              warren.postma@sympatico.ca
              warrenpstma@hotmail.com

Last Modified:
  2003-09-30 - (WP) - Alpha-Initial checkin of new component, into JVCL3 CVS tree.
  2004-02-26 - (WP) - Pre-JVCL3.0-Has been substantially jedified, also new
                      properties/events, and some renaming has occurred. See
                      cvs logs. NEW: OnChartClick event.
                      RENAME: Options.ThickLineWidth  -> Options.PenLineWidth
                      RENAME: Values                  -> ValueIndex
  2004-04-10 - (WP) - Much improved Charting! Beta-Quality in most places.
                      Significant property reorganization and renaming.
                      Primary and Secondary Y (vertical) Axis support.

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
  MARCH 2004 -JVCL3BETA- STILL IN DEVELOPMENT. REPORT PROBLEMS TO JEDI JVCL
  BUG TRACKING SYSTEM (AKA 'MANTIS') AND THE JEDI.VCL NEWSGROUP!
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvChart;

interface

uses
  SysUtils, Classes,
  {$IFDEF MSWINDOWS}
  Windows, 
  {$ENDIF MSWINDOWS}
  {$IFDEF VCL}
  Messages, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Printers, Clipbrd,
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, QPrinters, QClipbrd,
  Types, QWindows,
  {$ENDIF VisualCLX}
  JvComponent, JvJCLUtils;

const
  JvChartVersion = 300; // ie, version 3.00

  JvDefaultHintColor = TColor($00DDFBFA);

  JvDefaultYLegends = 20;
  MaxShowXValueInLegends = 10;

  // Special indices to GetPenColor(index)
  jvChartDivisionLineColorIndex  = -5;
  jvChartShadowColorIndex        = -4;
  jvChartAxisColorIndex          = -3;
  jvChartHintColorIndex          = -2;
  jvChartPaperColorIndex         = -1;

  JvChartDefaultMarkerSize    =3;

resourcestring
   JvChartDesigntimeLabel = ': JEDI JVCL Charting Component';

type
  {CHART TYPES}
  TJvChartKind =
   (ckChartNone, // Blank graph.
    ckChartLine, // default type. Line and Marker plots.
    ckChartBar,
    ckChartStackedBar,
    ckChartBarAverage,
    ckChartStackedBarAverage,
    ckChartPieChart,
    //ckChartLineWithMarkers, // obsolete. use ckChartLine, and set PenMarkerKind to cmDiamond.
    ckChartMarkers,
    ckChartDeltaAverage);

    // ckChartLine can have a different pen type for each pen:


  TJvChartPenMarkerKind = ( pmkNone, pmkDiamond, pmkCircle, pmkSquare, pmkCross );

  TJvChartLegend = (clChartLegendNone,clChartLegendRight,clChartLegendBelow);

  TJvChartDataArray = array of array of Double;

  { TJvChartData : Holds NxN array of Reals, Resizes automatically within preset
    limits. Provides a functionality mix of dynamic memory use, but with
    a memory cap, so we don't thrash the system or leak forever.  -WAP.}
  TJvChartData = class(TObject)
  private
    FData: TJvChartDataArray;
    FTimeStamp:array of TDateTime; // Time-series as a TDateTime
      // Dynamic array of dynamic array of Double.
      // is empty until data is stored in them.
      // *** Order of indexing: FData[ValueIndex,Pen] ***
    FDataAlloc: Integer; // Last Allocated Value.
    FValueCount: Integer; // Number of sample indices used
  protected
    procedure Grow(Pen, ValueIndex: Integer);
      //GetValue/SetValue resizer, also throws exception if Pen,ValueIndex is negative or just way too big.
    function GetValue(Pen, ValueIndex: Integer): Double;
    procedure SetValue(Pen, ValueIndex: Integer; NewValue: Double);

    function GetTimestamp(  ValueIndex:Integer):TDatetime;
    procedure SetTimestamp( ValueIndex:Integer; aValue:TDatetime);


  public
    constructor Create;
    destructor Destroy; override;
    function DebugStr( ValueIndex:Integer ):String; // dump all pens for particular valueindex, as string.
    procedure Clear; // Resets to zero.
    property Value[Pen,  ValueIndex : Integer]: Double    read GetValue write SetValue; default;
    property Timestamp[  ValueIndex : Integer]: TDateTime read GetTimestamp write SetTimestamp;
    property ValueCount: Integer                          read FValueCount write FValueCount;


    
    procedure Scroll;

  end;

  TJvChart = class;

  TJvChartEvent = procedure(Sender:TJvChart) of Object; {NEW}

  TJvChartClickEvent = procedure(Sender:TJvChart;
                                    Button: TMouseButton; { left/right mouse click?}
                                    Shift: TShiftState;   { keyboard shift state?}
                                    X, Y: Integer;        { mouse position}
                                    ChartValueIndex: Integer; { what value in the chart? }
                                    ChartPenIndex: Integer;   { what pen was clicked? }
                                    { User modifiable return values for custom hinting! }
                                    var ShowHint,HintFirstLineBold:Boolean; HintStrs:TStrings) of Object; {NEW}

  TJvChartOptions = class;

  { There are TWO Y Axis per graph, optionally:
        Chart.Options.GetPenAxis(I) -and-
        Chart.Options.SecondaryYAxisOne
    The primary one is displayed along the left side, and the one
    for the right side is only displayed if you need it.
    Properties for each side are grouped by the
    TJvChartYAxisOptions persistent-properties-object.
  }
  TJvChartYAxisOptions = class(TPersistent)
    private
        FOwner  : TJvChartOptions;
        FActive : Boolean; // One or more pens use this Y Axis.
    protected
    FYMax: Double; // Y Scale value at the top left hand side of chart.
    FYMin: Double; // Y Scale value at the bottom left hand side of the chart (default 0)
    FYGap: Double; // Number of values per Y scale division
    FYGap1:Double; // Gap multiplication factor for value scaling. 
    FYDivisions: Integer; // Number of vertical divisions in the chart. (default 10)
    FMaxYDivisions : Integer;
    FMinYDivisions : Integer;
    FYLegendDecimalPlaces: Integer;
    FYLegends: TStringList;
    FDefaultYLegends: Integer; // Number of default Y legends.
    FYPixelGap: Double;

     procedure SetYMax(newYmax: Double);
//     procedure SetYGap(newYgap: Double);
     function GetYLegends: TStrings;
     procedure SetYLegends(Value: TStrings);

     procedure SetYDivisions(aValue:Integer);


    public
          constructor  Create(owner:TJvChartOptions); virtual;
          destructor   Destroy; override;
          procedure    Normalize;
          procedure    Clear;

    // runtime only properties
        property YPixelGap: Double read FYPixelGap write FYPixelGap;

        property Active:Boolean read FActive;

        property YGap: Double read FYGap;
        property YGap1:Double read FYGap1; // Gap multiplication factor for value scaling.

        property YLegends: TStrings read GetYLegends write SetYLegends;     { Y Axis Legends as Strings }

    published
        property YMax: Double read FYMax write SetYMax;
        property YMin: Double read FYMin write FYMin;
        property YDivisions: Integer read FYDivisions write SetYDivisions default 10; // Number of vertical divisions in the chart
        // YDivisions->YDivisions
        property MaxYDivisions:Integer read FMaxYDivisions write FMaxYDivisions default 20;
        property MinYDivisions:Integer read FMinYDivisions write FMinYDivisions default 5;

        property YLegendDecimalPlaces: Integer read FYLegendDecimalPlaces write FYLegendDecimalPlaces;
        property DefaultYLegends: Integer read FDefaultYLegends write FDefaultYLegends default JvDefaultYLegends;



  end;




  TJvChartOptions = class(TPersistent)
  private
    FOwner: TJvChart;
  protected

    FChartKind: TJvChartKind; // default JvChartLine
    {runtime pixel spacing multipliers}
    FXPixelGap: Double;
    {Fonts}
    FHeaderFont: TFont;
    FLegendFont: TFont;
    FAxisFont: TFont;
    FTitle: string;

    FYAxisHeader: string;
    FYAxisDivisionMarkers:Boolean;    // Do you want grid-paper look?

    FXAxisDivisionMarkers:Boolean;  // Do you want grid-paper look?
    FXAxisHeader: string;
    FXLegends: TStringList; // Text labels.
    FXLegendMaxTextWidth: Integer; // runtime: display width (pixels) of widest string in FXLegends[1:x].

    FXAxisValuesPerDivision:Integer; // Number of Values (aka samples) in each vertical dotted lines that are divisision marker.
    FXAxisLegendSkipBy: Integer; //1=print every X axis label, 2=every other, and so on. default=1
    FXAxisDateTimeMode:Boolean; // False=use custom text labels, true=Use Date/Time Stamps as X axis labels.
    FXAxisDateTimeFormat:String; // Usually a short date-time label, hh:nn:ss is good.
    FDateTimeFormat:String; // Usually a long date-time label, ISO standard yyyy-mm-dd hh:nn:ss is fine, as is Windows locale defaults.


    FXValueCount: Integer;


    // Number of pens:
    FPenCount: Integer;
    // Per-pen array/list properties    
    FPenColors               : Array of TColor;
    FPenStyles               : Array of TPenStyle; // solid, dotted
    FPenMarkerKind           : Array of TJvChartPenMarkerKind;
    FPenSecondaryAxisFlag    : Array of Boolean; // False=Primary Y Axis, True=Secondary Y Axis.
    FPenValueLabels          : Array of Boolean;    
    FPenLegends              : TStringList;
    FPenUnit                 : TStringList;


    FAverageValue   : Array of Double; // Used in averaging chart types only.

    FPrimaryYAxis: TJvChartYAxisOptions;
    FSecondaryYAxis: TJvChartYAxisOptions;

    FXGap: Double; // Number of pixels per X scale unit.
    FXOrigin: Integer; {which value corresponds to Origin}
    FYOrigin: Integer; // Vertical (Y) Position of the Origin point, and X axis.
    FXStartOffset: Longint; {margin} // Horizontal (X) Position of the Origin point, and Y Axis
    FYStartOffset: Longint; // height of the top margin above the charting area.
    FXEnd: Longint; { From top left of control, add XEnd to find where the right margin starts }
    FYEnd: Longint; { from top left of control, add YEnd to find where the below-the bottom margin starts }
    FMarkerSize: Integer; { marker size. previously called PointSize which sounded like a Font attribute. }
    { more design time }
    FLegendWidth: Integer;
    FLegendRowCount: Integer; // Number of lines of text in legend.
    FAutoUpdateGraph: Boolean;
    FMouseEdit: Boolean;
    FMouseInfo: Boolean;
    FLegend: TJvChartLegend; // was FShowLegend, now     Legend=clChartLegendRight
    FPenLineWidth: Integer;
    FAxisLineWidth: Integer;
    FPaperColor: TColor;
    FAxisLineColor: TColor;
    FHintColor: TColor;
    FCursorColor    :TColor; // Sample indicator - Cursor color
    FCursorStyle    :TPenStyle; // Cursor style.



  protected
    { event interface }
    procedure NotifyOptionsChange;

    {accessors}
    function  GetAverageValue(Index: Integer): Double;
    procedure SetAverageValue(Index: Integer; AValue: Double);
    function  GetPenColor(Index: Integer): TColor;
    procedure SetPenColor(Index: Integer; AColor: TColor);
    function  GetPenStyle(Index:Integer):TPenStyle;
    procedure SetPenStyle(Index:Integer; aPenStyle:TPenStyle);
    function  GetPenMarkerKind(Index:Integer):TJvChartPenMarkerKind;
    procedure SetPenMarkerKind(Index:Integer; aMarkKind:TJvChartPenMarkerKind);

    procedure SetXStartOffset(Offset: Integer);

    function  GetPenSecondaryAxisFlag(index:Integer):Boolean;
    procedure SetPenSecondaryAxisFlag(index:Integer;newValue:Boolean);

    function  GetPenValueLabel(index:Integer):Boolean;
    procedure SetPenValueLabel(index:Integer;newValue:Boolean);

    procedure SetPenCount(Count: Integer);

    procedure SetChartKind(AKind: TJvChartKind);
    // TStrings<->TStringList transmogrifiers
    function GetPenLegends: TStrings;
    procedure SetPenLegends(Value: TStrings);
    function GetPenUnit: TStrings;
    procedure SetPenUnit(Value: TStrings);
    function GetXLegends: TStrings;
    procedure SetXLegends(Value: TStrings);
    procedure SetHeaderFont(AFont: TFont);
    procedure SetLegendFont(AFont: TFont);
    procedure SetAxisFont(AFont: TFont);

    procedure SetPaperColor(aColor:TColor);

    procedure SetPrimaryYAxis( AssignFrom: TJvChartYAxisOptions);
    procedure SetSecondaryYAxis(AssignFrom: TJvChartYAxisOptions);


  public
    constructor Create(Owner: TJvChart); virtual;
    destructor Destroy; override;

    // Each pen can be associated with either the primary or secondary axis,
    // this function decides which axis to return depending on the pen configuration:
    function GetPenAxis(index:integer):TJvChartYAxisOptions;

    { runtime properties }
    property AverageValue[Index: Integer]: Double read GetAverageValue write SetAverageValue;




    property XLegends: TStrings read GetXLegends write SetXLegends;     { X Axis Legends as Strings }

    { plot-canvas size, depends on size of control }
    property XEnd: Longint read FXEnd write FXEnd;
    property YEnd: Longint read FYEnd write FYEnd;
    { pixel spacing : multipliers to scale real values into X/Y pixel amounts before plotting. CRITICALLY important. }
    property XPixelGap: Double read FXPixelGap write FXPixelGap;
    property XLegendMaxTextWidth: Integer read FXLegendMaxTextWidth write FXLegendMaxTextWidth;

    { Per Pen Array/List Properties -- settable at RUNTIME only. }
    property PenColor[Index: Integer]: TColor read GetPenColor write SetPenColor;
    property PenStyle[index:integer]:TPenStyle read GetPenStyle write SetPenStyle;
    property PenMarkerKind[index:integer]: TJvChartPenMarkerKind read GetPenMarkerKind write SetPenMarkerKind;
    property PenSecondaryAxisFlag[index:Integer]:Boolean read GetPenSecondaryAxisFlag write SetPenSecondaryAxisFlag;
    property PenValueLabels[index:Integer]:Boolean read GetPenValueLabel write SetPenValueLabel;              




  published
    { design time}

    { Per Pen Array/List Properties - settable at DESIGNTIME. Others (color/style, marker) are runtime only. }
    property PenLegends: TStrings read GetPenLegends write SetPenLegends;
    property PenUnit: TStrings read GetPenUnit write SetPenUnit;


    property ChartKind: TJvChartKind read FChartKind write SetChartKind default ckChartLine;
    property Title: string                   read FTitle                   write FTitle;

    { X Axis Properties }
    property YAxisHeader: string             read FYAxisHeader             write FYAxisHeader;
    property YAxisDivisionMarkers:Boolean    read FYAxisDivisionMarkers    write FYAxisDivisionMarkers default true;    // Do you want grid-paper look?

    { X Axis Properties }
    property XAxisDivisionMarkers:Boolean    read FXAxisDivisionMarkers     write FXAxisDivisionMarkers default true;  // Do you want grid-paper look?
    property XAxisValuesPerDivision:Integer  read FXAxisValuesPerDivision   write FXAxisValuesPerDivision; // Number of Values (aka samples) in each vertical dotted lines that are divisision marker.
    property XAxisDateTimeMode   : Boolean   read FXAxisDateTimeMode        write FXAxisDateTimeMode;
    property XAxisDateTimeFormat : String    read FXAxisDateTimeFormat      write FXAxisDateTimeFormat;
    property XAxisHeader: string             read FXAxisHeader              write FXAxisHeader;
    property XAxisLegendSkipBy: Integer      read FXAxisLegendSkipBy        write FXAxisLegendSkipBy default 1;

    property DateTimeFormat:String read FDateTimeFormat write FDateTimeFormat; // Usually a long date-time label, ISO standard yyyy-mm-dd hh:nn:ss is fine, as is Windows locale defaults.

    property PenCount: Integer read FPenCount write SetPenCount default 1;
    property XGap: Double read FXGap write FXGap;
    property XOrigin: Integer read FXOrigin write FXOrigin;
    property YOrigin: Integer read FYOrigin write FYOrigin;
    property XStartOffset: Longint read FXStartOffset write SetXStartOffset default 45;
    property YStartOffset: Longint read FYStartOffset write FYStartOffset default 10;
    { Y Range }

    { plotting markers }
    property MarkerSize: Integer read FMarkerSize write FMarkerSize default JvChartDefaultMarkerSize;

    { !! New: Primary (left side) Y axis, and Secondary (right side) Y Axis !!} 
    property PrimaryYAxis: TJvChartYAxisOptions read FPrimaryYAxis write SetPrimaryYAxis;
    property SecondaryYAxis: TJvChartYAxisOptions read FSecondaryYAxis write SetSecondaryYAxis;



    //1=print every X axis label, 2=every other, and so on. default=1
    { vertical numeric decimal places }

    { more design time }

    property AutoUpdateGraph: Boolean read FAutoUpdateGraph write FAutoUpdateGraph default True;
    property MouseEdit: Boolean read FMouseEdit write FMouseEdit default True;
    property MouseInfo: Boolean read FMouseInfo write FMouseInfo default True;
    //OLD:property ShowLegend: Boolean read FShowLegend write FShowLegend default True;
    //CHANGEDTO:
    property Legend:TJvChartLegend read FLegend write FLegend default clChartLegendNone;



    property LegendRowCount: Integer read FLegendRowCount write FLegendRowCount;
    property LegendWidth: Integer read FLegendWidth write FLegendWidth default 150;
    property PenLineWidth: Integer read FPenLineWidth write FPenLineWidth default 1;
    property AxisLineWidth: Integer read FAxisLineWidth write FAxisLineWidth default 2;
    { more and more design time. these ones not sure about whether they are designtime or not.}
    property XValueCount: Integer read FXValueCount write FXValueCount default 10;

    {Font properties}
    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
    property LegendFont: TFont read FLegendFont write SetLegendFont;
    property AxisFont: TFont read FAxisFont write SetAxisFont;
    { Color properties}
    property PaperColor: TColor read FPaperColor write SetPaperColor;
    property AxisLineColor: TColor read FAxisLineColor write FAxisLineColor;
    property HintColor: TColor read FHintColor write FHintColor default JvDefaultHintColor;

    property CursorColor :TColor read FCursorColor write FCursorColor;
    property CursorStyle :TPenStyle read FCursorStyle write FCursorStyle;

  end;

  TJvChart = class(TJvGraphicControl) // formerly was a child of TImage
  private
    FUpdating :Boolean; // PREVENT ENDLES EVENT LOOPING.
    FAutoPlotDone:Boolean; // If Options.AutoUpdateGraph is set, then has paint method called PlotGraph already?
    FPlotGraphCalled :Boolean;

    FOnChartClick:TJvChartClickEvent; // mouse click event
    FMouseDownShowHint:Boolean; // True=showing hint.
    FMouseDownHintBold:Boolean;// True=first line of hint is bold.
    FMouseDownHintStrs:TStringList;
    { TImage stuff}
    FPicture: TPicture; // An image drawn via GDI primitives, saveable as
                        // bitmap or WMF, or displayable to screen
    { NEW:Data }
    FData: TJvChartData;
    FAverageData: TJvChartData;
    FBitmap: TBitmap;
    FOptions: TJvChartOptions; //^TOptions;
    //Options2          : ^TOptions2; // now FData
    PrintInSession: Boolean;
    FStartDrag: Boolean;
    FMouseLegend: Boolean;
    FContainsNegative: Boolean;
    { strColorFile: string;}// not used (ahuser)
    FOldYOrigin: Integer;
    FOldYGap: Double;
    FMouseDownX: Longint;
    FMouseDownY: Longint;
    FMouseValue: Integer;
    FMousePen: Integer;
    FYFont: TFont; // Delphi Font object wrapper.

    //NEW:
    FXOrigin: Double; {was in TJvChart.PlotGraph}
    FYOrigin: Double; {was in TJvChart.PlotGraph}
    //FYTempOrigin: Integer; {was in TJvChart.PlotGraph}
    FXAxisPosition : Integer; // how far down (in Y dimension) is the X axis?

    FOnOptionsChangeEvent : TJvChartEvent; {NEW:Component fires this event for when options change.}

    FCursorPosition :Integer; // NEW: -1 means no visible cursor, 0..n means make
                              // particular value highlighted.  The highlight is painted
                              // over top of the TImage, so that we can just restore the TImage
                              // without replotting the whole chart.

    {$IFDEF VCL}
    // Y Axis Vertical Font
    FYFontHandle: HFont; // Y AXIS VERTICAL TEXT: Vertical Font Handle (remember to DeleteObject)
    FYLogFont: TLogFont; // Y AXIS VERTICAL TEXT: Logical Font Options Record

    procedure MakeVerticalFont; // Call GDI calls to get the Y Axis Vertical Font handle
    procedure MyGraphVertFont; // vertical font handle
    {$ENDIF VCL}

    procedure PaintCursor; // called from Paint iif a Cursor is visible. does NOT modify FPicture!

    protected
    
    { Right Side Legend showing Pen Names, and/or Data Descriptors }
    procedure GraphXAxisLegend;
    procedure MyHeader(strText: string);
    procedure MyXHeader(strText: string);
    procedure MyYHeader(strText: string); // NEW
    procedure MyHeaderFont;
    procedure MyAxisFont;
    procedure MySmallGraphFont;
    function MyTextHeight(strText: string): Longint;

    { TEXTOUT stuff }
    procedure MyRightTextOut(X, Y: Integer; const Text: string); // RIGHT TEXT
    procedure MyCenterTextOut(X, Y: Integer; const Text: string); // CENTER TEXT
    procedure MyLeftTextOut(X, Y: Integer; const Text: string); // LEFT ALIGN TEXT
    { line, curve, rectangle stuff }
    procedure MyPenLineTo(X, Y: Integer);
    procedure MyAxisLineTo(X, Y: Integer);
    procedure MyRectangle(X, Y, X2, Y2: Integer);
    procedure MyColorRectangle(Pen: Integer; X, Y, X2, Y2: Integer);
    procedure MyPie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Longint); { pie chart segment }
//    procedure   MyArc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);  { arc } // not used (ahuser)
    procedure MyPolygon(Points: array of TPoint);
//    procedure   MyEllipse(X1, Y1, X2, Y2: Integer); // not used (ahuser)
    procedure   MyDrawLine(X1, Y1, X2, Y2: Integer); // not used (ahuser)
    procedure MyDrawAxisMark(X1, Y1, X2, Y2: Integer); // solid line as a tick on an axis.
    procedure MyDrawDotLine(X1, Y1, X2, Y2: Integer);
    procedure EditXHeader;
    procedure EditYScale;
    procedure EditHeader;
    procedure SetSolidLines;
    procedure SetDotLines;
    procedure SetLineColor(Pen: Integer);
    procedure SetRectangleColor(Pen: Integer);
    procedure SetFontColor(Pen: Integer);
    procedure CountGraphAverage;
    procedure DrawPenColorBox(nColor, W, H, X, Y: Integer);
    { function GetDefaultColorString(nIndex: Integer): string;} // (rom) not used
    procedure MyPiePercentage(X1, Y1, W: Longint; nPercentage: Double);
    procedure GraphPieChart(nPen: Integer);
    procedure GraphDeltaAverage;
    procedure MyPieLegend(nPen: Integer);
    procedure ShowMouseMessage(X, Y:Integer);

    // marker symbols:
    procedure PlotCross(x, y: Integer);
    procedure PlotDiamond(x, y: Integer);
    procedure PlotCircle(x, y: Integer);
    procedure PlotSquare(x, y: Integer);

    function MyPt(AX, AY: Integer): TPoint;
    procedure ClearScreen;

    // internal graphics methods
    procedure GraphSetup; // These set up variables used for all the rest of the plotting functions
    procedure GraphXAxis;
    procedure GraphYAxis;
    procedure GraphYAxisDivisionMarkers;
    procedure GraphXAxisDivisionMarkers; // new.

    procedure CalcYEnd; // Determine where the below-the bottom axis area starts

    function GetCanvas: TCanvas; // Picture.Bitmap has canvas.
    function DestRect: TRect; // from TImage


    procedure DesignModePaint; // Invoked by Paint method when we're in design mode.

    procedure Paint; override; // from TImage
    procedure Resize; override; // from TControl
    procedure Loaded; override;
    { draw dummy data for design mode}

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    property ChartCanvas: TCanvas read GetCanvas;

    procedure PrimaryYAxisLabels;  // Put contents into Options.PrimaryYAxis.YLegends

    procedure NotifyOptionsChange; {NEW}

    { internal drawing properties, valid during Paint method invocations only }
    property     XOrigin: Double      read FXOrigin; {was in TJvChart.PlotGraph}
    property     YOrigin: Double      read FYOrigin; {was in TJvChart.PlotGraph}
    //property     YOldOrigin: Integer  read FYOldOrigin; {was in TJvChart.PlotGraph}
    //property     YTempOrigin: Integer read FYTempOrigin; {was in TJvChart.PlotGraph}


  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {General procedures for the graph...}
    procedure ResetGraphModule; {Call this before totally new values and Pen}
    procedure AutoFormatGraph; {Call this after new values}
    procedure PlotGraph; {Update screen / draw graph to screen}
    procedure PrintGraph; {Send picture to printer; all printing done by component}
    procedure AddGraphToOpenPrintCanvas(XStartPos, YStartPos, GraphWidth, GraphHeight: Longint);
                                    {adds the graph to the "OPEN" printer canvas}
                                    {printing control=outside this component; add other text etc}
    procedure GraphToClipboard; {Puts picture on clipboard}
    procedure ResizeChartCanvas; {Call this after screen resize and after start up}
    procedure PivotData; { Pivot Table. Switches the x values with Pen! Resets AverageLine}
    {Changes the color of the graph...}
    property Data: TJvChartData read FData;
    property AverageData: TJvChartData read FAverageData;

    procedure AutoHint; // Make the automatic hint message showing all pens and their values.

    procedure SetCursorPosition(pos:Integer);

  public {runtime only helper properties}
    { TImage-like stuff }
    property Picture: TPicture read FPicture; // write SetPicture;




    // NEW: Ability to highlight a particular sample by setting the Cursor position!
    property CursorPosition:Integer read FCursorPosition write SetCursorPosition;
//    procedure DataTests; // TESTING. WAP.
  published
    { Standard TControl Stuff}
    //property Color default clWindow;
    property Font;
    property Align;
    property Anchors;
    property Constraints;
    {$IFDEF VCL}
    property AutoSize;
    property DragCursor;
    property DragKind;
    {$ENDIF VCL}
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    { chart options}
    property Options: TJvChartOptions read FOptions write FOptions;
    { chart events}
    property OnChartClick:TJvChartClickEvent read FOnChartClick write FOnChartClick;
    
  end;

implementation

uses
  Math, // VCL math: function isNan, constant NaN.
  {$IFDEF COMPILER5}
  JclMath, // function isNan for Delphi 5  (ahuser)
  {$ENDIF COMPILER5}
  JvJVCLUtils,
  JvConsts,
  JvResources;

const
  CHART_SANITY_LIMIT = 30000;
        // Any attempt to have more than CHART_SANITY_LIMIT elements in this
        // graph will be treated as an internal failure on our part.  This prevents
        // ugly situations where we thrash because of excessive memory usage.
        // Better to set this than to have the system pig out when we
        // don't want it to. Set this very small when debugging,
        // large when releasing component, and don't remove it unless
        // you're absolutely sure. Increase it whenever necessary.
        // Remember, it's a debugging tool, here on purpose to help keep you
        // out of thrashing-virtual-memory-hell.   You probably have a screen
        // to view the chart that is a maximum of 1600x1200, so more than 1600
        // samples will mean the data should be reduced before charting.

  MAX_VALUES = 20000; // Any attempt to exceed this values count will cause array size and performance problems, thus we limit it.
  MAX_PEN = 100;  // Any attempt to exceed this pen count will cause array size and performance problems, thus we hardcode the pen limit to 100 pens.
  DEFAULT_PEN_COUNT = 16; // By Default TJvChartData's internal data structures have room for up to 16 pens
  MAX_X_LEGENDS = 50;
  MAX_GRAPH_LEGEND_LEN = 9;
  REALPREC = 7;
  DEFAULT_MARKER_SIZE = 3;
  DEFAULT_VALUE_COUNT  = 100; // By Default TJvChartData holds 100 values per pen. Grows autofragellisticexpialidociously. :-)

//=== TJvChartData ===========================================================

constructor TJvChartData.Create;
var
 t:Integer;
begin
  inherited Create;
  for t := 0 to DEFAULT_PEN_COUNT do begin
    Grow( t, DEFAULT_VALUE_COUNT );
  end;

end;

destructor TJvChartData.Destroy;
var
  I: Integer;
begin
  for I := 0 to FDataAlloc - 1 do
    Finalize(FData[I]);
  Finalize(FData); // Free array.
  inherited Destroy;
end;

function TJvChartData.GetValue(Pen, ValueIndex: Integer): Double;
begin
  // Grow base array
  Grow(Pen, ValueIndex);
  Result := FData[ValueIndex, Pen]; // This will raise EInvalidOP for NaN values.
end;

procedure TJvChartData.SetValue(Pen, ValueIndex: Integer; NewValue: Double);
begin
  // Grow base array
  Grow(Pen, ValueIndex);
  FData[ValueIndex, Pen] := NewValue;
  if ValueIndex >= FValueCount then
  begin
    Grow(Pen, ValueIndex + 1);
    FData[ValueIndex + 1, Pen] := NewValue; // Workaround for a graphical bug. Sorry.
    FValueCount := ValueIndex + 1;
  end;
end;


function TJvChartData.GetTimestamp(  ValueIndex:Integer):TDatetime;
begin
  if (ValueIndex<0) or (ValueIndex>=Length(FTimestamp)) then
      result := 0.0 // null datetime
  else
      result := FTimestamp[ValueIndex];
end;

procedure TJvChartData.SetTimestamp( ValueIndex:Integer; aValue:TDatetime);
begin
  if (ValueIndex<0) then exit;
  if (ValueIndex>=Length(FTimestamp)) then
    SetLength(FTimestamp,ValueIndex+1);

  FTimestamp[ValueIndex] := aValue;
end;

procedure TJvChartData.Scroll;
var
  I,J:Integer;
begin
  if FValueCount<2 then begin
     Clear;
     exit;
  end;
{ ULTRA SLOW BUT NON-CRASHING Version }
 for I := 0 to FValueCount-1 do begin
      for J := 0 to Length( FData[i] ) -1 do begin
          FData[I,J] := FData[I+1,J];
      end;
      SetTimestamp(I, GetTimestamp(I+1));
 end;




  FTimeStamp[FValueCount-1] := 0;
 // Check we didn't break the heap:
end;

procedure TJvChartData.Grow(Pen, ValueIndex: Integer);
begin
  if (Pen < 0) or (ValueIndex < 0) then
    raise ERangeError.Create(RsEDataIndexCannotBeNegative);
  if (Pen > CHART_SANITY_LIMIT) or (ValueIndex > CHART_SANITY_LIMIT) then
    raise ERangeError.Create(RsEDataIndexTooLargeProbablyAnInternal);

  if ValueIndex >= FDataAlloc then
  begin
    FDataAlloc := ValueIndex+1;
    SetLength(FData, FDataAlloc);
  end;

  if Pen >= Length(FData[ValueIndex]) then
    SetLength(FData[ValueIndex], Pen +1);
end;


function TJvChartData.DebugStr( ValueIndex:Integer ):String; // dump all pens for particular valueindex, as string.
var
 s:String;
 i,imax:integer;
begin
 if (ValueIndex<0) or (ValueIndex >= FDataAlloc) then exit;
 imax := Length(FData[ValueIndex])-1;

    if Timestamp[ValueIndex]>0.0 then
         s := FormatDateTime( 'hh:nn:ss ', Timestamp[ValueIndex] );
 for i := 0 to imax do begin

     if IsNan(FData[ValueIndex,i]) then
       s := s + '-'
     else
       s := s + Format( '%5.2f', [ FData[ValueIndex,i] ] );
       
     if i < imax then
        s := s + ', '
 end;
 result := s;
end;

procedure TJvChartData.Clear; // Resets FValuesCount/FPenCount to zero. Zeroes everything too, just for good luck.
var
  I, J: Integer;
begin
  for I := 0 to FDataAlloc - 1 do
    for J := 0 to Length(FData[I]) - 1 do
      FData[I, J] := 0.0;
  FValueCount := 0;
end;




//============ TJvChartYAxisOptions =========================

constructor TJvChartYAxisOptions.Create(owner:TJvChartOptions); //virtual;
begin
    inherited Create;
    FOwner := owner;
    FYLegends := TStringList.Create;
    FMaxYDivisions := 20;
    FMinYDivisions := 5;
    FYDivisions    := 10;
    FDefaultYLegends := JvDefaultYLegends;
end;

destructor TJvChartYAxisOptions.Destroy;
begin
    FYLegends.Free;
    inherited Destroy;
end;

procedure TJvChartYAxisOptions.Clear;
begin
  YDivisions := DefaultYLegends;
  YLegends.Clear;
   Normalize;


end;


procedure TJvChartYAxisOptions.Normalize;
var
// CheckYDivisions:Integer;
 vc:Integer;
begin
  if (FYMax-FYMin)<0.00001 then // make sure that there is some difference here!
    FYMax := FYMin+10;

  if ( DefaultYLegends>0 ) and (YDivisions=0) then
    YDivisions := DefaultYLegends;

    // DON'T KNOW WHY WE NEEDED THIS. REMOVED IT.
    (*
  if (YGap>0.0) then begin
    CheckYDivisions := Round((YMax + (YGap - 1)) / YGap);
    if CheckYDivisions<>YDivisions then
        YDivisions :=CheckYDivisions;
  end;*)

  vc := YDivisions;
  if vc<1 then
      vc := 1;
   FYGap  := (   ( YMax - YMin )     / vc);
   FYGap1 := ( ( ( YMax - YMin )+1)  / vc );

   YPixelGap := ((FOwner.YEnd-1) / vc ); // Vertical Pixels Per Value Division counter.



  (*CheckYDivisions := Round((YMax + (YGap - 1)) / YGap);
  if CheckYDivisions<>YDivisions then
      YDivisions :=CheckYDivisions;  *)

   //---------------------------------------------------------------------
   // Here's the normalization section:
   // !!!The 10 and 20 here should be properties settable by the user!!!
   //---------------------------------------------------------------------
  if YDivisions < MinYDivisions then
  begin
    YDivisions := MinYDivisions;
    FYGap := YMax / YDivisions;
  end
  else
  begin
    if YDivisions > MaxYDivisions then begin
      YDivisions := MaxYDivisions;
      FYGap := YMax / YDivisions;
    end;
  end;
  


end;

procedure TJvChartYAxisOptions.SetYMax(newYmax: Double);
//var
//  wasUpdating:Boolean;
begin
  FYMax := newYMax;

  if not Assigned(FOwner) then exit;
  if not Assigned(FOwner.FOwner) then exit;
  if (csLoading in FOwner.FOwner.COmponentState ) then exit;

  // Rework other values around new YMax:
  Normalize;
  FOwner.NotifyOptionsChange;


end;

(*procedure TJvChartYAxisOptions.SetYGap(newYgap: Double);
begin
  if (FYGap < 5.0) and (YMax>100) then begin
    OutputDebugString('Bug');
  end;

  FYGap := newYGap;
  // TODO: Fire event, and cause a refresh, recalculate other
  // dependant fields that are calculated from the YGap.
  FOwner.NotifyOptionsChange; // Fire event before we auto-format graph. Allows some customization to occur here.
end;
  *)

function TJvChartYAxisOptions.GetYLegends: TStrings;
begin
  Result := FYLegends as TStrings;
end;

procedure TJvChartYAxisOptions.SetYLegends(Value: TStrings);
begin
  FYLegends.Assign(Value);
  if Assigned(FOwner) then 
    FOwner.NotifyOptionsChange; // Fire event before we auto-format graph. Allows some customization to occur here.

end;

procedure TJvChartYAxisOptions.SetYDivisions(aValue:Integer);
begin
  FYDivisions := aValue;

  if not Assigned(FOwner) then exit;
  if not Assigned(FOwner.FOwner) then exit;
  if (csLoading in FOwner.FOwner.COmponentState ) then exit;

  // Rework other values around new YMax:
  Normalize;
  FOwner.NotifyOptionsChange;
    
end;


//=== TJvChartOptions ========================================================


procedure TJvChartOptions.NotifyOptionsChange;
begin
  if Assigned(FOwner) then
    FOwner.NotifyOptionsChange;
end;

    // Each pen can be associated with either the primary or secondary axis,
    // this function decides which axis to return depending on the pen configuration:
function TJvChartOptions.GetPenAxis(index:integer):TJvChartYAxisOptions;
begin

  if (index<0) or (index >= Length(FPenSecondaryAxisFlag)) then
      result := FPrimaryYAxis // default
  else if FPenSecondaryAxisFlag[index] then
      result := FSecondaryYAxis // alternate!
  else
      result := FPrimaryYAxis; // default
end;


constructor TJvChartOptions.Create(Owner: TJvChart);
begin
  inherited Create;
  FOwner := Owner;

  FAutoUpdateGraph  := true;
  
  FPrimaryYAxis := TJvChartYAxisOptions.Create(Self);
  FSecondaryYAxis := TJvChartYAxisOptions.Create(Self);


  FXAxisDivisionMarkers := true; //default property.
  FYAxisDivisionMarkers := true; //default property.


  SetLength(FPenColors, 12);
  FPenColors[0] := clLime;
  FPenColors[1] := clRed;
  FPenColors[2] := clBlue;
  FPenColors[3] := clYellow;
  FPenColors[4] := clMaroon;
  FPenColors[5] := clGreen;
  FPenColors[6] := clOlive;
  FPenColors[7] := clNavy;
  FPenColors[8] := clPurple;
  FPenColors[9] := clTeal;
  FPenColors[10] := clFuchsia;
  FPenColors[11] := clAqua;

  FChartKind := ckChartLine;

  FPenCount := 1;

  FLegend := clChartLegendNone; //default Legend is None.

 // Create TStringList property objects
  FXLegends := TStringList.Create;
  FPenLegends := TStringList.Create;
  FPenUnit := TStringList.Create;
 // dynamic array setup
  SetLength(FAverageValue, DEFAULT_VALUE_COUNT );

 // Defaults for Graph Options:

  FMarkerSize := JvChartDefaultMarkerSize;
  FXStartOffset := 45; {DEFAULT}
  FYStartOffset := 10;
  FTitle := '';
//   FXAxisHeader := 'X';
//   FYAxisHeader := 'Y';

  FPaperColor := clWhite;
  FAxisLineColor := clBlack;

  FHeaderFont := TFont.Create;
  FLegendFont := TFont.Create;
  FAxisFont := TFont.Create;

  //FShowLegend := True;
  FMouseEdit := True;
  FMouseInfo := True;
  FLegendWidth := 150;
  FPenLineWidth := 1;
  FAxisLineWidth := 3;

  FXValueCount := 10;

  FXAxisLegendSkipBy := 1;

  FHintColor := JvDefaultHintColor;
end;

destructor TJvChartOptions.Destroy;
begin
  FreeAndNil(FXLegends);
  FreeAndNil(FPenLegends);
  FreeAndNil(FPenUnit);

  FreeAndNil(FHeaderFont);
  FreeAndNil(FLegendFont);
  FreeAndNil(FAxisFont);

  inherited Destroy;
end;

procedure TJvChartOptions.SetChartKind(AKind: TJvChartKind);
begin
  if AKind = FChartKind then
    exit;
  FChartKind := AKind;
end;



function TJvChartOptions.GetPenMarkerKind(Index:Integer):TJvChartPenMarkerKind;
begin
  result := pmkNone;
  if (Index < 0) or ( Index >= Length(FPenMarkerKind) ) then
      exit;
  result := FPenMarkerKind[Index];
end;

procedure TJvChartOptions.SetPenMarkerKind(Index:Integer;aMarkKind:TJvChartPenMarkerKind);
begin
  if (Index<0) then exit;
  if Index >= Length(FPenMarkerKind) then
    SetLength(FPenMarkerKind, Index + 1);
  FPenMarkerKind[Index] := aMarkKind;
end;


function TJvChartOptions.GetPenColor(Index: Integer): TColor;
begin
// Don't check for out of range values, since we use that on purpose in this
// function. Okay, ugly, but it works. -WP.

  if Index < jvChartDivisionLineColorIndex then
    Result := clBtnFace
  else
  if Index = jvChartDivisionLineColorIndex then // horizontal and vertical division line color
    Result := clLtGray // TODO Make this a property.
  else
  if Index = jvChartShadowColorIndex then // legend shadow (light gray)
    Result := clLtGray  // TODO Make this a property.
  else
  if Index = jvChartAxisColorIndex then
    Result := FAxisLineColor // TODO Make this a property.
  else
  if Index = jvChartHintColorIndex then
    Result := FHintColor // TODO Make this a property.
  else
  if Index = jvChartPaperColorIndex then
    Result := FPaperColor // TODO Make this a property.
  else
  if Index >= 0 then
    Result := FPenColors[Index]
  else
    Result := clNone; // I hope clNone is a good unknown value (ahuser). {{Good enough. -WP.}}
end;

procedure TJvChartOptions.SetPenColor(Index: Integer; AColor: TColor);
begin
  if (Index < 0) or (Index >= MAX_PEN) then
    raise ERangeError.Create(RsEChartOptionsPenCountPenCountOutOf);

  if Index >= Length(FPenColors) then
    SetLength(FPenColors, Index + 1);
  FPenColors[Index] := AColor;
end;



procedure TJvChartOptions.SetPenStyle(Index:Integer; aPenStyle:TPenStyle);
begin
  if (Index < 0) or (Index >= MAX_PEN) then
    raise ERangeError.Create(RsEChartOptionsPenCountPenCountOutOf);

  if Index >= Length(FPenStyles) then
    SetLength(FPenStyles,Index+1);
  FPenStyles[index] := aPenStyle;
end;

function TJvChartOptions.GetPenStyle(Index:Integer):TPenStyle;
begin
  result := psSolid;
  if (index<0) or (Index>=Length(FPenStyles)) then exit;
  result := FPenStyles[index];
end;

function TJvChartOptions.GetAverageValue(Index: Integer): Double;
begin
  if Index < 0 then
    raise ERangeError.Create(RsEGetAverageValueIndexNegative);
  if Index >= Length(FAverageValue) then
    Result := 0.0
  else
    Result := FAverageValue[Index];
end;

procedure TJvChartOptions.SetAverageValue(Index: Integer; AValue: Double);
begin
  if Index < 0 then
    raise ERangeError.Create(RsESetAverageValueIndexNegative);
  if Index >= Length(FAverageValue) then
    SetLength(FAverageValue, Index + 1);
  FAverageValue[Index] := AValue;
end;


function  TJvChartOptions.GetPenSecondaryAxisFlag(index:Integer):Boolean;
begin
  if (Index < 0) or (Index >= Length(FPenSecondaryAxisFlag)) then
    result := false
  else
    result := FPenSecondaryAxisFlag[index];
end;

procedure TJvChartOptions.SetPenSecondaryAxisFlag(index:Integer;newValue:Boolean);
begin
  if (index < 0) or (index>= MAX_PEN) then
    raise ERangeError.Create(RsEChartOptionsPenCountPenCountOutOf);

  if ( index >= Length(FPenSecondaryAxisFlag) ) then
      SetLength(FPenSecondaryAxisFlag,index+1); // grow!

  FPenSecondaryAxisFlag[index] := newValue;
end;



function  TJvChartOptions.GetPenValueLabel(index:Integer):Boolean;
begin
  if (index < 0) or (index>= Length(FPenValueLabels)) then
    result := false
  else
    result := FPenValueLabels[index];
end;


procedure TJvChartOptions.SetPenValueLabel(index:Integer;newValue:Boolean);
begin
  if (index < 0) or (index>= MAX_PEN) then
    raise ERangeError.Create(RsEChartOptionsPenCountPenCountOutOf);

  if ( index >= Length(FPenValueLabels) ) then
    SetLength(FPenValueLabels,index+1); // grow!

  FPenValueLabels[index] := newValue;
end;



procedure TJvChartOptions.SetPenCount(Count: Integer);
begin
  if (Count < 0) or (Count >= MAX_PEN) then
    raise ERangeError.Create(RsEChartOptionsPenCountPenCountOutOf);
  FPenCount := Count;
SetLength(FPenSecondaryAxisFlag,FPenCount+1);  
end;

function TJvChartOptions.GetPenLegends: TStrings;
begin
  Result := FPenLegends as TStrings;
end;

procedure TJvChartOptions.SetPenLegends(Value: TStrings);
begin
  FPenLegends.Assign(Value);
end;

function TJvChartOptions.GetPenUnit: TStrings;
begin
  Result := FPenUnit as TStrings;
end;

procedure TJvChartOptions.SetPenUnit(Value: TStrings);
begin
  FPenUnit.Assign(Value);
end;

function TJvChartOptions.GetXLegends: TStrings;
begin
  Result := FXLegends as TStrings;
end;

procedure TJvChartOptions.SetXLegends(Value: TStrings);
begin
  FXLegends.Assign(Value);
end;

procedure TJvChartOptions.SetHeaderFont(AFont: TFont);
begin
  FHeaderFont.Assign(AFont);
end;

procedure TJvChartOptions.SetLegendFont(AFont: TFont);
begin
  FLegendFont.Assign(AFont);
end;

procedure TJvChartOptions.SetAxisFont(AFont: TFont);
begin
  FAxisFont.Assign(AFont);
end;


procedure TJvChartOptions.SetPrimaryYAxis( AssignFrom: TJvChartYAxisOptions);
begin
   FPrimaryYAxis.Assign( AssignFrom );
end;
procedure TJvChartOptions.SetSecondaryYAxis(AssignFrom: TJvChartYAxisOptions);
begin
   FSecondaryYAxis.Assign( AssignFrom );
end;


procedure TJvChartOptions.SetPaperColor(aColor:TColor);
begin
   if aColor <> FPaperColor then begin
      FPaperColor := aColor;
      if Assigned(FOwner) then
          FOwner.Invalidate;
   end;
end;


procedure TJvChartOptions.SetXStartOffset(Offset: Integer);
begin
//if (not PrintInSession) then
//  if (Offset < 10) or (Offset > (FOwner.Width div 2)) then
  //  raise ERangeError.Create(RsEChartOptionsXStartOffsetValueOutO);
  FXStartOffset := Offset;
end;


{ GRAPH }
{**************************************************************************}
{ call this function : NEVER!                                              }
{**************************************************************************}

constructor TJvChart.Create(AOwner: TComponent);
{var
   I                      : Integer;
   nXScreenResolution     : Longint;}// not used (ahuser)
begin
  inherited Create(AOwner); {by TImage...}
//   Color := clWindow;
  FPicture := TPicture.Create;

  FCursorPosition := -1; // Invisible until CursorPosition is set >=0 to make it visible. 

  FMouseDownHintStrs := TStringList.Create;


   { logical font used for rotating text to show vertical labels }

       { NEW:Data }
  FData := TJvChartData.Create;
  FAverageData := TJvChartData.Create;

   //New(Options);
  FOptions := TJvChartOptions.Create(Self);
  CalcYEnd;

//   New(Options2);

  PrintInSession := False;

  FOldYGap := 1;
  FOldYOrigin := 0;
  FStartDrag := False;
  FMouseLegend := False;
  FContainsNegative := False;
  FMouseValue := 0;
  FMousePen := 0;

   //Width  :=  200; {VCL component initial size, IMPORTANT keep small default!}
   //Height :=  200; {VCL component initial size, IMPORTANT keep small default!}
   {Set default values for component fields...}

  if csDesigning in ComponentState then begin
    // default height and width
    if not Assigned(Parent) then begin
      Width := 300;
      Height := 300;
    end;

  end;

end;

{**************************************************************************}
{ call this function : NEVER!                                              }
{**************************************************************************}

destructor TJvChart.Destroy;
begin
   {Add code for destroying my own data...here}

  FBitmap.Free;
  {$IFDEF VCL}
  if Ord(FYFontHandle) <> 0 then
    DeleteObject(FYFontHandle); // vertical font object
  {$ENDIF VCL}
  FreeAndNil(FYFont);

  FreeAndNil(FPicture);
  FreeAndNil(FAverageData);
  FreeAndNil(FOptions);
  FreeAndNil(FData);

  FreeAndNil(FMouseDownHintStrs); //new.

  inherited Destroy;
end;

{Paint helper}

function TJvChart.DestRect: TRect;
var
  w, h {, cw, ch}: Integer; // not used (ahuser)
//  xyaspect: Double; // not used (ahuser)
begin
  w := Picture.Width;
  h := Picture.Height;
(*  cw := ClientWidth;
  ch := ClientHeight;
  if Stretch or (Proportional and ((w > cw) or (h > ch))) then
  begin
 if Proportional and (w > 0) and (h > 0) then
 begin
      xyaspect := w / h;
      if w > h then
      begin
        w := cw;
        h := Trunc(cw / xyaspect);
        if h > ch then  // woops, too big
        begin
          h := ch;
          w := Trunc(ch * xyaspect);
        end;
      end
      else
      begin
        h := ch;
        w := Trunc(ch * xyaspect);
        if w > cw then  // woops, too big
        begin
          w := cw;
          h := Trunc(cw / xyaspect);
        end;
      end;
    end
    else
    begin
      w := cw;
      h := ch;
    end;
  end;
    *)
  with Result do
  begin
    Left := 0;
    Top := 0;
    Right := w;
    Bottom := h;
  end;

(*  if Center then
 OffsetRect(Result, (cw - w) div 2, (ch - h) div 2); *)
end;

procedure TJvChart.Loaded;
begin
  inherited Loaded;
  ResizeChartCanvas;
end;

procedure TJvChart.Resize;
begin
  inherited Resize;
  ResizeChartCanvas;
//  Invalidate already happens in ResizeChartCanvas.
end;

{ PAINT }

procedure TJvChart.DesignModePaint;
var
  DesignStr: string;
  tw,th:Integer;
begin
    ChartCanvas.Brush.Color := Options.PaperColor;
    ChartCanvas.Rectangle(0, 0, Width, Height);

    DesignStr := ClassName + JvChartDesigntimeLabel;

    if (Abs(Options.PrimaryYAxis.YMax)<0.000001) and (Abs(Options.PrimaryYAxis.YMin)<0.000001) then begin
        Options.PrimaryYAxis.YMax := 10.0; // Reasonable non-zero default, so that charting works!
    end;

    Options.PrimaryYAxis.Normalize;
    Options.SecondaryYAxis.Normalize;
    GraphSetup;
    PrimaryYAxisLabels;
    GraphXAxis;
    GraphXAxisDivisionMarkers;
    GraphYAxis;
    GraphYAxisDivisionMarkers;

    { designtime component label }
    tw := Canvas.TextWidth(DesignStr);
    th := Canvas.TextHeight(DesignStr);

    ChartCanvas.Brush.Color := Options.PaperColor;
    ChartCanvas.Pen.Color := Color;
    
      //Canvas.Pen.Style := psDot;
      //Canvas.Rectangle( (width div 2) - (tw div 2), (height div 2) - (th div 2), tw, th);
      if (tw<Width) and (th<Height) then
        Canvas.TextOut( (width div 2) - (tw div 2), (height div 2) - (th div 2),DesignStr);

end;

procedure TJvChart.Paint; { based on TImage.Paint }
begin
  if (csDesigning in ComponentState) then// or (Options.ChartKind = ckChartNone) then // Blank.
  begin
    DesignModePaint;
  end
  else begin
    if Options.AutoUpdateGraph and (not FAutoPlotDone) then begin
        FAutoPlotDone:= true;
        PlotGraph; // Makes sure something is visible in the TPicture.
    end;

    with inherited Canvas do
      StretchDraw(DestRect, Picture.Graphic);

      if (FCursorPosition >= 0 ) and (FCursorPosition <= Options.XValueCount) then begin
            PaintCursor;
      end;
  end;
end;

// Draw an oscilliscope-like cursor over the place where the current sample is in the chart.
// This is very handy when you want to associate your table, grid, or other data source,
// with the chart, and highlight one row in the chart.
procedure TJvChart.PaintCursor;
var
 Y1,Y2,X1,X2 : Integer;
 XPixelGap   : Double;
begin
  with inherited Canvas do begin 
            Pen.Color := Options.CursorColor;
            Pen.Style := Options.CursorStyle;

            Y1 := Options.YStartOffset;
            XPixelGap := ( ((Options.XEnd-2) - Options.XStartOffset ) /
                           (Options.XValueCount-1) );

            X1 := Round(Options.XStartOffset + (XPixelGap * FCursorPosition) );

            MoveTo( {x} X1, {y} Y1);
            LineTo( {x} X1, {y} FXAxisPosition-1);
  end;
end;

{device independent functions... no checking for printer / screen needed}

{**************************************************************************}
{ call this function :                                                     }
{  a) before setting totally new values to the graph                       }
{  b) note that any custom strings in the PrimaryYAxis.Legends or          }
{     SecondaryYAxis.Legends are CLEARED by this function.                 }
{**************************************************************************}

procedure TJvChart.ResetGraphModule;
{var
   I,J      : Integer;}// not used (ahuser)
begin
  Data.Clear;

  FPlotGraphCalled := false;
  FContainsNegative := False;
  Options.Title := '';
  Options.PenCount := 1;
  Options.XValueCount := 0;

  Options.PrimaryYAxis.Clear;
  Options.SecondaryYAxis.Clear;

  Options.XOrigin := 0;
  Options.YOrigin := 0;
  Options.XGap := 1;

  Options.PenLegends.Clear;

(*   for I := 0 to MAX_VALUES-1 do
   begin
      Options.AverageValue[I] := 0;
   end; *)

  Data.Clear;
  AverageData.Clear;

  Options.XLegends.Clear;

end;

procedure TJvChart.PrimaryYAxisLabels;
var
  I         : Integer;
  YDivision : Double;
  YDivisionStr: string; // left hand side, vertically ascending labels for scale of Y values.
begin

  Options.PrimaryYAxis.YLegends.Clear;
  for I := 0 to Options.PrimaryYAxis.YDivisions do // NOTE! Don't make this YDivisions-1 That'd be bad! !!!!
  begin
    YDivision := (I * Options.PrimaryYAxis.YGap);
    if Options.PrimaryYAxis.YLegendDecimalPlaces <= 0 then
      YDivisionStr := IntToStr(Round(YDivision)) // This was giving MANY decimal places.
    else
    if Options.PrimaryYAxis.YLegendDecimalPlaces = 1 then
      YDivisionStr := FormatFloat('0.0',  YDivision )
    else
      YDivisionStr := FormatFloat('0.00', YDivision );

    Options.PrimaryYAxis.YLegends.Add( YDivisionStr );
    OutputDebugSTring(PChar('YDivisionStr='+YDivisionStr));
  end;

end;
{ Setup display graph ranges }

procedure TJvChart.AutoFormatGraph;
var
  V, nYMax, nYMin: Double;
  nPen: Longint;
  I, J: Integer;
//   calcYGap  :Double; // not used (ahuser)
  aTextWidth, skipby, maxfit: Integer;
begin

//   nMaxXValue       := 0;
  nPen := 0;
  Options.PrimaryYAxis.Normalize;
  Options.SecondaryYAxis.Normalize;

   {Set graph type according to component property}

  if Options.PrimaryYAxis.YMax <= Options.PrimaryYAxis.YMin then
  begin
       {Analyse graph for max and min values...}
    nYMax := -99999999;
    nYMin := 99999999;
    for I := 0 to Data.ValueCount - 1 do
    begin
      for J := 0 to Options.PenCount - 1 do
      begin
        if Options.GetPenAxis(J) <> Options.PrimaryYAxis then
            continue;  // XXX !!! AUTO SCALING ONLY ON PRIMARY AXIS, FOR NOW. !!!

        V := FData.Value[J, I];

        if IsNan(V) then begin
             OutputDebugString('gap');
             continue;
        end;
        if nYMin > V then
          nYMin := V;
             //if (I>nMaxXValue) and (FData.Value[J,I]<>0) then
                //nMaxXValue := I;
             //if (J>nPen) and (FData.Value[J,I]<>0) then
             //   nPen := J;
        if nYMax < FData.Value[J, I] then
          nYMax := FData.Value[J, I];
      end;
      if (nYMin > 0) and (Options.PrimaryYAxis.YMin = 0) then
        nYMin := 0;
    end;
       // Round up YMax so it's got some zeros after it:
    if nYMax > 5000 then
      nYMax := Trunc(Trunc(nYMax + 499) / 500) * 500
    else
    if nYMax > 1000 then
      nYMax := Trunc(Trunc(nYMax + 99) / 100) * 100
    else
    if nYMax > 10 then
      nYMax := Trunc(Trunc(nYMax + 9) / 10) * 10;

      // And now the really bad hack:
    Options.PrimaryYAxis.SetYMax(0);
    Options.PrimaryYAxis.SetYMax(nYMax);
  end
  else
  begin
    nYMax := Options.PrimaryYAxis.YMax;
    nYMin := Options.PrimaryYAxis.YMin;
  end;

   // And some negative handling crap.
  FContainsNegative := False;
  if nYMin < 0 then
  begin
    FContainsNegative := True;
    
//    if Options.PrimaryYAxis.DefaultYLegends>0 then
//      Options.PrimaryYAxis.Normalize
//    else
//      Options.PrimaryYAxis.YGap := 1;

//    if Options.PrimaryYAxis.YGap <= 0 then {*  XXX WORKAROUND A BUG. Better to have bad looking data than divide by zero exceptions. XXX *}
//      Options.PrimaryYAxis.YGap := 0.00001;
      
    Options.ChartKind := ckChartLine;
    Options.YOrigin := Round(-nYMin / Options.PrimaryYAxis.YGap);
  end;

(*  if Options.PrimaryYAxis.YGap = 0 then
  begin
    Options.PrimaryYAxis.YGap := 1;
    Options.PrimaryYAxis.YDivisions := Round(nYMax * nPen);
  end;*)

  if Options.PrimaryYAxis.YDivisions = 0 then
    Options.PrimaryYAxis.YDivisions := 1;

   //Options.PenCount    := nPen;
  if Options.XValueCount < Data.ValueCount then
    Options.XValueCount := Data.ValueCount;

//XXX  if Options.PrimaryYAxis.YDivisions < 3 then
//    Options.PrimaryYAxis.YDivisions := 3; // some labels


  // Primary Y Axis Labels. This version only supports 0,1,2 decimal places.
  PrimaryYAxisLabels;


  // XXX TODO: Draw secondary Y Axis labels, if enabled!


     // if we put too many labels on the bottom x axis, they crowd or overlap,
   // so this prevents that:

  for i := 0 to Options.XLegends.Count - 1 do
  begin
    aTextWidth := ChartCanvas.TextWidth(Options.XLegends[i]) + 10;

    if aTextWidth > Options.XLegendMaxTextWidth then
      Options.XLegendMaxTextWidth := aTextWidth;
  end;
  if Options.XLegendMaxTextWidth < 20 then
    Options.XLegendMaxTextWidth := 20;

  maxfit := ((Width - (Options.XStartOffset * 2)) div
    (Options.XLegendMaxTextWidth + (Options.XLegendMaxTextWidth div 4)));
  if maxfit < 1 then
    maxfit := 1;

  skipby := Data.ValueCount div maxfit;
  if skipby < 1 then
    skipby := 1;
  //if skipby > Options.XAxisLegendSkipBy then
  Options.XAxisLegendSkipBy := skipby;

      // Now do the graphing.
  CountGraphAverage;

  PlotGraph;
end;

procedure TJvChart.CountGraphAverage;
var
  I, J: Integer;
begin
  if Options.ChartKind = ckChartLine then
    Exit; // no average needed.

  for I := 0 to Data.ValueCount - 1 do
  begin
    Options.AverageValue[I] := 0;
    for J := 0 to MAX_PEN - 1 do
      Options.AverageValue[I] := Options.AverageValue[I] + FData.Value[J, I];
    if Options.PenCount = 0 then
      Options.AverageValue[I] := 0
    else
      Options.AverageValue[I] := Options.AverageValue[I] / Options.PenCount;
  end;
end;




// These set up variables used for all the rest of the plotting functions.
procedure TJvChart.GraphSetup;
var
 X1,X2,Y1,Y2,pyvc,vc:Integer;
begin
  if FData.ValueCount>0 then
     Options.XValueCount := FData.ValueCount;

  { Get x value count }
  vc := Options.XValueCount;
  if (vc<1) then
      vc := 1;

  { Get y value count. First normalize. }
  Options.PrimaryYAxis.Normalize;
  Options.SecondaryYAxis.Normalize;
  pyvc := Options.PrimaryYAxis.YDivisions;
  if (pyvc < 1) then
      pyvc := 1;
    
  Options.XPixelGap := ( (Options.XEnd-1) - Options.XStartOffset ) / vc;

  FXOrigin := Options.XStartOffset + Options.XPixelGap * (Options.XOrigin);
  FYOrigin := Options.YStartOffset + Round(Options.PrimaryYAxis.YPixelGap * pyvc);
  //Options.YStartOffset +
//    Round(Options.PrimaryYAxis.YPixelGap * (pyvc - Options.YOrigin));

    (*FOO
  if Options.YOrigin < 0 then
    FYTempOrigin := Options.YStartOffset + Round(Options.PrimaryYAxis.YPixelGap * pyvc)
  else
    FYTempOrigin := Round(yOrigin);
         *)
  ChartCanvas.Brush.Style := bsClear;

   { NEW: Box around entire chart area. }
   X1 := Round(xOrigin);
   X2 := Round(Options.XStartOffset + Options.XPixelGap * vc );
   Y1 := Options.YStartOffset;
   Y2 := Round(yOrigin); // was yTempOrigin;

   if (Y2>Height) then begin
      // I suspect that the value of YPixelGap is too large in some cases.
      Options.PrimaryYAxis.Normalize;
      OutputDebugString( PChar('Y2 is bogus. pyvc='+IntToStr(pyvc)) );
   end;
  MyRectangle(  X1, Y1, X2, Y2 );

  ChartCanvas.Brush.Style := bsSolid;
end;



// internal methods
procedure TJvChart.GraphYAxis;
begin
   ChartCanvas.Pen.Style := psSolid;
   ChartCanvas.Pen.Color := Options.AxisLineColor;
   ChartCanvas.MoveTo(Round(xOrigin), Options.YStartOffset);
   MyAxisLineTo(Round(xOrigin),
                Round(   Options.YStartOffset
                       + Options.PrimaryYAxis.YPixelGap
                       * (Options.PrimaryYAxis.YDivisions)
                     )
                );
end;


// internal methods
procedure TJvChart.GraphXAxis;
begin
    ChartCanvas.Pen.Style := psSolid;
    ChartCanvas.Pen.Color := Options.AxisLineColor;
    FXAxisPosition := Options.YStartOffset + Round(Options.PrimaryYAxis.YPixelGap * (Options.PrimaryYAxis.YDivisions));
     (*FOO yTempOrigin; *)
     {Draw X-axis}
    ChartCanvas.MoveTo(Options.XStartOffset,
      FXAxisPosition);
    MyAxisLineTo(Round(Options.XStartOffset + Options.XPixelGap * Options.XValueCount  ),
      FXAxisPosition);
end;


procedure TJvChart.GraphXAxisDivisionMarkers; // new.
var
    I,X:integer;
    Lines : Integer;
    YTempOrigin:Integer;
begin
    if not Options.XAxisDivisionMarkers then exit;
    if (Options.XAxisValuesPerDivision <= 0) then exit;

    YTempOrigin := Options.YStartOffset + Round(Options.PrimaryYAxis.YPixelGap * (Options.PrimaryYAxis.YDivisions));

    Lines := ( ( (Options.XValueCount
                    +(Options.XAxisValuesPerDivision div 2)
                 )
                  div Options.XAxisValuesPerDivision
               )
             )-1;

    for I := 1 to Lines do begin
        X := Round(Options.XStartOffset + Options.XPixelGap * I * Options.XAxisValuesPerDivision);

        ChartCanvas.Pen.Color :=  Options.GetPenColor(jvChartDivisionLineColorIndex);
        
        MyDrawDotLine( {x1} X,
                       {y1} Options.YStartOffset+1,
                       {x2} X,
                       {y2} FXAxisPosition-1);
    end;
end;



procedure TJvChart.GraphYAxisDivisionMarkers;
var
    I,Y:integer;
begin
  Assert(Assigned(Self));
  Assert(Assigned(Options));
  Assert(Assigned(Options.PrimaryYAxis));
  Assert(Options.PrimaryYAxis.YPixelGap > 0);

  ChartCanvas.Font := Options.AxisFont; 

  for I := 0 to Options.PrimaryYAxis.YDivisions do
  begin

    Y := Round(yOrigin - (Options.PrimaryYAxis.YPixelGap * ((I) - Options.YOrigin)));
    
    if ( I < Options.PrimaryYAxis.YLegends.Count)  then begin
        MyRightTextOut(Round(xOrigin - 3), Y, Options.PrimaryYAxis.YLegends[I]);
    end;
    
    Y := Round(yOrigin - (Options.PrimaryYAxis.YPixelGap * ((I) - Options.YOrigin)));
    if (i>0) and ( i < (Options.PrimaryYAxis.YDivisions) ) and  Options.YAxisDivisionMarkers then begin

      ChartCanvas.Pen.Color :=  Options.GetPenColor(jvChartDivisionLineColorIndex);

      MyDrawDotLine(Options.XStartOffset,
        Y,
        Round(Options.XStartOffset + Options.XPixelGap * Options.XValueCount)-1,
        Y
        );
    end;
    if I > 0 then
      if Options.PrimaryYAxis.YPixelGap > 20 then
      begin // more than 20 pixels per major division?
      
        ChartCanvas.Pen.Color :=  Options.GetPenColor(jvChartAxisColorIndex);

        Y := Round(Y + (Options.PrimaryYAxis.YPixelGap / 2));
        Self.MyDrawAxisMark(Options.XStartOffset,
          Y,
          Options.XStartOffset - 4, // Tick at halfway between major marks.
          Y);
      end;
    end;
end;



{**************************************************************************}
{ call this function :                                                     }
{  a) you want to show the graph stored in memory                          }
{  b) you have changed single graph value (call AutoFormatGraph if all new)}
{  c) you have changed the settings of the graph and if you do not use     }
{     FAutoUpdateGraph option                                              }
{**************************************************************************}

procedure TJvChart.PlotGraph;
var
  nStackGap: Integer;
  n100Sum: Double;
  nOldY: Longint;
  YOldOrigin : Integer;
  nMaxTextHeight : Integer;
   // Rectangle plotting:
  X, Y, X2, Y2: Integer;


    { Here be lots of local functions }

    { Draw symbol markers and text labels on a chart... }
    procedure PlotGraphChartMarkers;  {LOCAL to TJvChart.PlotGraph}
    var
        tw,th,vc, I,J        : integer;
        PenAxisOpt : TJvChartYAxisOptions;
        V          : Double;
        MaxV,MinV:Array of Double;
        LineXPixelGap:Double;
        LastX,LastY:Integer;
        MinIndex,MaxIndex:Array of Integer;
    begin
          ChartCanvas.Brush.Color := Options.PaperColor;
          ChartCanvas.Pen.Style := psSolid;
          ChartCanvas.Pen.Color := Options.AxisLineColor;
          ChartCanvas.Brush.Style := bsSolid;
          
          vc := Options.XValueCount;
          LastX := Round(xOrigin);
          LastY := 0;


          if (vc<2) then
              vc := 2;
          LineXPixelGap := ( (Options.XEnd-2) - Options.XStartOffset ) /
                             (vc-1);

          SetLength(MaxV,Options.PenCount);
          SetLength(MinV,Options.PenCount);
          SetLength(MinIndex,Options.PenCount);
          SetLength(MaxIndex,Options.PenCount);          

          for I := 0 to Options.PenCount - 1 do begin
            if Options.GetPenMarkerKind(I)=pmkNone then
                continue;
            PenAxisOpt := Options.GetPenAxis(I); // Get whether this pen is plotted using the lefthand or righthand Y axis.
            MaxV[I] := PenAxisOpt.YMin;
            MinV[I] := PenAxisOpt.YMax;
            MinIndex[I] := -1;
            MaxIndex[I] := -1; 
            
            for J := 0 to Options.XValueCount - 1 do
            begin
                V := FData.Value[I, J];
                if IsNan(V) then
                    continue;
                //MaxFlag := false;
                //MinFlag := false;
                if V>MaxV[I] then begin
                    MaxV[I] := V;
                    MaxIndex[I] := J;
                end;

                if V<MinV[I] then begin
                    MinV[I] := V;
                    MinIndex[I] := J;
                end;
                    
                // Calculate Marker position:
                X := Round(xOrigin + J * LineXPixelGap);
                Y := Round(yOrigin - ((V / PenAxisOpt.YGap1 ) * PenAxisOpt.YPixelGap));
                SetLineColor(I);
                if (Y < 0) then
                    Y := 0; // constrain Y.

                (*
                if MinFlag or MaxFlag then // local min/max markers!
                    ChartCanvas.Pen.Width := 2
                else
                    ChartCanvas.Pen.Width := 1;
                *)

                // Now plot the right kind of marker:
                case Options.GetPenMarkerKind(I) of
                    pmkDiamond:
                        PlotDiamond(X,Y);
                    pmkCircle:
                        PlotCircle( X,Y);
                    pmkSquare:
                        PlotSquare( X,Y);
                    pmkCross:
                        PlotCross( X,Y);
                end;{case}

            end; {for}
          end; {for}

          { Now plot labels After all the markers. Looks nicer than doing
             it all together }
          for I := 0 to Options.PenCount - 1 do begin
            if not Options.GetPenValueLabel(I) then
                continue;
            for J := 0 to Options.XValueCount - 1 do
            begin
                V := FData.Value[I, J];
                if IsNan(V) then
                    continue;

                // Calculate Marker position:
                X := Round(xOrigin + J * LineXPixelGap);
                Y := Round(yOrigin - ((V / PenAxisOpt.YGap1 ) * PenAxisOpt.YPixelGap));

                 Text := FloatToStr(V);
                 if Options.PenUnit.Count>=I then
                         Text := Text +Options.PenUnit[I];
                 
                 tw := ChartCanvas.TextWidth(Text);
                 th := ChartCanvas.TextHeight(Text);

                if Options.GetPenValueLabel(I)
                    and (  (X>(LastX+(tw div 2)))    // Show if it's not going to collide
                        or ( (Abs(Y-LastY)>(th*2))
                             and (X>LastX)
                           )
                        or (( J = MinIndex[I] ) or (J=MaxIndex[I] )) // Always show max/mins
                         ) then begin
                    // TODO: EVENT FOR END-USER-CUSTOMIZED OR FORMATTED LABELS
                    //if Assigned(FOnGetValueLabel) then begin
                    //    FOnGetValueLabel(Sender, {Pen}I, {Sample#}J, {Value}V, {var}Text );
                    //end
                    if Length(Text)>0 then begin
                        Dec(Y,2);

                        // nifty little bit to draw a box around min/max values.
                        if ( J = MinIndex[I] ) or (J=MaxIndex[I] ) then begin
                            ChartCanvas.Pen.Style  := psDot;
                            ChartCanvas.Brush.Color := Options.HintColor;
                            MyPolygon([MyPt(X - ((tw div 2)+2),   y - (th+Options.MarkerSize+2) ),
                                       MyPt(X - ((tw div 2)+2),   y - Options.MarkerSize  ),
                                       MyPt(X + (tw div 2)+2, y - Options.MarkerSize  ),
                                       MyPt(X + (tw div 2)+2, y - (th+Options.MarkerSize+2) ) ] );
                            ChartCanvas.Pen.Style := psSolid;
                        end;

                        ChartCanvas.Brush.Style := bsSolid;
                        MyCenterTextOut( X+1, (Y-(Options.MarkerSize+th))-1, Text);
                        ChartCanvas.Brush.Color := Options.PaperColor;
                        LastX := X+tw;
                        LastY := Y;
                    end;
                end;
            end;{for}
          end; {for}
    end; {PlotGraphChartMarkers}

    
    procedure PlotGraphStackedBar;  {LOCAL to TJvChart.PlotGraph}
    var
        I,J:integer;

    begin
        for J := 0 to Options.XValueCount - 1 do
        begin
          yOldOrigin := 0;
          for I := 0 to Options.PenCount - 1 do
          begin
            if Options.GetPenStyle(I)<>psClear then begin

            if Options.XPixelGap < 3.0 then
                ChartCanvas.Pen.Color := Options.GetPenColor(I); // greek-out the borders

            MyColorRectangle(I,
              Round((xOrigin + J * Options.XPixelGap)+(Options.XPixelGap/6) ),
              Round(yOrigin - yOldOrigin),
              Round(xOrigin + (J + 1) * Options.XPixelGap  - nStackGap),
              Round((yOrigin - yOldOrigin) -
              ((FData.Value[I, J] / Options.GetPenAxis(I).YGap) * Options.PrimaryYAxis.YPixelGap)));
            yOldOrigin := Round(yOldOrigin +
              ((FData.Value[I, J] / Options.GetPenAxis(I).YGap) * Options.PrimaryYAxis.YPixelGap));
            end;
          end;
        end;
     end;


  procedure PlotGraphBar;  {LOCAL to TJvChart.PlotGraph}
  var
        I,J,N:integer;
        BarCount : Double;
        V,BarGap :Double;
        yTempOrigin:Integer;
        function BarXPosition( index:Integer):Integer;
        begin
              result := Round( xOrigin + (index * BarGap) );
        end;
  begin
        yTempOrigin := Options.YStartOffset + Round(Options.PrimaryYAxis.YPixelGap * (Options.PrimaryYAxis.YDivisions));
        BarCount := Options.PenCount * Options.XValueCount;
        BarGap :=  ((( Options.XEnd-1) - Options.XStartOffset) /    BarCount );

        for I := 0 to Options.PenCount - 1 do begin

          if Options.GetPenAxis(I).YGap = 0 then continue; // Can't plot this one.
          
          for J := 0 to Options.XValueCount - 1 do
          begin

             N := (J* Options.PenCount)+I; // Which Bar Number!?

                // Plot a rectangle for each Bar in our bar chart...

            X := BarXPosition( N )+1;

            // Make a space between groups, 4 pixels per XValue index:
            //Dec(X,4);
            //Inc(X, 2*J);

            Y := yTempOrigin;
            Assert(Y<Height);
            Assert(Y>0);
            Assert(X>0);
            if (X>=Width) then
                OutputDebugString('foo!');
            Assert(X<Width);

            X2 := BarXPosition(N+1)-3;

            // Make a space between groups, 4 pixels per XValue index:
            //Dec(X2,4);
            //Inc(X2, 2*J);

            V := FData.Value[I, J];
            if IsNan(V) then
                continue;

            Y2 := Round(yOrigin - ((V / Options.GetPenAxis(I).YGap) * Options.PrimaryYAxis.YPixelGap));

            Assert(Y2<Height);
            Assert(Y2>0);
            if (Y2>=Y) then
                Y2 := Y-1;
            Assert(Y2<Y);

            Assert(X2>0);
            //if (X2<Width) then
              //  OutputDebugString('foo!');
            //Assert(X2<Width);
            //Assert(X2>X);

            if Options.PenCount > 1 then
              if X2 > X then
                Dec(X2); // Additional 1 pixel gap
                
            if Options.GetPenStyle(I) <> psClear then begin
                if (X2-X)<4 then // don't draw black line around bar if it is a very narrow bar.
                  ChartCanvas.Pen.Style := psClear
                else
                  ChartCanvas.Pen.Style := Options.GetPenStyle(I);
            
                MyColorRectangle(I, X, Y, X2, Y2);
            end;
          end; {for}
        end; {for}
        {add average line for the type...}
        if Options.ChartKind = ckChartBarAverage then
        begin
          SetLineColor(-3);
          ChartCanvas.MoveTo(Round(xOrigin + 1 * Options.XPixelGap),
            Round(yOrigin - ((Options.AverageValue[1] / Options.GetPenAxis(I).YGap) * Options.PrimaryYAxis.YPixelGap)));
          for J := 2 to Options.XValueCount do
            MyPenLineTo(Round(xOrigin + J * Options.XPixelGap),
              Round(yOrigin - ((Options.AverageValue[J] / Options.GetPenAxis(I).YGap) * Options.PrimaryYAxis.YPixelGap)));
          SetLineColor(-3);
        end;

        // NEW: Add markers to bar chart:
        PlotGraphChartMarkers;

      end;


    // Keep Y in visible chart range:
    function GraphConstrainedLineY(Pen,Sample:Integer): Double; {LOCAL to TJvChart.PlotGraph}
    var
      v:Double;
      PenAxisOpt:TJvChartYAxisOptions;
    begin
      v := FData.Value[Pen,Sample];
      PenAxisOpt := Options.GetPenAxis(Pen);
      if IsNan(v) then begin
          result := NaN; // blank placeholder value in chart!
          exit;
      end;
      if ( PenAxisOpt.YGap < 0.0000001 ) then begin
          result := 0.0; // can't chart! YGap is near zero, zero, or negative.
          exit;
      end;
      Result := (yOrigin - ((v/ PenAxisOpt.YGap) * PenAxisOpt.YPixelGap));
      if Result >= (yOrigin - 1) then
        Result := Round(yOrigin) - 1  // hit the top of the chart
      else
      if Result < 1 + (yOrigin - (Options.YEnd - PenAxisOpt.YPixelGap)) then
        Result := 1 + Round(yOrigin - (Options.YEnd - PenAxisOpt.YPixelGap));
    end;


    procedure PlotGraphChartLine; {LOCAL to TJvChart.PlotGraph}
    var
        I,I2,J,Y1:integer;
        V,LineXPixelGap:Double;
        NanFlag:Boolean;
        vc:Integer;
        PenAxisOpt:TJvChartYAxisOptions;
    begin
        NanFlag := false;
        vc := Options.XValueCount;
        if (vc<2) then
            vc := 2;
        LineXPixelGap := ( (Options.XEnd-2) - Options.XStartOffset ) /
                           (vc-1);

        ChartCanvas.Pen.Style := psSolid;
        for I := 0 to Options.PenCount - 1 do
        begin
          PenAxisOpt := Options.GetPenAxis(I);
          // No line types?
          if Options.GetPenStyle(I) = psClear then
              continue;
          SetLineColor(I);
          J := 0;
          V := GraphConstrainedLineY(I,J);
          if IsNan(V) then
              Y := 0 // what else can we do?
          else
              Y := Round( V );
          ChartCanvas.MoveTo(Round(xOrigin), Y );
          for J := 1 to Options.XValueCount - 1 do
          begin
            V := GraphConstrainedLineY(I,J);
            if IsNan(V) then begin
              NanFlag := true; // skip.
            end else begin
              if NanFlag then begin // resume, valid value.
                 NanFlag := false;
                  Y := Round( V );
                  // pick up the pen and slide forward
                  ChartCanvas.MoveTo(Round(xOrigin + J * LineXPixelGap), Y);
              end else begin
                  Y := Round( V );
                  ChartCanvas.Pen.Style := Options.GetPenStyle(I);
                  if (i >0) then begin
                    for i2 := 0 to I-1 do begin
                      V := GraphConstrainedLineY(i2,J);
                      if IsNan(V) then continue;
                      Y1 := Round(V);
                      if (Y1 = Y) then begin
                          Dec(Y); // Prevent line-overlap. Show dotted line above other line.
                          if ChartCanvas.Pen.Style=psSolid then
                                ChartCanvas.Pen.Style := psDot;
                      end;
                    end;
                  end;
                  MyPenLineTo(Round(xOrigin + J * LineXPixelGap), Y);
                  //OldV := V; // keep track of last valid value, for handling gaps.
              end;
            end;
          end; {for J}
         end; {for I}
         PlotGraphChartMarkers;
         // MARKERS:
        SetLineColor(-3);
    end; {PlotGraphChartLine}

    procedure PlotGraphStackedBarAverage;  {LOCAL to TJvChart.PlotGraph}
    var
        I,J:integer;
    begin
        for J := 0 to Options.XValueCount - 1 do
        begin
          n100Sum := 0;
          for I := 0 to Options.PenCount - 1 do
            n100Sum := n100Sum + FData.Value[I, J];

          for I := 0 to Options.PenCount - 1 do
            if n100Sum <> 0 then
              AverageData.Value[I, J] := (FData.Value[I, J] / n100Sum) * 100
            else
              AverageData.Value[I, J] := 0;
        end;

        for J := 0 to Options.XValueCount - 1 do
        begin
          yOldOrigin := 0;
          for I := 0 to Options.PenCount - 1 do
          begin
            if I = Options.PenCount then {last one; draw it always to the top line}
              MyColorRectangle(I,
                Round(xOrigin + J * Options.XPixelGap + (Options.XPixelGap / 2)),
                Round(yOrigin - yOldOrigin),
                Round(xOrigin + (J + 1) * Options.XPixelGap + (Options.XPixelGap / 2) - nStackGap),
                Options.YStartOffset)
            else
            begin
              MyColorRectangle(I,
                Round(xOrigin + J * Options.XPixelGap + (Options.XPixelGap / 2)),
                Round(yOrigin - yOldOrigin),
                Round(xOrigin + (J + 1) * Options.XPixelGap + (Options.XPixelGap / 2) - nStackGap),
                Round((yOrigin - yOldOrigin) -
                ((AverageData.Value[I, J] / Options.GetPenAxis(I).YGap) * Options.PrimaryYAxis.YPixelGap)
                )
                );
              yOldOrigin := yOldOrigin + Round((AverageData.Value[I, J] / Options.GetPenAxis(I).YGap) * Options.PrimaryYAxis.YPixelGap);
            end;
          end;
        end;
   end;  {PlotGraphStackedBarAverage}

   procedure CheckYAxisFlags;
   var
     i:Integer;
   begin
     Options.PrimaryYAxis.FActive := true;
     Options.SecondaryYAxis.FActive := false;
     for i := 0 to Options.PenCount-1 do begin
      if Options.GetPenSecondaryAxisFlag(i) then begin
          Options.SecondaryYAxis.FActive := true;
          break;
      end;{if}
     end;{for}
   end;{local fn}
   
begin { ------------------- PlotGraph begins... Enough local functions for ya? -WP }
   FPlotGraphCalled := true;

  // refuse to refresh under these conditions:
  if not (Enabled and Visible) then
    exit;
  if (csDesigning in ComponentState) then begin
    if (not Assigned(Self.Parent)) then exit;
    if (Self.Name = '') then exit;
  end;

  // safety before we paint.
  Assert(Assigned(Self));
  Assert(Assigned(Data));
  Assert(Assigned(Options));
  Assert(Assigned(Options.PrimaryYAxis));
  Assert(Assigned(Options.SecondaryYAxis));  
  Assert(Assigned(AverageData));

  // Sanity check on YEnd/XEnd:
  if     (Options.YEnd <= 0)
      or (Options.XEnd <= 0)
      or (Options.YEnd > Height)
      or (Options.XEnd > Width) then
  begin
    ResizeChartCanvas;  // Recovery. This shouldn't happen.
  end;

  // NEW: Primary Y axis is always shown, but secondary is only shown
  // if a pen is set up to plot on the secondary Y Axis scale.
  CheckYAxisFlags;

  ClearScreen;


  if Options.XValueCount > MAX_VALUES then
    Options.XValueCount := MAX_VALUES;
  if Options.PenCount > MAX_PEN then
    Options.PenCount := MAX_PEN;
    (*
  if Options.PrimaryYAxis.YGap = 0 then
      Options.PrimaryYAxis.YGap := 1;
  if Options.SecondaryYAxis.YGap = 0 then
      Options.SecondaryYAxis.YGap := 1;
      *)

  {Resize Header area according to HeaderFont size}
  if not PrintInSession then
  begin
    MyHeaderFont;
    nOldY := Options.YStartOffset;
    nMaxTextHeight := CanvasMaxTextHeight(ChartCanvas) + 8;
    // Bump bottom margins if the fonts don't fit!
    if ( Options.YStartOffset < (2*nMaxTextHeight)) then begin
        Options.YStartOffset := nMaxTextHeight * 2;
        //Options.YEnd := Options.YEnd + (nOldY - Options.YStartOffset);
        CalcYEnd;
        Options.PrimaryYAxis.Normalize;
        Options.SecondaryYAxis.Normalize;
    end;
  end;


  if (Options.ChartKind = ckChartStackedBar) or
    (Options.ChartKind = ckChartStackedBarAverage) then
  begin
    FOldYOrigin := Options.YOrigin;
    Options.YOrigin := 0;
  end
  else
  begin
    FOldYOrigin := Options.YOrigin;
  end;
  if Options.ChartKind = ckChartStackedBarAverage then
  begin
    FOldYGap := Options.PrimaryYAxis.YGap;
  end
  else
  begin
    FOldYGap := Options.PrimaryYAxis.YGap;
  end;

 {This effects only graph type: JvChartStackedBar(_100)}
  nStackGap := 1;
  if Options.XEnd > 200 then
    nStackGap := 3;

  MyAxisFont;


  YOldOrigin :=  Trunc(YOrigin);

   {Draw header and other stuff...}
  GraphSetup;

  // If FData.ValueCount is zero we can preview the visual appearance of the chart,
  // but there is no plotting of pens that can occur, so stop now...
  if (FData.ValueCount=0 )then // EMPTY!
  begin
    { draw a blank chart. Component shouldn't just be a white square, it makes
      users think we're broken, when we're not, they just haven't given us any
      data.}
    Options.PrimaryYAxis.Normalize;
    Options.SecondaryYAxis.Normalize;
    GraphSetup;
    PrimaryYAxisLabels;

    GraphXAxis;
    GraphXAxisDivisionMarkers;
    GraphYAxis;
    GraphYAxisDivisionMarkers;

    ChartCanvas.Font.Color := clRed;
    MyLeftTextOut(Round(xOrigin), Round(yOrigin)+4, RsNoData);
    Invalidate;
    Exit;
  end;
  

  {Y Axis}
  GraphYAxis;
  GraphYAxisDivisionMarkers; // dotted lines making graph-paper across graph
  
  {X Axis}
  GraphXAxis;
  GraphXAxisDivisionMarkers; // new.


  {X-axis legends...}
  GraphXAxisLegend;

   {Main Header}
  MyHeader(Options.Title);

   {X axis header}
  MyXHeader(Options.XAxisHeader);

   {Create the actual graph...}
  case (Options.ChartKind) of
    ckChartBar, ckChartBarAverage:
        PlotGraphBar;

    ckChartStackedBar:
        PlotGraphStackedBar;

    ckChartLine: //, ckChartLineWithMarkers:
        PlotGraphChartLine;

    ckChartMarkers:
        PlotGraphChartMarkers;

    ckChartStackedBarAverage:
        PlotGraphStackedBarAverage;


    ckChartPieChart:
        GraphPieChart(1);     { special types}


    ckChartDeltaAverage:
      GraphDeltaAverage;     { special types}
  end;

   {Y axis header}
  MyYHeader(Options.YAxisHeader); // vertical text out on Y axis

  Invalidate;
end;




procedure TJvChart.GraphXAxisLegend;
var
  I, K, Y, Count        : Integer;
  XLegendGap         : Integer;
  BoxWidth,BoxHeight : Integer;
  nTextHeight        : Integer;
  //yTempOrigin        : Integer; // (ahuser) conflict with YTempOrigin property?
  myLabel            : string;
  XLegendHoriz       : Integer;
  timestamp          : TDateTime;
  timestampStr       : String;
  XOverlap           : Integer;
  VisiblePenCount    : Integer;
  YTempOrigin        : Integer;
begin
   {X-LEGEND: ...}
//   DoSeparate := False; // not used (ahuser)
  XLegendGap := 0;
  VisiblePenCount := 0;
   {Count how many characters to show in the separate legend}
  //

  SetLineColor(-3);
  MyAxisFont;


  { datetime mode for X axis legends : follow the division markers }
  if Options.XAxisDateTimeMode then begin { if DateTime mode then legends are painted where the division markers are painted }

    // if not Options.XAxisDivisionMarkers then exit;
    if (Options.XAxisValuesPerDivision <= 0) then exit;

    YTempOrigin := Options.YStartOffset
                      + Round(  Options.PrimaryYAxis.YPixelGap
                                * Options.PrimaryYAxis.YDivisions );

    XOverlap := 0;
    for I := 1 to ((Options.XValueCount div Options.XAxisValuesPerDivision))-1 do begin
        XLegendHoriz := Round(Options.XStartOffset + Options.XPixelGap * I * Options.XAxisValuesPerDivision);

        timestamp := FData.Timestamp[ I * Options.XAxisValuesPerDivision ];

        if Length(Options.FXAxisDateTimeFormat)=0 then // not specified, means use Locale defaults
           timestampStr := TimeToStr( timestamp )
        else
           timestampStr := FormatDateTime( Options.FXAxisDateTimeFormat, timestamp );

        // Check if writing this label would collide with previous label, if not, plot it
        if (XLegendHoriz-( ChartCanvas.TextWidth(timestampStr) div 2 ))> XOverlap then begin
            MyCenterTextOut( XLegendHoriz,
                 {bottom:}   FXAxisPosition + Options.AxisLineWidth {top: Round(yTempOrigin - Options.PrimaryYAxis.YPixelGap)},
                             timestampStr );

            // draw a ticky-boo (technical term used by scientists the world over)
            // so that we can see where on the chart the X axis datetime is pointing to.
            ChartCanvas.Pen.Width := 1;
            ChartCanvas.MoveTo( XLegendHoriz, FXAxisPosition );
            ChartCanvas.LineTo(  XLegendHoriz, FXAxisPosition+Options.AxisLineWidth+2  );
                                 
            XOverlap := XLegendHoriz +   ChartCanvas.TextWidth(timestampStr);
        end;
        
    end;

  end else if Options.XValueCount > 0 then // is there data to plot?
  begin

    {default X axis legend mode: use text legends}
    
    if Options.FXAxisLegendSkipBy < 1 then
      Options.FXAxisLegendSkipBy := 1;

    Count := (Options.XValueCount + (Options.FXAxisLegendSkipBy - 1)) div Options.FXAxisLegendSkipBy;
         // Skip the first (index 0) Axis Label, for visual reasons.
    for k := 0 to Count - 1 do
    begin
      I := k * Options.FXAxisLegendSkipBy;
      XLegendHoriz := Round(Options.XStartOffset + Options.XPixelGap * I);

      // Don't exceed right margin:
      if (I<Options.XLegends.Count) then
        if ChartCanvas.TextWidth( Options.XLegends[I] )+ XLegendHoriz > Options.XEnd then
            break;

      // Label X axis above or below?
      if FContainsNegative then
        MyLeftTextOut( XLegendHoriz,
          Options.YEnd + 3,
          Options.XLegends[I])
      else
        if I < Options.XLegends.Count then
        MyLeftTextOut( XLegendHoriz,
          {bottom:} FXAxisPosition + Options.AxisLineWidth {top: Round(yTempOrigin - Options.PrimaryYAxis.YPixelGap)},
          Options.XLegends[I])
      else
        break;
    end; {for k}
  end; // (XValueCount>0)
   //end;

   MySmallGraphFont;

   {Pen Legend on Right Sid, only if Pen count is greater than one and we want them.}
  if  Options.Legend = clChartLegendRight then begin

        MySmallGraphFont;

         {10 % extra space for line height}
        nTextHeight := Round(CanvasMaxTextHeight(ChartCanvas) * 1.1);
        BoxWidth := ChartCanvas.TextWidth('X')*2 -2;
        BoxHeight := nTextHeight - 2;

        MyColorRectangle(-4,
          Options.XStartOffset + Options.XEnd + 6,
          Options.YStartOffset + XLegendGap + 6,
          Options.XStartOffset + Options.XEnd + Options.LegendWidth + 6,
          Options.YStartOffset + (Options.PenCount + 1) * nTextHeight + XLegendGap + 6 + 5);
        MyColorRectangle(-1,
          Options.XStartOffset + Options.XEnd + 3,
          Options.YStartOffset + 3 + XLegendGap,
          Options.XStartOffset + Options.XEnd + Options.LegendWidth + 3,
          Options.YStartOffset + (Options.PenCount + 1) * nTextHeight + 3 + XLegendGap + 5);

        for I := 0 to Options.PenCount - 1 do
        begin
          if Options.GetPenStyle(I) <>psClear then begin  // Only draw legend on VISIBLE pens.
          DrawPenColorBox( {pen#} I,
                  BoxWidth,
                  BoxHeight,
                  Options.XStartOffset + Options.XEnd + 7,
                  Options.YStartOffset + VisiblePenCount * nTextHeight + 7 + XLegendGap);
          SetFontColor(-3);
               // Draw the Pen Legend (WAP :add unit to legend. )
          if Options.PenLegends.Count > I then
            myLabel := Options.PenLegends[I]
          else
            myLabel := IntToStr(I + 1);

            // Put units in pen legends
            (*
               if     ( Options.PenUnit.Count > I )
                  and ( Length( Options.PenUnit[I] ) >  0 ) then
                  myLabel := myLabel + ' ('+Options.PenUnit[I]+')';
            *)

          MyLeftTextOut(Options.XStartOffset + Options.XEnd + 15 + ChartCanvas.TextWidth('12'),
            Options.YStartOffset + VisiblePenCount * nTextHeight + 7 + XLegendGap,
            myLabel);
            Inc(VisiblePenCount);
          end; {if}
        end;{for I}

  end else if Options.Legend = clChartLegendBelow then begin // space-saving legend below chart

        MySmallGraphFont;

         {10 % extra space for line height}
        nTextHeight := Round(CanvasMaxTextHeight(ChartCanvas) * 1.01);
        BoxWidth := ChartCanvas.TextWidth('X')*2 -2;
        //BoxHeight := nTextHeight - 2;

        XLegendHoriz       := Options.XStartOffset;
        for I := 0 to Options.PenCount - 1 do
        begin

          if Options.GetPenStyle(I) <>psClear then begin // Only draw legend on VISIBLE pens.

          Y := Options.YStartOffset + Options.YEnd + (nTextHeight div 2);

          // If chart has X legends:
          if (Options.XLegends.Count>0) or (Options.XAxisDateTimeMode) then
              Y := Y + nTextHeight;

          DrawPenColorBox( {pen#} I,
            {width}  ChartCanvas.TextWidth('12') - 2,
            {height} nTextHeight - 2,
            {X=}     XLegendHoriz,
            {Y=}     Y+4
                           );
          SetFontColor(-3);
               // Draw the Pen Legend (WAP :add unit to legend. )
          if Options.PenLegends.Count > I then
            myLabel := Options.PenLegends[I]
          else
            myLabel := IntToStr(I + 1);

            // Put units in pen legends
            (*
               if     ( Options.PenUnit.Count > I )
                  and ( Length( Options.PenUnit[I] ) >  0 ) then
                  myLabel := myLabel + ' ('+Options.PenUnit[I]+')';
            *)

          MyLeftTextOut(  XLegendHoriz + BoxWidth + 3,
                          Y,
                          myLabel);

          Inc( XLegendHoriz, BoxWidth + Canvas.TextWidth(myLabel) + 14 );

          //Inc(VisiblePenCount);
          end;

        end;

  end;

end;

procedure TJvChart.DrawPenColorBox(nColor, W, H, X, Y: Integer);
begin
  MyColorRectangle(nColor, X, Y, X + W, Y + H);
  SetRectangleColor(-1);
end;

{**************************************************************************}
{ call this function :                                                     }
{  a) when you want to print the graph to Windows default printer          }
{**************************************************************************}

procedure TJvChart.PrintGraph;
var
  nXEnd, nYEnd: Longint;
  nXStart, nYStart: Longint;
  nLegendWidth: Longint;
begin
   {Save display values...}
  nXEnd := Options.XEnd;
  nYEnd := Options.YEnd;
  nXStart := Options.XStartOffset;
  nYStart := Options.YStartOffset;
  nLegendWidth := Options.LegendWidth;
   {Calculate new values for printer....}
  Options.LegendWidth := Round((Options.LegendWidth / (nXEnd + Options.LegendWidth)) * Printer.PageWidth);
  Options.XStartOffset := Round(Printer.PageWidth * 0.08); {8%}
  Options.YStartOffset := Round(Printer.PageHeight * 0.1); {10%}
  Options.XEnd := Round(Printer.PageWidth - (1.2 * Options.LegendWidth)) - Options.XStartOffset;
  Options.YEnd := Round(Printer.PageHeight * 0.75);
  if Options.YEnd > Options.XEnd then
    Options.YEnd := Options.XEnd;
  {Begin printing...}
  PrintInSession := True;
  Printer.BeginDoc;
  PlotGraph; {Here it goes!}
  Printer.EndDoc;
  PrintInSession := False;
  {Restore display values...}
  Options.XStartOffset := nXStart; {margin}
  Options.YStartOffset := nYStart;
  Options.XEnd := nXEnd;
  Options.YEnd := nYEnd;
  Options.LegendWidth := nLegendWidth;
end;

{**************************************************************************}
{ call this function :                                                     }
{  a) when you want to print the graph to Windows default printer          }
{     AND you add something else on the same paper. This function          }
{     will just add the chart to the OPEN printer canvas at given position }
{**************************************************************************}

// (rom) XStartPos, YStartPos unused

procedure TJvChart.AddGraphToOpenPrintCanvas(XStartPos, YStartPos, GraphWidth, GraphHeight: Longint);
var
  nXEnd, nYEnd: Longint;
  nXStart, nYStart: Longint;
  nLegendWidth: Longint;
begin
   {Save display values...}
  nXEnd := Options.XEnd;
  nYEnd := Options.YEnd;
  nXStart := Options.XStartOffset;
  nYStart := Options.YStartOffset;
  nLegendWidth := Options.LegendWidth;
   {Set new values for printing the graph at EXISTING print canvas....}
  Options.LegendWidth := Round((Options.LegendWidth / (nXEnd + Options.LegendWidth)) * GraphWidth);
  Options.XStartOffset := Round(GraphWidth * 0.08); {8%}
  Options.YStartOffset := Round(GraphHeight * 0.1); {10%}
  Options.XEnd := Round(GraphWidth - (1.2 * Options.LegendWidth)) - Options.XStartOffset;
  Options.YEnd := Round(GraphHeight * 0.75);
   {Begin printing...NOTICE BeginDoc And EndDoc must be done OUTSIDE this procedure call}
  PrintInSession := True;
  PlotGraph; {Here it goes!}
  PrintInSession := False;
   {Restore display values...}
  Options.XStartOffset := nXStart; {margin}
  Options.YStartOffset := nYStart;
  Options.XEnd := nXEnd;
  Options.YEnd := nYEnd;
  Options.LegendWidth := nLegendWidth;
end;


{NEW}
{ when the user clicks the chart and changes the axis, we need a notification
  so we can save the new settings. }
procedure TJvChart.NotifyOptionsChange;
begin
  if FUpdating then exit;
  if (csDesigning in ComponentState) then begin
    Invalidate;
    exit;
  end;
  if (csLoading in ComponentState) then exit; // Component properties being set at runtime.

  // Event fire:
  if Assigned(FOnOptionsChangeEvent) then begin
    FOnOptionsChangeEvent(Self);
  end;
  if Options.AutoUpdateGraph then begin
    FAutoPlotDone := false; // Next paint will also call PlotGraph
    Invalidate;
  end;
end;



{ Warren implemented TImage related code directly into TJvChart, to remove TImage as base class.}
// (rom) simplified by returning the Printer Canvas when printing

function TJvChart.GetCanvas: TCanvas;
var
  Bitmap: TBitmap;
begin
  { designtime - draw directly to screen }
  if (csDesigning in ComponentState) then begin
     result := Self.Canvas;
     exit;
  end;

  { printer canvas }
  if PrintInSession then
  begin
    Result := Printer.Canvas;
    Exit;
  end;

  { FPicture.Graphic -bitmap canvas - normal display method. }
  if FPicture.Graphic = nil then
  begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.Width := Width;
      Bitmap.Height := Height;
      FPicture.Graphic := Bitmap;
    finally
      Bitmap.Free;
    end;
  end;
  if FPicture.Graphic is TBitmap then
    Result := TBitmap(FPicture.Graphic).Canvas
  else
    raise EInvalidOperation.Create(RsEUnableToGetCanvas);
end;

procedure TJvChart.CalcYEnd;
begin
 OutputDebugString(PChar('CalcYEnd Height='+IntToStr(Height) ) );
 if not Assigned(FBitmap) then
    Options.YEnd := 0
 else
    Options.YEnd := FBitmap.Height - 2 * Options.YStartOffset; {canvas size, excluding margin}
end;
{**************************************************************************}
{ call this function :                                                     }
{  a) when you resize the canvas for the AABsoftGraph                      }
{  b) at program startup before drawing the first graph                    }
{**************************************************************************}

procedure TJvChart.ResizeChartCanvas;
begin
  {Add code for my own data...here}
  if not Assigned(FBitmap) then
  begin
    FBitmap := TBitmap.Create;
    FBitmap.Height := Height;
    FBitmap.Width := Width;
    FPicture.Graphic := FBitmap;
  end
  else
  begin
    FBitmap.Width := Width;
    FBitmap.Height := Height;
    FPicture.Graphic := FBitmap;
  end;

  CalcYEnd; // Yend depends on YStartOffset.


  if Options.Legend = clChartLegendRight then
    Options.XEnd := Round(((FBitmap.Width-2) - 1.5 * Options.XStartOffset) - Options.LegendWidth)
  else
    Options.XEnd := Round((FBitmap.Width-2) - 0.5 * Options.XStartOffset);

  if Options.XEnd < 10 then
    Options.XEnd := 10;
  if Options.YEnd < 10 then
    Options.YEnd := 10;

  if not Assigned(Data) then
    exit; //safety.
//  if Data.ValueCount = 0 then
//    exit; // no use, there's no data yet.


  Options.PrimaryYAxis.Normalize;
  Options.SecondaryYAxis.Normalize;

  if Options.AutoUpdateGraph or  FPlotGraphCalled  then 
      PlotGraph;
end;

{This procedure is called when user clicks on the main header}

procedure TJvChart.EditHeader;
var
  strString: string;
begin
  strString := Options.Title;
  if InputQuery(RsGraphHeader, Format(RsCurrentHeaders, [Options.Title]), strString) then
    Options.Title := strString;
  PlotGraph;

  Invalidate;
end;

{This procedure is called when user clicks on the x-axis header}

procedure TJvChart.EditXHeader;
var
  strString: string;
begin
  strString := Options.XAxisHeader;
  if InputQuery(RsGraphHeader, Format(RsXAxisHeaders, [Options.XAxisHeader]), strString) then
    Options.XAxisHeader := strString;
  PlotGraph;

  Invalidate;
end;

procedure TJvChart.EditYScale;
var
  strString: string;
begin
  strString := FloatToStr( Options.PrimaryYAxis.YMax );
  if InputQuery(RsGraphScale, Format(RsYAxisScales, [FloatToStr(Options.PrimaryYAxis.YMax)]), strString) then
    Options.PrimaryYAxis.YMax := StrToFloatDef(strString, Options.PrimaryYAxis.YMax)
  else
    exit;

  AutoFormatGraph;    
(*  NotifyOptionsChange; // Fire event before we auto-format graph. Allows some customization to occur here.
  AutoFormatGraph;
  PlotGraph;
  Invalidate;*)
end;

procedure TJvChart.MyXHeader(strText: string);
var
 X,Y:Integer;
begin
  MyAxisFont;
  X := Options.XStartOffset + Round(Options.XEnd / 2);
  Y := Options.YStartOffset + Options.YEnd + (2*MyTextHeight(strText) -4 ); 
  MyCenterTextOut( X,Y, strText);
  //MyAxisFont;
end;

procedure TJvChart.MyYHeader(strText: string);
var
  {ht,}wd, vert, horiz: Integer; // not used (ahuser)
begin
  if Length(strText) = 0 then
    exit;
  ChartCanvas.Brush.Color := Color;
  {$IFDEF VCL}
  { !!warning: uses Win32 only font-handle stuff!!}
  MyGraphVertFont; // Select Vertical Font Output.
  {$ENDIF VCL}

  {$IFDEF VisualCLX}
  MyAxisFont;
  {$ENDIF VisuaLCLX}
  if Options.XStartOffset > 10 then
  begin
      {ht := MyTextHeight(strText); }// not used (ahuser)
    wd := ChartCanvas.TextWidth(strText);
      // Kindof a fudge, but we'll work out something better later... :-) -WAP.
    vert := (Options.YStartOffset * 2) + ((Height div 2) - (wd div 2));
    if vert < 0 then
      vert := 0;
    horiz := 2;
    {$IFDEF VCL}
      // NOTE: Because of the logical font selected, this time TextOut goes vertical.
      // If this doesn't go vertical, it may be because the font selection above failed.
    MyLeftTextOut(horiz, vert, strText);
    {$ENDIF VCL}
    {$IFDEF VisualCLX}
    TextOutAngle(ChartCanvas, 90, horiz, vert, strText);
    {$ENDIF VisualCLX}
  end;
  MyAxisFont;
//   Self.MyLeftTextOut(horiz,vert+50,'*');

end;

{***************************************************************************}
{ MOUSE FUNCTIONS AND PROCEDURES                                            }
{***************************************************************************}
{
function  TJvChart.GetXValue(X,Y:Integer): Double;
var
   xOrigin    : Longint;
   XPixelGap: Longint;
begin
   if (Y>Options.YStartOffset) and (Y<Options.YStartOffset+Options.YEnd) and
      (X>Options.XStartOffset) and (X<Options.XStartOffset+Options.XEnd) and
      (Options.ChartKind <> JvChartPieChart)
   then
   begin
      XPixelGap  := Round((Options.XEnd-Options.XStartOffset) /
                           (Options.XValueCount+1));
      xOrigin :=Options.XStartOffset + XPixelGap*(Options.XOrigin);

      GetXValue   := Round((X-xOrigin)/XPixelGap);
   end else GetXValue := 0;
end;

function  TJvChart.GetYValue(X,Y:Integer): Double;
var
   yOrigin    : Longint;
   YPixelGap: Longint;
begin
   if (Y>Options.YStartOffset) and (Y<Options.YStartOffset+Options.YEnd) and
      (X>Options.XStartOffset) and (X<Options.XStartOffset+Options.XEnd) and
      (Options.ChartKind <> JvChartPieChart)
   then
   begin
      YPixelGap  := Round(Options.YEnd/(Options.PrimaryYAxis.YDivisions+1));
      yOrigin      := Options.YStartOffset +
                     Round(YPixelGap*(Options.PrimaryYAxis.YDivisions-Options.YOrigin));
      GetYValue   := ((yOrigin-Y)/YPixelGap)*Options.PrimaryYAxis.YGap;
   end else GetYValue := 0;
end;
}

procedure TJvChart.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := crDefault;
  inherited MouseUp(Button, Shift, X, Y);

  if FStartDrag then
  begin
    Options.LegendWidth := Options.LegendWidth + (FMouseDownX - X);
    Options.XEnd := Options.XEnd - (FMouseDownX - X);
    PlotGraph;
  end;
  if FMouseLegend then
  begin
    PlotGraph;
    FMouseLegend := False;
  end;
  FStartDrag := False;

  Invalidate;
end;

procedure TJvChart.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  XPixelGap: Double;
//  YPixelGap  : Double; // not used (ahuser)
begin
  inherited MouseDown(Button, Shift, X, Y);

  if Options.MouseEdit then
  begin
    if X < Options.XStartOffset then
      EditYScale
    else
    if Y < Options.YStartOffset then
      EditHeader
    else
    if Y > (Options.YStartOffset + Options.YEnd) then
      EditXHeader;
  end;

  if Options.MouseInfo then
  begin
    FStartDrag := False;
    FMouseDownX := X;
    FMouseDownY := Y;
    if (Y > Options.YStartOffset) and
      (Y < Options.YStartOffset + Options.YEnd) and
      (X > Options.XStartOffset) and
      (X < Options.XStartOffset + Options.XEnd + 10) then
    begin
        {Legend resize...}
      if X > (Options.XStartOffset + Options.XEnd) - 5 then
      begin
        FStartDrag := True;
        Screen.Cursor := crSizeWE;
      end;
        {Inside the actual graph...}
      if (X <= (Options.XStartOffset + Options.XEnd) - 5) and
        (Options.ChartKind <> ckChartPieChart) and
        (Options.ChartKind <> ckChartDeltaAverage) then
      begin
        XPixelGap := ((Options.XEnd - Options.XStartOffset) /
          (Options.XValueCount + 1));
           //if XPixelGap <1 then
            //  XPixelGal := 1;
        if XPixelGap > 0.001 then
          FMouseValue := Round((X - Options.XStartOffset) / (XPixelGap))
        else
          FMouseValue := 0; // can't figure it out.

        case (Options.ChartKind) of
          ckChartBar, ckChartBarAverage:
            if Options.PenCount = 1 then {check for Pen count}
              FMousePen := Round(((X + (XPixelGap / 2)) -
                (Options.XStartOffset +
                Options.XOrigin * XPixelGap +
                XPixelGap * FMouseValue)) /
                Round(XPixelGap / (Options.PenCount + 0.1)) + 0.1)
            else
              FMousePen := Round(((X + (XPixelGap / 2)) -
                (Options.XStartOffset +
                Options.XOrigin * XPixelGap +
                XPixelGap * FMouseValue)) /
                Round(XPixelGap / (Options.PenCount + 0.5)) + 0.5);
          ckChartStackedBar, ckChartLine, ckChartStackedBarAverage:
            FMousePen := 0;
        end;
        if (FMouseValue > Options.XValueCount) or (FMouseValue < 0) then
          FMouseValue := 0;
        if FMousePen > Options.PrimaryYAxis.YDivisions then
          FMousePen := 0;

          // New: Allow user to do custom hints, or else do other things
          // when a chart is clicked.
        if Assigned(FOnChartClick) then begin
           FMouseDownShowHint:=false;
           FMouseDownHintBold := false;
           FOnChartClick(Self, Button, Shift, X, Y, FMouseValue, FMousePen, FMouseDownShowHint, FMouseDownHintBold, FMouseDownHintStrs);
        end else begin
          if Button=mbLeft then begin
            FMouseDownShowHint := true;
            FMouseDownHintBold := true;
            AutoHint;
          end else begin
            FMouseDownShowHint := false; { don't show }
          end;
        end;

        if ((FMouseDownHintStrs.Count>0) and FMouseDownShowHint) then begin
           ShowMouseMessage(X, Y);
        end;
      end;
    end;
  end;
end;

procedure TJvChart.SetCursorPosition(pos:Integer);
begin
    FCursorPosition := pos;
    Invalidate; // repaint!
end;

{ make list of 'PenName=Value' strings for each pen.. }
procedure TJvChart.AutoHint; // Make the automatic hint message showing all pens and their values.
var
   I: Integer;
   str :String;
   Val:Double;
begin
  FMouseDownHintStrs.Clear;


  if Options.XAxisDateTimeMode then begin
    if Length(Options.DateTimeFormat)=0 then
      str := DateTimeToStr( FData.GetTimestamp(FMouseValue))
    else
      str := FormatDateTime( Options.DateTimeFormat, FData.GetTimestamp(FMouseValue) );

    FMouseDownHintStrs.Add( str );
  end else if Options.XLegends.Count > FMouseValue then
    FMouseDownHintStrs.Add( Options.XLegends[FMouseValue] );

  for I := 0 to Options.PenCount- 1 do
  begin
    if Options.PenLegends.Count <= I then break; // Exception fixed. WP
    str := Options.PenLegends[I];
    Val := FData.Value[I, FMouseValue];
    if Length(str)=0 then
        str := IntToStr(I + 1);
    str := str + ' : ';
    if IsNan(Val) then
      str := str + ' n/a '
    else begin
      str := str + FloatToStrF(Val, ffFixed, REALPREC, 3);
      str := str + ' ' + Options.PenUnit[I];
    end;
   
   FMouseDownHintStrs.Add(str);
{$ifdef DEBUGINFO_ON}
   OutputDebugString(PChar('TJvChart.AutoHint: '+str));
{$endif}
  end;
end;




         (* orphaned
         
            {We will show some Double values...}
    if FMousePen = 0 then
    begin
      {show all values in the Pen...}
      nLineCount := Options.PenCount;
      nHeight := nLineH * (nLineCount + 2);
      if Options.XLegends.Count > FMouseValue then
        strMessage1 := Options.XLegends[FMouseValue]
      else
        strMessage1 := '';
      strMessage2 := '-';
      if nWidth < ChartCanvas.TextWidth(strMessage1) then
        nWidth := ChartCanvas.TextWidth(strMessage1);
    end
    else
    begin
      nLineCount := 1;
      nHeight := nLineH * (nLineCount + 2);
      strMessage1 := Options.XLegends[FMouseValue];
      if nWidth < ChartCanvas.TextWidth(strMessage1) then
        nWidth := ChartCanvas.TextWidth(strMessage1);
      if FMousePen > 0 then
        strMessage2 := Options.PenLegends[FMousePen];
      if ChartCanvas.TextWidth(strMessage2) > nWidth then
        nWidth := ChartCanvas.TextWidth(strMessage2);
      strMessage3 := FloatToStrF(FData.Value[FMousePen, FMouseValue], ffFixed, REALPREC, 3);
    end;

         *)


{ ShowMouseMessage can invoke an OnChartClick event, and/or
  shows hint boxes, etc. }
procedure TJvChart.ShowMouseMessage(X, Y : Integer);
var
  nWidth: Integer;
  nHeight: Integer;
  nLineH: Integer;
  nLineCount: Integer;
  I: Integer;

  strWidth,strHeight: Integer;
begin
    // scan and set nWidth,nLineH
    nWidth := 100; // minimum 100 pixel hint box width.
    nLineH := 8; // minimum 8 pixel line height for hints.
    nLineCount := FMouseDownHintStrs.Count;

    for I := 0 to nLineCount-1 do begin
        strWidth := ChartCanvas.TextWidth(FMouseDownHintStrs[I]);
        if strWidth > nWidth then
            nWidth := strWidth;
        strHeight := ChartCanvas.TextHeight(FMouseDownHintStrs[I]);
        if (strHeight > nLineH ) then
            nLineH  := strHeight;
    end;

    // bump height of text in hint box,
    // leaving a little extra pixel space between rows.
    nLineH := Round(nLineH * 1.07)+1;

    {RsNoValuesHere}
    if (FMouseDownHintStrs.Count=0) then
    begin
       strWidth := ChartCanvas.TextWidth(RsNoValuesHere);
       if strWidth > nWidth then
            nWidth := strWidth;
      MyColorRectangle(-2, X + 3, Y + 3, X + nWidth + 3 + 5, Y + nLineH + 3);
      MyColorRectangle(-1, X, Y, X + nWidth + 5, Y + nLineH);
      Canvas.Font.Color := Self.Font.Color;
      MyLeftTextOut(X + 2, Y, RsNoValuesHere );
      FMouseLegend := True;
      exit;
    end;



    // Get hint box height/width, size to contents:
    nWidth := nWidth + 25;
    nHeight := (nLineH * (nLineCount))+8;

    // keep hint from clipping at bottom and right.
    if (Y+nHeight) > Self.Height then
       Y := (Self.Height -nHeight);
    if (X+nWidth) > Self.Width then
       X := (Self.Width -nWidth);

    // Draw hint box:
    MyColorRectangle(-1, X + 3, Y + 3, X + nWidth + 3, Y + nHeight + 3);
    MyColorRectangle(-2, X, Y, X + nWidth, Y + nHeight);

    //MyLeftTextOut( X + 3, Y + 3, 'Foo');

    // Draw text inside the hint box:
    Canvas.Font.Color := Self.Font.Color;
    //Canvas.Font.Style :=

        if FMouseDownHintBold then begin
            Canvas.Font.Style := [fsBold];
        end;
    
    for I := 0 to nLineCount-1 do
    begin
      if (I = 1) and FMouseDownHintBold then
         Canvas.Font.Style := [];

      MyLeftTextOut(X + 2, 4+Y+(I*nLineH), FMouseDownHintStrs[I] ); // draw text for each line.
    end;

    FMouseLegend := True;

  Invalidate;
   //ResizeChartCanvas;
end;

{***************************************************************************}
{ PIE FUNCTIONS AND PROCEDURES                                              }
{***************************************************************************}

procedure TJvChart.GraphPieChart(nPen: Integer);
var
  nSize: Integer;
  I: Integer;
  nLast: Integer;
  nXExtra: Integer;
  nSum: Double;
  n100Sum: Double;
  nP: Double;
begin
  ClearScreen;

   {Main Header}
  MyHeader(Options.Title);
  MyPieLegend(nPen);
  if Options.XEnd < Options.YEnd then
  begin
    nSize := Options.XEnd;
    nXExtra := 0;
  end
  else
  begin
    nSize := Options.YEnd;
    nXExtra := Round((Options.XEnd - Options.YEnd) / 2);
  end;
   {Count total sum...}
  n100Sum := 0;
  for I := 1 to MAX_VALUES do
    n100Sum := n100Sum + FData.Value[nPen, I];
   {Show background pie....}
  SetRectangleColor(-3); {black...}
  MyPiePercentage(Options.XStartOffset + nXExtra + 2,
    Options.YStartOffset + 2,
    nSize, 100);
   {Show pie if not zero...}
  if n100Sum <> 0 then
  begin
    nSum := n100Sum;
    nLast := Options.XValueCount + 1;
    if nLast > MAX_VALUES then
      nLast := MAX_VALUES;
    for I := nLast downto 2 do
    begin
      nSum := nSum - FData.Value[nPen, I];
      nP := 100 * (nSum / n100Sum);
      SetRectangleColor(I - 1);
      MyPiePercentage(Options.XStartOffset + nXExtra,
        Options.YStartOffset,
        nSize, nP);
    end;
  end;
end;

procedure TJvChart.MyPiePercentage(X1, Y1, W: Longint; nPercentage: Double);
var
  nOriginX, nOriginY: Longint;
  nGrade: Double;
  nStartGrade: Double;
  x, y: Double;
  nLen: Double;
begin
  nOriginX := Round((W - 1.01) / 2) + X1;
  nOriginY := Round((W - 1.01) / 2) + Y1;
  nGrade := (nPercentage / 100) * 2 * Pi;
  nStartGrade := (2 / 8) * 2 * Pi;
  nLen := Round((W - 1) / 2);
  x := Cos(nStartGrade + nGrade) * nLen;
  y := Sin(nStartGrade + nGrade) * nLen;
  MyPie(X1, Y1, X1 + W, Y1 + W,
    nOriginX, Y1, nOriginX + Round(x), nOriginY - Round(y));
end;

procedure TJvChart.MyPieLegend(nPen: Integer);
var
  I: Integer;
  nTextHeight: Longint;
{   nChars      : Integer;}// not used (ahuser)
  xLegendStr: string;
begin
   {Count how many characters to show in the separate legend}
{   nChars := Round(Options.LegendWidth / ChartCanvas.TextWidth('1'));}// not used (ahuser)
   {Decrease the value due to the color box shown}
{   if (nChars>4) then nChars := nChars-4;}// not used (ahuser)

  MySmallGraphFont;
  nTextHeight := Round(CanvasMaxTextHeight(ChartCanvas) * 1.2);


  // Pie Chart Right Side Legend.
  if Options.Legend = clChartLegendRight then
  begin
    MyColorRectangle(0,
      Options.XStartOffset + Options.XEnd + 6,
      Options.YStartOffset + 1 * nTextHeight + 6 + 4,
      Options.XStartOffset + Options.XEnd + Options.LegendWidth + 6,
      Options.YStartOffset + (Options.XValueCount + 1) * nTextHeight + 6 + 4);
    MyColorRectangle(-1,
      Options.XStartOffset + Options.XEnd + 3,
      Options.YStartOffset + 1 * nTextHeight + 3 + 4,
      Options.XStartOffset + Options.XEnd + Options.LegendWidth + 3,
      Options.YStartOffset + (Options.XValueCount + 1) * nTextHeight + 3 + 4);
    for I := 1 to Options.XValueCount do
    begin
      DrawPenColorBox(I, ChartCanvas.TextWidth('12') - 2, nTextHeight - 4,
        Options.XStartOffset + Options.XEnd + 7,
        Options.YStartOffset + I * nTextHeight + 9);
      SetFontColor(-3);
      if I - 1 < Options.XLegends.Count then
        xLegendStr := Options.XLegends[I - 1]
      else
        xLegendStr := IntToStr(I);
      MyLeftTextOut(Options.XStartOffset + Options.XEnd + 7 + ChartCanvas.TextWidth('12'),
        Options.YStartOffset + I * nTextHeight + 7,
        xLegendStr);
    end;
  end;
end;

function TJvChart.MyPt(AX, AY: Integer): TPoint;
begin
  with Result do
  begin
    X := AX;
    Y := AY;
  end;
end;

// Used in line charting as a Marker kind:
procedure TJvChart.PlotSquare(x, y: Integer);
begin
   MyPolygon([MyPt(x - Options.MarkerSize, y - Options.MarkerSize),
              MyPt(x + Options.MarkerSize, y - Options.MarkerSize),
              MyPt(x + Options.MarkerSize, y + Options.MarkerSize),
              MyPt(x - Options.MarkerSize, y + Options.MarkerSize)]);
end;


// Used in line charting as a Marker kind:
procedure TJvChart.PlotDiamond(x, y: Integer);
begin
  MyPolygon([MyPt(x, y - Options.MarkerSize),
    MyPt(x + Options.MarkerSize, y),
      MyPt(x, y + Options.MarkerSize),
      MyPt(x - Options.MarkerSize, y)]);
end;

// Used in line charting as a Marker kind:
procedure TJvChart.PlotCircle(x, y: Integer);
begin
  ChartCanvas.Pen.Style := psSolid;
  ChartCanvas.Ellipse( x-Options.MarkerSize,
                      y-Options.MarkerSize,
                      x+Options.MarkerSize,
                      y+Options.MarkerSize ); // Marker Circle radius 3.
end;

// Used in line charting as a Marker kind:
procedure TJvChart.PlotCross(x, y: Integer);
begin
   MyDrawLine(x - Options.MarkerSize, y, x + Options.MarkerSize, y);
   MyDrawLine(x, y - Options.MarkerSize, x, y + Options.MarkerSize);
end;

procedure TJvChart.ClearScreen;
begin
   {Clear screen}
  SetLineColor(-1);
  // Fishy:
  MyColorRectangle(-1,
    0,
    0,
    // XXX The point here is to exceed the edges, wipe it all, thus the 3* and 5* multipliers.
    (3 * Options.XStartOffset + Options.XEnd + Options.LegendWidth),
    (5 * Options.YStartOffset + Options.YEnd));
  SetRectangleColor(-3);
  SetLineColor(-3);
end;

{NEW chart type!!!}

procedure TJvChart.GraphDeltaAverage;
var
  XPixelGap: Longint;
  YPixelGap: Longint;
  xOrigin: Longint;
  yOrigin: Longint;
  I, J: Longint;
  TempYorigin: Longint;
begin
   {new type of chart...}
  ClearScreen;

   {Check graph values and correct if wrong. Actually not needed if there are no bugs}
//   if (Options.PrimaryYAxis.YDivisions>MAX_Y_LEGENDS) then
//       Options.PrimaryYAxis.YDivisions := MAX_Y_LEGENDS;
  if Options.PrimaryYAxis.YDivisions = 0 then
    Options.PrimaryYAxis.YDivisions := 1;
  if Options.XValueCount > MAX_VALUES then
    Options.XValueCount := MAX_VALUES;
  if Options.XValueCount = 0 then
    Options.XValueCount := 1;
  if Options.PenCount > MAX_PEN then
    Options.PenCount := MAX_PEN;
//  if Options.PrimaryYAxis.YGap = 0 then
//    Options.PrimaryYAxis.YGap := 1;

  XPixelGap := Round((Options.YEnd - Options.YStartOffset) /
    (Options.XValueCount));
  YPixelGap := Round((Options.XEnd - Options.XStartOffset) /
    (Options.PrimaryYAxis.YDivisions + 1)); // SPECIALIZED.

  TempYorigin := Options.YOrigin;
  Options.YOrigin := Options.PrimaryYAxis.YDivisions div 2;

  yOrigin := Options.XStartOffset + (YPixelGap * Options.YOrigin);
  xOrigin := Options.YStartOffset;

   {Create texts for y-axis}
//   Options.PrimaryYAxis.YLegends.Clear;
//   for I := 0 to MAX_Y_LEGENDS-1 do
  //    Options.PrimaryYAxis.YLegends.Add( IntToStr(Round(((I-1)-Options.YOrigin)*Options.PrimaryYAxis.YGap)) );

   {Y-axis legends and lines...}
  MyAxisFont;
  for I := 1 to (Options.PrimaryYAxis.YDivisions + 1) do
  begin
    if I >= Options.PrimaryYAxis.YLegends.Count then
      exit;
    MyLeftTextOut(yOrigin + (YPixelGap * ((I - 1) - Options.YOrigin)),
      xOrigin + XPixelGap * Options.XValueCount + 2,
      Options.PrimaryYAxis.YLegends[I]);
    MyDrawDotLine(yOrigin - (YPixelGap * ((I - 1) - Options.YOrigin)),
      xOrigin,
      yOrigin - (YPixelGap * ((I - 1) - Options.YOrigin)),
      xOrigin + (XPixelGap * (Options.XValueCount))
      );
  end;

   {Draw Y-axis}
  ChartCanvas.MoveTo(Options.XStartOffset, xOrigin);
  MyAxisLineTo(Options.XEnd, xOrigin);
   {Draw second y-axis}
  ChartCanvas.MoveTo(Options.XStartOffset, xOrigin + XPixelGap * Options.XValueCount + 1);
  MyAxisLineTo(Options.XEnd, xOrigin + XPixelGap * Options.XValueCount + 1);
   {Draw X-axis}
  ChartCanvas.MoveTo(yOrigin, xOrigin);
  MyAxisLineTo(yOrigin, xOrigin + XPixelGap * Options.XValueCount + 1);

   {X-axis legends...}
  GraphXAxisLegend;

   {Main Header}
  MyHeader(Options.Title);

   {X axis header}
  MyXHeader(Options.XAxisHeader);


    // Now draw the delta average...
  for I := 0 to Options.PenCount - 1 do
    for J := 0 to Options.XValueCount - 1 do
      if Options.PenCount = 1 then
        MyColorRectangle(I,
          yOrigin,
          xOrigin + J * XPixelGap + (I) * Round(XPixelGap / (Options.PenCount + 0.1)) - XPixelGap,
          yOrigin + Round(((FData.Value[I, J] - Options.AverageValue[J]) /
          Options.PrimaryYAxis.YGap) * YPixelGap),
          xOrigin + J * XPixelGap + (I + 1) * Round(XPixelGap / (Options.PenCount + 0.1)) - XPixelGap)
      else
        MyColorRectangle(I,
          yOrigin,
          xOrigin + J * XPixelGap + (I) * Round(XPixelGap / (Options.PenCount + 0.5)) - XPixelGap,
          yOrigin + Round(((FData.Value[I, J] - Options.AverageValue[J]) /
          Options.PrimaryYAxis.YGap) * YPixelGap),
          xOrigin + J * XPixelGap + (I + 1) * Round(XPixelGap / (Options.PenCount + 0.5)) - XPixelGap);
  Options.YOrigin := TempYorigin;
end;

{***************************************************************************}
{ Device depended functions for the rest of this module...check for printer }
{ or check for metafile output!                                             }
{***************************************************************************}

{$IFDEF VCL}
{ !!warning: uses Win32 only font-handle stuff!!}
procedure TJvChart.MakeVerticalFont;
begin
  if Ord(FYFontHandle) <> 0 then
    DeleteObject(FYFontHandle); // delete old object
  // Clear the contents of FLogFont
  FillChar(FYLogFont, SizeOf(TLogFont), 0);
  // Set the TLOGFONT's fields - Win32 Logical Font Details.
  with FYLogFont do
  begin
    lfHeight := Abs(Font.Height) + 2;
    lfWidth := 0; //Font.Width;
    lfEscapement := 900; // 90 degree vertical rotation
    lfOrientation := 900; // not used.
    lfWeight := FW_BOLD; //FW_HEAVY; // bold, etc
    lfItalic := 1; // no
    lfUnderline := 0; // no
    lfStrikeOut := 0; // no
    lfCharSet := ANSI_CHARSET; // or DEFAULT_CHARSET
    lfOutPrecision := OUT_TT_ONLY_PRECIS; //Require TrueType!
      // OUT_DEFAULT_PRECIS;
      // OUT_STRING_PRECIS, OUT_CHARACTER_PRECIS, OUT_STROKE_PRECIS,
      // OUT_TT_PRECIS, OUT_DEVICE_PRECIS, OUT_RASTER_PRECIS,
      // OUT_TT_ONLY_PRECIS

    lfClipPrecision := CLIP_DEFAULT_PRECIS;
    lfQuality := DEFAULT_QUALITY;
    lfPitchAndFamily := DEFAULT_PITCH or FF_DONTCARE;
    StrPCopy(lfFaceName, Font.Name);
  end;

  // Retrieve the requested font
  FYFontHandle := CreateFontIndirect(FYLogFont);
  Assert(Ord(FYFontHandle) <> 0);
  // Assign to the Font.Handle
  //Font.Handle := FYFont; // XXX DEBUG
  //pbxFont.Refresh;
  FYFont := TFont.Create;
  FYFont.Assign(Font);
  FYFont.Color := Options.AxisFont.Color;
  FYFont.Handle := FYFontHandle;
end;
{$ENDIF VCL}

procedure TJvChart.MyHeader(strText: string);
{var
//   LogFont           : TLogFont;
   hMetaFileFont     : HFont;
   SaveOldFileFont   : THandle;
   OldColor          : TColorRef;}// not used (ahuser)
begin
  MyHeaderFont;
  MyCenterTextOut(Options.XStartOffset + Round(Options.XEnd / 2),
    Options.YStartOffset - (MyTextHeight(strText) + 2),
    strText);
  MyAxisFont;
end;

procedure TJvChart.MySmallGraphFont;
begin
  ChartCanvas.Brush.Color := clWhite;
  ChartCanvas.Font.Assign(Options.LegendFont);
end;

procedure TJvChart.MyAxisFont;
begin
  ChartCanvas.Brush.Color := clWhite;
  ChartCanvas.Font.Assign(Options.AxisFont);
end;

{$IFDEF VCL}
procedure TJvChart.MyGraphVertFont; { !!warning: uses Win32 only font-handle stuff!!}
begin
  if Ord(FYFontHandle) = 0 then
    MakeVerticalFont;
  ChartCanvas.Font.Assign(FYFont); //Handle := FYFontHnd;
  if not PrintInSession then
    Assert(ChartCanvas.Font.Handle = FYFontHandle);
end;
{$ENDIF VCL}

procedure TJvChart.MyHeaderFont;
begin
  ChartCanvas.Brush.Color := clWhite;
  ChartCanvas.Font.Assign(Options.HeaderFont);
end;

procedure TJvChart.MyPenLineTo(X, Y: Integer);
begin
  ChartCanvas.Pen.Width := Options.PenLineWidth;
  ChartCanvas.LineTo(X, Y);
  ChartCanvas.Pen.Width := 1;
end;

procedure TJvChart.MyAxisLineTo(X, Y: Integer);
begin
  ChartCanvas.Pen.Width := Options.AxisLineWidth;
  ChartCanvas.LineTo(X, Y);
  ChartCanvas.Pen.Width := 1;
end;

function TJvChart.MyTextHeight(strText: string): Longint;
begin
  Result := ChartCanvas.TextHeight(strText);
end;

{ Text Left Aligned to X,Y boundary }
procedure TJvChart.MyLeftTextOut(X, Y: Integer; const Text: string);
begin
  ChartCanvas.TextOut(X, Y + 1, Text);
end;

procedure TJvChart.MyCenterTextOut(X, Y: Integer; const Text: string);
begin
  ChartCanvas.TextOut(X - Round(ChartCanvas.TextWidth(Text) / 2), Y + 1, Text);
end;

procedure TJvChart.MyRightTextOut(X, Y: Integer; const Text: string);
begin
  ChartCanvas.TextOut(X - ChartCanvas.TextWidth(Text),
    Y - Round(ChartCanvas.TextHeight(Text) / 2), Text);
end;

procedure TJvChart.MyRectangle(X, Y, X2, Y2: Integer);
begin
  ChartCanvas.Rectangle(X, Y, X2, Y2);
end;

(*Procedure TJvChart.MyShadowRectangle(Pen : Integer; X, Y, X2, Y2: Integer);
begin
  SetRectangleColor(Shadow);
  Canvas.Rectangle(X, Y, X2, Y2);
end;*)

procedure TJvChart.MyColorRectangle(Pen: Integer; X, Y, X2, Y2: Integer);
begin
  SetRectangleColor(Pen);
  //OutputDebugString(PChar('MyColorRectangle X='+IntToStr(X)+'  Y='+IntToStr(Y)+ '  X2='+IntToStr(X2)+ '  Y2='+IntToStr(Y2) ));
  ChartCanvas.Rectangle(X,  Y, X2, Y2);
end;

procedure TJvChart.MyPie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Longint);
begin
  ChartCanvas.Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4);
end;

{Procedure TJvChart.MyArc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
begin
  ChartCanvas.Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4);
end;}// not used (ahuser)

procedure TJvChart.MyPolygon(Points: array of TPoint);
begin
  ChartCanvas.Polygon(Points);
end;

{Procedure TJvChart.MyEllipse(X1, Y1, X2, Y2: Integer);
begin
  ChartCanvas.Ellipse(X1, Y1, X2, Y2);
end;}

procedure TJvChart.MyDrawLine(X1, Y1, X2, Y2: Integer);
begin
   ChartCanvas.MoveTo(X1, Y1);
   ChartCanvas.LineTo(X2, Y2);
end;

procedure TJvChart.MyDrawAxisMark(X1, Y1, X2, Y2: Integer);
begin
  SetSolidLines;
  ChartCanvas.Pen.Width := 1; // always width 1
  ChartCanvas.MoveTo(X1, Y1);
  ChartCanvas.LineTo(X2, Y2);
end;

procedure TJvChart.MyDrawDotLine(X1, Y1, X2, Y2: Integer);
begin
  SetDotLines;
  ChartCanvas.MoveTo(X1, Y1);
  ChartCanvas.LineTo(X2, Y2);
  SetSolidLines;
end;

{ (rom) not used
function TJvChart.GetDefaultColorString(nIndex: Integer): string;
begin
  if nIndex <= 10 then
    case nIndex of
      -2:
        Result := 'clWhite'; // MouseDownBox
      -1:
        Result := 'clWhite';
      0:
        Result := 'clBlack';
      1:
        Result := 'clLime';
      2:
        Result := 'clBlue';
      3:
        Result := 'clRed';
      4:
        Result := 'clGreen';
      5:
        Result := 'clMaroon';
      6:
        Result := 'clOlive';
      7:
        Result := 'clSilver';
      8:
        Result := 'clTeal';
      9:
        Result := 'clBlack';
      10:
        Result := 'clAqua';
    end
  else
    Result := '$00888888';
end;
}

procedure TJvChart.SetFontColor(Pen: Integer);
begin
  ChartCanvas.Font.Color := Options.PenColor[Pen];
end;

procedure TJvChart.SetRectangleColor(Pen: Integer);
begin
  ChartCanvas.Brush.Color := Options.PenColor[Pen];
end;

procedure TJvChart.SetLineColor(Pen: Integer);
begin
  ChartCanvas.Pen.Color := Options.PenColor[Pen];
end;

procedure TJvChart.SetDotLines;
begin
  ChartCanvas.Pen.Style := psDot;
end;

procedure TJvChart.SetSolidLines;
begin
  ChartCanvas.Pen.Style := psSolid;
end;

procedure TJvChart.GraphToClipboard;
begin
   {This works with bitmaps at least...how to do it as a metafile?}
  Clipboard.Assign(FPicture);
end;

{ PivotData: Pivot Data in Table. Formerly ChangeXValuesWithPen }

procedure TJvChart.PivotData;
var
  I, J: Integer;
  pencount, xvaluecount: Integer;
  TempData: TJvChartData;
  TempStrings: TStringList;
begin
  TempData := TJvChartData.Create;
  pencount := Options.PenCount;
  xvaluecount := Options.XValueCount;
  try
       {Move data to temp }
    for I := 0 to pencount - 1 do
      for J := 0 to xvaluecount - 1 do
        TempData.Value[I, J] := FData.Value[I, J];
    FData.Clear;
       {copy back, pivot X/Y axis }
    for I := 0 to pencount - 1 do
      for J := 0 to xvaluecount - 1 do
        TempData.Value[I, J] := FData.Value[J, I];

       {swap labels}
    TempStrings := Options.FXLegends;
    Options.FXLegends := Options.FPenLegends;
    Options.FPenLegends := TempStrings;

    Options.XValueCount := pencount;
    Options.PenCount := xvaluecount;

       {recalc average}
    CountGraphAverage;
    PlotGraph;
  finally
    TempData.Free;
  end;
end;

end.

