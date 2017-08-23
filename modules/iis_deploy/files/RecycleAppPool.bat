@echo off

SET appPoolName=%~1

appcmd recycle apppool /apppool.name:%appPoolName%