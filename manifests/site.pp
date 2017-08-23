node default {
 
	class {'automation': }
	$version = $automation::params::app_ver
	$server_dest = $automation::params::server_dest
	$zip_dest = $automation::params::zip_dest
	$folders = $automation::params::folders
	$dbBackup = lookup('iis_deploy::params::db_backup')
	notify { "db_backup is set to ${dbBackup}": }
	
	#class {'git':}
	# class{'automation::git':}

	if ( $dbBackup != "1" ) {
		include class {'mssql': }
		# class {'mssql::backup':}
		mssql::dwnl_restore { "test":
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
#	class {'mssql::restore': f/ilename => 'test'}
#	class {'iis_deploy': }
##	notify { "version is set to ${version}": }
##	## class { 'update_ver_fact::initial_update' : version => "$version"}
##
##	if ($local_version != $version) {
##	notify { "zip_download is set to ${server_dest}": }
##		class { 'update_ver_fact::update' : version => "$version"} 
##
##		class { 'zip_utils::download' :
##	 		version => "$version",
##			zip_dest => "$zip_dest",
##	 	}
## 
## 
###		class { 'zip_utils::extract' :
###	 		version => "$version",
###			server_dest => "$server_dest",
###		}
###
##	}

}
node /puppet/ {
	$dbBackup = lookup('iis_deploy::params::db_backup')
	# $dbBackup = hiera('db_backup')
	notify { "db_backup is set to ${dbBackup}": }
	class {'route53':}

}
