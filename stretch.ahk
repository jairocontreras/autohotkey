#persistent
setbatchlines -1

menu, tray, tip, Stretch
menu, tray, nostandard
menu, tray, add, Exit

sysget, n, monitorworkarea
global nbottom

hookprocadr := registercallback("hookproc", "f")
hwineventhook := setwineventhook(0x1, 0x17, 0, hookprocadr, 0, 0, 0)
return

hookproc(hwineventhook, event) {
  global h, w, x, y
  if event = 8 ; EVENT_SYSTEM_CAPTURESTART
  {
    winexist("a")
    wingetpos, x, y, w, h
    x += 7
    w -= 14
    h -= 7
  }
  else if event = 11 ; EVENT_SYSTEM_MOVESIZEEND
  {
    wingetpos, x1, y1, w1, h1
    x1 += 7
    w1 -= 14
    h1 -= 7
    ; top screen edge: restore (resize past screen when window bottom edge is farthermost)
    if (h1 > nbottom)
      h1 -= h1 - nbottom
    ; stretch (resize from window edge towards screen) or restore (resize from window corner past screen)
    ; bottom screen edge (or taskbar)
    y1_bottom := y1 + h1
    if (h1 > h and y1 = y and y1_bottom > nbottom-8)
      h1 -= y1_bottom - nbottom
    ; left screen edge
    if (w1 > w and x1 < x and x1 < 8) {
      w1 += x1
      x1 = 0
    }
    ; right screen edge
    x1_right := x1 + w1
    if (w1 > w and x1 = x and x1_right > a_screenwidth-8)
      w1 -= x1_right - a_screenwidth
    winmove,,, x1-7, y1, w1+14, h1+7
  }
}

setwineventhook(eventmin, eventmax, hmodwineventproc, lpfnwineventproc, idprocess, idthread, dwflags) {
  dllcall("CoInitialize", uint, 0)
  return dllcall("SetWinEventHook", uint, eventmin, uint, eventmax, uint, hmodwineventproc, uint, lpfnwineventproc, uint, idprocess, uint, idthread, uint, dwflags)
}

exit:
exitapp