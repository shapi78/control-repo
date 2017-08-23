class mssql::readfacts {

	exec { 'Running Restore DB script':
		command => "& C:/Scripts/readfacts.ps1",
		provider => powershell,
		logoutput => true,
	}
		


}
