;"Floating Alphanumeric" sorting by joedf [18:03 2014/06/10]

arr:=["Jack","Bob","Charles","Albert","John","Kate","Sasha","REALLY_LONG_STRING_of_DooOOOOoOOooOOoOMMMMmmmMMMmm!!!!!"]
;arr:=["jACK","Jack"]
;MsgBox % stringNumbify("REALLY_LONG_STRING_KHGD_fdsfdsfsda_sdfakhflsdjkfhksdjfsad_sdfdsSHSGF")+0
;MsgBox % stringNumbify("Jack") " | " stringNumbify("John") " | " stringNumbify("Albert") " | " stringNumbify("Sasha") " | " asc("a") "\" asc("o")
MsgBox % arr2str(arr,"`n")
;MsgBox % stringNumbify("Jack",0) " \ " stringNumbify("jACK",0)
arr:=alphasort(arr)
MsgBox % arr2str(arr,"`n")

AlphaSort(obj,ic:=1,precise:=0) {
	newObj:=Object(), retObj:=Object()
	for key, val in obj
		newObj[stringNumbify(val,ic,precise)]:=val
	for key, val in newObj
		retObj[A_Index]:=val
	return retObj
}

stringNumbify(str,ic:=1,precise:=0) {
	if (precise)
		SetFormat, float, 0.15
	if (ic)
		StringLower,str,str
	k:=(ic>0)?97:65
	num:=""
	loop, Parse, str
		num .= (asc(A_LoopField)-k)+10
	return ( "0." ((num=="")?0:num) )
}

arr2str(o,d:=",",q:=1) {
	s:=""
	for i, v in o
		if (q)
			s .= """" v """" d
		else
			s .= v d
	return SubStr(s,1,-1)
}