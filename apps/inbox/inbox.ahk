menu, tray, icon, images\_empty.png
menu, tray, nostandard
menu, tray, add, Check now, check
menu, tray, add, Exit
onmessage(0x404, "AHK_NOTIFYICON")
xml = %appdata%\inbox\%1%.xml
if %4%
  frequency = %4%
else
  frequency = 1
loop {
  gosub check
  sleep frequency*1000*60
}
return

AHK_NOTIFYICON(wparam, lparam) {
  if lparam = 0x202 ; WM_LBUTTONUP
    run https://mail.google.com
}

check:
urldownloadtofile, https://%1%:%2%@mail.google.com/mail/feed/atom, %xml%
if errorlevel {
  icon = _empty.png
  tooltip = No internet connection
}
else {
  fileread, contents, %xml%
  regexmatch(contents, "<fullcount>[0-9]+", fullcount)
  unread := substr(fullcount, 12)
  if unread = 0
  {
    icon = _empty.png
    tooltip = No new mail
  }
  else if unread > 0
  {
    icon = %3%
    tooltip = %unread% unread
  }
  else {
    icon = _error.png
    regexmatch(contents, "i)<title>unauthorized", 401)
    regexmatch(contents, "i)<title>error 502", 502)
    if 401
      tooltip = Unauthorized
    else if 502
      tooltip = Server
    else
      tooltip = Unknown
    tooltip .= " error"
  }
}
menu, tray, icon, images\%icon%,, 1
menu, tray, tip, %1%@gmail.com`n%tooltip%
if icon = _error.png
{
  menu, tray, delete, check now
  pause
}
return

exit:
run exit.ahk