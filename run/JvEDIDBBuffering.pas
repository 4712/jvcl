{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvEDIDBBuffering.PAS, released on 2004-04-05.

The Initial Developer of the Original Code is Raymond Alexander .
Portions created by Joe Doe are Copyright (C) 2004 Raymond Alexander.

All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

{$I jvcl.inc}

unit JvEDIDBBuffering;

interface

uses
  Windows, Messages, SysUtils, Classes, Contnrs,
  JvComponent, DB, JclEDI, JclEDI_ANSIX12, JclEDISEF;

const
  Field_SegmentId = 'SegmentId';
  Field_ElementId = 'ElementId';
  Field_ElementCount = 'ElementCount';
  Field_ElementType = 'ElementType';
  Field_MaximumLength = 'MaximumLength';
  Field_OwnerLoopId = 'OwnerLoopId';
  Field_ParentLoopId = 'ParentLoopId';

  FieldType_PKey = 'PKey';
  FieldType_FKey = 'FKey';
  TransactionSetKeyName = 'TS';

type

  TJvOnAfterProfiledTransactionSet = procedure(TransactionSet: TEDIObject) of object;
  TJvOnAfterProfiledSegment = procedure(Segment: TEDIObject) of object;

  //Base Class EDI Specification Profiler (TDataSet Compatible)
  TJvEDIDBProfiler = class(TJvComponent)
  private
    FElementProfiles: TDataSet;
    FSegmentProfiles: TDataSet;
    FLoopProfiles: TDataSet;
    FOnAfterProfiledTransactionSet: TJvOnAfterProfiledTransactionSet;
    FOnAfterProfiledSegment: TJvOnAfterProfiledSegment;
  protected
    procedure DoAfterProfiledTransactionSet(TransactionSet: TEDIObject); virtual;
    procedure DoAfterProfiledSegment(Segment: TEDIObject); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BuildProfile; virtual; abstract;
    procedure ClearProfile; virtual;
    procedure AddElement(SegmentId, ElementId, ElementType: string;
      MaximumLength: Integer); virtual;
    procedure UpdateElement(SegmentId, ElementId, ElementType: string; MaximumLength,
      Count: Integer); virtual;
    procedure AddSegment(SegmentId, OwnerLoopId, ParentLoopId: string); virtual;
    procedure AddLoop(OwnerLoopId, ParentLoopId: string); virtual;
    function ElementExist(SegmentId, ElementId: string): Boolean; virtual;
    function SegmentExist(SegmentId, OwnerLoopId, ParentLoopId: string): Boolean; virtual;
    function LoopExist(OwnerLoopId, ParentLoopId: string): Boolean; virtual;
  published
    property ElementProfiles: TDataSet read FElementProfiles write FElementProfiles;
    property SegmentProfiles: TDataSet read FSegmentProfiles write FSegmentProfiles;
    property LoopProfiles: TDataSet read FLoopProfiles write FLoopProfiles;
    property OnAfterProfiledTransactionSet: TJvOnAfterProfiledTransactionSet
      read FOnAfterProfiledTransactionSet write FOnAfterProfiledTransactionSet;
    property OnAfterProfiledSegment: TJvOnAfterProfiledSegment read FOnAfterProfiledSegment
      write FOnAfterProfiledSegment;
  end;

  //EDI Specification Profiler (JclEDI_ANSIX12.pas)
  TJvEDIDBSpecProfiler = class(TJvEDIDBProfiler)
  public
    procedure BuildProfile(EDIFileSpec: TEDIFileSpec); reintroduce;
  end;

  //Standard Exchange Format (SEF) EDI Specification Profiler (JclEDISEF.pas)
  TJvEDIDBSEFProfiler = class(TJvEDIDBProfiler)
  public
    procedure BuildProfile(EDISEFFile: TEDISEFFile); reintroduce;
  end;

  TJvEDIFieldDef = class(TCollectionItem)
  private
    FFieldName: string;
    FFieldType: string;
    FDataType: TFieldType;
    FMaximumLength: Integer;
    FUpdateStatus: TUpdateStatus;
  public
    constructor Create(Collection: TCollection); override;
  published
    property FieldName: string read FFieldName write FFieldName;
    property FieldType: string read FFieldType write FFieldType;
    property DataType: TFieldType read FDataType write FDataType;
    property MaximumLength: Integer read FMaximumLength write FMaximumLength;
    property UpdateStatus: TUpdateStatus read FUpdateStatus write FUpdateStatus;
  end;

  TJvEDIFieldDefs = class(TCollection)
  private
    function GetItem(Index: Integer): TJvEDIFieldDef;
    procedure SetItem(Index: Integer; Value: TJvEDIFieldDef);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add: TJvEDIFieldDef;
    property Items[Index: Integer]: TJvEDIFieldDef read GetItem write SetItem; default;
  end;

  TJvOnTableExistsEvent = procedure(TableName: string; var TableExists: Boolean) of object;
  TJvOnTableProfileEvent = procedure(FieldDefs: TJvEDIFieldDefs; TableName: string) of object;
  TJvOnCreateTableEvent = TJvOnTableProfileEvent;
  TJvOnCheckForFieldChangesEvent = TJvOnTableProfileEvent;
  TJvOnAlterTableEvent = TJvOnTableProfileEvent;
  TJvOnResolveFieldDefTypeEvent = procedure(FieldDef: TJvEDIFieldDef) of object;
  TJvOnBeforeApplyElementFilterEvent = procedure(DataSet: TDataSet; TableName: string;
    var ApplyFilter: Boolean) of object;

  TJvEDIDBBuffer = class(TJvComponent)
  private
    { Private declarations }
    FElementProfiles: TDataSet;
    FSegmentProfiles: TDataSet;
    FLoopProfiles: TDataSet;
    FLoopKeyPrefix: string;
    FSegmentKeyPrefix: string;
    FKeySuffix: string;
    FElementNonKeyPrefix: string;
    FOnBeforeOpenDataSets: TNotifyEvent;
    FOnAfterOpenDataSets: TNotifyEvent;
    FOnBeforeCloseDataSets: TNotifyEvent;
    FOnAfterCloseDataSets: TNotifyEvent;
    FOnTableExists: TJvOnTableExistsEvent;
    FOnCreateTable: TJvOnCreateTableEvent;
    FOnCheckForFieldChanges: TJvOnCheckForFieldChangesEvent;
    FOnAlterTable: TJvOnAlterTableEvent;
    FOnResolveFieldDefDataType: TJvOnResolveFieldDefTypeEvent;
    FOnBeforeApplyElementFilter: TJvOnBeforeApplyElementFilterEvent;
    procedure CreateFieldDefs(FieldDefs: TJvEDIFieldDefs; TableName, OwnerLoopId,
      ParentLoopId: string; DefaultUpdateStatus: TUpdateStatus);
    procedure CreateLoopFieldDefs(FieldDefs: TJvEDIFieldDefs; TableName, ParentLoopId: string;
      DefaultUpdateStatus: TUpdateStatus);
  protected
    { Protected declarations }
    procedure DoBeforeOpenDataSets; virtual;
    procedure DoAfterOpenDataSets; virtual;
    procedure DoBeforeCloseDataSets; virtual;
    procedure DoAfterCloseDataSets; virtual;
    procedure DoTableExists(TableName: string; var TableExists: Boolean); virtual;
    procedure DoCreateTable(FieldDefs: TJvEDIFieldDefs; TableName: string); virtual;
    procedure DoCheckForFieldChanges(FieldDefs: TJvEDIFieldDefs; TableName: string); virtual;
    procedure DoAlterTable(FieldDefs: TJvEDIFieldDefs; TableName: string); virtual;
    procedure DoResolveFieldDefDataType(FieldDef: TJvEDIFieldDef); virtual;
    procedure DoBeforeApplyElementFilter(DataSet: TDataSet; Table: string;
      var ApplyFilter: Boolean); virtual;
    //
    procedure OpenProfileDataSets; virtual;
    procedure CloseProfileDataSets; virtual;
    function TableExists(TableName: string): Boolean; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SyncProfilesWithBuffer; virtual;
  published
    { Published declarations }
    property ElementProfiles: TDataSet read FElementProfiles write FElementProfiles;
    property SegmentProfiles: TDataSet read FSegmentProfiles write FSegmentProfiles;
    property LoopProfiles: TDataSet read FLoopProfiles write FLoopProfiles;
    //
    property KeySuffix: string read FKeySuffix write FKeySuffix;
    property LoopKeyPrefix: string read FLoopKeyPrefix write FLoopKeyPrefix;
    property SegmentKeyPrefix: string read FSegmentKeyPrefix write FSegmentKeyPrefix;
    property ElementNonKeyPrefix: string read FElementNonKeyPrefix write FElementNonKeyPrefix;
    //
    property OnBeforeOpenDataSets: TNotifyEvent read FOnBeforeOpenDataSets
      write FOnBeforeOpenDataSets;
    property OnAfterOpenDataSets: TNotifyEvent read FOnAfterOpenDataSets
      write FOnAfterOpenDataSets;
    property OnBeforeCloseDataSets: TNotifyEvent read FOnBeforeCloseDataSets
      write FOnBeforeCloseDataSets;
    property OnAfterCloseDataSets: TNotifyEvent read FOnAfterCloseDataSets
      write FOnAfterCloseDataSets;
    property OnTableExists: TJvOnTableExistsEvent read FOnTableExists write FOnTableExists;
    property OnCreateTable: TJvOnCreateTableEvent read FOnCreateTable write FOnCreateTable;
    property OnCheckForFieldChanges: TJvOnCheckForFieldChangesEvent read FOnCheckForFieldChanges
      write FOnCheckForFieldChanges;
    property OnAlterTable: TJvOnAlterTableEvent read FOnAlterTable write FOnAlterTable;
    property OnResolveFieldDefType: TJvOnResolveFieldDefTypeEvent read FOnResolveFieldDefDataType
      write FOnResolveFieldDefDataType;
    property OnBeforeApplyElementFilter: TJvOnBeforeApplyElementFilterEvent
      read FOnBeforeApplyElementFilter write FOnBeforeApplyElementFilter;
  end;

implementation
{$IFDEF COMPILER6_UP}
uses
  Variants;
{$ENDIF COMPILER6_UP}

const
  Default_LoopKeyPrefix = 'Loop_';
  Default_KeySuffix = '_Id';
  Default_SegmentKeyPrefix = '';
  Default_ElementNonKeyPrefix = 'E';

{ TJvEDIDBProfiler }

procedure TJvEDIDBProfiler.AddElement(SegmentId, ElementId, ElementType: string;
  MaximumLength: Integer);
begin
  with FElementProfiles do
  begin
    Insert;
    FieldByName(Field_SegmentId).AsString := SegmentId;
    FieldByName(Field_ElementId).AsString := ElementId;
    FieldByName(Field_ElementCount).AsInteger := 1;
    FieldByName(Field_ElementType).AsString := ElementType;
    FieldByName(Field_MaximumLength).AsInteger := MaximumLength;
    Post;
  end;
end;

procedure TJvEDIDBProfiler.AddLoop(OwnerLoopId, ParentLoopId: string);
begin
  with FLoopProfiles do
  begin
    Insert;
    FieldByName(Field_OwnerLoopId).AsString := OwnerLoopId;
    FieldByName(Field_ParentLoopId).AsString := ParentLoopId;
    Post;
  end;
end;

procedure TJvEDIDBProfiler.AddSegment(SegmentId, OwnerLoopId, ParentLoopId: string);
begin
  with FSegmentProfiles do
  begin
    Insert;
    FieldByName(Field_SegmentId).AsString := SegmentId;
    FieldByName(Field_OwnerLoopId).AsString := OwnerLoopId;
    FieldByName(Field_ParentLoopId).AsString := ParentLoopId;
    Post;
  end;
end;

procedure TJvEDIDBProfiler.ClearProfile;
begin
  FElementProfiles.First;
  while not FElementProfiles.Eof do
  begin
    FElementProfiles.Delete;
  end;
  FSegmentProfiles.First;
  while not FSegmentProfiles.Eof do
  begin
    FSegmentProfiles.Delete;
  end;
  FLoopProfiles.First;
  while not FLoopProfiles.Eof do
  begin
    FLoopProfiles.Delete;
  end;
end;

constructor TJvEDIDBProfiler.Create(AOwner: TComponent);
begin
  FElementProfiles := nil;
  FSegmentProfiles := nil;
  FLoopProfiles := nil;
  inherited;
end;

destructor TJvEDIDBProfiler.Destroy;
begin
  FElementProfiles := nil;
  FSegmentProfiles := nil;
  FLoopProfiles := nil;
  inherited;
end;

procedure TJvEDIDBProfiler.DoAfterProfiledSegment(Segment: TEDIObject);
begin
  if Assigned(FOnAfterProfiledSegment) then
  begin
    FOnAfterProfiledSegment(Segment);
  end;
end;

procedure TJvEDIDBProfiler.DoAfterProfiledTransactionSet(TransactionSet: TEDIObject);
begin
  if Assigned(FOnAfterProfiledTransactionSet) then
  begin
    FOnAfterProfiledTransactionSet(TransactionSet);
  end;
end;

function TJvEDIDBProfiler.ElementExist(SegmentId, ElementId: string): Boolean;
begin
  FElementProfiles.First;
  Result := FElementProfiles.Locate(Field_SegmentId + ';' + Field_ElementId,
                                    VarArrayOf([SegmentId, ElementId]), [loCaseInsensitive]);
end;

function TJvEDIDBProfiler.LoopExist(OwnerLoopId, ParentLoopId: string): Boolean;
begin
  FLoopProfiles.First;
  Result := FLoopProfiles.Locate(Field_OwnerLoopId + ';' + Field_ParentLoopId,
                                 VarArrayOf([OwnerLoopId, ParentLoopId]), [loCaseInsensitive]);
end;

function TJvEDIDBProfiler.SegmentExist(SegmentId, OwnerLoopId, ParentLoopId: string): Boolean;
begin
  FSegmentProfiles.First;
  Result := FSegmentProfiles.Locate(Field_SegmentId + ';' + Field_OwnerLoopId + ';' +
              Field_ParentLoopId, VarArrayOf([SegmentId, OwnerLoopId, ParentLoopId]),
              [loCaseInsensitive]);
end;

procedure TJvEDIDBProfiler.UpdateElement(SegmentId, ElementId, ElementType: string; MaximumLength,
  Count: Integer);
begin
  with FElementProfiles do
  begin
    Edit;
    if Count > FieldByName(Field_ElementCount).AsInteger then
    begin
      FieldByName(Field_ElementCount).AsInteger := Count;
    end;
    FieldByName(Field_ElementType).AsString := ElementType;
    if MaximumLength > FieldByName(Field_MaximumLength).AsInteger then
    begin
      FieldByName(Field_MaximumLength).AsInteger := MaximumLength;
    end;
    Post;
  end;
end;

{ TJvEDIDBSpecProfiler }

procedure TJvEDIDBSpecProfiler.BuildProfile(EDIFileSpec: TEDIFileSpec);
var
  I, F, T, S, E: Integer;
  TransactionSet: TEDITransactionSetSpec;
  Segment: TEDISegmentSpec;
  Element: TEDIElementSpec;
  RecordExists: Boolean;
  ElementList: TStrings;
begin
  if (FElementProfiles = nil) or (FSegmentProfiles = nil) or (FLoopProfiles = nil) then
  begin
    raise Exception.Create('Not all profile datasets have been assigned.');
  end;
  FElementProfiles.Filtered := False;
  FSegmentProfiles.Filtered := False;
  FLoopProfiles.Filtered := False;
  ElementList := TStringList.Create;
  for I := 0 to EDIFileSpec.InterchangeControlCount - 1 do
  begin
    for F := 0 to EDIFileSpec[I].FunctionalGroupCount - 1 do
    begin
      for T := 0 to EDIFileSpec[I][F].TransactionSetCount - 1 do
      begin
        TransactionSet := TEDITransactionSetSpec(EDIFileSpec[I][F][T]);
        for S := 0 to TransactionSet.SegmentCount - 1 do
        begin
          ElementList.Clear;
          Segment := TEDISegmentSpec(TransactionSet[S]);
          RecordExists := LoopExist(Segment.OwnerLoopId, Segment.ParentLoopId);
          if not RecordExists then
          begin
            AddLoop(Segment.OwnerLoopId, Segment.ParentLoopId);
          end;
          RecordExists := SegmentExist(Segment.SegmentID, Segment.OwnerLoopId,
                                       Segment.ParentLoopId);
          if not RecordExists then
          begin
            AddSegment(Segment.SegmentID, Segment.OwnerLoopId, Segment.ParentLoopId);
          end;
          for E := 0 to Segment.ElementCount - 1 do
          begin
            Element := TEDIElementSpec(Segment.Element[E]);
            if ElementList.Values[Element.Id] = '' then
            begin
              ElementList.Values[Element.Id] := '0';
            end;
            ElementList.Values[Element.Id] :=
              IntToStr(StrToInt(ElementList.Values[Element.Id]) + 1);
            RecordExists := ElementExist(Segment.SegmentID, Element.Id);
            if not RecordExists then
            begin
              AddElement(Segment.SegmentID, Element.Id, Element.ElementType, Element.MaximumLength);
            end
            else
            begin
              UpdateElement(Segment.SegmentID, Element.Id, Element.ElementType,
                            Element.MaximumLength, StrToInt(ElementList.Values[Element.Id]));
            end;
            //
          end; //for E
          DoAfterProfiledSegment(Segment);
        end; //for S
        DoAfterProfiledTransactionSet(TransactionSet);
      end; //for T
    end; //for F
  end; //for I
  ElementList.Free;
end;

{ TJvEDIDBSEFProfiler }

procedure TJvEDIDBSEFProfiler.BuildProfile(EDISEFFile: TEDISEFFile);
var
  E, I, J: Integer;
  RecordExists: Boolean;
  ElementStrList: TStrings;
  Id: string;

  SEFSet: TEDISEFSet;
  SEFSegment: TEDISEFSegment;
  SEFElement: TEDISEFElement;

  SegmentList: TObjectList;
  ElementList: TObjectList;
begin
  if (FElementProfiles = nil) or (FSegmentProfiles = nil) or (FLoopProfiles = nil) then
  begin
    raise Exception.Create('Not all profile datasets have been assigned.');
  end;
  FElementProfiles.Filtered := False;
  FSegmentProfiles.Filtered := False;
  FLoopProfiles.Filtered := False;
  for I := 0 to EDISEFFile.SETS.Count - 1 do
  begin
    SEFSet := TEDISEFSet(EDISEFFile.SETS[I]);
    SegmentList := SEFSet.GetSegmentObjectList;
    try
      for J := 0 to SegmentList.Count - 1 do
      begin
        SEFSegment := TEDISEFSegment(SegmentList[J]);
        RecordExists := LoopExist(SEFSegment.OwnerLoopId, SEFSegment.ParentLoopId);
        if not RecordExists then
          AddLoop(SEFSegment.OwnerLoopId, SEFSegment.ParentLoopId);
        RecordExists := SegmentExist(SEFSegment.SegmentID, SEFSegment.OwnerLoopId,
          SEFSegment.ParentLoopId);
        if not RecordExists then
          AddSegment(SEFSegment.SegmentID, SEFSegment.OwnerLoopId, SEFSegment.ParentLoopId);
        ElementList := SEFSegment.GetElementObjectList;
        ElementStrList := TStringList.Create;
        try
          ElementStrList.Clear;
          for E := 0 to ElementList.Count - 1 do
          begin
            if ElementList[E] is TEDISEFElement then
            begin
              SEFElement := TEDISEFElement(ElementList[E]);
              Id := SEFSegment.Id + SEFElement.Id;
              if ElementStrList.Values[Id] = '' then
              begin
                ElementStrList.Values[Id] := '0';
              end;
              ElementStrList.Values[Id] :=
                IntToStr(StrToInt(ElementStrList.Values[Id]) + 1);
              RecordExists := ElementExist(SEFSegment.Id, SEFElement.Id);
              if not RecordExists then
              begin
                AddElement(SEFSegment.Id, SEFElement.Id, SEFElement.ElementType,
                  SEFElement.MaximumLength);
              end
              else
              begin
                UpdateElement(SEFSegment.Id, SEFElement.Id, SEFElement.ElementType,
                              SEFElement.MaximumLength, StrToInt(ElementStrList.Values[Id]));
              end; //if
            end; //if
          end; //for E
        finally
          ElementStrList.Free;
          ElementList.Free;
        end; //try
        DoAfterProfiledSegment(SEFSegment);
      end; //for J
    finally
      SegmentList.Free;
    end; //try
    DoAfterProfiledTransactionSet(SEFSet);
  end; //for I
end;

{ TJclEDIFieldDef }

constructor TJvEDIFieldDef.Create(Collection: TCollection);
begin
  inherited;
  FUpdateStatus := usUnmodified;
end;

{ TJvEDIFieldDefs }

function TJvEDIFieldDefs.Add: TJvEDIFieldDef;
begin
  Result := TJvEDIFieldDef(inherited Add);
end;

function TJvEDIFieldDefs.GetItem(Index: Integer): TJvEDIFieldDef;
begin
  Result := TJvEDIFieldDef(inherited GetItem(Index));
end;

procedure TJvEDIFieldDefs.SetItem(Index: Integer; Value: TJvEDIFieldDef);
begin
  inherited SetItem(Index, Value);
end;

procedure TJvEDIFieldDefs.Update(Item: TCollectionItem);
begin
  inherited;
end;

{ TJvEDIDBBuffer }

procedure TJvEDIDBBuffer.CloseProfileDataSets;
begin
  DoBeforeCloseDataSets;
  if FLoopProfiles.Active then
    FLoopProfiles.Close;
  if FLoopProfiles.Active then
    FElementProfiles.Close;
  if FLoopProfiles.Active then
    FSegmentProfiles.Close;
  DoAfterCloseDataSets;
end;

constructor TJvEDIDBBuffer.Create(AOwner: TComponent);
begin
  inherited;
  FLoopKeyPrefix := Default_LoopKeyPrefix;
  FKeySuffix := Default_KeySuffix;
  FSegmentKeyPrefix := Default_SegmentKeyPrefix;
  FElementNonKeyPrefix := Default_ElementNonKeyPrefix;
end;

destructor TJvEDIDBBuffer.Destroy;
begin
  inherited;
end;

procedure TJvEDIDBBuffer.DoAfterOpenDataSets;
begin
  if Assigned(FOnAfterOpenDataSets) then
    FOnAfterOpenDataSets(Self);
end;

procedure TJvEDIDBBuffer.DoAlterTable(FieldDefs: TJvEDIFieldDefs; TableName: string);
begin
  if Assigned(FOnAlterTable) then
    FOnAlterTable(FieldDefs, TableName);
end;

procedure TJvEDIDBBuffer.DoBeforeCloseDataSets;
begin
  if Assigned(FOnBeforeCloseDataSets) then
    FOnBeforeCloseDataSets(Self);
end;

procedure TJvEDIDBBuffer.DoAfterCloseDataSets;
begin
  if Assigned(FOnAfterCloseDataSets) then
    FOnAfterCloseDataSets(Self);
end;

procedure TJvEDIDBBuffer.DoBeforeOpenDataSets;
begin
  if Assigned(FOnBeforeOpenDataSets) then
    FOnBeforeOpenDataSets(Self);
end;

procedure TJvEDIDBBuffer.DoCheckForFieldChanges(FieldDefs: TJvEDIFieldDefs; TableName: string);
begin
  if Assigned(FOnCheckForFieldChanges) then
    FOnCheckForFieldChanges(FieldDefs, TableName);
end;

procedure TJvEDIDBBuffer.DoCreateTable(FieldDefs: TJvEDIFieldDefs; TableName: string);
begin
  if Assigned(FOnCreateTable) then
    FOnCreateTable(FieldDefs, TableName);
end;

procedure TJvEDIDBBuffer.DoTableExists(TableName: string; var TableExists: Boolean);
begin
  if Assigned(FOnTableExists) then
    FOnTableExists(TableName, TableExists);
end;

procedure TJvEDIDBBuffer.CreateFieldDefs(FieldDefs: TJvEDIFieldDefs; TableName, OwnerLoopId,
  ParentLoopId: string; DefaultUpdateStatus: TUpdateStatus);
var
  FieldDef: TJvEDIFieldDef;
  ApplyFilter: Boolean;
  I: Integer;
begin
  FieldDefs.Clear;
  //Primary Key
  FieldDef := FieldDefs.Add;
  FieldDef.FieldName := FSegmentKeyPrefix + TableName + FKeySuffix; //Primary Key
  FieldDef.FieldType := FieldType_PKey;
  FieldDef.DataType := ftInteger;
  FieldDef.MaximumLength := 1;
  FieldDef.UpdateStatus := DefaultUpdateStatus;
  //Foreign Key
  FieldDef := FieldDefs.Add;
  if (OwnerLoopId = NA_LoopId) or (OwnerLoopId = '') then
    FieldDef.FieldName := TransactionSetKeyName + FKeySuffix //Transaction Set Foreign Key
  else
    FieldDef.FieldName := FLoopKeyPrefix + OwnerLoopId + FKeySuffix; //Loop Foreign Key
  FieldDef.FieldType := FieldType_FKey;
  FieldDef.DataType := ftInteger;
  FieldDef.MaximumLength := 1;
  FieldDef.UpdateStatus := DefaultUpdateStatus;
  //Fields
  ApplyFilter := True;
  DoBeforeApplyElementFilter(FElementProfiles, TableName, ApplyFilter);
  if ApplyFilter then
  begin
    FElementProfiles.Filtered := False;
    FElementProfiles.Filter := Field_SegmentId + ' = ' + QuotedStr(TableName);
    FElementProfiles.Filtered := True;
  end;
  FElementProfiles.First;
  while not FElementProfiles.Eof do
  begin
    for I := 1 to FElementProfiles.FieldByName(Field_ElementCount).AsInteger do
    begin
      FieldDef := FieldDefs.Add;
      FieldDef.FieldName := FElementNonKeyPrefix + FElementProfiles.FieldByName(Field_ElementId).AsString + '_' + IntToStr(I);
      FieldDef.FieldType := FElementProfiles.FieldByName(Field_ElementType).AsString;
      if FieldDef.FieldType = '' then
        FieldDef.DataType := ftString
      else if FieldDef.FieldType[1] = EDIDataType_Numeric then
        FieldDef.DataType := ftInteger
      else if FieldDef.FieldType = EDIDataType_Decimal then
        FieldDef.DataType := ftFloat
      else if FieldDef.FieldType = EDIDataType_Identifier then
        FieldDef.DataType := ftString
      else if FieldDef.FieldType = EDIDataType_String then
        FieldDef.DataType := ftString
      else if FieldDef.FieldType = EDIDataType_Date then
        FieldDef.DataType := ftDate
      else if FieldDef.FieldType = EDIDataType_Time then
        FieldDef.DataType := ftTime
      else if FieldDef.FieldType = EDIDataType_Binary then
        FieldDef.DataType := ftBlob
      else
        FieldDef.DataType := ftString;
      FieldDef.MaximumLength := FElementProfiles.FieldByName(Field_MaximumLength).AsInteger;
      FieldDef.UpdateStatus := DefaultUpdateStatus;
      DoResolveFieldDefDataType(FieldDef);
    end;
    FElementProfiles.Next;
  end; //while
end;

procedure TJvEDIDBBuffer.OpenProfileDataSets;
begin
  DoBeforeOpenDataSets;
  FSegmentProfiles.Open;
  FElementProfiles.Open;
  FLoopProfiles.Open;
  DoAfterOpenDataSets;
end;

procedure TJvEDIDBBuffer.SyncProfilesWithBuffer;
var
  TableName, OwnerLoopId, ParentLoopId: string;
  FieldDefs: TJvEDIFieldDefs;
begin
  FieldDefs := TJvEDIFieldDefs.Create(TJvEDIFieldDef);
  OpenProfileDataSets;
  while not FLoopProfiles.Eof do
  begin
    OwnerLoopId := FLoopProfiles.FieldByName(Field_OwnerLoopId).AsString;
    TableName := FLoopKeyPrefix + OwnerLoopId;
    ParentLoopId := FLoopProfiles.FieldByName(Field_ParentLoopId).AsString;
    if (OwnerLoopId <> NA_LoopId) and (not TableExists(TableName)) then
    begin
      CreateLoopFieldDefs(FieldDefs, TableName, ParentLoopId, usInserted);
      DoCreateTable(FieldDefs, TableName);
    end
    else if OwnerLoopId <> NA_LoopId then
    begin
      CreateLoopFieldDefs(FieldDefs, TableName, ParentLoopId, usUnmodified);
      DoCheckForFieldChanges(FieldDefs, TableName);
      DoAlterTable(FieldDefs, TableName);
    end;
    FLoopProfiles.Next;
  end;  
  while not FSegmentProfiles.Eof do
  begin
    TableName := FSegmentProfiles.FieldByName(Field_SegmentId).AsString;
    OwnerLoopId := FSegmentProfiles.FieldByName(Field_OwnerLoopId).AsString;
    ParentLoopId := FSegmentProfiles.FieldByName(Field_ParentLoopId).AsString;
    if not TableExists(TableName) then
    begin
      CreateFieldDefs(FieldDefs, TableName, OwnerLoopId, ParentLoopId, usInserted);
      DoCreateTable(FieldDefs, TableName);
    end
    else
    begin
      CreateFieldDefs(FieldDefs, TableName, OwnerLoopId, ParentLoopId, usUnmodified);
      DoCheckForFieldChanges(FieldDefs, TableName);
      DoAlterTable(FieldDefs, TableName);
    end;
    FSegmentProfiles.Next;
  end;
  CloseProfileDataSets;
  FieldDefs.Free;
end;

function TJvEDIDBBuffer.TableExists(TableName: string): Boolean;
begin
  Result := False;
  DoTableExists(TableName, Result);
end;

procedure TJvEDIDBBuffer.DoResolveFieldDefDataType(FieldDef: TJvEDIFieldDef);
begin
  if Assigned(FOnResolveFieldDefDataType) then
    FOnResolveFieldDefDataType(FieldDef);
end;

procedure TJvEDIDBBuffer.CreateLoopFieldDefs(FieldDefs: TJvEDIFieldDefs;
  TableName, ParentLoopId: string; DefaultUpdateStatus: TUpdateStatus);
var
  FieldDef: TJvEDIFieldDef;
begin
  FieldDefs.Clear;
  if TableName = 'N/A' then
    Exit;
  //Primary Key
  FieldDef := FieldDefs.Add;
  FieldDef.FieldName := TableName + FKeySuffix; //Primary Key
  FieldDef.FieldType := FieldType_PKey;
  FieldDef.DataType := ftInteger;
  FieldDef.MaximumLength := 1;
  FieldDef.UpdateStatus := DefaultUpdateStatus;
  //Foriegn Key
  FieldDef := FieldDefs.Add;
  if (ParentLoopId = NA_LoopId) or (ParentLoopId = '') then
    FieldDef.FieldName := TransactionSetKeyName + FKeySuffix //Transaction Set Foreign Key
  else
    FieldDef.FieldName := FLoopKeyPrefix + ParentLoopId + FKeySuffix; //Foreign Key
  FieldDef.FieldType := FieldType_FKey;
  FieldDef.DataType := ftInteger;
  FieldDef.MaximumLength := 1;
  FieldDef.UpdateStatus := DefaultUpdateStatus;
end;

procedure TJvEDIDBBuffer.DoBeforeApplyElementFilter(DataSet: TDataSet; Table: string;
  var ApplyFilter: Boolean);
begin
  if Assigned(FOnBeforeApplyElementFilter) then
    FOnBeforeApplyElementFilter(DataSet, Table, ApplyFilter);
end;

end.
