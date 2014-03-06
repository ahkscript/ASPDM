#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

/*
	API temporarily hosted @ api-php.aspdm.1eko.com
	See https://trello.com/c/V27ITnHO/16-web-server-api

	info.php	--	Get JSON info from a package in "packs/"
		Usage: ?f=FILENAME&c=JSONITEM
		If 'JSONITEM' is specified, it returns a normal string.
		Otherwise, a JSON string is returned.
		
	list.php	--	List all files in "packs/"
		Usage: no arguments
		Returns a list of all packages seperated by '`n'
		
	submit.php	--	Used for the online upload form
		no arguments
*/

u2v(u){
	URLDownloadToFile,%u%, % t:=Util_TempFile()
	FileRead,x,%t%
	FileDelete,%t%
	return x
}

API_list() {
	l:=StrSplit(u2v("http://api-php.aspdm.1eko.com/list.php"),"`n")
	l.Remove(l.MaxIndex())
	return l
}

API_info(file,item="") {
	return u2v("http://api-php.aspdm.1eko.com/info.php?f=" . file . "&c=" . item)
}

API_Get(file) {
	DownloadFile("http://packs.aspdm.1eko.com/" file,t:=Util_TempFile())
	return t
}

Gui, Add, ListView, x4 y4 w500 h250 gListViewEvents, File|Name|Version|Author|Description
Gui, Show,,%A_scriptName% - DoubleClick to Download...

LV_Add("","Downloading...")
LV_ModifyCol(1,"100")
LV_ModifyCol(2,"120")
LV_ModifyCol(3,"60")
LV_ModifyCol(4,"80")
LV_ModifyCol(5,"290")
if !Ping() {
	MsgBox, 16, , Network Error : Check your internet connection.`nThe program will now exit.
	ExitApp
}
Progress CWFDFDB1 CT111111 CB468847 w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11, Waiting..., Loading Package List...
Progress Show
packs:=API_list()
total:=packs.MaxIndex()
Loop % total
{
	info:=JSON_ToObj(API_info(packs[A_Index]))
	LV_Add("",packs[A_Index],info["name"],info["version"],info["author"],info["description"])
	load_progress(packs[A_Index],A_Index,total)
}
LV_Delete(1)
Sleep 100
Progress, Off
return

ListViewEvents:
if A_GuiEvent = DoubleClick
{
	LV_GetText(FileName,A_EventInfo,1)
	LV_GetText(pack_name,A_EventInfo,2)
	LV_GetText(pack_desc,A_EventInfo,4)
	MsgBox, 68, , Download Package?`nName: %pack_name%`nDesc: %pack_desc%
	IfMsgBox, Yes
	{
		Gui +OwnDialogs
		FileSelectFile, _SelectedFile, S18, %FileName%, Save package, AHKP file (*.ahkp)
		if _SelectedFile =
			MsgBox, 64, , Package file was not saved.
		else
		{
			tmp_file:=API_Get(FileName)
			FileMove,%tmp_file%,%_SelectedFile%,1
			if ( (!FileExist(tmp_file)) && (FileExist(_SelectedFile)) )
				MsgBox, 64, , Download Successful
			else
				MsgBox, 16, , Error: Download Unsuccessful
		}
	}
}
return

GuiClose:
ExitApp

load_progress(t,c,f) {
	p:=Round((c/f)*100)
	Progress, %p% , Loading:  %c% / %f% items  [ %p%`% ] , %t%
}

