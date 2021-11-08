#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Icon=C:\Windows\Hard_Configurator\Icons\ConfigureDefender.ico
#AutoIt3Wrapper_Res_Comment=Utility for configuring Defender antivirus on Windows 10
#AutoIt3Wrapper_Res_Description=Utility for configuring Defender antivirus on Windows 10
#AutoIt3Wrapper_Res_Fileversion=2.1.1.1
#AutoIt3Wrapper_Res_LegalCopyright=""
#AutoIt3Wrapper_Res_Field=|Configure Defender
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GuiScrollBars.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
;#Include <Array.au3>
#include <ColorConstants.au3>
#include <constants.au3>
#include <Date.au3>
;#include <EditConstants.au3>
#Include <File.au3>
#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
;#include <GuiEdit.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIProc.au3>
#include <GuiScrollBars.au3>
#include <String.au3>
#include <GuiMenu.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

;#include <Misc.au3>
#include <WindowsConstants.au3>
#include 'ASRExclusions.au3'
#include 'PathsFromKey2Array.au3'
#include 'CFA_Folders.au3'
#include 'CFAExclusions.au3'
#include 'ExtMsgBox.au3'
#include 'DefenderEvents.au3'

Global $DefenderGUI
Global $MainDefenderGUI
Global $idComboBoxDisableRealtimeMonitoring
Global $idComboBoxNetworkProtection
Global $idComboBoxControlledFolderAccess
Global $idComboBoxDisableBehaviorMonitoring
Global $idComboBoxDisableBlockAtFirstSeen
Global $idComboBoxMAPSReporting
Global $idComboBoxSubmitSamplesConsent
Global $idComboBoxDisableIOAVProtection
Global $idComboBoxDisableScriptScanning
Global $idComboBoxPUAProtection
Global $idComboBoxMpCloudBlockLevel
Global $idComboBoxMpBafsExtendedTimeout
Global $idComboBoxScanAvgCPULoadFactor
Global $idComboBoxAdminSmartScreenForExplorer
Global $idComboBoxAdminSmartScreenForEdge
Global $idComboBoxAdminSmartScreenForIE
Global $idComboBoxASR1
Global $idComboBoxASR2
Global $idComboBoxASR3
Global $idComboBoxASR4
Global $idComboBoxASR5
Global $idComboBoxASR6
Global $idComboBoxASR7
Global $idComboBoxASR8
Global $idComboBoxASR9
Global $idComboBoxASR10
Global $idComboBoxASR11
Global $idComboBoxASR12
Global $idComboBoxASR13
Global $idComboBoxASR14
Global $idComboBoxASR15
Global $idComboBoxHideSecurityCenter
Global $MpenginePolicyKey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine'
Global $cloudlevelKey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine'
Global $SmartScreenForExplorerKey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\System'
Global $SmartScreenForEdgeKey = 'HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter'
Global $SmartScreenForIEKey = 'HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter'
Global $ASRKey = 'HKLM\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
Global $ASRKeyPolicy = 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
Global $ASRKeyExclusions = 'HKLM\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\ASROnlyExclusions'
Global $ASRKeyPolicyExclusions = 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\ASROnlyExclusions'
Global $ConfigureDefender_temp_key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\Defender\TEMP'
Global $ASRExclusionslistview
Global $ASRExclusionslistGUI 
Global $CFAExclusionslistview
Global $CFAExclusionslistGUI 
Global $HideSecurityCenter


;11111

Global $BtnDefaultDefenderSettings
Global $BtnDefenderHighSettings
Global $BtnHelpDefenderSettings
Global $BtnManageASRExclusions
Global $BtnManageCFAExclusions
Global $BtnASRExclusionsAdd
Global $BtnASRExclusionsRemove

Global $PowerShellDir = 'c:\Windows\System32\WindowsPowerShell\v1.0\'
Local $tempKey = $ConfigureDefender_temp_key
Local $ActualSetting

;****************************************

If Not (@OSVersion="WIN_10") Then
   MsgBox(262144,"","This program works only on Windows 10.")
   Exit
EndIf

If (@ScriptName = 'ConfigureDefender_x64.exe' And @OSArch = "X86") Then
   MsgBox(262144,"","This file works only on 64-bit Windows version.")
   Exit
EndIf

If (@ScriptName = 'ConfigureDefender_x86.exe' And @OSArch = "X64") Then
   MsgBox(262144,"","This file works only on 32-bit Windows version.")
   Exit
EndIf



;   Create a GUI with various controls.


     $MainDefenderGUI = GUICreate("Defender settings", 525, 550)
     GUISetOnEvent($GUI_EVENT_CLOSE, "CloseDefender")
     GUISetBkColor(0xf4f4ff)
;0xf0f0f5
;0xf0f0ff

; Refresh
    $BtnRefresh = GUICtrlCreateButton("REFRESH", 410, 490, 80, 40,-1,1)
    GUICtrlSetFont ( $BtnRefresh, 10, 700)
    GUICtrlSetBkColor(-1,0x00F000)
    GUICtrlSetOnEvent($BtnRefresh, "RefreshDefenderGUIWindow")

;   Close Button
    $BtnCloseDefender = GUICtrlCreateButton("Close", 205, 495, 85, 30,-1,1)
    GUICtrlSetFont ( $BtnCloseDefender, 10)
    GUICtrlSetOnEvent($BtnCloseDefender, "CloseDefender")
    GUICtrlSetBkColor(-1,0xeaeaea)
  
  CheckBoxDefender()

Func CheckBoxDefender()
Local $dx=110
LocaL $dy=320
Local $dz=60
local $dp=100
local $dq=100
local $dr=110
$DefenderGUI = GUICreate("Child GUI", 510, 460, 10, 10, $WS_CHILD, $WS_EX_CLIENTEDGE, $MainDefenderGUI)
;Opt("GUIOnEventMode", 1)
GUISetBkColor(0xeaeaf5)
;0xeaeaf0
;0xeaeaf5


GUIRegisterMsg($WM_VSCROLL, "WM_VSCROLL")

; Info about Defender
    $BtnInfoAboutDefender = GUICtrlCreateButton("Info about Defender", 20, 10, 170, 30,-1,1)
    GUICtrlSetFont ( $BtnInfoAboutDefender, 10)
    GUICtrlSetBkColor(-1,0xeaeaea)
    GUICtrlSetOnEvent($BtnInfoAboutDefender, "InfoAboutDefender")

; Defender Security Log
    $BtnDefenderSecurityLog = GUICtrlCreateButton("Defender Security Log", 210, 10, 170, 30,-1,1)
    GUICtrlSetFont ( $BtnDefenderSecurityLog, 10)
    GUICtrlSetBkColor(-1,0xeaeaea)
    GUICtrlSetOnEvent($BtnDefenderSecurityLog, "DefenderSecurityLog")

; Help
    $BtnHelpDefenderSettings = GUICtrlCreateButton("HELP", 300+$dp, 10, 80, 30,-1,1)
    GUICtrlSetBkColor(-1,0xeaeaea)
    GUICtrlSetOnEvent($BtnHelpDefenderSettings, "HelpDefenderSettings")

Local $ProtectionLevels = GUICtrlCreateLabel ("PROTECTION  LEVELS", 20, $dx-40, 230, 16,$SS_LEFT,-1)
GUICtrlSetFont ($ProtectionLevels, 10, 600)

; Default Defender settings
    $BtnDefaultDefenderSettings = GUICtrlCreateButton("DEFAULT", 20, $dx-10+5, 80, 30,-1,1)
    GUICtrlSetFont ( $BtnDefaultDefenderSettings, 10, 700)
    GUICtrlSetBkColor($BtnDefaultDefenderSettings,0x00F000)
    GUICtrlSetOnEvent($BtnDefaultDefenderSettings, "DefaultDefender")


; Defender High Settings
    $BtnDefenderHighSettings = GUICtrlCreateButton("HIGH", 110, $dx-10+5, 80, 30,-1,1)
    GUICtrlSetFont ( $BtnDefenderHighSettings, 10, 700)
    GUICtrlSetBkColor($BtnDefenderHighSettings,0x00F000)
    GUICtrlSetOnEvent($BtnDefenderHighSettings, "DefenderHighSettings")

; Child Protection
    $BtnDefenderChildProtection = GUICtrlCreateButton("MAX",200, $dx-10+5, 80, 30,-1,1)
    GUICtrlSetFont ($BtnDefenderChildProtection, 10, 700)
    GUICtrlSetBkColor($BtnDefenderChildProtection,0xff4040)
    GUICtrlSetOnEvent($BtnDefenderChildProtection, "DefenderChildProtection")

    _GUIScrollBars_Init ($DefenderGUI, 100, 100)
    _GUIScrollBars_EnableScrollBar($DefenderGUI, $SB_HORZ, $ESB_DISABLE_LEFT)
    _GUIScrollBars_EnableScrollBar($DefenderGUI, $SB_HORZ, $ESB_DISABLE_RIGHT)


;Saves the value of EnableNetworkProtection setting in temp registry key as DWORD
Local $sMessage = "Initializing ConfigureDefender. Please wait."
SplashTextOn("Warning", $sMessage, 300, 40, -1, -1, 1, "", 10)
RegWrite($tempKey)
RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden $Preferences=Get-MpPreference;$path='HKLM:\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\Defender\TEMP'; New-ItemProperty -Path $path -Name 'PreferencesTest' -Value $Preferences.DisableRealtimeMonitoring -PropertyType String -Force | Out-Null; function SetRegistryKey ([string]$name){$svalue=$Preferences.$name;New-ItemProperty -Path $path -Name $name -Value $svalue -PropertyType DWORD -Force | Out-Null}; SetRegistryKey('EnableNetworkProtection'); SetRegistryKey( 'EnableControlledFolderAccess');SetRegistryKey('DisableRealtimeMonitoring'); SetRegistryKey('DisableBehaviorMonitoring'); SetRegistryKey('DisableBlockAtFirstSeen'); SetRegistryKey('MAPSReporting');SetRegistryKey('SubmitSamplesConsent');SetRegistryKey('DisableIOAVProtection'); SetRegistryKey('DisableScriptScanning'); SetRegistryKey('PUAProtection'); SetRegistryKey('ScanAvgCPULoadFactor'); ", "", @SW_HIDE, $STDOUT_CHILD)
SplashOff()
;22222


;************************
;Test if PowerShell cmdlet MpPreference works. If not then exit.
Local $isOK = RegRead($tempKey,'PreferencesTest')
;MsgBox(0,"",$isOK)
If not ($isOK = 'True' or $isOK = 'False') Then
;   MsgBox(262144,"","PowerShell error. ConfigureDefender cannot gather information about Windows Defender.")
   _ExtMsgBoxSet(1+4+8+32, 0, 0xdddddd, 0xff0000, 10, "Arial", @DesktopWidth*0.3)
   _ExtMsgBox(16,"&CLOSE", "ConfigureDefender", "Error. PowerShell cannot gather information about Windows Defender. Possibly, another security application restricts PowerShell.")
   Exit
EndIf

OptimizeASRExclusions()

;   Create a label
    Local $BASICDEFENDERSETTINGS = GUICtrlCreateLabel ("BASIC  DEFENDER  SETTINGS", 20, 65+$dx, 250, 16,$SS_LEFT,-1)
    GUICtrlSetFont ( $BASICDEFENDERSETTINGS, 10, 600)

;;   Create a combobox control.
;    Local $LabelRealtimeMonitoring = GUICtrlCreateLabel ("Real-time Monitoring", 20, 75+$dx, 250, 16, $SS_LEFT)
;    GUICtrlSetFont ( $LabelRealtimeMonitoring, 10)
;    $idComboBoxDisableRealtimeMonitoring = GUICtrlCreateCombo("ON", 300+$dp, 75+$dx, 80, 20)
;    GUICtrlSetBkColor(-1,0xf8f8f8)
;    Switch RegRead($tempKey, 'DisableRealtimeMonitoring')
;	case 0       
;	   $ActualSetting = "ON"       
;	case 1
;	   $ActualSetting = "Disabled"
;	case Else
 ; 	   RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -DisableRealtimeMonitoring 0", "", @SW_HIDE)
