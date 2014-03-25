;InstallTest

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Should specify fullpaths
packs:="package_test.ahkp"

Runwait *RunAs Package_Installer.ahk "%packs%",,UseErrorLevel
ecode:=ErrorLevel
if (ecode==21) ;random chosen value
	MsgBox, 64, , Installation finished successfully.
else
	MsgBox, 16, , An installation error occured.`n(ExitCode: %ecode%)