$toolURL = "https://www.digital-detective.net/software/DCode-v4.02a-build-4.02.0.9306.zip"
#Write-Host $toolURL

$output = "$PSScriptRoot\DCode-v4.02a-build-4.02.0.9306.zip"
$start_time = Get-Date

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($toolURL, $output)
#OR
#(New-Object System.Net.WebClient).DownloadFile($toolURL, $output)

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)" #>