;	   $ActualSetting = "ON"
;	   MsgBox(262144,"","Wrong 'Real-time Monitoring' Defender setting. The value was corrected and set to Windows default.")
;   EndSwitch    
;    GUICtrlSetData($idComboBoxDisableRealtimeMonitoring, "Disabled", $ActualSetting)
;;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelBehaviorMonitoring=GUICtrlCreateLabel ("Behavior Monitoring", 20, 100+$dx, 250, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelBehaviorMonitoring, 10)
    $idComboBoxDisableBehaviorMonitoring = GUICtrlCreateCombo("ON", 300+$dp, 100+$dx, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Switch RegRead($tempKey, 'DisableBehaviorMonitoring')
	case 0       
	   $ActualSetting = "ON"       
	case 1
	   $ActualSetting = "Disabled"
	case Else
  	   RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -DisableBehaviorMonitoring 0", "", @SW_HIDE)
	   $ActualSetting = "ON"
	   MsgBox(262144,"","Wrong 'Behavior Monitoring' Defender setting. The value was corrected and set to Windows default.")
    EndSwitch    
    GUICtrlSetData($idComboBoxDisableBehaviorMonitoring, "Disabled", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelBlockAtFirstSeen=GUICtrlCreateLabel ("Block At First Sight", 20, 125+$dx, 250, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelBlockAtFirstSeen, 10)
    $idComboBoxDisableBlockAtFirstSeen = GUICtrlCreateCombo("ON", 300+$dp, 125+$dx, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Switch RegRead($tempKey, 'DisableBlockAtFirstSeen')
	case 0       
	   $ActualSetting = "ON"       
	case 1
	   $ActualSetting = "Disabled"
	case Else
  	   RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -DisableBlockAtFirstSeen 0", "", @SW_HIDE)
	   $ActualSetting = "ON"
	   MsgBox(262144,"","Wrong 'Block At FirstSeen' Defender setting. The value was corrected and set to Windows default.")
    EndSwitch    
    GUICtrlSetData($idComboBoxDisableBlockAtFirstSeen, "Disabled", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelReportinglevel=GUICtrlCreateLabel ("Cloud-delivered Protection", 20, 150+$dx, 250, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelReportinglevel, 10)
    $idComboBoxMAPSReporting = GUICtrlCreateCombo("ON", 300+$dp, 150+$dx, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Switch RegRead($tempKey, 'MAPSReporting')
	case 0       
	   $ActualSetting = "Disabled"       
	case 2
	   $ActualSetting = "ON"
	case Else
  	   RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -MAPSReporting 2", "", @SW_HIDE)
	   $ActualSetting = "ON"
	   MsgBox(262144,"","Wrong 'Cloud-delivered Protection' Defender setting. The value was corrected and set to Windows default.")
    EndSwitch    
    GUICtrlSetData($idComboBoxMAPSReporting, "Disabled", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelAutomaticSampleSubmission=GUICtrlCreateLabel ("Automatic Sample Submission", 20, 175+$dx, 250, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelAutomaticSampleSubmission, 10)
    $idComboBoxSubmitSamplesConsent = GUICtrlCreateCombo("Send", 300+$dp, 175+$dx, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Switch RegRead($tempKey, 'SubmitSamplesConsent')
	case 0       
	   $ActualSetting = "Prompt"
	case 1       
	   $ActualSetting = "Send"  
	case 2
	   $ActualSetting = "Disabled"
	case Else
  	   RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -SubmitSamplesConsent 1", "", @SW_HIDE)
	   $ActualSetting = "Send"
	   MsgBox(262144,"","Wrong 'Automatic Sample Submission' Defender setting. The value was corrected and set to Windows default.")
    EndSwitch    
    GUICtrlSetData($idComboBoxSubmitSamplesConsent, "Prompt|Disabled", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelScanAll=GUICtrlCreateLabel ("Scan all downloaded files and attachments", 20, 200+$dx, 250, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelScanAll, 10)
    $idComboBoxDisableIOAVProtection = GUICtrlCreateCombo("ON", 300+$dp, 200+$dx, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Switch RegRead($tempKey, 'DisableIOAVProtection')
	case 0       
	   $ActualSetting = "ON"       
	case 1
	   $ActualSetting = "Disabled"
	case Else
  	   RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -DisableIOAVProtection 0", "", @SW_HIDE)
	   $ActualSetting = "ON"
	   MsgBox(262144,"","Wrong 'Scan all downloaded files and attachments' Defender setting. The value was corrected and set to Windows default.")
    EndSwitch    
    GUICtrlSetData($idComboBoxDisableIOAVProtection, "Disabled", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelScriptScanning = GUICtrlCreateLabel ("Script Scanning", 20, 225+$dx, 250, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelScriptScanning, 10)
    $idComboBoxDisableScriptScanning = GUICtrlCreateCombo("ON", 300+$dp, 225+$dx, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Switch RegRead($tempKey, 'DisableScriptScanning')
	case 0       
	   $ActualSetting = "ON"       
	case 1
	   $ActualSetting = "Disabled"
	case Else
  	   RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -DisableScriptScanning 0", "", @SW_HIDE)
	   $ActualSetting = "ON"
	   MsgBox(262144,"","Wrong 'Script Scanning' Defender setting. The value was corrected and set to Windows default.")
    EndSwitch    
    GUICtrlSetData($idComboBoxDisableScriptScanning, "Disabled", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelPUAProtection = GUICtrlCreateLabel ("PUA Protection", 20, 250+$dx, 250, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelPUAProtection, 10)
    $idComboBoxPUAProtection = GUICtrlCreateCombo("ON", 300+$dp, 250+$dx, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Switch RegRead($tempKey, 'PUAProtection')
	case 0       
	   $ActualSetting = "Disabled"       
	case 1
	   $ActualSetting = "ON"
	case 2
	   $ActualSetting = "Audit"
	case Else
  	   RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -PUAProtection 0", "", @SW_HIDE)
	   $ActualSetting = "Disabled"
	   MsgBox(262144,"","Wrong 'PUA Protection' Defender setting. The value was corrected and set to Windows default.")
    EndSwitch    
    GUICtrlSetData($idComboBoxPUAProtection, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelCloudProtectionLevel=GUICtrlCreateLabel ("Cloud Protection Level", 20, 275+$dx, 250, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelCloudProtectionLevel, 10)
    $idComboBoxMpCloudBlockLevel = GUICtrlCreateCombo("Default", 300+$dp, 275+$dx, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Switch RegRead($cloudlevelKey, 'MpCloudBlockLevel')
	case 0       
	   $ActualSetting = "Default"       
	case 2
	   $ActualSetting = "High"
	case 4
	   $ActualSetting = "Highest"
	case 6
	   $ActualSetting = "Block"
        case Else
	   RegWrite($cloudlevelKey, 'MpCloudBlockLevel', 'REG_DWORD', Number('0'))
	   $ActualSetting = "Default"    
	   MsgBox(262144,"","Wrong 'Cloud Protection Level' Defender setting. The value was corrected and set to Windows default.")  
    EndSwitch
    GUICtrlSetData($idComboBoxMpCloudBlockLevel, "High|Highest|Block", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelCloudchecktimelimit=GUICtrlCreateLabel ("Cloud Check Time Limit", 20, 300+$dx, 250, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelCloudchecktimelimit, 10)
    $idComboBoxMpBafsExtendedTimeout = GUICtrlCreateCombo("10s", 300+$dp, 300+$dx, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Switch RegRead($cloudlevelKey, 'MpBafsExtendedTimeout')
	case 0       
	   $ActualSetting = "10s"       
	case Number('10')
	   $ActualSetting = "20s"
	case Number('20')
	   $ActualSetting = "30s"
	case Number('30')
	   $ActualSetting = "40s"
	case Number('40')
	   $ActualSetting = "50s"
	case Number('50')
	   $ActualSetting = "60s"
        case Else
	   RegWrite($cloudlevelKey, 'MpBafsExtendedTimeout', 'REG_DWORD', Number('0'))
	   $ActualSetting = "10s"
	   MsgBox(262144,"", "Wrong 'Cloud check time limit' Defender setting. The value was corrected and set to Windows default.")        
    EndSwitch    
    GUICtrlSetData($idComboBoxMpBafsExtendedTimeout, "20s|30s|40s|50s|60s", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelAverageCPUload=GUICtrlCreateLabel ("Average CPU Load while scanning", 20, 325+$dx, 250, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelAverageCPUload, 10)
    $idComboBoxScanAvgCPULoadFactor = GUICtrlCreateCombo("10%", 300+$dp, 325+$dx, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Switch RegRead($tempKey, 'ScanAvgCPULoadFactor')
	case Number('10')       
	   $ActualSetting = "10%"       
	case Number('20')
	   $ActualSetting = "20%"
	case Number('30')
	   $ActualSetting = "30%"
	case Number('40')
	   $ActualSetting = "40%"
	case Number('50')
	   $ActualSetting = "50%"
	case Number('60')
	   $ActualSetting = "60%"
	case Number('70')
	   $ActualSetting = "70%"
	case Number('80')
	   $ActualSetting = "80%"
        case Else
	RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -ScanAvgCPULoadFactor 50", "", @SW_HIDE)
	   $ActualSetting = "50%"
	   RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan','AvgCPULoadFactor')
	   MsgBox(262144,"", "Wrong 'Average CPU load while scanning' Defender setting. The value was corrected and set to Windows default.") 
    EndSwitch    
    GUICtrlSetData($idComboBoxScanAvgCPULoadFactor, "20%|30%|40%|50%|60%|70%|80%", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a label
    Local $ADMINSMARTSCREEN=GUICtrlCreateLabel ("ADMIN:  SMARTSCREEN", 20, 55+$dx+$dy, 240, 16,$SS_LEFT,-1)
    GUICtrlSetFont ($ADMINSMARTSCREEN, 10, 600)
    GUICtrlCreateLabel ("When set to 'User', it can be configured and bypassed by the User.", 20, 75+$dx+$dy, 350, 16,$SS_LEFT,-1)
;   Create a combobox control.
    Local $LabelForExplorer=GUICtrlCreateLabel ("For Explorer", 20, 100+$dx+$dy, 350, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelForExplorer, 10)
    $idComboBoxAdminSmartScreenForExplorer = GUICtrlCreateCombo("Warn", 300+$dp, 100+$dx+$dy, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $SmartScreenValue = RegRead($SmartScreenForExplorerKey, 'EnableSmartScreen')
    If not @error Then 
       Switch $SmartScreenValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
	      If RegRead($SmartScreenForExplorerKey, 'ShellSmartScreenLevel') = "Block" Then $ActualSetting = "Block"
              If RegRead($SmartScreenForExplorerKey, 'ShellSmartScreenLevel') = "Warn" Then $ActualSetting = "Warn"
	      If not (RegRead($SmartScreenForExplorerKey, 'ShellSmartScreenLevel') = "Block" OR RegRead($SmartScreenForExplorerKey, 'ShellSmartScreenLevel') = "Warn") Then
	         RegWrite($SmartScreenForExplorerKey, 'ShellSmartScreenLevel', "REG_SZ", "Warn")
                 $ActualSetting = "Warn"
   	         MsgBox(262144,"", "Wrong Admin SmartScreen setting. The value was corrected and set to 'Warn'.") 
	      EndIf
           case Else
	      RegDelete($SmartScreenForExplorerKey, 'EnableSmartScreen')
	      RegDelete($SmartScreenForExplorerKey, 'ShellSmartScreenLevel')
	      $ActualSetting = "User"
              MsgBox(262144,"", "Wrong SmartScreen setting. The value was corrected and set to Windows default.") 
       EndSwitch
    Else
       RegDelete($SmartScreenForExplorerKey, 'EnableSmartScreen')
       RegDelete($SmartScreenForExplorerKey, 'ShellSmartScreenLevel')
       $ActualSetting = "User"
    EndIf
    GUICtrlSetData($idComboBoxAdminSmartScreenForExplorer, "Block|Disabled|User", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelForEdge=GUICtrlCreateLabel ("For Edge", 20, 125+$dx+$dy, 350, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelForEdge, 10)
    $idComboBoxAdminSmartScreenForEdge = GUICtrlCreateCombo("Warn", 300+$dp, 125+$dx+$dy, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $SmartScreenValue = RegRead($SmartScreenForEdgeKey, 'EnabledV9')
    If not @error Then 
       Switch $SmartScreenValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
	      If RegRead($SmartScreenForEdgeKey, 'PreventOverride') = 1 Then $ActualSetting = "Block"
              If RegRead($SmartScreenForEdgeKey, 'PreventOverride') = 0 Then $ActualSetting = "Warn"
	      If not (RegRead($SmartScreenForEdgeKey, 'PreventOverride') = 1 OR RegRead($SmartScreenForEdgeKey, 'PreventOverride') = 0) Then
	         RegWrite($SmartScreenForEdgeKey, 'PreventOverride', "REG_DWORD", Number('0'))
                 $ActualSetting = "Warn"
   	         MsgBox(262144,"", "Wrong Admin SmartScreen setting. The value was corrected and set to 'Warn'.") 
	      EndIf
           case Else
	      RegDelete($SmartScreenForEdgeKey, 'EnabledV9')
	      RegDelete($SmartScreenForEdgeKey, 'PreventOverride')
	      $ActualSetting = "User"
              MsgBox(262144,"", "Wrong SmartScreen setting. The value was corrected and set to Windows default.") 
       EndSwitch
    Else
       RegDelete($SmartScreenForEdgeKey, 'EnabledV9')
       RegDelete($SmartScreenForEdgeKey, 'PreventOverride')
       $ActualSetting = "User"
    EndIf
    GUICtrlSetData($idComboBoxAdminSmartScreenForEdge, "Block|Disabled|User", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelForIE=GUICtrlCreateLabel ("For Internet Explorer", 20, 150+$dx+$dy, 350, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelForIE, 10)
    $idComboBoxAdminSmartScreenForIE = GUICtrlCreateCombo("Warn", 300+$dp, 150+$dx+$dy, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $SmartScreenValue = RegRead($SmartScreenForIEKey, 'EnabledV9')
    If not @error Then 
       Switch $SmartScreenValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
	      If RegRead($SmartScreenForIEKey, 'PreventOverride') = 1 Then $ActualSetting = "Block"
              If RegRead($SmartScreenForIEKey, 'PreventOverride') = 0 Then $ActualSetting = "Warn"
	      If not (RegRead($SmartScreenForIEKey, 'PreventOverride') = 1 OR RegRead($SmartScreenForIEKey, 'PreventOverride') = 0) Then
	         RegWrite($SmartScreenForIEKey, 'PreventOverride', "REG_DWORD", Number('0'))
                 $ActualSetting = "Warn"
   	         MsgBox(262144,"", "Wrong Admin SmartScreen setting. The value was corrected and set to 'Warn'.") 
	      EndIf
           case Else
	      RegDelete($SmartScreenForIEKey, 'EnabledV9')
	      RegDelete($SmartScreenForIEKey, 'PreventOverride')
	      $ActualSetting = "User"
              MsgBox(262144,"", "Wrong SmartScreen setting. The value was corrected and set to Windows default.") 
       EndSwitch
    Else
       RegDelete($SmartScreenForIEKey, 'EnabledV9')
       RegDelete($SmartScreenForIEKey, 'PreventOverride')
       $ActualSetting = "User"
    EndIf
    GUICtrlSetData($idComboBoxAdminSmartScreenForIE, "Block|Disabled|User", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a label
    GUICtrlCreateLabel ("EXPLOIT  GUARD", 20, 140+$dx+$dy+$dz, 270, 16,$SS_LEFT,-1)
    GUICtrlSetFont (-1, 10, 600)

;   Create a label
    Local $breakline = "-----------------------------------------"
    Local $LabeBreak1=GUICtrlCreateLabel ($breakline & $breakline & $breakline & $breakline, 20, 160+$dx+$dy+$dz, 435, 16,$SS_LEFT,-1)
    GUICtrlSetFont (-1, 10, 600)


; ASR Exclusions
    Local $LabelASRExclusions=GUICtrlCreateLabel ("ASR  EXCLUSIONS:", 20, 192+$dx+$dy+$dz, 25+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASRExclusions, 10)
 
   $BtnManageASRExclusions = GUICtrlCreateButton("Manage ASR Exclusions", 145, 185+$dx+$dy+$dz, 160, 30,-1,1)
   GUICtrlSetFont ( $BtnManageASRExclusions,10, 500)
   GUICtrlSetBkColor(-1,0xeaeaea)
   GUICtrlSetOnEvent($BtnManageASRExclusions, "ManageASRExclusions")

;   Create a combobox control.
    Local $LabelASR1=GUICtrlCreateLabel ("Block executable content from email client and webmail", 20, 225+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR1, 10)
    $idComboBoxASR1 = GUICtrlCreateCombo("ON", 300+$dp, 225+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR1, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelASR2=GUICtrlCreateLabel ("Block Office applications from creating child processes", 20, 250+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR2, 10)
    $idComboBoxASR2 = GUICtrlCreateCombo("ON", 300+$dp, 250+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "D4F940AB-401B-4EFC-AADC-AD5F3C50688A"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR2, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelASR3=GUICtrlCreateLabel ("Block Office applications from creating executable content", 20, 275+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR3, 10)
    $idComboBoxASR3 = GUICtrlCreateCombo("ON", 300+$dp, 275+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "3B576869-A4EC-4529-8536-B80A7769E899"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR3, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelASR4=GUICtrlCreateLabel ("Block Office applications from injecting into other processes", 20, 300+$dx+$dy+$dz, 260+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR4, 10)
    $idComboBoxASR4 = GUICtrlCreateCombo("ON", 300+$dp, 300+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else        
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR4, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelASR5=GUICtrlCreateLabel ("**** Impede JavaScript and VBScript to launch executables", 20, 325+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR5, 10)
    $idComboBoxASR5 = GUICtrlCreateCombo("ON", 300+$dp, 325+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "D3E037E1-3EB8-44C8-A917-57927947596D"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR5, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelASR6=GUICtrlCreateLabel ("Block execution of potentially obfuscated scripts", 20, 350+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR6, 10)
    $idComboBoxASR6 = GUICtrlCreateCombo("ON", 300+$dp, 350+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "5BEB7EFE-FD9A-4556-801D-275E5FFC04CC"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR6, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
        Local $LabelASR7=GUICtrlCreateLabel ("Block Win32 imports from Macro code in Office", 20, 375+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR7, 10)
    $idComboBoxASR7 = GUICtrlCreateCombo("ON", 300+$dp, 375+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR7, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)


;   Create a combobox control.
        Local $LabelASR81=GUICtrlCreateLabel ("Block executable files from running unless they meet", 20, 400+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR81, 10)
        Local $LabelASR82=GUICtrlCreateLabel ("a prevalence, age, or trusted list criteria", 20, 416+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR82, 10)
    $idComboBoxASR8 = GUICtrlCreateCombo("ON", 300+$dp, 405+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "01443614-cd74-433a-b99e-2ecdc07bfc25"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR8, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)


;   Create a combobox control.
        Local $LabelASR91=GUICtrlCreateLabel ("Block credential stealing from the Windows local security", 20, 440+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR91, 10)
        Local $LabelASR92=GUICtrlCreateLabel ("authority subsystem (lsass.exe)", 20, 456+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR92, 10)
    $idComboBoxASR9 = GUICtrlCreateCombo("ON", 300+$dp, 445+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR9, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
        Local $LabelASR101=GUICtrlCreateLabel ("**** Block process creations originating from PSExec and", 20, 480+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR101, 10)
        Local $LabelASR102=GUICtrlCreateLabel ("WMI commands", 20, 496+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR102, 10)
    $idComboBoxASR10 = GUICtrlCreateCombo("ON", 300+$dp, 485+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "d1e49aac-8f56-4280-b9ba-993a6d77406c"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR10, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
        Local $LabelASR111=GUICtrlCreateLabel ("Block untrusted and unsigned processes that run from USB", 20, 520+$dx+$dy+$dz, 260+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR111, 10)
;        Local $LabelASR112=GUICtrlCreateLabel ("USB", 20, 536+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
;    GUICtrlSetFont ($LabelASR112, 10)
    $idComboBoxASR11 = GUICtrlCreateCombo("ON", 300+$dp, 520+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR11, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)


;   Create a combobox control.
    Local $LabelASR12=GUICtrlCreateLabel ("Use advanced protection against ransomware", 20, -5+550+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR12, 10)
    $idComboBoxASR12 = GUICtrlCreateCombo("ON", 300+$dp, 545+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "c1db55ab-c21a-4637-bb3f-a12568109d35"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR12, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)


;   Create a combobox control.                   
        Local $LabelASR131=GUICtrlCreateLabel ("Block only Office communication applications from", 20, 570+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR131, 10)
        Local $LabelASR132=GUICtrlCreateLabel ("creating child processes", 20, +585+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR132, 10)
    $idComboBoxASR13 = GUICtrlCreateCombo("ON", 300+$dp, 575+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "26190899-1602-49e8-8b27-eb1d0a1ce869"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR13, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)


;   Create a combobox control.
    Local $LabelASR14=GUICtrlCreateLabel ("Block Adobe Reader from creating child processes", 20, 610+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR14, 10)
    $idComboBoxASR14 = GUICtrlCreateCombo("ON", 300+$dp, 610+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR14, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a combobox control.
    Local $LabelASR15=GUICtrlCreateLabel ("**** Block persistence through WMI event subscription", 20, 635+$dx+$dy+$dz, 250+$dq, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelASR15, 10)
    $idComboBoxASR15 = GUICtrlCreateCombo("ON", 300+$dp, 635+$dx+$dy+$dz, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Local $ASRValue = "e6db77e5-3df2-4cf1-b95a-636979351e5b"
    Local $ASRDwordValue = RegRead($ASRKey, $ASRValue)
    Local $ASRDwordValuePolicy = RegRead($ASRKeyPolicy, $ASRValue)
    If not @error Then
       If ($ASRDwordValuePolicy = 0 or $ASRDwordValuePolicy = 1 or $ASRDwordValuePolicy = 2) Then
  	  $ASRDwordValue = $ASRDwordValuePolicy
       Else
	  RegDelete($ASRKeyPolicy, $ASRValue)
       EndIf
    EndIf
       Switch $ASRDwordValue
	   case 0       
	      $ActualSetting = "Disabled"       
	   case 1
              $ActualSetting = "ON"
	   case 2
              $ActualSetting = "Audit"
	   case Else
	      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $ASRValue & " -AttackSurfaceReductionRules_Actions Disabled", "", @SW_HIDE)
	      $ActualSetting = "Disabled"
              MsgBox(262144,"", "Wrong ASR setting. The value was corrected and set to Windows default.") 
       EndSwitch
    GUICtrlSetData($idComboBoxASR15, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

;   Create a label
    GUICtrlCreateLabel ("**** - file / folder exclusions not supported.", 20, 560+$dx+$dy+$dz+$dr, 300, 16,$SS_LEFT,-1)
    GUICtrlSetFont (-1, 10, 600)

;   Create a label
    GUICtrlCreateLabel ($breakline & $breakline & $breakline & $breakline, 20, 590+$dx+$dy+$dz+$dr, 435, 10,$SS_LEFT,-1)
    GUICtrlSetFont (-1, 10, 600)

;   Create a combobox control.
    Local $LabelNetworkProtection=GUICtrlCreateLabel ("Network Protection", 20, 610+$dx+$dy+$dz+$dr, 350, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelNetworkProtection, 10)
    $idComboBoxNetworkProtection = GUICtrlCreateCombo("ON", 300+$dp, 610+$dx+$dy+$dz+$dr, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Switch RegRead($tempKey, 'EnableNetworkProtection')
	case 0       
	   $ActualSetting = "Disabled"       
	case 1
	   $ActualSetting = "ON"
	case 2
	   $ActualSetting = "Audit"
	case Else
  	   RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -EnableNetworkProtection Disabled", "", @SW_HIDE)
	   $ActualSetting = "Disabled"
	   MsgBox(262144,"","Wrong 'Network Protection' Defender setting. The value was corrected and set to Windows default.")
    EndSwitch    
    GUICtrlSetData($idComboBoxNetworkProtection, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)
 
   Local $LabelControlledFolderAccess=GUICtrlCreateLabel ("Controlled Folder Access", 20, 635+$dx+$dy+$dz+$dr, 145, 16, $SS_LEFT)
    GUICtrlSetFont ($LabelControlledFolderAccess, 10)
    $idComboBoxControlledFolderAccess = GUICtrlCreateCombo("ON", 300+$dp, 635+$dx+$dy+$dz+$dr, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    Switch RegRead($tempKey, 'EnableControlledFolderAccess')
	case 0       
	   $ActualSetting = "Disabled"       
	case 1
	   $ActualSetting = "ON"
	case 2
	   $ActualSetting = "Audit"
	case Else
  	   RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -EnableControlledFolderAccess Disabled", "", @SW_HIDE)
	   $ActualSetting = "Disabled"
	   MsgBox(262144,"","Wrong 'Controlled Folder Access' Defender setting. The value was corrected and set to Windows default.")
    EndSwitch
    GUICtrlSetData($idComboBoxControlledFolderAccess, "Disabled|Audit", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)

    $BtnCFA_Folder = GUICtrlCreateButton("Folders", 170, 630+$dx+$dy+$dz+$dr, 80, 30,-1,1)
    GUICtrlSetFont ( $BtnCFA_Folder, 10, 500)
    GUICtrlSetBkColor(-1,0xeaeaea)

    $BtnCFA_Exclusions = GUICtrlCreateButton("Exclusions", 260, 630+$dx+$dy+$dz+$dr, 100, 30,-1,1)
    GUICtrlSetFont ( $BtnCFA_Exclusions, 10, 500)
    GUICtrlSetBkColor(-1,0xeaeaea)

    GUICtrlCreateLabel ($breakline & $breakline & $breakline & $breakline, 20, 660+$dx+$dy+$dz+$dr, 435, 16,$SS_LEFT,-1)
    GUICtrlSetFont (-1, 10, 600)
    Local $LabelHideSecurityCenter=GUICtrlCreateLabel ("ADMIN:  HIDE  SECURITY  CENTER", 20, 695+$dx+$dy+$dz+$dr, 350, 16, $SS_LEFT)
;    GUICtrlSetFont ($LabelHideSecurityCenter, 10)
    GUICtrlSetFont ($LabelHideSecurityCenter, 10, 600)
    $idComboBoxHideSecurityCenter = GUICtrlCreateCombo("Visible", 300+$dp, 695+$dx+$dy+$dz+$dr, 80, 20)
    GUICtrlSetBkColor(-1,0xf8f8f8)
    $HideSecurityCenter = 0
    If RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','DisallowExploitProtectionOverride') = 1 Then $HideSecurityCenter = $HideSecurityCenter + 1
    If RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','UILockdown') = 1 Then $HideSecurityCenter = $HideSecurityCenter + 1
    If RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health','UILockdown') = 1 Then $HideSecurityCenter = $HideSecurityCenter + 1
    If RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options','UILockdown') = 1 Then $HideSecurityCenter = $HideSecurityCenter + 1
    If RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Firewall and network protection','UILockdown') = 1 Then $HideSecurityCenter = $HideSecurityCenter + 1
    If RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection','UILockdown') = 1 Then $HideSecurityCenter = $HideSecurityCenter + 1
    If RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection','UILockdown') = 1 Then $HideSecurityCenter = $HideSecurityCenter + 1
    If RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security','UILockdown') = 1 Then $HideSecurityCenter = $HideSecurityCenter + 1

    Switch $HideSecurityCenter
	case 0       
	   $ActualSetting = "Visible"       
	case 8
	   $ActualSetting = "Hidden"
	case Else
	   $ActualSetting = "??????"
    EndSwitch
    GUICtrlSetData($idComboBoxHideSecurityCenter, "Hidden|??????", $ActualSetting)
;    MsgBox(0,"",$ActualSetting)


;   Display the GUI.
    GUISetState(@SW_SHOW, $MainDefenderGUI)
    GUISetState(@SW_SHOW, $DefenderGUI)

; Continuation of refreshing
  Local $refresh_settings_key = $ConfigureDefender_temp_key
;  If RegRead($ConfigureDefender_temp_key, 'ConfigureDefenderProtectionLevel') = 'Yes' Then
;     RegDelete($refresh_settings_key,'RefreshDefender')
;     RegDelete($ConfigureDefender_temp_key, 'ConfigureDefenderProtectionLevel')
;     RegDelete($ConfigureDefender_temp_key, 'CheckConfigureDefenderComboBoxSettings')
;  EndIf

;  MsgBox(0,"","")
  Local $refresh_data_old = RegRead($refresh_settings_key,'CheckConfigureDefenderComboBoxSettings')
  If (RegRead($refresh_settings_key,'RefreshDefender') = 'Yes' and $refresh_data_old <> "") Then
     If CheckConfigureDefenderComboBoxSettings() = $refresh_data_old Then
;        MsgBox(0, "Refresh warning", "Refreshing finished successfully. Restart Windows to apply the protection.")
       _ExtMsgBoxSet(1+4+8+32, 0, 0xdddddd, 0x000000, 10, "Arial", @DesktopWidth*0.3)
       _ExtMsgBox(64,"&CLOSE", "ConfigureDefender", "Refreshing finished successfully. Restart Windows to apply the protection.")
     Else
;      MsgBox(0, "Refresh warning", "Some settings were not stored properly. This can usually happen when another security application restricts PowerShell or prevents modifying the Windows Registry.")
       _ExtMsgBoxSet(1+4+8+32, 0, 0xdddddd, 0x000000, 10, "Arial", @DesktopWidth*0.3)
       _ExtMsgBox(16,"&CLOSE", "ConfigureDefender", "Some settings were not stored properly. This can usually happen when another security application restricts PowerShell or prevents modifying the Windows Registry.")
     EndIf
  EndIf
RegDelete($refresh_settings_key, 'CheckConfigureDefenderComboBoxSettings')
RegDelete($refresh_settings_key, 'RefreshDefender') 
;Clean Defender Temp registry key
RegDelete($ConfigureDefender_temp_key)

    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()
           Case $GUI_EVENT_CLOSE, $idOK
		FileDelete(@TempDir & "\Defender.log")
;                ExitLoop
		Exit
           Case $BtnCloseDefender
		FileDelete(@TempDir & "\Defender.log")
;                ExitLoop
		Exit
	   Case $BtnDefaultDefenderSettings
		DefaultDefender()
	   Case $BtnDefenderHighSettings
		DefenderHighSettings()
	   case $BtnInfoAboutDefender
		Run($PowerShellDir & "powershell -command Get-MpComputerStatus; start-sleep 300")
	   case $BtnDefenderSecurityLog
		DefenderSecurityLog()
	   case $BtnDefenderChildProtection
		DefenderChildProtection()
	   Case $BtnHelpDefenderSettings
		HelpDefenderSettings()
	   Case $BtnRefresh
	        RefreshDefenderGUIWindow()
;	   Case $idComboBoxDisableRealtimeMonitoring
;                $sComboRead = GUICtrlRead($idComboBoxDisableRealtimeMonitoring)
;                MsgBox($MB_SYSTEMMODAL, "", "Real-time Monitoring state is: " & $sComboRead, 0, $MainDefenderGUI)
;                RealtimeMonitoring($sComboRead)
	   Case $idComboBoxDisableBehaviorMonitoring
                $sComboRead = GUICtrlRead($idComboBoxDisableBehaviorMonitoring)
;                MsgBox($MB_SYSTEMMODAL, "", "Behavior Monitoring state is: " & $sComboRead, 0, $MainDefenderGUI)
                BehaviorMonitoring($sComboRead)
	   Case $idComboBoxDisableBlockAtFirstSeen
                $sComboRead = GUICtrlRead($idComboBoxDisableBlockAtFirstSeen)
;                MsgBox($MB_SYSTEMMODAL, "", "Block At First Sight state is: " & $sComboRead, 0, $MainDefenderGUI)
                BlockAtFirstSeen($sComboRead)
	   Case $idComboBoxMAPSReporting
                $sComboRead = GUICtrlRead($idComboBoxMAPSReporting)
;                MsgBox($MB_SYSTEMMODAL, "", "Cloud-delivered Protection state is: " & $sComboRead, 0, $MainDefenderGUI)
                MAPSReporting($sComboRead)
	   Case $idComboBoxSubmitSamplesConsent
                $sComboRead = GUICtrlRead($idComboBoxSubmitSamplesConsent)
;                MsgBox($MB_SYSTEMMODAL, "", "Automatic Sample Submission state is: " & $sComboRead, 0, $MainDefenderGUI)
                SubmitSamplesConsent($sComboRead)
	   Case $idComboBoxDisableIOAVProtection
                $sComboRead = GUICtrlRead($idComboBoxDisableIOAVProtection)
;                MsgBox($MB_SYSTEMMODAL, "", "IOAV Protection state is: " & $sComboRead, 0, $MainDefenderGUI)
                IOAVProtection($sComboRead)
	   Case $idComboBoxDisableScriptScanning
                $sComboRead = GUICtrlRead($idComboBoxDisableScriptScanning)
;                MsgBox($MB_SYSTEMMODAL, "", "Script Scanning state is: " & $sComboRead, 0, $MainDefenderGUI)
                ScriptScanning($sComboRead)
	   Case $idComboBoxPUAProtection
                $sComboRead = GUICtrlRead($idComboBoxPUAProtection)
;                MsgBox($MB_SYSTEMMODAL, "", "PUA Protection state is: " & $sComboRead, 0, $MainDefenderGUI)
                PUAProtection($sComboRead)
	   Case $idComboBoxMpCloudBlockLevel
                $sComboRead = GUICtrlRead($idComboBoxMpCloudBlockLevel)
;                MsgBox($MB_SYSTEMMODAL, "", "Cloud Protection Level state is: " & $sComboRead, 0, $MainDefenderGUI)
                MpCloudBlockLevel($sComboRead)
	   Case $idComboBoxMpCloudBlockLevel
                $sComboRead = GUICtrlRead($idComboBoxMpCloudBlockLevel)
;                MsgBox($MB_SYSTEMMODAL, "", "Cloud Protection Level state is: " & $sComboRead, 0, $MainDefenderGUI)
                MpCloudBlockLevel($sComboRead)
	   Case $idComboBoxMpBafsExtendedTimeout
                $sComboRead = GUICtrlRead($idComboBoxMpBafsExtendedTimeout)
;                MsgBox($MB_SYSTEMMODAL, "", "Cloud check time limit is: " & $sComboRead, 0, $MainDefenderGUI)
                MpBafsExtendedTimeout($sComboRead)
	   Case $idComboBoxScanAvgCPULoadFactor
                $sComboRead = GUICtrlRead($idComboBoxScanAvgCPULoadFactor)
;                MsgBox($MB_SYSTEMMODAL, "", "Average CPU Load while scanning is: " & $sComboRead, 0, $MainDefenderGUI)
                ScanAvgCPULoadFactor($sComboRead)
	   Case $idComboBoxAdminSmartScreenForExplorer
                $sComboRead = GUICtrlRead($idComboBoxAdminSmartScreenForExplorer)
;                MsgBox($MB_SYSTEMMODAL, "", "Admin SmartScreen for Explorer state is: " & $sComboRead, 0, $MainDefenderGUI)
                SmartScreenForExplorer($sComboRead)
	   Case $idComboBoxAdminSmartScreenForEdge
                $sComboRead = GUICtrlRead($idComboBoxAdminSmartScreenForEdge)
;                MsgBox($MB_SYSTEMMODAL, "", "Admin SmartScreen for Edge state is: " & $sComboRead, 0, $MainDefenderGUI)
                SmartScreenForEdge($sComboRead)
	   Case $idComboBoxAdminSmartScreenForIE
                $sComboRead = GUICtrlRead($idComboBoxAdminSmartScreenForIE)
;                MsgBox($MB_SYSTEMMODAL, "", "Admin SmartScreen for Internet Explorer state is: " & $sComboRead, 0, $MainDefenderGUI)
                SmartScreenForIE($sComboRead)
	   Case $BtnManageASRExclusions
		ManageASRExclusions()
	   Case $idComboBoxASR1
                $sComboRead = GUICtrlRead($idComboBoxASR1)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR1 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, 'BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550')
	   Case $idComboBoxASR2
                $sComboRead = GUICtrlRead($idComboBoxASR2)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR2 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, 'D4F940AB-401B-4EFC-AADC-AD5F3C50688A')
	   Case $idComboBoxASR3
                $sComboRead = GUICtrlRead($idComboBoxASR3)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR3 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, '3B576869-A4EC-4529-8536-B80A7769E899')
	   Case $idComboBoxASR4
                $sComboRead = GUICtrlRead($idComboBoxASR4)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR4 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, '75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84')
	   Case $idComboBoxASR5
                $sComboRead = GUICtrlRead($idComboBoxASR5)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR5 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, 'D3E037E1-3EB8-44C8-A917-57927947596D')
	   Case $idComboBoxASR6
                $sComboRead = GUICtrlRead($idComboBoxASR6)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR6 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, '5BEB7EFE-FD9A-4556-801D-275E5FFC04CC')
	   Case $idComboBoxASR7
                $sComboRead = GUICtrlRead($idComboBoxASR7)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR7 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, '92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B')
	   Case $idComboBoxASR8
                $sComboRead = GUICtrlRead($idComboBoxASR8)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR8 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, '01443614-cd74-433a-b99e-2ecdc07bfc25')
	   Case $idComboBoxASR9
                $sComboRead = GUICtrlRead($idComboBoxASR9)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR9 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, '9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2')
	   Case $idComboBoxASR10
                $sComboRead = GUICtrlRead($idComboBoxASR10)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR10 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, 'd1e49aac-8f56-4280-b9ba-993a6d77406c')
	   Case $idComboBoxASR11
                $sComboRead = GUICtrlRead($idComboBoxASR11)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR11 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, 'b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4')
	   Case $idComboBoxASR12
                $sComboRead = GUICtrlRead($idComboBoxASR12)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR12 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, 'c1db55ab-c21a-4637-bb3f-a12568109d35')
	   Case $idComboBoxASR13
                $sComboRead = GUICtrlRead($idComboBoxASR13)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR13 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, '26190899-1602-49e8-8b27-eb1d0a1ce869')
	   Case $idComboBoxASR14
                $sComboRead = GUICtrlRead($idComboBoxASR14)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR14 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, '7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c')
	   Case $idComboBoxASR15
                $sComboRead = GUICtrlRead($idComboBoxASR15)
;                MsgBox($MB_SYSTEMMODAL, "", "ASR15 state is: " & $sComboRead, 0, $MainDefenderGUI)
                ASRAddRule($sComboRead, 'e6db77e5-3df2-4cf1-b95a-636979351e5b')
;44444
           Case $idComboBoxNetworkProtection
                $sComboRead = GUICtrlRead($idComboBoxNetworkProtection)
;                MsgBox($MB_SYSTEMMODAL, "", "Network Protection state is: " & $sComboRead, 0, $MainDefenderGUI)
                NetworkProtection($sComboRead)
	   Case $idComboBoxControlledFolderAccess
                $sComboRead = GUICtrlRead($idComboBoxControlledFolderAccess)
;                MsgBox($MB_SYSTEMMODAL, "", "Controlled Folder Access state is: " & $sComboRead, 0, $MainDefenderGUI)
		ControlledFolderAccess($sComboRead)
	   Case $BtnCFA_Folder
		ManageCFAFolders()
	   Case $BtnCFA_Exclusions
		ManageCFAExclusions()
	   case $idComboBoxHideSecurityCenter
		$sComboRead = GUICtrlRead($idComboBoxHideSecurityCenter)
                If not ($sComboRead = "??????") Then
		   HideSecurityCenter($sComboRead)
		Else
		   MsgBox($MB_SYSTEMMODAL, "", "This setting cannot be selected by the user. It was set by using another application.")
		   Switch $HideSecurityCenter
			case 0       
			   $ActualSetting = "Visible"       
			case 8
			   $ActualSetting = "Hidden"
			case Else
			   $ActualSetting = "??????"
		    EndSwitch
		    GUICtrlSetData($idComboBoxHideSecurityCenter, $ActualSetting)
		EndIf
        EndSwitch
    WEnd
EndFunc


Func RealtimeMonitoring($state)
If $state = 'ON' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -DisableRealtimeMonitoring 0", "", @SW_HIDE)
If $state = 'Disabled' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -DisableRealtimeMonitoring 1", "", @SW_HIDE)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection','DisableRealtimeMonitoring')
EndFunc

Func BehaviorMonitoring($state)
If $state = 'ON' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -DisableBehaviorMonitoring 0", "", @SW_HIDE)
If $state = 'Disabled' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -DisableBehaviorMonitoring 1", "", @SW_HIDE)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection','DisableBehaviorMonitoring')
EndFunc

Func BlockAtFirstSeen($state)
If $state = 'ON' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -DisableBlockAtFirstSeen 0", "", @SW_HIDE)
If $state = 'Disabled' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -DisableBlockAtFirstSeen 1", "", @SW_HIDE)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet','DisableBlockAtFirstSeen')
EndFunc

Func MAPSReporting($state)
If $state = 'ON' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -MAPSReporting 2", "", @SW_HIDE)
If $state = 'Disabled' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -MAPSReporting 0", "", @SW_HIDE)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet','SpynetReporting')
EndFunc

Func SubmitSamplesConsent($state)
If $state = 'Prompt' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -SubmitSamplesConsent 0", "", @SW_HIDE)
If $state = 'Send' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -SubmitSamplesConsent 1", "", @SW_HIDE)
If $state = 'Disabled' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -SubmitSamplesConsent 2", "", @SW_HIDE)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet','SubmitSamplesConsent')
EndFunc

Func IOAVProtection($state)
If $state = 'ON' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -DisableIOAVProtection 0", "", @SW_HIDE)
If $state = 'Disabled' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -DisableIOAVProtection 1", "", @SW_HIDE)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection','DisableIOAVProtection')
EndFunc

Func ScriptScanning($state)
If $state = 'ON' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -DisableScriptScanning 0", "", @SW_HIDE)
If $state = 'Disabled' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -DisableScriptScanning 1", "", @SW_HIDE)
EndFunc

Func PUAProtection($state)
If $state = 'ON' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -PUAProtection Enabled", "", @SW_HIDE)
If $state = 'Disabled' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -PUAProtection Disabled", "", @SW_HIDE)
If $state = 'Audit' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -PUAProtection AuditMode", "", @SW_HIDE)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine','MpEnablePus')
EndFunc

Func MpCloudBlockLevel($state)
Local $WinVersion = RegRead('HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion','CurrentBuild')
If $state = "Default" Then 
   RegWrite($cloudlevelKey, 'MpCloudBlockLevel', 'REG_DWORD', Number('0'))
Else
   If $WinVersion < 15063 Then RegWrite($cloudlevelKey, 'MpCloudBlockLevel', 'REG_DWORD', Number('0'))
   If $WinVersion = 15063 Then RegWrite($cloudlevelKey, 'MpCloudBlockLevel', 'REG_DWORD', Number('2'))
   If $WinVersion > 15063 Then
      If $state = "High" Then RegWrite($cloudlevelKey, 'MpCloudBlockLevel', 'REG_DWORD', Number('2'))
      If $state = "Highest" Then RegWrite($cloudlevelKey, 'MpCloudBlockLevel', 'REG_DWORD', Number('4'))
      If $state = "Block" Then RegWrite($cloudlevelKey, 'MpCloudBlockLevel', 'REG_DWORD', Number('6'))
   EndIf
EndIf
EndFunc

Func MpBafsExtendedTimeout($state)
If $state = "10s" Then RegWrite($cloudlevelKey, 'MpBafsExtendedTimeout', 'REG_DWORD', Number('0'))
If $state = "20s" Then RegWrite($cloudlevelKey, 'MpBafsExtendedTimeout', 'REG_DWORD', Number('10'))
If $state = "30s" Then RegWrite($cloudlevelKey, 'MpBafsExtendedTimeout', 'REG_DWORD', Number('20'))
If $state = "40s" Then RegWrite($cloudlevelKey, 'MpBafsExtendedTimeout', 'REG_DWORD', Number('30'))
If $state = "50s" Then RegWrite($cloudlevelKey, 'MpBafsExtendedTimeout', 'REG_DWORD', Number('40'))
If $state = "60s" Then RegWrite($cloudlevelKey, 'MpBafsExtendedTimeout', 'REG_DWORD', Number('50'))
EndFunc

Func ScanAvgCPULoadFactor($state)
If $state = "10%" Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -ScanAvgCPULoadFactor 10", "", @SW_HIDE)
If $state = "20%" Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -ScanAvgCPULoadFactor 20", "", @SW_HIDE)
If $state = "30%" Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -ScanAvgCPULoadFactor 30", "", @SW_HIDE)
If $state = "40%" Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -ScanAvgCPULoadFactor 40", "", @SW_HIDE)
If $state = "50%" Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -ScanAvgCPULoadFactor 50", "", @SW_HIDE)
If $state = "60%" Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -ScanAvgCPULoadFactor 60", "", @SW_HIDE)
If $state = "70%" Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -ScanAvgCPULoadFactor 70", "", @SW_HIDE)
If $state = "80%" Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -ScanAvgCPULoadFactor 80", "", @SW_HIDE)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan','AvgCPULoadFactor')
EndFunc

Func SmartScreenForExplorer($state)
Switch $state
	   case 'Disabled'       
		RegWrite($SmartScreenForExplorerKey, 'EnableSmartScreen', 'REG_DWORD', Number('0'))
	   case 'Block'
		RegWrite($SmartScreenForExplorerKey, 'EnableSmartScreen', 'REG_DWORD', Number('1'))
		RegWrite($SmartScreenForExplorerKey, 'ShellSmartScreenLevel', 'REG_SZ', 'Block')
	   case 'Warn'
		RegWrite($SmartScreenForExplorerKey, 'EnableSmartScreen', 'REG_DWORD', Number('1'))
		RegWrite($SmartScreenForExplorerKey, 'ShellSmartScreenLevel', 'REG_SZ', 'Warn')
	   case 'User'
	      RegDelete($SmartScreenForExplorerKey, 'EnableSmartScreen')
	      RegDelete($SmartScreenForExplorerKey, 'ShellSmartScreenLevel')
       EndSwitch
EndFunc


Func SmartScreenForEdge($state)
;MsgBox(0,"",$state)
Switch $state
	   case 'Disabled'       
		RegWrite($SmartScreenForEdgeKey, 'EnabledV9', 'REG_DWORD', Number('0'))
	   case 'Block'
		RegWrite($SmartScreenForEdgeKey, 'EnabledV9', 'REG_DWORD', Number('1'))
		RegWrite($SmartScreenForEdgeKey, 'PreventOverride', 'REG_DWORD', Number('1'))
	   case 'Warn'
		RegWrite($SmartScreenForEdgeKey, 'EnabledV9', 'REG_DWORD', Number('1'))
		RegWrite($SmartScreenForEdgeKey, 'PreventOverride', 'REG_DWORD', Number('0'))
	   case 'User'
	      RegDelete($SmartScreenForEdgeKey, 'EnabledV9')
	      RegDelete($SmartScreenForEdgeKey, 'PreventOverride')
EndSwitch
EndFunc

Func SmartScreenForIE($state)
;MsgBox(0,"",$state)
Switch $state
	   case 'Disabled'       
		RegWrite($SmartScreenForIEKey, 'EnabledV9', 'REG_DWORD', Number('0'))
	   case 'Block'
		RegWrite($SmartScreenForIEKey, 'EnabledV9', 'REG_DWORD', Number('1'))
		RegWrite($SmartScreenForIEKey, 'PreventOverride', 'REG_DWORD', Number('1'))
	   case 'Warn'
		RegWrite($SmartScreenForIEKey, 'EnabledV9', 'REG_DWORD', Number('1'))
		RegWrite($SmartScreenForIEKey, 'PreventOverride', 'REG_DWORD', Number('0'))
	   case 'User'
	        RegDelete($SmartScreenForIEKey, 'EnabledV9')
	        RegDelete($SmartScreenForIEKey, 'PreventOverride')
EndSwitch
EndFunc

Func ASRAddRule($state, $RuleId)
Local $command
Switch $state
  case 'Disabled'  
        $command = $PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $RuleId & " -AttackSurfaceReductionRules_Actions Disabled"
	RunWait($command, "", @SW_HIDE)
  case 'ON'
        $command = $PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $RuleId & " -AttackSurfaceReductionRules_Actions Enabled"
; Add C:\Windows folder to exclusions for most restrictive rules
	Local $text = ""
	If ($RuleId = '01443614-cd74-433a-b99e-2ecdc07bfc25') Then
	   $command = $command & "; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\assembly'"
	   $command = $command & "; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\Microsoft.NET\Framework\*\NativeImages'"
	   $command = $command & "; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\WinSxS\*\*.ni.dll'"
	   $command = $command & "; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:ProgramData'\Microsoft\Windows Defender'" 
;	   $command = $command & "; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot"
;	   $command = $command & "; Add-MpPreference -AttackSurfaceReductionOnlyExclusions ${env:ProgramFiles(x86)}"
;	   $command = $command & "; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:ProgramW6432"
; Info about excluded folders
;	   Local $ProgramFiles86 = ""
; 	   If @OSArch = "X64" Then $ProgramFiles86 = @ProgramFilesDir & " (x86)" & @CRLF
           Local $ProgramDataWD = StringReplace(@WindowsDir, 'Windows', 'ProgramData\Microsoft\Windows Defender') & @CRLF
	   $text = "The following folders are excluded:" & @CRLF & @WindowsDir & '\assembly' & @CRLF & @WindowsDir & '\Microsoft.NET\Framework\*\NativeImages' & @CRLF & @WindowsDir & '\WinSxS\*\*.ni.dll' & @CRLF & $ProgramDataWD
	EndIf
; Apply ASR rule
	RunWait($command, "", @SW_HIDE)
; Display excluded folders (if any).
	If not ($text = "") Then MsgBox(262144,"", $text)
  case 'Audit'  
        $command = $PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionRules_Ids " & $RuleId & " -AttackSurfaceReductionRules_Actions AuditMode"
	RunWait($command, "", @SW_HIDE)
EndSwitch
; Delete possible rules introduced via policies reg tweaks
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules',$RuleId)
EndFunc

;55555

Func NetworkProtection($state)
If $state = 'ON' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -EnableNetworkProtection Enabled", "", @SW_HIDE)
If $state = 'Disabled' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -EnableNetworkProtection Disabled", "", @SW_HIDE)
If $state = 'Audit' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -EnableNetworkProtection AuditMode", "", @SW_HIDE)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection','EnableNetworkProtection')
EndFunc

Func ControlledFolderAccess($state)
; Deletes all settings in Policy keys (also folder paths and file paths, because they cannot be removed via Security Center.
If $state = 'ON' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -EnableControlledFolderAccess Enabled", "", @SW_HIDE)
If $state = 'Disabled' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -EnableControlledFolderAccess Disabled", "", @SW_HIDE)
If $state = 'Audit' Then RunWait($PowerShellDir & "powershell -WindowStyle hidden -command Set-MpPreference -EnableControlledFolderAccess AuditMode", "", @SW_HIDE)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access','EnableControlledFolderAccess')
EndFunc


Func HideSecurityCenter($state)
Switch $state
   case 'Visible'
      RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','DisallowExploitProtectionOverride')
      RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','UILockdown')
      RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health','UILockdown')
      RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options','UILockdown')
      RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Firewall and network protection','UILockdown')
      RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection','UILockdown')
      RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection','UILockdown')
      RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security','UILockdown')
      $HideSecurityCenter = 0
   case 'Hidden'
      RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','DisallowExploitProtectionOverride', 'REG_DWORD', 1)
      RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','UILockdown', 'REG_DWORD', 1)
      RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health','UILockdown', 'REG_DWORD', 1)
      RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options','UILockdown', 'REG_DWORD', 1)
      RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Firewall and network protection','UILockdown', 'REG_DWORD', 1)
      RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection','UILockdown', 'REG_DWORD', 1)
      RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection','UILockdown', 'REG_DWORD', 1)
      RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security','UILockdown', 'REG_DWORD', 1)
      $HideSecurityCenter = 8
   case else
      MsgBox(262144,"","Some elements of Security Center (but not all) are hidden.")
   EndSwitch
EndFunc


Func CloseDefender()
   GuiDelete($MainDefenderGUI)
   FileDelete(@TempDir & "\Defender.log")
   Exit
EndFunc


Func RefreshDefenderGUIWindow()
;  Local $pos = WinGetPos ($DefenderGUI)
;  $X_DefenderGUI = $pos[0] 
;  $Y_DefenderGUI = $pos[1]
;  GUISetState(@SW_HIDE,$DefenderGUI)
  Local $value = CheckConfigureDefenderComboBoxSettings()
;  MsgBox(0,"",$value)
  RegWrite($ConfigureDefender_temp_key,'CheckConfigureDefenderComboBoxSettings', 'REG_SZ', $value)
  RegWrite($ConfigureDefender_temp_key,'RefreshDefender', 'REG_SZ', 'Yes')
  GuiDelete($DefenderGUI)
  CheckBoxDefender()
EndFunc


;**********

Func WM_VSCROLL($hWnd, $iMsg, $wParam, $lParam)
    #forceref $iMsg, $wParam, $lParam
    Local $iScrollCode = BitAND($wParam, 0x0000FFFF)
    Local $iIndex = -1, $iCharY, $iPosY
    Local $iMin, $iMax, $iPage, $iPos, $iTrackPos

    For $x = 0 To UBound($__g_aSB_WindowInfo) - 1
        If $__g_aSB_WindowInfo[$x][0] = $hWnd Then
            $iIndex = $x
            $iCharY = $__g_aSB_WindowInfo[$iIndex][3]
            ExitLoop
        EndIf
    Next
    If $iIndex = -1 Then Return 0

    ; Get all the vertial scroll bar information
    Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_VERT)
    $iMin = DllStructGetData($tSCROLLINFO, "nMin")
    $iMax = DllStructGetData($tSCROLLINFO, "nMax")
    $iPage = DllStructGetData($tSCROLLINFO, "nPage")
    ; Save the position for comparison later on
    $iPosY = DllStructGetData($tSCROLLINFO, "nPos")
    $iPos = $iPosY
    $iTrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")


    Switch $iScrollCode
        Case $SB_TOP ; user clicked the HOME keyboard key
            DllStructSetData($tSCROLLINFO, "nPos", $iMin)

        Case $SB_BOTTOM ; user clicked the END keyboard key
            DllStructSetData($tSCROLLINFO, "nPos", $iMax)

        Case $SB_LINEUP ; user clicked the top arrow
            DllStructSetData($tSCROLLINFO, "nPos", $iPos - 1)

        Case $SB_LINEDOWN ; user clicked the bottom arrow
            DllStructSetData($tSCROLLINFO, "nPos", $iPos + 1)

        Case $SB_PAGEUP ; user clicked the scroll bar shaft above the scroll box
            DllStructSetData($tSCROLLINFO, "nPos", $iPos - $iPage)

        Case $SB_PAGEDOWN ; user clicked the scroll bar shaft below the scroll box
            DllStructSetData($tSCROLLINFO, "nPos", $iPos + $iPage)

        Case $SB_THUMBTRACK ; user dragged the scroll box
            DllStructSetData($tSCROLLINFO, "nPos", $iTrackPos)
    EndSwitch

    ; // Set the position and then retrieve it.  Due to adjustments
    ; //   by Windows it may not be the same as the value set.

    DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
    _GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
    _GUIScrollBars_GetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
    ;// If the position has changed, scroll the window and update it
    $iPos = DllStructGetData($tSCROLLINFO, "nPos")

    If ($iPos <> $iPosY) Then
       _GUIScrollBars_ScrollWindow($hWnd, 0, $iCharY * ($iPosY - $iPos))

        $iPosY = $iPos
    EndIf

    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_VSCROLL

;66666

Func DefaultDefender()
Local $sMessage = "Please wait."
SplashTextOn("Warning", $sMessage, 150, 40, -1, -1, 1, "", 10)
RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -EnableNetworkProtection Disabled; Set-MpPreference -EnableControlledFolderAccess Disabled; Set-MpPreference -DisableRealtimeMonitoring 0; Set-MpPreference -DisableBehaviorMonitoring 0; Set-MpPreference -DisableBlockAtFirstSeen 0; Set-MpPreference -MAPSReporting 2; Set-MpPreference -SubmitSamplesConsent 1; Set-MpPreference -DisableIOAVProtection 0; Set-MpPreference -DisableScriptScanning 0; Set-MpPreference -PUAProtection Disabled; Set-MpPreference -ScanAvgCPULoadFactor 50; $get = (Get-Mppreference).AttackSurfaceReductionRules_Ids; Remove-MpPreference -AttackSurfaceReductionRules_Ids $get; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\assembly'; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\Microsoft.NET\Framework\*\NativeImages'; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\WinSxS\*\*.ni.dll'; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:ProgramData'\Microsoft\Windows Defender'; ", "", @SW_HIDE)
RegDelete($SmartScreenForExplorerKey, 'EnableSmartScreen')
RegDelete($SmartScreenForExplorerKey, 'ShellSmartScreenLevel')
RegDelete($SmartScreenForEdgeKey, 'EnabledV9')
RegDelete($SmartScreenForEdgeKey, 'PreventOverride')
RegDelete($SmartScreenForIEKey, 'EnabledV9')
RegDelete($SmartScreenForIEKey, 'PreventOverride')
RegDelete($MpenginePolicyKey)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\NIS')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard')
; Unhiding Security Center
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','DisallowExploitProtectionOverride')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Firewall and network protection','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security','UILockdown')
SplashOff()
;RegWrite($ConfigureDefender_temp_key, 'ConfigureDefenderProtectionLevel', 'REG_SZ', 'Yes')
;RefreshDefenderGUIWindow()
SetProtectionLevelOptions("DEFAULT")
EndFunc


Func DefenderHighSettings()
Local $sMessage = "Please wait."
SplashTextOn("Warning", $sMessage, 150, 40, -1, -1, 1, "", 10)
RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -EnableNetworkProtection Enabled; Set-MpPreference -EnableControlledFolderAccess Disabled; Set-MpPreference -DisableRealtimeMonitoring 0; Set-MpPreference -DisableBehaviorMonitoring 0; Set-MpPreference -DisableBlockAtFirstSeen 0; Set-MpPreference -MAPSReporting 2; Set-MpPreference -SubmitSamplesConsent 1; Set-MpPreference -DisableIOAVProtection 0; Set-MpPreference -DisableScriptScanning 0; Set-MpPreference -PUAProtection Enabled; Set-MpPreference -ScanAvgCPULoadFactor 50; Set-MpPreference -AttackSurfaceReductionRules_Ids BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550,D4F940AB-401B-4EFC-AADC-AD5F3C50688A,3B576869-A4EC-4529-8536-B80A7769E899,75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84,D3E037E1-3EB8-44C8-A917-57927947596D,5BEB7EFE-FD9A-4556-801D-275E5FFC04CC,92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B,01443614-cd74-433a-b99e-2ecdc07bfc25,c1db55ab-c21a-4637-bb3f-a12568109d35,9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2,d1e49aac-8f56-4280-b9ba-993a6d77406c,b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4,26190899-1602-49e8-8b27-eb1d0a1ce869,7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c,e6db77e5-3df2-4cf1-b95a-636979351e5b -AttackSurfaceReductionRules_Actions Enabled,Enabled,Enabled,Enabled,Enabled,Enabled,Enabled,Disabled,Enabled,Disabled,Disabled,Enabled,Enabled,Enabled,Enabled; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\assembly'; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\Microsoft.NET\Framework\*\NativeImages'; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\WinSxS\*\*.ni.dll'; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:ProgramData'\Microsoft\Windows Defender'; ", "", @SW_HIDE)

; Delete Policy keys
RegDelete($MpenginePolicyKey)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\NIS')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard')
; Delete Admin SmartScreen
RegDelete($SmartScreenForExplorerKey, 'EnableSmartScreen')
RegDelete($SmartScreenForExplorerKey, 'ShellSmartScreenLevel')
RegDelete($SmartScreenForEdgeKey, 'EnabledV9')
RegDelete($SmartScreenForEdgeKey, 'PreventOverride')
RegDelete($SmartScreenForIEKey, 'EnabledV9')
RegDelete($SmartScreenForIEKey, 'PreventOverride')
; Cloud Level
MpCloudBlockLevel('Highest')
RegWrite($cloudlevelKey, 'MpBafsExtendedTimeout', 'REG_DWORD', Number('10'))
; Unhiding Security Center
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','DisallowExploitProtectionOverride')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Firewall and network protection','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security','UILockdown')
SplashOff()
; Refresh
;RegWrite($ConfigureDefender_temp_key, 'ConfigureDefenderProtectionLevel', 'REG_SZ', 'Yes')
;RefreshDefenderGUIWindow()
SetProtectionLevelOptions("HIGH")
EndFunc

Func DefenderChildProtection()
Local $Warning = "Please, use this Protection Level with caution. It can sometimes prevent downloading/running some legal applications, including the fresh new versions of ConfigureDefender. It is recommended to change Protection Level to HIGH or DEFAULT before updating ConfigureDefender to the new version. Please note, that MAX settings are most aggressive and sometimes can interfere with installed applications. Some ASR rules and Controlled Folder Access can also generate a higher number of security alerts."
_ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
_ExtMsgBox(0,"CLOSE", "MAX Protection Level", $Warning)

Local $sMessage = "Please wait."
SplashTextOn("Warning", $sMessage, 150, 40, -1, -1, 1, "", 10)
RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -EnableNetworkProtection Enabled; Set-MpPreference -EnableControlledFolderAccess Enabled; Set-MpPreference -DisableRealtimeMonitoring 0; Set-MpPreference -DisableBehaviorMonitoring 0; Set-MpPreference -DisableBlockAtFirstSeen 0; Set-MpPreference -MAPSReporting 2; Set-MpPreference -SubmitSamplesConsent 1; Set-MpPreference -DisableIOAVProtection 0; Set-MpPreference -DisableScriptScanning 0; Set-MpPreference -PUAProtection Enabled; Set-MpPreference -ScanAvgCPULoadFactor 50; Set-MpPreference -AttackSurfaceReductionRules_Ids BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550,D4F940AB-401B-4EFC-AADC-AD5F3C50688A,3B576869-A4EC-4529-8536-B80A7769E899,75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84,D3E037E1-3EB8-44C8-A917-57927947596D,5BEB7EFE-FD9A-4556-801D-275E5FFC04CC,92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B,01443614-cd74-433a-b99e-2ecdc07bfc25,c1db55ab-c21a-4637-bb3f-a12568109d35,9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2,d1e49aac-8f56-4280-b9ba-993a6d77406c,b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4,26190899-1602-49e8-8b27-eb1d0a1ce869,7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c,e6db77e5-3df2-4cf1-b95a-636979351e5b -AttackSurfaceReductionRules_Actions Enabled,Enabled,Enabled,Enabled,Enabled,Enabled,Enabled,Enabled,Enabled,Enabled,Enabled,Enabled,Enabled,Enabled,Enabled; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\assembly'; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\Microsoft.NET\Framework\*\NativeImages'; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\WinSxS\*\*.ni.dll'; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:ProgramData'\Microsoft\Windows Defender'; ", "", @SW_HIDE)

; Display excluded folders
Local $ProgramDataWD = StringReplace(@WindowsDir, 'Windows', 'ProgramData\Microsoft\Windows Defender') & @CRLF
Local $text = "The below folders are excluded:" & @CRLF & @WindowsDir & '\assembly' & @CRLF & @WindowsDir & '\Microsoft.NET\Framework\*\NativeImages' & @CRLF & @WindowsDir & '\WinSxS\*\*.ni.dll' & @CRLF & $ProgramDataWD
MsgBox(262144,"", $text)

; Delete Policy keys
RegDelete($MpenginePolicyKey)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\NIS')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard')
; SmartScreen
RegWrite($SmartScreenForExplorerKey, 'EnableSmartScreen', 'REG_DWORD', Number('1'))
RegWrite($SmartScreenForExplorerKey, 'ShellSmartScreenLevel', 'REG_SZ', 'Block')
RegWrite($SmartScreenForEdgeKey, 'EnabledV9', 'REG_DWORD', Number('1'))
RegWrite($SmartScreenForEdgeKey, 'PreventOverride', 'REG_DWORD', Number('1'))
RegWrite($SmartScreenForIEKey, 'EnabledV9', 'REG_DWORD', Number('1'))
RegWrite($SmartScreenForIEKey, 'PreventOverride', 'REG_DWORD', Number('1'))
; Cloud Level
MpCloudBlockLevel('Block')
RegWrite($cloudlevelKey, 'MpBafsExtendedTimeout', 'REG_DWORD', Number('50'))
; Hiding Security Center
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','DisallowExploitProtectionOverride', 'REG_DWORD', 1)
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','UILockdown', 'REG_DWORD', 1)
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health','UILockdown', 'REG_DWORD', 1)
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options','UILockdown', 'REG_DWORD', 1)
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Firewall and network protection','UILockdown', 'REG_DWORD', 1)
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection','UILockdown', 'REG_DWORD', 1)
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection','UILockdown', 'REG_DWORD', 1)
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security','UILockdown', 'REG_DWORD', 1)
SplashOff()

; Refresh
;RegWrite($ConfigureDefender_temp_key, 'ConfigureDefenderProtectionLevel', 'REG_SZ', 'Yes')
;RefreshDefenderGUIWindow()
SetProtectionLevelOptions("MAX")
EndFunc


Func OptimizeASRExclusions()

Local $k = 0
RegRead($ASRKeyPolicyExclusions, @WindowsDir)
if not @error then 
;  If $k is greater than 1 then optimized exclusions for Windows folder will be applied
   $k = 1
EndIf

; If ASR exclusions policies are not empty then delete them with alert
If not (RegEnumVal('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\ASROnlyExclusions', 1) = "") Then
   RegDelete($ASRKeyPolicyExclusions)
   MsgBox(0,"","ASR exclusions applied by Windows policies were deleted for compatibility with ConfigureDefender. Please use 'Manage ASR Exclusions' option to check/add/remove the exclusions.")
EndIf

;Check if c:\Windows, c:\Program Files, c:\Program Files (x86) are excluded. If so then delete them with alert
Local $n = 0
Local $nExlusions = 0
Local $WinDirExlusions = ""
Local $arrayASR_Exclusions = PathsFromKey2Array($ASRKeyExclusions)
For $i=1 to UBound($arrayASR_Exclusions) -1
   $nExlusions = _ArraySearch($arrayASR_Exclusions, @WindowsDir)
   If ($nExlusions > 0 and StringReplace($arrayASR_Exclusions[$nExlusions], @WindowsDir, "") = "") then
      $WinDirExlusions = @WindowsDir & @crlf
      $n = $n + 1
   EndIf
Next 
$nExlusions = 0
Local $ProgramFilesExlusions = ""
For $i=1 to UBound($arrayASR_Exclusions) -1
   $nExlusions = _ArraySearch($arrayASR_Exclusions, @ProgramFilesDir)
   If ($nExlusions > 0 and StringReplace($arrayASR_Exclusions[$nExlusions], @ProgramFilesDir, "") = "") then
      $ProgramFilesExlusions = @ProgramFilesDir & @crlf
      $n = $n + 1
   EndIf
Next 
$nExlusions = 0
Local $ProgramFilesExlusions_x86 = ""
For $i=1 to UBound($arrayASR_Exclusions) -1
   $nExlusions = _ArraySearch($arrayASR_Exclusions, @ProgramFilesDir & ' (x86)')
   If ($nExlusions > 0 and StringReplace($arrayASR_Exclusions[$nExlusions], @ProgramFilesDir & ' (x86)', "") = "") then
      $ProgramFilesExlusions_x86 = @ProgramFilesDir & ' (x86)' & @crlf
      $n = $n + 1
   EndIf
Next 

; If c:\Windows, c:\Program Files, c:\Program Files (x86) removed from exclusion then add optimized exclusions for Windows folder
If $n > 0 Then
   Local $OKCancel = MsgBox(1, "", 'Some ASR exclusions are not optimized for the new ASR rules:' & @crlf & @crlf & $WinDirExlusions & $ProgramFilesExlusions & $ProgramFilesExlusions_x86 & @crlf & 'Press the OK button to delete those exclusions and add the optimized ones.')
   If $OKCancel = 1 Then
      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:ProgramFiles; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions ${env:ProgramFiles(x86)}; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:ProgramW6432; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot; ", "", @SW_HIDE)
      If RegRead('HKLM\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules', '01443614-cd74-433a-b99e-2ecdc07bfc25') = 1 Then 
         RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\assembly'; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\Microsoft.NET\Framework\*\NativeImages'; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\WinSxS\*\*.ni.dll'; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:ProgramData'\Microsoft\Windows Defender'; ", "", @SW_HIDE)
      EndIf
   EndIf
Else
   If $k > 0 Then 
      RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\assembly'; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\Microsoft.NET\Framework\*\NativeImages'; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot'\WinSxS\*\*.ni.dll'; Add-MpPreference -AttackSurfaceReductionOnlyExclusions $env:ProgramData'\Microsoft\Windows Defender'; ", "", @SW_HIDE)
   EndIf
EndIf
EndFunc


Func CheckConfigureDefenderComboBoxSettings()
Local $settings = ""
$settings = $settings & @crlf & GUICtrlRead($idComboBoxDisableBehaviorMonitoring)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxDisableBlockAtFirstSeen)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxMAPSReporting)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxSubmitSamplesConsent)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxDisableIOAVProtection)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxDisableScriptScanning)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxPUAProtection)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxMpCloudBlockLevel)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxMpBafsExtendedTimeout)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxScanAvgCPULoadFactor)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxAdminSmartScreenForExplorer)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxAdminSmartScreenForEdge)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxAdminSmartScreenForIE)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR1)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR2)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR3)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR4)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR5)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR6)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR7)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR8)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR9)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR10)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR11)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR12)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR13)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR14)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxASR15)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxNetworkProtection)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxControlledFolderAccess)
$settings = $settings & @crlf & GUICtrlRead($idComboBoxHideSecurityCenter)
Return $settings
EndFunc


