#===============================================================================
# 作者：ZWDK
# USAGE: 
#   ps: > iwr https://qiq.zwdk.im/ps | iex 
#   ps: > irm https://qiq.zwdk.im/ps | iex 
#   cmd:> cmd /c "$(iwr https://qiq.zwdk.im/bat)" 
#===============================================================================

# 禁用进度条以提升下载速度
# $ProgressPreference = 'SilentlyContinue'


# 设置 PowerShell 输出编码，确保中文显示正常
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

# 检测 winget 是否可用
$wingetAvailable = $false
if (Get-Command winget -ErrorAction SilentlyContinue) {
    $wingetAvailable = $true
}

# 检测 choco 是否可用
$chocoAvailable = $false
if (Get-Command choco -ErrorAction SilentlyContinue) {
    $chocoAvailable = $true
}


function get_region {    
    $ipapi = ""
    $region = "Unknown"
    foreach ($url in ("https://dash.cloudflare.com/cdn-cgi/trace", "https://developers.cloudflare.com/cdn-cgi/trace", "https://1.0.0.1/cdn-cgi/trace")) {
        try {
            $ipapi = Invoke-RestMethod -Uri $url -TimeoutSec 5 -UseBasicParsing
            if ($ipapi -match "loc=(\w+)" ) {
                $region = $Matches[1]
                break
            }
        }
        catch {
            Write-Host "Error occurred while querying $url : $_"
        }
    }
    return $region
}

function Get_proxy_url {
    param (
        # Parameter help description
        # [Parameter(AttributeValues)]
        [string]$Url,
        [string]$proxy = "https://proxy.zwdk.org/proxy/"
    )
    
    $region = get_region 

    if ($region -ne "CN") {
        # write-host "Region: $region" -ForegroundColor Green
        # write-host "Url   : $Url"    -ForegroundColor Green
        $proxy_url = $Url
    }
    else {
        # write-host "Region: $region" -ForegroundColor Green
        # write-host "Url   : $Url"    -ForegroundColor Green
        # write-host "proxy : $proxy"  -ForegroundColor Green
        $proxy_url = $proxy + $Url
    }
    return $proxy_url
}

function Get_download_path {
    param ( [string]$sfld )
    # 获取脚本所在的目录路径
    # $scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
    $scriptDir = $PWD.Path

    # 创建目标子目录 Apps（如果不存在）
    $targetDir = Join-Path -Path $scriptDir -ChildPath $sfld 
    if (-not (Test-Path -Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir
    }
    # 定义目标文件路径
    # $targetFilePath = Join-Path -Path $targetDir -ChildPath "file.zip"
    return $targetDir
}

function url_from_repo_2_api {
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern("https?://github.com/.*")]
        [string]$Url
    )
    
    $apiUrl = $Url -replace "https://github.com/", "https://api.github.com/repos/" -replace "/$", ""
    $apiUrl += "/releases/latest"
    return $apiUrl 
}

function get_json_gh_latest {
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern("https?://api.github.com/repos/.*")]
        [string]$Url
    )
    
    $release = Invoke-RestMethod -Uri $Url -Headers @{
        "Accept" = "application/vnd.github.v3+json"
    }
    return $release 
}

function Get_sys_info {   
    # 自动检测系统参数
    $systemInfo = @{
        OS   = if ($env:OS -eq 'Windows_NT') { "win" } else { $PSVersionTable.OS.Split()[0].ToLower() }
        Arch = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }
    }
    return $systemInfo 
}

function Get_auto_pattern {  
    # 构建智能匹配规则
    $autoPattern = @{
        win    = @{
            # pattern  = ".*(win|windows|windows64).*$($systemInfo.Arch).*(exe|msi|zip)$"
            # pattern  = ".*(win|windows|windows64)(?:.*\$$?systemInfo\.Arch$?)?.*(exe|msi|zip)$"
            pattern  = ".*(win|windows|windows64)(?:.*$($systemInfo.Arch))?.*(exe|msi|zip)$"
            priority = 1
        }
        linux  = @{
            pattern  = ".*(linux|linux64|ubuntu|debian)(?:.*$($systemInfo.Arch))?.*(deb|rpm|tar.gz)$"
            priority = 2
        }
        darwin = @{
            pattern  = ".*(macos|osx|darwin).*(dmg|pkg|tar.gz)$"
            priority = 3
        }
    }
    return $autoPattern 
}

