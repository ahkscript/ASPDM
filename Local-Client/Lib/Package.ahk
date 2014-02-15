
Package_Build(outFile, baseDir)
{
	; Read manifest
	man := Manifest_FromFile(baseDir "\package.json")
	
	tree := Util_DirTreeIndexed(baseDir)
	_Package_DumpTreeIndexed(outFile, tree)
		;tree := Util_DirTree(baseDir)
		;_Package_DumpTree(outFile, tree)
	_Package_Compress(outFile, outFile, JSON_FromObj(man))
}

_Package_Compress(fIn, fOut, manjson)
{
	FileGetSize, fSize, %fIn%
	FileRead, data, *c %fIn%
	
	; COMPRESSION_FORMAT_LZNT1 | COMPRESSION_ENGINE_MAXIMUM
	DllCall("ntdll\RtlGetCompressionWorkSpaceSize", "ushort", 0x102, "uint*", bufWorkSpaceSize, "uint*", fragWorkSpaceSize)
	VarSetCapacity(bufWorkSpace, bufWorkSpaceSize)
	
	VarSetCapacity(bufTemp, fSize)
	if DllCall("ntdll\RtlCompressBuffer", "ushort", 0x102, "ptr", &data, "uint", fSize
		, "ptr", &bufTemp, "uint", fSize, "uint", fragWorkSpaceSize, "uint*", cSize, "ptr", &bufWorkSpace) != 0
		throw Exception("Compression failure")
	
	f := FileOpen(fOut, "w", "UTF-8-RAW")
	f.Write("AHKPKG00")
	Util_FileWriteStr(f, manjson)
	f.WriteUInt(fSize)
	f.RawWrite(bufTemp, cSize)
	f.Close()
}

_Package_Extract(dir, inFile)
{
	FileGetSize, dataSize, %inFile%
	FileRead, data, *c %inFile%
	pData := &data
	if StrGet(pData, 8, "UTF-8") != "AHKPKG00"
		return "Invalid format"
	
	lpOffset:=NumGet(pData+0,8,"UInt")+15
	uncompSize := NumGet(pData+lpOffset, "UInt"), pData += (4+lpOffset)
	
	VarSetCapacity(uncompData, uncompSize)
	; COMPRESSION_FORMAT_LZNT1 | COMPRESSION_ENGINE_MAXIMUM
	if DllCall("ntdll\RtlDecompressBuffer", "ushort", 0x102, "ptr", &uncompData, "uint", uncompSize
		, "ptr", pData, "uint", &data + dataSize - pData, "uint*", finalSize) != 0
		throw Exception("Decompression error")
	
	ptr := &uncompData
	tPtr := NumGet(ptr+0, "UInt") + ptr
	tSz  := NumGet(ptr+4, "UInt")
	tree := JSON_ToObj(StrGet(tPtr,tSz,"UTF-8"))
	ptr += 8
	
	return Util_ExtractTreeIndexed(ptr, tree, dir)
		;return Util_ExtractTree(&uncompData, dir)
}

_Package_DumpTree(f, tree)
{
	if !IsObject(f)
		f := FileOpen(f, "w", "UTF-8-RAW")
	
	tl := tree.MaxIndex(), tl := tl ? tl : 0
	f.WriteUInt(tl)
	for _,e in tree
	{
		Util_FileWriteStr(f, e.name)
		if e.isDir
		{
			f.WriteUInt(-1)
			_Package_DumpTree(f, e.contents)
		} else
		{
			fullPath := e.fullPath
			FileGetSize, fSize, %fullPath%
			VarSetCapacity(fData, fSize)
			FileRead, fData, *c %fullPath%
			f.WriteUInt(fSize)
			f.RawWrite(fData, fSize)
			Util_FileAlign(f)
			VarSetCapacity(fData, 0)
		}
	}
}

_Package_DumpTreeIndexed(f, ByRef tree, fork=0)
{
	if !IsObject(f)
		f := FileOpen(f, "rw", "UTF-8-RAW")
	if (!fork) {
		f.Seek(8)
	}
	for _,e in tree
	{
		if e.isDir
		{
			e.Remove("fullPath")
			_Package_DumpTreeIndexed(f, e.contents, fork+1)
		}
		else
		{
			fullPath := e.Remove("fullPath")
			VarSetCapacity(fData, e.size)
			FileRead, fData, *c %fullPath%
			f.RawWrite(fData, e.size)
			VarSetCapacity(fData, 0)
		}
	}
	if (!fork) {
		x := f.Pos
		f.Write((sTree:=JSON_FromObj(tree)))
		f.Seek(0)
		f.WriteUInt(x)
		f.WriteUInt(StrLen(sTree))
		f.Close()
	}
}
