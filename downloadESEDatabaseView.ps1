$toolURL = "https://www.nirsoft.net/utils/esedatabaseview.zip"
#Write-Host $toolURL

$output = "$PSScriptRoot\esedatabaseview.zip"
$start_time = Get-Date

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($toolURL, $output)
#OR
(New-Object System.Net.WebClient).DownloadFile($toolURL, $output)

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)" #>