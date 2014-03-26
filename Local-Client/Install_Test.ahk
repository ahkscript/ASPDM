;InstallTest

#Include Lib\Install.ahk
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Should specify fullpaths
packs:="package_test.ahkp"

;TODO: check for "required" aka dependencies

Runwait *RunAs Package_Installer.ahk "%packs%",,UseErrorLevel

if ( (ecode:=ErrorLevel)==Install.Success )
	MsgBox, 64, , Installation finished successfully.
else
	MsgBox, 16, , % "An installation error occured.`n(ExitCode: " ecode " [""" Install_ExitCode(ecode) """])"