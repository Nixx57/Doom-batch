@ECHO off
setlocal enabledelayedexpansion
::-----------------------------SETUP--------------------------------------

set "iwad=Doom2.wad"
set "pwad[0]=KDiKDi_A.wad"
set "pwad[1]=KDiKDi_B.wad"
set "pwad[2]="

set "deh=kdikdizd.deh"

:: Play / Record / PlayDemo / Warp / VidDump
set "action=play" 

::complevel  2 : Doom 2 | 3 : Ultimate Doom | 4 : Final Doom | 9 : Boom | 11 : MBF | 21 : MBF21
set "complevel=2"

set "additionalParameters="

:: PlayDemo / Record params
set "nameRecord=demoName" #Demo name (Record)
set playdemopath="C:\Users\%USERNAME%\OneDrive\Bureau\doom-max-movie-2295069.lmp" #(Play Demo)

:: Warp / Record params
set "skill=4"
set "warp=13"

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

FOR /F "delims=|" %%A IN ("%iwad%") DO (
    SET SOMEFILE=%%~nxA
)
ECHO IWAD = %SOMEFILE%

:my_loop 
    if defined pwad[%i%]  (
        set files=%files%%wadspath%!pwad[%i%]! 
        call ECHO PWAD = %%pwad[%i%]%%
        set /a i = %i% + 1
        goto :my_loop
    )

if defined deh  (
  set files=%files%-deh %wadspath%%deh%
  call ECHO DEH = %deh%
)

set path=.\%nameRecord%\
if not exist "%path%" (mkdir "%path%")
set record=%path%%nameRecord%

if defined files (
  set files=-file %files%
)

if defined complevel (
    set complevel=-complevel %complevel%
)
::------------------------------------------------------------------------

CALL :CASE_%action%
IF ERRORLEVEL 1 CALL :DEFAULT_CASE

ECHO Done.
EXIT /B

:CASE_play
  ECHO Parameters : %complevel% %additionalParameters%
  ECHO --------------------
  ECHO %executable% -iwad %iwad% %files% %complevel% %additionalParameters%
  pause
  Start %executable% -iwad %iwad% %files% %complevel% %additionalParameters%
  GOTO END_CASE
:CASE_warp
  ECHO Parameters : -skill %skill% -warp %warp% %complevel% %additionalParameters%
  ECHO --------------------
  ECHO %executable% -iwad %iwad% %files% -skill %skill% -warp %warp% %complevel% %additionalParameters%
  pause
  Start %executable% -iwad %iwad% %files% -skill %skill% -warp %warp% %complevel% %additionalParameters%
  GOTO END_CASE
:CASE_record
  ECHO Parameters : -skill %skill% -warp %warp% -record %record% %complevel% %additionalParameters%
  ECHO --------------------
  ECHO %executable% -iwad %iwad% %files% -skill %skill% -warp %warp% -record %record% %complevel% %additionalParameters%
  pause
  Start %executable% -iwad %iwad% %files% -skill %skill% -warp %warp% -record %record% %complevel% %additionalParameters%
  GOTO END_CASE
:CASE_playdemo
  ECHO Parameters : -playdemo %playdemopath% %additionalParameters%
  ECHO --------------------
  ECHO %executable% -iwad %iwad% %files% -playdemo %playdemopath% %additionalParameters%
  pause
  Start %executable% -iwad %iwad% %files% -playdemo %playdemopath% %additionalParameters%
  GOTO END_CASE
:CASE_viddump
  ECHO Parameters : -timedemo %playdemopath% -warp %warp% %complevel% -viddump %name%.mp4 %additionalParameters%
  ECHO --------------------
  ECHO %executable% -iwad %iwad% %files% -timedemo %playdemopath% -warp %warp% %complevel% -viddump %name%.mp4 %additionalParameters%
  pause
  Start %executable% -iwad %iwad% %files% -timedemo %playdemopath% -warp %warp% %complevel% -viddump %name%.mp4 %additionalParameters%
:DEFAULT_CASE
  Unknown action "%action%"
  GOTO END_CASE
:END_CASE

if ERRORLEVEL 1 ECHO Error
