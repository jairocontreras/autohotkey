#persistent
setbatchlines -1
menu, tray, icon, images\workspace.png
menu, tray, nostandard
menu, tray, add, Exit
coordmode mouse ; screen
sysget, screen, monitorworkarea
global WS_SIZEBOX = 0x40000
global screenbottom
hookprocadr := registercallback("hookproc", "f")
hwineventhook := setwineventhook(0x2, 0x27, 0, hookprocadr, 0, 0, 0)
return

hookproc(hwineventhook, event) {
  global dwstyle, w, h
  if event = 8 ; EVENT_SYSTEM_CAPTURESTART
  {
    winexist("a")
    winget, dwstyle, style
    wingetpos,,, w, h
  }
  else if event = 11 ; EVENT_SYSTEM_MOVESIZEEND
  {
    if a_cursor = arrow
    {
      mousegetpos,, ym
      if (getkeystate("shift") and ym = 0 and dwstyle & 0x20000) ; WS_MAXIMIZEBOX
        winmaximize
      else {
        wingetpos, x2, y2, w2, h2
        if dwstyle & WS_SIZEBOX
          x2 += 7
        else
          x2 += 2
        if x2 < 0
          x2 = 0
        w2 -= 14
        if dwstyle & WS_SIZEBOX {
          w -= 14
          h -= 7
        }
        else {
          w -= 4
          h -= 2
        }
        x2_right := x2+w2
        if x2_right > %a_screenwidth%
          x2 -= x2_right-a_screenwidth
        h2 -= 7
        y2_bottom := y2+h2
        if y2_bottom > %screenbottom%
          y2 -= y2_bottom-screenbottom
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