@echo off
: ---------------------------------------------------------------------
:    WARNING   WARNING    WARNING    WARNING    WARNING    WARNING
:
: Please read the help before using this batch file as there are
: some compulsory parameters
:
: ---------------------------------------------------------------------
if %1!==! goto help

MakeBCB "BCB6 Packages" Bcb6 %1

goto end

:help
echo MakeBCB6.bat - Builds the JVCL for BCB6
echo.
echo Usage:    MakeBCB6 BCBDirectory [JCLDirectory] [LIBDirectory] [BPLDirectory]
echo.
echo     BCBDirectory   The place where BCB6 is installed.
echo                    e.g. "C:\Program Files\CBuilder6"
echo     JCLDirectory   The place where the JCL is installed. You must specify 
echo                    this value if the JCL is not in ..\..\JCL
echo     LIBDirectory   The place where to put the BPI and LIB files.
echo                    Defaults to $(BCB)\Projects\Lib
echo                    You MUST ensure that this directory is in the
echo                    PATH environment variable
echo     BPLDirectory   The place where to put the BPL and TDS files.
echo                    Defaults to $(BCB)\Projects\Bpl
echo.
echo Any additional argument will be ignored
echo.
:end

