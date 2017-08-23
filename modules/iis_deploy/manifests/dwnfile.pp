define iis_deploy::dwnfile::download (
	$artifact,
	$version  = "2.4",
	) {
	$nexusHost = hiera("automation::downloadnexus::nexusHost")
	$repo = hiera("automation::downloadnexus::repo")
	$workdir = hiera("automation::WorkDirectory") 
	$fullPathFileName="${workdir}/${artifact}-${version}.zip"
		
	case $artifact {
		"GuidePortal": {
				 $fact = $facts['guideportal']
				}
		"GuideRepository": {
				 $fact = $facts['guiderepository']
				 }
		"GuideServices":{
				 $fact = $facts['guideservices']
				}
		default: {
			notify {"Could not find  ${artifact} ":}
			}

		}
	notice ($fact)
	notify {"Fact ${fact} ${artifact}":}
	notify {"Fact version ${fact['version']} ${artifact}":}
	if $fact {
		
		if $fact["version"] == "${version}" and $fact["fileLocation"] == "${fullPathFileName}"  {
		notify {"FullFilePath ${fullPathFileName} already exits":}
		} else {
			notify {"Downloading ${artifact}":}
			automation::nexus::download { "${artifact}":
				group 		=> "hess",
				version		=> $version,
				nexusHost	=> $nexusHost,
				repo		=> $repo,
				
				}
			static_custom_facts::fact {"${artifact}": value => {repo => "${repo}", fileLocation => "${fullPathFileName}", version => "${version}"}}
		}
	}
#	zip_utils::extract { "extracting_${artifact}":
#					full_filename	=> "${fullPathFileName}",
#				}
				
	
				
				
}

class iis_deploy::dwnfile  {
	include static_custom_facts 
	$artifact = hiera("artifacts")
	create_resources(iis_deploy::dwnfile::download, $artifact)
###                                        version=>"2.4",
###                                        nexusHost=>"nexus3",
###                                        repo=>"portal",
###                                        artifact=>$artifact, }
###        
}
