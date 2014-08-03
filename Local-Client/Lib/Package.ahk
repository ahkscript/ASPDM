
Package_Build(outFile, baseDir, jfile="")
{
	; Read manifest
	if (!jfile)
		man := Manifest_FromFile(baseDir "\package.json")
	else
		man := Manifest_FromFile(jfile)
	
	man.ahkversion:=A_AhkVersion

	tree := Util_DirTree(baseDir)
	
	if FileExist(ignorefile:=baseDir "\.aspdm_ignore") {
		ignore_patterns:=Ignore_GetPatterns(ignorefile)
		tree := Ignore_DirTree(tree,ignore_patterns)
	}
	
	_Package_DumpTree(outFile, tree)
	_Package_Compress(outFile, outFile, JSON_FromObj(man))
	return Package_Validate(outFile)
}

Package_Validate(fIn) { ;Quick Validate
	if !FileExist(fIn) {
		MsgBox Validation Error: Non-existant file.
		return 0
	}
	pFile := FileOpen(fIn,"r","UTF-8-RAW")
	if !IsObject(pFile) {
		MsgBox Can't open "%fIn%" for validation.
		return 0
	}
	magic:=pFile.Read(8)
	if ( (m_int := pFile.ReadUInt()) < 80 )
		return 0
	m_st := pFile.Read(1)
	pFile.Seek(0x0B+m_int)
	m_en := pFile.Read(1)
	pFile.Close()
	;msgbox % "[" . magic . "|" . m_int . "|" . m_st . "|" . m_en . "]"
	return ( (magic == "AHKPKG00") && (m_int >= 80) && (m_int<5242880) && (m_st == "{") && (m_en == "}") )
}

Package_Extract(dir, inFile)
{
	FileGetSize, dataSize, %inFile%
	FileRead, data, *c %inFile%
	pData := &data
	if StrGet(pData, 8, "UTF-8") != "AHKPKG00"
		return "Invalid format"
	
	; Skip manifest
	off := 8, manSize := NumGet(data, off, "UInt"), off := (off+manSize+7) &~ 3
	pData += off
	uncompSize := NumGet(pData+0, "UInt"), pData += 4
	
	VarSetCapacity(uncompData, uncompSize)
	; COMPRESSION_FORMAT_LZNT1 | COMPRESSION_ENGINE_MAXIMUM
	if DllCall("ntdll\RtlDecompressBuffer", "ushort", 0x102, "ptr", &uncompData, "uint", uncompSize
		, "ptr", pData, "uint", &data + dataSize - pData, "uint*", finalSize) != 0
		throw Exception("Decompression error")
	
	return _Package_ExtractTree(&uncompData, dir)
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
	; f.Close() not necessary because 'f' goes out of scope
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

_Package_ExtractTree(ptr, dir)
{
	try FileCreateDir, %dir%
	nElems := NumGet(ptr+0, "UInt"), ptr += 4
	Loop, %nElems%
	{
		name := dir "\" Util_ReadLenStr(ptr, ptr)
		size := NumGet(ptr+0, "UInt"), ptr += 4
		if (size = 0xFFFFFFFF)
		{
			; Directory
			if not ptr := _Package_ExtractTree(ptr, name)
				break
		} else
		{
			f := FileOpen(name, "w", "UTF-8-RAW")
			f.RawWrite(ptr+0, size)
			f := ""
			ptr += (size+3) &~ 3
		}
	}
	return ptr
}