function Get-GitHubLatestRelease {
    <#
    .SYNOPSIS
    自动下载 GitHub 仓库的最新发布版本
    
    .DESCRIPTION
    通过 GitHub API 获取指定仓库的最新发布版本，并根据当前系统自动匹配安装包
    
    .PARAMETER RepositoryUrl
    GitHub 仓库地址（例如：https://github.com/PowerShell/PowerShell）
    
    .PARAMETER DownloadPath
    文件保存路径（默认：用户临时目录）
    
    .PARAMETER FileNamePattern
    使用正则表达式筛选资产文件（示例："\.msi$|\.exe$"）
    
    .PARAMETER ExcludePattern
    排除文件的正则表达式（示例："symbols|debug"）
    
    .PARAMETER Proxy
    代理服务器地址（示例："http://proxy.example.com:8080"）
    
    .EXAMPLE
    Get-GitHubLatestRelease -RepositoryUrl "https://github.com/PowerShell/PowerShell"
    
    .EXAMPLE
    Get-GitHubLatestRelease -RepositoryUrl "https://github.com/notepad-plus-plus/notepad-plus-plus" -FileNamePattern "\.exe$"
    
    .OUTPUTS
    System.IO.FileInfo (返回下载文件对象)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern("https?://github.com/.*")]
        [string]$RepositoryUrl,
        
        [string]$FileNamePattern,
        
        [string]$ExcludePattern,
        
        [string]$Proxy,
        
        [string]$SubPath = "Apps"
    )

    begin {
        # 设置 TLS 1.2 避免连接问题
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        
        # 处理代理设置
        if ($Proxy) {
            $webProxy = New-Object System.Net.WebProxy($Proxy, $true)
            $global:PSDefaultParameterValues["Invoke-RestMethod:Proxy"] = $webProxy
        }
    }


    process {
        try {
            # 转换仓库地址为 API 路径
            $apiUrl = url_from_repo_2_api -Url $RepositoryUrl

            # 获取发布信息
            Write-Host " Fetch info. from GitHub API (releases/latest) ... " -ForegroundColor Cyan
            $release = get_json_gh_latest -Url $apiUrl

            # 自动检测系统参数
            $systemInfo = Get_sys_info

            # 构建智能匹配规则
            $autoPattern = Get_auto_pattern 

            # 筛选可用资产
            $assets = $release.assets | Sort-Object -Property @{
                Expression = { $_.name -match ".*$($systemInfo.Arch).*" }
                Descending = $true
            }

            # 应用筛选条件
            $selectedAsset = $assets | Where-Object {
                ($_.name -match $FileNamePattern) -or 
                ($_.name -match $autoPattern[$systemInfo.OS].pattern)
                # ($_.name -match $autoPattern[$systemInfo.OS].pattern) -and
                # (-not ($_.name -match $ExcludePattern))
            } | Sort-Object @{
                Expression = { 
                    $score = 0
                    if ($_.name -match $autoPattern[$systemInfo.OS].pattern) { $score += 100 }
                    if ($_.name -match $FileNamePattern) { $score += 50 }
                    $score
                }
                Descending = $true
            } | Select-Object -First 1

            if (-not $selectedAsset) {
                Write-Host " System Info: OS=$($systemInfo.OS)`tArch=$($systemInfo.Arch)" -ForegroundColor Yellow
                Write-Host " File List: `n$($assets.name -join "`n")" -ForegroundColor Green
                # Write-Host " 下载地址：`n$($assets.browser_download_url -join "`n")" -ForegroundColor Green
                throw " !!! Can't find the target file !!!"
            } else {
                Write-Host " Find target: $($selectedAsset.name)" -ForegroundColor Green
            }

            # 创建下载目录
            $downloadDir = Get_download_path $SubPath
            # $downloadDir = New-Item -Path $sfld -ItemType Directory -Force
            # Write-Host " Target Dir: $($downloadDir)" -ForegroundColor Blue

            # 下载文件
            $url_target = Get_proxy_url -Url $selectedAsset.browser_download_url
            # Write-Host " Target Url: $($url_target)" -ForegroundColor Blue
            $localFile = Join-Path $downloadDir $selectedAsset.name
            # Write-Host " Downloading: $($selectedAsset.name) `n url: $($url_target)" -ForegroundColor Cyan
            # Invoke-WebRequest -Uri $url_target -OutFile $localFile 
            Start-BitsTransfer -Source $url_target -Destination  $localFile   # 适合下载大文件或需要后台下载的场景
            Write-Host " Saved to: $($localFile) " -ForegroundColor Green
            # return # ######## 临时调试，不下载文件

            # 返回文件对象
            Get-Item $localFile
        }
        catch [System.Net.WebException] {
            Write-Error "网络连接失败：$($_.Exception.Message)"
        }
        catch {
            Write-Error "操作失败：$($_.Exception.Message)"
        }
        finally {
            # 重置代理设置
            if ($Proxy) {
                $global:PSDefaultParameterValues.Remove("Invoke-RestMethod:Proxy")
            }
        }
    }
}

