Func MoreRestrictions()
;GUI for additional restrictions
;#include <EditConstants.au3>
;#include <GUIConstantsEx.au3>
;#include <WindowsConstants.au3>

Global $MRSTRlistview
Global $MRSTRlistGUI
Global $BtnDisableUntrustedFonts
Global $BtnDisable_16Bits
Global $BtnShellExtensionSecurity
Global $Disable16Bits
Global $BtnDisableSMB1
Local  $deltaX=10

;GUISetState(@SW_DISABLE, $listGUI)
;GUISetState(@SW_HIDE,$listGUI)
;Opt("GUIOnEventMode", 1)
HideMainGUI()

; _GUICtrlListView_DeleteAllItems($Listview)

;   Opt("GUIOnEventMode", 1)
  If not $X_MRSTRlistGUI > 0 Then $X_MRSTRlistGUI = -1
  If not $Y_MRSTRlistGUI > 0 Then $Y_MRSTRlistGUI = -1

   $MRSTRlistGUI = GUICreate("More Restrictions", 330, 500, $X_MRSTRlistGUI, $Y_MRSTRlistGUI, -1)
   GUISetOnEvent($GUI_EVENT_CLOSE, "CloseMoreRestrictions")
   $MRSTRlistview = GUICtrlCreateListView("Settings", 10, 10, 100, 350)
   _GUICtrlListView_SetColumnWidth($MRSTRlistview, 0, 70)

  MoreRestrictionsValues()

;   $BtnDisableUntrustedFonts = GUICtrlCreateButton("Disable Untrusted Fonts", 117+$deltaX, 35, 140, 19)
;   GUICtrlSetOnEvent(-1, "DisableUntrustedFonts")
;   $BtnHelpDisableUntrustedFonts = GUICtrlCreateButton("Help", 260+$deltaX, 35, 40, 19)
;   GUICtrlSetOnEvent(-1, "HelpG")
   
   $BtnDisable_16Bits = GUICtrlCreateButton("Disable 16-bits", 117+$deltaX, 54-19, 140, 19)
   GUICtrlSetOnEvent(-1, "Disable_16Bits")
   $BtnHelpDisable_16Bits = GUICtrlCreateButton("Help", 260+$deltaX, 54-19, 40, 19)
   GUICtrlSetOnEvent(-1, "HelpH")

   $BtnShellExtensionSecurity = GUICtrlCreateButton("Shell Extension Security", 117+$deltaX, 73-19, 140, 19)
   GUICtrlSetOnEvent(-1, "ShellExtensionSecurity")
   $BtnHelpShellExtensionSecurity = GUICtrlCreateButton("Help", 260+$deltaX, 73-19, 40, 19)
   GUICtrlSetOnEvent(-1, "HelpI")

   $BtnMSIElevation = GUICtrlCreateButton("MSI Elevation", 117+$deltaX, 92-19, 140, 19)
   GUICtrlSetOnEvent(-1, "MSIElevation")
   $BtnHelpMSIElevation = GUICtrlCreateButton("Help", 260+$deltaX, 92-19, 40, 19)
   GUICtrlSetOnEvent(-1, "HelpM") 

   $BtnNoElevationSUA = GUICtrlCreateButton("Disable Elevation on SUA", 117+$deltaX, 111-19, 140, 19)
   GUICtrlSetOnEvent(-1, "NoElevationSUA")
   $BtnHelpNoElevationSUA = GUICtrlCreateButton("Help", 260+$deltaX, 111-19, 40, 19)
   GUICtrlSetOnEvent(-1, "HelpK") 

   $BtnDisableSMB1 = GUICtrlCreateButton("Disable SMB", 117+$deltaX, 130-19, 140, 19)
   GUICtrlSetOnEvent(-1, "_DisableSMB")
   $BtnHelpDisableSMB1 = GUICtrlCreateButton("Help", 260+$deltaX, 130-19, 40, 19)
   GUICtrlSetOnEvent(-1, "HelpSMB") 

   $BtnDisableCachedLogons = GUICtrlCreateButton("Disable Cached Logons", 117+$deltaX, 149-19, 140, 19)
   GUICtrlSetOnEvent(-1, "DisableCachedLogons1")
   $BtnHelpDisableCachedLogons = GUICtrlCreateButton("Help", 260+$deltaX, 149-19, 40, 19)
   GUICtrlSetOnEvent(-1, "HelpDisableCachedLogons") 

   $BtnUAC_CTRL_ALT_DEL = GUICtrlCreateButton("UAC CTRL_ALT_DEL", 117+$deltaX, 168-19, 140, 19)
   GUICtrlSetOnEvent(-1, "UAC_CTRL_ALT_DEL1")
   $BtnHelpUAC_CTRL_ALT_DEL = GUICtrlCreateButton("Help", 260+$deltaX, 168-19, 40, 19)
   GUICtrlSetOnEvent(-1, "HelpUAC_CTRL_ALT_DEL") 


   $BtnCloseMoreRestrictions = GUICtrlCreateButton("Close", 150, 330, 80, 30)
   GUICtrlSetOnEvent(-1, "CloseMoreRestrictions")
   GUISetState(@SW_SHOW, $MRSTRlistGUI)

