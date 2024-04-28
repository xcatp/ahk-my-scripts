#Requires AutoHotkey v2.0
#SingleInstance Force

#Include G:\AHK\git-ahk-lib\Tip.ahk
#Include G:\AHK\git-ahk-lib\Theme.ahk
#Include G:\AHK\git-ahk-lib\Extend.ahk
#Include G:\AHK\git-ahk-lib\util\Explorer.ahk
#Include G:\AHK\git-ahk-lib\util\Animation.ahk

CoordMode 'Mouse', 'Screen'

!#0:: ShowContextMenu()

imgList := IL_Create(10)
  , IL_Add(imgList, './resource/icon/vscode.ico')
  , IL_Add(imgList, './resource/icon/text.png')

ExplorerContextActions := [
  ['Icon' 0, '复制路径', _copyPath],
  ['Icon' 1, '以vscode打开', _openWithVsCode],
  ['Icon' 2, '以记事本打开', _openWithNotepad],
]

selected := []

ShowContextMenu() {
  try id := WinGetID('A')
  catch {
    Tip.ShowTip('Error on get id')
    return
  }
  if !Explorer.IsValidHwnd(id)
    return
  window := Explorer(WinGetID('A'))
  global selected := window.GetListViewSelected()
  if !selected.Length
    return
  ExplorerContext.Show(imgList, ExplorerContextActions)
}

_openWithVsCode() {
  if selected.Length
    Run(A_ComSpec ' /c code ' selected[1])
}
_openWithNotepad() {
  if selected.Length
    Run('notepad ' selected.join(A_Space))
}
_copyPath() {
  if selected.Length
    A_Clipboard := '', A_Clipboard := selected[1], Tip.ShowTip('Copied!')
}


class ExplorerContext extends Gui {

  static Width := 150
  cbs := Map()

  __New(imageList := '', actions := []) {
    super.__New('+AlwaysOnTop +ToolWindow -Caption')
    this.SetFont('s14', 'consolas')
    lv := this.AddListView('w' ExplorerContext.Width ' Grid -Multi -Hdr Lv0x2000 LV0x8000', ['items'])
    lv.OnEvent('Click', (p*) => this.OnLvClick(p*))
    this.lv := lv, lv.SetImageList(imageList)
    for v in actions
      this.LvAdd(v[1], v[2], v[3])
    Theme.Light(this)
  }

  static Show(imgList, actions) {
    static ins := ExplorerContext(imgList, actions)
    Animation.FadeIn(ins, (*) => ins.Modify(), , 8)
    Hotkey '~LButton Up', (*) => ins._Hide(), 'On'
  }

  Modify() => (lv := this.lv, this.GetPos(&x, &y, &w, &h), lv.Move(3, 3, w - 6, h - 6), lv.ModifyCol(1, w - 10))
  LvAdd(opts, col, callback) => (this.lv.Add(opts, col), this.cbs.Set(col, callback))
  _Hide() => (Animation.FadeOut(this, true), HotKey('~LButton Up', 'Off'))
  OnLvClick(lv, row, *) => this.cbs.Get(lv.GetText(row, 1), Noop)()

}