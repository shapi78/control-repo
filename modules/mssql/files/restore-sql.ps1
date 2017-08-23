#============================================================
# Restore a Database using PowerShell and SQL Server SMO
# Restore to the a new database name, specifying new mdf and ldf
# Donabel Santos
#============================================================
 
Param(
    [string]$backupFile,
    [string]$restoreDB,
    [switch]$norecovery=$true
    )
#clear screen

 
#load assemblies
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
#Need SmoExtended for backup
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
[Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
[Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null
 
## $backupFile = 'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\Backup\test_db_20090531153233.bak'
 
#we will query the database name from the backup header later
$server = New-Object ("Microsoft.SqlServer.Management.Smo.Server") "(local)"
$backupDevice = New-Object("Microsoft.SqlServer.Management.Smo.BackupDeviceItem") ($backupFile, "File")
$smoRestore = new-object("Microsoft.SqlServer.Management.Smo.Restore")
 
#restore settings
$smoRestore.NoRecovery = $false;
$smoRestore.ReplaceDatabase = $true;
$smoRestore.Action = "Database"
$smoRestorePercentCompleteNotification = 10;
$smoRestore.Devices.Add($backupDevice)
 
#get database name from backup file
$smoRestoreDetails = $smoRestore.ReadBackupHeader($server)
 
#display database name
"Database Name from Backup Header : " +$smoRestoreDetails.Rows[0]["DatabaseName"]
 
#give a new database name
### $smoRestore.Database =$smoRestoreDetails.Rows[0]["DatabaseName"] + "_Copy"
$smoRestore.Database =$restoreDB

#specify new data and log files (mdf and ldf)
$smoRestoreFile = New-Object("Microsoft.SqlServer.Management.Smo.RelocateFile")
$smoRestoreLog = New-Object("Microsoft.SqlServer.Management.Smo.RelocateFile")
 
#the logical file names should be the logical filename stored in the backup media
$smoRestoreFile.LogicalFileName = $smoRestoreDetails.Rows[0]["DatabaseName"]
$smoRestoreFile.PhysicalFileName = $server.Information.MasterDBPath + "\" + $smoRestore.Database + "_Data.mdf"
$smoRestoreLog.LogicalFileName = $smoRestoreDetails.Rows[0]["DatabaseName"] + "_Log"
$smoRestoreLog.PhysicalFileName = $server.Information.MasterDBLogPath + "\" + $smoRestore.Database + "_Log.ldf"
$smoRestore.RelocateFiles.Add($smoRestoreFile)
$smoRestore.RelocateFiles.Add($smoRestoreLog)
 
#restore database
$smoRestore.SqlRestore($server)