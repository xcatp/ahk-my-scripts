#Requires AutoHotkey v2.0
#SingleInstance Ignore

#Include G:\AHK\git-ahk-lib\Extend.ahk
#Include G:\AHK\git-ahk-lib\Theme.ahk
#Include G:\AHK\git-ahk-lib\Tip.ahk
#Include G:\AHK\git-ahk-lib\util\Animation.ahk

#NoTrayIcon

TransparencyGUI.Show()

class TransparencyGUI extends Gui {

  __New() {
    super.__New("+AlwaysOnTop -Caption +Border +ToolWindow")
    this.SetFont('s12', 'consolas'), id := WinGetID('A')
    slider := this.AddSlider("ToolTip Range0-255 AltSubmit w200", GetWinTransparent('ahk_id' id))
    slider.OnEvent("Change", (ctrl, *) => (WinSetTransparent(Ctrl.Value, 'ahk_id' id), Tip.ShowTip(ctrl.Value)))
    this.AddText("xm w200", _c(WinGetTitle('ahk_id' id), 22).RTrim('`n')).OnEvent("Click", (*) => Animation.FadeOut(this))
    ControlFocus(slider), Theme.Dark(this)
    _c(v, l, i := 1) => v.Length - i <= l ? SubStr(v, i) '`n' : SubStr(v, i, l) '`n' _c(v, l, i + l)
  }

  static Show() => TransparencyGUI().Show(Format('x{} y{}', 100, 50))
}