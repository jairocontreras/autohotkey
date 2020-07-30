#persistent
setbatchlines -1
menu, tray, icon, images\prison.png
menu, tray, nostandard
menu, tray, add, Exit
sysget, screen, monitorworkarea
global screenbottom
hookprocadr := registercallback("hookproc", "f")
hwineventhook := setwineventhook(0x2, 0x27, 0, hookprocadr, 0, 0, 0)
return

hookproc(hwineventhook, event) {
  global xs, ys, xw, yw, x, y, w, h, minmax
  if event = 8 ; EVENT_SYSTEM_CAPTURESTART
  {
    coordmode mouse ; screen
    mousegetpos, xs, ys
    coordmode, mouse, window
    mousegetpos, xw, yw
    winexist("a")
    wingetpos, x, y, w, h
    winget, minmax, minmax
  }
  else if event = 10 ; EVENT_SYSTEM_MOVESIZESTART
  {
    if a_cursor = arrow
    {
      varsetcapacity(lprect, 16)
      numput(xs-x-7, &lprect+0) ; left
      numput(ys-y, &lprect+4) ; right
      numput(a_screenwidth-w+xw+8, &lprect+8) ; top
      numput(screenbottom-h+yw+8, &lprect+12) ; bottom
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
      if x2 < 0
        x2 = 0
      w2 -= 14
      x2_right := x2+w2
      if x2_right > %a_screenwidth%
        x2 -= x2_right-a_screenwidth
      y2_bottom := y2+h2-7
      if y2_bottom > %screenbottom%
        y2 -= y2_bottom-screenbottom
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