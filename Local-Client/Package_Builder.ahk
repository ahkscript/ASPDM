#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Settings:=Settings_Get()

package_dir := 0

all_vars:="id|version|name|ahkbranch|ahkflavour|description|author|license|required|forumurl|screenshot|type|tags"

Attributes:={id:			"A short name used for identification purposes (Should be a valid AutoHotkey identifier)"
			,version:		"Package version (must follow AHK-flavored Semantic Versioning)"
			,type:			"Package type (lib, tool, other)"
			,ahkbranch:		"AutoHotkey branch the package is developed for (v1.1, v2-alpha, ahk_h, ...)"
			,ahkflavour:	"Comma-separated list of supported AutoHotkey flavours (a32, u32, u64)"
			,name:			"The human-friendly name of the package"
			,description:	"Description of the package"
			,author:		"The author(s) of the package"
			,license:		"Name of the license under which the package is released (Optional)"
			,required:		"Comma-separated list of dependencies' package identifiers (leave empty if none)"
			,tags:			"Comma-separated tags (Optional, Recommended)"
			,forumurl:		"ahkscript.org forum topic URL (Optional, Recommended)"
			,screenshot:	"Filename of the screenshot to be displayed (Optional)"}

; "Standard" ASPDM Header
Gui, Font, s16 wBold, Arial
Gui, Add, Picture, x12 y8 w32 h-1, res\ahk.png
Gui, Add, Text, x+4 yp+4 , ASPDM
Gui, Font
Gui, Add, Text, yp+5 x+12, AHKScript.org's Package/StdLib Distribution and Management
;Gui, Add, Picture, x12 y+16 w418 h1, res\greenpixel.bmp

GuiLeft:=12
GuiTab:=6
GuiDispBlock:="x" GuiLeft
GuiDispInline:="yp x+" GuiTab
Gui, +HWNDhGUI

LV_packs:=Object()
LV_packs_list:=Object()

Gui, Add, Edit, vid x12 gInfoActive,
Gui, Add, Edit, vversion x+4 yp gInfoActive Limit10,

