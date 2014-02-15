#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

outP := A_ScriptDir "\package_test.ahkp"
testDir := A_ScriptDir "\package_test"
tempDir := Util_TempDir()

Package_Build(outP, testDir)
MsgBox % Manifest_FromPackage(outP)

if (_Package_Extract(tempDir, outP) == "OK") {
	MsgBox, 68, , Extraction was successful!`nOpen in Explorer?
	ifMsgBox, Yes
		Run, Explorer.exe "%tempDir%"
}
else
{
	FileRemoveDir, %tempDir%, 1
	MsgBox, 16, , Extraction failed!
}