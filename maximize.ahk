setbatchlines -1

; scheduled task
setworkingdir %a_scriptdir%

menu, tray, icon, images/maximize.png
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
winexist("a")
winget, minmax, minmax
if minmax = 1 ; maximized
  winrestore
else {
  winget, dwstyle, style
  if dwstyle & 0x10000 ; WS_MAXIMIZEBOX
    winmaximize
}
return

#end::
winexist("a")
winget, dwstyle, style
if dwstyle & 0x20000 ; WS_MINIMIZEBOX
  winminimize
return

#+end::
winexist("ahk_id" . id)
winget, minmax, minmax
if minmax = -1 ; minimized
  winrestore
return

exit:
exitapp