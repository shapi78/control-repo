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
 
Function Update-Facter {
    Param([string]$isSQL)
    $SQLFacts="C:\ProgramData\PuppetLabs\facter\facts.d\SQLFacts.txt"
	if (Test-Path $SQLFacts) {
		Remove-Item ${SQLFacts}; 
	} Else {
		Write-Host "Updating facter to sqlserver=${isSQL}"
	}
	New-Item ${SQLFacts} -ItemType file;
	Add-Content ${SQLFacts} sqlserver=${isSQL}
    
}

if (Test-Path "HKLM:\Software\Microsoft\Microsoft SQL Server\Instance Names\SQL" ) {
	write-host "SQL Installed"
	Update-Facter "1"
} Else {
	write-host "SQL is not installed"
	Update-Facter "0"
}
 



