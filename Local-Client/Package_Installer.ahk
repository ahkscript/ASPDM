﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
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
ExamplesFolder:=Settings.StdLib_Examples_Folder ;Should be fetched from "settings/Config" file
DocsFolder:=Settings.StdLib_Docs_Folder ;Should be fetched from "settings/Config" file
/*	Possible Lib\ Folders:

	%A_ScriptDir%\Lib\  ; Local library - requires AHK_L 42+.
	%A_MyDocuments%\AutoHotkey\Lib\  ; User library.
	path-to-the-currently-running-AutoHotkey.exe\Lib\  ; Standard library.
*/

packs:=StrSplit(args[1],"|")
if (!IsObject(packs))
	ExitApp, % Install.Error_NoAction
TotalItems:=packs.MaxIndex()

;Install Packages
	Progress CWFEFEF0 CT111111 CB468847 w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11, Waiting..., Installing Packages...
	Progress Show
for Current, FilePath in packs
{
	;Validate File Paths
	SplitPath,FilePath,FileName,FileDir
	if !StrLen(FileDir)	{
		FileDir:=A_WorkingDir
		FilePath:=FileDir "\" FileName
	}
	
	;Assure file existance
	if (!FileExist(FilePath))
		ExitApp, % Install.Error_NonExistantFile
	
	;Get package ID from metadata
	mdata:=JSON_ToObj(Manifest_FromPackage(FilePath))
	
	;Check version of AutoHotkey
	if (Util_VersionCompare(ver_pack:=mdata.ahkversion,A_AhkVersion)) {
		MsgBox, 52, , The package's AutoHotkey version is greater than the installed version:`n`t%ver_pack%`n`t%A_AhkVersion%`nDo you want to continue the installation?
		IfMsgBox, No
			ExitApp, % Install.Error_AhkVersionInvalid
	}
	
	;Make backup copy to asdpm\archive\*.ahkp
	arch_file := Local_Archive "\" mdata["id"] ".ahkp" ;Rename : [ID].ahkp
	if (!FileExist(arch_file))
	{
		FileCopy,%FilePath%,%arch_file%,1
		if ErrorLevel
			ExitApp, % Install.Error_ArchiveBackup
	}
	else
	{
		FileGetSize,file_Sz,%FilePath%
		FileGetSize,arch_Sz,%arch_file%
		mdata_arch:=JSON_ToObj(Manifest_FromPackage(arch_file))
		if ( (file_Sz!=arch_Sz) || (mdata["id"] != mdata_arch["version"]) ) {
			FileCopy,%FilePath%,%arch_file%,1
			if ErrorLevel
				ExitApp, % Install.Error_ArchiveBackup
		}
	}
	
	;Setup Extraction Dirs
	FileCreateDir, % ExtractDir := Local_Repo "\" mdata["id"]
	if ErrorLevel
		ExitApp, % Install.Error_CreateRepoSubDir
	RepoSubDir := ExtractDir "\Lib"
	RepoSampleDir := ExtractDir "\Examples"
	RepoDocsDir := ExtractDir "\Docs"
	
	;Extract package to local repo
	if !Package_Extract(ExtractDir, FilePath)
		ExitApp, % Install.Error_Extraction
	
	;Copy data from local repo "Lib\" to StdLib "Lib\"
	FileCopyDir,%RepoSubDir%,%InstallationFolder%,1
	if ErrorLevel
	{
		;Delete or clean before exit
		FileRemoveDir,%ExtractDir%,1
		ExitApp, % Install.Error_CopyToStdLib
	}
	
	;Copy data from local repo "Examples\" to StdLib "Examples\"
	FileCopyDir,%RepoSampleDir%,%ExamplesFolder%,1
	if ErrorLevel
	{
		;Delete or clean before exit
		FileRemoveDir,%ExtractDir%,1
		ExitApp, % Install.Error_CopyToStdLib
	}
	
	;Copy data from local repo "Docs\" to StdLib "Docs\"
	FileCopyDir,%RepoDocsDir%,%DocsFolder%,1
	if ErrorLevel
	{
		;Delete or clean before exit
		FileRemoveDir,%ExtractDir%,1
		ExitApp, % Install.Error_CopyToStdLib
	}
	
	;delete key in case of "double-install"
	for x, installed in Settings.installed
		if (installed==mdata["id"])
			Settings.installed.Remove(x)
	
	;Append Package ID to "Installed" in Settings
	Settings.installed.Insert(mdata["id"])
	
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
	Progress, %p% , Installing:  %c% / %f% items  [ %p%`% ] , %t%
}

