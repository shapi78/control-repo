class zip_utils {

}
define zip_utils::extract (
	$dst_folder = lookup("automation::UnZipFolder"),
	$full_filename,
	) {


	exec { "UnZip_$full_filename":
  		command   => "Add-Type -A System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::ExtractToDirectory('${full_filename}', '${dst_folder}')",
  		provider  => powershell,
  		#require => [Download_file['Download from nexus'],File["${server_dest}"]]
	}	

}
