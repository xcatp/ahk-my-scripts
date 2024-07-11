#Requires AutoHotkey v2.0
#SingleInstance Force

#Include g:\AHK\git-ahk-lib\Extend.ahk
#Include g:\AHK\git-ahk-lib\Theme.ahk

class _ extends Gui {
  __New() {
    super.__New('-Caption +Border')
    this.SetFont('s14', 'consolas')
    headerBar := this.AddText('h20 Backgrounde3cca0', 'text processor')
    headerBar.OnEvent('Click', (*) => PostMessage(0xA1, 2))
    edit := this.AddEdit('w650 h200 Section', ''), edit.GetPos(&ex, , &ew)
    this.AddButton('yp Section w75', '关闭').OnEvent('Click', (*) => this.Destroy())
    (btn := this.AddButton('yp w75', '清空')).OnEvent('Click', (*) => edit.Value := '')
    this.AddButton('xs w75', '\n').OnEvent('Click', (*) => (edit.Value && echo.Value .= this.RemoveLF(edit.Value)))
    btn.GetPos(&bx, , &bw), headerBar.Move(, , bx - ex + bw)
    echo := this.AddEdit('w650 h200 xm')
    this.AddButton('yp w75', '复制').OnEvent('Click', (*) => A_Clipboard := echo.Value)
    this.AddButton('yp w75', '清空').OnEvent('Click', (*) => echo.Value := '')
    ControlFocus(edit), Theme.Light(this)
  }


  RemoveLF(t) => StrReplace(t, '`n', '\n')
}

_().Show()

; Animation.FadeIn(_(), , Noop, 1)
