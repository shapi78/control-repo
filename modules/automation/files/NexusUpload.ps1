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


$version = "2.4"
$packaging = "zip"

$credential = "$($user):$($pass)"
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credential))
$basicAuthValue = "Basic $encodedCreds"
$headers = @{ Authorization=$basicAuthValue }
### write-host "Credentials $Credential.UserName, $Credential.Password"
# Import-ArtifactGAV $server $repoName $group $artifact $version $packaging $package $credential
$URI = $server + "/repository/" + $repo +"/"+$group+"/"+$artifact+"/"+$version+"/"+$artifact+"-"+$version+".zip"

if ( Test-Path $filename) {
	write-host "URI $URI"
	Invoke-WebRequest -Headers $headers -uri $URI -Method Put -Infile $filename
} Else {
	Throw "File was not found"
}