; Disable some buttons for earlier Windows versions

; Disable Untrusted Fonts is not useful so will be deactivated for all Windows versions
_GUICtrlButton_Enable($BtnDisableUntrustedFonts, False)
$GreyDisableUntrustedFonts = 1


;  GUICtrlCreateListViewItem($DisableUntrustedFonts, $MRSTRlistview)
  GUICtrlCreateListViewItem($Disable16Bits, $MRSTRlistview)
  GUICtrlCreateListViewItem($EnforceShellExtensionSecurity, $MRSTRlistview)
  GUICtrlCreateListViewItem($MSIElevation, $MRSTRlistview)
  GUICtrlCreateListViewItem($NoElevationSUA, $MRSTRlistview)
  GUICtrlCreateListViewItem($DisableSMB, $MRSTRlistview)
  GUICtrlCreateListViewItem($DisableCachedLogons, $MRSTRlistview)
  GUICtrlCreateListViewItem($UACSecureCredentialPrompting, $MRSTRlistview)
EndFunc


Func CloseMoreRestrictions()
   GuiDelete($MRSTRlistGUI)
;   GUISetState(@SW_ENABLE, $listGUI)
;   GUISetState(@SW_HIDE,$listGUI)
;   GUISetState(@SW_SHOW,$listGUI)
   ShowMainGUI()
   ShowRegistryTweaks()
EndFunc

Func RefreshMoreRestrictionsGUI()
  Local $pos = WinGetPos ($MRSTRlistGUI)
  $X_MRSTRlistGUI = $pos[0] 
  $Y_MRSTRlistGUI = $pos[1]
  GUISetState(@SW_HIDE,$MRSTRlistGUI)
  GuiDelete($MRSTRlistGUI)
  MoreRestrictions()
EndFunc

Func MoreRestrictionsValues()
$MoreRestrictionsOutput = ""
;Local $keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\MitigationOptions'
;Local $valuename = 'MitigationOptions_FontBocking'
;IF $GreyDisableUntrustedFonts = 0 Then
;   $DisableUntrustedFonts = RegRead ( $keyname, $valuename )
;   $iskey = @error
;   Switch $DisableUntrustedFonts
;      case 1000000000000
;         $DisableUntrustedFonts = "ON"
;         $MoreRestrictionsOutput =  $MoreRestrictionsOutput & '1'
;      case 2000000000000
;         $DisableUntrustedFonts = "OFF"
;         $MoreRestrictionsOutput =  $MoreRestrictionsOutput & '0'
;      case 3000000000000
;         $DisableUntrustedFonts = "AUDIT"
;         $MoreRestrictionsOutput =  $MoreRestrictionsOutput & '2'
;      case Else
;         If ($iskey = -1 or $iskey =1) Then
;            $DisableUntrustedFonts = "OFF"
;            $MoreRestrictionsOutput =  $MoreRestrictionsOutput & '0'
;         Else
;            $DisableUntrustedFonts = "?"
;            $MoreRestrictionsOutput =  $MoreRestrictionsOutput & '?'
;         EndIf
;   EndSwitch 
;EndIf
;IF $GreyDisableUntrustedFonts = 1 Then
;   RegDelete ( $keyname, $valuename )
;   $DisableUntrustedFonts = "OFF"
;   $MoreRestrictionsOutput = $MoreRestrictionsOutput & '0'
;EndIf

Local $keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat'
Local $valuename = 'VDMDisallowed'
$Disable16Bits = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $Disable16Bits
   case '0'
     $Disable16Bits = 'OFF'
   case 1
     $Disable16Bits = 'ON'
   case Else
     If ($iskey = -1 or $iskey =1) Then
         $Disable16Bits = "OFF"
;         $MoreRestrictionsOutput =  $MoreRestrictionsOutput & '0'
      Else
         $Disable16Bits = '?'
;         $MoreRestrictionsOutput =  $MoreRestrictionsOutput & '?'
      EndIf
EndSwitch
$MoreRestrictionsOutput = AddMoreRestrictionsOutput($Disable16Bits, $MoreRestrictionsOutput)
If ($iskey = -1 or $iskey =1) Then $Disable16Bits = "OFF"

$keyname = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
$valuename = 'EnforceShellExtensionSecurity'
$EnforceShellExtensionSecurity = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $EnforceShellExtensionSecurity
   case 0
     $EnforceShellExtensionSecurity = 'OFF'
   case 1
     $EnforceShellExtensionSecurity = 'ON'
   case Else
     $EnforceShellExtensionSecurity = '?'
EndSwitch
$MoreRestrictionsOutput = AddMoreRestrictionsOutput($EnforceShellExtensionSecurity, $MoreRestrictionsOutput)
If ($iskey = -1 or $iskey =1) Then $EnforceShellExtensionSecurity = "OFF"

