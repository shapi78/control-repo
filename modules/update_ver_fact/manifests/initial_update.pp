class update_ver_fact::initial_update ($version = '',) inherits update_ver_fact::params
{	
notify { "Path in initial_update is set to ${$winverfile}": }
#CREATE VERSION FACT ON CLIENT ON FIRST RUN
exec    { 'create version facter':
	# command => "New-Item C:\ProgramData\PuppetLabs\facter\facts.d\ver.txt -ItemType file; Add-Content C:\ProgramData\PuppetLabs\facter\facts.d\ver.txt local_version=${version} -Force",
	command => "New-Item ${winverfile} -ItemType file; Add-Content ${winverfile} local_version=${version} -Force",
	creates => "${winverfile}",
	provider    => powershell,
	logoutput   => true,
}	
	
notify {"Old version number: ${local_version}, New version number: ${version} ": }
	
}
