Func GetFirewallEvents()
;#RequireAdmin
;#include <Constants.au3>
;#Include <Array.au3>
;#include <File.au3>
;#include <String.au3>
;#include <Date.au3>
;#Include <WinAPIEx.au3>
Local $n = 0
Local $m = 0
Local $temp = 0
Local $stars = @crlf & @crlf & "**************************************"
Local $FirewallLogArray
Local $ProgramFolder = @ScriptDir
Local $ArrStrBetween
FileDelete($ProgramFolder & '\Firewall.log')
;; Setting the 2x default max size of the LOG File
;RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Security', 'MaxSize', 'REG_DWORD', Number('41943040'))
;; Enabling auditing dropped packeds on failure (=blocked event), to monitor the 5152 event.
;Local $COMMAND1 = 'auditpol /set /subcategory:"{0CCE9225-69AE-11D9-BED3-505054503030}" /failure:enable'
;Run($COMMAND1, "", @SW_HIDE)


; Reading from the LOG
Local $COMMAND2 = 'wevtutil qe Security /c:200000 /rd:true /f:xml /q:"Event[System[(EventID=5152)]]"'
Local $iPID = Run($COMMAND2, "", @SW_HIDE, $STDOUT_CHILD)
Local $sMessage = "Please wait !  It will take some time."
SplashTextOn("Reading Windows Event Log", $sMessage, 250, 40, -1, -1, 0, "", 10)
   ProcessWaitClose($iPID)
   Local $sOutput = StdoutRead($iPID, False, True)
   $FirewallLogArray = StringSplit(_HexToString($sOutput), @crlf)
;   _ArrayDisplay($FirewallLogArray)
If UBound($FirewallLogArray) < 2 Then 
   MsgBox(0,"", "Firewall Blocked Events not found.")
   Return
EndIf
   For $i=1 To UBound($FirewallLogArray) - 1
;  THROWING OUT INBOUND EVENTS
      If StringInStr(StringLower($FirewallLogArray[$i]), "%%14592") > 0 Then
         $FirewallLogArray[$i] = ""
      EndIf
;  Keepeng only events which are related to blocked files on hard disks
      If StringInStr($FirewallLogArray[$i], "\device\harddiskvolume") = 0 Then
         $FirewallLogArray[$i] = ""
      EndIf 
   Next
      $FirewallLogArray = _ArrayUnique($FirewallLogArray)

;      MsgBox(0,"",UBound($FirewallLogArray))
;     _ArrayDisplay($FirewallLogArray)
SplashOff()

   If UBound($FirewallLogArray) < 3 Then
      MsgBox(0,"", "Firewall Blocked Events not found.")
      Return
   EndIf
  For $i=2 To UBound($FirewallLogArray) - 1
	If $FirewallLogArray[$i] = "" Then 
	   _ArrayDelete($FirewallLogArray, $i)
	   ExitLoop
	EndIf
  Next
;     _ArrayDisplay($FirewallLogArray)

SplashTextOn("Processing Blocked Events", $sMessage, 250, 40, -1, -1, 0, "", 10)
;  Changing the Log format from XML to TXT 
   For $i=2 To UBound($FirewallLogArray) - 1
      $n = StringInStr($FirewallLogArray[$i], 'SystemTime=')
      $FirewallLogArray[$i] = StringTrimLeft($FirewallLogArray[$i], $n-1)
     $ArrStrBetween = _StringBetween($FirewallLogArray[$i], '/>', "ProcessId'")
     $temp = _ArrayPop($ArrStrBetween)
     $FirewallLogArray[$i] = StringReplace($FirewallLogArray[$i], $temp, @crlf)
     $FirewallLogArray[$i] = StringReplace($FirewallLogArray[$i], "</Data><Data Name='", @crlf)
     $FirewallLogArray[$i] = StringReplace($FirewallLogArray[$i], "%%14593","Outbound")
     $FirewallLogArray[$i] = StringReplace($FirewallLogArray[$i], "%%14592","Inbound")
;     $FirewallLogArray[$i] = StringReplace($FirewallLogArray[$i], "FilterRTID","Filter Run-Time ID:")
     $FirewallLogArray[$i] = StringReplace($FirewallLogArray[$i], "</Data></EventData></Event>",$stars)

;    Changing System Time to Local Time
     $ArrStrBetween = _StringBetween($FirewallLogArray[$i],"SystemTime='","Z'/>")
     Local $DT1 = _ArrayPop($ArrStrBetween)
     Local $DT = StringReplace($DT1, "T", "")
     $DT = StringReplace($DT,"-","")
     $DT = StringReplace($DT,":","")
     Local $ST = _Date_Time_EncodeSystemTime(StringMid($DT,5,2),StringMid($DT,7,2),StringMid($DT,1,4),StringMid($DT,9,2),StringMid($DT,11,2),StringMid($DT,13,2))
     Local $LT = _Date_Time_SystemTimeToTzSpecificLocalTime(DllStructGetPtr($ST))
     $LT = _Date_Time_SystemTimeToDateTimeStr($LT,1)
;     MsgBox(0,"", $FirewallLogArray[$i] & @CRLF & @CRLF & @CRLF & $DT & @CRLF & @CRLF & @CRLF & $LT)
     $FirewallLogArray[$i] = StringReplace($FirewallLogArray[$i],"SystemTime='" & $DT1 & "Z'/>", "Local Time:  " & $LT)
     $FirewallLogArray[$i] = StringReplace($FirewallLogArray[$i], "'>", ":  ")
     $ArrStrBetween = _StringBetween($FirewallLogArray[$i], "Application:  ", "Direction:")
     $temp = _ArrayPop($ArrStrBetween)   
     $FirewallLogArray[$i] = StringReplace($FirewallLogArray[$i], $temp, _DosPathNameToPathName($temp))
   Next
;  Writing blocked entries to the final log file.

   For $i=2 To UBound($FirewallLogArray) - 1
	FileWriteLine($ProgramFolder & '\Firewall.log', "Event[" & $i-2 & "]:" & @crlf & $FirewallLogArray[$i])
   Next
SplashOff()

;    _ArrayDisplay($FirewallLogArray)
;   MsgBox(0, "", $FirewallLogArray[2] & @crlf & $FirewallLogArray[3])
   If UBound($FirewallLogArray) > 2 Then 
	Run(@SystemDir & "\notepad.exe " & $ProgramFolder & '\Firewall.log', "", @SW_MAXIMIZE)
   Else
        MsgBox(0,"", "Firewall Blocked Events not found.")
   EndIf
EndFunc


Func _DosPathNameToPathName($sPath)

    Local $sName, $aDrive = DriveGetDrive('ALL')
    If Not IsArray($aDrive) Then
        Return SetError(1, 0, $sPath)
    EndIf

    For $i = 1 To $aDrive[0]
        $sName = _WinAPI_QueryDosDevice($aDrive[$i])
        If StringInStr($sPath, $sName) = 1 Then
            Return StringReplace($sPath, $sName, StringUpper($aDrive[$i]), 1)
        EndIf
    Next
    Return SetError(2, 0, $sPath)
EndFunc
