# 禁用进度条以提升下载速度
# $ProgressPreference = 'SilentlyContinue'

# 获取最新发布版本信息
$releaseAPI = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
$response = Invoke-RestMethod -Uri $releaseAPI -Headers @{
    "Accept" = "application/vnd.github.v3+json"
}

# 根据系统类型选择安装包
$systemMap = @{
    "Windows" = @{
        "x64"    = "win-x64.msi"
        "Arm64"  = "win-arm64.msi"
    }
    "Linux"   = @{
        "x64"    = "linux-x64.tar.gz"
        "Arm64"  = "linux-arm64.tar.gz"
    }
    "MacOS"   = @{
        "x64"    = "osx-x64.pkg"
        "Arm64"  = "osx-arm64.pkg"
    }
}

# 自动检测系统信息
$os = if ($env:OS -eq 'Windows_NT') { "Windows" } else { $PSVersionTable.OS.Split()[0] }
$arch = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "Arm64" }

# 匹配安装包文件名
$assetPattern = ".*$($systemMap[$os][$arch])$"
$downloadFile = $response.assets | Where-Object name -match $assetPattern | Select-Object -First 1

if ($downloadFile) {
    # 创建下载目录
    $downloadDir = Join-Path $env:TEMP "PowerShell-$(Get-Date -Format 'yyyyMMdd')"
    New-Item -ItemType Directory -Path $downloadDir -Force | Out-Null

    # 下载文件
    Write-Host "正在下载 PowerShell $($response.tag_name)..." -ForegroundColor Cyan
    $localPath = Join-Path $downloadDir $downloadFile.name
    Invoke-WebRequest -Uri $downloadFile.browser_download_url -OutFile $localPath

    # 打开下载目录
    if ($os -eq "Windows") {
        Start-Process explorer.exe -ArgumentList "/select,`"$localPath`""
    } else {
        Write-Host "文件已保存到: $localPath"
    }

    # 安装提示
    Write-Host "`n下载完成，请手动执行以下操作：" -ForegroundColor Green
    switch ($os) {
        "Windows" {
            Write-Host "1. 右键以管理员身份运行安装程序"
            Write-Host "2. 或使用以下命令安装：msiexec /package `"$localPath`""
        }
        "Linux" {
            Write-Host "解压并安装：tar zxf `"$localPath`" -C /usr/local/"
        }
        "MacOS" {
            Write-Host "双击打开安装包：open `"$localPath`""
        }
    }
} else {
    Write-Error "未找到适用于当前系统 ($os-$arch) 的安装包"
}