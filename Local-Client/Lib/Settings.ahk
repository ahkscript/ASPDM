;Settings Saved in AppData or A_scriptDir ("portable mode")

Settings_File(portable_mode:=0,sf:="settings.json") {
	if (portable_mode)
	{
		f:=A_scriptDir "\" sf
		if !FileExist(d:=(A_scriptDir "\repo"))
			FileCreateDir, % d
		if !FileExist(d:=(A_scriptDir "\archive"))
			FileCreateDir, % d
	} else {
		if !FileExist(d:=(A_AppData "\aspdm"))
			FileCreateDir, % d
		f:=d "\" sf
	}
	return f
}

Settings_Get(portable_mode:=0) {
	f:=Settings_File(portable_mode)
	if !FileExist(f) {
		;Save default settings
		Settings_Save(Settings_Default(),portable_mode)
	}
	FileRead,s, % f
	return Settings_Validate(JSON_ToObj(s),portable_mode)
}

Settings_Validate(j,portable_mode:=0) {
	j_default:=Settings_Default("",portable_mode)
	vars:="stdlib_folder|local_repo|local_archive|hide_installed|only_show_stdlib|installed"
	loop,Parse,vars,`|
		if (!j.Haskey(A_LoopField))
			j[A_LoopField]:=j_default[A_LoopField]
	return j
}

Settings_Default(key="",portable_mode:=0) {
	j:={stdlib_folder: 	RegExReplace(A_AhkPath,"\w+\.exe","lib")
		,local_repo: 		((portable_mode)?(A_scriptDir):(A_AppData "\aspdm")) "\repo"
		,local_archive:		((portable_mode)?(A_scriptDir):(A_AppData "\aspdm")) "\archive"
		,hide_installed: 	true
		,only_show_stdlib: 	false
		,portable_mode:		(portable_mode)
		,installed: 		{}}
	if (k=="")
		return j
	return j[key]
}

Settings_Save(j,portable_mode:=0) {
	s:=JSON_FromObj(j)
	f:=Settings_File(portable_mode)
	FileDelete, % f
	if ErrorLevel
		return ErrorLevel
	FileAppend, % s, % f
	return ErrorLevel
}

