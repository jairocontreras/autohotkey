#notrayicon
detecthiddenwindows on
loop, read, %appdata%\inbox\pid.txt
  winclose ahk_pid %a_loopreadline%