{******************************************************************************}
{                        UNIFIED INTERBASE (UIB)                               }
{                                                                              }
{ Project JEDI Code Library (JCL)                                              }
{                                                                              }
{ The contents of this file are subject to the Mozilla Public License Version  }
{ 1.0 (the "License"); you may not use this file except in compliance with the }
{ License. You may obtain a copy of the License at http://www.mozilla.org/MPL/ }
{                                                                              }
{ Software distributed under the License is distributed on an "AS IS" basis,   }
{ WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for }
{ the specific language governing rights and limitations under the License.    }
{                                                                              }
{ The Original Code is JvUIBLib.pas.                                           }
{                                                                              }
{ The Initial Developer of the Original Code is documented in the accompanying }
{ help file JCL.chm. Portions created by these individuals are Copyright (C)   }
{ 2000 of these individuals.                                                   }
{                                                                              }
{ Interbase & Firebird Usefull Class, Exceptions, and Methods. Using directly  }
{ Interbase conversion API is very hard so this unit is designed to interface  }
{ common tasks.                                                                }
{                                                                              }
{ The Initial Developer of TMemoryPool is TurboPower FlashFiler.               }
{                                                                              }
{ Unit owner:    Henri Gourvest                                                }
{ Last modified: September 21, 2003                                            }
{                                                                              }
{******************************************************************************}

unit JvUIBLib;

{$I JCL.INC}
{$I JvUIB.inc}

{$ALIGN ON}
{$MINENUMSIZE 4}

interface
uses
{$IFDEF MSWINDOWS}Windows, {$ENDIF}
{$IFDEF COMPILER6_UP} Variants, {$ENDIF}
{$IFDEF FPC} Variants, {$ENDIF}
  JvUIBase, JvUIBError, Classes, SysUtils;

type

  TUIBFieldType = (uftUnKnown, uftNumeric, uftChar, uftVarchar, uftCstring, uftSmallint,
    uftInteger, uftQuad, uftFloat, uftDoublePrecision, uftTimestamp, uftBlob, uftBlobId,
    uftDate, uftTime, uftInt64 {$IFDEF IB7_UP}, uftBoolean{$ENDIF});

  TScale = 1..15;

//******************************************************************************
// Errors handling
//******************************************************************************

  EUIBConvertError = class(Exception);

  EUIBError = class(Exception)
  private
    FErrorCode: Integer;
    FSQLCode  : Integer;
  public
    property ErrorCode: Integer read FErrorCode;
    property SQLCode: Integer read FSQLCode;
  end;

  EUIBGFixError    = class(EUIBError);
  EUIBDSQLError    = class(EUIBError);
  EUIBDynError     = class(EUIBError);
  EUIBGBakError    = class(EUIBError);
  EUIBGSecError    = class(EUIBError);
  EUIBLicenseError = class(EUIBError);
  EUIBGStatError   = class(EUIBError);

  EUIBParser = class(Exception)
  private
    FLine: Integer;
    FCharacter: Integer;
  public
    constructor Create(Line, Character: Integer);
    property Line: Integer read FLine;
    property Character: Integer read FCharacter;
  end;

const
  QuadNull: TISCQuad = (gds_quad_high: 0; gds_quad_low: 0);

//******************************************************************************
// Database
//******************************************************************************

type
  TCharacterSet = (csNONE, csASCII, csBIG_5, csCYRL, csDOS437, csDOS850,
  csDOS852, csDOS857, csDOS860, csDOS861, csDOS863, csDOS865, csEUCJ_0208,
  csGB_2312, csISO8859_1, csISO8859_2, csKSC_5601, csNEXT, csOCTETS, csSJIS_0208,
  csUNICODE_FSS, csWIN1250, csWIN1251, csWIN1252, csWIN1253, csWIN1254
{$IFDEF FB15_UP}
  ,csDOS737, csDOS775, csDOS858, csDOS862, csDOS864, csDOS866, csDOS869, csWIN1255,
  csWIN1256, csWIN1257, csISO8859_3, csISO8859_4, csISO8859_5, csISO8859_6, csISO8859_7,
  csISO8859_8, csISO8859_9, csISO8859_13
{$ENDIF}
{$IFDEF IB71_UP}
  ,csISO8859_15 ,csKOI8R
{$ENDIF}
  );

  function CreateDBParams(Params: String; Delimiter: Char = ';'): string;

//******************************************************************************
// Transaction
//******************************************************************************

const
  // Default Transaction Parameter
  TPBDefault = isc_tpb_version3 + isc_tpb_write + isc_tpb_concurrency + isc_tpb_wait;

//******************************************************************************
//  DSQL
//******************************************************************************

  //****************************************
  // TSQLDA
  //****************************************

const
{$IFDEF IB7_UP}
  MaxParamLength = 274;
{$ELSE}
  MaxParamLength = 125;
{$ENDIF}

type
  PUIBSQLVar = ^TUIBSQLVar;
  TUIBSQLVar = record
    SqlType      : Smallint;
    SqlScale     : Smallint;
{$IFDEF IB7_UP}
    SqlPrecision : Smallint;
{$ENDIF}
    SqlSubType   : Smallint;
    SqlLen       : Smallint;
    SqlData      : Pchar;
    SqlInd       : PSmallint;
    case byte of
    0 : ( SqlNameLength   : Smallint;
          SqlName         : array[0..METADATALENGTH-1] of char;
          RelNameLength   : Smallint;
          RelName         : array[0..METADATALENGTH-1] of char;
          OwnNameLength   : Smallint;
          OwnName         : array[0..METADATALENGTH-1] of char;
          AliasNameLength : Smallint;
          AliasName       : array[0..METADATALENGTH-1] of char;
          );
    1 : ( Init            : boolean;
          ID              : Word;
          ParamNameLength : Smallint;
          ParamName       : array[0..MaxParamLength-1] of char;
          );
  end;

  PUIBSQLDa = ^TUIBSQLDa;
  TUIBSQLDa = record
    version : Smallint;                // version of this XSQLDA
    sqldaid : array[0..7] of char;     // XSQLDA name field          ->  RESERVED
    sqldabc : ISCLong;                 // length in bytes of SQLDA   ->  RESERVED
    sqln    : Smallint;                // number of fields allocated
    sqld    : Smallint;                // actual number of fields
    sqlvar: array[Word] of TUIBSQLVar; // first field address
  end;

  TUIBStatementType = (
    stSelect,             //  select                 SELECT
    stInsert,             //  insert                 INSERT INTO
    stUpdate,             //  update                 UPDATE
    stDelete,             //  delete                 DELETE FROM
    stDDL,                //
    stGetSegment,         //  blob                   READ BLOB
    stPutSegment,         //  blob                   INSERT BLOB
    stExecProcedure,      //  invoke_procedure       EXECUTE PROCEDURE
    stStartTrans,         //  declare                DECLARE
    stCommit,             //  commit                 COMMIT
    stRollback,           //  rollback               ROLLBACK [WORK]
    stSelectForUpdate,    //                         SELECT ... FOR UPDATE
    stSetGenerator
  {$IFDEF FB15_UP}
    ,stSavePoint          //  user_savepoint | undo_savepoint       SAVEPOINT | ROLLBACK [WORK] TO
  {$ENDIF}
  );

// TODO
//  alter                  ALTER              -> DDL
//  create                 CREATE
//  drop                   DROP
//  grant                  GRANT
//  recreate               RECREATE
//  replace                CREATE OR ALTER
//  revoke                 REVOKE
//  set                    SET

//******************************************************************************
//  Abstract Class
//******************************************************************************

const
  ScaleDivisor: array[-15..-1] of Int64 = (1000000000000000,100000000000000,
    10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,
    10000000,1000000,100000,10000,1000,100,10);
type
  TSQLDA = class
  private
    FXSQLDA: PUIBSQLDa;
    function GetPointer: PUIBSQLDa;
    function GetAllocatedFields: Word;
    procedure SetAllocatedFields(Fields: Word);
    function GetActualFields: Word;
    function GetFieldCount: Integer;
    function GetSQLType(const Index: Word): Smallint;
    function GetSQLLen(const Index: Word): Smallint;
    function DecodeString(const Code: Smallint; Index: Word): String; overload;
    procedure DecodeString(const Code: Smallint; Index: Word; out Str: String); overload;
    procedure DecodeWideString(const Code: Smallint; Index: Word; out Str: WideString);
  protected
    procedure CheckRange(const Index: Word);
    function GetSqlName(const Index: Word): string;
    function GetRelName(const Index: Word): string;
    function GetOwnName(const Index: Word): string;
    function GetAliasName(const Index: Word): string;

    function GetIsNumeric(const Index: Word): boolean;
    function GetIsBlob(const Index: Word): boolean;
    function GetIsNull(const Index: Word): boolean;
    function GetIsNullable(const Index: Word): boolean;
    function GetAsDouble(const Index: Word): Double;
    function GetAsCurrency(const Index: Word): Currency;
    function GetAsInt64(const Index: Word): Int64;
    function GetAsInteger(const Index: Word): Integer;
    function GetAsSingle(const Index: Word): Single;
    function GetAsSmallint(const Index: Word): Smallint;
    function GetAsString(const Index: Word): String; virtual;
    function GetAsWideString(const Index: Word): WideString; virtual;
    function GetAsQuad(const Index: Word): TISCQuad;
    function GetAsVariant(const Index: Word): Variant; virtual;
    function GetAsDateTime(const Index: Word): TDateTime;
    function GetAsBoolean(const Index: Word): boolean;

    function GetByNameIsNumeric(const Name: String): boolean;
    function GetByNameIsBlob(const Name: String): boolean;
    function GetByNameIsNull(const Name: String): boolean;
    function GetByNameIsNullable(const Name: String): boolean;
    function GetByNameAsDouble(const Name: String): Double;
    function GetByNameAsCurrency(const Name: String): Currency;
    function GetByNameAsInt64(const Name: String): Int64;
    function GetByNameAsInteger(const Name: String): Integer;
    function GetByNameAsSingle(const Name: String): Single;
    function GetByNameAsSmallint(const Name: String): Smallint;
    function GetByNameAsString(const Name: String): String;
    function GetByNameAsWideString(const Name: String): WideString;
    function GetByNameAsQuad(const Name: String): TISCQuad;
    function GetByNameAsVariant(const Name: String): Variant;
    function GetByNameAsDateTime(const Name: String): TDateTime;
    function GetByNameAsBoolean(const Name: String): boolean;

    function GetFieldType(const Index: Word): TUIBFieldType; virtual;
  public
    function GetFieldIndex(const name: String): Word; virtual;
    property Data: PUIBSQLDa read FXSQLDA;
    property IsBlob[const Index: Word]: boolean read GetIsBlob;
    property IsNull[const Index: Word]: boolean read GetIsNull;
    property IsNullable[const Index: Word]: boolean read GetIsNullable;
    property IsNumeric[const Index: Word]: boolean read GetIsNumeric;
    property AsQuad     [const Index: Word]: TISCQuad  read GetAsQuad;
    property XSQLDA: PUIBSQLDa read GetPointer;
    property FieldCount: Integer read GetFieldCount;
    property SQLType[const Index: Word]: Smallint read GetSQLType;
    property SQLLen[const Index: Word]: Smallint read GetSQLLen;
    property FieldType[const Index: Word]: TUIBFieldType read GetFieldType;
  end;

  PPageInfo = ^TPageInfo;
  TPageInfo = packed record
    NextPage    : Pointer;
    UsageCounter: Integer;
  end;

  TMemoryPool = class
  private
    function GetCount: Integer;
    function GetItems(const Index: Integer): Pointer;
  protected
    FItemSize    : Integer;
    FItemsInPage : Integer;
    FPageSize    : Integer;
    FFirstPage   : PPageInfo;
    FFreeList    : Pointer;
    FList        : TList;
  protected
    procedure AddPage;
    procedure CleanFreeList(const PageStart : Pointer);
  public
    constructor Create(ItemSize, ItemsInPage : Integer);
    destructor Destroy; override;
    function New : Pointer;
    function PageCount : Integer;
    function PageUsageCount(const PageIndex : Integer) : Integer;
    procedure Dispose(var P);
    function RemoveUnusedPages : Integer;

    property PageSize : Integer read FPageSize;
    property ItemsInPage : Integer read FItemsInPage;
    property ItemSize : Integer read FItemSize;
    property Items[const Index: Integer]: Pointer read GetItems;
    property Count: Integer read GetCount;
  end;

  TBlobData = packed record
    Size: Integer;
    Buffer: Pointer;
  end;
  TBlobDataArray = array[Word] of TBlobData;
  PBlobDataArray = ^TBlobDataArray;

  TSQLResult = class(TSQLDA)
  private
    FRecords: TMemoryPool;
    FCachedFetch: boolean;
    FFetchBlobs: boolean;
    FDataBuffer: Pointer;
    FBlobArray: PBlobDataArray;
    FDataBufferLength: Word;
    FBlobsIndex: array of Word;
    FCurrentRecord: Integer;
    FBufferChunks: Cardinal;
    FScrollEOF: boolean;
    procedure AddCurrentRecord;
    procedure FreeBlobs(Buffer: Pointer);
    function GetRecordCount: Integer;
    function GetCurrentRecord: Integer;
    procedure AllocateDataBuffer;
    function GetBlobIndex(const Index: Word): Word;
    function GetEof: boolean;
  protected
    function GetAsString(const Index: Word): String; override;
    function GetAsWideString(const Index: Word): WideString; override;
    function GetAsVariant(const Index: Word): Variant; override;
  public
    constructor Create(Fields: SmallInt = 0;
      CachedFetch: Boolean = False;
      FetchBlobs: boolean = false;
      BufferChunks: Cardinal = 1000);
    destructor Destroy; override;
    procedure ClearRecords;
    procedure GetRecord(const Index: Integer);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);

    procedure ReadBlob(const Index: Word; Stream: TStream); overload;
    procedure ReadBlob(const Index: Word; var str: string); overload;
    procedure ReadBlob(const Index: Word; var str: WideString); overload;
    procedure ReadBlob(const Index: Word; var Value: Variant); overload;
    procedure ReadBlob(const name: string; Stream: TStream); overload;
    procedure ReadBlob(const name: string; var str: string); overload;
    procedure ReadBlob(const name: string; var str: WideString); overload;
    procedure ReadBlob(const name: string; var Value: Variant); overload;

    property Eof: boolean read GetEof;

    property CachedFetch: boolean read FCachedFetch;
    property FetchBlobs: boolean read FFetchBlobs;
    property RecordCount: Integer read GetRecordCount;
    property CurrentRecord: Integer read GetCurrentRecord write GetRecord;
    property BufferChunks: Cardinal read FBufferChunks;

    property SqlName[const Index: Word]: string read GetSqlName;
    property RelName[const Index: Word]: string read GetRelName;
    property OwnName[const Index: Word]: string read GetOwnName;
    property AliasName[const Index: Word]: string read GetAliasName;

    property AsSmallint   [const Index: Word]: Smallint   read GetAsSmallint;
    property AsInteger    [const Index: Word]: Integer    read GetAsInteger;
    property AsSingle     [const Index: Word]: Single     read GetAsSingle;
    property AsDouble     [const Index: Word]: Double     read GetAsDouble;
    property AsCurrency   [const Index: Word]: Currency   read GetAsCurrency;
    property AsInt64      [const Index: Word]: Int64      read GetAsInt64;
    property AsString     [const Index: Word]: String     read GetAsString;
    property AsWideString [const Index: Word]: WideString read GetAsWideString;
    property AsVariant    [const Index: Word]: Variant    read GetAsVariant;
    property AsDateTime   [const Index: Word]: TDateTime  read GetAsDateTime;
    property AsDate       [const Index: Word]: Integer    read GetAsInteger;
    property AsBoolean    [const Index: Word]: Boolean    read GetAsBoolean;

    property ByNameIsNull[const name: String]: boolean read GetByNameIsNull;
    property ByNameIsNullable[const name: String]: boolean read GetByNameIsNullable;

    property ByNameAsSmallint   [const name: String]: Smallint   read GetByNameAsSmallint;
    property ByNameAsInteger    [const name: String]: Integer    read GetByNameAsInteger;
    property ByNameAsSingle     [const name: String]: Single     read GetByNameAsSingle;
    property ByNameAsDouble     [const name: String]: Double     read GetByNameAsDouble;
    property ByNameAsCurrency   [const name: String]: Currency   read GetByNameAsCurrency;
    property ByNameAsInt64      [const name: String]: Int64      read GetByNameAsInt64;
    property ByNameAsString     [const name: String]: String     read GetByNameAsString;
    property ByNameAsWideString [const name: String]: WideString read GetByNameAsWideString;
    property ByNameAsQuad       [const name: String]: TISCQuad   read GetByNameAsQuad;
    property ByNameAsVariant    [const name: String]: Variant    read GetByNameAsVariant;
    property ByNameAsDateTime   [const name: String]: TDateTime  read GetByNameAsDateTime;
    property ByNameAsBoolean    [const name: String]: Boolean    read GetByNameAsBoolean;

    property Values[const name: String]: Variant read GetByNameAsVariant; default;
  end;

  TSQLResultClass = class of TSQLResult;

  TSQLParams = class(TSQLDA)
  private
    FParamCount: Word;
    procedure EncodeString(Code: Smallint; Index: Word; const str: String);
    procedure EncodeWideString(Code: Smallint; Index: Word; const str: WideString);
    function FindParam(const name: string; out Index: Word): boolean;
    function GetFieldName(const Index: Word): string;
  protected
    function AddField(const name: string): Word;
    procedure SetFieldType(const Index: Word; Size: Integer; Code: SmallInt;
      Scale: Smallint = 0);
    procedure SetIsNull(const Index: Word; const Value: boolean);

    procedure SetAsDouble(const Index: Word; const Value: Double);
    procedure SetAsCurrency(const Index: Word; const Value: Currency);
    procedure SetAsInt64(const Index: Word; const Value: Int64);
    procedure SetAsInteger(const Index: Word; const Value: Integer);
    procedure SetAsSingle(const Index: Word; const Value: Single);
    procedure SetAsSmallint(const Index: Word; const Value: Smallint);
    procedure SetAsString(const Index: Word; const Value: String);
    procedure SetAsWideString(const Index: Word; const Value: WideString);
    procedure SetAsQuad(const Index: Word; const Value: TISCQuad);
    procedure SetAsDateTime(const Index: Word; const Value: TDateTime);
    procedure SetAsBoolean(const Index: Word; const Value: Boolean);

    procedure SetByNameIsNull(const Name: String; const Value: boolean);
    procedure SetByNameAsDouble(const Name: String; const Value: Double);
    procedure SetByNameAsCurrency(const Name: String; const Value: Currency);
    procedure SetByNameAsInt64(const Name: String; const Value: Int64);
    procedure SetByNameAsInteger(const Name: String; const Value: Integer);
    procedure SetByNameAsSingle(const Name: String; const Value: Single);
    procedure SetByNameAsSmallint(const Name: String; const Value: Smallint);
    procedure SetByNameAsString(const Name: String; const Value: String);
    procedure SetByNameAsWideString(const Name: String; const Value: WideString);
    procedure SetByNameAsQuad(const Name: String; const Value: TISCQuad);
    procedure SetByNameAsDateTime(const Name: String; const Value: TDateTime);
    procedure SetByNameAsBoolean(const Name: String; const Value: boolean);

    function GetFieldType(const Index: Word): TUIBFieldType; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Parse(const SQL: string): string;
    function GetFieldIndex(const name: String): Word; override;

    procedure AddFieldType(const Name: string; FieldType: TUIBFieldType;
      Scale: TScale = 1; Precision: byte = 0);

    property IsNull[const Index: Word]: boolean read GetIsNull write SetIsNull;

    property AsSmallint   [const Index: Word]: Smallint   read GetAsSmallint   write SetAsSmallint;
    property AsInteger    [const Index: Word]: Integer    read GetAsInteger    write SetAsInteger;
    property AsSingle     [const Index: Word]: Single     read GetAsSingle     write SetAsSingle;
    property AsDouble     [const Index: Word]: Double     read GetAsDouble     write SetAsDouble;
    property AsCurrency   [const Index: Word]: Currency   read GetAsCurrency   write SetAsCurrency;
    property AsInt64      [const Index: Word]: Int64      read GetAsInt64      write SetAsInt64;
    property AsString     [const Index: Word]: String     read GetAsString     write SetAsString;
    property AsWideString [const Index: Word]: WideString read GetAsWideString write SetAsWideString;
    property AsQuad       [const Index: Word]: TISCQuad   read GetAsQuad       write SetAsQuad;
    property AsDateTime   [const Index: Word]: TDateTime  read GetAsDateTime   write SetAsDateTime;
    property AsBoolean    [const Index: Word]: Boolean    read GetAsBoolean    write SetAsBoolean;

    property ByNameIsNull[const name: String]: boolean read GetByNameIsNull write SetByNameIsNull;

    property ByNameAsSmallint   [const name: String]: Smallint   read GetByNameAsSmallint   write SetByNameAsSmallint;
    property ByNameAsInteger    [const name: String]: Integer    read GetByNameAsInteger    write SetByNameAsInteger;
    property ByNameAsSingle     [const name: String]: Single     read GetByNameAsSingle     write SetByNameAsSingle;
    property ByNameAsDouble     [const name: String]: Double     read GetByNameAsDouble     write SetByNameAsDouble;
    property ByNameAsCurrency   [const name: String]: Currency   read GetByNameAsCurrency   write SetByNameAsCurrency;
    property ByNameAsInt64      [const name: String]: Int64      read GetByNameAsInt64      write SetByNameAsInt64;
    property ByNameAsString     [const name: String]: String     read GetByNameAsString     write SetByNameAsString;
    property ByNameAsWideString [const name: String]: WideString read GetByNameAsWideString write SetByNameAsWideString;
    property ByNameAsQuad       [const name: String]: TISCQuad   read GetByNameAsQuad       write SetByNameAsQuad;
    property ByNameAsVariant    [const name: String]: Variant    read GetByNameAsVariant;
    property ByNameAsDateTime   [const name: String]: TDateTime  read GetByNameAsDateTime   write SetByNameAsDateTime;
    property ByNameAsBoolean    [const name: String]: Boolean    read GetByNameAsBoolean    write SetByNameAsBoolean;

    property Values[const name: String]: Variant read GetByNameAsVariant; default;
    property FieldName[const Index: Word]: string read GetFieldName;

  end;

  TSQLParamsClass = class of TSQLParams;

