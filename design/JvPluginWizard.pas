{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvPluginWizard.PAS, released on 1999-09-06.

The Initial Developer of the Original Code is Tim Sullivan [tim@uil.net]
Portions created by Tim Sullivan are Copyright (C) 1999 Tim Sullivan.
All Rights Reserved.

Contributor(s): Ralf Steinhaeusser [ralfiii@gmx.net].

Last Modified: 2002-09-02

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:

 Todo : I don't know why but IDE does not not navigate correctly here...
 Todo : Creates code with #10#13 instead of the other way ound (#13#10 is correct)

 Versionhistory :

 V 09 : inserted TYPE-decaration, IDE navigation works now
        rewrote ProjectCreate (100 times), seems to work now except a AV when
        creating a DLL-project. May have to do with ressources
 V 08 : Setting the pluginname works fine after A LOT of trying...
 V 07 : #10#13 -> #13#10 corrected
 V 06 : Wizard-Form added, lets select Plugin-Type and Object-name
 V 05 : uses-list minimized

 -----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvPluginWizard;

interface

uses
  Windows, ToolsApi;

type
  TJvPluginWizard = class( TNotifierObject, IOTAWizard, IOTARepositoryWizard,
                                            IOTAMenuWizard, IOTAProjectWizard )
  public
    PluginMainMenu : IOTAComponent;

    { IOTAWizard Methods }
    function GetIDString : string; virtual;
    function GetName     : string; Virtual;
    function GetState    : TWizardState; Virtual;
    procedure Execute; virtual;

    { IOTARepositoryWizard Methods }
    function GetAuthor: string; virtual;
    function GetComment: string; virtual;
    function GetPage: string; virtual;
    function GetGlyph: {$IFDEF COMPILER6_UP}Cardinal;{$ELSE}HICON;{$ENDIF} virtual;

    { IOTAMenuWizard methods }
    function GetMenuText: string; virtual;
  end;

  TJvPluginProjectCreator = class(TInterfacedObject, IOTACreator, IOTAProjectCreator) // both interfaces needed !!!!
  public
    Wizard : TJvPluginWizard;

    { 0 = dll; 1 = dpk }
    PlugType: Integer;

    { Private variables which will be used to store some properties for
      the TJvPlugin }
    PlugName: string;
    PlugDesc : String;
    PlugAuth : String;
    PlugCopy : String;
    PlugUID  : String;

    Project : IOTAModule;

    function GetFileName: string;
    function GetOptionFileName: string;
    function GetShowSource: Boolean;
    procedure NewDefaultModule;
    function NewOptionSource(const ProjectName: string): IOTAFile;
    procedure NewProjectResource(const Project: IOTAProject);
    function NewProjectSource(const ProjectName: string): IOTAFile;
    function GetCreatorType: string;
    function GetExisting: Boolean;
    function GetFileSystem: string;
    function GetOwner: IOTAModule;
    function GetUnnamed: Boolean;
  end;

  TJvPluginModuleCreator = class( TInterfacedObject, IOTACreator, IOTAModuleCreator )
  public
    Wizard : TJvPluginWizard;

    { 0 = dll; 1 = dpk }
    PlugType: Integer;

    Project    : IOTAModule;

    { Private variables which will be used to store some properties for
      the TJvPlugin }
    PlugName: string;
    PlugDesc : String;
    PlugAuth : String;
    PlugCopy : String;
    PlugUID  : String;

    function GetCreatorType: string;
    function GetExisting: Boolean;
    function GetFileSystem: string;
    function GetOwner: IOTAModule;
    function GetUnnamed: Boolean;

    function GetAncestorName: string;
    function GetImplFileName: string;
    function GetIntfFileName: string;
    function GetFormName: string;
    function GetMainForm: Boolean;
    function GetShowForm: Boolean;
    function GetShowSource: Boolean;
    function NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
    function NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
    procedure FormCreated(const FormEditor: IOTAFormEditor);
  end;

  // from http://www.gexperts.org/opentools/GXModuleCreator.pas
  TJvOTAFile = class(TInterfacedObject, IOTAFile)
  private
    FSource: string;
  public
    constructor Create(const Source: string);
    function GetSource: string;
    function GetAge: TDateTime;
  end;

implementation

uses
  {$IFDEF COMPILER6_UP}
  DesignIntf, DesignEditors,
  {$ELSE}
  DsgnIntf,
  {$ENDIF COMPILER6_UP}
  Controls, SysUtils, Dialogs, Classes, actnList, Menus,
  JvPlugin, JvPluginParamsForm;//, JvTypes;

{$R JvPluginWiz.res}

const
  CrLf = #13#10;
  cJediPuginWizard = 'JEDI Plugin Wizard';
  cPlgPrefix = 'Plg';
  cPluginPrefix = 'Plugin';
  cDirSep = '\';

function GetFormEditorFromModule(
  IModule: IOTAModule): IOTAFormEditor;
var
  i: Integer;
  IEditor: IOTAEditor;
begin
  Result := nil;
  if IModule = nil then
     Exit;
  for i := 0 to IModule.GetModuleFileCount - 1 do
  begin
    IEditor := IModule.GetModuleFileEditor(i);
    if Supports(IEditor, IOTAFormEditor, Result) then
      Break;
  end;
end;

//=== TJvPluginWizard ========================================================

function TJvPluginWizard.GetIDString: string;
begin
  Result := 'JVCL.PluginWizard'; //cJediPuginWizard;
end;

function TJvPluginWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

function TJvPluginWizard.GetMenuText: string;
begin
  Result := cJediPuginWizard;
end;

function TJvPluginWizard.GetName: string;
begin
  Result := 'Jv Plugin Wizard';
end;

function TJvPluginWizard.GetPage: string;
begin
  Result := 'Projects';
end;

function TJvPluginWizard.GetAuthor: string;
begin
  Result := 'MPL';
end;

function TJvPluginWizard.GetComment: string;
begin
  Result := 'New Plugin';
end;

function TJvPluginWizard.GetGlyph:{$IFDEF COMPILER6_UP}Cardinal;{$ELSE}HICON;{$ENDIF}
begin
  Result := LoadIcon(HInstance, 'JvPLUGINWIZ');
end;

procedure TJvPluginWizard.Execute;
var
  ModuleServices: IOTAModuleServices;
  ProjectCreator: TJvPluginProjectCreator;
begin
  with TfrmPluginParams.Create(nil) do
  begin
    try
      if ShowModal = mrOk then
      begin
        if Assigned(BorlandIDEServices) and
          (BorlandIDEServices.QueryInterface(IOTAModuleServices, ModuleServices) = S_OK) then
        begin
          ProjectCreator := TJvPluginProjectCreator.Create;
          ProjectCreator.Wizard := Self;
          
          { rbDll checked     => dll     => PlugType = 0 = Ord(False)
            rbPackage checked => package => PlugType = 1 = Ord(True)
          }
          ProjectCreator.PlugType := Ord(rbPackage.Checked); //  radPluginType.ItemIndex;
          ProjectCreator.PlugName := Trim(edtPluginName.Text);

          ProjectCreator.PlugAuth := Trim( edtPluginAuthor.Text );
          ProjectCreator.PlugCopy := Trim( edtPluginCopyright.Text );
          ProjectCreator.PlugDesc := Trim( mmoDescripton.Text );
          ProjectCreator.PlugUID  := Trim( edtPluginUID.Text );

          ModuleServices.CreateModule(ProjectCreator);
        end;
      end;
    finally
      Free;
    end;
  end;
end;

//=== TJvPluginProjectCreator ================================================

// left empty this makes problems !!

function TJvPluginProjectCreator.GetFileName: string;
begin
  { 0 = dll; 1 = dpk }
  if PlugType = 0 then
    Result := GetCurrentDir + cDirSep + cPlgPrefix + PlugName + '.dpr'
  else
    Result := GetCurrentDir + cDirSep + cPlgPrefix + PlugName + '.dpk';
end;

function TJvPluginProjectCreator.GetOptionFileName: string;
begin
  Result := '';
end;

function TJvPluginProjectCreator.GetShowSource: Boolean;
begin
  Result := True;
end;

procedure TJvPluginProjectCreator.NewDefaultModule;
var
  Module       : IOTAModule;
  ModuleCreator: TJvPluginModuleCreator;
begin
  ModuleCreator := TJvPluginModuleCreator.Create;
  ModuleCreator.Wizard := Wizard;
  ModuleCreator.PlugType := PlugType;
  ModuleCreator.PlugName := PlugName;
  ModuleCreator.PlugAuth := PlugAuth;
  ModuleCreator.PlugDesc := PlugDesc;
  ModuleCreator.PlugCopy := PlugCopy;
  ModuleCreator.PlugUID  := PlugUID;
  ModuleCreator.Project := Project;
  Module := (BorlandIDEServices as IOTAModuleServices).CreateModule(ModuleCreator);
end;

function TJvPluginProjectCreator.NewOptionSource(const ProjectName: string): IOTAFile;
begin
  Result := nil;
end;

procedure TJvPluginProjectCreator.NewProjectResource(const Project: IOTAProject);
begin
end;

function TJvPluginProjectCreator.NewProjectSource(const ProjectName: string): IOTAFile;
var
  S: string;
begin
  { 0 = dll; 1 = dpk }
  if PlugType = 0 then
    S := 'library ' + ProjectName + ';' + CrLf +
      CrLf +
      'uses' + CrLf +
      '  ShareMem;' + CrLf +
      CrLf +
      'exports' + CrLf +
      '  RegisterPlugin;' + CrLf +
      CrLf +
      'begin' + CrLf +
      'end.'
  else // Package-Library
    S := 'package ' + ProjectName + ';' + CrLf + CrLf +
      '{$DESCRIPTION ''JEDI Plugin Package''}' + CrLf +
      '{$RUNONLY}' + CrLf +
      '{$IMPLICITBUILD ON}' + CrLf + CrLf +
      'requires' + CrLf +
    {$IFDEF COMPILER5}
    '  vcl50,' + CrLf + '  JVCL200_R50;' +
    {$ENDIF COMPILER5}
    {$IFDEF COMPILER6}
    '  vcl,' + CrLf + '  JVCL200_R60;' +
    {$ENDIF COMPILER6}
    {$IFDEF COMPILER7}
    '  vcl,' + CrLf + '  JVCL200_R70;' +
    {$ENDIF COMPILER7}

    CrLf + CrLf + 'end.';

  Result := TJvOTAFile.Create(S);
end;

function TJvPluginProjectCreator.GetCreatorType: string;
begin
  { 0 = dll; 1 = dpk }
  if PlugType = 0 then
    Result := sLibrary
  else
    Result := sPackage;
end;

function TJvPluginProjectCreator.GetExisting: Boolean;
begin
  Result := False;
end;

function TJvPluginProjectCreator.GetFileSystem: string;
begin
  Result := '';
end;

function GetCurrentProjectGroup: IOTAProjectGroup;
var
  IModuleServices: IOTAModuleServices;
  IModule: IOTAModule;
  IProjectGroup: IOTAProjectGroup;
  I: Integer;
begin
  Result := nil;
  IModuleServices := BorlandIDEServices as IOTAModuleServices;
  for I := 0 to IModuleServices.ModuleCount - 1 do
  begin
    IModule := IModuleServices.Modules[I];
    if IModule.QueryInterface(IOTAProjectGroup, IProjectGroup) = S_OK then
    begin
      Result := IProjectGroup;
      Break;
    end;
  end;
end;

function TJvPluginProjectCreator.GetOwner: IOTAModule;
begin
  Result := GetCurrentProjectGroup; // nil
end;

function TJvPluginProjectCreator.GetUnnamed: Boolean;
begin
  Result := True;
end;

//=== TJvOTAFile =============================================================

// TJvOTAFile - from Stefaan Lesage

constructor TJvOTAFile.Create(const Source: string);
begin
  FSource := Source;
end;

function TJvOTAFile.GetAge: TDateTime;
begin
  Result := -1; // new
end;

function TJvOTAFile.GetSource: string;
begin
  Result := FSource;
end;

procedure RegisterContainerModule;
begin
  RegisterCustomModule(TJvPlugin, TCustomModule);
end;

{ TJvPluginModuleCreator }

{*****************************************************************************
  Name           : TJvPluginModuleCreator.FormCreated
  Author         : Stefaan Lesage
  Arguments      : FormEditor - Interface to the IOTAFormEditor for the form
                                that has been created.
  Return Values  : None
  Exceptions     : None
  Description    : This method will be executed Called the new
                   form/datamodule/custom module is created.  We will use it
                   to initialise some properties on the TJvPluginDataModule.
  History        :

  Date         By                   Description
  ----         --                   -----------
  11/07/2003   slesage              Initial creation of the Method.
 *****************************************************************************}

procedure TJvPluginModuleCreator.FormCreated(
  const FormEditor: IOTAFormEditor);
begin
  with TJvPlugin( INTAComponent( FormEditor.GetRootComponent ).GetComponent ) do
  begin
    Author := PlugAuth;
    Description := PlugDesc;
    Copyright := PlugCopy;
    PluginID := PlugUID;
  end;
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.GetAncestorName
  Author         : Stefaan Lesage
  Arguments      : None
  Return Values  : The name of the Ancestor.
  Exceptions     : None
  Description    : Property Getter for the AncestorName property
  History        :

  Date         By                   Description
  ----         --                   -----------
  11/07/2003   slesage              Initial creation of the Method.
 *****************************************************************************}

