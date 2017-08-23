@echo off

set PATH=%PATH%;C:\Windows\System32\inetsrv
set PATH=%PATH%;C:\Windows\system32\WindowsPowerShell\v1.0
call C:\Users\Yos\Puppet\puppet_prisma\Scripts\Bat-Scripts\createAppPool.bat "" 32

call C:\Users\Yos\Puppet\puppet_prisma\Scripts\Bat-Scripts\createWebSite.bat c:\web c:\zip GuideServices website http://*:80:test.Prisma.com

set serverUrl=http://guideservices:2222
set repositoryUrl=http://guiderepository:4444
set physicalPath=c:\web\GuideServices\GuideServices

call C:\Users\Yos\Puppet\puppet_prisma\Scripts\Bat-Scripts\createApplication.bat website %physicalPath%\web.config dev-yos flyway %serverUrl% %repositoryUrl% %physicalPath% %physicalPath%

call C:\Users\Yos\Puppet\puppet_prisma\Scripts\Bat-Scripts\setAppPoolToSite.bat website "/GuideServices" app