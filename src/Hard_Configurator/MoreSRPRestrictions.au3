Func MoreSRPRestrictions()

;GUI for additional SRP restrictions
;#include <EditConstants.au3>
;#include <GUIConstantsEx.au3>
;#include <WindowsConstants.au3>
;#include 'BlockArchivers.au3'

;Global $M_SRPlistview
;Global $M_SRPlistGUI
Local  $deltaX=10

;GUISetState(@SW_DISABLE, $listGUI)
;GUISetState(@SW_HIDE,$listGUI)
;Opt("GUIOnEventMode", 1)
HideMainGUI()

; _GUICtrlListView_DeleteAllItems($Listview)

;  Opt("GUIOnEventMode", 1)
  If not $X_M_SRPlistGUI > 0 Then $X_M_SRPlistGUI = -1
  If not $Y_M_SRPlistGUI > 0 Then $Y_M_SRPlistGUI = -1

   $M_SRPlistGUI = GUICreate("More SRP Restrictions", 330, 500, $X_M_SRPlistGUI, $Y_M_SRPlistGUI, -1)
   GUISetOnEvent($GUI_EVENT_CLOSE, "CloseMoreSRPRestrictions")
   $M_SRPlistview = GUICtrlCreateListView("Settings", 10, 10, 100, 350)
   _GUICtrlListView_SetColumnWidth($M_SRPlistview, 0, 70)

  MoreSRPRestrictionsValues()

  GUICtrlCreateListViewItem($WritableSubWindows, $M_SRPlistview)
  GUICtrlCreateListViewItem($DenyShortcuts, $M_SRPlistview)
  GUICtrlCreateListViewItem($LowerExeRestrictions, $M_SRPlistview)
  GUICtrlCreateListViewItem($HardenArchivers, $M_SRPlistview)
  GUICtrlCreateListViewItem($HardenEmailClients, $M_SRPlistview)

  $BtnWritableSubWindows = GUICtrlCreateButton("Protect Windows Folder",  112+$deltaX, 35, 148, 19)
  GUICtrlSetOnEvent(-1, "WritableSubWindows1")
  $BtnHelpWritableSubWindows = GUICtrlCreateButton("Help", 264+$deltaX, 35, 40, 19)
  GUICtrlSetOnEvent(-1, "Help7")

  $BtnDenyShortcuts = GUICtrlCreateButton("Protect Shortcuts", 112+$deltaX, 54, 148, 19)
  GUICtrlSetOnEvent(-1, "Deny_Shortcuts1")
  $BtnHelpDenyShortcuts = GUICtrlCreateButton("Help",  264+$deltaX, 54, 40, 19)
  GUICtrlSetOnEvent(-1, "Help8")

  $BtnLowerExeRestrictions = GUICtrlCreateButton("Update Mode", 112+$deltaX, 73, 148, 19)
  GUICtrlSetOnEvent(-1, "LowerExeRestrictions1")
  $BtnHelpLowerExeRestrictions = GUICtrlCreateButton("Help",  264+$deltaX, 73, 40, 19)
  GUICtrlSetOnEvent(-1, "LowerExeRestrictionsHelp")

  $BtnHardenArchivers = GUICtrlCreateButton("Harden Archivers", 112+$deltaX, 92, 148, 19)
  GUICtrlSetOnEvent(-1, "HardenArchivers1")
  $BtnHelpHardenArchivers = GUICtrlCreateButton("Help",  264+$deltaX, 92, 40, 19)
  GUICtrlSetOnEvent(-1, "HardenArchiversHelp")

  $BtnHardenEmailClients = GUICtrlCreateButton("Harden Email Clients", 112+$deltaX, 111, 148, 19)
  GUICtrlSetOnEvent(-1, "HardenEmailClients1")
  $BtnHelpHardenEmailClients = GUICtrlCreateButton("Help",  264+$deltaX, 111, 40, 19)
  GUICtrlSetOnEvent(-1, "HardenEmailClientsHelp")

   $BtnEndExtensions = GUICtrlCreateButton("Close", 150, 330, 80, 30)
   GUICtrlSetOnEvent(-1, "CloseMoreSRPRestrictions")
   GUISetState(@SW_SHOW, $M_SRPlistGUI)

; Disable some buttons for earlier Windows versions
  If not (@OSVersion="WIN_10") Then
     _GUICtrlButton_Enable($BtnDisableUntrustedFonts, False)
     $GreyDisableUntrustedFonts = 1
  EndIf

