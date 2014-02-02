;placeholder script
;SHould maybe, be made as fork, mod pAHKLight?

data =
(join`n
Package A00001	Bob	2013-12-08 21:18	176 Kb
Package B00002	Jack	2013-12-08 21:18	224 Kb
Package C00003	George	2013-12-08 21:20	172 Kb
Package D00004	Sarah	2013-12-08 21:20	216 Kb
Package E00005	John	2013-10-11 17:46	176 Kb
Package F00006	Lisa	2013-10-11 17:45	224 Kb
Package G00007	Charles	2013-10-11 17:44	172 Kb
Package H00008	Jacob	2013-10-11 17:44	172 Kb
Package I00009	Alexandra	2013-10-11 17:44	172 Kb
Package J00010	Andy	2013-10-11 17:44	216 Kb
Package K00011	Lisa	2013-10-11 17:45	224 Kb
Package L00012	Andy	2013-10-11 17:44	216 Kb
Package M00013	Charles	2013-10-11 17:44	172 Kb
Package N00014	George	2013-12-08 21:20	172 Kb
Package O00015	Jack	2013-12-08 21:18	224 Kb
)

Gui, Font, s16 wBold, Arial
Gui, Add, Text, x16 , ASPDM
Gui, Font
Gui, Add, Text, yp+5 x+16, AHKScript.org's Package/StdLib Distribution and Management
Gui, Add, ListView, x16 y+8 w440 h200, Name|Maintainer|Last modified|Size ;Name|Type|FullName|Author
Gui, Add, Button, y+4 w80, Button
Gui, Add, Button, yp x+2 w80, Button
Gui, Show,, ASPDM - Package/StdLib Distribution and Management
Loop, Parse, data, `n
{
	a:=StrSplit(A_LoopField,A_Tab)
	LV_Add("",a[1],a[2],a[3],a[4],a[5])
}
LV_ModifyCol(1,"144")
LV_ModifyCol(2,"100")
LV_ModifyCol(3,"100")
LV_ModifyCol(4,"Right 64")
return

GuiClose:
ExitApp