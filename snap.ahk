menu, tray, icon, images\snap.png
sysget, screen, monitorworkarea
global WS_SIZEBOX = 0x40000
global w_half := a_screenwidth/2
global h_half := screenbottom/2
global screenbottom

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
winexist("a")
winmove(w_half/2, h_half/2, w_half, h_half)
return

#+space::
winexist("a")
winmove(0, 0, a_screenwidth, screenbottom)
return

snap_h(key) {
  winexist("a")
  if key = left
    x = 0
  else
    x = %w_half%
  wingetpos,, y2,, h2
  h2 -= 7
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
  if (w2 <= w_half and x2+w2 = a_screenwidth)
    x = %w_half%
  else
    x = 0
  if key = up
    y = 0
  else
    y = %h_half%
  if (w2 <= w_half and (x2 = 0 or x2+w2 = a_screenwidth))
    w = %w_half%
  else
    w = %a_screenwidth%
  winmove(x, y, w, h_half)
}

extend(direction) {
  winexist("a")
  winget, dwstyle, style
  if dwstyle & WS_SIZEBOX {
    if direction = x
      winmove,,, -7,, a_screenwidth+14
    else
      winmove,,,, 0,, screenbottom+7
  }
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