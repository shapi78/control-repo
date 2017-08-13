class automation::iis
{
	notify{"execute iis.bat":}
	exec{ "execute_bat":
     		 command  => "C:\Users\yos\Puppet\puppet_prisma\Scripts\Bat-Scripts\iis.bat",
		 logoutput => true,
		 path => "%windir%\system32\cmd.exe",
  	 }  
}
