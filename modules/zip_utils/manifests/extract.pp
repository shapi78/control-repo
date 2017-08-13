class zip_utils::extract

(
$version = '',
$server_dest = '',
)

{

##DELETE ROOT DIR CONTENT
#file { "${server_dest}" :
#  	ensure => 'absent',
#		force => true,
#    }

$zipFullPath="$zip_dest\yos-test-${version}-debug.zip"
exec { 'REMOVE ROOT DIR':
  command   => "Remove-Item -path ${server_dest} -Recurse",
  provider  => powershell,
}

#UNZIP FILE USING POWERSHELL TO IIS ROOT FOLDER
exec { 'UNZIP FILE':
  #command   => "Add-Type -A System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::ExtractToDirectory('C:\Users\Administrator\ms-builds-${version}.zip', '${server_dest}')",
  ### - command   => "Add-Type -A System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::ExtractToDirectory('C:\Users\Administrator\ms-builds-${version}.zip', '${server_dest}')",
  command   => "Add-Type -A System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::ExtractToDirectory('${zipFullPath}', '${server_dest}')",
  provider  => powershell,
  #require => [Download_file['Download from nexus'],File["${server_dest}"]]
  require => Exec['REMOVE ROOT DIR'],
}

}
