# In Powershell, variable is declared by prefixing dollar symbol $ 
# Anything followed by hash # is treating as a single line comment 
# –eq is the comparison operator 
# Plus + is used to concatenate strings


# Parameter declaration which will be passed to the script during execution


Param ( 
    $webConfigPath,              
	$dbServerName,
    $dbName,
    $ServiceAddress,
    $GuideRepositoryAddress
)


$xml = [xml](get-content $webConfigPath);                           # Create the XML Object and open the web.config file 
$root = $xml.get_DocumentElement();                                  # Get the root element of the file.

$newConnectionStrings = "Integrated Security=SSPI;Data Source=$dbServerName;Initial Catalog=$dbName"
$connectionStrings = $root."connectionStrings".add
$connectionStrings.connectionString = $newConnectionStrings




foreach( $item in $root.appSettings.add)                              # Updating the DBServer Name 
{ 
        if( $item.key -eq "DBServer" ) 
            { $item.value = $dbServerName; } 
            
        if($item.key -eq "ServiceAddress")
            {$item.value = $ServiceAddress}
    
        if($item.key -eq "GuideRepositoryAddress")
            {$item.value = $GuideRepositoryAddress}
}

foreach( $item in $root."system.serviceModel".client.endpoint)
{
        $address = $item.address -split '/'
        $address[0] = "https"
        $address[2] = $ServiceAddress

}


$xml.Save($webConfigPath)                                               # Finally, Saving the file