function TJvPluginModuleCreator.GetAncestorName: string;
begin
  Result := 'JvPlugin';
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.GetCreatorType 
  Author         : Stefaan Lesage
  Arguments      : None
  Return Values  : Returns the type of the creator as a string.  In our case
                   it returns sForm since we create a DataModule / CustomForm.
  Exceptions     : None
  Description    : Property Getter for the CreatorType property.
  History        :

  Date         By                   Description
  ----         --                   -----------
  11/07/2003   slesage              Initial creation of the Method.
 *****************************************************************************}

function TJvPluginModuleCreator.GetCreatorType: string;
begin
  Result := sForm;
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.GetExisting 
  Author         : Stefaan Lesage
  Arguments      : None
  Return Values  : Returns a boolean indicating if this is an existing
                   module.  We return false since this is a new Module.
  Exceptions     : None
  Description    : Property Getter for the Existing property.
  History        :

  Date         By                   Description
  ----         --                   -----------
  11/07/2003   slesage              Initial creation of the Method.
 *****************************************************************************}

function TJvPluginModuleCreator.GetExisting: Boolean;
begin
  Result := False;
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.GetFileSystem 
  Author         : Stefaan Lesage
  Arguments      : None
  Return Values  : Return the File system IDString that this module uses for
                   reading/writing.  We return an empty string since our module
                   doesn't use a virtual file system.
  Exceptions     : None
  Description    : Property Getter for the FileSystem property.
  History        :

  Date         By                   Description
  ----         --                   -----------
  11/07/2003   slesage              Initial creation of the Method.
 *****************************************************************************}