If not ($isSRPinstalled = "Installed") Then
  _GUICtrlButton_Enable($BtnWritableSubWindows, False)
  _GUICtrlButton_Enable($BtnDenyShortcuts, False)
  _GUICtrlButton_Enable($BtnLowerExeRestrictions, False)
EndIf

EndFunc


Func WritableSubWindows1()
   WritableSubWindows('0')
EndFunc


Func Deny_Shortcuts1()
   Deny_Shortcuts('0')
EndFunc


Func LowerExeRestrictions1()
;MsgBox(0,"",$SRPAllowExe & @crlf & $SRPAllowMsi)
Local $temp

If ($SRPAllowExe = "ON" And $SRPAllowMsi = "ON") Then
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
   _ExtMsgBox(64,"&OK", "UPDATE MODE", "You have already allowed EXE and MSI files globally, so the <Update Mode> setting should be set to OFF")
   	$LowerExeRestrictions = 'ON'
	LowerExeRestrictions('0', 0)
	$LowerExeRestrictions = 'OFF'
	Return
EndIf

Local   $restrictions =  CheckLowerExeRestrictions()
; Return 1 ----> '\*.exe', '\*.tmp', and '\*.msi' paths restricted
; Return 3 ----> only '\*.msi' paths restricted
; Return 0 = no restrictions
; Return 2 wrong settings
Switch $restrictions
;  No lowering restrictions ---> only '\*.msi'
   case 0
	If not ($SRPAllowMsi = "ON") Then
  	   $LowerExeRestrictions = 'OFF'
	   LowerExeRestrictions('0', 0)
	   $LowerExeRestrictions = 'MSI'
	Else
	   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
	   $temp = _ExtMsgBox(64,"&KEEP|ON", "UPDATE MODE", "You have already allowed MSI files globally in UserSpace." & @crlf & @crlf & "** Press the < KEEP > button if you want to keep the current setting <Update Mode> = OFF, that does not allow other untrusted files in ProgramData and user Appdata folders." & @crlf & @crlf & "** Press the < ON > button if you want to turn ON the <Update Mode> for MSI and EXE files. This will additionally allow EXE files in ProgramData and user Appdata folders." & @crlf)
	   If $temp = 2 Then
		$LowerExeRestrictions = 'MSI'
		LowerExeRestrictions('0', 1)
		$LowerExeRestrictions = 'ON'
	   EndIf
	EndIf
;  only '\*.msi' ---> '\*.exe', '\*.tmp', and '\*.msi'
   case 3
	If not ($SRPAllowExe = "ON") Then
	   $LowerExeRestrictions = 'MSI'
	   LowerExeRestrictions('0', 1)
	   $LowerExeRestrictions = 'ON'
	Else
	   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
	   $temp = _ExtMsgBox(64,"&KEEP|OFF", "UPDATE MODE", "You have already allowed EXE files globally." & @crlf & @crlf & "** Press the < KEEP > button if you want to keep the current setting <Update Mode> = MSI, that allows MSI files in ProgramData and user Appdata folders." & @crlf & @crlf & "** Press the < OFF > button if you want to turn OFF the <Update Mode>." & @crlf)
	   If $temp = 2 Then
		$LowerExeRestrictions = 'ON'
		LowerExeRestrictions('0', 0)
		$LowerExeRestrictions = 'OFF'
	   EndIf
	EndIf
;  '\*.exe', '\*.tmp', and '\*.msi' -----> no lowering restrictions
   case 1
	$LowerExeRestrictions = 'ON'
	LowerExeRestrictions('0', 0)
	$LowerExeRestrictions = 'OFF'
   case Else
	MsgBox(0,"", "Wrong setting detected. The <Update Mode> will be set to OFF.")
	$LowerExeRestrictions = 'ON'
	LowerExeRestrictions('0', 0)
	$LowerExeRestrictions = 'OFF'
EndSwitch
EndFunc


Func CloseMoreSRPRestrictions()
   GuiDelete($M_SRPlistGUI)
;   GUISetState(@SW_ENABLE, $listGUI)
;   GUISetState(@SW_HIDE,$listGUI)
;   GUISetState(@SW_SHOW,$listGUI)
   ShowMainGUI()
   ShowRegistryTweaks()
EndFunc


Func RefreshMoreSRPRestrictionsGUI()
  Local $pos = WinGetPos ($M_SRPlistGUI)
  $X_M_SRPlistGUI = $pos[0]
  $Y_M_SRPlistGUI = $pos[1]
  GUISetState(@SW_HIDE,$M_SRPlistGUI)
  GuiDelete($M_SRPlistGUI)
  MoreSRPRestrictions()
