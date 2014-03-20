#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include Lib\Arguments.ahk

if (!A_IsAdmin)
   ExitApp,1
if (!args)
	ExitApp,2

InstallationFolder:=RegExReplace(A_AhkPath,"\w+\.exe","lib")
;Should be fetched from "settings/Config" file
/*	Possible Lib\ Folders:

	%A_ScriptDir%\Lib\  ; Local library - requires AHK_L 42+.
	%A_MyDocuments%\AutoHotkey\Lib\  ; User library.
	path-to-the-currently-running-AutoHotkey.exe\Lib\  ; Standard library.
*/
packs:=StrSplit(args[1],"|")
TotalItems:=packs.MaxIndex()
	
;Install Packages
	Progress CWFEFEF0 CT111111 CB468847 w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11, Waiting..., Installing Packages...
	Progress Show
for Current, FilePath in packs
{
	SplitPath,FilePath,FileName,FileDir
	if !StrLen(FileDir)	{
		FileDir:=A_WorkingDir
		FilePath:=FileDir "\" FileName
	}
	
	if (!FileExist(FilePath))
		ExitApp,3

	mdata:=JSON_ToObj(Manifest_FromPackage(FilePath))

	if !Package_Extract(InstallationFolder "\" mdata["id"], FilePath)
		ExitApp,4

	load_progress(FileName,Current,TotalItems)
}
	Sleep 100
	Progress, Off

ExitApp,21 ;Success

load_progress(t,c,f) {
	p:=Round((c/f)*100)
	Progress, %p% , Installing:  %c% / %f% items  [ %p%`% ] , %t%
}

