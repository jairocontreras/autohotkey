#persistent
#include include\trayicon.ahk
setbatchlines -1
menu, tray, icon, images\tray.png
menu, tray, nostandard
menu, tray, add, Edit
menu, tray, add, Exit
global process
onmessage(0x404, "AHK_NOTIFYICON")
gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
onmessage(dllcall("RegisterWindowMessage", str, "shellhook"), "shellmessage")
return

AHK_NOTIFYICON(wparam, lparam) {
  if lparam = 0x202 ; WM_LBUTTONUP
  {
    loop, read, tray.txt
    {
      process = % strsplit(a_loopreadline, "*")[1] ".exe"
      gosub remove
      if instr(a_loopreadline, "*")
        gosub remove
    }
  }
}

shellmessage(wparam, lparam) {
  if wparam = 1 ; HSHELL_WINDOWCREATED
  {
    winget, process, processname, ahk_id %lparam%
    loop, read, tray.txt
    {
      if (strsplit(a_loopreadline, "*")[1] ".exe" = process) {
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