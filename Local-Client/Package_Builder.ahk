;Package Builder

Attributes:={name:			"A short/abbreviated version of the full name (Should be a valid AutoHotkey identifier)"
			,version:		"Package version (must follow AHK-flavored Semantic Versioning)"
			,type:			"Package type (lib, tool, other)"
			,ahkbranch:		"AutoHotkey branch the package is developed for (v1.1, v2-alpha, ahk_h, ...)"
			,ahkversion:	"Version number of AutoHotkey the package was developed with"
			,ahkflavour:	"Comma-separated list of supported AutoHotkey flavours (a32, u32, u64)"
			,fullname:		"The full human-friendly name of the package"
			,description:	"Description of the package"
			,author:		"The author(s) of the package"
			,license:		"(Optional) Name of the license under which the package is released"
			,category:		"See ""Package categories"" below"
			,forumurl:		"(Optional, Recommended) ahkscript.org forum topic URL"
			,screenshot:	"(Optional) Filename of the screenshot to be displayed"}
Categories =
(RTrim Join
Arrays|Call|COM|Console|Control|Dynamic|Database|DateTime|
Editor|Encryption|File|FileSystem|Format|Graphics|Gui|INI|
Hardware|Hash|Hotstrings|JSON|Keyboard|Math|Media|Memory|
Menu|Network|Objects|Parser|Process|Regular Expressions|Sound|
Strings|System|Text|Variables|Window|Windows|YAML|Other
)

; "Standard" ASPDM Header
Gui, Font, s16 wBold, Arial
Gui, Add, Picture, x12 y8 w32 h-1, res\ahk.png
Gui, Add, Text, x+4 yp+4 , ASPDM
Gui, Font
Gui, Add, Text, yp+5 x+12, AHKScript.org's Package/StdLib Distribution and Management

GuiLeft:=12
GuiTab:=6
GuiDispBlock:="x" GuiLeft
GuiDispInline:="yp x+" GuiTab
Gui, +HWNDhGUI
Gui, Add, Edit, vname %GuiDispBlock%,
Gui, Add, Edit, vversion %GuiDispInline%,
Gui, Add, Edit, vfullname %GuiDispInline%,
Gui, Add, Edit, vahkbranch %GuiDispBlock%,
Gui, Add, Edit, vahkversion %GuiDispInline%,
Gui, Add, Edit, vahkflavour %GuiDispInline%,
Gui, Add, Edit, vdescription %GuiDispBlock%,
Gui, Add, Edit, vauthor %GuiDispInline%,
Gui, Add, Edit, vlicense %GuiDispInline%,
Gui, Add, Edit, vforumurl %GuiDispBlock%,
Gui, Add, Edit, vscreenshot %GuiDispInline%,
Gui, Add, Text, yp+3 x+4, Type
Gui, Add, DropDownList, vtype x+4 yp-3, Library|Tool|Other
Gui, Add, Text, %GuiDispBlock%, Category
Gui, Add, DropDownList, vCategory x+4 yp-3, %Categories%
Gui, Add, Button, yp-1 x+24 Default, Select Files...
Gui, Add, Button, %GuiDispInline%, Save JSON
Gui, Add, Button, %GuiDispInline%, Build Package

;Add placeholders - supported since Windows XP
SetEditPlaceholder("name","name")
SetEditPlaceholder("version","version")
SetEditPlaceholder("type","type")
SetEditPlaceholder("ahkbranch","ahkbranch")
SetEditPlaceholder("ahkversion","ahkversion")
SetEditPlaceholder("ahkflavour","ahkflavour")
SetEditPlaceholder("fullname","fullname")
SetEditPlaceholder("description","description")
SetEditPlaceholder("author","author")
SetEditPlaceholder("license","license")
SetEditPlaceholder("forumurl","forumurl")
SetEditPlaceholder("screenshot","screenshot")

Gui, Show,, ASPDM - Package Creation
ControlFocus, Button1, ahk_id %hGUI%
return

GuiClose:
ExitApp