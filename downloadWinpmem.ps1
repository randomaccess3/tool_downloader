$toolURL = "https://github.com/Velocidex/c-aff4/releases/download/3.2/winpmem_3.2.exe"
#Write-Host $toolURL

$output = "$PSScriptRoot\winpmem.exe"
$start_time = Get-Date

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($toolURL, $output)
#OR
#(New-Object System.Net.WebClient).DownloadFile($toolURL, $output)

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)" #>