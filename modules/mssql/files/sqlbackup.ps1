<#
     .SYNOPSIS
          Backup Database
     .DESCRIPTION
          Back up an SQL Server to file in specific folder.
      
     .PARAMETER  folder
          Full path for the backup file. Must be local
     .PARAMETER  Server
          The name\instance of the SQL Server.
     .PARAMETER  database
          The name of the database to be backup
     .EXAMPLE
          PS C:\> Sqlbackup -file 'D:\Backups\mydb.bak' `
            -server 'MyServr\SQLinstance' -dbname NEWDB
    
#>
 
Param(
    [string]$folder,
    [string]$Server = "localhost",
    [string]$dbname,
    [string]$version

    )

Function Compress-Zip ([string]$fileToZip) # Full path fileName
	{
	Add-Type -assembly 'System.IO.Compression'
	Add-Type -assembly 'System.IO.Compression.FileSystem'
	[string]$folder = (Get-Item $fileToZip ).DirectoryName
	[string]$zipFile = $dbname + ".zip"
	$Global:zipFileName =  Join-Path $folder $zipFile
	Write-Host "zipFileName $zipFileName"
	[System.IO.Compression.ZipArchive]$ZipFile = [System.IO.Compression.ZipFile]::Open($zipFileName, ([System.IO.Compression.ZipArchiveMode]::Update))
	[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($ZipFile, $fileToZip, (Split-Path $fileToZip -Leaf))
	$ZipFile.Dispose()

}
Function Update-Facter {
    Param([string]$fileName)
    $facts=@{}
    $backup_fact = @{} 
    $key = "backup_${dbname}"
    $DBFacts="C:\ProgramData\PuppetLabs\facter\facts.d\backup_${dbname}.json"
	$facts['db_name'] = $dbname
	$facts['folder'] = $folder
	$facts['timestamp'] = $tStamp
	$facts['version'] = $version
	$facts['backup_file_name'] = $fileName
	$backup_fact[$key] = $facts

	if (Test-Path $DBFacts) {
		Remove-Item ${DBFacts}; 
	} Else {
		Write-Host "Updating facter with facts:"
		$backup_fact| ConvertTo-Json
	
	}
	
	New-Item ${DBFacts} -ItemType file;
	$backup_fact| ConvertTo-Json | Out-File -Encoding ASCII   ${DBFacts}
    
}

$tStamp = Get-Date -format yyyyMMddHHmm

 

$BakFileName = $dbname + "_" + $tStamp + ".bak"

$fullBakFileName = Join-Path $folder $BakFileName

TRY 
{
	Backup-SqlDatabase -ServerInstance $Server -Database $dbname -BackupFile $fullBakFileName
	
} 
CATCH  

{
	$Database.Name + " backup failed." 
	$_.Exception.Message
	
 
} 

Write-Host "Backup file $fullFileName was created for DB $dbname "
Compress-Zip -fileToZip $fullBakFileName
Write-Host "$fullBakFileName was Zip compressed to $zipFileName"
Update-Facter $zipFileName