function TJvPluginModuleCreator.GetFileSystem: string;
begin
  Result := '';
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.GetFormName 
  Author         : Stefaan Lesage
  Arguments      : None
  Return Values  : Returns the name of the form ( not the class, but its
                   actual name property ).  We will make sure that each
                   plugin module always gets the Plugin prefix before its
                   name.
  Exceptions     : None
  Description    : Property getter for the FormName property.
  History        :                                                          
                                                                            
  Date         By                   Description                                    
  ----         --                   -----------                                    
  11/07/2003   slesage              Initial creation of the Method.                  
 *****************************************************************************}

function TJvPluginModuleCreator.GetFormName: string;
begin
  Result := 'Plugin' + PlugName;
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.GetImplFileName 
  Author         : Stefaan Lesage
  Arguments      : None                                                     
  Return Values  : Returns the complete path to the implementation ( source )
                   file name, e.g. �C:\dir\Unit1.pas�. If GetUnnamed returns
                   true, the file name is just a placeholder, and the user
                   will be prompted for a file name when the file is saved.                                                     
  Exceptions     : None
  Description    : Property getter for the ImplFileName property.
  History        :

  Date         By                   Description
  ----         --                   -----------
  11/07/2003   slesage              Initial creation of the Method.
 *****************************************************************************}

