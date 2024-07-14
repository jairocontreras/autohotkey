trayseticon("images\media controls.png")
!space::do(0xe0000) ; APPCOMMAND_MEDIA_PLAY_PAUSE
!left::do(0xc0000) ; APPCOMMAND_MEDIA_PREVIOUSTRACK
!right::do(0xb0000) ; APPCOMMAND_MEDIA_NEXTTRACK
return

do(action) {
  postmessage 0x319,, action,, "ahk_exe spotify.exe" ; WM_APPCOMMAND
}