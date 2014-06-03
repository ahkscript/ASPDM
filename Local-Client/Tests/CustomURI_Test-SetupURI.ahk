#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Custom URI Documentation : http://msdn.microsoft.com/en-us/library/ie/aa767914

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
   ExitApp
}
Gui, Add, Button, x0 y0 w300 h30 gInstall, Install
Gui, Add, Button, xp y+0 wp hp gRemove, Remove
Gui, Add, Button, xp y+0 wp hp gCancel, Cancel
Gui, Show, w300 h90, Setup "aspdm://" Test URI
return

Cancel:
MsgBox Canceled : Nothing was changed.
GuiClose:
ExitApp

Install:
if !FileExist("CustomURI_Test.exe") {
	MsgBox, 48, , First, please compile "CustomURI_Test.ahk" to "CustomURI_Test.exe".
	return
}
if (Setup_CustomURI("aspdm",A_ScriptDir "\CustomURI_Test.exe"))
	MsgBox, 64, , Seems to be installed.`nNow try out "aspdm://samples.ahkp" ...
else
	MsgBox, 48, , It seems the install has failed.
ExitApp

Remove:
RegRead,x_testvar,HKEY_CLASSES_ROOT,aspdm
if ErrorLevel
{
	MsgBox, 48, , Nothing was installed.
	return
}
RegDelete,HKEY_CLASSES_ROOT,aspdm
if (!ErrorLevel)
{
	RegRead,x_testvar,HKEY_CLASSES_ROOT,aspdm
	if ErrorLevel
	{
		MsgBox, 64, , The removal seems to be successful.
		ExitApp
	}
}
MsgBox, 48, , It seems the removal has failed.
ExitApp


Setup_CustomURI(ProtocolName,ProtocolHandler,ProtocolHandlerIcon="") {
	;Admin rights possibly required
	
	;Check URI RegKey Existance
	RegRead,x_tempvar,HKEY_CLASSES_ROOT,%ProtocolName%
	if !ErrorLevel
		return 2048
	
	;Write URI RegKey
	StringUpper,uProtocolName,ProtocolName
	RegWrite,REG_SZ,HKEY_CLASSES_ROOT,%ProtocolName%,URL Protocol
	RegWrite,REG_SZ,HKEY_CLASSES_ROOT,%ProtocolName%,,URL:%uProtocolName% Protocol
	RegWrite,REG_SZ,HKEY_CLASSES_ROOT,%ProtocolName%\DefaultIcon
	if !ProtocolHandlerIcon
		RegWrite,REG_SZ,HKEY_CLASSES_ROOT,%ProtocolName%\DefaultIcon,,"%ProtocolHandler%",1
	else
		RegWrite,REG_SZ,HKEY_CLASSES_ROOT,%ProtocolName%\DefaultIcon,,"%ProtocolHandlerIcon%"
	RegWrite,REG_SZ,HKEY_CLASSES_ROOT,%ProtocolName%\shell
	RegWrite,REG_SZ,HKEY_CLASSES_ROOT,%ProtocolName%\shell\open
	RegWrite,REG_SZ,HKEY_CLASSES_ROOT,%ProtocolName%\shell\open\command
	RegWrite,REG_SZ,HKEY_CLASSES_ROOT,%ProtocolName%\shell\open\command,,"%ProtocolHandler%" "`%1"
	return !ErrorLevel
}