
function Generate_wh3_bat {
    param(
        [string]$exePath = "C:\Vanho Goldminer3\vanhogm3.exe",
        [string]$batFileName = "c:\gm_api\run_wh3.bat"
    )

    $batContent = @"
start "" "$exePath" 
"@

    $batContent | Out-File -FilePath $batFileName -Encoding ASCII

    Write-Host " .bat file saved: $batFileName"
}


Generate_wh3_bat 


