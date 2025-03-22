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
        
        [string]$DownloadPath = $env:TEMP,
        
        [string]$FileNamePattern,
        
        [string]$ExcludePattern,
        
        [string]$Proxy
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
            $apiUrl = $RepositoryUrl -replace "https://github.com/", "https://api.github.com/repos/" -replace "/$", ""
            $apiUrl += "/releases/latest"

            # 获取发布信息
            Write-Host " 正在获取仓库发布信息..." -ForegroundColor Cyan
            $release = Invoke-RestMethod -Uri $apiUrl -Headers @{
                "Accept" = "application/vnd.github.v3+json"
            }

            # 自动检测系统参数
            $systemInfo = @{
                OS   = if ($env:OS -eq 'Windows_NT') { "win" } else { $PSVersionTable.OS.Split()[0].ToLower() }
                Arch = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }
            }

            # 构建智能匹配规则
            $autoPattern = @{
                win = @{
                    pattern = ".*(win|windows).*$($systemInfo.Arch).*(exe|msi|zip)$"
                    priority = 1
                }
                linux = @{
                    pattern = ".*(linux|ubuntu|debian).*$($systemInfo.Arch).*(deb|rpm|tar.gz)$"
                    priority = 2
                }
                darwin = @{
                    pattern = ".*(macos|osx|darwin).*(dmg|pkg|tar.gz)$"
                    priority = 3
                }
            }

            # 筛选可用资产
            $assets = $release.assets | Sort-Object -Property @{
                Expression = { $_.name -match ".*$($systemInfo.Arch).*" }
                Descending = $true
            }

            # 应用筛选条件
            $selectedAsset = $assets | Where-Object {
                ($_.name -match $FileNamePattern) -or 
                ($_.name -match $autoPattern[$systemInfo.OS].pattern) -and
                (-not ($_.name -match $ExcludePattern))
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
                throw "未找到匹配的发布文件，可用文件列表：`n$($assets.name -join "`n")"
            }

            # 创建下载目录
            $downloadDir = New-Item -Path (Join-Path $DownloadPath $release.tag_name) -ItemType Directory -Force

            # 下载文件
            $localFile = Join-Path $downloadDir.FullName $selectedAsset.name
            Write-Host "正在下载 $($selectedAsset.name)..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $selectedAsset.browser_download_url -OutFile $localFile

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
function Install-Python {
    while ($true) {
        Clear-Host
        Write-Host "========== Python Management ==========" -ForegroundColor Green
        Write-Host " 1. Install Latest Python"
        Write-Host " 2. Install Specific Python Version"
        Write-Host " 3. Install pipenv"
        Write-Host " 4. Set Python Pip Mirror"
        Write-Host " 0. Back to Main Menu"
        $py_choice = Read-Host "Enter your choice (1-5)"
        
        switch ($py_choice) {
            "1" { Install-Software "Python.Python" "python" "https://www.python.org/downloads/" }
            "2" { 
                $py_version = Read-Host "Enter the Python version (e.g., 3.11.5)"
                Install-Software "Python.Python --version $py_version" "python --version $py_version" "https://www.python.org/downloads/release/python-$py_version/"
            }
            "3" { python -m pip install --upgrade pip; python -m pip install pipenv; Pause }
            "4" { Set-Pip-Mirror }
            "0" { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; Pause }
        }
    }
}

# 设置 pip 源
function Set-Pip-Mirror {
    Write-Host " 选择镜像: "
    Write-Host " 1. 阿里云"
    Write-Host " 2. 清华源"
    Write-Host " 3. 中科大"
    Write-Host " 4. 自定义"
    Write-Host " 0. 返回"
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
    } else {
        Write-Host "PowerShell 7 is not installed! Install it first." -ForegroundColor Red
    }
    Pause
}

function download_all_software {
    "PowerShell", "git", "vscode" | ForEach-Object {
        Get-GitHubLatestRelease -RepositoryUrl "https://github.com/$_/$_"
    }
}

function get_download_path {
    param ([string]$sfld)
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


function app_download{
    $sfld = 'Apps'
    $targetDir = get_download_path $sfld

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
        Write-Host "  8. 7zip"  -ForegroundColor Green
        Write-Host "  9. All" 
        Write-Host "  0. Exit" -ForegroundColor Red
        Write-Host "===============================" -ForegroundColor Cyan
    }
    function download_vc_redist64{
        $file = "VC_redist.x64.exe"
        $targetDir = get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        $url_dl = "https://alist.ywzsqx.top/d/a/apps/$file"
        write-host "File URL  : $url_dl"
        write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_nekobox{
        $file = "nekoray-4.0.1-2024-12-12-windows64.zip"
        $targetDir = get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        $url_dl = "https://alist.ywzsqx.top/d/a/apps/$file"
        write-host "File URL  : $url_dl"
        write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_python3127{
        $file = "python-3.12.7-amd64.exe"
        $targetDir = get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        $url_dl = "https://alist.ywzsqx.top/d/a/apps/$file"
        write-host "File URL  : $url_dl"
        write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_powershell{
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl "https://github.com/PowerShell/PowerShell"
        if ($downloadedFile) {
            Write-Host " Download finished, file saved: " -ForegroundColor Green
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
            "0" { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; }
        }
        # Pause 
        $null = Read-Host " Press Enter to continue  "
    }
    
}

function activate_win_office{
    # > irm https://get.activated.win | iex 
    Invoke-RestMethod "https://get.activated.win" | Invoke-Expression
}

function print_web_links{
    Clear-Host
    Write-Host "========== Web Urls ============" -ForegroundColor Cyan
    Write-Host "  1. NekoBox   : https://nekoray.net/"
    Write-Host "  2. VC_Redist : https://aka.ms/vs/17/release/vc_redist.x64.exe"
    Write-Host "  3. PowerShell: https://aka.ms/powershell-release?tag=stable"
    Write-Host "  4. Python    : https://www.python.org/downloads/windows/"
    Write-Host "  5. Git       : https://git-scm.com/downloads/win"
    Write-Host "  6. VSCode    : https://code.visualstudio.com/Download"
    Write-Host "  7. Notepad++ : https://notepad-plus-plus.org/downloads/"
    # Write-Host "  0. Exit"       -ForegroundColor Red
    Write-Host "===============================" -ForegroundColor Cyan
}

function  main_menu {
    # 菜单界面
    function Show-Menu {
        Clear-Host
        Write-Host "========== Tool Menu ==========" -ForegroundColor Cyan
        Write-Host "  1. Web Links"
        Write-Host "  2. App Download"  -ForegroundColor Green
        Write-Host "  3. App Install"
        Write-Host "  4. Symtems Setting"  -ForegroundColor Yellow
        Write-Host "  5. Activate Tool"  -ForegroundColor Blue 
        Write-Host "  6. Python Management"  
        Write-Host "  0. Exit"     -ForegroundColor Red
        Write-Host "===============================" -ForegroundColor Cyan
    }
    # 菜单循环
    while ($true) {
        Show-Menu
        $choice = Read-Host "Enter your choice (1-6)"
        switch ($choice) {
            "1" { print_web_links; Pause }
            "2" { app_download }
            "3" { Software_install }
            "4" { System_Settings }
            "5" { activate_win_office }
            "6" { Install-Python }
            "0" { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; Pause }
        }
    }
    
}


main_menu 

# # 使用示例
# $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl "https://github.com/PowerShell/PowerShell"
# if ($downloadedFile) {
#     Write-Host "下载完成！文件路径：" -ForegroundColor Green
#     $downloadedFile.FullName
# }

# 查找包含 Python 3.12 的 Windows 安装包
# Get-GitHubLatestRelease -RepositoryUrl "https://github.com/python/cpython" `
#                        -FileNamePattern "python-3\.12.*-win.*\.exe"

# 排除测试版本
# Get-GitHubLatestRelease -RepositoryUrl "https://github.com/microsoft/vscode" `
#                        -ExcludePattern "insider|exploration"