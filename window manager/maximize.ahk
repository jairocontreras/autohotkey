processsetpriority "h"
trayseticon("images\maximize.png")
id := ""
hookprocadr := callbackcreate(capturewinevent, "f")
hwineventhook := setwineventhook(0x1, 0x17, 0, hookprocadr, 0, 0, 0)
onexit exit

capturewinevent(hwineventhook, event, hwnd) {
  if event = 22 ; EVENT_SYSTEM_MINIMIZESTART
    global id := hwnd
}

setwineventhook(eventmin, eventmax, hmodwineventproc, lpfnwineventproc, idprocess, idthread, dwflags) {
  dllcall("ole32\CoInitialize", "uint", 0)
  return dllcall("SetWinEventHook", "uint", eventmin, "uint", eventmax, "uint", hmodwineventproc, "uint", lpfnwineventproc, "uint", idprocess, "uint", idthread, "uint", dwflags)
}

#space::
{
  winexist("a")
  if wingetstyle() & 0x10000 { ; WS_MAXIMIZEBOX
    if wingetminmax() = 0 ; normal
      winmaximize
    else
      winrestore
  }
}

#pgdn::
{
  winexist("a")
  if wingetstyle() & 0x20000 ; WS_MINIMIZEBOX
    winminimize
}

#pgup::
{
  if winexist(id) {
    if wingetminmax() = -1 ; minimized, not maximized
      winrestore
  }
}

exit(*) {
  dllcall("UnhookWinEvent", "uint", hwineventhook)
  dllcall("GlobalFree", "uint", hookprocadr)
}