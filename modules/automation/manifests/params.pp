class automation::params(){

$app_ver = '1.1.1.1'
$folders = "Content Resources"

$server_dest = 'C:\Drop\Deploy'
$zip_dest = 'C:\Drop'
$sql_defaults = {
	group => "${::hostname}",
	artifact => "test",
	
}

}
