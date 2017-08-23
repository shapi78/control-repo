@echo fff

SET webSiteName=%~1
SET appPath=%~2
SET appPoolName=%~3

REM echo its here!!!!!!!
::match between site to application pool
appcmd set site /site.name:%webSiteName% /[path='%appPath%'].applicationPool:%appPoolName%


