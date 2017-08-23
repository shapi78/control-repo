# Class: deploy
# ===========================
#
# Full description of class deploy here.
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
#    class { 'deploy':
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
class iis_deploy {

		$webfolder = hiera("iis_deploy::params::webfolder")
		class { 'iis_deploy::dwnfile': } ->
		class {'iis_deploy::createwebsite': 
                                sitename => "babaganush",
                                siteAddress => "babaganush.mpcmobideo.com", 
			}
               

		$iis_features = ['Web-WebServer','Web-Scripting-Tools']
		file {"${webfolder}":
			  ensure => 'directory'
			} 
		file { 'c:\\Scripts\\EditConfigFile.ps1':
               		source => "puppet:///modules/iis_deploy/EditConfigFile.ps1"
			} 
		iis_feature { $iis_features:
			     ensure => present,
		} 
}
