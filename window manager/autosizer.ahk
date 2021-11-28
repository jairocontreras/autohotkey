#persistent
setbatchlines -1
menu, tray, icon, images\autosizer.png
menu, tray, nostandard
menu, tray, add, Edit
menu, tray, add, Exit
file = autosizer\apps.txt
sysget, screen, monitorworkarea
global screenbottom
gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
onmessage(dllcall("RegisterWindowMessage", str, "shellhook"), "shellmessage")
return

shellmessage(wparam, lparam) {
  if wparam = 1 ; HSHELL_WINDOWCREATED
  {
    global file
    winexist("a")
    winget, process, processname
    exe := substr(process, 1, strlen(process)-4)
    loop, read, %file%
    {
      if exe = %a_loopreadline%
        gosub maximize
    }
  }
}

edit:
run explorer %file%
return

maximize:
winmove,,, -7, 0, a_screenwidth+14, screenbottom+7
winmaximize
return

exit:
exitapp