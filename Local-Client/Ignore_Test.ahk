#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;<<<<<<<<  HEADER END  >>>>>>>>>

baseDir:="Test_Packages\sample_tool"

if FileExist(ignorefile:=baseDir "\.aspdm_ignore")
	ignore_patterns:=Ignore_GetPatterns(ignorefile)

NUM_RUNS := 100

/*
Tested result WITH patterns:

	Ignore() Benchmark (100 runs)
	
	Number of patterns:	21
	
	Method (old):
		Tree Gen:	16.220181
		Ignores:	0.634856
		Total:	16.855037 secs

	Method (new):
		Tree Gen:	8.033097
		Total:	8.033097 secs

	Ratio:
		new/old:	47.66 %
		old/new:	209.82 %
		
Tested result WITHOUT patterns (empty '.aspdm_ignore' file):

	Ignore() Benchmark (100 runs)
	
	Number of patterns:	0
	
	Method (old):
		Tree Gen:	16.473013
		Ignores:	0.044311
		Total:	16.517324 secs

	Method (new):
		Tree Gen:	16.215377
		Total:	16.215377 secs

	Ratio:
		new/old:	98.17 %
		old/new:	101.86 %
*/

TIME_t:=0
TIME_A:=0
TIME_tA:=0
TIME_B:=0

Loop %NUM_RUNS%
{
	;Old method
	QPX(1)
		tree := Util_DirTree(baseDir)
	TIME_st:=QPX(0)
	QPX(1)
		treeA := IgnoreParse_DirTree(tree,ignore_patterns)
	TIME_sA:=QPX(0), TIME_stA:=TIME_st+TIME_sA
	
	;New method
	QPX(1)
		treeB := Ignore_DirTree(baseDir,ignore_patterns)
	TIME_sB:=QPX(0)
	
	TIME_t+=TIME_st
	TIME_A+=TIME_sA
	TIME_tA+=TIME_stA
	TIME_B+=TIME_sB
	
	ToolTip Done. (%A_index%/%NUM_RUNS%)
}
ToolTip

Num_patterns := Util_ObjCount(ignore_patterns)

Ratio_NO := Round((TIME_B/TIME_tA)*100,2)
Ratio_ON := Round((TIME_tA/TIME_B)*100,2)

MsgBox,64,Ignore() Benchmark (%NUM_RUNS% runs),
(
Number of patterns:`t%Num_patterns%

Method (old):
`tTree Gen:`t%TIME_t%
`tIgnores:`t%TIME_A%
`tTotal:`t%TIME_tA% secs

Method (new):
`tTree Gen:`t%TIME_B%
`tTotal:`t%TIME_B% secs

Ratio:
`tnew/old:`t%Ratio_NO% `%
`told/new:`t%Ratio_ON% `%
)

Original_tree := JSON_Beautify(Obj_StripKey(tree,"fullPath"),3)
New_tree := JSON_Beautify(Obj_StripKey(treeB,"fullPath"),3)
patterns:=Util_SingleArray2Str(ignore_patterns,"`n")

Gui, Font, s8, Courier New
Gui, Add, Edit, x3 w400 h300, % Original_tree
Gui, Add, Edit, x+4 yp wp hp, % New_tree
Gui, Add, Edit, x3 y+4 w804 h150, % patterns
Gui, Show
return

GuiClose:
ExitApp

/*
	Deprecated, use Ignore_DirTree() instead.
	IgnoreParse_DirTree() modifies already existent Dir-trees
*/
IgnoreParse_DirTree(tree,patterns) ;currently, inefficient due to indexing problem...
{
	if (!patterns.MaxIndex())
		return tree
	tree := tree.Clone() ; Indexing problem, therefore using a copy	
	for i, file in tree
	{
		for j, pat in patterns
		{
			if (SubStr(pat,-1)=="\\")
				if (file.isDir)
					StringTrimRight,pat,pat,2
				else
					continue
			;MsgBox % "FILE:`t" file.fullPath "`nPAT:`t" pat "`nMATCH:`t" RegExMatch(file.fullPath,"m)" pat "$")
			if RegExMatch(file.fullPath,"m)" pat "$") {
				tree.Remove(i)
				;break
				return IgnoreParse_DirTree(tree,patterns) ; Indexing problem, therefore reprocess
			}
		}
		if (file.isDir)
			tree[i].contents:=IgnoreParse_DirTree(file.contents,patterns)
	}
	return tree
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

QPX( N=0 ) { ; Wrapper for QueryPerformanceCounter()by SKAN | CD: 06/Dec/2009
	Static F,A,Q,P,X ; www.autohotkey.com/forum/viewtopic.php?t=52083 | LM: 10/Dec/2009
	If	( N && !P )
		Return	DllCall("QueryPerformanceFrequency",Int64P,F) + (X:=A:=0) + DllCall("QueryPerformanceCounter",Int64P,P)
	DllCall("QueryPerformanceCounter",Int64P,Q), A:=A+Q-P, P:=Q, X:=X+1
	Return	( N && X=N ) ? (X:=X-1)<<64 : ( N=0 && (R:=A/X/F) ) ? ( R + (A:=P:=X:=0) ) : 1
}