$newPath = "C:\Program Files\PowerShell\7\pwsh.exe"
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\PowerShell.exe"
New-ItemProperty -Path $registryPath -Name "(Default)" -Value $newPath -PropertyType String -Force