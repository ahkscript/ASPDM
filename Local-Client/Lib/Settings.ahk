;Settings Saved in AppData or A_scriptDir ("portable mode")

Settings_File(portable_mode:=0,sf:="settings.json") {
	if (portable_mode)
		f:=A_scriptDir "/" sf
	else
	{
		if !FileExist(d:=(A_AppData "/aspdm"))
			FileCreateDir, % d
		f:=d "/" sf
	}
	return f
}

Settings_Get() {
	f:=Settings_File()
	if !FileExist(f) {
		;Save default settings
		j:={stdlib_folder: 	RegExReplace(A_AhkPath,"\w+\.exe","lib")
			,hide_installed: 	true
			,only_show_stdlib: 	false
			,installed: 		{}}
		Settings_Save(j)
	}	
	FileRead,s, % f
	return JSON_ToObj(s)
}

Settings_Save(j) {
	s:=JSON_FromObj(j)
	f:=Settings_File()
	FileDelete, % f
	FileAppend, % s, % f
	return ErrorLevel
}

