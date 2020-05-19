#include <AutoItConstants.au3>
#include <String.au3>
#include <File.au3>
#include <Array.au3>

Func DefenderSecurityLog()

FileDelete(@TempDir & "\Defender.log")
Local $command = "wevtutil qe " & '"Microsoft-Windows-Windows Defender/Operational"' & " /q:" & chr(34) & "*[System[Provider[@Name='Microsoft-Windows-Windows Defender']  and (EventID=1006 or EventID=1008 or EventID=1015 or EventID=1116 or EventID=1118 or EventID=1119 or EventID=1121 or EventID=1122 or EventID=1123 or EventID=1124 or EventID=1125 or EventID=1126 or EventID=1127 or EventID=1128 or EventID=3002 or EventID=5001 or EventID=5004 or EventID=5007 or EventID=5008 or EventID=5010 or EventID=5012)]]" & chr(34) & " /c:300 /f:text /rd:true"
;MsgBox(0,"",$command)
SplashTextOn("ConfigureDefender", "Please wait, it can take a minute", 300, 40, -1, -1, 1, "", 10)
Local $iPID = Run($command, "", @SW_HIDE, $STDOUT_CHILD)
ProcessWaitClose($iPID)
Local $temp = StdoutRead($iPID, False, True)
FileWrite(@TempDir & "\Defender.log", $temp)
Local $arr_log
_FileReadToArray (@TempDir & "\Defender.log", $arr_log)
FileDelete(@TempDir & "\Defender.log")
;MsgBox(0,"",UBound($arr_log))
If UBound($arr_log) <= 1 Then
  SplashOff()
  MsgBox(0, "Defender Security Log", "No events in the Log.", 3)
  Return
EndIf
Local $stars = "*****************************************"
For $i = 1 to UBound($arr_log)-1
 If StringInStr($arr_log[$i], "  Log Name: ") > 0 Then $arr_log[$i] = $stars
 If StringInStr($arr_log[$i], "  Source: ") > 0 Then $arr_log[$i] = $stars
 If StringInStr($arr_log[$i], "  Task: ") > 0 Then $arr_log[$i] = @crlf
 If StringInStr($arr_log[$i], "  Level: ") > 0 Then $arr_log[$i] = @crlf
 If StringInStr($arr_log[$i], "  Opcode: ") > 0 Then $arr_log[$i] = @crlf
 If StringInStr($arr_log[$i], "  Keyword: ") > 0 Then $arr_log[$i] = @crlf
 If StringInStr($arr_log[$i], "  User: ") > 0 Then $arr_log[$i] = @crlf
 If StringInStr($arr_log[$i], "  Date: ") > 0 Then $arr_log[$i] = StringReplace($arr_log[$i], "T", "   Time: ", 0, 1)
 If StringInStr($arr_log[$i], "  Event ID: 1006") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (found malware or other potentially unwanted software)"
 If StringInStr($arr_log[$i], "  Event ID: 1008") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Error when taking action on malware or PUA)"
 If StringInStr($arr_log[$i], "  Event ID: 1015") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Detected suspicious behavior)"
 If StringInStr($arr_log[$i], "  Event ID: 1116") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Detected malware or PUA)"
 If StringInStr($arr_log[$i], "  Event ID: 1117") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Action taken on malware or PUA)"
 If StringInStr($arr_log[$i], "  Event ID: 1118") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Error when taking action on malware or PUA)"
 If StringInStr($arr_log[$i], "  Event ID: 1119") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Error when taking action on malware or PUA)"
 If StringInStr($arr_log[$i], "  Event ID: 1121") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Blocked by ASR rule)"
 If StringInStr($arr_log[$i], "  Event ID: 1122") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Audited by ASR rule)"
 If StringInStr($arr_log[$i], "  Event ID: 1123") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Blocked by Controlled Folder Access)"
 If StringInStr($arr_log[$i], "  Event ID: 1124") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Audited by Controlled Folder Access)"
 If StringInStr($arr_log[$i], "  Event ID: 1125") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Audited by Windows Defender Network Protection)"
 If StringInStr($arr_log[$i], "  Event ID: 1126") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Blocked by Windows Defender Network Protection)"
 If StringInStr($arr_log[$i], "  Event ID: 1127") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Blocked by Controlled Folder Access - sector write block event)"
 If StringInStr($arr_log[$i], "  Event ID: 1128") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Audited by Controlled Folder Access - sector write block event)"
 If StringInStr($arr_log[$i], "  Event ID: 3002") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Error: Real-time protection failure)"
 If StringInStr($arr_log[$i], "  Event ID: 5001") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Disabled Real-time protection)"
 If StringInStr($arr_log[$i], "  Event ID: 5004") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Changed Windows Defender settings)"
 If StringInStr($arr_log[$i], "  Event ID: 5007") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Changed Windows Defender settings)"
 If StringInStr($arr_log[$i], "  Event ID: 5008") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Error: Windows Defender engine failure)"
 If StringInStr($arr_log[$i], "  Event ID: 5010") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Disabled malware and PUA scanning)"
 If StringInStr($arr_log[$i], "  Event ID: 5012") > 0 Then $arr_log[$i] = $arr_log[$i] & @crlf & " (Disabled Windows Defender Antivirus scanning)"
