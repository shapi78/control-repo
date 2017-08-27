
#Class: mssql
# ===========================
#
# Full description of class mssql here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'mssql':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
define mssql::backup (
	$database = $title,
	$folder="${automation::workdir}",
	$version,
	){
	$backup_file="${folder}/${database}.zip"
	$backup_facts = $facts["backup_${database}"]
	## notify {"Fact version ${backup_facts['version']} ${backup_facts}":}
	if $backup_facts and
		$backup_facts["version"] == "${version}" and $backup_facts["db_name"] == "${database}" {
			notify {"${database} already  backed-up ": }
	} else {
		exec { "Running Backup ${database} to folder ${folder}":
			command => "& C:/Scripts/sqlbackup.ps1 -folder $folder -dbname $database -version $version",
			provider => powershell,
			logoutput => true,
			require => File["C:/Scripts/sqlbackup.ps1"],
		}-> 
		automation::nexus::upload { "${database}":
			filename => "${backup_file}",
			version => "${version}",

		}
	}




}
define mssql::restore (
	$database = $title,
	$filename,
	$version
	){
	file{"${filename}":
                        ensure => file,
              }
	$res_facts = $facts["restore_${database}"]
	if $res_facts and
		$res_facts["version"] == $version and $res_facts["database"] == $database {
		notify {"${database} already restored": }

	} else {
		notify {"restoring DB ${database}": }
		exec { "Restore DB ${database}":
			command => "& C:/Scripts/restore_sql.ps1 -backupFile $filename -restoreDB $database",
			provider => powershell,
			logoutput => true,
			require => [File["C:/Scripts/restore_sql.ps1"], File["${filename}"]]
		}
		static_custom_facts::fact {"restore_${database}": value => {version => "${version}", filename => "${filename}", database => "${database}"}}
	}
		
}
define mssql::dwnl_restore (
	$artifact,
	$version,
	$group,
	$database = $title ,
	){

		if $mssql::sqlserver != true {
			fail "backup requires SQL"
		}

		$artifact_file = "$automation::workdir/${artifact}-${version}.zip"
		$backup_file = "${automation::unzip_dir}/${artifact}_${version}.bak"
##		archive::nexus {"${artifact_file}":
##			url => "http://nexus3",
##			gav => "${group}:${artifact}:${version}",
##			repository => "iis-repo",
##			packaging  => 'zip',
##			extract    => true,
##		}
		automation::nexus::download{"${artifact}":
                        		group           => $group,
                        		version         => $version,
                        		repo            => $repo,
                }
		archive { "${artifact_file}":
			  ensure          => present,
			  extract         => true,
			  extract_path    => "${automation::unzip_dir}",
			  cleanup         => true,
			  creates         => "${backup_file}",
		}

##		zip_utils::extract {"extracting $artifact":
##				full_filename   => $artifact_file,
##				dst_folder 	=> "${automation::unzip_dir}"
##			}
##

		mssql::restore { "${database}":
					filename => $backup_file,
					version => $version,
				}
 		
			

}
define mssql::database (
	$database,
	$action 	= $title,
	$version,
	$group		= "${::hostname}"
	$artifact,
	){
	case $action {
		"backup": {
			notify {"DB ${database} initiate backup": }
			mssql::backup {"${database}":
				version => $version, }
				
			}
		"restore": {
			notify {"DB ${database} initiate restore": }
			mssql::dwnl_restore {"${database}":
				version 	=> $version, 
				artifact	=> $artifact,
				group		=> $group,

				}
			}
	}
}
			
				
class mssql {
		include 'static_custom_facts'
		file { "C:/Scripts/sqlbackup.ps1":
                	source => "puppet:///modules/mssql/sqlbackup.ps1"
             	}
		file { "C:/Scripts/restore_sql.ps1":
                       source => "puppet:///modules/mssql/restore_sql.ps1"
                }
		file { 'C:\Scripts\readfacts.ps1':
                       source => "puppet:///modules/mssql/readfacts.ps1"
                }
		file { 'C:\Scripts\checksql.ps1':
                       source => "puppet:///modules/mssql/checksql.ps1"
                }
		notice ($facts['sqlserver'])
		notify {"sqlserver ${facts['sqlserver']}": }
		if $facts['sqlserver'] and $facts['sqlserver'] == "1" {
			notice ($facts['sqlserver'])
			$sqlserver = true
		} else {
			
			$sqlserver = false
			exec { 'Check if SQL exists':
				command => "& C:/Scripts/checksql.ps1",
				provider => powershell,
				logoutput => true,
				require => File['C:\Scripts\checksql.ps1'],
				}
		}
}
