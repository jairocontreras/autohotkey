menu, tray, icon, images\volume.png

detecthiddenwindows on

#if mouseisover("ahk_class Shell_TrayWnd")
wheelup::
send {volume_up}
return

wheeldown::
send {volume_down}
return

~mbutton::
winget, pid, pid, ahk_class Shell_TrayWnd
hproc := dllcall("OpenProcess", uint, 0x38, int, 0, uint, pid)
prb := dllcall("VirtualAllocEx", ptr, hproc, ptr, 0, uptr, 20, uint, 0x1000, uint, 0x4)
sendmessage, 0x418, 0, 0, toolbarwindow323, ahk_class Shell_TrayWnd ; TB_BUTTONCOUNT
szbtn := varsetcapacity(btn, (a_is64bitos ? 32 : 20), 0)
sznfo := varsetcapacity(nfo, (a_is64bitos ? 32 : 24), 0)
sztip := varsetcapacity(tip, 128 * 2, 0)
loop %errorlevel% {
  sendmessage, 0x417, a_index-1, prb, toolbarwindow323, ahk_class Shell_TrayWnd ; TB_GETBUTTON
  dllcall("ReadProcessMemory", ptr, hproc, ptr, prb, ptr, &btn, uptr, szbtn, uptr, 0)
  dwdata := numget(btn, (a_is64bitos ? 16 : 12))
  istring := numget(btn, (a_is64bitos ? 24 : 16), ptr)
  dllcall("ReadProcessMemory", ptr, hproc, ptr, dwdata, ptr, &nfo, uptr, sznfo, uptr, 0)
  hwnd := numget(nfo, 0, ptr)
  winget, process, processname, ahk_id %hwnd%
  if process = explorer.exe
  {
    dllcall("ReadProcessMemory", ptr, hproc, ptr, istring, ptr, &tip, uptr, sztip, uptr, 0)
    sendmessage, 0x447, 0, 0, toolbarwindow323, ahk_class Shell_TrayWnd ; TB_GETHOTITEM
    if (instr(strget(&tip, "utf-16"), "speakers:") && (errorlevel << 32 >> 32) = a_index-1)
      send {volume_mute}
  }
}
dllcall("VirtualFreeEx", ptr, hproc, ptr, prb, uptr, 0, uint, 0x8000)
dllcall("CloseHandle", ptr, hproc)
return
#if

mouseisover(wintitle) {
  mousegetpos,,, win
  return winexist(wintitle " ahk_id" win)
}