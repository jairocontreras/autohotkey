; run as administrator

menu, tray, icon, images\media.png
menu, tray, nostandard
menu, tray, add, Exit

^#up::
send {volume_up}
return

^#down::
send {volume_down}
return

^#space::
send {media_play_pause}
return

^#left::
send {media_prev}
return

^#right::
send {media_next}
return

exit:
exitapp