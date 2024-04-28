#Requires AutoHotkey v2.0
#SingleInstance Force

targetDir := ''
outPutDir := A_ScriptDir

if !targetDir or not targetDir ~= 'i)^\w:[\\/]'
  throw Error('目标目录必须为绝对路径')
if targetDir ~= 'i)[\\/]$'
  targetDir := SubStr(targetDir, 1, StrLen(targetDir) - 1)
if !DirExist(outPutDir)
  DirCreate(outPutDir)

for v in GetFileList(A_ScriptDir) {
  f := FileOpen(outPutDir '/' v, 'w', 'utf-8')
  f.Write(Resolve(A_ScriptDir '/' v))
  f.Close()
}

MsgBox 'Done!'

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

GetFileList(_dir) {
  r := []
  loop files _dir '/*.*', 'F' {
    SplitPath(A_LoopFileName, , , &ext)
    ss := StrSplit(A_LoopFileName)
    if ss[1] = '.' || ss[1] = '_' || ext != 'ahk'
      continue
    r.Push(A_LoopFileName)
  }
  return r
}