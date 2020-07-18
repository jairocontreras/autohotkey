menu, tray, icon, empty.png
menu, tray, nostandard
menu, tray, add, Check now, check
menu, tray, add, Exit

xml = %appdata%\inbox\%1%.xml

frequency = 1
if %4%
  frequency = %4%

loop {
  gosub check
  sleep frequency*1000*60
}
return

check:
urldownloadtofile, https://%1%:%2%@mail.google.com/mail/feed/atom, %xml%
if errorlevel {
  _path := ""
  icon = empty
  tooltip = No internet connection
}
else {
  fileread, contents, %xml%
  regexmatch(contents, "<fullcount>[0-9]+", fullcount)
  regexmatch(contents, "<TITLE>Unauthorized", 401)
  regexmatch(contents, "<title>Error 502", 502)
  count := substr(fullcount, 12)
  if count = 0
  {
    _path := ""
    icon = empty
    tooltip = No new mail
  }
  else if count > 0
  {
    _path = icons\
    icon = %3%
    tooltip = %count% unread
  }
  else {
    _path := ""
    icon = error
    if 401
      tooltip = Unauthorized
    else if 502
      tooltip = Server
    else
      tooltip = Unknown
    tooltip .= " error"
  }
}
menu, tray, icon, %_path%%icon%.png,, 1
menu, tray, tip, %1%@gmail.com`n%tooltip%
if icon = error
{
  menu, tray, delete, check now
  pause
}
return

exit:
run exit