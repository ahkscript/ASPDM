;Test Package Validation

Gui, Add, Button, x0 y0 w50 h20 gBrowse, Browse
Gui, Add, Edit, x+0 yp w170 hp +ReadOnly vPath,
Gui, Add, Button, x0 y+0 w220 hp gValidate, Validate
Gui, Show, w220 h40, Package Validation
return

GuiClose:
	ExitApp

Browse:
	FileSelectFile, SelectedFile, 3, , Open a Package file, AHKP file (*.ahkp)
	if StrLen(SelectedFile)
		GuiControl,,Path, % Util_ShortPath(Path:=SelectedFile,32)
return

Validate:
	if Package_Validate(Path)
	{
		SplitPath,Path,,,x
		if x = AHKP
			MsgBox, 64, , The package seems to be valid.
		else
			MsgBox, 48, , The package seems to be valid.`nNotice: The extension "%x%" should be "AHKP"
	}
	else
	{
		MsgBox, 16, , The package is invalid!
	}
return