#--------------------------------------------------------------------------------------------------#
#                                                                                                  #
# devtools                                                                                         #
#                                                                                                  #
#--------------------------------------------------------------------------------------------------#

!ifndef ROOT
ROOT = $(MAKEDIR)\..
!endif

!ifndef JCLROOT
JCLROOT = ..\..\..\jcl
!endif

.path.exe=bin

#---------------------------------------------------------------------------------------------------
SRC = ..\..\Run
ARCH = ..\..\Archive
COM = ..\Common;..\..\Common
BIN = ..\Bin
DCU = ..\Dcu
JCL = $(JCLROOT)\source;$(JCLROOT)\source\common;$(JCLROOT)\source\windows;$(JCLROOT)\source\vcl;$(JCLROOT)\source\visclx
DRC = $&.drc
SRCP = $(SRC);$(COM);$(JCL);$(ARCH);$(DCU)
SRCH = ..\$(SRC);..\$(COM);..\$(JCL);..\$(ARCH);..\$(DCU)
#---------------------------------------------------------------------------------------------------
MAKE = "$(ROOT)\bin\make.exe" -$(MAKEFLAGS) -f$**
DCC  = "$(ROOT)\bin\dcc32.exe" -e"$(BIN)" -i"$(SRCP)" -n"$(DCU)" -r"$(SRCP)" -u"$(SRCP)" -u"$(ROOT)\Lib\Obj" -q -w -h -m
DCCx = "$(ROOT)\bin\dcc32.exe" -Q -M
DCCH = "$(ROOT)\bin\dcc32.exe" -e"..\$(BIN)" -i"$(SRCH)" -n"..\$(DCU)" -r"$(SRCH)" -u"$(SRCH)" -q -w -h -m
BRCC = "$(ROOT)\bin\brcc32.exe" $**
#---------------------------------------------------------------------------------------------------
default: \
isu.exe \
JConvert.exe \
JVCLConvert.exe \
JTouch.exe \
crlf.exe \
MakeDOF.exe \
MakeCFG.exe \
Bpg2Make.exe \
MakeRC.exe \
dc.exe \
NoQuotes.exe \
SetPoHeader.exe \
pg.exe \
pgEdit.exe \
LastModifyRepl.exe \
ErrLook.exe \
MakePNG.exe \
Res2BMP.exe \
stripCmtPO.exe \
dxgettextResstr.exe \
pg2want.exe

#---------------------------------------------------------------------------------------------------

isu.exe: ITEStrip\isu.dpr
  cd ITEStrip
  $(DCC) $&.dpr
  cd ..

MakeRC.exe: MakeRC\MakeRC.dpr \
		MakeRC\MakeRCUtils.pas
  cd MakeRC
  $(DCC) $&.dpr
  cd ..

jconvert.exe: JConvert\jconvert.dpr \
		JConvert\JConvertUtils.pas
  cd JConvert
  $(DCC) $&.dpr
  cd ..

MakeDOF.exe: MakeDOF\MakeDOF.dpr \
		MakeDOF\MakeDOFUtils.pas
  cd MakeDOF
  $(DCC) $&.dpr
  cd ..

MakeCFG.exe: MakeCFG\MakeCFG.dpr \
		MakeCFG\MakeCFGUtils.pas
  cd MakeCFG
  $(DCC) $&.dpr
  cd ..

Bpg2Make.exe: Bpg2Make\Bpg2Make.dpr \
		Bpg2Make\Bpg2MakeUtils.pas
  cd Bpg2Make
  @type &&|
-e"$(BIN)"
-i"$(SRCP)"
-n"$(DCU)"
-r"$(SRCP)"
-u"$(SRCP)"
-u"$(ROOT)\Lib\Obj"
| >Bpg2Make.cfg
  $(DCCx) Bpg2Make.dpr
  -@del Bpg2Make.cfg >NUL 2>NUL
  -@del Make*.@@@ >NUL 2>NUL
  cd ..

jtouch.exe: JTouch\jtouch.dpr \
		JTouch\JTouchUtils.pas
  cd JTouch
  $(DCC) $&.dpr
  cd ..

crlf.exe: JvAdjustLineBreaks\crlf.dpr \
		JvAdjustLineBreaks\crlfutils.pas
  cd JvAdjustLineBreaks
  $(DCC) $&.dpr
  cd ..

