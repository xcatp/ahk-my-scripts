#Include G:\AHK\git-ahk-lib\Tip.ahk

<+<!PrintScreen:: Send("{Media_Play_Pause}"), MediaSwitchTip('切换')
<+<!Ins:: Send("{Media_Prev}"), MediaSwitchTip('往前')
<+<!Del::  Send("{Media_Next}"), MediaSwitchTip('向后')

MediaSwitchTip(msg) {
  raw := '+===+`n'
    . ' | ' msg ' |`n'
    . '+===+`n'
  Tip.ShowTip(raw)
}