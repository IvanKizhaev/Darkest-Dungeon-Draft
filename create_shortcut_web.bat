@echo off
setlocal EnableExtensions

rem ================== НАСТРОЙКИ ==================
rem Имя файла (лежит рядом с этим .bat), на который создаём ярлык:
set "TARGET_NAME=v073_stable_web.html"

rem Имя ярлыка на рабочем столе (без .lnk):
set "SHORTCUT_NAME=Darkest Dungeon Draft v.0.7.3 (Web)"
rem ================================================

rem Папка, где находится сам .bat (с завершающим "\")
set "SCRIPT_DIR=%~dp0"

rem Полные пути
set "TARGET_FILE=%SCRIPT_DIR%%TARGET_NAME%"
set "ICON_FILE=%SCRIPT_DIR%ico\ico.ico"

rem Проверки
if not exist "%TARGET_FILE%" (
    echo [ОШИБКА] Файл не найден: "%TARGET_FILE%"
    pause
    exit /b 1
)
if not exist "%ICON_FILE%" (
    echo [ОШИБКА] Иконка не найдена: "%ICON_FILE%"
    pause
    exit /b 1
)

rem Создание ярлыка через PowerShell + WScript.Shell
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ws = New-Object -ComObject WScript.Shell; " ^
  "$desktop = [Environment]::GetFolderPath('Desktop'); " ^
  "$sc = $ws.CreateShortcut((Join-Path $desktop '%SHORTCUT_NAME%.lnk')); " ^
  "$sc.TargetPath = '%TARGET_FILE%'; " ^
  "$sc.WorkingDirectory = '%SCRIPT_DIR%'; " ^
  "$sc.IconLocation = '%ICON_FILE%'; " ^
  "$sc.Save(); " ^
  "exit 0"

if errorlevel 1 (
    echo [ОШИБКА] Не удалось создать ярлык.
    pause
    exit /b 1
)

rem Успех — окно закрывается само, без pause
endlocal
exit /b 0