function TJvPluginModuleCreator.GetImplFileName: string;
begin
  Result := GetCurrentDir + cDirSep + cPluginPrefix + PlugName + '.pas'
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.GetIntfFileName
  Author         : Stefaan Lesage
  Arguments      : None
  Return Values  : Return the interface filename, or blank to have the IDE
                   create a new unique one.
  Exceptions     : None
  Description    : Property getter for the IntfFileName property.
  History        :                                                          
                                                                            
  Date         By                   Description                                    
  ----         --                   -----------
  11/07/2003   slesage              Initial creation of the Method.                  
 *****************************************************************************}

function TJvPluginModuleCreator.GetIntfFileName: string;
begin
  Result := '';
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.GetMainForm
  Author         : Stefaan Lesage
  Arguments      : None
  Return Values  : Returns true if the newly created form is to be the
                   application�s main form. It returns false if the form
                   is not necessarily the main form.
  Exceptions     : None
  Description    : Property getter for the MainForm property.                                                          
  History        :

  Date         By                   Description
  ----         --                   -----------
  11/07/2003   slesage              Initial creation of the Method.
 *****************************************************************************}

function TJvPluginModuleCreator.GetMainForm: Boolean;
begin
  Result := False;
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.GetOwner 
  Author         : Stefaan Lesage
  Arguments      : None                                                     
  Return Values  : Returns the module interface of the new module�s owner,
                   that is, it returns the project interface for a new source
                   file or the project group interface for a new project.
                   You can create a module that does not have an owner by
                   returning 0.
                   In our case we will return the Active ProjectGroup's
                   Active Project.
  Exceptions     : None
  Description    : Property getter for the Owner property.                                                          
  History        :                                                          
                                                                            
  Date         By                   Description                                    
  ----         --                   -----------                                    
  11/07/2003   slesage              Initial creation of the Method.                  
 *****************************************************************************}

