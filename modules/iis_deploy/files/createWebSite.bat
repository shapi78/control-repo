@echo off

SET webPath=%~1
SET zipPath=%~2
SET packageName=%~3
SET webSiteName=%~4
SET binding=%~5
SET appPoolName=%~6



::create folder
IF Not Exist %webPath%  md %webPath% 

::unzip
IF Not Exist %webPath%\%packageName%  powershell Add-Type -A System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::ExtractToDirectory('%zipPath%\%packageName%.zip', '%webPath%\%packageName%')

::create website
appcmd list site /name:%webSiteName%
IF NOT "%ERRORLEVEL%" EQU "0" appcmd add site /name:%webSiteName% /id:14 /physicalPath:%webPath% /bindings:%binding% 
::binding example="*:85:marketing.contoso.com"

appcmd set site /site.name:%webSiteName% /[path='/'].applicationPool:%appPoolName%