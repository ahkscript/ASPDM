#NoTrayIcon

#SingleInstance, On  ; Notify User
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines,-1
SetWinDelay,0

#Include Lib\Arguments.ahk
#Include Lib\Install.ahk
#Include Lib\NetworkAPI.ahk
#Include Lib\LV_Colors.ahk

SelfPID:=DllCall("GetCurrentProcessId")

Start_select_localmode:=0
Start_select_pack:=""

if (args) {
	if (argc==1) {
		if SubStr(args[1],-4) = .ahkp
			Start_select_pack:=args[1]
	} else {
		i:=0
		while(i<argc)
		{
			i+=1
			if InStr(args[i],"--local") {
				Start_select_localmode:=1
				if (args[i+1]) {
					if (!FileExist(Start_select_pack:=args[i+1]))
						Start_select_pack:=""
				} else
					continue
				i+=1
			}
			else if InStr(args[i],"--source") {
				if (Package_Source != Trim(args[i+1])) {
					API_SetSource(args[i+1]) ;If unsuccessful, nothing changes
					Start_Package_Source := Package_Source
				} else
					continue
				i+=1
			}
			else if SubStr(args[i],-4) = .ahkp
				Start_select_pack:=args[i]
		}
	}
}

if (FileExist(Start_select_pack))
	Start_select_localmode:=1
else
	Start_select_localmode:=0

if !StrLen(Start_Package_Source)
	Start_Package_Source:=Package_Source

;get settings
Settings:=Settings_Get()

AppVersion:="1.0.0.0"
if (Settings.Check_ClientUpdates)
	CheckUpdate(AppVersion,-1)

CheckedItems:=0

if (!args)
	if (Package_Source != Settings.package_source)
		API_SetSource(Settings.package_source) ;If unsuccessful, nothing changes

Package_Sources:=Util_SingleArray2Str(Util_ArraySort(Settings.package_sources),"|") ;sort and remove duplicates

Menu, tray, Icon, res\ahk.ico

; "Standard" ASPDM Header
Gui, Font, s16 wBold, Arial
Gui, Add, Picture, x12 y8 w32 h-1, res\ahk.png
Gui, Add, Text, x+4 yp+4 , ASPDM
Gui, Font, s8 wNormal, MS Sans Serif
Gui, Font, s8 wNormal, Segoe UI
Gui, Add, Text, yp+5 x+12, AHKScript.org's Package/StdLib Distribution and Management

Gui, +hwndhGUI +Resize +MinSize560x384

;gui tabs
Gui, Add, Tab2, x8 y+16 w456 h264 vTabs gTabSwitch, Available|Updates|Installed|Settings
	Gui, Add, ListView, x16 y+8 w440 h200 Checked AltSubmit Grid -Multi gListView_Events vLV_A hwndhLV_A, File|Name|Version|Author|Source|Description|tags
	Gui, Add, Button, y+4 w80 vInstallButton Disabled gInstall, Install
	Gui, Add, Button, yp x+2 vInstallFileButton gInstallFile, Install from file...
	Gui, Add, Button, yp x+2 w80 vRefresh_AButton gRefresh, Refresh
	Gui, Add, Button, yp x+2 wp vCheckAll_AButton gCheckAll,Check all
	Gui, Add, Text, yp+6 xp+170 vPackageCounter_A +Right, Loading packages...
Gui, Tab, Updates
	Gui, Add, ListView, x16 y+8 w440 h200 Checked AltSubmit Grid -Multi gListView_Events vLV_U hwndhLV_U, File|Name|Installed Version|Latest Version
	Gui, Add, Button, y+4 w80 Disabled vUpdateButton gUpdate, Update
	Gui, Add, Button, yp x+2 vUpdateFileButton gUpdateFile, Update from file...
	Gui, Add, Button, yp x+2 w80 vRefresh_UButton gRefresh, Refresh
	Gui, Add, Button, yp x+2 wp vCheckAll_UButton gCheckAll,Check all
	Gui, Add, Text, yp+6 xp+170 +Right vPackageCounter_U, Loading packages...