Func SetProtectionLevelOptions($ProtectionLevel)
GUICtrlSetData($idComboBoxDisableBehaviorMonitoring, "ON")
GUICtrlSetData($idComboBoxDisableBlockAtFirstSeen, "ON")
GUICtrlSetData($idComboBoxMAPSReporting, "ON")
GUICtrlSetData($idComboBoxSubmitSamplesConsent, "Send")
GUICtrlSetData($idComboBoxDisableIOAVProtection, "ON")
GUICtrlSetData($idComboBoxDisableScriptScanning, "ON")
GUICtrlSetData($idComboBoxScanAvgCPULoadFactor, "50%")
Switch $ProtectionLevel
   case "DEFAULT"
      GUICtrlSetData($idComboBoxNetworkProtection, "Disabled")
      GUICtrlSetData($idComboBoxControlledFolderAccess, "Disabled")
      GUICtrlSetData($idComboBoxPUAProtection, "Disabled")
      GUICtrlSetData($idComboBoxMpCloudBlockLevel, "Default")
      GUICtrlSetData($idComboBoxMpBafsExtendedTimeout, "10s")
      GUICtrlSetData($idComboBoxAdminSmartScreenForExplorer, "User")
      GUICtrlSetData($idComboBoxAdminSmartScreenForEdge, "User")
      GUICtrlSetData($idComboBoxAdminSmartScreenForIE, "User")
      GUICtrlSetData($idComboBoxASR1, "Disabled")
      GUICtrlSetData($idComboBoxASR2, "Disabled")
      GUICtrlSetData($idComboBoxASR3, "Disabled")
      GUICtrlSetData($idComboBoxASR4, "Disabled")
      GUICtrlSetData($idComboBoxASR5, "Disabled")
      GUICtrlSetData($idComboBoxASR6, "Disabled")
      GUICtrlSetData($idComboBoxASR7, "Disabled")
      GUICtrlSetData($idComboBoxASR8, "Disabled")
      GUICtrlSetData($idComboBoxASR9, "Disabled")
      GUICtrlSetData($idComboBoxASR10, "Disabled")
      GUICtrlSetData($idComboBoxASR11, "Disabled")
      GUICtrlSetData($idComboBoxASR12, "Disabled")
      GUICtrlSetData($idComboBoxASR13, "Disabled")
      GUICtrlSetData($idComboBoxASR14, "Disabled")
      GUICtrlSetData($idComboBoxASR15, "Disabled")
      GUICtrlSetData($idComboBoxHideSecurityCenter, "Visible")
   case "HIGH"
      GUICtrlSetData($idComboBoxNetworkProtection, "ON")
      GUICtrlSetData($idComboBoxControlledFolderAccess, "Disabled")
      GUICtrlSetData($idComboBoxPUAProtection, "ON")
      GUICtrlSetData($idComboBoxMpCloudBlockLevel, "Highest")
      GUICtrlSetData($idComboBoxMpBafsExtendedTimeout, "20s")
      GUICtrlSetData($idComboBoxAdminSmartScreenForExplorer, "User")
      GUICtrlSetData($idComboBoxAdminSmartScreenForEdge, "User")
      GUICtrlSetData($idComboBoxAdminSmartScreenForIE, "User")
      GUICtrlSetData($idComboBoxASR1, "ON")
      GUICtrlSetData($idComboBoxASR2, "ON")
      GUICtrlSetData($idComboBoxASR3, "ON")
      GUICtrlSetData($idComboBoxASR4, "ON")
      GUICtrlSetData($idComboBoxASR5, "ON")
      GUICtrlSetData($idComboBoxASR6, "ON")
      GUICtrlSetData($idComboBoxASR7, "ON")
      GUICtrlSetData($idComboBoxASR8, "Disabled")
      GUICtrlSetData($idComboBoxASR9, "Disabled")
      GUICtrlSetData($idComboBoxASR10, "Disabled")
      GUICtrlSetData($idComboBoxASR11, "ON")
      GUICtrlSetData($idComboBoxASR12, "ON")
      GUICtrlSetData($idComboBoxASR13, "ON")
      GUICtrlSetData($idComboBoxASR14, "ON")
      GUICtrlSetData($idComboBoxASR15, "ON")
      GUICtrlSetData($idComboBoxHideSecurityCenter, "Visible")
   case 'MAX'
      GUICtrlSetData($idComboBoxNetworkProtection, "ON")
      GUICtrlSetData($idComboBoxControlledFolderAccess, "ON")
      GUICtrlSetData($idComboBoxPUAProtection, "ON")
      GUICtrlSetData($idComboBoxMpCloudBlockLevel, "Block")
      GUICtrlSetData($idComboBoxMpBafsExtendedTimeout, "60s")
      GUICtrlSetData($idComboBoxAdminSmartScreenForExplorer, "Block")
      GUICtrlSetData($idComboBoxAdminSmartScreenForEdge, "Block")
      GUICtrlSetData($idComboBoxAdminSmartScreenForIE, "Block")
      GUICtrlSetData($idComboBoxASR1, "ON")
      GUICtrlSetData($idComboBoxASR2, "ON")
      GUICtrlSetData($idComboBoxASR3, "ON")
      GUICtrlSetData($idComboBoxASR4, "ON")
      GUICtrlSetData($idComboBoxASR5, "ON")
      GUICtrlSetData($idComboBoxASR6, "ON")
      GUICtrlSetData($idComboBoxASR7, "ON")
      GUICtrlSetData($idComboBoxASR8, "ON")
      GUICtrlSetData($idComboBoxASR9, "ON")
      GUICtrlSetData($idComboBoxASR10, "ON")
      GUICtrlSetData($idComboBoxASR11, "ON")
      GUICtrlSetData($idComboBoxASR12, "ON")
      GUICtrlSetData($idComboBoxASR13, "ON")
      GUICtrlSetData($idComboBoxASR14, "ON")
      GUICtrlSetData($idComboBoxASR15, "ON")
      GUICtrlSetData($idComboBoxHideSecurityCenter, "Hidden")
