#Requires AutoHotkey v2.0
#SingleInstance Force

#Include G:\AHK\git-ahk-lib\Tip.ahk
#Include 'G:\AHK\git-ahk-lib\ShellRun.ahk'

^Home:: LightCtrl.Set(LightCtrl.Inc)
^End:: LightCtrl.Set(LightCtrl.Desc)
^SC046:: LightCtrl.Set(LightCtrl.Toggle) ; ^scrollock

class LightCtrl {
  static cur := 0, low := 6, high := 30, inc := 0, desc := 1, toggle := 2

  static Get() {
    fields := ShellRun.RunWaitOne('WMIC /NAMESPACE:\\root\wmi PATH WmiMonitorBrightness WHERE "Active=TRUE" GET /value')
    return +Rtrim(SubStr(fields, InStr(fields, match := 'CurrentBrightness=') + StrLen(match), 2), '`r`n')
  }

  static Set(action, param := 2) {
    cur := this.cur || this.Get()
    switch action {
      case LightCtrl.Toggle: cur := _toggle()
      case LightCtrl.Inc: cur := _inc(param)
      case LightCtrl.Desc: cur := _desc(param)
      default: throw Error('unsupport action')
    }
    Run(A_ComSpec
      ' /c "WMIC /NAMESPACE:\\root\wmi PATH WmiMonitorBrightnessMethods WHERE "Active=TRUE" CALL WmiSetBrightness Brightness='
      cur ' Timeout=0"', , 'Hide')
    this.cur := cur, _showTip()

    _inc(val) => cur + val > 70 ? cur : cur + val
    _desc(val) => cur - val <= 0 ? cur : cur - val
    _toggle() => cur < 15 ? LightCtrl.high : LightCtrl.low

    _showTip() {
      dili := this.cur >= 10 ? '  ' : '   '
      raw := '+===+`n'
        . ' |' dili this.cur dili '|`n'
        . '+===+`n'
      Tip.ShowTip(raw)
    }
  }
}