type
  TDSQLInfoData = packed record
    InfoCode: byte;
    InfoLen : Word; // isc_portable_integer convert a SmallInt to Word ??? so just say it is a word
    case byte of
      isc_info_sql_stmt_type: (StatementType: TUIBStatementType);
      isc_info_sql_get_plan : (PlanDesc     : array[0..255] of Char);
  end;

{$IFDEF IB7_UP}
  TArrayDesc = TISCArrayDescV2;
  TBlobDesc = TISCBlobDescV2;
{$ELSE}
  TArrayDesc = TISCArrayDesc;
  TBlobDesc = TISCBlobDesc;
{$ENDIF}

  TStatusVector = array[0..19] of ISCStatus;
  PStatusVector = ^TStatusVector;

  TUIBLibrary = class(TUIBaseLibrary)
  private
    FStatusVector: TStatusVector;
    procedure GetDSQLInfoData(var StmtHandle: IscStmtHandle;
      var DSQLInfoData: TDSQLInfoData; InfoCode: Byte);
    procedure CheckUIBApiCall(Status: ISCStatus);
  public
    {Attaches to an existing database.
     Ex: AttachDatabase('c:\DataBase.gdb', DBHandle, 'user_name=SYSDBA; password=masterkey'); }
    procedure AttachDatabase(FileName: String; var DbHandle: IscDbHandle; Params: String; Sep: Char = ';');
    {Detaches from a database previously connected with AttachDatabase.}
    procedure DetachDatabase(var DBHandle: IscDbHandle);

    procedure TransactionStart(var TraHandle: IscTrHandle; var DbHandle: IscDbHandle; const TPB: string = '');
    procedure TransactionStartMultiple(var TraHandle: IscTrHandle; DBCount: Smallint; Vector: PISCTEB);
    procedure TransactionCommit(var TraHandle: IscTrHandle);
    procedure TransactionRollback(var TraHandle: IscTrHandle);
    procedure TransactionCommitRetaining(var TraHandle: IscTrHandle);
    procedure TransactionPrepare(var TraHandle: IscTrHandle);
    procedure TransactionRollbackRetaining(var TraHandle: IscTrHandle);
    procedure DSQLExecuteImmediate(var DBHandle: IscDbHandle; var TraHandle: IscTrHandle;
      const Statement: string; Dialect: Word; Sqlda: TSQLDA = nil); overload;
    procedure DSQLExecuteImmediate(const Statement: string; Dialect: Word; Sqlda: TSQLDA = nil); overload;
    procedure DSQLAllocateStatement(var DBHandle: IscDbHandle; var StmtHandle: IscStmtHandle);
    procedure DSQLPrepare(var TraHandle: IscTrHandle; var StmtHandle: IscStmtHandle;
      Statement: string; Dialect: Word; Sqlda: TSQLResult = nil);
    procedure DSQLExecute(var TraHandle: IscTrHandle; var StmtHandle: IscStmtHandle;
      Dialect: Word; Sqlda: TSQLParams = nil);
    procedure DSQLExecute2(var TraHandle: IscTrHandle; var StmtHandle: IscStmtHandle;
      Dialect: Word; InSqlda: TSQLParams; OutSqlda: TSQLResult);
    procedure DSQLFreeStatement(var StmtHandle: IscStmtHandle; Option: Word);
    function  DSQLFetch(var StmtHandle: IscStmtHandle; Dialect: Word; Sqlda: TSQLResult): boolean;
    function  DSQLFetchWithBlobs(var DBHhandle: IscDbHandle; var TraHandle: IscTrHandle;
      var StmtHandle: IscStmtHandle; Dialect: Word; Sqlda: TSQLResult): boolean;
    procedure DSQLDescribe(var StmtHandle: IscStmtHandle; Dialect: Word; Sqlda: TSQLResult);
    procedure DSQLDescribeBind(var StmtHandle: IscStmtHandle; Dialect: Word; Sqlda: TSQLDA);
    procedure DSQLSetCursorName(var StmtHandle: IscStmtHandle; const cursor: string);
    procedure DSQLExecImmed2(var DBHhandle: IscDbHandle; var TraHandle: IscTrHandle;
      const Statement: string; dialect: Word; InSqlda, OutSqlda: TSQLDA);

    procedure DSQLInfo(var StmtHandle: IscStmtHandle; const Items: array of byte; var buffer: String);
    function  DSQLInfoPlan(var StmtHandle: IscStmtHandle): string;
    function  DSQLInfoStatementType(var StmtHandle: IscStmtHandle): TUIBStatementType;

    procedure DDLExecute(var DBHandle: IscDbHandle; var TraHandle: IscTrHandle; const ddl: string);

    function ArrayLookupBounds(var DBHandle: IscDbHandle; var TransHandle: IscTrHandle;
      const RelationName, FieldName: String): TArrayDesc;
    procedure ArrayGetSlice(var DBHandle: IscDbHandle; var TransHandle: IscTrHandle; ArrayId: TISCQuad;
      var desc: TArrayDesc; DestArray: PPointer; var SliceLength: Integer);
    procedure ArrayPutSlice(var DBHandle: IscDbHandle; var TransHandle: IscTrHandle; ArrayId: TISCQuad;
      var desc: TArrayDesc; DestArray: PPointer; var SliceLength: Integer);

    procedure ServiceAttach(const ServiceName: string; var SvcHandle: IscSvcHandle; const Spb: string);
    procedure ServiceDetach(var SvcHandle: IscSvcHandle);
    procedure ServiceQuery(var SvcHandle: IscSvcHandle; const SendSpb, RequestSpb: string; var Buffer: string);
    procedure ServiceStart(var SvcHandle: IscSvcHandle; const Spb: string);

    function ErrSqlcode: ISCLong;
    function ErrInterprete: String;
    function ErrSQLInterprete(SQLCODE: Smallint): String;

    procedure BlobOpen(var DBHandle: IscDbHandle; var TraHandle: IscTrHandle; var BlobHandle: IscBlobHandle; BlobId: TISCQuad; BPB: string = '');
    function  BlobGetSegment(var BlobHandle: IscBlobHandle; out length: Word; BufferLength: Word; Buffer: PChar): boolean;
    procedure BlobClose(var BlobHandle: IscBlobHandle);
    procedure BlobInfo(var BlobHandle: IscBlobHandle; out NumSegments, MaxSegment, TotalLength: Cardinal; out btype : byte);
    procedure BlobSize(var BlobHandle: IscBlobHandle; out Size: Cardinal);
    procedure BlobMaxSegment(var BlobHandle: IscBlobHandle; out Size: Cardinal);
    procedure BlobDefaultDesc(var Desc: TBlobDesc; const RelationName, FieldName: string);
    procedure BlobSaveToStream(var BlobHandle: IscBlobHandle; Stream: TStream);
    function  BlobReadString(var BlobHandle: IscBlobHandle): string; overload;
    procedure BlobReadString(var BlobHandle: IscBlobHandle; var Str: String); overload;
    procedure BlobReadVariant(var BlobHandle: IscBlobHandle; var Value: Variant);
    // you must free memory allocated by this method !!
    procedure BlobReadBuffer(var BlobHandle: IscBlobHandle; var Size: Integer; var Buffer: Pointer);
    function  BlobCreate(var DBHandle: IscDbHandle; var TraHandle: IscTrHandle; var BlobHandle: IscBlobHandle): TISCQuad;
    procedure BlobWriteSegment(var BlobHandle: IscBlobHandle; BufferLength: Word; Buffer: PChar);
    procedure BlobWriteString(var BlobHandle: IscBlobHandle; var Str: String);
    procedure BlobWriteStream(var BlobHandle: IscBlobHandle; Stream: TStream);

{$IFDEF IB71_UP}
    procedure SavepointRelease(var TrHandle: IscTrHandle; const Name: string);
    procedure SavepointRollback(var TrHandle: IscTrHandle; const Name: string; Option: Word);
    procedure SavepointStart(var TrHandle: IscTrHandle; const Name: string);
{$ENDIF}

  end;

//******************************************************************************
// Conversion
//******************************************************************************

   procedure DecodeTimeStamp(v: PISCTimeStamp; out DateTime: Double); overload;
   procedure DecodeTimeStamp(v: PISCTimeStamp; out TimeStamp: TTimeStamp); overload;

   function  DecodeTimeStamp(v: PISCTimeStamp): Double; overload;
   procedure EncodeTimeStamp(const DateTime: TDateTime; v: PISCTimeStamp);
   procedure DecodeSQLDate(v: Integer; out Year: SmallInt; out Month, Day: Word); overload;
   procedure DecodeSQLDate(const v: Integer; out Date: Double); overload;
   function  DecodeSQLDate(const v: Integer): Integer; overload;
   procedure EncodeSQLDate(date: TDateTime; out v: Integer); overload;
   procedure EncodeSQLDate(Year: SmallInt; Month, Day: Word; out v: Integer); overload;

   procedure DecodeSQLTime(v: Cardinal; out Hour, Minute, Second: Word; out Fractions: LongWord);
   procedure EncodeSQLTime(const Hour, Minute, Second: Word; const Fractions: LongWord; out v: Cardinal);


//******************************************************************************
// Event functions
//******************************************************************************
//    function  isc_cancel_events
//    function  isc_que_events
//    function  isc_wait_for_event
//    procedure isc_event_counts
//    function  isc_event_block

//******************************************************************************
// Security
//******************************************************************************
//    function isc_add_user
//    function isc_delete_user
//    function isc_modify_user


//******************************************************************************
// Other
//******************************************************************************
//    function isc_compile_request
//    function isc_compile_request2
//    function isc_ddl
//    function isc_prepare
//    function isc_receive
//    function isc_reconnect_transaction
//    function isc_release_request
//    function isc_request_info
//    function isc_seek_blob
//    function isc_send
//    function isc_start_and_send
//    function isc_start_request
//    function isc_transact_request
//    function isc_unwind_request

//******************************************************************************
//
//******************************************************************************
//    function isc_ftof
//    function isc_free
//    function isc_print_blr
//    procedure isc_qtoq
//    procedure isc_set_debug
//    procedure isc_vtof
//    procedure isc_vtov
//  {$IFDEF FB15}
//    function isc_reset_fpe
//  {$ENDIF}
//  {$IFDEF IB7_UP}
//    procedure isc_get_client_version
//    function  isc_get_client_major_version
//    function isc_get_client_minor_version
//  {$ENDIF}


{$IFNDEF DELPHI6_UP}
function TryStrToInt(const S: string; out Value: Integer): Boolean;
{$ENDIF}

implementation
uses JvUIBConst;
{ EUIBParser }

constructor EUIBParser.Create(Line, Character: Integer);
begin
  FLine := Line;
  FCharacter := Character;
  Message := format('Parse error Line %d, Char %d', [FLine, FCharacter]);
end;

//******************************************************************************
// Errors handling
//******************************************************************************

{$IFNDEF DELPHI6_UP}
{$IFNDEF FPC}
type
  PWord = ^Word;
  PCardinal = ^Cardinal;
  PSmallInt = ^SmallInt;
  PInteger = ^Integer;
  PDouble = ^Double;
  PSingle = ^Single;
  PInt64 = ^Int64;
{$ENDIF}
function TryStrToInt(const S: string; out Value: Integer): Boolean;
var
  E: Integer;
begin
  Val(S, Value, E);
  Result := E = 0;
end;

{$ENDIF}

const
  ISC_MASK   = $14000000; // Defines the code as a valid ISC code
  FAC_MASK   = $00FF0000; // Specifies the facility where the code is located
  CODE_MASK  = $0000FFFF; // Specifies the code in the message file
  CLASS_MASK = $F0000000; // Defines the code as warning, error, info, or other

  // Note: Perhaps a debug level could be interesting !!!
  CLASS_ERROR   = 0; // Code represents an error
  CLASS_WARNING = 1; // Code represents a warning
  CLASS_INFO    = 2; // Code represents an information msg

//FACILITY   FAC_CODE    MAX_NUMBER    LAST_CHANGE
  FAC_JRD        =  0;  //         501   26/10/2002 17:02:13   <- In Use
  FAC_QLI        =  1;  //         509   07/11/1996 13:38:37
  FAC_GDEF       =  2;  //         345   07/11/1996 13:38:37
  FAC_GFIX       =  3;  //         114   25/12/2001 02:59:17   <- In Use
  FAC_GPRE       =  4;  //           1   07/11/1996 13:39:40
  FAC_GLTJ       =  5;  //           1   07/11/1996 13:39:40
  FAC_GRST       =  6;  //           1   07/11/1996 13:39:40
  FAC_DSQL       =  7;  //          15   22/07/2001 23:26:58   <- In Use
  FAC_DYN        =  8;  //         215   01/07/2001 17:43:07   <- In Use
  FAC_FRED       =  9;  //           1   07/11/1996 13:39:40
  FAC_INSTALL    = 10;  //           1   07/11/1996 13:39:40
  FAC_TEST       = 11;  //           4   07/11/1996 13:38:41
  FAC_GBAK       = 12;  //         283   05/03/2002 02:38:49   <- In Use
  FAC_SQLERR     = 13;  //         917   05/03/2002 02:55:22
  FAC_SQLWARN    = 14;  //         102   07/11/1996 13:38:42
  FAC_JRD_BUGCHK = 15;  //         305   05/03/2002 02:29:03
  FAC_GJRN       = 16;  //         241   07/11/1996 13:38:43
  FAC_ISQL       = 17;  //         109   10/10/2001 03:27:43
  FAC_GSEC       = 18;  //          91   04/11/1998 11:06:15   <- In Use
  FAC_LICENSE    = 19;  //          60   05/03/2002 02:30:12   <- In Use
  FAC_DOS        = 20;  //          74   05/03/2002 02:31:54
  FAC_GSTAT      = 21;  //          36   10/10/2001 18:05:16   <- In Use


  function GetFacility(code: ISCStatus): Word;
  begin
    Result := (code and FAC_MASK) shr 16;
  end;

  function GetClass(code: ISCStatus): Word;
  begin
    Result := (code and CLASS_MASK) shr 30;
  end;

  function GETCode(code: ISCStatus): Word;
  begin
    Result := (code and CODE_MASK) shr 0;
  end;

  procedure TUIBLibrary.CheckUIBApiCall(Status: ISCStatus);
  var
    Exception: EUIBError;
  begin
    if (Status <> 0) then
    if (GetClass(Status) = CLASS_ERROR) then // only raise CLASS_ERROR
    begin
      case GetFacility(Status) of
        FAC_JRD     : Exception := EUIBError.Create(ErrInterprete);
        FAC_GFIX    : Exception := EUIBGFIXError.Create(ErrInterprete);
        FAC_DSQL    : Exception := EUIBDSQLError.Create(ErrInterprete);
        FAC_DYN     : Exception := EUIBDYNError.Create(ErrInterprete);
        FAC_GBAK    : Exception := EUIBGBAKError.Create(ErrInterprete);
        FAC_GSEC    : Exception := EUIBGSECError.Create(ErrInterprete);
        FAC_LICENSE : Exception := EUIBLICENSEError.Create(ErrInterprete);
        FAC_GSTAT   : Exception := EUIBGSTATError.Create(ErrInterprete);
      else
        Exception := EUIBError.Create(ErrInterprete);
      end;
      Exception.FErrorCode := GETCode(Status);
      Exception.Message := Exception.Message + #13'Error Code: ' + IntToStr(Exception.FErrorCode);
      Exception.FSQLCode   := ErrSqlcode;
      if Exception.FSQLCode <> 0 then
        Exception.Message := Exception.Message + #13 + ErrSQLInterprete(Exception.FSQLCode) +
          #13'SQL Code: ' + IntToStr(Exception.FSQLCode);
      raise Exception;
    end;
  end;

//******************************************************************************
// Database
//******************************************************************************


type
  TParamType = (
    prNone, // no param
    prByte, // Byte Param
    prCard, // Cardinal Param
    prStrg, // String Param
    prIgno  // Ignore Command
  );

  TDPBInfo = record
    Name      : String;
    ParamType : TParamType;
  end;

