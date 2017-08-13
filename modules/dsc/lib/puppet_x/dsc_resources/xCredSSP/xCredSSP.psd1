@{
# Version number of this module.
ModuleVersion = '1.2.0.0'

# ID used to uniquely identify this module
GUID = '38e1ad0f-9b30-490a-a2b6-cc77765af4ec'

# Author of this module
Author = 'Microsoft Corporation'

# Company or vendor of this module
CompanyName = 'Microsoft Corporation'

# Copyright statement for this module
Copyright = '(c) 2014 Microsoft Corporation. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Module with DSC Resources for WSMan CredSSP.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '4.0'

# Minimum version of the common language runtime (CLR) required by this module
CLRVersion = '4.0'

# Functions to export from this module
FunctionsToExport = '*'

# Cmdlets to export from this module
CmdletsToExport = '*'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('DesiredStateConfiguration', 'DSC', 'DSCResourceKit', 'DSCResource')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/PowerShell/xCredSSP/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/PowerShell/xCredSSP'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = '* Converted appveyor.yml to install Pester from PSGallery instead of from Chocolatey.
* Implemented a GPO check to prevent an endless reboot loop when CredSSP is configured via a GPO
* Fixed issue with Test always returning false with other regional settings then english
* Added check to test if Role=Server and DelegateComputers parameter is specified
* Added parameter to supress a reboot, default value is false (reboot server when required)

'

    } # End of PSData hashtable

} # End of PrivateData hashtable
}


