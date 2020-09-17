#persistent
#include include\trayicon.ahk
setbatchlines -1
menu, tray, icon, images\tray.png
menu, tray, nostandard
menu, tray, add, Edit
menu, tray, add, Exit
global process
gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
onmessage(dllcall("RegisterWindowMessage", str, "shellhook"), "shellmessage")
loop, read, tray.txt
{
  process = % strsplit(a_loopreadline, "*")[1] ".exe"
  gosub remove
  if instr(a_loopreadline, "*")
    gosub remove
}
return

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