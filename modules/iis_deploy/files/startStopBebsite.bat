@echo off 

SET webSiteName=%~1
SET command=%~2

::start/stop website
IF %command% == "stop" appcmd stop site /site.name:%webSiteName%
IF %command% == "start" appcmd stop site /site.name:%webSiteName%