Next
$arr_log[0]=""
$temp = _ArrayToString($arr_log)
$temp = StringReplace($temp, "|", @crlf)
$temp = StringReplace($temp, @crlf & @crlf & @crlf & @crlf & @crlf, @crlf & $stars)
$temp = StringReplace($temp, "BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550", "BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550" & @crlf &"        ConfigureDefender option: Block executable content from email client and webmail")
$temp = StringReplace($temp, "D4F940AB-401B-4EFC-AADC-AD5F3C50688A", "D4F940AB-401B-4EFC-AADC-AD5F3C50688A" & @crlf &"        ConfigureDefender option: Block Office applications from creating child processes")
$temp = StringReplace($temp, "3B576869-A4EC-4529-8536-B80A7769E899", "3B576869-A4EC-4529-8536-B80A7769E899" & @crlf &"        ConfigureDefender option: Block Office applications from creating executable content")
$temp = StringReplace($temp, "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84", "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84" & @crlf &"        ConfigureDefender option: Block Office applications from injecting into other processes")
$temp = StringReplace($temp, "D3E037E1-3EB8-44C8-A917-57927947596D", "D3E037E1-3EB8-44C8-A917-57927947596D" & @crlf &"        ConfigureDefender option: Impede JavaScript and VBScript to launch executables")
$temp = StringReplace($temp, "5BEB7EFE-FD9A-4556-801D-275E5FFC04CC", "5BEB7EFE-FD9A-4556-801D-275E5FFC04CC" & @crlf &"        ConfigureDefender option: Block execution of potentially obfuscated scripts")
$temp = StringReplace($temp, "92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B", "92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B" & @crlf &"        ConfigureDefender option: Block Win32 imports from Macro code in Office")
$temp = StringReplace($temp, "01443614-cd74-433a-b99e-2ecdc07bfc25", "01443614-cd74-433a-b99e-2ecdc07bfc25" & @crlf &"        ConfigureDefender option: Block executable files from running unless they meet a prevalence, age, or trusted list criteria")
$temp = StringReplace($temp, "c1db55ab-c21a-4637-bb3f-a12568109d35", "c1db55ab-c21a-4637-bb3f-a12568109d35" & @crlf &"        ConfigureDefender option: Use advanced protection against ransomware")
$temp = StringReplace($temp, "9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2", "9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2" & @crlf &"        ConfigureDefender option: Block credential stealing from the Windows local security authority subsystem (lsass.exe)")
$temp = StringReplace($temp, "d1e49aac-8f56-4280-b9ba-993a6d77406c", "d1e49aac-8f56-4280-b9ba-993a6d77406c" & @crlf &"        ConfigureDefender option: Block process creations originating from PSExec and WMI commands")
$temp = StringReplace($temp, "b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4", "b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4" & @crlf &"        ConfigureDefender option: Block untrusted and unsigned processes that run from USB")
$temp = StringReplace($temp, "26190899-1602-49e8-8b27-eb1d0a1ce869", "26190899-1602-49e8-8b27-eb1d0a1ce869" & @crlf &"        ConfigureDefender option: Block only Office communication applications from creating child processes")
$temp = StringReplace($temp, "7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c", "7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c" & @crlf &"        ConfigureDefender option: Block Adobe Reader from creating child processes")
$temp = StringReplace($temp, "e6db77e5-3df2-4cf1-b95a-636979351e5b", "e6db77e5-3df2-4cf1-b95a-636979351e5b" & @crlf &"        ConfigureDefender option: Block persistence through WMI event subscription")

FileWrite(@TempDir & "\Defender.log", $temp)
SplashOff()
ShellExecute('notepad.exe', @TempDir & "\Defender.log")

EndFunc
