#persistent
setbatchlines -1
menu, tray, icon, images\autosizer.png
menu, tray, nostandard
menu, tray, add, Edit
menu, tray, add, Exit
detecthiddenwindows on ; scheduled task
sysget, screen, monitorworkarea
global screenbottom
gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
onmessage(dllcall("RegisterWindowMessage", str, "shellhook"), "shellmessage")
return

shellmessage(wparam, lparam) {
  if wparam = 1 ; HSHELL_WINDOWCREATED
  {
    winget, process, processname, ahk_id %lparam%
    exe := substr(process, 1, strlen(process)-4)
    if exe = startmenuexperiencehost
    {
      detecthiddenwindows off
      exit
    }
    winwait ahk_id %lparam% ; winexist("a") not good for applicationframehost
    loop, read, exceptions.txt
    {
      titlelist =
      loop, parse, a_loopreadline, csv
      {
        if a_index = 1
          exec = %a_loopfield%
        else
          titlelist .= a_loopfield ","
      }
      if exec = %exe%
      {
        if titlelist {
          wingettitle title
          if title in %titlelist%
            exit
        }
        else
          exit
      }
    }
    winget, dwstyle, style
    if dwstyle & 0x10000 { ; WS_MAXIMIZEBOX
      winmove,,, -7, 0, a_screenwidth+14, screenbottom+7
      winmaximize
    }
  }
}

edit:
run explorer exceptions.txt
return

exit:
exitapp