#Requires AutoHotkey v2.0
#SingleInstance Force

#Include G:\AHK\git-ahk-lib\Extend.ahk
#Include G:\AHK\git-ahk-lib\lib\gdip\gdip4ahk2.ahk
#Include G:\AHK\git-ahk-lib\Tip.ahk

CoordMode 'Mouse', 'Screen'
CoordMode 'ToolTip', 'Screen'
CoordMode 'Pixel', 'Screen'

!7:: {
  MouseGetPos(&x, &y)
  color := PixelGetColor(x, y, 'Slow').substring(3)
  Tip.ShowTip(color), A_Clipboard := color
}

; if not pToken := Gdip_Startup()
;   MsgBox 'fail'

; OnExit(exitFunc)
; exitFunc(*) => Gdip_Shutdown(pToken)


; pPen := Gdip_CreatePen(0xff00aeff, 2)
; pPenszx := Gdip_CreatePen(0x4400aeff, 1)
; pBrush := Gdip_BrushCreateSolid(0x8f000000)
; pPenbk := Gdip_CreatePen(0xffffffff, 1)


; gui_ := Gui('-Caption +AlwaysOnTop +ToolWindow +E0x00080000')
; gui_.Show('NA')


; hbm := CreateDIBSection(A_ScreenWidth, A_ScreenHeight)
; hdc := CreateCompatibleDC()
; obm := SelectObject(hdc, hbm)
; G := Gdip_GraphicsFromHDC(hdc)
; Gdip_SetSmoothingMode(G, 4)


; MouseGetPos(&n_mX, &n_mY)
; DrawEnlargementfiFrame(G, pPenbk, pPenszx, hdc, hdc, A_ScreenWidth, A_ScreenHeight, n_mX, n_mY)


; UpdateLayeredWindow(gui_.Hwnd, hdc, 0, 0, A_ScreenWidth, A_ScreenHeight)

; KeyWait('d')

; SelectObject(hdc, obm)
; DeleteObject(hbm)
; DeleteDC(hdc)
; Gdip_DeleteGraphics(G)

; DrawEnlargementfiFrame(graphic, pPenbk, pPenszx, staticHdc, chdc, Screen_w, Screen_h, mx, my) {
;   _hbm := CreateDIBSection(Screen_w, Screen_h)
;   _hdc := CreateCompatibleDC()
;   _obm := SelectObject(_hdc, _hbm)
;   G := Gdip_GraphicsFromHDC(_hdc) 	; 光标放大框
;   BitBlt(_hdc, 0, 0, Screen_w, Screen_h, staticHdc, 0, 0) ; 绘制放大框
;   Gdip_DrawLine(G, pPenszx, mx, my - 12, mx, my + 12) ; 十字线
;   Gdip_DrawLine(G, pPenszx, mx - 12, my, mx + 12, my)
;   StretchBlt(chdc, mx + 15, my + 25, 126, 126, _hdc, mx - 10, my - 10, 21, 21) ; 放大框
;   Gdip_DrawRoundedRectangle(graphic, pPenbk, mx + 14, my + 24, 127, 127, 0) ; 放大框轮廓

;   SelectObject(_hdc, _obm)
;   DeleteObject(_hbm)
;   DeleteDC(_hdc)
;   Gdip_DeleteGraphics(G)
; }