var
  
  DPBInfos : array[1..isc_dpb_Max_Value] of TDPBInfo =
   ((Name: 'cdd_pathname';           ParamType: prIgno), // not implemented
    (Name: 'allocation';             ParamType: prIgno), // not implemented
    (Name: 'journal';                ParamType: prIgno), // not implemented
    (Name: 'page_size';              ParamType: prCard), // ok
    (Name: 'num_buffers';            ParamType: prCard), // ok
    (Name: 'buffer_length';          ParamType: prIgno), // not implemented
    (Name: 'debug';                  ParamType: prCard), // ok
    (Name: 'garbage_collect';        ParamType: prIgno), // not implemented
    (Name: 'verify';                 ParamType: prCard), // ok
    (Name: 'sweep';                  ParamType: prCard), // ok

    (Name: 'enable_journal';         ParamType: prStrg), // ok
    (Name: 'disable_journal';        ParamType: prNone), // ok
    (Name: 'dbkey_scope';            ParamType: prCard), // ok
    (Name: 'number_of_users';        ParamType: prIgno), // not implemented
    (Name: 'trace';                  ParamType: prNone), // ok
    (Name: 'no_garbage_collect';     ParamType: prIgno), // not implemented
    (Name: 'damaged';                ParamType: prNone), // ok
    (Name: 'license';                ParamType: prStrg),
    (Name: 'sys_user_name';          ParamType: prStrg), // ok
    (Name: 'encrypt_key';            ParamType: prStrg), // ok

    (Name: 'activate_shadow';        ParamType: prNone), // ok deprecated
    (Name: 'sweep_interval';         ParamType: prCard), // ok
    (Name: 'delete_shadow';          ParamType: prNone), // ok
    (Name: 'force_write';            ParamType: prCard), // ok
    (Name: 'begin_log';              ParamType: prStrg), // ok
    (Name: 'quit_log';               ParamType: prNone), // ok
    (Name: 'no_reserve';             ParamType: prCard), // ok
    (Name: 'user_name';              ParamType: prStrg), // ok
    (Name: 'password';               ParamType: prStrg), // ok
    (Name: 'password_enc';           ParamType: prStrg), // ok

    (Name: 'sys_user_name_enc';      ParamType: prNone),
    (Name: 'interp';                 ParamType: prCard), // ok
    (Name: 'online_dump';            ParamType: prCard), // ok
    (Name: 'old_file_size';          ParamType: prCard), // ok
    (Name: 'old_num_files';          ParamType: prCard), // ok
    (Name: 'old_file';               ParamType: prStrg), // ok
    (Name: 'old_start_page';         ParamType: prCard), // ok
    (Name: 'old_start_seqno';        ParamType: prCard), // ok
    (Name: 'old_start_file';         ParamType: prCard), // ok
    (Name: 'drop_walfile';           ParamType: prCard), // ok

    (Name: 'old_dump_id';            ParamType: prCard), // ok
    (Name: 'wal_backup_dir';         ParamType: prStrg), // ok
    (Name: 'wal_chkptlen';           ParamType: prCard), // ok
    (Name: 'wal_numbufs';            ParamType: prCard), // ok
    (Name: 'wal_bufsize';            ParamType: prCard), // ok
    (Name: 'wal_grp_cmt_wait';       ParamType: prCard), // ok
    (Name: 'lc_messages';            ParamType: prStrg), // ok
    (Name: 'lc_ctype';               ParamType: prStrg), // ok
    (Name: 'cache_manager';          ParamType: prIgno), // not used in fb1.5
    (Name: 'shutdown';               ParamType: prCard), // ok

    (Name: 'online';                 ParamType: prNone), // ok
    (Name: 'shutdown_delay';         ParamType: prCard), // ok
    (Name: 'reserved';               ParamType: prStrg), // ok
    (Name: 'overwrite';              ParamType: prCard), // ok
    (Name: 'sec_attach';             ParamType: prCard), // ok
    (Name: 'disable_wal';            ParamType: prNone), // ok
    (Name: 'connect_timeout';        ParamType: prCard), // ok
    (Name: 'dummy_packet_interval';  ParamType: prCard), // ok
    (Name: 'gbak_attach';            ParamType: prStrg), // ok
    (Name: 'sql_role_name';          ParamType: prStrg), // ok rolename

    (Name: 'set_page_buffers';       ParamType: prCard), // ok Change age buffer 50 >= buf >= 65535 (default 2048)
    (Name: 'working_directory';      ParamType: prStrg), // ok
    (Name: 'sql_dialect';            ParamType: prCard), // ok Set SQL Dialect for this connection (1,2,3)
    (Name: 'set_db_readonly';        ParamType: prCard), // ok
    (Name: 'set_db_sql_dialect';     ParamType: prCard), // ok Change sqldialect (1,2,3))
    (Name: 'gfix_attach';            ParamType: prNone), // ok FB15: don't work
    (Name: 'gstat_attach';           ParamType: prNone)  // ok FB15: don't work
{$IFDEF IB65ORYF867}
   ,(Name: 'gbak_ods_version';       ParamType: prCard) // ??
   ,(Name: 'gbak_ods_minor_version'; ParamType: prCard) // ??
{$ENDIF}

{$IFDEF YF867_UP}
   ,(Name: 'numeric_scale_reduction';ParamType: prNone) 
{$ENDIF}

{$IFDEF IB7_UP}
   ,(Name: 'set_group_commit';       ParamType: prNone) // ??
{$ENDIF}
{$IFDEF IB71_UP}
   ,(Name: 'gbak_validate';          ParamType: prNone) // ??
{$ENDIF}
{$IFDEF FB103_UP}
   ,(Name: 'set_db_charset';         ParamType: prStrg) // ok
{$ENDIF}
   );

  function CreateDBParams(Params: String; Delimiter: Char = ';'): string;
  var
    BufferSize: Integer;
    CurPos, NextPos: PChar;
    CurStr, CurValue: String;
    EqualPos: Integer;
    Code: Byte;
    AValue: Integer;
    FinalSize: Integer;
    function Min(v1, v2: Integer): Integer;
    begin
      if v1 > v2 then Result := v2 else Result := v1;
    end;
    // dont reallocate memory each time, step by step ...
    procedure CheckBufferSize;
    begin
      while (FinalSize > BufferSize) do
        begin
          Inc(BufferSize, 32);
          SetLength(Result, BufferSize);
        end;
    end;
    procedure AddByte(AByte: Byte);
    begin
      inc(FinalSize);
      CheckBufferSize;
      Result[FinalSize] := chr(AByte);
    end;
    procedure AddWord(AWord: Word);
    begin
      inc(FinalSize,2);
      CheckBufferSize;
      PWord(@Result[FinalSize-1])^ := AWord;
    end;
    procedure AddCard(ACard: Cardinal);
    begin
      case ACard of
      0  ..   255 :
        begin
          AddByte(1);
          AddByte(ACard)
        end;
      256.. 65535 :
        begin
          AddByte(2);
          AddWord(ACard)
        end;
      else
        AddByte(4);
        inc(FinalSize,4);
        CheckBufferSize;
        PCardinal(@Result[FinalSize-3])^ := ACard;
      end;
    end;
    procedure AddString(var AString: String);
    var l: Integer;
    begin
      l := Min(Length(AString), 255);
      inc(FinalSize,l+1);
      CheckBufferSize;
      Result[FinalSize-l] := chr(l);
      Move(PChar(AString)^, Result[FinalSize-l+1], l);
    end;

  begin
    FinalSize := 1;
    BufferSize := 32;
    SetLength(Result, BufferSize);
    Result[1] := chr(isc_dpb_version1);
    CurPos  := PChar(Params);
    while (CurPos <> nil) do
    begin
      NextPos := StrScan(CurPos, Delimiter);
      if (NextPos = nil) then
        CurStr := CurPos else
        begin
          CurStr := Copy(CurPos, 0, NextPos-CurPos);
          Inc(NextPos);
        end;
      CurPos := NextPos;
      if (CurStr = '') then Continue;
      begin
        CurValue := '';
        EqualPos := Pos('=', CurStr);
        if EqualPos <> 0 then
        begin
          CurValue := Copy(CurStr, EqualPos+1, Length(CurStr) - EqualPos);
          CurStr   := Copy(CurStr, 0, EqualPos-1);
        end;
        CurStr := Trim(LowerCase(CurStr));
        CurValue := Trim(CurValue);
        for Code := 1 to isc_dpb_Max_Value do
          with DPBInfos[Code] do
            if (Name = CurStr) then
            begin
              case ParamType of
                prNone : AddByte(Code);
                prByte :
                  if TryStrToInt(CurValue, AValue) and (AValue in [0..255]) then
                  begin
                    AddByte(Code);
                    AddByte(AValue);
                  end;
                prCard :
                  if TryStrToInt(CurValue, AValue) and (AValue > 0) then
                  begin
                    AddByte(Code);
                    AddCard(AValue);
                  end;
                prStrg :
                  if (Length(CurValue) > 0) then
                  begin
                    AddByte(Code);
                    AddString(CurValue)
                  end;
              end;
              break;
            end;
      end;
    end;
    SetLength(Result, FinalSize);
  end;

  procedure TUIBLibrary.AttachDatabase(FileName: String; var DbHandle: IscDbHandle;
    Params: String; Sep: Char = ';');
  begin
    Params := CreateDBParams(Params, Sep);
    Lock;
    try
      CheckUIBApiCall(isc_attach_database(@FStatusVector, Length(FileName), Pointer(FileName),
        @DBHandle, Length(Params), PChar(Params)));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.DetachDatabase(var DBHandle: IscDbHandle);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_detach_database(@FStatusVector, @DBHandle));
    finally
      UnLock;
    end;
  end;

//******************************************************************************
// Transaction
//******************************************************************************

  procedure TUIBLibrary.TransactionStart(var TraHandle: IscTrHandle; var DbHandle: IscDbHandle;
    const TPB: string = '');
  var Vector: TISCTEB;
  begin
    Vector.Handle  := @DbHandle;
    Vector.Length  := Length(TPB);
    Vector.Address := PChar(TPB);
    TransactionStartMultiple(TraHandle, 1, @Vector);
  end;

  procedure TUIBLibrary.TransactionStartMultiple(var TraHandle: IscTrHandle; DBCount: Smallint; Vector: PISCTEB);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_start_multiple(@FStatusVector, @TraHandle, DBCount, Vector));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.TransactionCommit(var TraHandle: IscTrHandle);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_commit_transaction(@FStatusVector, @TraHandle));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.TransactionRollback(var TraHandle: IscTrHandle);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_rollback_transaction(@FStatusVector, @TraHandle));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.TransactionCommitRetaining(var TraHandle: IscTrHandle);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_commit_retaining(@FStatusVector, @TraHandle));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.TransactionPrepare(var TraHandle: IscTrHandle);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_prepare_transaction(@FStatusVector, @TraHandle));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.TransactionRollbackRetaining(var TraHandle: IscTrHandle);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_rollback_retaining(@FStatusVector, @TraHandle));
    finally
      UnLock;
    end;
  end;

//******************************************************************************
// DSQL
//******************************************************************************

  function GetSQLDAData(SQLDA: TSQLDA): Pointer;
  begin
    if SQLDA <> nil then
      Result := SQLDA.FXSQLDA else
      Result := nil;
  end;

  //****************************************
  // API CALLS
  //****************************************

  procedure TUIBLibrary.DSQLExecuteImmediate(var DBHandle: IscDbHandle; var TraHandle: IscTrHandle;
    const Statement: string; Dialect: Word; Sqlda: TSQLDA = nil);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_dsql_execute_immediate(@FStatusVector, @DBHandle, @TraHandle,
        length(Statement), Pointer(Statement), Dialect, GetSQLDAData(Sqlda)));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.DSQLExecuteImmediate(const Statement: string; Dialect: Word; Sqlda: TSQLDA = nil);
  var p: pointer;
  begin
    Lock;
    try
      p := nil;
      CheckUIBApiCall(isc_dsql_execute_immediate(@FStatusVector, @p, @p,
        length(Statement), Pointer(Statement), Dialect, GetSQLDAData(Sqlda)));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.DSQLAllocateStatement(var DBHandle: IscDbHandle; var StmtHandle: IscStmtHandle);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_dsql_allocate_statement(@FStatusVector, @DBHandle, @StmtHandle));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.DSQLPrepare(var TraHandle: IscTrHandle; var StmtHandle: IscStmtHandle;
    Statement: string; Dialect: Word; Sqlda: TSQLResult = nil);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_dsql_prepare(@FStatusVector, @TraHandle, @StmtHandle, Length(Statement),
        PChar(Statement), Dialect, GetSQLDAData(Sqlda)));
    finally
      UnLock;
    end;
    if (Sqlda <> nil) then
    begin
      Sqlda.ClearRecords;
      if (Sqlda.GetActualFields <> Sqlda.GetAllocatedFields) then
      begin
        Sqlda.SetAllocatedFields(Sqlda.FXSQLDA.sqld);
        DSQLDescribe(StmtHandle, Dialect, Sqlda);
      end else
        Sqlda.AllocateDataBuffer;
    end;
  end;

  procedure TUIBLibrary.DSQLExecute(var TraHandle: IscTrHandle; var StmtHandle: IscStmtHandle;
    Dialect: Word; Sqlda: TSQLParams = nil);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_dsql_execute(@FStatusVector, @TraHandle, @StmtHandle,
        Dialect, GetSQLDAData(Sqlda)));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.DSQLExecute2(var TraHandle: IscTrHandle; var StmtHandle: IscStmtHandle; Dialect: Word;
    InSqlda: TSQLParams; OutSqlda: TSQLResult);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_dsql_execute2(@FStatusVector, @TraHandle, @StmtHandle, Dialect,
        GetSQLDAData(InSqlda), GetSQLDAData(OutSqlda)));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.DSQLFreeStatement(var StmtHandle: IscStmtHandle; Option: Word);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_dsql_free_statement(@FStatusVector, @StmtHandle, Option));
    finally
      UnLock;
    end;
  end;

  function TUIBLibrary.DSQLFetch(var StmtHandle: IscStmtHandle; Dialect: Word; Sqlda: TSQLResult): boolean;
  var Status: ISCStatus;
  begin
    Result := True;
    if (Sqlda <> nil) then
      Sqlda.FScrollEOF := False;
    Lock;
    try
      Status := isc_dsql_fetch(@FStatusVector, @StmtHandle, Dialect, GetSQLDAData(Sqlda));
    finally
      UnLock;
    end;
    case Status of
      0   : if (Sqlda <> nil) then
              if Sqlda.FCachedFetch then
                Sqlda.AddCurrentRecord;
      100 :
        begin
          Result := False; // end of fetch
          if (Sqlda <> nil) then
          begin
            Sqlda.FScrollEOF := True;
          end;
        end;
    else
      CheckUIBApiCall(Status);
    end;
  end;

  function  TUIBLibrary.DSQLFetchWithBlobs(var DBHhandle: IscDbHandle; var TraHandle: IscTrHandle;
    var StmtHandle: IscStmtHandle; Dialect: Word; Sqlda: TSQLResult): boolean;
  var
    Status: ISCStatus;
    BlobHandle: IscBlobHandle;
    i: Integer;
  begin
    Result := True;
    if (Sqlda <> nil) then
      sqlda.FScrollEOF := False;
    Lock;
    try
      Status := isc_dsql_fetch(@FStatusVector, @StmtHandle, Dialect, GetSQLDAData(Sqlda));
    finally
      UnLock;
    end;

    case Status of
      0   :
            begin
              if (Sqlda <> nil) then
              begin
                // read blobs
                for i := 0 to Length(Sqlda.FBlobsIndex) - 1 do
                begin
                  // free previous blobs if not stored
                  if (not Sqlda.FCachedFetch) and        // not stored
                    (Sqlda.FBlobArray[i].Size > 0)  then // not null (null if the first one)
                      FreeMem(Sqlda.FBlobArray[i].Buffer);

                  if Sqlda.IsNull[Sqlda.FBlobsIndex[i]] then
                  begin
                    Sqlda.FBlobArray[i].Size := 0;
                    Sqlda.FBlobArray[i].Buffer := nil;
                  end else
                  begin
                    BlobHandle := nil;
                    BlobOpen(DBHhandle, TraHandle, BlobHandle, Sqlda.AsQuad[Sqlda.FBlobsIndex[i]]);
                    try
                      BlobReadBuffer(BlobHandle, Sqlda.FBlobArray[i].Size, Sqlda.FBlobArray[i].Buffer); // memory allocated here !!
                    finally
                      BlobClose(BlobHandle);
                    end;
                  end;
                end;
                // add to list after the blobs are fetched
                if Sqlda.FCachedFetch then Sqlda.AddCurrentRecord;
              end;
            end;
      100 :
        begin
          Result := False; // end of fetch
          if (Sqlda <> nil) then
            Sqlda.FScrollEOF := True;
        end;
    else
      CheckUIBApiCall(Status);
    end;
  end;

  procedure TUIBLibrary.DSQLDescribe(var StmtHandle: IscStmtHandle; Dialect: Word; Sqlda: TSQLResult);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_dsql_describe(@FStatusVector, @StmtHandle, Dialect, GetSQLDAData(Sqlda)));
    finally
      UnLock;
    end;
    if (Sqlda <> nil) then
      Sqlda.AllocateDataBuffer;
  end;

  procedure TUIBLibrary.DSQLDescribeBind(var StmtHandle: IscStmtHandle; Dialect: Word; Sqlda: TSQLDA);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_dsql_describe_bind(@FStatusVector, @StmtHandle, Dialect,
        GetSQLDAData(Sqlda)));
    finally
      UnLock;
    end;
  end;

  procedure  TUIBLibrary.DSQLSetCursorName(var StmtHandle: IscStmtHandle; const cursor: string);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_dsql_set_cursor_name(@FStatusVector, @StmtHandle, PChar(cursor), 0));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.DSQLExecImmed2(var DBHhandle: IscDbHandle; var TraHandle: IscTrHandle;
    const Statement: string; dialect: Word; InSqlda, OutSqlda: TSQLDA);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_dsql_exec_immed2(@FStatusVector, @DBHhandle, @TraHandle, Length(Statement),
        PChar(Statement), dialect, GetSQLDAData(InSqlda), GetSQLDAData(OutSqlda)));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.DSQLInfo(var StmtHandle: IscStmtHandle; const Items: array of byte; var buffer: String);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_dsql_sql_info(@FStatusVector, @StmtHandle, Length(Items), @Items[0],
        Length(buffer), PChar(buffer)));
    finally
      UnLock;
    end;
  end;


  procedure TUIBLibrary.GetDSQLInfoData(var StmtHandle: IscStmtHandle; var DSQLInfoData: TDSQLInfoData;
    InfoCode: Byte);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_dsql_sql_info(@FStatusVector, @StmtHandle, 1, @InfoCode,
        SizeOf(TDSQLInfoData), @DSQLInfoData));
    finally
      UnLock;
    end;
    if (DSQLInfoData.InfoCode <> InfoCode) then
    begin
      // Contact me if you have this error.
      if DSQLInfoData.InfoCode = 2 then
        raise Exception.Create(EUIB_UNEXPECTEDERROR + ': Buffer too small.') else
        raise Exception.Create(EUIB_UNEXPECTEDERROR + ': Error getting SQL Info.');
    end;
  end;

  function TUIBLibrary.DSQLInfoPlan(var StmtHandle: IscStmtHandle): string;
  var DSQLInfoData: TDSQLInfoData;
  begin
    GetDSQLInfoData(StmtHandle, DSQLInfoData, isc_info_sql_get_plan);
    SetString(Result, PChar(@DSQLInfoData.PlanDesc[1]), DSQLInfoData.InfoLen - 1);
  end;

  function TUIBLibrary.DSQLInfoStatementType(var StmtHandle: IscStmtHandle): TUIBStatementType;
  var DSQLInfoData: TDSQLInfoData;
  begin
    GetDSQLInfoData(StmtHandle, DSQLInfoData, isc_info_sql_stmt_type);
    Dec(DSQLInfoData.StatementType);
    Result := DSQLInfoData.StatementType;
  end;

  procedure TUIBLibrary.DDLExecute(var DBHandle: IscDbHandle;
    var TraHandle: IscTrHandle; const ddl: string);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_ddl(@FStatusVector, @DBHandle, @TraHandle,
        length(ddl), Pointer(ddl)));
    finally
      UnLock;
    end;
  end;

