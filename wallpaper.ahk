#Requires AutoHotkey v2.0
#SingleInstance Ignore

#Include G:\AHK\git-ahk-lib\Extend.ahk
#Include G:\AHK\git-ahk-lib\Tip.ahk

TraySetIcon '.\resource\icon\Meow.png'

; 2024/04/03
/**
 * 使用 VLC 作为播放器，通过传递命令行参数控制vlc显示及播放列表
 */
Persistent

options := ['--video-wallpaper', '--no-video-title-show', '--no-loop', '-R'], videoList := []
if IsEmpty(A_Args)
  ExitApp()
for v in A_Args
  videoList.Push(v)
_log .= '-参数: `n>' videoList.join('`n>'), Tip.ShowTip(_log)

RunWait(JoinStr(A_Space, A_ComSpec, '/c start F:\VLC\vlc.exe', options.join(A_Space), videoList.join(A_Space)), , 'min')
SendMsgToProgman()

_log .= '`n-等待vlc窗口(5s)', Tip.ShowTip(_log)
WinWaitActive('ahk_exe' 'vlc.exe', , 5)
if !WinExist('ahk_exe' 'vlc.exe')
  throw Error('无法启动vlc')
vlcId := WinGetID('ahk_exe' 'vlc.exe'), progmanId := WinGetID('ahk_class Progman')
beforeParent := DllCall('SetParent', 'ptr', vlcId, 'ptr', progmanId)

DetectHiddenWindows true
workerWId := WinGetList('ahk_class WorkerW').at(-1)
WinHide('ahk_id' workerWId)

_log .= '`n-完成', Tip.ShowTip(_log)

switchItems := ['隐藏', '显示']
m := A_TrayMenu
  , m.Delete()
  , m.Add(switchItems[1], Toggle)
  , m.Add('重置', (*) => (DllCall('SetParent', 'ptr', vlcId, 'ptr', WinGetID('ahk_class Progman')), WinHide('ahk_id' workerWId)))
  , m.Add()
  , m.Add('编辑', (*) => Edit())
  , m.Add('退出', (*) => ExitApp())

Toggle(*) {
  static flag := false
  if !WinExist('ahk_id' vlcId)
    return Tip.ShowTip('vlc已被关闭')
  if flag := !flag
    m.Rename(switchItems[1], switchItems[2]), WinHide('ahk_id' vlcId), Tip.ShowTip(switchItems[1])
  else m.Rename(switchItems[2], switchItems[1]), WinShow('ahk_id' vlcId), Tip.ShowTip(switchItems[2])
}

OnExit((*) => (WinClose('ahk_id' vlcId), WinShow('ahk_id' workerWId)))

PullVCL(*) {
  global vlcId, beforeParent
  if !WinExist('ahk_id' vlcId)
    return Tip.ShowTip('vlc已被关闭')
  DllCall('SetParent', 'ptr', vlcId, 'ptr', beforeParent), WinMinimize('ahk_id' vlcId)
}

SendMsgToProgman() {
  DllCall('SendMessageTimeout',
    'ptr', WinGetID('ahk_class Progman'),
    'uint', 0x052c, 'uint', 0, 'uint', 0,
    'uint', 0x0000, 'uint', 0x3e8, 'ptr*', &out := 0
  )
}

; TransparentTaskBar(accent_state) {
;   ;0：表示禁用玻璃效果和透明度，窗口不会有透明效果。
;   ;1：表示启用玻璃效果，通常以一种轻度透明的方式呈现窗口。
;   ;2：表示启用玻璃效果，通常以更明显的透明方式呈现窗口。
;   ;3：表示启用玻璃效果，通常以更明显的透明方式呈现窗口，并带有模糊效果。
;   WCA_ACCENT_POLICY := 19, pad := A_PtrSize = 8 ? 4 : 0, gradient_color := "0x01000000"
;   ACCENT_POLICY := Buffer(16, 0), WINCOMPATTRDATA := Buffer(4 + pad + A_PtrSize + 4 + pad, 0)
;   hTrayWnd := DllCall("User32\FindWindow", "str", "Shell_TrayWnd", "ptr", 0, "ptr")
;   NumPut("int", (accent_state > 0 && accent_state < 4) ? accent_state : 0, ACCENT_POLICY, 0)
;     , NumPut("int", gradient_color, ACCENT_POLICY, 8)
;     , NumPut("int", WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0)
;     , NumPut("int*", ACCENT_POLICY.ptr, WINCOMPATTRDATA, 4 + pad)
;     , NumPut("uint", ACCENT_POLICY.size, WINCOMPATTRDATA, 4 + pad + A_PtrSize)
;   DllCall("user32\SetWindowCompositionAttribute", "ptr", hTrayWnd, "ptr", WINCOMPATTRDATA)
; }