7z_exe:=A_scriptDir . "\7za.exe"

7z_compress(dPack,files*) {
	global 7z_exe
	flist:=""
	for each, file in files
		flist:= flist """" file """" " "
	if FileExist(dPack)
		FileDelete, %dPack%
	RunWait, %7z_exe% a -t7z "%dPack%" %flist%,,Hide UseErrorLevel
	return !7z_error(ErrorLevel)
}

7z_extract(dPack,dFolder="",opts="") {
	global 7z_exe
	if StrLen(dFolder)
		out:="-o" . """" . dFolder . """"
	RunWait, %7z_exe% x "%dPack%" %out% -y %opts%,,Hide UseErrorLevel
	return !7z_error(ErrorLevel)
}

7z_error(e) {
	if (e==1)
		MsgBox Warning (Non fatal error(s)). For example, one or more files were locked by some other application, so they were not compressed. 
	else if (e==2)
		MsgBox Fatal error 
	else if (e==7)
		MsgBox Command line error 
	else if (e==8)
		MsgBox Not enough memory for operation 
	else if (e==255)
		MsgBox User stopped the process 
	return e
}