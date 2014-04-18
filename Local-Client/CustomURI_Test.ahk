#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include Lib\Arguments.ahk
#Include Lib\NetworkAPI.ahk

; Custom URI Documentation : http://msdn.microsoft.com/en-us/library/ie/aa767914

if (!A_IsCompiled) {
	MsgBox, 48, , Please run "CustomURI_Test-SetupURI.ahk" first.
	ExitApp
}
/*
if (!A_IsAdmin) {
	MsgBox, 16, , Error: Please run as Administrator.
	ExitApp
}
*/
if (!args) {
	MsgBox, 16, , Error: no args
	ExitApp
}

URI_str:=RegExReplace(args[1],"(aspdm:|\/+)") ; ex:  aspdm://samples.ahkp/ or aspdm:samples.ahkp

if !Ping() {
	MsgBox, 16, , Network Error : Check your internet connection.`nThe program will now exit.
	ExitApp
}
Progress CWFEFEF0 CT111111 CB468847 w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11, Waiting..., Loading Package List...
Progress Show
info:=JSON_ToObj(API_info(URI_str)) ;assuming only one package. Future: CSV Elements -> Loop for each
if (!info.MaxIndex()) {
	Progress, Off
	MsgBox, 48, , The ASPDM API is not responding.`nThe server might be down.`n`nPlease try again in while (5 min).
	ExitApp
}
pack_id:=info["id"]
pack_name:=info["name"]
pack_copy:=info["license"]
pack_desc:=info["description"]
load_progress(URI_str,1,1)
Sleep 100
Progress, Off
if (StrLen(trim(pack_id))==0) {
	MsgBox, 16, , Error: Non existent Package ("%URI_str%")?
	ExitApp
}
MsgBox, 68, , Download Package?`nID: `t%pack_id%`nName: `t%pack_name%`nLicense: `t%pack_copy%`n`nDescription: `n%pack_desc%
IfMsgBox, Yes
{
	Gui +OwnDialogs
	FileSelectFile, _SelectedFile, S18, %pack_id%.ahkp, Save package : %pack_name%, AHKP file (*.ahkp)
	if _SelectedFile =
		MsgBox, 64, , Package file was not saved.
	else
	{
		tmp_file:=API_Get(pack_id ".ahkp")
		FileMove,%tmp_file%,%_SelectedFile%,1
		if ( (!FileExist(tmp_file)) && (FileExist(_SelectedFile)) )
			MsgBox, 64, , Download Successful
		else
			MsgBox, 16, , Error: Download Unsuccessful
	}
}
ExitApp

load_progress(t,c,f) {
	p:=Round((c/f)*100)
	Progress, %p% , Loading:  %c% / %f% items  [ %p%`% ] , %t%
}
