@echo off

SET siteName=%~1
SET protocol=%~2
SET bindingInformation=%~3


::set binding to a site
appcmd set site /site.name:%siteName% /+bindings.[protocol='%protocol%',bindingInformation='/%bindingInformation%']
::FOR HELP - https://technet.microsoft.com/en-us/library/cc731692(v=ws.10).aspx


::change the value of an application setting
::IF NOT [%appSettingsName%] EQU []  appcmd set config /commit:Machine /section:appSettings /[key='%appSettingsName%'].value:'%appSettingsValue%'
