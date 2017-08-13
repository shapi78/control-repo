class automation  inherits automation::params {
	$systemtype = $::operatingsystem ? {
		'Ubuntu' => 'debian',
		'windows' => 'windows',
		default => 'unknown',
	}
#	class { 'automation::uploadnexus' : filename => "c:\website.txt", version => 1}
#	class { 'automation::iis' :}
	notify {"Using a ${systemtype} system":}
	notify {"zip dest ${zip_dest}":}
	notify {"Operating system is ${::operatingsystem}": }
	case $::operatingsystem{
		'windows': {

			file  { "${zip_dest}": 
                                ensure => directory,
                                }
			file  { "${$server_dest}": 
                                ensure => directory,
                                }
			file  { 'C:\Scripts':
                                ensure => directory,
                                }
			file { 'C:\Scripts\DownloadNexus.ps1':
                                source => "puppet:///modules/automation/DownloadNexus.ps1"
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

