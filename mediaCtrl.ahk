#Include G:\AHK\git-ahk-lib\Tip.ahk

^F10::Send('{Media_Play_Pause}')
^F11::Send('{Media_Prev}')
^F12::Send('{Media_Next}')


MediaSwitchTip(msg) {
  raw := '+===+`n'
    . ' | ' msg ' |`n'
    . '+===+`n'
  Tip.ShowTip(raw)
}