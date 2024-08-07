#Requires AutoHotkey v2.0
#SingleInstance Ignore

prefixDir := 'G:\AHK\git-ahk-lib\'  ; 脚本初始的目录
targetDir := 'G:\AHK\git-ahk-lib\'  ; 初始目录将改为此目录
outPutDir := ''  ; 输出目录，留空将原地修改

g := Gui('+AlwaysOnTop')
g.SetFont('s14', 'consolas')
g.OnEvent('DropFiles', OnDrpoFiles)
g.AddText('Section', 'prefix dir:')
_e0 := g.AddEdit('yp w800 r1', prefixDir)
g.AddText('xs', 'target dir:')
_e1 := g.AddEdit('yp w800 r1', targetDir)
g.AddText('xs', 'output dir:')
_e2 := g.AddEdit('yp w800 r1', outPutDir)
g.SetFont('s12', 'consolas')
_e := g.AddEdit('xs w920 h500 vEdit ReadOnly')
g.Show('x ' A_ScreenWidth - 980)
_e.Value := 'drop dir or files to here.`n'

ChangeSetting(*) {
  global prefixDir, targetDir, outPutDir
  if _e1.Value ~= 'i)[\\/]$'
    _e1.Value := SubStr(_e1.Value, 1, StrLen(_e1.Value) - 1)
  if _e2.Value && !DirExist(_e2.Value)
    DirCreate(_e2.Value)
  prefixDir := _e0.Value, targetDir := _e1.Value, outPutDir := _e2.Value
}

OnDrpoFiles(g, gc, fileArray, *) {
  ChangeSetting()
  for v in fileArray {
    if InStr(FileGetAttrib(v), 'D') {
      loop files v '/*.*', 'DFR' {
        SplitPath(A_LoopFileName, , , &ext)
        ss := StrSplit(A_LoopFileName)
        if ss[1] = '.' || ss[1] = '_' || ext != 'ahk'
          continue
        _write(A_LoopFileFullPath, A_LoopFileName)
      }
    } else {
      SplitPath(v, &fileName)
      _write(v, fileName)
    }
  }
  g['Edit'].Value .= 'Done!`n'

  _write(fullPath, fileName) {
    t := Resolve(fullPath)
    f := FileOpen(_p := (outPutDir ? outPutDir '/' fileName : fullPath), 'w', 'utf-8')
    f.Write(t), f.Close()
    g['Edit'].Value .= '> 文件' fullPath ' 已输出到 ' _p '`n'
  }
}

Resolve(filePath) {
  f := FileOpen(filePath, 'r', 'utf-8')
  while !f.AtEOF {

    r .= (RegExMatch(l := f.ReadLine(), 'i)^#Include\s+(\w:.*)', &re)  ; 只修改绝对路径导入
      ? '#Include ' StrReplace(targetDir SubStr(re[1], StrLen(prefixDir)), '/', '\')
      : l) '`n'
  }
  f.Close()
  return r
}