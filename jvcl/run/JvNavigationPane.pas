{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvNavigationPane.PAS, released on 2004-03-28.

The Initial Developer of the Original Code is Peter Thornqvist <peter3 at sourceforge dot net>
Portions created by Peter Thornqvist are Copyright (C) 2004 Peter Thornqvist.
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$
{$I jvcl.inc}

unit JvNavigationPane;

interface
uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Menus, ExtCtrls, ImgList,
  JvButton, JvPageList, JvComponent;

type
  TJvCustomNavigationPane = class;
  TJvNavIconButton = class;
  TJvNavStyleLink = class;
  TJvNavPaneStyleManager = class;

  TJvNavPanelHeader = class(TJvCustomControl)
  private
    FColorFrom: TColor;
    FColorTo: TColor;
    FImages: TCustomImageList;
    FImageIndex: TImageIndex;
    FChangeLink: TChangeLink;
    FStyleManager: TJvNavPaneStyleManager;
    FStyleLink: TJvNavStyleLink;
    procedure SetColorFrom(const Value: TColor);
    procedure SetColorTo(const Value: TColor);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetImages(const Value: TCustomImageList);
    procedure DoImagesChange(Sender: TObject);
    procedure SetStyleManager(const Value: TJvNavPaneStyleManager);
    procedure DoStyleChange(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure TextChanged; override;
    procedure Paint; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Caption;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;

    property ColorFrom: TColor read FColorFrom write SetColorFrom default $D68652;
    property ColorTo: TColor read FColorTo write SetColorTo default $944110;
    property Images: TCustomImageList read FImages write SetImages;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property StyleManager: TJvNavPaneStyleManager read FStyleManager write SetStyleManager;
    property Height default 27;
    property Width default 225;

    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TJvNavPanelDivider = class(TSplitter)
  private
    FColorFrom: TColor;
    FColorTo: TColor;
    FFrameColor: TColor;
    FStyleManager: TJvNavPaneStyleManager;
    FStyleLink: TJvNavStyleLink;
    procedure SetColorFrom(const Value: TColor);
    procedure SetColorTo(const Value: TColor);
    procedure SetFrameColor(const Value: TColor);
    procedure SetStyleManager(const Value: TJvNavPaneStyleManager);
    procedure DoStyleChange(Sender: TObject);
  protected
    procedure Paint; override;
    procedure CMTextchanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    // NB! Color is published but not used
    property Align default alNone;
    property Anchors;
    property AutoSnap default False;
    property Caption;
    property ColorFrom: TColor read FColorFrom write SetColorFrom default $FFE7CE;
    property ColorTo: TColor read FColorTo write SetColorTo default $E7A67B;
    property Constraints;
    property Cursor default crSizeNS;
    property Enabled;
    property Font;
    property FrameColor: TColor read FFrameColor write SetFrameColor default $943000;
    property Height default 19;
    property ResizeStyle default rsUpdate;
    property StyleManager: TJvNavPaneStyleManager read FStyleManager write SetStyleManager;
    property Width default 125;
  end;

  TJvOutlookSplitter = class(TSplitter)
  private
    FColorTo: TColor;
    FColorFrom: TColor;
    FStyleManager: TJvNavPaneStyleManager;
    FStyleLink: TJvNavStyleLink;
    procedure SetColorFrom(const Value: TColor);
    procedure SetColorTo(const Value: TColor);
    procedure SetStyleManager(const Value: TJvNavPaneStyleManager);
    procedure DoStyleChange(Sender: TObject);
  protected
    procedure Paint; override;
    procedure CMEnabledchanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    // NB! Color is published but not used
    property Align default alBottom;
    property AutoSnap default False;
    property ResizeStyle default rsUpdate;
    property ColorFrom: TColor read FColorFrom write SetColorFrom default $D68652;
    property ColorTo: TColor read FColorTo write SetColorTo default $944110;
    property Height default 7;
    property Cursor default crSizeNS;
    property Enabled;
    property StyleManager: TJvNavPaneStyleManager read FStyleManager write SetStyleManager;
  end;

  TJvNavPanelColors = class(TPersistent)
  private
    FButtonColorTo: TColor;
    FButtonColorFrom: TColor;
    FFrameColor: TColor;
    FButtonHotColorFrom: TColor;
    FButtonHotColorTo: TColor;
    FButtonSelectedColorFrom: TColor;
    FButtonSelectedColorTo: TColor;
    FOnChange: TNotifyEvent;
    FSplitterColorFrom: TColor;
    FSplitterColorTo: TColor;
    FDividerColorTo: TColor;
    FDividerColorFrom: TColor;
    FHeaderColorFrom: TColor;
    FHeaderColorTo: TColor;
    procedure SetButtonColorFrom(const Value: TColor);
    procedure SetButtonColorTo(const Value: TColor);
    procedure SetFrameColor(const Value: TColor);
    procedure SetButtonHotColorFrom(const Value: TColor);
    procedure SetButtonHotColorTo(const Value: TColor);
    procedure SetButtonSelectedColorFrom(const Value: TColor);
    procedure SetButtonSelectedColorTo(const Value: TColor);
    procedure SetSplitterColorFrom(const Value: TColor);
    procedure SetSplitterColorTo(const Value: TColor);
    procedure SetDividerColorFrom(const Value: TColor);
    procedure SetDividerColorTo(const Value: TColor);
    procedure SetHeaderColorFrom(const Value: TColor);
    procedure SetHeaderColorTo(const Value: TColor);
  protected
    procedure Change;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property SplitterColorFrom: TColor read FSplitterColorFrom write SetSplitterColorFrom;
    property SplitterColorTo: TColor read FSplitterColorTo write SetSplitterColorTo;
    property DividerColorFrom: TColor read FDividerColorFrom write SetDividerColorFrom;
    property DividerColorTo: TColor read FDividerColorTo write SetDividerColorTo;
    property HeaderColorFrom: TColor read FHeaderColorFrom write SetHeaderColorFrom;
    property HeaderColorTo: TColor read FHeaderColorTo write SetHeaderColorTo;
    property ButtonColorFrom: TColor read FButtonColorFrom write SetButtonColorFrom;
    property ButtonColorTo: TColor read FButtonColorTo write SetButtonColorTo;
    property ButtonHotColorFrom: TColor read FButtonHotColorFrom write SetButtonHotColorFrom;
    property ButtonHotColorTo: TColor read FButtonHotColorTo write SetButtonHotColorTo;
    property ButtonSelectedColorFrom: TColor read FButtonSelectedColorFrom write SetButtonSelectedColorFrom;
    property ButtonSelectedColorTo: TColor read FButtonSelectedColorTo write SetButtonSelectedColorTo;
    property FrameColor: TColor read FFrameColor write SetFrameColor;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TJvIconPanel = class(TJvCustomControl)
  private
    FDropButton: TJvNavIconButton;
    FColors: TJvNavPanelColors;
    FStyleManager: TJvNavPaneStyleManager;
    FStyleLink: TJvNavStyleLink;
    procedure SetDropDownMenu(const Value: TPopupMenu);

    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    function GetDropDownMenu: TPopupMenu;
    procedure SetColors(const Value: TJvNavPanelColors);
    procedure SetStyleManager(const Value: TJvNavPaneStyleManager);
    procedure DoStyleChange(Sender: TObject);
  protected
    procedure DoColorsChange(Sender: TObject);
    procedure Paint; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Colors: TJvNavPanelColors read FColors write SetColors;
    property StyleManager: TJvNavPaneStyleManager read FStyleManager write SetStyleManager;
    property DropDownMenu: TPopupMenu read GetDropDownMenu write SetDropDownMenu;
  end;

  TJvNavIconButtonType = (nibDropDown, nibImage, nibDropArrow, nibClose);

  TJvNavIconButton = class(TJvCustomGraphicButton)
  private
    FChangeLink: TChangeLink;
    FImages: TCustomImageList;
    FImageIndex: TImageIndex;
    FButtonType: TJvNavIconButtonType;
    FColors: TJvNavPanelColors;
    FStyleManager: TJvNavPaneStyleManager;
    FStyleLink: TJvNavStyleLink;
    procedure SetImages(const Value: TCustomImageList);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure DoImagesChange(Sender: TObject);
    procedure SetButtonType(const Value: TJvNavIconButtonType);
    procedure SetColors(const Value: TJvNavPanelColors);
    procedure DoColorsChange(Sender: TObject);
    procedure SetStyleManager(const Value: TJvNavPaneStyleManager);
    procedure DoStyleChange(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Action;
    property Align;
    property AllowAllup;
    property Anchors;
    //    property Caption;
    property Constraints;
    property Down;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownMenu;
    property GroupIndex;
    property Enabled;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;

    property ButtonType: TJvNavIconButtonType read FButtonType write SetButtonType;
    property Colors: TJvNavPanelColors read FColors write SetColors;
    property Images: TCustomImageList read FImages write SetImages;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex;
    property StyleManager: TJvNavPaneStyleManager read FStyleManager write SetStyleManager;
    property Width default 22;
    property Height default 22;

    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TJvNavPanelButton = class(TJvCustomGraphicButton)
  private
    FImageIndex: TImageIndex;
    FImages: TCustomImageList;
    FColors: TJvNavPanelColors;
    FStyleManager: TJvNavPaneStyleManager;
    FStyleLink: TJvNavStyleLink;
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetColors(const Value: TJvNavPanelColors);
    procedure DoColorsChange(Sender: TObject);
    procedure SetStyleManager(const Value: TJvNavPaneStyleManager);
    procedure DoStyleChange(Sender: TObject);
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  protected
    procedure Paint; override;
    procedure TextChanged; override;
    procedure FontChanged; override;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Action;
    property Align;
    property AllowAllUp;
    property Anchors;
    property Caption;
    property Constraints;
    property Down;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property GroupIndex;

    property HotTrack;
    property HotTrackFont;
    property HotTrackFontOptions;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;

    property Width default 125;
    property Height default 28;

    property Colors: TJvNavPanelColors read FColors write SetColors;
    property StyleManager: TJvNavPaneStyleManager read FStyleManager write SetStyleManager;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex;
    property Images: TCustomImageList read FImages write SetImages;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TJvNavPanelPage = class(TJvCustomPage)
  private
    FNavPanel: TJvNavPanelButton;
    FIconButton: TJvNavIconButton;
    FOnClick: TNotifyEvent;
    FIconPanel: TJvIconPanel;
    FStyleManager: TJvNavPaneStyleManager;
    FStyleLink: TJvNavStyleLink;
    procedure SetCaption(const Value: TCaption);
    procedure SetIconic(const Value: boolean);
    procedure SetImageIndex(const Value: TImageIndex);
    function GetCaption: TCaption;
    function GetIconic: boolean;
    function GetImageIndex: TImageIndex;
    procedure DoButtonClick(Sender: TObject);
    function GetHint: string;
    procedure SetHint(const Value: string);

    procedure SetIconPanel(const Value: TJvIconPanel);
    function GetColors: TJvNavPanelColors;
    procedure SetColors(const Value: TJvNavPanelColors);
    procedure SetStyleManager(const Value: TJvNavPaneStyleManager);
    procedure DoStyleChange(Sender: TObject);
  protected
    procedure UpdatePageList;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetPageIndex(Value: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property NavPanel: TJvNavPanelButton read FNavPanel;
    property IconButton: TJvNavIconButton read FIconButton;
    property IconPanel: TJvIconPanel read FIconPanel write SetIconPanel;
    property Colors: TJvNavPanelColors read GetColors write SetColors;
    property StyleManager: TJvNavPaneStyleManager read FStyleManager write SetStyleManager;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property Color;
    property Caption: TCaption read GetCaption write SetCaption;
    property Iconic: boolean read GetIconic write SetIconic default False;
    property ImageIndex: TImageIndex read GetImageIndex write SetImageIndex default -1;
    property Hint: string read GetHint write SetHint;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TJvNavPaneToolPanel = class;

  TJvNavPaneToolButton = class(TCollectionItem)
  private
    FImageIndex: TImageIndex;
    FEnabled: boolean;
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetEnabled(const Value: boolean);
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(Collection: TCollection); override;

  published
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Enabled: boolean read FEnabled write SetEnabled default True;
  end;

  TJvNavPaneToolButtons = class(TOwnedCollection)
  private
    FPanel: TJvNavPaneToolPanel;
    function GetItem(Index: integer): TJvNavPaneToolButton;
    procedure SetItem(Index: integer; const Value: TJvNavPaneToolButton);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TJvNavPaneToolPanel);
    function Add: TJvNavPaneToolButton;
    procedure Assign(Source: TPersistent); override;
    property Items[Index: integer]: TJvNavPaneToolButton read GetItem write SetItem; default;
  end;

  TJvNavPaneToolButtonClick = procedure(Sender: TObject; Index: integer) of object;
  TJvNavPaneToolPanel = class(TJvCustomControl)
  private
    FStyleLink: TJvNavStyleLink;
    FChangeLink: TChangeLink;
    FStyleManager: TJvNavPaneStyleManager;
    FColorFrom: TColor;
    FColorTo: TColor;
    FButtonWidth: integer;
    FHeaderHeight: integer;
    FEdgeRounding: integer;
    FButtonHeight: integer;
    FButtonColor: TColor;
    FImages: TCustomImageList;
    FButtons: TJvNavPaneToolButtons;
    FRealButtons: TList;
    FOnButtonClick: TJvNavPaneToolButtonClick;
    FDropDown: TJvNavIconButton;
    FCloseButton: TJvNavIconButton;
    FOnClose: TNotifyEvent;
    FShowGrabber: boolean;
    procedure SetStyleManager(const Value: TJvNavPaneStyleManager);
    procedure SetColorFrom(const Value: TColor);
    procedure SetColorTo(const Value: TColor);
    procedure SetButtonColor(const Value: TColor);
    procedure SetButtonHeight(const Value: integer);
    procedure SetButtonWidth(const Value: integer);
    procedure SetEdgeRounding(const Value: integer);
    procedure SetHeaderHeight(const Value: integer);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetButtons(const Value: TJvNavPaneToolButtons);
    procedure DoStyleChange(Sender: TObject);
    procedure DoImagesChange(Sender: TObject);
    procedure ButtonsChanged;
    procedure InternalButtonClick(Sender: TObject);
    function GetCloseButton: boolean;
    function GetDropDownMenu: TPopupMenu;
    procedure SetCloseButton(const Value: boolean);
    procedure SetDropDownMenu(const Value: TPopupMenu);
    procedure DoCloseClick(Sender: TObject);
    procedure SetShowGrabber(const Value: boolean);
  protected
    procedure Paint; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure TextChanged; override;
    procedure FontChanged; override;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMNCPaint(var Message: TWMNCPaint); message WM_NCPAINT;
    property EdgeRounding: integer read FEdgeRounding write SetEdgeRounding default 9;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
  published
    property Align;
    property Anchors;
    property Caption;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;

    property Enabled;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Width default 185;
    property Height default 41;

    property Buttons: TJvNavPaneToolButtons read FButtons write SetButtons;
    property ButtonColor: TColor read FButtonColor write SetButtonColor default $C08000;
    property ButtonWidth: integer read FButtonWidth write SetButtonWidth default 30;
    property ButtonHeight: integer read FButtonHeight write SetButtonHeight default 21;
    property Color default clWindow;
    property CloseButton: boolean read GetCloseButton write SetCloseButton default True;
    property ColorFrom: TColor read FColorFrom write SetColorFrom default $FFF7CE;
    property ColorTo: TColor read FColorTo write SetColorTo default $E7A67B;
    property DropDownMenu: TPopupMenu read GetDropDownMenu write SetDropDownMenu;
    property HeaderHeight: integer read FHeaderHeight write SetHeaderHeight default 29;
    property Images: TCustomImageList read FImages write SetImages;
    property ParentColor default False;
    property ShowGrabber: boolean read FShowGrabber write SetShowGrabber default True;
    property StyleManager: TJvNavPaneStyleManager read FStyleManager write SetStyleManager;
    property OnButtonClick: TJvNavPaneToolButtonClick read FOnButtonClick write FOnButtonClick;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;

    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TJvCustomNavigationPane = class(TJvCustomPageList)
  private
    FIconPanel: TJvIconPanel;
    FSplitter: TJvOutlookSplitter;
    FLargeImages: TCustomImageList;
    FSmallImages: TCustomImageList;
    FColors: TJvNavPanelColors;
    FNavPanelFont: TFont;
    FResizable: boolean;
    FButtonWidth: integer;
    FButtonHeight: integer;
    FStyleManager: TJvNavPaneStyleManager;
    FStyleLink: TJvNavStyleLink;
    function GetDropDownMenu: TPopupMenu;
    function GetSmallImages: TCustomImageList;
    procedure SetDropDownMenu(const Value: TPopupMenu);
    procedure SetLargeImages(const Value: TCustomImageList);
    procedure SetSmallImages(const Value: TCustomImageList);
    function GetMaximizedCount: integer;
    procedure SetMaximizedCount(Value: integer);
    procedure HidePanel(Index: integer);
    procedure ShowPanel(Index: integer);
    procedure SetColors(const Value: TJvNavPanelColors);
    procedure SetResizable(const Value: boolean);
    function GetNavPage(Index: integer): TJvNavPanelPage;
    procedure WMNCPaint(var Message: TWMNCPaint); message WM_NCPAINT;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;

    procedure DoSplitterCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
    procedure DoColorsChange(Sender: TObject);
    procedure SetNavPanelFont(const Value: TFont);
    procedure DoNavPanelFontChange(Sender: TObject);
    function IsNavPanelFontStored: Boolean;
    procedure SetButtonHeight(const Value: integer);
    procedure SetButtonWidth(const Value: integer);
    procedure SetSplitterHeight(const Value: integer);
    function GetSplitterHeight: integer;
    procedure SetStyleManager(const Value: TJvNavPaneStyleManager);
    procedure DoStyleChange(Sender: TObject);
  protected
    procedure SetActivePage(Page: TJvCustomPage); override;
    procedure InsertPage(APage: TJvCustomPage); override;
    procedure RemovePage(APage: TJvCustomPage); override;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    function InternalGetPageClass: TJvCustomPageClass; override;
    property NavPages[Index: integer]: TJvNavPanelPage read GetNavPage;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdatePositions;
  protected
    property BorderWidth default 1;
    property ButtonHeight: integer read FButtonHeight write SetButtonHeight default 28;
    property ButtonWidth: integer read FButtonWidth write SetButtonWidth default 22;
    property NavPanelFont: TFont read FNavPanelFont write SetNavPanelFont stored IsNavPanelFontStored;
    property Color default clWindow;
    property Colors: TJvNavPanelColors read FColors write SetColors;
    property StyleManager: TJvNavPaneStyleManager read FStyleManager write SetStyleManager;
    property DropDownMenu: TPopupMenu read GetDropDownMenu write SetDropDownMenu;
    property LargeImages: TCustomImageList read FLargeImages write SetLargeImages;
    property MaximizedCount: integer read GetMaximizedCount write SetMaximizedCount;
    property ParentColor default False;
    property Resizable: boolean read FResizable write SetResizable default True;
    property SmallImages: TCustomImageList read GetSmallImages write SetSmallImages;
    property SplitterHeight: integer read GetSplitterHeight write SetSplitterHeight default 7;
  end;

  TJvNavigationPane = class(TJvCustomNavigationPane)
  public
    property NavPages;
  published
    property ActivePage;
    property Align;
    property Anchors;
    property BorderWidth;
    property ButtonHeight;
    property ButtonWidth;
    property Caption;
    property Color;
    property Colors;
    property StyleManager;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownMenu;
    property Enabled;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property SplitterHeight;
    property Visible;

    property LargeImages;
    property MaximizedCount;
    property NavPanelFont;
    property Resizable;
    property SmallImages;
  end;

  TJvNavStyleLink = class(TObject)
  private
    FSender: TObject;
    FOnChange: TNotifyEvent;
  public
    destructor Destroy; override;
    procedure Change; dynamic;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Sender: TObject read FSender write FSender;
  end;

  TJvNavPanelTheme = (nptStandard, nptXPBlue, nptXPSilver, nptXPOlive, nptCustom);
  TJvNavPaneStyleManager = class(TJvComponent)
  private
    FColors: TJvNavPanelColors;
    FTheme: TJvNavPanelTheme;
    FClients: TList;
    procedure SetColors(const Value: TJvNavPanelColors);
    procedure SetTheme(const Value: TJvNavPanelTheme);
    procedure DoColorsChange(Sender: TObject);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure RegisterChanges(Value: TJvNavStyleLink);
    procedure UnRegisterChanges(Value: TJvNavStyleLink);
  published
    property Theme: TJvNavPanelTheme read FTheme write SetTheme default nptStandard;
    property Colors: TJvNavPanelColors read FColors write SetColors;
    //    property Fonts; // TODO!!!
  end;

implementation
uses
  Forms, ActnList, JvJVCLUtils, JvJCLUtils;

type
  TObjectList = class(TList)
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  end;

procedure TObjectList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited;
  if Action = lnDeleted then
    TObject(Ptr).Free;
end;

{ TJvIconPanel }

constructor TJvIconPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls];
  FStyleLink := TJvNavStyleLink.Create;
  FStyleLink.OnChange := DoStyleChange;
  ControlStyle := ControlStyle + [csOpaque, csAcceptsControls];
  Height := 28;
  FDropButton := TJvNavIconButton.Create(Self);
  FDropButton.Visible := false;
  FDropButton.ButtonType := nibDropDown;
  FDropButton.GroupIndex := 0;
  FDropButton.Width := 22;
  FDropButton.Left := Width + 10;
  FDropButton.Align := alRight;
  FDropButton.Parent := self;
  FColors := TJvNavPanelColors.Create;
  FColors.OnChange := DoColorsChange;
end;

destructor TJvIconPanel.Destroy;
begin
  FStyleLink.Free;
  FColors.Free;
  inherited;
end;

procedure TJvIconPanel.DoColorsChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TJvIconPanel.DoStyleChange(Sender: TObject);
begin
  Colors := (Sender as TJvNavPaneStyleManager).Colors;
end;

function TJvIconPanel.GetDropDownMenu: TPopupMenu;
begin
  Result := FDropButton.DropDownMenu;
end;

procedure TJvIconPanel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = StyleManager then
      StyleManager := nil;
  end;
end;

procedure TJvIconPanel.Paint;
begin
  GradientFillRect(Canvas, ClientRect, Colors.ButtonColorFrom, Colors.ButtonColorTo, fdTopToBottom, 32);
  Canvas.Pen.Color := Colors.FrameColor;
  if Align = alBottom then
  begin
    Canvas.MoveTo(0, 0);
    Canvas.LineTo(Width + 1, 0);
  end
  else
  begin
    Canvas.MoveTo(0, ClientHeight - 1);
    Canvas.LineTo(Width + 1, ClientHeight - 1);
  end;
end;

procedure TJvIconPanel.SetColors(const Value: TJvNavPanelColors);
begin
  FColors.Assign(Value);
  FDropButton.Colors := Value;
end;

procedure TJvIconPanel.SetStyleManager(const Value: TJvNavPaneStyleManager);
var
  i: integer;
begin
  if FStyleManager <> Value then
  begin
    if FStyleManager <> nil then
      FStyleManager.UnRegisterChanges(FStyleLink);
    FStyleManager := Value;
    if FStyleManager <> nil then
    begin
      FStyleManager.RegisterChanges(FStyleLink);
      FStyleManager.FreeNotification(Self);
      Colors := FStyleManager.Colors;
    end;
  end;
  FDropButton.StyleManager := Value;
  for i := 0 to ControlCount - 1 do
    if Controls[i] is TJvNavIconButton then
      TJvNavIconButton(COntrols[i]).StyleManager := Value;
end;

procedure TJvIconPanel.SetDropDownMenu(const Value: TPopupMenu);
begin
  FDropButton.DropDownMenu := Value;
  FDropButton.Visible := Value <> nil;
end;

procedure TJvIconPanel.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

{ TJvCustomNavigationPane }

constructor TJvCustomNavigationPane.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls];
  FStyleLink := TJvNavStyleLink.Create;
  FStyleLink.OnChange := DoStyleChange;
  FButtonHeight := 28;
  FButtonWidth := 22;
  BorderWidth := 1;
  ParentColor := False;
  Color := clWindow;
  ControlStyle := ControlStyle + [csOpaque];
  FResizable := True;
  FColors := TJvNavPanelColors.Create;
  FColors.OnChange := DoColorsChange;
  FIconPanel := TJvIconPanel.Create(Self);
  FIconPanel.Parent := Self;
  FIconPanel.Align := alBottom;
  FNavPanelFont := TFont.Create;
  FNavPanelFont.Assign(Screen.IconFont);
  FNavPanelFont.Style := [fsBold];
  FNavPanelFont.OnChange := DoNavPanelFontChange;

  FSplitter := TJvOutlookSplitter.Create(Self);
  with FSplitter do
  begin
    ResizeStyle := rsNone;
    MinSize := 1;
    OnCanResize := DoSplitterCanResize;
    Parent := Self;
  end;
end;

destructor TJvCustomNavigationPane.Destroy;
begin
  FStyleLink.Free;
  FColors.Free;
  FNavPanelFont.Free;
  inherited Destroy;
end;

procedure TJvCustomNavigationPane.DoSplitterCanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
var
  ACount: integer;
begin
  ACount := MaximizedCount;
  if NewSize < ButtonHeight div 2 then
    MaximizedCount := ACount - 1
  else if NewSize > ButtonHeight + ButtonHeight div 2 then
    MaximizedCount := ACount + 1;
  NewSize := 0;
  Accept := False;
end;

function TJvCustomNavigationPane.GetDropDownMenu: TPopupMenu;
begin
  if FIconPanel <> nil then
    Result := FIconPanel.DropDownMenu
  else
    Result := nil;
end;

function TJvCustomNavigationPane.GetSmallImages: TCustomImageList;
begin
  Result := FSmallImages;
end;

function TJvCustomNavigationPane.GetMaximizedCount: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to PageCount - 1 do
    if not NavPages[i].Iconic then
      Inc(result);
end;

procedure TJvCustomNavigationPane.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = LargeImages then
      LargeImages := nil;
    if AComponent = SmallImages then
      SmallImages := nil;
    if (AComponent = StyleManager) then
      StyleManager := nil;
  end;
end;

procedure TJvCustomNavigationPane.SetDropDownMenu(const Value: TPopupMenu);
begin
  if FIconPanel <> nil then
    FIconPanel.DropDownMenu := Value;
end;

procedure TJvCustomNavigationPane.SetLargeImages(const Value: TCustomImageList);
var
  i: integer;
begin
  if FLargeImages <> Value then
  begin
    FLargeImages := Value;
    for i := 0 to PageCount - 1 do
      NavPages[i].NavPanel.Images := FLargeImages;
  end;
end;

procedure TJvCustomNavigationPane.SetSmallImages(const Value: TCustomImageList);
var
  i: integer;
begin
  if FSmallImages <> Value then
  begin
    FSmallImages := Value;
    for i := 0 to PageCount - 1 do
      NavPages[i].IconButton.Images := FSmallImages;
  end;
end;

procedure TJvCustomNavigationPane.HidePanel(Index: integer);
begin
  if (Index >= 0) and (Index < PageCount) then // don't hide the first panel
    NavPages[Index].Iconic := true;
end;

procedure TJvCustomNavigationPane.ShowPanel(Index: integer);
begin
  if (Index >= 0) and (Index < PageCount) then
    NavPages[Index].Iconic := false;
end;

procedure TJvCustomNavigationPane.SetMaximizedCount(Value: integer);
var
  i, ACount: integer;
begin
  ACount := MaximizedCount;
  if (Value < 0) then Value := 0;
  if (Value > PageCount) then Value := PageCount;
  if Value = MaximizedCount then Exit;
  while ACount > Value do
  begin
    HidePanel(ACount - 1);
    Dec(ACount);
  end;
  if Value > ACount then
    for i := Value downto ACount do
      ShowPanel(i - 1);
  UpdatePositions;
end;

procedure TJvCustomNavigationPane.WMNCPaint(var Message: TWMNCPaint);
var
  AColor: TColor;
begin
  AColor := Color;
  try
    Color := Colors.FrameColor;
    inherited;
  finally
    Color := AColor;
  end;
end;

procedure TJvCustomNavigationPane.UpdatePositions;
var
  i, X, Y: integer;
begin
  if (csDestroying in ComponentState) or (FIconPanel = nil) then Exit;
  DisableAlign;
  FIconPanel.DisableAlign;
  try
    Y := 0;
    X := 0;
    FSplitter.Top := Y;
    FIconPanel.FDropButton.Left := Width;
    FIconPanel.Top := Height - FIconPanel.Height;
    Inc(Y, FSplitter.Height);
    for i := 0 to PageCount - 1 do
    begin
      if NavPages[i].NavPanel = nil then Exit;
      if NavPages[i].Iconic then
      begin
        NavPages[i].IconButton.Left := X;
        Inc(X, NavPages[i].IconButton.Width);
      end
      else
      begin
        NavPages[i].NavPanel.Top := Y;
        Inc(Y, NavPages[i].NavPanel.Height);
      end;
      NavPages[i].Invalidate;
    end;
  finally
    EnableAlign;
    FIconPanel.EnableAlign;
  end;
  Invalidate;
end;

procedure TJvCustomNavigationPane.SetColors(const Value: TJvNavPanelColors);
begin
  FColors.Assign(Value);
end;

procedure TJvCustomNavigationPane.DoColorsChange(Sender: TObject);
var
  i: integer;
begin
  if FIconPanel <> nil then
    TJvIconPanel(FIconPanel).Colors := Colors;
  for i := 0 to PageCount - 1 do
  begin
    NavPages[i].NavPanel.Colors := Colors;
    NavPages[i].IconButton.Colors := Colors;
  end;
  FSplitter.ColorFrom := Colors.SplitterColorFrom;
  FSplitter.ColorTo := Colors.SplitterColorTo;
end;

procedure TJvCustomNavigationPane.Loaded;
begin
  inherited;
  UpdatePositions;
end;

procedure TJvCustomNavigationPane.SetResizable(const Value: boolean);
begin
  if FResizable <> Value then
  begin
    FResizable := Value;
    FSplitter.Enabled := FResizable;
  end;
end;

function TJvCustomNavigationPane.InternalGetPageClass: TJvCustomPageClass;
begin
  Result := TJvNavPanelPage;
end;

function TJvCustomNavigationPane.GetNavPage(Index: integer): TJvNavPanelPage;
begin
  Result := TJvNavPanelPage(Pages[Index]);
end;

procedure TJvCustomNavigationPane.InsertPage(APage: TJvCustomPage);
begin
  inherited InsertPage(APage);
  if APage <> nil then
  begin
    TJvNavPanelPage(APage).Top := FIconPanel.Top;
    if ActivePage = nil then
      ActivePage := APage;
  end;
  UpdatePositions;
end;

procedure TJvCustomNavigationPane.SetActivePage(Page: TJvCustomPage);
begin
  inherited;
  if (ActivePage <> nil) then
  begin
    TJvNavPanelPage(ActivePage).NavPanel.Down := True;
    TJvNavPanelPage(ActivePage).IconButton.Down := True;
    TJvNavPanelPage(ActivePage).NavPanel.Invalidate;
    TJvNavPanelPage(ActivePage).IconButton.Invalidate;
    ActivePage.Invalidate;
  end;
end;

procedure TJvCustomNavigationPane.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  if ActivePage = nil then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(ClientRect);
  end;
  Message.Result := 1;
end;

procedure TJvCustomNavigationPane.SetNavPanelFont(const Value: TFont);
begin
  FNavPanelFont.Assign(Value);
end;

function TJvCustomNavigationPane.IsNavPanelFontStored: Boolean;
var
  F: TFont;
begin
  F := Screen.IconFont;
  with FNavPanelFont do
    Result := (Name <> F.Name) or (Size <> F.Size) or (Style <> [fsBold])
      or (Color <> F.Color) or (Pitch <> F.Pitch) or (Charset <> F.CharSet);
end;

procedure TJvCustomNavigationPane.DoNavPanelFontChange(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to PageCount - 1 do
    NavPages[i].NavPanel.Font := FNavPanelFont;
end;

procedure TJvCustomNavigationPane.RemovePage(APage: TJvCustomPage);
begin
  inherited RemovePage(APage);
  Invalidate;
end;

procedure TJvCustomNavigationPane.SetButtonHeight(const Value: integer);
var
  i: integer;
begin
  if FButtonHeight <> Value then
  begin
    FButtonHeight := Value;
    for i := 0 to PageCount - 1 do
      NavPages[i].NavPanel.Height := FButtonHeight;
    FIconPanel.Height := FButtonHeight;
  end;
end;

procedure TJvCustomNavigationPane.SetButtonWidth(const Value: integer);
var
  i: integer;
begin
  if FButtonWidth <> Value then
  begin
    FButtonWidth := Value;
    for i := 0 to PageCount - 1 do
      NavPages[i].IconButton.Width := FButtonWidth;
    FIconPanel.FDropButton.Width := FButtonWidth;
  end;
end;

procedure TJvCustomNavigationPane.SetSplitterHeight(const Value: integer);
begin
  if FSplitter.Height <> Value then
    FSplitter.Height := Value;
end;

function TJvCustomNavigationPane.GetSplitterHeight: integer;
begin
  Result := FSplitter.Height;
end;

procedure TJvCustomNavigationPane.SetStyleManager(const Value: TJvNavPaneStyleManager);
var
  i: integer;
begin
  if FStyleManager <> Value then
  begin
    if FStyleManager <> nil then
      FStyleManager.UnRegisterChanges(FStyleLink);
    FStyleManager := Value;
    if FStyleManager <> nil then
    begin
      FStyleManager.RegisterChanges(FStyleLink);
      FStyleManager.FreeNotification(Self);
      Colors := FStyleManager.Colors;
    end;
    for i := 0 to PageCount - 1 do
      NavPages[i].StyleManager := Value;
    FSplitter.StyleManager := Value;
  end;
end;

procedure TJvCustomNavigationPane.DoStyleChange(Sender: TObject);
begin
  Colors := (Sender as TJvNavPaneStyleManager).Colors;
end;

{ TJvNavIconButton }

constructor TJvNavIconButton.Create(AOwner: TComponent);
begin
  inherited;
  FStyleLink := TJvNavStyleLink.Create;
  FStyleLink.OnChange := DoStyleChange;
  FColors := TJvNavPanelColors.Create;
  FColors.OnChange := DoColorsChange;
  FChangeLink := TChangeLink.Create;
  FChangeLink.OnChange := DoImagesChange;
  Width := 22;
  Height := 22;
  Font := Screen.IconFont;
  Font.Style := [fsBold];
end;

destructor TJvNavIconButton.Destroy;
begin
  FStyleLink.Free;
  FChangeLink.Free;
  FColors.Free;
  inherited;
end;

procedure TJvNavIconButton.DoColorsChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TJvNavIconButton.DoImagesChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TJvNavIconButton.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = Images then
      Images := nil
    else if AComponent = StyleManager then
      StyleManager := nil;
  end;
end;

procedure TJvNavIconButton.Paint;
var
  Rect: TRect;
  P: TPoint;
  i: integer;
begin
  with Canvas do
  begin
    Rect := ClientRect;
    Brush.Style := bsClear;
    InflateRect(Rect, 0, -1);
    if (bsMouseInside in MouseStates) then
    begin
      if (bsMouseDown in MouseStates) then
        GradientFillRect(Canvas, Rect, Colors.ButtonSelectedColorFrom, Colors.ButtonSelectedColorTo, fdTopToBottom, 32)
      else
        GradientFillRect(Canvas, Rect, Colors.ButtonHotColorFrom, Colors.ButtonHotColorTo, fdTopToBottom, 32)
    end
    else if Down then
      GradientFillRect(Canvas, Rect, Colors.ButtonSelectedColorFrom, Colors.ButtonSelectedColorTo, fdTopToBottom, 32);
    case ButtonType of
      nibDropDown:
        begin // area should be 7x12
          InflateRect(Rect, -((Rect.Right - Rect.Left) - 7) div 2 + Ord(bsMouseDown in MouseStates), -((Rect.Bottom - Rect.Top) - 12) div 2 + Ord(bsMouseDown in MouseStates));
          Canvas.Pen.Color := clBlack;
          P.X := Rect.Left;
          P.Y := Rect.Top;
          // chevron, upper
          for i := 0 to 2 do
          begin
            Canvas.MoveTo(P.X, P.Y);
            Canvas.LineTo(P.X + 2, P.Y);

            Canvas.MoveTo(P.X + 4, P.Y);
            Canvas.LineTo(P.X + 6, P.Y);
            Inc(P.X);
            Inc(P.Y);
          end;
          // chevron, lower
          Dec(P.X);
          Dec(P.Y);
          for i := 0 to 2 do
          begin
            Canvas.MoveTo(P.X, P.Y);
            Canvas.LineTo(P.X + 2, P.Y);

            Canvas.MoveTo(P.X + 4, P.Y);
            Canvas.LineTo(P.X + 6, P.Y);
            Dec(P.X);
            Inc(P.Y);
          end;

          // drop arrow
          Inc(P.X, 1);
          Inc(P.Y, 3);
          for i := 0 to 3 do
          begin
            Canvas.MoveTo(P.X + i, P.Y + i);
            Canvas.LineTo(P.X + 7 - i, P.Y + i);
          end;
        end;
      nibImage:
        begin
          if (Images <> nil) and (ImageIndex >= 0) and (ImageIndex < Images.Count) then
            // draw image only
            Images.Draw(Canvas,
              (Width - Images.Width) div 2 + Ord(bsMouseDown in MouseStates),
              (Height - Images.Height) div 2 + Ord(bsMouseDown in MouseStates), ImageIndex, Enabled);
        end;
      nibDropArrow:
        begin
          // area should be 9 x 5, centered
          P.X := Rect.Left + (RectWidth(Rect) - 9) div 2 + Ord(bsMouseDown in MouseStates);
          P.Y := Rect.Top + (RectHeight(Rect) - 5) div 2 + Ord(bsMouseDown in MouseStates);
          Canvas.Pen.Color := clBlack;
          for i := 0 to 4 do
          begin
            Canvas.MoveTo(P.X + i, P.Y + i);
            Canvas.LineTo(P.X + 9 - i, P.Y + i);
          end;
        end;
      nibClose:
        begin
          // area should be 9 x 8, centered
          P.X := Rect.Left + (RectWidth(Rect) - 8) div 2 + Ord(bsMouseDown in MouseStates);
          P.Y := Rect.Top + (RectHeight(Rect) - 7) div 2 + Ord(bsMouseDown in MouseStates);
          Canvas.Pen.Color := clBlack;
          for i := 0 to 7 do
          begin
            Canvas.MoveTo(P.X, P.Y);
            Canvas.LineTo(P.X + 2, P.Y);
            Inc(P.X);
            Inc(P.Y);
          end;
          P.X := Rect.Left + (RectWidth(Rect) - 8) div 2 + Ord(bsMouseDown in MouseStates);
          P.Y := Rect.Top + (RectHeight(Rect) - 7) div 2 + Ord(bsMouseDown in MouseStates);
          Inc(P.Y, 7);
          for i := 0 to 7 do
          begin
            Canvas.MoveTo(P.X, P.Y);
            Canvas.LineTo(P.X + 2, P.Y);
            Inc(P.X);
            Dec(P.Y);
          end;
        end;

    end;
    if csDesigning in ComponentState then
    begin
      Canvas.Pen.Color := clBlack;
      Canvas.Pen.Style := psDot;
      Canvas.Brush.Style := bsClear;
      Canvas.Rectangle(ClientRect);
    end;
  end;
end;

procedure TJvNavIconButton.SetColors(const Value: TJvNavPanelColors);
begin
  FColors.Assign(Value);
end;

procedure TJvNavIconButton.SetImageIndex(const Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Invalidate;
  end;
end;

procedure TJvNavIconButton.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then
  begin
    if FImages <> nil then
      FImages.UnRegisterChanges(FChangeLink);
    FImages := Value;
    if FImages <> nil then
    begin
      FImages.FreeNotification(Self);
      FImages.RegisterChanges(FChangeLink);
    end;
    Invalidate;
  end;
end;

procedure TJvNavIconButton.SetButtonType(const Value: TJvNavIconButtonType);
begin
  if FButtonType <> Value then
  begin
    FButtonType := Value;
    Invalidate;
  end;
end;

procedure TJvNavIconButton.SetStyleManager(const Value: TJvNavPaneStyleManager);
begin
  if FStyleManager <> Value then
  begin
    if FStyleManager <> nil then
      FStyleManager.UnRegisterChanges(FStyleLink);
    FStyleManager := Value;
    if FStyleManager <> nil then
    begin
      FStyleManager.RegisterChanges(FStyleLink);
      FStyleManager.FreeNotification(Self);
      Colors := FStyleManager.Colors;
    end;
  end;
end;

procedure TJvNavIconButton.DoStyleChange(Sender: TObject);
begin
  Colors := (Sender as TJvNavPaneStyleManager).Colors;
end;

{ TJvNavPanelButton }

procedure TJvNavPanelButton.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if not CheckDefaults or (Self.Caption = '') or (Self.Caption = Self.Name) then
        Self.Caption := Caption;
      if not CheckDefaults or Self.Enabled then
        Self.Enabled := Enabled;
      if not CheckDefaults or (Self.Hint = '') then
        Self.Hint := Hint;
      if not CheckDefaults or (Self.ImageIndex = -1) then
        Self.ImageIndex := ImageIndex;
      if not CheckDefaults or Self.Visible then
        Self.Visible := Visible;
      if not CheckDefaults or not Assigned(Self.OnClick) then
        Self.OnClick := OnExecute;
    end;
end;

constructor TJvNavPanelButton.Create(AOwner: TComponent);
begin
  inherited;
  FStyleLink := TJvNavStyleLink.Create;
  FStyleLink.OnChange := DoStyleChange;
  ControlStyle := ControlStyle + [csOpaque, csDisplayDragImage];
  Flat := True;
  HotTrack := True;
  Height := 28;
  FColors := TJvNavPanelColors.Create;
  FColors.OnChange := DoColorsChange;
  Font := Screen.IconFont;
  Font.Style := [fsBold];
  Width := 125;
  Height := 28;
end;

destructor TJvNavPanelButton.Destroy;
begin
  FStyleLink.Free;
  FColors.Free;
  inherited;
end;

procedure TJvNavPanelButton.DoColorsChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TJvNavPanelButton.DoStyleChange(Sender: TObject);
begin
  Colors := (Sender as TJvNavPaneStyleManager).Colors;
end;

procedure TJvNavPanelButton.FontChanged;
begin
  inherited;
  Invalidate;
end;

procedure TJvNavPanelButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = StyleManager then
      StyleManager := nil;
  end;
end;

procedure TJvNavPanelButton.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  if bsMouseInside in MouseStates then
  begin
    if (bsMouseDown in MouseStates) then
      GradientFillRect(Canvas, R, Colors.ButtonSelectedColorTo, Colors.ButtonSelectedColorFrom, fdTopToBottom, 32)
    else
      GradientFillRect(Canvas, R, Colors.ButtonHotColorFrom, Colors.ButtonHotColorTo, fdTopToBottom, 32);
  end
  else if Down then
    GradientFillRect(Canvas, R, Colors.ButtonSelectedColorFrom, Colors.ButtonSelectedColorTo, fdTopToBottom, 32)
  else
    GradientFillRect(Canvas, ClientRect, Colors.ButtonColorFrom, Colors.ButtonColorTo, fdTopToBottom, 32);

  if Assigned(Images) then
  begin
    OffsetRect(R, 4, 0);
    Images.Draw(Canvas, R.Left, (Height - Images.Height) div 2, ImageIndex);
    OffsetRect(R, Images.Width + 4, 0);
  end
  else
    OffsetRect(R, 8, 0);
  if Caption <> '' then
  begin
    Canvas.Font := Font;
    SetBkMode(Canvas.Handle, Windows.TRANSPARENT);
    DrawText(Canvas.Handle, PChar(Caption), Length(Caption), R, DT_SINGLELINE or DT_VCENTER or DT_EDITCONTROL);
  end;
  Canvas.Pen.Color := clGray;
  if Align = alBottom then
  begin
    Canvas.MoveTo(0, 0);
    Canvas.LineTo(Width + 1, 0);
  end
  else
  begin
    Canvas.MoveTo(0, ClientHeight - 1);
    Canvas.LineTo(Width + 1, ClientHeight - 1);
  end;
end;

procedure TJvNavPanelButton.SetColors(const Value: TJvNavPanelColors);
begin
  FColors.Assign(Value);
end;

procedure TJvNavPanelButton.SetStyleManager(const Value: TJvNavPaneStyleManager);
begin
  if FStyleManager <> Value then
  begin
    if FStyleManager <> nil then
      FStyleManager.UnRegisterChanges(FStyleLink);
    FStyleManager := Value;
    if FStyleManager <> nil then
    begin
      FStyleManager.RegisterChanges(FStyleLink);
      FStyleManager.FreeNotification(Self);
      Colors := FStyleManager.Colors;
    end;
  end;
end;

procedure TJvNavPanelButton.SetImageIndex(const Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Invalidate;
  end;
end;

procedure TJvNavPanelButton.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
    Invalidate;
  end;
end;

procedure TJvNavPanelButton.TextChanged;
begin
  inherited;
  Invalidate;
end;

procedure TJvNavPanelButton.CMDialogChar(var Message: TCMDialogChar);
begin
  if IsAccel(Message.CharCode, Caption) then
  begin
    Message.Result := 1;
    Click;
  end
  else
    inherited;
end;

{ TJvNavPanelColors }

procedure TJvNavPanelColors.Assign(Source: TPersistent);
begin
  if (Source is TJvNavPanelColors) and (Source <> Self) then
  begin
    FButtonColorFrom := TJvNavPanelColors(Source).ButtonColorFrom;
    FButtonColorTo := TJvNavPanelColors(Source).ButtonColorTo;
    FButtonHotColorFrom := TJvNavPanelColors(Source).ButtonHotColorFrom;
    FButtonHotColorTo := TJvNavPanelColors(Source).ButtonHotColorTo;
    FButtonSelectedColorFrom := TJvNavPanelColors(Source).ButtonSelectedColorFrom;
    FButtonSelectedColorTo := TJvNavPanelColors(Source).ButtonSelectedColorTo;
    FFrameColor := TJvNavPanelColors(Source).FrameColor;
    FHeaderColorFrom := TJvNavPanelColors(Source).HeaderColorFrom;
    FHeaderColorTo := TJvNavPanelColors(Source).HeaderColorTo;
    FDividerColorFrom := TJvNavPanelColors(Source).DividerColorFrom;
    FDividerColorTo := TJvNavPanelColors(Source).DividerColorTo;
    FSplitterColorFrom := TJvNavPanelColors(Source).SplitterColorFrom;
    FSplitterColorTo := TJvNavPanelColors(Source).SplitterColorTo;
    Change;
    Exit;
  end;
  inherited;
end;

procedure TJvNavPanelColors.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

constructor TJvNavPanelColors.Create;
begin
  inherited Create;
  FSplitterColorFrom := $D68652;
  FSplitterColorTo := $944110;
  FButtonColorFrom := $FFE7CE;
  FButtonColorTo := $E7A67B;
  FFrameColor := $943000;
  FButtonHotColorFrom := $8CE7FF;
  FButtonHotColorTo := $1096EF;
  FButtonSelectedColorFrom := $0053DDFF;
  FButtonSelectedColorTo := $000D7BC6;
  FDividerColorFrom := $FFE7CE;
  FDividerColorTo := $E7A67B;
  FHeaderColorFrom := $D68652;
  FHeaderColorTo := $944110;
end;

procedure TJvNavPanelColors.SetButtonColorFrom(const Value: TColor);
begin
  if FButtonColorFrom <> Value then
  begin
    FButtonColorFrom := Value;
    Change;
  end;
end;

procedure TJvNavPanelColors.SetButtonColorTo(const Value: TColor);
begin
  if FButtonColorTo <> Value then
  begin
    FButtonColorTo := Value;
    Change;
  end;
end;

procedure TJvNavPanelColors.SetDividerColorFrom(const Value: TColor);
begin
  if FDividerColorFrom <> Value then
  begin
    FDividerColorFrom := Value;
    Change;
  end;
end;

procedure TJvNavPanelColors.SetDividerColorTo(const Value: TColor);
begin
  if FDividerColorTo <> Value then
  begin
    FDividerColorTo := Value;
    Change;
  end;
end;

procedure TJvNavPanelColors.SetFrameColor(const Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    Change;
  end;
end;

procedure TJvNavPanelColors.SetHeaderColorFrom(const Value: TColor);
begin
  if FHeaderColorFrom <> Value then
  begin
    FHeaderColorFrom := Value;
    Change;
  end;
end;

procedure TJvNavPanelColors.SetHeaderColorTo(const Value: TColor);
begin
  if FHeaderColorTo <> Value then
  begin
    FHeaderColorTo := Value;
    Change;
  end;
end;

procedure TJvNavPanelColors.SetButtonHotColorFrom(const Value: TColor);
begin
  if FButtonHotColorFrom <> Value then
  begin
    FButtonHotColorFrom := Value;
    Change;
  end;
end;

procedure TJvNavPanelColors.SetButtonHotColorTo(const Value: TColor);
begin
  if FButtonHotColorTo <> Value then
  begin
    FButtonHotColorTo := Value;
    Change;
  end;
end;

procedure TJvNavPanelColors.SetButtonSelectedColorFrom(const Value: TColor);
begin
  if FButtonSelectedColorFrom <> Value then
  begin
    FButtonSelectedColorFrom := Value;
    Change;
  end;
end;

procedure TJvNavPanelColors.SetButtonSelectedColorTo(const Value: TColor);
begin
  if FButtonSelectedColorTo <> Value then
  begin
    FButtonSelectedColorTo := Value;
    Change;
  end;
end;

procedure TJvNavPanelColors.SetSplitterColorFrom(const Value: TColor);
begin
  if FSplitterColorFrom <> Value then
  begin
    FSplitterColorFrom := Value;
    Change;
  end;
end;

procedure TJvNavPanelColors.SetSplitterColorTo(const Value: TColor);
begin
  if FSplitterColorTo <> Value then
  begin
    FSplitterColorTo := Value;
    Change;
  end;
end;

{ TJvNavPanelPage }

constructor TJvNavPanelPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStyleLink := TJvNavStyleLink.Create;
  FStyleLink.OnChange := DoStyleChange;

  FNavPanel := TJvNavPanelButton.Create(Self);
  FNavPanel.Visible := true;
  FNavPanel.Align := alBottom;
  FNavPanel.GroupIndex := 113; // use a silly number that no one else is probable to use
  FNavPanel.AllowAllUp := false;

  FIconButton := TJvNavIconButton.Create(Self);
  FIconButton.ButtonType := nibImage;
  FIconButton.Visible := false;
  FIconButton.Align := alRight;
  FIconButton.Width := 0;
  FIconButton.GroupIndex := 113;
  FIconButton.AllowAllUp := false;

  FNavPanel.OnClick := DoButtonClick;
  FIconButton.OnClick := DoButtonClick;

  ImageIndex := -1;
end;

destructor TJvNavPanelPage.Destroy;
begin
  FStyleLink.Free;
  inherited;
end;

procedure TJvNavPanelPage.DoButtonClick(Sender: TObject);
begin
  if not NavPanel.Down then
  begin
    if Parent <> nil then
      TJvCustomNavigationPane(Parent).ActivePage := Self; // this sets "Down" as well
    if Assigned(FOnClick) then FOnClick(Self);
  end;
end;

procedure TJvNavPanelPage.DoStyleChange(Sender: TObject);
begin
  Colors := (Sender as TJvNavPaneStyleManager).Colors;
end;

function TJvNavPanelPage.GetCaption: TCaption;
begin
  if NavPanel = nil then
    Result := ''
  else
    Result := NavPanel.Caption;
end;

function TJvNavPanelPage.GetColors: TJvNavPanelColors;
begin
  Result := NavPanel.Colors;
end;

function TJvNavPanelPage.GetHint: string;
begin
  if NavPanel = nil then
    Result := ''
  else
    Result := NavPanel.Hint;
end;

function TJvNavPanelPage.GetIconic: boolean;
begin
  if NavPanel = nil then
    Result := false
  else
    Result := not NavPanel.Visible;
end;

function TJvNavPanelPage.GetImageIndex: TImageIndex;
begin
  if NavPanel = nil then
    Result := -1
  else
    Result := NavPanel.ImageIndex;
end;

procedure TJvNavPanelPage.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (AComponent = IconPanel) then
      IconPanel := nil
    else if AComponent = StyleManager then
      StyleManager := nil;
  end;
end;

procedure TJvNavPanelPage.SetCaption(const Value: TCaption);
begin
  if NavPanel <> nil then
    NavPanel.Caption := Value;
end;

procedure TJvNavPanelPage.SetColors(const Value: TJvNavPanelColors);
begin
  NavPanel.Colors := Value;
  IconButton.Colors := Value;
end;

procedure TJvNavPanelPage.SetStyleManager(const Value: TJvNavPaneStyleManager);
begin
  if FStyleManager <> Value then
  begin
    if FStyleManager <> nil then
      FStyleManager.UnRegisterChanges(FStyleLink);
    FStyleManager := Value;
    if FStyleManager <> nil then
    begin
      FStyleManager.RegisterChanges(FStyleLink);
      FStyleManager.FreeNotification(Self);
      Colors := FStyleManager.Colors;
    end;
  end;
  FNavPanel.StyleManager := Value;
  FIconButton.StyleManager := Value;
end;

procedure TJvNavPanelPage.SetHint(const Value: string);
begin
  NavPanel.Hint := Value;
  IconButton.Hint := Value;
end;

procedure TJvNavPanelPage.SetIconic(const Value: boolean);
begin
  NavPanel.Visible := not Value;
  IconButton.Visible := Value;
  NavPanel.Height := TJvCustomNavigationPane(Parent).ButtonHeight * Ord(NavPanel.Visible);
  IconButton.Width := TJvCustomNavigationPane(Parent).ButtonWidth * Ord(IconButton.Visible);
  UpdatePageList;
end;

procedure TJvNavPanelPage.SetIconPanel(const Value: TJvIconPanel);
begin
  if (FIconPanel <> Value) and not (csDestroying in ComponentState) then
  begin
    FIconPanel := Value;
    if IconButton <> nil then
    begin
      if FIconPanel <> nil then
      begin
        IconButton.Parent := FIconPanel;
        FIconPanel.FreeNotification(Self);
      end
      else
        IconButton.Parent := nil;
    end;
  end;
end;

procedure TJvNavPanelPage.SetImageIndex(const Value: TImageIndex);
begin
  NavPanel.ImageIndex := Value;
  IconButton.ImageIndex := Value;
end;

procedure TJvNavPanelPage.SetPageIndex(Value: Integer);
begin
  inherited SetPageIndex(Value);
  UpdatePageList;
end;

procedure TJvNavPanelPage.SetParent(AParent: TWinControl);
begin
  inherited;
  if (FNavPanel = nil) or (FIconButton = nil) or (csDestroying in ComponentState) then
    Exit;
  NavPanel.Parent := AParent;
  if AParent is TJvCustomNavigationPane then
  begin
    IconPanel := TJvCustomNavigationPane(AParent).FIconPanel;
    StyleManager := TJvCustomNavigationPane(AParent).StyleManager;

    NavPanel.Colors := TJvCustomNavigationPane(AParent).Colors;
    NavPanel.StyleManager := StyleManager;
    NavPanel.Height := TJvCustomNavigationPane(AParent).ButtonHeight;
    NavPanel.Images := TJvCustomNavigationPane(AParent).LargeImages;
    NavPanel.Font := TJvCustomNavigationPane(AParent).NavPanelFont;

    IconButton.Images := TJvCustomNavigationPane(AParent).SmallImages;
    IconButton.Width := TJvCustomNavigationPane(AParent).ButtonWidth;
    IconButton.StyleManager := StyleManager;
  end
  else
    IconButton.Parent := nil;
end;

procedure TJvNavPanelPage.UpdatePageList;
begin
  if PageList <> nil then
    TJvCustomNavigationPane(PageList).UpdatePositions;
end;

{ TJvOutlookSplitter }

procedure TJvOutlookSplitter.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

constructor TJvOutlookSplitter.Create(AOwner: TComponent);
begin
  inherited;
  FStyleLink := TJvNavStyleLink.Create;
  FStyleLink.OnChange := DoStyleChange;
  FColorFrom := $D68652;
  FColorTo := $944110;
  Align := alBottom;
  AutoSnap := False;
  ResizeStyle := rsUpdate;
  Height := 7;
  Cursor := crSizeNS;
end;

destructor TJvOutlookSplitter.Destroy;
begin
  FStyleLink.Free;
  inherited;
end;

procedure TJvOutlookSplitter.DoStyleChange(Sender: TObject);
begin
  with (Sender as TJvNavPaneStyleManager).Colors do
  begin
    FColorFrom := SplitterColorFrom;
    FColorTo := SplitterColorTo;
    Invalidate;
  end;
end;

procedure TJvOutlookSplitter.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = StyleManager then
      StyleManager := nil;
  end;
end;

procedure TJvOutlookSplitter.Paint;
var
  i: integer;
  R: TRect;
begin
  R := ClientRect;
  if Align in [alTop, alBottom] then
  begin
    GradientFillRect(Canvas, R, ColorFrom, ColorTo, fdTopToBottom, R.Bottom - R.Top);
    Inc(R.Left, (R.Right - R.Left) div 2 - 20);
    Inc(R.Top, (R.Bottom - R.Top) div 2 - 1);
    R.Right := R.Left + 2;
    R.Bottom := R.Top + 2;
    if Enabled then
      for i := 0 to 9 do // draw the dots
      begin
        Canvas.Brush.Color := cl3DDkShadow;
        Canvas.FillRect(R);
        OffsetRect(R, 1, 1);
        Canvas.Brush.Color := clWhite;
        Canvas.FillRect(R);
        Canvas.Brush.Color := ColorFrom; // (p3) this is probably not the right color, but it's close enough for me...
        Canvas.FillRect(Rect(R.Left, R.Top, R.Left + 1, R.Top + 1));
        OffsetRect(R, 3, -1);
      end;
  end
  else
  begin
    GradientFillRect(Canvas, R, ColorFrom, ColorTo, fdLeftToRight, R.Right - R.Left);
    Inc(R.Top, (R.Bottom - R.Top) div 2 - 20);
    Inc(R.Left, (R.Right - R.Left) div 2 - 1);
    R.Right := R.Left + 2;
    R.Bottom := R.Top + 2;
    if Enabled then
      for i := 0 to 9 do // draw the dots
      begin
        Canvas.Brush.Color := cl3DDkShadow;
        Canvas.FillRect(R);
        OffsetRect(R, 1, 1);
        Canvas.Brush.Color := clWhite;
        Canvas.FillRect(R);
        Canvas.Brush.Color := ColorFrom;
        Canvas.FillRect(Rect(R.Left, R.Top, R.Left + 1, R.Top + 1));
        OffsetRect(R, -1, 3);
      end;

  end;
end;

procedure TJvOutlookSplitter.SetColorFrom(const Value: TColor);
begin
  if FColorFrom <> Value then
  begin
    FColorFrom := Value;
    Invalidate;
  end;
end;

procedure TJvOutlookSplitter.SetStyleManager(const Value: TJvNavPaneStyleManager);
begin
  if FStyleManager <> Value then
  begin
    if FStyleManager <> nil then
      FStyleManager.UnRegisterChanges(FStyleLink);
    FStyleManager := Value;
    if FStyleManager <> nil then
    begin
      FStyleManager.RegisterChanges(FStyleLink);
      FStyleManager.FreeNotification(Self);
      ColorFrom := FStyleManager.Colors.SplitterColorFrom;
      ColorTo := FStyleManager.Colors.SplitterColorTo;
    end;
  end;
end;

procedure TJvOutlookSplitter.SetColorTo(const Value: TColor);
begin
  if FColorTo <> Value then
  begin
    FColorTo := Value;
    Invalidate;
  end;
end;

{ TJvNavPanelHeader }

constructor TJvNavPanelHeader.Create(AOwner: TComponent);
begin
  inherited;
  FChangeLink := TChangeLink.Create;
  FChangeLink.OnChange := DoImagesChange;
  FStyleLink := TJvNavStyleLink.Create;
  FStyleLink.OnChange := DoStyleChange;
  ControlStyle := ControlStyle + [csOpaque, csAcceptsControls];
  FColorFrom := $D68652;
  FColorTo := $944110;
  Font.Name := 'Arial';
  Font.Size := 12;
  Font.Style := [fsBold];
  Font.Color := clWhite;
  Height := 27;
  Width := 225;
end;

destructor TJvNavPanelHeader.Destroy;
begin
  FChangeLink.Free;
  FStyleLink.Free;
  inherited;
end;

procedure TJvNavPanelHeader.DoImagesChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TJvNavPanelHeader.DoStyleChange(Sender: TObject);
begin
  with (Sender as TJvNavPaneStyleManager).Colors do
  begin
    FColorFrom := HeaderColorFrom;
    FColorTo := HeaderColorTo;
    Invalidate;
  end;
end;

procedure TJvNavPanelHeader.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = Images) then
      Images := nil
    else if AComponent = StyleManager then
      StyleManager := nil;
  end;
end;

procedure TJvNavPanelHeader.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  GradientFillRect(Canvas, R, ColorFrom, ColorTo, fdTopToBottom, 32);
  if Caption <> '' then
  begin
    Canvas.Font := Font;
    OffsetRect(R, 4, 0);
    SetBkMode(Canvas.Handle, Windows.TRANSPARENT);
    DrawText(Canvas.Handle, PChar(Caption), Length(Caption), R, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or
      DT_EDITCONTROL);
  end;
  if (Images <> nil) and (ImageIndex >= 0) and (ImageIndex < Images.Count) then
  begin
    Images.Draw(Canvas,
      ClientWidth - Images.Width - (Height - Images.Height) div 2, (Height - Images.Height) div 2, ImageIndex, True);
  end;
end;

procedure TJvNavPanelHeader.SetColorFrom(const Value: TColor);
begin
  if FColorFrom <> Value then
  begin
    FColorFrom := Value;
    Invalidate;
  end;
end;

procedure TJvNavPanelHeader.SetStyleManager(const Value: TJvNavPaneStyleManager);
begin
  if FStyleManager <> Value then
  begin
    if FStyleManager <> nil then
      FStyleManager.UnRegisterChanges(FStyleLink);
    FStyleManager := Value;
    if FStyleManager <> nil then
    begin
      FStyleManager.RegisterChanges(FStyleLink);
      FStyleManager.FreeNotification(Self);
      FColorFrom := FStyleManager.Colors.HeaderColorFrom;
      FColorTo := FStyleManager.Colors.HeaderColorTo;
      Invalidate;
    end;
  end;
end;

procedure TJvNavPanelHeader.SetColorTo(const Value: TColor);
begin
  if FColorTo <> Value then
  begin
    FColorTo := Value;
    Invalidate;
  end;
end;

procedure TJvNavPanelHeader.SetImageIndex(const Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Invalidate;
  end;
end;

procedure TJvNavPanelHeader.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then
  begin
    if FImages <> nil then
      FImages.UnRegisterChanges(FChangeLink);
    FImages := Value;
    if FImages <> nil then
    begin
      FImages.RegisterChanges(FChangeLink);
      FImages.FreeNotification(Self);
    end;
    Invalidate;
  end;
end;

procedure TJvNavPanelHeader.TextChanged;
begin
  inherited;
  Invalidate;
end;

procedure TJvNavPanelHeader.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

{ TJvNavPanelDivider }

procedure TJvNavPanelDivider.CMTextchanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

constructor TJvNavPanelDivider.Create(AOwner: TComponent);
begin
  inherited;
  FStyleLink := TJvNavStyleLink.Create;
  FStyleLink.OnChange := DoStyleChange;
  Align := alNone;
  AutoSnap := False;
  ResizeStyle := rsUpdate;
  ControlStyle := ControlStyle + [csOpaque];
  FColorFrom := $FFE7CE;
  FColorTo := $E7A67B;
  FFrameColor := $943000;
  Cursor := crSizeNS;
  Font := Screen.IconFont;
  Height := 19;
  Width := 125;
end;

destructor TJvNavPanelDivider.Destroy;
begin
  FStyleLink.Free;
  inherited;
end;

procedure TJvNavPanelDivider.DoStyleChange(Sender: TObject);
begin
  with (Sender as TJvNavPaneStyleManager).Colors do
  begin
    FColorFrom := DividerColorFrom;
    FColorTo := DividerColorTo;
    Self.FFrameColor := FrameColor;
    Invalidate;
  end;
end;

procedure TJvNavPanelDivider.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = StyleManager then
      StyleManager := nil;
  end;
end;

procedure TJvNavPanelDivider.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  GradientFillRect(Canvas, R, ColorFrom, ColorTo, fdTopToBottom, 32);
  if Caption <> '' then
  begin
    Canvas.Font := Font;
    OffsetRect(R, 7, 0);
    SetBkMode(Canvas.Handle, Windows.TRANSPARENT);
    DrawText(Canvas.Handle, PChar(Caption), Length(Caption), R, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or
      DT_EDITCONTROL);
  end;
  Canvas.Pen.Color := FrameColor;
  Canvas.MoveTo(0, ClientHeight - 1);
  Canvas.LineTo(Width, ClientHeight - 1);
end;

procedure TJvNavPanelDivider.SetColorFrom(const Value: TColor);
begin
  if FColorFrom <> Value then
  begin
    FColorFrom := Value;
    Invalidate;
  end;
end;

procedure TJvNavPanelDivider.SetStyleManager(const Value: TJvNavPaneStyleManager);
begin
  if FStyleManager <> Value then
  begin
    if FStyleManager <> nil then
      FStyleManager.UnRegisterChanges(FStyleLink);
    FStyleManager := Value;
    if FStyleManager <> nil then
    begin
      FStyleManager.RegisterChanges(FStyleLink);
      FStyleManager.FreeNotification(Self);
      ColorFrom := FStyleManager.Colors.DividerColorFrom;
      ColorTo := FStyleManager.Colors.DividerColorTo;
    end;
  end;
end;

procedure TJvNavPanelDivider.SetColorTo(const Value: TColor);
begin
  if FColorTo <> Value then
  begin
    FColorTo := Value;
    Invalidate;
  end;
end;

procedure TJvNavPanelDivider.SetFrameColor(const Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    Invalidate;
  end;
end;

{ TJvNavPaneStyleManager }

procedure TJvNavPaneStyleManager.Assign(Source: TPersistent);
var
  SourceColors: TJvNavPanelColors;
begin
  if Source is TJvNavPaneStyleManager then
  begin
    Theme := TJvNavPaneStyleManager(Source).Theme;
    if Theme = nptCustom then
      SourceColors := TJvNavPaneStyleManager(Source).Colors
    else
      Exit;
  end
  else if Source is TJvIconPanel then
    SourceColors := TJvIconPanel(Source).Colors
  else if Source is TJvNavIconButton then
    SourceColors := TJvNavIconButton(Source).Colors
  else if Source is TJvNavPanelButton then
    SourceColors := TJvNavPanelButton(Source).Colors
  else if Source is TJvNavPanelPage then
    SourceColors := TJvNavPanelPage(Source).Colors
  else if Source is TJvCustomNavigationPane then
    SourceColors := TJvCustomNavigationPane(Source).Colors
  else
  begin
    inherited Assign(Source);
    Exit;
  end;
  FColors.Assign(SourceColors);
end;

procedure TJvNavPaneStyleManager.AssignTo(Dest: TPersistent);
var
  DestColors: TJvNavPanelColors;
begin
  if Dest is TJvNavPaneStyleManager then
  begin
    TJvNavPaneStyleManager(Dest).Theme := Theme;
    if Theme = nptCustom then
      DestColors := TJvNavPaneStyleManager(Dest).Colors
    else
      Exit;
  end
  else if Dest is TJvIconPanel then
    DestColors := TJvIconPanel(Dest).Colors
  else if Dest is TJvNavIconButton then
    DestColors := TJvNavIconButton(Dest).Colors
  else if Dest is TJvNavPanelButton then
    DestColors := TJvNavPanelButton(Dest).Colors
  else if Dest is TJvNavPanelPage then
    DestColors := TJvNavPanelPage(Dest).Colors
  else if Dest is TJvCustomNavigationPane then
    DestColors := TJvCustomNavigationPane(Dest).Colors
  else
  begin
    inherited AssignTo(Dest);
    Exit;
  end;
  DestColors.Assign(Colors);
end;

constructor TJvNavPaneStyleManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClients := TList.Create;
  FColors := TJvNavPanelColors.Create;
  FColors.OnChange := DoColorsChange;
  Theme := nptStandard;
end;

destructor TJvNavPaneStyleManager.Destroy;
begin
  while FClients.Count > 0 do
    UnRegisterChanges(TJvNavStyleLink(FClients.Last));
  FClients.Free;
  FClients := nil;
  FColors.Free;
  inherited;
end;

procedure TJvNavPaneStyleManager.DoColorsChange(Sender: TObject);
var
  I: integer;
begin
  Theme := nptCustom;
  if FClients <> nil then
    for I := 0 to FClients.Count - 1 do
      TJvNavStyleLink(FClients[I]).Change;
end;

procedure TJvNavPaneStyleManager.RegisterChanges(Value: TJvNavStyleLink);
begin
  Value.Sender := Self;
  if FClients <> nil then FClients.Add(Value);
end;

procedure TJvNavPaneStyleManager.SetColors(const Value: TJvNavPanelColors);
begin
  FColors.Assign(Value);
end;

procedure TJvNavPaneStyleManager.SetTheme(const Value: TJvNavPanelTheme);
begin
  if FTheme <> Value then
  begin
    case Value of
      nptStandard:
        begin
          FColors.ButtonColorFrom := $FFFFFF;
          FColors.ButtonColorTo := $BDBEBD;
          FColors.ButtonSelectedColorFrom := $DECFCE;
          FColors.ButtonSelectedColorTo := $DECFCE;
          FColors.FrameColor := $848484;
          FColors.ButtonHotColorFrom := $C68284;
          FColors.ButtonHotColorTo := $C68284;
          FColors.DividerColorFrom := $EFF3EF;
          FColors.DividerColorTo := $C6C3C6;
          FColors.HeaderColorFrom := $848284;
          FColors.HeaderColorTo := $848284;
          FColors.SplitterColorFrom := $C6C3C6;
          FColors.SplitterColorTo := $8C8E8C;
        end;
      nptXPBlue:
        begin
          FColors.ButtonColorFrom := $F7E2CD;
          FColors.ButtonColorTo := $F3A080;
          FColors.ButtonSelectedColorFrom := $BBE2EA;
          FColors.ButtonSelectedColorTo := $389FDD;
          FColors.FrameColor := $6F2F0C;
          FColors.ButtonHotColorFrom := $DBFBFF;
          FColors.ButtonHotColorTo := $5FC8FB;
          FColors.DividerColorFrom := $FFDBBC;
          FColors.DividerColorTo := $F2C0A4;
          FColors.HeaderColorFrom := $D0835C;
          FColors.HeaderColorTo := $903B09;
          FColors.SplitterColorFrom := $B78676;
          FColors.SplitterColorTo := $A03D09;
        end;
      nptXPSilver:
        begin
          FColors.ButtonColorFrom := $F4E2E1;
          FColors.ButtonColorTo := $B09494;
          FColors.ButtonSelectedColorFrom := $BBE2EA;
          FColors.ButtonSelectedColorTo := $389FDD;
          FColors.FrameColor := $527D92;
          FColors.ButtonHotColorFrom := $DBFBFF;
          FColors.ButtonHotColorTo := $5FC8FB;
          FColors.DividerColorFrom := $F8F3F4;
          FColors.DividerColorTo := $EADADB;
          FColors.HeaderColorFrom := $BAA8BA;
          FColors.HeaderColorTo := $917275;
          FColors.SplitterColorFrom := $B8ABA9;
          FColors.SplitterColorTo := $81767E;
        end;
      nptXPOlive:
        begin
          FColors.ButtonColorFrom := $D6F3E3;
          FColors.ButtonColorTo := $93BFB2;
          FColors.ButtonSelectedColorFrom := $BBE2EA;
          FColors.ButtonSelectedColorTo := $389FDD;
          FColors.FrameColor := $5A7972;
          FColors.ButtonHotColorFrom := $DBFBFF;
          FColors.ButtonHotColorTo := $5FC8FB;
          FColors.DividerColorFrom := $D2F4EE;
          FColors.DividerColorTo := $B5DFD8;
          FColors.HeaderColorFrom := $94BFB4;
          FColors.HeaderColorTo := $427665;
          FColors.SplitterColorFrom := $758D81;
          FColors.SplitterColorTo := $3A584D;
        end;
      nptCustom:
        begin
          // do nothing
        end;
    end;
    FTheme := Value;
  end;
end;

procedure TJvNavPaneStyleManager.UnRegisterChanges(Value: TJvNavStyleLink);
var
  I: Integer;
begin
  if FClients <> nil then
    for I := 0 to FClients.Count - 1 do
      if FClients[I] = Value then
      begin
        Value.Sender := nil;
        FClients.Delete(I);
        Break;
      end;
end;

{ TJvNavStyleLink }

procedure TJvNavStyleLink.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Sender)
end;

destructor TJvNavStyleLink.Destroy;
begin
  if (Sender is TJvNavPaneStyleManager) then
    TJvNavPaneStyleManager(Sender).UnRegisterChanges(Self);
  inherited Destroy;
end;

{ TJvNavPaneToolPanel }

procedure TJvNavPaneToolPanel.ButtonsChanged;
var
  i: integer;
  B: TJvNavIconButton;
begin
  FRealButtons.Clear;
  for i := 0 to Buttons.Count - 1 do
  begin
    B := TJvNavIconButton.Create(nil);
    B.Visible := False;
    B.SetBounds(0, 0, ButtonWidth - 1, ButtonHeight - 1);
    B.ButtonType := nibImage;
    B.Images := Images;
    B.ImageIndex := Buttons[i].ImageIndex;
    B.Enabled := Buttons[i].Enabled;
    B.Parent := Self;
    B.Colors.ButtonSelectedColorFrom := clNone;
    B.Colors.ButtonSelectedColorTo := clNone;
    B.Colors.ButtonHotColorFrom := clNone;
    B.Colors.ButtonHotColorTo := clNone;
    B.Tag := i;
    B.OnClick := InternalButtonClick;
    FRealButtons.Add(B);
  end;
  Invalidate;
end;

constructor TJvNavPaneToolPanel.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csAcceptsControls, csOpaque];
  ParentColor := False;
  Color := clWindow;

  FRealButtons := TObjectList.Create;
  FButtons := TJvNavPaneToolButtons.Create(Self);
  FStyleLink := TJvNavStyleLink.Create;
  FStyleLink.OnChange := DoStyleChange;
  FChangeLink := TChangeLink.Create;
  FChangeLink.OnChange := DoImagesChange;
  FColorFrom := $FFF7CE;
  FColorTo := $E7A67B;
  FButtonColor := $C08000;
  FButtonWidth := 30;
  FButtonHeight := 21;
  FHeaderHeight := 29;
  FEdgeRounding := 9;
  FShowGrabber := True;
  Font := Screen.IconFont;
  Font.Style := [fsBold];

  FCloseButton := TJvNavIconButton.Create(Self);
  FCloseButton.ButtonType := nibClose;
  FCloseButton.Anchors := [akRight, akTop];
  //  FCloseButton.Colors.ButtonColorFrom := clNone;
  //  FCloseButton.Colors.ButtonColorTo := clNone;
  //  FCloseButton.Colors.ButtonSelectedColorFrom := clNone;
  //  FCloseButton.Colors.ButtonSelectedColorTo := clNone;
  //  FCloseButton.Colors.ButtonHotColorFrom := clNone;
  //  FCloseButton.Colors.ButtonHotColorTo := clNone;
  FCloseButton.Parent := Self;
  FCloseButton.Visible := True;
  FCloseButton.OnClick := DoCloseClick;

  FDropDown := TJvNavIconButton.Create(Self);
  FDropDown.ButtonType := nibDropArrow;
  FDropDown.Anchors := [akRight, akTop];
  //  FDropDown.Colors.ButtonColorFrom := clNone;
  //  FDropDown.Colors.ButtonColorTo := clNone;
  //  FDropDown.Colors.ButtonSelectedColorFrom := clNone;
  //  FDropDown.Colors.ButtonSelectedColorTo := clNone;
  //  FDropDown.Colors.ButtonHotColorFrom := clNone;
  //  FDropDown.Colors.ButtonHotColorTo := clNone;
  FDropDown.Parent := Self;

end;

destructor TJvNavPaneToolPanel.Destroy;
begin
  FStyleLink.Free;
  FChangeLink.Free;
  FButtons.Free;
  FRealButtons.Free;
  inherited;
end;

procedure TJvNavPaneToolPanel.DoCloseClick(Sender: TObject);
begin
  if Assigned(FOnClose) then
    FOnClose(Self);
end;

procedure TJvNavPaneToolPanel.DoImagesChange(Sender: TObject);
begin
  ButtonsChanged;
end;

procedure TJvNavPaneToolPanel.DoStyleChange(Sender: TObject);
begin
  with (Sender as TJvNavPaneStyleManager).Colors do
  begin
    FColorFrom := ButtonColorFrom;
    FColorTo := ButtonColorTo;
    FButtonColor := SplitterColorTo;
    Invalidate;
  end;
end;

procedure TJvNavPaneToolPanel.FontChanged;
begin
  inherited;
  Invalidate;
end;

function TJvNavPaneToolPanel.GetCloseButton: boolean;
begin
  Result := FCloseButton.Visible;
end;

function TJvNavPaneToolPanel.GetDropDownMenu: TPopupMenu;
begin
  Result := FDropDown.DropDownMenu;
end;

procedure TJvNavPaneToolPanel.InternalButtonClick(Sender: TObject);
begin
  if Assigned(FOnButtonClick) then
    FOnButtonClick(Self, TJvNavIconButton(Sender).Tag);
end;

procedure TJvNavPaneToolPanel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = Images) then
      Images := nil
    else if AComponent = StyleManager then
      StyleManager := nil;
  end;
end;

procedure TJvNavPaneToolPanel.Paint;
var
  R, R2: TRect;
  i, X, Y: integer;
begin
  // first, fill the background
  Canvas.Lock;
  try
    R := ClientRect;
    R.Bottom := HeaderHeight + EdgeRounding;
    Canvas.Brush.Color := ColorTo;
    Canvas.FillRect(R);
    R.Bottom := R.Top + HeaderHeight;
    GradientFillRect(Canvas, R, ColorFrom, ColorTo, fdTopToBottom, 32);
    // draw the drag dots
    R2 := Rect(R.Left, R.Top + HeaderHeight div 4, R.Left + 2, R.Top + HeaderHeight div 4 + 2);
    OffsetRect(R2, 6, 0);
    if ShowGrabber then
    begin
      for i := 0 to 3 do
      begin
        Canvas.Brush.Color := clWhite;
        OffsetRect(R2, 1, 1);
        Canvas.FillRect(R2);
        Canvas.Brush.Color := ButtonColor;
        OffsetRect(R2, -1, -1);
        Canvas.FillRect(R2);
        OffsetRect(R2, 0, 4);
      end;
      // draw the text
      Inc(R.Left, 16);
    end
    else
      Inc(R.Left, 12);
    Canvas.Font := Self.Font;

    SetBkMode(Canvas.Handle, Windows.TRANSPARENT);
    DrawText(Canvas.Handle, PChar(Caption), Length(Caption), R, DT_SINGLELINE or DT_VCENTER or DT_LEFT);

    // draw the client areas top rounding
    R := ClientRect;
    Inc(R.Top, HeaderHeight);
    Inc(R.Left);
//    Inc(R.Right);
    Canvas.Brush.Color := Color;
    Canvas.Pen.Style := psClear;
    Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, EdgeRounding, EdgeRounding);
//    Dec(R.Right);
    // draw the button area
    Canvas.Brush.Color := ButtonColor;
    if Buttons.Count > 0 then
    begin
      R2 := Rect(R.Left, R.Top, R.Left + ButtonWidth * Buttons.Count - 1, R.Top + ButtonHeight);
      Canvas.RoundRect(R2.Left, R2.Top, R2.Right, R2.Bottom, EdgeRounding, EdgeRounding);
      // square two corners
      Canvas.FillRect(Rect(R2.Right - EdgeRounding, R2.Top, R2.Right - 1, R2.Top + EdgeRounding));
      Canvas.FillRect(Rect(R2.Left, R2.Bottom - EdgeRounding, R2.Left + EdgeRounding, R2.Bottom - 1));
    end;
    if Buttons.Count > 1 then
    begin
      // draw the separator lines
      Canvas.Pen.Style := psSolid;
      Y := R2.Top - 1;
      with TJvNavIconButton(FRealButtons[0]) do
      begin
        Left := R2.Left;
        Top := Y;
        Visible := True;
      end;
      // adjust the buttons and draw the dividers
      for i := 1 to Buttons.Count - 1 do
      begin
        with TJvNavIconButton(FRealButtons[i]) do
        begin
          Left := R2.Left + ButtonWidth * i - 1;
          Top := Y;
          Visible := true;
        end;
        Canvas.Pen.Color := clBtnFace;
        X := R2.Left + ButtonWidth * i;
        Canvas.MoveTo(X, R2.Top + 2);
        Canvas.LineTo(X, R2.Bottom - 4);
        Canvas.Pen.Color := clWhite;
        Canvas.MoveTo(X + 1, R2.Top + 3);
        Canvas.LineTo(X + 1, R2.Bottom - 3);
      end;
      // fill the rest of the client area
      Canvas.Brush.Color := Color;
      Inc(R.Top, HeaderHeight + ButtonHeight + EdgeRounding);
//      Dec(R.Right);
      Canvas.FillRect(R);
    end;
  finally
    Canvas.Unlock;
  end;
end;

procedure TJvNavPaneToolPanel.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
begin
  inherited;
  FCloseButton.SetBounds(ClientWidth - 22, 0, 22, HeaderHeight);
  if FCloseButton.Visible then
    FDropDown.SetBounds(FCloseButton.Left - 23, 0, 22, HeaderHeight)
  else
    FDropDown.SetBounds(ClientWidth - 22, 0, 22, HeaderHeight)
end;

procedure TJvNavPaneToolPanel.SetButtonColor(const Value: TColor);
begin
  if FButtonColor <> Value then
  begin
    FButtonColor := Value;
    Invalidate;
  end;
end;

procedure TJvNavPaneToolPanel.SetButtonHeight(const Value: integer);
begin
  if FButtonHeight <> Value then
  begin
    FButtonHeight := Value;
    Invalidate;
  end;
end;

procedure TJvNavPaneToolPanel.SetButtons(
  const Value: TJvNavPaneToolButtons);
begin
  FButtons := Value;
end;

procedure TJvNavPaneToolPanel.SetButtonWidth(const Value: integer);
begin
  if FButtonWidth <> Value then
  begin
    FButtonWidth := Value;
    Invalidate;
  end;
end;

procedure TJvNavPaneToolPanel.SetCloseButton(const Value: boolean);
begin
  if FCloseButton.Visible <> Value then
  begin
    FCloseButton.Visible := Value;
    SetBounds(Left, Top, Width, Height);
  end;
end;

procedure TJvNavPaneToolPanel.SetColorFrom(const Value: TColor);
begin
  if FColorFrom <> Value then
  begin
    FColorFrom := Value;
    Invalidate;
  end;
end;

procedure TJvNavPaneToolPanel.SetColorTo(const Value: TColor);
begin
  if FColorTo <> Value then
  begin
    FColorTo := Value;
    Invalidate;
  end;
end;

procedure TJvNavPaneToolPanel.SetDropDownMenu(const Value: TPopupMenu);
begin
  if FDropDown.DropDownMenu <> Value then
  begin
    FDropDown.DropDownMenu := Value;
    FDropDown.Visible := Value <> nil;
  end;
end;

procedure TJvNavPaneToolPanel.SetEdgeRounding(const Value: integer);
begin
  if FEdgeRounding <> Value then
  begin
    FEdgeRounding := Value;
    Invalidate;
  end;
end;

procedure TJvNavPaneToolPanel.SetHeaderHeight(const Value: integer);
begin
  if FHeaderHeight <> Value then
  begin
    FHeaderHeight := Value;
    Invalidate;
  end;
end;

procedure TJvNavPaneToolPanel.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then
  begin
    if FImages <> nil then
      FImages.UnregisterChanges(FChangeLink);
    FImages := Value;
    if FImages <> nil then
    begin
      FImages.RegisterChanges(FChangeLink);
      FImages.FreeNotification(Self);
    end;
    Invalidate;
  end;
end;

procedure TJvNavPaneToolPanel.SetShowGrabber(const Value: boolean);
begin
  if FShowGrabber <> Value then
  begin
    FShowGrabber := Value;
    Invalidate;
  end;
end;

procedure TJvNavPaneToolPanel.SetStyleManager(const Value: TJvNavPaneStyleManager);
begin
  if FStyleManager <> Value then
  begin
    if FStyleManager <> nil then
      FStyleManager.UnRegisterChanges(FStyleLink);
    FStyleManager := Value;
    if FStyleManager <> nil then
    begin
      FStyleManager.RegisterChanges(FStyleLink);
      FStyleManager.FreeNotification(Self);
      FColorFrom := FStyleManager.Colors.ButtonColorFrom;
      FColorTo := FStyleManager.Colors.ButtonColorTo;
      FButtonColor := FStyleManager.Colors.SplitterColorTo;
      FDropDown.StyleManager := FStyleManager;
      FCloseButton.StyleManager := FStyleManager;
      Invalidate;
    end;
  end;
end;

procedure TJvNavPaneToolPanel.TextChanged;
begin
  inherited;
  Invalidate;
end;

procedure TJvNavPaneToolPanel.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TJvNavPaneToolPanel.WMNCPaint(var Message: TWMNCPaint);
var
  AColor: TColor;
begin
  AColor := Color;
  Color := ButtonColor;
  inherited;
  Color := AColor;
end;

{ TJvNavPaneToolButton }

procedure TJvNavPaneToolButton.Assign(Source: TPersistent);
begin
  inherited;
end;

constructor TJvNavPaneToolButton.Create(Collection: TCollection);
begin
  inherited;
  FImageIndex := -1;
  FEnabled := True;
end;

procedure TJvNavPaneToolButton.SetEnabled(const Value: boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed(False);
  end;
end;

procedure TJvNavPaneToolButton.SetImageIndex(const Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed(False);
  end;
end;

{ TJvNavPaneToolButtons }

function TJvNavPaneToolButtons.Add: TJvNavPaneToolButton;
begin
  Result := TJvNavPaneToolButton(inherited Add);
end;

procedure TJvNavPaneToolButtons.Assign(Source: TPersistent);
begin
  inherited;
end;

constructor TJvNavPaneToolButtons.Create(AOwner: TJvNavPaneToolPanel);
begin
  inherited Create(AOwner, TJvNavPaneToolButton);
  FPanel := AOwner;
end;

function TJvNavPaneToolButtons.GetItem(Index: integer): TJvNavPaneToolButton;
begin
  Result := TJvNavPaneToolButton(inherited Items[Index]);
end;

procedure TJvNavPaneToolButtons.SetItem(Index: integer;
  const Value: TJvNavPaneToolButton);
begin
  inherited Items[Index] := Value;
end;

procedure TJvNavPaneToolButtons.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if FPanel <> nil then
    FPanel.ButtonsChanged;
end;

{ TObjectList }

initialization
  RegisterClasses([TJvNavPanelPage]);
end.