$keyname = 'HKCR\Msi.Package\shell\runas\command'
$valuename = ''
$MSIElevation = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $MSIElevation
   case '"%SystemRoot%\System32\msiexec.exe" /i "%1" %*'
      $MSIElevation = "ON"
   case ''
      RegDelete('HKCR\Msi.Package\shell\runas')
      $MSIElevation = "OFF"
   case Else
      $MSIElevation = "?"
EndSwitch
$MoreRestrictionsOutput = AddMoreRestrictionsOutput($MSIElevation, $MoreRestrictionsOutput)

$keyname = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$valuename = 'ConsentPromptBehaviorUser'
$NoElevationSUA = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $NoElevationSUA
   case '0'
      $NoElevationSUA = "ON"
      $MoreRestrictionsOutput = $MoreRestrictionsOutput & '1'
   case 1
      $NoElevationSUA = "OFF1"
      $MoreRestrictionsOutput = $MoreRestrictionsOutput & '0'   
   case 3
      $NoElevationSUA = "OFF3"
      $MoreRestrictionsOutput = $MoreRestrictionsOutput & '0'   
   case Else
      $NoElevationSUA = "?"
      $MoreRestrictionsOutput = $MoreRestrictionsOutput & '?'         
EndSwitch
;If ($iskey = -1 or $iskey =1) Then $NoElevationSUA = "OFF"

_CheckDisableSMB()

;$keyname = 'HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10'
;$valuename = 'Start'
;$DisableSMB = RegRead ( $keyname, $valuename )
;If CorrectSMB10Uninstalled() = 1 Then $DisableSMB = 4
;$keyname = 'HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb20'
;$DisableSMB = $DisableSMB & RegRead ( $keyname, $valuename )
;$keyname = 'HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation'
;$valuename = 'DependOnService'
;$DisableSMB = $DisableSMB & RegRead ( $keyname, $valuename )
;$keyname = 'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters'
;$valuename = 'SMB1'
;Local $x= RegRead ( $keyname, $valuename )
;If @error <> 0 Then $x = '1'
;$DisableSMB = $DisableSMB & $x
;$valuename = 'SMB2'
;$x= RegRead ( $keyname, $valuename )
;If @error <> 0 Then $x = '1'
;$DisableSMB = $DisableSMB & $x

;;Correction to invalid registry values after Windows upgrade
;If $DisableSMB = '43' & 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI' & '00' Then
;   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb20', 'Start', 'REG_DWORD', Number('4'))
;   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation', 'DependOnService', 'REG_MULTI_SZ', 'Bowser' & @LF & 'NSI')
;   $DisableSMB = '44' & 'Bowser' & @LF & 'NSI' & '00'
;EndIf
;If $DisableSMB = '23' & 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI' & '00' Then
;   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10', 'Start', 'REG_DWORD', Number('4'))
;   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb20', 'Start', 'REG_DWORD', Number('4'))
;   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation', 'DependOnService', 'REG_MULTI_SZ', 'Bowser' & @LF & 'NSI')
;   $DisableSMB = '44' & 'Bowser' & @LF & 'NSI' & '00'
;EndIf
;If $DisableSMB = '23' & 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI' & '01' Then
;   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10', 'Start', 'REG_DWORD', Number('4'))
;   $DisableSMB = '43' & 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI' & '01'
;EndIf

