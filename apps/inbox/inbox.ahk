#notrayicon

filegetsize, size, list.txt
if !size
{
  msgbox,, Inbox, You must add at least one account
  return
}

install = %appdata%\inbox
process = %install%\pid.txt

filecreatedir %install%
filedelete %process%

loop, read, list.txt
{
  loop, parse, a_loopreadline, %a_space%
    item%a_index% = %a_loopfield%
  run, check.ahk %item1% %item2% %item3% %item4%,,, pid
  fileappend, %pid%`n, %process%
}