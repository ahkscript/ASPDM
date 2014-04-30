Packs_Source:="http://packs.aspdm.tk"
API_Source:="http://api-php.aspdm.tk"
API_u2vClean:=0

; Other/mirror servers - [not always updated]
; --------------------------------------------
; Packs_Source:="http://packs.ahk.cu.cc"
; API_Source:="http://api-php.ahk.cu.cc"
;
; Packs_Source:="http://packs.aspdm.cu.cc"
; API_Source:="http://api-php.aspdm.cu.cc"
; API_u2vClean:=1 ;enable u2v_clean()
;
; Packs_Source:="http://packs.aspdm.1eko.com"
; API_Source:="http://api-php.aspdm.1eko.com"
; --------------------------------------------

CheckUpdate(version,silent:=0,Update_URL:="http://aspdm.tk/update.ini") {
	URLDownloadToFile,%Update_URL%, % tempupdatefile:=Util_TempFile()
	IniRead,NewVersion,%tempupdatefile%,Update,Version,NULL (Error)
	IniRead,__URL,%tempupdatefile%,Update,URL
	FileDelete,%tempupdatefile%
	if (InStr(NewVersion,"NULL") || InStr(NewVersion,"Error"))
	{
		if (silent)
			return "ERROR"
		else
			MsgBox, 262192, %A_ScriptName% - Update, An error occured.`nPlease check your internet connection and try again.
	}
	else
	{
		if (NewVersion > Version)
		{
			if (silent==-1 || silent==0) {
				MsgBox, 262212, %A_ScriptName% - Update, A new version is available.`nCurrent Version: `t%Version%`nLatest Version: `t%NewVersion%`nWould you like to update?
				IfMsgBox, Yes
					run, %__URL%
			}
			return 1
		}
		else
		{
			if (!silent)
				MsgBox, 262208, %A_ScriptName% - Update, You have the latest version.
			return 0
		}
	}
}

u2v(u){
	URLDownloadToFile,%u%, % t:=Util_TempFile()
	FileRead,x,%t%
	FileDelete,%t%
	return x
}

v_clean(s){ ;the new free host adds junk, this filters it out
	/*
	j:=substr(k:=RegExReplace(u2v(u),"s)<!--.*"),1,1)
	return ((j=="?")?SubStr(k,2):k)
	*/
	i:=0, k:=RegExReplace(s,"s)<!--.*")
	loop % strlen(3)
		if (!Util_isASCII(SubStr(k,1,1)))
			i+=1
	k:=SubStr(k,i+1)
	return ((SubStr(k,1,1)=="?")?SubStr(k,2):k)
}

u2v_clean(u){ ;the new free host adds junk, this filters it out
	global API_u2vClean
	if (API_u2vClean)
		return v_clean(u2v(u))
	return u2v(u)
}

API_List() {
	global API_Source
	l:=StrSplit(u2v_clean(API_Source "/list.php"),"`n")
	l.Remove(l.MaxIndex())
	return l
}

/* Not available yet
API_ListNum(limits) {
	global API_Source
	return JSON_ToObj(u2v_clean(API_Source "/list.php?lim=" n))
}
*/

API_ListAll() {
	global API_Source
	return JSON_ToObj(u2v_clean(API_Source "/list.php?full"))
}

API_Info(file,item="") {
	global API_Source
	return u2v_clean(API_Source "/info.php?f=" . file . "&c=" . item)
}

API_Get(file) {
	global Packs_Source
	DownloadFile(Packs_Source "/" file,t:=Util_TempFile())
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

