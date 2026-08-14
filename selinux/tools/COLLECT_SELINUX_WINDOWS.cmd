@echo off
setlocal EnableExtensions DisableDelayedExpansion
set "ROOT=%~dp0"
set "COLLECTOR=%ROOT%collect_selinux_ims.sh"
set "STAGE=%~1"
set "MODE=%~2"
if not defined STAGE set "STAGE=manual"
if not defined MODE set "MODE=collect"

where adb.exe >nul 2>&1
if errorlevel 1 (
    echo ERROR: adb.exe is unavailable.
    exit /b 2
)
if not exist "%COLLECTOR%" (
    echo ERROR: collector missing: %COLLECTOR%
    exit /b 2
)
if /I not "%MODE%"=="arm" if /I not "%MODE%"=="collect" (
    echo Usage: %~nx0 STAGE arm^|collect
    exit /b 2
)

adb push "%COLLECTOR%" /sdcard/collect_selinux_ims.sh
if errorlevel 1 exit /b 2
adb shell su -c "chmod 755 /sdcard/collect_selinux_ims.sh"
if errorlevel 1 exit /b 2

if /I "%MODE%"=="arm" (
    adb shell su -c "sh /sdcard/collect_selinux_ims.sh %STAGE% arm"
    if errorlevel 1 (
        echo ERROR: SELinux audit arm failed. No workload was run.
        exit /b 2
    )
    echo SELinux audit armed for stage %STAGE%.
    echo Keep the device booted and run the workload, then invoke:
    echo %~nx0 %STAGE% collect
    exit /b 0
)

adb shell su -c "sh /sdcard/collect_selinux_ims.sh %STAGE% collect"
if errorlevel 1 (
    echo ERROR: SELinux evidence collection failed or audit was not armed.
    exit /b 2
)
for /f "usebackq delims=" %%I in (`adb shell su -c "cat /sdcard/s20volte_selinux_latest.txt"`) do set "REMOTE=%%I"
if not defined REMOTE (
    echo ERROR: collector did not publish an output path.
    exit /b 2
)
adb pull "%REMOTE%" "%ROOT%evidence\"
if errorlevel 1 exit /b 2
echo Evidence collected for stage %STAGE%.
echo Evidence collection does not require dontaudit stripping; avc_coverage.txt records whether stripping succeeded.
exit /b 0
