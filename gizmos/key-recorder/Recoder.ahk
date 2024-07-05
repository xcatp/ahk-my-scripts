#Requires AutoHotkey v2.0
#SingleInstance Force

#Include g:\AHK\git-ahk-lib\Extend.ahk
#Include g:\AHK\git-ahk-lib\util\JSON.ahk
#Include g:\AHK\git-ahk-lib\Theme.ahk

startTime := A_TickCount
action := []
pushUp(*) => (D(A_ThisHotkey.substring(2, 3) '^'), action.push([A_TickCount - startTime, A_ThisHotkey, 0]))
pushDown(*) {
  if action.Length && action.at(-1)[2] = A_ThisHotkey ; not keywait
    return
  D A_ThisHotkey.substring(2, 3)
  action.push([A_TickCount - startTime, A_ThisHotkey, 1])
}

Record() =>
  Noop(
    D('`n---Start!`n'),
    saved := false,
    action := [],
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890\'
    .toCharArray()
    .forEach(v => (Hotkey('~' v ' UP', pushUp, 'On'), Hotkey('~' v, pushDown, 'On')))
  )

Clear() =>
  Noop(
    D('`n---End, total:' action.Length '`n'),
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890\'
    .toCharArray()
    .forEach(v => (Hotkey('~' v ' UP', 'Off'), Hotkey('~' v, 'Off')))
  )

saved := false

Save() {
  if !action.Length
    return D('`n---Empty data`n')
  s := JSON.Stringify(action)
  f := FileOpen('./data.txt', 'w', 'utf-8')
  f.Write s
  f.Close
  global saved := true
  D '`n--Done!`n'
}

Exit() {
  global saved
  if !saved && action.Length {
    D '`n---Will discard the recording`n'
    saved := true
  } else ExitApp()
}

class Debug extends Gui {
  static ins := Debug()

  __New() {
    super.__New('+AlwaysOnTop -Caption +Border', 'Debug Window')
    this.SetFont('s13', 'consolas')
    this.AddButton('Section', 'start').OnEvent('Click', (*) => Record())
    this.AddButton('yp', 'end').OnEvent('Click', (*) => Clear())
    this.AddButton('yp', 'save').OnEvent('Click', (*) => Save())
    this.AddButton('yp', 'clear').OnEvent('Click', (*) => this.content.Value := '')
    this.AddButton('yp', 'reload').OnEvent('Click', (*) => Reload())
    this.AddButton('yp', 'exit').OnEvent('Click', (*) => Exit())
    this.content := this.AddEdit('w420 h400 xs ReadOnly')
    OnMessage(0x0201, (*) => PostMessage(0xA1, 2)), Theme.Light(this)
  }

  static Show() => (Debug.ins.Show('x' A_ScreenWidth - 460), WinSetTransparent(240, Debug.ins))
  static Log(msg) => Debug.ins.content.Value .= msg
}

D(msg) => Debug.Log(msg)

Debug.Show()