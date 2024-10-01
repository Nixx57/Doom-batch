@ECHO off
setlocal enabledelayedexpansion
::-----------------------------SETUP--------------------------------------

set "iwad=doom2.wad"
set "pwad[0]=hr2final.wad"
set "pwad[1]="
set "pwad[2]="

set "deh="

:: Play / Record / PlayDemo / Warp / VidDump
set "action=warp" 

::complevel  2 : Doom 2 | 3 : Ultimate Doom | 4 : Final Doom | 9 : Boom | 11 : MBF | 21 : MBF21
set "complevel=2"

set "additionalParameters="

:: PlayDemo / Record params
set "nameRecord=demo" #Demo name (Record)
set playdemopath="" #(Play Demo)

:: Warp / Record params
set "skill=4"
set "warp=32"

::-----------------------------FILES PATH-------------------------------------

set "sourceport=C:\Users\Tonton Panzer\Desktop\RetroFPS\DOOM\BOOM\DSDADOOM okversion\" # Source port folder
set "executable=dsda-doom.exe"
set "iwadspath=C:\Users\Tonton Panzer\Desktop\RetroFPS\DOOM\BOOM\DSDADOOM okversion\" # Doom.wad / Doom2.wad folder
set "wadspath=C:\Users\Tonton Panzer\Desktop\RetroFPS\DOOM\BOOM\DSDADOOM okversion\" # Wads path

::-----------------------------SCRIPT : DO NOT MODIFY---------------------
cd "%sourceport%"

set iwad="%iwadspath%%iwad%"
set "files="
set /A i = 0

FOR /F "delims=|" %%A IN ("%iwad%") DO (
    SET SOMEFILE=%%~nxA
)
ECHO IWAD = %SOMEFILE%

:my_loop 
    if defined pwad[%i%]  (
        if defined files (
            set files=%files% "%wadspath%!pwad[%i%]!"
        ) else (
            set files="%wadspath%!pwad[%i%]!"
        )
        call ECHO PWAD = %%pwad[%i%]%%
        set /a i = %i% + 1
        goto :my_loop
    )

if defined deh  (
    if defined files (
        set files=%files% -deh "%wadspath%%deh%"
    ) else (
        set files=-deh "%wadspath%%deh%"
    )
    call ECHO DEH = %deh%
)

set path=.\%nameRecord%\
if not exist "%path%" (mkdir "%path%")
set record="%path%%nameRecord%"

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