//******************************************************************************
//  Array
//******************************************************************************
  function TUIBLibrary.ArrayLookupBounds(var DBHandle: IscDbHandle; var TransHandle: IscTrHandle;
    const RelationName, FieldName: String): TArrayDesc;
  begin
    Lock;
    try
      {$IFDEF IB7_UP}
        CheckUIBApiCall(isc_array_lookup_bounds2(@FStatusVector, @DBHandle, @TransHandle,
          PChar(RelationName), PChar(FieldName), @Result));
      {$ELSE}
        CheckUIBApiCall(isc_array_lookup_bounds(@FStatusVector, @DBHandle, @TransHandle,
          PChar(RelationName), PChar(FieldName), @Result));
      {$ENDIF}
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.ArrayGetSlice(var DBHandle: IscDbHandle; var TransHandle: IscTrHandle; ArrayId: TISCQuad;
    var desc: TArrayDesc; DestArray: PPointer; var SliceLength: Integer);
  begin
    Lock;
    try
      {$IFDEF IB7_UP}
        CheckUIBApiCall(isc_array_get_slice2(@FStatusVector, @DBHandle, @TransHandle, @ArrayId,
          @desc, DestArray, @SliceLength));
      {$ELSE}
        CheckUIBApiCall(isc_array_get_slice(@FStatusVector, @DBHandle, @TransHandle, @ArrayId,
          @desc, DestArray, @SliceLength));
      {$ENDIF}
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.ArrayPutSlice(var DBHandle: IscDbHandle; var TransHandle: IscTrHandle; ArrayId: TISCQuad;
    var desc: TArrayDesc; DestArray: PPointer; var SliceLength: Integer);
  begin
    Lock;
    try
      {$IFDEF IB7_UP}
        CheckUIBApiCall(isc_array_put_slice2(@FStatusVector, @DBHandle, @TransHandle, @ArrayId,
          @desc, DestArray, @SliceLength));
      {$ELSE}
        CheckUIBApiCall(isc_array_put_slice(@FStatusVector, @DBHandle, @TransHandle, @ArrayId,
          @desc, DestArray, @SliceLength));
      {$ENDIF}
    finally
      UnLock;
    end;
  end;

//******************************************************************************
//  Error-handling
//******************************************************************************

  function  TUIBLibrary.ErrSqlcode: ISCLong;
  begin
    Lock;
    try
      Result := isc_sqlcode(@FStatusVector);
    finally
      UnLock;
    end;
  end;

  function TUIBLibrary.ErrInterprete: String;
  var
    StatusVector: PStatusVector;
    i : Integer;
    buffer: array[0..512] of char;
  begin
    StatusVector := @FStatusVector;
    Lock;
    try
      if isc_interprete(buffer, @StatusVector) > 0 then
        Result := Result + Trim(buffer);

    finally
      UnLock;
    end;
    for i := 1 to 255 do if Result[i] = #0 then Break; // Quick trim
    SetLength(Result, i-1);
  end;

  function TUIBLibrary.ErrSQLInterprete(SQLCODE: Smallint): String;
  var
    i : Integer;
  begin
    SetLength(Result, 255);
    Lock;
    try
      isc_sql_interprete(SQLCODE, PChar(Result), 255);
    finally
      UnLock;
    end;
    for i := 1 to 255 do if Result[i] = #0 then Break; // Quick trim
    SetLength(Result, i-1);
  end;

//******************************************************************************
// Services
//******************************************************************************

  procedure TUIBLibrary.ServiceAttach(const ServiceName: string; var SvcHandle: IscSvcHandle; const Spb: string);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_service_attach(@FStatusVector, Length(ServiceName),
        PChar(ServiceName), @SvcHandle, Length(Spb), PChar(Spb)));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.ServiceDetach(var SvcHandle: IscSvcHandle);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_service_detach(@FStatusVector, @SvcHandle));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.ServiceQuery(var SvcHandle: IscSvcHandle; const SendSpb, RequestSpb: string; var Buffer: string);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_service_query(@FStatusVector, @SvcHandle, nil,
        Length(SendSpb), PChar(SendSpb), Length(RequestSpb), PChar(RequestSpb),
        Length(Buffer), PChar(Buffer)));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.ServiceStart(var SvcHandle: IscSvcHandle; const Spb: string);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_service_start(@FStatusVector, @SvcHandle, nil, Length(Spb), PChar(Spb)));
    finally
      UnLock;
    end;
  end;

//******************************************************************************
//  Blob
//******************************************************************************

  procedure TUIBLibrary.BlobOpen(var DBHandle: IscDbHandle; var TraHandle: IscTrHandle;
    var BlobHandle: IscBlobHandle; BlobId: TISCQuad; BPB: string = '');
  begin
    Lock;
    try
      CheckUIBApiCall(isc_open_blob2(@FStatusVector, @DBHandle, @TraHandle, @BlobHandle,
        @BlobId, Length(BPB), PChar(BPB)));
    finally
      UnLock;
    end;
  end;

  function TUIBLibrary.BlobGetSegment(var BlobHandle: IscBlobHandle; out length: Word;
    BufferLength: Word; Buffer: PChar): boolean;
  var AStatus: ISCStatus;
  begin
    Lock;
    try
      AStatus := isc_get_segment(@FStatusVector, @BlobHandle, @length, BufferLength, Buffer);
    finally
      UnLock;
    end;
    Result := (AStatus = 0) or (FStatusVector[1] = isc_segment);
    if not Result then
      if (FStatusVector[1] <> isc_segstr_eof) then
        CheckUIBApiCall(AStatus);
  end;

  procedure TUIBLibrary.BlobClose(var BlobHandle: IscBlobHandle);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_close_blob(@FStatusVector, @BlobHandle));
    finally
      UnLock;
    end;
  end;

type
  TBlobInfo = packed record
    Info: Char;
    Length: Word;
    case byte of
      0: (CardType: Cardinal);
      1: (ByteType: Byte);
  end;

  procedure TUIBLibrary.BlobSize(var BlobHandle: IscBlobHandle; out Size: Cardinal);
  var BlobInfo: array[0..1] of TBlobInfo;
  begin
    Lock;
    try
      CheckUIBApiCall(isc_blob_info(@FStatusVector, @BlobHandle, 1,
        isc_info_blob_total_length, SizeOf(BlobInfo), @BlobInfo));
      Size := BlobInfo[0].CardType;
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.BlobMaxSegment(var BlobHandle: IscBlobHandle; out Size: Cardinal);
  var BlobInfo: array[0..1] of TBlobInfo;
  begin
    Lock;
    try
      CheckUIBApiCall(isc_blob_info(@FStatusVector, @BlobHandle, 1,
        isc_info_blob_max_segment, SizeOf(BlobInfo), @BlobInfo));
      Size := BlobInfo[0].CardType;
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.BlobInfo(var BlobHandle: IscBlobHandle; out NumSegments, MaxSegment,
    TotalLength: Cardinal; out btype : byte);
  var BlobInfos: array[0..3] of TBlobInfo;
  begin
    Lock;
    try
      CheckUIBApiCall(isc_blob_info(@FStatusVector, @BlobHandle, 4,
        isc_info_blob_num_segments + isc_info_blob_max_segment +
        isc_info_blob_total_length + isc_info_blob_type, SizeOf(BlobInfos), @BlobInfos));
    finally
      UnLock;
    end;
    NumSegments := BlobInfos[0].CardType;
    MaxSegment  := BlobInfos[1].CardType;
    TotalLength := BlobInfos[2].CardType;
    btype       := BlobInfos[3].ByteType;
  end;

  procedure TUIBLibrary.BlobDefaultDesc(var Desc: TBlobDesc; const RelationName, FieldName: string);
  begin
    Lock;
    try
      {$IFDEF IB7_UP}
        isc_blob_default_desc2(@Desc, PChar(RelationName), PChar(FieldName));
      {$ELSE}
        isc_blob_default_desc(@Desc, PChar(RelationName), PChar(FieldName));
      {$ENDIF}
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.BlobSaveToStream(var BlobHandle: IscBlobHandle; Stream: TStream);
  var
    BlobInfos: array[0..2] of TBlobInfo;
    Buffer: Pointer;
    CurrentLength: Word;
  begin
    Lock;
    try
      CheckUIBApiCall(isc_blob_info(@FStatusVector, @BlobHandle, 2,
        isc_info_blob_max_segment + isc_info_blob_total_length,
        SizeOf(BlobInfos), @BlobInfos));
    finally
      UnLock;
    end;

    Stream.Size := BlobInfos[1].CardType; // don't realloc mem too many time
    Stream.Seek(0, soFromBeginning);
    Getmem(Buffer, BlobInfos[0].CardType);
    try
      while BlobGetSegment(BlobHandle, CurrentLength, BlobInfos[0].CardType, Buffer) do
        Stream.Write(Buffer^, CurrentLength);
    finally
      FreeMem(Buffer);
    end;
    Stream.Seek(0, soFromBeginning);
  end;

  function TUIBLibrary.BlobReadString(var BlobHandle: IscBlobHandle): string;
  begin
    BlobReadString(BlobHandle, Result);
  end;

  procedure TUIBLibrary.BlobReadString(var BlobHandle: IscBlobHandle; var Str: String);
  var
    BlobInfos: array[0..2] of TBlobInfo;
    CurrentLength: Word;
    Buffer: PChar;
    Pos: Integer;
  begin
    Lock;
    try
      CheckUIBApiCall(isc_blob_info(@FStatusVector, @BlobHandle, 2,
        isc_info_blob_max_segment + isc_info_blob_total_length,
        SizeOf(BlobInfos), @BlobInfos));
    finally
      UnLock;
    end;
    SetLength(Str, BlobInfos[1].CardType);
    Pos := 1;
    Getmem(Buffer, BlobInfos[0].CardType);
    try
      while BlobGetSegment(BlobHandle, CurrentLength, BlobInfos[0].CardType, Buffer) do
      begin
        move(Buffer^, Str[Pos], CurrentLength);
        inc(Pos, CurrentLength);
      end;
    finally
      FreeMem(Buffer);
    end;
  end;

  procedure TUIBLibrary.BlobReadBuffer(var BlobHandle: IscBlobHandle; var Size: Integer; var Buffer: Pointer);
  var
    BlobInfos: array[0..2] of TBlobInfo;
    CurrentLength: Word;
    TMP: PChar;
    Pos: Integer;
  begin
    Lock;
    try
      CheckUIBApiCall(isc_blob_info(@FStatusVector, @BlobHandle, 2,
        isc_info_blob_max_segment + isc_info_blob_total_length,
        SizeOf(BlobInfos), @BlobInfos));
    finally
      UnLock;
    end;
    Size := BlobInfos[1].CardType;
    GetMem(Buffer, Size);
    Pos := 0;
    Getmem(TMP, BlobInfos[0].CardType);
    try
      while BlobGetSegment(BlobHandle, CurrentLength, BlobInfos[0].CardType, TMP) do
      begin
        move(TMP^, PChar(Buffer)[Pos], CurrentLength);
        inc(Pos, CurrentLength);
      end;
    finally
      FreeMem(TMP);
    end;
  end;

  procedure TUIBLibrary.BlobReadVariant(var BlobHandle: IscBlobHandle; var Value: Variant);
  var
    BlobInfos: array[0..2] of TBlobInfo;
    CurrentLength: Word;
    TMP: PChar;
    Pos: Integer;
    Buffer: Pointer;
  begin
    Lock;
    try
      CheckUIBApiCall(isc_blob_info(@FStatusVector, @BlobHandle, 2,
        isc_info_blob_max_segment + isc_info_blob_total_length,
        SizeOf(BlobInfos), @BlobInfos));
    finally
      UnLock;
    end;
    Value := VarArrayCreate([0, BlobInfos[1].CardType - 1], varByte);
    Pos := 0;
    Getmem(TMP, BlobInfos[0].CardType);
    Buffer := VarArrayLock(Value);
    try
      while BlobGetSegment(BlobHandle, CurrentLength, BlobInfos[0].CardType, TMP) do
      begin
        move(TMP^, PChar(Buffer)[Pos], CurrentLength);
        inc(Pos, CurrentLength);
      end;
    finally
      FreeMem(TMP);
      VarArrayUnlock(Value);
    end;
  end;

  function TUIBLibrary.BlobCreate(var DBHandle: IscDbHandle; var TraHandle: IscTrHandle;
    var BlobHandle: IscBlobHandle): TISCQuad;
  begin
    Lock;
    try
      CheckUIBApiCall(isc_create_blob(@FStatusVector, @DBHandle, @TraHandle, @BlobHandle, @Result));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.BlobWriteSegment(var BlobHandle: IscBlobHandle; BufferLength: Word; Buffer: PChar);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_put_segment(@FStatusVector, @BlobHandle, BufferLength, Buffer));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.BlobWriteString(var BlobHandle: IscBlobHandle; var Str: String);
  begin
    BlobWriteSegment(BlobHandle, Length(Str), PChar(Str));
  end;

  procedure TUIBLibrary.BlobWriteStream(var BlobHandle: IscBlobHandle; Stream: TStream);
  var
    Buffer: array[0..255] of Char;
    count: Integer;
  begin
    Stream.Seek(0, soFromBeginning);
    count := Stream.Read(Buffer, 256);
    while Count > 0 do
    begin
      BlobWriteSegment(BlobHandle, count, Buffer);
      count := Stream.Read(Buffer, 256);
    end;
    Stream.Seek(0, soFromBeginning);
  end;

{$IFDEF IB71_UP}
  procedure TUIBLibrary.SavepointRelease(var TrHandle: IscTrHandle;
    const Name: string);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_release_savepoint(@FStatusVector, @TrHandle, PChar(Name)));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.SavepointRollback(var TrHandle: IscTrHandle;
    const Name: string; Option: Word);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_rollback_savepoint(@FStatusVector, @TrHandle, PChar(Name), Option));
    finally
      UnLock;
    end;
  end;

  procedure TUIBLibrary.SavepointStart(var TrHandle: IscTrHandle;
    const Name: string);
  begin
    Lock;
    try
      CheckUIBApiCall(isc_start_savepoint(@FStatusVector, @TrHandle, PChar(Name)));
    finally
      UnLock;
    end;
  end;
{$ENDIF}

//******************************************************************************
// Conversion
// Making a delphi conversion will help to transport data buffer and use it
// without GDS32 ;)
//******************************************************************************

  procedure DecodeSQLDate(const v: Integer; out Date: Double);
  var
    year: SmallInt;
    month, day: Word;
  begin
    DecodeSQLDate(v, year, month, day);
    Date := EncodeDate(Year, month, day)
  end;

  procedure DecodeSQLDate(v: Integer; out Year: SmallInt; out Month, Day: Word);
  var c: Word;
  begin
    inc(v, 678882);
    c     := (4 * v - 1) div 146097; // century
    v     := 4 * v - 1  - 146097 * c;
    day   := v div 4;
    v     := (4 * day + 3) div 1461;
    day   := 4 * day + 3 - 1461 * v;
    day   := (day + 4) div 4;
    month := (5 * day - 3) div 153;
    day   := 5 * day - 3 - 153 * month;
    day   := (day + 5) div 5;
    year  := 100 * c + v;
    if (month < 10) then inc(month, 3) else
      begin
        dec(month, 9);
        inc(year, 1);
      end;
  end;

{$IFDEF FPC}
{$IFDEF LINUX}
type
  PDayTable = ^TDayTable;
  TDayTable = array[1..12] of Word;
  
