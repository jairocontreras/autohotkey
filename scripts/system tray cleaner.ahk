persistent
trayseticon("images/system tray cleaner.png")
_gui := gui()
dllcall("RegisterShellHookWindow", "uint", _gui.hwnd)
onmessage dllcall("RegisterWindowMessage", "str", "shellhook"), captureshellmessage

captureshellmessage(wparam, lparam, msg, hwnd) {
  if wparam = 1 { ; HSHELL_WINDOWCREATED
    id := winexist("ahk_id " lparam)
    loop read "apps.txt" {
      if wingetprocessname() = a_loopreadline ".exe"  {
        notifyicondata := buffer(24)
        numput "ptr", 24, notifyicondata ; cbsize
        numput "uint", id, notifyicondata, 8 ; hwnd
        numput "uint", 0, notifyicondata, 16 ; uid
        dllcall("shell32\Shell_NotifyIcon", "uint", 2, "ptr", notifyicondata) ; NIM_DELETE
      }
    }
  }
}