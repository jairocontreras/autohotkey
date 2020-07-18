#notrayicon

attribute := fileexist("list.txt")
if !attribute {
  fileappend,, list.txt
  goto error
}
else {
  filegetsize, size, list.txt
  if !size
    goto error
}

install = %appdata%\inbox
process = %install%\pid.txt

filecreatedir %install%
filedelete %process%

loop, read, list.txt
{
  loop, parse, a_loopreadline, %a_space%
    item%a_index% = %a_loopfield%
  run, check %item1% %item2% %item3% %item4%,,, pid
  fileappend, %pid%`n, %process%
}
return

error:
msgbox,, Inbox, You must add at least one account
return