const
  MonthDays: array [Boolean] of TDayTable =
    ((31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31),
     (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31));
{$ENDIF}
{$ENDIF}

  procedure EncodeDate(const Year: Smallint; const Month: Word; Day: Word; out Date: Integer);
  var
    I: Integer;
    DayTable: PDayTable;
  begin
    Date := 0;
    DayTable := @MonthDays[IsLeapYear(Year)];
    if (Year >= 1) and (Year <= 9999) and (Month >= 1) and (Month <= 12) and
      (Day >= 1) and (Day <= DayTable^[Month]) then
    begin
      for I := 1 to Month - 1 do Inc(Day, DayTable^[I]);
      I := Year - 1;
      Date := I * 365 + I div 4 - I div 100 + I div 400 + Day - DateDelta;
    end;
  end;

  function DecodeSQLDate(const v: Integer): Integer;
  var
    year: SmallInt;
    month, day: Word;
  begin
    DecodeSQLDate(v, year, month, day);
    EncodeDate(Year, month, day, Result)
  end;


  procedure EncodeSQLDate(date: TDateTime; out v: Integer);
  var
    day, month: Word;
    year: Word;
    c, ya: Integer;
  begin
    DecodeDate(Date, year, month, day);
    if (month > 2) then
      dec(month, 3) else
      begin
        inc(month, 9);
        dec(year);
      end;
    c := year div 100;
    ya := year - (100 * c);
    v := ((146097 * c) div 4 + (1461 * ya) div 4 + (153 * month + 2) div 5 + day - 678882);
  end;

  procedure EncodeSQLDate(Year: SmallInt; Month, Day: Word; out v: Integer); overload;
  var c, ya: Integer;
  begin
    if (month > 2) then
      dec(month, 3) else
      begin
        inc(month, 9);
        dec(year);
      end;
    c := year div 100;
    ya := year - (100 * c);
    v := ((146097 * c) div 4 + (1461 * ya) div 4 + (153 * month + 2) div 5 + day - 678882);
  end;

  procedure DecodeTimeStamp(v: PISCTimeStamp; out DateTime: Double);
  begin
    DecodeSQLDate(v.timestamp_date, DateTime);
    DateTime := DateTime + (v.timestamp_time / 864000000);
  end;

  procedure DecodeTimeStamp(v: PISCTimeStamp; out TimeStamp: TTimeStamp);
  begin
    TimeStamp.Date := DecodeSQLDate(v.timestamp_date) + 693594;
    TimeStamp.Time := v.timestamp_time div 10;
  end;

  function  DecodeTimeStamp(v: PISCTimeStamp): Double;
  begin
    DecodeTimeStamp(v, Result);
  end;

  procedure EncodeTimeStamp(const DateTime: TDateTime; v: PISCTimeStamp);
  begin
    EncodeSQLDate(DateTime, v.timestamp_date);
    v.timestamp_time := Round(Frac(DateTime) * 864000000);
  end;

  procedure DecodeSQLTime(v: Cardinal; out Hour, Minute, Second: Word;
    out Fractions: LongWord);
  begin
    Hour      := v div 36000000;
    v         := v mod 36000000;
    if (v > 0) then
    begin
      Minute    := v div 600000;
      v         := v mod 600000;
      if (v > 0) then
      begin
        Second    := v div 10000;
        v         := v mod 10000;
        if (v > 0) then
          Fractions := v div 10 else
          Fractions := 0;
      end else
        begin
          Second    := 0;
          Fractions := 0;
        end;
    end else
      begin
        Minute    := 0;
        Second    := 0;
        Fractions := 0;
      end;
  end;

  procedure EncodeSQLTime(const Hour, Minute, Second: Word; const Fractions: LongWord; out v: Cardinal);
  begin
    v := Hour * 36000000 + Minute * 600000 + Second * 10000 + Fractions * 10;
  end;

 { TSQLDA }

  function TSQLDA.GetActualFields: Word;
  begin
    Result := FXSQLDA.sqld;
  end;

  function TSQLDA.GetAllocatedFields: Word;
  begin
    Result := FXSQLDA.sqln;
  end;

  function TSQLDA.GetPointer: PUIBSQLDa;
  begin
    result := FXSQLDA;
  end;

  procedure TSQLDA.SetAllocatedFields(Fields: Word);
  begin
    if Fields <= 0 then Fields := 1;
    ReallocMem(FXSQLDA, XSQLDA_LENGTH(Fields));
    FXSQLDA.sqln := Fields;
    FXSQLDA.sqld := Fields;
    FXSQLDA.version := SQLDA_CURRENT_VERSION;
  end;

  function TSQLDA.GetSqlName(const Index: Word): string;
  begin
    CheckRange(Index);
    SetString(Result, FXSQLDA.sqlvar[Index].SqlName,
      FXSQLDA.sqlvar[Index].SqlNameLength);
  end;

  function TSQLDA.GetAliasName(const Index: Word): string;
  begin
    CheckRange(Index);
    SetString(Result, FXSQLDA.sqlvar[Index].AliasName,
      FXSQLDA.sqlvar[Index].AliasNameLength);
  end;

  function TSQLDA.GetOwnName(const Index: Word): string;
  begin
    CheckRange(Index);
    SetString(Result, FXSQLDA.sqlvar[Index].OwnName,
      FXSQLDA.sqlvar[Index].OwnNameLength);
  end;

  function TSQLDA.GetRelName(const Index: Word): string;
  begin
    CheckRange(Index);
    SetString(Result, FXSQLDA.sqlvar[Index].RelName,
      FXSQLDA.sqlvar[Index].RelNameLength);
  end;

  function TSQLDA.GetIsNull(const Index: Word): boolean;
  begin
    CheckRange(Index);
    Result := (FXSQLDA.sqlvar[Index].sqlind <> nil) and
              (FXSQLDA.sqlvar[Index].sqlind^ = -1)
  end;

  procedure TSQLDA.CheckRange(const Index: Word);
  begin
    if Index >= Word(FXSQLDA.sqln) then
      raise EUIBError.CreateFmt(EUIB_FIELDNUMNOTFOUND, [Index]);
  end;

  function TSQLDA.DecodeString(const Code: Smallint; Index: Word): String;
  begin
    with FXSQLDA.sqlvar[Index] do
    case Code of
      SQL_TEXT    : SetString(Result, sqldata, sqllen);
      SQL_VARYING : SetString(Result, PVary(sqldata).vary_string, PVary(sqldata).vary_length);
    end;
  end;

  procedure TSQLDA.DecodeString(const Code: Smallint; Index: Word; out Str: String);
  begin
    with FXSQLDA.sqlvar[Index] do
    case Code of
      SQL_TEXT    : SetString(Str, sqldata, sqllen);
      SQL_VARYING : SetString(Str, PVary(sqldata).vary_string, PVary(sqldata).vary_length);
    end;
  end;

  procedure TSQLDA.DecodeWideString(const Code: Smallint; Index: Word; out Str: WideString);
    procedure SetWideString(var s: WideString; buffer: PChar; len: Integer);
    begin
      SetLength(s, len div 2);
      move(buffer^, PWideChar(s)^, len);
    end;
  begin
    with FXSQLDA.sqlvar[Index] do
    case Code of
      SQL_TEXT    : SetWideString(Str, sqldata, sqllen);
      SQL_VARYING : SetWideString(Str, PVary(sqldata).vary_string, PVary(sqldata).vary_length);
    end;
  end;

  function TSQLDA.GetAsDouble(const Index: Word): Double;
  var ASQLCode: SmallInt;
  begin
    CheckRange(Index);
    with FXSQLDA.sqlvar[Index] do
    begin
      Result := 0;
      if (sqlind <> nil) and (sqlind^ = -1) then Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : Result := PSmallInt(sqldata)^ / ScaleDivisor[sqlscale];
          SQL_LONG   : Result := PInteger(sqldata)^  / ScaleDivisor[sqlscale];
          SQL_INT64,
          SQL_QUAD   : Result := PInt64(sqldata)^    / ScaleDivisor[sqlscale];
          SQL_DOUBLE : Result := PDouble(sqldata)^;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : Result := PDouble(sqldata)^;
          SQL_TIMESTAMP : DecodeTimeStamp(PISCTimeStamp(sqldata), Result);
          SQL_TYPE_DATE : DecodeSQLDate(PInteger(sqldata)^, Result);
          SQL_TYPE_TIME : Result := PCardinal(sqldata)^ / 864000000;
          SQL_LONG      : Result := PInteger(sqldata)^;
          SQL_D_FLOAT,
          SQL_FLOAT     : Result := PSingle(sqldata)^;
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : Result := PSmallint(sqldata)^;
          SQL_INT64     : Result := PInt64(sqldata)^;
          SQL_TEXT      : Result := StrToFloat(DecodeString(SQL_TEXT, Index));
          SQL_VARYING   : Result := StrToFloat(DecodeString(SQL_VARYING, Index));
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
    end;
  end;

  function TSQLDA.GetAsInt64(const Index: Word): Int64;
  var ASQLCode: SmallInt;
  begin
    CheckRange(Index);
    with FXSQLDA.sqlvar[Index] do
    begin
      Result := 0;
      if (sqlind <> nil) and (sqlind^ = -1) then Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : Result := PSmallInt(sqldata)^ div ScaleDivisor[sqlscale];
          SQL_LONG   : Result := PInteger(sqldata)^  div ScaleDivisor[sqlscale];
          SQL_INT64,
          SQL_QUAD   : Result := PInt64(sqldata)^    div ScaleDivisor[sqlscale];
          SQL_DOUBLE : Result := Trunc(PDouble(sqldata)^);
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : Result := Trunc(PDouble(sqldata)^);
          SQL_TIMESTAMP : Result := DecodeSQLDate(PISCTimeStamp(sqldata).timestamp_date); // Only Date
          SQL_TYPE_DATE : Result := DecodeSQLDate(PInteger(sqldata)^);
          SQL_TYPE_TIME : ; // Result := 0; What else ??
          SQL_LONG      : Result := PInteger(sqldata)^;
          SQL_D_FLOAT,
          SQL_FLOAT     : Result := Trunc(PSingle(sqldata)^);
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : Result := PSmallint(sqldata)^;
          SQL_INT64     : Result := PInt64(sqldata)^;
          SQL_TEXT      : Result := StrToInt64(DecodeString(SQL_TEXT, Index));
          SQL_VARYING   : Result := StrToInt64(DecodeString(SQL_VARYING, Index));
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
    end;
  end;

  function TSQLDA.GetAsInteger(const Index: Word): Integer;
  var ASQLCode: SmallInt;
  begin
    CheckRange(Index);
    with FXSQLDA.sqlvar[Index] do
    begin
      Result := 0;
      if (sqlind <> nil) and (sqlind^ = -1) then Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : Result := PSmallInt(sqldata)^ div ScaleDivisor[sqlscale];
          SQL_LONG   : Result := PInteger(sqldata)^  div ScaleDivisor[sqlscale];
          SQL_INT64,
          SQL_QUAD   : Result := PInt64(sqldata)^    div ScaleDivisor[sqlscale];
          SQL_DOUBLE : Result := Trunc(PDouble(sqldata)^);
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : Result := Trunc(PDouble(sqldata)^);
          SQL_TIMESTAMP : Result := DecodeSQLDate(PISCTimeStamp(sqldata).timestamp_date); // Only Date
          SQL_TYPE_DATE : Result := DecodeSQLDate(PInteger(sqldata)^);
          SQL_TYPE_TIME : ; // Result := 0; What else ??
          SQL_LONG      : Result := PInteger(sqldata)^;
          SQL_D_FLOAT,
          SQL_FLOAT     : Result := Trunc(PSingle(sqldata)^);
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : Result := PSmallint(sqldata)^;
          SQL_INT64     : Result := PInt64(sqldata)^;
          SQL_TEXT      : Result := StrToInt(DecodeString(SQL_TEXT, Index));
          SQL_VARYING   : Result := StrToInt(DecodeString(SQL_VARYING, Index));
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
    end;
  end;

  function TSQLDA.GetAsSingle(const Index: Word): Single;
  var ASQLCode: SmallInt;
  begin
    CheckRange(Index);
    with FXSQLDA.sqlvar[Index] do
    begin
      Result := 0;
      if (sqlind <> nil) and (sqlind^ = -1) then Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : Result := PSmallInt(sqldata)^ / ScaleDivisor[sqlscale];
          SQL_LONG   : Result := PInteger(sqldata)^  / ScaleDivisor[sqlscale];
          SQL_INT64,
          SQL_QUAD   : Result := PInt64(sqldata)^    / ScaleDivisor[sqlscale];
          SQL_DOUBLE : Result := PDouble(sqldata)^;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : Result := PDouble(sqldata)^;
          SQL_TIMESTAMP : Result := DecodeTimeStamp(PISCTimeStamp(sqldata));
          SQL_TYPE_DATE : Result := DecodeSQLDate(PInteger(sqldata)^);
          SQL_TYPE_TIME : Result := PCardinal(sqldata)^ / 864000000;
          SQL_LONG      : Result := PInteger(sqldata)^;
          SQL_D_FLOAT,
          SQL_FLOAT     : Result := PSingle(sqldata)^;
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : Result := PSmallint(sqldata)^;
          SQL_INT64     : Result := PInt64(sqldata)^;
          SQL_TEXT      : Result := StrToFloat(DecodeString(SQL_TEXT, Index));
          SQL_VARYING   : Result := StrToFloat(DecodeString(SQL_VARYING, Index));
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
    end;
  end;

  function TSQLDA.GetAsSmallint(const Index: Word): Smallint;
  var ASQLCode: SmallInt;
  begin
    CheckRange(Index);
    with FXSQLDA.sqlvar[Index] do
    begin
      Result := 0;
      if (sqlind <> nil) and (sqlind^ = -1) then Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : Result := PSmallInt(sqldata)^ div ScaleDivisor[sqlscale];
          SQL_LONG   : Result := PInteger(sqldata)^  div ScaleDivisor[sqlscale];
          SQL_INT64,
          SQL_QUAD   : Result := PInt64(sqldata)^    div ScaleDivisor[sqlscale];
          SQL_DOUBLE : Result := Trunc(PDouble(sqldata)^);
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : Result := Trunc(PDouble(sqldata)^);
          SQL_TIMESTAMP : Result := DecodeSQLDate(PISCTimeStamp(sqldata).timestamp_date); // Only Date
          SQL_TYPE_DATE : Result := DecodeSQLDate(PInteger(sqldata)^);
          SQL_TYPE_TIME : ; // Result := 0; What else ??
          SQL_LONG      : Result := PInteger(sqldata)^;
          SQL_D_FLOAT,
          SQL_FLOAT     : Result := Trunc(PSingle(sqldata)^);
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : Result := PSmallint(sqldata)^;
          SQL_INT64     : Result := PInt64(sqldata)^;
          SQL_TEXT      : Result := StrToInt(DecodeString(SQL_TEXT, Index));
          SQL_VARYING   : Result := StrToInt(DecodeString(SQL_VARYING, Index));
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
    end;
  end;

  function TSQLDA.GetAsString(const Index: Word): String;
    function BoolToStr(const Value: boolean): string;
    begin if Value then result := sUIBTrue else result := sUIBFalse; end;
  var ASQLCode: SmallInt;
  begin
    CheckRange(Index);
    Result := '';
    with FXSQLDA.sqlvar[Index] do
    begin
      if (sqlind <> nil) and (sqlind^ = -1) then Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : Result := FloatToStr(PSmallInt(sqldata)^ / ScaleDivisor[sqlscale]);
          SQL_LONG   : Result := FloatToStr(PInteger(sqldata)^  / ScaleDivisor[sqlscale]);
          SQL_INT64,
          SQL_QUAD   : Result := FloatToStr(PInt64(sqldata)^    / ScaleDivisor[sqlscale]);
          SQL_DOUBLE : Result := FloatToStr(PDouble(sqldata)^);
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : Result := FloatToStr(PDouble(sqldata)^);
          SQL_TIMESTAMP : Result := DateTimeToStr(DecodeTimeStamp(PISCTimeStamp(sqldata)));
          SQL_TYPE_DATE : Result := DateToStr(DecodeSQLDate(PInteger(sqldata)^));
          SQL_TYPE_TIME : Result := TimeToStr(PCardinal(sqldata)^ / 864000000);
          SQL_LONG      : Result := IntToStr(PInteger(sqldata)^);
          SQL_D_FLOAT,
          SQL_FLOAT     : Result := FloatToStr(PSingle(sqldata)^);
{$IFDEF IB7_UP}
          SQL_BOOLEAN   : Result := BoolToStr(PSmallint(sqldata)^ = 1);
{$ENDIF}
          SQL_SHORT     : Result := IntToStr(PSmallint(sqldata)^);
          SQL_INT64     : Result := IntToStr(PInt64(sqldata)^);
          SQL_TEXT      : DecodeString(SQL_TEXT, Index, Result);
          SQL_VARYING   : DecodeString(SQL_VARYING, Index, Result);
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
    end;
  end;


  function TSQLDA.GetAsQuad(const Index: Word): TISCQuad;
  begin
    CheckRange(Index);
    with FXSQLDA.sqlvar[Index] do
      if not ((sqlind <> nil) and (sqlind^ = -1)) then
        case (sqltype and not(1)) of
          SQL_QUAD, SQL_DOUBLE, SQL_INT64, SQL_BLOB, SQL_ARRAY: result := PISCQuad(sqldata)^;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end
      else
        Result := QuadNull;
  end;

  function TSQLDA.GetFieldCount: Integer;
  begin
    Result := FXSQLDA.sqln;
  end;

  function TSQLDA.GetSQLType(const Index: Word): Smallint;
  begin
    CheckRange(Index);
    result := FXSQLDA.sqlvar[Index].sqltype and not (1);
  end;

  function TSQLDA.GetSQLLen(const Index: Word): Smallint;
  begin
    CheckRange(Index);
    result := FXSQLDA.sqlvar[Index].sqllen;
  end;

  function TSQLDA.GetIsBlob(const Index: Word): boolean;
  begin
    CheckRange(Index);
    result := ((FXSQLDA.sqlvar[Index].sqltype and not(1)) = SQL_BLOB);
  end;

  function TSQLDA.GetFieldIndex(const name: String): Word;
  begin
    for Result := 0 to GetAllocatedFields - 1 do
      if FXSQLDA.sqlvar[Result].AliasNameLength = Length(name) then
        if StrLIComp(@FXSQLDA.sqlvar[Result].aliasname, PChar(Name),
          FXSQLDA.sqlvar[Result].AliasNameLength) = 0 then Exit;
    raise EUIBError.CreateFmt(EUIB_FIELDSTRNOTFOUND, [name]);
  end;

  function TSQLDA.GetByNameAsDouble(const Name: String): Double;
  begin
    Result := GetAsDouble(GetFieldIndex(Name));
  end;

  function TSQLDA.GetByNameAsInt64(const Name: String): Int64;
  begin
    Result := GetAsInt64(GetFieldIndex(Name));
  end;

  function TSQLDA.GetByNameAsInteger(const Name: String): Integer;
  begin
    Result := GetAsInteger(GetFieldIndex(Name));
  end;

  function TSQLDA.GetByNameAsQuad(const Name: String): TISCQuad;
  begin
    Result := GetAsQuad(GetFieldIndex(Name));
  end;

  function TSQLDA.GetByNameAsSingle(const Name: String): Single;
  begin
    Result := GetAsSingle(GetFieldIndex(Name));
  end;

  function TSQLDA.GetByNameAsSmallint(const Name: String): Smallint;
  begin
    Result := GetAsSmallint(GetFieldIndex(Name));
  end;

  function TSQLDA.GetByNameAsString(const Name: String): String;
  begin
    Result := GetAsString(GetFieldIndex(Name));
  end;

  function TSQLDA.GetAsVariant(const Index: Word): Variant;
  var
    ASQLCode: SmallInt;
    Dbl: Double;
  begin
    CheckRange(Index);
    with FXSQLDA.sqlvar[Index] do
    begin
      Result := NULL;
      if (sqlind <> nil) and (sqlind^ = -1) then Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : Result := PSmallInt(sqldata)^ / ScaleDivisor[sqlscale];
          SQL_LONG   : Result := PInteger(sqldata)^  / ScaleDivisor[sqlscale];
          SQL_INT64,
          SQL_QUAD   : Result := PInt64(sqldata)^    / ScaleDivisor[sqlscale];
          SQL_DOUBLE : Result := PDouble(sqldata)^;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : Result := PDouble(sqldata)^;
          SQL_TIMESTAMP : Result := TDateTime(DecodeTimeStamp(PISCTimeStamp(sqldata)));
          SQL_TYPE_DATE :
            begin
              Dbl := DecodeSQLDate(PInteger(sqldata)^);
              Result := TDateTime(Dbl);
            end;
          SQL_TYPE_TIME : Result := PCardinal(sqldata)^ / 864000000;
          SQL_LONG      : Result := PInteger(sqldata)^;
          SQL_D_FLOAT,
          SQL_FLOAT     : Result := PSingle(sqldata)^;
{$IFDEF IB7_UP}
          SQL_BOOLEAN   : Result := PSmallint(sqldata)^ = 1;
{$ENDIF}
          SQL_SHORT     : Result := PSmallint(sqldata)^;
{$IFDEF COMPILER6_UP}
          SQL_INT64     : Result := PInt64(sqldata)^;
{$ELSE}
          SQL_INT64     : Result := Integer(PInt64(sqldata)^);
{$ENDIF}
          SQL_TEXT      : Result := DecodeString(SQL_TEXT, Index);
          SQL_VARYING   : Result := DecodeString(SQL_VARYING, Index);
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
    end;
  end;

  function TSQLDA.GetByNameAsVariant(const Name: String): Variant;
  begin
    Result := GetAsVariant(GetFieldIndex(Name));
  end;

