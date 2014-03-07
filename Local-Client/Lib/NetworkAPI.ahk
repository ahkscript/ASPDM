u2v(u){
	URLDownloadToFile,%u%, % t:=Util_TempFile()
	FileRead,x,%t%
	FileDelete,%t%
	return x
}

API_List() {
	l:=StrSplit(u2v("http://api-php.aspdm.1eko.com/list.php"),"`n")
	l.Remove(l.MaxIndex())
	return l
}

API_Info(file,item="") {
	return u2v("http://api-php.aspdm.1eko.com/info.php?f=" . file . "&c=" . item)
}

API_Get(file) {
	DownloadFile("http://packs.aspdm.1eko.com/" file,t:=Util_TempFile())
	return t
}

API_UpdateExists(file) {
	SplitPath,file,packname
	server:=API_Info(packname,"version")
	_local:=JSON_ToObj(Manifest_FromPackage(file))
	if (server > _local["version"])
		return server
	return 0
}

