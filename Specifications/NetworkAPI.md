ASPDM Network API (WIP)
====================

API temporarily hosted @ api-php.aspdm.1eko.com  
See https://trello.com/c/V27ITnHO/16-web-server-api  
  
`info.php`	--	Get JSON info from a package in "packs/"
	**Usage:** `?f=FILENAME&c=JSONITEM`
	If `JSONITEM` is specified, it returns a normal string.
	Otherwise, a JSON string is returned.
	
`list.php`	--	List all files in "packs/"
	**Usage:** no arguments
	Returns a list of all packages seperated by '`n'
	
`submit.php`	--	Used for the online upload form
	**Usage:** no arguments
  
Packages are temporarily hosted @ packs.aspdm.1eko.com  
Packages that are waiting to be "validated" are stored @ packs.aspdm.1eko.com/tmp