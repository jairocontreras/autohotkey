#persistent
setbatchlines -1

; scheduled task
detecthiddenwindows on
setworkingdir %a_scriptdir%

menu, tray, tip, AutoSizer
menu, tray, nostandard
menu, tray, add, Edit
menu, tray, add, Exit

gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
msgnumber := dllcall("RegisterWindowMessage", str, "shellhook")
onmessage(msgnumber, "shellmessage")
return

shellmessage(wparam, lparam) {
  if wparam = 1 ; HSHELL_WINDOWCREATED
  {
    winget, process, processname, ahk_id %lparam%
    exe := substr(process, 1, strlen(process)-4)
    if exe = StartMenuExperienceHost
    {
      detecthiddenwindows off
      exit
    }
    winwait ahk_id %lparam%
    fileread, contents, apps.txt
    apps := strreplace(contents, "`r`n", ",")
    if exe in %apps%
    {
      if exe = explorer
      {
        wingetclass class
        if class != cabinetwclass
          exit
      }
      x = 0
      w = %a_screenwidth%
      h := a_screenheight-40
      x -= 7
      w += 14
      h += 7
      winmove,,, x, 0, w, h
      winmaximize
    }
  }
}

edit:
run explorer apps.txt
return

exit:
exitapp