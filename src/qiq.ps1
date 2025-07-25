#===============================================================================
# 作者：ZWDK
# USAGE: 
#   ps: > iwr https://qiq.zwdk.im/ps | iex 
#   ps: > irm https://qiq.zwdk.im/ps | iex 
#   cmd:> cmd /c "$(iwr https://qiq.zwdk.im/bat)" 
#===============================================================================

# 禁用进度条以提升下载速度
# $ProgressPreference = 'SilentlyContinue'

# 设置脚本运行区域全局变量，避免脚本运行时出现乱码
$global:LOCATION_REGION = "Unknown"
$global:URL_PROXY = "https://proxy.180102.xyz/proxy/"

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


function Add_port_in_out {
    param([int]$port = 5000)
    # 以管理员身份运行 PowerShell，执行以下命令：
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -Command `"& '$PSCommandPath'`"" -Verb RunAs
        return 
    }
    New-NetFirewallRule -DisplayName "Allow Port $port Inbound" `
                        -Direction Inbound `
                        -LocalPort $port `
                        -Protocol TCP `
                        -Action Allow
    Write-Host " Add TCP inbound: $port" -ForegroundColor Green

    New-NetFirewallRule -DisplayName "Allow Port $port Outbound" `
                        -Direction Outbound `
                        -LocalPort $port `
                        -Protocol TCP `
                        -Action Allow
    Write-Host " Add TCP outbound: $port" -ForegroundColor Green
}

function Add_port_in {
    param([int]$port = 5000)
    # 以管理员身份运行 PowerShell，执行以下命令：
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -Command `"& '$PSCommandPath'`"" -Verb RunAs
        return 
    }
    New-NetFirewallRule -DisplayName "Allow Port $port Inbound" `
                        -Direction Inbound `
                        -LocalPort $port `
                        -Protocol TCP `
                        -Action Allow
    Write-Host " Add TCP inbound: $port" -ForegroundColor Green

    # New-NetFirewallRule -DisplayName "Allow Port $port Outbound" `
    #                     -Direction Outbound `
    #                     -LocalPort $port `
    #                     -Protocol TCP `
    #                     -Action Allow
    # Write-Host " Add TCP outbound: $port" -ForegroundColor Green
}

function process_download_dir {
    param (
        [string]$sfld = "Apps"
    )
    # $sfld = 'Apps'
    $targetDir = Get_download_path $sfld 
    if (Test-Path -Path $targetDir) {
        $prompt = "`n To add firewall exclusion for the target directory? (Default:N) [y/N]"
        $confirmation = Read-Host $prompt
        # 处理空输入（直接回车）和首尾空格
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) {
            $userInput = 'N'  # 设置默认值
        }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            # # 排除整个文件夹, 避免安全检测
            Add-MpPreference -ExclusionPath $targetDir
        }
    }
    return $targetDir
}

function get_region { 
    $ipapi = "" 
    $region = "Unknown"
    try {
        $url = "ipinfo.io/country"
        $region = Invoke-RestMethod -Uri $url -TimeoutSec 5 -UseBasicParsing
    }
    catch {
        Write-Host " Error querying $url :`n $_"
        foreach ($url in ("https://dash.cloudflare.com/cdn-cgi/trace", "https://developers.cloudflare.com/cdn-cgi/trace", "https://1.0.0.1/cdn-cgi/trace")) {
            try {
                $ipapi = Invoke-RestMethod -Uri $url -TimeoutSec 5 -UseBasicParsing
                if ($ipapi -match "loc=(\w+)" ) {
                    $region = $Matches[1]
                    break
                }
            }
            catch {
                Write-Host " Error querying $url :`n $_"
                # $region = "CN"
            }
        }
    }
    return $region
}

function Get_location_region {
    $region = $global:LOCATION_REGION 
    if ( $region -eq "Unknown") {
        $region = get_region 
        $region = $region.Trim() 
        write-host " Get Region: $region" -ForegroundColor Green
        $global:LOCATION_REGION = $region 
    }

    if ( $region -eq "Unknown") {        
        $prompt = "`n Get Unknow region, set to CN ? (Default:Y) [Y/N]"
        $confirmation = Read-Host $prompt
        
        # 处理空输入（直接回车）和首尾空格
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) {
            $userInput = 'Y'  # 设置默认值
        }

        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            # 此处放置同意后的执行代码
            $region = 'CN' 
            write-host " Set Region: $region, LOCATION_REGION=$global:LOCATION_REGION" -ForegroundColor Red
        }
    }
    
    return $region
}

