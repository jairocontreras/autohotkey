#persistent
#include include\trayicon.ahk
menu, tray, icon, images\tray.png
menu, tray, nostandard
menu, tray, add, Edit
menu, tray, add, Exit
global exe
onmessage(0x404, "AHK_NOTIFYICON")
return

AHK_NOTIFYICON(wparam, lparam) {
  if lparam = 0x202 ; WM_LBUTTONUP
  {
    loop, read, tray.txt
    {
      exe := strsplit(a_loopreadline, "*")[1]
      gosub remove
      if instr(a_loopreadline, "*")
        gosub remove
    }
  } 
}

edit:
run explorer tray.txt
return

remove:
info := trayicon_getinfo(exe . ".exe")
loop % info.maxindex()
  trayicon_remove(info[a_index].hwnd, info[a_index].uid)
return

exit:
exitapp