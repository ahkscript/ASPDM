#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include Lib\NetworkAPI.ahk

Gui, Add, ListView, x4 y4 w500 h250 gListViewEvents, File|Name|Version|Author|index
Gui, Show,,%A_scriptName% - DoubleClick to view screenshot...

Gui, projector:+ToolWindow
Gui, projector:Margin, 0, 0
Gui, projector:Add, ActiveX, w320 h240 vWB, Shell.Explorer
WB.silent := true

LV_Add("","Downloading...")
LV_ModifyCol(1,"100")
LV_ModifyCol(2,"220")
LV_ModifyCol(3,"60")
LV_ModifyCol(4,"80")
LV_ModifyCol(5,"0")
if !Ping() {
	MsgBox, 16, , Network Error : Check your internet connection.`nThe program will now exit.
	ExitApp
}
Progress CWFEFEF0 CT111111 CB468847 w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11, Waiting..., Loading Package List...
Progress Show

packs:=API_ListAll()
total:=Util_ObjCount(packs)
for each, info in packs
	LV_Add("",info["id"] ".ahkp",info["name"],info["version"],info["author"],each)
LV_Delete(1)
Sleep 100
Progress, Off
return

ListViewEvents:
if A_GuiEvent = DoubleClick
{
	if (!A_EventInfo)
		return
	
	Gui +OwnDialogs
	LV_GetText(objRef,A_EventInfo,5)
	t := packs[objRef].id ".ahkp - Screenshot"
	s := packs[objRef].screenshot
	if StrLen(s) {
		Gui 1:+Disabled
		Gui, projector:+Owner1
		HTML_page := "<!DOCTYPE html><html><body><img src=""" s """ title=""screenshot"" alt=""ERROR: failed to load screenshot."" style=""max-width:100%;max-height:100%;""></body></html>"
		Display(WB,HTML_page)
		Gui, projector:Show,,%t%
	} else {
		MsgBox No screenshot to show.
	}
}
return

load_progress(t,c,f) {
	p:=Round((c/f)*100)
	Progress, %p% , Loading:  %c% / %f% items  [ %p%`% ] , %t%
}

Display(wb,html_str) {
	wb.Navigate("about:blank")
	while wb.readystate != 4
		sleep, 50
	wb.document.Write(html_str)
}

projectorGuiClose:
Gui 1:-Disabled
Gui projector:hide
return

GuiClose:
ExitApp
