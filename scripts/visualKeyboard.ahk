#Requires AutoHotkey v2.0
#SingleInstance Force

CoordMode "Mouse", "Screen"

fontSize := 14, fontName := 'Verdana'
guiBackColor := 'cfff2e6', guiProgressColor := 'cA1BE7B'
guiProgressBackColor := SubStr(guiBackColor, 2)

TrayText := ['Hide', 'Show']
m := A_TrayMenu
  , m.ClickCount := 2
  , m.Delete()
  , m.Add(TrayText[1], K_Toggle)
  , m.Add()
  , m.Add("Exit", (*) => ExitApp())
  , m.default := TrayText[1]

K_Toggle(*) {
  static flag := true
  if flag
    m.rename(TrayText[1], TrayText[2]), VK.Hide()
  else m.rename(TrayText[2], TrayText[1]), VK.Show()
  flag := !flag
}

k_KeyWidth := fontSize * 3
k_KeyHeight := fontSize * 3
k_KeyMargin := fontSize // 6
width := 15 * k_KeyWidth + 14 * k_KeyMargin
k_KeyWidthHalf := k_KeyWidth / 2
k_TabW := fontSize * 4
k_CapsW := k_KeyWidth + k_KeyMargin + k_KeyWidthHalf
k_ShiftW := 2 * k_KeyWidth + k_KeyMargin
k_SpacebarWidth := fontSize * 17
k_LastKeyWidth := width - (k_TabW + 12 * k_KeyWidth + 13 * k_KeyMargin)
k_EnterWidth := width - (k_CapsW + 11 * k_KeyWidth + 12 * k_KeyMargin)
k_LastShiftWidth := width - (k_ShiftW + 10 * k_KeyWidth + 11 * k_KeyMargin)
k_LastCtrlWidth := width - (6 * k_TabW + k_SpacebarWidth + 7 * k_KeyMargin)
k_KeySize := ' w' k_KeyWidth ' h' k_KeyHeight
k_Position := ' x+' k_KeyMargin k_KeySize
K_Pos := ' x+' k_KeyMargin ' w' k_KeyWidth - 22 ' h' k_KeyHeight

k_Characters := Map(
  "ESC", -1, "F1", -2, "F2", -3, "F3", -4, "F4", -5, "F5", -6, "F6", -7, "F7", -8, "F8", -9
  , "F9", -10, "F10", -11, "F11", -12, "F12", -13, "PRINTSCREEN", -14, "SCROLLLOCK", -15, "PAUSE", -16
  , "``", 1, '1', 2, '2', 3, '3', 4, '4', 5, '5', 6, '6', 7, '7', 8, '8', 9, '9', 10, '0', 11
  , "-", 12, "=", 13, "BACKSPACE", 14, "TAB", 15, "Q", 16, "W", 17, "E", 18, "R", 19, "T", 20
  , "Y", 21, "U", 22, "I", 23, "O", 24, "P", 25, "[", 26, "]", 27, "\", 28, "CAPSLOCK", 29
  , "A", 30, "S", 31, "D", 32, "F", 33, "G", 34, "H", 35, "J", 36, "K", 37, "L", 38, ";", 39
  , "'", 40, "ENTER", 41, "LSHIFT", 42, "Z", 43, "X", 44, "C", 45, "V", 46, "B", 47, "N", 48
  , "M", 49, ",", 50, ".", 51, "/", 52, "RSHIFT", 53, "LCTRL", 54, "LWIN", 55, "LALT", 56
  , "SPACE", 57, "RALT", 58, "RWN", 59, "APPSKEY", 60, "RCTRL", 61, "INSERT", 62, "HOME", 63
  , "PGUP", 64, "DELETE", 65, "END", 66, "PGDN", 67, "UP", 68, "LEFT", 69, "DOWN", 70, "RIGHT", 71
)