;Switch $DisableSMB
;   case '44' & 'Bowser' & @LF & 'NSI' & '00'
;      $DisableSMB = "ON123"
;      $MoreRestrictionsOutput = $MoreRestrictionsOutput & '3'
;   case '43' & 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI' & '01'
;      $DisableSMB = "ON1"
;      $MoreRestrictionsOutput = $MoreRestrictionsOutput & '1'
;   case '33' & 'Bowser' & @LF & 'MRxSmb10' & @LF & 'MRxSmb20' & @LF & 'NSI' & '11'
;      If (@OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
;         $DisableSMB = "OFF"
;         $MoreRestrictionsOutput = $MoreRestrictionsOutput & '0'   
;      Else
;         $DisableSMB = "?"
;         $MoreRestrictionsOutput = $MoreRestrictionsOutput & '?'   
;      EndIf
;   case '23' & 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI' & '11'
;      If (@OSVersion="WIN_10" or @OSVersion="WIN_81") Then
;         $DisableSMB = "OFF"
;         $MoreRestrictionsOutput = $MoreRestrictionsOutput & '0'   
;      Else
;         $DisableSMB = "?"
;         $MoreRestrictionsOutput = $MoreRestrictionsOutput & '?'  
;      EndIf 
;   case Else
;      $DisableSMB = "?"
;      $MoreRestrictionsOutput = $MoreRestrictionsOutput & '?'         
;EndSwitch

Local $keyname = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
Local $valuename = 'CachedLogonsCount'
$DisableCachedLogons = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $DisableCachedLogons
   case '0'
      $DisableCachedLogons = "ON"
      $MoreRestrictionsOutput = $MoreRestrictionsOutput & '1'
   case '10'
      $DisableCachedLogons = "OFF"
      $MoreRestrictionsOutput = $MoreRestrictionsOutput & '0'
   case Else
      $DisableCachedLogons = "?"
      $MoreRestrictionsOutput = $MoreRestrictionsOutput & '?'         
EndSwitch
;If ($iskey = -1 or $iskey =1) Then $DisableCachedLogons = "OFF"

$keyname = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\CredUI'
$valuename = 'EnableSecureCredentialPrompting'
$UACSecureCredentialPrompting = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $UACSecureCredentialPrompting
   case 1
      $UACSecureCredentialPrompting = "ON"
   case 0
      $UACSecureCredentialPrompting = "OFF"
   case Else
      $UACSecureCredentialPrompting = "?"
EndSwitch
$MoreRestrictionsOutput = AddMoreRestrictionsOutput($UACSecureCredentialPrompting, $MoreRestrictionsOutput)

EndFunc


Func Disable_16Bits()

Local $keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat'
Local $valuename = 'VDMDisallowed'
Local $RegDataNew
Switch $Disable16Bits
   case 'ON'
      $RegDataNew = 0     
   case Else
      $RegDataNew = 1
EndSwitch
RegWrite($keyname, $valuename,'REG_DWORD',$RegDataNew)
;Delete the Switch OFF/ON Restrictions backup
RegDelete($BackupSwitchRestrictions)

RefreshMoreRestrictionsGUI()

EndFunc


Func ShellExtensionSecurity()
Local $keyname = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
Local $valuename = 'EnforceShellExtensionSecurity'
Local $RegDataNew
Local $EnforceShellExtensionSecurity = RegRead ( $keyname, $valuename )
select
   case $EnforceShellExtensionSecurity = 1
      $RegDataNew = 0
   case Else
      $RegDataNew = 1
EndSelect
RegWrite($keyname, $valuename,'REG_DWORD',$RegDataNew)
;Delete the Switch OFF/ON Restrictions backup
RegDelete($BackupSwitchRestrictions)

RefreshMoreRestrictionsGUI()

EndFunc


;Func DisableCommandPrompt()

;If $SRPTransparentEnabled = "No Enforcement" Then 
;   MsgBox(262144,"", "Cannot turn on <Disable Command Prompt>, because of <Enforcement> = 'No Enforcement' setting.") 
;   Return
;EndIf
;Local $keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers'
;Local $valuename = 'IsCMDBlocked'
;Local $BlacklistKeyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\'
;Local $partGUID = '{1016bbe0-a716-428b-822e-5E544B6A310'
;Local $DisableCommandPrompt = RegRead ( $keyname, $valuename )
;If $isSRPinstalled = "Installed" Then
;   Switch $DisableCommandPrompt
;      case 0
;         RegWrite($BlacklistKeyname & $partGUID & '2}', 'Description','REG_SZ','cmd.exe  (***)  Microsoft Corporation Windows Command Processor')
;         RegWrite($BlacklistKeyname & $partGUID & '2}', 'SaferFlags','REG_DWORD',Number('0'))
;         RegWrite($BlacklistKeyname & $partGUID & '2}', 'ItemData','REG_SZ','cmd.exe')
;         RegWrite($keyname, $valuename, 'REG_DWORD', Number('1'))
;     case Else
;         RegDelete($BlacklistKeyname & $partGUID & '2}')
;         RegDelete($keyname, $valuename)
;   EndSwitch
;Else
;   MsgBox(262144,"", "Cannot set <Disable Command Prompt>. Please, use <(Re)Install SRP> option first to activate SRP")
;   RegDelete($BlacklistKeyname & $partGUID & '2}')
;   RegDelete($keyname, $valuename) 
;EndIf

;Local $valuename = 'DisableCMD'
;Local $RegDataNew
;Local $DisableCommandPrompt = RegRead ( $keyname, $valuename )
;select
;   case $DisableCommandPrompt = 1
;      $RegDataNew = 0
;   case Else
;      $RegDataNew = 1
;EndSelect
;RegWrite($keyname, $valuename,'REG_DWORD',$RegDataNew)

;RefreshMoreRestrictionsGUI()
;Delete the Switch OFF/ON Restrictions backup
;RegDelete($BackupSwitchRestrictions)
;Endfunc


;Func DisableCommandPrompt()
;BlockSponsors('cmd.exe', 'Windows CMD', 'IsCMDBlocked', '{1016bbe0-a716-428b-822e-5E544B6A3102}')
;;Delete the Switch OFF/ON Restrictions backup
;RegDelete($BackupSwitchRestrictions)

;RefreshMoreRestrictionsGUI()
;EndFunc


Func NoElevationSUA()
Local $keyname = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
Local $valuename = 'ConsentPromptBehaviorUser'
Local $RegDataNew
Local $NoElevationSUA = RegRead ( $keyname, $valuename )
select
   case $NoElevationSUA = 3
      $RegDataNew = 0
   case $NoElevationSUA = '0'
      $RegDataNew = 1
   case Else
      $RegDataNew = 3
EndSelect
RegWrite($keyname, $valuename,'REG_DWORD',$RegDataNew)
;Delete the Switch OFF/ON Restrictions backup
RegDelete($BackupSwitchRestrictions)

RefreshMoreRestrictionsGUI()


Endfunc


;Func BlockPowerShellSponsors()

;If $SRPTransparentEnabled = "No Enforcement" Then 
;   MsgBox(262144,"", "Cannot turn on <Block PowerShell Sponsors>, because of <Enforcement> = 'No Enforcement' setting.") 
;   Return
;EndIf
;Local $keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers'
;Local $BlacklistKeyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\'
;Local $valuename = 'IsPowerShellBlocked'
;Local $partGUID = '{1016bbe0-a716-428b-822e-5E544B6A310'
;Local $PowerShell = RegRead ( $keyname, $valuename )
;If $isSRPinstalled = "Installed" Then
;   Switch $PowerShell
;      case 0
;         RegWrite($BlacklistKeyname & $partGUID & '0}', 'Description','REG_SZ','powershell.exe  (***)  Microsoft Corporation Windows PowerShell')
;         RegWrite($BlacklistKeyname & $partGUID & '0}', 'SaferFlags','REG_DWORD',Number('0'))
;         RegWrite($BlacklistKeyname & $partGUID & '0}', 'ItemData','REG_SZ','powershell.exe')
;         RegWrite($BlacklistKeyname & $partGUID & '1}', 'Description','REG_SZ','powershell_ise.exe  (***)  Microsoft Corporation Windows PowerShell ISE')
;         RegWrite($BlacklistKeyname & $partGUID & '1}', 'SaferFlags','REG_DWORD',Number('0'))
;         RegWrite($BlacklistKeyname & $partGUID & '1}', 'ItemData','REG_SZ','powershell_ise.exe')
;         RegWrite($keyname, $valuename, 'REG_DWORD', Number('1'))
;      case Else
;         RegDelete($BlacklistKeyname & $partGUID & '0}')
;         RegDelete($BlacklistKeyname & $partGUID & '1}')
;         RegDelete($keyname, $valuename)
;   EndSwitch
;Else
;   MsgBox(262144,"", "Cannot set <Block PowerShell Sponsors>. Please, use <(Re)Install SRP> option first to activate SRP")
;   RegDelete($BlacklistKeyname & $partGUID & '0}')
;   RegDelete($BlacklistKeyname & $partGUID & '1}')
;   RegDelete($keyname, $valuename)
;EndIf
;MsgBox(0,"",$PowerShell)
;RefreshMoreRestrictionsGUI()
;MsgBox(0,"",$PowerShell)
;Delete the Switch OFF/ON Restrictions backup
;RegDelete($BackupSwitchRestrictions)
;EndFunc

;Func BlockPowerShellSponsors()
;BlockSponsors('powershell.exe', 'POWERSHELL', 'IsPowerShellBlocked0', '{1016bbe0-a716-428b-822e-5E544B6A3100}')
;BlockSponsors('powershell_ise.exe', 'POWERSHELL_ISE', 'IsPowerShellBlocked1', '{1016bbe0-a716-428b-822e-5E544B6A3101}')
;Local $keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers'
;Local $x = RegRead($keyname, 'IsPowerShellBlocked0')
;$x = $x & RegRead($keyname, 'IsPowerShellBlocked1')
;If $x = '11' Then
;   RegWrite($keyname, 'IsPowerShellBlocked', 'REG_DWORD', Number('1'))
;Else
;    RegDelete($keyname, 'IsPowerShellBlocked')
;EndIf
;;Delete the Switch OFF/ON Restrictions backup
;RegDelete($BackupSwitchRestrictions)

;RefreshMoreRestrictionsGUI()
;EndFunc



Func MSIElevation()
  Local $keyname = 'HKCR\Msi.Package\shell\runas\command'
  Local $valuename = ''
  Local $RegDataNew
  Local $MSIElevation = RegRead ( $keyname, $valuename )
  select
     case $MSIElevation = '"%SystemRoot%\System32\msiexec.exe" /i "%1" %*'
        RegDelete('HKCR\Msi.Package\shell\runas')
     case Else
        $RegDataNew = '"%SystemRoot%\System32\msiexec.exe" /i "%1" %*'
        RegWrite($keyname, $valuename,'REG_EXPAND_SZ',$RegDataNew)
  EndSelect
  If $isSRPinstalled = "Not Installed" Then
     RegDelete('HKCR\Msi.Package\shell\runas')
     MsgBox(262144,"","SRP are not installed. 'MSI Elevation' is set to 'OFF'.")
  EndIf
;Delete the Switch OFF/ON Restrictions backup
RegDelete($BackupSwitchRestrictions)

  RefreshMoreRestrictionsGUI()
EndFunc


Func _CheckDisableSMB()
Local $keyname = 'HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10'
Local $valuename = 'Start'
$DisableSMB = RegRead ( $keyname, $valuename )
If CorrectSMB10Uninstalled() = 1 Then $DisableSMB = 4
$keyname = 'HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb20'
$DisableSMB = $DisableSMB & RegRead ( $keyname, $valuename )
$keyname = 'HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation'
$valuename = 'DependOnService'
$DisableSMB = $DisableSMB & RegRead ( $keyname, $valuename )
$keyname = 'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters'
$valuename = 'SMB1'
Local $x= RegRead ( $keyname, $valuename )
If @error <> 0 Then $x = '1'
$DisableSMB = $DisableSMB & $x
$valuename = 'SMB2'
$x= RegRead ( $keyname, $valuename )
If @error <> 0 Then $x = '1'
$DisableSMB = $DisableSMB & $x

;Correction to invalid registry values after Windows upgrade
If $DisableSMB = '43' & 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI' & '00' Then
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb20', 'Start', 'REG_DWORD', Number('4'))
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation', 'DependOnService', 'REG_MULTI_SZ', 'Bowser' & @LF & 'NSI')
   $DisableSMB = '44' & 'Bowser' & @LF & 'NSI' & '00'
EndIf
If $DisableSMB = '23' & 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI' & '00' Then
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10', 'Start', 'REG_DWORD', Number('4'))
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb20', 'Start', 'REG_DWORD', Number('4'))
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation', 'DependOnService', 'REG_MULTI_SZ', 'Bowser' & @LF & 'NSI')
   $DisableSMB = '44' & 'Bowser' & @LF & 'NSI' & '00'
EndIf
If $DisableSMB = '23' & 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI' & '01' Then
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10', 'Start', 'REG_DWORD', Number('4'))
   $DisableSMB = '43' & 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI' & '01'
EndIf

Switch $DisableSMB
   case '44' & 'Bowser' & @LF & 'NSI' & '00'
      $DisableSMB = "ON123"
      $MoreRestrictionsOutput = $MoreRestrictionsOutput & '3'
   case '43' & 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI' & '01'
      $DisableSMB = "ON1"
      $MoreRestrictionsOutput = $MoreRestrictionsOutput & '1'
   case '33' & 'Bowser' & @LF & 'MRxSmb10' & @LF & 'MRxSmb20' & @LF & 'NSI' & '11'
      If (@OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
         $DisableSMB = "OFF"
         $MoreRestrictionsOutput = $MoreRestrictionsOutput & '0'   
      Else
         $DisableSMB = "?"
         $MoreRestrictionsOutput = $MoreRestrictionsOutput & '?'   
      EndIf
   case '23' & 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI' & '11'
      If (@OSVersion="WIN_10" or @OSVersion="WIN_81") Then
         $DisableSMB = "OFF"
        $MoreRestrictionsOutput = $MoreRestrictionsOutput & '0'   
      Else
         $DisableSMB = "?"
         $MoreRestrictionsOutput = $MoreRestrictionsOutput & '?'  
      EndIf 
   case Else
      $DisableSMB = "?"
      $MoreRestrictionsOutput = $MoreRestrictionsOutput & '?'         
EndSwitch
EndFunc


Func DisableSMB($flag)
StringReplace($RefreshChangesCheck, "DisableSMB" & @LF, "")
$RefreshChangesCheck = $RefreshChangesCheck & "DisableSMB" & @LF
Local $x1 = RegRead('HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters', 'SMB1')
If not ($x1 = '1') Then $x1 = '0'
Local $x2 = RegRead('HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters', 'SMB2')
If not ($x2 = '1') Then $x2 = '0'

; ON123 (00) > OFF (11) > ON1 (01) > 
; Disable SMBv2 and SMBv3 on the SMB server and on SMB client.

; If '01' -> '00'
If ($x1='0' And $x2='1') Then
   If CorrectSMB10Uninstalled() = 0 Then RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10', 'Start', 'REG_DWORD', Number('4'))
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb20', 'Start', 'REG_DWORD', Number('4'))
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation', 'DependOnService','REG_MULTI_SZ', 'Bowser' & @LF & 'NSI')
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters', 'SMB1', 'REG_DWORD', Number('0'))
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters', 'SMB2', 'REG_DWORD', Number('0'))
;  Delete the Switch OFF/ON Restrictions backup
   If $flag = '0' Then RegDelete($BackupSwitchRestrictions)
   Return
EndIf

; If '00' -> '11'
If ($x1='0' And $x2='0') Then
   If (@OSVersion="WIN_10" or  @OSVersion="WIN_81") Then
      If CorrectSMB10Uninstalled() = 0 Then RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10', 'Start', 'REG_DWORD', Number('2'))
      RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation', 'DependOnService','REG_MULTI_SZ', 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI')
   Else
      If CorrectSMB10Uninstalled() = 0 Then RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10', 'Start', 'REG_DWORD', Number('3'))
      RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation', 'DependOnService','REG_MULTI_SZ', 'Bowser' & @LF & 'MRxSmb10' & @LF & 'MRxSmb20' & @LF & 'NSI')
   EndIf
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb20', 'Start', 'REG_DWORD', Number('3'))
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters', 'SMB1', 'REG_DWORD', Number('1'))
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters', 'SMB2', 'REG_DWORD', Number('1'))
;  Delete the Switch OFF/ON Restrictions backup
   If $flag = '0' Then RegDelete($BackupSwitchRestrictions)
   Return
EndIf

; If '11' -> '01'
If ($x1='1' And $x2='1') Then
   If CorrectSMB10Uninstalled() = 0 Then RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10', 'Start', 'REG_DWORD', Number('4'))
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb20', 'Start', 'REG_DWORD', Number('3'))
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation', 'DependOnService','REG_MULTI_SZ', 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI')
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters', 'SMB1', 'REG_DWORD', Number('0'))
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters', 'SMB2', 'REG_DWORD', Number('1'))
;  Delete the Switch OFF/ON Restrictions backup
   If $flag = '0' Then RegDelete($BackupSwitchRestrictions)
   Return
