trayseticon("images\snap.png")
monitorgetworkarea(,,,, &screenheight)
screenwidth_half := a_screenwidth/2
screenheight_half := screenheight/2
#left::snap("left")
#right::snap("right")
#up::snap("up")
#down::snap("down")
#c::snap("center")
#+left::
#+right::snap("horizontal", true)
#+up::
#+down::snap("vertical", true)

snap(direction, extend := false) {
  hwnd := winexist("a")
  if wingetstyle() & 0x40000 { ; WS_SIZEBOX
    if extend {
      if direction = "horizontal"
        winmove -7,, a_screenwidth+14
      else
        winmove , 0,, screenheight+7
    }
    else {
      wingetpos &x_current, &y_current, &w_current, &h_current
      x_current += 7
      w_current -= 14
      h_current -= 7
      if direction = "left"
        x := 0
      else if direction = "right"
        x := screenwidth_half
      else if direction = "up"
        y := 0
      else if direction = "down"
        y := screenheight_half
      else {
        w := screenwidth_half
        h := screenheight_half
        x := w/2
        y := h/2
      }
      if direction = "left" or direction = "right" {
        if (y_current = 0 or y_current = screenheight_half) and (w_current = a_screenwidth or w_current = screenwidth_half) and h_current = screenheight_half {
          if y_current = screenheight_half
            y := screenheight_half
          else
            y := 0
          h := screenheight_half
        }
        else {
          y := 0
          h := screenheight
        }
        w := screenwidth_half
      }
      else if direction = "up" or direction = "down" {
        if (x_current = 0 or x_current = screenwidth_half) and w_current = screenwidth_half and (h_current = screenheight or h_current = screenheight_half) {
          if x_current = screenwidth_half
            x := screenwidth_half
          else
            x := 0
          w := screenwidth_half
        }
        else {
          x := 0
          w := a_screenwidth
        }
        h := screenheight_half
      }
      x -= 7
      w += 14
      h += 7
      windowplacement := buffer(44)
      ; length
      numput "uint", 44, windowplacement
      ; showcmd
      numput "uint", 9, windowplacement, 8 ; SW_RESTORE
      ; rcnormalposition
      numput "int", x, windowplacement, 28 ; left
      numput "int", y, windowplacement, 32 ; top
      numput "int", x+w, windowplacement, 36 ; right
      numput "int", y+h, windowplacement, 40 ; bottom
      dllcall("SetWindowPlacement", "ptr", hwnd, "ptr", windowplacement)
    }
  }
}