EndSwitch

_ExtMsgBoxSet(1+4+8+32, 0, 0xdddddd, 0x000000, 10, "Arial", @DesktopWidth*0.3)
_ExtMsgBox(64," ", "ConfigureDefender", $ProtectionLevel & " Protection Level configured.", 3)

EndFunc


Func HelpDefenderSettings()

Local $help0 = 'Most settings available in ConfigureDefender are related to Windows Defender real-time protection and work only when Windows Defender real-time protection is set to "ON".' & @Crlf  & @Crlf
$help0 = $help0 & 'Important: These two settings (below) should never be changed because important features like "Block at First Sight" and "Cloud Protection Level" will not work properly:' & @Crlf & '*  Cloud-delivered Protection = "ON"'  & @Crlf & '*  Automatic Sample Submission = "Send"' & @Crlf  & @Crlf & 'If SmartScreen setting is set to Block in ConfigureDefender, then this can block the newest version of ConfigureDefender executable (SmartScreen alert with no option to run). To unblock it, just do a right-click on ConfigureDefender executable and choose Properties. Look at the Security entry in the bottom of the window and tick Unblock.' & @Crlf  & @Crlf  & @Crlf
$help0 = $help0 & 'ConfigureDefender Protection Levels (pre-defined settings).' & @Crlf & @Crlf & '"DEFAULT"' & @Crlf & 'Microsoft Windows Defender default configuration which is applied automatically when installing the Windows system. It provides basic antivirus protection and can be used to quickly revert any configuration to Windows defaults.' & @Crlf & @Crlf & '"HIGH"' & @Crlf & 'Enhanced configuration which enables Network Protection and most of Exploit Guard (ASR) features. Three Exploit Guard features and Controlled Folder Access ransomware protection are disabled to avoid false positives. This is the recommended configuration which is appropriate for most users and provides significantly increased security.' & @Crlf & @Crlf & '"MAX"' & @Crlf & 'This is the most secure protection level which enables all advanced Windows Defender features and hides Windows Security Center. Configuration changes can be made only with the ConfigureDefender user interface. The "MAX" settings are intended to protect children and casual users but can be also used (with some modifications) to maximize the protection. This protection level usually generates more false positives compared to the "HIGH" settings and may require more user knowledge or skill.'
_ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.9)
Local $x = _ExtMsgBox(0,"&CLOSE|NEXT", "ConfigureDefender HELP 1/4", $help0)
If $x < 2 Then Return
If $x >= 2 Then Help1()
EndFunc