EndIf

; Not typical values -> set SMB values to OFF ('11')
If (@OSVersion="WIN_10" or  @OSVersion="WIN_81") Then
   If CorrectSMB10Uninstalled() = 0 Then RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10', 'Start', 'REG_DWORD', Number('2'))
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation', 'DependOnService','REG_MULTI_SZ', 'Bowser' & @LF & 'MRxSmb20' & @LF & 'NSI')
Else
   If CorrectSMB10Uninstalled() = 0 Then RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10', 'Start', 'REG_DWORD', Number('3'))
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation', 'DependOnService','REG_MULTI_SZ', 'Bowser' & @LF & 'MRxSmb10' & @LF & 'MRxSmb20' & @LF & 'NSI')
EndIf
RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb20', 'Start', 'REG_DWORD', Number('3'))
RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters', 'SMB1', 'REG_DWORD', Number('1'))
RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters', 'SMB2', 'REG_DWORD', Number('1'))

;Delete the Switch OFF/ON Restrictions backup
If $flag = '0' Then RegDelete($BackupSwitchRestrictions)

EndFunc


Func _DisableSMB()
DisableSMB('0')
RefreshMoreRestrictionsGUI()
EndFunc



Func CalculateBlacklistFilePaths($path)

;$DescriptionLabel variable is the Global variable defined in Autoruns() function !!!
#include <GUIConstantsEx.au3>
#include <StringConstants.au3>
#Include <File.au3>
#include <FileConstants.au3>
#RequireAdmin

