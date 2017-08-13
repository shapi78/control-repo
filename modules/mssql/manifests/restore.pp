class mssql::restore ($server="localhost", $filename, $database="flyway")  {

	exec { 'Running Restore DB script':
		command => "& C:/Scripts/sqlRestoreDB.ps1 $filename $server $database",
		provider => powershell,
		logoutput => true,
	}
		


}
