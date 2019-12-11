#persistent
setbatchlines -1

menu, tray, tip, AutoSizer
menu, tray, nostandard
menu, tray, add, Exit

gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
msgnumber := dllcall("RegisterWindowMessage", str, "shellhook")
onmessage(msgnumber, "shellmessage")
return

shellmessage(wparam, lparam) {
  if wparam = 1 ; HSHELL_WINDOWCREATED
  {
    wingetclass, class, ahk_id %lparam%
    if class = CabinetWClass
    {
      x = 0
      w = %a_screenwidth%
      h := a_screenheight-40
      x -= 7
      w += 14
      h += 7
      winmove, ahk_id %lparam%,, x, 0, w, h
      winmaximize ahk_id %lparam%
    }
  }
}

exit:
exitapp