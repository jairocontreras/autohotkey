#persistent
setbatchlines -1
coordmode, mouse, screen

menu, tray, tip, Workspace
menu, tray, nostandard
menu, tray, add, Exit

sysget, n, monitorworkarea

global WS_MAXIMIZEBOX = 0x10000
global WS_SIZEBOX = 0x40000
global nbottom

hookprocadr := registercallback("hookproc", "f")
hwineventhook := setwineventhook(0x1, 0x17, 0, hookprocadr, 0, 0, 0)
return

hookproc(hwineventhook, event) {
  global dwstyle, h, minmax, w, x, y
  if event = 8 ; EVENT_SYSTEM_CAPTURESTART
  {
    winexist("a")
    winget, dwstyle, style
    wingetpos, x, y, w, h
    if dwstyle & WS_SIZEBOX
    {
      x += 7
      w -= 14
      h -= 7
    }
    else {
      x += 2
      w -= 4
      h -= 2
    }
  }
  else if event = 10 ; EVENT_SYSTEM_MOVESIZESTART
    winget, minmax, minmax
  else if event = 11 ; EVENT_SYSTEM_MOVESIZEEND
  {
    wingetpos, x1, y1, w1, h1
    if dwstyle & WS_SIZEBOX
    {
      x1 += 7
      w1 -= 14
      h1 -= 7
    }
    else {
      x1 += 2
      w1 -= 4
      h1 -= 2
    }
    ; top edge of screen
    ; window move
    mousegetpos,, mouse_y
    if (((w1 = w and h1 = h) or minmax = 1) and dwstyle & WS_MAXIMIZEBOX and mouse_y = 0 and getkeystate("shift")) {
      winmaximize
      exit
    }
    ; window resize
    if (h1 > nbottom)
      h1 -= h1 - nbottom
    ; left edge
    ; window move (restore to screen)
    if x1 < 0
      x1 = 0
    ; window resize (restore or stretch to edge)
    if (w1 > w and x1 < x and x1 < 8) {
      w1 += x1
      x1 = 0
    }
    ; right edge
    x1_right := x1 + w1
    diff_x := x1_right - a_screenwidth
    ; window move (restore)
    if (w1 <= w and x1_right > a_screenwidth) ; w1 < w drag from maximize
      x1 -= diff_x
    ; window resize (restore or stretch)
    if (w1 > w and x1 = x and x1_right > a_screenwidth-8)
      w1 -= diff_x
    ; bottom edge (taskbar)
    y1_bottom := y1 + h1
    diff_y := y1_bottom - nbottom
    ; window move (restore)
    if (h1 <= h and y1_bottom > nbottom) ; h1 < h drag from maximize
      y1 -= diff_y
    ; window resize (stretch)
    if (h1 > h and y1 = y and y1_bottom > nbottom-8)
      h1 -= diff_y
    if dwstyle & WS_SIZEBOX
    {
      x1 -= 7
      w1 += 14
      h1 += 7
    }
    else {
      x1 -= 2
      w1 += 4
      h1 += 2
    }
    winmove,,, x1, y1, w1, h1
  }
}

setwineventhook(eventmin, eventmax, hmodwineventproc, lpfnwineventproc, idprocess, idthread, dwflags) {
  dllcall("CoInitialize", uint, 0)
  return dllcall("SetWinEventHook", uint, eventmin, uint, eventmax, uint, hmodwineventproc, uint, lpfnwineventproc, uint, idprocess, uint, idthread, uint, dwflags)
}

exit:
exitapp