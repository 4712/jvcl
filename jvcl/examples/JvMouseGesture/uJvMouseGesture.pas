unit uJvMouseGesture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvMouseGesture, ExtCtrls, JvComponent;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    RadioGroup1: TRadioGroup;
    JvMouseGesture1: TJvMouseGesture;
    JvMouseGestureHook1: TJvMouseGestureHook;
    ComboBox1: TComboBox;
    Label1: TLabel;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure JvMouseGestureHook1JvMouseGestureCustomInterpretation(
      aGesture: String);
    procedure FormShow(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    procedure RefreshCaption;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}


procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if RadioGroup1.ItemIndex = 1 then exit;

  if Button = mbRight then
    JvMouseGesture1.StartMouseGesture(x,y);

end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if JvMouseGesture1.TrailActive then
    JvMouseGesture1.TrailMouseGesture(x,y);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if JvMouseGesture1.TrailActive then begin
    JvMouseGesture1.EndMouseGesture;
    Memo1.Lines.Add('Gesture = ' + JvMouseGesture1.Gesture);
  end;
end;


procedure TForm1.JvMouseGestureHook1JvMouseGestureCustomInterpretation(
  aGesture: String);
begin
  Memo1.Lines.Add('Gesture (via hook) = ' + aGesture);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  JvMouseGesture1.Active := True;
  JvMouseGestureHook1.Active := False;
  RefreshCaption;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 0 then begin
    JvMouseGesture1.Active := true;
    JvMouseGestureHook1.Active := false;
  end
  else begin
    JvMouseGesture1.Active := false;
    JvMouseGestureHook1.Active := true;
  end;
  RefreshCaption;
end;

procedure TForm1.RefreshCaption;
begin
  Memo1.Clear;
  Caption := 'hook on form active = ' + booltostr(JvMouseGesture1.Active,true) +
             '  ApplicationHook active = '+ booltostr(JvMouseGestureHook1.Active,true);
  Memo1.Lines.Add(Caption);
end;


procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  case Combobox1.ItemIndex of
    0: JvMouseGestureHook1.MouseButton := JvMButtonLeft;
    1: JvMouseGestureHook1.MouseButton := JvMButtonMiddle;
    2: JvMouseGestureHook1.MouseButton := JvMButtonRight;
  end;
    
end;

end.
