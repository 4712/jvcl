{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvTreeItemsEditorForm.PAS, released on 2003-01-01.

The Initial Developer of the Original Code is Peter Th�rnqvist [peter3 att users dott sourceforge dott net] .
Portions created by Peter Th�rnqvist are Copyright (C) 2003 Peter Th�rnqvist.
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
Changes:
2002-10-22:
  Drawing of State images differs from normal images since they are 1-based:
  the 0-th item for the state imagelist isn't drawn to alert the user to this fact
-----------------------------------------------------------------------------}
// $Id$

{$I jvcl.inc}

unit JvTreeItemsEditorForm;

interface

uses
  SysUtils, Classes,
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ActnList, ComCtrls, Menus, StdActns,
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  QGraphics, QControls, QForms, QDialogs, QStdCtrls, QExtCtrls,
  QActnList, QComCtrls, QMenus, QStdActns, QWindows, Types, QTypes,
  {$ENDIF VisualCLX}
  {$IFDEF COMPILER6_UP}
  DesignEditors, DesignIntf;
  {$ELSE}
  DsgnIntf;
  {$ENDIF COMPILER6_UP}

type
  TJvTreeItemsProperty = class(TClassProperty)
    function GetAttributes: TPropertyAttributes; override;
  public
    procedure Edit; override;
  end;

  TJvTreeViewComponentEditor = class(TComponentEditor)
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb(Index: Integer); override;
    procedure Edit; override;
  end;

  TJvPageTreeViewComponentEditor = class(TJvTreeViewComponentEditor)
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

  TfrmTreeViewItems = class(TForm)
    Panel1: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    tvItems: TTreeView;
    Splitter1: TSplitter;
    Panel2: TPanel;
    btnNew: TButton;
    btnNewSub: TButton;
    btnDelete: TButton;
    acItems: TActionList;
    acNewItem: TAction;
    acNewSubItem: TAction;
    acDelete: TAction;
    Bevel1: TBevel;
    gbProperties: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cbImage: TComboBox;
    cbSelected: TComboBox;
    cbState: TComboBox;
    edNodeText: TEdit;
    PopupMenu1: TPopupMenu;
    acNodeMoveLeft: TAction;
    acNodeMoveRight: TAction;
    acNodeMoveUp: TAction;
    acNodeMoveDown: TAction;
    Movedown1: TMenuItem;
    Moveup1: TMenuItem;
    N1: TMenuItem;
    Moveleft1: TMenuItem;
    Moveright1: TMenuItem;
    acLoadFromFile: TAction;
    acSaveToFile: TAction;
    LoadFromFile1: TMenuItem;
    SaveToFile1: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    procedure edNodeTextChange(Sender: TObject);
    procedure acNewItemExecute(Sender: TObject);
    procedure acNewSubItemExecute(Sender: TObject);
    procedure tvItemsChange(Sender: TObject; Node: TTreeNode);
    procedure acFileOpenAccept(Sender: TObject);
    procedure acFileSaveAsAccept(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acItemsUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure cbImageIndexDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbStateDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure acNodeMoveUpExecute(Sender: TObject);
    procedure acNodeMoveDownExecute(Sender: TObject);
    procedure acNodeMoveRightExecute(Sender: TObject);
    procedure acNodeMoveLeftExecute(Sender: TObject);
    procedure tvItemsStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure tvItemsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tvItemsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure acLoadFromFileExecute(Sender: TObject);
    procedure acSaveToFileExecute(Sender: TObject);
  private
    FDragNode:TTreeNode;
    FTreeView:TCustomTreeView;
  public
    class function Edit(TreeView: TCustomTreeView): Boolean;
  end;

  {$IFDEF VCL}
  TGroupBox = class(StdCtrls.TGroupBox)
  private
    FPropagateEnabled: Boolean;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property PropagateEnabled: Boolean read FPropagateEnabled write FPropagateEnabled default True;
  end;
  {$ENDIF VCL}

  {$IFDEF VisualCLX}
  TGroupBox = class(QStdCtrls.TGroupBox)
  private
    FPropagateEnabled: Boolean;
  protected
    procedure EnabledChanged; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property PropagateEnabled: Boolean read FPropagateEnabled write FPropagateEnabled default True;
  end;
  {$ENDIF VisualCLX}


procedure ShowTreeNodeEditor(TreeView:TCustomTreeView);

implementation

uses
  {$IFDEF VCL}
  ImgList,
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  QImgList,
  {$ENDIF VisualCLX}
  JvPageListTreeView, JvPageLinkEditorForm, JvDsgnConsts;

{$IFDEF VCL}
{$R *.dfm}
{$ENDIF VCL}
{$IFDEF VisualCLX}
{$R *.xfm}
{$ENDIF VisualCLX}

type
  THackTreeView = class(TCustomTreeView);

procedure ShowTreeNodeEditor(TreeView:TCustomTreeView);
begin
  TfrmTreeViewItems.Edit(TreeView);
end;

//=== { TGroupBox } ==========================================================

constructor TGroupBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  PropagateEnabled := True;
end;

procedure TGroupBox.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  if PropagateEnabled then
    Broadcast(Msg);
end;

//=== { TfrmTreeViewItems } ==================================================

procedure TfrmTreeViewItems.edNodeTextChange(Sender: TObject);
begin
  if tvItems.Selected <> nil then
  begin
    tvItems.Selected.Text := edNodeText.Text;
    tvItems.Selected.ImageIndex := StrToIntDef(cbImage.Text,
      tvItems.Selected.ImageIndex);
    tvItems.Selected.SelectedIndex := StrToIntDef(cbSelected.Text,
      tvItems.Selected.SelectedIndex);
    tvItems.Selected.StateIndex := StrToIntDef(cbState.Text,
      tvItems.Selected.StateIndex);
  end;
end;

procedure TfrmTreeViewItems.acNewItemExecute(Sender: TObject);
begin
  with tvItems.Items.Add(tvItems.Selected, '') do
  begin
    MakeVisible;
    Selected := True;
  end;
  gbProperties.Enabled := True;
  edNodeText.SetFocus;
end;

procedure TfrmTreeViewItems.acNewSubItemExecute(Sender: TObject);
begin
  with tvItems.Items.AddChild(tvItems.Selected, '') do
  begin
    MakeVisible;
    Selected := True;
  end;
  gbProperties.Enabled := True;
  edNodeText.SetFocus;
end;

function DoStringCompare(SL: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := StrToIntDef(SL[Index2], Index2) - StrToIntDef(SL[Index1], Index1);
end;

procedure TfrmTreeViewItems.tvItemsChange(Sender: TObject; Node: TTreeNode);

  function AddCB(CB: TComboBox; AItemIndex: Integer): Integer;
  var
    S: string;
    SL: TStringList;
  begin
    S := IntToStr(AItemIndex);
    Result := CB.Items.IndexOf(S);
    if Result < 0 then
    begin
      Result := CB.Items.Add(S);
      SL := TStringList.Create;
      try
        SL.Assign(CB.Items);
        SL.CustomSort(DoStringCompare);
        CB.Items := SL;
      finally
        SL.Free;
      end;
    end;
  end;

begin
  if Node <> nil then
  begin
    edNodeText.OnChange := nil;
    edNodeText.Text := Node.Text;
    cbImage.ItemIndex := AddCB(cbImage, Node.ImageIndex);
    cbSelected.ItemIndex := AddCB(cbSelected, Node.SelectedIndex);
    cbState.ItemIndex := AddCB(cbState, Node.StateIndex);
    edNodeText.OnChange := edNodeTextChange;
  end;
  gbProperties.Enabled := tvItems.Selected <> nil;
end;

procedure TfrmTreeViewItems.acFileOpenAccept(Sender: TObject);
begin
//  tvItems.LoadFromFile(acFileOpen.Dialog.Filename);
  tvItems.FullExpand;
end;

procedure TfrmTreeViewItems.acFileSaveAsAccept(Sender: TObject);
begin
//  tvItems.SaveToFile(acFileSaveAs.Dialog.Filename);
end;

procedure TfrmTreeViewItems.acDeleteExecute(Sender: TObject);
var
  N: TTreeNode;
begin
  edNodeText.OnChange := nil;
  tvItems.OnChange := nil;
  try
    N := tvItems.Selected.GetPrev;
    if N = nil then
      N := tvItems.Selected.GetNext;
    tvItems.Selected.Delete;
    edNodeText.Text := '';
    if N <> nil then
    begin
      N.MakeVisible;
      N.Selected := True;
    end;
  finally
    edNodeText.OnChange := edNodeTextChange;
    tvItems.OnChange := tvItemsChange;
  end;
end;

procedure TfrmTreeViewItems.acItemsUpdate(Action: TBasicAction; var Handled: Boolean);
var
  bSel: Boolean;
  nSel: TTreeNode;
begin
  bSel := tvItems.Selected <> nil;
  nSel := tvItems.Selected;
  acNewSubItem.Enabled := bSel;
  acDelete.Enabled := bSel;
  acNodeMoveLeft.Enabled := bSel and (nSel.Parent <> nil);
  acNodeMoveRight.Enabled := bSel and (nSel.getPrevSibling <> nil);
  acNodeMoveUp.Enabled := bSel and ((nSel.getPrevSibling <> nil) or (nSel.Parent <> nil));
  acNodeMoveDown.Enabled := bSel and ((nSel.getNextSibling <> nil) or (nSel.Parent <> nil));
end;

class function TfrmTreeViewItems.Edit(TreeView: TCustomTreeView): Boolean;
const
  cNegItem = '-1';
var
  f: TfrmTreeViewItems;
  il: TCustomImageList;
  i: Integer;
begin
  // keep in mind that Self is class here not object
  f := Self.Create(Application);
  try
    f.FTreeView := TreeView;
    f.tvItems.Items.Assign(THackTreeView(Treeview).Items);
    il := THackTreeView(Treeview).Images;
    if il <> nil then
    begin
      f.cbImage.Style := csOwnerDrawFixed;
      f.cbSelected.Style := csOwnerDrawFixed;
      f.cbImage.ItemHeight := il.Height;
      f.cbSelected.ItemHeight := il.Height;

      f.cbImage.Items.Add(cNegItem);
      f.cbSelected.Items.Add(cNegItem);
      for I := 0 to il.Count - 1 do
      begin
        f.cbImage.Items.Add(IntToStr(I));
        f.cbSelected.Items.Add(IntToStr(I));
      end;
      f.cbImage.Tag := Integer(il);
      f.cbSelected.Tag := Integer(il);
    end;
    il := THackTreeView(Treeview).StateImages;
    if il <> nil then
    begin
      f.cbState.Style := csOwnerDrawFixed;
      f.cbState.ItemHeight := il.Height;
      f.cbState.Items.Add(cNegItem);
      for i := 0 to il.Count - 1 do
        f.cbState.Items.Add(IntToStr(i));
      f.cbState.Tag := Integer(il);
    end;
    f.cbSelected.ItemIndex := 0;
    f.cbSelected.ItemIndex := 0;
    f.cbState.ItemIndex := 0;
    f.tvItems.FullExpand;
    if f.tvItems.Items.Count > 0 then
      f.tvItems.Items.getFirstNode.MakeVisible;
    Result := f.ShowModal = mrOk;
    if Result then
      THackTreeView(Treeview).Items.Assign(f.tvItems.Items);
  finally
    f.Free;
  end;
end;

procedure TfrmTreeViewItems.cbImageIndexDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  DrawOffset, DrawIndex: Integer;
  il: TImageList;
  CB: TComboBox;
begin
  CB := TComboBox(Control);
  il := TImageList(CB.Tag);
  DrawIndex := Index - 1;
  DrawOffset := 2;
  CB.Canvas.FillRect(Rect);
  if il <> nil then
  begin
    il.Draw(CB.Canvas, Rect.Left + 2, Rect.Top, DrawIndex);
    DrawOffset := il.Width + 2;
  end;
  Rect.Left := Rect.Left + DrawOffset;
  DrawText(CB.Canvas.Handle, PChar(Format('%d', [DrawIndex])), -1, Rect,
    DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
end;

procedure TfrmTreeViewItems.cbStateDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  DrawOffset, DrawIndex: Integer;
  il: TImageList;
  CB: TComboBox;
begin
  CB := TComboBox(Control);
  il := TImageList(CB.Tag);
  DrawIndex := Index - 1;
  DrawOffset := 2;
  CB.Canvas.FillRect(Rect);
  // state images are *one*-based, so we don't draw the 0'th image
  // to remind the user about this fact...
  if il <> nil then
  begin
    if DrawIndex > 0 then
      il.Draw(CB.Canvas, Rect.Left + 2, Rect.Top, DrawIndex);
    DrawOffset := il.Width + 2;
  end;
  Rect.Left := Rect.Left + DrawOffset;
  DrawText(CB.Canvas.Handle, PChar(Format('%d', [DrawIndex])), -1, Rect,
    DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
end;

//=== { TJvTreeItemsProperty } ===============================================

procedure TJvTreeItemsProperty.Edit;
begin
  TfrmTreeViewItems.Edit(TCustomTreeView(GetComponent(0)));
end;

function TJvTreeItemsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

//=== { TJvTreeViewComponentEditor } =========================================

procedure TJvTreeViewComponentEditor.Edit;
begin
  ExecuteVerb(0);
end;

procedure TJvTreeViewComponentEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then
    ShowTreeNodeEditor(TCustomTreeView(Component))
  else
    inherited ExecuteVerb(Index);
end;

function TJvTreeViewComponentEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := RsItemsEditorEllipsis
  else
    Result := '';
end;

function TJvTreeViewComponentEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

//=== { TfrmTreeViewItems } ==================================================

procedure TfrmTreeViewItems.acNodeMoveUpExecute(Sender: TObject);
begin
  with tvItems.Selected do
  begin
    if GetPrevSibling <> nil then
      MoveTo(GetPrevSibling, naInsert)
    else
    if Parent <> nil then
      MoveTo(Parent, naInsert);
  end;
  tvItems.FullExpand;
end;

procedure TfrmTreeViewItems.acNodeMoveDownExecute(Sender: TObject);
var N:TTreeNode;
begin
  with tvItems.Selected do
  begin
    if GetNextSibling <> nil then
      GetNextSibling.MoveTo(tvItems.Selected, naInsert)
    else
    if Parent <> nil then
    begin
      N := Parent;
      MoveTo(Parent, naInsert);
      N.MoveTo(tvItems.Selected, naInsert);
    end;
  end;
  tvItems.FullExpand;
end;

procedure TfrmTreeViewItems.acNodeMoveRightExecute(Sender: TObject);
begin
  with tvItems.Selected do
    MoveTo(GetPrevSibling, naAddChild);
  tvItems.FullExpand;
end;

procedure TfrmTreeViewItems.acNodeMoveLeftExecute(Sender: TObject);
var N:TTreeNode;
begin
  with tvItems.Selected do
  begin
    N := Parent;
    MoveTo(Parent, naInsert);
    N.MoveTo(tvItems.Selected, naInsert);
  end;
  tvItems.FullExpand;
end;

procedure TfrmTreeViewItems.tvItemsStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  FDragNode := tvItems.Selected;
end;

procedure TfrmTreeViewItems.tvItemsDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  N: TTreeNode;
begin
  N := tvItems.GetNodeAt(X,Y);
  Accept := (Source = Sender) and (FDragNode <> nil) and (N <> FDragNode);
  if (N <> nil) and N.HasChildren and not N.Expanded then
    N.Expand(False);
end;

procedure TfrmTreeViewItems.tvItemsDragDrop(Sender, Source: TObject;
  X, Y: Integer);
var
  N: TTreeNode;
begin
  if FDragNode = nil then
    Exit;
  N := tvItems.GetNodeAt(X,Y);
  if N = nil then
    FDragNode.MoveTo(tvItems.Items.GetFirstNode, naAdd)
  else
    FDragNode.MoveTo(N, naAddChildFirst);
  FDragNode := nil;
  tvItems.FullExpand;
end;

procedure TfrmTreeViewItems.acLoadFromFileExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
    tvItems.LoadFromFile(OpenDialog1.Filename);
end;

procedure TfrmTreeViewItems.acSaveToFileExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
    tvItems.SaveToFile(SaveDialog1.Filename);
end;

//=== { TJvPageTreeViewComponentEditor } =====================================

procedure TJvPageTreeViewComponentEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 1 then
    ShowPageLinkEditor(TJvCustomPageListTreeView(Component))
  else
    inherited ExecuteVerb(Index);
end;

function TJvPageTreeViewComponentEditor.GetVerb(Index: Integer): string;
begin
  if Index = 1 then
    Result := RsLinksEditorEllipsis
  else
    Result := inherited GetVerb(Index);
end;

function TJvPageTreeViewComponentEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

end.

