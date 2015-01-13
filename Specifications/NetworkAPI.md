ASPDM Network API (WIP)
==========================

API is currently hosted @ `api-php.aspdm.2fh.co` or `aspdm.2fh.co/api-php`  
See https://trello.com/c/V27ITnHO/16-web-server-api  
  
## API Status
_Check and validate if API is available._  
  
**Usage:** `status.php?_c=CHECKSTRING`  
  
It returns a JSON string in the following structure :  
```JSON
{
	"api": {
		"name": "aspdm",
		"check": "CHECKSTRING"
	}
}
```  
- If `CHECKSTRING` is uppercase/lowercase, the return is **case-sensitive**.  
  
## Package Details
_Get JSON info from a listed package._  
  
**Usage:** `info.php?f=FILENAME&c=JSONITEM`  
  
- If `JSONITEM` is specified, it returns a normal string.  
Otherwise, a JSON string is returned.  

## Package Listing	
_List available packages._  
  
**Usage:** `list.php?full&sort&lim=TOTAL&origin=START`, _or_ no arguments  
  
- If `?full` is used, a JSON string is returned containing all Metadata of all available packages.  
- If `?lim` is used, a JSON string is returned with all Metadata of `TOTAL` packages, starting from `START`.  
- Otherwise, it returns a simple list of all packages seperated by `\n` (line feed).  
- In any case, `?sort` can be used for [Natural sorting](http://www.php.net/manual/en/function.natsort.php).  
- By default, packages are sorted by modification date.  
  
## Note
- Packages are currently hosted @ `packs.aspdm.2fh.co` or `aspdm.2fh.co/packs`  
- Packages that are waiting to be "validated" are stored @ `packs.aspdm.2fh.co/tmp` or `aspdm.2fh.co/packs/tmp`
