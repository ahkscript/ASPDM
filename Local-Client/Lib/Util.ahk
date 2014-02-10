
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
			try f := FileOpen(name, "w", "UTF-8-RAW")
			catch
				throw Exception("Cannot extract data!")
			f.RawWrite(ptr+0, size)
			f := ""
			ptr := (ptr+size+3)&~3
		}
	}
	return "OK"
}