function Get_proxy_url {
    param (
        # Parameter help description
        # [Parameter(AttributeValues)]
        [string]$Url,
        [string]$proxy = $global:URL_PROXY
        # [string]$proxy = "https://proxy.180102.xyz/proxy/"
        # [string]$proxy = "https://proxy.zwdk.org/proxy/"
    )
    
    $region = Get_location_region
    $proxy_url = $Url
    if ($region -eq "CN") {
        $proxy_url = $proxy + $proxy_url
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
        # # 排除整个文件夹, 避免安全检测
        # Add-MpPreference -ExclusionPath $targetDir
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
    $url_target = Get_proxy_url -Url $Url 
    $release = Invoke-RestMethod -Uri $url_target -Headers @{
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
        # 创建下载目录
        $downloadDir = Get_download_path $SubPath
    }


    process {
        try {
            # 转换仓库地址为 API 路径
            $apiUrl = url_from_repo_2_api -Url $RepositoryUrl

            # 获取发布信息
            # Write-Host " Fetch info. from GitHub API (releases/latest) ... " -ForegroundColor Cyan
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
            }
            else {
                Write-Host " Find target: $($selectedAsset.name)" -ForegroundColor Green
            }

            # 创建下载目录
            $downloadDir = Get_download_path $SubPath
            # $downloadDir = New-Item -Path $sfld -ItemType Directory -Force
            # Write-Host " Target Dir: $($downloadDir)" -ForegroundColor Blue

            # 下载文件
            $url_target = Get_proxy_url -Url $selectedAsset.browser_download_url
            Write-Host " Target Url: $($url_target)" -ForegroundColor Blue
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
            Write-Error " Network connect failed: $($_.Exception.Message)"
        }
        catch {
            Write-Error " Action failed: $($_.Exception.Message)"
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
    function Show_manage_python_menu {
        Clear-Host
        Write-Host "========== Python Management ==========" -ForegroundColor Green
        Write-Host "  1. Install Python Latest              "
        Write-Host "  2. Install Python by ver.             "
        Write-Host "  3. Install pyenv                      " -ForegroundColor Yellow
        Write-Host "  4. Install pipenv                     "
        Write-Host "  5. Install Poetry                     " -ForegroundColor Blue
        Write-Host "  6. Install Julia                      "
        Write-Host " 98. Set poetry Mirror                  " #-ForegroundColor Blue
        Write-Host " 99. Set Pip Mirror                     " -ForegroundColor Green 
        Write-Host "  0. Back                               "
        Write-Host "=======================================" -ForegroundColor Green
    }
    function show_jill_usage {
        Write-Host "========== Jill Usage ==========" -ForegroundColor Green
        Write-Host "Usage: jill install [options] "
        Write-Host "   > jill upstream                       # Check available Julia upstream sources"
        Write-Host "   > jill install --upstream USTC        # Install Julia from USTC source"
        Write-Host "   > jill install --install_dir './'     # Install Julia to current directory"
        Write-Host "================================" -ForegroundColor Green
    }
    function py_install_pyenv {
        # 下载 pyenv 安装脚本
        $sfld = "./"
        $file = "install-pyenv-win.ps1"
        $url_dl = "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1"
        $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        $url_target = Get_proxy_url -Url $url_dl
        write-host "File URL: $url_target"
        Invoke-WebRequest -Uri $url_target -OutFile $targetFilePath            # 
        # Start-BitsTransfer -Source $url_target -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green

        # 安装 pyenv 
        write-host " Installing pyenv..." -ForegroundColor Green
        &"$targetFilePath"
        write-host " Success: pyenv installed, restart PowerShell to take effect." -ForegroundColor Green
    }
    # 设置 pip 源
    function Set-Pip-Mirror {
        Write-Host " Select Source: "
        Write-Host " 1. AliYun  "
        Write-Host " 2. TUNA    "
        Write-Host " 3. USTC    "
        Write-Host " 4. Custom  "
        Write-Host " 0. Back    "
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
        # Pause
    }
    # 设置 pip 源
    function Set-Pip-Mirror2 {
        Write-Host " Select Source: "
        Write-Host " 1. AliYun  "
        Write-Host " 2. TUNA    "
        Write-Host " 3. USTC    "
        Write-Host " 4. 163     "
        Write-Host " 5. Douban  "
        Write-Host " 6. Tencent "
        Write-Host " 7. Custom  "
        Write-Host " 0. Back    "
        $mirror_choice = Read-Host "Enter choice"
        $mirrorURL = switch ($mirror_choice) {
            "1" { "https://mirrors.aliyun.com/pypi/simple/" }
            "2" { "https://pypi.tuna.tsinghua.edu.cn/simple/" }
            "3" { "https://pypi.mirrors.ustc.edu.cn/simple/" }
            "4" { "https://mirrors.163.com/pypi/simple/" }
            "5" { "https://pypi.doubanio.com/simple/" }
            "6" { "https://mirrors.cloud.tencent.com/pypi/simple/" }
            "7" { Read-Host "Enter custom pip mirror URL" }
            "0" { return }
            default { Write-Host "Invalid input"; return }
        }
        switch ($mirror_choice) {
            "1" { 
                pip config set global.index-url "http://mirrors.aliyun.com/pypi/simple" 
                pip config set global.trusted-host "mirrors.aliyun.com" 
             }             
            "2" { 
                pip config set global.index-url "https://pypi.tuna.tsinghua.edu.cn/simple/e" 
                pip config set global.trusted-host "pypi.tuna.tsinghua.edu.cn" 
             }
            "3" { 
                pip config set global.index-url "https://pypi.mirrors.ustc.edu.cn/simple/" 
                pip config set global.trusted-host "pypi.mirrors.ustc.edu.cn" 
             }
            "4" { 
                pip config set global.index-url "https://mirrors.163.com/pypi/simple/" 
                pip config set global.trusted-host "mirrors.163.com" 
             }
            "5" { 
                pip config set global.index-url "https://pypi.doubanio.com/simple/" 
                pip config set global.trusted-host "pypi.doubanio.com" 
             }
            "6" { 
                pip config set global.index-url "https://mirrors.cloud.tencent.com/pypi/simple/" 
                pip config set global.trusted-host "mirrors.cloud.tencent.com" 
             }
            "7" { 
                pip config set global.index-url $mirrorURL
                # pip config set global.trusted-host "mirrors.aliyun.com" 
             }
        }

        pip config set global.disable-pip-version-check true
        pip config set global.timeout 30

        Write-Host "Pip mirror set to: $mirrorURL" -ForegroundColor Green
        # Pause
    }
    function Set-poetry-source {
        Write-Host "`n Select Mirror: "
        Write-Host "================================"
        Write-Host " 1. AliYun      " -ForegroundColor Green
        Write-Host " 2. TUNA        "
        Write-Host " 3. USTC        "
        Write-Host " 4. Doubanio    "
        Write-Host " 5. Custom      "
        Write-Host " 0. Back        "
        Write-Host "================================"
        $mirror_choice = Read-Host "Enter choice"
        switch ($mirror_choice) {
            "1" { poetry source add aliyun   "https://mirrors.aliyun.com/pypi/simple/"   --default  }
            "2" { poetry source add tsinghua "https://pypi.tuna.tsinghua.edu.cn/simple/" --default  }
            "3" { poetry source add ustc     "https://pypi.mirrors.ustc.edu.cn/simple/"  --default  }
            "4" { poetry source add doubanio "https://pypi.doubanio.com/simple/"         --default  }
            "5" { 
                $URL = Read-Host "Enter custom poetry mirror URL"  
                poetry source add custom $URL --default 
            }
            "0" { return }
            default { Write-Host "Invalid input"; return }
        }
    }
    function Install-Poetry {
        Write-Host " Select Install Option: "
        Write-Host "================================"
        Write-Host " 1. Official      "
        Write-Host " 2. pip           "
        Write-Host " 3. Set source    "
        Write-Host " 0. Back          "
        Write-Host "================================"
        $mirror_choice = Read-Host "Enter choice"
        switch ($mirror_choice) {
            "1" { 
                (Invoke-WebRequest -Uri "https://install.python-poetry.org" -UseBasicParsing).Content | python - 
                # write-host "`nPoetry installed! Please add %USERPROFILE%\.local\bin to your PATH `n" -ForegroundColor Green
                # write-host "`nPoetry installed! Please add %APPDATA%\pypoetry\venv\Scripts to your PATH `n" -ForegroundColor Green
                write-host "`nPoetry installed! Please add %APPDATA%\Python\Scripts to your PATH `n" -ForegroundColor Green
                
                $prompt = "`n Add %APPDATA%\Python\Scripts to your PATH ? (Default:Y) [Y/n]"
                $confirmation = Read-Host $prompt                
                # 处理空输入（直接回车）和首尾空格
                $userInput = $confirmation.Trim()
                if ([string]::IsNullOrEmpty($userInput)) {
                    $userInput = 'Y'  # 设置默认值
                }
                # 使用正则表达式进行智能匹配
                if ($userInput -match '^(y|yes)$') {
                    $tarpath = $env:APPDATA + "\Python\Scripts"
                    # [Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "User") + ";%APPDATA%\Python\Scripts", "User")
                    [Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "User") + ";$tarpath", "User")
                }else{
                    Write-Host ""
                    write-host " 1. In order to use poetry, please add %APPDATA%\Python\Scripts to your PATH " -ForegroundColor Green
                    write-host " 2. Directory path for poetry: %APPDATA%\pypoetry\venv\Scripts " -ForegroundColor Green
                }
            }
            "2" { pip install --user poetry; Pause }
            "3" { 
                # write-host "Change source: " -ForegroundColor Green
                # write-host " 1. > poetry source add tsinghua https://pypi.tuna.tsinghua.edu.cn/simple --default " -ForegroundColor Green
                # write-host " 2. > poetry source add tsinghua https://mirrors.aliyun.com/pypi/simple --default " -ForegroundColor Green
                # write-host " 3. > poetry source add tsinghua https://pypi.doubanio.com/simple --default " -ForegroundColor Green 
                Set-poetry-source
                # Pause 
             }
            "0" { return }
            default { Write-Host "Invalid input"; return }
        }
    }

    while ($true) {
        Show_manage_python_menu
        $py_choice = Read-Host "Enter your choice" 
        switch ($py_choice) {
            "1" { Install-Software "Python.Python" "python" "https://www.python.org/downloads/"; Pause }
            "2" { 
                $py_version = Read-Host "Enter the Python version (e.g., 3.11.5)"
                Install-Software "Python.Python --version $py_version" "python --version $py_version" "https://www.python.org/downloads/release/python-$py_version/"
                Pause 
            }
            "3" { py_install_pyenv; Pause }
            "4" { python -m pip install --upgrade pip; python -m pip install pipenv; Pause }
            "5" { Install-Poetry; Pause   }
            "6" { show_jill_usage; pip install jill; jill install; Pause }

            "98" { Set-poetry-source; Pause }
            "99" { Set-Pip-Mirror2; Pause   }
            # "7" { Set-Pip-Mirror; Pause   }
            "0" { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; Pause }
        }
    }
}

# 常用软件安装
function Software_install {
    function Shwo_software_menu {
        Clear-Host
        Write-Host "======  Software Installation ======" -ForegroundColor Cyan
        Write-Host "  1. Install 7-Zip                  "
        Write-Host "  2. Install Notepad++              "
        Write-Host "  3. Install VS Code                "
        Write-Host "  4. Install GO-Lang                "
        Write-Host "  5. Install Node.js                " -ForegroundColor Blue
        Write-Host "  6. Install LocalSend              " -ForegroundColor Green
        Write-Host "  0. Back to Main Menu              "
        Write-Host "====================================" -ForegroundColor Cyan
    }
    while ($true) {
        Shwo_software_menu
        $soft_choice = Read-Host "Enter your choice (1-4)"        
        switch ($soft_choice) {
            "1" { Install-Software "7zip.7zip" "7zip" "https://www.7-zip.org/download.html" }
            "2" { Install-Software "Notepad++.Notepad++" "notepadplusplus" "https://notepad-plus-plus.org/downloads/" }
            "3" { Install-Software "Microsoft.VisualStudioCode" "vscode" "https://code.visualstudio.com/download" }
            "4" { 
                Write-Host "`n GoLang URL: https://go.dev/dl/ `n" -ForegroundColor Green
                $go_version = Read-Host "Enter the GO version (e.g., 1.24.2)"
                if ($go_version -eq "") { $go_version = "1.24.2" }
                $gourl = "https://go.dev/dl/go$go_version.windows-amd64.msi"
                Start-BitsTransfer -Source $gourl -Destination  './'            # 适合下载大文件或需要后台下载的场景
                write-host "Success download GO-Lang: v$go_version" -ForegroundColor Green                
             }
             "5" {
                # Download and install fnm:
                winget install Schniz.fnm
                # Download and install Node.js:
                $JSver = Read-Host "Enter the Node.js version (e.g., 22)"
                if ($JSver -eq "") { $JSver = "22" }
                fnm install $JSver
                # Verify the Node.js version:
                node -v # Should print "v22.15.0".
                # Verify npm version:
                npm -v # Should print "10.9.2".
             }
            "6" { winget install localsend }
            "0" { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; Pause }
        }
    }
}

# 系统设置
function System_Settings {
    function Show_system_menu {
        Clear-Host
        Write-Host "======= System Settings ===============" -ForegroundColor Yellow
        Write-Host "  1. Set PowerShell Execution Policy   "
        Write-Host "  2. Set Default Shell to pwsh         "
        Write-Host "  3. Enable OpenSSH Service            "
        Write-Host "  "
        Write-Host "  4. Open Port                         " -ForegroundColor Green
        Write-Host "  5. Add Task (run_wh)                 " 
        Write-Host "  6. Set GO-cn                         " -ForegroundColor Blue
        Write-Host "  7. Install cnpm                      " 
        Write-Host "  "
        Write-Host "  8. Install nssm                      "
        Write-Host "  9. Download WinSW                    "  -ForegroundColor Blue
        Write-Host " 10. Download Shawl                    " 
        Write-Host "  "
        Write-Host " 11. Setup frp service                 " 
        Write-Host " 12. Setup alist service               " 
        Write-Host " 13. Setup zoraxy service              " 
        Write-Host " 14. Setup gm-api service              " -ForegroundColor Green
        Write-Host " 15. Setup gm-csv service              " 
        Write-Host "  "
        Write-Host " 99. Show reinstall for win 2025       " -ForegroundColor Green
        Write-Host "  0. Back                              " 
        Write-Host "=======================================" -ForegroundColor Yellow
    }
    # 启用 OpenSSH 服务
    function Enable-OpenSSH {
        Write-Host "Enabling OpenSSH server ..."
        Write-Host " Note: OpenSSH install need Windows Update service."
        Add-WindowsFeature -Name OpenSSH-Server
        Set-Service -Name sshd -StartupType Automatic
        Start-Service sshd
        Write-Host "OpenSSH is enabled!" -ForegroundColor Green
        # Pause
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
        # Pause
    }
    # 安装nssm
    function install_nssm {
        $sfld = 'Apps'
        $targetDir = process_download_dir $sfld 
        # $targetDir = Get_download_path $sfld 
        # $nssm_url = "https://nssm.cc/release/nssm-2.24.zip"
        $nssm_url = "https://ypora.zwdk.org/d/app/nssm-2.24.zip"
        # $nssm_url = "https://ypkxus.133119.xyz/d/a/apps/nssm-2.24.zip"
        $nssm_file = "$targetDir/nssm-2.24.zip"

        # 下载并安装 NSSM
        write-host " "
        write-host "File URL: $nssm_url"
        Invoke-WebRequest -Uri $nssm_url -OutFile $nssm_file
        Expand-Archive -Path $nssm_file -Force -DestinationPath "C:\nssm"
        Copy-Item "C:\nssm\nssm-2.24\win64\nssm.exe" -Force -Destination "C:\Windows"
        Write-Host "nssm installed!" -ForegroundColor Green
        
        # 创建服务
        write-host " "
        write-host "===== Create service: frps ==================================="
        # 创建服务（指定 frps.exe 路径和参数）
        write-host 'nssm install frps'
        write-host 'nssm set frps Application "C:\frp\frps.exe"'
        write-host 'nssm set frps AppParameters "-c C:\frp\frps.toml"'
        write-host 'nssm set frps AppDirectory "C:\frp"'
        write-host 'nssm set frps Start SERVICE_AUTO_START'
        # Write-Host ' > nssm install frps "C:\frp\frps.exe" -c "C:\frp\frps.toml"'
        # write-host " "
        # Write-Host ' > nssm start frps           # start frps service '  
        # Write-Host ' > nssm stop frps            # stop frps service '  
        # Write-Host ' > nssm restart frps         # restart frps service '  
        # Write-Host ' > nssm remove frps          # remove frps service '
        # Write-Host ' > nssm remove frps confirm  # revomve frps service with confirm '
        write-host " "

        # 启动服务
        nssm start frps

        Pause
    }

    function download_winsw {
        # https://github.com/winsw/winsw/releases/download/v2.12.0/WinSW-x64.exe
        # https://github.com/winsw/winsw/releases/latest/download/WinSW-x64.exe
        process_download_dir
        $url_gh = "https://github.com/winsw/winsw"
        $fpattern = ".*WinSW-x64.exe"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    function download_winsw2 {        
        param(
            [string]$targetDir = "./APPs",
            [string]$file = "WinSW-x64.exe"
        )
        # https://github.com/winsw/winsw/releases/download/v2.12.0/WinSW-x64.exe
        # https://github.com/winsw/winsw/releases/latest/download/WinSW-x64.exe
        
        # $file = "WinSW-x64.exe"
        $url_dl = Get_proxy_url "https://github.com/winsw/winsw/releases/latest/download/WinSW-x64.exe"
        
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success download: $targetFilePath" -ForegroundColor Green
    }
    function download_shawl {
        process_download_dir
        $url_gh = "https://github.com/mtkennerly/shawl"
        $fpattern = ".*-win64.zip"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    function set_sw_frp {
        param([string]$sfld = "c:\frp")
        $targetDir = $sfld
        if (-not (Test-Path -Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir
            # # 排除整个文件夹, 避免安全检测
            $prompt = "`n To exclude $sfld from Windows Defender? (Default:Y) [Y/n]"
            $confirmation = Read-Host $prompt
            $userInput = $confirmation.Trim()
            if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
            # 使用正则表达式进行智能匹配
            if ($userInput -match '^(y|yes)$') {
                Add-MpPreference -ExclusionPath $targetDir
            }
        } 
        
        $file = "frp-win64.zip"
        $url_dl = "https://ypora.zwdk.org/d/app/gm/$file"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success download: $targetFilePath" -ForegroundColor Green

        # 解压文件
        Expand-Archive -Path $targetFilePath -DestinationPath $targetDir -Force

        
        $prompt = "`n To open web Port(7400,7500)?(Default:N) [y/N]"
        $confirmation = Read-Host $prompt
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'n' }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            Add_port_in 7400 
            Add_port_in 7500 
        }
        
        $prompt = "`n To download WinSW? (Default:Y) [Y/n]"
        $confirmation = Read-Host $prompt
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            download_winsw2 $targetDir "sw_frpc.exe"
        }
        
        $srcfile = Join-Path -Path $targetDir -ChildPath "sw_frpc.exe"
        $tarfile = Join-Path -Path $targetDir -ChildPath "sw_frps.exe"
        Copy-Item -Path $srcfile -Force -Destination $tarfile
        # Copy-Item "$targetDir\winsw.exe" -Force -Destination '$targetDir\sw_frps.exe'
        # Remove-Item "$targetDir\winsw.exe"

        $prompt = "`n Remove target file:$targetFilePath? (Default:Y) [Y/n]"
        $confirmation = Read-Host $prompt
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) {
            $userInput = 'y'  # 设置默认值
        }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            Remove-Item $targetFilePath
        }
        
    }
    
    function Add_task_scheduler_gm_wh {
        param([string]$sfld = "c:\gm_api")
        # 以管理员运行
        if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -Command `"& '$PSCommandPath'`"" -Verb RunAs
            return 
        }

        $tsk_dir  = $sfld
        $tsk_path = "$sfld\run_wh.bat"
        $tsk_name = "gm_wh"
        $currentUser = "$env:USERDOMAIN\$env:USERNAME" # 当前用户
        # $tsk_user = "NT AUTHORITY\SYSTEM" # 服务账户 
        $action   = New-ScheduledTaskAction -Execute $tsk_path -WorkingDirectory $tsk_dir
        $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Seconds 0)

        # $trigger  = New-ScheduledTaskTrigger -AtStartup
		# 系统启动触发器
        $BootTrigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay 00:05:00
        # 每日定时触发器（带容错机制）
        $DailyTrigger = New-ScheduledTaskTrigger -Daily -At "00:30:00" -RandomDelay (New-TimeSpan -Minutes 15)
        # 合并触发器数组
        $Triggers = @($BootTrigger, $DailyTrigger)

        Register-ScheduledTask -TaskName $tsk_name -Action $action -Trigger $Triggers -Settings $Settings -Description "This task runs gm_wh.bat." -RunLevel Highest -User $currentUser
        Write-Host " Task Added: $tsk_path"  -ForegroundColor Green

    }
    function set_sw_gmapi {
        param([string]$sfld = "c:\gm_api")
        $targetDir = $sfld
        if (-not (Test-Path -Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir
            $prompt = "`n To exclude $sfld from Windows Defender? (Default:Y) [Y/n]"
            $confirmation = Read-Host $prompt
            $userInput = $confirmation.Trim()
            if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
            # 使用正则表达式进行智能匹配
            if ($userInput -match '^(y|yes)$') {
                Add-MpPreference -ExclusionPath $targetDir
            }
        } 
        
        $file = "gmapi-py-win64.zip"
        $url_dl = "https://ypora.zwdk.org/d/app/gm/$file"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success download: $targetFilePath" -ForegroundColor Green

        # 解压文件
        Expand-Archive -Path $targetFilePath -DestinationPath $targetDir
        
        # 添加万和运行环境计划任务 
        $prompt = "`n To add Task (run_wh)? (Default:Y) [Y/n]"
        $confirmation = Read-Host $prompt
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            add_task_scheduler_gm_wh $targetDir
        }

        $prompt = "`n To download WinSW? (Default:Y) [Y/n]"
        $confirmation = Read-Host $prompt
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            download_winsw2 $targetDir "sw_gmapi.exe"
        }

        $prompt = "`n To remove target file:$targetFilePath? (Default:Y) [Y/n]"
        $confirmation = Read-Host $prompt
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            Remove-Item $targetFilePath
        }
    }
    function set_sw_gmcsv {
        param([string]$sfld = "c:\gm_csv")
        $targetDir = $sfld
        if (-not (Test-Path -Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir
            $prompt = "`n To exclude $sfld from Windows Defender? (Default:Y) [Y/n]"
            $confirmation = Read-Host $prompt
            $userInput = $confirmation.Trim()
            if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
            # 使用正则表达式进行智能匹配
            if ($userInput -match '^(y|yes)$') {
                Add-MpPreference -ExclusionPath $targetDir
            }
        } 
        
        $file = "gmcsv-go-win64.zip"
        $url_dl = "https://ypora.zwdk.org/d/app/gm/$file"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success download: $targetFilePath" -ForegroundColor Green

        # 解压文件
        Expand-Archive -Path $targetFilePath -DestinationPath $targetDir
        
        $prompt = "`n To download WinSW? (Default:Y) [Y/n]"
        $confirmation = Read-Host $prompt
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            download_winsw2 $targetDir "sw_gmcsv.exe"
        }

        $prompt = "`n To remove target file:$targetFilePath? (Default:N) [y/N]"
        $confirmation = Read-Host $prompt
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) {
            $userInput = 'n'  # 设置默认值
        }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            Remove-Item $targetFilePath
        }
    }
    function set_sw_zoraxy {
        param([string]$sfld = "c:\zoraxy")
        $targetDir = $sfld
        if (-not (Test-Path -Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir
            # # 排除整个文件夹, 避免安全检测            
            $prompt = "`n To exclude $sfld from Windows Defender? (Default:Y) [Y/n]"
            $confirmation = Read-Host $prompt
            $userInput = $confirmation.Trim()
            if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
            # 使用正则表达式进行智能匹配
            if ($userInput -match '^(y|yes)$') {
                Add-MpPreference -ExclusionPath $targetDir
            }
        } 
        
        $xmlFileName = "$sfld\sw_zoraxy.xml"
        $xmlContent = @"
<service>
  <id>zoraxy</id>
  <name>Zoraxy-Server</name>
  <description>This service runs zoraxy Server.</description>
  <executable>zoraxy_windows_amd64.exe</executable>
  <log mode="roll"></log>
</service>
"@
        $xmlContent | Out-File -FilePath $xmlFileName -Encoding ASCII
        Write-Host " WinSW config file saved: $xmlFileName" -ForegroundColor Green
        
        $prompt = "`n To open Port(80,443)?(Default:Y) [Y/n]"
        $confirmation = Read-Host $prompt
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            Add_port_in 80 
            Add_port_in 443 
        }

        
        $file = "zoraxy_windows_amd64.exe"
        # $url_dl = "https://ypora.zwdk.org/d/app/gm/$file"
        $url_dl = Get_proxy_url "https://github.com/tobychui/zoraxy/releases/latest/download/zoraxy_windows_amd64.exe"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success download: $targetFilePath" -ForegroundColor Green

        $prompt = "`n To download WinSW? (Default:Y) [Y/n]"
        $confirmation = Read-Host $prompt
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            download_winsw2 $targetDir "sw_zoraxy.exe"
        }
    }
    function set_sw_alist {
        param([string]$sfld = "c:\alist")
        $targetDir = $sfld
        if (-not (Test-Path -Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir
            # # 排除整个文件夹, 避免安全检测            
            $prompt = "`n To exclude $sfld from Windows Defender? (Default:Y) [Y/n]"
            $confirmation = Read-Host $prompt
            $userInput = $confirmation.Trim()
            if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
            # 使用正则表达式进行智能匹配
            if ($userInput -match '^(y|yes)$') {
                Add-MpPreference -ExclusionPath $targetDir
            }
        } 
        
        $vbsFileName = "$sfld\run.vbs"
        $vbsContent = @"
Dim ws
Set ws = Wscript.CreateObject("Wscript.Shell")
ws.run "alist.exe server",vbhide
Wscript.quit
"@
        $vbsContent | Out-File -FilePath $vbsFileName -Encoding ASCII
        Write-Host " Run .vbs file saved: $vbsFileName" -ForegroundColor Green
        
        $vbsFileName = "$sfld\stop.vbs"
        $vbsContent = @"
Dim ws
Set ws = Wscript.CreateObject("Wscript.Shell")
ws.run "taskkill /f /im alist.exe",0
Wscript.quit
"@
        $vbsContent | Out-File -FilePath $vbsFileName -Encoding ASCII
        Write-Host " Stop .vbs file saved: $vbsFileName" -ForegroundColor Green

        $xmlFileName = "$sfld\sw_alist.xml"
        $xmlContent = @"
<service>
  <id>alist</id>
  <name>Alist-Server</name>
  <description>This service runs Alist Server.</description>
  <executable>alist.exe</executable>
  <arguments>server</arguments>
  <log mode="roll"></log>
</service>
"@
        $xmlContent | Out-File -FilePath $xmlFileName -Encoding ASCII
        Write-Host " WinSW config file saved: $xmlFileName" -ForegroundColor Green
        
        $prompt = "`n To open Port(:5244)?(Default:N) [y/N]"
        $confirmation = Read-Host $prompt
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'n' }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            Add_port_in 5244 
        }

        
        $file = "alist-windows-amd64.zip"
        $url_dl = Get_proxy_url "https://github.com/AlistGo/alist/releases/latest/download/alist-windows-amd64.zip"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success download: $targetFilePath" -ForegroundColor Green
        
        # 解压文件
        Expand-Archive -Path $targetFilePath -DestinationPath $targetDir
        
        $prompt = "`n To remove target file:$targetFilePath? (Default:Y) [Y/n]"
        $confirmation = Read-Host $prompt
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            Remove-Item $targetFilePath
        }

        $prompt = "`n To download WinSW? (Default:Y) [Y/n]"
        $confirmation = Read-Host $prompt
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) { $userInput = 'y' }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            download_winsw2 $targetDir "sw_alist.exe"
        }
    }
    while ($true) {
        Show_system_menu
        $sys_choice = Read-Host "Enter choice " 
        switch ($sys_choice) {
            "1" { Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; Write-Host "Execution policy set!";  }
            "2" { Set-DefaultShell-Pwsh }
            "3" { Enable-OpenSSH }
            "4" { 
                $port = Read-Host "Enter port need to set inbound (e.g.: 5000)"
                if ( ($port -ne "") -and ($port -match "^\d+$") -and ($port -le 65535) -and ($port -ge 1) )  { 
                    Add_port_in $port
                }else {
                    write-host " !!! Invalid input for port:  $port"
                }
                 
            }
            "5" { Add_task_scheduler_gm_wh;  }
            "6" { 
                # go env -w GO111MODULE=on; 
                go env -w GOPROXY=https://goproxy.cn,direct; 
                Write-Host "GO(cn) set!" -ForegroundColor Green
                 
            }
            "7"  { npm install -g cnpm --registry=https://registry.npmmirror.com }
            "8"  { install_nssm }
            "9"  { download_winsw }
            "10" { download_shawl }

            "11" { set_sw_frp;  }
            "12" { set_sw_alist;  }
            "13" { set_sw_zoraxy; }
            "14" { set_sw_gmapi;  }
            "15" { set_sw_gmcsv;  }
            "99" { Write-Host "Comand for reinstall: `n./reinstall.bat windows --image-name 'Windows server 2025 Serverdatacenter' --iso 'https://iso.zwdk.org/win2025'`n" -ForegroundColor Green;;  }
            "0"  { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red;  }
        }
        Pause
    }
}


