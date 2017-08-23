class automation::git{

	include 'git'

	git::config { 'user.name':
	  value => 'yos55',
	}
	
	git::config { 'user.email':
	  value => 'yos.amichay5.com',
	}
}
