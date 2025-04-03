# https://developer.aliyun.com/article/1654250
const fs = require('fs');
const {
    exec } = require('child_process');

// 检查是否安装了 Docker
exec('docker --version', (error, stdout, stderr) => {
   
    if (error) {
   
        console.error("Docker 未安装，请先安装 Docker。");
        process.exit(1);
    }
    console.log(stdout.trim());

    // 配置文件路径
    const CONFIG_FILE = 'docker-images.txt';

    // 检查配置文件是否存在
    if (!fs.existsSync(CONFIG_FILE)) {
   
        console.error(`配置文件 ${
     CONFIG_FILE} 不存在。`);
        process.exit(1);
    }

    // 读取配置文件并逐行处理
    fs.readFile(CONFIG_FILE, 'utf8', (err, data) => {
   
        if (err) {
   
            console.error(`读取配置文件 ${
     CONFIG_FILE} 失败:`, err);
            process.exit(1);
        }

        const lines = data.split('\n');

        lines.forEach(line => {
   
            const trimmedLine = line.trim();

            // 跳过空行和注释行（以 # 开头）
            if (trimmedLine === '' || trimmedLine.startsWith('#')) {
   
                return;
            }

            // 提取镜像名称和标签
            const parts = trimmedLine.split(':');
            const IMAGE_NAME = parts[0];
            const IMAGE_TAG = parts.length > 1 ? parts[1] : 'latest';

            // 下载 Docker 镜像
            console.log(`正在下载 Docker 镜像: ${
     IMAGE_NAME}:${
     IMAGE_TAG}`);
            exec(`docker pull ${
     IMAGE_NAME}:${
     IMAGE_TAG}`, (error, stdout, stderr) => {
   
                if (error) {
   
                    console.error(`Docker 镜像 ${
     IMAGE_NAME}:${
     IMAGE_TAG} 下载失败。`);
                    console.error(stderr);
                    process.exit(1);
                }
                console.log(`Docker 镜像 ${
     IMAGE_NAME}:${
     IMAGE_TAG} 下载成功。`);
                console.log(stdout);
            });
        });
    });
});
