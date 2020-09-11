; run as administrator

menu, tray, icon, images\volume.png
menu, tray, nostandard
menu, tray, add, Exit

#numpadadd::
send {volume_up}
return

#numpadsub::
send {volume_down}
return

exit:
exitapp