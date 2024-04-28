#Requires AutoHotkey v2.0
#SingleInstance Ignore

#Include G:\AHK\git-ahk-lib\Extend.ahk
#Include G:\AHK\git-ahk-lib\Tip.ahk

TraySetIcon '.\resource\icon\Meow.png'

; 2024/04/03
; --transform-type={90,180,270,hflip,vflip,transpose,antitranspose}  翻转或旋转
; --video-filter='transform{type="vflip"}'
; --no-skins2-systray 关闭托盘
; --no-audio

Persistent

videoList := [
  'D:\video\020.mp4',
  'D:\video\030.mp4',
  'D:\video\032.mp4'
]
for v in A_Args
  FileExist(v) && videoList.Push(v)

options := ['--video-wallpaper', '--no-video-title-show', '--no-loop', '-R']
cmdRunVLC := JoinStr(A_Space, 'F:\VLC\vlc.exe', options.join(A_Space), videoList.join(A_Space))
_log .= '`n-使用视频列表: `n>' videoList.join('`n>'), Tip.ShowTip(_log)

RunWait(A_ComSpec ' /c start ' cmdRunVLC, , 'min')

_log .= '`n-等待vlc窗口', Tip.ShowTip(_log)
WinWaitActive('ahk_exe' 'vlc.exe', , 10)
if !WinExist('ahk_exe' 'vlc.exe') {
  _log .= '`n-无法启动vlc', Tip.ShowTip(_log)
  throw Error('无法启动vlc')
}
vlcId := WinGetID('ahk_exe' 'vlc.exe'), progmanId := WinGetID('ahk_class Progman')

if DllCall("FindWindowEx"
  , "UInt", progmanId
  , "UInt", 0, "Str", "SHELLDLL_DefView"
  , "UInt", 0
) {
  _log .= '`n-需要向Progman发送消息', Tip.ShowTip(_log)
  SendMsgToProgman(), Sleep(200)
}
beforeParent := DllCall('SetParent', 'ptr', vlcId, 'ptr', progmanId)

DetectHiddenWindows true
workerWIds := WinGetList('ahk_class WorkerW')
WinHide('ahk_id' workerWIds.at(-1))

_log .= '`n-完成', Tip.ShowTip(_log)

TransparentTaskBar(2)

switchItems := ['拉回VLC', '压入VLC', '隐藏VLC', '显示VLC']
m := A_TrayMenu
  , m.Delete()
  , m.Add(switchItems[3], M_Toggle1)
  , m.Add(switchItems[1], M_Toggle2)
  , m.Add()
  , m.Add('透明', (*) => TransparentTaskBar(2))
  , m.Add('模糊', (*) => TransparentTaskBar(3))
  , m.Add()
  , m.Add('编辑', (*) => Edit())
  , m.Add('退出', (*) => ExitApp())
m.ClickCount := 1, m.Default := '透明'

M_Toggle1(*) {
  global vlcId, m
  static flag := false
  if !WinExist('ahk_id' vlcId)
    return Tip.ShowTip('vlc已被关闭')
  if flag := !flag {
    m.Rename(switchItems[3], switchItems[4])
    WinHide('ahk_id' vlcId), Tip.ShowTip(switchItems[3])
  } else {
    m.Rename(switchItems[4], switchItems[3])
    WinShow('ahk_id' vlcId), Tip.ShowTip(switchItems[4])
  }
}

M_Toggle2(*) {
  global vlcId, m
  static flag := false
  if flag := !flag {
    m.Rename(switchItems[1], switchItems[2])
    PullVCL(), Tip.ShowTip(switchItems[1])
  } else {
    if !WinExist('ahk_id' vlcId)
      return Tip.ShowTip('vlc已被关闭')
    m.Rename(switchItems[2], switchItems[1]), WinHide('ahk_id' workerWIds.at(-1))
    DllCall('SetParent', 'ptr', vlcId, 'ptr', WinGetID('ahk_class Progman')), Tip.ShowTip(switchItems[2])
  }
}

OnExit((*) => (WinClose('ahk_id' vlcId), WinShow('ahk_id' workerWIds.at(-1))))

PullVCL(*) {
  global vlcId, beforeParent
  if !WinExist('ahk_id' vlcId)
    return Tip.ShowTip('vlc已被关闭')
  DllCall('SetParent', 'ptr', vlcId, 'ptr', beforeParent), WinMinimize('ahk_id' vlcId)
}

SendMsgToProgman() {
  DllCall('SendMessageTimeout',
    'ptr', WinGetID('ahk_class Progman'),
    'uint', 0x052c,
    'uint', 0,
    'uint', 0,
    'uint', 0x0000,
    'uint', 0x3e8,
    'ptr*', &out := 0
  )
}

TransparentTaskBar(accent_state) {
  ;0：表示禁用玻璃效果和透明度，窗口不会有透明效果。
  ;1：表示启用玻璃效果，通常以一种轻度透明的方式呈现窗口。
  ;2：表示启用玻璃效果，通常以更明显的透明方式呈现窗口。
  ;3：表示启用玻璃效果，通常以更明显的透明方式呈现窗口，并带有模糊效果。
  WCA_ACCENT_POLICY := 19, pad := A_PtrSize = 8 ? 4 : 0, gradient_color := "0x01000000"
  ACCENT_POLICY := Buffer(16, 0), WINCOMPATTRDATA := Buffer(4 + pad + A_PtrSize + 4 + pad, 0)
  hTrayWnd := DllCall("User32\FindWindow", "str", "Shell_TrayWnd", "ptr", 0, "ptr")
  NumPut("int", (accent_state > 0 && accent_state < 4) ? accent_state : 0, ACCENT_POLICY, 0)
    , NumPut("int", gradient_color, ACCENT_POLICY, 8)
    , NumPut("int", WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0)
    , NumPut("int*", ACCENT_POLICY.ptr, WINCOMPATTRDATA, 4 + pad)
    , NumPut("uint", ACCENT_POLICY.size, WINCOMPATTRDATA, 4 + pad + A_PtrSize)
  DllCall("user32\SetWindowCompositionAttribute", "ptr", hTrayWnd, "ptr", WINCOMPATTRDATA)
}