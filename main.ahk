#Requires AutoHotkey v2.0
#SingleInstance Force

#Include G:\AHK\git-ahk-lib\Extend.ahk
#Include G:\AHK\git-ahk-lib\Tip.ahk
#Include G:\AHK\git-ahk-lib\extend\HotStringEx.ahk
#Include G:\AHK\git-ahk-lib\util\log\log.ahk
#Include G:\AHK\git-ahk-lib\util\AhkCmdLine.ahk
#Include G:\AHK\git-ahk-lib\util\Fs.ahk

#Hotstring EndChars `t `n.';/
TraySetIcon "./Meow.ico"

#Include lightCtrl.ahk
#Include mediaCtrl.ahk
#Include quickLook.ahk
#Include simpleMove.ahk
#Include volumeCtrl.ahk
#Include blockMouse.ahk
#Include windowTopCtrl.ahk
#Include setDesktopIconState.ahk

CoordMode "ToolTip", "Screen"
CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Screen"

tray := A_TrayMenu
tray.delete()
  , tray.add('Folder', (*) => Run(A_ScriptDir))
  , tray.add('Log', (*) => Run('.\_log.txt'))

sm := Menu()
tray.add('use', sm)
  , tray.add()
  , tray.add('Reload', (*) => Reload())
  , tray.add('Exit', (*) => ExitApp())
  , tray.Default := 'Log'

Filter(v) {
  SplitPath(v, , , &ext)
  _p := StrSplit(v)[1]
  return _p != '.' && _p != '_' && ext = 'ahk'
}
fList := FS.ReadDir('./scripts', Filter)
fList.foreach(v => sm.Add(v, (v, *) => (Sleep(300), Run('.\scripts\' v))))

$LAlt:: {  ; 
  if A_PriorHotkey = A_ThisHotkey && A_TimeSincePriorHotkey < 5
    return
  Send('{LAlt Down}'), KeyWait('LAlt'), Send('{LAlt Up}')
}

main_actions := [
  ['Date', (*) => SendInput(FormatTime(, "yyyy/MM/dd"))],
  ['Time', (*) => SendInput(FormatTime(, "HH:mm:ss"))]
]
hse := HotStringEx('~;', 1)
hse.Register(main_actions*)
::;datetime:: {
  SendInput(FormatTime(, "yyyy/MM/dd_HH:mm:ss/tt"))
}

+!Pause:: {
  CoordMode "Mouse", "Window"
  MouseGetPos &PosX, &PosY
  CoordMode "Mouse", "Screen"
  MouseGetPos &xpos, &ypos
  raw := "S:" xpos A_Space ypos "   W:" PosX A_Space PosY
    . "`nP:" PixelGetColor(xpos, ypos, "Slow") "  I:" WinGetID("A")
    . "`nC:" WinGetClass("A")
    . "`nT:" WinGetTitle("A")
  CoordMode "Mouse", "Window"
  Tip.ShowTip(raw, xpos + 15, ypos + 15, 8000)
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

logger := Log('.\_log.txt')
; logger.slient := true
if InStr(ParseCmdLine(GetCommandLine()).switchs.Join(), '/restart')
  logger.Info('RESTART')
else {
  logger.Info('Script Start')
  OnExit((*) => logger.Info('Script Exit'))
}

<+<!q:: Run('.\scripts\_windowTransparentCtrl.ahk')
!7:: Run('.\scripts\colorThief.ahk')

#Include G:\AHK\_SELF\meow.ahk       ; some private data
