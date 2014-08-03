#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;<<<<<<<<  HEADER END  >>>>>>>>>

baseDir:="Test_Packages\sample_tool"

tree := Util_DirTree(baseDir)

Original_tree := JSON_Beautify(Obj_StripKey(tree,"fullPath"),3)

if FileExist(ignorefile:=baseDir "\.aspdm_ignore") {
	ignore_patterns:=Ignore_GetPatterns(ignorefile)
	patterns:=Util_SingleArray2Str(ignore_patterns,"`n")
	tree := Ignore_DirTree(tree,ignore_patterns)
}

New_tree := JSON_Beautify(Obj_StripKey(tree,"fullPath"),3)

Gui, Font, s8, Courier New
Gui, Add, Edit, x3 w400 h300, % Original_tree
Gui, Add, Edit, x+4 yp wp hp, % New_tree
Gui, Add, Edit, x3 y+4 w804 h150, % patterns
Gui, Show
return

GuiClose:
ExitApp

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