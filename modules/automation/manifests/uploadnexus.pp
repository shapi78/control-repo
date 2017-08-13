class automation::uploadnexus($filename, $group="${::hostname}", $version, $nexusHost="nexus3" ,$repo="iis-repo",$artifact="${::hostname}") {

	notify {"Uploading file ${filename}, versioned $version, groupid ${group} to nexus $nexusHost":}
	file { 'C:\Scripts\NexusUpload.ps1':
               source => "puppet:///modules/automation/NexusUpload.ps1"
                        }
	file { 'C:\Scripts\test.ps1':
               source => "puppet:///modules/automation/test.ps1"
                        }
	exec {"Check extension of $filename} ":
		command=>"[IO.Path]::GetExtension('c:\dir\file.xml')",
		provider => powershell,
	}

	exec { "Uploading file ${filename} to ${nexusHost} ":
		command => "& C:/Scripts/NexusUpload.ps1 -filename $filename -group $group -version $version -artifact $artifact",
		provider => powershell,
		logoutput => true,
		subscribe => File['C:\Scripts\NexusUpload.ps1'],
		onlyif => "[IO.Path]::GetExtension($filename) -eq '.zip'"
	}
		
}
