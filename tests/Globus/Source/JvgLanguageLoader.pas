{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvgLanguageLoader.PAS, released on 2003-01-15.

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

{
eng:
 Load new string resources from file to components. Uses RTTI

rus:
�������� �� ������� �� ����� ��� ��������� ������ ������ ����� �� ������
 ������� � ���� ������ ����:
 ������ �� ����� 1=������ �� ����� 2
 ...
 ������ �� ����� 1=������ �� ����� 2
 ===================================================================
}
UNIT JvgLanguageLoader;

INTERFACE

USES
   Windows,
   Messages,
   SysUtils,
   Classes,
   JVComponent,
   Graphics,
   Controls,
   Forms,
   Dialogs,
   comctrls,
   grids;

TYPE
   TLanguageLoaderOptions = SET OF (lofTrimSpaces);
   {����� �������� ��������� � ����������� ��������}

   TJvgLanguageLoader = CLASS(TJvComponent)
   PRIVATE
      sl: TStringList;
      FOptions: TLanguageLoaderOptions;
      FUNCTION TranslateString(sString: STRING): STRING;
   PROTECTED
      PROCEDURE UpdateComponent(Component: TPersistent); VIRTUAL;
   PUBLIC
      PROCEDURE LoadLanguage(Component: TComponent; FileName: STRING);  {main function}
   PUBLISHED
      PROPERTY Options: TLanguageLoaderOptions READ FOptions WRITE FOptions;
   END;

PROCEDURE LoadLanguage(Component: TComponent; FileName: STRING; Options:
   TLanguageLoaderOptions);

PROCEDURE Register;

IMPLEMENTATION
USES TypInfo;

PROCEDURE Register;
BEGIN
END;

{�-�� ��� �������� ������� ��� ���������������� �������� ����������}

PROCEDURE LoadLanguage(Component: TComponent; FileName: STRING; Options:
   TLanguageLoaderOptions);
VAR
   LanguageLoader             : TJvgLanguageLoader;
BEGIN
   LanguageLoader := TJvgLanguageLoader.Create(NIL);
   TRY
      LanguageLoader.LoadLanguage(Component, FileName);
   FINALLY
      LanguageLoader.Free;
   END;
END;

{ TJvgLanguageLoader }

{  �������� �������, ����� ���������� ���������� �  }
{  ���� ��� �������� �����������                    }

PROCEDURE TJvgLanguageLoader.LoadLanguage(Component: TComponent; FileName:
   STRING);

   PROCEDURE UpdateAllComponents(Component: TComponent);
   VAR
      i                       : integer;
   BEGIN
      { ��������� ������� ���������� }
      UpdateComponent(Component);
      FOR i := 0 TO Component.ComponentCount - 1 DO
         UpdateAllComponents(Component.Components[i]);
   END;
BEGIN
   sl := TStringList.Create;
   TRY
      { �������� ������� �� ��������� ����� }
      sl.LoadFromFile(FileName);
      sl.Sorted := true;
      UpdateAllComponents(Component);
   FINALLY
      sl.Free;
   END;
END;

{ ������ �� ���� ��������� ����������                        }
{ ��� ���� ��������� ������� - �������� �������� �� �������  }

PROCEDURE TJvgLanguageLoader.UpdateComponent(Component: TPersistent);
VAR
   PropInfo                   : PPropInfo;
   TypeInf, PropTypeInf       : PTypeInfo;
   TypeData                   : PTypeData;
   i, j                       : integer;
   AName, PropName, StringPropValue: STRING;
   PropList                   : PPropList;
   NumProps                   : word;
   PropObject                 : TObject;
BEGIN
   { Playing with RTTI }
   TypeInf := Component.ClassInfo;
   AName := TypeInf^.Name;
   TypeData := GetTypeData(TypeInf);
   NumProps := TypeData^.PropCount;

   GetMem(PropList, NumProps * sizeof(pointer));

   TRY
      GetPropInfos(TypeInf, PropList);

      FOR i := 0 TO NumProps - 1 DO
      BEGIN
         PropName := PropList^[i]^.Name;

         PropTypeInf := PropList^[i]^.PropType^;
         PropInfo := PropList^[i];

         CASE PropTypeInf^.Kind OF
            tkString, tkLString:
               IF PropName <> 'Name' THEN { ���������� �������� Name �� ������� }
               BEGIN
                  { ��������� �������� �������� � ����� �������� � ������� }
                  StringPropValue := GetStrProp(Component, PropInfo);
                  SetStrProp(Component, PropInfo,
                     TranslateString(StringPropValue));
               END;
            tkClass:
               BEGIN
                  PropObject := GetObjectProp(Component, PropInfo
                     {, TPersistent});

                  IF Assigned(PropObject) THEN
                  BEGIN
                     { ��� �������� �������-������� ����� ��������� ������� }
                     IF (PropObject IS TPersistent) THEN
                        UpdateComponent(PropObject AS TPersistent);

                     { �������������� ������ � ��������� ������� }
                     IF (PropObject IS TStrings) THEN
                     BEGIN
                        FOR j := 0 TO (PropObject AS TStrings).Count - 1 DO
                           TStrings(PropObject)[j] :=
                              TranslateString(TStrings(PropObject)[j]);
                     END;
                     IF (PropObject IS TTreeNodes) THEN
                     BEGIN
                        FOR j := 0 TO (PropObject AS TTreeNodes).Count - 1 DO
                           TTreeNodes(PropObject).Item[j].Text :=
                              TranslateString(TTreeNodes(PropObject).Item[j].Text);
                     END;
                     IF (PropObject IS TListItems) THEN
                     BEGIN
                        FOR j := 0 TO (PropObject AS TListItems).Count - 1 DO
                           TListItems(PropObject).Item[j].Caption :=
                              TranslateString(TListItems(PropObject).Item[j].Caption);
                     END;
                     { ����� ����� �������� ��������� ��������� ������� }
                  END;

               END;

         END;
      END;
   FINALLY
      FreeMem(PropList, NumProps * sizeof(pointer));
   END;
END;

{ ����� �������� ��� �������� ������ � ������� }

FUNCTION TJvgLanguageLoader.TranslateString(sString: STRING): STRING;
BEGIN
   IF lofTrimSpaces IN Options THEN
      sString := trim(sString);
   IF sString = '' THEN
   BEGIN
      Result := '';
      exit;
   END;
   IF sl.IndexOfName(sString) <> -1 THEN
      Result := sl.Values[sString]
   ELSE
      Result := sString;
END;

END.

