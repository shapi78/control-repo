node default {
 
	class {'automation': }
	$version = $automation::params::app_ver
	$server_dest = $automation::params::server_dest
	$zip_dest = $automation::params::zip_dest
	$folders = $automation::params::folders
	$dbAction = lookup('params.sql_action')
	notify { "dbAction is set to ${dbAction}": }
	
	#class {'git':}
	# class{'automation::git':}

	if ( $dbAction ) {
		include class {'mssql': }
		$sqldb_jobs = hiera("sql_db")
		notify { "defaults are  ${automation::params::sql_defaults}": }
		create_resources(mssql::database, $sqldb_jobs, $automation::params::sql_defaults)
##		mssql::backup { "test":
##				 version => 20,
##				}
##		mssql::dwnl_restore { "shapi":
##				group           => "LocalWeb",
##                                artifact        => "test",
##                                version         => "201708200408",
##			}
	} else {
		notify { "dbAction is set to ${dbAction}, starting deploy": }
	
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
	$dbAction = lookup('iis_deploy::params::dbAction')
	# $dbAction = hiera('dbAction')
	notify { "dbAction is set to ${dbAction}": }
	class {'route53':}

}