Gui, Tab, Installed
	Gui, Add, ListView, x16 y+8 w440 h200 Checked AltSubmit Grid -Multi gListView_Events vLV_I hwndhLV_I, File|Name|Installed Version
	Gui, Add, Button, y+4 w80 Disabled vReinstallButton gReinstall, Reinstall
	Gui, Add, Button, yp x+2 wp Disabled vRemoveButton gRemove, Remove
	Gui, Add, Button, yp x+2 vOpenSelectedButton gOpenSelected, See selected package files
	Gui, Add, Button, yp x+2 w80 vCheckAll_IButton gCheckAll,Check all
	Gui, Add, Text, yp+6 x+252 +Right vPackageCounter_I, Loading packages...
Gui, Tab, Settings
	Gui, Add, Checkbox, y78 x20 vHide_Installed, Hide Installed Packages in Available tab
	Gui, Add, Checkbox, y+4 xp vShow_AllPackSources, Show Packages from all sources
	Gui, Add, Checkbox, y+4 xp vOnly_Show_StdLib Disabled, Only show StdLib Packages
	Gui, Add, Checkbox, y+4 xp vCheck_ClientUpdates, Check for ASPDM client updates
	Gui, Add, Checkbox, y+4 xp vContentSensitiveSearch, Content-Sensitive Search (Uncheck to search tags only)
	GuiControl,,Hide_Installed, % (!(!(Settings.hide_installed)))+0
	GuiControl,,Show_AllPackSources, % (!(!(Settings.Show_AllPackSources)))+0
	GuiControl,,Only_Show_StdLib, % (!(!(Settings.only_show_stdlib)))+0
	GuiControl,,Check_ClientUpdates, % (!(!(Settings.Check_ClientUpdates)))+0
	GuiControl,,ContentSensitiveSearch, % (!(!(Settings.ContentSensitiveSearch)))+0
	Gui, Add, Text, y+10 xp, Package source
	Gui, Add, Button, yp-5 x+4 vPackSource_AddButton gPackSource_Add, Add...
	Gui, Add, Button, yp x+2 vPackSource_RemoveButton gPackSource_Remove, Remove
	Gui, Add, DropDownList, yp+1 x+4 w280 h21 R5 Choose1 vPackSource_list -Multi, %Package_Sources%
	GuiControl, ChooseString, PackSource_list, % Settings.Package_Source
	Gui, Add, Text, y+10 x20, StdLib Installation folder
	Gui, Add, Button, yp-5 x+4 vstdlib_folderBrowseButton gstdlib_folderBrowse, Browse...
	Gui, Add, Edit, yp+1 x+4 w280 h21 Disabled vstdlib_folder -Multi, % Settings.stdlib_folder
	Gui, Add, Button, y278 x16 w80 vSaveSettingsButton gSaveSettings, Save Settings
	Gui, Add, Button, yp x+2 vResetSettingsButton gResetSettings, Reset Settings
	Gui, Add, Button, yp x+2 vClientUpdateButton gClientUpdate, Check for updates
	Gui, Add, Text, yp+6 x+170 +Right vtxt_version, ASPDM Client v%AppVersion%
Gui, Tab,
	Gui, Add, Edit, vSearchBar gSearch y44 x222 w300,
	SetEditPlaceholder("SearchBar","Search...")
	
Gui, Add, StatusBar,, Loading...
SB_SetParts(264)
pk_src_count:=Util_ObjCount(Settings.package_sources)
if (pk_src_count>1)
	SB_SetText("Package sources: " pk_src_count,1)
else
	SB_SetText("Package source: " Package_Source,1)
__tmp_localRepo:=Settings.Local_Repo
StringReplace,__tmp_localRepo,__tmp_localRepo,%A_AppData%,`%AppData`%
SB_SetText("Local repository: " __tmp_localRepo,2)

Gui, Show, w560 h384, ASPDM - Package Listing

start:
Gui +Disabled
Gui +OwnDialogs

ImageListID := IL_Create(2)
IL_Add(ImageListID, "shell32.dll", 73) ;Lib
IL_Add(ImageListID, "shell32.dll", 13) ;tool
IL_Add(ImageListID, "shell32.dll", 1) ;other

