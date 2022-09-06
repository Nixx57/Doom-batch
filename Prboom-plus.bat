@echo off
setlocal enabledelayedexpansion

::-----------------------------SETUP--------------------------------------

set "iwad=Doom2.WAD"
set "pwad[0]=btsx_e2a.wad"
set "pwad[1]=btsx_e2b.wad"
set "pwad[2]="

set "deh=btsx_e2.deh"

::complevel  2 : Doom 2 | 3 : Ultimate Doom | 4 : Final Doom | 9 : Boom | 11 : MBF | 21 : MBF21
set "complevel=2"

set "action=play" # Play / Record / PlayDemo

set "additionalParameters="

::------------- PlayDemo / Record ONLY
set "name=demo" #Demo name (record)
set playdemopath="C:\Users\rinam\OneDrive\Bureau\tv01-050.lmp" #(play demo)
set "skill=4"
set "warp=1"

::-----------------------------FILES PATH-------------------------------------

set "sourceport=C:\Users\%USERNAME%\OneDrive\Documents\Doom\Source port\PrBoom+\" # Source port folder
set "iwadspath=C:\Users\%USERNAME%\OneDrive\Documents\Doom\WAD\" # Doom.wad / Doom2.wad folder
set "wadspath=C:\Users\%USERNAME%\OneDrive\Documents\Doom\WAD\wads\" # Wads path

::-----------------------------SCRIPT : DO NOT MODIFY---------------------
cd %sourceport%

set iwad=%iwadspath%%iwad%
set "files="
set /A i = 0

:my_loop 
    if defined pwad[%i%]  (
        set files=%files%%wadspath%!pwad[%i%]! 
        call echo PWAD = %%pwad[%i%]%%
        set /a i = %i% + 1
        goto :my_loop
    )

if defined deh  (
  set files=%files%-deh %wadspath%%deh%
  call echo DEH = %deh%
)

set path=.\%name%\
if not exist "%path%" (mkdir "%path%")
set record=%path%%name%

FOR /F "delims=|" %%A IN ("%iwad%") DO (
    SET SOMEFILE=%%~nxA
)
ECHO IWAD = %SOMEFILE%

::-----------------------
CALL :CASE_%action%
IF ERRORLEVEL 1 CALL :DEFAULT_CASE

ECHO Done.
EXIT /B

:CASE_play
  @echo on
  prboom-plus.exe -iwad %iwad% -file %files% -complevel %complevel% %additionalParameters%
  GOTO END_CASE
:CASE_record
  @echo on
  prboom-plus.exe -iwad %iwad% -skill %skill% -warp %warp% -file %files% -longtics -record %record% -complevel %complevel% %additionalParameters%
  GOTO END_CASE
:CASE_playdemo
  @echo on
  prboom-plus.exe -iwad %iwad% -file %files% -playdemo %playdemopath% -complevel %complevel% %additionalParameters%
  GOTO END_CASE
:DEFAULT_CASE
  Unknown action "%action%"
  GOTO END_CASE
:END_CASE

if ERRORLEVEL 1 echo Error
