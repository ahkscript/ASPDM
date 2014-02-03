ASPDM Database (Non final version)
===============================

Metadata
--------------------------

The database format is [JSON (JavaScript Object Notation)](http://www.json.org/).  
An [open standard](http://en.wikipedia.org/wiki/Open_standard) and [human-readable](http://en.wikipedia.org/wiki/Human-readable) data interchange format.

|     Items     |                            Description                              |
|---------------|---------------------------------------------------------------------|
| name          | A short/abbreviated version of the full name                        |
| fullname      | The full name of the package                                        |
| author        | The author(s) of the package                                        |
| authorurl     | The author(s) homepage/webpage (**Optional**)                       |
| description   | Description of the package                                          |
| license       | The package's "copyright" terms (**Optional**)                      |
| version       | Version of the package (must follow Ahk Lib v3 versioning)          |
| type          | Type of package (Library, Function, Tool, Other)                    |
| category      | See "**Categories**" below                                          |
| forumurl      | Forum topic's URL at ahkscript.org (**Optional**, **Recommended**)  |
| packageurl    | The Package's download URL (**Only** for online package listing)    |
| screenshoturl | URL to a screenshot to be displayed (**Optional**)                  |
| ahkversion    | The minimal version of autohotkey to run the package                |
| isstdlib      | True if the package is part of stdlib (**Internal**, **Moderated**) |

_**All fields are mandatory, unless otherwise stated.**_

| Categories                                       |
|-------------|-------------|----------------------|
| Arrays      | Graphics    | Objects              |
| Call        | Gui         | Parser               |
| COM         | INI         | Process              |
| Console     | Hardware    | Regular Expressions  |
| Control     | Hash        | Sound                |
| Dynamic     | Hotstrings  | Strings              |
| Database    | JSON        | System               |
| DateTime    | Keyboard    | Text                 |
| Editor      | Math        | Variables            |
| Encryption  | Media       | Window               |
| File        | Memory      | Windows              |
| FileSystem  | Menu        | YAML                 |
| Format      | Network     | Other                |

Packaging / Archive ?
--------------------------------

[to do] .ahkp file extension, etc...
?...