EndFunc



Func MoreSRPRestrictionsValues()
$MoreSRPRestrictionsOutput = ""
Local $CheckRestrictArchivers
Local $CheckRestrictEmailClients
Local $temp = ""

If ($SRPTransparentEnabled = "No Enforcement" or $SRPTransparentEnabled = "not found" or $SRPTransparentEnabled = "?") Then
   $temp = "E"
EndIf

If $GreyWritableSubWindows = 0 Then
   $WritableSubWindows =  CheckWritableSubWindows()
   Switch $WritableSubWindows
      case "0"
         $WritableSubWindows = "OFF"
         $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '0'
      case 1
	 $WritableSubWindows = "ON"
	 If $temp = "E" Then
	    $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & 'E'
	 Else
	    $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '1'
	 EndIf
      case Else
         $WritableSubWindows = "?"
         $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '?'
   EndSwitch
Else
   $WritableSubWindows = "OFF"
   $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '0'
EndIf


local $guidname = '{1016bbe0-a716-428b-822e-5E544B6A3301}'
$keyname = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\paths\' & $guidname
$valuename = "ItemData"
$DenyShortcuts = RegRead ( $keyname, $valuename )
$iskey = @error
If ($SRPTransparentEnabled = "No Enforcement" or $SRPTransparentEnabled = "not found" or $SRPTransparentEnabled = "?") Then
   $DenyShortcuts = "OFF"
EndIf
If ($iskey = -1 or $iskey =1) Then $DenyShortcuts = "OFF"
If ($SRPDefaultLevel = "White List" and $DenyShortcuts = "*.lnk") Then
   RegWrite($keyname, $valuename, 'REG_SZ', "protected")
   $DenyShortcuts = "protected"
   $RefreshChangesCheck = $RefreshChangesCheck & "Deny_Shortcuts" & @LF
EndIf
If ($SRPDefaultLevel = "Basic User" and $DenyShortcuts = "protected") Then
   RegWrite($keyname, $valuename, 'REG_SZ', "*.lnk")
   $DenyShortcuts = "*.lnk"
   $RefreshChangesCheck = $RefreshChangesCheck & "Deny_Shortcuts" & @LF
EndIf
Switch $DenyShortcuts
   case "*.lnk"
      $DenyShortcuts = "ON"
      $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '1'
   case "protected"
      $DenyShortcuts = "ON"
      $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '1'
   case "OFF"
      $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '0'
   case Else
      $DenyShortcuts = "?"
      $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '?'
EndSwitch

