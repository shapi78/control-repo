# Class: route53
# ===========================
#
# Full description of class route53 here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'route53':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
define route53::update(
 		$siteAddress,
 		$version,
 		$ipAddress,
 		) {
 	notify {"Create ${title} hostname ${siteAddress} with IP ${ipAddress}":}
	if  $facts["${title}"] and  $facts["${title}"]['siteAddress'] == "${siteAddress}" and $facts["${title}"]['ipAddress'] == "${ipAddress}"  {
		notify{"found ${title}":}
	}
	else {
		notify{"update ${title} with ip ${ipAddress}":}
		route53_a_record {"${siteAddress}.":
			ensure 	=> "present",
			ttl 	=> "600",
			values	=> "${ipAddress}",
			zone	=> "mpcmobideo.com.",
		}
        	static_custom_facts::fact {"${title}": value => {siteAddress=>"${siteAddress}", ipAddress=>"${ipAddress}",version=>"${version}"}}
	}
	
	
}
class route53 {

	include 'static_custom_facts'
	$sites = hiera("sites")
	create_resources(route53::update, $sites)

}