function TJvPluginModuleCreator.GetOwner: IOTAModule;
var
  ModuleServices : IOTAModuleServices;
  Module         : IOTAModule;
  NewModule      : IOTAModule;
begin
  // You may prefer to return the project group's ActiveProject instead
  Result := nil;
  ModuleServices := (BorlandIDEServices as IOTAModuleServices);
  Module := ModuleServices.CurrentModule;

  if Module <> nil then
  begin
    if Module.QueryInterface(IOTAProject, NewModule) = S_OK then
      Result := NewModule

    {$IFDEF VER130} // Delphi 5
    else if Module.GetOwnerCount > 0 then
    begin
      NewModule := Module.GetOwner(0);
    {$ELSE not VER_140} // Delphi 6+
    else if Module.OwnerModuleCount > 0 then
    begin
      NewModule := Module.OwnerModules[0];
    {$ENDIF}
      if NewModule <> nil then
        if NewModule.QueryInterface(IOTAProject, Result) <> S_OK then
          Result := nil;
    end;
  end
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.GetShowForm 
  Author         : Stefaan Lesage
  Arguments      : None                                                     
  Return Values  : Returns true if you want the IDE to show the form editor
                   after the form is created. Have GetShowForm returns false
                   to keep the form hidden.
  Exceptions     : None
  Description    : Property getter for the ShowForm property.
  History        :

  Date         By                   Description
  ----         --                   -----------
  11/07/2003   slesage              Initial creation of the Method.
 *****************************************************************************}

function TJvPluginModuleCreator.GetShowForm: Boolean;
begin
  Result := True;
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.GetShowSource
  Author         : Stefaan Lesage
  Arguments      : None
  Return Values  : Returns true if you want the IDE to show the source file
                   in the source editor. Have GetShowSource return false to
                   keep the source file hidden.
  Exceptions     : None
  Description    : Property getter for the ShowSource property.
  History        :
                                                                            
  Date         By                   Description                                    
  ----         --                   -----------                                    
  11/07/2003   slesage              Initial creation of the Method.                  
 *****************************************************************************}

function TJvPluginModuleCreator.GetShowSource: Boolean;
begin
  Result := True;
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.GetUnnamed 
  Author         : Stefaan Lesage
  Arguments      : None                                                     
  Return Values  : Returns true if the new module has not been saved to a
                   file and therefore does not have a file name yet. If the
                   user saves the module, the user will be prompted for a
                   file name. GetUnnamed returns false if the module has a
                   file name.                                                     
  Exceptions     : None
  Description    : Property Getter for the Unnamed property.                                                         
  History        :                                                          
                                                                            
  Date         By                   Description                                    
  ----         --                   -----------                                    
  11/07/2003   slesage              Initial creation of the Method.                  
 *****************************************************************************}

function TJvPluginModuleCreator.GetUnnamed: Boolean;
begin
  Result := True;
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.NewFormFile 
  Author         : Stefaan Lesage
  Arguments      : FormIdent     - The name of the form. Use this to
                                   parameterize the form description.
                   AncestorIdent - The name of the ancestor form. Use this to
                                   parameterize the form description.
  Return Values  : Returns an instance of a file creator class that you must
                   write, deriving from IOTAFile. If you return 0,
                   a default form will be created.

  Exceptions     : None
  Description    : NewFormFile returns the new form description or 0 to use
                   the default form description. The form description must be
                   binary or text form resource.
  History        :

  Date         By                   Description
  ----         --                   -----------
  11/07/2003   slesage              Initial creation of the Method.
 *****************************************************************************}

