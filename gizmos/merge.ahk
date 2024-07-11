#Requires AutoHotkey v2.0
#SingleInstance Force

#Include G:\AHK\git-ahk-lib\Extend.ahk
#Include G:\AHK\git-ahk-lib\Path.ahk

require := Map()                              ; store the require statements
directives := Map()
included := Map()

buildin := Map()

requiresRE := 'i)#requires\s(.*)'
includedRE := 'i)#include\s(.*)'
commentRE := '^\s*;.*$'                       ; This RE only handles single-line comments
trailingComment := '(.*?)\s+;.*?$'            ; trailingComment

RemoveComment(&line) {                        ; Remove the comment
  copy := line
  if copy ~= commentRE {
    copy := ''
  } else if RegExMatch(copy, trailingComment, &match) {
    copy := match[1]
  } else {
    copy := copy
  }
  line := copy
}

ReplaceKeyWord(&input) {                      ; Remove the buildin keyworlds
  copy := input
  for k, v in buildin
    copy := StrReplace(copy, k, v)
  input := copy
}

_Trim(&input) {                               ; Remove before and after Spaces
  copy := input
  input := Trim(copy)
}

filters := [RemoveComment, ReplaceKeyWord]

_Trim_(singleLine) {
  for fn in filters {                         ; Run filter
    fn(&singleLine)
  }
  return singleLine ? singleLine '`r`n' : ''
}

ConcatPath(curr, _path) {
  curr := Path.Normalize(curr)
  _path := Path.Normalize(_path)
  segs := []

  curr := curr.Split(Path.delimiter)
  _path := _path.Split(Path.delimiter)

  loop _path.Length {
    if '..' == _path[A_Index] {
      curr.Pop()
    } else if '.' != _path[A_Index] && '' != _path[A_Index] {
      segs.Push(_path[A_Index])
    }
  }
  return curr.Concat(segs).Join(Path.delimiter)
}

Reset() {
  global
  require.Clear()
  directives.Clear()
  included.Clear()
}

Resolve(fileFullPath) {
  if (!FileExist(fileFullPath)) {
    throw Error('bad filepath: ' fileFullPath)
  }
  resolved := ''
  global currentFile := fileFullPath
  currentDir := Path.Parse(fileFullPath).dir
  f := FileOpen(fileFullPath, 'r', 'utf-8')
  while !f.AtEOF {
    oriLine := f.ReadLine()
    if !oriLine                               ; brank line
      continue
    line := _Trim_(oriLine)
    if line ~= '^#' {
      if line ~= requiresRE {
        RegExMatch(line, requiresRE, &match)
        content := match[1]
        for k, v in require {
          if content = v {
            line := ''
            break
          }
        }
        require.set(fileFullPath, content)
      } else if line ~= includedRE {
        RegExMatch(line, includedRE, &match)
        includeFilePath := Trim(match[1], '[`'|"]')
        if Path.IsAbsolute(includeFilePath) { ; If it is an absolute path, no processing is needed
          resolvedPath := Path.Normalize(includeFilePath)
        } else {                              ; Get the correct absolute path
          resolvedPath := ConcatPath(currentDir, includeFilePath)
        }
        lowerCasePath := StrLower(resolvedPath)
        if not included.Has(lowerCasePath) {
          included.Set(lowerCasePath, resolvedPath)
          resolved .= Resolve(resolvedPath)   ; Recursive processing
        }
        line := ''
      } else {
        directives.Set(fileFullPath, line)
      }
    }
    d.Join line, oriLine
    resolved .= line
  }
  return resolved
}

d := Debug('Merge.ahk - A tool for merging partial ahk scripts  -- Drag the file you want to merge into the gui', 1600, 800, , , , 'DETAIL', false)

d.Log()
d.OnEvent('DropFiles', OnDropFiles)

OnDropFiles(GuiObj, GuiCtrlObj, FileArray, X, Y) {
  d.ClearContent()
  Reset()
  DroppedFile := FileArray[1]
  included.set(StrLower(DroppedFile), DroppedFile)
  parsed := Path.Parse(DroppedFile)
  output := parsed.dir Path.delimiter parsed.nameNoExt '_Merged.' parsed.ext       ; the output path
  global currentFile := DroppedFile
  global buildin
  buildin.Set('A_LineFile', "'" currentFile "'")                            ; keywords
  prefix := A_Space.repeat(14)
  d.Join 'filter count: '
  d.Join prefix filters.Length
  d.Join 'filter funcs: ', 'function name'
  for v in filters
    d.Join prefix v.Name
  d.Join 'buildin info: ', 'The keyword to replace'
  for k, v in buildin
    d.Join prefix k
  d.Divi 'RESOLVE'
  result := Resolve(DroppedFile)
  d.Divi('RESULT', , true)
  subStrings := StrSplit(result, '`r`n')
  for v in subStrings
    d.Join v, '-'
  d.Divi('REQUIRES')
  for k, v in require
    d.Join v, k
  d.Divi('DIRECTIVES')
  for k, v in directives
    d.Join v, k
  d.Divi('INCLUDE')
  for k, v in included
    d.Join v
  d.Log()

  f := FileOpen(output, 'w', 'utf-8')
  f.Write(result)
  f.Close()

  MsgBox 'The merged files have been saved to: ' output
}



; MsgBox('this script [Debug.ahk] was deprecated')

class Debug {
  static slient := false

  __New(topic, w := 800, h := 600, n := true, l := unset, title1 := 'INFO', title2 := 'COMMENT', top := true) {
    this.Window := Debug.Log(topic, w, h, top)
    l := IsSet(l) ? l : Floor(w / 25)
    this.conf := {
      num: n,
      fLen: l + 15
    }
    this.RSep := '-'.Repeat(l)
    this.LSep := '-'.Repeat(this.conf.fLen - 2)
    this.header := Format('{:-' this.conf.fLen '}|{}`r`n', title1, title2)
    this.info := ''
    this.infoC := 1
  }

  ClearContent() {
    this.Window.SetContent('')
    this.info := ''
    this.Reset()
  }

  OnEvent(eventName, cb, *) {
    this.Window.OnEvent(eventName, cb)
  }

  Reset() {
    this.infoC := 1
  }

  GetHeader(header) {
    return this.LSep header this.RSep '`r`n'
  }

  Divi(desc := unset, reset := true, n := true) {
    static count := 1
    if n && reset
      this.Reset()
    this.conf.num := n
    if IsSet(desc)
      this.info .= this.LSep desc this.RSep '`r`n'
    else
      this.info .= this.LSep count++ this.RSep '`r`n'
  }

  SubSection() {
    this.info .= this.LSep '`r`n'
  }

  Join(info?, comment?) {
    if not IsSet(info)
      return
    info := RTrim(info, '`r`n')
    if this.conf.num
      info := this.infoC++ ' ' info
    this.info .= Format('{:-' this.conf.fLen '}|{}`r`n', info, comment?)
  }

  Log() {
    if Debug.slient {
      return
    }
    this.Window.SetContent(this.header this.GetHeader('HEADER') this.info)
    this.Window.Show()
  }

  static RemoveLog(path) {
  }

  class Log extends Gui {
    __New(topic, w, h, top) {
      if top
        opt := '+AlwaysOnTop'
      else
        opt := ''
      super.__New(opt)
      this.SetFont('s13', 'Consolas')
      this.topic := this.AddText(, '[ ' topic ' ]')
      this.content := this.AddEdit('xp ReadOnly h' h ' w' w, '')
      ControlFocus(this.content)
    }

    SetContent(content) {
      this.content.Value := content
    }
  }
}