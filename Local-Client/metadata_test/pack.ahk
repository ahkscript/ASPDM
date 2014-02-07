#Include 7zWrap.ahk

add_metadata(dPack,MData) {
	if (f:=FileOpen(dPack,"r")) {
		s:=abs( (f.Length) + 0 )
		VarSetCapacity(buf,s)
		f.Seek(0)
		if (k:=f.RawRead(buf,s)) {
			f.Close()
			f:=FileOpen(dPack,"w")
			f.Seek(0)
			f.Write(MData)
			f.RawWrite(buf,s)
		}
		f.Close()
		return k
	}
	return 0
}

get_metadata(dPack,ByRef lp=-1) {
	f:=FileOpen(dPack,"r")
	f.Seek(0)
	o:=""
	s:=0
	Loop % (l:=f.Length)
	{
		f.RawRead(c,1)
		if (c==chr(0))
		{
			o:=""
			break
		}
		if (c=="{")
			s:=1
		if (s)
			o.=c
		if (c=="}") {
			lp := f.Pos + 0
			break
		}
	}
	f.Close()
	return o
}

/* 7zip detect offset automatically using the 7z header mark
unpack(dPack,dFolder,opts="") {
	tmp:=dPack . ".tmp" . A_TickCount
	FileCopy,%dPack%,%tmp%,1
	e:=get_metadata(tmp,lp)
	if (f:=FileOpen(tmp,"r")) {
		s:=abs( (f.Length) - lp )
		VarSetCapacity(buf,s)
		f.Seek(lp)
		if (k:=f.RawRead(buf,s)) {
			if (f:=FileOpen(tmp,"w")) {
				f.Seek(0)
				f.RawWrite(buf,k)
				f.Close()
				if (7z_extract(tmp,dFolder,opts))
				{
					return e
				}
			}
		}
		f.Close()
	}
	return 0
}
*/






