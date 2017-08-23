class zip_utils {

}
define zip_utils::extract (
	$dst_folder = lookup("automation::UnZipFolder"),
	$full_filename,
	) {


	file{"${full_filename}":
                  ensure => file,
               }->
	exec { "UnZip_$full_filename":
  		command   => "Add-Type -A System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::ExtractToDirectory('${full_filename}', '${dst_folder}')",
  		provider  => powershell,
  		require => File["${full_filename}"]
	}	

}
