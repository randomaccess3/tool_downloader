$baseURL = "https://owl.phy.queensu.ca/~phil/exiftool/"
$versionURL = $baseURL + "ver.txt"

$version = Invoke-WebRequest $versionURL
$toolURL = $baseURL+"exiftool-"+$version+".zip"
#Write-Host $toolURL

$output = "$PSScriptRoot\exiftool.zip"
$start_time = Get-Date

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($toolURL, $output)
#OR
(New-Object System.Net.WebClient).DownloadFile($toolURL, $output)

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)" #>