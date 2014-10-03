;Package_Moderator.ahk

	all_vars:=["id","version","name","ahkbranch","ahkflavour","description","author","license","required","forumurl","screenshot","type","tags"]

	Gui, Add, ListView, w430 h270 vLVMetaData +Grid, Attribute|Value
	Gui, Add, TreeView, wp h135 vTVFiles
	Gui, Add, Button, w80 gOpen, Open
	Gui, Add, Button, yp x+4 wp gSave, Save As...
	Gui, Show

	LV_ModifyCol(1,"80")
	LV_ModifyCol(2,"300")
	for each, item in all_vars
		LV_Add("",item)
	TV_Add("Package Base Dir")
return

GuiClose:
ExitApp

Open:
Save:
return