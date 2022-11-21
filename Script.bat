@echo off
setlocal enabledelayedexpansion
::-----------------------------SETUP--------------------------------------

set "iwad=Doom2.wad"
set "pwad[0]=arrival.wad"
set "pwad[1]="
set "pwad[2]="

set "deh="

::complevel  2 : Doom 2 | 3 : Ultimate Doom | 4 : Final Doom | 9 : Boom | 11 : MBF | 21 : MBF21
set "complevel=2"

set "action=play" # Play / Record / PlayDemo / VidDump / Warp

set "additionalParameters="

:: PlayDemo / Record ONLY
set "name=MyFirstDemo" #Demo name (Record)
set playdemopath="C:\Users\MyDemo.lmp" #(play demo)
set "skill=4"
set "warp=3"

::-----------------------------FILES PATH-------------------------------------

set "sourceport=C:\Users\%USERNAME%\OneDrive\Documents\Doom\Source port\DSDA Doom\" # Source port folder
set "executable=dsda-doom.exe"
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
  Start %executable% -iwad %iwad% -file %files% -complevel %complevel% %additionalParameters%
  GOTO END_CASE
:CASE_warp
  @echo on
  Start %executable% -iwad %iwad% -file %files% -skill %skill% -warp %warp% -complevel %complevel% %additionalParameters%
  GOTO END_CASE
:CASE_record
  @echo on
  Start %executable% -iwad %iwad% -file %files% -skill %skill% -warp %warp% -longtics -record %record% -complevel %complevel% %additionalParameters%
  GOTO END_CASE
:CASE_playdemo
  @echo on
  Start %executable% -iwad %iwad% -file %files% -playdemo %playdemopath% -complevel %complevel% %additionalParameters%
  GOTO END_CASE
:CASE_viddump
  @echo on
  Start %executable% -iwad %iwad% -file %files% -timedemo %playdemopath% -warp %warp% -complevel %complevel% -viddump %name%.mp4 %additionalParameters%
:DEFAULT_CASE
  Unknown action "%action%"
  GOTO END_CASE
:END_CASE

if ERRORLEVEL 1 echo Error
