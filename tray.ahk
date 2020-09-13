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
    global process
    winget, process, processname, ahk_id %lparam%
    loop, read, tray.txt
    {
      if (substr(process, 1, strlen(process)-4) = strsplit(a_loopreadline, "*")[1]) {
        winwait ahk_id %lparam%
        gosub remove
        if instr(a_loopreadline, "*")
          gosub remove
        break
      }
    }
  }
}

edit:
run explorer tray.txt
return

remove:
info := trayicon_getinfo(process)
loop % info.maxindex()
  trayicon_remove(info[a_index].hwnd, info[a_index].uid)
return

exit:
exitapp