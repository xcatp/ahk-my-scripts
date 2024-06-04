#Include G:\AHK\git-ahk-lib\Tip.ahk
#Include G:\AHK\git-ahk-lib\Extend.ahk

^PgUp:: SetWin(0)
^PgDn:: SetWin(1)
^SC146:: WinTopCtrl.SetTop(WinGetID('A')) ; ^Pause
^+SC146:: WinTopCtrl.CancelAll()
~MButton:: {
  try WinGetPos(&wx, &wy, &ww, , 'A')
  catch
    return
  MouseGetPos(&mx, &my)
  if mx.between(wx, wx + ww) and my.between(wy, wy + 50)
    WinTopCtrl.SetTop(WinGetID('A'))
}

SetWin(param) {
  try {
    if WinGetClass('A') = 'WorkerW'
      Tip.ShowTip('不要关闭桌面喵~')
    else param ? WinClose('A') : WinMinimize('A')
  } catch
    Tip.ShowTip('操作失败了喵...')
}

class WinTopCtrl {
  static state := Map()

  static SetTop(wid) {
    if not WinExist('ahk_id' wid) {
      Tip.ShowTip('该窗口不存在')
      return
    }
    if WinTopCtrl.state.Has(wid)
      isTop := false, WinTopCtrl.state.Delete(wid)
    else isTop := true, WinTopCtrl.state.Set(wid, true)
    WinSetAlwaysOnTop(-1, 'ahk_id' wid)
    t := '[ ' (Trim(WinGetTitle('ahk_id' wid)) || WinGetClass('ahk_id' wid)) ' ] '
      . (isTop ? '置顶' : '取消置顶') '了喵~☆'
      . (this.state.Count ? _getTopWinList(wid) : '')
    Tip.ShowTip(t)

    _getTopWinList(wid) {
      for k in this.state
        if WinExist('ahk_id' k) or k = wid
          titleList .= '`n- [ ' WinGetTitle('ahk_id' k) ' ]'
      return IsSet(titleList) && '`n置顶列表: ' titleList || ''
    }
  }

  static CancelAll() {
    if this.state.Count {
      for k in this.state
        try WinSetAlwaysOnTop(0, 'ahk_id' k)
        catch
          errInfo := 'Some of the window is closed'
      this.state := Map()
      Tip.ShowTip('取消所有置顶了喵~' (IsSet(errInfo) && '`n但是-->' errInfo || ''))
    } else Tip.ShowTip('没有置顶窗口喵~')
  }
}