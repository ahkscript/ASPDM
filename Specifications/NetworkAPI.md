ASPDM Network API (WIP)
==========================

API temporarily hosted @ `api-php.aspdm.tk` or `aspdm.tk/api-php`  
See https://trello.com/c/V27ITnHO/16-web-server-api  
  
## API Status
`status.php` - _Check and validate if API is available_  
**Usage:** `?_c=CHECKSTRING`  
It returns a JSON string in the following structure :  
```JSON
{
	"api": {
		"name": "aspdm",
		"check": "CHECKSTRING"
	}
}
```  
If `CHECKSTRING` is uppercase/lowercase, the return is **case-sensitive**.  
  
## Package Details
`info.php` - _Get JSON info from a package in "packs/"_  
**Usage:** `?f=FILENAME&c=JSONITEM`  
If `JSONITEM` is specified, it returns a normal string.  
Otherwise, a JSON string is returned.  

## Package Listing	
`list.php` - _List all files in "packs/"_  
**Usage:** `?full`, `?sort`, `?lim=TOTAL&origin=START`, _or_ no arguments  
If `?full` is used, a JSON string is returned containing all Metadata of all available packages.  
If `?lim` is used, a JSON string is returned with all Metadata of `TOTAL` packages, starting from `START`.  
Otherwise, it returns a simple list of all packages seperated by `\n` (line feed).  
In any case, `?sort` can be used for [Natural sorting](http://www.php.net/manual/en/function.natsort.php).  
By default, packages are sorted by modification date.  
  
## Note
Packages are temporarily hosted @ `packs.aspdm.tk` or `aspdm.tk/packs`  
Packages that are waiting to be "validated" are stored @ `packs.aspdm.tk/tmp` or `aspdm.tk/packs/tmp`
