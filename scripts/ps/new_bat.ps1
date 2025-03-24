# 指定要运行的程序路径（替换为你的实际路径）
$exePath = "C:\Vanho Goldminer3\vanhogm3.exe"

# 定义批处理文件名
$batFileName = "c:\gm_api\run_wh3.bat"

# 创建批处理文件内容
$batContent = @"
start "" "$exePath"
"@

# 生成.bat文件
$batContent | Out-File -FilePath $batFileName -Encoding ASCII

# 可选：执行批处理文件（移除下面行的注释符#以启用）
# Start-Process $batFileName

Write-Host " 批处理文件已创建：$batFileName "

