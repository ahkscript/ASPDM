#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include Lib\Install.ahk
#Include Lib\NetworkAPI.ahk
#Include Lib\LV_Colors.ahk

CheckedItems:=0

;get settings
Settings:=Settings_Get()
Local_Repo:=Settings.Local_Repo
Local_Archive:=Settings.Local_Archive
Hide_Installed:=(!(!(Settings.hide_installed)))+0
Only_Show_StdLib:=(!(!(Settings.only_show_stdlib)))+0

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
	Gui, Add, ListView, x16 y+8 w440 h200 Checked AltSubmit Grid -Multi gListView_Events vLV_I hwndhLV_I, File|Name|Installed Version
	Gui, Add, Button, y+4 w80 Disabled vRemoveButton gRemove, Remove
	Gui, Add, Text, yp+6 x+252 +Right vPackageCounter_I, Loading packages...
Gui, Tab, Settings
	Gui, Add, Checkbox, y78 x20 vHide_Installed, Hide Installed Packages in Available tab
	Gui, Add, Checkbox, y+4 xp vOnly_Show_StdLib, Only show StdLib Packages
	GuiControl,,Hide_Installed, % Hide_Installed
	GuiControl,,Only_Show_StdLib, % Only_Show_StdLib
	Gui, Add, Text, y+10 xp, StdLib Installation folder
	Gui, Add, Button, yp-5 x+4, Browse...
	Gui, Add, Edit, yp+1 x+4 w250 Disabled, % Settings.stdlib_folder ;temporary
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
	packs:=API_ListAll()
	if (!IsObject(packs)) {
		Progress, Off
		ListView_OfflineMsg:="Offline mode, ASPDM API is not responding."
		gosub, ListView_Offline
		MsgBox, 48, , The ASPDM API is not responding.`nThe server might be down.`n`nPlease try again in while (5 min).
		return
	}
	TotalItems:=Util_ObjCount(packs)
	for each, info in packs
		LV_Add("",info["id"] ".ahkp",info["name"],info["version"],info["author"],info["description"])
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
;List installed packs
gosub,List_Installed
LV_Colors.Attach(hLV_I,1,0,0)
Gui, ListView, LV_A
return

List_Installed:
	Gui, ListView, LV_I
	for each, IPacks in Settings.Installed
	{
		i_pack:=Local_Archive "\" IPacks ".ahkp"
		i_info:=JSON_ToObj(Manifest_FromPackage(i_pack))
		LV_Add("",i_info["id"] ".ahkp",i_info["name"],i_info["version"])
	}
	TotalItems_I := Util_ObjCount(Settings.Installed)
	GuiControl,,PackageCounter_I, %TotalItems_I% Packages
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
return

ListView_Events:
if A_GuiEvent = I
{
	if InStr(ErrorLevel, "C", true)
		CheckedItems%_selectedlist%+=1
	if InStr(ErrorLevel, "c", true)
		CheckedItems%_selectedlist%-=1
	if (CheckedItems%_selectedlist%>0) {
		if (_selectedlist == "LV_A")
		{
			GuiControl,Enable,InstallButton
			GuiControl,,InstallButton,Install (%CheckedItemsLV_A%)
		}
		if (_selectedlist == "LV_I")
		{
			GuiControl,Enable,RemoveButton
			GuiControl,,RemoveButton,Remove (%CheckedItemsLV_I%)
		}
	} else {
		CheckedItems%_selectedlist%:=0
		if (_selectedlist == "LV_A")
		{
			GuiControl,Disable,InstallButton
			GuiControl,,InstallButton,Install
		}
		if (_selectedlist == "LV_I")
		{
			GuiControl,Disable,RemoveButton
			GuiControl,,RemoveButton,Remove
		}
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
	Gui +Disabled
	;Installation process
	;TODO: check for "required" aka dependencies
	
	;example - Install_packs:="~built_packs~\winfade.ahkp"
	Install_packs := ""
	Install_packs_rows := ""
	r_check:=0
	Loop
	{
		r_check := LV_GetNext(r_check,"Checked")
		if (!r_check)
		break
		LV_GetText(r_item,r_check,1)
		r_path:=API_Get(r_item) ;download the package
		Install_packs.= r_path "|"
		Install_packs_rows.= r_check "|"
	}
	Install_packs:=SubStr(Install_packs,1,-1)
	Install_packs_rows:=SubStr(Install_packs_rows,1,-1)
	;Note WinXP Command-line 8191 chars limitation
	;  http://support.microsoft.com/kb/830473
	;Assuming approximately 50 each file path, should be around 114 packages with "|" delimiters
	Runwait *RunAs Package_Installer.ahk "%Install_packs%",,UseErrorLevel
	if ( (ecode:=ErrorLevel)==Install.Success )
	{
		;Update list
		/* TODO : hide installed Option
		Install_packs_list:=StrSplit(Install_packs_rows,"|")
		for x, Install_packs_row in Install_packs_list
			LV_Delete(Install_packs_row+0)
		CheckedItems%_selectedlist%:=0
		GuiControl,Disable,InstallButton
		GuiControl,,InstallButton,Install
		*/
		
		;Update "Installed" list - full-blown list update
		Settings:=Settings_Get()
		Gui, ListView, LV_I
		LV_Delete()
		gosub,List_Installed
		Gui, ListView, LV_A
		
		MsgBox, 64, , Installation finished successfully.
	}
	else
		MsgBox, 16, , % "An installation error occured.`n(ExitCode: " ecode " [""" Install_ExitCode(ecode) """])"
	
	Gui -Disabled
return

InstallFile:
Update:
UpdateFile:
return

Remove:
	Gui +Disabled
	Remove_packs := ""
	Remove_packs_rows := ""
	r_check:=0
	Loop
	{
		r_check := LV_GetNext(r_check,"Checked")
		if (!r_check)
		break
		LV_GetText(r_item,r_check,1)
		Remove_packs.= r_item "|"
		Remove_packs_rows.= r_check "|"
	}
	Remove_packs:=SubStr(Remove_packs,1,-1)
	Remove_packs_rows:=SubStr(Remove_packs_rows,1,-1)
	
	Runwait *RunAs Package_Remover.ahk "%Remove_packs%",,UseErrorLevel
	if ( (ecode:=ErrorLevel)==Install.Success )
	{
		;Update list
		/*MsgBox % Remove_packs_rows
		Remove_packs_list:=StrSplit(Remove_packs_rows,"|")
		for x, Remove_packs_row in Remove_packs_list
			LV_Delete(Remove_packs_row+0)
		*/
		;full-blown list update
		Settings:=Settings_Get()
		Gui, ListView, LV_I
		LV_Delete()
		gosub,List_Installed
		Gui, ListView, LV_I
		
		;Update Button
		CheckedItems%_selectedlist%:=0
		GuiControl,Disable,RemoveButton
		GuiControl,,RemoveButton,Remove
		
		MsgBox, 64, , Removal finished successfully.
	}
	else
		MsgBox, 16, , % "An uninstallation error occured.`n(ExitCode: " ecode " [""" Install_ExitCode(ecode) """])"
	
	Gui -Disabled
return

load_progress(t,c,f) {
	p:=Round((c/f)*100)
	Progress, %p% , Loading:  %c% / %f% items  [ %p%`% ] , %t%
}

