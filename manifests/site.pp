node default {
	$version = $automation::params::app_ver
	$server_dest = $automation::params::server_dest
	$zip_dest = $automation::params::zip_dest
	$folders = $automation::params::folders

	class {'mssql': }
	class {'mssql::backup':}
#	class {'automation': }

	notify { "version is set to ${version}": }
	class { 'update_ver_fact::initial_update' : version => "$version"}

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
##		class { 'zip_utils::extract' :
##	 		version => "$version",
##			server_dest => "$server_dest",
##		}
##
##	}

}
