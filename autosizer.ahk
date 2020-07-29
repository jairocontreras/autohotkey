#persistent
setbatchlines -1
menu, tray, icon, images/autosizer.png
menu, tray, nostandard
menu, tray, add, Edit
menu, tray, add, Exit
gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
onmessage(dllcall("RegisterWindowMessage", str, "shellhook"), "shellmessage")
return

shellmessage(wparam) {
  if wparam = 1 ; HSHELL_WINDOWCREATED
  {
    winexist("a")
    winget, process, processname
    loop, read, list.txt
    {
      loop, parse, a_loopreadline, %a_space%
        item%a_index% = %a_loopfield%
      if item1 = % substr(process, 1, strlen(process)-4)
      {
        wingetclass class
        if (item2 and class != item2)
          exit
        winmaximize
      }
    }
  }
}

edit:
run explorer list.txt
return

exit:
exitapp