unit glXMLSerializer;
{
  
  								  
 		 Globus Delphi VCL Extensions Library		   
 			  ' GLOBUS LIB '			   
  			     Freeware				  
  	  Copyright (c) 2001 Chudin A.V, chudin@yandex.ru	  
  								  
  
 ===================================================================
 glXMLSerializer Unit 08.2001	      component TglXMLSerializer 1.2
 ===================================================================

  ��������� ������������ ��������� � XML � ������� � ������������
  � published-����������� ������ ����������.

  XML ����������� � ���� ��� ����� � ���������� � ��� ����������.
  �������� � ����� �����������.

  ��� �������� ������ ������������� ������ �������.
  ��������� ���� ������������� ������ �������.
  ��� ��������� ��������� ������������ ��� ������������� ����� ������.

  ����������� ����� �� ���������� � ��������� ���������
  published ��������� ������ ��������� �������.

  �������������� ����� ����, ���� � ��������� ������, ������������,
  ������, ������, �������. ���������� ����,
  ��������� ����, �������� ������ � ���������.

  ���������:
    procedure Serialize(Component: TObject; Stream: TStream);
     - ������������ ������� � XML
    procedure DeSerialize(Component: TObject; Stream: TStream);
     - �������� XML � ������

    property GenerateFormattedXML       - ��������� ��������������� XML ���
    property ExcludeEmptyValues         - ���������� ������ �������� �������
    property ExcludeDefaultValues       - ���������� �������� �� ���������
    property StrongConformity           - ���������� ������� � XML �����. ����� ��� ���� ��������� �����
    property IgnoreUnknownTags          - ������������ ����������� ���� ��� ��������
    property OnGetXMLHeader             - ��������� ������� ���� XML ���������

    WrapCollections - ����������� ��������� � ��������� ����

  �����������:
    � � ������ ������� ��������� ������������ ������ ���� ��������� ������� ����.

    ���������� ������ TStrings �� ����� ����� published �������.

    ����������� ���� �� ��������������.

    ��� ��������� DTD � ������� ��� �������� ��������� �����, ����������� ��
    ���������� �������������� ��������, ������ ���� ������ ������.

  �����������:
    ������ ��� (��)������������ ������ ���� ������ �� ������ ���������.

    ��� StrongConformity == true ���������� ����������� � ����������� XML �����
    ��� ���� ��������� �����. ����������� ��������� ����� �� �����������.

  �������������:
    ��� �������� �� XML ���������� ��������� � ������� �� ���������,
    ��� ��������� ����������� ������ �� ��������� ���������� � ���� ������.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, comctrls, TypInfo;

type
  TOnGetXMLHeader = procedure (Sender: TObject; var Value: string) of object;
  TBeforeParsingEvent = procedure (Sender: TObject; Buffer: PChar) of object;

  XMLSerializerException = class(Exception)
  end;

  TglXMLSerializer = class(TComponent)
  private
    Buffer: PChar;
    BufferLength: DWORD;
    TokenPtr{, MaxTokenPtr}: PChar;
    OutStream: TStream;

    FOnGetXMLHeader: TOnGetXMLHeader;
    FGenerateFormattedXML: boolean;
    FExcludeEmptyValues: boolean;
    FExcludeDefaultValues: boolean;
    FReplaceReservedSymbols: boolean;
    FStrongConformity: boolean;
    FBeforeParsing: TBeforeParsingEvent;
    FWrapCollections: boolean;
    FIgnoreUnknownTags: boolean;
    procedure check(Expr: boolean; const Message: string);
    procedure WriteOutStream(Value: string);
    { Private declarations }
  protected
    procedure SerializeInternal(Component: TObject; Level: integer = 1);
    procedure DeSerializeInternal(Component: TObject; {const} ComponentTagName: string; ParentBlockEnd: PChar = nil);
    procedure GenerateDTDInternal(Component: TObject; DTDList: TStrings; Stream: TStream; const ComponentTagName: string);
    procedure SetPropertyValue(Component: TObject; PropInfo: PPropInfo; Value, ValueEnd: PChar; ParentBlockEnd: PChar);
  public
    DefaultXMLHeader: string;
    tickCounter, tickCount: DWORD;
    constructor Create(AOwner: TComponent); override;
    { ������������ ������� � XML }
    procedure Serialize(Component: TObject; Stream: TStream);
    { �������� XML � ������ }
    procedure DeSerialize(Component: TObject; Stream: TStream);
    { ��������� DTD }
    procedure GenerateDTD(Component: TObject; Stream: TStream);
  published
    property GenerateFormattedXML: boolean
     read FGenerateFormattedXML write FGenerateFormattedXML default true;
    property ExcludeEmptyValues: boolean
     read FExcludeEmptyValues write FExcludeEmptyValues;
    property ExcludeDefaultValues: boolean
     read FExcludeDefaultValues write FExcludeDefaultValues;
    property ReplaceReservedSymbols: boolean
     read FReplaceReservedSymbols write FReplaceReservedSymbols;
    property StrongConformity: boolean
     read FStrongConformity write FStrongConformity default true;
    property IgnoreUnknownTags: boolean
     read FIgnoreUnknownTags write FIgnoreUnknownTags;

    property WrapCollections: boolean
     read FWrapCollections write FWrapCollections default true;


    property OnGetXMLHeader: TOnGetXMLHeader
     read FOnGetXMLHeader write FOnGetXMLHeader;
    property BeforeParsing: TBeforeParsingEvent
     read FBeforeParsing write FBeforeParsing;
  end;

procedure Register;

implementation
uses glUtils {$IFDEF GLVER_D6}, DesignIntf{$ELSE} {$IFDEF GLVER_D5}, dsgnintf{$ENDIF} {$ENDIF};

const
  ORDINAL_TYPES = [tkInteger, tkChar, tkEnumeration, tkSet];
var
  TAB: string;
  CR: string;

procedure Register;
begin
//  RegisterComponents('Gl Components', [TglXMLSerializer]);
end;


constructor TglXMLSerializer.Create(AOwner: TComponent);
begin
  inherited;
  //...defaults
  FGenerateFormattedXML := true;
  FStrongConformity := true;
  FWrapCollections := true;
end;

{ ����� ������ � ��������� �����. ���-�� ��� ������������ }
procedure TglXMLSerializer.WriteOutStream(Value: string);
begin
  OutStream.Write(Pchar(Value)[0], Length(Value));
end;

{
  ������������ ��������� � XML-��� � ������������
  � published ����������� ������ �������.
  ����:
    Component - ��������� ��� �����������
  �����:
    ����� XML � ����� Stream
}
procedure TglXMLSerializer.Serialize(Component: TObject; Stream: TStream);
var
  Result: string;
begin
  TAB := IIF(GenerateFormattedXML, #9, '');
  CR := IIF(GenerateFormattedXML, #13#10, '');

  Result := '';
  { ��������� XML ��������� }
  if Assigned(OnGetXMLHeader) then OnGetXMLHeader(self, Result);
  if Result = '' then Result := DefaultXMLHeader;

  OutStream := Stream;

  WriteOutStream( PChar(Result) );

  WriteOutStream( PChar(CR + '<' + Component.ClassName + '>') );
  SerializeInternal(Component);
  WriteOutStream( PChar(CR + '</' + Component.ClassName + '>') );
end;

{
  ���������� ��������� ����������� ������� � XML
  ���������� ��:
    Serialize()
  ����:
    Component - ��������� ��� �����������
    Level - ������� ����������� ���� ��� �������������� ����������
  �����:
    ������ XML � �������� ����� ����� ����� WriteOutStream()
}
procedure TglXMLSerializer.SerializeInternal(Component: TObject; Level: integer = 1);
var
  PropInfo: PPropInfo;
  TypeInf, PropTypeInf: PTypeInfo;
  TypeData: PTypeData;
  i, j: integer;
  AName, PropName, sPropValue: string;
  PropList: PPropList;
  NumProps: word;
  PropObject: TObject;

  { ��������� ����������� ��� � �������� ������ }
  procedure addOpenTag(const Value: string);
  begin
    WriteOutStream(CR + DupStr(TAB, Level) + '<' + Value + '>');
    inc(Level);
  end;

  { ��������� ����������� ��� � �������� ������ }
  procedure addCloseTag(const Value: string; addBreak: boolean = false);
  begin
    dec(Level);
    if addBreak then
      WriteOutStream(CR + DupStr(TAB, Level));
    WriteOutStream('</' + Value + '>');
  end;

  { ��������� �������� � �������������� ������ }
  procedure addValue(const Value: string);
  begin
    WriteOutStream(Value);
  end;
begin
//  Result := '';

  { Playing with RTTI }
  TypeInf := Component.ClassInfo;
  AName := TypeInf^.Name;
  TypeData := GetTypeData(TypeInf);
  NumProps := TypeData^.PropCount;


  GetMem(PropList, NumProps*sizeof(pointer));
  try

    { �������� ������ ������� }
    GetPropInfos(TypeInf, PropList);

    for i := 0 to NumProps-1 do
    begin
      PropName := PropList^[i]^.Name;

      PropTypeInf := PropList^[i]^.PropType^;
      PropInfo := PropList^[i];

      { ����� �� ��������, ����� ��� ��������� ? }
      if not IsStoredProp(Component, PropInfo) then continue;

      case PropTypeInf^.Kind of
        tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkSet,
        tkWChar, tkLString, tkWString, tkVariant:
        begin
          { ��������� �������� �������� }
          sPropValue := GetPropValue(Component, PropName, true);

          { ��������� �� ������ �������� � �������� �� ��������� }
          if ExcludeEmptyValues and (sPropValue = '') then continue;
          if ExcludeDefaultValues and (PropTypeInf^.Kind in ORDINAL_TYPES)
           and (sPropValue = IntToStr(PropInfo.Default)) then continue;

          { ������ ������������ }
          if FReplaceReservedSymbols then
          begin
            sPropValue := StringReplace(sPropValue, '<', '&lt;', [rfReplaceAll]);
            sPropValue := StringReplace(sPropValue, '>', '&gt;', [rfReplaceAll]);
            // sPropValue := StringReplace(sPropValue, '&', '&', [rfReplaceAll]);
          end;

          { ������� � XML }
          addOpenTag(PropName);
          addValue(sPropValue); { ��������� �������� �������� � ��������� }
          addCloseTag(PropName);
        end;
        tkClass: { ��� ��������� ����� ����������� ��������� }
        begin


          PropObject := GetObjectProp(Component, PropInfo);
          if Assigned(PropObject)then
          begin
            { ��� �������� �������-������� - ����������� ����� }

            { �������������� ������ � ��������� ������� }
            if (PropObject is TStrings) then { ��������� ������ }
            begin
              addOpenTag(PropName);
              WriteOutStream(TStrings(PropObject).CommaText);
              addCloseTag(PropName, true);
            end else
            if (PropObject is TCollection) then { ��������� }
            begin
              if WrapCollections then addOpenTag(PropName);

              SerializeInternal(PropObject, Level);
              for j := 0 to (PropObject as TCollection).Count-1 do
              begin { ������������ ��� �� ����� ������ }
                addOpenTag(TCollection(PropObject).Items[j].ClassName);
                SerializeInternal(TCollection(PropObject).Items[j], Level);
                addCloseTag(TCollection(PropObject).Items[j].ClassName, true);
              end;

              if WrapCollections then addCloseTag(PropName, true);
            end else
            if (PropObject is TPersistent) then
            begin
               addOpenTag(PropName);
               SerializeInternal(PropObject, Level);
               addCloseTag(PropName, true);
            end;

            { ����� ����� �������� ��������� ��������� �������: TTreeNodes, TListItems }
          end;
          { ����� ��������� ������� ��������� ��� ������� }

        end;

      end;
    end;
  finally
    FreeMem(PropList, NumProps*sizeof(pointer));
  end;

end;


{
  ��������� � ��������� ������ �� ������ � XML-�����.
  ����:
    Component - ��������� ��� �����������
    Stream - �������� �������� XML
  �����������:
    ������ Component ������ ���� ������ �� ������ ���������
}
procedure TglXMLSerializer.DeSerialize(Component: TObject; Stream: TStream);
begin
  GetMem(Buffer, Stream.Size);
  try
    { �������� ������ �� ������ }
    Stream.Read(Buffer[0], Stream.Size + 1);

    if Assigned(BeforeParsing) then BeforeParsing(self, Buffer);

    { ������������� ������� ��������� ������ ������ }
    TokenPtr := Buffer;
    BufferLength := Stream.Size-1;
    { �������� ��������� }
    DeSerializeInternal(Component, Component.ClassName);
  finally
    FreeMem(Buffer);
  end;
end;


{
  ����������� ��������� �������� ������� �� ���������� ������ � XML
  ���������� ��:
    Serialize()
  ����:
    Component - ��������� ��� �����������
    ComponentTagName - ��� XML ���� �������
    ParentBlockEnd - ��������� �� ����� XML �������� ������������� ����
}
procedure TglXMLSerializer.DeSerializeInternal(Component: TObject; {const} ComponentTagName: string; ParentBlockEnd: PChar = nil);
var
  BlockStart, BlockEnd, TagStart, TagEnd: PChar;
  TagName, TagValue, TagValueEnd: PChar;
  TypeInf: PTypeInfo;
  TypeData: PTypeData;
  PropIndex: integer;
  AName: string;
  PropList: PPropList;
  NumProps: word;

  { ����� � ������� �������� � �������� ������ }
  function FindProperty(TagName: PChar): integer;
  var i: integer;
  begin
    Result := -1;
    for i := 0 to NumProps-1 do
    if CompareStr(PropList^[i]^.Name, TagName) = 0 then
    begin
      Result := i;
      break;
    end;
  end;

  procedure SkipSpaces(var TagEnd: PChar);
  begin
    while TagEnd[0] <= #33 do inc(TagEnd);
  end;

{
  StrPosExt - ���� ������� ����� ������ � ������ � �������� ������.
  �� ������� ������� ����������� StrPos.
}
function StrPosExt(const Str1, Str2: PChar; Str2Len: DWORD): PChar; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        OR      EAX,EAX         // Str1
        JE      @@2             // ���� ������ Str1 ����� - �� �����
        OR      EDX,EDX         // Str2
        JE      @@2             // ���� ������ Str2 ����� - �� �����
        MOV     EBX,EAX
        MOV     EDI,EDX         // ��������� �������� ��� SCASB - ��������� Str2
        XOR     AL,AL           // ������� AL

        push ECX                // ����� ������

        MOV     ECX,0FFFFFFFFH  // ������� � �������
        REPNE   SCASB           // ���� ����� ��������� Str2
        NOT     ECX             // ����������� ECX - �������� ����� ������+1
        DEC     ECX             // � ECX - ����� ������� ��������� Str2

        JE      @@2             // ��� ������� ����� - ��� �� �����
        MOV     ESI,ECX         // ��������� ����� ��������� � ESI

        pop ECX

        SUB     ECX,ESI         // ECX == ������� ���� ����� : Str1 - Str2
        JBE     @@2             // ���� ����� �������� ������ ����� ������ - �����
        MOV     EDI,EBX         // EDI  - ������ ������ Str1
        LEA     EBX,[ESI-1]     // EBX - ����� ��������� �����
@@1:    MOV     ESI,EDX         // ESI - �������� ������ Str2
        LODSB                   // �������� ������ ������ ��������� � AL
        REPNE   SCASB           // ���� ���� ������ � ������ EDI
        JNE     @@2             // ���� ������ �� ��������� - �� �����
        MOV     EAX,ECX         // �������� ������� ���� �����
        PUSH    EDI             // �������� ������� �������� ������
        MOV     ECX,EBX
        REPE    CMPSB           // �������� ���������� ������
        POP     EDI
        MOV     ECX,EAX
        JNE     @@1             // ���� ������ �������� - ���� ��������� ���������� ������� �������
        LEA     EAX,[EDI-1]
        JMP     @@3
@@2:    XOR     EAX,EAX
@@3:    POP     EBX
        POP     ESI
        POP     EDI
end;

begin
  { Playing with RTTI }
  TypeInf := Component.ClassInfo;
  AName := TypeInf^.Name;
  TypeData := GetTypeData(TypeInf);
  NumProps := TypeData^.PropCount;

  GetMem(PropList, NumProps*sizeof(pointer));

  if not WrapCollections and (Component is TCollection) then
    ComponentTagName := TCollection(Component).ItemClass.ClassName;

  try
    GetPropInfos(TypeInf, PropList);

  { ���� ����������� ��� }
  BlockStart := StrPosExt(TokenPtr, PChar('<' + ComponentTagName + '>'), BufferLength);

  { ���� ��� �� ������ � ��� ������� �������������, �� �� ������������ ��� }
  if (BlockStart = nil)and not StrongConformity then exit;

  { ����� ��������� ��� ����������� }
  check(BlockStart <> nil, '����������� ��� �� ������: ' + '<' + ComponentTagName + '>');
  inc(BlockStart, length(ComponentTagName) + 2);

  { ���� ����������� ��� }
  BlockEnd := StrPosExt(BlockStart, PChar('</' + ComponentTagName + '>'), BufferLength);
  check(BlockEnd <> nil, '����������� ��� �� ������: ' + '<' + ComponentTagName + '>');

  { �������� �� ��������� ����. ���� � ������������ ��� }
  check((ParentBlockEnd = nil)or(BlockEnd < ParentBlockEnd), '����������� ��� �� ������: ' + '<' + ComponentTagName + '>');

  TagEnd := BlockStart;
  SkipSpaces(TagEnd);

  { XML ������ }
  while (TagEnd < BlockEnd){ and (TagEnd >= TokenPtr)} do
  begin
    { ������� ����� ������� ������ }
    asm
      mov CL, '<'
      mov EDX, Pointer(TagEnd)
      dec EDX
@@1:  inc EDX
      mov AL, byte[EDX]
      cmp AL, CL
      jne @@1
      mov TagStart, EDX

      mov CL, '>'
@@2:  inc EDX
      mov AL, byte[EDX]
      cmp AL, CL
      jne @@2
      mov TagEnd, EDX
    end;

    GetMem(TagName, TagEnd - TagStart + 1);
    try

      { TagName - ��� ���� }
      StrLCopy(TagName, TagStart + 1, TagEnd - TagStart - 1);

      { TagEnd - ����������� ��� }
      TagEnd := StrPosExt(TagEnd, PChar('</' + TagName + '>'), BufferLength);

      //inc(TagStart, length('</' + TagName + '>')-1);

      { ������ ���������� ��������� ���� }
      TagValue := TagStart + length('</' + TagName + '>') - 1;
      TagValueEnd := TagEnd;


      { ����� ��������, ���������������� ���� }
      PropIndex := FindProperty(TagName);

      if not WrapCollections and (PropIndex = -1) then
      begin
        PropIndex := FindProperty(Pchar(TagName+'s'));

      end else
        TokenPtr := TagStart;

      if not IgnoreUnknownTags then
        check(PropIndex <> -1, 'TglXMLSerializer.DeSerializeInternal: Uncknown property: ' + TagName);

      if PropIndex <> -1 then
        SetPropertyValue(Component, PropList^[PropIndex], TagValue, TagValueEnd, BlockEnd);

      inc(TagEnd, length('</' + TagName + '>'));
      SkipSpaces(TagEnd);

    finally
      FreeMem(TagName);
    end;

  end;


  finally
    FreeMem(PropList, NumProps*sizeof(pointer));
  end;

end;


{
  ��������� ������������� �������� �������
  ���������� ��:
    DeSerializeInternal()
  ����:
    Component - ���������������� ������
    PropInfo - ���������� � ���� ��� ���������������� ��������
    Value - �������� ��������
    ParentBlockEnd - ��������� �� ����� XML �������� ������������� ����
                     ������������ ��� ��������
}
procedure TglXMLSerializer.SetPropertyValue(Component: TObject; PropInfo: PPropInfo; Value, ValueEnd: PChar; ParentBlockEnd: PChar);
var
  PropTypeInf: PTypeInfo;
  PropObject: TObject;
  CollectionItem: TCollectionItem;
  sValue: string;
  charTmp: char;
begin
    PropTypeInf := PropInfo.PropType^;

    case PropTypeInf^.Kind of
      tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkSet,
      tkWChar, tkLString, tkWString, tkVariant:
      begin
        { ��������� zero terminated string }
        charTmp := ValueEnd[0];
        ValueEnd[0] := #0;
        sValue := StrPas(Value);
        ValueEnd[0] := charTmp;

        { ������ ������������. ��������� ������ ��� XML,
         ������������ � ������� ����� ���������� }
         if FReplaceReservedSymbols then
         begin
           sValue := StringReplace(sValue, '&lt;', '<', [rfReplaceAll]);
           sValue := StringReplace(sValue, '&gt;', '>', [rfReplaceAll]);
           // sValue := StringReplace(sValue, '&', '&', [rfReplaceAll]);
         end;

         { ������ ����������� �� ��������� }
         if PropTypeInf^.Kind = tkFloat then
         begin
           if DecimalSeparator = ',' then
             sValue := StringReplace(sValue, '.', DecimalSeparator, [rfReplaceAll])
           else
             sValue := StringReplace(sValue, ',', DecimalSeparator, [rfReplaceAll]);
         end;

        { ��� ����������� �������������� �������� tkSet ����� ������� ������ }
        if PropTypeInf^.Kind = tkSet then sValue := '[' + sValue + ']';
        SetPropValue(Component, PropInfo^.Name, sValue);
      end;
      tkClass:
      begin
        PropObject := GetObjectProp(Component, PropInfo);
        if Assigned(PropObject)then
        begin
          { �������������� ������ � ��������� ������� }
          if (PropObject is TStrings) then { ��������� ������ }
          begin
            charTmp := ValueEnd[0];
            ValueEnd[0] := #0;
            sValue := StrPas(Value);
            ValueEnd[0] := charTmp;
            TStrings(PropObject).CommaText := sValue;
          end
          else
          if (PropObject is TCollection) then { ��������� }
          begin
            while true do { ������� �� �������� ����� ��������� � ��������� }
            begin
              CollectionItem := (PropObject as TCollection).Add;
              try
                DeSerializeInternal(CollectionItem, CollectionItem.ClassName, ParentBlockEnd);
              except { ����������, ���� ��������� ������� �� ������ }
                on E: Exception do
                begin
                  // Application.MessageBox(PChar(E.Message), '', MB_OK); - debug string
                  CollectionItem.Free;
                  // raise;  - debug string
                  break;
                end;
              end;
            end;
          end
          else { ��� ��������� ������� - ����������� ��������� }
            DeSerializeInternal(PropObject, PropInfo^.Name, ParentBlockEnd);
        end;

      end;
    end;
end;


{
  ��������� ��������� DTD ��� ��������� ������� �
  ������������ � published ����������� ��� ������.
  ����:
    Component - ������
  �����:
    ����� DTD � ����� Stream
}
procedure TglXMLSerializer.GenerateDTD(Component: TObject; Stream: TStream);
var
  DTDList: TStringList;
begin
  DTDList := TStringList.Create;
  try
    GenerateDTDInternal(Component, DTDList, Stream, Component.ClassName);
  finally
    DTDList.Free;
  end;
end;


{
  ���������� ����������� ��������� ��������� DTD ��� ��������� �������.
  ����:
    Component - ������
    DTDList - ������ ��� ������������ ��������� DTD
              ��� �������������� ����������.
  �����:
    ����� DTD � ����� Stream
}
procedure TglXMLSerializer.GenerateDTDInternal(Component: TObject; DTDList: TStrings; Stream: TStream; const ComponentTagName: string);
var
  PropInfo: PPropInfo;
  TypeInf, PropTypeInf: PTypeInfo;
  TypeData: PTypeData;
  i: integer;
  AName, PropName, TagContent: string;
  PropList: PPropList;
  NumProps: word;
  PropObject: TObject;
const
  PCDATA = '#PCDATA';
  procedure addElement(const ElementName: string; Data: string);
  var s: string;
  begin
    if DTDList.IndexOf(ElementName) <> -1 then exit;
    DTDList.Add(ElementName);
    s := '<!ELEMENT ' + ElementName + ' ';
    if Data = '' then Data := PCDATA;
    s := s + '(' + Data + ')>'#13#10;
    Stream.Write(PChar(s)[0], length(s));
  end;
begin
  { Playing with RTTI }
  TypeInf := Component.ClassInfo;
  AName := TypeInf^.Name;
  TypeData := GetTypeData(TypeInf);
  NumProps := TypeData^.PropCount;


  GetMem(PropList, NumProps*sizeof(pointer));
  try
    { �������� ������ ������� }
    GetPropInfos(TypeInf, PropList);
    TagContent := '';

    for i := 0 to NumProps-1 do
    begin
      PropName := PropList^[i]^.Name;

      PropTypeInf := PropList^[i]^.PropType^;
      PropInfo := PropList^[i];

      { ���������� �� �������������� ���� }
      if not (PropTypeInf^.Kind in [tkDynArray, tkArray, tkRecord, tkInterface, tkMethod]) then
      begin
        if TagContent <> '' then TagContent := TagContent + '|';
        TagContent := TagContent + PropName;
      end;


      case PropTypeInf^.Kind of
        tkInteger, tkChar, tkFloat, tkString,
        tkWChar, tkLString, tkWString, tkVariant, tkEnumeration, tkSet:
        begin
          { ������� � DTD. ��� ������ ����� ������ ���������� - #PCDATA }
          addElement(PropName, PCDATA);
        end;
        { ��� ��� �� ������� ��� ������������� ���������
        tkEnumeration:
        begin
          TypeData:= GetTypeData(GetTypeData(PropTypeInf)^.BaseType^);
          s := '';
          for j := TypeData^.MinValue to TypeData^.MaxValue do
          begin
            if s <> '' then s := s + '|';
            s := s + GetEnumName(PropTypeInf, j);
          end;
          addElement(PropName, s);
        end;
        }
        tkClass: { ��� ��������� ����� ����������� ��������� }
        begin
          PropObject := GetObjectProp(Component, PropInfo);
          if Assigned(PropObject)then
          begin
            { ��� �������� �������-������� - ����������� ����� }
            if (PropObject is TPersistent) then
              GenerateDTDInternal(PropObject, DTDList, Stream, PropName);
          end;
        end;

      end;
    end;

    { �������������� ������ � ��������� ������� }
    { ��� ��������� ���������� �������� � ������ ���������� ��� �������� }
    if (Component is TCollection) then
    begin
      if TagContent <> '' then TagContent := TagContent + '|';
      TagContent := TagContent + (Component as TCollection).ItemClass.ClassName + '*';
    end;

    { ��������� ������ ���������� ��� �������� }
    addElement(ComponentTagName, TagContent);
  finally
    FreeMem(PropList, NumProps*sizeof(pointer));
  end;

end;

procedure TglXMLSerializer.check(Expr: boolean; const Message: string);
begin
  if not Expr then raise XMLSerializerException.Create('XMLSerializerException'#13#10#13#10 + Message);
end;

end.

//(PShortString(@(GetTypeData(GetTypeData(PropTypeInf)^.BaseType^).NameList)))

//tickCount := GetTickCount();
//inc(tickCounter, GetTickCount() - tickCount);


