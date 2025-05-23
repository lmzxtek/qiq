@echo off
mode con cp select=437 >nul
setlocal EnableDelayedExpansion

set confhome=https://raw.githubusercontent.com/bin456789/reinstall/main
set confhome_cn=https://proxy.063643.xyz/proxy/https://raw.githubusercontent.com/bin456789/reinstall/main
@REM set confhome_cn=https://www.ghproxy.cc/https://raw.githubusercontent.com/bin456789/reinstall/main
rem set confhome_cn=https://jihulab.com/bin456789/reinstall/-/raw/main

rem 65001 代码页会乱码

rem 不要用 :: 注释
rem 否则可能会出现 系统找不到指定的驱动器

rem Windows 7 SP1 winhttp 默认不支持 tls 1.2
rem https://support.microsoft.com/en-us/topic/update-to-enable-tls-1-1-and-tls-1-2-as-default-secure-protocols-in-winhttp-in-windows-c4bd73d2-31d7-761e-0178-11268bb10392
rem 有些系统根证书没更新
rem 所以不要用https
rem 进入脚本目录
cd /d %~dp0

rem 检查是否有管理员权限
fltmc >nul 2>&1
if errorlevel 1 (
    echo Please run as administrator^^!
    exit /b
)

rem 有时 %tmp% 带会话 id，且文件夹不存在
rem https://learn.microsoft.com/troubleshoot/windows-server/shell-experience/temp-folder-with-logon-session-id-deleted
if not exist %tmp% (
    md %tmp%
)

rem 24h2 默认禁用了 wmic
where wmic >nul 2>nul
if errorlevel 1 (
    DISM /Online /Add-Capability /CapabilityName:WMIC
)

rem 检查是否国内
if not exist %tmp%\geoip (
    rem 部分地区 www.cloudflare.com 被墙
    call :download http://dash.cloudflare.com/cdn-cgi/trace %tmp%\geoip
    if errorlevel 1 goto :download_failed
)
findstr /c:"loc=CN" %tmp%\geoip >nul
if not errorlevel 1 (
    rem mirrors.tuna.tsinghua.edu.cn 会强制跳转 https
    set mirror=http://mirror.nju.edu.cn
    if defined confhome_cn (
        set confhome=!confhome_cn!
    ) else if defined github_proxy (
        echo !confhome! | findstr /c:"://raw.githubusercontent.com/" >nul
        if not errorlevel 1 (
            set confhome=!confhome:http://=https://!
            set confhome=!confhome:https://raw.githubusercontent.com=%github_proxy%!
        )
    )
) else (
    rem 服务器在美国 equinix 机房，不是 cdn
    set mirror=http://mirrors.kernel.org
)

rem pkgs 改动了才重新运行 Cygwin 安装程序
set pkgs=curl,cpio,p7zip,bind-utils,ipcalc,dos2unix,binutils,jq,xz,gzip,zstd,openssl,libiconv
set tags=%tmp%\cygwin-installed-%pkgs%
if not exist "%tags%" (
    rem win10 arm 支持运行 x86 软件
    rem win11 arm 支持运行 x86 和 x86_64 软件
    rem wmic os get osarchitecture 显示中文
    rem wmic ComputerSystem get SystemType 显示英文

    for /f "tokens=2 delims==" %%a in ('wmic os get BuildNumber /format:list ^| find "BuildNumber"') do (
        set /a BuildNumber=%%a
    )

    set CygwinEOL=1

    wmic ComputerSystem get SystemType | find "ARM" > nul
    if not errorlevel 1 (
        if !BuildNumber! GEQ 22000 (
            set CygwinEOL=0
        )
    ) else (
        wmic ComputerSystem get SystemType | find "x64" > nul
        if not errorlevel 1 (
            if !BuildNumber! GEQ 9600 (
                set CygwinEOL=0
            )
        )
    )

    rem win7/8 cygwin 已 EOL，不能用最新 cygwin 源，而要用 Cygwin Time Machine 源
    rem 但 Cygwin Time Machine 没有国内源
    rem 为了保证国内下载速度, cygwin EOL 统一使用 cygwin-archive x86 源
    if !CygwinEOL! == 1 (
        set CygwinArch=x86
        set dir=/sourceware/cygwin-archive/20221123
    ) else (
        set CygwinArch=x86_64
        set dir=/sourceware/cygwin
    )

    rem 下载 Cygwin
    call :download http://www.cygwin.com/setup-!CygwinArch!.exe %tmp%\setup-cygwin.exe
    if errorlevel 1 goto :download_failed

    rem 安装 Cygwin
    set site=!mirror!!dir!
    %tmp%\setup-cygwin.exe --allow-unsupported-windows ^
                           --quiet-mode ^
                           --only-site ^
                           --site !site! ^
                           --root %SystemDrive%\cygwin ^
                           --local-package-dir %tmp%\cygwin-local-package-dir ^
                           --packages %pkgs% ^
                           && type nul >"%tags%"
)

rem 在c盘根目录下执行 cygpath -ua . 会得到 /cygdrive/c，因此末尾要有 /
for /f %%a in ('%SystemDrive%\cygwin\bin\cygpath -ua ./') do set thisdir=%%a

rem 下载 reinstall.sh
if not exist reinstall.sh (
    rem call :download %confhome%/reinstall.sh %~dp0reinstall.sh
    call :download_with_curl %confhome%/reinstall.sh %thisdir%reinstall.sh
    if errorlevel 1 goto :download_failed
    call :chmod a+x %thisdir%reinstall.sh
)

rem 为每个参数添加引号，使参数正确传递到 bash
for %%a in (%*) do (
    set "param=!param! "%%~a""
)

rem 方法1
%SystemDrive%\cygwin\bin\dos2unix -q '%thisdir%reinstall.sh'
%SystemDrive%\cygwin\bin\bash -l -c '%thisdir%reinstall.sh !param!'

rem 方法2
rem %SystemDrive%\cygwin\bin\bash reinstall.sh %*
rem 再在 reinstall.sh 里运行 source /etc/profile
exit /b





:download
rem bits 要求有 Content-Length 才能下载
rem https://learn.microsoft.com/en-us/windows/win32/bits/http-requirements-for-bits-downloads
rem certutil 会被 windows Defender 报毒
rem windows server 2019 要用第二条 certutil 命令
echo Download: %~1 %~2
del /q "%~2" 2>nul
if exist "%~2" (echo Cannot delete %~2 & exit /b 1)
if not exist "%~2" certutil -urlcache -f -split "%~1" "%~2" >nul
if not exist "%~2" certutil -urlcache -split "%~1" "%~2" >nul
if not exist "%~2" exit /b 1
exit /b

:download_with_curl
echo Download: %~1 %~2
%SystemDrive%\cygwin\bin\curl -L "%~1" -o "%~2"
exit /b

:chmod
%SystemDrive%\cygwin\bin\chmod "%~1" "%~2"
exit /b

:download_failed
echo Download failed.
exit /b 1
