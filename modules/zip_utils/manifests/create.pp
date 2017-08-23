class zip_utils::create ( $filename )
{

	file { 'C:\Scripts\zipfile.ps1':
               source => "puppet:///modules/zip_utils/zipfile.ps1"
                        }

	exec { "Zipping ${filename} ":
		command => "& C:/Scripts/zipfile.ps1 -fileToZip $filename",
		provider => powershell,
		logoutput => true,
		subscribe => File['C:\Scripts\zipfile.ps1'],
	}
		
}