; Zero-width non-breaking space
zwnbs := Chr(8204)
labels := Map(
  "AppsKey", "App", "BackSpace", Chr(0x1F844), "CapsLock", "Caps", "Delete", "Del"
  , "End", Chr(0x21F2), "Home", Chr(0x21F1), "Insert", "Ins", "LAlt", "Alt", "LCtrl", "Ctrl"
  , "LShift", "Shift", "LWin", "Win", "PgDn", "PD", "PgUp", "PU", "RAlt", "Alt" zwnbs
  , "RCtrl", "Ctrl" zwnbs, "RShift", "Shift" zwnbs, "RWin", "Win" zwnbs, "Tab", "Tab" ;Chr(0x2B7E)
  , "Left", "◀", "Right", "▶", "Down", "▼", "Up", "▲")

class VK extends Gui {

  static insHwnd := unset

  __New() {
    super.__New('+AlwaysOnTop +ToolWindow -Caption +Border')
    this.SetFont('s' fontSize, fontName)
    this.BackColor := guiBackColor
    ; 0
    this.AddProgress('Section Disabled vprg-1 xm ym ' k_Position)
    this.AddProgress('Disabled ' k_Position)
    this.AddProgress('Disabled vprg-2 ' k_Position), this.AddProgress('Disabled vprg-3 ' k_Position)
    this.AddProgress('Disabled vprg-4 ' k_Position), this.AddProgress('Disabled vprg-5 ' k_Position)
    this.AddProgress('Disabled ' k_Pos)
    this.AddProgress('Disabled vprg-6 ' k_Position), this.AddProgress('Disabled vprg-7 ' k_Position)
    this.AddProgress('Disabled vprg-8 ' k_Position), this.AddProgress('Disabled vprg-9 ' k_Position)
    this.AddProgress('Disabled ' k_Pos)
    this.AddProgress('Disabled vprg-10 ' k_Position), this.AddProgress('Disabled vprg-11 ' k_Position)
    this.AddProgress('Disabled vprg-12 ' k_Position), this.AddProgress('Disabled vprg-13 ' k_Position)
    this.AddProgress('Disabled ' k_Position)
    this.AddProgress('Disabled vprg-14 ' k_Position)
    this.AddProgress('Disabled vprg-15 ' k_Position), this.AddProgress('Disabled vprg-16 ' k_Position)
    ; 1
    this.AddProgress('Disabled vprg1 xs y+' k_KeyMargin k_KeySize)
    this.AddProgress('Disabled vprg2 ' k_Position), this.AddProgress('Disabled vprg3 ' k_Position)
    this.AddProgress('Disabled vprg4 ' k_Position), this.AddProgress('Disabled vprg5 ' k_Position)
    this.AddProgress('Disabled vprg6 ' k_Position), this.AddProgress('Disabled vprg7 ' k_Position)
    this.AddProgress('Disabled vprg8 ' k_Position), this.AddProgress('Disabled vprg9 ' k_Position)
    this.AddProgress('Disabled vprg10 ' k_Position), this.AddProgress('Disabled vprg11 ' k_Position)
    this.AddProgress('Disabled vprg12 ' k_Position), this.AddProgress('Disabled vprg13 ' k_Position)
    this.AddProgress('Disabled vprg14 x+' k_KeyMargin ' w' k_ShiftW ' h' k_KeyHeight)
    this.AddProgress('Disabled ' k_Position), this.AddProgress('Disabled vprg62 ' k_Position)
    this.AddProgress('Disabled vprg63 ' k_Position), this.AddProgress('Disabled vprg64 ' k_Position)
    ; 2
    this.AddProgress('Disabled vprg15 xs y+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight)
    this.AddProgress('Disabled vprg16 ' k_Position), this.AddProgress('Disabled vprg17 ' k_Position)
    this.AddProgress('Disabled vprg18 ' k_Position), this.AddProgress('Disabled vprg19 ' k_Position)
    this.AddProgress('Disabled vprg20 ' k_Position), this.AddProgress('Disabled vprg21 ' k_Position)
    this.AddProgress('Disabled vprg22 ' k_Position), this.AddProgress('Disabled vprg23 ' k_Position)
    this.AddProgress('Disabled vprg24 ' k_Position), this.AddProgress('Disabled vprg25 ' k_Position)
    this.AddProgress('Disabled vprg26 ' k_Position), this.AddProgress('Disabled vprg27 ' k_Position)
    this.AddProgress('Disabled vprg28 x+' k_KeyMargin ' w' k_LastKeyWidth ' h' k_KeyHeight)
    this.AddProgress('Disabled ' k_Position), this.AddProgress('Disabled vprg65 ' k_Position)
    this.AddProgress('Disabled vprg66 ' k_Position), this.AddProgress('Disabled vprg67 ' k_Position)
    ; 3
    this.AddProgress('Disabled vprg29 xs y+' k_KeyMargin ' w' k_CapsW ' h' k_KeyHeight)
    this.AddProgress('Disabled vprg30 ' k_Position), this.AddProgress('Disabled vprg31 ' k_Position)
    this.AddProgress('Disabled vprg32 ' k_Position), this.AddProgress('Disabled vprg33 ' k_Position)
    this.AddProgress('Disabled vprg34 ' k_Position), this.AddProgress('Disabled vprg35 ' k_Position)
    this.AddProgress('Disabled vprg36 ' k_Position), this.AddProgress('Disabled vprg37 ' k_Position)
    this.AddProgress('Disabled vprg38 ' k_Position), this.AddProgress('Disabled vprg39 ' k_Position)
    this.AddProgress('Disabled vprg40 ' k_Position)
    this.AddProgress('Disabled vprg41 x+' k_KeyMargin ' w' k_EnterWidth ' h' k_KeyHeight)
    this.AddProgress('Disabled ' k_Position), this.AddProgress('Disabled ' k_Position)
    this.AddProgress('Disabled ' k_Position), this.AddProgress('Disabled ' k_Position)
    ; 4
    this.AddProgress('Disabled vprg42 xs y+' k_KeyMargin ' w' k_ShiftW ' h' k_KeyHeight)
    this.AddProgress('Disabled vprg43 ' k_Position), this.AddProgress('Disabled vprg44 ' k_Position)
    this.AddProgress('Disabled vprg45 ' k_Position), this.AddProgress('Disabled vprg46 ' k_Position)
    this.AddProgress('Disabled vprg47 ' k_Position), this.AddProgress('Disabled vprg48 ' k_Position)
    this.AddProgress('Disabled vprg49 ' k_Position), this.AddProgress('Disabled vprg50 ' k_Position)
    this.AddProgress('Disabled vprg51 ' k_Position), this.AddProgress('Disabled vprg52 ' k_Position)
    this.AddProgress('Disabled vprg53 x+' k_KeyMargin ' w' k_LastShiftWidth ' h' k_KeyHeight)
    this.AddProgress('Disabled ' k_Position), this.AddProgress('Disabled ' k_Position)
    this.AddProgress('Disabled vprg68 ' k_Position), this.AddProgress('Disabled ' k_Position)
    ; 5
    this.AddProgress('Disabled vprg54 xs y+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight)
    this.AddProgress('Disabled vprg55 x+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight)
    this.AddProgress('Disabled vprg56 x+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight)
    this.AddProgress('Disabled vprg57 x+' k_KeyMargin ' w' k_SpacebarWidth ' h' k_KeyHeight)
    this.AddProgress('Disabled vprg58 x+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight)
    this.AddProgress('Disabled vprg59 x+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight)
    this.AddProgress('Disabled vprg60 x+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight)

    this.AddProgress('Disabled vprg61 x+' k_KeyMargin ' w' k_LastCtrlWidth ' h' k_KeyHeight)
    this.AddProgress('Disabled ' k_Position), this.AddProgress('Disabled vprg69 ' k_Position)
    this.AddProgress('Disabled vprg70 ' k_Position), this.AddProgress('Disabled vprg71 ' k_Position)

    ; Overlay the progress bar with a button
    this.AddButton('Section xs ys ' k_KeySize, '*')
    this.AddProgress('Disabled Background' guiProgressBackColor k_Position)
    this.AddButton(k_Position, 'F1'), this.AddButton(k_Position, 'F2')
    this.AddButton(k_Position, 'F3'), this.AddButton(k_Position, 'F4')
    this.AddProgress('Disabled Background' guiProgressBackColor K_Pos)
    this.AddButton(k_Position, 'F5'), this.AddButton(k_Position, 'F6')
    this.AddButton(k_Position, 'F7'), this.AddButton(k_Position, 'F8')
    this.AddProgress('Disabled Background' guiProgressBackColor K_Pos)
    this.AddButton(k_Position, 'F9'), this.AddButton(k_Position, 'F10')
    this.AddButton(k_Position, 'F11'), this.AddButton(k_Position, 'F12')
    this.AddProgress('Disabled Background' guiProgressBackColor k_Position)
    this.AddButton(k_Position, 'PS')
    this.AddButton(k_Position, 'SL'), this.AddButton(k_Position, 'x')
    ; 1
    this.AddButton('xs y+' k_KeyMargin ' w' k_KeyWidth ' h' k_KeyHeight, '``')
    this.AddButton(k_Position, '1'), this.AddButton(k_Position, '2')
    this.AddButton(k_Position, '3'), this.AddButton(k_Position, '4')
    this.AddButton(k_Position, '5'), this.AddButton(k_Position, '6')
    this.AddButton(k_Position, '7'), this.AddButton(k_Position, '8')
    this.AddButton(k_Position, '9'), this.AddButton(k_Position, '0')
    this.AddButton(k_Position, '-'), this.AddButton(k_Position, '=')
    this.AddButton(k_Position ' w' k_ShiftW ' h' k_KeyHeight, labels.Get('BackSpace'))
    this.AddProgress('Disabled Background' guiProgressBackColor k_Position)
    this.AddButton(k_Position, 'Ins')
    this.AddButton(k_Position, labels.Get('Home')), this.AddButton(k_Position, labels.Get('PgUp'))
    ; 2
    this.AddButton('xs y+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight, labels.Get('Tab'))
    this.AddButton(k_Position, 'Q'), this.AddButton(k_Position, 'W')
    this.AddButton(k_Position, 'E'), this.AddButton(k_Position, 'R')
    this.AddButton(k_Position, 'T'), this.AddButton(k_Position, 'Y')
    this.AddButton(k_Position, 'U'), this.AddButton(k_Position, 'I')
    this.AddButton(k_Position, 'O'), this.AddButton(k_Position, 'P')
    this.AddButton(k_Position, '['), this.AddButton(k_Position, ']')
    this.AddButton('x+' k_KeyMargin ' w' k_LastKeyWidth ' h' k_KeyHeight, '\')
    this.AddProgress('Disabled Background' guiProgressBackColor k_Position)
    this.AddButton(k_Position, 'Del')
    this.AddButton(k_Position, labels.Get('End')), this.AddButton(k_Position, labels.Get('PgDn'))
    ; 3
    this.AddButton('xs y+' k_KeyMargin ' w' k_CapsW ' h' k_KeyHeight, labels.Get('CapsLock'))
    this.AddButton(k_Position, 'A'), this.AddButton(k_Position, 'S')
    this.AddButton(k_Position, 'D'), this.AddButton(k_Position, 'F')
    this.AddButton(k_Position, 'G'), this.AddButton(k_Position, 'H')
    this.AddButton(k_Position, 'J'), this.AddButton(k_Position, 'K')
    this.AddButton(k_Position, 'L'), this.AddButton(k_Position, ';')
    this.AddButton(k_Position, '`'')
    this.AddButton('x+' k_KeyMargin ' w' k_EnterWidth ' h' k_KeyHeight, 'Enter')
    this.AddProgress('Disabled Background' guiProgressBackColor k_Position)
    this.AddProgress('Disabled Background' guiProgressBackColor k_Position)
    this.AddProgress('Disabled Background' guiProgressBackColor k_Position)
    this.AddProgress('Disabled Background' guiProgressBackColor k_Position)
    ; 4
    this.AddButton('xs y+' k_KeyMargin ' w' k_ShiftW ' h' k_KeyHeight, labels.Get('LShift'))
    this.AddButton(k_Position, 'Z'), this.AddButton(k_Position, 'X')
    this.AddButton(k_Position, 'C'), this.AddButton(k_Position, 'V')
    this.AddButton(k_Position, 'B'), this.AddButton(k_Position, 'N')
    this.AddButton(k_Position, 'M'), this.AddButton(k_Position, ',')
    this.AddButton(k_Position, '.'), this.AddButton(k_Position, '/')
    this.AddButton('x+' k_KeyMargin ' w' k_LastShiftWidth ' h' k_KeyHeight, labels.Get('RShift'))
    this.AddProgress('Disabled Background' guiProgressBackColor k_Position)
    this.AddProgress('Disabled Background' guiProgressBackColor k_Position)
    this.AddButton(k_Position, labels.Get('Up'))
    this.AddProgress('Disabled Background' guiProgressBackColor k_Position)
    ; 5
    this.AddButton('xs y+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight, labels.Get('LCtrl'))
    this.AddButton('x+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight, labels.Get('LWin'))
    this.AddButton('x+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight, labels.Get('LAlt'))
    this.AddButton('x+' k_KeyMargin ' w' k_SpacebarWidth ' h' k_KeyHeight, 'Space')
    this.AddButton('x+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight, labels.Get('RAlt'))
    this.AddButton('x+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight, labels.Get('RWin'))
    this.AddButton('x+' k_KeyMargin ' w' k_TabW ' h' k_KeyHeight, labels.Get('AppsKey'))
    this.AddButton('x+' k_KeyMargin ' w' k_LastCtrlWidth ' h' k_KeyHeight, labels.Get('RCtrl'))
    this.AddProgress('Disabled Background' guiProgressBackColor k_Position)
    this.AddButton(k_Position, labels.Get('Left'))
    this.AddButton(k_Position, labels.Get('Down'))
    this.AddButton(k_Position, labels.Get('Right'))
  }

  SendValue(v) => Send('')

  static Show() {
    static g := VK()
    g.Show('y790 NA'), VK.ins := g
    WinSetTransparent(200, g)
    return g
  }

  static Hide() => VK.ins.Hide()

  Reset() => (this.Move(, A_ScreenHeight * (3 / 4)), WinSetTransparent(255, this))
}

; set all the keys as hotkey
; from ascii 45 to 96 but skip some keys
Loop 49 {
  k_char := Chr(A_Index + 44)
  if k_char ~= '[<>^``]'
    continue
  Hotkey '~*' k_char, Flash
}

~*`::
~*Backspace::
~*Tab::
~*CapsLock::
~*'::
~*Enter::
~*LShift::
~*,::
~*RShift::
~*LCtrl::
~*LWin::
~*LAlt::
~*Space::
~*RAlt::
~*RWin::
~*AppsKey::
~*RCtrl::
~*Insert::
~*Home::
~*PgUp::
~*Delete::
~*End::
~*PgDn::
~*Up::
~*Left::
~*Down::
~*Right::
~*F1::
~*F2::
~*F3::
~*F4::
~*F5::
~*F6::
~*F7::
~*F8::
~*F9::
~*F10::
~*F11::
~*F12::
~*PrintScreen::
~*ScrollLock::
~*Pause::
~*Esc:: Flash()

Flash(*) {
  k_ThisHotKey := StrReplace(A_ThisHotkey, '~*', '')
  k_ThisHotKey := StrUpper(k_ThisHotKey)
  try {
    keySuffix := k_Characters.Get(K_ThisHotkey)
    ctrl := GuiCtrlFromHwnd(VK.ins['prg' keySuffix].Hwnd)
    ctrl.Opt('+Background' guiProgressColor)
    KeyWait(K_ThisHotkey)
    ctrl.Opt('+Background' guiProgressBackColor)
    ctrl.Redraw()
  }
  catch as e
    MsgBox e.Message
}

VK.Show()