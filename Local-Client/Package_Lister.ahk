#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include Lib\NetworkAPI.ahk
#Include Lib\LV_Colors.ahk

CheckedItems:=0

; "Standard" ASPDM Header
Gui, Font, s16 wBold, Arial
Gui, Add, Picture, x12 y8 w32 h-1, res\ahk.png
Gui, Add, Text, x+4 yp+4 , ASPDM
Gui, Font
Gui, Add, Text, yp+5 x+12, AHKScript.org's Package/StdLib Distribution and Management

Gui, +hwndhGUI +Resize +MinSize480x304

;gui tabs
Gui, Add, Tab2, x8 y+16 w456 h264 vTabs gTabSwitch, Available|Updates|Installed|Settings
	Gui, Add, ListView, x16 y+8 w440 h200 Checked AltSubmit Grid -Multi gListView_Events vLV_A hwndhLV_A, File|Name|Version|Author|Description
	Gui, Add, Button, y+4 w80 vInstallButton Disabled gInstall, Install
	Gui, Add, Button, yp x+2 vInstallFileButton gInstallFile, Install from file...
	Gui, Add, Text, yp+6 x+172 vPackageCounter_A +Right, Loading packages...
Gui, Tab, Updates
	Gui, Add, ListView, x16 y+8 w440 h200 Checked AltSubmit Grid -Multi vLV_U hwndhLV_U, File|Name|Installed Version|Latest Version
	Gui, Add, Button, y+4 w80 Disabled vUpdateButton gUpdate, Update
	Gui, Add, Button, yp x+2 vUpdateFileButton gUpdateFile, Update from file...
	Gui, Add, Text, yp+6 x+172 +Right vPackageCounter_U, Loading packages...
Gui, Tab, Installed
	Gui, Add, ListView, x16 y+8 w440 h200 Checked AltSubmit Grid -Multi vLV_I hwndhLV_I, File|Name|Installed Version
	Gui, Add, Button, y+4 w80 Disabled vRemoveButton gRemove, Remove
	Gui, Add, Text, yp+6 x+252 +Right vPackageCounter_I, Loading packages...
Gui, Tab, Settings
	Gui, Add, Checkbox, y78 x20 Checked, Hide Installed Packages in Available tab
	Gui, Add, Checkbox, y+4 xp, Only show StdLib Packages
	Gui, Add, Text, y+10 xp, StdLib Installation folder
	Gui, Add, Button, yp-5 x+4, Browse...
	Gui, Add, Edit, yp+1 x+4 w250 Disabled, % RegExReplace(A_AhkPath,"\w+\.exe","lib") ;temporary
Gui, Tab,
	Gui, Add, Edit, vSearchBar gSearch y44 x272 w250,
	SetEditPlaceholder("SearchBar","Search...")

Gui, Show, w480, ASPDM - Package Listing