Func Help1()
Local $help1 = 'ConfigureDefender custom settings.' & @Crlf & 'You may customize your configuration by choosing any of the three Protection Levels and then change individual features.' & @Crlf & @Crlf & 'How to apply the settings.' & @Crlf & 'Select a Protection Level or custom configuration, press the "Refresh" green button and let ConfigureDefender confirm the changes. ConfigureDefender will alert if any of your changes have been blocked. Reboot to apply chosen protection.' & @Crlf & @Crlf & 'Audit mode.' & @Crlf & 'Many ConfigureDefender options can be set to "Audit". In this setting, Windows Defender will log events and warn the user about processes which would otherwise be blocked with this setting "ON". This feature is available for users to check for software incompatibilities with applied Defender settings. The user can avoid incompatibilities by adding software exclusions for ASR rules and Controlled Folder Access.' & @Crlf & @Crlf & 'Defender Security Log.' & @Crlf & 'This option can gather the last 200 entries from the Windows Defender Antivirus events. These entries are reformated and displayed in the notepad. The following event IDs are included: 1006, 1008, 1015, 1116, 1118, 1119, 1121, 1122, 1123, 1124, 1125, 1126, 1127, 1128, 3002, 5001, 5004, 5007, 5008, 5010, 5012. Inspecting the log can be useful when a process or file execution has been blocked by Windows Defender Exploit Guard.' & @Crlf & @Crlf

_ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
Local $x = _ExtMsgBox(0,"&CLOSE|NEXT|BACK", "ConfigureDefender HELP 2/4", $help1)
If $x < 2 Then Return
If $x = 2 Then Help2()
If $x > 2 Then HelpDefenderSettings()
EndFunc


Func Help2()

Local $text1 = "ConfigureDefender works on Windows 10. Windows 8.1 and earlier versions are not supported. Microsoft has added new Windows Defender features with successive Windows 10 feature updates. Below is the list of ConfigureDefender features available on different versions of Windows 10:"

Local $Text2 = "At least Windows 10" & @CRLF & "Real-time Monitoring, Cloud-delivered Protection, Cloud Protection Level (Default), Cloud Check Time Limit, Automatic Sample Submission, Behavior Monitoring, Scan all downloaded files and attachments, Average CPU Load while scanning, PUA Protection."

Local $Text3 = "At least Windows 10, version 1607 (Anniversary Update)" & @CRLF & "Block At First Sight"

Local $Text4 = "At least Windows 10, version 1703 (Anniversary Update)" & @CRLF & "Cloud Protection Level (High level for Windows Pro and Enterprise), Cloud Check Time Limit (Extended to 60s)."

Local $Text5 = "At least Windows 10, version 1709 (Creators Fall Update)" & @CRLF & "Attack Surface Reduction, Cloud Protection Level (extendend Levels for Windows Pro and Enterprise), Controlled Folder Access, Network Protection." & @CRLF

