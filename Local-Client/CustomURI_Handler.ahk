#NoTrayIcon

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include Lib\Arguments.ahk
#Include Lib\NetworkAPI.ahk

; Custom URI Documentation : http://msdn.microsoft.com/en-us/library/ie/aa767914

if (!A_IsCompiled) {
	MsgBox, 48, , Please run "CustomURI_SetupURI.ahk" first.
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

URI_str:=Trim(RegExReplace(args[1],"(aspdm:\/+)"),"/ `t") ; ex:  aspdm://samples.ahkp/ or aspdm:samples.ahkp

if !Ping() {
	MsgBox, 16, , Network Error : Check your internet connection.`nThe program will now exit.
	ExitApp
}
Progress CWFEFEF0 CT111111 CB468847 w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11, Waiting..., Loading Package List...
Progress Show
info:=JSON_ToObj(raw:=API_info(URI_str)) ;assuming only one package. Future: CSV Elements -> Loop for each
if (!strlen(info["id"])) {
	Progress, Off
	if (InStr(raw,"suspended"))
		raw_reason:="ERROR: Server suspended for 24 hours."
	else if (InStr(raw,"File does not exist.")) {
		MsgBox, 48, , The following package does not exist:`n%URI_str%`n`nServer Response:`n[[%raw%]]
		ExitApp
	} else
		raw_reason:=raw
	MsgBox, 48, , The ASPDM API is not responding.`nThe server might be down.`nPlease try again in while (5 min).`n`nServer Response:`n[[%raw_reason%]]
	ExitApp
}
pack_id:=info["id"]
load_progress(URI_str,1,1)
Sleep 100
Progress, Off
if (StrLen(trim(pack_id))==0) {
	MsgBox, 16, , Error: Non existent Package ("%URI_str%")?
	ExitApp
}
run Package_Lister.ahk "%pack_id%.ahkp",,UseErrorLevel
if ErrorLevel
	MsgBox, 48, , ASPDM could not start properly.`nError: (%ErrorLevel%)[%A_LastError%]
ExitApp

load_progress(t,c,f) {
	p:=Round((c/f)*100)
	Progress, %p% , Loading:  %c% / %f% items  [ %p%`% ] , %t%
}
