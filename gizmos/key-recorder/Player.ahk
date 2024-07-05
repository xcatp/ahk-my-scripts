#Requires AutoHotkey v2.0
#SingleInstance Force

#Include g:\AHK\git-ahk-lib\Extend.ahk
#Include g:\AHK\git-ahk-lib\Tip.ahk
#Include g:\AHK\git-ahk-lib\util\JSON.ahk

Tip.ShowTip('F1 to start')
action := []
Read()

F1:: Play()
F2:: Reload()

playing := false

Play() {
  if playing {
    Tip.ShowTip('playing')
    return
  }
  global action, playing
  Tip.ShowTip('Start'), playing := true

  start := A_TickCount - action[1][1]

  loop action.Length {
    i := A_Index

    while A_TickCount - start < action[i][1]
    {
      Sleep 10
    }

    Send '{' Format('{}{}', key := action[i][2].substring(2, 3), ac := action[i][3] ? ' down' : ' up') '}'
  }

  Tip.ShowTip('Done!'), playing := false
}

Read() {
  s := FileRead('./data.txt', 'utf-8')
  global action := JSON.Parse(s)
}