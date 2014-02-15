
Util_TempDir(outDir="")
{
	Loop
		tempName := "~temp" A_TickCount ".tmp", tempDir := ((!outDir)?A_WorkingDir:outDir) "\" tempName
	until !FileExist(tempDir)
	return tempDir
}

Util_FileAlign(f)
{
	while f.Pos & 3
		f.WriteUChar(0)
}

Util_FileWriteStr(f, ByRef str)
{
	pos := f.Pos
	f.WriteUInt(0)
	f.Write(str)
	size := (tmp := f.Pos) - pos - 4
	f.Pos := pos
	f.WriteUInt(size)
	f.Pos := tmp
	Util_FileAlign(f)
}

Util_ReadLenStr(ptr, ByRef endPtr)
{
	len := NumGet(ptr+0, "UInt")
	endPtr := (ptr+len+7)&~3
	return StrGet(ptr+4, len, "UTF-8")
}

Util_DirTree(dir, bd := "")
{
	data := [], bd := bd ? bd : dir, lbd := StrLen(bd)+1
	Loop, %dir%\*.*, 1
	{
		StringTrimLeft, name, A_LoopFileFullPath, %lbd%
		e := { name: name, fullPath: A_LoopFileLongPath }
		if SubStr(name, 0) = "~" || SubStr(name, -3) = ".bak" || name = "package.json"
			continue
		IfInString, A_LoopFileAttrib, D
		{
			e.isDir := true
			e.contents := Util_DirTree(A_LoopFileFullPath, bd)
		}
		data.Insert(e)
	}
	return data
}

Util_DirTreeIndexed(dir, bd := "")
{
	data := [], bd := bd ? bd : dir, lbd := StrLen(bd)+1
	Loop, %dir%\*.*, 1
	{
		StringTrimLeft, name, A_LoopFileFullPath, %lbd%
		e := { name: name, fullPath: A_LoopFileLongPath }
		if SubStr(name, 0) = "~" || SubStr(name, -3) = ".bak" || name = "package.json"
			continue
		IfInString, A_LoopFileAttrib, D
		{
			e.isDir := true
			e.contents := Util_DirTreeIndexed(A_LoopFileFullPath, bd)
		}
		else
		{
			FileGetSize, fsz, %A_LoopFileFullPath%
			e.size := fsz
		}
		data.Insert(e)
	}
	return data
}

/*
Util_ExtractTree(ptr, dir)
{
	FileCreateDir, %dir%
	nElems := NumGet(ptr+0, "UInt"), ptr += 4
	Loop, %nElems%
	{
		name := dir "\" Util_ReadLenStr(ptr, ptr)
		size := NumGet(ptr+0, "UInt"), ptr += 4
		if (size = 0xFFFFFFFF)
		{
			; Directory
			ret := Util_ExtractTree(ptr, name)
			if ret != OK
				return ret
		} else
		{
			f := FileOpen(name, "w", "UTF-8-RAW")
			f.RawWrite(ptr+0, size)
			f := ""
			ptr := (ptr+size+3)&~3
		}
	}
	return "OK"
}
*/

Util_ExtractTree(ptr, dir, i=0, root="")
{
	global kPtr
	if (!i)
		kPtr:=ptr
	
	if (!root)
		root:=dir
	FileCreateDir, %dir%
	nElems := NumGet(ptr+0, "UInt"), ptr += 4
	Loop, %nElems%
	{
		nPtr:=ptr
		
		Nchk:=NumGet(ptr+0, "UInt")
		if ( (Nchk==1) )
			ptr+=4
		
		file := Util_ReadLenStr(ptr, ptr)
		name := dir "\" file
		if (i)
			name := root "\" file
		size := NumGet(ptr+0, "UInt"), ptr += 4
		
		if (size = 0xFFFFFFFF)
		{
			; Directory
			ret := Util_ExtractTree(ptr, name, i+1, root)
			if ret != OK
				return ret
		} else
		{
			try f := FileOpen(name, "w", "UTF-8-RAW")
			catch
				throw Exception("Cannot extract data!`nFile: """ . name . """")
			f.RawWrite(ptr+0, size)
			f := ""
			ptr := (ptr+size+3)&~3
		}
	}
	return "OK"
}

Util_ExtractTreeIndexed(byref ptr, tree, root="", fork=0)
{
	static sPtr
	if (!fork) {
		sPtr := ptr
	}

	for _,e in tree
	{
		if e.isDir
		{
			d:=e.name
			FileCreateDir, %root%\%d%
			ret := Util_ExtractTreeIndexed(ptr, e.contents, root, fork+1)
			if ret != OK
				return ret
		}
		else
		{
			fname := root . "\" . (e.name)
			try f := FileOpen(fname, "w", "UTF-8-RAW")
			catch
				throw Exception("Cannot extract data!`nFile: """ . fname . """")
			f.RawWrite(ptr+0, e.size)
			f := ""
			ptr := ptr + (e.size)
		}
	}
	return "OK"
}

Util_isASCII(s)
{
	i:=0
	Loop, % k:=StrLen(s)
	{
		z:=Asc(SubStr(s,A_Index,1))
		;if ( (z<=8) || (z==11) || (z==12) || (z==127) || ((z>=14) && (z<=31)) )
		if ( z==0x09 || z==0x0A || z==0x0D || (0x20 <= z && z <= 0x7E) )
			i+=1
		else
			i-=1
	}
	return (((k)?k:-i)==i)
}
