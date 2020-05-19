Func CheckForTampering()
Local $SRPkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer'
Local $GuidKey1 = "{1016bbe0-a716-428b-822e-1E544B6A3"
Local $GuidKey2 = "{1016bbe0-a716-428b-822e-2E544B6A3"
Local $GuidKey3 = "{1016bbe0-a716-428b-822e-3E544B6A3"
Local $GuidKey5 = "{1016bbe0-a716-428b-822e-5E544B6A3"
Local $GuidKey8 = "{1016bbe0-a716-428b-822e-8E544B6A3"
Local $GuidLNK1 = "{525B53C3-AB48-4EC1-BA1F-A1EF4146FC"
Local $GuidLNK2 = "{A4BFCC3A-DB2C-424C-B029-7FE99A87C6"
Local $GuidLNK3 = "{89a0fd77-ed0c-4e30-91ff-9d51428d2f2"
Local $GuidTools = "{5d175a36-ec0e-4585-a588-95a5f942b3a3}"

Local $GuidWHash = "{1016bbe0-a716-428b-822e-7E544B6A"
Local $GuidWOneDrive = "{1016bbe0-a716-428b-822e-0E544B6A3"
Local $GuidWPath = "{1016bbe0-a716-428b-822e-6E544B6A"
Local $GuidWExeTmpMsi = "{1016bbe0-a716-428b-822e-DE544B6A352"
Local $GuidWProgramW6432Dir = "{6D809377-6AF0-444B-8957-A3773F02200E}"
Local $GuidWProgramFilesDir_x86 = "{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}"
Local $GuidWProgramFilesDir = "{905E63B6-C1BF-494E-B29C-65B732D3D21A}"
Local $GuidW_WD_Dir = "{f073d7e6-ec43-4bf6-a2a8-536eb63b03c8}"
Local $GuidW_SystemRoot = "{F38BF404-1D43-42F2-9305-67DE0B28FC23}"
Local $GuidWhitelistLNK1 = "{625B53C3-AB48-4EC1-BA1F-A1EF4146FC"
Local $GuidWhitelistLNK2 = "{B4BFCC3A-DB2C-424C-B029-7FE99A87C6"
Local $GuidWhitelistLNK3 = "{99a0fd77-ed0c-4e30-91ff-9d51428d2f2"
Local $GuidW_UpdateMode = "{1016bbe0-a716-428b-822e-4E544B6A"

Local $n
Local $temp = RegEnumKey($SRPkey & '\CodeIdentifiers\0\Paths', 1)
Local $temphash = RegEnumKey($SRPkey & '\CodeIdentifiers\131072\Hashes', 1)
Local $temp131072 = RegEnumKey($SRPkey & '\CodeIdentifiers\131072\Paths', 1)
Local $temphash131072 = RegEnumKey($SRPkey & '\CodeIdentifiers\0\Hashes', 1)
Local $wpath = RegEnumKey($SRPkey & '\CodeIdentifiers\262144\Paths', 1)
Local $whash = RegEnumKey($SRPkey & '\CodeIdentifiers\262144\Hashes', 1)
Local $T, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9
Local $W, $w1, $w2, $w3, $w4, $w5, $w6, $w7, $w8, $w9, $w10, $w11, $w12, $w13
Local $x

; Disallowed SRP hash rules
If $temphash <> "" Then
   DisplayTamperInfo("Disallowed SRP hash")
   Exit
EndIf

; SRP "Basic User" rules
If $temp131072 & $temphash131072 <> "" Then
   DisplayTamperInfo("SRP Basic User")
   Exit
EndIf

; Disallowed SRP path rules
$n = 0
While $temp <> ""
$t1 = StringInStr($temp, $GuidKey1)
$t2 = StringInStr($temp, $GuidKey2)
$t3 = StringInStr($temp, $GuidKey3)
$t4 = StringInStr($temp, $GuidKey5)
$t5 = StringInStr($temp, $GuidKey8)
$t6 = StringInStr($temp, $GuidLNK1)
$t7 = StringInStr($temp, $GuidLNK2)
$t8 = StringInStr($temp, $GuidLNK3)
$t9 = StringInStr($temp, $GuidTools)
$T = $t1+$t2+$t3+$t4+$t5+$t6+$t7+$t8+$t9
   If $T = 0 Then
