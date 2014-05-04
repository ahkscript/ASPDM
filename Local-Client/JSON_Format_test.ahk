FileRead,JSON, % "Test_Packages\samples\package.json"
MsgBox % j:=JSON_Beautify(JSON,3)
MsgBox % JSON_Uglify(j)
