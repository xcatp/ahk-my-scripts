#Include G:\AHK\git-ahk-lib\Tip.ahk

<+<!d:: {
  HDefView := DllCall("FindWindowEx"
    , "uint", WinGetID("ahk_class WorkerW")
    , "uint", 0, "str", "SHELLDLL_DefView"
    , "uint", 0
  )
  HListView := DllCall("FindWindowEx"
    , "uint", HDefView
    , "uint", 0, "str", "SysListView32"
    , "uint", 0
  )
  if DllCall("IsWindowVisible", "uint", HListView)
    DllCall("ShowWindow", "uint", HListView, "uint", 0), Tip.ShowTip('隐藏桌面')
  else DllCall("ShowWindow", "uint", HListView, "uint", 5), Tip.ShowTip('显示桌面')
}