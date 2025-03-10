processsetpriority "h"
persistent
trayseticon("images\workspace.png")
coordmode "mouse"
monitorgetworkarea(,,,, &screenheight)
hookprocadr := callbackcreate(capturewinevent, "f")
hwineventhook := setwineventhook(0x1, 0x17, 0, hookprocadr, 0, 0, 0)
onexit exit
return

capturewinevent(hwineventhook, event, hwnd) {
  if event = 10 ; EVENT_SYSTEM_MOVESIZESTART
    global cursor := a_cursor
  else if event = 11 { ; EVENT_SYSTEM_MOVESIZEEND
    if winexist(hwnd) {
      mousegetpos , &mouse_y
      if (mouse_y = 0) and (cursor = "arrow") and (wingetstyle() & 0x10000) ; WS_MAXIMIZEBOX
        winmaximize
      else {
        ; merge tabs
        if !winexist()
          return
        wingetpos &x, &y, &w, &h
        x += 7
        w -= 14
        h -= 7
        x_right := x+w
        ; move
        if cursor = "arrow" {
          y_bottom := y+h
          if x < 0
            x := 0
          else if x_right > a_screenwidth
            x -= x_right - a_screenwidth
          if y_bottom > screenheight
            y -= y_bottom - screenheight
        }
        ; resize left/right
        else if cursor = "sizewe" {
          if x <= 7 {
            w += x
            x := 0
          }
          if x_right >= a_screenwidth - 7
            w += a_screenwidth - x_right
        }
        ; resize top/bottom
        else if cursor = "sizens" {
          ; restore to screen
          if y < 0
            y := 0
          if h > screenheight
            h -= h - screenheight
          ; fill to edge
          y_bottom := y+h
          if y_bottom >= screenheight - 7
            h += screenheight - y_bottom
        }
        x -= 7
        w += 14
        h += 7
        winmove x, y, w, h
      }
    }
  }
}

setwineventhook(eventmin, eventmax, hmodwineventproc, lpfnwineventproc, idprocess, idthread, dwflags) {
  dllcall("ole32\CoInitialize", "uint", 0)
  return dllcall("SetWinEventHook", "uint", eventmin, "uint", eventmax, "uint", hmodwineventproc, "uint", lpfnwineventproc, "uint", idprocess, "uint", idthread, "uint", dwflags)
}

exit(*) {
  dllcall("UnhookWinEvent", "uint", hwineventhook)
  dllcall("GlobalFree", "uint", hookprocadr)
}