Gui, ListView, LV_I
LV_SetImageList(ImageListID)
Gui, ListView, LV_U
LV_ModifyCol(1,"100")
LV_ModifyCol(2,"220")
LV_ModifyCol(3,"105")
LV_ModifyCol(4,"95")
Gui, ListView, LV_I
LV_ModifyCol(1,"120")
LV_ModifyCol(2,"295")
LV_ModifyCol(3,"105")
Gui, ListView, LV_A
_selectedlist:="LV_A"
_selectedlistH:=hLV_A
LV_Add("","Downloading...")
LV_ModifyCol(1,"110")
LV_ModifyCol(2,"120")
LV_ModifyCol(3,"60")
LV_ModifyCol(4,"80")
LV_ModifyCol(5,"80")
LV_ModifyCol(6,"300")
LV_ModifyCol(7,"0") ;make tags invisible
ListView_Offline:=0
if Ping() {
	Progress CWFEFEF0 CT111111 CB468847 w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11, Waiting..., Loading Package List...
	Progress Show
	
	packs_l:=Object()
	if (Settings.Show_AllPackSources) {
		for each, package_src in Settings.package_sources
		{
			if (API_SetSource(package_src))
				packs_l[package_source]:=API_ListAll()
		}
		packs:=packs_l[Settings.package_sources[1]]
	} else {
		API_SetSource(Settings.package_source)
		packs_l[package_source]:=API_ListAll()
		packs:=packs_l[package_source]
	}
	
	if (!IsObject(packs)) {
		Progress, Off
		ListView_OfflineMsg:="Offline mode, ASPDM API is not responding."
		ListView_Offline:=1
		gosub, ListView_Offline
		gosub, List_Installed
		MsgBox, 48, , The ASPDM API is not responding.`nThe server might be down.`n`nPlease try again in a while (5 min).
		Gui -Disabled
		return
	}
	gosub,List_Available
	Sleep 100
	LV_Colors.OnMessage()
	LV_Colors.Attach(hLV_A,1,0,0)
	LV_Colors.Attach(hLV_U,1,0,0)
} else {
	ListView_Offline:=1
	ListView_OfflineMsg:="Offline mode, No internet connection detected..."
	gosub, ListView_Offline
}
;List installed packs
gosub,List_Installed
LV_Colors.Attach(hLV_I,1,0,0)
Gui, ListView, LV_A
Progress, Off
if (ListView_Offline)
{
	MsgBox, 52, , The program is currently running in Offline mode.`nDo you want the program to reload and try again?
	IfMsgBox,Yes
		Reload
}

if (StrLen(Start_select_pack)) {
	Gui +Disabled
	Gui +OwnDialogs
	if (Start_select_localmode) {
		Start_select_packINFO:=JSON_ToObj(Manifest_FromPackage(Start_select_pack))
		Start_select_packID:=Start_select_packINFO["id"]
	} else {
		SplitPath,Start_select_pack,,,,Start_select_packID
	}
	
	if (!array_has_value(Settings.Installed,Start_select_packID)) {
		if (Start_select_localmode) {
			pack_name:=Start_select_packINFO["name"]
			pack_auth:=Start_select_packINFO["author"]
			pack_desc:=Start_select_packINFO["description"]
			pack_desc:=(StrLen(pack_desc))?pack_desc:"No description."
			MsgBox, 36, , Would you like to Install the following package?`n`nPackage Information`nID: `t%Start_select_packID%`nName: `t%pack_name%`nAuthor: `t%pack_auth%`n`nDescription: `n%pack_desc%
			IfMsgBox,Yes
			{
				Install_packs:=Start_select_pack
				gosub,_Install
			}
			Gui -Disabled
			return
		} else {
			Loop
			{
				if !LV_GetText(tmp_fpackname, A_index)
					break
				if InStr(tmp_fpackname,Start_select_pack) {
					LV_GetText(pack_src,A_index,5)
					if pack_src = %Start_Package_Source%
					{
						API_SetSource(pack_src)  ; Apply requested source
						LV_Modify(A_index, "+Check")
						gosub,ListView_Events_checkedList
						GuiControl,,SearchBar,%Start_select_pack%
						LV_GetText(pack_id,A_index,1)
						LV_GetText(pack_name,A_index,2)
						LV_GetText(pack_auth,A_index,4)
						LV_GetText(pack_desc,A_index,6)
						SplitPath,pack_id,,,,pack_id
						pack_desc:=(StrLen(pack_desc))?pack_desc:"No description."
						MsgBox, 64, , Package Information`nID: `t%pack_id%`nName: `t%pack_name%`nAuthor: `t%pack_auth%`n`nDescription: `n%pack_desc%
						Gui -Disabled
						return
					}
				}
			}
			MsgBox, 48, , Could not find the following package:`n"%Start_select_pack%" (%Start_Package_Source%)
		}
	} else {
		MsgBox, 64, , The following package is already installed:`n%Start_select_pack%
		GuiControl, Choose, Tabs, 3 ;switched to "installed" tab
		GuiControl,,SearchBar,%Start_select_packID%.ahkp
		gosub,TabSwitch
	}
}
Gui -Disabled
return

