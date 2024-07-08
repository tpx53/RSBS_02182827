@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

set "dir_web_path=E:\NEWOOSWeb"
set "dir_service_path=E:\OOS_Application"
set "zip_path=E:\upDate"
set "output_path="

set "foldersPrdWeb=Da OOS T1"
set "foldersOrdWeb=DataTransAPI OOSWeb T100WebService"

@REM for %%e in (!foldersPrdWeb!) do (
@REM     set "filename=%%e"
@REM     echo filename:!filename!
@REM     for %%d in (!foldersOrdWeb!) do (
@REM         set "newasasa=%%d"
@REM         @REM echo !newasasa!
@REM         set "found=false"
@REM         for %%f in (!filename!) do (
@REM             if "!newasasa:%%f=!" neq "!newasasa!" (
@REM                 set "found=true"
@REM                 echo !newasasa:%%f=!--------------------
@REM             )
@REM             echo 跑了一遍
@REM         )
@REM     )
@REM )

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "today=%dt:~0,8%"
md "C:\backup\%today%"
echo "C:\backup\%today%"