#Requires AutoHotkey v2.0

#SingleInstance Ignore
#NoTrayIcon

#Include g:\AHK\git-ahk-lib\lib\gdip\GdipStarter.ahk
#Include g:\AHK\git-ahk-lib\Extend.ahk
#Include g:\AHK\git-ahk-lib\Tip.ahk
#Include g:\AHK\git-ahk-lib\util\Cursor.ahk

CoordMode 'Mouse'
CoordMode 'Pixel'

; config
hex := true, staticG := true
offsetX := 12, offsetY := 12, width := 160, height := 128, _h := 16
font := "consolas", fc := '#ffdbffd5'.substring(2)

; _fc := '#6003ffff'

pBrush := Gdip_BrushCreateSolid(0x8f000000)
pPenLine := Gdip_CreatePen(0x6003ffff, 1)
pPenbkBlack := Gdip_CreatePen(0xff000000, 1)
pPenbkWhite := Gdip_CreatePen(0xffffffff, 1)

_()

_() {
  Cursor.SetIcon(Cursor.Icon.cross)
  Gdip_FontFamilyCreate(Font)

  pBitmap := Gdip_BitmapFromScreen()
    , hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
    , staticHdc := CreateCompatibleDC()
    , staticObm := SelectObject(staticHdc, hBitmap)

  gui_ := Gui('-Caption +AlwaysOnTop +ToolWindow +E0x00080000')
  gui_.Show('NA')
  global hex, flag, _h, g_c
  Hotkey('LButton Up', Done, 'On')
  Hotkey('MButton', (*) => (flag := false, hex := !hex), 'On')
  Hotkey('WheelUp', (*) => (_h -= _h <= 8 ? 0 : 2, flag := false), 'On')
  Hotkey('WheelDown', (*) => (_h += _h >= height ? 0 : 2, flag := false), 'On')
  Hotkey('RButton Up', Exit, 'On')
  Hotkey('Left', (*) => MouseMove(-1, 0, , 'R'), 'On')
  Hotkey('Right', (*) => MouseMove(1, 0, , 'R'), 'On')
  Hotkey('Up', (*) => MouseMove(0, -1, , 'R'), 'On')
  Hotkey('Down', (*) => MouseMove(0, 1, , 'R'), 'On')
  Hotkey('Esc', Exit, 'On')

  Done(*) => (A_Clipboard := hex ? g_c : Format('rgb{}', g_c), Exit())
  Exit(*) => (Clean(), ExitApp())

  SetTimer(Start, 10)

  Start() {
    static o_mX := 0, o_mY := 0
    MouseGetPos(&n_mX, &n_mY)
    if n_mX = o_mX && n_mY = o_mY && flag
      return
    flag := true, o_mX := n_mX, o_mY := n_mY
    hbm := CreateDIBSection(A_ScreenWidth, A_ScreenHeight)
    hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
    ; SetStretchBltMode(hdc, 4)
    G := Gdip_GraphicsFromHDC(hdc), Gdip_SetSmoothingMode(G, 4)
    if staticG  ; static background
      BitBlt(hdc, 0, 0, A_ScreenWidth, A_ScreenHeight, staticHdc, 0, 0)
    _DrawEnlargementfiFrame(n_mX, n_mY)
    UpdateLayeredWindow(gui_.Hwnd, hdc, 0, 0, A_ScreenWidth, A_ScreenHeight)
    SelectObject(hdc, obm) DeleteObject(hbm), DeleteDC(hdc), Gdip_DeleteGraphics(G)

    _DrawEnlargementfiFrame(mx, my) {
      _offsetX := mx + offsetX + width + 5 > A_ScreenWidth ? -width - 5 : offsetX
      _offsetY := my + offsetY + height + 25 > A_ScreenHeight ? -height - 25 : offsetY
      _hbm := CreateDIBSection(A_ScreenWidth, A_ScreenHeight)
      _obm := SelectObject(_hdc := CreateCompatibleDC(), _hbm), _G := Gdip_GraphicsFromHDC(_hdc)
      BitBlt(_hdc, 0, 0, A_ScreenWidth, A_ScreenHeight, staticHdc, 0, 0)
      _w := width * _h // height, _pw := width // _w, _ph := height // _h
      Gdip_DrawLine(_G, pPenLine, mx, my - 1, mx, my - _h // 2) ; vertical
      Gdip_DrawLine(_G, pPenLine, mx, my + 1, mx, my + _h // 2)
      Gdip_DrawLine(_G, pPenLine, mx - 1, my, mx - _w // 2, my)
      Gdip_DrawLine(_G, pPenLine, mx + 1, my, mx + _w // 2, my)
      _x := mx + _offsetX, _y := my + _offsetY, cx := _x + (width + 4) // 2, cy := _y + (height + 4) // 2
      StretchBlt(hdc, _x + 2, _y + 2, width, height, _hdc, mx - _w // 2, my - _h // 2, (_w & 1 ? _w : _w + 1), _h)
      Gdip_DrawRoundedRectangle(G, pPenbkBlack, _x, _y, width + 2, height + 2, 0) ; border
      Gdip_DrawRoundedRectangle(G, pPenbkWhite, _x + 1, _y + 1, width, height, 0)
      Gdip_DrawRoundedRectangle(G, pPenbkBlack, cx - _pw // 2 - 2, cy - 2, _pw + 3, _ph + 3, 0)
      Gdip_DrawRoundedRectangle(G, pPenbkWhite, cx - _pw // 2 - 1, cy - 1, _pw + 1, _ph + 1, 0)

      ; ListVars

      _DrawTip()
      SelectObject(_hdc, _obm), DeleteObject(_hbm), DeleteDC(_hdc), Gdip_DeleteGraphics(_G)

      _DrawTip() {
        local x := _x + 1, y := _y + height + 3
        global g_c
        Gdip_FillRoundedRectangle(G, pBrush, _x, y - 1, width + 2, 22, 0) ; background
        _c := '0xff' (hexC := PixelGetColor(Cursor.x, Cursor.y, 'slow').substring(3))
        Gdip_FillRectangle(G, _b := Gdip_BrushCreateSolid(_c), x, y, 20, 20) ; color box
        Gdip_DrawRoundedRectangle(G, pPenbkWhite, x, y, 20, 20, 0)
        options := Format('x{} y{} c{} Center s15', x + 15, y + 2, fc)
        Gdip_TextToGraphics(G, (g_c := hex ? '#' hexC : _hexToRGB(hexC)), options, font, width - 20, 30)
        Gdip_DeleteBrush(_b)

        _hexToRGB(_c) {
          local r, g, b
          if _c.length = 3
            _c := _c[0] + _c[0] + _c[1] + _c[1] + _c[2] + _c[2]
          r := ('0x' _c.substring(1, 3)) & 0xFF
          g := ('0x' _c.substring(3, 5)) & 0xFF
          b := ('0x' _c.substring(5)) & 0xFF
          return JoinStr(',', '(' r, g, b ')')
        }
      }
    }
  }

  Clean() {
    ; HotKeysOff('LButton Up', 'RButton Up', 'Esc')
    SetTimer(Start, 0)
    Gdip_DeletePen(pPenLine)
    Gdip_DeletePen(pPenbkBlack), Gdip_DeleteBrush(pBrush)
    SelectObject(staticHdc, staticObm), DeleteDC(staticHdc), DeleteObject(hBitmap)
  }
}