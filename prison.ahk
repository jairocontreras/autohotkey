#persistent
setbatchlines -1

menu, tray, tip, Prison
menu, tray, nostandard
menu, tray, add, Exit

sysget, n, monitorworkarea
global WS_SIZEBOX = 0x40000
global nbottom

hookprocadr := registercallback("hookproc", "f")
hwineventhook := setwineventhook(0x1, 0x17, 0, hookprocadr, 0, 0, 0)
return

hookproc(hwineventhook, event) {
  global h, minmax, sx, sy, w, wx, wy, x, y
  if event = 8 ; EVENT_SYSTEM_CAPTURESTART
  {
    coordmode, mouse, screen
    mousegetpos, sx, sy
    coordmode, mouse, window
    mousegetpos, wx, wy
    winexist("a")
    wingetpos, x, y, w, h
    winget, minmax, minmax
  }
  else if event = 10 ; EVENT_SYSTEM_MOVESIZESTART
  {
    if a_cursor = arrow
    {
      varsetcapacity(lprect, 16)
      numput(sx-x-7, &lprect+0)
      numput(sy-y, &lprect+4)
      numput(a_screenwidth-w+wx+8, &lprect+8)
      numput(nbottom-h+wy+8, &lprect+12)
      dllcall("ClipCursor", uint, &lprect)
    }
  }
  else if event = 11 ; EVENT_SYSTEM_MOVESIZEEND
  {
    dllcall("ClipCursor")
    ; restore to screen after drag from maximize
    if minmax = 1 ; maximized
    {
      wingetpos, x1, y1, w1, h1
      x1 += 7
      w1 -= 14
      h1 -= 7
      ; bottom screen edge (or taskbar)
      y1_bottom := y1 + h1
      if (y1_bottom > nbottom)
        y1 -= y1_bottom - nbottom
      ; left screen edge
      if x1 < 0
        x1 = 0
      ; right screen edge
      x1_right := x1 + w1
      if (x1_right > a_screenwidth)
        x1 -= x1_right - a_screenwidth
      winmove,,, x1-7, y1
    }
  }
}

setwineventhook(eventmin, eventmax, hmodwineventproc, lpfnwineventproc, idprocess, idthread, dwflags) {
  dllcall("CoInitialize", uint, 0)
  return dllcall("SetWinEventHook", uint, eventmin, uint, eventmax, uint, hmodwineventproc, uint, lpfnwineventproc, uint, idprocess, uint, idthread, uint, dwflags)
}

exit:
exitapp