; Automatical correction of Protected Shortcuts feature for updates from version 4.0.0.0 and prior.
If $DenyShortcuts = "ON" Then
   If not (RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{A4BFCC3A-DB2C-424C-B029-7FE99A87C641}', 'ItemData') = '%USERPROFILE%\Desktop\*.lnk\*') Then
       $DenyShortcuts = "OFF"
       Deny_Shortcuts('1')
   EndIf
EndIf

If $GreyLowerExeRestrictions = 0 Then
   $LowerExeRestrictions =  CheckLowerExeRestrictions()
;  Correction to H_C ver. 5.0.0.1 (which has less supported archivers)
   If $LowerExeRestrictions = 4 Then
      RemoveOld_ProtectLowerExeRestrictions()
      $LowerExeRestrictions = 'MSI'
      LowerExeRestrictions('1', 1)
      $LowerExeRestrictions = 'ON'
   EndIf
   If $LowerExeRestrictions = 5 Then
      RemoveOld_ProtectLowerExeRestrictions()
      $LowerExeRestrictions = 'OFF'
      LowerExeRestrictions('1', 0)
      $LowerExeRestrictions = 'MSI'
   EndIf

   $LowerExeRestrictions = CheckLowerExeRestrictions()

;   If ($SRPTransparentEnabled = "No Enforcement" or $SRPTransparentEnabled = "not found" or $SRPTransparentEnabled = "?") Then
;      $LowerExeRestrictions = "0"
;   EndIf
   Switch $LowerExeRestrictions
      case "0"
         $LowerExeRestrictions = "OFF"
         $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '0'
      case 1
         $LowerExeRestrictions = "ON"
	 If $temp = "E" Then
	    $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & 'E'
	 Else
	    $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '1'
	 EndIf
      case 3
         $LowerExeRestrictions = "MSI"
	 If $temp = "E" Then
	    $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & 'E'
	 Else
	    $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '3'
	 EndIf
      case Else
         $LowerExeRestrictions = "?"
         $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '?'
   EndSwitch
EndIf

If $GreyLowerExeRestrictions = 1 Then
   $LowerExeRestrictions = "OFF"
   $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '0'
EndIf

$CheckRestrictArchivers = CheckRestrictArchivers()
; Correction to H_C ver. 5.0.0.1 (which has less supported archivers)
If $CheckRestrictArchivers = 4 Then RestrictArchivers(0)
If $CheckRestrictArchivers = 5 Then RestrictArchivers(1)
$CheckRestrictArchivers = CheckRestrictArchivers()
;MsgBox(0,"MoreSRPRestr",$CheckRestrictArchivers)

If $CheckRestrictArchivers = 1 Then $HardenArchivers = "ON"
If $CheckRestrictArchivers = 0 Then $HardenArchivers = "OFF"
If $CheckRestrictArchivers = 3 Then $HardenArchivers = "MSI"

If not ($CheckRestrictArchivers = 1 Or $CheckRestrictArchivers = 0 or $CheckRestrictArchivers = 3) Then $HardenArchivers = "?"
Switch $HardenArchivers
   case "OFF"
      $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '0'
   case "ON"
	 If $temp = "E" Then
	    $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & 'E'
	 Else
	    $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '1'
	 EndIf
   case "MSI"
	 If $temp = "E" Then
	    $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & 'E'
	 Else
	    $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '3'
	 EndIf
   case Else
      $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '?'
EndSwitch


; Email Clients
; Correction to H_C ver. 5.0.0.1 (which has less supported archivers)
If CheckRestrictEmailClients() = 4 Then RestrictEmailClients()
;MsgBox(0, "More SRP Email", CheckRestrictEmailClients())
$CheckRestrictEmailClients = CheckRestrictEmailClients()
If $CheckRestrictEmailClients = 1 Then $HardenEmailClients = "ON"
If $CheckRestrictEmailClients = 0 Then $HardenEmailClients = "OFF"
If not ($CheckRestrictEmailClients = 1 Or $CheckRestrictEmailClients = 0) Then $HardenEmailClients = "?"
Switch $HardenEmailClients
   case "OFF"
      $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '0'
   case "ON"
	 If $temp = "E" Then
	    $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & 'E'
	 Else
	    $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '1'
	 EndIf
   case Else
      $MoreSRPRestrictionsOutput =  $MoreSRPRestrictionsOutput & '?'
EndSwitch

EndFunc


Func LowerExeRestrictions($flag, $skipEXE)
; If $skipEXE = 1 then only MSI will be whitelisted in AppData and ProgramData
#RequireAdmin
Local $temp
Local $path0 = $systemdrive & '\Users\*\AppData'
Local $path
Local $path0_ProgramData = $systemdrive & '\ProgramData'
Local $EXEext = '\*.exe'
Local $TMPext = '\*.tmp'
Local $MSIext = '\*.msi'

If not (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
   _ExtMsgBox(0,"OK", "Update Mode Alert", "This Windows version is not supported.")
   Return
EndIf

Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144\Paths\{1016bbe0-a716-428b-822e-4E544B6A3'

; Disabling <Update Mode> when SRP Enforcement is set to block DLLs.
If $SRPTransparentEnabled = "Include DLLs" Then
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
   _ExtMsgBox(64,"&OK", "UPDATE MODE", "You have set <Enforcement> = 'All Files'. This SRP Enforcement setting does not support <Update Mode>. The <Update Mode> setting will be be set to OFF")
   For $i=301 to 420
      RegDelete($RegGUID & $i & '}')
   Next
   RemoveProtectLowerExeRestrictions()
   $LowerExeRestrictions = 'OFF'
;  Enable alerts when running unsafe EXE files (from Internet Zone or unsigned) on Windows Vista and Windows 7
   RemoveEXE2ModRiskFileTypes()
   If not ($flag = '1') Then
      RefreshMoreSRPRestrictionsGUI()
   EndIf
;  RefreshChangesCheck("LowerExeRestrictions")
   $RefreshChangesCheck = $RefreshChangesCheck & "UpdateMode" & $LowerExeRestrictions & @LF
   Return
EndIf

;  Switch to 'OFF'
If ($LowerExeRestrictions <> 'OFF' and $skipEXE = 0) Then
   For $i=301 to 420
      RegDelete($RegGUID & $i & '}')
   Next
   RemoveProtectLowerExeRestrictions()
   $LowerExeRestrictions = 'OFF'
;  Enable alerts when running unsafe EXE files (from Internet Zone or unsigned) on Windows Vista and Windows 7
   RemoveEXE2ModRiskFileTypes()
Else
   If $isSRPinstalled = "Installed" Then
;	   MsgBox(0,"",$LowerExeRestrictions)
;  Switch to 'ON'
;	Disable alerts when running unsafe EXE files (from Internet Zone or unsigned) on Windows Vista and Windows 7
      AddEXE2ModRiskFileTypes()
      If $skipEXE = 0 Then
         For $i=301 to 420
            RegDelete($RegGUID & $i & '}')
         Next
      EndIf
      If not ($skipEXE = 0) Then
;       Appdata Unrestricted rules for EXE
	   $path = $path0
	   For $i=301 to 320
 	      $path = $path & '\*'
;	      MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $EXEext)
              RegWrite($RegGUID & $i & '}', 'Description','REG_SZ','')
              RegWrite($RegGUID & $i & '}', 'SaferFlags','REG_DWORD',Number('0'))
              RegWrite($RegGUID & $i & '}', 'ItemData','REG_SZ', $path & $EXEext)
	   Next
;       Appdata Unrestricted rules for TMP
	   $path = $path0
	   For $i=321 to 340
 	      $path = $path & '\*'
;	      MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $TMPext)
              RegWrite($RegGUID & $i & '}', 'Description','REG_SZ','')
              RegWrite($RegGUID & $i & '}', 'SaferFlags','REG_DWORD',Number('0'))
              RegWrite($RegGUID & $i & '}', 'ItemData','REG_SZ', $path & $TMPext)
	   Next
      EndIf
;  Appdata Unrestricted rules for MSI
;	   MsgBox(0,"",$LowerExeRestrictions)
;          Switch to 'ON'
	   $path = $path0
	   For $i=341 to 360
 	      $path = $path & '\*'
;	      MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $MSIext)
              RegWrite($RegGUID & $i & '}', 'Description','REG_SZ','')
              RegWrite($RegGUID & $i & '}', 'SaferFlags','REG_DWORD',Number('0'))
              RegWrite($RegGUID & $i & '}', 'ItemData','REG_SZ', $path & $MSIext)
	   Next

      If not ($skipEXE = 0) Then