# 统一安装软件逻辑
function Install-Software {
    param (
        [string]$wingetName,
        [string]$chocoName,
        [string]$manualURL
    )
    
    if ($wingetAvailable) {
        Write-Host "Using winget to install $wingetName..."
        winget install $wingetName -e
    }
    elseif ($chocoAvailable) {
        Write-Host "Using Chocolatey to install $chocoName..."
        choco install $chocoName -y
    }
    else {
        Write-Host "Download manually: $manualURL" -ForegroundColor Red
        Start-Process $manualURL
    }
    Pause
}

# 安装 Python（可选择版本）
function Manage_Python {
    function show_jill_usage{
        Write-Host "========== Jill Usage ==========" -ForegroundColor Green
        Write-Host "Usage: jill install [options] "
        Write-Host "   > jill upstream                       # Check available Julia upstream sources"
        Write-Host "   > jill install --upstream USTC        # Install Julia from USTC source"
        Write-Host "   > jill install --install_dir './'     # Install Julia to current directory"
        Write-Host "================================" -ForegroundColor Green
    }
    while ($true) {
        Clear-Host
        Write-Host "========== Python Management ==========" -ForegroundColor Green
        Write-Host " 1. Install Python Latest "
        Write-Host " 2. Install Python by ver."
        Write-Host " 3. Install pipenv"
        Write-Host " 4. Install Julia"
        Write-Host " 5. Set Pip Source"
        Write-Host " 0. Back"
        Write-Host "=======================================" -ForegroundColor Green
        $py_choice = Read-Host "Enter your choice (1-5)"
        
        switch ($py_choice) {
            "1" { Install-Software "Python.Python" "python" "https://www.python.org/downloads/" }
            "2" { 
                $py_version = Read-Host "Enter the Python version (e.g., 3.11.5)"
                Install-Software "Python.Python --version $py_version" "python --version $py_version" "https://www.python.org/downloads/release/python-$py_version/"
            }
            "3" { python -m pip install --upgrade pip; python -m pip install pipenv; Pause }
            "4" { show_jill_usage; pip install jill; jill install  }
            "5" { Set-Pip-Mirror }
            "0" { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; Pause }
        }
    }
}

# 设置 pip 源
function Set-Pip-Mirror {
    Write-Host " Select Source: "
    Write-Host " 1. AliYun"
    Write-Host " 2. TUNA"
    Write-Host " 3. USTC"
    Write-Host " 4. Custom"
    Write-Host " 0. Back"
    $mirror_choice = Read-Host "Enter choice"

    $mirrorURL = switch ($mirror_choice) {
        "1" { "https://mirrors.aliyun.com/pypi/simple/" }
        "2" { "https://pypi.tuna.tsinghua.edu.cn/simple/" }
        "3" { "https://pypi.mirrors.ustc.edu.cn/simple/" }
        "4" { Read-Host "Enter custom pip mirror URL" }
        "0" { return }
        default { Write-Host "Invalid input"; return }
    }

    $pipConfigPath = "$env:USERPROFILE\pip\pip.ini"
    if (-not (Test-Path "$env:USERPROFILE\pip")) {
        New-Item -ItemType Directory -Path "$env:USERPROFILE\pip" -Force
    }

    @"
[global]
index-url = $mirrorURL
"@ | Set-Content -Path $pipConfigPath -Encoding UTF8

    Write-Host "Pip mirror set to: $mirrorURL" -ForegroundColor Green
    Pause
}