{ TSQLDAResult }

  constructor TSQLResult.Create(Fields: SmallInt = 0;
    CachedFetch: Boolean = False;
    FetchBlobs: boolean = false;
    BufferChunks: Cardinal = 1000);
  begin
    FCachedFetch := CachedFetch;
    FFetchBlobs := FetchBlobs;
    FDataBufferLength := 0;
    FDataBuffer := nil;
    if Fields <= 0 then Fields := 0;
    GetMem(FXSQLDA, XSQLDA_LENGTH(Fields));
    FXSQLDA.sqln := Fields;
    FXSQLDA.sqld := Fields;
    FXSQLDA.version := SQLDA_CURRENT_VERSION;
    FBufferChunks := BufferChunks;
  end;

  destructor TSQLResult.Destroy;
  begin
    ClearRecords;
    FreeMem(FXSQLDA);
    if FDataBuffer <> nil then
    begin
      if (not FCachedFetch) and FFetchBlobs then
        FreeBlobs(FDataBuffer);
      FreeMem(FDataBuffer)
    end;
    inherited;
  end;

  procedure TSQLResult.AddCurrentRecord;
  begin
    if not Assigned(FRecords) then
      FRecords := TMemoryPool.Create(FDataBufferLength, FBufferChunks);
    Move(FDataBuffer^, FRecords.New^, FDataBufferLength);
    FCurrentRecord := FRecords.Count - 1;
  end;

  procedure TSQLResult.ClearRecords;
  var
    i: Integer;
  begin
    FScrollEOF := False;
    if Assigned(FRecords) then
    begin
      if FFetchBlobs then
        for i := 0 to FRecords.Count - 1 do
          FreeBlobs(FRecords.Items[i]);
      FreeAndNil(FRecords);
    end;
  end;

  procedure TSQLResult.GetRecord(const Index: Integer);
  begin
    if (Index <> FCurrentRecord) then
    begin
      Move(FRecords.Items[Index]^, FDataBuffer^, FDataBufferLength);
      FCurrentRecord := Index;
    end;
  end;

  function TSQLResult.GetRecordCount: Integer;
  begin
    if Assigned(FRecords) then
      Result := FRecords.Count else
      Result := 0;
  end;

  procedure TSQLResult.AllocateDataBuffer;
  var
    i, LastLen: SmallInt;
    BlobCount: Word;
  begin
    FDataBufferLength := 0;
    LastLen    := 0;
    BlobCount := 0;
    SetLength(FBlobsIndex, BlobCount);
    // calculate offsets and store them instead of pointers ;)
    for i := 0 to FXSQLDA.sqln - 1 do
    begin
      Inc(FDataBufferLength, LastLen);
      FXSQLDA.sqlvar[i].sqldata := Pointer(FDataBufferLength);
      if FXSQLDA.sqlvar[i].sqltype and not (1) = SQL_VARYING then
        LastLen := FXSQLDA.sqlvar[i].sqllen + 2 else
        LastLen := FXSQLDA.sqlvar[i].sqllen;
      if ((FXSQLDA.sqlvar[i].sqltype and 1) = 1) then
      begin
        Inc(FDataBufferLength, LastLen);
        FXSQLDA.sqlvar[i].sqlind := Pointer(FDataBufferLength);
        LastLen := 2; // SizeOf(SmallInt)
      end else
        FXSQLDA.sqlvar[i].sqlind := nil;
      // count blobs
      if FFetchBlobs and ((FXSQLDA.sqlvar[i].sqltype and not 1) = SQL_BLOB) then
      begin
        inc(BlobCount);
        SetLength(FBlobsIndex, BlobCount);
        FBlobsIndex[BlobCount-1] := i;
      end;
    end;
    Inc(FDataBufferLength, LastLen);
    Inc(FDataBufferLength, BlobCount * SizeOf(TBlobData)); // Size + Pointer

    // Now we have the total length needed
    if (FDataBuffer = nil) then
      GetMem(FDataBuffer, FDataBufferLength {+ (FXSQLDA.sqln * 2)}) else
      ReallocMem(FDataBuffer, FDataBufferLength {+ (FXSQLDA.sqln * 2)});
    FillChar(FDataBuffer^, FDataBufferLength, 0);
    FBlobArray := FDataBuffer;
    Inc(Integer(FBlobArray), FDataBufferLength - BlobCount * SizeOf(TBlobData));

    // increment Offsets with the buffer
    for i := 0 to FXSQLDA.sqln - 1 do
    begin
      inc(Integer(FXSQLDA.sqlvar[i].sqldata), Integer(FDataBuffer));
      if (FXSQLDA.sqlvar[i].sqlind <> nil) then
        inc(Integer(FXSQLDA.sqlvar[i].sqlind), Integer(FDataBuffer));
    end;
  end;

  procedure TSQLResult.SaveToStream(Stream: TStream);
  var
    RecCount, i, j: Integer;
    BlobArray: PBlobDataArray;
  begin
    Stream.Write(FCachedFetch, SizeOf(FCachedFetch));
    Stream.Write(FFetchBlobs, SizeOf(FFetchBlobs));

    Stream.Write(FXSQLDA.sqln, SizeOf(FXSQLDA.sqln));
    Stream.Write(FXSQLDA^, XSQLDA_LENGTH(FXSQLDA.sqln)); // MetaData
    RecCount := RecordCount;
    Stream.Write(RecCount, SizeOf(RecCount));
    for i := 0 to RecCount - 1 do
    begin
      Stream.Write(FRecords.Items[i]^, FDataBufferLength);
      for j := 0 to Length(FBlobsIndex) - 1 do
      begin
        BlobArray := Pointer(Integer(FRecords.Items[i]) + FDataBufferLength - (Length(FBlobsIndex)*8));
        Stream.Write(BlobArray[j].Size, 4);
        Stream.Write(BlobArray[j].Buffer^, BlobArray[j].Size);
      end;
    end;
  end;

  procedure TSQLResult.LoadFromStream(Stream: TStream);
  var
    Fields: SmallInt;
    RecCount, i, j: Integer;
  begin
    // CleanUp
    ClearRecords;
    if (not FCachedFetch) and FFetchBlobs then
      FreeBlobs(FDataBuffer);

    Stream.Read(FCachedFetch, SizeOf(FCachedFetch));
    Stream.Read(FFetchBlobs, SizeOf(FFetchBlobs));

    Stream.Read(Fields, SizeOf(Fields));
    SetAllocatedFields(Fields);
    Stream.Read(FXSQLDA^, XSQLDA_LENGTH(Fields));

    // realloc & index buffer
    AllocateDataBuffer;
    Stream.Read(RecCount, SizeOf(RecCount));
    FBufferChunks := RecCount; // Inprove memory allocation
    for i := 0 to RecCount - 1 do
    begin
      Stream.Read(FDataBuffer^, FDataBufferLength);
      for j := 0 to Length(FBlobsIndex) - 1 do
      begin
        Stream.Read(FBlobArray[j].Size, 4);
        if FBlobArray[j].Size > 0 then
        begin
          GetMem(FBlobArray[j].Buffer, FBlobArray[j].Size);
          Stream.Read(FBlobArray[j].Buffer^, FBlobArray[j].Size);
        end else
          FBlobArray[j].Buffer := nil;
      end;
      AddCurrentRecord;
    end;

    FScrollEOF := True;
  end;

  function TSQLResult.GetCurrentRecord: Integer;
  begin
    if (FRecords = nil) then
      Result := -1 else
      Result := FCurrentRecord;
  end;

  procedure TSQLResult.FreeBlobs(Buffer: Pointer);
  var
    BlobArray: PBlobDataArray;
    I: integer;
  begin
    BlobArray := Pointer(Integer(Buffer) + FDataBufferLength - (Length(FBlobsIndex)*8));
    for I := 0 to Length(FBlobsIndex) - 1 do
      if BlobArray[I].Size > 0 then
        FreeMem(BlobArray[I].Buffer);
  end;

  function TSQLResult.GetBlobIndex(const Index: Word): Word;
  begin
    if FFetchBlobs then
    begin
      for Result := 0 to Length(FBlobsIndex) - 1 do
        if (FBlobsIndex[Result] = Index) then Exit;
      raise Exception.CreateFmt(EUIB_BLOBFIELDNOTFOUND, [Index]);
    end else
      raise Exception.Create(EUIB_FETCHBLOBNOTSET);
  end;

  function TSQLResult.GetEof: boolean;
  begin
    Result := FScrollEOF;
  end;

  procedure TSQLResult.ReadBlob(const Index: Word; var str: string);
  begin
    CheckRange(Index);
    with FBlobArray[GetBlobIndex(Index)] do
    begin
      SetLength(str, Size);
      Move(Buffer^, PChar(Str)^, Size);
    end;
  end;

  procedure TSQLResult.ReadBlob(const Index: Word; Stream: TStream);
  begin
    CheckRange(Index);
    with FBlobArray[GetBlobIndex(Index)] do
    begin
      Stream.Seek(0, 0);
      Stream.Write(Buffer^, Size);
      Stream.Seek(0, 0);
    end;
  end;

  procedure TSQLResult.ReadBlob(const Index: Word; var Value: Variant);
  var PData: Pointer;
  begin
    CheckRange(Index);
    with FBlobArray[GetBlobIndex(Index)] do
    begin
      Value := VarArrayCreate([0, Size-1], varByte);
      PData := VarArrayLock(Value);
      try
        move(Buffer^, PData^, Size);
      finally
        VarArrayUnlock(Value);
      end;
    end;
  end;

  procedure TSQLResult.ReadBlob(const Index: Word; var str: WideString);
  begin
    CheckRange(Index);
    with FBlobArray[GetBlobIndex(Index)] do
    begin
      SetLength(str, Size);
      Move(Buffer^, PWideChar(Str)^, Size);
    end;
  end;

  procedure TSQLResult.ReadBlob(const name: string; var str: WideString);
  begin
    ReadBlob(GetFieldIndex(name), str);
  end;

  procedure TSQLResult.ReadBlob(const name: string; var str: string);
  begin
    ReadBlob(GetFieldIndex(name), str);
  end;

  procedure TSQLResult.ReadBlob(const name: string; Stream: TStream);
  begin
    ReadBlob(GetFieldIndex(name), Stream);
  end;

  procedure TSQLResult.ReadBlob(const name: string; var Value: Variant);
  begin
    ReadBlob(GetFieldIndex(name), Value);
  end;

  function TSQLResult.GetAsString(const Index: Word): String;
    function BoolToStr(const Value: boolean): string;
    begin if Value then result := sUIBTrue else result := sUIBFalse; end;
  var ASQLCode: SmallInt;
  begin
    CheckRange(Index);
    Result := '';
    with FXSQLDA.sqlvar[Index] do
    begin
      if (sqlind <> nil) and (sqlind^ = -1) then Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : Result := FloatToStr(PSmallInt(sqldata)^ / ScaleDivisor[sqlscale]);
          SQL_LONG   : Result := FloatToStr(PInteger(sqldata)^  / ScaleDivisor[sqlscale]);
          SQL_INT64,
          SQL_QUAD   : Result := FloatToStr(PInt64(sqldata)^    / ScaleDivisor[sqlscale]);
          SQL_DOUBLE : Result := FloatToStr(PDouble(sqldata)^);
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : Result := FloatToStr(PDouble(sqldata)^);
          SQL_TIMESTAMP : Result := DateTimeToStr(DecodeTimeStamp(PISCTimeStamp(sqldata)));
          SQL_TYPE_DATE : Result := DateToStr(DecodeSQLDate(PInteger(sqldata)^));
          SQL_TYPE_TIME : Result := TimeToStr(PCardinal(sqldata)^ / 864000000);
          SQL_LONG      : Result := IntToStr(PInteger(sqldata)^);
          SQL_D_FLOAT,
          SQL_FLOAT     : Result := FloatToStr(PSingle(sqldata)^);
{$IFDEF IB7_UP}
          SQL_BOOLEAN   : Result := BoolToStr(PSmallint(sqldata)^ = 1);
{$ENDIF}
          SQL_SHORT     : Result := IntToStr(PSmallint(sqldata)^);
          SQL_INT64     : Result := IntToStr(PInt64(sqldata)^);
          SQL_TEXT      : DecodeString(SQL_TEXT, Index, Result);
          SQL_VARYING   : DecodeString(SQL_VARYING, Index, Result);
          SQL_BLOB      : ReadBlob(Index, Result);
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
    end;
  end;

  function TSQLResult.GetAsWideString(const Index: Word): WideString;
    function BoolToStr(const Value: boolean): string;
    begin if Value then result := sUIBTrue else result := sUIBFalse; end;
  var ASQLCode: SmallInt;
  begin
    CheckRange(Index);
    Result := '';
    with FXSQLDA.sqlvar[Index] do
    begin
      if (sqlind <> nil) and (sqlind^ = -1) then Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : Result := FloatToStr(PSmallInt(sqldata)^ / ScaleDivisor[sqlscale]);
          SQL_LONG   : Result := FloatToStr(PInteger(sqldata)^  / ScaleDivisor[sqlscale]);
          SQL_INT64,
          SQL_QUAD   : Result := FloatToStr(PInt64(sqldata)^    / ScaleDivisor[sqlscale]);
          SQL_DOUBLE : Result := FloatToStr(PDouble(sqldata)^);
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : Result := FloatToStr(PDouble(sqldata)^);
          SQL_TIMESTAMP : Result := DateTimeToStr(DecodeTimeStamp(PISCTimeStamp(sqldata)));
          SQL_TYPE_DATE : Result := DateToStr(DecodeSQLDate(PInteger(sqldata)^));
          SQL_TYPE_TIME : Result := TimeToStr(PCardinal(sqldata)^ / 864000000);
          SQL_LONG      : Result := IntToStr(PInteger(sqldata)^);
          SQL_D_FLOAT,
          SQL_FLOAT     : Result := FloatToStr(PSingle(sqldata)^);
{$IFDEF IB7_UP}
          SQL_BOOLEAN   : Result := BoolToStr(PSmallint(sqldata)^ = 1);
{$ENDIF}
          SQL_SHORT     : Result := IntToStr(PSmallint(sqldata)^);
          SQL_INT64     : Result := IntToStr(PInt64(sqldata)^);
          SQL_TEXT      : DecodeWideString(SQL_TEXT, Index, Result);
          SQL_VARYING   : DecodeWideString(SQL_VARYING, Index, Result);
          SQL_BLOB      : ReadBlob(Index, Result);
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
    end;
  end;

  function TSQLResult.GetAsVariant(const Index: Word): Variant;
  var
    ASQLCode: SmallInt;
    Dbl: Double;
  begin
    CheckRange(Index);
    with FXSQLDA.sqlvar[Index] do
    begin
      Result := NULL;
      if (sqlind <> nil) and (sqlind^ = -1) then Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : Result := PSmallInt(sqldata)^ / ScaleDivisor[sqlscale];
          SQL_LONG   : Result := PInteger(sqldata)^  / ScaleDivisor[sqlscale];
          SQL_INT64,
          SQL_QUAD   : Result := PInt64(sqldata)^    / ScaleDivisor[sqlscale];
          SQL_DOUBLE : Result := PDouble(sqldata)^;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : Result := PDouble(sqldata)^;
          SQL_TIMESTAMP : Result := TDateTime(DecodeTimeStamp(PISCTimeStamp(sqldata)));
          SQL_TYPE_DATE :
            begin
              Dbl := DecodeSQLDate(PInteger(sqldata)^);
              Result := TDateTime(Dbl);
            end;
          SQL_TYPE_TIME : Result := PCardinal(sqldata)^ / 864000000;
          SQL_LONG      : Result := PInteger(sqldata)^;
          SQL_D_FLOAT,
          SQL_FLOAT     : Result := PSingle(sqldata)^;
{$IFDEF IB7_UP}
          SQL_BOOLEAN   : Result :=  WordBool(PSmallint(sqldata)^);
{$ENDIF}
          SQL_SHORT     : Result := PSmallint(sqldata)^;
{$IFDEF COMPILER6_UP}
          SQL_INT64     : Result := PInt64(sqldata)^;
{$ELSE}
          SQL_INT64     : Result := Integer(PInt64(sqldata)^);
{$ENDIF}
          SQL_TEXT      : Result := DecodeString(SQL_TEXT, Index);
          SQL_VARYING   : Result := DecodeString(SQL_VARYING, Index);
          SQL_BLOB      : ReadBlob(Index, Result);
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
    end;
  end;

function TSQLDA.GetByNameIsBlob(const Name: String): boolean;
begin
  Result := GetIsBlob(GetFieldIndex(Name));
end;

function TSQLDA.GetByNameIsNull(const Name: String): boolean;
begin
  Result := GetIsNull(GetFieldIndex(Name));
end;

function TSQLDA.GetAsDateTime(const Index: Word): TDateTime;
begin
  Result := GetAsDouble(Index);
end;

function TSQLDA.GetByNameAsDateTime(const Name: String): TDateTime;
begin
  Result := GetAsDouble(GetFieldIndex(Name));
end;

function TSQLDA.GetIsNullable(const Index: Word): boolean;
begin
  CheckRange(Index);
  Result := (FXSQLDA.sqlvar[Index].sqlind <> nil);
end;

function TSQLDA.GetByNameIsNullable(const Name: String): boolean;
begin
  Result := GetIsNullable(GetFieldIndex(Name));
end;

function TSQLDA.GetAsCurrency(const Index: Word): Currency;
  var ASQLCode: SmallInt;
  begin
    CheckRange(Index);
    with FXSQLDA.sqlvar[Index] do
    begin
      Result := 0;
      if (sqlind <> nil) and (sqlind^ = -1) then Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : Result := PSmallInt(sqldata)^ / ScaleDivisor[sqlscale];
          SQL_LONG   : Result := PInteger(sqldata)^  / ScaleDivisor[sqlscale];
          SQL_INT64,
          SQL_QUAD   : Result := PInt64(sqldata)^    / ScaleDivisor[sqlscale];
          SQL_DOUBLE : Result := PDouble(sqldata)^;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : Result := PDouble(sqldata)^;
          SQL_TIMESTAMP : Result := DecodeTimeStamp(PISCTimeStamp(sqldata));
          SQL_TYPE_DATE : Result := DecodeSQLDate(PInteger(sqldata)^);
          SQL_TYPE_TIME : Result := PCardinal(sqldata)^ / 864000000;
          SQL_LONG      : Result := PInteger(sqldata)^;
          SQL_D_FLOAT,
          SQL_FLOAT     : Result := PSingle(sqldata)^;
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : Result := PSmallint(sqldata)^;
          SQL_INT64     : Result := PInt64(sqldata)^;
          SQL_TEXT      : Result := StrToFloat(DecodeString(SQL_TEXT, Index));
          SQL_VARYING   : Result := StrToFloat(DecodeString(SQL_VARYING, Index));
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
    end;
end;

function TSQLDA.GetByNameAsCurrency(const Name: String): Currency;
begin
  Result := GetAsCurrency(GetFieldIndex(Name));
end;

function TSQLDA.GetAsBoolean(const Index: Word): boolean;
  var ASQLCode: SmallInt;
  begin
    CheckRange(Index);
    with FXSQLDA.sqlvar[Index] do
    begin
      Result := False;
      if (sqlind <> nil) and (sqlind^ = -1) then Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : Result := PSmallInt(sqldata)^ div ScaleDivisor[sqlscale] <> 0;
          SQL_LONG   : Result := PInteger(sqldata)^  div ScaleDivisor[sqlscale] <> 0;
          SQL_INT64,
          SQL_QUAD   : Result := PInt64(sqldata)^    div ScaleDivisor[sqlscale] <> 0;
          SQL_DOUBLE : Result := Trunc(PDouble(sqldata)^) > 0;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : Result := Trunc(PDouble(sqldata)^) <> 0;
          SQL_LONG      : Result := PInteger(sqldata)^ <> 0;
          SQL_D_FLOAT,
          SQL_FLOAT     : Result := Trunc(PSingle(sqldata)^) <> 0;
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : Result := PSmallint(sqldata)^ <> 0;
          SQL_INT64     : Result := PInt64(sqldata)^ <> 0;
          SQL_TEXT      : Result := StrToInt(DecodeString(SQL_TEXT, Index)) <> 0;
          SQL_VARYING   : Result := StrToInt(DecodeString(SQL_VARYING, Index)) <> 0;
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
    end;
  end;

function TSQLDA.GetByNameAsBoolean(const Name: String): boolean;
begin
  Result := GetAsBoolean(GetFieldIndex(Name));
end;

function TSQLDA.GetByNameIsNumeric(const Name: String): boolean;
begin
  result := GetIsNumeric(GetFieldIndex(Name));
end;

function TSQLDA.GetIsNumeric(const Index: Word): boolean;
begin
  CheckRange(Index);
  result := (FXSQLDA.sqlvar[Index].SqlScale < 0);
end;

function TSQLDA.GetAsWideString(const Index: Word): WideString;
    function BoolToStr(const Value: boolean): string;
    begin if Value then result := sUIBTrue else result := sUIBFalse; end;
  var ASQLCode: SmallInt;
  begin
    CheckRange(Index);
    Result := '';
    with FXSQLDA.sqlvar[Index] do
    begin
      if (sqlind <> nil) and (sqlind^ = -1) then Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : Result := FloatToStr(PSmallInt(sqldata)^ / ScaleDivisor[sqlscale]);
          SQL_LONG   : Result := FloatToStr(PInteger(sqldata)^  / ScaleDivisor[sqlscale]);
          SQL_INT64,
          SQL_QUAD   : Result := FloatToStr(PInt64(sqldata)^    / ScaleDivisor[sqlscale]);
          SQL_DOUBLE : Result := FloatToStr(PDouble(sqldata)^);
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : Result := FloatToStr(PDouble(sqldata)^);
          SQL_TIMESTAMP : Result := DateTimeToStr(DecodeTimeStamp(PISCTimeStamp(sqldata)));
          SQL_TYPE_DATE : Result := DateToStr(DecodeSQLDate(PInteger(sqldata)^));
          SQL_TYPE_TIME : Result := TimeToStr(PCardinal(sqldata)^ / 864000000);
          SQL_LONG      : Result := IntToStr(PInteger(sqldata)^);
          SQL_D_FLOAT,
          SQL_FLOAT     : Result := FloatToStr(PSingle(sqldata)^);
{$IFDEF IB7_UP}
          SQL_BOOLEAN   : Result := BoolToStr(PSmallint(sqldata)^ = 1);
{$ENDIF}
          SQL_SHORT     : Result := IntToStr(PSmallint(sqldata)^);
          SQL_INT64     : Result := IntToStr(PInt64(sqldata)^);
          SQL_TEXT      : DecodeWideString(SQL_TEXT, Index, Result);
          SQL_VARYING   : DecodeWideString(SQL_VARYING, Index, Result);
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
    end;
  end;

function TSQLDA.GetByNameAsWideString(const Name: String): WideString;
begin
  Result := GetAsWideString(GetFieldIndex(Name));
end;

