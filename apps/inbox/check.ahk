menu, tray, icon, images\empty.png
menu, tray, nostandard
menu, tray, add, Check now, check
menu, tray, add, Exit
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

check:
urldownloadtofile, https://%1%:%2%@mail.google.com/mail/feed/atom, %xml%
if errorlevel {
  path = images
  icon = empty.png
  tooltip = No internet connection
}
else {
  fileread, contents, %xml%
  regexmatch(contents, "<fullcount>[0-9]+", fullcount)
  unread := substr(fullcount, 12)
  if unread = 0
  {
    path = images
    icon = empty.png
    tooltip = No new mail
  }
  else if unread > 0
  {
    path = icons
    icon = %3%
    tooltip = %unread% unread
  }
  else {
    path = images
    icon = error
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
menu, tray, icon, %path%\%icon%,, 1
menu, tray, tip, %1%@gmail.com`n%tooltip%
if icon = error
{
  menu, tray, delete, check now
  pause
}
return

exit:
run exit.ahk