# 常用软件安装
function Software_install {
    while ($true) {
        Clear-Host
        Write-Host "====== Common Software Installation ======" -ForegroundColor Cyan
        Write-Host "1. Install 7-Zip"
        Write-Host "2. Install Notepad++"
        Write-Host "3. Install VS Code"
        Write-Host "0. Back to Main Menu"
        $soft_choice = Read-Host "Enter your choice (1-4)"
        
        switch ($soft_choice) {
            "1" { Install-Software "7zip.7zip" "7zip" "https://www.7-zip.org/download.html" }
            "2" { Install-Software "Notepad++.Notepad++" "notepadplusplus" "https://notepad-plus-plus.org/downloads/" }
            "3" { Install-Software "Microsoft.VisualStudioCode" "vscode" "https://code.visualstudio.com/download" }
            "0" { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; Pause }
        }
    }
}

# 系统设置
function System_Settings {
    # 启用 OpenSSH 服务
    function Enable-OpenSSH {
        Write-Host "Enabling OpenSSH server..."
        Add-WindowsFeature -Name OpenSSH-Server
        Set-Service -Name sshd -StartupType Automatic
        Start-Service sshd
        Write-Host "OpenSSH is enabled!" -ForegroundColor Green
        Pause
    }

    # 设置 PowerShell 7 为默认 shell
    function Set-DefaultShell-Pwsh {
        if (Get-Command pwsh -ErrorAction SilentlyContinue) {
            $pwshPath = (Get-Command pwsh).Source
            New-ItemProperty -Path "HKCU:\Software\Microsoft\Command Processor" -Name "AutoRun" -Value "$pwshPath" -PropertyType String -Force
            Write-Host "Default shell set to PowerShell 7 (pwsh)." -ForegroundColor Green
        }
        else {
            Write-Host "PowerShell 7 is not installed! Install it first." -ForegroundColor Red
        }
        Pause
    }

    while ($true) {
        Clear-Host
        Write-Host "======= System Settings =======" -ForegroundColor Yellow
        Write-Host "1. Set PowerShell Execution Policy"
        Write-Host "2. Enable OpenSSH Service"
        Write-Host "3. Set Default Shell to pwsh"
        Write-Host "0. Back to Main Menu"
        $sys_choice = Read-Host "Enter your choice (1-4)"
        
        switch ($sys_choice) {
            "1" { Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; Write-Host "Execution policy set!"; Pause }
            "2" { Enable-OpenSSH }
            "3" { Set-DefaultShell-Pwsh }
            "0" { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; Pause }
        }
    }
}




