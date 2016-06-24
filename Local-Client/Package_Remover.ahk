#NoTrayIcon

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include Lib\Install.ahk
#Include Lib\Settings.ahk
#Include Lib\Arguments.ahk

;if (!A_IsAdmin)
;	ExitApp, % Install.Error_NonAdministrator
if (!args)
	ExitApp, % Install.Error_InvalidParameters

Settings:=Settings_Get()

FileCreateDir, % Local_Repo:=Settings.Local_Repo
if ErrorLevel
	ExitApp, % Install.Error_CreateRepoDir

FileCreateDir, % Local_Archive:=Settings.Local_Archive
if ErrorLevel
	ExitApp, % Install.Error_CreateArchiveDir

InstallMode:="NULL"
if (SubStr(args[1],1,2) == "--") {
	InstallMode := SubStr(args[1],3)
	pList := args[2]
} else {
	pList := args[1]
}

if Instr(InstallMode,"User") {
	InstallationFolder := Settings.userlib_folder
} else if Instr(InstallMode,"Custom") {
	InstallationFolder := Settings.customlib_folder
} else { ;/ "Global"
	InstallationFolder:=Settings.StdLib_Folder ;Should be fetched from "settings/Config" file
}
/*	Possible Lib\ Folders:

	%A_ScriptDir%\Lib\  ; Local library - requires AHK_L 42+.
	%A_MyDocuments%\AutoHotkey\Lib\  ; User library.
	path-to-the-currently-running-AutoHotkey.exe\Lib\  ; Standard library.
*/
InstallIndex := Settings_InstallGet(InstallationFolder)

packs:=StrSplit(pList,"|")
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
	
	
	if (Instr(mdata["type"],"Lib")) { ;if package type is 'library'
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
	} else { ;'Tool/Other' type package
		_tmpname:=mdata["id"]
		try_remove_tool:
		RunWait, %RepoSubDir%\Remove.ahk, %RepoSubDir%, UseErrorLevel
		if ( ErrorLevel || ErrorLevel=="ERROR" ) { ;Remove Script failure
			MsgBox, 20, , The '%_tmpname%' tool remove script has failed.`nTry again?`n`nError code: [%ErrorLevel%:%A_LastError%]
			ifMsgBox, Yes
				goto,try_remove_tool
			else
				ExitApp, % Install.Error_ToolRemoveScript
		}
	}
	
	/* comment out for now, because of deletion of local repo
	*  should not happen when still installed in other Lib dirs
	;Delete data in local repo "[ID]\"
	if FileExist(RepoSubDir) {
		FileRemoveDir,%RepoSubDir%,1
		if ErrorLevel
			ExitApp, % Install.Error_DeleteRepoSubDir
	}
	*/
	
	;Remove Package ID from "Installed" in Settings
	for x, installed in InstallIndex.installed
		if (installed==mdata["id"])
			InstallIndex.installed.Remove(x)
	
	;Save settings right-away in case of error-exit
	Settings_InstallSave(InstallationFolder,InstallIndex)
	
	;Increment progress bar
	load_progress(mdata["id"],Current,TotalItems)
}
	Sleep 100
	Progress, Off

;Save Settings & Exit Success
Settings_Save(Settings)
Settings_InstallSave(InstallationFolder,InstallIndex)
ExitApp, % Install.Success

load_progress(t,c,f) {
	p:=Round((c/f)*100)
	Progress, %p% , Removing:  %c% / %f% items  [ %p%`% ] , %t%
}

