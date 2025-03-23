#Persistent
#SingleInstance Force
#NoEnv

IniFile := "level0_path.ini"

; Load saved path or set default
IniRead, level0Exe, %IniFile%, Settings, Path, % "C:\Program Files (x86)\Roblox\Versions\version-*\RobloxPlayerBeta.exe"

Gui, Font, s10, Verdana  ; Better font
Gui, Add, Text, x20 y15, 🔹 Enter level0 Path:
Gui, Add, Edit, vlevel0Path w400 x20 y40, %level0Exe%
Gui, Add, Button, gSavePath w100 h30 x20 y80, 💾 Save
Gui, Add, Button, gStartlevel0 w150 h30 x130 y80, 🚀 Start level0
Gui, Add, Button, gExitApp w80 h30 x290 y80, ❌ Exit
Gui, Show, AutoSize Center, level0 Launcher
Return

SavePath:
Gui, Submit, NoHide
IniWrite, %level0Path%, %IniFile%, Settings, Path
MsgBox, ✅ Path Saved!
Return

Startlevel0:
Gui, Submit, NoHide
Launchlevel0(level0Path)

Return

Launchlevel0(level0Exe)
{
    Process, Exist, RobloxPlayerBeta.exe
    If !ErrorLevel
    {
        Run, %level0Exe% --app, , UseErrorLevel
        Sleep, 5000  ; Wait for level0 to open
    }

    level0Title := "ahk_exe RobloxPlayerBeta.exe"

    ; Wait for level0 window
    Loop 10
    {
        hwnd := WinExist(level0Title)
        If (hwnd)
            Break
        Sleep, 500
    }

    If !hwnd
    {
        MsgBox, ❌ level0 Window Not Found!
        ExitApp
    }

    ; Create GUI
    Gui, +Resize +MinSize
    Gui, Show, w1024 h768, level0

    ; Embed level0 window inside AHK GUI
    Gui +LastFound
    ahkGui := WinExist()
    DllCall("SetParent", "uint", hwnd, "uint", ahkGui)

    ; Resize level0 window inside GUI
    SetTimer, Resizelevel0, 100
}

Resizelevel0:
    Gui, +LastFound
    ahkGui := WinExist()
    WinGetPos, gx, gy, gw, gh, ahk_id %ahkGui%
    WinMove, ahk_id %hwnd%, , gx, gy, gw, gh
Return

ExitApp:
ExitApp
