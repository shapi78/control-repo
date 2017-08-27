define automation::nexus::download (
	$group		= "${::hostname}", 
	$version	= undef, 
	$nexusHost	= "nexus3",
	$repo		= "iis-repo",
	$artifact	= $title,
	$dwnld_folder	= "${automation::workdir}",
	) {

	include automation::nexus
	$fact = $facts["artifact_${artifact}"]
	if $facts{
		if $fact["repo"] == "$repo" and  $fact["version"] == "$version"{
			notify{"Artifact ${artifact} alreadey exist":}
			$_downloaded=false
		}else{
			notify {"Downloading ${artifact}":}->
			exec { "${artifact}_file" :
				command => "& C:/Scripts/DownloadNexus.ps1 -repo $repo -artifact $artifact -group $group -version $version -DownloadFolder $dwnld_folder",
				provider => powershell,
				logoutput => true,
				require => File["C:/Scripts/DownloadNexus.ps1"],
			}
			$_downloaded=true
		static_custom_facts::fact {"download_${artifact}": value => {repo => "${repo}", folder => "${automation::workdir}", name => "${artifact}", group => "${group}", version => "${version}"}}
		}
	}
}
		
define automation::nexus::upload (
	$filename,
	$group		= "${::hostname}", 
	$version	= undef, 
	$nexusHost	= "nexus3",
	$repo		= "iis-repo",
	$artifact	= $title,
	) {
	
	include automation::nexus
	notify {"Uploading file ${filename}, artifact: ${artifact} version $version, groupid ${group} to nexus $nexusHost":}

	exec { "Uploading file ${filename} to ${nexusHost} ":
		command => "& C:/Scripts/NexusUpload.ps1 -filename $filename -group $group -version $version -artifact $artifact",
		provider => powershell,
		logoutput => true,
		require => File["C:/Scripts/NexusUpload.ps1"],
		## Need to move all files to hiera
	}
	static_custom_facts::fact {"upload_${artifact}": value => {repo => "${repo}", artifact => "${artifact}", group => "${group}", filename => "${filename}", version => "${version}"}}
		

}
	


class automation::nexus{

	file { "C:/Scripts/DownloadNexus.ps1":
               source => "puppet:///modules/automation/DownloadNexus.ps1"
                        }
	file { "C:/Scripts/NexusUpload.ps1":
               source => "puppet:///modules/automation/NexusUpload.ps1"
                        }
}
