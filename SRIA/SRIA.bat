@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

@REM web站点路径，目前生产和订单一直，无需修改
set "dir_web_path=E:\NEWOOSWeb"
@REM 生产中心程序路径
set "prdservice_path=E:\OOS_Application"
@REM 订单中心程序路径
set "ordservice_path=E:\"
@REM jenkins服务器丢过来的压缩包存放路径
set "zip_path=E:\upDate"

set "foldersPrdWeb=EMOAPI MailWebService PSCDataSyncWebAPI"
set "foldersOrdWeb=DataTransAPI OOSWeb T100WebService"
set "foldersPrdService=InsertOrderDataService OOS_GeneratePack UpdateBaseDataService 状态回传"
set "existing_foldersPrdWeb="
set "existing_foldersOrdWeb="

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "today=%dt:~0,8%"
@REM 备份路径，以时间命名
set "backuppath=E:\autobackup\!today!"

set /a count_existing_foldersPrdWeb=0
set /a count_existing_foldersOrdWeb=0

@REM 收集符合生产中心特征的web站点
for %%f in (%foldersPrdWeb%) do (
    if exist "%dir_web_path%\%%f" (
        set "existing_foldersPrdWeb=!existing_foldersPrdWeb! %%f"
        set /a count_existing_foldersPrdWeb+=1
    )
)

@REM 收集符合订单中心特征的web站点
for %%f in (%foldersOrdWeb%) do (
    for /d %%d in ("%dir_web_path%\%%f*") do (
        echo %%d
        if exist "%%d" (
            set "existing_foldersOrdWeb=!existing_foldersOrdWeb! %%~nxd"
            set /a count_existing_foldersOrdWeb+=1
        )
    )
)
echo 侦测到生产中心web站点: !existing_foldersPrdWeb!
echo 侦测到订单中心web站点: !existing_foldersOrdWeb!

@REM 《《《《《《《《《《《《《主程序，通过web站点数来判定服务器类型，并做相应逻辑操作》》》》》》》》》》》》》》
if !count_existing_foldersPrdWeb! gtr !count_existing_foldersOrdWeb! (
    echo 生产中心
    for %%f in ("!zip_path!\*.rar") do (
        set "filename=%%~nf"
        echo !filename!
        for %%g in (!foldersPrdWeb!) do (
            if "!filename!"=="%%g" (
                echo %dir_web_path%\!filename!-------------------------------
                xcopy "%dir_web_path%\!filename!" "!backuppath!\!filename!" /E /I /H /Y 
            )
        )
    )
) else if !count_existing_foldersOrdWeb! gtr !count_existing_foldersPrdWeb! (
    echo 订单中心
    for %%f in ("!zip_path!\*.rar") do (
        set "filename=%%~nf"
        if "!filename:_=!"=="!filename!" (
            echo 处理所有品牌发布 !filename!
            for %%e in (!existing_foldersOrdWeb!) do (
                @REM echo filename:!filename!
                set "original=%%e"
                @REM echo !original!
                @REM DOS命令功能contain用不了下面是\\if "!original!" CONTAINS "!filename!"想识别original是否包含filename\\的替代方案
                for %%z in (!filename!) do (
                    if "!original:%%z=!" neq "!original!" (
                        echo ~~~~~~~~~~~~命中~~~~~~~~~~~~
                        echo 需要copy和覆盖的路径:%dir_web_path%\!original!
                        @REM xcopy "%dir_web_path%\!original!" "!backuppath!\!original!" /E /I /H /Y 
                        @REM 7z x "%%f" -o"%dir_web_path%\!original!" -y 
                    )
                )
            )
        ) else (
            echo 处理单一品牌发布 !filename!
            for %%e in (!existing_foldersOrdWeb!) do (
                set "original=%%e"
                if "%%e" == "!filename!" (
                    echo "需要copy和覆盖的路径:%dir_web_path%\!original!"-----------------
                    xcopy "%dir_web_path%\!original!" "!backuppath!\!original!" /E /I /H /Y 
                    @REM 7z x "%%f" -o"%dir_web_path%\!original!" -y 
                )
            )
        )
    )
) else (
    echo 此服务器不属于订单中心或生产中心
)

endlocal