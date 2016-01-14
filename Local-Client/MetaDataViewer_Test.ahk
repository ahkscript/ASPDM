#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include Lib\NetworkAPI.ahk

Gui, Add, ListView, x4 y4 w500 h250 gListViewEvents, File|Name|Version|Author|index
Gui, Show,,%A_scriptName% - DoubleClick to view screenshot...

Gui, projector:+ToolWindow
Gui, projector:Margin, 0, 0
Gui, projector:Add, ActiveX, w600 h400 vWB, Shell.Explorer
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
	t			:= packs[objRef].id ".ahkp - Screenshot"
	pName 		:= packs[objRef].name
	pAuthor 	:= packs[objRef].author
	pType	 	:= packs[objRef].type
	pVer	 	:= packs[objRef].version
	pURL	 	:= packs[objRef].forumurl
	pReq	 	:= packs[objRef].required, pReq:=(StrLen(pReq))?pReq:"None."
	pLicense	:= packs[objRef].license
	pScreenshot := packs[objRef].screenshot, d := packs[objRef].description
	pDesc		:= (StrLen(d))?d:"No description."
	
	Gui 1:+Disabled
	Gui, projector:+Owner1
	pImgErr:=(StrLen(pScreenshot))?"ERROR: failed to load screenshot.":"No screenshot."
	HTML_page =
	(
	<!DOCTYPE html>
	<html>
		<style>body,textarea{font-family:sans-serif;font-size:11px;}</style>
		<body>
			<h2>%pName%</h2>
			<table class="sortable"><thead><tr><th>Package details</th></tr></thead>
			<tbody><tr></tr>
			<tr><td>Version           : </td><td>%pVer%</td></tr>
			<tr><td>Type              : </td><td>%pType%</td></tr>
			<tr><td>Author            : </td><td>%pAuthor%</td></tr>
			<tr><td>URL               : </td><td><a href="%pURL%">%pURL%</a></td></tr>
			<tr><td class="important">Required Packages : </td><td>%pReq%</td></tr>
			<tr><td class="important_blue">License : </td><td><a href="#">%pLicense%</a></td></tr>
			</tbody><tfoot></tfoot></table>
			<textarea style="width:100`%;height:150px">%pDesc%</textarea>
			<hr>
			<h3>Screenshot</h3>
			<img src="%pScreenshot%" title="screenshot" alt="%pImgErr%" style="max-width:100`%;max-height:100`%;">
		</body>
	</html>
	)
	Display(WB,HTML_page)
	Gui, projector:Show,,%t%
}
return

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