Gui, Add, GroupBox, x+4 yp-8 w180 h108, Required (Dependencies)
Gui, Add, ListView, vrequired xp+8 yp+18 w164 h82 Checked Grid -Hdr, Packages
LV_ModifyCol(1,"140")
for _each, item in Settings.Installed
{
	_lv_man:=JSON_ToObj(Manifest_FromPackage(Settings.local_archive "\" item ".ahkp"))
	LV_packs[item]:=_lv_man
	LV_packs_list[A_Index]:=_lv_man.id
	LV_Add("",_lv_man.name)
}

Gui, Add, Edit, vname x12 yp+16 gInfoActive,
Gui, Add, Edit, vauthor x+4 yp gInfoActive,
Gui, Add, Edit, vlicense x12 y+4 gInfoActive,
Gui, Add, Edit, vforumurl x+4 yp gInfoActive,
Gui, Add, Edit, vscreenshot x12 y+4 w244 gInfoActive,

Gui, Add, GroupBox, x12 y+6 w136 h48, Package Type
Gui, Add, DropDownList, vtype xp+8 yp+18 w120 Choose1, Library|Tool|Other
Gui, Add, GroupBox, x+14 yp-18 w246 h48, ahkflavour
Gui, Add, Checkbox, vahkflavour_a32 xp+8 yp+21 Checked, ANSI
Gui, Add, Checkbox, vahkflavour_u32 x+4 yp Checked, Unicode 32-bit
Gui, Add, Checkbox, vahkflavour_u64 x+4 yp Checked, Unicode 64-bit
Gui, Add, GroupBox, x12 y+16 w136 h48, ahkbranch
Gui, Add, ComboBox, vahkbranch xp+8 yp+18 w120 Choose1, v1.1|v2-alpha|ahk_h
Gui, Add, GroupBox, x+14 yp-18 w246 h48, Tags
Gui, Add, Edit, vtags xp+8 yp+18 gInfoActive w230,

Gui, Add, Text, x12 y+16, Description
Gui, Add, Edit, vdescription x12 y+4 gInfoActive +Multi w410 h86,
Gui, Add, Button, x12 Default gOpen, Open JSON
Gui, Add, Button, x+4 yp gSave, Save JSON
Gui, Add, Button, x+4 yp gBuild, Build Package

;Add placeholders - supported since Windows XP
	SetEditPlaceholder("id","id")
	SetEditPlaceholder("version","version")
	SetEditPlaceholder("name","name")
	SetEditPlaceholder("author","author")
	SetEditPlaceholder("license","license")
	SetEditPlaceholder("tags",Attributes.tags)
	SetEditPlaceholder("forumurl","forumurl")
	SetEditPlaceholder("screenshot","screenshot")
	;SetEditPlaceholder("description","Description of the package...")

Gui, Add, StatusBar,,
SB_SetParts(320)
SB_SetText("No JSON file opened.")
SB_SetText("(Idle)",2)

Gui, Show,, ASPDM - Package Creation
GroupAdd, MainGUIWindows, ahk_id %hGUI%
ControlFocus, Button1, ahk_id %hGUI%
return

GuiClose:
ExitApp

InfoActive:
	GuiControlGet, FocusedControl, FocusV
	EditShowBalloonTip(FocusedControl,FocusedControl,Attributes[FocusedControl])
return

#IfWinActive ahk_group MainGUIWindows
~Tab::
	ToolTip
return
#IfWinActive

EditShowBalloonTip(h, title, text, timeout := 2000)
{
    if control is not number
        GuiControlGet, h, HWND, %h%
    ControlGetPos,x,y,,t,,ahk_id %h%
    ToolTip, %title%`n%text%, %x%, % (y+t)
    SetTimer, RemoveToolTip, %timeout%
    return

    RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
    return
}

Open:
	Gui +OwnDialogs
	FileSelectFile, _SelectedFile, 3, , Open a package JSON file, JSON file (*.json)
	if _SelectedFile =
		MsgBox, 64, , No package JSON file selected.
	else
	{
		FileRead,json_s,%_SelectedFile%
		oJSON:=Manifest_FromStr(json_s)
		Loop, Parse, all_vars, |
		{
			if (A_LoopField = "type")
				GuiControl,ChooseString,%A_LoopField%, % oJSON[A_LoopField]
			else if ( (A_LoopField = "tags") || (A_LoopField = "required") || (A_LoopField = "ahkflavour") )
				if (A_LoopField = "required")
				{
					LV_Delete()
					for _each, item in Settings.Installed
						if array_has_value(oJSON["required"],item)
							LV_Add("Check",LV_packs[item].name)
						else
							LV_Add("",LV_packs[item].name)
				}
				else if (A_LoopField = "ahkflavour")
				{
					for _each, item in ["a32","u32","u64"]
						GuiControl,,ahkflavour_%item%,0
					for _each, item in oJSON["ahkflavour"]
						GuiControl,,ahkflavour_%item%,1
				}
				else
					GuiControl,,%A_LoopField%, % Util_TagsObj2CSV(oJSON[A_LoopField])
			else
				GuiControl,,%A_LoopField%, % oJSON[A_LoopField]
		}
		SplitPath,_SelectedFile,,package_dir
		SelectedFile:=_SelectedFile
		SB_SetText("JSON: " . Util_ShortPath(SelectedFile))
		SB_SetText("File opened.",2)
	}
return

Save:
	Gui +OwnDialogs
	FileSelectFile, _SelectedFile, S18, package.json, Save package JSON file, JSON file (*.json)
	if _SelectedFile =
		MsgBox, 64, , Package JSON file was not saved.
	else
	{
		Gui, Submit, NoHide
		
		ahkflavour:=Object()
		for _each, item in ["a32","u32","u64"]
		{
			GuiControlGet,_checked,,ahkflavour_%item%
			if (_checked)
				ahkflavour.Insert(item)
		}
		
		required:=Object(), r_check:=0
		Loop
		{
			r_check := LV_GetNext(r_check,"Checked")
			if (!r_check)
			break
			required.Insert(LV_packs_list[r_check])
		}
		
		;this part is redundant...
		;suggest Manifest_FromObj()
		mdata:=JSON_FromObj(Manifest_FromStr(JSON_FromObj({id: RegExReplace(id,"\W")
			,version: 		version
			,name: 			name
			,ahkbranch: 	ahkbranch
			,ahkversion:	A_AhkVersion
			,ahkflavour: 	ahkflavour
			,description: 	description
			,author: 		author
			,license: 		license
			,required: 		Util_ArraySort(required)
			,tags: 			Util_CSV2TagsObj(tags)
			,forumurl: 		forumurl
			,screenshot: 	screenshot
			,type: 			type
			,isstdlib:		false})))
		
		mdata:=JSON_Beautify(mdata)
		
		try
		{
			;Overwrite "safely"
			if FileExist(_SelectedFile)
			{
				safety_bkp:=1
				FileGetSize,safety_bkp_sz,%_SelectedFile%
				tmpfile:=Util_TempFile()
				FileMove,%_SelectedFile%,%tmpfile%
			}
			
			FileAppend,%mdata%,%_SelectedFile%
			FileGetSize,sz,%_SelectedFile%
			if (!sz)
				throw "Could not write/parse JSON!"
			else
			{
				if (safety_bkp) {
					;copy was successful, delete backup
					FileDelete,%tmpfile%
				}
			}
		}
		catch e
		{
			if (safety_bkp)
			{
				FileMove,%tmpfile%,%_SelectedFile%,1
				FileGetSize,sz,%_SelectedFile%
				if (sz != safety_bkp_sz)
					MsgBox, 16, , All data was lost.`nErrorlevel: %Errorlevel%
			}
			throw e
		}
		SplitPath,_SelectedFile,,package_dir
		SelectedFile:=_SelectedFile
		SB_SetText("JSON: " . Util_ShortPath(SelectedFile))
		SB_SetText("File saved.",2)
	}
return

Build:
	Gui +OwnDialogs
	if (!package_dir)
		MsgBox, 48, , No package JSON file has been selected.`n(No JSON file was opened or saved.)`n`nPlease try again.
	else if !FileExist(SelectedFile) || !FileExist(package_dir)
		MsgBox, 64, , Please save the current JSON file to your package folder first.`n`nPlease try again.
	else
	{
		jdata:=Manifest_FromFile(SelectedFile)
		_package_out_name := RegExReplace(jdata.id,"\W")
		FileSelectFile, outP, S18, %_package_out_name%.ahkp, Save the built package file, AHKP file (*.ahkp)
		if outP =
			MsgBox, 64, , Package build canceled.
		else
		{
			Gui +Disabled
				SplitPath,outP,outP_file,outP_dir
				SB_SetText("JSON: " . Util_ShortPath(SelectedFile))
				SB_SetText("Building package...",2)
				if (Build_check:=Package_Build(outP, package_dir, SelectedFile))
					SB_SetText("Done.",2)
				else
					SB_SetText("Done. (error occurred)",2)
			Gui -Disabled
			if (Build_check) {
				MsgBox, 68, , Package built.`nOpen containing folder?
				IfMsgBox, Yes
					Run, Explorer.exe "%outP_dir%"
			} else {
				MsgBox, 48, , An error occurred.`nThe built package seems to be invalid.`nPlease try again.
			}
		}
	}
return

array_has_value(arr,value) {
	for each, item in arr
		if (item=value)
			return 1
	return 0
}