List_Available:
	Gui +Disabled
	Gui, ListView, LV_A
	if (!ListView_Offline)
	{
		LV_Delete()
		
		GuiControl,+Checked,LV_A
		GuiControl,+Checked,LV_U
		
		TotalItems:=0
		for each, packs in packs_l
			TotalItems += Util_ObjCount(packs)
		TotalItemsNew:=TotalItems
		for each, packs in packs_l
		{
		for _each, info in packs
		{
			if (Settings.hide_installed) {
				if (!array_has_value(Settings.Installed,info["id"])) {
					LV_Add("",info["id"] ".ahkp",info["name"],info["version"],info["author"],each,info["description"],Util_TagsObj2CSV(info["tags"]))
					TotalItemsNew-=1
				}
			}
			else
			{
				if (StrLen(info["id"]))
					LV_Add("",info["id"] ".ahkp",info["name"],info["version"],info["author"],each,info["description"],Util_TagsObj2CSV(info["tags"]))
				else
					LV_Add("","ERROR: Unable to load package(s)")
			}
		}
		}
		TotalItemsNew:=(TotalItemsNew<0)?0:(TotalItems-TotalItemsNew)
		if (Settings.hide_installed)
			GuiControl,,PackageCounter_A, %TotalItemsNew%/%TotalItems% Packages
		else
			GuiControl,,PackageCounter_A, %TotalItems% Packages
		
		if (!LV_GetCount())
			GuiControl,Disable,CheckAll_AButton
		else
			GuiControl,Enable,CheckAll_AButton
		
		pk_src_count:=Util_ObjCount(packs_l)
		_tmp_sbtxt:="Package source"
		if (pk_src_count>1)
			_tmp_sbtxt .= "s: " pk_src_count
		else {
			_tmp_sbtxt .= ": " Package_Source
			LV_ModifyCol(5,"0")
		}
		_tmp_sbtxt .= " [" TotalItems " items]"
		SB_SetParts(6*(StrLen(_tmp_sbtxt)+2))
		SB_SetText(_tmp_sbtxt,1)
	}
	Gui -Disabled
return

List_Installed: ;and Updates List
	Gui +Disabled
	Gui, ListView, LV_U
	if (!ListView_Offline)
		LV_Delete()
	TotalItems_U:=0
	Gui, ListView, LV_I
	LV_Delete()
	for each, IPacks in Settings.Installed
	{
		i_pack:=Settings.Local_Archive "\" IPacks ".ahkp"
		i_info:=JSON_ToObj(Manifest_FromPackage(i_pack))
		
		If InStr(i_info["type"],"lib")
			_icon:="Icon1"
		else If InStr(i_info["type"],"tool")
			_icon:="Icon2"
		else
			_icon:="Icon3"
		
		LV_Add(_icon,i_info["id"] ".ahkp",i_info["name"],i_info["version"])
		if (!ListView_Offline) {
			if (_isUpdate:=API_UpdateExists(i_info["id"] ".ahkp",i_info["version"])) {
				Gui, ListView, LV_U
				LV_Add("",i_info["id"] ".ahkp",i_info["name"],i_info["version"],_isUpdate)
				TotalItems_U+=1
				Gui, ListView, LV_I
			}
		}
	}
	if (!ListView_Offline)
		GuiControl,,PackageCounter_U, %TotalItems_U% Packages
	TotalItems_I := Util_ObjCount(Settings.Installed)
	GuiControl,,PackageCounter_I, %TotalItems_I% Packages
	_tmp:="UI"
	Loop,Parse,_tmp
		if (!TotalItems_%A_loopfield%)
			GuiControl,Disable,CheckAll_%A_loopfield%Button
		else
			GuiControl,Enable,CheckAll_%A_loopfield%Button
	Gui -Disabled
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
		LV_ModifyCol(6,"0")
		LV_Colors.Attach(hLV_%A_loopfield%,1,0,1)
	}
