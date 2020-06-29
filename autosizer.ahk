#persistent
setbatchlines -1

; scheduled task
detecthiddenwindows on
setworkingdir %a_scriptdir%

menu, tray, tip, AutoSizer
menu, tray, nostandard
menu, tray, add, Edit
menu, tray, add, Exit

filename = apps.txt
attribute := fileexist(filename)
if !attribute
{
  fileappend,, %filename%
  msgbox,, AutoSizer, A text file named 'apps' was automatically created.`nAdd one executable filename per line.
  run explorer %filename%
}

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
    global filename
    fileread, contents, %filename%
    apps := strreplace(contents, "`r`n", ",")
    if exe in %apps%
    {
      wingetclass class
      if exe = explorer
      {
        if class != cabinetwclass
          exit
      }
      if exe = notepad++
      {
        if class = nppprogressclass
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
run explorer %filename%
return

exit:
exitapp