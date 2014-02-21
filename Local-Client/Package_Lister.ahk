;placeholder script
;SHould maybe, be made as fork, mod pAHKLight?
#Include Lib\LV_Colors.ahk

data =
(join`n
Package A00001	Bob	2013-12-08 21:18	176 Kb
Package B00002	Jack	2013-12-08 21:18	224 Kb
Package C00003	George	2013-12-08 21:20	172 Kb
Package D00004	Sarah	2013-12-08 21:20	216 Kb
Package E00005	John	2013-10-11 17:46	176 Kb
Package F00006	Lisa	2013-10-11 17:45	224 Kb
Package G00007	Charles	2013-10-11 17:44	172 Kb
Package H00008	Jacob	2013-10-11 17:44	172 Kb
Package I00009	Alexandra	2013-10-11 17:44	172 Kb
Package J00010	Andy	2013-10-11 17:44	216 Kb
Package K00011	Lisa	2013-10-11 17:45	224 Kb
Package L00012	Andy	2013-10-11 17:44	216 Kb
Package M00013	Charles	2013-10-11 17:44	172 Kb
Package N00014	George	2013-12-08 21:20	172 Kb
Package O00015	Jack	2013-12-08 21:18	224 Kb
)

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
	Gui, Add, ListView, x16 y+8 w440 h200 Checked AltSubmit Grid gListView_Events vLV_A hwndhLV_A, Name|Maintainer|Last modified|Size
	Gui, Add, Button, y+4 w80 vInstallButton Disabled, Install
	Gui, Add, Button, yp x+2 vInstallFileButton, Install from file...
	Gui, Add, Text, yp+6 x+172 vPackageCounter_A +Right, Loading packages...
Gui, Tab, Updates
	Gui, Add, ListView, x16 y+8 w440 h200 Checked AltSubmit Grid vLV_U hwndhLV_U, Updates
	Gui, Add, Button, y+4 w80 Disabled vUpdateButton, Update
	Gui, Add, Button, yp x+2 vUpdateFileButton, Update from file...
	Gui, Add, Text, yp+6 x+172 +Right vPackageCounter_U, Loading packages...
Gui, Tab, Installed
	Gui, Add, ListView, x16 y+8 w440 h200 Checked AltSubmit Grid vLV_I hwndhLV_I, Installed
	Gui, Add, Button, y+4 w80 Disabled vRemoveButton, Remove
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

Gui, ListView, LV_A
_selectedlist:="LV_A"
_selectedlistH:=hLV_A
LV_ModifyCol(1,"144")
LV_ModifyCol(2,"100")
LV_ModifyCol(3,"100")
LV_ModifyCol(4,"Right 64")
Loop, Parse, data, `n
{
	a:=StrSplit(A_LoopField,A_Tab)
	LV_Add("",a[1],a[2],a[3],a[4],a[5])
	TotalItems:=LV_GetCount()
	GuiControl,,PackageCounter_A, %TotalItems% Packages
}
LV_Colors.OnMessage()
LV_Colors.Attach(hLV_A,1,0)
LV_Colors.Attach(hLV_U,1,0)
LV_Colors.Attach(hLV_I,1,0)
return

ListView_Events:
if A_GuiEvent = I
{
	if InStr(ErrorLevel, "C", true)
		CheckedItems+=1
	if InStr(ErrorLevel, "c", true)
		CheckedItems-=1
	if (CheckedItems) {
		GuiControl,Enable,InstallButton
		GuiControl,,InstallButton,Install (%CheckedItems%)
	} else {
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
			Query_Item_match:=0
			for each, Query_Item in QueryList
			{
				if InStr(ltmpA ltmpB, Query_Item, 0)
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