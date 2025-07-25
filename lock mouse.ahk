trayseticon("images\lock mouse.png")
a_hotkeyinterval := 0
varsetstrcapacity(&lprect, 16)
target := strptr(lprect)
loop 4
  numput "int", 0, target, (a_index-1)*4
dllcall("ClipCursor", "ptr", target)
return

lbutton::
mbutton::
rbutton::
wheeldown::
wheelup::return

~esc::
{
  dllcall("ClipCursor", "ptr", 0)
  exitapp
}