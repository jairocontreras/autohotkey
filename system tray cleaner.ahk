persistent
trayseticon("images\system tray cleaner.png")

config := "config.txt"
loop read config {
  if winexist("ahk_exe " a_loopreadline ".exe")
    clean(wingetid())
}

b_gui := gui()
dllcall("RegisterShellHookWindow", "uint", b_gui.hwnd)
onmessage dllcall("RegisterWindowMessage", "str", "shellhook"), captureshellmessage

captureshellmessage(wparam, lparam, *) {
  if wparam = 1 { ; HSHELL_WINDOWCREATED
    if winexist("ahk_id " lparam) {
      process := wingetprocessname()
      app := strreplace(process, ".exe", "")
      loop read config {
        if app = a_loopreadline
          clean(wingetid())
      }
    }
  }
}

clean(hwnd) {
  notifyicondata := buffer(24)
  numput "ptr", 24, notifyicondata ; cbsize
  numput "uint", hwnd, notifyicondata, 8
  numput "uint", 0, notifyicondata, 16 ; uid
  dllcall("shell32\Shell_NotifyIcon", "uint", 2, "ptr", notifyicondata) ; NIM_DELETE
}