menu, tray, icon, images\opennewwindow.png

~mbutton::
winwaitactive, ahk_class CabinetWClass,, 1
if winactive("ahk_class CabinetWClass") {
  mousegetpos,,,, control
  if control = systreeview321
    send {rbutton}e
}
return