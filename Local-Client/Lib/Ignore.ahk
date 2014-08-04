;Mimic/emulate ".gitignore", see http://git-scm.com/docs/gitignore

Ignore_GetPatterns(ignorefile)
{
	i_fp := Util_FullPath(ignorefile)
	SplitPath,i_fp,,baseDir
	StringReplace,baseDir,baseDir,\,/,All
	
	ignore_patterns:=[]
	Loop,Read,%ignorefile%
	{
		if StrLen(current_line:=Trim(A_LoopReadLine)) ;A blank line matches no files, so it can serve as a separator for readability.
		{
			tf:=SubStr(current_line,1,2) ;two first chars
			fc:=SubStr(tf,1,1) ;first char
			
			if (fc=="#") ;A line starting with # serves as a comment.
				continue
			if (tf=="\#") { ;Put a backslash ("\") in front of the first hash for patterns that begin with a hash.
				ignore_patterns.Insert(Trim(SubStr(current_line,2)))
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
		StringReplace,_tmp,_tmp,/,\\,All
		StringReplace,_tmp,_tmp,.,\.,All
		StringReplace,_tmp,_tmp,*,.*,All
		StringReplace,_tmp,_tmp,$,\$,All
		ignore_patterns[each]:=_tmp
	}
	return ignore_patterns
}

Ignore_DirTree(tree,patterns) ;currently, inefficient...
{
	tree := tree.Clone() ; Indexing problem, therefore using a copy
	if (patterns.MaxIndex == 0)
		return tree
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
				return Ignore_DirTree(tree,patterns) ; Indexing problem, therefore reprocess
			}
		}
		if (file.isDir)
			tree[i].contents:=Ignore_DirTree(file.contents,patterns)
	}
	return tree
}