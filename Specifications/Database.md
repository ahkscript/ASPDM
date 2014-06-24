ASPDM Database (WIP)
====================

Package metadata format
-----------------------

The package metadata (manifest) format is a [JSON](http://www.json.org/) document. The package repository (aka database) format is a JSON array of package metadata documents.

_**All attributes are mandatory, unless otherwise stated.**_

| Attribute     | Description                                                                                |
|---------------|--------------------------------------------------------------------------------------------|
| id            | A short name used for identification purposes (Should be a valid AutoHotkey identifier)    |
| version       | Package version (must follow AHK-flavored Semantic Versioning)                             |
| type          | Package type (`lib`, `tool`, `other`)                                                      |
| ahkbranch     | AutoHotkey branch the package is developed for (`v1.1`, `v2-alpha`, `ahk_h`, ...)          |
| ahkversion    | Version number of AutoHotkey the package was developed with (**Internal**, **Automatic**)  |
| ahkflavour    | Comma-separated list of supported AutoHotkey flavours (`a32`, `u32`, `u64`)                |
| required      | Comma-separated list of dependencies' package identifiers (leave empty if none)            |
| name          | The human-friendly name of the package                                                     |
| description   | Description of the package (**Optional**, **Recommended**)                                 |
| author        | The author(s) of the package                                                               |
| license       | (**Optional**) Name of the license under which the package is released                     |
| tags          | Comma-separated tags (**Optional**, **Recommended**)                                       |
| forumurl      | (**Optional**, **Recommended**) ahkscript.org forum topic URL                              |
| screenshot    | (**Optional**) Filename of the screenshot to be displayed                                  |

_**Licenses :**_ packages submitted to ahkscript.org without the license attribute filled in are assumed to be released under the [ahkscript.org Default Package License](License.md).

### Package Repository-only attributes

| Attribute     | Description                                                                                                         |
|---------------|---------------------------------------------------------------------------------------------------------------------|
| isstdlib      | (**Internal**, **Moderated**) True if the package has been selected to be part of the official StdLib distribution  |

### Recommended tags (Examples)

| Categories  |             |                      |
|-------------|-------------|----------------------|
| Arrays      | Graphics    | Network              |
| Call        | Gui         | Objects              |
| COM         | INI         | Parser               |
| Console     | Hardware    | Process              |
| Control     | Hash        | Regular Expressions  |
| Dynamic     | Hotstrings  | Sound                |
| Database    | JSON        | Strings              |
| DateTime    | Keyboard    | System               |
| Editor      | Math        | Text                 |
| Encryption  | Media       | Variables            |
| File        | Memory      | Window               |
| FileSystem  | Menu        | YAML                 |
| Format      | MS Windows  | Other                |

Package Structure
-------------------

### 'Library' packages

Library packages should have a standard package structure consisting of the following folders:

- `Lib\` (*Mandatory*) : StdLib files
- `Doc\` : Documentation
- Root folder : Examples, etc.

_Note:_ When installing a package into a StdLib folder, the files in the package's `Lib\` folder would be copied to it.

### 'Tool/Other' packages

Tool/Other packages should have a standard package structure consisting of the following:

- `Install.ahk` (*Mandatory*) : Executed on package installation
- `Remove.ahk` (*Mandatory*) : Executed on package removal
- `Execute.ahk` (*Mandatory*) : Execute the tool
- `Doc\` : Documentation
- Root folder : Examples, etc.

Package File Format
-------------------

The packages will have the `.ahkp` file extension.
The compression format is `LZNT` (a.k.a [LZ compression](http://msdn.microsoft.com/library/ff552127)).
The [Magic Number](https://en.wikipedia.org/wiki/Magic_number_(programming)) is `AHKPKG00`.
The uncompressed `JSON` metadata is stored at offset `0xC`, with its string length stored as a `UInt` at offset `0x8` (Right after the magic number).
