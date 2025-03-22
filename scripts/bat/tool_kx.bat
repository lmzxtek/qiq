@ECHO OFF
::网址: nat.ee
::QQ群: 6281379
::TG群: https://t.me/nat_ee
::批处理: 荣耀&制作 QQ:1800619
>nul 2>&1 "%SYSTEMROOT%\system32\caCLS.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
GOTO UACPrompt
) ELSE ( GOTO gotAdmin )
:UACPrompt
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
ECHO UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
title nat.ee
mode con: cols=36 lines=8
color 17
SET "wall=HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules"
SET "rdp=HKLM\SYSTEM\ControlSet001\Control\Terminal Server"
:Menu
CLS
ECHO.
ECHO 1.修改远程桌面端口
ECHO.
ECHO 2.修改用户密码
ECHO.
ECHO 3.重启计算机
ECHO.
choice /C:123 /N /M "请输入你的选择 [1,2,3]": 
if errorlevel 3 GOTO:Restart
if errorlevel 2 GOTO:Password
if errorlevel 1 GOTO:RemotePort
:RemotePort
SET Port=3389
CLS
ECHO 修改远程桌面端口
ECHO.
ECHO 输入^" q ^"返回主菜单
ECHO 留空默认使用 3389 端口
ECHO 按回车键 (Enter) 确定
ECHO.
SET /P "Port=自定义端口范围(1-65535):"
ECHO;%Port%|find " "&&goto:RemotePort
ECHO;%Port%|findstr "^0.*"&&goto:RemotePort
IF "%Port%" == "q" (GOTO:Menu)
IF "%Port%" == "0" (GOTO:RemotePort)
IF "%Port%" == "" (SET Port=3389)
IF %Port% LEQ 65535 (
Reg add "%rdp%\Wds\rdpwd\Tds\tcp" /v "PortNumber" /t REG_DWORD /d "%Port%" /f  > nul
Reg add "%rdp%\WinStations\RDP-Tcp" /v "PortNumber" /t REG_DWORD /d "%Port%" /f  > NUL
Reg add "%wall%" /v "{338933891-3389-3389-3389-338933893389}" /t REG_SZ /d "v2.29|Action=Allow|Active=TRUE|Dir=In|Protocol=6|LPort=%Port%|Name=Remote Desktop(TCP-In)|" /f
Reg add "%wall%" /v "{338933892-3389-3389-3389-338933893389}" /t REG_SZ /d "v2.29|Action=Allow|Active=TRUE|Dir=In|Protocol=17|LPort=%Port%|Name=Remote Desktop(UDP-In)|" /f
CLS
ECHO.
ECHO 修改成功。
ECHO.
ECHO 请牢记，你的远程端口是: %Port% 
ECHO.
ECHO 重启计算机生效。
TIMEOUT 5 >NUL
GOTO:Menu
) ELSE (
CLS
ECHO.
ECHO 错误端口: %Port% 
ECHO 大于所设置的范围，
ECHO 请在^"1 - 65535^"内。
TIMEOUT 3 >NUL
GOTO:RemotePort
)
:Password
SET pwd1=
SET pwd2=
CLS
ECHO 修改当前用户: %username% 的密码
ECHO.
ECHO 输入^" q ^"返回主菜单
ECHO 按回车键 (Enter) 确定
ECHO.
SET /p pwd1=请输入新密码: 
IF "%pwd1%" == "q" (GOTO:Menu)
CLS
ECHO.
ECHO 输入^" q ^"返回主菜单
ECHO 按回车键 (Enter) 确定
ECHO.
SET /p pwd2=请再次输入密码: 
IF "%pwd2%" == "q" (GOTO:Menu)
IF "%pwd1%" == "%pwd2%" (
CLS
net user "%username%" "%pwd2%"||PAUSE&&GOTO:Password
ECHO.
TIMEOUT 3 >NUL
GOTO:Menu
) ELSE (
CLS
ECHO.
ECHO 密码错误，请重新输入。
TIMEOUT 3 >NUL
GOTO:Password
)
:Restart
CLS
ECHO 正在倒计时重启……
TIMEOUT /t 5
shutdown.exe /r /f /t 0
EXIT