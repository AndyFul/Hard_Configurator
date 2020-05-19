Func RestoreWindowsDefaults()
  Local $YesNo=""
  If (@OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then 
     $YesNo = MsgBox(4,"","Do you want to remove all Hard_Configurator settings, including those applied via FirewallHardening?")
  Else
     $YesNo = MsgBox(4,"","Do you want to remove all Hard_Configurator settings, including those applied via ConfigureDefender and FirewallHardening?")
  EndIf
  Switch $YesNo
  case 6
     RestoreWindowsDefaults1()
     MsgBox(0,"",'Hard_Configurator will exit now.' & @CRLF & 'Please reboot Windows to fully restore Windows Defaults.')
     Exit  
  case 7
     Return
  EndSwitch 

EndFunc

Func RestoreWindowsDefaults1()
Local $sMessage = "Please wait. It can take a minute."
Local $SRPkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers'
Local $n=0
SplashTextOn("Restoring Windows Defaults", $sMessage, 300, 40, -1, -1, 1, "", 10)
     $isSRPinstalled = "Not Installed"
     RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator')
     FileDelete($ProgramFolder & 'Hard_Configurator.ini')
     RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers', 'Installed', 'REG_SZ', '1')
     TurnOFFAllRestrictions()
     RegDelete('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', 'Hard_ConfiguratorSwitch')
     RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator')
     ValidateAdminCodeSignatures("OFF")
     If @OSVersion="WIN_10" Then DefaultDefender()
     RemoveFirewallRules()
     RegDelete('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments', 'SaveZoneInformation')
     RemoveEXE2ModRiskFileTypes()
     RegDelete('HKCR\*\shell\Install application')
     RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers', 'ExecutableTypes')
     RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers')
     RegWrite($SRPkey, 'AuthenticodeEnabled', 'REG_DWORD', Number('0'))
SplashOFF()
;MsgBox(0,"", RegEnumKey($SRPkey, 1) & @crlf & RegEnumKey($SRPkey, 2))
If not (RegEnumKey($SRPkey, 1) = "") Then $n = $n + 1
If $n > 0 Then
   MsgBox(0, "Restore Windows Defaults", "Error. Some processes or security software leftovers prevented Hard_Configurator to remove Software Restriction Policies in a standard way." & @crlf & "Hard_Configurator will try to use an advanced method by taking ownership of SRP Registry keys.")
   $n = 0
   RemoveSRP("1")
   If not (RegEnumKey($SRPkey, 1) = "") Then $n = $n + 1
   If $n > 0 Then
      MsgBox(0, "Restore Windows Defaults", "Error. The Windows Registry values under the key 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', could not be fully removed." & @crlf & "They have to be removed manually.")
   Else
      MsgBox(0, "Restore Windows Defaults", "SRP removed successfully.")
   EndIf
EndIf
EndFunc

Func RemoveFirewallRules()
Local $StartLogging = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\FirewallRules'
Local $val = "Name=H_C rule for:"
Local $COMMAND2 = 'auditpol /set /subcategory:"{0CCE9225-69AE-11D9-BED3-505054503030}" /failure:disable'
Run($COMMAND2, "", @SW_HIDE)
;     Setting Windows default max size of the LOG File
RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Security', 'MaxSize', 'REG_DWORD', Number('20971520'))
DeleteFW_GUIDs($val)
EndFunc


Func DeleteFW_GUIDs($_item)
Local $MainFWKey = 'HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\FirewallRules'
;Deletes the entries (GUIDs) from the Policy Firewall key if the 'Description' value contains the string = $_item
#include <MsgBoxConstants.au3>
#include <Array.au3> ; Required for _ArrayDisplay() only.
Local $data
Local $hArray[1] =[""]
Local $n = 1
Local $sSubVal = RegEnumVal($MainFWKey, 1)
While $sSubVal <> ""
  $sSubVal = RegEnumVal($MainFWKey, $n)
  $data = RegRead($MainFWKey, $sSubVal)
;  MsgBox(0,"",$sSubVal)
  If StringInStr($data, $_item) > 0 Then _ArrayAdd($hArray, $sSubVal)
    $n = $n + 1
WEnd
;_ArrayDisplay($hArray)
If UBound($hArray) < 2 Then Return
For $n=1 to UBound($hArray)-1
  RegDelete($MainFWKey, $hArray[$n])
Next

EndFunc
