#Requires AutoHotkey v2.0
#SingleInstance Force

#Include G:\AHK\git-ahk-lib\Extend.ahk
#Include G:\AHK\git-ahk-lib\Theme.ahk
#Include G:\AHK\git-ahk-lib\extend\Set.ahk
#Include G:\AHK\git-ahk-lib\util\GetSize.ahk
#Include G:\AHK\git-ahk-lib\util\ExecAhk2Script.ahk
#Include G:\AHK\git-ahk-lib\util\AhkCmdLine.ahk
#Include G:\AHK\git-ahk-lib\util\Animation.ahk

CoordMode 'Mouse', 'Screen'

AhkProcessView.Show()

class AhkProcessView extends Gui {

  selectedRow := [], statusInfo := ''

  __New() {
    super.__New('Resize', 'AhkProcessView')
    this.SetFont('s14', 'consolas')
    lv := this.AddListView("w1200 h500 Grid", ["PId", "Path", 'WS', 'Args', 'Switchs', 'Remark'])
    lv.OnEvent("ContextMenu", (p*) => this.OnContextMenu(p*))
    lv.OnEvent('DoubleClick', (p*) => this.OnDobuleClick(p*))
    status := this.AddStatusBar('-Theme')
    status.OnEvent('Click', (*) => this.OnClickStatus())
    this.lv := lv, this.status := status, this.OnEvent('Size', (*) => this.OnReSize())
    Theme.Light(this), this.Init(), this.OnEvent('Close', (*) => this.OnClose())
    Hotkey('~F5', (*) => this.onRefresh(), 'On')
  }

  static Show() => AhkProcessView().Show()

  Init() {
    this.SetStatus('no thing'), this.RetriveInfo()
  }

  RetriveInfo(hlSet := unset) {
    lv := this.lv, lv.Delete(), thisId := WinGetPID(this)
    for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process Where Name = 'AutoHotkey64.exe'") {
      if process.ProcessId = thisId {
        remark := 'this'
      } else remark := ''
      parts := ParseCmdLine(process.CommandLine)
      opt := (IsSet(hlSet) && hlSet.Has(parts.filespec)) ? 'Select' : ''
      lv.Add(opt
        , process.ProcessId
        , parts.filespec
        , AutoByteFormat(process.WorkingSetSize)
        , parts.params
        , parts.switchs.join(' ')
        , remark
      )
    }
    lv.ModifyCol()
  }

  GetSelected() {
    selected := [], idx := 0, lv := this.lv
    while idx := lv.GetNext(idx++) {
      selected.Push(idx)
    }
    this.selectedRow := selected

  }

  EditSelected() {
    selected := this.selectedRow, cnt := 0, lv := this.lv
    paths := ''
    for row in selected {
      paths .= lv.GetText(row, 2) ' ', cnt++
    }
    Run(A_ComSpec ' /c code ' paths, , 'Hide')
    this.SetStatus('Edit ' cnt ' scripts.')
  }

  KillSelected() {
    selected := this.selectedRow, cnt := 0, info := '', lv := this.lv
    for row in selected {
      pid := lv.GetText(row, 1), res := _killProcess(pid), filePath := lv.GetText(row, 2)
      if !res
        MsgBox 'can not kill:' filePath
      else info .= '`n' filePath, cnt++
    }
    this.SetStatus('killed ' cnt ' scripts:' info), this.RetriveInfo()

    _killProcess(id) {
      ; winclose can not find the target window, even though open the detectHiddenWindow
      return ProcessClose(id)
    }
  }

  RestartSelected() {
    cnt := 0, info := '', selected := this.selectedRow, lv := this.lv, _set := Set()
    for row in selected {
      filePath := lv.GetText(row, 2)
      try {
        ExecScript(filePath, ['/restart', '/force'])
        cnt++, info .= '`n' filePath, _set.Add(lv.GetText(row, 2))
      } catch as e
        MsgBox('can not restart:' filePath '`ncause ' e.Message)
    }

    this.SetStatus('restarted ' cnt ' scripts:' info)
      , Sleep(200)    ; necessary but don't know why
      , this.RetriveInfo(_set)
  }

  SetStatus(msg) {
    this.status.SetText(msg), this.statusInfo := msg
  }

  OnContextMenu(LV, Item, IsRightClick, X, Y) {
    this.GetSelected(), selected := this.selectedRow
    if selected.Length {
      m := Menu()
        , m.Add('编辑', (*) => this.EditSelected())
        , m.Add()
        , m.Add('停止', (*) => this.KillSelected())
        , m.Add('重启', (*) => this.RestartSelected())
        , m.Show(X, Y)
    } else {
      m := Menu()
        , m.Add('refresh', (*) => this.OnReFresh())
        , m.Show(X - 20, Y - 10)
    }
  }

  OnReFresh(*) {
    this.RetriveInfo(), this.SetStatus('refresh list')
  }

  OnDobuleClick(lv, row, *) {
    this.SetStatus('dobule clicked lv ' row)
  }

  OnResize() {
    this.GetPos(&x, &y, &w, &h), marginX := this.MarginX, marginY := this.MarginY
    this.lv.Move(marginX, marginY, w - 3 * marginX, h - 8 * marginY)
  }

  OnClose() {
    Hotkey('~F5', 'Off'), Animation.FadeOut(this)
    ExitApp()
  }

  OnClickStatus(*) => MsgBox(this.statusInfo || 'no history message', 'History info')

}