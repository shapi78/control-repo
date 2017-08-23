 define iis_deploy::createwebsite::createapp(
 		$appPool,
 		$username,
 		$userpass,
 		) {

 	$artifactversion = hiera("artifacts.${$appPool}.version")
 	$srcFileName="${automation::workdir}/${appPool}-${artifactversion}.zip"
 	$sitefolder="${iis_deploy::createwebsite::sitefolder}/${sitename}"
 	$appFolder="${sitefolder}/${appPool}"
	$sitename="${iis_deploy::createwebsite::sitename}"
	$app_pool_name="${sitename}-${appPool}"
	$endpointAddress="server2012.mobideo.local"
	$serviceAddress= hiera("iis_deploy::params::serviceAddress")
	#$GuideRepositoryAddress="REPOSITORY"
	#$sqlServer="SQLSERVER"
	#$catalogName="catalog"
	static_custom_facts::fact {"${app_pool_name}": value => {name=>"${sitename}", appFolder=>"${appFolder}",version=>"${artifactversion}"}}
 	notify {"Create app ${appPool} on ${iis_deploy::createwebsite::sitefolder}":}
 
	file { "${appFolder}":
                          ensure => 'directory'
                        } 
	zip_utils::extract { "extracting_${appPool}":
					full_filename	=> "${srcFileName}",
					dst_folder => "${sitefolder}",
				}
# 	unzip { "${appPool}":
#  		 source  => "${srcFileName}",
# 		 creates => "${sitefolder}/${appPool}",
# 		 destination  => "${sitefolder}",
# 	}->
 	iis_application_pool {"${app_pool_name}":
  		 ensure                  => 'present',
 	 	 managed_pipeline_mode   => 'Integrated',
  		 managed_runtime_version => 'v4.0',
 		 state                   => 'Started',
 		 enable32_bit_app_on_win64 => "false",
 		 user_name		 => "${username}",
 		 password		 => "${userpass}",
 	}->
 	iis_application { "${appPool}":
  		 ensure       		=> 'present',
		 applicationpool	=> "${app_pool_name}",
 		 sitename     		=> "${sitename}",
  		 physicalpath		=> "${appFolder}",
		 require 		=> File["${appFolder}"],
  		
 	}->
	file { "${sitefolder}/${appPool}/web.config":
			ensure  => file,
			content => template( "iis_deploy/${appPool}.web.cfg.erb" ),
	}
 
 }
 
class iis_deploy::createwebsite (
				$sitename,
	    			$siteAddress,
    		){
	include 'static_custom_facts' 
	## require class iis_deploy::dwnfile
	static_custom_facts::fact {"${sitename}": value => {address=>"${siteAddress}",version=>"2.0"}}

 	notify {"Creating site ${sitename} on ${iis_deploy::webfolder}":}
	$sitefolder="${iis_deploy::webfolder}/${sitename}"

	file { "${sitefolder}":
                          ensure => 'directory'
                        } 
	acl { "${sitefolder}":
		 permissions                => [
   		 {identity => 'Users', 'rights' => ['read', 'execute']},
 	 	],
	  	require => File["${sitefolder}"],
        }
	$appPools = hiera("appPools")
	create_resources(iis_deploy::createwebsite::createapp, $appPools)
	
	iis_site {"$sitename":
 		 ensure               => 'started',
		 physicalpath         => "${sitefolder}",
# 		 enabledprotocols     => 'https',
 		 bindings             => [
   		 {
      			'bindinginformation'   => "*:80:${siteAddress}",
			'protocol'             => 'http',
#			'certificatehash'      => '6084b11f8a4c2321cde1ff6a2d0d414129b8ee09',
#		        'certificatestorename' => 'MY',
#		        'sslflags'             => 1,
 	   },
 	 ],
	}

	### $GuideRepositoryAddress = "http://guiderepository:7878"
}