;       ProgramData Unrestricted rules for EXE
	   $path = $path0_ProgramData
	   For $i=361 to 380
 	      $path = $path & '\*'
;	      MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $EXEext)
              RegWrite($RegGUID & $i & '}', 'Description','REG_SZ','')
              RegWrite($RegGUID & $i & '}', 'SaferFlags','REG_DWORD',Number('0'))
              RegWrite($RegGUID & $i & '}', 'ItemData','REG_SZ', $path & $EXEext)
	   Next
;       ProgramData Unrestricted rules for TMP
	   $path = $path0_ProgramData
	   For $i=381 to 400
 	      $path = $path & '\*'
;	      MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $TMPext)
              RegWrite($RegGUID & $i & '}', 'Description','REG_SZ','')
              RegWrite($RegGUID & $i & '}', 'SaferFlags','REG_DWORD',Number('0'))
              RegWrite($RegGUID & $i & '}', 'ItemData','REG_SZ', $path & $TMPext)
	   Next
      EndIf
;  ProgramData Unrestricted rules for MSI
	   $path = $path0_ProgramData
;	   MsgBox(0,"",$LowerExeRestrictions)
	   For $i=401 to 420
 	      $path = $path & '\*'
;	      MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $MSIext)
              RegWrite($RegGUID & $i & '}', 'Description','REG_SZ','')
              RegWrite($RegGUID & $i & '}', 'SaferFlags','REG_DWORD',Number('0'))
              RegWrite($RegGUID & $i & '}', 'ItemData','REG_SZ', $path & $MSIext)
	   Next
           $temp = CheckLowerExeRestrictions()
	   Switch $temp
		case 0
		   $LowerExeRestrictions = "OFF"
		case 1
		   $LowerExeRestrictions = "ON"
		case 3
   		   $LowerExeRestrictions = "MSI"
		case Else
		   $LowerExeRestrictions = "?"
	   EndSwitch
           ProtectLowerExeRestrictions()
   Else
           MsgBox(262144,"","This option needs SRP to be installed, with Enforcement set to 'Skip DLLs' or 'All Files'.")
   EndIf
EndIf

;ShowRegistryTweaks()
If not ($flag = '1') Then
   RefreshMoreSRPRestrictionsGUI()
EndIf
;RefreshChangesCheck("LowerExeRestrictions")
$RefreshChangesCheck = $RefreshChangesCheck & "UpdateMode" & $LowerExeRestrictions & @LF

