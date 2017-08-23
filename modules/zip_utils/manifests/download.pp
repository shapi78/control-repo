class zip_utils::download ($version = '',$zip_dest ='',)
{

 	notify {"version on zip_utils ${version}":}

 #FOR WIN NODES: DOWNLOAD ZIP FILE FROM NEXUS SERVER
 download_file { "Download from nexus" :
   url => "http://nexus3/repository/yos-test/sp/sd/yos-test/${version}/yos-test-${version}-debug.Zip",
   destination_directory => "${zip_dest}",
   ### url => "${version}",
 }
}