stripCmtPO.exe: stripCmtPO\stripCmtPO.dpr \
		stripCmtPO\stripUtils.pas
  cd stripCmtPO
  $(DCC) $&.dpr
  cd ..

dxgettextResstr.exe: dxgettextResstr\dxgettextResstr.dpr
  cd dxgettextResstr
  $(DCC) $&.dpr
  cd ..

dc.exe: DFMCleaner\dc.dpr \
		DFMCleaner\dcUtils.pas
  cd DFMCleaner
  $(DCC) $&.dpr
  cd ..

pg.exe: PackagesGenerator\pg.dpr \
		PackagesGenerator\CmdLineUtils.pas \
		PackagesGenerator\FileUtils.pas \
		PackagesGenerator\GenerateUtils.pas
  @cd PackagesGenerator
  @type &&|
-e"$(BIN)"
-i"$(SRCP)"
-n"$(DCU)"
-r"$(SRCP)"
-u"$(SRCP)"
-u"$(ROOT)\Lib\Obj"
| >pg.cfg
  $(DCCx) -DNO_JCL pg.dpr
  -@del pg.cfg >NUL 2>NUL
  -@del Make*.@@@ >NUL 2>NUL
  @cd ..

pgEdit.exe: PackagesGenerator\pgEdit.dpr \
		PackagesGenerator\AdvancedBCBForm.pas \
		PackagesGenerator\CmdLineUtils.pas \
		PackagesGenerator\CmdLineUtils.pas \
		PackagesGenerator\FileUtils.pas \
		PackagesGenerator\FormTypeDialog.pas \
		PackagesGenerator\GenerateUtils.pas \
		PackagesGenerator\GenerationMessagesForm.pas \
		PackagesGenerator\KnownTagsForm.pas \
		PackagesGenerator\MainForm.pas \
		PackagesGenerator\ModelsForm.pas \
		PackagesGenerator\TargetDialog.pas \
		PackagesGenerator\UtilsJcl.pas
  cd PackagesGenerator
  @type &&|
-e"$(BIN)"
-i"$(SRCP)"
-n"$(DCU)"
-r"$(SRCP)"
-u"$(SRCP)"
-u"$(ROOT)\Lib\Obj"
| >pgEdit.cfg
  $(DCCx) pgEdit.dpr
  -@del pgEdit.cfg >NUL 2>NUL
  -@del Make*.@@@ >NUL 2>NUL
  @cd ..

NoQuotes.exe: NoQuotes\NoQuotes.dpr
  cd NoQuotes
  $(DCC) $&.dpr
  cd ..

SetPoHeader.exe: SetPoHeader\SetPoHeaderUtils.pas \
		SetPoHeader\SetPoHeader.dpr
  cd SetPoHeader
  @echo.
  @echo.
  $(DCC) SetPoHeader.dpr
  cd ..


JVCLConvert.exe: JVCLConvert\JVCLConvert.dpr \
		JVCLConvert\fAboutMe.pas \
		JVCLConvert\fAboutMe.pas \
		JVCLConvert\FastTime.pas \
		JVCLConvert\fJvclConverterMain.pas \
		JVCLConvert\JVCLConvertUtils.pas \
		JVCLConvert\OptionsFrm.pas
  cd JVCLConvert
  @echo.
  @echo.
  $(DCC) $&.dpr
  cd ..
  
# these are put last because they are most likely to fail
ErrLook.exe: ErrLook\src\ErrLook.dpr
  cd ErrLook\src
  @echo.
  @echo.
  $(DCCH) $&.dpr
  cd ..\..

MakePNG.exe: MakePNG\MakePNG.dpr
  cd MakePNG
  @echo.
  @echo.
  $(DCC) $&.dpr
  cd ..

Res2Bmp.exe: Res2Bmp\Res2Bmp.dpr
  cd Res2Bmp
  @echo.
  @echo.
  $(DCC) $&.dpr
  cd ..

pg2want.exe: pg2want\pg2want.dpr
  cd pg2want
  @echo.
  @echo.
  $(DCC) $&.dpr
  cd ..

LastModifyRepl.exe: LastModifyRepl\LastModifyRepl.dpr \
		LastModifyRepl\LastModifyReplUtil.pas
  cd LastModifyRepl
  @echo.
  @echo.
  $(DCC) $&.dpr
  cd ..
