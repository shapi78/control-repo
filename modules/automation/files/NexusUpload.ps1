Param(
   	[string]$repo = "iis-repo",
	[string]$version = "1.1",
    [string]$NexusHost = "nexus3",
    [string]$filename,
	[string]$group,
	[string]$artifact
    )

$user = 'jenkins'
$pass = '1q2w3e4r'
$server = "http://" + $NexusHost
Function Read-Facter {
	$FactsFile="C:\ProgramData\PuppetLabs\facter\facts.d\${filename}.json";
	$factJson = Get-Content "$FactsFile" | ConvertFrom-Json
	$Global:BackupFilevalue = $factJson.${filename}.backup_file_name
	$Global:factVer = $factJson.${filename}.timestamp
	Write-Host "$BackupFilevalue $factVer"
}

if ($filename.ToLower().StartsWith("backup_")) {
	Read-Facter
	$filename=$BackupFilevalue
	$version=$factVer
}

Write-Host "Setting file source to $filename, version: $version"

$packaging = "zip"
 
$credential = "$($user):$($pass)"
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credential))
$basicAuthValue = "Basic $encodedCreds"
$headers = @{ Authorization=$basicAuthValue }
### write-host "Credentials $Credential.UserName, $Credential.Password"
# Import-ArtifactGAV $server $repoName $group $artifact $version $packaging $package $credential
$URI = $server + "/repository/" + $repo +"/"+$group+"/"+$artifact+"/"+$version+"/"+$artifact+"-"+$version+".zip"
if ( Test-Path $filename) {
	if ([IO.Path]::GetExtension($filename).ToLower() -eq '.zip') {
		write-host "URI $URI"
		Invoke-WebRequest -Headers $headers -uri $URI -Method Put -Infile $filename
	} Else {
		Throw "File extension mismatch"
	}
} Else {
	Throw "File was not found"
}
