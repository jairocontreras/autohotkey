#notrayicon
icon := "images\icon resource viewer.ico"
; window
trayseticon(icon)
my_gui := gui(, "Icon Resource Viewer")
; taskbar
sendmessage(0x0080, 1, loadpicture(icon, "w24", &imagetype), my_gui) ; WM_SETICON, ICON_BIG
my_gui.opt("-minimizebox")
my_gui.marginy := 10
my_gui.add("text", "ym4", "File:")
my_file := my_gui.add("edit", "x+m5 ym")
my_file.onevent("change", change)
my_gui.add("text", "section xm y+m4", "Index:")
index := my_gui.add("edit", "x+5 ys-4")
index.onevent("change", change)
my_gui.add("updown", "range0-999")
icon := my_gui.add("pic", "h32 w32 ym10")
my_gui.show()
return

change(*) {
  if instr(my_file.text, ".") and isinteger(index.text) {
    _index := index.text
    if _index >= 0
      _index += 1
    try
      icon.value := "*icon" _index " " my_file.text
    catch
      icon.visible := 0
    else
      icon.visible := 1
  }
  else
    icon.visible := 0
}