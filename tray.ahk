#persistent
#include include\trayicon.ahk
setbatchlines -1
menu, tray, icon, images\tray.png
menu, tray, nostandard
menu, tray, add, Edit
menu, tray, add, Exit
gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
onmessage(dllcall("RegisterWindowMessage", str, "shellhook"), "shellmessage")
return

shellmessage(wparam, lparam) {
  if wparam = 1 ; HSHELL_WINDOWCREATED
  {
    winget, process, processname, ahk_id %lparam%
    fileread, contents, tray.txt
    if (substr(process, 1, strlen(process)-4) in strreplace(contents, "`r`n", ","))
    {
      winwait ahk_id %lparam%
      info := trayicon_getinfo(process)[1]
      trayicon_remove(info.hwnd, info.uid)
    }
  }
}

edit:
run explorer tray.txt
return

exit:
exitapp