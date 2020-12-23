; run as administrator

menu, tray, icon, images\media.png
coordmode mouse ; screen

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

#^left::
send {media_prev}
return

#^right::
send {media_next}
return