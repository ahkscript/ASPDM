Install := { Error_NonAdministrator:	0x01
			,Error_InvalidParameters:	0x02
			,Error_NonExistantFile:		0x03
			,Error_NonExistantDir:		0x04
			,Error_Extraction:			0x05
			,Error_CopyToStdLib:	 	0x06
			,Error_CreateRepoDir:		0x07
			,Error_CreateRepoSubDir:	0x08
			,Error_CreateArchiveDir:	0x09
			,Error_ArchiveBackup:		0x0A
			,Error_DeleteStdLib:		0x0B
			,Error_DeleteRepoSubDir:	0x0C
			,Error_RunInstaller: "ERROR"
			,Success: 0x21 } ;random chosen value
Install_ExitCode(e) {
	global Install
	for i, code in Install
		if (e==code)
			return i
	return "Error_Unknown"
}