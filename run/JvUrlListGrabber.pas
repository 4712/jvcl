{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvUrlListGrabber.Pas, released on 2003-08-04.

The Initial Developer of the Original Code is Olivier Sannier [obones@meloo.com]
Portions created by Olivier Sannier are Copyright (C) 2003 Olivier Sannier.
All Rights Reserved.

Contributor(s): -

Last Modified: 2003-11-02

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvUrlListGrabber;

interface

uses Windows, Classes, SysUtils, JvComponent, JvUrlGrabbers;

type
  // early declarations
  TJvUrlListGrabber = class;

  // A Grabber index, defined as a new type to allow to give it
  // a specific property editor 
  TJvUrlGrabberIndex = type Integer;

  // The type of the events triggered when one of the grabbers
  // has triggred its own event to indicate a change in its state
  TJvGrabberNotifyEvent = procedure (Sender : TJvUrlListGrabber; Grabber : TJvUrlGrabber) of object;

  ENoGrabberForUrl = class (Exception);

  // This component allows the user to specify a list of URLs to be
  // grabbed and then start grabbing. All the grab operations will be done
  // in parallel in the background, leaving the user's application free
  // to continue its operations
  TJvUrlListGrabber = class (TJvComponent)
  protected
    FOnClosed: TJvGrabberNotifyEvent;
    FOnReceiving: TJvGrabberNotifyEvent;
    FOnResolving: TJvGrabberNotifyEvent;
    FOnReceived: TJvGrabberNotifyEvent;
    FOnConnecting: TJvGrabberNotifyEvent;
    FOnRequest: TJvGrabberNotifyEvent;
    FOnConnected: TJvGrabberNotifyEvent;
    FOnResolved: TJvGrabberNotifyEvent;
    FOnSent: TJvGrabberNotifyEvent;
    FOnClosing: TJvGrabberNotifyEvent;
    FOnSending: TJvGrabberNotifyEvent;

    FCleanupThreshold: Cardinal;
    FGrabbers : TJvUrlGrabberList;
    FURLs : TStrings;
    FDefaultGrabberIndex: TJvUrlGrabberIndex;
    FDefaultGrabbersProperties : TJvUrlGrabberDefaultPropertiesList;

    // sets the Default Grabber value, ensuring that it doesn't go
    // below -1 or above the number of registered grabber classes
    // if you try to set the value above the last index in the
    // JvUrlGrabberClassList, then the value will be set to -1.
    // The same goes if you set a value below -1.
    procedure SetDefaultGrabberIndex(const Value: TJvUrlGrabberIndex);

    // returns the grabber associated with the given index
    function GetGrabbers(const Index: Integer): TJvUrlGrabber;

    // Called whenever the list of Urls has changed
    procedure URLsChange(Sender : TObject);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    // cleans up the internal list of grabbers
    procedure Cleanup;

    // starts all the grabbers
    procedure StartAll;

    // stops all the grabbers
    procedure StopAll;

    // the Grabber objects associated with the Urls
    property Grabbers[const Index : Integer]: TJvUrlGrabber read GetGrabbers;
  published
    // the index of the default grabber to use, if any
    property DefaultGrabberIndex : TJvUrlGrabberIndex read FDefaultGrabberIndex write SetDefaultGrabberIndex default -1;

    // the cleanup threshold. When the difference between Urls.Count
    // and the internal Grabber count is greater than this value
    // the process of cleaning if launched. This can take some time
    // and this is why it's done every time
    property CleanupThreshold : Cardinal read FCleanupThreshold write FCleanupThreshold default 10;

    // The Urls to grab
    property URLs : TStrings read FURLs;

    // The default properties for each family of grabber
    property DefaultGrabbersProperties : TJvUrlGrabberDefaultPropertiesList read FDefaultGrabbersProperties;

    // Events
    property OnResolvingName      : TJvGrabberNotifyEvent read FOnResolving  write FOnResolving;
    property OnNameResolved       : TJvGrabberNotifyEvent read FOnResolved   write FOnResolved;
    property OnConnectingToServer : TJvGrabberNotifyEvent read FOnConnecting write FOnConnecting;
    property OnConnectedToServer  : TJvGrabberNotifyEvent read FOnConnected  write FOnConnected;
    property OnSendingRequest     : TJvGrabberNotifyEvent read FOnSending    write FOnSending;
    property OnRequestSent        : TJvGrabberNotifyEvent read FOnSent       write FOnSent;
    property OnRequestComplete    : TJvGrabberNotifyEvent read FOnRequest    write FOnRequest;
    property OnReceivingResponse  : TJvGrabberNotifyEvent read FOnReceiving  write FOnReceiving;
    property OnResponseReceived   : TJvGrabberNotifyEvent read FOnReceived   write FOnReceived;
    property OnClosingConnection  : TJvGrabberNotifyEvent read FOnClosing    write FOnClosing;
    property OnConnectionClosed   : TJvGrabberNotifyEvent read FOnClosed     write FOnClosed;
//    property OnRedirect: TGrabberNotifyEvent read FOnRedirect write FOnRedirect;
//    property OnStateChange: TGrabberNotifyEvent read FOnStateChange write FOnStateChange;
  end;

implementation

uses JvConsts;

{ TJvUrlListGrabber }

procedure TJvUrlListGrabber.Cleanup;
var
  i : Integer;
begin
  // try to find each created grabber in the string list
  // if not found, mark the object as nil which in turn
  // will delete it
  for i := 0 to FGrabbers.Count - 1 do
  begin
    if FUrls.IndexOfObject(FGrabbers[i]) = -1 then
    begin
      FGrabbers[i] := nil;
    end;
  end;

  // pack the list
  FGrabbers.Pack;
end;

constructor TJvUrlListGrabber.Create(AOwner: TComponent);
begin
  inherited;
  FDefaultGrabbersProperties := TJvUrlGrabberDefaultPropertiesList.Create;
  FGrabbers := TJvUrlGrabberList.Create(True);
  FURLs := TStringList.Create;
  TStringList(FURLs).OnChange := URLsChange;
  FDefaultGrabberIndex := -1;
  FCleanupThreshold := 10;
end;

destructor TJvUrlListGrabber.Destroy;
begin
  FURLs.Free;
  FGrabbers.Free;
  FDefaultGrabbersProperties.Free;
  inherited;
end;

function TJvUrlListGrabber.GetGrabbers(const Index: Integer): TJvUrlGrabber;
begin
  Result := TJvUrlGrabber(FURLs.Objects[Index]);
end;

procedure TJvUrlListGrabber.SetDefaultGrabberIndex(
  const Value: TJvUrlGrabberIndex);
begin
  if Value < -1 then
    FDefaultGrabberIndex := -1
  else if Value > JvUrlGrabberClassList.Count - 1 then
    FDefaultGrabberIndex := -1
  else
    FDefaultGrabberIndex := Value;
end;

procedure TJvUrlListGrabber.StartAll;
var
  i : Integer;
begin
  for i := 0 to FUrls.Count - 1 do
  begin
    Grabbers[i].Start;
  end;
end;

procedure TJvUrlListGrabber.StopAll;
var
  i : Integer;
begin
  for i := 0 to FUrls.Count - 1 do
  begin
    Grabbers[i].Stop;
  end;
end;

procedure TJvUrlListGrabber.URLsChange(Sender: TObject);
var
  i : Integer;
  tmpGrabber : TJvUrlGrabber;
begin
  for i := 0 to FUrls.Count - 1 do
  begin
    if not Assigned(FUrls.Objects[i]) then
    begin
      tmpGrabber := JvUrlGrabberClassList.CreateFor(FUrls[i], FDefaultGrabbersProperties);
      if Assigned(tmpGrabber) then
        FUrls.Objects[i] := tmpGrabber
      else if DefaultGrabberIndex > -1 then
        FUrls.Objects[i] := JvUrlGrabberClassList[DefaultGrabberIndex].Create(FUrls[i], FDefaultGrabbersProperties.Items[DefaultGrabberIndex])
      else
        raise ENoGrabberForUrl.CreateFmt(sENoGrabberForUrl, [FUrls[i]]);

      // add in the list of owned objects
      FGrabbers.Add(TJvUrlGrabber(FUrls.Objects[i]));
      if Cardinal(FGrabbers.Count - FUrls.Count) > FCleanupThreshold then
        Cleanup;
    end;
  end;
end;

end.
