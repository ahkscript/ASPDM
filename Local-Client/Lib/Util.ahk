
;Rename this Function. I don't have a good name for it now...
Util_CSV2TagsObj(rawCSV:="") {
	obj:=Object()
	Loop, Parse, rawCSV, CSV
		if ( (k:=Trim(A_LoopField)) != "")
			obj.Insert(k)
	return obj
}

Util_TagsObj2CSV(TagsObj:="") {
	if !IsObject(TagsObj)
		return ""
	CSV:=""
	for index, tag in TagsObj
		if ( (k:=Trim(tag)) != "")
			CSV := CSV k ","
	return SubStr(CSV,1,-1)
}

Util_ObjCount(Obj) {
	if (!IsObject(Obj))
		return 0
	z:=0
	for k in Obj
		z+=1 ;or z:=A_Index
	return z
}

Util_ShortPath(p,l=50) {
	VarSetCapacity(_p, (A_IsUnicode?2:1)*StrLen(p) )
	DllCall("shlwapi\PathCompactPathEx"
		,"str", _p
		,"str", p
		,"uint", abs(l)
		,"uint", 0)
	return _p
}

Util_TempDir(outDir="")
{
	Loop
		tempName := "~temp" A_TickCount ".tmp", tempDir := ((!outDir)?A_Temp:outDir) "\" tempName
	until !FileExist(tempDir)
	return tempDir
}

Util_TempFile()
{
	Loop
		tempName := A_Temp "\~temp" A_TickCount ".tmp"
	until !FileExist(tempName)
	return tempName
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
	endPtr := ptr + ((len+7)&~3)
	return StrGet(ptr+4, len, "UTF-8")
}

Util_DirTree(dir)
{
	data := [], ldir := StrLen(dir)+1
	Loop, %dir%\*.*, 1
	{
		StringTrimLeft, name, A_LoopFileFullPath, %ldir%
		e := { name: name, fullPath: A_LoopFileLongPath }
		if SubStr(name, 0) = "~" || SubStr(name, -3) = ".bak" || name = "package.json"
			continue
		IfInString, A_LoopFileAttrib, D
		{
			e.isDir := true
			e.contents := Util_DirTree(A_LoopFileFullPath)
		}
		data.Insert(e)
	}
	return data
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
