# 检查是否安装了 Docker
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
   
    Write-Output "Docker 未安装，请先安装 Docker。"
    exit 1
}
# https://developer.aliyun.com/article/1654250
# 配置文件路径
$CONFIG_FILE = "docker-images.txt"

# 检查配置文件是否存在
if (-not (Test-Path $CONFIG_FILE)) {
   
    Write-Output "配置文件 $CONFIG_FILE 不存在。"
    exit 1
}

# 读取配置文件并逐行处理
Get-Content $CONFIG_FILE | ForEach-Object {
   
    $line = $_.Trim()

    # 跳过空行和注释行（以 # 开头）
    if ([string]::IsNullOrEmpty($line) -or $line.StartsWith("#")) {
   
        return
    }

    # 提取镜像名称和标签
    $parts = $line -split ':'
    $IMAGE_NAME = $parts[0]
    $IMAGE_TAG = if ($parts.Length -gt 1) {
    $parts[1] } else {
    "latest" }

    # 下载 Docker 镜像
    Write-Output "正在下载 Docker 镜像: ${IMAGE_NAME}:${IMAGE_TAG}"
    $result = docker pull "${IMAGE_NAME}:${IMAGE_TAG}"

    # 检查镜像是否下载成功
    if ($LASTEXITCODE -eq 0) {
   
        Write-Output "Docker 镜像 ${IMAGE_NAME}:${IMAGE_TAG} 下载成功。"
    } else {
   
        Write-Output "Docker 镜像 ${IMAGE_NAME}:${IMAGE_TAG} 下载失败。"
        exit 1
    }
}
