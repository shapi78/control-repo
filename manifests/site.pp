node default {
 
	class {'automation': }
	$version = $automation::params::app_ver
	$server_dest = $automation::params::server_dest
	$zip_dest = $automation::params::zip_dest
	$folders = $automation::params::folders
	$dbBackup = lookup('sql_db.db_backup')
	notify { "db_backup is set to ${dbBackup}": }
	
	#class {'git':}
	# class{'automation::git':}

	if ( $dbBackup ) {
		include class {'mssql': }
		class {'mssql::backup':}
		mssql::dwnl_restore { "shapi":
				group           => "LocalWeb",
                                artifact        => "test",
                                version         => "201708200408",
			}
	} else {
		notify { "db_backup is set to ${dbBackup}, starting deploy": }
	
	}
	case $::operatingsystem {
		'windows': {
			notify {"Using a ${systemtype} Microsoft system":}
			# class {'iis_deploy::dwnfile':}
			# class {'mssql': }

		}	
		default: {
			notify {"Using a ${systemtype} unix system":}
		}
	}

}
node /puppet/ {
	$dbBackup = lookup('iis_deploy::params::db_backup')
	# $dbBackup = hiera('db_backup')
	notify { "db_backup is set to ${dbBackup}": }
	class {'route53':}

}
