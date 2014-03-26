#Include WinFade.ahk

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
