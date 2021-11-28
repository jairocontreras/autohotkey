#persistent
setbatchlines -1
menu, tray, icon, images\stretch.png
sysget, screen, monitorworkarea
global screenbottom
hookprocadr := registercallback("hookproc", "f")
hwineventhook := setwineventhook(0x2, 0x27, 0, hookprocadr, 0, 0, 0)
return

hookproc(hwineventhook, event) {
  global x, y, w, h
  if event = 8 ; EVENT_SYSTEM_CAPTURESTART
  {
    winexist("a")
    wingetpos, x, y, w, h
  }
  else if event = 11 ; EVENT_SYSTEM_MOVESIZEEND
  {
    wingetpos, x2, y2, w2, h2
    ; stretch: resize from window edge towards screen (up to 7px close)
    ; restore: resize from window corner past screen
    w2 -= 14
    w -= 14
    if w2 > %w%
    {
      x2 += 7
      x += 7
      if (x2 < x and x2 < 8) {
        w2 += x2
        x2 = 0
      }
      x2_right := x2+w2
      if (x2 = x and x2_right > a_screenwidth-8)
        w2 -= x2_right-a_screenwidth
      x2 -= 7
    }
    h2 -= 7
    h -= 7
    y2_bottom := y2+h2
    if (h2 > h and y2 = y and y2_bottom > screenbottom-8)
      h2 -= y2_bottom-screenbottom
    ; restore: resize window past top screen edge when window is full height
    if h2 > %screenbottom%
      h2 -= h2-screenbottom
    winmove,,, x2, y2, w2+14, h2+7
  }
}

setwineventhook(eventmin, eventmax, hmodwineventproc, lpfnwineventproc, idprocess, idthread, dwflags) {
  dllcall("CoInitialize", uint, 0)
  return dllcall("SetWinEventHook", uint, eventmin, uint, eventmax, uint, hmodwineventproc, uint, lpfnwineventproc, uint, idprocess, uint, idthread, uint, dwflags)
}