
class mssql::backup ($server="localhost", $folder="${automation::workdir}", $database="test")  {
	include automation::nexus
	if $mssql::sqlserver == false {
		fail "backup requires SQL"
	}
	file { 'C:\Scripts\sqlbackup.ps1':
                source => "puppet:///modules/mssql/sqlbackup.ps1"
             }
	exec { "Running Backup ${database}  script":
		command => "& C:/Scripts/sqlbackup.ps1 $folder $server $database",
		provider => powershell,
		logoutput => true,
		require => File['C:\Scripts\sqlbackup.ps1'],
	} -> 
	automation::nexus::upload { "${database}":
			filename => "backup_${database}",
			version => "1",

	}

	
notify {"Operating system is ${::operatingsystem} backup_file ${::sql_backupfile_name}": }


}
