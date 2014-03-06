;http://www.autohotkey.com/board/topic/72536-solved-click-through-a-gui/
SetWinDelay, 0
setbatchlines, 0
Gui Color, 0x1A1A1A
Gui +E0x20 -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndHgui
WinSet, Transparent, 0
Gui Show, x0 y0 w%A_screenwidth% h%A_screenHeight%
winfade("ahk_id " Hgui,100,5) ;winfade("ahk_id" Hgui,100,5)
sleep 1000
winfade("ahk_id " Hgui,10,5) ;winfade("ahk_id" Hgui,10,-5)
goto guiclose
return

guiclose:
exitapp

winfade(w:="",t:=128,i:=1,d:=10) {
	w:=(w="")?("ahk_id " WinActive("A")):w
	t:=(t>255)?255:(t<0)?0:t
	WinGet,s,Transparent,%w%
	s:=(s="")?255:s ;prevent trans unset bug
	WinSet,Transparent,%s%,%w% 
	i:=(s<t)?abs(i):-1*abs(i)
	while(k:=(i<0)?(s>t):(s<t)&&WinExist(w)) {
		WinGet,s,Transparent,%w%
		s+=i
		WinSet,Transparent,%s%,%w%
		sleep %d%
	}
}

/*
__winfade(w:="",t:=128,i:=1,d:=10) {
	w:=(w="")?("ahk_id " WinActive("A")):w
	t:=(t>255)?255:(t<0)?0:t
	WinGet,s,Transparent, %w%
	while(k:=(i<0)?(s>t):(s<t)&&WinExist(w)) {
		WinGet,s,Transparent, %w%
		s+=i
		WinSet,Transparent,%s%,%w%
		sleep %d%
	}
}
*/


