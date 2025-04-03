#!/bin/bash

# https://developer.aliyun.com/article/1654250
# 检查是否安装了 Docker
if ! command -v docker &> /dev/null
then
    echo "Docker 未安装，请先安装 Docker。"
    exit 1
fi

# 检查配置文件是否存在
CONFIG_FILE="docker-images.txt"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "配置文件 $CONFIG_FILE 不存在。"
    exit 1
fi

# 读取配置文件并逐行处理
while IFS= read -r line
do
    # 跳过空行和注释行（以 # 开头）
    if [[ -z "$line" || "$line" =~ ^# ]]; then
        continue
    fi

    # 提取镜像名称和标签
    IMAGE_NAME=$(echo "$line" | cut -d':' -f1)
    IMAGE_TAG=$(echo "$line" | cut -d':' -f2)

    # 如果 IMAGE_TAG 为空，则默认为 latest
    if [ -z "$IMAGE_TAG" ]; then
        IMAGE_TAG="latest"
    fi

    # 下载 Docker 镜像
    echo "正在下载 Docker 镜像: ${IMAGE_NAME}:${IMAGE_TAG}"
    docker pull "${IMAGE_NAME}:${IMAGE_TAG}"

    # 检查镜像是否下载成功
    if [ $? -eq 0 ]; then
        echo "Docker 镜像 ${IMAGE_NAME}:${IMAGE_TAG} 下载成功。"
    else
        echo "Docker 镜像 ${IMAGE_NAME}:${IMAGE_TAG} 下载失败。"
        exit 1
    fi
done < "$CONFIG_FILE"
