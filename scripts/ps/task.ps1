# 以管理员运行
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -Command `"& '$PSCommandPath'`"" -Verb RunAs
    exit
}

$action = New-ScheduledTaskAction -Execute "C:\path\to\frps.exe" -Argument "-c cfg.toml" -WorkingDirectory "C:\path\to\frp"
$trigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName "FrpsService" -Action $action -Trigger $trigger -RunLevel Highest -User "NT AUTHORITY\SYSTEM"

