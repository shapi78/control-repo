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
    [string]$FactKey,
    [string]$FactValue,
    [string]$FactFileName,
    )


Function Update-Facter {
    Param([string]$fileName)
    $FactFileFullPath="C:\ProgramData\PuppetLabs\facter\facts.d\${fileName}"
	if (Test-Path $FactFileFullPath) {
		Remove-Item ${FactFileFullPath}; 
	} Else {
		Write-Host "Updating facter to ${FactKey}=${FactValue}"
	}
	New-Item ${FactFileFullPath} -ItemType file;
	Add-Content ${FactFileFullPath} "${FactKey}=${FactValue}
    
}
Function Read-Facter {
	$pattern = "(?-s)(?<=$($property)=).+"
	$value = $text | sls $pattern | %{$_.Matches} | %{$_.Value}
	Write-Host $value
}

if ($FactFileName -NotLike "*.txt") {
	$FactFileFullPath="C:\ProgramData\PuppetLabs\facter\facts.d\${FactFileName}"+".txt"
}
 

Update-Facter
