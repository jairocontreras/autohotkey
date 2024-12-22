persistent
trayseticon("images\sound check.png",, 1)
setworkingdir "audio"
onmessage 0x404, ahk_notifyicon
return

ahk_notifyicon(wparam, lparam, *) {
  if lparam = 0x0202 ; WM_LBUTTONUP
    soundplay "left.mp3"
  else if lparam = 0x0205 { ; WM_RBUTTONUP
    soundplay "right.mp3"
    pause 1
    return 1
  }
  else if lparam = 0x0208 ; WM_MBUTTONUP
    exitapp
}