; run as administrator

coordmode mouse ; screen
menu, tray, icon, images\media.png
menu, tray, nostandard
menu, tray, add, Exit

#if mouseisover("ahk_class Shell_TrayWnd")
wheelup::
send {volume_up}
return

wheeldown::
send {volume_down}
return
#if

mouseisover(wintitle) {
  mousegetpos,,, win
  return winexist(wintitle " ahk_id" win)
}

#enter::
#numpadenter::
send {media_play_pause}
return

#pgup::
send {media_prev}
return

#pgdn::
send {media_next}
return

exit:
exitapp