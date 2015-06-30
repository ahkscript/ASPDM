#NoTrayIcon

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include Lib\Arguments.ahk

if (!A_IsCompiled) {
	MsgBox, 48, , Please compile this script first.
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

if (!FileExist(FILE_str:=args[1])) {
	MsgBox, 16, , Error: Could not open file:`n`n`t"%FILE_str%"
	ExitApp
}

Progress CWFEFEF0 CT111111 CB468847 w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11, Waiting..., Loading Package...
Progress Show
info:=JSON_ToObj(Manifest_FromPackage(FILE_str)) ;assuming only one package. Future: CSV Elements -> Loop for each
pack_id:=info["id"]
load_progress(pack_id,1,1)
Sleep 100
Progress, Off
if (StrLen(trim(pack_id))==0) {
	MsgBox, 16, , Error: The following package seems to be invalid:`n`n`t"%FILE_str%"
	ExitApp
}
run Package_Lister.ahk "--local" "%FILE_str%",,UseErrorLevel
if ErrorLevel
	MsgBox, 48, , ASPDM could not start properly.`nError: (%ErrorLevel%)[%A_LastError%]
ExitApp

load_progress(t,c,f) {
	p:=Round((c/f)*100)
	Progress, %p% , Loading:  %c% / %f% items  [ %p%`% ] , %t%
}
