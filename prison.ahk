#persistent
setbatchlines -1

menu, tray, icon, images/prison.png
menu, tray, nostandard
menu, tray, add, Exit

sysget, n, monitorworkarea
global WS_SIZEBOX = 0x40000
global nbottom

hookprocadr := registercallback("hookproc", "f")
hwineventhook := setwineventhook(0x2, 0x27, 0, hookprocadr, 0, 0, 0)
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
    if a_cursor = arrow
      dllcall("ClipCursor")
    ; restore to screen after drag from maximize
    if minmax = 1 ; maximized
    {
      wingetpos, x2, y2, w2, h2
      x2 += 7
      w2 -= 14
      h2 -= 7
      ; bottom screen edge (or taskbar)
      y2_bottom := y2 + h2
      if y2_bottom > %nbottom%
        y2 -= y2_bottom - nbottom
      ; left screen edge
      if x2 < 0
        x2 = 0
      ; right screen edge
      x2_right := x2 + w2
      if x2_right > %a_screenwidth%
        x2 -= x2_right - a_screenwidth
      winmove,,, x2-7, y2
    }
  }
}

setwineventhook(eventmin, eventmax, hmodwineventproc, lpfnwineventproc, idprocess, idthread, dwflags) {
  dllcall("CoInitialize", uint, 0)
  return dllcall("SetWinEventHook", uint, eventmin, uint, eventmax, uint, hmodwineventproc, uint, lpfnwineventproc, uint, idprocess, uint, idthread, uint, dwflags)
}

exit:
exitapp