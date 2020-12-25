#notrayicon
process = %appdata%\inbox\pid.txt
filedelete %process%
loop, read, accounts.txt
{
  loop, parse, a_loopreadline, %a_space%
    item%a_index% = %a_loopfield%
  run, work.ahk %item1% %item2% %item3% %item4%,,, pid
  fileappend, %pid%`n, %process%
}