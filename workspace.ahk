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
hwineventhook := setwineventhook(0x2, 0x27, 0, hookprocadr, 0, 0, 0)
return

hookproc(hwineventhook, event) {
  global dwstyle, h, w, x, y
  if event = 8 ; EVENT_SYSTEM_CAPTURESTART
  {
    winexist("a")
    winget, dwstyle, style
    wingetpos, x, y, w, h
    if dwstyle & WS_SIZEBOX {
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
    if a_cursor = arrow
    {
      wingetpos, x2, y2, w2, h2
      if dwstyle & WS_SIZEBOX
        x2 += 7
      else
        x2 += 2
      w2 -= 14
      h2 -= 7
      ; top screen edge
      mousegetpos,, my
      if (getkeystate("shift") and my = 0 and dwstyle & 0x20000) { ; WS_MAXIMIZEBOX
        winmaximize
      }
      else {
        ; bottom screen edge (or taskbar)
        y2_bottom := y2 + h2
        if (h2 <= h and y2_bottom > nbottom) ; h2 < h drag from maximize
          y2 -= y2_bottom - nbottom
        ; left screen edge
        if x2 < 0
          x2 = 0
        ; right screen edge
        x2_right := x2 + w2
        if (w2 <= w and x2_right > a_screenwidth) ; w2 < w drag from maximize
          x2 -= x2_right - a_screenwidth
        if dwstyle & WS_SIZEBOX
          x2 -= 7
        else {
          x2 -= 2
          if y2 > 5
            y2 -= 5
        }
        winmove,,, x2, y2, w2+14, h2+7
      }
    }
  }
}

setwineventhook(eventmin, eventmax, hmodwineventproc, lpfnwineventproc, idprocess, idthread, dwflags) {
  dllcall("CoInitialize", uint, 0)
  return dllcall("SetWinEventHook", uint, eventmin, uint, eventmax, uint, hmodwineventproc, uint, lpfnwineventproc, uint, idprocess, uint, idthread, uint, dwflags)
}

exit:
exitapp