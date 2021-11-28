#notrayicon
detecthiddenwindows on
loop, read, pid.txt
  winclose ahk_pid %a_loopreadline%