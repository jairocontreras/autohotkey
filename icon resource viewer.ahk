#notrayicon
icon := "images\icon resource viewer.ico"
; window
trayseticon(icon)
b_gui := gui(, "Icon Resource Viewer")
; taskbar
sendmessage(0x0080, 1, loadpicture(icon, "w24", &imagetype), b_gui) ; WM_SETICON, ICON_BIG
b_gui.opt("-minimizebox")
b_gui.marginy := 10
b_gui.add("text", "ym4", "File:")
b_file := b_gui.add("edit", "x+m5 ym")
b_file.onevent("change", change)
b_gui.add("text", "section xm y+m4", "Index:")
index := b_gui.add("edit", "x+5 ys-4")
index.onevent("change", change)
b_gui.add("updown", "range0-999")
icon := b_gui.add("pic", "h32 w32 ym10")
b_gui.show()

change(*) {
  if instr(b_file.text, ".") and isinteger(index.text) {
    _index := index.text
    if _index >= 0
      _index += 1
    try
      icon.value := "*icon" _index " " b_file.text
    catch
      icon.visible := 0
    else
      icon.visible := 1
  }
  else
    icon.visible := 0
}