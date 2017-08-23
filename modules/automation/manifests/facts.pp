define automation::facts::create (
	$factKey,
	$factValue,
	$filename,
	) {

	
	exec { "${filename}" :
		command => "& C:/Scripts/facts.ps1 -FactKey $factKey -FactValue $factValue -FactFileName $filename",
		provider => powershell,
		logoutput => true,
	}
}
		


class automation::facts{

	file { 'C:\Scripts\facts.ps1':
               source => "puppet:///modules/automation/facts.ps1"
                        }



}
