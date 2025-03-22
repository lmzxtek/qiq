@echo off
chcp 65001 >nul
title Tool Menu
setlocal enabledelayedexpansion

:: 检测 winget 是否可用
where winget >nul 2>&1
if %errorlevel% neq 0 (
    set USE_WINGET=0
) else (
    set USE_WINGET=1
)

:: 检测 choco 是否可用
where choco >nul 2>&1
if %errorlevel% neq 0 (
    set USE_CHOCO=0
) else (
    set USE_CHOCO=1
)

:menu
cls
echo ==================================
echo            Tool Menu
echo ==================================
echo 1. Install Python (Select Version)
echo 2. Install pipenv
echo 3. Install PowerShell (Latest)
echo 4. Set PowerShell Execution Policy
echo 5. Install 7-Zip
echo 6. Install Notepad++
echo 7. Install VS Code
echo 8. Activate Windows/Office
echo 0. Exit
echo ==================================
set /p choice=Enter your choice (1-8): 

if "%choice%"=="1" goto install_python
if "%choice%"=="2" goto install_pipenv
if "%choice%"=="3" goto install_powershell
if "%choice%"=="4" goto set_ps_policy
if "%choice%"=="5" goto install_7zip
if "%choice%"=="6" goto install_notepadpp
if "%choice%"=="7" goto install_vscode
if "%choice%"=="0" exit
echo Invalid input, please try again!
pause
goto menu

:install_python
cls
echo ======================================
echo          Python Installation
echo ======================================
echo 1. Install Latest Version
echo 2. Install Specific Version
echo ======================================
set /p py_choice=Enter your choice (1-2): 

if "%py_choice%"=="1" (
    echo Installing the latest Python version...
    if %USE_WINGET%==1 (
        winget install Python.Python -e
    ) else if %USE_CHOCO%==1 (
        choco install python -y
    ) else (
        echo Download and install manually: https://www.python.org/downloads/
        start https://www.python.org/downloads/
    )
    pause
    goto menu
) 

if "%py_choice%"=="2" (
    set /p py_version=Enter the Python version to install (e.g., 3.11.5): 
    if "%py_version%"=="" (
        echo Version cannot be empty, please try again!
        pause
        goto install_python
    )
    echo Installing Python %py_version% ...
    if %USE_WINGET%==1 (
        winget install Python.Python --version %py_version% -e
    ) else if %USE_CHOCO%==1 (
        choco install python --version %py_version% -y
    ) else (
        echo Download and install manually: https://www.python.org/downloads/release/python-%py_version:/ 
        start https://www.python.org/downloads/
    )
    pause
    goto menu
)

echo Invalid input, please try again!
pause
goto install_python

:install_pipenv
echo Checking if Python is installed...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed! Please install Python first.
    pause
    goto menu
)

echo Installing pipenv...
python -m pip install --upgrade pip
python -m pip install pipenv
echo pipenv installation completed!
pause
goto menu

:install_powershell
echo Installing the latest version of PowerShell...
if %USE_WINGET%==1 (
    winget install Microsoft.Powershell -e
) else if %USE_CHOCO%==1 (
    choco install powershell-core -y
) else (
    echo Download and install manually: https://github.com/PowerShell/PowerShell/releases
    start https://github.com/PowerShell/PowerShell/releases
)
pause
goto menu

:set_ps_policy
echo Setting PowerShell execution policy to RemoteSigned...
powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"
echo Execution policy set successfully!
pause
goto menu

:install_7zip
echo Installing 7-Zip...
if %USE_WINGET%==1 (
    winget install 7zip.7zip -e
) else if %USE_CHOCO%==1 (
    choco install 7zip -y
) else (
    echo Download and install manually: https://www.7-zip.org/download.html
    start https://www.7-zip.org/download.html
)
pause
goto menu

:install_notepadpp
echo Installing Notepad++...
if %USE_WINGET%==1 (
    winget install Notepad++.Notepad++ -e
) else if %USE_CHOCO%==1 (
    choco install notepadplusplus -y
) else (
    echo Download and install manually: https://notepad-plus-plus.org/downloads/
    start https://notepad-plus-plus.org/downloads/
)
pause
goto menu

:install_vscode
echo Installing VS Code...
if %USE_WINGET%==1 (
    winget install Microsoft.VisualStudioCode -e
) else if %USE_CHOCO%==1 (
    choco install vscode -y
) else (
    echo Download and install manually: https://code.visualstudio.com/download
    start https://code.visualstudio.com/download
)
pause
goto menu
