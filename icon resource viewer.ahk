#notrayicon
#singleinstance off
coordmode, tooltip, client
sendmode input

BS_NOTIFY = 0x4000

gui +hwndhwnd +minsize298x114 +maxsizex114 +resize
gui, margin,, 10
gui, add, edit, section vfilename gload, filename
gui, add, edit, vindex gload, index
gui, add, picture, w32 h32 vicon
gui, add, button, ys-1 vhelp_filename ghelp_filename %BS_NOTIFY%, ?
gui, add, button, y+8 vhelp_index ghelp_index %BS_NOTIFY%, ?
gui, show,, Icon Resource Viewer

hotkey, ifwinactive, ahk_id %hwnd%
hotkey, ~down, down
hotkey, ~up, up

onmessage(0x03, "WM_MOVE") ; maximize/restore/snap using keyboard
onmessage(0xa1, "WM_NCLBUTTONDOWN") ; click non-client area
onmessage(0x111, "WM_COMMAND") ; focus another control or switch window
onmessage(0x201, "WM_LBUTTONDOWN") ; click empty space
return

guisize:
list = filename,index
loop, parse, list, `,
{
  guicontrol, move, %a_loopfield%, % "w" a_guiwidth-41
  guicontrol, move, help_%a_loopfield%, % "x" a_guiwidth-27
}
guicontrol, move, icon, % "x" (a_guiwidth/2)-16
return

guiclose:
exitapp

load:
gui, submit, nohide
if filename contains .
{
  if index is integer
  {
    if index > -1
      index += 1
    guicontrol,, icon, *icon%index% %filename% ; index represents group
    guicontrol, show, icon
  }
  else
    guicontrol, hide, icon
}
else
  guicontrol, hide, icon
return

down:
guicontrolget, focus, focusv
if focus = index
{
  gui, submit, nohide
  if index is integer
  {
    if index > 0
      index -= 1
    else if index < -1
      index += 1
    guicontrol,, index, %index%
    send {end}
  }
}
return

up:
guicontrolget, focus, focusv
if focus = index
{
  gui, submit, nohide
  if index is integer
  {
    if index > -1
      index += 1
    else if index < 0
      index -= 1
    guicontrol,, index, %index%
    send {end}
  }
}
return

help_filename:
guicontrolget, help_filename, pos
tooltip, % "- absolute, relative, or PATH (environment variable)`n- supported file types: ani, cpl, cur, dll, exe, ico, scr", help_filenamex+22, help_filenamey+1
return

help_index:
guicontrolget, help_index, pos
tooltip, supports up and down arrow keys, help_indexx+22, help_indexy+1
return

WM_MOVE() {
  tooltip
}

WM_NCLBUTTONDOWN() {
  tooltip
}

WM_COMMAND(wparam) {
  if (wparam>>16) = 7 ; BN_KILLFOCUS
    tooltip
}

WM_LBUTTONDOWN() {
  if !a_guicontrol
    tooltip
}