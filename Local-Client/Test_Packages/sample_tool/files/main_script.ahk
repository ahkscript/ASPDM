#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;<<<<<<<<  HEADER END  >>>>>>>>>

FileRead,stuff,some_text.txt
MsgBox Sample tool`n`nContents of "some_text.txt" :`n`n%stuff%

ExitApp