Local $var[6]
;Select a file for adding to the Whitelist.
$var[0] = $path
;MsgBox(0,"", $var[0])
If not ($var[0] = "") Then
;Get the filesize
        $var[1] = FileGetSize ($var[0])
;       MsgBox(0,"", $var[0] & @CRLF & $var[1])
;Get the info about the file               
        Local $fileinfo = FileGetVersion ( $var[0], $FV_COMPANYNAME)
        $fileinfo =  $fileinfo & @CRLF & FileGetVersion ( $var[0], $FV_FILEDESCRIPTION)
        $var[2] =  $fileinfo & @CRLF & FileGetVersion ( $var[0], $FV_FILEVERSION)
;       MsgBox(0,"", $var[2])
;Create new GUID
        Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths'
        Local $sSubKey = RegEnumKey($mainkey, 1)
        Local $partSubkey = $mainkey & '\{1016bbe0-a716-428b-822e-5E544B6A3'
        Local $i = 1
        Local $n = 100
        While ($sSubKey <> "")
            If $n > 999 Then
               MsgBox(0,"ALERT", "Cannot be blacklisted by Path. There are too many entries already blacklisted")
               ExitLoop
            EndIf
            $sSubKey = RegEnumKey($mainkey, $i)
            If @error Then ExitLoop  
