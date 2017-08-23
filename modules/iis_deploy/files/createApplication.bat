@echo off

SET webSiteName=%~1
SET configFilePath=%~2
SET sqlServerName=%~3
SET dbName=%~4
SET serverUrl=%~5
SET repositoryUrl=%~6
SET packageName=%~7
SET physicalPath=%~8


::create applications
appcmd add app /site.name:%webSiteName% /path:"/%packageName%" /physicalPath:%physicalPath%

::edit web.config
powershell . "..\PS-Scripts\EditConfigFile.ps1 %configFilePath% %sqlServerName% %dbName% %serverUrl% %repositoryUrl%