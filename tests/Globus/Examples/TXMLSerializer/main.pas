unit main;
{
������ ������������� ���������� ������ � XML � �������� ������ �� XML.

����� ����������� ����� ���������������� ��������� �������.


coded by Xelby, 09.2001
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, JvgXMLSerializer;

type
  TfglXMLSerializerDemo = class(TForm)
    bLoadXML: TButton;
    bSaveXML: TButton;
    JvgXMLSerializer: TJvgXMLSerializer;
    Memo1: TMemo;
    eTestFileName: TEdit;
    Label1: TLabel;
    bViewXML: TButton;
    procedure FormCreate(Sender: TObject);
    procedure bLoadXMLClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bSaveXMLClick(Sender: TObject);
    procedure bViewXMLClick(Sender: TObject);
    procedure glXMLSerializerGetXMLHeader(Sender: TObject;
      var Value: String);
  private
    sTestFileName: string; // ���� ��� ���������� XML
  public
    { Public declarations }
  end;

var
  fglXMLSerializerDemo: TfglXMLSerializerDemo;

implementation
uses testClasses, ShellApi;
{$R *.DFM}

var
    Catalogue: TCatalogue; // �����, ������� ����� ��������� � ���������

procedure TfglXMLSerializerDemo.FormCreate(Sender: TObject);
var
  i: integer;
begin
  { ����� ������������ ��������� ���� test.xml }
  sTestFileName := ExtractFilePath(ParamStr(0)) + 'test.xml';
  eTestFileName.Text := sTestFileName;

  { TCatalogue - �����, �� ������� ����� ������������� }
  Catalogue := TCatalogue.Create(self);
end;

procedure TfglXMLSerializerDemo.FormDestroy(Sender: TObject);
begin
  Catalogue.Free;
end;




{ ��������� ������� � XML }
procedure TfglXMLSerializerDemo.bSaveXMLClick(Sender: TObject);
var
  fs: TFileStream;
  i: integer;
begin

  { ��������� ������ ������������� ������� }

  Catalogue.Header := '������� �������� ������� �������';
  for i := 1 to 30 do
  with Catalogue.Documents.Add do
  begin
    DocIndex := i;
    Title := 'Title ' + IntToStr(i);
    Author := 'Author ' + IntToStr(i);
    PublicDate :=DateTimeToStr(now);
  end;
  Catalogue.Footer := '������� ' + DateToStr(date);

  { ��������� }
  try
    fs := TFileStream.Create( sTestFileName, fmCreate);
    JvgXMLSerializer.Serialize(Catalogue, fs);
  finally
    fs.Free;
  end;

  ShowMessage('������ �������� � ����');
end;



{ ������������� ������� �� XML }
procedure TfglXMLSerializerDemo.bLoadXMLClick(Sender: TObject);
var
  fs: TFileStream;
begin
  Catalogue.Documents.Clear;
  try
    fs := TFileStream.Create( sTestFileName, fmOpenRead);
    JvgXMLSerializer.DeSerialize(Catalogue, fs);
  finally
    fs.Free;
  end;
  ShowMessage('������ ��������. ������: ' + IntToStr(Catalogue.Documents.Count));
end;

{ �������� � �������� }
procedure TfglXMLSerializerDemo.bViewXMLClick(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar(sTestFileName), 0, 0, SW_SHOW);
end;


{ ����������� ��������� � ��������� ��������� ��� ������� ���� }
procedure TfglXMLSerializerDemo.glXMLSerializerGetXMLHeader(Sender: TObject; var Value: String);
begin
  Value := '<?xml version="1.0" encoding="windows-1251"?>';
end;

end.
