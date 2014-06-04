#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include Lib\Install.ahk
#Include Lib\Settings.ahk
#Include Lib\Arguments.ahk

if (!A_IsAdmin)
   ExitApp, % Install.Error_NonAdministrator
if (!args)
	ExitApp, % Install.Error_InvalidParameters

Settings:=Settings_Get()

FileCreateDir, % Local_Repo:=Settings.Local_Repo
if ErrorLevel
	ExitApp, % Install.Error_CreateRepoDir

FileCreateDir, % Local_Archive:=Settings.Local_Archive
if ErrorLevel
	ExitApp, % Install.Error_CreateArchiveDir

InstallationFolder:=Settings.StdLib_Folder ;Should be fetched from "settings/Config" file
/*	Possible Lib\ Folders:

	%A_ScriptDir%\Lib\  ; Local library - requires AHK_L 42+.
	%A_MyDocuments%\AutoHotkey\Lib\  ; User library.
	path-to-the-currently-running-AutoHotkey.exe\Lib\  ; Standard library.
*/

packs:=StrSplit(args[1],"|")
if (!IsObject(packs))
	ExitApp, % Install.Error_NoAction
TotalItems:=packs.MaxIndex()
	
;Remove Packages
	Progress CWFEFEF0 CT111111 CB468847 w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11, Waiting..., Removing Packages...
	Progress Show
for Current, id_akhp in packs
{
	arch_file := Local_Archive "\" id_akhp ;Rename : [ID].ahkp
	
	;Assure file existance
	if (!FileExist(arch_file))
		ExitApp, % Install.Error_NonExistantFile
	
	;Get package ID from metadata
	mdata:=JSON_ToObj(Manifest_FromPackage(arch_file))
	
	;Setup Deletion Lists
	RepoSubDir := Local_Repo "\" mdata["id"]
	RepoSubDirLib := RepoSubDir "\Lib"
	if (!FileExist(RepoSubDirLib))
		ExitApp, % Install.Error_NonExistantDir
	RemList:=Object()
	Loop, %RepoSubDirLib%\*, 1, 0
	{
		RemList.Insert(A_LoopFileName)
	}
	
	;Delete files in StdLib folder
	For each, file in RemList
	{
		if (_fAttrib:=FileExist(InstallationFolder "\" file))
		{
			if (InStr(_fAttrib, "D")) {
				FileRemoveDir,%InstallationFolder%\%file%,1
				if ErrorLevel
					ExitApp, % Install.Error_DeleteStdLibSubDir
			}
			else
			{
				FileDelete,%InstallationFolder%\%file%
				if ErrorLevel
					ExitApp, % Install.Error_DeleteStdLib
			}
		}
	}
	
	;Delete data in local repo "[ID]\"
	FileRemoveDir,%RepoSubDir%,1
	if ErrorLevel
		ExitApp, % Install.Error_DeleteRepoSubDir
	
	;Remove Package ID from "Installed" in Settings
	for x, installed in Settings.installed
		if (installed==mdata["id"])
			Settings.installed.Remove(x)
	
	;Save settings right-away in case of error-exit
	Settings_Save(Settings)
	
	;Increment progress bar
	load_progress(mdata["id"],Current,TotalItems)
}
	Sleep 100
	Progress, Off

;Save Settings & Exit Success
Settings_Save(Settings)
ExitApp, % Install.Success

load_progress(t,c,f) {
	p:=Round((c/f)*100)
	Progress, %p% , Removing:  %c% / %f% items  [ %p%`% ] , %t%
}

