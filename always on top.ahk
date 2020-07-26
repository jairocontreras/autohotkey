#persistent
setbatchlines -1
menu, tray, icon, imageres.dll, 234
menu, tray, nostandard
menu, tray, add, Exit
gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
onmessage(dllcall("RegisterWindowMessage", str, "shellhook"), "shellmessage")

#a::
winexist("a")
winset, alwaysontop
goto tray
return

shellmessage(wparam) {
  if wparam = 32772 ; HSHELL_RUDEAPPACTIVATED
  {
    winexist("a")
    wingetclass class
    if class not in shell_traywnd,multitaskingviewframe
      gosub tray
  }
}

tray:
winget, exstyle, exstyle
if exstyle & 0x8 ; WS_EX_TOPMOST
  menu, tray, icon, images\alwaysontop.png
else
  menu, tray, icon, imageres.dll, 234
return

exit:
exitapp