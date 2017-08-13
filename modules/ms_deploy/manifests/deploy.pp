class mindlab_deploy::deploy

(
$version = '',
$deploy_dest = '',
$server_dest = '',
)

{

exec    { 'DEPLOY TO IIS':
        command => "\"C:\\Program Files (x86)\\IIS\\Microsoft Web Deploy V3\\msdeploy.exe\" -verb:sync -source:package=${server_dest}\\deploy-${version}.zip -dest:auto",
        logoutput   => true,
}


}