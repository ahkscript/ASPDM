
Package_Build(outFile, baseDir)
{
	; Read manifest
	man := Manifest_FromFile(baseDir "\package.json")
	
	tree := Util_DirTree(baseDir)
	_Package_DumpTree(outFile, tree)
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
