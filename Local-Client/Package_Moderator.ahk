#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;<<<<<<<<  HEADER END  >>>>>>>>>

	all_vars:=["id","version","name","ahkbranch","ahkflavour","description","author","license","required","forumurl","screenshot","type","tags"]

	Gui, Add, ListView, w430 h270 vLVMetaData +Grid, Attribute|Value
	Gui, Add, TreeView, wp h135 vTVFiles
	Gui, Add, Button, w80 gOpen, Open
	Gui, Add, Button, yp x+4 wp gSave, Save As...
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
return

Open:
	Gui +OwnDialogs
	FileSelectFile, thePack, 3, , Open AHKP Package, AHKP Package (*.ahkp)
	if !ErrorLevel
	{
		; Package Metadata
		mdata:=Manifest_FromStr(Manifest_FromPackage(thePack))
		LV_Delete()
		for each, item in all_vars
		{
			if (IsObject(mdata[item]))
				LV_Add("",item,Util_TagsObj2CSV(mdata[item]))
			else
				LV_Add("",item,mdata[item])
		}
		
		; Package tree
		tmpDir:=Util_TempDir(A_Temp "\ASPDM_tmp")
		eTree:=Package_Extract(tmpDir,thePack,1)
		gosub,PrepTV
		GuiControl, -Redraw, TVFiles
		eObj2TV(eTree,TV_baseDirID)
		GuiControl, +Redraw, TVFiles
	}
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