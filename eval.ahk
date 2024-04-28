#Requires AutoHotkey v2.0
#SingleInstance Force

#Include G:\AHK\git-ahk-lib\Extend.ahk
#Include G:\AHK\git-ahk-lib\Theme.ahk
#Include G:\AHK\git-ahk-lib\util\Animation.ahk
#Include G:\AHK\git-ahk-lib\util\ExecAhk2Code.ahk

class _ extends Gui {
  __New() {
    super.__New('-Caption +Border')
    this.SetFont('s14', 'consolas')
    headerBar := this.AddText('h20 Backgroundfff0d5', 'Run ahk2 code')
    headerBar.OnEvent('Click', (*) => PostMessage(0xA1, 2))
    edit := this.AddEdit('w650 h200 Section', ''), edit.GetPos(&ex, , &ew)
    this.AddButton('yp Section w75', '关闭').OnEvent('Click', (*) => this.Destroy())
    btn := this.AddButton('xp w75', '&Run')
    btn.OnEvent('Click', (*) => (edit.Value && echo.Value .= '>' ExecCode(JoinStr(,'FileAppend(',edit.Value, ', "*")') '`n')))
    btn.GetPos(&bx, , &bw), headerBar.Move(, , bx - ex + bw)
    this.AddButton('xp w75', '清空').OnEvent('Click', (*) => edit.Value := '')
    echo := this.AddEdit('w650 h200 xm')
    this.AddButton('yp w75', '清空').OnEvent('Click', (*) => echo.Value := '')
    ControlFocus(edit), Theme.Light(this)
  }
}

Animation.FadeIn(_(), , Noop, 1)