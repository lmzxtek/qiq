https://developer.aliyun.com/article/1654250

using System;
using System.IO;
using System.Diagnostics;

namespace ConsoleApp1;

class Program
{
   
    static async Task Main(string[] args)
    {
   
        // 检查是否安装了 Docker
        if (!await IsDockerInstalledAsync())
        {
   
            Console.WriteLine("Docker 未安装，请先安装 Docker。");
            Environment.Exit(1);
        }

        // 配置文件路径
        string config_file = "docker-images.txt";

        // 检查配置文件是否存在
        if (!File.Exists(config_file))
        {
   
            Console.WriteLine($"配置文件 {config_file} 不存在。");
            Environment.Exit(1);
        }

        // 读取配置文件并逐行处理
        string[] lines = File.ReadAllLines(config_file);

        foreach (string line in lines)
        {
   
            string trimmedLine = line.Trim();

            // 跳过空行和注释行（以 # 开头）
            if (string.IsNullOrEmpty(trimmedLine) || trimmedLine.StartsWith("#"))
            {
   
                continue;
            }

            // 提取镜像名称和标签
            string[] parts = trimmedLine.Split(':');
            string image_name = parts[0];
            string image_tag = parts.Length > 1 ? parts[1] : "latest";

            // 下载 Docker 镜像
            Console.WriteLine($"正在下载 Docker 镜像: {image_name}:{image_tag}");
            if (await PullDockerImageAsync(image_name, image_tag))
            {
   
                Console.WriteLine($"Docker 镜像 {image_name}:{image_tag} 下载成功。");
            }
            else
            {
   
                Console.WriteLine($"Docker 镜像 {image_name}:{image_tag} 下载失败。");
                Environment.Exit(1);
            }
        }
    }

    static async Task<bool> IsDockerInstalledAsync()
    {
   
        try
        {
   
            ProcessStartInfo psi = new()
            {
   
                FileName = "docker",
                Arguments = "--version",
                RedirectStandardOutput = true,
                UseShellExecute = false,
                CreateNoWindow = true
            };

            using Process process = new() {
    StartInfo = psi };
            process.Start();
            string output = await process.StandardOutput.ReadToEndAsync();
            await process.WaitForExitAsync();
            await Console.Out.WriteLineAsync(output.Trim());
            return process.ExitCode == 0;
        }
        catch
        {
   
            return false;
        }
    }

    static async Task<bool> PullDockerImageAsync(string imageName, string imageTag)
    {
   
        try
        {
   
            ProcessStartInfo psi = new()
            {
   
                FileName = "docker",
                Arguments = $"pull {imageName}:{imageTag}",
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true
            };

            using Process process = new() {
    StartInfo = psi };
            process.Start();
            string output = await process.StandardOutput.ReadToEndAsync();
            string error = await process.StandardError.ReadToEndAsync();
            await process.WaitForExitAsync();
            await Console.Out.WriteLineAsync(output.Trim());
            if (!string.IsNullOrEmpty(error))
            {
   
                Console.WriteLine(error);
            }
        }
        catch (Exception ex)
        {
   
            Console.WriteLine($"发生错误: {ex.Message}");
            return false;
        }
    }
}
