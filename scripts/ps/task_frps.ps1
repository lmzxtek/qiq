# 以管理员运行
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