function TJvPluginModuleCreator.NewFormFile(const FormIdent,
  AncestorIdent: string): IOTAFile;
begin
  Result := Nil;
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.NewImplSource
  Author         : Stefaan Lesage
  Arguments      : ModuleIdent   - The ModuleIdent parameter is the name of
                                   the unit or module, e.g., �Unit1�. Use
                                   this to parameterize the file contents.
                   FormIdent     - The FormIdent parameter is the name of
                                   the form. Use this to parameterize the
                                   file contents.
                   AncestorIdent - The AncestorIdent parameter is the name
                                   of the ancestor form. Use this to
                                   parameterize the file contents
  Return Values  : Returns an instance of a file creator class that you must
                   write, deriving from IOTAFile. If you return 0,
                   a default form will be created.

  Exceptions     : None
  Description    : NewImplSource returns the source code for the new
                   module�s implementation or 0 for a default unit.
  History        :

  Date         By                   Description
  ----         --                   -----------
  11/07/2003   slesage              Initial creation of the Method.
 *****************************************************************************}

function TJvPluginModuleCreator.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
var
  TypeName: string;
  Ancestor: string;
  Source  : String;

  aPluginClassName : String;
begin
  aPluginClassName := 'T' + FormIdent;

  TypeName := FormIdent;
  Ancestor := AncestorIdent;

  TypeName := PlugName;

  Source := 'unit ' + ModuleIdent + ';' + CrLf + CrLf +

  'interface' + CrLf + CrLf +

  'uses' + CrLf +
    '  Windows, Messages, SysUtils, Classes, Dialogs, Forms,' + CrLf +
    '  Controls' + CrLf +
    '  JvPlugin;' + CrLf + CrLf +

  'type' + CrLf +
    '  ' + aPluginClassName + ' = class(T' + Ancestor + ')' + CrLf +
//    '  T' + TypeName + ' = class(T' + Ancestor + ')' + CrLf +
    '  private' + CrLf +
    '    { Private declarations }' + CrLf +
    '  public' + CrLf +
    '    { Public declarations }' + CrLf +
    '  end;' + CrLf + CrLf +

//  'function RegisterPlugin: T' + TypeName + '; stdcall;' + CrLf + CrLf;
  'function RegisterPlugin: TJvPlugin; stdcall;' + CrLf + CrLf;

  { 0 = dll; 1 = dpk }
  if PlugType <> 0 then
    Source := Source + 'exports RegisterPlugin;' + CrLf + CrLf;

  Source := Source +
    'implementation' + CrLf + CrLf +

  '{$R *.DFM}' + CrLf + CrLf +

  '// IMPORTANT NOTE: If you change the name of the Plugin container,' + CrLf +
    '// you must set the type below to the same type. (Delphi changes' + CrLf +
    '// the declaration, but not the procedure itself. Both the return' + CrLf +
    '// type and the type created must be the same as the declared type above.' + CrLf +
    'function RegisterPlugin: TJvPlugin;' + CrLf + CrLf +
    'begin' + CrLf +
    '  Result := ' + aPluginClassName + '.Create(nil);' + CrLf +
//    '  Result := T' + TypeName + '.Create(nil);' + CrLf +
    'end;' + CrLf + CrLf +

  'end.';

  Result := TJvOTAFile.Create( Source );
end;

{*****************************************************************************
  Name           : TJvPluginModuleCreator.NewIntfSource
  Author         : Stefaan Lesage
  Arguments      : ModuleIdent   - The ModuleIdent parameter is the name of
                                   the unit or module, e.g., �Unit1�. Use
                                   this to parameterize the file contents.
                   FormIdent     - The FormIdent parameter is the name of
                                   the form. Use this to parameterize the
                                   file contents.
                   AncestorIdent - The AncestorIdent parameter is the name
                                   of the ancestor form. Use this to
                                   parameterize the file contents
  Return Values  : Returns an instance of a file creator class that you must
                   write, deriving from IOTAFile. If you return 0,
                   a default form will be created.

  Exceptions     : None
  Description    : NewIntfSource returns the source code for the new module�s
                   interface or 0 for a default header.
  History        :
                                                                            
  Date         By                   Description                                    
  ----         --                   -----------                                    
  11/07/2003   slesage              Initial creation of the Method.                  
 *****************************************************************************}

function TJvPluginModuleCreator.NewIntfSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
begin
  Result := Nil;
end;

initialization
  RegisterContainerModule;

end.

