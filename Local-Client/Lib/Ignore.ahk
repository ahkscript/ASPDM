;Mimic/emulate ".gitignore", see http://git-scm.com/docs/gitignore

Ignore_GetPatterns(ignorefile)
{
	i_fp := Util_FullPath(ignorefile)
	SplitPath,i_fp,,baseDir
	StringReplace,baseDir,baseDir,\,/,All
	c2_:=chr(2), c3_:=chr(3)
	
	ignore_patterns:=[]
	Loop,Read,%ignorefile%
	{
		if StrLen(current_line:=Trim(A_LoopReadLine)) ;A blank line matches no files, so it can serve as a separator for readability.
		{
			tf:=SubStr(current_line,1,2) ;two first chars
			fc:=SubStr(tf,1,1) ;first char
			
			if (fc=="#") ;A line starting with # serves as a comment.
				continue
			if (tf=="\ ") ;escape for leading spaces
			|| (tf=="\#") { ;Put a backslash ("\") in front of the first hash for patterns that begin with a hash.
				ignore_patterns.Insert(SubStr(current_line,2))
				continue
			} else {
				ignore_patterns.Insert(Trim(current_line))
			}
		}
	}
	for each, pat in ignore_patterns
	{
		_tmp:=pat
		if (SubStr(_tmp,1,1)=="/")
			_tmp:= "^" baseDir "/" SubStr(_tmp,2)
		StringReplace,_tmp,_tmp,/**/,%c2_%,All
		StringReplace,_tmp,_tmp,/,\\,All
		StringReplace,_tmp,_tmp,.,\.,All
		StringReplace,_tmp,_tmp,**,%c3_%,All
		StringReplace,_tmp,_tmp,*,[^\\]+,All
		StringReplace,_tmp,_tmp,$,\$,All
		StringReplace,_tmp,_tmp,%c2_%,\\+.*\\*,All
		StringReplace,_tmp,_tmp,%c3_%,.*,All
		ignore_patterns[each]:=_tmp
	}
	return ignore_patterns
}

Ignore_DirTree(dir,patterns)
{
	data := [], ldir := StrLen(dir)+1
	Loop, %dir%\*.*, 1
	{
		StringTrimLeft, name, A_LoopFileFullPath, %ldir%
		e := { name: name, fullPath: A_LoopFileLongPath }
		
		;quick-ignore the package metadata files
		if name in package.json,.aspdm_ignore
			continue
		
		;check attrib
		IfInString, A_LoopFileAttrib, D
			e.isDir := true
		
		;check ignores
		for j, pat in patterns
		{
			if (SubStr(pat,-1)=="\\") {
				if (e.isDir)
					StringTrimRight,pat,pat,2
				else
					continue
			}
			if RegExMatch(e.fullPath,"m)" pat "$") {
				continue 2
			}
		}
		
		;continue parsing inside directories
		if (e.isDir)
			e.contents := Ignore_DirTree(A_LoopFileFullPath,patterns)
		
		data.Insert(e)
	}
	return data
}