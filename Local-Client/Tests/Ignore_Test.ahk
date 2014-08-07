#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;<<<<<<<<  HEADER END  >>>>>>>>>

baseDir:="Test_Packages\sample_tool"
if FileExist(ignorefile:=baseDir "\.aspdm_ignore")
	ignore_patterns:=Ignore_GetPatterns(ignorefile)
Original_tree := JSON_Beautify(Obj_StripKey(Util_DirTree(baseDir),"fullPath"),3)
New_tree      := JSON_Beautify(Obj_StripKey(Ignore_DirTree(baseDir,ignore_patterns),"fullPath"),3)
patterns      := Util_SingleArray2Str(ignore_patterns,"`n") "`n-----------`nNegate patterns`n-----------`n" Util_SingleArray2Str(ignore_patterns.negate,"`n")
Num_patterns  := ignore_patterns.MaxIndex() + (ignore_patterns.negate.MaxIndex()+0)
Num_matches   := StrCount("""name"":",Original_tree) - StrCount("""name"":",New_tree)

Gui, Font, s8, Courier New
Gui, Add, Edit, x3 w400 h300, % Original_tree
Gui, Add, Edit, x+4 yp wp hp, % New_tree
Gui, Add, Edit, x3 y+4 w804 h150, % patterns
Gui, Add, StatusBar,, Number of patterns : %num_patterns%  |  Number of matches : %Num_matches%
Gui, Show
return

GuiClose:
ExitApp

StrCount(Needle,Haystack) {
	StringReplace,Haystack,Haystack,%Needle%,,UseErrorLevel
	return ErrorLevel
}

Obj_StripKey(Obj,keyname) {
	Obj := Obj.Clone()
	for key, val in Obj
	{
		if key = %keyname%
		{
			Obj.Remove(keyname)
			continue
		}
		if IsObject(val)
			Obj[key]:=Obj_StripKey(val,keyname)
	}
	return Obj
}