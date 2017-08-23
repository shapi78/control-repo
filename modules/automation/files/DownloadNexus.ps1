Param(
   	[string]$repo = "iis-repo",
	[string]$version = "2.4",
    [string]$NexusHost = "nexus3",
	[string]$group,
	[string]$DownloadFolder = "C:\Drop",
	[string]$artifact
    )


Function Update-Facter {
    $facts=@{}
    $download_fact = @{} 
    $key = "download_${artifact}"
    $FactFile="C:\ProgramData\PuppetLabs\facter\facts.d\download_${artifact}.json"
	$facts['group'] = $group
	$facts['version'] = $version
	$facts['artifact'] = $artifact
	$facts['file_name'] = $OutputFile
	$facts['url']=$DownloadURL
	$facts['host']=$NexusHost
	$download_fact[$key] = $facts

	if (Test-Path $FactFile) {
		Remove-Item ${FactFile}; 
	} Else {
		Write-Host "Updating facter with facts:"
		$backup_fact| ConvertTo-Json
	
	}
	
	New-Item ${FactFile} -ItemType file;
	$download_fact| ConvertTo-Json | Out-File -Encoding ASCII   ${FactFile}
    
}	
	
	
$server = "http://" + $NexusHost	
$DownloadURL = $server + "/repository/" + $repo +"/"+$group+"/"+$artifact+"/"+$version+"/"+$artifact+"-"+$version+".zip"
Write-Host "Downloading artifact from $DownloadURL"
$FileName = $DownloadURL.SubString($DownloadURL.LastIndexOf('/') + 1)
$OutputFile = "$DownloadFolder\$FileName"
$request = Invoke-WebRequest -Uri $DownloadURL -MaximumRedirection 0 -ErrorAction Ignore -OutFile $OutputFile
if (Test-Path $OutputFile) {
	Write-Host "Artifact was saved to $OutFile successfuly"
	Update-Facter
} Else {
	Throw "Error accoured - File was not created"
}
