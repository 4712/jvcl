{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvgXMLSerializer.PAS, released on 2003-01-15.

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

UNIT JvgXMLSerializer;
{
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

INTERFACE

USES
   Windows,
   Messages,
   SysUtils,
   Classes,
   Graphics,
   Controls,
   Forms,
   Dialogs,
   comctrls,
   JVComponent,
   TypInfo;

TYPE
   TOnGetXMLHeader = PROCEDURE(Sender: TObject; VAR Value: STRING) OF OBJECT;
   TBeforeParsingEvent = PROCEDURE(Sender: TObject; Buffer: PChar) OF OBJECT;

   EJvgXMLSerializerException = CLASS(Exception)
   END;

   TJvgXMLSerializer = CLASS(TJvComponent)
   PRIVATE
      Buffer: PChar;
      BufferLength: DWORD;
      TokenPtr {, MaxTokenPtr}: PChar;
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
      PROCEDURE check(Expr: boolean; CONST Message: STRING);
      PROCEDURE WriteOutStream(Value: STRING);
      { Private declarations }
   PROTECTED
      PROCEDURE SerializeInternal(Component: TObject; Level: integer = 1);
      PROCEDURE DeSerializeInternal(Component: TObject; {const}
         ComponentTagName: STRING; ParentBlockEnd: PChar = NIL);
      PROCEDURE GenerateDTDInternal(Component: TObject; DTDList: TStrings;
         Stream: TStream; CONST ComponentTagName: STRING);
      PROCEDURE SetPropertyValue(Component: TObject; PropInfo: PPropInfo; Value,
         ValueEnd: PChar; ParentBlockEnd: PChar);
   PUBLIC
      DefaultXMLHeader: STRING;
      tickCounter, tickCount: DWORD;
      CONSTRUCTOR Create(AOwner: TComponent); OVERRIDE;
      { ������������ ������� � XML }
      PROCEDURE Serialize(Component: TObject; Stream: TStream);
      { �������� XML � ������ }
      PROCEDURE DeSerialize(Component: TObject; Stream: TStream);
      { ��������� DTD }
      PROCEDURE GenerateDTD(Component: TObject; Stream: TStream);
   PUBLISHED
      PROPERTY GenerateFormattedXML: boolean
         READ FGenerateFormattedXML WRITE FGenerateFormattedXML DEFAULT true;
      PROPERTY ExcludeEmptyValues: boolean
         READ FExcludeEmptyValues WRITE FExcludeEmptyValues;
      PROPERTY ExcludeDefaultValues: boolean
         READ FExcludeDefaultValues WRITE FExcludeDefaultValues;
      PROPERTY ReplaceReservedSymbols: boolean
         READ FReplaceReservedSymbols WRITE FReplaceReservedSymbols;
      PROPERTY StrongConformity: boolean
         READ FStrongConformity WRITE FStrongConformity DEFAULT true;
      PROPERTY IgnoreUnknownTags: boolean
         READ FIgnoreUnknownTags WRITE FIgnoreUnknownTags;

      PROPERTY WrapCollections: boolean
         READ FWrapCollections WRITE FWrapCollections DEFAULT true;

      PROPERTY OnGetXMLHeader: TOnGetXMLHeader
         READ FOnGetXMLHeader WRITE FOnGetXMLHeader;
      PROPERTY BeforeParsing: TBeforeParsingEvent
         READ FBeforeParsing WRITE FBeforeParsing;
   END;

PROCEDURE Register;

IMPLEMENTATION
USES JvgUtils{$IFDEF COMPILER6_UP},
   DesignIntf{$ELSE}{$IFDEF COMPILER5_UP},
   dsgnintf{$ENDIF}{$ENDIF};

CONST
   ORDINAL_TYPES              = [tkInteger, tkChar, tkEnumeration, tkSet];
VAR
   TAB                        : STRING;
   CR                         : STRING;

PROCEDURE Register;
BEGIN
END;

CONSTRUCTOR TJvgXMLSerializer.Create(AOwner: TComponent);
BEGIN
   INHERITED;
   //...defaults
   FGenerateFormattedXML := true;
   FStrongConformity := true;
   FWrapCollections := true;
END;

{ ����� ������ � ��������� �����. ���-�� ��� ������������ }

PROCEDURE TJvgXMLSerializer.WriteOutStream(Value: STRING);
BEGIN
   OutStream.Write(Pchar(Value)[0], Length(Value));
END;

{
  ������������ ��������� � XML-��� � ������������
  � published ����������� ������ �������.
  ����:
    Component - ��������� ��� �����������
  �����:
    ����� XML � ����� Stream
}

PROCEDURE TJvgXMLSerializer.Serialize(Component: TObject; Stream: TStream);
VAR
   Result                     : STRING;
BEGIN
   TAB := IIF(GenerateFormattedXML, #9, '');
   CR := IIF(GenerateFormattedXML, #13#10, '');

   Result := '';
   { ��������� XML ��������� }
   IF Assigned(OnGetXMLHeader) THEN
      OnGetXMLHeader(self, Result);
   IF Result = '' THEN
      Result := DefaultXMLHeader;

   OutStream := Stream;

   WriteOutStream(PChar(Result));

   WriteOutStream(PChar(CR + '<' + Component.ClassName + '>'));
   SerializeInternal(Component);
   WriteOutStream(PChar(CR + '</' + Component.ClassName + '>'));
END;

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

PROCEDURE TJvgXMLSerializer.SerializeInternal(Component: TObject; Level: integer
   = 1);
VAR
   PropInfo                   : PPropInfo;
   TypeInf, PropTypeInf       : PTypeInfo;
   TypeData                   : PTypeData;
   i, j                       : integer;
   AName, PropName, sPropValue: STRING;
   PropList                   : PPropList;
   NumProps                   : word;
   PropObject                 : TObject;

   { ��������� ����������� ��� � �������� ������ }

   PROCEDURE addOpenTag(CONST Value: STRING);
   BEGIN
      WriteOutStream(CR + DupStr(TAB, Level) + '<' + Value + '>');
      inc(Level);
   END;

   { ��������� ����������� ��� � �������� ������ }

   PROCEDURE addCloseTag(CONST Value: STRING; addBreak: boolean = false);
   BEGIN
      dec(Level);
      IF addBreak THEN
         WriteOutStream(CR + DupStr(TAB, Level));
      WriteOutStream('</' + Value + '>');
   END;

   { ��������� �������� � �������������� ������ }

   PROCEDURE addValue(CONST Value: STRING);
   BEGIN
      WriteOutStream(Value);
   END;
BEGIN
   //  Result := '';

     { Playing with RTTI }
   TypeInf := Component.ClassInfo;
   AName := TypeInf^.Name;
   TypeData := GetTypeData(TypeInf);
   NumProps := TypeData^.PropCount;

   GetMem(PropList, NumProps * sizeof(pointer));
   TRY

      { �������� ������ ������� }
      GetPropInfos(TypeInf, PropList);

      FOR i := 0 TO NumProps - 1 DO
      BEGIN
         PropName := PropList^[i]^.Name;

         PropTypeInf := PropList^[i]^.PropType^;
         PropInfo := PropList^[i];

         { ����� �� ��������, ����� ��� ��������� ? }
         IF NOT IsStoredProp(Component, PropInfo) THEN
            continue;

         CASE PropTypeInf^.Kind OF
            tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkSet,
               tkWChar, tkLString, tkWString, tkVariant:
               BEGIN
                  { ��������� �������� �������� }
                  sPropValue := GetPropValue(Component, PropName, true);

                  { ��������� �� ������ �������� � �������� �� ��������� }
                  IF ExcludeEmptyValues AND (sPropValue = '') THEN
                     continue;
                  IF ExcludeDefaultValues AND (PropTypeInf^.Kind IN
                     ORDINAL_TYPES)
                     AND (sPropValue = IntToStr(PropInfo.Default)) THEN
                     continue;

                  { ������ ������������ }
                  IF FReplaceReservedSymbols THEN
                  BEGIN
                     sPropValue := StringReplace(sPropValue, '<', '&lt;',
                        [rfReplaceAll]);
                     sPropValue := StringReplace(sPropValue, '>', '&gt;',
                        [rfReplaceAll]);
                     // sPropValue := StringReplace(sPropValue, '&', '&', [rfReplaceAll]);
                  END;

                  { ������� � XML }
                  addOpenTag(PropName);
                  addValue(sPropValue); { ��������� �������� �������� � ��������� }
                  addCloseTag(PropName);
               END;
            tkClass: { ��� ��������� ����� ����������� ��������� }
               BEGIN

                  PropObject := GetObjectProp(Component, PropInfo);
                  IF Assigned(PropObject) THEN
                  BEGIN
                     { ��� �������� �������-������� - ����������� ����� }

                     { �������������� ������ � ��������� ������� }
                     IF (PropObject IS TStrings) THEN { ��������� ������ }
                     BEGIN
                        addOpenTag(PropName);
                        WriteOutStream(TStrings(PropObject).CommaText);
                        addCloseTag(PropName, true);
                     END
                     ELSE IF (PropObject IS TCollection) THEN { ��������� }
                     BEGIN
                        IF WrapCollections THEN
                           addOpenTag(PropName);

                        SerializeInternal(PropObject, Level);
                        FOR j := 0 TO (PropObject AS TCollection).Count - 1 DO
                        BEGIN           { ������������ ��� �� ����� ������ }
                           addOpenTag(TCollection(PropObject).Items[j].ClassName);
                           SerializeInternal(TCollection(PropObject).Items[j],
                              Level);
                           addCloseTag(TCollection(PropObject).Items[j].ClassName, true);
                        END;

                        IF WrapCollections THEN
                           addCloseTag(PropName, true);
                     END
                     ELSE IF (PropObject IS TPersistent) THEN
                     BEGIN
                        addOpenTag(PropName);
                        SerializeInternal(PropObject, Level);
                        addCloseTag(PropName, true);
                     END;

                     { ����� ����� �������� ��������� ��������� �������: TTreeNodes, TListItems }
                  END;
                  { ����� ��������� ������� ��������� ��� ������� }

               END;

         END;
      END;
   FINALLY
      FreeMem(PropList, NumProps * sizeof(pointer));
   END;

END;

{
  ��������� � ��������� ������ �� ������ � XML-�����.
  ����:
    Component - ��������� ��� �����������
    Stream - �������� �������� XML
  �����������:
    ������ Component ������ ���� ������ �� ������ ���������
}

PROCEDURE TJvgXMLSerializer.DeSerialize(Component: TObject; Stream: TStream);
BEGIN
   GetMem(Buffer, Stream.Size);
   TRY
      { �������� ������ �� ������ }
      Stream.Read(Buffer[0], Stream.Size + 1);

      IF Assigned(BeforeParsing) THEN
         BeforeParsing(self, Buffer);

      { ������������� ������� ��������� ������ ������ }
      TokenPtr := Buffer;
      BufferLength := Stream.Size - 1;
      { �������� ��������� }
      DeSerializeInternal(Component, Component.ClassName);
   FINALLY
      FreeMem(Buffer);
   END;
END;

{
  ����������� ��������� �������� ������� �� ���������� ������ � XML
  ���������� ��:
    Serialize()
  ����:
    Component - ��������� ��� �����������
    ComponentTagName - ��� XML ���� �������
    ParentBlockEnd - ��������� �� ����� XML �������� ������������� ����
}

PROCEDURE TJvgXMLSerializer.DeSerializeInternal(Component: TObject; {const}
   ComponentTagName: STRING; ParentBlockEnd: PChar = NIL);
VAR
   BlockStart, BlockEnd, TagStart, TagEnd: PChar;
   TagName, TagValue, TagValueEnd: PChar;
   TypeInf                    : PTypeInfo;
   TypeData                   : PTypeData;
   PropIndex                  : integer;
   AName                      : STRING;
   PropList                   : PPropList;
   NumProps                   : word;

   { ����� � ������� �������� � �������� ������ }

   FUNCTION FindProperty(TagName: PChar): integer;
   VAR
      i                       : integer;
   BEGIN
      Result := -1;
      FOR i := 0 TO NumProps - 1 DO
         IF CompareStr(PropList^[i]^.Name, TagName) = 0 THEN
         BEGIN
            Result := i;
            break;
         END;
   END;

   PROCEDURE SkipSpaces(VAR TagEnd: PChar);
   BEGIN
      WHILE TagEnd[0] <= #33 DO
         inc(TagEnd);
   END;

   {
     StrPosExt - ���� ������� ����� ������ � ������ � �������� ������.
     �� ������� ������� ����������� StrPos.
   }

   FUNCTION StrPosExt(CONST Str1, Str2: PChar; Str2Len: DWORD): PChar;
      ASSEMBLER;
   ASM
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
   END;

BEGIN
   { Playing with RTTI }
   TypeInf := Component.ClassInfo;
   AName := TypeInf^.Name;
   TypeData := GetTypeData(TypeInf);
   NumProps := TypeData^.PropCount;

   GetMem(PropList, NumProps * sizeof(pointer));

   IF NOT WrapCollections AND (Component IS TCollection) THEN
      ComponentTagName := TCollection(Component).ItemClass.ClassName;

   TRY
      GetPropInfos(TypeInf, PropList);

      { ���� ����������� ��� }
      BlockStart := StrPosExt(TokenPtr, PChar('<' + ComponentTagName + '>'),
         BufferLength);

      { ���� ��� �� ������ � ��� ������� �������������, �� �� ������������ ��� }
      IF (BlockStart = NIL) AND NOT StrongConformity THEN
         exit;

      { ����� ��������� ��� ����������� }
      check(BlockStart <> NIL, '����������� ��� �� ������: ' + '<' +
         ComponentTagName + '>');
      inc(BlockStart, length(ComponentTagName) + 2);

      { ���� ����������� ��� }
      BlockEnd := StrPosExt(BlockStart, PChar('</' + ComponentTagName + '>'),
         BufferLength);
      check(BlockEnd <> NIL, '����������� ��� �� ������: ' + '<' +
         ComponentTagName + '>');

      { �������� �� ��������� ����. ���� � ������������ ��� }
      check((ParentBlockEnd = NIL) OR (BlockEnd < ParentBlockEnd),
         '����������� ��� �� ������: ' + '<' + ComponentTagName + '>');

      TagEnd := BlockStart;
      SkipSpaces(TagEnd);

      { XML ������ }
      WHILE (TagEnd < BlockEnd) { and (TagEnd >= TokenPtr)} DO
      BEGIN
         { ������� ����� ������� ������ }
         ASM
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
         END;

         GetMem(TagName, TagEnd - TagStart + 1);
         TRY

            { TagName - ��� ���� }
            StrLCopy(TagName, TagStart + 1, TagEnd - TagStart - 1);

            { TagEnd - ����������� ��� }
            TagEnd := StrPosExt(TagEnd, PChar('</' + TagName + '>'),
               BufferLength);

            //inc(TagStart, length('</' + TagName + '>')-1);

            { ������ ���������� ��������� ���� }
            TagValue := TagStart + length('</' + TagName + '>') - 1;
            TagValueEnd := TagEnd;

            { ����� ��������, ���������������� ���� }
            PropIndex := FindProperty(TagName);

            IF NOT WrapCollections AND (PropIndex = -1) THEN
            BEGIN
               PropIndex := FindProperty(Pchar(TagName + 's'));

            END
            ELSE
               TokenPtr := TagStart;

            IF NOT IgnoreUnknownTags THEN
               check(PropIndex <> -1,
                  'TJvgXMLSerializer.DeSerializeInternal: Uncknown property: ' +
                  TagName);

            IF PropIndex <> -1 THEN
               SetPropertyValue(Component, PropList^[PropIndex], TagValue,
                  TagValueEnd, BlockEnd);

            inc(TagEnd, length('</' + TagName + '>'));
            SkipSpaces(TagEnd);

         FINALLY
            FreeMem(TagName);
         END;

      END;

   FINALLY
      FreeMem(PropList, NumProps * sizeof(pointer));
   END;

END;

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

PROCEDURE TJvgXMLSerializer.SetPropertyValue(Component: TObject; PropInfo:
   PPropInfo; Value, ValueEnd: PChar; ParentBlockEnd: PChar);
VAR
   PropTypeInf                : PTypeInfo;
   PropObject                 : TObject;
   CollectionItem             : TCollectionItem;
   sValue                     : STRING;
   charTmp                    : char;
BEGIN
   PropTypeInf := PropInfo.PropType^;

   CASE PropTypeInf^.Kind OF
      tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkSet,
         tkWChar, tkLString, tkWString, tkVariant:
         BEGIN
            { ��������� zero terminated string }
            charTmp := ValueEnd[0];
            ValueEnd[0] := #0;
            sValue := StrPas(Value);
            ValueEnd[0] := charTmp;

            { ������ ������������. ��������� ������ ��� XML,
             ������������ � ������� ����� ���������� }
            IF FReplaceReservedSymbols THEN
            BEGIN
               sValue := StringReplace(sValue, '&lt;', '<', [rfReplaceAll]);
               sValue := StringReplace(sValue, '&gt;', '>', [rfReplaceAll]);
               // sValue := StringReplace(sValue, '&', '&', [rfReplaceAll]);
            END;

            { ������ ����������� �� ��������� }
            IF PropTypeInf^.Kind = tkFloat THEN
            BEGIN
               IF DecimalSeparator = ',' THEN
                  sValue := StringReplace(sValue, '.', DecimalSeparator,
                     [rfReplaceAll])
               ELSE
                  sValue := StringReplace(sValue, ',', DecimalSeparator,
                     [rfReplaceAll]);
            END;

            { ��� ����������� �������������� �������� tkSet ����� ������� ������ }
            IF PropTypeInf^.Kind = tkSet THEN
               sValue := '[' + sValue + ']';
            SetPropValue(Component, PropInfo^.Name, sValue);
         END;
      tkClass:
         BEGIN
            PropObject := GetObjectProp(Component, PropInfo);
            IF Assigned(PropObject) THEN
            BEGIN
               { �������������� ������ � ��������� ������� }
               IF (PropObject IS TStrings) THEN { ��������� ������ }
               BEGIN
                  charTmp := ValueEnd[0];
                  ValueEnd[0] := #0;
                  sValue := StrPas(Value);
                  ValueEnd[0] := charTmp;
                  TStrings(PropObject).CommaText := sValue;
               END
               ELSE IF (PropObject IS TCollection) THEN { ��������� }
               BEGIN
                  WHILE true DO { ������� �� �������� ����� ��������� � ��������� }
                  BEGIN
                     CollectionItem := (PropObject AS TCollection).Add;
                     TRY
                        DeSerializeInternal(CollectionItem,
                           CollectionItem.ClassName, ParentBlockEnd);
                     EXCEPT { ����������, ���� ��������� ������� �� ������ }
                        ON E: Exception DO
                        BEGIN
                           // Application.MessageBox(PChar(E.Message), '', MB_OK); - debug string
                           CollectionItem.Free;
                           // raise;  - debug string
                           break;
                        END;
                     END;
                  END;
               END
               ELSE { ��� ��������� ������� - ����������� ��������� }
                  DeSerializeInternal(PropObject, PropInfo^.Name,
                     ParentBlockEnd);
            END;

         END;
   END;
END;

{
  ��������� ��������� DTD ��� ��������� ������� �
  ������������ � published ����������� ��� ������.
  ����:
    Component - ������
  �����:
    ����� DTD � ����� Stream
}

PROCEDURE TJvgXMLSerializer.GenerateDTD(Component: TObject; Stream: TStream);
VAR
   DTDList                    : TStringList;
BEGIN
   DTDList := TStringList.Create;
   TRY
      GenerateDTDInternal(Component, DTDList, Stream, Component.ClassName);
   FINALLY
      DTDList.Free;
   END;
END;

{
  ���������� ����������� ��������� ��������� DTD ��� ��������� �������.
  ����:
    Component - ������
    DTDList - ������ ��� ������������ ��������� DTD
              ��� �������������� ����������.
  �����:
    ����� DTD � ����� Stream
}

PROCEDURE TJvgXMLSerializer.GenerateDTDInternal(Component: TObject; DTDList:
   TStrings; Stream: TStream; CONST ComponentTagName: STRING);
VAR
   PropInfo                   : PPropInfo;
   TypeInf, PropTypeInf       : PTypeInfo;
   TypeData                   : PTypeData;
   i                          : integer;
   AName, PropName, TagContent: STRING;
   PropList                   : PPropList;
   NumProps                   : word;
   PropObject                 : TObject;
CONST
   PCDATA                     = '#PCDATA';

   PROCEDURE addElement(CONST ElementName: STRING; Data: STRING);
   VAR
      s                       : STRING;
   BEGIN
      IF DTDList.IndexOf(ElementName) <> -1 THEN
         exit;
      DTDList.Add(ElementName);
      s := '<!ELEMENT ' + ElementName + ' ';
      IF Data = '' THEN
         Data := PCDATA;
      s := s + '(' + Data + ')>'#13#10;
      Stream.Write(PChar(s)[0], length(s));
   END;
BEGIN
   { Playing with RTTI }
   TypeInf := Component.ClassInfo;
   AName := TypeInf^.Name;
   TypeData := GetTypeData(TypeInf);
   NumProps := TypeData^.PropCount;

   GetMem(PropList, NumProps * sizeof(pointer));
   TRY
      { �������� ������ ������� }
      GetPropInfos(TypeInf, PropList);
      TagContent := '';

      FOR i := 0 TO NumProps - 1 DO
      BEGIN
         PropName := PropList^[i]^.Name;

         PropTypeInf := PropList^[i]^.PropType^;
         PropInfo := PropList^[i];

         { ���������� �� �������������� ���� }
         IF NOT (PropTypeInf^.Kind IN [tkDynArray, tkArray, tkRecord,
            tkInterface, tkMethod]) THEN
         BEGIN
            IF TagContent <> '' THEN
               TagContent := TagContent + '|';
            TagContent := TagContent + PropName;
         END;

         CASE PropTypeInf^.Kind OF
            tkInteger, tkChar, tkFloat, tkString,
               tkWChar, tkLString, tkWString, tkVariant, tkEnumeration, tkSet:
               BEGIN
                  { ������� � DTD. ��� ������ ����� ������ ���������� - #PCDATA }
                  addElement(PropName, PCDATA);
               END;
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
               BEGIN
                  PropObject := GetObjectProp(Component, PropInfo);
                  IF Assigned(PropObject) THEN
                  BEGIN
                     { ��� �������� �������-������� - ����������� ����� }
                     IF (PropObject IS TPersistent) THEN
                        GenerateDTDInternal(PropObject, DTDList, Stream,
                           PropName);
                  END;
               END;

         END;
      END;

      { �������������� ������ � ��������� ������� }
      { ��� ��������� ���������� �������� � ������ ���������� ��� �������� }
      IF (Component IS TCollection) THEN
      BEGIN
         IF TagContent <> '' THEN
            TagContent := TagContent + '|';
         TagContent := TagContent + (Component AS
            TCollection).ItemClass.ClassName + '*';
      END;

      { ��������� ������ ���������� ��� �������� }
      addElement(ComponentTagName, TagContent);
   FINALLY
      FreeMem(PropList, NumProps * sizeof(pointer));
   END;

END;

PROCEDURE TJvgXMLSerializer.check(Expr: boolean; CONST Message: STRING);
BEGIN
   IF NOT Expr THEN
      RAISE
         EJvgXMLSerializerException.Create('EJvgXMLSerializerException'#13#10#13#10
         + Message);
END;

END.

//(PShortString(@(GetTypeData(GetTypeData(PropTypeInf)^.BaseType^).NameList)))

//tickCount := GetTickCount();
//inc(tickCounter, GetTickCount() - tickCount);

