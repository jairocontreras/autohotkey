trayseticon("images\media controls.png")
return

!space::do(0xe0000) ; APPCOMMAND_MEDIA_PLAY_PAUSE
!left::do(0xc0000) ; APPCOMMAND_MEDIA_PREVIOUSTRACK
!right::do(0xb0000) ; APPCOMMAND_MEDIA_NEXTTRACK

do(action) {
  if winexist("ahk_exe spotify.exe")
    postmessage 0x319,, action ; WM_APPCOMMAND
}