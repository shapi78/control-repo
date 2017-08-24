class automation  inherits automation::params {
	$systemtype = $::operatingsystem ? {
		'Ubuntu' => 'debian',
		'windows' => 'windows',
		default => 'unknown',
	}
#	class { 'automation::uploadnexus' : filename => "latest", version => 1}

	notify {"Using a ${systemtype} system":}
	notify {"zip dest ${zip_dest}":}
	notify {"Operating system is ${::operatingsystem}": }
	case $::operatingsystem{
		'windows': {
			include '::archive'
 			$workdir = hiera("workdir")
			$unzip_dir= hiera("unzip_folder")
			file  {"${workdir}": 
                                ensure => directory,
                                }
			file  { lookup("automation::ScriptFolder"): 
                                ensure => directory,
                                }
			file  { "${unzip_dir}": 
                                ensure => directory,
                                }
			notify {"OS type is ${::osfamily}": }

	}	
		default: {
			 file  { '/usr/Repo':
				ensure => directory,
				}
                        file { '/usr/Repo/myfile.txt':
				source => "puppet:///modules/automation/myfile.txt"
			}
		}
	}
}

