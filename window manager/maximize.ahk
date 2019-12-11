setbatchlines -1

menu, tray, tip, Maximize
menu, tray, nostandard
menu, tray, add, Exit

hookprocadr := registercallback("hookproc", "f")
hwineventhook := setwineventhook(0x1, 0x17, 0, hookprocadr, 0, 0, 0)
return

hookproc(hwineventhook, event, hwnd) {
  global id
  if event = 22 ; EVENT_SYSTEM_MINIMIZESTART
    id = %hwnd%
}

setwineventhook(eventmin, eventmax, hmodwineventproc, lpfnwineventproc, idprocess, idthread, dwflags) {
  dllcall("CoInitialize", uint, 0)
  return dllcall("SetWinEventHook", uint, eventmin, uint, eventmax, uint, hmodwineventproc, uint, lpfnwineventproc, uint, idprocess, uint, idthread, uint, dwflags)
}

#space::
winget, minmax, minmax, a
if minmax = 1
  winrestore a
else {
  winget, dwstyle, style, a
  if dwstyle & 0x10000 ; WS_MAXIMIZEBOX
    winmaximize a
}
return

#end::
winget, dwstyle, style, a
if dwstyle & 0x20000 ; WS_MINIMIZEBOX
  winminimize a
return

#+end::
winget, minmax, minmax, ahk_id %id%
if minmax = -1
  winrestore ahk_id %id%
return

exit:
exitapp