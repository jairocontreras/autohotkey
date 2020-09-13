#notrayicon
#include include\trayicon.ahk
loop, read, tray.txt
{
  info := trayicon_getinfo(a_loopreadline . ".exe")[1]
  trayicon_remove(info.hwnd, info.uid)
}