Gui, ListView, LV_U
LV_ModifyCol(1,"100")
LV_ModifyCol(2,"170")
LV_ModifyCol(3,"90")
LV_ModifyCol(4,"80")
Gui, ListView, LV_I
LV_ModifyCol(1,"100")
LV_ModifyCol(2,"250")
LV_ModifyCol(3,"90")
Gui, ListView, LV_A
_selectedlist:="LV_A"
_selectedlistH:=hLV_A
LV_Add("","Downloading...")
LV_ModifyCol(1,"100")
LV_ModifyCol(2,"120")
LV_ModifyCol(3,"60")
LV_ModifyCol(4,"80")
LV_ModifyCol(5,"300")
if Ping() {
	Progress CWFEFEF0 CT111111 CB468847 w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11, Waiting..., Loading Package List...
	Progress Show
	packs:=API_list()
	if (!packs.MaxIndex()) {
		Progress, Off
		ListView_OfflineMsg:="Offline mode, ASPDM API is not responding."
		gosub, ListView_Offline
		MsgBox, 48, , The ASPDM API is not responding.`nThe server might be down.`n`nPlease try again in while (5 min).
		return
	}
	TotalItems:=packs.MaxIndex()
	Loop % TotalItems
	{
		info:=JSON_ToObj(API_info(packs[A_Index]))
		LV_Add("",packs[A_Index],info["name"],info["version"],info["author"],info["description"])
		load_progress(packs[A_Index],A_Index,TotalItems)
	}
	GuiControl,,PackageCounter_A, %TotalItems% Packages
	LV_Delete(1)
	Sleep 100
	Progress, Off
	LV_Colors.OnMessage()
	LV_Colors.Attach(hLV_A,1,0,0)
	LV_Colors.Attach(hLV_U,1,0,0)
}
else
{
	ListView_OfflineMsg:="Offline mode, No internet connection detected..."
	gosub, ListView_Offline
}
LV_Colors.Attach(hLV_I,1,0,0)
return

ListView_Offline:
	LV_Delete(1)
	LV_Colors.OnMessage()
	tmp__:="AU"
	Loop, Parse, tmp__
	{
		Gui, ListView, LV_%A_loopField%
		GuiControl,-Checked,LV_%A_loopField%
		GuiControl,,PackageCounter_%A_loopField%, Offline mode
		LV_Add("",ListView_OfflineMsg)
		LV_ModifyCol(1,"300")
		LV_ModifyCol(2,"0")
		LV_ModifyCol(3,"0")
		LV_ModifyCol(4,"0")
		LV_ModifyCol(5,"0")
		LV_Colors.Attach(hLV_%A_loopfield%,1,0,1)
	}
	Gui, ListView, LV_A
return

ListView_Events:
if A_GuiEvent = I
{
	if InStr(ErrorLevel, "C", true)
		CheckedItems+=1
	if InStr(ErrorLevel, "c", true)
		CheckedItems-=1
	if (CheckedItems>0) {
		GuiControl,Enable,InstallButton
		GuiControl,,InstallButton,Install (%CheckedItems%)
	} else {
		CheckedItems:=0
		GuiControl,Disable,InstallButton
		GuiControl,,InstallButton,Install
	}
}
return

TabSwitch:
	GuiControlGet,Tabs,,Tabs
	if (Tabs!="Settings") {
		GuiControl,Show,SearchBar
		GuiControl,Enable,SearchBar
		_selectedlist:="LV_" SubStr(Tabs,1,1)
		Gui, ListView, %_selectedlist%
		GuiControlGet,_selectedlistH,HWND,%_selectedlist%
		gosub Search
	}else
	{
		GuiControl,Disable,SearchBar
		GuiControl,Hide,SearchBar
	}
return

Search:
	GuiControlGet,Query,,SearchBar
	Loop % LV_GetCount()
	{
		;LV_Modify(A_Index, "-Select")
		LV_Colors.Row(_selectedlistH, A_Index, 0xFFFFFF)
	}
	if StrLen(Query)
	{
		QueryList := StrSplit(Query,A_Space)
		Loop % LV_GetCount()
		{
			LV_GetText(ltmpA, A_Index,1)
			LV_GetText(ltmpB, A_Index,2)
			LV_GetText(ltmpC, A_Index,3)
			LV_GetText(ltmpD, A_Index,4)
			LV_GetText(ltmpE, A_Index,5)
			Query_Item_match:=0
			for each, Query_Item in QueryList
			{
				if InStr(ltmpA ltmpB ltmpC ltmpD ltmpE, Query_Item, 0)
				{
					Query_Item_match+=1
				}
			}
			if (Query_Item_match == QueryList.MaxIndex()) {
				;LV_Modify(A_Index, "Select Vis")
				LV_Modify(A_Index, "Vis")
				LV_Colors.Row(_selectedlistH, A_Index, 0xFFFFAD)
			}
			Query_Item_match:=0
		}
	}
	GuiControl, +Redraw, %_selectedlistH%
return

GuiSize:
	GuiControl,move,Tabs, % "w" (A_GuiWidth-16) " h" (A_GuiHeight-60)
	GuiControl,move,SearchBar, % "x" (A_GuiWidth-258)
	GuiSize_list:="AUI"
	Loop, Parse, GuiSize_list
	{
		GuiControl,move,LV_%A_LoopField%, % "w" (A_GuiWidth-32) " h" (A_GuiHeight-124)
		GuiControl,move,PackageCounter_%A_LoopField%, % "y" (A_GuiHeight-38) " x" (A_GuiWidth-118)
	}
	GuiSize_list:="Install|InstallFile|Update|UpdateFile|Remove"
	Loop, Parse, GuiSize_list, |
		GuiControl,move,%A_LoopField%Button, % "y" (A_GuiHeight-44)
return

GuiClose:
ExitApp

Install:
InstallFile:
Update:
UpdateFile:
/*
	Installation process
*/
Remove:
return

load_progress(t,c,f) {
	p:=Round((c/f)*100)
	Progress, %p% , Loading:  %c% / %f% items  [ %p%`% ] , %t%
}

