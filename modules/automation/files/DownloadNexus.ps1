$DownloadURL = "http://nexus3/repository/yos-test/sp/sd/yos-test/1.1.1.1/yos-test-1.1.1.1-debug.Zip"
$DownloadFolder = "C:\Drop"
$FileName = $DownloadURL.SubString($DownloadURL.LastIndexOf('/') + 1)
$OutputFile = "$DownloadFolder\$FileName"
$request = Invoke-WebRequest -Uri $DownloadURL -MaximumRedirection 0 -ErrorAction Ignore -OutFile $OutputFile
