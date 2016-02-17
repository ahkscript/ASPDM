;from  https://github.com/ahkscript/ASPDM/blob/3c480181729a339a84d8e1d0c3672f1954c1320b/Network/lib/utils.php#L140-L176
license(_s) {
	_s := Trim(_s)
	if ( (StrLen(_s)<2) || (InStr(_s,"ASPDM")) )
		return {name:"ASPDM Default License",url:"https://github.com/ahkscript/ASPDM/blob/master/Specifications/License.md"}
	if (InStr(_s,"MIT"))
		return {name:"MIT License",url:"http://opensource.org/licenses/MIT"}
	if (InStr(_s,"BSD")) {
		if (InStr(_s,"2"))
			return {name:"BSD 2-Clause License",url:"http://opensource.org/licenses/BSD-2-Clause"}
		else if (InStr(_s,"3"))
			return {name:"BSD 3-Clause License",url:"http://opensource.org/licenses/BSD-3-Clause"}
		else
			return {name:_s,url:"http://opensource.org/licenses/BSD-3-Clause"}
	}
	if (InStr(_s,"LGPL")) {
		if (InStr(_s,"2.1"))
			return {name:"LGPL v2.1",url:"http://opensource.org/licenses/LGPL-2.1"}
		else if (InStr(_s,"3"))
			return {name:"LGPL v3.0",url:"http://opensource.org/licenses/LGPL-3.0"}
		else
			return {name:_s,url:"http://opensource.org/licenses/lgpl-license"}
	}
	if (InStr(_s,"GPL")) {
		if (InStr(_s,"2"))
			return {name:"GPL v2.0",url:"http://opensource.org/licenses/GPL-2.0"}
		else if (InStr(_s,"3"))
			return {name:"GPL v3.0",url:"http://opensource.org/licenses/GPL-3.0"}
		else
			return {name:_s,url:"http://opensource.org/licenses/gpl-license"}
	}
	if (InStr(_s,"Apache"))
		return {name:"Apache License v2.0",url:"http://opensource.org/licenses/Apache-2.0"}
	if (InStr(_s,"MPL") || InStr(_s,"Mozilla"))
		return {name:"Mozilla Public License v2.0",url:"http://opensource.org/licenses/MPL-2.0"}
	if (InStr(_s,"CC0") || "Public domain")
		return {name:"Public domain (CC0 1.0)",url:"http://creativecommons.org/publicdomain/zero/1.0"}
	if ( (InStr(_s,"CC")) || (InStr(_s,"creative")) || (InStr(_s,"commons")) )
		return {name:_s,url:"http://creativecommons.org/licenses"}
}