EndFunc


Func ProtectLowerExeRestrictions()
; requires $systemdrive global variable which is defined in the main program
;MsgBox(0,"xxx",$LowerExeRestrictions)
RemoveProtectLowerExeRestrictions()
If $LowerExeRestrictions = 'OFF' Then Return
If not ($LowerExeRestrictions = "ON" Or $LowerExeRestrictions = "MSI") Then
   MsgBox(0, "Update Mode", "Wrong <Update Mode> setting. The <Update Mode> will be set to OFF" )
   Return
EndIf

; If $LowerExeRestrictions = 'MSI' then the restrictions for EXE and TMP will be skipped
  Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-2E544B6A3'
  Local $pathDir1 = '%USERPROFILE%\AppData\*'
  Local $pathDir2 = $systemdrive & '\ProgramData\*'
  Local $pathDir3 = '%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'
  Local $EXEextDir = '\*.exe\'
  Local $MSIextDir = '\*.msi\'
  Local $TMPextDir = '\*.tmp\'

  Local $sMessage = "Please wait !  It will take some time."
SplashTextOn("Update Mode", $sMessage, 250, 40, -1, -1, 0, "", 10)
; Block files (except EXE and MSI) in c:\Users\*\AppData\*\ ... \*.exe\... subfolders and in
; c:\Users\*\AppData\*\ ...\*.msi\... subfolders. This is required when whitelisting EXE and MSI files in c:\Users\*\AppData\*\
    If $LowerExeRestrictions = "ON" Then
	AddDisallowedRuleForFileExtension($RegGUID, $pathDir1, 101, 120, $EXEextDir)
	AddDisallowedRuleForFileExtension($RegGUID, $pathDir1, 121, 140, $TMPextDir)
    EndIf
    AddDisallowedRuleForFileExtension($RegGUID, $pathDir1, 141, 160, $MSIextDir)

;   Block files (except EXE and MSI) in c:\ProgramData\*\ ... \*.exe\... subfolders and in
;   c:\ProgramData\*\ ...\*.msi\... subfolders. This is required when whitelisting EXE and MSI files in c:\ProgramData\*\
    If $LowerExeRestrictions = "ON" Then
	AddDisallowedRuleForFileExtension($RegGUID, $pathDir2, 161, 180, $EXEextDir)
	AddDisallowedRuleForFileExtension($RegGUID, $pathDir2, 181, 200, $TMPextDir)
    EndIf
    AddDisallowedRuleForFileExtension($RegGUID, $pathDir2, 201, 221, $MSIextDir)

; Block anything in local user Startup folder and subfolders
    AddDisallowedRuleForFileExtension($RegGUID, $pathDir3, 221, 240, '\*')

SplashOff()
;RefreshChangesCheck("ProtectLowerExeRestrictions")
$RefreshChangesCheck = $RefreshChangesCheck & "ProtectLowerExeRestrictions" & @LF
EndFunc


Func RemoveProtectLowerExeRestrictions()
Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-2E544B6A3'
   For $i=101 to 240
      RegDelete($RegGUID & $i & '}')
   Next
;Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-1E544B6A3'
;   For $i=101 to 520
;      RegDelete($RegGUID & $i & '}')
;   Next
;;   RefreshChangesCheck("ProtectLowerExeRestrictions")
$RefreshChangesCheck = $RefreshChangesCheck & "RemoveProtectLowerExeRestrictions" & @LF
EndFunc


Func RemoveOld_ProtectLowerExeRestrictions()
Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-2E544B6A3'
   For $i=101 to 860
      RegDelete($RegGUID & $i & '}')
   Next
Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-1E544B6A3'
   For $i=101 to 520
      RegDelete($RegGUID & $i & '}')
   Next
   RefreshChangesCheck("ProtectLowerExeRestrictions")
EndFunc




