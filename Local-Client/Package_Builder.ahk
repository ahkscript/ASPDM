#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

package_dir := 0

all_vars =
(RTrim Join
id|version|name|ahkbranch|ahkversion|ahkflavour|description|
author|license|required|forumurl|screenshot|type|tags
)

Attributes:={id:			"A short name used for identification purposes (Should be a valid AutoHotkey identifier)"
			,version:		"Package version (must follow AHK-flavored Semantic Versioning)"
			,type:			"Package type (lib, tool, other)"
			,ahkbranch:		"AutoHotkey branch the package is developed for (v1.1, v2-alpha, ahk_h, ...)"
			,ahkversion:	"Version number of AutoHotkey the package was developed with"
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
Gui, Add, Edit, vid %GuiDispBlock% gInfoActive,
Gui, Add, Edit, vversion %GuiDispInline% gInfoActive Limit10,
Gui, Add, Edit, vname %GuiDispInline% gInfoActive,
Gui, Add, Edit, vahkbranch %GuiDispBlock% gInfoActive,
Gui, Add, Edit, vahkversion %GuiDispInline% gInfoActive Limit10,
Gui, Add, Edit, vahkflavour %GuiDispInline% gInfoActive,
Gui, Add, Edit, vauthor %GuiDispBlock% gInfoActive,
Gui, Add, Edit, vlicense %GuiDispInline% gInfoActive,
Gui, Add, Edit, vrequired %GuiDispInline% gInfoActive,
Gui, Add, Edit, vforumurl %GuiDispBlock% gInfoActive,
Gui, Add, Edit, vscreenshot %GuiDispInline% gInfoActive,
Gui, Add, Text, x+%GuiTab% yp+3, Type
Gui, Add, DropDownList, vtype x+4 yp-3 w92, Library|Tool|Other
Gui, Add, Edit, vtags %GuiDispBlock% gInfoActive w372,
Gui, Add, Text, %GuiDispBlock%, Description
Gui, Add, Edit, vdescription y+4 %GuiDispBlock% gInfoActive +Multi w410 h86,
Gui, Add, Button, %GuiDispBlock% Default gOpen, Open JSON
Gui, Add, Button, %GuiDispInline% gSave, Save JSON
Gui, Add, Button, %GuiDispInline% gBuild, Build Package

;Add placeholders - supported since Windows XP
	SetEditPlaceholder("id","id")
	SetEditPlaceholder("version","version")
	SetEditPlaceholder("type","type")
	SetEditPlaceholder("ahkbranch","ahkbranch")
	SetEditPlaceholder("ahkversion","ahkversion")
	SetEditPlaceholder("ahkflavour","ahkflavour")
	SetEditPlaceholder("name","name")
	SetEditPlaceholder("author","author")
	SetEditPlaceholder("license","license")
	SetEditPlaceholder("required","required")
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
		;this part is redundant...
		;suggest Manifest_FromObj()
		mdata:=JSON_FromObj(Manifest_FromStr(JSON_FromObj({id: RegExReplace(id,"\W")
			,version: 		version
			,name: 			name
			,ahkbranch: 	ahkbranch
			,ahkversion: 	ahkversion
			,ahkflavour: 	Util_CSV2TagsObj(ahkflavour)
			,description: 	description
			,author: 		author
			,license: 		license
			,required: 		Util_CSV2TagsObj(required)
			,tags: 			Util_CSV2TagsObj(tags)
			,forumurl: 		forumurl
			,screenshot: 	screenshot
			,type: 			type})))
			
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
				if (safety_bkp)
					;copy was successful, delete backup
					FileDelete,%tmpfile%
			}
		}
		catch e
		{
			if (safety_bkp)
			{
				FileMove,%tmpfile%,%_SelectedFile%,1
				FileGetSize,sz,%_SelectedFile%
				if (sz != safety_bkp_sz)
					MsgBox, 16, , All data was lost.`nErrorlevel: %nErrorlevel%
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
				Package_Build(outP, package_dir, SelectedFile)
				SB_SetText("Done.",2)
			Gui -Disabled
			MsgBox, 68, , Package built.`nOpen containing folder?
			IfMsgBox, Yes
				Run, Explorer.exe "%outP_dir%"
		}
	}
return