function TSQLDA.GetFieldType(const Index: Word): TUIBFieldType;
begin
  CheckRange(Index);
  if FXSQLDA.sqlvar[Index].SqlScale < 0 then
    Result := uftNumeric else
  case FXSQLDA.sqlvar[Index].sqltype and not (1) of
    SQL_TEXT        : Result := uftChar;
    SQL_VARYING     : Result := uftVarchar;
    SQL_SHORT       : Result := uftSmallint;
    SQL_LONG        : Result := uftInteger;
    SQL_FLOAT,
    SQL_D_FLOAT     : Result := uftFloat;
    SQL_DOUBLE      : Result := uftDoublePrecision;
    SQL_TIMESTAMP   : Result := uftTimestamp;
    SQL_BLOB        : Result := uftBlob;
    SQL_ARRAY,
    SQL_QUAD        : Result := uftQuad;
    SQL_TYPE_TIME   : Result := uftTime;
    SQL_TYPE_DATE   : Result := uftDate;
    SQL_INT64       : Result := uftInt64;
  {$IFDEF IB7_UP}
    SQL_BOOLEAN     : Result := uftBoolean;
  {$ENDIF}
  else
    Result := uftUnKnown;
  end;
end;

{ TMemoryPool }

constructor TMemoryPool.Create(ItemSize, ItemsInPage: Integer);
const
  PageSizeAdjustment = SizeOf(TPageInfo);
  MaxPageSize = (64 * 1024) + (PageSizeAdjustment * 2);
var
  RealItemSize, TestSize: Integer;
const
  MinItemSize = SizeOf(Word) + SizeOf(Pointer);
  function Max(a, b : Integer) : Integer;
{$IFDEF FPC}
  begin if a > b then Result := a else Result := b; end;
{$ELSE}
  asm
    cmp eax, edx
    jge @@Exit
    mov eax, edx
  @@Exit:
  end;
{$ENDIF}
begin
  FList := TList.Create;
  FItemSize := Max(ItemSize, MinItemSize);
  FItemsInPage := ItemsInPage;
  RealItemSize := FItemSize + sizeof(Word);
  TestSize := (RealItemSize * FItemsInPage) + PageSizeAdjustment;
  if (TestSize > MaxPageSize) then
  begin
    FItemsInPage := (MaxPageSize - PageSizeAdjustment) div RealItemSize;
    TestSize := (RealItemSize * FItemsInPage) + PageSizeAdjustment;
  end;
  FPageSize := TestSize;
end;

function TSQLParams.GetFieldName(const Index: Word): string;
begin
  CheckRange(Index);
  SetString(Result, FXSQLDA.sqlvar[Index].ParamName,
    FXSQLDA.sqlvar[Index].ParamNameLength);
end;

procedure TSQLParams.AddFieldType(const Name: string; FieldType: TUIBFieldType;
  Scale: TScale = 1; Precision: byte = 0);
begin
  case FieldType of
    uftNumeric   :
      begin
        case Precision of
          0..4: SetFieldType(AddField(name), SizeOf(Smallint), SQL_SHORT + 1, -scale);
          5..7: SetFieldType(AddField(name), SizeOf(Integer) , SQL_LONG + 1 , -scale);
        else
          SetFieldType(AddField(name), SizeOf(Int64), SQL_INT64 + 1, -scale);
        end;
      end;
    uftChar,
    uftVarchar,
    uftCstring         : SetFieldType(AddField(name), 0                    , SQL_TEXT      + 1, 0);
    uftSmallint        : SetFieldType(AddField(name), SizeOf(Smallint)     , SQL_SHORT     + 1, 0);
    uftInteger         : SetFieldType(AddField(name), SizeOf(Integer)      , SQL_LONG      + 1, 0);
    uftQuad            : SetFieldType(AddField(name), SizeOf(TISCQuad)     , SQL_QUAD      + 1, 0);
    uftFloat           : SetFieldType(AddField(name), SizeOf(Single)       , SQL_FLOAT     + 1, 0);
    uftDoublePrecision : SetFieldType(AddField(name), SizeOf(Double)       , SQL_DOUBLE    + 1, 0);
    uftTimestamp       : SetFieldType(AddField(name), SizeOf(TISCTimeStamp), SQL_TIMESTAMP + 1, 0);
    uftBlob,
    uftBlobId          : SetFieldType(AddField(name), SizeOf(TISCQuad)     , SQL_BLOB      + 1, 0);
    uftDate            : SetFieldType(AddField(name), SizeOf(Integer)      , SQL_TYPE_DATE + 1, 0);
    uftTime            : SetFieldType(AddField(name), SizeOf(Cardinal)     , SQL_TYPE_TIME + 1, 0);
    uftInt64           : SetFieldType(AddField(name), SizeOf(Int64)        , SQL_INT64     + 1, 0);
{$IFDEF IB7_UP}
    uftBoolean         : SetFieldType(AddField(name), SizeOf(Smallint)     , SQL_BOOLEAN   + 1, 0);
{$ENDIF}
  end;
end;

procedure TSQLParams.SetFieldType(const Index: Word; Size: Integer; Code,
  Scale: Smallint);
var i: Word;
begin
  CheckRange(Index);
  with FXSQLDA.sqlvar[Index] do
    if Init then  // need to be set, cf addfield
    begin
      Init := False; // don't need to be set
      sqltype := Code;
      sqlscale := Scale;
      sqllen := Size;
      if (Size > 0) then
        GetMem(sqldata, Size) else
        sqldata := nil;
      if ParamNameLength > 0 then
        for i := 0 to GetAllocatedFields - 1 do
          if (i <> Index) and (ID = FXSQLDA.sqlvar[i].ID) then
            move(FXSQLDA.sqlvar[Index], FXSQLDA.sqlvar[i], SizeOf(TUIBSQLVar)-MaxParamLength-2);
    end;
end;

function TSQLParams.Parse(const SQL: string): string;
const
  Identifiers: set of char = ['a'..'z', 'A'..'Z', '0'..'9', '_'];
