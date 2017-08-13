class update_ver_fact::update ($version='',) inherits update_ver_fact::params

{

## notify { "Path facter from update is set to ${update_ver_fact::params::win_facter_version}": }
exec    { 'UPDATE version facter':
        command => "Remove-Item ${winverfile}; New-Item ${winverfile} -ItemType file; Add-Content ${winverfile} local_version=${version}",
        provider    => 'powershell',
        logoutput   => true,
}

}
