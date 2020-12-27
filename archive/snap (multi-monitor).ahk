;menu, tray, icon, images\snap.png
sysget, screen, monitorworkarea
global WS_SIZEBOX = 0x40000
global w_half := a_screenwidth/2
global h_half := screenbottom/2
global screenbottom, x_global

#left::
snap_h("left")
return

#right::
snap_h("right")
return

#up::
snap_v("up")
return

#down::
snap_v("down")
return

#+left::
#+right::
extend("x")
return

#+up::
#+down::
extend("y")
return

#c::
x_global := w_half/2
check_monitor()
winmove(x_global, h_half/2, w_half, h_half)
return

#+space::
x_global = 0
check_monitor()
winmove(x_global, 0, a_screenwidth, screenbottom)
return

snap_h(key) {
  winexist("a")
  wingetpos, x2, y2,, h2
  x2 += 7
  h2 -= 7
  if key = left
  {
    x = 0
    if x2 >= %a_screenwidth%
      x += a_screenwidth
  }
  else {
    x = %w_half%
    if x2 >= %a_screenwidth%
      x += a_screenwidth
  }
  if (h2 <= h_half and y2+h2 = screenbottom)
    y = %h_half%
  else
    y = 0
  if (h2 <= h_half and (y2 = 0 or y2+h2 = screenbottom))
    h = %h_half%
  else
    h = %screenbottom%
  winmove(x, y, w_half, h)
}

snap_v(key) {
  winexist("a")
  wingetpos, x2,, w2
  w2 -= 14
  x2 += 7
  if (w2 <= w_half and (x2+w2 = a_screenwidth or x2+w2 = a_screenwidth*2)) {
    x = %w_half%
    if x2 >= %a_screenwidth%
      x += a_screenwidth
  }
  else {
    x = 0
    if x2 >= %a_screenwidth%
      x += a_screenwidth
  }
  if key = up
    y = 0
  else
    y = %h_half%
  if (w2 <= w_half and (x2 = 0 or x2+w2 = a_screenwidth or x2 = a_screenwidth or x2+w2 = a_screenwidth*2))
    w = %w_half%
  else
    w = %a_screenwidth%
  winmove(x, y, w, h_half)
}

extend(direction) {
  winexist("a")
  winget, dwstyle, style
  if dwstyle & WS_SIZEBOX {
    wingetpos x2,, w2
    x2 += 7
    w2 -= 14
    if direction = x
    {
      w = %a_screenwidth%
      if x2 < %a_screenwidth%
      {
        x = 0
        if x2+w2 > %a_screenwidth%
          w *= 2
      }
      else
        x = %a_screenwidth%
      winmove,,, x-7,, w+14
    }
    else
      winmove,,,, 0,, screenbottom+7
  }
}

check_monitor() {
  winexist("a")
  wingetpos x
  x += 7
  if x >= %a_screenwidth%
    x_global += a_screenwidth
}

winmove(x, y, w, h) {
  winget, dwstyle, style
  if dwstyle & WS_SIZEBOX {
    x -= 7
    varsetcapacity(lpwndpl, 44)
    ; length
    numput(44, lpwndpl,, uint)
    ; showcmd
    numput(9, lpwndpl, 8, uint) ; SW_RESTORE
    ; rcnormalposition
    numput(x, lpwndpl, 28, "int") ; left
    numput(y, lpwndpl, 32, "int") ; top
    numput(x+w+14, lpwndpl, 36, "int") ; right
    numput(y+h+7, lpwndpl, 40, "int") ; bottom
    dllcall("SetWindowPlacement", ptr, winexist("a"), ptr, &lpwndpl)
  }
}