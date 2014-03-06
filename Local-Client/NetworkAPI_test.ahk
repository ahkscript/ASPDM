#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

/*
	API temporarily hosted @ api-php.aspdm.1eko.com
	See https://trello.com/c/V27ITnHO/16-web-server-api

	info.php	--	Get JSON info from a package in "packs/"
		Usage: ?f=FILENAME&c=JSONITEM
		If 'JSONITEM' is specified, it returns a normal string.
		Otherwise, a JSON string is returned.
		
	list.php	--	List all files in "packs/"
		Usage: no arguments
		Returns a list of all packages seperated by '`n'
		
	submit.php	--	Used for the online upload form
		no arguments
*/

u2v(u){
	URLDownloadToFile,%u%, % t:=Util_TempFile()
	FileRead,x,%t%
	FileDelete,%t%
	return %x%
}

API_list() {
	l:=StrSplit(u2v("http://api-php.aspdm.1eko.com/list.php"),"`n")
	l.Remove(l.MaxIndex())
	return l
}

API_info(file,item="") {
	return u2v("http://api-php.aspdm.1eko.com/info.php?f=" . file . "&c=" . item)
}

packs:=API_list()
total:=packs.MaxIndex()
item:=API_info(packs[1],"id")
MsgBox There is currently a total of %total% package(s).`nThe 'id' of the first item in the package list is : %item%
