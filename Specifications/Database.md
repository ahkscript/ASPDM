ASPDM Database (WIP)
====================

Package metadata format
-----------------------

The package metadata (manifest) format is a [JSON](http://www.json.org/) document. The package repository (aka database) format is a JSON array of package metadata documents.

_**All attributes are mandatory, unless otherwise stated.**_

| Attribute     | Description                                                                            |
|---------------|----------------------------------------------------------------------------------------|
| id            |A short name used for identification purposes (Should be a valid AutoHotkey identifier) |
| version       | Package version (must follow AHK-flavored Semantic Versioning)                         |
| type          | Package type (`lib`, `tool`, `other`)                                                  |
| ahkbranch     | AutoHotkey branch the package is developed for (`v1.1`, `v2-alpha`, `ahk_h`, ...)      |
| ahkversion    | Version number of AutoHotkey the package was developed with                            |
| ahkflavour    | Comma-separated list of supported AutoHotkey flavours (`a32`, `u32`, `u64`)            |
| name          | The human-friendly name of the package                                                 |
| description   | Description of the package                                                             |
| author        | The author(s) of the package                                                           |
| license       | (**Optional**) Name of the license under which the package is released                 |
| category      | See "**Package categories**" below                                                     |
| forumurl      | (**Optional**, **Recommended**) ahkscript.org forum topic URL                          |
| screenshot    | (**Optional**) Filename of the screenshot to be displayed                              |

_**Licenses:**_ packages submitted to ahkscript.org without the license attribute filled in are assumed to be released under the ahkscript.org Default Package License.

### Package Repository-only attributes

| Attribute     | Description                                                                                                        |
|---------------|--------------------------------------------------------------------------------------------------------------------|
| isstdlib      | (**Internal**, **Moderated**) True if the package has been selected to be part of the official StdLib distribution |
| filename      | Filename of the package (used during downloading)                                                                  |

### Package categories

| Categories  |             |                      |
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

Package File Format
-------------------

[to do] .ahkp file extension, etc...
Compression method?...