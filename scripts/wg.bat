@echo off
setlocal

:: Read the first argument (converted to lowercase logic handling below)
set "CMD=%~1"
set "PARAM=%~2"

:: Check for no arguments
if "%CMD%"=="" goto usage

:: Route commands
if /i "%CMD%"=="list" goto do_list
if /i "%CMD%"=="ls" goto do_list
if /i "%CMD%"=="search" goto do_search
if /i "%CMD%"=="find" goto do_search
if /i "%CMD%"=="install" goto do_install
if /i "%CMD%"=="i" goto do_install
if /i "%CMD%"=="uninstall" goto do_uninstall
if /i "%CMD%"=="remove" goto do_uninstall
if /i "%CMD%"=="upgrade" goto do_upgrade
if /i "%CMD%"=="up" goto do_upgrade
if /i "%CMD%"=="info" goto do_info
if /i "%CMD%"=="show" goto do_info
if /i "%CMD%"=="export" goto do_export
if /i "%CMD%"=="import" goto do_import
if /i "%CMD%"=="help" goto usage
if /i "%CMD%"=="-h" goto usage
if /i "%CMD%"=="--help" goto usage

:: Unknown command handler
echo [ERROR] Unknown command: %CMD%
echo.
goto usage

:: --- Command Implementations ---

:do_list
echo [+] Listing installed packages matching: %PARAM%
if "%PARAM%"=="" (
    winget list
) else (
    winget list --query "%PARAM%"
)
goto end

:do_search
if "%PARAM%"=="" (
    echo [ERROR] Missing search term. Usage: wg search ^<app_name^>
    goto end
)
echo [+] Searching repository for: %PARAM%
winget search --query "%PARAM%"
goto end

:do_install
if "%PARAM%"=="" (
    echo [ERROR] Missing package name. Usage: wg install ^<app_name^>
    goto end
)
echo [+] Installing %PARAM% (accepting source/package agreements)...
winget install --id "%PARAM%" --exact --accept-package-agreements --accept-source-agreements
if errorlevel 1 (
    echo [!] Exact ID match failed, searching generic query...
    winget install --query "%PARAM%" --accept-package-agreements --accept-source-agreements
)
goto end

:do_uninstall
if "%PARAM%"=="" (
    echo [ERROR] Missing package name. Usage: wg uninstall ^<app_name^>
    goto end
)
echo [+] Uninstalling %PARAM%...
winget uninstall --query "%PARAM%"
goto end

:do_upgrade
if "%PARAM%"=="" (
    echo [+] Upgrading ALL installed packages...
    winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements
) else (
    echo [+] Upgrading %PARAM%...
    winget upgrade --query "%PARAM%" --accept-package-agreements --accept-source-agreements
)
goto end

:do_info
if "%PARAM%"=="" (
    echo [ERROR] Missing package name. Usage: wg info ^<app_name^>
    goto end
)
echo [+] Displaying details for: %PARAM%
winget show --query "%PARAM%"
goto end

:do_export
set "OUT_FILE=%PARAM%"
if "%OUT_FILE%"=="" set "OUT_FILE=winget-packages.json"
echo [+] Exporting package list to %OUT_FILE%...
winget export -o "%OUT_FILE%"
goto end

:do_import
set "IN_FILE=%PARAM%"
if "%IN_FILE%"=="" set "IN_FILE=winget-packages.json"
echo [+] Importing and installing packages from %IN_FILE%...
winget import -i "%IN_FILE%" --ignore-unavailable --accept-package-agreements --accept-source-agreements
goto end

:usage
echo Winget Wrapper Utility (wg.bat)
echo.
echo Usage: wg ^<command^> [parameter]
echo.
echo Commands:
echo   list, ls [query]     List installed packages (optionally filter by name)
echo   search, find ^<term^> Search the Winget repository for packages
echo   install, i ^<id^>    Install a package (auto-accepts agreements)
echo   uninstall, remove ^<id^> Uninstall a package
echo   upgrade, up [id]     Upgrade all apps (default) or a specific app
echo   info, show ^<id^>     Show detailed information about a package
echo   export [file.json]   Export installed packages to JSON (default: winget-packages.json)
echo   import [file.json]   Import and install packages from JSON (default: winget-packages.json)
echo.

:end
endlocal