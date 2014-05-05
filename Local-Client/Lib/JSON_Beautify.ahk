/*
 *    "JSON_Beautify.ahk" by Joe DF
 *    __________________________________________________________________________________
 *    "Transform Objects & JSON strings into nice or ugly JSON strings."
 *    
 *    Uses VxE's JSON_FromObj() & JSON_ToObj()
 *    Released under MIT License : Basically, just leave this header intact.
 *    ____
 * 
 *    The MIT License (MIT)
 * 
 *    Copyright (c) Joe DF (joedf@users.sourceforge.net)
 * 
 *        Permission is hereby granted, free of charge, to any person obtaining a copy
 *        of this software and associated documentation files (the "Software"), to deal
 *        in the Software without restriction, including without limitation the rights
 *        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *        copies of the Software, and to permit persons to whom the Software is
 *        furnished to do so, subject to the following conditions:
 * 
 *    The above copyright notice and this permission notice shall be included in
 *    all copies or substantial portions of the Software.
 * 
 *        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 *        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 *        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 *        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *        SOFTWARE.
*/

JSON_Uglify(JSON) {
	if JSON is space
		return ""
	if (!IsObject(JSON))
		return JSON_FromObj(JSON_ToObj(JSON))
	else
		return JSON_FromObj(JSON)
}

JSON_Beautify(JSON, gap, fork:=0) {
	if (!fork) {
		if JSON is space
			return ""
		i:=0, indent:="", sp:=""
		_JSON := "{`n"
		if gap is number
		{
			i :=0
			while (i < gap) {
				indent .= " "
				i+=1
			}
		} else {
			indent := gap
		}
	} else {
		indent := gap
	}
	if (!IsObject(JSON))
		JSON:=JSON_ToObj(JSON)
	for key, val in JSON
	{
		if (!IsObject(val))
		{
			_JSON .= indent """"
			ch:=val
			; JSON_Encode(ch) {
				; from VxE's JSON_FromObj
				; Encode control characters, starting with backslash.
				StringReplace, ch, ch, \, \\, A
				StringReplace, ch, ch, % Chr(08), \b, A
				StringReplace, ch, ch, % A_Tab, \t, A
				StringReplace, ch, ch, `n, \n, A
				StringReplace, ch, ch, % Chr(12), \f, A
				StringReplace, ch, ch, `r, \r, A
				StringReplace, ch, ch, ", \", A
				StringReplace, ch, ch, /, \/, A
				While RegexMatch( ch, "[^\x20-\x7e]", kk )
				{
					sss := Asc( kk )
					vv := "\u" . Chr( ( ( sss >> 12 ) & 15 ) + ( ( ( s >> 12 ) & 15 ) < 10 ? 48 : 55 ) )
							. Chr( ( ( sss >> 8 ) & 15 ) + ( ( ( sss >> 8 ) & 15 ) < 10 ? 48 : 55 ) )
							. Chr( ( ( sss >> 4 ) & 15 ) + ( ( ( sss >> 4 ) & 15 ) < 10 ? 48 : 55 ) )
							. Chr( ( sss & 15 ) + ( ( sss & 15 ) < 10 ? 48 : 55 ) )
					StringReplace, ch, ch, % kk, % vv, A
				}
			;   Return ch
			; }
			if key is not number
				_JSON .= key """" ":" """"
			_JSON .= ch """" ",`n"
		} else {
			_JSON .= indent """" key """" ":"
			if (val.MaxIndex()!="")
				_JSON .= "[`n" JSON_Beautify(val,indent indent,1) indent "],`n"
			else
				_JSON .= "{`n" JSON_Beautify(val,indent indent,1) indent "},`n"
		}
	}
	_JSON:=SubStr(_JSON,1,-2) "`n"
	if (!fork)
		return _JSON "}"
	else
		return _JSON
}