Func CheckLowerExeRestrictions()
;***************This function must be exactly copied to InstallBySmartScreen.au3 ************
Local $path0 = $systemdrive & '\Users\*\AppData'
Local $path1 = $systemdrive & '\ProgramData'
Local $path = $path0
Local $EXEext = '\*.exe'
Local $TMPext = '\*.tmp'
Local $MSIext = '\*.msi'

Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144\Paths\{1016bbe0-a716-428b-822e-4E544B6A3'
Local $n = 0
Local $m = 0
If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
   For $i = 301 to 320
      $path = $path & '\*'
      If RegRead($RegGUID & $i & '}', 'SaferFlags') = '0' Then
	$m = $m + 1
      EndIf
      If RegRead($RegGUID & $i & '}', 'ItemData') = $path & $EXEext Then
	$m = $m + 1
      EndIf
;     MsgBox(0,"",RegRead($RegGUID & $i & '}', 'ItemData') & @CRLF & $path & $EXEext)
   Next
   $path = $path0
   For $i = 321 to 340
      $path = $path & '\*'
      If RegRead($RegGUID & $i & '}', 'SaferFlags') = '0' Then
	$m = $m + 1
      EndIf
      If RegRead($RegGUID & $i & '}', 'ItemData') = $path & $TMPext Then
	$m = $m + 1
      EndIf
;     MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $TMPext)
   Next
   $path = $path0
   For $i = 341 to 360
      $path = $path & '\*'
      If RegRead($RegGUID & $i & '}', 'SaferFlags') = '0' Then $n = $n+1
      If RegRead($RegGUID & $i & '}', 'ItemData') = $path & $MSIext Then $n = $n+1
;     MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $MSIext)
   Next
   $path = $path1
   For $i = 361 to 380
      $path = $path & '\*'
      If RegRead($RegGUID & $i & '}', 'SaferFlags') = '0' Then
	$m = $m + 1
      EndIf
      If RegRead($RegGUID & $i & '}', 'ItemData') = $path & $EXEext Then
	$m = $m + 1
      EndIf
;     MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $EXEext)
   Next
   $path = $path1
   For $i = 381 to 400
      $path = $path & '\*'
      If RegRead($RegGUID & $i & '}', 'SaferFlags') = '0' Then
	$m = $m + 1
      EndIf
      If RegRead($RegGUID & $i & '}', 'ItemData') = $path & $TMPext Then
	$m = $m + 1
      EndIf
;     MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $TMPext)
   Next
   $path = $path1
   For $i = 401 to 420
      $path = $path & '\*'
      If RegRead($RegGUID & $i & '}', 'SaferFlags') = '0' Then $n = $n+1
      If RegRead($RegGUID & $i & '}', 'ItemData') = $path & $MSIext Then $n = $n+1
;     MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $MSIext)
   Next
;   MsgBox(0,"",$m & @crlf & $n)
; Return 1 ----> '\*.exe', '\*.tmp', and '\*.msi' paths restricted
; Return 3 ----> only '\*.msi' paths restricted
; Return 0 = no restrictions
; Return 2 wrong settings
   If $m + $n = 240 Then Return 1
   If ($m = 0 and $n = 80) Then Return 3
   If ($m = 120 and $n = 60) Then Return 4
   If ($m = 0 and $n = 60) Then Return 5
   If $m + $n = 0 Then Return 0
   Return 2
EndIf

EndFunc


Func AddEXE2ModRiskFileTypes()
Local $RegKey = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies'
RegWrite($RegKey & '\Attachments', 'SaveZoneInformation', 'REG_DWORD', Number('2'))
If (IsSRP_DefaultDeny() = 1 And (@OSVersion="WIN_7" Or @OSVersion="WIN_VISTA")) Then
   RegWrite($RegKey & '\Associations', 'DefaultFileTypeRisk', 'REG_DWORD', Number('6151'))
   RegWrite($RegKey & '\Associations', 'ModRiskFileTypes', 'REG_SZ', '.exe')
;   MsgBox(0,"","")
EndIf
EndFunc


Func RemoveEXE2ModRiskFileTypes()
Local $RegKey = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies'
If (@OSVersion="WIN_7" Or @OSVersion="WIN_VISTA") Then
   RegDelete($RegKey & '\Associations', 'DefaultFileTypeRisk')
   RegDelete($RegKey & '\Associations', 'ModRiskFileTypes')
EndIf
EndFunc


Func IsSRP_DefaultDeny()
If ($isSRPinstalled = "Installed" And ($SRPDefaultLevel = "White List" or $SRPDefaultLevel = "Basic User")) Then
   Return 1
Else
   Return 0
EndIf
EndFunc



Func LowerExeRestrictionsHelp()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\LowerExeRestrictionsHelp.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
      Local $x = _ExtMsgBox(0,"&CLOSE|NEXT", "Update Mode Help 1/2", $help)
   If $x = 1 Then Return
   If $x = 2 Then LowerExeRestrictionsHelp_1()
EndFunc

Func LowerExeRestrictionsHelp_1()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\LowerExeRestrictionsHelp_1.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
   Local $x = _ExtMsgBox(0,"&CLOSE|BACK", "Update Mode Help 2/2", $help)
   If $x = 1 Then Return
   If $x = 2 Then LowerExeRestrictionsHelp()