return

ListView_Events:
	if A_GuiEvent = I
	{
		if InStr(ErrorLevel,"C")
			gosub, ListView_Events_checkedList
	}
	else if A_GuiEvent = DoubleClick
	{
		if (!A_EventInfo)
			return
		
		if (_selectedlist == "LV_A")
		{
			Gui +Disabled
			Gui +OwnDialogs
			LV_GetText(pack_id,A_EventInfo,1)
			LV_GetText(pack_name,A_EventInfo,2)
			;LV_GetText(pack_ver,A_EventInfo,3)
			LV_GetText(pack_auth,A_EventInfo,4)
			LV_GetText(pack_desc,A_EventInfo,6)
			SplitPath,pack_id,,,,pack_id
			pack_desc:=(StrLen(pack_desc))?pack_desc:"No description."
			MsgBox, 64, , Package Information`nID: `t%pack_id%`nName: `t%pack_name%`nAuthor: `t%pack_auth%`n`nDescription: `n%pack_desc%
			gosub, ListView_Events_checkedList ;quick Bugfix "doubleclick on checkbox"
			Gui -Disabled
		}
	}
return

ListView_Events_checkedList:
	if ((CheckedItems:=LV_GetCheckedCount())>0) {
		if (_selectedlist == "LV_A")
		{
			GuiControl,Enable,InstallButton
			GuiControl,,InstallButton,Install (%CheckedItems%)
		}
		else if (_selectedlist == "LV_I")
		{
			GuiControl,Enable,ReinstallButton
			GuiControl,,ReinstallButton,Reinstall (%CheckedItems%)
			
			GuiControl,Enable,RemoveButton
			GuiControl,,RemoveButton,Remove (%CheckedItems%)
		}
		else if (_selectedlist == "LV_U")
		{
			GuiControl,Enable,UpdateButton
			GuiControl,,UpdateButton,Update (%CheckedItems%)
		}
	} else {
		if (_selectedlist == "LV_A")
		{
			GuiControl,Disable,InstallButton
			GuiControl,,InstallButton,Install
		}
		else if (_selectedlist == "LV_I")
		{
			GuiControl,Disable,ReinstallButton
			GuiControl,,ReinstallButton,Reinstall
			
			GuiControl,Disable,RemoveButton
			GuiControl,,RemoveButton,Remove
		}
		else if (_selectedlist == "LV_U")
		{
			GuiControl,Disable,UpdateButton
			GuiControl,,UpdateButton,Update
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
			LV_GetText(ltmpE, A_Index,6)
			LV_GetText(ltmp_TAGS, A_Index,7)
			Query_Item_match:=0
			for each, Query_Item in QueryList
			{
				if InStr(ltmp_TAGS, Query_Item, 0)
				{
					Query_Item_match+=1
				}
				else if (Settings.ContentSensitiveSearch) {
					if InStr(ltmpA ltmpB ltmpC ltmpD ltmpE, Query_Item, 0)
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
	GuiControl,move,Tabs, % "w" (A_GuiWidth-16) " h" (A_GuiHeight-72)
	GuiControl,move,SearchBar, % "x" (A_GuiWidth-308)
	GuiSize_list:="AUI"
	Loop, Parse, GuiSize_list
	{
		GuiControl,move,LV_%A_LoopField%, % "w" (A_GuiWidth-32) " h" (A_GuiHeight-136)
		GuiControl,move,PackageCounter_%A_LoopField%, % "y" (A_GuiHeight-50) " x" (A_GuiWidth-118)
	}
	GuiControl,move,txt_version, % "y" (A_GuiHeight-50) " x" (A_GuiWidth-130)
	GuiSize_list:="Install|InstallFile|Refresh_A|Update|UpdateFile|Refresh_U|Reinstall|Remove|OpenSelected|SaveSettings|ResetSettings|ClientUpdate|CheckAll_A|CheckAll_U|CheckAll_I"
	Loop, Parse, GuiSize_list, |
		GuiControl,move,%A_LoopField%Button, % "y" (A_GuiHeight-56)
return

GuiClose:
ExitApp

CheckAll:
	CheckAll_v := "CheckAll_" SubStr(_selectedlist,0)
	if (%CheckAll_v%) {
		LV_Modify(0,"-Check")
		GuiControl,,%CheckAll_v%Button,Check all
	} else {
		LV_Modify(0,"+Check")
		GuiControl,,%CheckAll_v%Button,Uncheck all
	}
	%CheckAll_v% := !(%CheckAll_v%)
return

PackSource_Add: ;PackSource_AddButton
	Gui +Disabled
	Gui +OwnDialogs
	InputBox,__tmp,Add package repository,Add a package source to work with.,,300,128
	if __tmp is not Space
	{
		Progress, CWFEFEF0 CT111111 CB468847 w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11, Verification..., Package Source
		Progress, Show
		Progress, 50
		sleep 100
		__tmp_t:=API_SetSource(__tmp:=Trim(__tmp))
		Progress, 100
		sleep, 100
		Progress, Off
		if (__tmp_t) {
			GuiControl,,PackSource_List, % API_ParseSource(__tmp) ;auto-add
			MsgBox, 64, , The package source was added successfully.`nPlease save your settings now.
		} else
			MsgBox, 48, , The following package source is invalid:`n`n`t%__tmp%`n`nPlease verify the entry and try again.
	}
	Gui -Disabled
return

PackSource_Remove: ;PackSource_RemoveButton
	GuiControlGet,PackSource_ListSelected,,PackSource_List
	ControlGet, PackSource_PipeList, List,, ComboBox1, ahk_pid %SelfPID%
	__tmp:=""
	Loop,Parse,PackSource_PipeList,`n
	{
		if A_LoopField != %PackSource_ListSelected%
			__tmp .= "|" A_LoopField
	}
	GuiControl,,PackSource_List,%__tmp% ;auto-add
	GuiControl, Choose, PackSource_list, 1
return

stdlib_folderBrowse: ;stdlib_folderBrowseButton
	Gui +Disabled
	Gui +OwnDialogs
	FileSelectFolder, __tmp, *C:\, 3, Select the StdLib Installation folder
	if __tmp is not Space
		GuiControl,,stdlib_folder,%__tmp%
	Gui -Disabled
return

SaveSettings:
	MsgBox, 36, , Are you sure you want to save these settings?
	IfMsgBox,Yes
	{
		_list_SaveSettings:="Hide_Installed|Show_AllPackSources|Only_Show_StdLib|Check_ClientUpdates|ContentSensitiveSearch|stdlib_folder"
		Loop, Parse, _list_SaveSettings, |
		{
			GuiControlGet, %A_LoopField%
			Settings[A_LoopField] := (%A_LoopField%)
		}
		
		GuiControlGet,PackSource_ListSelected,,PackSource_List
		Settings.package_source := PackSource_ListSelected
		ControlGet, PackSource_PipeList, List,, ComboBox1, ahk_pid %SelfPID%
		Settings.package_sources := StrSplit(PackSource_PipeList,"`n")
		
		gosub,_SaveSettings
	}
return

ResetSettings:
	MsgBox, 308, , Are you sure you want to reset to default settings?`nInstallation paths will be affected.
	IfMsgBox,Yes
	{
		_settings_installed_tmp:=Settings.Installed
		Settings:=Settings_Default()
		Settings.Installed:=_settings_installed_tmp
		gosub,_SaveSettings
	}
return

_SaveSettings:
	if (Settings_Save(Settings)!=0) ;failure
	{
		MsgBox, 18, , Error: Could not save settings.`n(ErrorLevel = -4)
		IfMsgBox,Retry
			goto,SaveSettings
	} else {
		MsgBox, 36, , Settings were successfully saved.`nReload the program?
		IfMsgBox,Yes
			Reload
	}
return

Install:
	MsgBox, 36, , Are you sure you want to install the selected packages?
	IfMsgBox,No
		return
	Gui +Disabled
	Gui +OwnDialogs
	;Installation process
	
	;check for "required" aka dependencies
	Install_packs_dependencies:=Object()
	Install_packs_dependencies_src:=Object()
	
	;example - Install_packs:="~built_packs~\winfade.ahkp"
	Install_packs := ""
	r_check:=0
	Loop
	{
		r_check := LV_GetNext(r_check,"Checked")
		if (!r_check)
		break
		LV_GetText(r_item,r_check,1)
		LV_GetText(r_item_src,r_check,5)
		API_SetSource(r_item_src)
		r_path:=API_Get(r_item) ;download the package
		Install_packs_dependencies_src.Insert(Package_Source)
		Util_ArrayInsert(Install_packs_dependencies,API_GetDependencies(r_item))
		Install_packs.= r_path "|"
	}
	Install_packs:=SubStr(Install_packs,1,-1)
	
	if (Install_packs_dependencies.MaxIndex() > 0)
	{
		Install_packs_reqList:=Util_SingleArray2Str(Install_packs_dependencies,"`n`t",1)
		MsgBox, 51, , It seems that the selected packages have some dependencies :`n%Install_packs_reqList%`n`nSome packages may not work correctly if they are not installed.`nWould you like to install the missing packages?`nYou may click 'Cancel' to cancel the whole installation process.
		IfMsgBox,Cancel
		{
			;Installation canceled, Clean temporary files
			Loop,Parse,Install_packs,|
				FileDelete,%A_loopField%
			Gui -Disabled
			return
		}
		IfMsgBox,Yes
		{
			Install_packs.= "|"
			for _each, r_item in Install_packs_dependencies
			{
				SplitPath,r_item,,,,r_item_noExt
				if (!array_has_value(Settings.Installed,r_item_noExt)) {
					API_SetSource(Install_packs_dependencies_src[_each])
					r_path:=API_Get(r_item)
					if (Package_Validate(r_path))
						Install_packs.= r_path "|"
					else
						MsgBox, 48, , The following package could not be retrieved:`n`n`t%r_item%
				}
			}
			Install_packs:=SubStr(Install_packs,1,-1)
		}
	}
	
	_Install:
	;Note WinXP Command-line 8191 chars limitation
	;  http://support.microsoft.com/kb/830473
	;Assuming approximately 50 each file path, should be around 114 packages with "|" delimiters
	
	;Changing Install folder will added in the future
	if (isAdminRunAs_Needed(Settings.StdLib_Folder)) {
		ecode:=Admin_run("Package_Installer.ahk",Install_packs)
		if (ecode=="NOT_ADMIN") {
			Gui -Disabled
			return
		}
	} else {
		Runwait "Package_Installer.ahk" "%Install_packs%",,UseErrorLevel
		ecode := ErrorLevel
	}
	
	;Update "Installed" list - full-blown list update
	Settings:=Settings_Get()
	gosub,List_Installed
	gosub,List_Available
	Gui, ListView, LV_A
	
	if ( (ecode)==Install.Success )
	{
		MsgBox, 64, , Installation finished successfully.
	}
	else
		MsgBox, 16, , % "An installation error occured.`n(ExitCode: " ecode " [""" Install_ExitCode(ecode) """])"
	
	gosub,ListView_Events_checkedList
	
	Gui -Disabled
return

InstallFile:
	Gui +Disabled
	Gui +OwnDialogs
	FileSelectFile, _SelectedPack, 3, , Install a package, AHKP file (*.ahkp)
	if _SelectedPack is not space
	{
		Install_packs:=_SelectedPack
		gosub,_Install
	}
	Gui -Disabled
return

Refresh:
	Gui +Disabled
	Gui +OwnDialogs
	CheckedItems:=0
	Settings:=Settings_Get()
	Start_select_pack:=""
	_tmp:="UIA"
	Loop,Parse,_tmp
	{
		CheckAll_%A_loopfield%:=0
		GuiControl,Enable,CheckAll_%A_loopfield%Button
		GuiControl,,CheckAll_%A_loopfield%Button,Check all
		Gui, ListView, LV_%A_Loopfield%
		LV_Delete()
	}
	gosub,ListView_Events_checkedList
	gosub,start
	gosub,TabSwitch
	Gui -Disabled
return

Update:
	gosub,Install
	Gui, ListView, LV_U
return

UpdateFile:
	gosub,InstallFile
	Gui, ListView, LV_U
return

Reinstall:
	gosub,Install
	Gui, ListView, LV_I
return

Remove:
	MsgBox, 52, , Are you sure you want to remove the selected packages?
	IfMsgBox,No
		return
	Gui +Disabled
	Gui +OwnDialogs
	Remove_packs := ""
	r_check:=0
	Loop
	{
		r_check := LV_GetNext(r_check,"Checked")
		if (!r_check)
		break
		LV_GetText(r_item,r_check,1)
		Remove_packs.= r_item "|"
	}
	Remove_packs:=SubStr(Remove_packs,1,-1)
	
	_Remove:
	;Note WinXP Command-line 8191 chars limitation
	;  http://support.microsoft.com/kb/830473
	;Assuming approximately 50 each file path, should be around 114 packages with "|" delimiters
	
	;Changing Install folder will added in the future
	if (isAdminRunAs_Needed(Settings.StdLib_Folder)) {
		ecode:=Admin_run("Package_Remover.ahk",Remove_packs)
		if (ecode=="NOT_ADMIN") {
			Gui -Disabled
			return
		}
	} else {
		Runwait "Package_Remover.ahk" "%Remove_packs%",,UseErrorLevel
		ecode := ErrorLevel
	}
	
	;full-blown list update
	Settings:=Settings_Get()
	gosub,List_Installed
	gosub,List_Available
	Gui, ListView, LV_I
	
	if ( (ecode)==Install.Success ) {
		MsgBox, 64, , Removal finished successfully.
	}
	else
		MsgBox, 16, , % "An uninstallation error occured.`n(ExitCode: " ecode " [""" Install_ExitCode(ecode) """])"
	
	gosub,ListView_Events_checkedList
	
	Gui -Disabled
return

OpenSelected:
	if (__tmp:=LV_GetNext()) {
		__tmp_a:=Settings.Local_Repo
		LV_GetText(__tmp_id, __tmp)
		__tmp_id:=RegExReplace(__tmp_id,"\.ahkp")
		run explorer.exe "%__tmp_a%\%__tmp_id%"
	}
	else
		MsgBox, 48, , No package is currently selected.`nPlease select/highlight a package in the list.
return

ClientUpdate:
	CheckUpdate(AppVersion)
return

array_has_value(arr,value) {
	for each, item in arr
		if (item=value)
			return 1
	return 0
}

load_progress(t,c,f) {
	p:=Round((c/f)*100)
	Progress, %p% , Loading:  %c% / %f% items  [ %p%`% ] , %t%
}

LV_GetCheckedCount() {
	Loop
		if (!(checked := LV_GetNext(checked,"Checked")))
			return (A_Index-1)
}

Admin_run(program, argument) {
	;AutoHotkey Supported OS Versions: WIN_7, WIN_8, WIN_8.1, WIN_VISTA, WIN_2003, WIN_XP, WIN_2000
	if A_OSVersion in WIN_2003,WIN_XP,WIN_2000
	{
		if (A_IsAdmin)
			Runwait "%program%" "%argument%",,UseErrorLevel
		else {
			MsgBox, 48, , Sorry`, an error has occured.`n`nYou need administrator rights.`nPlease contact your administrator for help.
			Gui -Disabled
			return "NOT_ADMIN"
		}
	}
	else
		Runwait *RunAs "%program%" "%argument%",,UseErrorLevel
	return ErrorLevel
}

isAdminRunAs_Needed(dir) {
	if A_IsAdmin
		return false
	else {
		tmpfn := Util_TempFile(dir)
		FileAppend,__ASPDM_ADMIN_TEST__,%tmpfn%
		if !(e:=ErrorLevel)
			FileDelete,%tmpfn%
		return e
	}
}

