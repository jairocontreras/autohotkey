; run as administrator

menu, tray, icon, images\media.png
menu, tray, nostandard
menu, tray, add, Exit

#numpadadd::
send {volume_up}
return

#numpadsub::
send {volume_down}
return

#enter::
#numpadenter::
send {media_play_pause}
return

#numpad4::
send {media_prev}
return

#numpad6::
send {media_next}
return

exit:
exitapp