Install := { Error_NonAdministrator: 0x01
			,Error_InvalidParameters: 0x02
			,Error_NonExistantFile: 0x03
			,Error_Extraction: 0x04
			,Error_RunInstaller: "ERROR"
			,Success: 0x21} ;random chosen value
Install_ExitCode(e) {
	global Install
	for i, code in Install
		if (e==code)
			return i
	return "Error_Unknown"
}