function App_download {
    $sfld = 'Apps'
    $targetDir = Get_download_path $sfld

    function download_all_software {
        "PowerShell", "git", "vscode" | ForEach-Object {
            Get-GitHubLatestRelease -RepositoryUrl "https://github.com/$_/$_"
        }
    }

    function Show_Menu_app_download {
        Clear-Host
        Write-Host "========== Download Menu ==========" -ForegroundColor Cyan
        Write-Host "  1. VC_redist.x64"  -ForegroundColor Green
        Write-Host "  2. NekoBox 4.0.1"  -ForegroundColor Yellow
        Write-Host "  3. Python 3.12.7"  -ForegroundColor Blue
        Write-Host "  4. PowerShell"
        Write-Host "  5. Notepad++"
        Write-Host "  6. Hiddify"
        Write-Host "  7. VSCode"
        Write-Host "  7. 1Remote"
        Write-Host "  8. 7zip"  -ForegroundColor Green
        Write-Host "  8. WanHo"  
        Write-Host "  9. frp"   -ForegroundColor Green
        Write-Host " 10. All" 
        Write-Host "  0. Exit"  -ForegroundColor Red
        Write-Host "===============================" -ForegroundColor Cyan
    }
    function download_vc_redist64 {
        $file = "VC_redist.x64.exe"
        $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        $url_dl = "https://alist.ywzsqx.top/d/a/apps/$file"
        write-host "File URL  : $url_dl"
        write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_nekobox {
        $file = "nekoray-4.0.1-2024-12-12-windows64.zip"
        $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        $url_dl = "https://alist.ywzsqx.top/d/a/apps/$file"
        write-host "File URL  : $url_dl"
        write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_python3127 {
        $file = "python-3.12.7-amd64.exe"
        $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        $url_dl = "https://alist.ywzsqx.top/d/a/apps/$file"
        write-host "File URL  : $url_dl"
        write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_powershell {
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl "https://github.com/PowerShell/PowerShell"
        if ($downloadedFile) {
            Write-Host " Download finished, saved: " -ForegroundColor Green
            $downloadedFile.FullName
        }
        else {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    # 菜单循环
    while ($true) {
        Show_Menu_app_download
        $choice = Read-Host " Please select (1-9)"
        switch ($choice) {
            "1" { download_vc_redist64; }
            "2" { download_nekobox; }
            "3" { download_python3127; }
            "4" { download_powershell; }
            "10" { download_all_software }
            "0" { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; }
        }
        # Pause 
        $null = Read-Host " Press Enter to continue  "
    }
    
}


function show_web_links {
    Clear-Host
    Write-Host "========== Web Urls ============" -ForegroundColor Cyan
    Write-Host "  1. VC_Redist : 
    https://aka.ms/vs/17/release/vc_redist.x64.exe
    https://aka.ms/vs/17/release/vc_redist.x86.exe
    https://aka.ms/vs/17/release/vc_redist.arm64.exe
    "

    Write-Host "  2. NekoBox : 
    https://nekoray.net/
    https://github.com/MatsuriDayo/nekoray/releases/download/4.0.1/nekoray-4.0.1-2024-12-12-windows64.zip
    "

    Write-Host "  3. PowerShell: 
    https://aka.ms/powershell-release?tag=stable
    https://github.com/PowerShell/PowerShell/releases/download/v7.5.0/PowerShell-7.5.0-win-x64.exe
    "

    Write-Host "  4. Python : 
    https://www.python.org/downloads/windows/
    https://www.python.org/ftp/python/3.13.2/python-3.13.2-amd64.exe
    "

    Write-Host "  5. Git : 
    https://git-scm.com/downloads/win
    https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/Git-2.49.0-64-bit.exe
    "

    Write-Host "  6. VSCode : 
    https://code.visualstudio.com/Download
    https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user 
    "

    Write-Host "  7. Notepad++ : 
    https://notepad-plus-plus.org/downloads/
    https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.7.8/npp.8.7.8.Installer.x64.exe
    "

    # Write-Host "  0. Exit"       -ForegroundColor Red
    Write-Host "===============================" -ForegroundColor Cyan
}

function  main_menu {
    
    function activate_win_office {
        # > irm https://get.activated.win | iex 
        Invoke-RestMethod "https://get.activated.win" | Invoke-Expression
    }
    # 菜单界面
    function Show-Menu {
        Clear-Host
        Write-Host "========== Tool Menu ==========" -ForegroundColor Cyan
        Write-Host "  1. App Install          "
        Write-Host "  2. Web Links            "
        Write-Host "  3. App Download         "  -ForegroundColor Green
        Write-Host "  4. Symtems Setting      "  -ForegroundColor Yellow
        Write-Host "  5. Activate Tool        "  -ForegroundColor Blue 
        Write-Host "  6. Python Management    "  
        Write-Host "  0. Exit                 "     -ForegroundColor Red
        Write-Host "===============================" -ForegroundColor Cyan
    }
    # 菜单循环
    while ($true) {
        Show-Menu
        $choice = Read-Host "Enter your choice (1-6)"
        switch ($choice) {
            "1" { Software_install }
            "2" { show_web_links; Pause }
            "3" { App_download }
            "4" { System_Settings }
            "5" { activate_win_office }
            "6" { Manage_Python }
            "0" { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; Pause }
        }
    }
    
}


# main_menu 

# # 使用示例


$region = get_region 
Write-Host $region 

$url_gh = "https://github.com/PowerShell/PowerShell"
$fpattern = ".*-win-x64.exe"
# $url_gh = "https://github.com/microsoft/vscode"
# $url_gh = "https://github.com/python/cpython"
# $url_gh = "https://github.com/MatsuriDayo/nekoray"
# $fpattern = ".*-windows64.zip"

# $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl "https://github.com/PowerShell/PowerShell"
$downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
if ($downloadedFile) {
    Write-Host " 下载完成！文件路径：" -ForegroundColor Green
    $downloadedFile.FullName
}

# 查找包含 Python 3.12 的 Windows 安装包
# Get-GitHubLatestRelease -RepositoryUrl "https://github.com/python/cpython" `
#                        -FileNamePattern "python-3\.12.*-win.*\.exe"

# 排除测试版本
# Get-GitHubLatestRelease -RepositoryUrl "https://github.com/microsoft/vscode" `
#                        -ExcludePattern "insider|exploration"
