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
    [string]$Server,
    [string]$dbname
    )


Function Update-Facter {
    Param([string]$fileName)
    $DBFacts="C:\ProgramData\PuppetLabs\facter\facts.d\DBFacts.txt"
	if (Test-Path $DBFacts) {
		Remove-Item ${DBFacts}; 
	} Else {
		Write-Host "Updating facter to sql_backupfile_name=${fileName}"
	}
	New-Item ${DBFacts} -ItemType file;
	Add-Content ${DBFacts} sql_backupfile_name=${fileName}
    
}
Function Read-Facter {
	$DBFacts="C:\ProgramData\PuppetLabs\facter\facts.d\DBFacts.txt";
	$text = Get-Content "$DBFacts"
	$property = "sql_backupfile_name"
	$pattern = "(?-s)(?<=$($property)=).+"

	$value = $text | sls $pattern | %{$_.Matches} | %{$_.Value}
	Write-Host $value
}

$tStamp = Get-Date -format yyyyMMddHHmm

 

Read-Facter
