menu, tray, icon, images\volume.png
menu, tray, nostandard
menu, tray, add, Exit

#if mouseisover("ahk_class Shell_TrayWnd")
wheelup::send {volume_up}
wheeldown::send {volume_down}
#if

mouseisover(wintitle) {
  mousegetpos,,, win
  return winexist(wintitle . " ahk_id" . win)
}

exit:
exitapp