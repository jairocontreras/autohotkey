menu, tray, icon, images\opennewwindow.png
menu, tray, nostandard
menu, tray, add, Exit

~mbutton::
mousegetpos,,,, control
if control = systreeview321
  send {rbutton}e
return

exit:
exitapp