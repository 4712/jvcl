{**************************************************************************************************}
{  WARNING:  JEDI preprocessor generated unit. Manual modifications will be lost on next release.  }
{**************************************************************************************************}

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvProgressBar.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is S�bastien Buysse [sbuysse@buypin.com]
Portions created by S�bastien Buysse are Copyright (C) 2001 S�bastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck@bigfoot.com].

Last Modified: 2004-01-06

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvQProgressBar;

interface

uses
  SysUtils, Classes,
  
  
  QGraphics, QControls, QForms, QComCtrls,
  
  JvQExComCtrls;

type
  TJvProgressBar = class(TJvExProgressBar)
  private
  
  public
    constructor Create(AOwner: TComponent); override;
  published
    
    
    property FillColor default clHighlight;
    
    property HintColor;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnParentColorChange;
    property Color;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

implementation

constructor TJvProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FillColor := clHighlight;
end;



end.

