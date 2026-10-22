@echo off
setlocal

set "PROJECT_DIR=%~dp0"
if "%PROJECT_DIR:~-1%"=="\" set "PROJECT_DIR=%PROJECT_DIR:~0,-1%"

if not defined GEODE_SDK (
    if exist "%USERPROFILE%\Documents\Geode\CMakeLists.txt" (
        set "GEODE_SDK=%USERPROFILE%\Documents\Geode"
    ) else (
        echo ERROR: GEODE_SDK is not set and the default SDK path was not found.
        echo Set GEODE_SDK to the Geode SDK directory and run this file again.
        exit /b 1
    )
)

if not exist "%GEODE_SDK%\CMakeLists.txt" (
    echo ERROR: GEODE_SDK does not point to a valid Geode SDK: "%GEODE_SDK%"
    exit /b 1
)

set "EXPERIMENTAL_BINDINGS=%PROJECT_DIR%\build\_deps\bindings-src"
if exist "%EXPERIMENTAL_BINDINGS%\.git" (
    set "GEODE_BINDINGS_REPO_PATH=%EXPERIMENTAL_BINDINGS%"
)

where cmake >nul 2>nul
if errorlevel 1 (
    echo ERROR: CMake was not found on PATH.
    exit /b 1
)

cmake --fresh -S "%PROJECT_DIR%" -B "%PROJECT_DIR%\build" -G "Visual Studio 17 2022" -A x64
if errorlevel 1 exit /b %errorlevel%

cmake --build "%PROJECT_DIR%\build" --config Release
if errorlevel 1 exit /b %errorlevel%

echo.
echo Build completed successfully.
endlocal