var
  Src: PChar;
  Dest, idlen: Word;

  procedure next;
  begin
    inc(dest);
    Result[dest] := Src^;
    inc(Src);
  end;

  procedure Skip(c: char);
  begin
    repeat
      next;
      if Src^ = c then
      begin
        Next;
        Break;
      end;
    until (Src^ = #0);
  end;

  {$IFDEF FPC}
  function PrevChar(c: pchar): char;
  begin
    dec(c);
    result := c^;
  end;
  {$ENDIF}
begin
  Clear;
  Src := PChar(SQL);
  Dest := 0;
  SetLength(Result, Length(SQL));
  while true do
    case Src^ of
      // eof
      #0 :  begin
              SetLength(Result, Dest);
              Exit;
            end;
      // normal comments
      '/' : if Src[1] = '*' then
            begin
              inc(Src, 2);
              while (Src^ <> #0) do
                if (Src^ = '*') and (Src[1] = '/') then
                begin
                  inc(Src, 2);
                  Break;
                end else
                  inc(Src);
            end else
              next;
      // Firebird comments -- My comment + (eol or eof)
      {.$IFDEF FB15_UP}
      '-' : if Src[1] = '-' then
            begin
              inc(Src, 2);
              while not(Src^ in [#0, #13, #10]) do
                inc(Src);
            end else
              next;
      {.$ENDIF}
      // text ''
      '''': Skip('''');
      // text ""
      '"' : Skip('"');
      // Unnamed Input
      '?' : begin
              AddField('');
              Next;
            end;
      // Named Input
      ':' : begin
              inc(dest);
              Result[dest] := '?';
              inc(Src);
              idlen := 0;
              while Src[idlen] in Identifiers do
                inc(idlen);
              AddField(copy(Src, 0, idlen));
              inc(Src, idlen);
            end;
      // skip everything when begin identifier found !
      // in procedures
      'b','B':
        begin
          if not ((dest > 0) and ({$IFDEF FPC}PrevChar(src){$ELSE}src[-1]{$ENDIF}
            in Identifiers)) and (CompareText(copy(Src, 0, 5), 'begin') = 0) and
             not (Src[5] in Identifiers) then
               while (Src^ <> #0) do Next else next;
        end;
    else
      next;
    end;
end;

function TSQLParams.GetFieldType(const Index: Word): TUIBFieldType;
begin
  if IsNull[Index] and FXSQLDA.sqlvar[Index].Init then
    Result := uftUnKnown else
    Result := inherited GetFieldType(Index);
end;

function TSQLParams.GetFieldIndex(const name: String): Word;
begin
  if not FindParam(name, Result) then
    raise EUIBError.CreateFmt(EUIB_PARAMSTRNOTFOUND, [name]);
end;

procedure TSQLParams.SetByNameAsBoolean(const Name: String;
  const Value: boolean);
var
  Field: Word;
begin
  if (Length(Name) > 0) and FindParam(Name, Field) then
    SetAsBoolean(Field, Value) else
    raise EUIBError.CreateFmt(EUIB_PARAMSTRNOTFOUND, [name]);
end;

procedure TSQLParams.SetByNameAsCurrency(const Name: String;
  const Value: Currency);
var
  Field: Word;
begin
  if (Length(Name) > 0) and FindParam(Name, Field) then
    SetAsCurrency(Field, Value) else
    raise EUIBError.CreateFmt(EUIB_PARAMSTRNOTFOUND, [name]);
end;

procedure TSQLParams.SetByNameAsDateTime(const Name: String;
  const Value: TDateTime);
var
  Field: Word;
begin
  if (Length(Name) > 0) and FindParam(Name, Field) then
    SetAsDateTime(Field, Value) else
    raise EUIBError.CreateFmt(EUIB_PARAMSTRNOTFOUND, [name]);
end;

procedure TSQLParams.SetByNameAsDouble(const Name: String;
  const Value: Double);
var
  Field: Word;
begin
  if (Length(Name) > 0) and FindParam(Name, Field) then
    SetAsDouble(Field, Value) else
    raise EUIBError.CreateFmt(EUIB_PARAMSTRNOTFOUND, [name]);
end;

procedure TSQLParams.SetByNameAsInt64(const Name: String;
  const Value: Int64);
var
  Field: Word;
begin
  if (Length(Name) > 0) and FindParam(Name, Field) then
    SetAsInt64(Field, Value) else
    raise EUIBError.CreateFmt(EUIB_PARAMSTRNOTFOUND, [name]);
end;

procedure TSQLParams.SetByNameAsInteger(const Name: String;
  const Value: Integer);
var
  Field: Word;
begin
  if (Length(Name) > 0) and FindParam(Name, Field) then
    SetAsInteger(Field, Value) else
    raise EUIBError.CreateFmt(EUIB_PARAMSTRNOTFOUND, [name]);
end;

procedure TSQLParams.SetByNameAsQuad(const Name: String;
  const Value: TISCQuad);
var
  Field: Word;
begin
  if (Length(Name) > 0) and FindParam(Name, Field) then
    SetAsQuad(Field, Value) else
    raise EUIBError.CreateFmt(EUIB_PARAMSTRNOTFOUND, [name]);
end;

procedure TSQLParams.SetByNameAsSingle(const Name: String;
  const Value: Single);
var
  Field: Word;
begin
  if (Length(Name) > 0) and FindParam(Name, Field) then
    SetAsSingle(Field, Value) else
    raise EUIBError.CreateFmt(EUIB_PARAMSTRNOTFOUND, [name]);
end;

procedure TSQLParams.SetByNameAsSmallint(const Name: String;
  const Value: Smallint);
var
  Field: Word;
begin
  if (Length(Name) > 0) and FindParam(Name, Field) then
    SetAsSmallint(Field, Value) else
    raise EUIBError.CreateFmt(EUIB_PARAMSTRNOTFOUND, [name]);
end;

procedure TSQLParams.SetByNameAsString(const Name, Value: String);
var
  Field: Word;
begin
  if (Length(Name) > 0) and FindParam(Name, Field) then
    SetAsString(Field, Value) else
    raise EUIBError.CreateFmt(EUIB_PARAMSTRNOTFOUND, [name]);
end;

procedure TSQLParams.SetByNameAsWideString(const Name: String; const Value: WideString);
var
  Field: Word;
begin
  if (Length(Name) > 0) and FindParam(Name, Field) then
    SetAsWideString(Field, Value) else
    raise EUIBError.CreateFmt(EUIB_PARAMSTRNOTFOUND, [name]);
end;

procedure TSQLParams.SetByNameIsNull(const Name: String;
  const Value: boolean);
var
  Field: Word;
begin
  if (Length(Name) > 0) and FindParam(Name, Field) then
    SetIsNull(Field, Value) else
    raise EUIBError.CreateFmt(EUIB_PARAMSTRNOTFOUND, [name]);
end;

destructor TMemoryPool.Destroy;
var
  Temp, Next : PPageInfo;
begin
  Temp := FFirstPage;
  while Assigned(Temp) do
  begin
    Next := Temp^.NextPage;
    FreeMem(Temp, FPageSize);
    Temp := Next;
  end;
  FList.Free;
end;

procedure TMemoryPool.AddPage;
var
  Page : PPageInfo;
  Temp : PAnsiChar;
  Prev : Pointer;
  i    : Integer;
begin
  GetMem(Page, FPageSize);
  Page^.NextPage := FFirstPage;
  Page^.UsageCounter := 0;
  FFirstPage := Page;
  Temp := PAnsiChar(Page);
  inc(Temp, sizeof(Pointer) + sizeOf(Integer));
  Prev := nil;
  for i := 0 to pred(FItemsInPage) do
  begin
    PWord(Temp)^ := Temp - PAnsiChar(Page);
    inc(Temp, sizeOf(Word));
    PPointer(Temp)^ := Prev;
    Prev := Temp;
    inc(Temp, FItemSize);
  end;
  FFreeList := Prev;
end;

function TMemoryPool.New: Pointer;
var
  Page : PPageInfo;
  Temp : PAnsiChar;
begin
  if not Assigned(FFreeList) then
    AddPage;
  Result := FFreeList;
  FFreeList := PPointer(Result)^;
  Temp := Result;
  dec(Temp, sizeOf(Word));
  dec(Temp, PWord(Temp)^);
  Page := PPageInfo(Temp);
  inc(Page^.UsageCounter);
  FList.Add(Result);
end;

function TMemoryPool.PageCount : Integer;
var
  Temp : PPageInfo;
begin
  Result := 0;
  Temp := FFirstPage;
  while Assigned(Temp) do
  begin
    inc(Result);
    Temp := Temp^.NextPage;
  end;
end;

function TMemoryPool.PageUsageCount(const PageIndex: Integer): Integer;
var
  Index : Integer;
  Temp : PPageInfo;
begin
  Result := -1;
  Index := 0;
  Temp := FFirstPage;
  while Assigned(Temp) and (Index <= PageIndex) do
  begin
    if Index = PageIndex then
    begin
      Result := Temp^.UsageCounter;
      break;
    end else
    begin
      inc(Index);
      Temp := Temp^.NextPage;
    end;
  end;
end;

procedure TMemoryPool.Dispose(var P);
var
  Page : PPageInfo;
  Pt : Pointer absolute P;
  Temp : PAnsiChar;
begin
  PPointer(Pt)^ := FFreeList;
  FFreeList := Pt;
  Temp := FFreeList;
  dec(Temp, sizeOf(Word));
  dec(Temp, PWord(Temp)^);
  Page := PPageInfo(Temp);
  dec(Page^.UsageCounter);
  Pt := nil;
end;

procedure TMemoryPool.CleanFreeList(const PageStart: Pointer);
var
  PageEnd    : Pointer;
  ItemsFound : Integer;
  Prev       : Pointer;
  Temp       : Pointer;
begin
  PageEnd := PAnsiChar(PageStart) + FPageSize;
  ItemsFound := 0;
  Prev := nil;
  Temp := FFreeList;
  while assigned(Temp) and (ItemsFound < FItemsInPage) do
  begin
    if (PAnsiChar(Temp) > PageStart) and (PAnsiChar(Temp) <= PageEnd) then
    begin
      inc(ItemsFound);
      if Temp = FFreeList then
        FFreeList := PPointer(Temp)^
      else
        PPointer(Prev)^ := PPointer(Temp)^;
      Temp := PPointer(Temp)^;
    end else
    begin
      Prev := Temp;
      Temp := PPointer(Temp)^;
    end;
  end;
end;

function TMemoryPool.RemoveUnusedPages: Integer;
var
  Next, Prev, Temp: PPageInfo;
begin
  Result := 0;
  Prev := nil;
  Temp := FFirstPage;
  while assigned(Temp) do
  begin
    Next := Temp^.NextPage;
    if Temp^.UsageCounter = 0 then
    begin
      if Temp = FFirstPage then
        FFirstPage := Next else
        if assigned(Prev) then
          Prev^.NextPage := Next;
      CleanFreeList(Temp);
      Freemem(Temp, FPageSize);
      inc(Result);
    end
    else
      Prev := Temp;
    Temp := Next;
  end;
end;

function TMemoryPool.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TMemoryPool.GetItems(const Index: Integer): Pointer;
begin
  Result := FList.Items[Index];
end;

{ TSQLParams }

  procedure TSQLParams.EncodeString(Code: Smallint; Index: Word; const str: String);
  var
    i: smallint;
    OldLen: SmallInt;
    NewLen: Integer;
  begin
    OldLen  := FXSQLDA.sqlvar[Index].SqlLen;
    with FXSQLDA.sqlvar[Index] do
      case Code of
        SQL_TEXT :
          begin
            NewLen := Length(str);
            if NewLen = 0 then
              Inc(NewLen); // empty string not null
            if sqllen = 0 then
              getmem(sqldata, NewLen) else
              ReallocMem(sqldata, NewLen);
            sqllen := NewLen;
            Move(PChar(str)^, sqldata^, sqllen);
          end;
        SQL_VARYING :
          begin
            NewLen := Length(str);
            if NewLen = 0 then
              Inc(NewLen); // empty string not null
            if sqllen = 0 then
              getmem(sqldata, NewLen+2) else
              ReallocMem(sqldata, NewLen+2);
            sqllen := NewLen + 2;
            PVary(sqldata).vary_length := NewLen;
            Move(PChar(str)^, PVary(sqldata).vary_string, PVary(sqldata).vary_length);
          end;
      end;

      // named parametters share the same memory !!
      with FXSQLDA.sqlvar[Index] do
        if (ParamNameLength > 0) and (OldLen <> SqlLen) then
           for i := 0 to FXSQLDA.sqln - 1 do
             if (FXSQLDA.sqlvar[i].ID = ID) then
             begin
               FXSQLDA.sqlvar[i].SqlData := SqlData;
               FXSQLDA.sqlvar[i].SqlLen  := SqlLen;
             end;
  end;

  procedure TSQLParams.EncodeWideString(Code: Smallint; Index: Word; const str: WideString);
  var
    i: smallint;
    OldLen: SmallInt;
    NewLen: Integer;
  begin
    OldLen  := FXSQLDA.sqlvar[Index].SqlLen;
    with FXSQLDA.sqlvar[Index] do
      case Code of
        SQL_TEXT :
          begin
            NewLen := Length(str) * 2;
            if sqllen = 0 then
              getmem(sqldata, NewLen) else
              ReallocMem(sqldata, NewLen);
            sqllen := NewLen;
            Move(PWideChar(str)^, sqldata^, sqllen);
          end;
        SQL_VARYING :
          begin
            NewLen := Length(str) * 2;
            if sqllen = 0 then
              getmem(sqldata, NewLen+2) else
              ReallocMem(sqldata, NewLen+2);
            sqllen := NewLen + 2;
            PVary(sqldata).vary_length := NewLen;
            Move(PWideChar(str)^, PVary(sqldata).vary_string, PVary(sqldata).vary_length);
          end;
      end;

      // named parametters share the same memory !!
      with FXSQLDA.sqlvar[Index] do
        if (ParamNameLength > 0) and (OldLen <> SqlLen) then
           for i := 0 to FXSQLDA.sqln - 1 do
             if (FXSQLDA.sqlvar[i].ID = ID) then
             begin
               FXSQLDA.sqlvar[i].SqlData := SqlData;
               FXSQLDA.sqlvar[i].SqlLen  := SqlLen;
             end;
  end;

  procedure TSQLParams.SetAsQuad(const Index: Word; const Value: TISCQuad);
  begin
    SetFieldType(Index, sizeof(TISCQuad), SQL_QUAD + 1);
    with FXSQLDA.sqlvar[Index] do
      begin
        case (sqltype and not(1)) of
          SQL_QUAD, SQL_DOUBLE, SQL_INT64, SQL_BLOB, SQL_ARRAY: PISCQuad(sqldata)^ := Value;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
        if (sqlind <> nil) then
          if CompareMem(@Value, @QuadNull, SizeOf(TIscQuad)) then
            sqlind^ := -1 else
            sqlind^ := 0;
      end;
  end;

  procedure TSQLParams.SetAsDateTime(const Index: Word;
    const Value: TDateTime);
  begin
    SetFieldType(Index, sizeof(TISCQuad), SQL_TIMESTAMP + 1);
    SetAsDouble(Index, Value);
  end;

  procedure TSQLParams.SetAsBoolean(const Index: Word; const Value: Boolean);
  var ASQLCode: SmallInt;
  begin
{$IFDEF IB7_UP}
    SetFieldType(Index, sizeof(Smallint), SQL_BOOLEAN + 1);
{$ELSE}
    SetFieldType(Index, sizeof(Smallint), SQL_SHORT + 1);
{$ENDIF}
    with FXSQLDA.sqlvar[Index] do
    begin
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : PSmallInt(sqldata)^ := ord(Value) * ScaleDivisor[sqlscale];
          SQL_LONG   : PInteger(sqldata)^  := ord(Value) * ScaleDivisor[sqlscale];
          SQL_INT64,
          SQL_QUAD   : PInt64(sqldata)^    := ord(Value) * ScaleDivisor[sqlscale];
          SQL_DOUBLE : PDouble(sqldata)^   := ord(Value);
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : PDouble(sqldata)^   := ord(Value);
          SQL_LONG      : PInteger(sqldata)^ := ord(Value);
          SQL_D_FLOAT,
          SQL_FLOAT     : PSingle(sqldata)^ := ord(Value);
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : PSmallint(sqldata)^ := ord(Value);
          SQL_INT64     : PInt64(sqldata)^ := ord(Value);
          SQL_TEXT      : EncodeString(SQL_TEXT, Index, IntToStr(ord(Value)));
          SQL_VARYING   : EncodeString(SQL_VARYING, Index, IntToStr(ord(Value)));
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
        if (sqlind <> nil) then sqlind^ := 0; // not null
    end;
  end;

  procedure TSQLParams.SetAsInteger(const Index: Word; const Value: Integer);
  var ASQLCode: SmallInt;
  begin
    SetFieldType(Index, sizeof(Integer), SQL_LONG + 1);
    with FXSQLDA.sqlvar[Index] do
    begin
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : PSmallInt(sqldata)^ := Value * ScaleDivisor[sqlscale];
          SQL_LONG   : PInteger(sqldata)^  := Value * ScaleDivisor[sqlscale];
          SQL_INT64,
          SQL_QUAD   : PInt64(sqldata)^    := Value * ScaleDivisor[sqlscale];
          SQL_DOUBLE : PDouble(sqldata)^   := Value;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : PDouble(sqldata)^   := Value;
          SQL_TIMESTAMP : EncodeTimeStamp(Value, PISCTimeStamp(sqldata));
          SQL_TYPE_DATE : EncodeSQLDate(Value, PInteger(sqldata)^);
          SQL_TYPE_TIME : PCardinal(sqldata)^ := 0;
          SQL_LONG      : PInteger(sqldata)^ := Value;
          SQL_D_FLOAT,
          SQL_FLOAT     : PSingle(sqldata)^ := Value;
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : PSmallint(sqldata)^ := Value;
          SQL_INT64     : PInt64(sqldata)^ := Value;
          SQL_TEXT      : EncodeString(SQL_TEXT, Index, IntToStr(Value));
          SQL_VARYING   : EncodeString(SQL_VARYING, Index, IntToStr(Value));
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
        if (sqlind <> nil) then sqlind^ := 0; // not null
    end;
  end;

  procedure TSQLParams.SetAsSingle(const Index: Word; const Value: Single);
  var ASQLCode: SmallInt;
  begin
    SetFieldType(Index, sizeof(Single), SQL_FLOAT + 1);
    with FXSQLDA.sqlvar[Index] do
    begin
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : PSmallInt(sqldata)^ := Trunc(Value * ScaleDivisor[sqlscale]);
          SQL_LONG   : PInteger(sqldata)^  := Trunc(Value * ScaleDivisor[sqlscale]);
          SQL_INT64,
          SQL_QUAD   : PInt64(sqldata)^    := Trunc(Value * ScaleDivisor[sqlscale]);
          SQL_DOUBLE : PDouble(sqldata)^   := Value;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : PDouble(sqldata)^   := Value;
          SQL_TIMESTAMP : EncodeTimeStamp(Value, PISCTimeStamp(sqldata));
          SQL_TYPE_DATE : EncodeSQLDate(Value, PInteger(sqldata)^);
          SQL_TYPE_TIME : PCardinal(sqldata)^ := Round(Frac(Value) * 864000000);
          SQL_LONG      : PInteger(sqldata)^ := Trunc(Value);
          SQL_D_FLOAT,
          SQL_FLOAT     : PSingle(sqldata)^ := Value;
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : PSmallint(sqldata)^ := Trunc(Value);
          SQL_INT64     : PInt64(sqldata)^ := Trunc(Value);
          SQL_TEXT      : EncodeString(SQL_TEXT, Index, FloatToStr(Value));
          SQL_VARYING   : EncodeString(SQL_VARYING, Index, FloatToStr(Value));
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
        if (sqlind <> nil) then sqlind^ := 0; // not null
    end;
  end;

  procedure TSQLParams.SetAsSmallint(const Index: Word; const Value: Smallint);
  var ASQLCode: SmallInt;
  begin
    SetFieldType(Index, sizeof(Smallint), SQL_SHORT + 1);
    with FXSQLDA.sqlvar[Index] do
    begin
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : PSmallInt(sqldata)^ := Value * ScaleDivisor[sqlscale];
          SQL_LONG   : PInteger(sqldata)^  := Value * ScaleDivisor[sqlscale];
          SQL_INT64,
          SQL_QUAD   : PInt64(sqldata)^    := Value * ScaleDivisor[sqlscale];
          SQL_DOUBLE : PDouble(sqldata)^   := Value;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : PDouble(sqldata)^   := Value;
          SQL_TIMESTAMP : EncodeTimeStamp(Value, PISCTimeStamp(sqldata));
          SQL_TYPE_DATE : EncodeSQLDate(Value, PInteger(sqldata)^);
          SQL_TYPE_TIME : PCardinal(sqldata)^ := 0;
          SQL_LONG      : PInteger(sqldata)^ := Value;
          SQL_D_FLOAT,
          SQL_FLOAT     : PSingle(sqldata)^ := Value;
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : PSmallint(sqldata)^ := Value;
          SQL_INT64     : PInt64(sqldata)^ := Value;
          SQL_TEXT      : EncodeString(SQL_TEXT, Index, IntToStr(Value));
          SQL_VARYING   : EncodeString(SQL_VARYING, Index, IntToStr(Value));
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
        if (sqlind <> nil) then sqlind^ := 0; // not null
    end;
  end;

  procedure TSQLParams.SetAsString(const Index: Word; const Value: String);
  var
    ASQLCode: SmallInt;
  begin
    SetFieldType(Index, Length(Value), SQL_TEXT + 1);
    with FXSQLDA.sqlvar[Index] do
    begin
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : PSmallInt(sqldata)^ := Trunc(StrToFloat(Value) * ScaleDivisor[sqlscale]);
          SQL_LONG   : PInteger(sqldata)^  := Trunc(StrToFloat(Value) * ScaleDivisor[sqlscale]);
          SQL_INT64,
          SQL_QUAD   : PInt64(sqldata)^    := Trunc(StrToFloat(Value) * ScaleDivisor[sqlscale]);
          SQL_DOUBLE : PDouble(sqldata)^   := StrToFloat(Value);
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : PDouble(sqldata)^   := StrToFloat(Value);
          SQL_TIMESTAMP : EncodeTimeStamp(StrToDateTime(Value), PISCTimeStamp(sqldata));
          SQL_TYPE_DATE : EncodeSQLDate(StrToDate(Value), PInteger(sqldata)^);
          SQL_TYPE_TIME : PCardinal(sqldata)^ := Round(Frac(StrToTime(Value)) * 864000000);
          SQL_LONG      : PInteger(sqldata)^ := Trunc(StrToFloat(Value));
          SQL_D_FLOAT,
          SQL_FLOAT     : PSingle(sqldata)^ := StrToFloat(Value);
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : PSmallint(sqldata)^ := Trunc(StrToFloat(Value));
          SQL_INT64     : PInt64(sqldata)^ := Trunc(StrToFloat(Value));
          SQL_TEXT      : EncodeString(SQL_TEXT, Index, Value);
          SQL_VARYING   : EncodeString(SQL_VARYING, Index, Value);
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
        if (sqlind <> nil) then
          sqlind^ := 0;
    end;
  end;

  procedure TSQLParams.SetAsWideString(const Index: Word;
    const Value: WideString);
  var
    ASQLCode: SmallInt;
  begin
    SetFieldType(Index, Length(Value), SQL_TEXT + 1);
    with FXSQLDA.sqlvar[Index] do
    begin
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : PSmallInt(sqldata)^ := Trunc(StrToFloat(Value) * ScaleDivisor[sqlscale]);
          SQL_LONG   : PInteger(sqldata)^  := Trunc(StrToFloat(Value) * ScaleDivisor[sqlscale]);
          SQL_INT64,
          SQL_QUAD   : PInt64(sqldata)^    := Trunc(StrToFloat(Value) * ScaleDivisor[sqlscale]);
          SQL_DOUBLE : PDouble(sqldata)^   := StrToFloat(Value);
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : PDouble(sqldata)^   := StrToFloat(Value);
          SQL_TIMESTAMP : EncodeTimeStamp(StrToDateTime(Value), PISCTimeStamp(sqldata));
          SQL_TYPE_DATE : EncodeSQLDate(StrToDate(Value), PInteger(sqldata)^);
          SQL_TYPE_TIME : PCardinal(sqldata)^ := Round(Frac(StrToTime(Value)) * 864000000);
          SQL_LONG      : PInteger(sqldata)^ := Trunc(StrToFloat(Value));
          SQL_D_FLOAT,
          SQL_FLOAT     : PSingle(sqldata)^ := StrToFloat(Value);
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : PSmallint(sqldata)^ := Trunc(StrToFloat(Value));
          SQL_INT64     : PInt64(sqldata)^ := Trunc(StrToFloat(Value));
          SQL_TEXT      : EncodeWideString(SQL_TEXT, Index, Value);
          SQL_VARYING   : EncodeWideString(SQL_VARYING, Index, Value);
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
        if (sqlind <> nil) then
          sqlind^ := 0;
    end;
  end;

  procedure TSQLParams.SetAsInt64(const Index: Word; const Value: Int64);
  var ASQLCode: SmallInt;
  begin
    SetFieldType(Index, sizeof(Int64), SQL_INT64 + 1);
    with FXSQLDA.sqlvar[Index] do
    begin
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : PSmallInt(sqldata)^ := Value * ScaleDivisor[sqlscale];
          SQL_LONG   : PInteger(sqldata)^  := Value * ScaleDivisor[sqlscale];
          SQL_INT64,
          SQL_QUAD   : PInt64(sqldata)^    := Value * ScaleDivisor[sqlscale];
          SQL_DOUBLE : PDouble(sqldata)^   := Value;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : PDouble(sqldata)^   := Value;
          SQL_TIMESTAMP : EncodeTimeStamp(Value, PISCTimeStamp(sqldata));
          SQL_TYPE_DATE : EncodeSQLDate(Value, PInteger(sqldata)^);
          SQL_TYPE_TIME : PCardinal(sqldata)^ := 0;
          SQL_LONG      : PInteger(sqldata)^ := Value;
          SQL_D_FLOAT,
          SQL_FLOAT     : PSingle(sqldata)^ := Value;
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : PSmallint(sqldata)^ := Value;
          SQL_INT64     : PInt64(sqldata)^ := Value;
          SQL_TEXT      : EncodeString(SQL_TEXT, Index, IntToStr(Value));
          SQL_VARYING   : EncodeString(SQL_VARYING, Index, IntToStr(Value));
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
        if (sqlind <> nil) then sqlind^ := 0; // not null
    end;
  end;

  procedure TSQLParams.SetAsDouble(const Index: Word; const Value: Double);
  var ASQLCode: SmallInt;
  begin
    SetFieldType(Index, sizeof(double), SQL_DOUBLE + 1);
    with FXSQLDA.sqlvar[Index] do
    begin
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : PSmallInt(sqldata)^ := Trunc(Value * ScaleDivisor[sqlscale]);
          SQL_LONG   : PInteger(sqldata)^  := Trunc(Value * ScaleDivisor[sqlscale]);
          SQL_INT64,
          SQL_QUAD   : PInt64(sqldata)^    := Trunc(Value * ScaleDivisor[sqlscale]);
          SQL_DOUBLE : PDouble(sqldata)^   := Value;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : PDouble(sqldata)^   := Value;
          SQL_TIMESTAMP : EncodeTimeStamp(Value, PISCTimeStamp(sqldata));
          SQL_TYPE_DATE : EncodeSQLDate(Value, PInteger(sqldata)^);
          SQL_TYPE_TIME : PCardinal(sqldata)^ := Round(Frac(Value) * 864000000);
          SQL_LONG      : PInteger(sqldata)^ := Trunc(Value);
          SQL_D_FLOAT,
          SQL_FLOAT     : PSingle(sqldata)^ := Value;
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : PSmallint(sqldata)^ := Trunc(Value);
          SQL_INT64     : PInt64(sqldata)^ := Trunc(Value);
          SQL_TEXT      : EncodeString(SQL_TEXT, Index, FloatToStr(Value));
          SQL_VARYING   : EncodeString(SQL_VARYING, Index, FloatToStr(Value));
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
        if (sqlind <> nil) then sqlind^ := 0; // not null
    end;
  end;

  procedure TSQLParams.SetAsCurrency(const Index: Word;
    const Value: Currency);
  var ASQLCode: SmallInt;
  begin
    SetFieldType(Index, sizeof(Int64), SQL_INT64 + 1, -4);
    with FXSQLDA.sqlvar[Index] do
    begin
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0)  then
      begin
        case ASQLCode of
          SQL_SHORT  : PSmallInt(sqldata)^ := Trunc(Value * ScaleDivisor[sqlscale]);
          SQL_LONG   : PInteger(sqldata)^  := Trunc(Value * ScaleDivisor[sqlscale]);
          SQL_INT64,
          SQL_QUAD   : PInt64(sqldata)^    := Trunc(Value * ScaleDivisor[sqlscale]);
          SQL_DOUBLE : PDouble(sqldata)^   := Value;
        else
          raise EUIBConvertError.Create(EUIB_UNEXPECTEDERROR + ': ' + EUIB_CASTERROR);
        end;
      end else
        case ASQLCode of
          SQL_DOUBLE    : PDouble(sqldata)^   := Value;
          SQL_TIMESTAMP : EncodeTimeStamp(Value, PISCTimeStamp(sqldata));
          SQL_TYPE_DATE : EncodeSQLDate(Value, PInteger(sqldata)^);
          SQL_TYPE_TIME : PCardinal(sqldata)^ := Round(Frac(Value) * 864000000);
          SQL_LONG      : PInteger(sqldata)^ := Trunc(Value);
          SQL_D_FLOAT,
          SQL_FLOAT     : PSingle(sqldata)^ := Value;
{$IFDEF IB7_UP}
          SQL_BOOLEAN,
{$ENDIF}
          SQL_SHORT     : PSmallint(sqldata)^ := Trunc(Value);
          SQL_INT64     : PInt64(sqldata)^ := Trunc(Value);
          SQL_TEXT      : EncodeString(SQL_TEXT, Index, FloatToStr(Value));
          SQL_VARYING   : EncodeString(SQL_VARYING, Index, FloatToStr(Value));
        else
          raise EUIBConvertError.Create(EUIB_CASTERROR);
        end;
        if (sqlind <> nil) then sqlind^ := 0; // not null
    end;
  end;


  procedure TSQLParams.SetIsNull(const Index: Word; const Value: boolean);
  begin
    CheckRange(Index);
    with FXSQLDA.sqlvar[Index] do
      if (sqlind <> nil) then
        case Value of
          True  : sqlind^ := -1;
          False : sqlind^ :=  0;
        end;
  end;

  function TSQLParams.FindParam(const name: string; out Index: Word): boolean;
  var Field: Smallint;
  begin
    for Field := 0 to FXSQLDA.sqln - 1 do
      if FXSQLDA.sqlvar[Field].ParamNameLength = Length(name) then
        if StrLIComp(@FXSQLDA.sqlvar[Field].ParamName, PChar(Name),
          FXSQLDA.sqlvar[Field].ParamNameLength) = 0 then
          begin
            Result := true;
            Index  := Field;
            Exit;
          end;
    Result := False;
  end;

  function TSQLParams.AddField(const Name: string): Word;
  var
    num: Word;
    len: Cardinal;
  begin
    len := Length(Name);
    if len > MaxParamLength then
      raise EUIBError.CreateFmt(EUIB_SIZENAME, [Name]);

    Result := FXSQLDA.sqln;
    if (len > 0) and FindParam(Name, num) then
    begin
      inc(FXSQLDA.sqln);
      inc(FXSQLDA.sqld);
      ReallocMem(FXSQLDA, XSQLDA_LENGTH(FXSQLDA.sqln));
      move(FXSQLDA.sqlvar[num], FXSQLDA.sqlvar[Result], SizeOf(TUIBSQLVar));
    end else
    begin
      inc(FXSQLDA.sqln);
      inc(FXSQLDA.sqld);
      ReallocMem(FXSQLDA, XSQLDA_LENGTH(FXSQLDA.sqln));
      inc(FParamCount);
      with FXSQLDA.sqlvar[Result] do
      begin
        Init := True;
        ID := FParamCount;
        ParamNameLength := len;
        if ParamNameLength > 0 then
          move(Pointer(Name)^, ParamName[0], ParamNameLength);
        sqltype    := SQL_TEXT + 1; // tip: don't allocate memory if not defined
        sqlscale   := 0;
        sqlsubtype := 0;
        sqllen     := 0;
        sqldata    := nil;
        GetMem(sqlind, 2); // Can be NULL
        sqlind^ := -1; // NULL
      end;
    end;
  end;

  constructor TSQLParams.Create;
  begin
    GetMem(FXSQLDA, XSQLDA_LENGTH(0));
    FillChar(FXSQLDA^, XSQLDA_LENGTH(0), 0);
    FXSQLDA.sqln := 0;
    FXSQLDA.sqld := 0;
    FXSQLDA.version := SQLDA_CURRENT_VERSION;
    FParamCount := 0;
  end;

  destructor TSQLParams.Destroy;
  begin
    Clear;
    FreeMem(FXSQLDA);
    inherited;
  end;

  procedure TSQLParams.Clear;
  var i, j: Smallint;
  begin
    for i := 0 to FXSQLDA.sqln - 1 do
    begin
      if (FXSQLDA.sqlvar[i].sqlind <> nil) then
      begin
        freemem(FXSQLDA.sqlvar[i].sqldata);
        freemem(FXSQLDA.sqlvar[i].sqlind);
        // don't free shared pointers
        for j := i + 1 to FXSQLDA.sqln - 1 do
          if (FXSQLDA.sqlvar[i].ID = FXSQLDA.sqlvar[j].ID) then
            begin
              FXSQLDA.sqlvar[j].sqldata := nil;
              FXSQLDA.sqlvar[j].sqlind  := nil;
            end;
      end;
    end;
    FXSQLDA.sqln := 0;
    FXSQLDA.sqld := 0;
    ReallocMem(FXSQLDA, XSQLDA_LENGTH(0));
    FParamCount := 0;
  end;

end.


