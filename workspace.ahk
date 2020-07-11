#persistent
setbatchlines -1
coordmode, mouse, screen

menu, tray, tip, Workspace
menu, tray, nostandard
menu, tray, add, Exit

sysget, n, monitorworkarea
global WS_SIZEBOX = 0x40000
global nbottom

hookprocadr := registercallback("hookproc", "f")
hwineventhook := setwineventhook(0x1, 0x17, 0, hookprocadr, 0, 0, 0)
return

hookproc(hwineventhook, event) {
  global dwstyle, h, w, x, y
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
  else if event = 11 ; EVENT_SYSTEM_MOVESIZEEND
  {
    wingetpos, x1, y1, w1, h1
    if dwstyle & WS_SIZEBOX
      x1 += 7
    else
      x1 += 2
    w1 -= 14
    h1 -= 7
    ; top screen edge
    if a_cursor = arrow
    {
      mousegetpos,, my
      if (getkeystate("shift") and my = 0 and dwstyle & 0x10000) { ; WS_MAXIMIZEBOX
        winmaximize
        exit
      }
    }
    ; bottom screen edge (or taskbar)
    y1_bottom := y1 + h1
    if (h1 <= h and y1_bottom > nbottom) ; h1 < h drag from maximize
      y1 -= y1_bottom - nbottom
    ; left screen edge
    if x1 < 0
      x1 = 0
    ; right screen edge
    x1_right := x1 + w1
    if (w1 <= w and x1_right > a_screenwidth) ; w1 < w drag from maximize
      x1 -= x1_right - a_screenwidth
    if dwstyle & WS_SIZEBOX
      x1 -= 7
    else {
      x1 -= 2
      if y1 > 5
        y1 -= 5
    }
    winmove,,, x1, y1, w1+14, h1+7
  }
}

setwineventhook(eventmin, eventmax, hmodwineventproc, lpfnwineventproc, idprocess, idthread, dwflags) {
  dllcall("CoInitialize", uint, 0)
  return dllcall("SetWinEventHook", uint, eventmin, uint, eventmax, uint, hmodwineventproc, uint, lpfnwineventproc, uint, idprocess, uint, idthread, uint, dwflags)
}

exit:
exitapp