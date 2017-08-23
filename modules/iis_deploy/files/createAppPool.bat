@echo off

SET applicatiomName=%~1
SET bits=%~2
SET userName="MOIDEOEX\guideuser"
SET password="Guide4User"

::create application pool 

IF NOT [%applicatiomName%] EQU [] (appcmd add apppool /name:%applicatiomName% /managedRuntimeVersion:"v4.0" /managedPipelineMode:"Integrated" 

	::check if OS is 64 bits
	IF %bits% == 64 appcmd set apppool /apppool.name:%applicatiomName% /enable32BitAppOnWin64:true

	SET setConfig="appcmd set config /section:applicationPools /[name='%applicatiomName%'].processModel.identityType:SpecificUser /[name='%applicatiomName%'].processModel.userName:%userName%"

	::creditional without password
	IF [%password%] EQU []( %setConfig%	 
		) ELSE (
		"%setConfig%/[name='%applicatiomName%'].processModel.password:%password%"
	)	
)












 