EndFunc


Func HardenArchivers1()
Local   $restrictions =  CheckRestrictArchivers()
; Return 1 ----> '\*.exe', '\*.tmp', and '\*.msi' paths restricted
; Return 3 ----> only '\*.msi' paths restricted
; Return 0 = no restrictions
; Return 2 wrong settings
; Return 4 ----> old H_C version 5.0.0.1 ---> '\*.exe', '\*.tmp', and '\*.msi' paths restricted
; Return 5 ----> old H_C version 5.0.0.1 --->  only '\*.msi' paths restricted

Switch $restrictions
;  No lowering restrictions    ---> only '\*.msi'
   case 0
	RestrictArchivers(1)
	$HardenArchivers = 'MSI'
;  only '\*.msi'    ---> '\*.exe', '\*.tmp', and '\*.msi'
   case 3
	RestrictArchivers(0)
	$HardenArchivers = 'ON'
;  '\*.exe', '\*.tmp', and '\*.msi' -----> no lowering restrictions
   case 1
	RemoveArchiversRestrictions()
	$HardenArchivers = 'OFF'
   case Else
	MsgBox(0,"", "Wrong setting detected. The <Update Mode will be set to OFF>")
	RemoveArchiversRestrictions()
	$HardenArchivers = 'OFF'
EndSwitch
;RefreshChangesCheck("RestrictArchivers")
$RefreshChangesCheck = $RefreshChangesCheck & "RestrictArchivers" & $HardenArchivers & @LF
RefreshMoreSRPRestrictionsGUI()
EndFunc


Func HardenEmailClients1()
  HardenEmailClients("0")
;  RefreshChangesCheck("HardenEmailClients")
$RefreshChangesCheck = $RefreshChangesCheck & "HardenEmailClients" & $HardenEmailClients & @LF
EndFunc


Func HardenArchivers($flag)
;MsgBox(0,"", CheckRestrictArchivers() & @crlf & $HardenArchivers )
If not (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
   _ExtMsgBox(0,"OK", "Harden Archivers", "This Windows version is not supported.")
   Return
EndIf

If $isSRPinstalled = "Installed" Then
   Switch $HardenArchivers
      case "OFF"
	RestrictArchivers(1)
	$HardenArchivers = "MSI"
      case "MSI"
	RestrictArchivers(0)
	$HardenArchivers = 'ON'
      case "ON"
	RemoveArchiversRestrictions()
	$HardenArchivers = 'OFF'
      case Else
	MsgBox(0,"", "Wrong setting detected. The <Update Mode will be set to OFF>")
	RemoveArchiversRestrictions()
	$HardenArchivers = 'OFF'
   EndSwitch
Else
   MsgBox(262144,"Harden Archivers","This option needs SRP to be installed, with Enforcement set to 'Skip DLLs' or 'All Files'.")
EndIf

;ShowRegistryTweaks()
If not ($flag = '1') Then
   RefreshMoreSRPRestrictionsGUI()
EndIf

EndFunc


;*************
Func HardenEmailClients($flag)
;MsgBox(0,"", CheckRestrictEmailClients() & @crlf & $HardenEmailClients )
If not (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
   _ExtMsgBox(0,"OK", "Harden Email Clients", "This Windows version is not supported.")
   Return
EndIf

;  Switch to 'OFF'
If $HardenEmailClients = "ON" Then
;  Remove the restrictions for execution of EXE, TMP, MSI files directly from Email Clients by blocking temporary folders characteristic to supported Email Client applications (see the BlockEmailClients.au3)
   RemoveEmailClientsRestrictions()
   $HardenEmailClients = "OFF"
Else
   If $isSRPinstalled = "Installed" Then
;  Switch to 'ON'
;   Blocks execution of EXE, TMP, MSI files directly from Email Clients by blocking temporary folders characteristic to supported Email Client applications (see the BlockEmailClients.au3)
           RestrictEmailClients()
;	   MsgBox(0,"", CheckRestrictEmailClients())
	   $HardenEmailClients = "ON"
   Else
           MsgBox(262144,"Harden Email Clients","This option needs SRP to be installed, with Enforcement set to 'Skip DLLs' or 'All Files'.")
   EndIf
EndIf

;ShowRegistryTweaks()
If not ($flag = '1') Then
   RefreshMoreSRPRestrictionsGUI()
EndIf

EndFunc
;*************

;Func HelpM()
;   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpM.txt")
;;   MsgBox(0,"", $help)
;   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
;  _ExtMsgBox(0,"OK", "", $help)
;EndFunc

