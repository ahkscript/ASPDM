    ; http://ahk.uk.to/?p=2ae86b
	Http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    Http.Open("GET", "http://api-php.aspdm.2fh.co/list.php?full", false)
    Http.Send()
     
    ; Use Coco or VxE's JSON lib. I have Coco's lib wrapped like VxE's
    Libraries := Json_ToObj(http.ResponseText)
     
    Gui, Add, ListView, w640 h480 gMyListView, Name|Author|Version|Branch|Package
    for Package, Library in Libraries
    LV_Add("", Library.Name, Library.Author, Library.Version, Library.AHKBranch, Package)
    Loop, 5
    LV_ModifyCol(A_Index, "AutoHdr")
    Gui, Show
    return
     
    GuiClose:
    ExitApp
    return
     
    MyListView:
    if (A_GuiEvent == "DoubleClick")
    {
    LV_GetText(Package, A_EventInfo, 5)
    Run, % Libraries[Package].ForumUrl
    }
    return