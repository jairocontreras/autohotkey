#persistent
setbatchlines -1
menu, tray, icon, images\system tray.png
menu, tray, nostandard
menu, tray, add, Edit
menu, tray, add, Exit
global process
gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
onmessage(dllcall("RegisterWindowMessage", str, "shellhook"), "shellmessage")

; when you open app(s) before running script
loop, read, apps.txt
{
  process = % strsplit(a_loopreadline, "*")[1] ".exe"
  gosub remove
}
return

shellmessage(wparam, lparam) {
  if wparam = 1 ; HSHELL_WINDOWCREATED
  {
    winget, process, processname, ahk_id %lparam%
    loop, read, apps.txt
    {
      if (strsplit(a_loopreadline, "*")[1] ".exe" = process) {
        winwait ahk_id %lparam%
        gosub remove
        break
      }
    }
  }
}

edit:
run explorer apps.txt
return

remove:
detecthiddenwindows on
winget, pid, pid, ahk_class NotifyIconOverflowWindow
hproc := dllcall("OpenProcess", uint, 0x38, int, 0, uint, pid)
prb := dllcall("VirtualAllocEx", ptr, hproc, ptr, 0, uptr, 20, uint, 0x1000, uint, 0x4)
sendmessage, 0x418, 0, 0, toolbarwindow321, ahk_class NotifyIconOverflowWindow ; TB_BUTTONCOUNT
szbtn := varsetcapacity(btn, (a_is64bitos ? 32 : 20), 0)
sznfo := varsetcapacity(nfo, (a_is64bitos ? 32 : 24), 0)
sztip := varsetcapacity(tip, 128 * 2, 0)
loop %errorlevel% {
  sendmessage, 0x417, a_index-1, prb, toolbarwindow321, ahk_class NotifyIconOverflowWindow ; TB_GETBUTTON
  dllcall("ReadProcessMemory", ptr, hproc, ptr, prb, ptr, &btn, uptr, szbtn, uptr, 0)
  dwdata := numget(btn, (a_is64bitos ? 16 : 12))
  istring := numget(btn, (a_is64bitos ? 24 : 16), ptr)
  dllcall("ReadProcessMemory", ptr, hproc, ptr, dwdata, ptr, &nfo, uptr, sznfo, uptr, 0)
  _hwnd := numget(nfo, 0, ptr)
  winget, _process, processname, ahk_id %_hwnd%
  if process = %_process%
  {
    sendmessage, 0x416, a_index-1, 0, toolbarwindow321, ahk_class NotifyIconOverflowWindow ; TB_DELETEBUTTON
    sendmessage, 0x1a, 0, 0,, ahk_class NotifyIconOverflowWindow ; WM_SETTINGCHANGE
  }
}
dllcall("VirtualFreeEx", ptr, hproc, ptr, prb, uptr, 0, uint, 0x8000)
dllcall("CloseHandle", ptr, hproc)
detecthiddenwindows off
return

exit:
exitapp