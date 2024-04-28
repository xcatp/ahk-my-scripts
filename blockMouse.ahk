#Requires AutoHotkey v2.0
#SingleInstance Force

#Include G:\AHK\git-ahk-lib\Extend.ahk
#Include G:\AHK\git-ahk-lib\Tip.ahk

flag_mouse_block := false

!SC046:: {
  global flag_mouse_block
  if flag_mouse_block
    BlockInput("MouseMoveOff"), Tip.ShowTip('Unlock Mouse')
  else BlockInput("MouseMove"), Tip.ShowTip('Block Mouse')
  flag_mouse_block := !flag_mouse_block
}

{
  #HotIf flag_mouse_block
  LButton:: ActionCtrl.undo()
  RButton:: ActionCtrl.do()
  #HotIf
}

/**
 * @example
 * actions := [
 *   [Fn(MsgBox, '1'), Fn(MsgBox, '-1')],
 *   [Fn(MsgBox, '2'), Fn(MsgBox, '-2')],
 *   [Fn(MsgBox, '3'), Fn(MsgBox, '-3')]
 * ]
 * ActionCtrl.init(actions)
 * n:: ActionCtrl.do()
 * m:: ActionCtrl.undo()
 */
class ActionCtrl {
  static actions := [], idx := 1, step := 0
  static resetIdx() => this.idx := 1
  static resetStep() => this.step := 0

  static init(actions) => this.actions := actions
  static do() {
    if !this.actions.Length
      return Tip.ShowTip('没有下一步喵~')
    if this.idx > this.actions.Length
      this.resetIdx(), this.resetStep(), Tip.ShowTip('重新开始喵~')
    this.actions[this.idx++][1](), this.step++
  }
  static undo() {
    if this.step {
      this.actions[--this.idx][2](), this.step--
    } else Tip.ShowTip('没有上一步喵~')
  }
}