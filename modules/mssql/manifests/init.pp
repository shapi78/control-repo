
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
define mssql::restore (
	$server="localhost",
	$database = $title,
	$filename
	){

	exec { 'Running Restore DB script':
		command => "& C:/Scripts/restore-sql.ps1 -backupFile $filename -restoreDB $database",
		provider => powershell,
		logoutput => true,
		require => File["C:\Scripts\restore-sql.ps1"]
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
		notify {"Downloading ${artifact}":}->

		automation::nexus::download{"${artifact}":
                        		group           => $group,
                        		version         => $version,
                        		repo            => $repo,
                }
		$artifact_file = "$automation::workdir/${artifact}-${version}.zip"


		file{$artifact_file:
			ensure => file,
		}->

		exec{"Check if $artifact_file exist":
			provider => powershell,
			require => File[$artifact_file],
		}

		zip_utils::extract {"extracting $artifact":
				full_filename   => $artifact_file,
				dst_folder 	=> "${automation::unzip_dir}"
			}

		$backup_file = "${automation::unzip_dir}/${artifact}_${version}.bak"
		file{$backup_file:
                        ensure => file,
                }->
		exec{"Check if $backup_file  exist":
                        provider => powershell,
                        require => File[$backup_file],
                }


		mssql::restore { "${database}":
					filename => $backup_file,
				}
 		
			

}
class mssql {
		include 'static_custom_facts'
		file { "C:\Scripts\restore-sql.ps1":
                       source => "puppet:///modules/mssql/restore-sql.ps1"
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
