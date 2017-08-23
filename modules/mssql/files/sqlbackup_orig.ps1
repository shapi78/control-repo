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
            -server 'MyServr\SQLinstance' -database NEWDB
    
#>
 
Param(
    [string]$folder,
    [string]$Server,
    [string]$database
    )
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null


# The folder in your bucket to copy, including trailing slash. Leave blank to copy the entire bucket


$tStamp = Get-Date -format yyyyMMddHHmm
$srv = New-Object ("Microsoft.SqlServer.Management.Smo.Server") $Server
$dbs = New-Object Microsoft.SqlServer.Management.Smo.Database 
$dbs = $srv.Databases 
 
foreach ($Database in $dbs | where {$_.name -eq $database}) 
{ 
$Database.name 
Write-Host "Database Name is set to $($Database.name)"
$bk = New-Object ("Microsoft.SqlServer.Management.Smo.Backup") 
$bk.Action = [Microsoft.SqlServer.Management.Smo.BackupActionType]::Database 
# $bk.Action = "Database"
$bk.BackupSetDescription = "Full backup of " + $Database.name
$bk.BackupSetName = $Database.Name + "_backup_" + $tStamp
$bk.Database = $Database.Name 
# $bk.CompressionOption = 1 
$bk.MediaDescription = "Disk"
$bk.Devices.AddDevice($folder + "\" + $Database.Name + "_" + $tStamp + ".bak", "File") 
 
TRY 
{
	$bk.SqlBackup($srv)
	

} 
CATCH  

{
	$Database.Name + " backup failed." 
	$_.Exception.Message
	write-host $error[0] 
	} 
} 

