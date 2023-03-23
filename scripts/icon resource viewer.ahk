#notrayicon
_gui := gui()
_gui.marginy := 10
_gui.add("text", "ym4", "File:")
_file := _gui.add("edit", "x+m5 ym")
_file.onevent("change", change)
_gui.add("text", "section xm y+m4", "Index:")
index := _gui.add("edit", "x+5 ys-4")
index.onevent("change", change)
_gui.add("updown", "range0-999")
icon := _gui.add("pic", "h32 w32 ym10")
_gui.show()

change(*) {
  if instr(_file.text, ".") and isinteger(index.text) {
    _index := index.text
    if _index >= 0
      _index += 1
    try
      icon.value := "*icon" _index " " _file.text
    catch
      icon.visible := 0
    else
      icon.visible := 1
  }
  else
    icon.visible := 0
}