#Persistent 
#SingleInstance Force
SetBatchLines -1
ListLines Off

RealFile := "C:\ProgramData\Level0.ahk"
ScriptURL := "https://raw.githubusercontent.com/mepro123/LevelZero/refs/heads/main/Lvl0.ahk"
Website := "https://github.com/mepro123/LevelZero/releases"

; Create GUI for Bootstrapper
Gui, +Resize +MinSize +MaxSize ; Allow resizing but restrict small/large sizes
Gui, Font, s12, Arial
Gui, Color, 1e1e2e  ; Set background to dark mode

; Header Text
Gui, Add, Text, x20 y20 w280 h30 vStatus cWhite, Welcome to Level0!
Gui, Add, Text, x20 y60 w280 h60 cWhite, Saved in %programdata%              Bootstrapper V1.0

; Download Progress (Initially Hidden)
Gui, Add, Text, x20 y100 w250 h30 vDownloadingText cWhite, 
Gui, Add, Progress, x20 y130 w250 h20 vProgressBar, 0

; Buttons
Gui, Add, Button, x20 y170 w120 h30 gDownloadScript vDownloadBtn cWhite, 📥Install Level0
Gui, Add, Button, x20 y170 w120 h30 gStartLevel0 vLaunchBtn cWhite Hidden, ▶️Launch Level0
Gui, Add, Button, x150 y170 w120 h30 gUninstall cWhite, ❌Uninstall
Gui, Add, Button, x20 y210 w250 h30 gBrowseFiles cWhite, 📂 Browse Files

Gui, Show, w300 h260, 𝕃𝕖𝕧𝕖𝕝𝟘

; If file exists, show the Launch button instead of Download
If FileExist(RealFile) {
    GuiControl, Hide, DownloadBtn
    GuiControl, Show, LaunchBtn
}

return

DownloadScript:
    ; Show downloading text
    GuiControl,, DownloadingText, ↻Downloading Level0...
    GuiControl,, ProgressBar, 0
    Sleep, 500  ; Small delay

    ; Create HTTP Request (Using ServerXMLHTTP to fix errors)
    pHTTP := ComObjCreate("MSXML2.ServerXMLHTTP")
    pHTTP.Open("GET", ScriptURL, false)
    pHTTP.Send()

    ; Get the script content
    ScriptContent := pHTTP.ResponseText

    Loop, 100 {
        GuiControl,, ProgressBar, %A_Index%
        Random, sleepTime, 10,10
        GuiControl,, DownloadingText, ↺Downloading Level0...
        Sleep, %sleepTime%
        GuiControl,, DownloadingText, ↻Downloading Level0...
    }
    
    ; Write to file
    FileDelete, %RealFile%  
    FileAppend, %ScriptContent%, %RealFile%  

    ; Update UI After Download
    Run, %Website%
    GuiControl,, ProgressBar, 100
    GuiControl,, DownloadingText, Download Complete!
    
    ; Switch to Launch button
    GuiControl, Hide, DownloadBtn
    GuiControl, Show, LaunchBtn
return

StartLevel0:
    Run, %RealFile%
    ExitApp

Uninstall:
    If FileExist(RealFile) {
        FileDelete, %RealFile%
        MsgBox, Level0 has been uninstalled successfully.
        GuiControl,, ProgressBar, 0
        ; Show Download button again
        GuiControl, Hide, LaunchBtn
        GuiControl, Show, DownloadBtn
    } else {
        MsgBox, Level0 is not installed.
    }
return

BrowseFiles:
    FileSelectFile, SelectedFile
    if (SelectedFile) {
        MsgBox, You selected: %SelectedFile%
    }
return

ExitApp:
    ExitApp
