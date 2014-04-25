ASPDM Network API (WIP)
==========================

API temporarily hosted @ `api-php.aspdm.tk`  
See https://trello.com/c/V27ITnHO/16-web-server-api  
  
`info.php` - _Get JSON info from a package in "packs/"_  
	**Usage:** `?f=FILENAME&c=JSONITEM`  
	If `JSONITEM` is specified, it returns a normal string.  
	Otherwise, a JSON string is returned.  
	
`list.php` - _List all files in "packs/"_  
	**Usage:** no arguments  
	Returns a list of all packages seperated by `\n` (line feed)  
  
Packages are temporarily hosted @ `packs.aspdm.tk`  
Packages that are waiting to be "validated" are stored @ `packs.aspdm.tk/tmp`
