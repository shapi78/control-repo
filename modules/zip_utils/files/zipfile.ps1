Param(
    [string]$fileToZip
    )
Add-Type -assembly 'System.IO.Compression'
Add-Type -assembly 'System.IO.Compression.FileSystem'
[string]$folder = (Get-Item $fileToZip ).DirectoryName
[string]$zipFile = (Get-Item $fileToZip).BaseName + ".zip"
$zipFileName =  Join-Path $folder $zipFile
[System.IO.Compression.ZipArchive]$ZipFile = [System.IO.Compression.ZipFile]::Open($zipFileName, ([System.IO.Compression.ZipArchiveMode]::Update))
[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($ZipFile, $fileToZip, (Split-Path $fileToZip -Leaf))
$ZipFile.Dispose()