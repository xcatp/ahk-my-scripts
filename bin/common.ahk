/*
此文件用于打包成exe，方便在非本机环境下使用；
（相比主脚本包含的功能少很多）
*/

#Requires AutoHotkey v2.0
#SingleInstance Force

#Include G:\AHK\git-ahk-lib\Extend.ahk
#Include G:\AHK\git-ahk-lib\Tip.ahk

#Hotstring EndChars `t `n.';/

#Include ../simpleMove.ahk
#Include ../windowTopCtrl.ahk

CoordMode "ToolTip", "Screen"
CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Screen"

tray := A_TrayMenu
  , tray.delete()
  , tray.add('Reload', (*) => Reload())
  , tray.add('Exit', (*) => ExitApp())

$LAlt:: {
  if A_PriorHotkey = A_ThisHotkey && A_TimeSincePriorHotkey < 5
    return
  Send('{LAlt Down}'), KeyWait('LAlt'), Send('{LAlt Up}')
}

*<+<!LButton:: {
  CoordMode "Mouse", "Screen"
  MouseGetPos(&px, &py), WinGetPos(&wx, &wy, , , 'A')
  dx := wx - px, dy := wy - py
  SetWinDelay -1
  While GetKeyState("LButton", "P")
    MouseGetPos(&nx, &ny), WinMove(nx + dx, ny + dy, , , "A")
  if (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 300)
    try WinMaximize('A')
}