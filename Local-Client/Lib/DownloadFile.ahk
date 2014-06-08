; Script by brutosozialprodukt
; http://ahkscript.org/boards/viewtopic.php?f=6&t=1674

; Revision: joedf
; Changes:  - Changed progress bar style & colors
;           - Changed Display Information
;           - Commented-out Size calculation
;           - Added ShortURL()
;           - Added short delay 100 ms to show the progress bar if download was too fast
;           - Added ProgressBarTitle
;           - Try-Catch "backup download code"
; ----------------------------------------------------------------------------------

DownloadFile(UrlToFile, SaveFileAs, Overwrite := True, UseProgressBar := True, ProgressBarTitle:="Downloading...") {
    ;Check if the file already exists and if we must not overwrite it
      If (!Overwrite && FileExist(SaveFileAs))
          Return
    ;Check if the user wants a progressbar
      If (UseProgressBar) {
          _surl:=ShortURL(UrlToFile)
          ;Initialize the WinHttpRequest Object
            WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
          ;Download the headers
            WebRequest.Open("HEAD", UrlToFile)
            WebRequest.Send()
          ;Store the header which holds the file size in a variable:
          try
            FinalSize := WebRequest.GetResponseHeader("Content-Length")
          catch
          {
            ;throw Exception("could not get Content-Length for URL: " UrlToFile)
            Progress, CWFEFEF0 CT111111 CB468847 w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11, , %ProgressBarTitle%, %_surl%
            UrlDownloadToFile, %UrlToFile%, %SaveFileAs%
            Sleep 100
            Progress, Off
            return
          }
          ;Create the progressbar and the timer
            Progress, CWFEFEF0 CT111111 CB468847 w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11, , %ProgressBarTitle%, %_surl%
            SetTimer, __UpdateProgressBar, 100
      }
    ;Download the file
      UrlDownloadToFile, %UrlToFile%, %SaveFileAs%
    ;Remove the timer and the progressbar because the download has finished
      If (UseProgressBar) {
          Sleep 100
          Progress, Off
          SetTimer, __UpdateProgressBar, Off
      }
    Return
    
    ;The label that updates the progressbar
      __UpdateProgressBar:
         ;Get the current filesize and tick
            CurrentSize := FileOpen(SaveFileAs, "r").Length ;FileGetSize wouldn't return reliable results
            CurrentSizeTick := A_TickCount
          ;Calculate the downloadspeed
            ;Speed := Round((CurrentSize/1024-LastSize/1024)/((CurrentSizeTick-LastSizeTick)/1000)) . " Kb/s"
          ;Save the current filesize and tick for the next time
            ;LastSizeTick := CurrentSizeTick
            ;LastSize := FileOpen(SaveFileAs, "r").Length
          ;Calculate percent done
            PercentDone := Round(CurrentSize/FinalSize*100)
          ;Update the ProgressBar
          _csize:=Round(CurrentSize/1024,1)
          _fsize:=Round(FinalSize/1024)
            Progress, %PercentDone%, Downloading:  %_csize% KB / %_fsize% KB  [ %PercentDone%`% ], %_surl%
      Return
}

ShortURL(p,l=50) {
    VarSetCapacity(_p, (A_IsUnicode?2:1)*StrLen(p) )
    DllCall("shlwapi\PathCompactPathEx"
        ,"str", _p
        ,"str", p
        ,"uint", abs(l)
        ,"uint", 0)
    return _p
}