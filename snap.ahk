menu, tray, tip, Snap
menu, tray, nostandard
menu, tray, add, Exit

sysget, n, monitorworkarea

global WS_SIZEBOX = 0x40000
global h_half := nbottom/2
global w_half := a_screenwidth/2
global nbottom

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
extend("horizontal")
return

#+up::
#+down::
extend("vertical")
return

snap_h(key) {
  winexist("a")
  winget, dwstyle, style
  if dwstyle & WS_SIZEBOX
  {
    wingetpos,, y1,, h1
    h1 -= 7
    if (key = "left")
      x = 0
    else
      x = %w_half%
    if (h1 <= h_half and y1+h1 = nbottom)
      y = %h_half%
    else
      y = 0
    if (h1 <= h_half and (y1 = 0 or y1+h1 = nbottom))
      h = %h_half%
    else
      h = %nbottom%
    winmove(x, y, w_half, h)
  }
}

snap_v(key) {
  winexist("a")
  winget, dwstyle, style
  if dwstyle & WS_SIZEBOX
  {
    wingetpos, x1,, w1
    x1 += 7
    w1 -= 14
    if (w1 <= w_half and x1+w1 = a_screenwidth)
      x = %w_half%
    else
      x = 0
    if (key = "up")
      y = 0
    else
      y = %h_half%
    if (w1 <= w_half and (x1 = 0 or x1+w1 = a_screenwidth))
      w = %w_half%
    else
      w = %a_screenwidth%
    winmove(x, y, w, h_half)
  }
}

extend(direction) {
  winexist("a")
  winget, dwstyle, style
  if dwstyle & WS_SIZEBOX
  {
    if (direction = "horizontal") {
      x = 0
      w = %a_screenwidth%
      x -= 7
      w += 14
      winmove,,, x,, w
    }
    else {
      h = %nbottom%
      h += 7
      winmove,,,, 0,, h
    }
  }
}

winmove(x, y, w, h) {
  x -= 7
  w += 14
  h += 7
  varsetcapacity(lpwndpl, 44)
  ; length
  numput(44, lpwndpl,, uint)
  ; showcmd
  numput(9, lpwndpl, 8, uint) ; SW_RESTORE
  ; rcnormalposition
  numput(x, lpwndpl, 28, "int") ; left
  numput(y, lpwndpl, 32, "int") ; top
  numput(x+w, lpwndpl, 36, "int") ; right
  numput(y+h, lpwndpl, 40, "int") ; bottom
  dllcall("SetWindowPlacement", ptr, winexist("a"), ptr, &lpwndpl)
}

exit:
exitapp