Local $help2 = $text1 & @CRLF & @CRLF & $text2 & @CRLF & @CRLF & $text3 & @CRLF & @CRLF & $text4 & @CRLF & @CRLF & $text5 
_ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
Local $x = _ExtMsgBox(0,"&CLOSE|NEXT|BACK", "ConfigureDefender HELP 3/4", $help2)
If $x < 2 Then Return
If $x = 2 Then Help3()
If $x > 2 Then Help1()
EndFunc

Func Help3()
$text1 = "Windows Defender stores its native settings under the registry key (owned by SYSTEM):" & @CRLF & "HKLM\SOFTWARE\Microsoft\Windows Defender" & @CRLF & "These can be changed when using PowerShell cmdlets. A few settings can be also changed from Windows Security Center."

$text2 = "Administrators can use Group Policy Management Console to apply policy settings for Windows Defender. They are stored under another registry key (policy key owned by ADMINISTRATORS):" & @CRLF & "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" & @CRLF & "Group Policy settings can override but do not change native Windows Defender settings. The native settings are automatically recovered when removing Group Policy settings."

$text3 = "The ConfigureDefender utility removes the settings made via direct registry editing under the policy key:" & @CRLF & "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" & @CRLF & "This is required because those settings would override ConfigureDefender settings."

$text4 = 'The ConfigureDefender utility may be used on all Windows 10 versions. But, on Windows Professional and Enterprise editions it will only work if your Administrator has not applied Defender policies by using another management tool, for example, Group Policy Management Console. These policies  are set to "Not configured" by default. If they have been changed by Administrator, thenthey should be reset to "Not configured". Group Policy settings may be found in Group Policy Management Console:' & @CRLF & "Computer configuration > Policies > Administrative templates > Windows components > Windows Defender Antivirus" & @CRLF & "The settings under the tabs: MAPS, MpEngine, Real-time Protection, Reporting Scan, Spynet, and Windows Defender Exploit Guard should be examined."

$text5 = 'Please note: Group Policy Refresh feature will override ConfigureDefender settings if Defender Group Policy settings are not reset to "Not configured"!' & @CRLF & 'ConfigureDefender should not be used to configure the settings, alongside other management tools deployed in Enterprises, like Intune or MDM CSPs.'

Local $help3 = $text1 & @CRLF & @CRLF & $text2 & @CRLF & @CRLF & $text3 & @CRLF & @CRLF & $text4 & @CRLF & @CRLF & $text5
;   $help = FileRead(@ScriptDir & "\ConfigureDefenderHelp1.txt")
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.8)
   Local $x = _ExtMsgBox(0,"&CLOSE|BACK", "ConfigureDefender HELP 4/4", $help3)
If $x < 2 Then Return
If $x >= 2 Then Help2()
EndFunc
