class update_ver_fact ($version = '') inherits update_ver_fact::params
{	

notify { "Path in init is set to ${$winverfile}": }
#CREATE VERSION FACT ON CLIENT ON FIRST RUN
exec    { 'create version facter':
	command => "New-Item ${winverfile} -ItemType file; Add-Content ${winverfile} local_version=${version} -Force",
	creates => "${winverfile}",
	provider    => 'powershell',
	logoutput   => true,
}	
	
notify {"Old version number: ${local_version}, New version number: ${version} ": }
	
}
