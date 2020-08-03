menu, tray, icon, images\volume.png
menu, tray, nostandard
menu, tray, add, Exit
coordmode mouse ; screen
coordmode tooltip ; screen
sysget, screen, monitorworkarea
global screenbottom

loop {
  mousegetpos, x2, y2
  if (abs(x2-x) > 20 or y2 < screenbottom)
    tooltip
}

#if mouseisover("ahk_class Shell_TrayWnd")
wheelup::
send {volume_up}
tooltip()
return

wheeldown::
send {volume_down}
tooltip()
return
#if

mouseisover(wintitle) {
  mousegetpos,,, win
  return winexist(wintitle " ahk_id" win)
}

tooltip() {
  global x
  soundget volume
  mousegetpos x
  if volume > 9
    x -= 3
  tooltip, % ceil(volume) "%", x-14, screenbottom-21
}

exit:
exitapp