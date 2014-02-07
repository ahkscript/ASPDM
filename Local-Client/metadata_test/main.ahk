#SingleInstance, Ignore
#Include pack.ahk

FileRead,MData,package.json
files:="Package_Files"
archive:="pack.ahkp"
outdir:="unpacked"

7z_Compress(archive,files)
add_metadata(archive,mdata)
MsgBox % get_metadata(archive)
MsgBox, 36, , Unpack %archive% ?
IfMsgBox,Yes
	if (7z_extract(archive,outdir))
		MsgBox Extraction successful!