;           MsgBox(0,"", $partSubkey & $n  & "}" & @CRLF & $mainkey & '\' & $sSubKey)
            If $partSubkey & $n & "}" = $mainkey & '\' & $sSubKey Then
                $n = $n + 1
                $i = 0
            EndIf
            $i = $i + 1
;           MsgBox(0,"", "$i = " & $i & @CRLF & "$n = " & $n)
        WEnd

;Here is the path with the new GUID
        $var[5] = $partSubkey & $n & '}'
;       MsgBox(0,"Found the new GUID", $var[5])

        ;Write data to the Registry
   If SearchBlacklistedPathsDuplicates ($var[0]) = 0 Then
     RegWrite ($var[5], 'Description','REG_SZ', $DescriptionLabel & $var[0] & "  (***)  " & $var[2] & '  REG = ' & $var[5])
     RegWrite ($var[5], 'SaferFlags','REG_DWORD', Number('0'))
     RegWrite ($var[5], 'ItemData','REG_SZ', $var[0])
;    MsgBox("0","",RegRead ($var[5], 'ItemData'))
     _ArrayAdd($NewPathsArray, $var[0])
   Else
     _ArrayAdd($PathDuplicatesArray, $var[0])
;    MsgBox(0,"", 'This item is already on the list' & @CRLF & $PathDuplicatesArray[1])
     Return '0'
   EndIf

;Content of the added list item 
If Stringlen($var[2]) > 200 Then $var[2] = StringLeft($var[2],200)
Return $var[0] & "  (***)  " & $var[2] & '   REG = ' & $var[5]

EndIf
EndFunc 

Func SearchBlacklistedPathsDuplicates()
Local $MaxEntries = 2000
 #include <MsgBoxConstants.au3>
 Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\'
 Local $sSubKey = ""
 For $i = 1 To $MaxEntries
   $sSubKey = RegEnumKey('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths', $i)
   If @error Then ExitLoop
   Local $itemold = RegRead($mainkey & $sSubKey, 'ItemData')
   If (StringInStr($itemold, $itemnew) = 1 ) And (StringInStr($itemnew, $itemold) = 1 ) Then
;   MsgBox (0,"", StringInStr($itemold, $itemnew) & '    ' &  StringInStr($itemnew, $itemold))
   Return '1'
   EndIf
 Next
 Return '0'
EndFunc


Func DisableCachedLogons1()
  DisableCachedLogons()
  RefreshMoreRestrictionsGUI()
; Delete the Switch OFF/ON Restrictions backup
  RegDelete($BackupSwitchRestrictions)
EndFunc


Func DisableCachedLogons()

Local $keyname = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
Local $valuename = 'CachedLogonsCount'
Local $RegDataNew
Local $DisableCachedLogons = RegRead ( $keyname, $valuename )
select
   case $DisableCachedLogons = '0'
      $RegDataNew = '10'
   case $DisableCachedLogons = '10'
      $RegDataNew = '0'
   case Else
      $RegDataNew = '0'
EndSelect
RegWrite($keyname, $valuename,'REG_SZ',$RegDataNew)

EndFunc


Func UAC_CTRL_ALT_DEL1()
  UAC_CTRL_ALT_DEL()
  RefreshMoreRestrictionsGUI()
; Delete the Switch OFF/ON Restrictions backup
  RegDelete($BackupSwitchRestrictions)
EndFunc



Func UAC_CTRL_ALT_DEL()

Local $keyname = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\CredUI'
Local $valuename = 'EnableSecureCredentialPrompting'
Local $RegDataNew
Local $UACSecureCredentialPrompting = RegRead ( $keyname, $valuename )
select
   case $UACSecureCredentialPrompting = 0
      $RegDataNew = 1
   case $UACSecureCredentialPrompting = 1
      $RegDataNew = 0
   case Else
      $RegDataNew = 0
EndSelect
RegWrite($keyname, $valuename,'REG_DWORD',$RegDataNew)

EndFunc


Func HelpH()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpH.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
  _ExtMsgBox(0,"CLOSE", "Disable 16-bits Help", $help)
EndFunc

Func HelpI()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpI.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
  _ExtMsgBox(0,"CLOSE", "Shell Extension Security Help", $help)
EndFunc

Func HelpJ()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpJ.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
  _ExtMsgBox(0,"CLOSE", " Help", $help)
EndFunc

Func HelpK()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpK.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
  _ExtMsgBox(0,"CLOSE", "Disable Elevation on SUA Help", $help)
EndFunc

Func HelpL()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpL.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
  _ExtMsgBox(0,"CLOSE", " Help", $help)
EndFunc

Func HelpM()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpM.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
  _ExtMsgBox(0,"CLOSE", "MSI Elevation Help", $help)
EndFunc

Func HelpSMB()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpSMB.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
  _ExtMsgBox(0,"CLOSE", "Disable SMB Help", $help)
EndFunc

Func HelpDisableCachedLogons()
  Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\NoCachedLogons.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
  _ExtMsgBox(0,"CLOSE", "Disable Cached Logons Help", $help)
EndFunc

Func HelpUAC_CTRL_ALT_DEL()
  Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\UAC_CTRL_ALT_DEL.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
  _ExtMsgBox(0,"CLOSE", "UAC_CTRL_ALT_DEL Help", $help)
EndFunc


Func CorrectSMB10Uninstalled()
$keyname = 'HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10'
$valuename = 'Start'
RegRead ( $keyname, $valuename )
If (@error = 1 AND (@OSVersion = "WIN_10" OR @OSVersion = "WIN_81")) Then 
   RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters', 'SMB1', 'REG_DWORD', Number('0'))
   Return 1
EndIf
Return 0
EndFunc