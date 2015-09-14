#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#Include Lib\LV_InCellEdit.ahk
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;<<<<<<<<  HEADER END  >>>>>>>>>

	all_vars:=["id","version","name","ahkbranch","ahkflavour","description","author","license","required","forumurl","screenshot","type","tags"]

	Gui, Add, ListView, w430 h270 vLVMetaData +Grid -Readonly hwndHLV1 AltSubmit, Attribute|Value
	Gui, Add, TreeView, wp h135 vTVFiles
	Gui, Add, Button, w80 gOpen, Open
	Gui, Add, Button, yp x+4 w80 gSave +Disabled, Save As...
	Gui, Add, Button, yp x+4 w150 gOpenPKG +Disabled vopkgBtn, Open in Package Builder
	Gui, Add, Button, yp x+4 w80 gotmpdir +Disabled vtmpdirBtn, Inspect files...
	Gui, Show

	LV_ModifyCol(1,"80")
	LV_ModifyCol(2,"340")
	gosub,PrepLV
	gosub,PrepTV
return

GuiClose:
FileRemoveDir, %A_temp%\ASPDM_tmp, 1
ExitApp

PrepTV:
	TV_Delete()
	TV_baseDirID := TV_Add("Package Base Dir")
return

PrepLV:
	LV_Delete()
	for each, item in all_vars
		LV_Add("",item)
	ICELV1 := New LV_InCellEdit(HLV1)
	ICELV1.SetColumns(2)
return

Open:
	Gui +OwnDialogs
	FileSelectFile, thePack, 3, , Open AHKP Package, AHKP Package (*.ahkp)
	if !ErrorLevel
	{
		; Package Metadata
		mdata:=Manifest_FromStr(Manifest_FromPackage(thePack))
		LV_Delete()
		for each, item in mdata
		{
			if (IsObject(item))
				LV_Add("",each,Util_TagsObj2CSV(item))
			else
				LV_Add("",each,item)
		}
		
		; Package tree
		tmpDir:=Util_TempDir(A_Temp "\ASPDM_tmp")
		eTree:=Package_Extract(tmpDir,thePack,1)
		gosub,PrepTV
		GuiControl, -Redraw, TVFiles
		eObj2TV(eTree,TV_baseDirID)
		GuiControl, +Redraw, TVFiles
		GuiControl, -Disabled, tmpdirBtn
		
		; Save a copy of the extracted manifest in the extraction folder
		outman:=JSON_Beautify(mdata)
		FileAppend, %outman%, %tmpDir%\package.json
		
		GuiControl, -Disabled, opkgBtn
	}
return

OpenPKG:
MsgBox, Once you close %A_ScriptName%, all the package files that were extracted to a temporary folder will be deleted.
Run, Package_Builder.ahk "%tmpDir%\package.json"
return

eObj2TV(obj,parentID) {
	for key, val in obj
	{
		if IsObject(val) {
			kName:=SubStr(key,2)
			SplitPath,kName,kName
			SubID:=TV_Add(kName,parentID)
			eObj2TV(val,SubID)
		} else {
			SplitPath,val,kName
			TV_Add(kName,parentID)
		}
	}
}

Save:
return

otmpdir:
Run, explorer.exe %tmpDir%
return
