;Settings Saved in AppData or A_scriptDir ("portable mode")

Settings_File(portable_mode:=0,sf:="settings.json") {
	if (portable_mode)
		f:=A_scriptDir "\" sf
	else
	{
		if !FileExist(d:=(A_AppData "\aspdm"))
			FileCreateDir, % d
		f:=d "\" sf
	}
	return f
}

Settings_Get() {
	f:=Settings_File()
	if !FileExist(f) {
		;Save default settings
		Settings_Save(Settings_Default())
	}
	FileRead,s, % f
	return Settings_Validate(JSON_ToObj(s))
}

Settings_Validate(j) {
	j_default:=Settings_Default()
	vars:="stdlib_folder|local_repo|local_archive|hide_installed|only_show_stdlib|installed"
	loop,Parse,vars,`|
		if (!j.Haskey(A_LoopField))
			j[A_LoopField]:=j_default[A_LoopField]
	return j
}

Settings_Default(key="") {
	j:={stdlib_folder: 	RegExReplace(A_AhkPath,"\w+\.exe","lib")
		,local_repo: 		A_AppData "\aspdm\repo"
		,local_archive:		A_AppData "\aspdm\archive"
		,hide_installed: 	true
		,only_show_stdlib: 	false
		,installed: 		{}}
	if (k=="")
		return j
	return j[key]
}

Settings_Save(j) {
	s:=JSON_FromObj(j)
	f:=Settings_File()
	FileDelete, % f
	FileAppend, % s, % f
	return ErrorLevel
}

