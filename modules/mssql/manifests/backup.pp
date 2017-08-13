
class mssql::backup ($server="localhost", $folder="c:/drop", $database="flyway")  {

	file { 'C:\Scripts\sqlbackup.ps1':
                source => "puppet:///modules/mssql/sqlbackup.ps1"
             }
	exec { 'Running Backup DB script':
		command => "& C:/Scripts/sqlbackup.ps1 $folder $server $database",
		provider => powershell,
		logoutput => true,
		require => File['C:\Scripts\sqlbackup.ps1'],
	} -> class { 'zip_utils::create' :  filename => "${::sql_backupfile_name}", }
	-> class {'automation::uploadnexus' : filename => "c:\website.txt" , version => 2.4 ,}	
notify {"Operating system is ${::operatingsystem} backup_file ${::sql_backupfile_name}": }


}