function App_download {
    $sfld = 'Apps'
    $targetDir = process_download_dir $sfld
    
    function Show_Menu_app_download {
        Clear-Host
        Write-Host "========== Download Menu =============" -ForegroundColor Cyan
        Write-Host "   1. Git                  " -NoNewline 
        Write-Host "  51. QBittorrent          " -ForegroundColor Blue
        Write-Host "   2. frp                  " -NoNewline -ForegroundColor Blue
        Write-Host "  52. VC_redist(x64)       "  
        Write-Host "   3. 7zip                 " -NoNewline -ForegroundColor Yellow
        Write-Host "  53. RustDesk-Server      "  
        Write-Host "   4. VSCode               " -NoNewline 
        Write-Host "  54. RustDesk             " -ForegroundColor Green
        Write-Host "   5. 1Remote              " -NoNewline  -ForegroundColor Green
        Write-Host "  55. ToDesk               "  
        Write-Host "   6. Notepad++            " -NoNewline
        Write-Host "  56. WeChat               " 
        Write-Host "   7. PowerShell           " -NoNewline -ForegroundColor Blue  
        Write-Host "  57. xdown                " -ForegroundColor Blue
        Write-Host "   8. Python3.12.7         " -NoNewline
        Write-Host "  58. Pot-desktop          " 
        Write-Host "   9. Zoraxy               " -NoNewline -ForegroundColor Green
        Write-Host "  59. PotPlayer            " 
        Write-Host "  10. Nginx                " -NoNewline  
        Write-Host "  60. NorthStar(java)      " 
        Write-Host "  11. Go-Lang              " -NoNewline -ForegroundColor Blue
        Write-Host "  61. LocalSend            " -ForegroundColor Green
        Write-Host "  12. Node.js              " -NoNewline -ForegroundColor Blue
        Write-Host "  62. WanhoGM              " 
        Write-Host "  13. Rustup               " -NoNewline  
        Write-Host "  63. THS-Hevo             " 
        Write-Host "  14. dotNet9(Runtime)     " -NoNewline 
        Write-Host "  64. TG(x64)              " 
        Write-Host "  15. Podman(Desktop)      " -NoNewline 
        Write-Host "  65. Hiddify              " -ForegroundColor Blue
        Write-Host "  16.                      " -NoNewline -ForegroundColor Yellow
        Write-Host "  66. NekoBox              " -ForegroundColor Yellow
        # Write-Host "  17. Zoraxy               " -NoNewline
        # Write-Host "  67.                      " 
        # Write-Host "  18. Nginx                " -NoNewline
        # Write-Host "  68.                      " 
        Write-Host "  98. All                  " -NoNewline -ForegroundColor Green
        Write-Host "  99. reinstall.bat        " -ForegroundColor Cyan
        Write-Host "   0. Exit                 " -ForegroundColor Red
        Write-Host "======================================" -ForegroundColor Cyan
    }
    function download_tg {
        $file = "tg-win-x64.exe"
        $url_dl = Get_proxy_url "https://telegram.org/dl/desktop/win64"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_net9 {
        $file = "windowsdesktop-runtime-9.0.4-win-x64.exe"
        $url_dl = "https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/9.0.4/windowsdesktop-runtime-9.0.4-win-x64.exe"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_wechat {
        $file = "WeChatWin.exe"
        $url_dl = "https://dldir1v6.qq.com/weixin/Universal/Windows/WeChatWin.exe"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_rustup {
        $file = "rustup-init.exe"
        $url_dl = "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_vc_redist_x64_alist {
        $file = "VC_redist.x64.exe"
        $url_dl = "https://ypora.zwdk.org/d/app/$file"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_vc_redist_x64_ms {
        $file = "vc_redist.x64.exe"
        $url_dl = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_python3127 {
        $file = "python-3.12.7-amd64.exe"
        $url_dl = "https://ypora.zwdk.org/d/app/$file"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_vscode {
        Write-Host "======  VSCode version ======" -ForegroundColor Cyan
        Write-Host "  1. VScode(User)                  "
        Write-Host "  2. VScode(Admin)                 "
        Write-Host "=============================" -ForegroundColor Cyan
        $soft_choice = Read-Host " Enter your choice(1-2), default[1]"  
        if ($soft_choice -eq "2") {
            $file = "vscode-x64-admin.exe"
            $url_dl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
        }else{
            $file = "vscode-x64-user.exe"
            $url_dl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
        }
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_powershell {
        $url_gh = "https://github.com/PowerShell/PowerShell"
        $fpattern = ".*-win-x64.msi"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    function download_notepadpp {
        $url_gh = "https://github.com/notepad-plus-plus/notepad-plus-plus"
        $fpattern = ".*Installer.x64.exe"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
        
        # 下载 Notepad++ Julia语言配色方案
        $file = "npp_julia_style.xml"
        $url_dl = "https://ypora.zwdk.org/d/app/$file"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        # Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_reinstall {        
        $file = "reinstall.bat"
        # $url_gh = "https://github.com/bin456789/reinstall"
        $url_dl = Get_proxy_url "https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.bat"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        # Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_potplayer {        
        $file = "PotPlayerSetup64.exe"
        $url_dl = Get_proxy_url "https://t1.daumcdn.net/potplayer/PotPlayer/Version/Latest/PotPlayerSetup64.exe"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_golang { 
        Write-Host "`n GoLang URL: https://go.dev/dl/ `n" -ForegroundColor Green
        $appver = "1.24.2"
        $userInput = Read-Host "Enter ToDesk version (e.g., $appver)"
        if ($userInput.Trim() -ne "") { $appver = $userInput.Trim() }
        # $go_version = Read-Host "Enter the GO version (e.g., 1.24.2)"
        # if ($go_version -eq "") { $go_version = "1.24.2" }
        $file = "go$appver.windows-amd64.msi"
        $url_dl = "https://go.dev/dl/go$appver.windows-amd64.msi"
        # https://go.dev/dl/go1.24.2.windows-amd64.msi
        
        # $url_dl = Get_proxy_url $url_dl
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_nodejs { 
        Write-Host "`n Node.js URL: https://nodejs.org/zh-cn/download `n" -ForegroundColor Green
        $appver = "22.16.0"
        $userInput = Read-Host "Enter ToDesk version (e.g., $appver)"
        if ($userInput.Trim() -ne "") { $appver = $userInput.Trim() }
        # $njs = Read-Host "Enter Node.js version (e.g., 22.15.0)"
        # if ($njs -eq "") { $njs = "22.15.0" }
        $file = "node-v$appver-x64.msi"
        $url_dl = "https://nodejs.org/dist/v$appver/node-v$appver-x64.msi"
        # https://nodejs.org/dist/v22.16.0/node-v22.16.0-x64.msi
        
        # $url_dl = Get_proxy_url $url_dl
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_todesk { 
        Write-Host "`n ToDesk URL: https://www.todesk.com/ `n" -ForegroundColor Green
        $appver = "4.7.7.1"
        $userInput = Read-Host "Enter ToDesk version (e.g., $appver)"
        if ($userInput.Trim() -ne "") { $appver = $userInput.Trim() }
        $file = "ToDesk_$appver.exe"
        $url_dl = "https://dl.todesk.com/irrigation/$file"
        # https://dl.todesk.com/irrigation/ToDesk_4.7.6.3.exe
        
        # $url_dl = Get_proxy_url $url_dl
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_xdown { 
        Write-Host "`n xDown URL: https://www.xdown.org/ `n" -ForegroundColor Green
        $appver = "2.0.9.5"
        $userInput = Read-Host "Enter ToDesk version (e.g., $appver)"
        if ($userInput.Trim() -ne "") { $appver = $userInput.Trim() }
        # $appver = Read-Host "Enter xdown version (e.g., 2.0.9.4)"
        # if ($appver -eq "") { $appver = "2.0.9.4" }
        $file = "xdown-$appver.zip"
        $url_dl = "https://dl.xdown.dev/windows/i386/$file"
        # https://dl.xdown.dev/windows/i386/xdown-2.0.9.4.zip
        
        # $url_dl = Get_proxy_url $url_dl
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_qbittorrent { 
        Write-Host "`n QBittorent URL: https://www.qbittorrent.org `n" -ForegroundColor Green

        # 定义 qBittorrent 的 SourceForge 项目 URL
        $SF_PROJECT_URL = "https://sourceforge.net/projects/qbittorrent"
        # 获取最新版本号
        # $RSS = Invoke-WebRequest -Uri "$SF_PROJECT_URL/rss" # -UseBasicParsing
        $RSS = Invoke-RestMethod -Uri "$SF_PROJECT_URL/rss" # -UseBasicParsing
        # $LATEST_VERSION = ($RSS.Content -split "qbittorrent/qbittorrent/qbittorrent-" | Select-Object -Skip 1 | Select-Object -First 1) -split "/" | Select-Object -First 1
        $LATEST_VERSION = $RSS.Content[0].url
        if (-not $LATEST_VERSION) {
            Write-Host " !!! Cannot get QBittorent latest version. "
            return 
        }
        Write-Host " Get QBittorrent latest version: $LATEST_VERSION"

        # Windows 下载
        $file = $LATEST_VERSION -split "/" | Select-Object -Last 2 | Select-Object -First 1 
        # $url_dl = "${SF_PROJECT_URL}/files/qbittorrent/qbittorrent-${LATEST_VERSION}/${FILE_NAME}/download"
        $url_dl = $LATEST_VERSION
        # https://sourceforge.net/projects/qbittorrent/files/qbittorrent-win32/qbittorrent-5.1.0/qbittorrent_5.1.0_x64_setup.exe/download
        
        $url_dl = Get_proxy_url $url_dl
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_northstar {        
        $file = "northstar_env.ps1"
        $url_dl = Get_proxy_url "https://gitee.com/dromara/northstar/raw/master/env.ps1"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "`nGit URL: https://gitee.com/dromara/northstar`n"
        write-host "File URL: $url_dl"
        Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        # Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
        write-host "`nGit URL: https://gitee.com/dromara/northstar"
        write-host "exe URL: https://gitee.com/dromara/northstar/releases`n"
        write-host "Run NorthStar env installation ... "
        powershell -noexit "$targetFilePath"
        # Invoke-WebRequest $url_dl -OutFile $file; powershell -noexit ".\$file"
    }
    function download_rustdesk {
        $url_gh = "https://github.com/rustdesk/rustdesk"
        $fpattern = ".*-x86_64.exe"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    function download_rustdesk_server {
        $url_gh = "https://github.com/rustdesk/rustdesk-server"
        $fpattern = ".*-x86_64-unsigned.zip"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    function download_git {
        $url_gh = "https://github.com/git-for-windows/git"
        $fpattern = ".*-64-bit.exe"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    function download_podman_desktop {
        # https://github.com/podman-desktop/podman-desktop/releases/download/v1.18.1/podman-desktop-1.18.1-setup-x64.exe
        # https://github.com/podman-desktop/podman-desktop/releases/download/v1.18.1/podman-desktop-1.18.1-x64.exe
        $url_gh = "https://github.com/podman-desktop/podman-desktop"
        $fpattern = ".*-setup-x64.exe$"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    function download_1remote {
        $url_gh = "https://github.com/1Remote/1Remote"
        $fpattern = ".*-x64.zip$"
        # $fpattern = ".*net9-x64.zip"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    function download_hiddify {
        $url_gh = "https://github.com/hiddify/hiddify-app"
        $fpattern = ".*Portable-x64.zip"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    function download_zoraxy {     
        $file = "zoraxy_windows_amd64.exe"
        # $url_gh = "https://github.com/tobychui/zoraxy"
        $url_dl = Get_proxy_url "https://github.com/tobychui/zoraxy/releases/latest/download/zoraxy_windows_amd64.exe"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_nginx {     
        $fver = "1.28.0"
        $userInput = Read-Host "Enter Nginx version (e.g., $fver)"
        $userInput = $userInput.Trim()
        if ($userInput -ne "") { $fver = $userInput }
        $file = "nginx-$fver.zip"
        # $file = "nginx-1.28.0.zip"
        # $url_gh = "https://nginx.org/en/download.html"
        # $url_gh = "https://github.com/nginx/nginx.org"
        $url_dl = "https://nginx.org/download/$file"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_7zip_latest {
        $url_gh = "https://github.com/ip7z/7zip"
        $fpattern = ".*-x64.exe"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    function download_localsend_latest {
        $url_gh = "https://github.com/localsend/localsend"
        $fpattern = ".*-windows-x86-64.exe"
        # https://github.com/localsend/localsend/releases/download/v1.17.0/LocalSend-1.17.0-windows-x86-64.exe
        # https://github.com/localsend/localsend/releases/download/v1.17.0/LocalSend-1.17.0-windows-x86-64.zip
        
        $prompt = "`n Get Portable version of localsend? (Default:Y) [Y/N]"
        $confirmation = Read-Host $prompt
        
        # 处理空输入（直接回车）和首尾空格
        $userInput = $confirmation.Trim()
        if ([string]::IsNullOrEmpty($userInput)) {
            $userInput = 'Y'  # 设置默认值
        }
        # 使用正则表达式进行智能匹配
        if ($userInput -match '^(y|yes)$') {
            $fpattern = ".*-windows-x86-64.zip"
        }

        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    function download_pot_desktop {
        $url_gh = "https://github.com/pot-app/pot-desktop"
        $fpattern = ".*_x64-setup.exe"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    function download_nekobox_latest {
        $url_gh = "https://github.com/MatsuriDayo/nekoray"
        $fpattern = ".*-windows64.zip"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }
    }
    function download_nekobox_alist {
        $file = "nekoray-4.0.1-2024-12-12-windows64.zip"
        $url_dl = "https://ypora.zwdk.org/d/app/$file"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_ths_hevo {
        $file = "ths-hevo.exe"
        $url_dl = "https://download.10jqka.com.cn/index/download/id/275/"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_wanho_gm {
        $file = "Vanhogm.exe"
        $url_dl = "https://download.vanho.cn/download/juejin/Vanhogm.exe"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_wanho_alist {
        $file = "Vanhogm.exe"
        $url_dl = "https://ypora.zwdk.org/d/app/$file"
        # $targetDir = Get_download_path $sfld
        $targetFilePath = Join-Path -Path $targetDir -ChildPath $file
        write-host "File URL: $url_dl"
        # write-host "Target dir: $targetDir" -ForegroundColor Cyan
        # Invoke-WebRequest -Uri $url_dl -OutFile $targetFilePath            # 
        Start-BitsTransfer -Source $url_dl -Destination  $targetFilePath   # 适合下载大文件或需要后台下载的场景
        write-host "Success: $targetFilePath" -ForegroundColor Green
    }
    function download_frp {
        param([string]$sfld = "c:\frp")
        $targetDir = $sfld
        if (-not (Test-Path -Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir
            # # 排除整个文件夹, 避免安全检测
            Add-MpPreference -ExclusionPath $targetDir
        } 

        #=================================================
        function Generate_frps_ps1 {
            $batFileName = "$sfld\task_frps.ps1"
            $batContent = @'
# Run as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -Command `"& '$PSCommandPath'`"" -Verb RunAs
    exit
}

$tsk_dir  = "C:\frp"
$tsk_path = "$tsk_dir\frps.exe"

#========================================
$tsk_name = "frps"
$tsk_arg  = "-c frps.toml"
$tsk_user = "NT AUTHORITY\SYSTEM"
#========================================
$action  = New-ScheduledTaskAction -Execute $tsk_path -Argument $tsk_arg -WorkingDirectory $tsk_dir
$trigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName $tsk_name -Action $action -Trigger $trigger -RunLevel Highest -User $tsk_user

'@
            $batContent | Out-File -FilePath $batFileName -Encoding ASCII
            Write-Host " task_frps.ps1 file saved: $batFileName"
        }
        function Generate_frpc_ps1 {
            $batFileName = "$sfld\task_frpc.ps1"
            $batContent = @'
# Run as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -Command `"& '$PSCommandPath'`"" -Verb RunAs
    exit
}

$tsk_dir  = "C:\frp"
$tsk_path = "$tsk_dir\frpc.exe"

#========================================
$tsk_name = "frpc"
$tsk_arg  = "-c frpc.toml"
$tsk_user = "NT AUTHORITY\SYSTEM"
#========================================
$action  = New-ScheduledTaskAction -Execute $tsk_path -Argument $tsk_arg -WorkingDirectory $tsk_dir
$trigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName $tsk_name -Action $action -Trigger $trigger -RunLevel Highest -User $tsk_user

'@
            $batContent | Out-File -FilePath $batFileName -Encoding ASCII
            Write-Host " task_frpc.ps1 file saved: $batFileName"
        }
        function Generate_frps_port_ps1 {
            $batFileName = "$sfld\add_frps_port.ps1"
            $batContent = @'
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -Command `"& '$PSCommandPath'`"" -Verb RunAs
    return 
}
New-NetFirewallRule -DisplayName "Allow Port 7000 Inbound" `
                    -Direction Inbound `
                    -LocalPort 7000 `
                    -Protocol TCP `
                    -Action Allow
Write-Host " Add TCP inbound: 7000" -ForegroundColor Green

New-NetFirewallRule -DisplayName "Allow Port 7000 Outbound" `
                    -Direction Outbound `
                    -LocalPort 7000 `
                    -Protocol TCP `
                    -Action Allow
Write-Host " Add TCP outbound: 7000" -ForegroundColor Green

'@
            $batContent | Out-File -FilePath $batFileName -Encoding ASCII
            Write-Host " task_frps.ps1 file saved: $batFileName"
        }

        # Generate_frps_ps1
        # Generate_frpc_ps1
        # Generate_frps_port_ps1

        $url_gh = "https://github.com/fatedier/frp"
        $fpattern = ".*windows_amd64.zip"
        $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
        if (-not $downloadedFile) {
            Write-Host " Download failed" -ForegroundColor Red
        }

        # 以管理员运行
        # if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        #     Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -Command `"& '$PSCommandPath'`"" -Verb RunAs
        #     exit
        # }

        # $action = New-ScheduledTaskAction -Execute "C:\frp\frps.exe" -Argument "-c cfg.toml" -WorkingDirectory "C:\frp\frp"
        # $trigger = New-ScheduledTaskTrigger -AtStartup
        # Register-ScheduledTask -TaskName "FrpsService" -Action $action -Trigger $trigger -RunLevel Highest -User "NT AUTHORITY\SYSTEM"

    }
    function download_gm_api {
        # 生成 gm_api.py, cfg.toml, 生成 run_wh3.bat, 生成 run_gm.bat
        param([string]$sfld = "c:\gm_api")
        $targetDir = $sfld
        if (-not (Test-Path -Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir
            # # 排除整个文件夹, 避免安全检测
            Add-MpPreference -ExclusionPath $targetDir
        }
        function Generate_run_wh3_bat {
            param(
                [string]$batFileName = "c:\gm_api\run_wh.bat",
                [string]$exePath = "C:\Vanho Goldminer3\vanhogm3.exe"
            )

            $batContent = @"
start "" "$exePath" 
"@

            $batContent | Out-File -FilePath $batFileName -Encoding ASCII
            Write-Host " .bat file saved: $batFileName"
        }
        function Generate_run_gm_bat {
            param([string]$batFileName = "c:\gm_api\run_gm.bat")

            $batContent = @"
hypercorn gm_api:app -b 0.0.0.0:5000 --bind :::5000 --workers 9
"@

            $batContent | Out-File -FilePath $batFileName -Encoding ASCII
            Write-Host " .bat file saved: $batFileName"
        }
        function Generate_cfg_toml {
            param([string]$batFileName = "c:\gm_api\cfg.toml")

            $batContent = @"
[gm-api] # gm-api server config
debug = false
token = "9ac4d4a74c4daf280baa84512faf5612bac25ae3"
# token = "77613857b482f33d6d5e3cf90ec8cd67fd4effaa"

host  = ""
port  = 5000
workers = 4 
servertag = 'gm'
"@
            $batContent | Out-File -FilePath $batFileName -Encoding ASCII
            Write-Host " cfg.toml file saved: $batFileName"
        }
        function Generate_requirements_txt {
            param([string]$batFileName = "c:\gm_api\requirements.txt")

            $batContent = @"
annotated-types==0.7.0
anyio==4.9.0
cachetools==5.5.0
fastapi==0.115.12
gm==3.0.176
h11==0.14.0
h2==4.2.0
hpack==4.1.0
Hypercorn==0.17.3
hyperframe==6.1.0
idna==3.10
numpy==2.2.4
pandas==2.2.3
priority==2.0.0
protobuf==3.20.3
pydantic==2.11.3
pydantic_core==2.33.1
python-dateutil==2.9.0.post0
pytz==2025.2
setuptools==69.1.1
six==1.17.0
sniffio==1.3.1
starlette==0.46.2
toml==0.10.2
typing==3.7.4.3
typing-inspection==0.4.0
typing_extensions==4.13.2
tzdata==2023.3
wheel==0.45.1
wsproto==1.2.0
"@

            $batContent | Out-File -FilePath $batFileName -Encoding ASCII
            Write-Host " requirements.txt file saved: $batFileName"
        }
        function Generate_gm_api_py {
            param([string]$batFileName = "c:\gm_api\gm_api.py")

            $batContent = ""
            $batContent | Out-File -FilePath $batFileName -Encoding ASCII
            Write-Host " .py file saved: $batFileName"
        }
        function Add_task_scheduler_gm_api {
            # 以管理员运行
            if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
                Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -Command `"& '$PSCommandPath'`"" -Verb RunAs
                return 
            }

            $tsk_dir  = "C:\gm_api"
            $tsk_path = "C:\gm_api\run_gm.bat"
            $tsk_name = "gm_api"
            $tsk_user = "NT AUTHORITY\SYSTEM"
            $action   = New-ScheduledTaskAction -Execute $tsk_path -WorkingDirectory $tsk_dir
            $trigger  = New-ScheduledTaskTrigger -AtStartup
            Register-ScheduledTask -TaskName $tsk_name -Action $action -Trigger $trigger -RunLevel Highest -User $tsk_user
            Write-Host " Added task: $tsk_path"

        }
        function Add_task_scheduler_gm_wh {
            # 以管理员运行
            if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
                Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -Command `"& '$PSCommandPath'`"" -Verb RunAs
                return 
            }

            $tsk_dir  = "C:\gm_api"
            $tsk_path = "C:\gm_api\run_wh.bat"
            $tsk_name = "gm_wh"
            $tsk_user = "NT AUTHORITY\SYSTEM"
            $action   = New-ScheduledTaskAction -Execute $tsk_path -WorkingDirectory $tsk_dir
            $trigger  = New-ScheduledTaskTrigger -AtStartup
            Register-ScheduledTask -TaskName $tsk_name -Action $action -Trigger $trigger -RunLevel Highest -User $tsk_user
            Write-Host " Added task: $tsk_path" 

        }

        Generate_run_wh3_bat $(Join-Path -Path $targetDir -ChildPath "run_wh.bat") 
        Generate_run_gm_bat  $(Join-Path -Path $targetDir -ChildPath "run_gm.bat")  
        Generate_gm_api_py   $(Join-Path -Path $targetDir -ChildPath "gm_api.py")   
        Generate_cfg_toml    $(Join-Path -Path $targetDir -ChildPath "cfg.toml")    
        Generate_requirements_txt $(Join-Path -Path $targetDir -ChildPath "requirements.txt")  
        Add_task_scheduler_gm_api 
        Add_task_scheduler_gm_wh 
        Add_port_in 5000
    }

    
    function download_all_software {
        download_7zip_latest
        download_notepadpp
        download_python3127
        download_powershell
        download_vc_redist_x64_alist
        download_wanho_alist
        # download_wanho_gm
        # download_git
        # download_frp
        # download_nekobox_alist
        # download_nekobox_latest
        # download_hiddify
        # download_vscode
        # download_1remote
    }
    # 菜单循环
    while ($true) {
        Show_Menu_app_download
        $choice = Read-Host " Please select "
        switch ($choice) {
            # "1"  { download_vc_redist_x64_ms; }
            "1"  { download_git; }
            "2"  { download_frp; }
            "3"  { download_7zip_latest; }
            "4"  { download_vscode }
            "5"  { download_1remote; }
            "6"  { download_notepadpp }
            "7"  { download_powershell; }
            "8"  { download_python3127 }
            "9"  { download_zoraxy  }
            "10" { download_nginx }
            "11" { download_golang }
            "12" { download_nodejs }
            "13" { download_rustup }
            "14" { download_net9 }
            "15" { download_podman_desktop }
            "16" {  }

            "51" { download_qbittorrent; }
            "52" { download_vc_redist_x64_alist }
            "53" { download_rustdesk_server; }
            "54" { download_rustdesk; }
            "55" { download_todesk; }
            "56" { download_wechat; }
            "57" { download_xdown }
            "58" { download_pot_desktop }
            "59" { download_potplayer  }
            "60" { download_northstar }
            "61" { download_localsend_latest }
            "62" { download_wanho_alist }
            # "62" { download_wanho_gm }
            "63" { download_ths_hevo }
            "64" { download_tg }
            "65" { download_hiddify }
            "66" { download_nekobox_alist }
            # "65"  { download_nekobox_latest; }

            "98" { download_all_software }
            "99" { download_reinstall; }
            "0"  { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; }
        }
        # Pause 
        $null = Read-Host " Press Enter to continue "
    }
    
}

function GetRealURLforRedirect {
    param (
        $redirectUrl = "https://iso.zwdk.org/win2025"
    )
    # 要处理的重定向URL

    try {
        # 使用 Invoke-WebRequest 发送请求
        # -MaximumRedirection 属性指定允许的最大重定向次数
        # -UseBasicParsing 可以加快解析速度，因为我们只关心URL，不关心HTML内容
        $webRequest = Invoke-WebRequest -Uri $redirectUrl -MaximumRedirection 10 -UseBasicParsing -ErrorAction Stop

        # 获取重定向后的真实URL
        $finalUrl = $webRequest.BaseResponse.ResponseUri.AbsoluteUri

        # 打印最终的URL
        Write-Host " 重定向的真实链接: $redirectionUrl `n$finalUrl" -ForegroundColor Green

        # 你现在可以在脚本中使用 $finalUrl 变量
        # 例如：
        # Invoke-WebRequest -Uri $finalUrl -OutFile "downloaded_file.txt"
        # "真实链接的长度: $($finalUrl.Length)"

    } catch {
        Write-Error "获取真实链接时发生错误: $($_.Exception.Message)"
    }
}

function show_github_links {
    Clear-Host
    Write-Host "========== GitHub Urls ============" -ForegroundColor Cyan
    # GetRealURLforRedirect
    # GetRealURLforRedirect "https://iso.zwdk.org/win2025"
    # GetRealURLforRedirect "https://iso.zwdk.org/win2022"
    # Write-Host ''
    
    Write-Host " 51. Windows(.iso) : 
    https://iso.zwdk.org/win2025
    https://iso.zwdk.org/win2022
    
    https://ypkxus.133119.xyz/d/a/sys/zh-cn_windows_server_2025_updated_nov_2024_x64_dvd_ccbcec44.iso
    https://ypkxus.133119.xyz/d/qbd/sys/zh-cn_windows_server_2025_updated_may_2025_x64_dvd_9c776dbb.iso
    https://ypora.zwdk.org/d/sys/zh-cn_windows_server_2025_updated_nov_2024_x64_dvd_ccbcec44.iso
    https://ypora.zwdk.org/d/sys/zh-cn_windows_server_2022_updated_nov_2024_x64_dvd_4e34897c.iso
    https://ypora.zwdk.org/d/sys/zh-cn_windows_11_business_editions_version_24h2_x64_dvd_5f9e5858.iso
    
    DD cmd: 
        reinstall.bat windows 
            --image-name 'Windows server 2025 Serverdatacenter' 
            --iso 'https://ypkxus.133119.xyz/d/qbd/sys/zh-cn_windows_server_2025_updated_may_2025_x64_dvd_9c776dbb.iso'

            
        reinstall.bat windows 
            --image-name 'Windows server 2025 Serverdatacenter' 
            --iso 'https://iso.zwdk.org/win2025'

        reinstall.bat windows 
            --image-name 'Windows server 2022 Serverdatacenter' 
            --iso 'https://iso.zwdk.org/win2022'
    "

    Write-Host " 52. Windows(images) : 
    https://next.itellyou.cn/Original
    https://msdl.gravesoft.dev
    https://www.xitongku.com
    https://massgrave.dev
    "
    
    Write-Host "  1. Docker-win : 
    https://github.com/dockur/windows-arm/
    https://github.com/dockur/windows
    https://github.com/dockur/macos
    https://github.com/qemus/qemu-docker
    https://github.com/sickcodes/Docker-OSX
    "

    Write-Host "  2. reinstall.bat : 
    https://github.com/bin456789/reinstall
    https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.bat
    "

    Write-Host "  3. KejiLion.sh : 
    https://github.com/kejilion/sh
    https://kejilion.pro/kejilion.sh
    https://raw.githubusercontent.com/kejilion/sh/main/kejilion.sh
    "

    Write-Host "  4. warp(@fscarmen) : 
    https://gitlab.com/fscarmen/warp
    https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh
    "

    Write-Host "  4. Sing-box(@fscarmen) : 
    https://github.com/fscarmen/sing-box
    https://raw.githubusercontent.com/fscarmen/sing-box/main/sing-box.sh
    "

    Write-Host "  5. Warp(@ygkkk) : 
    https://github.com/yonggekkk/warp-yg
    https://raw.githubusercontent.com/yonggekkk/warp-yg/main/CFwarp.sh
    "

    Write-Host "  5. Sing-box(@ygkkk) : 
    https://github.com/yonggekkk/sing-box-yg
    https://raw.githubusercontent.com/yonggekkk/sing-box-yg/main/serv00.sh
    "

    Write-Host "  6. NeZha : 
    https://nezhainfojson.pages.dev/
    https://nezhadash-docs.buycoffee.top/custom-code
    https://wiziscool.github.io/Nezha-Traffic-Alarm-Generator/
    "

    Write-Host "===============================" -ForegroundColor Cyan
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

    Write-Host "  5. Pot-Desktop : 
    https://github.com/pot-app/pot-desktop
    https://github.com/pot-app/pot-desktop/releases/download/3.0.6/pot_3.0.6_x64-setup.exe
    "

    Write-Host "  6. 7Zip : 
    https://www.7-zip.org/download.html
    https://www.7-zip.org/a/7z2409-x64.exe
    https://github.com/ip7z/7zip
    https://github.com/ip7z/7zip/releases/download/24.09/7z2409-x64.exe
    "

    Write-Host "  7. Git : 
    https://git-scm.com/downloads/win
    https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/Git-2.49.0-64-bit.exe
    "

    Write-Host "  8. VSCode : 
    https://code.visualstudio.com/Download
    https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user 
    "

    Write-Host "  9. Notepad++ : 
    https://notepad-plus-plus.org/downloads/
    https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.7.8/npp.8.7.8.Installer.x64.exe
    "

    Write-Host " 10. frp : 
    https://github.com/fatedier/frp
    https://github.com/fatedier/frp/releases/download/v0.61.2/frp_0.61.2_windows_amd64.zip
    "

    Write-Host " 11. rustdesk : 
    https://github.com/rustdesk/rustdesk
    https://github.com/rustdesk/rustdesk/releases/download/1.3.8/rustdesk-1.3.8-x86_64.exe
    "

    Write-Host " 12. 1Remote : 
    https://github.com/1Remote/1Remote
    https://github.com/1Remote/1Remote/releases/download/1.1.1/1Remote-1.1.1-net6-x64-250124.zip
    "

    Write-Host " 13. Hiddify : 
    https://github.com/hiddify/hiddify-app
    https://github.com/hiddify/hiddify-app/releases/download/v2.5.7/Hiddify-Windows-Portable-x64.zip
    https://github.com/hiddify/hiddify-app/releases/download/v2.5.7/Hiddify-Windows-Setup-x64.exe
    "

    Write-Host " 14. WanHo : 
    http://www.wanhesec.com.cn/main/views/softwareDownload/index.html
    https://download.vanho.cn/download/juejin/Vanhogm.exe
    "

    Write-Host " 15. PTrade : 
    https://www.i618.com.cn/main/companybusi/wealth/quantitativetrading/ptrade/index.shtml
    https://www.i618.com.cn/plat_files/upload/source_upload/20250321/%E4%BB%BF%E7%9C%9F-PTrade1.0-Client-V202407-09-001(%E5%B1%B1%E8%A5%BF-FZ).zip
    https://www.i618.com.cn/plat_files/upload/source_upload/20250321/%E7%94%9F%E4%BA%A7-PTrade1.0-Client-V202407-09-001(%E5%B1%B1%E8%A5%BF).zip
    "

    Write-Host " 16. THS : 
    https://www.10jqka.com.cn
    https://download.10jqka.com.cn/index/download/id/275/ Hevo-THS
    https://sp.thsi.cn/staticS3/mobileweb-upload-static-server.file/app_6/downloadcenter/THS_freeldy_9.40.40_0228.exe
    "

    Write-Host " 17. GO : 
    https://go.dev
    https://go.dev/dl/
    https://go.dev/dl/go1.24.2.windows-amd64.msi
    Set Proxy: go env -w GOPROXY=https://goproxy.cn,direct
    "

    Write-Host " 18. Node.js : 
    https://nodejs.org
    https://nodejs.org/zh-cn/download
    https://nodejs.org/dist/v22.16.0/node-v22.16.0-x64.msi
    Add cnpm: npm install -g cnpm --registry=https://registry.npm.taobao.org
    Add yarn: corepack enable yarn
    Add pnpm: corepack enable pnpm
    "

    Write-Host " 19. LocalSend : 
    https://localsend.org/download
    https://d.localsend.org/LocalSend-1.17.0-windows-x86-64.exe
    https://github.com/localsend/localsend/releases/download/v1.17.0/LocalSend-1.17.0-windows-x86-64.exe
    Install: winget install LocalSend
    "

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
        Write-Host "========== Tool Menu =========="  -ForegroundColor Cyan
        Write-Host "  1. Activate Tool             "  #-ForegroundColor Blue 
        Write-Host "  2. App Download              "  -ForegroundColor Green
        Write-Host "  3. App Install               "
        Write-Host "  4. Web Links                 "  -ForegroundColor Yellow
        Write-Host "  5. GitHub Links              "  
        Write-Host "  6. Symtem Setting            "  -ForegroundColor Green  
        Write-Host "  7. Python Management         "  
        Write-Host "  8. Show region               "  -ForegroundColor Cyan 
        Write-Host "  9. Show Excludepath          " 
        Write-Host " 10. Test Connection           "  -ForegroundColor Blue
        Write-Host " 99. ReBoot System             "  -ForegroundColor Red
        Write-Host "  x. Exit                      "  #-ForegroundColor Red
        Write-Host "==============================="  -ForegroundColor Cyan
    }
    # 菜单循环
    while ($true) {
        Show-Menu
        $choice = Read-Host "Enter your choice"
        switch ($choice) {
            "1"  { activate_win_office }
            "2"  { App_download }
            "3"  { Software_install }
            "4"  { show_web_links; Pause }
            "5"  { show_github_links; Pause }
            "6"  { System_Settings }
            "7"  { Manage_Python }
            "8"  { $region = Get_location_region; Write-Host "`n It is: $region, LOCATION_REGION=$global:LOCATION_REGION `n" -ForegroundColor Green ; Pause }
            "9"  { Get-MpPreference | Select-Object -ExpandProperty ExclusionPath ; Pause }
            "10" { $port = Read-Host "Enter port(default: 5000)"; if (!$port) { $port = 5000 }; Test-NetConnection -ComputerName localhost -Port $port ; Pause }
            "99" { shutdown /r /t 0 }
            "x"  { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; Pause }
        }
    }
    
}


main_menu 

# # 使用示例


# $region = get_region 
# Write-Host $region 

# $url_gh = "https://github.com/PowerShell/PowerShell"
# $fpattern = ".*-win-x64.exe"
# # $url_gh = "https://github.com/microsoft/vscode"
# # $url_gh = "https://github.com/python/cpython"
# $url_gh = "https://github.com/MatsuriDayo/nekoray"
# $fpattern = ".*-windows64.zip"

# # $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl "https://github.com/PowerShell/PowerShell"
# $downloadedFile = Get-GitHubLatestRelease -RepositoryUrl $url_gh -FileNamePattern $fpattern
# if ($downloadedFile) {
#     Write-Host " Download OK: $($downloadedFile.FullName)" -ForegroundColor Green
# }

# 查找包含 Python 3.12 的 Windows 安装包
# Get-GitHubLatestRelease -RepositoryUrl "https://github.com/python/cpython" `
#                        -FileNamePattern "python-3\.12.*-win.*\.exe"

# 排除测试版本
# Get-GitHubLatestRelease -RepositoryUrl "https://github.com/microsoft/vscode" `
#                        -ExcludePattern "insider|exploration"
