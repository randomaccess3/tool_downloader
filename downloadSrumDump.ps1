$toolURL = "https://github.com/MarkBaggett/srum-dump/archive/refs/heads/master.zip"
#Write-Host $toolURL

$output = "$PSScriptRoot\SRUMDUMP2.zip"
$start_time = Get-Date

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($toolURL, $output)
#OR
#(New-Object System.Net.WebClient).DownloadFile($toolURL, $output)

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)" #>