;      MsgBox(0,"",$temp)
       DisplayTamperInfo("Disallowed SRP path")
      Exit
   EndIf
   $n = $n + 1
   $temp = RegEnumKey($SRPkey & '\CodeIdentifiers\0\Paths', $n)
WEnd

$n = 0
While $whash <> ""
$w1 = StringInStr($whash, $GuidWHash)
   If $w1 = 0 Then
;      MsgBox(0,"",$temp)
       DisplayTamperInfo("Unrestricted SRP hash")
      Exit
   EndIf
   $n = $n + 1
   $whash = RegEnumKey($SRPkey & '\CodeIdentifiers\262144\Hashes', $n)
WEnd

$n = 0
While $wpath <> ""
   $w2 = StringInStr($wpath, $GuidWOneDrive)
   $w3 = StringInStr($wpath, $GuidWPath)
   $w4 = StringInStr($wpath, $GuidWExeTmpMsi)
   $w5 = StringInStr($wpath, $GuidWProgramW6432Dir)
   $w6 = StringInStr($wpath, $GuidWProgramFilesDir_x86)
   $w7 = StringInStr($wpath, $GuidWProgramFilesDir)
   $w8 = StringInStr($wpath, $GuidW_WD_Dir)
   $w9 = StringInStr($wpath, $GuidW_SystemRoot)
   $w10 = StringInStr($wpath, $GuidWhitelistLNK1)
   $w11 = StringInStr($wpath, $GuidWhitelistLNK2)
   $w12 = StringInStr($wpath, $GuidWhitelistLNK3)
   $w13 = StringInStr($wpath, $GuidW_UpdateMode)
   $W = $w2+$w3+$w4+$w5+$w6+$w7+$w8+$w9+$w10+$w11+$w12+$w13
   If $W = 0 Then
;      MsgBox(0,"",$wpath)
       DisplayTamperInfo("Unrestricted SRP path")
      Exit
   EndIf
   $n = $n + 1
   $wpath = RegEnumKey($SRPkey & '\CodeIdentifiers\262144\Paths', $n)
WEnd
EndFunc


Func DisplayTamperInfo($text)
Local $x

Local $info = "Hard_Configurator detected " & $text & " rules applied by another program. This can be dangerous because Hard_Configurator also uses SRP. Two different programs usually make SRP work incorrectly." & @crlf & @crlf & "** Press the <Continue> button if you are sure that currently, you do not use another SRP application. This will reinstall SRP to avoid problems, but other settings will not be changed." & @crlf & @crlf & "** Press the <Abort> button otherwise. Next, you have to uninstall other applications that use SRP. The possible (rare) uninstallation problems can be solved by booting into Safe Mode. In the end, run Hard_Configurator and use <(Re)Install SRP> to start configuring SRP settings or press <Uninstall> button to remove Hard_Configurator from your computer. Use only one application that applies SRP."

_ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
$x = _ExtMsgBox(64,"&Continue|Abort|Show in Notepad", "WARNING", $info)
If $x = 3 Then
   FileWrite($ProgramFolder & '\Temp\TamperInfo.txt', $info)
   ShellExecute('notepad.exe',$ProgramFolder & '\Temp\TamperInfo.txt')
   DisplayTamperInfo($text)
EndIf
If $x = 1 Then
SplashTextOn("Warning", "Reinstalling SRP", 300, 40, -1, -1, 1, "", 10)
   SRP1()
   HideMainGUI()
   RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers', 'Installed')
   If @OSArch = "X64" Then Run('Hard_Configurator(x64).exe')
   If @OSArch = "X86" Then Run('Hard_Configurator(x86).exe')
   Sleep(4000)
SplashOff()
;   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
;   _ExtMsgBox(64,"OK", "Hard_Configurator", "SRP has been reinstalled.", 4)
EndIf
EndFunc