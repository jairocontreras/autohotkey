setbatchlines -1
menu, tray, icon, images\alwaysontop.png
menu, tray, nostandard
menu, tray, add, Exit
global exclude
gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
onmessage(dllcall("RegisterWindowMessage", str, "shellhook"), "shellmessage")

#t::
winexist("a")
winset alwaysontop
goto tray
return

shellmessage(wparam) {
  if wparam = 32772 ; HSHELL_RUDEAPPACTIVATED
  {
    winexist("a")
    winget, process, processname
    classlist =
    exclude := false
    loop, read, exceptions.txt
    {
      loop, parse, a_loopreadline, %a_space%
      {
        if a_index = 1
          exe = %a_loopfield%
        else
          classlist .= a_loopfield ","
      }
      if exe = % substr(process, 1, strlen(process)-4)
      {
        if classlist {
          wingetclass class
          if class in %classlist%
            exclude := true
        }
        else
          exclude := true
      }
    }
    gosub tray
  }
}

tray:
winget, exstyle, exstyle
if (exstyle & 0x8 and !exclude) ; WS_EX_TOPMOST
  menu, tray, icon, imageres.dll, 234
else
  menu, tray, icon, images\alwaysontop.png
return

exit:
exitapp