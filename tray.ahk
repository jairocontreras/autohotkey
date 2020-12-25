#persistent
setbatchlines -1
menu, tray, icon, images\tray.png
menu, tray, nostandard
menu, tray, add, Edit
menu, tray, add, Exit
global process
gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
onmessage(dllcall("RegisterWindowMessage", str, "shellhook"), "shellmessage")

; when you open app(s) before running script
loop, read, tray.txt
{
  process = % strsplit(a_loopreadline, "*")[1] ".exe"
  gosub remove
}
return

shellmessage(wparam, lparam) {
  if wparam = 1 ; HSHELL_WINDOWCREATED
  {
    winget, process, processname, ahk_id %lparam%
    loop, read, tray.txt
    {
      if (strsplit(a_loopreadline, "*")[1] ".exe" = process) {
        winwait ahk_id %lparam%
        gosub remove
        break
      }
    }
  }
}

TrayIcon_GetInfo(sExeName)
{
  DetectHiddenWindows, % (Setting_A_DetectHiddenWindows := A_DetectHiddenWindows) ? "On" :
  oTrayIcon_GetInfo := {}
  For key, sTray in ["Shell_TrayWnd", "NotifyIconOverflowWindow"]
  {
    idxTB := TrayIcon_GetTrayBar(sTray)
    WinGet, pidTaskbar, PID, ahk_class %sTray%

    hProc := DllCall("OpenProcess", UInt, 0x38, Int, 0, UInt, pidTaskbar)
    pRB   := DllCall("VirtualAllocEx", Ptr, hProc, Ptr, 0, UPtr, 20, UInt, 0x1000, UInt, 0x4)

    SendMessage, 0x418, 0, 0, ToolbarWindow32%idxTB%, ahk_class %sTray%   ; TB_BUTTONCOUNT

    szBtn := VarSetCapacity(btn, (A_Is64bitOS ? 32 : 20), 0)
    szNfo := VarSetCapacity(nfo, (A_Is64bitOS ? 32 : 24), 0)
    szTip := VarSetCapacity(tip, 128 * 2, 0)

    Loop, %ErrorLevel%
    {
      SendMessage, 0x417, A_Index - 1, pRB, ToolbarWindow32%idxTB%, ahk_class %sTray%   ; TB_GETBUTTON
      DllCall("ReadProcessMemory", Ptr, hProc, Ptr, pRB, Ptr, &btn, UPtr, szBtn, UPtr, 0)

      iBitmap := NumGet(btn, 0, "Int")
      IDcmd   := NumGet(btn, 4, "Int")
      statyle := NumGet(btn, 8)
      dwData  := NumGet(btn, (A_Is64bitOS ? 16 : 12))
      iString := NumGet(btn, (A_Is64bitOS ? 24 : 16), "Ptr")

      DllCall("ReadProcessMemory", Ptr, hProc, Ptr, dwData, Ptr, &nfo, UPtr, szNfo, UPtr, 0)

      hWnd  := NumGet(nfo, 0, "Ptr")
      uID   := NumGet(nfo, (A_Is64bitOS ? 8 : 4), "UInt")
      msgID := NumGet(nfo, (A_Is64bitOS ? 12 : 8))
      hIcon := NumGet(nfo, (A_Is64bitOS ? 24 : 20), "Ptr")

      WinGet, pID, PID, ahk_id %hWnd%
      WinGet, sProcess, ProcessName, ahk_id %hWnd%
      WinGetClass, sClass, ahk_id %hWnd%

      If (sExeName = sProcess) || (sExeName = pID)
      {
        DllCall("ReadProcessMemory", Ptr, hProc, Ptr, iString, Ptr, &tip, UPtr, szTip, UPtr, 0)
        Index := (oTrayIcon_GetInfo.MaxIndex()>0 ? oTrayIcon_GetInfo.MaxIndex()+1 : 1)
        oTrayIcon_GetInfo[Index,"idx"]     := A_Index - 1
        oTrayIcon_GetInfo[Index,"IDcmd"]   := IDcmd
        oTrayIcon_GetInfo[Index,"pID"]     := pID
        oTrayIcon_GetInfo[Index,"uID"]     := uID
        oTrayIcon_GetInfo[Index,"msgID"]   := msgID
        oTrayIcon_GetInfo[Index,"hIcon"]   := hIcon
        oTrayIcon_GetInfo[Index,"hWnd"]    := hWnd
        oTrayIcon_GetInfo[Index,"Class"]   := sClass
        oTrayIcon_GetInfo[Index,"Process"] := sProcess
        oTrayIcon_GetInfo[Index,"Tooltip"] := StrGet(&tip, "UTF-16")
        oTrayIcon_GetInfo[Index,"Tray"]    := sTray
      }
    }
    DllCall("VirtualFreeEx", Ptr, hProc, Ptr, pRB, UPtr, 0, Uint, 0x8000)
    DllCall("CloseHandle", Ptr, hProc)
  }
  DetectHiddenWindows, %Setting_A_DetectHiddenWindows%
  Return oTrayIcon_GetInfo
}

TrayIcon_Delete(idx)
{
  sTray = NotifyIconOverflowWindow
  DetectHiddenWindows, % (Setting_A_DetectHiddenWindows := A_DetectHiddenWindows) ? "On" :
  idxTB := TrayIcon_GetTrayBar()
  SendMessage, 0x416, idx, 0, ToolbarWindow32%idxTB%, ahk_class %sTray% ; TB_DELETEBUTTON
  SendMessage, 0x1A, 0, 0, , ahk_class %sTray%
  DetectHiddenWindows, %Setting_A_DetectHiddenWindows%
}

TrayIcon_GetTrayBar(Tray:="NotifyIconOverflowWindow")
{
  DetectHiddenWindows, % (Setting_A_DetectHiddenWindows := A_DetectHiddenWindows) ? "On" :
  WinGet, ControlList, ControlList, ahk_class %Tray%
  RegExMatch(ControlList, "(?<=ToolbarWindow32)\d+(?!.*ToolbarWindow32)", nTB)
  Loop, %nTB%
  {
    ControlGet, hWnd, hWnd,, ToolbarWindow32%A_Index%, ahk_class %Tray%
    hParent := DllCall( "GetParent", Ptr, hWnd )
    WinGetClass, sClass, ahk_id %hParent%
    If !(sClass = "SysPager" or sClass = "NotifyIconOverflowWindow" )
      Continue
    idxTB := A_Index
    Break
  }
  DetectHiddenWindows, %Setting_A_DetectHiddenWindows%
  Return  idxTB
}

edit:
run explorer tray.txt
return

remove:
info := trayicon_getinfo(process)
loop % info.maxindex()
  trayicon_delete(info[a_index].idx)
return

exit:
exitapp