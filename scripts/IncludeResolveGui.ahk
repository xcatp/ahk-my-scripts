﻿#Requires AutoHotkey v2.0
#SingleInstance Ignore

targetDir := 'G:\AHK\git-ahk-lib\'
outPutDir := ''  ; 留空将原地修改

g := Gui('+AlwaysOnTop')
g.SetFont('s14', 'consolas')
g.OnEvent('DropFiles', OnDrpoFiles)
_e1 := g.AddEdit('w800 r1', targetDir)
_e2 := g.AddEdit('w800 r1', outPutDir)
g.AddButton('w80', 'ok').OnEvent('Click', ChangeSetting)
_e := g.AddEdit('w800 h500 vEdit ReadOnly')
g.Show()
_e.Value := 'drop dir or files to here.`n'

ChangeSetting(*) {
  global targetDir, outPutDir
  if !_e1.Value or not _e1.Value ~= 'i)^\w:[\\/]'
    throw Error('目标目录必须为绝对路径')
  if _e1.Value ~= 'i)[\\/]$'
    _e1.Value := SubStr(_e1.Value, 1, StrLen(_e1.Value) - 1)
  if _e2.Value && !DirExist(_e2.Value)
    DirCreate(_e2.Value)
  targetDir := _e1.Value, outPutDir := _e2.Value
  _e.Value :=
    Format('target dir is:[{}]`noutput dir is:[{}]`n---`ndrop dir or files to here.`n---`n'
      , _e1.Value
      , _e2.Value ? _e2.Value : 'null'
    )
}

OnDrpoFiles(g, gc, fileArray, *) {
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

  _write(fullPath, fileName) {
    t := Resolve(fullPath)
    f := FileOpen(outPutDir ? outPutDir '/' fileName : fullPath, 'w', 'utf-8')
    f.Write(t), f.Close()
    g['Edit'].Value .= '> ' fullPath '`n'
  }

  MsgBox 'Done!'
}


Resolve(filePath) {
  f := FileOpen(filePath, 'r', 'utf-8')
  while !f.AtEOF {
    r .= (((l := f.ReadLine()) ~= 'i)^#Include\s+(\w:)')
      ? '#Include ' targetDir SubStr(l, InStr(l := StrReplace(l, '/', '\'), '\', , 1, 3))
      : l) '`n'
  }
  f.Close()
  return r
}