Param(
    [string]$file,
    [string]$Server,
    [string]$database
    )
Write-Host "Restoring $file to DB $database on $Server"
Restore-SqlDatabase -ServerInstance $Server -Database $database -BackupFile $file
