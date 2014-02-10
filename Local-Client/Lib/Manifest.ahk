
/* Method A
Manifest_FromPackage(fileName,ByRef lastpos=-1)
{
	if (f:=FileOpen(fileName,"r")) {
		f.Seek(0)
		o:="", s:=0
		Loop % (l:=f.Length)
		{
			if (k:=f.RawRead(c,1)) {
				if ( (c==chr(0)) && s ) ;if reading & encounter null byte
					break
				if (c=="{")
					s:=1
				if (s)
					o.=c
				if (c=="}") {
					lastpos := f.Pos + 0
					break
				}
			}
			else
				break
		}
		f.Close()
	}
	if ( (!f) || (lastpos<2) || (SubStr(o,0)!="}") )
		throw Exception("Could not extract manifest!")
	return o
}
*/

; Method B
Manifest_FromPackage(fileName,ByRef lastpos=-1)
{
	o:="", s:=0
	try {
		FileRead, data, *c %fileName%
		Loop, % VarSetCapacity(data)
		{
			c:=Chr(*(&data + A_Index - 1))
			if ( (c==chr(0)) && s ) ;if reading & encounter null byte
				break
			if (c=="{")
				s:=1
			if (s)
				o.=c
			if (c=="}") {
				lastpos := A_Index
				break
			}
		}
		VarSetCapacity(data,0)
		if ( (lastpos<2) || (SubStr(o,0)!="}") )
			throw "Could not extract manifest!"
	}
	catch e
		throw Exception(e)
	return o
}

Manifest_FromFile(fileName)
{
	try FileRead, tman, % fileName
	catch
		throw Exception("Cannot read manifest!")
	
	return Manifest_FromStr(tman)
}

Manifest_FromStr(tman)
{
	man := JSON_ToObj(tman)
	if !IsObject(man)
		throw Exception("Manifest parse error!")
	
	out := {}
	
	; Validation
	_ManValidateField(out, man, "name")
	if !_IsValidAHKIdentifier(out.name)
		throw Exception("Invalid package name (should be a valid AHK identifier): '" out.name "'")
	_ManValidateField(out, man, "version")
	_ManValidateField(out, man, "type")
	_ManValidateField(out, man, "ahkbranch")
	_ManValidateField(out, man, "ahkversion")
	_ManValidateField(out, man, "ahkflavour")
	_ManValidateField(out, man, "fullname")
	_ManValidateField(out, man, "author")
	_ManOptionalField(out, man, "description")
	_ManOptionalField(out, man, "license", "ASPDM Default License")
	_ManOptionalField(out, man, "category", "Other")
	_ManOptionalField(out, man, "forumurl")
	_ManOptionalField(out, man, "screenshot")
	return out
}

_IsValidAHKIdentifier(x)
{
	return !!RegExMatch(x, "^(?:[a-zA-Z0-9#_@\$]|[^\x00-\x7F])+$")
}

ObjHasNonEmptyKey(obj, field)
{
	return ObjHasKey(obj, field) && obj[field] != ""
}

_ManValidateField(out, man, field)
{
	if !ObjHasNonEmptyKey(man, field)
		throw Exception("Missing manifest field: '" field "'")
	out[field] := man[field]
}

_ManOptionalField(out, man, field, defValue := "")
{
	out[field] := ObjHasNonEmptyKey(man, field) ? man[field] : defValue
}

