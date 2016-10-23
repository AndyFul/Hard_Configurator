#Include <Array.au3>
#include <ColorConstants.au3>
#include <Crypt.au3>
#include <EditConstants.au3>
#Include <File.au3>
#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>

#include 'AddRemoveHash.au3'
#include 'AddSRPExtension.au3'
#include 'DeleteSRPExtension.au3'
#include 'ExtMsgBox.au3'
#include 'Hash2Array.au3'
#include 'RASExecutableTypes.au3'
#include 'SRPExecutableTypes.au3'
#include 'StringSize.au3'
#Include 'XSkinModAF.au3'

#RequireAdmin

Opt("GUIOnEventMode", 1)

;GUI parameters
Global $MainGuiWidth = 690
Global $MainGuiHeight = 360
Global $ListwievColor = 0xDFDEE1
Global $GuiSkin = "MAmbre"
Global $ProgramFolder = @WindowsDir & "\Hard_Configurator\"
Global $SkinsFolder = @WindowsDir & "\Hard_Configurator\Skins\"
Global $HardConfigurator_IniFile = @WindowsDir & "\Hard_Configurator\Hard_Configurator.ini"
Global $DeltaX = 30
Global $DeltaY=0
Global $DeltaListview = 19
Global $ChangeGuiSkin =0

;Read the favourite skin or select "NoSkin" if error
Select
    case FileExists ($SkinsFolder) <> 1
       $GuiSkin = "NoSkin"
    case FileExists ($HardConfigurator_IniFile) <> 1
       $GuiSkin = "NoSkin"
;       MsgBox(0,"", "Cannot locate Hard_Configurator INI File")
    case else
       Local $x = FileReadLine ($HardConfigurator_IniFile,1) 
       Local $y = FileReadLine ($HardConfigurator_IniFile,2) 
       If abs(@error)=1 Then
           MsgBox(0,"", "Cannot read GUI Skin from Hard_Configurator INI File")
       Else
           $GuiSkin = StringReplace($x,"SKIN=","",1,0)
           $ListwievColor = StringReplace($y,"ListColor=","",1,0)
           If $GuiSkin = "NoSkin" Then $GuiSkin = "MAmbre"
       EndIf        
EndSelect


While 1
  MainGUI()
WEnd


 ; ----- GUIs
Func MainGUI()


GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close_Main") 

;Create GUI with Skin or Standard GUI on Skin error
If $GuiSkin = "NoSkin" Then
      Global $listGUI = GUICreate("Main Configurator", $MainGuiWidth, $MainGuiHeight, 100, 200, -1) 
;      GUICtrlSetDefBkColor(0xFF0000)
Else
;      MsgBox(0,"",$SkinsFolder & $GuiSkin)
      Global $listGUI = XSkinGUICreate( "Main Configurator", $MainGuiWidth, $MainGuiHeight, $SkinsFolder & $GuiSkin)
;      GUICtrlSetDefBkColor(0xFFEEcc)
      If $listGUI="NoSkin" Then $listGUI = GUICreate("Main Configurator", $MainGuiWidth, $MainGuiHeight, 100, 200, -1) 
EndIf 

GUISetState(@SW_ENABLE, $listGUI)

; Create 2 panel lists

; The color of list panels
$ListwievColor = Number($ListwievColor)

; Left list panel
Global $listview
$listview = GUICtrlCreateListView("VALUE", 10+$DeltaX, 44+$DeltaListview, 100, 180)
_GUICtrlListView_SetColumnWidth($listview, 0, 95)
_GUICtrlListView_SetBkColor($listview, $ListwievColor)
_GUICtrlListView_SetTextBkColor($Listview, $ListwievColor)

;Right list panel
Global $listview1
$listview1 = GUICtrlCreateListView("VALUE", 520+$DeltaX, 44+$DeltaListview, 100, 180)
_GUICtrlListView_SetColumnWidth($listview1, 0, 95)
_GUICtrlListView_SetBkColor($listview1, $ListwievColor)
_GUICtrlListView_SetTextBkColor($Listview1, $ListwievColor)

ShowRegistryTweaks()

;Create Main GUI Buttons 
  $BtnInstallSRP = GUICtrlCreateButton("(Re)Install SRP", 120+$DeltaX, 90, 140, 19)
;  GUICtrlSetColor ( $BtnInstallSRP, 0x000000 )
  GUICtrlSetOnEvent(-1, "SRP")
  $BtnHelpInstallSRP = GUICtrlCreateButton("Help", 270+$DeltaX, 90, 40, 19)
  GUICtrlSetOnEvent(-1,"Help1")

  $BtnSRPWhitelistByHash = GUICtrlCreateButton("SRP File Whitelist By Hash", 120+$DeltaX, 109, 140, 19)
  GUICtrlSetOnEvent(-1, "WhitelistByHash")
  $BtnHelpSRPWhitelistByHash = GUICtrlCreateButton("Help", 270+$DeltaX, 109, 40, 19)
  GUICtrlSetOnEvent(-1, "Help2")  

  $BtnViewSRPExtensions = GUICtrlCreateButton("SRP Extensions", 120+$DeltaX, 128, 140, 19)
  GUICtrlSetOnEvent(-1, "AddRemoveGui")
  $BtnHelpViewSRPExtensions = GUICtrlCreateButton("Help", 270+$DeltaX, 128, 40, 19)
  GUICtrlSetOnEvent(-1, "Help3")  

  $BtnSRPDefaultLevel = GUICtrlCreateButton("SRP Default Level", 120+$DeltaX, 147, 140, 19)
  GUICtrlSetOnEvent(-1, "DefaultLevel")
  $BtnHelpSRPDefaultLevel = GUICtrlCreateButton("Help", 270+$DeltaX, 147, 40, 19)
  GUICtrlSetOnEvent(-1, "Help4")  

  $BtnSRPTransparentEnabled = GUICtrlCreateButton("SRP Transparent Enabled", 120+$DeltaX, 166, 140, 19)
  GUICtrlSetOnEvent(-1, "TransparentEnabled")
  $BtnHelpSRPTransparentEnabled = GUICtrlCreateButton("Help", 270+$DeltaX, 166, 40, 19)
  GUICtrlSetOnEvent(-1, "Help5")  

  $BtnDefenderAntiPUA = GUICtrlCreateButton("Defender PUA Protection", 120+$DeltaX, 185, 140, 19)
  GUICtrlSetOnEvent(-1, "DefenderAntiPUA")
  $BtnHelpDefenderAntiPUA = GUICtrlCreateButton("Help", 270+$DeltaX, 185, 40, 19)
  GUICtrlSetOnEvent(-1, "Help6")

  $BtnDisableUntrustedFonts = GUICtrlCreateButton("Disable Untrusted Fonts", 120+$DeltaX, 204, 140, 19)
  GUICtrlSetOnEvent(-1, "DisableUntrustedFonts")
  $BtnHelpDisableUntrustedFonts = GUICtrlCreateButton("Help", 270+$DeltaX, 204, 40, 19)
  GUICtrlSetOnEvent(-1, "Help7")  
  
  $BtnNoRemovableDisksExecution = GUICtrlCreateButton("No Removable Disks Exec.", 370+$DeltaX, 90, 140, 19)
  GUICtrlSetOnEvent(-1, "NoRemovableDisksExecution")
  $BtnHelpNoRemovableDisksExecution = GUICtrlCreateButton("Help", 320+$DeltaX, 90, 40, 19)
  GUICtrlSetOnEvent(-1, "Help8")
 
  $BtnNoPowerShellExecution = GUICtrlCreateButton("No PowerShell Exec.", 370+$DeltaX, 109, 140, 19)
  GUICtrlSetOnEvent(-1, "NoPowerShellExecution")
  $BtnHelpNoPowerShellExecution = GUICtrlCreateButton("Help", 320+$DeltaX, 109, 40, 19)
  GUICtrlSetOnEvent(-1, "Help9")
   
  $BtnDisableCommandPrompt = GUICtrlCreateButton("Disable Command Prompt", 370+$DeltaX, 128, 140, 19)
  GUICtrlSetOnEvent(-1, "DisableCommandPrompt")
  $BtnHelpDisableCommandPrompt = GUICtrlCreateButton("Help", 320+$DeltaX, 128, 40, 19)
  GUICtrlSetOnEvent(-1, "HelpA")
     
  $BtnDisableWSH = GUICtrlCreateButton("Disable Win. Script Host", 370+$DeltaX, 147, 140, 19)
  GUICtrlSetOnEvent(-1, "DisableWSH")
  $BtnHelpDisableWSH = GUICtrlCreateButton("Help", 320+$DeltaX, 147, 40, 19)
  GUICtrlSetOnEvent(-1, "HelpB")
   
     
  $BtnHideRunAsAdmin = GUICtrlCreateButton("Hide  'Run As Administrator'", 370+$DeltaX, 166, 140, 19)
  GUICtrlSetOnEvent(-1, "HideRunAsAdmin")
  $BtnHelpHideRunAsAdmin = GUICtrlCreateButton("Help", 320+$DeltaX, 166, 40, 19)
  GUICtrlSetOnEvent(-1, "HelpC")  
  
  $BtnRunAsSmartScreen = GUICtrlCreateButton("Run As SmartScreen", 370+$DeltaX, 185, 140, 19)
  GUICtrlSetOnEvent(-1, "RunAsSmartScreen")
  $BtnHelpRunAsSmartScreen = GUICtrlCreateButton("Help", 320+$DeltaX, 185, 40, 19)
  GUICtrlSetOnEvent(-1, "HelpD")
 
  $BtnBlockRemoteAssistance = GUICtrlCreateButton("Block Remote Assistance", 370+$DeltaX, 204, 140, 19)
  GUICtrlSetOnEvent(-1, "BlockRemoteAssistance")
  $BtnHelpBlockRemoteAssistance = GUICtrlCreateButton("Help", 320+$DeltaX, 204, 40, 19)
  GUICtrlSetOnEvent(-1, "HelpE")

  $BtnWindowsDefaults = GUICtrlCreateButton("Turn OFF All Restrictions", 250, 260, 190, 25)
  GUICtrlSetOnEvent(-1, "TurnOFFAllRestrictions")
  
  $BtnTurnOnAllRestrictions = GUICtrlCreateButton("Turn ON All Restrictions", 220+$DeltaX, 295, 190, 25)
  GUICtrlSetOnEvent(-1, "TurnOnAllRestrictions")

 $BtnGuiSkin = GUICtrlCreateButton("GUI Skin", 20+$DeltaX, 295, 80, 25)
 GUICtrlSetOnEvent(-1, "ChangeGuiSkin")
 
 $BtnLoadDefaults = GUICtrlCreateButton("Load Defaults", 120+$DeltaX, 295, 80, 25)
 GUICtrlSetOnEvent(-1, "LoadDefaults") 
 
 $BtnSaveDefaults = GUICtrlCreateButton("Save Defaults", 430+$DeltaX, 295, 80, 25)
 GUICtrlSetOnEvent(-1, "SaveDefaults") 

; Disable some buttons for earlier Windows versions
If not (@OSVersion="WIN_10") Then
   _GUICtrlButton_Enable($BtnDisableUntrustedFonts, False)
   _GUICtrlButton_Enable($BtnHelpDisableUntrustedFonts, False)
EndIf

If not (@OSVersion="WIN_10" or  @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
   _GUICtrlButton_Enable($BtnRunAsSmartScreen, False)
   _GUICtrlButton_Enable($BtnHelpRunAsSmartScreen, False)
   _GUICtrlButton_Enable($BtnDefenderAntiPUA, False)
   _GUICtrlButton_Enable($BtnHelpDefenderAntiPUA, False)
EndIf

If not (@OSVersion="WIN_10" or  @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7") Then
   _GUICtrlButton_Enable($BtnNoRemovableDisksExecution, False)
   _GUICtrlButton_Enable($BtnHelpNoRemovableDisksExecution, False)
   _GUICtrlButton_Enable($BtnNoPowerShellExecution, False)
   _GUICtrlButton_Enable($BtnHelpNoPowerShellExecution, False)
EndIf

If not (@OSVersion="WIN_10" or  @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
   _GUICtrlButton_Enable($BtnHideRunAsAdmin, False)
   _GUICtrlButton_Enable($BtnHelpHideRunAsAdmin, False)
   _GUICtrlButton_Enable($BtnBlockRemoteAssistance, False)
   _GUICtrlButton_Enable($BtnHelpBlockRemoteAssistance, False)
EndIf

If $GuiSkin = "NoSkin" Then _GUICtrlButton_Enable($BtnGuiSkin, False)

$iClose = GUICtrlCreateButton("Close", 530+$DeltaX, 295, 80, 25)
GUICtrlSetOnEvent(-1, "On_Close_Main")  


;MsgBox(0,"", "Stan GUISkin = " & GUICtrlSetOnEvent(-1, "ChangeGuiSkin"))

GUISetState()

; Change GUI Skin
Do
    Until $ChangeGuiSkin = 1
GUIDelete()
$ChangeGuiSkin = 0

EndFunc



Func ShowRegistryTweaks()

;Clear Main GUI list panels
 _GUICtrlListView_DeleteAllItems($Listview)
 _GUICtrlListView_DeleteAllItems($Listview1)

;Read Rregistry keys to be tweaked

$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
$valuename = "DefaultLevel"
Global $SRPDefaultLevel = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $SRPDefaultLevel
   case 0 
      $SRPDefaultLevel = "White List"
   case 262144
      $SRPDefaultLevel = "Allow All"
   case 131072
      $SRPDefaultLevel = "Basic User"
   case Else 
      $SRPDefaultLevel = "?"
EndSwitch
If ($iskey = -1 or $iskey =1) Then $SRPDefaultLevel = "not found"


If ($SRPDefaultLevel = "White List" or $SRPDefaultLevel = "Allow All" or $SRPDefaultLevel = "Basic User") Then
     $isSRPinstalled = "Installed"
Else 
     $isSRPinstalled = "Not Installed"
EndIf


Local $_HashNumber = Ubound(Hash2Array())
;MsgBox(0,"",$_HashNumber)
If $SRPDefaultLevel = "Allow All" Then $_HashNumber = "OFF"

Local $_ExtensionsNumber = Ubound(Reg2Array())
If $SRPDefaultLevel = "Allow All" Then $_ExtensionsNumber = "OFF"

$valuename = "TransparentEnabled"
Global $SRPTransparentEnabled =  RegRead ( $keyname, $valuename )
$iskey = @error
Switch $SRPTransparentEnabled
   case 0 
      $SRPTransparentEnabled = "No Enforcement"
   case 1
      $SRPTransparentEnabled = "Skip DLLs"
   case 2
      $SRPTransparentEnabled = "Include DLLs"
  case Else 
      $SRPTransparentEnabled = "?"
EndSwitch
If ($iskey = -1 or $iskey =1) Then $SRPTransparentEnabled = "not found" 
If $SRPDefaultLevel = "Allow All" Then $SRPTransparentEnabled = "OFF"


$keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine'
$valuename = 'MpEnablePus'
Global $DefenderAntiPUA = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $DefenderAntiPUA
   case 1 
      $DefenderAntiPUA = "ON"
   case 0
      $DefenderAntiPUA = "OFF"
   case Else 
     $DefenderAntiPUA = "?"
EndSwitch
If ($iskey = -1 or $iskey =1) Then $DefenderAntiPUA = "not found" 

$keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\MitigationOptions'
$valuename = 'MitigationOptions_FontBocking'
Global $DisableUntrustedFonts = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $DisableUntrustedFonts
   case 1000000000000 
      $DisableUntrustedFonts = "ON"
   case 2000000000000
      $DisableUntrustedFonts = "OFF"
   case 3000000000000
      $DisableUntrustedFonts = "AUDIT"
   case Else 
      $DisableUntrustedFonts = "?"
EndSwitch
If ($iskey = -1 or $iskey =1) Then $DisableUntrustedFonts = "not found" 


; Show settings values in the left list panel
  GUICtrlCreateListViewItem($isSRPinstalled, $listview)
  GUICtrlCreateListViewItem($_HashNumber, $listview)
  GUICtrlCreateListViewItem($_ExtensionsNumber, $listview)
  GUICtrlCreateListViewItem($SRPDefaultLevel, $listview)
  GUICtrlCreateListViewItem($SRPTransparentEnabled, $listview)
  GUICtrlCreateListViewItem($DefenderAntiPUA, $listview)
  GUICtrlCreateListViewItem($DisableUntrustedFonts, $listview)


$keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}'
$valuename = 'Deny_Execute'
Global $NoRemovableDisksExecution = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $NoRemovableDisksExecution
   case 0 
      $NoRemovableDisksExecution = "OFF"
   case 1
      $NoRemovableDisksExecution = "ON"
   case Else 
     $NoRemovableDisksExecution = "?"
EndSwitch
If ($iskey = -1 or $iskey =1) Then $NoRemovableDisksExecution = "not found" 



$keyname = 'HKLM\Software\Policies\Microsoft\Windows\PowerShell'
$valuename = 'EnableScripts'
Global $NoPowerShellExecution = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $NoPowerShellExecution
   case 1 
      $NoPowerShellExecution = "OFF"
   case 0
      $NoPowerShellExecution = "ON"
   case Else 
     $NoPowerShellExecution = "?"
EndSwitch
If ($iskey = -1 or $iskey =1) Then $NoPowerShellExecution = "not found" 


$keyname = 'HKCU\Software\Policies\Microsoft\Windows\System'
$valuename = 'DisableCMD'
Global $DisableCommandPrompt = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $DisableCommandPrompt
   case 1 
      $DisableCommandPrompt = "ON"
   case 0
      $DisableCommandPrompt = "OFF"
   case Else 
      $DisableCommandPrompt = "?"
EndSwitch
If ($iskey = -1 or $iskey =1) Then $DisableCommandPrompt = "not found" 


$keyname = 'HKLM\SOFTWARE\Microsoft\Windows Script Host\Settings'
$valuename = 'Enabled'
Global $DisableWSH = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $DisableWSH
   case 0 
      $DisableWSH = "ON"
   case 1
      $DisableWSH = "OFF"
   case Else 
     $DisableWSH = "?"
EndSwitch
If ($iskey = -1 or $iskey =1) Then $DisableWSH = "not found" 


$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$valuename = "HideRunAsVerb"
Global $HideRunAsAdmin = RegRead ( $keyname, $valuename )
$iskey = @error
Switch $HideRunAsAdmin
   case 0 
      $HideRunAsAdmin = "OFF"
   case 1
      $HideRunAsAdmin = "ON"
   case Else 
      $HideRunAsAdmin = "?"
EndSwitch
If ($iskey = -1 or $iskey =1) Then $HideRunAsAdmin = "not found" 


$keyname = "HKEY_CLASSES_ROOT\*\shell\Run As SmartScreen\command"
$valuename = ""
Global $RunAsSmartScreen = RegRead ( $keyname, $valuename )
$iskey = @error
select 
   case $RunAsSmartScreen = @WindowsDir & '\Hard_Configurator\RunAsSmartscreen(x64).exe "%1" %*'
        $RunAsSmartScreen = "ON"
   case $RunAsSmartScreen = @WindowsDir & '\Hard_Configurator\RunAsSmartscreen(x86).exe "%1" %*'
        $RunAsSmartScreen = "ON"
   case ($iskey = -1 or $iskey = 1)
        $RunAsSmartScreen = "OFF"
   case Else 
        $RunAsSmartScreen = "?"
EndSelect


$keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
$valuename = 'fAllowUnsolicited'
$valuename1 = 'fAllowToGetHelp'
$valuename2 = 'fDenyTSConnections'
Global $BlockRemoteAssistance = RegRead ( $keyname, $valuename )
$iskey = @error
$BlockRemoteAssistance = $BlockRemoteAssistance & RegRead ( $keyname, $valuename1 )
$iskey = $iskey & @error
$BlockRemoteAssistance = $BlockRemoteAssistance & RegRead ( $keyname, $valuename2 )
$iskey = $iskey & @error
;MsgBox(0,"",$BlockRemoteAssistance & "    " & $iskey)
select 
   case $BlockRemoteAssistance = '001'
      $BlockRemoteAssistance = "ON"
   case ($iskey = '-1-1-1' or $BlockRemoteAssistance = '110')
      $BlockRemoteAssistance = "OFF"
   case Else 
      $BlockRemoteAssistance = "?"
EndSelect



; Show settings values in the right list panel
GUICtrlCreateListViewItem($NoRemovableDisksExecution, $listview1)
GUICtrlCreateListViewItem($NoPowerShellExecution, $listview1)
GUICtrlCreateListViewItem($DisableCommandPrompt, $listview1)
GUICtrlCreateListViewItem($DisableWSH, $listview1)
GUICtrlCreateListViewItem($HideRunAsAdmin, $listview1)
GUICtrlCreateListViewItem($RunAsSmartScreen, $listview1)
GUICtrlCreateListViewItem($BlockRemoteAssistance, $listview1)

EndFunc

 ; ///// Functions

; Help functions for Help Buttons

Func Help1()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\help1.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc  


Func Help2()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\help2.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc 


Func Help3()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\help3.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc  

Func Help4()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\help4.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc  

Func Help5()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\help5.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc  

Func Help6()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\help6.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc  

Func Help7()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\help7.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc  

Func Help8()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\help8.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
  _ExtMsgBox(0,"OK", "", $help)
EndFunc  

Func Help9()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\help9.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc  

Func HelpA()
  Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpA.txt")
;  MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc  

Func HelpB()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpB.txt")
;  MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc  

Func HelpC()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpC.txt")
;  MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc  

Func HelpD()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpD.txt")
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial",@DesktopWidth*0.75)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc  

Func HelpE()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpE.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc  

Func HelpF()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpF.txt")
;   MsgBox(0,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.7)
   _ExtMsgBox(0,"OK", "", $help)
EndFunc  


; Functions for Registry changing Buttons
  
Func DefaultLevel()
$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
$valuename = "DefaultLevel"
$SRPDefaultLevel = RegRead ( $keyname, $valuename )
Switch $SRPDefaultLevel
   case 0 
      $RegDataNew = 131072
   case 131072
      $RegDataNew = 262144
   case 262144
      $RegDataNew = 0
EndSwitch 

IF ($SRPDefaultLevel = 0 or $SRPDefaultLevel = 131072 or $SRPDefaultLevel = 262144) Then
    RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'DefaultLevel','REG_DWORD',  $RegDataNew)
Else
    MsgBox($MB_SYSTEMMODAL, "ALERT", "The value of SRP DefaultLevel value in the Registry is unusual." & @CRLF & "Please consider reinstalation of SRP!")
EndIf

If $RegDataNew  = 131072 Then RASExecutableTypes("full")
If ($RegDataNew  = 0 and $RunAsSmartScreen = "ON") Then RASExecutableTypes("light")

ShowRegistryTweaks()
 
EndFunc


Func TransparentEnabled()

$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
$valuename = "TransparentEnabled"
$SRPTransparentEnabled = RegRead ( $keyname, $valuename )
Switch $SRPTransparentEnabled
   case 0
      $RegDataNew = 1
   case 1
      $RegDataNew = 2
   case 2
      $RegDataNew = 0
EndSwitch 

IF ($SRPTransparentEnabled = 0 or $SRPTransparentEnabled = 1 or $SRPTransparentEnabled = 2) Then
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'TransparentEnabled','REG_DWORD',  $RegDataNew)
EndIf

ShowRegistryTweaks()
EndFunc


Func HideRunAsAdmin()

$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$valuename = "HideRunAsVerb"
$HideRunAsAdmin = RegRead ( $keyname, $valuename )
select 
   case $HideRunAsAdmin = 1
      $RegDataNew = 0
   case else 
      $RegDataNew = 1
EndSelect 

;%SystemRoot% folder should be whitelisted when RunAsAdmin is hided.
If not (RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{F38BF404-1D43-42F2-9305-67DE0B28FC23}', 'ItemData') ='%SystemRoot%' or  $RegDataNew = 0) Then
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{F38BF404-1D43-42F2-9305-67DE0B28FC23}', 'ItemData','REG_EXPAND_SZ','%SystemRoot%')
EndIf

RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer', 'HideRunAsVerb','REG_DWORD',  $RegDataNew)
MsgBox(0,"","You have to log out and log in again to save changes")

ShowRegistryTweaks()
EndFunc


Func RunAsSmartScreen()

Local $keyname = 'HKEY_CLASSES_ROOT\*\shell\Run As SmartScreen\command'
Local $valuename = ""
If @OSArch="X64" Then Local $value = @WindowsDir & '\Hard_Configurator\RunAsSmartscreen(x64).exe "%1" %*'
If @OSArch="X86" Then Local $value = @WindowsDir & '\Hard_Configurator\RunAsSmartscreen(x86).exe "%1" %*'
Local $keynameIcon = 'HKCR\*\shell\Run As SmartScreen'
Local $valueIcon = @WindowsDir & '\system32\SmartScreenSettings.exe'
Local $RunAsSmartScreen = RegRead ( $keyname, $valuename )
Local $iskey = @error 
RegDelete('HKEY_CLASSES_ROOT\*\shell\Run As SmartScreen')
Local $isSRP = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers", "DefaultLevel")
IF ($iskey = -1 or $iskey = 1) Then 
     RegWrite($keynameIcon, 'Icon','REG_SZ',$valueIcon)
     RegWrite($keyname, '','REG_SZ',$value)
     RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer','SmartScreenEnabled','REG_SZ','Prompt') 
     If $isSRP = 0 Then
         RASExecutableTypes("light")
     EndIf
Else
     MsgBox(0,"", "SmartScreen Filter is still turned ON. It is not recommended to turn it OFF.")
EndIf
ShowRegistryTweaks()

EndFunc


Func WhitelistByHash()

#include <Array.au3>
#Include <File.au3>
#include <FileConstants.au3>
;#include <Crypt.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <StringConstants.au3>
AddRemoveHash()

EndFunc


Func NoRemovableDisksExecution()

Local $keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}'
Local $valuename = 'Deny_Execute'
Local $NoRemovableDisksExec = RegRead ( $keyname, $valuename )
select 
   case $NoRemovableDisksExec = 1
      $RegDataNew = 0
   case else 
      $RegDataNew = 1
EndSelect 
RegWrite($keyname , $valuename,'REG_DWORD',  $RegDataNew)
MsgBox(0,"","You have to unplug removable storage devices, and log out to make this option work.")
ShowRegistryTweaks()

EndFunc


Func NoPowerShellExecution()

Local $keyname = 'HKLM\Software\Policies\Microsoft\Windows\PowerShell'
Local $valuename = 'EnableScripts'
Local $NoPowerShellExec = RegRead ( $keyname, $valuename )
select 
   case $NoPowerShellExec = 0
      $RegDataNew = 1
   case else 
      $RegDataNew = 0
EndSelect 
RegWrite($keyname , $valuename,'REG_DWORD',  $RegDataNew)
ShowRegistryTweaks()

EndFunc


Func DisableCommandPrompt()

Local $keyname = 'HKCU\Software\Policies\Microsoft\Windows\System'
Local $valuename = 'DisableCMD'
Local $DisableCommandPrompt = RegRead ( $keyname, $valuename )
select 
   case $DisableCommandPrompt = 1
      $RegDataNew = 0
   case else 
      $RegDataNew = 1
EndSelect 
RegWrite($keyname , $valuename,'REG_DWORD',  $RegDataNew)
ShowRegistryTweaks()

EndFunc


Func DisableWSH()

Local $keyname = 'HKLM\SOFTWARE\Microsoft\Windows Script Host\Settings'
Local $valuename = 'Enabled'
Local $DisableWSH = RegRead ($keyname, $valuename)
select 
   case $DisableWSH = 0
      $RegDataNew = 1
   case else 
      $RegDataNew = 0
EndSelect 
RegWrite($keyname, $valuename,'REG_DWORD',$RegDataNew)
ShowRegistryTweaks()

EndFunc


Func DisableUntrustedFonts()
Local $keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\MitigationOptions'
Local $valuename = 'MitigationOptions_FontBocking'
Local $DisableUntrustedFonts = RegRead ( $keyname, $valuename )
select 
   case $DisableUntrustedFonts = 1000000000000
      $RegDataNew = 2000000000000
   case $DisableUntrustedFonts = 2000000000000
      $RegDataNew = 3000000000000
case else 
      $RegDataNew = 1000000000000
EndSelect 
RegWrite($keyname, $valuename,'REG_SZ',$RegDataNew)
ShowRegistryTweaks()

EndFunc


Func DefenderAntiPUA()

Local $keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine'
Local $valuename = 'MpEnablePus'
Local $DefenderAntiPUA = RegRead ($keyname, $valuename)
select 
   case $DefenderAntiPUA = 1
      $RegDataNew = 0
   case else 
      $RegDataNew = 1
EndSelect 
RegWrite($keyname, $valuename,'REG_DWORD',$RegDataNew)
ShowRegistryTweaks()

EndFunc


Func BlockRemoteAssistance()

Local $keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
Local $valuename = 'fAllowUnsolicited'
Local $valuename1 = 'fAllowToGetHelp'
Local $valuename2 = 'fDenyTSConnections'

select 
    case $BlockRemoteAssistance = "ON"
           RegWrite($keyname, $valuename,'REG_DWORD',Number('1'))
           RegWrite($keyname, $valuename1,'REG_DWORD',Number('1'))
           RegWrite($keyname, $valuename2,'REG_DWORD',Number('0'))
    case else
           RegWrite($keyname, $valuename,'REG_DWORD',Number('0'))
           RegWrite($keyname, $valuename1,'REG_DWORD',Number('0'))
           RegWrite($keyname, $valuename2,'REG_DWORD',Number('1'))
EndSelect 	   
ShowRegistryTweaks()

EndFunc


Func TurnOFFAllRestrictions()

RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'DefaultLevel','REG_DWORD',Number('262144'))
RegWrite ( 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer', 'HideRunAsVerb','REG_DWORD',Number('0'))
RegDelete('HKEY_CLASSES_ROOT\*\shell\Run As SmartScreen')
RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine', 'MpEnablePus','REG_DWORD',Number('0'))
RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\MitigationOptions', 'MitigationOptions_FontBocking','REG_SZ','2000000000000')
RegWrite ( 'HKLM\SOFTWARE\Microsoft\Windows Script Host\Settings', 'Enabled','REG_DWORD',Number('1'))
RegWrite ( 'HKCU\Software\Policies\Microsoft\Windows\System', 'DisableCMD','REG_DWORD',Number('0'))
RegWrite ( 'HKLM\Software\Policies\Microsoft\Windows\PowerShell', 'EnableScripts','REG_DWORD',Number('1'))
RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}', 'Deny_Execute','REG_DWORD',Number('0'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fAllowUnsolicited','REG_DWORD',Number('1'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fAllowToGetHelp','REG_DWORD',Number('1'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fDenyTSConnections','REG_DWORD',Number('0'))
MsgBox(0,"", "SmartScreen Filter is still turned ON. It is not recommended to turn it OFF." & @CRLF & @CRLF & "Software Restriction Policies are inactive, but their registry keys have not been removed.")

ShowRegistryTweaks()

EndFunc


Func TurnOnAllRestrictions()

RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'DefaultLevel','REG_DWORD',Number('0'))
RegWrite ( 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer', 'HideRunAsVerb','REG_DWORD',Number('1'))
RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine', 'MpEnablePus','REG_DWORD',Number('1'))
RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\MitigationOptions', 'MitigationOptions_FontBocking','REG_SZ','1000000000000')
RegWrite ( 'HKLM\SOFTWARE\Microsoft\Windows Script Host\Settings', 'Enabled','REG_DWORD',Number('0'))
RegWrite ( 'HKCU\Software\Policies\Microsoft\Windows\System', 'DisableCMD','REG_DWORD',Number('1'))
RegWrite ( 'HKLM\Software\Policies\Microsoft\Windows\PowerShell', 'EnableScripts','REG_DWORD',Number('0'))
RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}', 'Deny_Execute','REG_DWORD',Number('1'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fAllowUnsolicited','REG_DWORD',Number('0'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fAllowToGetHelp','REG_DWORD',Number('0'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fDenyTSConnections','REG_DWORD',Number('1'))
RegDelete('HKEY_CLASSES_ROOT\*\shell\Run As SmartScreen')
RunAsSmartScreen()

ShowRegistryTweaks()
EndFunc


Func ChangeGuiSkin()
; Change GUI Skin. The Skins are predefined in @WindowsDir\Hard_Configurator\Skins\  folder.
; XSkin.au3 uses RGB for displaing GIU colors (can be edited in Skin.dat file for each Skin).
; Autoit Listview uses BGR (Blue Green Red) for displaying colors.
Switch $GuiSkin
      case "NoSkin"
      $GuiSkin = "MAmbre"
      case "MAmbre"
      $GuiSkin = "MsgPlus!"
;      $ListwievColor = 0xFFFBF0
      $ListwievColor = 0xECE7E1
   case  "MsgPlus!"
      $GuiSkin = "Mid_Gray"
      $ListwievColor = 0xDADEE1
   case "Mid_Gray"
      $GuiSkin = "Lizondo"
      $ListwievColor = 0xfdf0eb
   case "Lizondo"
      $GuiSkin = "DeFacto"
      $ListwievColor = 0xDDDEE1
   case "DeFacto"
      $GuiSkin = "Light-Green"
      $ListwievColor = 0xDEE1DA
   case "Light-Green"
      $GuiSkin = "Blue-line"
;      $ListwievColor = 0xCEDDB0
;      $ListwievColor = 0xCEDDB0
      $ListwievColor = 0xCED7B0
   case "Blue-line"
      $GuiSkin = "Blue-Gray"
;      $ListwievColor = 0xCEDDB0
;      $ListwievColor = 0xE7EDDC
      $ListwievColor = 0xE2E8D7
   case "Blue-Gray"
      $GuiSkin = "Carbon"
;      $ListwievColor = 0xE0E5E0
      $ListwievColor = 0xDCDCDD
   case "Carbon"
      $GuiSkin = "Gray-bar"
      $ListwievColor = 0xcccccc
   case "Gray-bar"
      $ListwievColor = 0xcccccc
      $GuiSkin = "DarkRed"
   case "DarkRed"
      $GuiSkin = "HeavenlyBodies"
      $ListwievColor = 0xddccaa
   case "HeavenlyBodies"
      $GuiSkin = "Leadore"
      $ListwievColor = 0xd3d6d9
   case "Leadore"
      $GuiSkin =  "Noir"
      $ListwievColor = 0xcccccc
   case "Noir"
      $GuiSkin = "Rezak"
      $ListwievColor = 0xE4E5E0
   case "Rezak"
      $GuiSkin = "Skilled"
      $ListwievColor = 0xcccccc
   case "Skilled"
      $GuiSkin = "Sleek"
      $ListwievColor = 0xbbbbbb
   case "Sleek"
      $GuiSkin = "MAmbre"
      $ListwievColor = 0xDFDEE1
   case else
       $GuiSkin = "NoSkin"
       $ListwievColor = 0xDFDEE1
EndSwitch
;_ExtMsgBox(0,"OK", "", "Zmiana GUI")
$ChangeGuiSkin = 1
EndFunc


Func SRP()
; (Re)Install Software Restriction Policies
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'DefaultLevel','REG_DWORD',Number('0'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'TransparentEnabled','REG_DWORD',Number('2'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'PolicyScope','REG_DWORD',Number('1'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'AuthenticodeEnabled','REG_DWORD',Number('0'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Hashes')
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths')
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\131072\Paths')
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\131072\UrlZones')
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{6D809377-6AF0-444B-8957-A3773F02200E}', 'Description','REG_SZ','Program Files on 64 bits')
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{6D809377-6AF0-444B-8957-A3773F02200E}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{6D809377-6AF0-444B-8957-A3773F02200E}', 'ItemData','REG_EXPAND_SZ','%ProgramW6432%')
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}', 'Description','REG_SZ','Program Files (x86) on 64 bits')
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}', 'ItemData','REG_EXPAND_SZ','%ProgramFiles(x86)%')
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{905E63B6-C1BF-494E-B29C-65B732D3D21A}', 'Description','REG_SZ','Program Files (default)')
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{905E63B6-C1BF-494E-B29C-65B732D3D21A}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{905E63B6-C1BF-494E-B29C-65B732D3D21A}', 'ItemData','REG_EXPAND_SZ','%ProgramFiles%')
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{F38BF404-1D43-42F2-9305-67DE0B28FC23}', 'Description','REG_SZ','Windows')
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{F38BF404-1D43-42F2-9305-67DE0B28FC23}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{F38BF404-1D43-42F2-9305-67DE0B28FC23}', 'ItemData','REG_EXPAND_SZ','%SystemRoot%')


; Write to Registry SRP Executable types without BAT, CMD, JSE, VBE if RunAsSmartScreen is active and
; SRP security level is "WhiteList"
$keyname = "HKEY_CLASSES_ROOT\*\shell\Run As SmartScreen\command"
$valuename = ""
$RunAsSmartScreen = RegRead ( $keyname, $valuename )

If ($RunAsSmartScreen = @WindowsDir & '\Hard_Configurator\RunAsSmartscreen(x64).exe "%1" %*' or $RunAsSmartScreen = @WindowsDir & '\Hard_Configurator\RunAsSmartscreen(x86).exe "%1" %*') Then
     SRPExecutableTypes("light")
Else
     SRPExecutableTypes("full")
EndIf

Local $sVar = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers", "ExecutableTypes")
MsgBox($MB_SYSTEMMODAL, "SRP Extensions:", $sVar)

ShowRegistryTweaks()

EndFunc


Func AddRemoveGui()
;GUI for Adding/Removing SRP Extensions
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
;#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)
Global $ARlistview
Global $ARlistGUI 
$ARlistGUI = GUICreate("SRP Extensions", 250, 500, 100, 100, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseExtensions")
$ARlistview = GUICtrlCreateListView("Extensions", 10, 10, 100, 450)
 _GUICtrlListView_SetColumnWidth($ARlistview, 0, 70)
  
Local $keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
Local $valuename = "ExecutableTypes"
Local $sVal = RegRead($keyname, $valuename)

If $sVal = "" Then MsgBox(0, "Alert", "Your list of SRP protected extensions is empty! Please consider to (Re)Install SRP.")

Local $_Array = Reg2Array()
_ArraySort($_Array,0)
Local $element
While UBound($_Array) > 0 
   $element = _ArrayPop($_Array)
   GUICtrlCreateListViewItem($element, $ARlistview)
WEnd

Global $BtnAddExtension = GUICtrlCreateButton("Add", 150, 15, 80, 30)
GUICtrlSetOnEvent(-1, "AddItem")
Global $BtnRemoveExtension = GUICtrlCreateButton("Remove", 150, 65, 80, 30)
GUICtrlSetOnEvent(-1, "RemoveItem")
Global $BtnEndExtensions = GUICtrlCreateButton("Close", 150, 400, 80, 30)
GUICtrlSetOnEvent(-1, "CloseExtensions")

GUISetState(@SW_SHOW)


EndFunc


Func CloseExtensions()
   GUISetState(@SW_HIDE)
   ShowRegistryTweaks()
EndFunc


Func AddItem()
; Add SRP extension
Local $sToAdd = InputBox("Add", "Enter Item Name", "")

;Check if the extension is OK, and if so, add it to the list 
Local $_aArray = Reg2Array()
Local $n = _ArraySearch($_aArray, $sToAdd) 
If not ($n > 0 or $sToAdd = "") Then
      GUICtrlCreateListViewItem($sToAdd, $ARlistview)
;     Local $hWndListView = GUICtrlGetHandle($ARlistview)
;     _GUICtrlListView_SimpleSort($hWndListView, False,1)
      AddSRPExtension($sToAdd)
Else
      If $n > 0 Then MsgBox(0, "ALERT", "The  " & '"' & $sToAdd & '"' & "  extension is already on the list!")
EndIf
EndFunc

Func RemoveItem()
;Remove SRP extension
  Local $sItem = GUICtrlRead(GUICtrlRead($ARlistview))
  $sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
  If not ($sItem = "") Then
     MsgBox(0, "Selected Item", $sItem)
     DeleteSRPExtension($sItem)
     local $n = _GUICtrlListView_FindText($ARlistview, $sItem)
     _GUICtrlListView_DeleteItem($ARlistview, $n) 
  Else
    MsgBox(0, "Selected Item", "Please chosoe non empty item")
  EndIf
EndFunc


Func LoadDefaults()

; Load default settings for all restrictions
$SRPDefaultLevel = FileReadLine(@WindowsDir & "\Hard_Configurator\Hard_Configurator.ini",3)
;MsgBox(0,"",@error)
If @error = 0 Then
   Local $canread = Abs(@error)
   Switch $SRPDefaultLevel
      case "White List" 
         RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'DefaultLevel','REG_DWORD',Number('0'))
      case "Allow All"
         RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'DefaultLevel','REG_DWORD',Number('262144'))
      case "Basic User"
         RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'DefaultLevel','REG_DWORD',Number('131072'))
      case Else 
         RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'DefaultLevel','REG_DWORD',Number('0'))
         MsgBox(0,"", "Wrong parametr. 'SRP Default Level' wil be set on 'White List'")
   EndSwitch

   $SRPTransparentEnabled = FileReadLine(@WindowsDir & "\Hard_Configurator\Hard_Configurator.ini",4)
   $canread = $canread + Abs(@error)
   Switch $SRPTransparentEnabled
      case "No Enforcement" 
         RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'TransparentEnabled','REG_DWORD',Number('0'))
      case "Skip DLLs"
         RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'TransparentEnabled','REG_DWORD',Number('1'))
      case "Include DLLs"
         RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'TransparentEnabled','REG_DWORD',Number('2'))
     case Else 
         RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'TransparentEnabled','REG_DWORD',Number('2'))
         MsgBox(0,"", "Wrong parametr. 'SRP Transparent Enabled' will be set on 'Include DLLs'")
   EndSwitch

   $DefenderAntiPUA =  FileReadLine(@WindowsDir & "\Hard_Configurator\Hard_Configurator.ini",5)
   $canread = $canread + Abs(@error)
   Switch $DefenderAntiPUA
      case "ON" 
         RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine', 'MpEnablePus','REG_DWORD',Number('1'))
      case "OFF"
         RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine', 'MpEnablePus','REG_DWORD',Number('0'))
      case Else 
        RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine', 'MpEnablePus','REG_DWORD',Number('1'))
        MsgBox(0,"", "Wrong parametr. 'Defender PUA Protection' will be set 'ON'")
   EndSwitch

   $DisableUntrustedFonts = FileReadLine(@WindowsDir & "\Hard_Configurator\Hard_Configurator.ini",6)
   $canread = $canread + Abs(@error)
   Switch $DisableUntrustedFonts
      case "ON"
         RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\MitigationOptions', 'MitigationOptions_FontBocking','REG_SZ','1000000000000')
      case "OFF"
         RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\MitigationOptions', 'MitigationOptions_FontBocking','REG_SZ','2000000000000')
      case "AUDIT"
         RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\MitigationOptions', 'MitigationOptions_FontBocking','REG_SZ','3000000000000')
      case Else 
         RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\MitigationOptions', 'MitigationOptions_FontBocking','REG_SZ','1000000000000')
         MsgBox(0,"", "Wrong parametr. 'Disable Untrusted Fonts' will be set 'ON'")
   EndSwitch

   $NoRemovableDisksExecution = FileReadLine(@WindowsDir & "\Hard_Configurator\Hard_Configurator.ini",7)
   $canread = $canread + Abs(@error)
   Switch $NoRemovableDisksExecution
      case "OFF"
         RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}', 'Deny_Execute','REG_DWORD',Number('0'))
      case "ON"
         RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}', 'Deny_Execute','REG_DWORD',Number('1'))
      case Else 
        RegWrite ( 'HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}', 'Deny_Execute','REG_DWORD',Number('1'))
        MsgBox(0,"", "Wrong parametr. 'No Removable Disks Exec.' will be set 'ON'")
   EndSwitch

   $NoPowerShellExecution = FileReadLine(@WindowsDir & "\Hard_Configurator\Hard_Configurator.ini",8)
   $canread = $canread + Abs(@error)
   Switch $NoPowerShellExecution
      case "OFF"
         RegWrite ( 'HKLM\Software\Policies\Microsoft\Windows\PowerShell', 'EnableScripts','REG_DWORD',Number('1'))
      case "ON"
         RegWrite ( 'HKLM\Software\Policies\Microsoft\Windows\PowerShell', 'EnableScripts','REG_DWORD',Number('0'))
      case Else 
        RegWrite ( 'HKLM\Software\Policies\Microsoft\Windows\PowerShell', 'EnableScripts','REG_DWORD',Number('0'))
        MsgBox(0,"", "Wrong parametr. 'No PowerShell Exec.' will be set 'ON'")
   EndSwitch

   $DisableCommandPrompt = FileReadLine(@WindowsDir & "\Hard_Configurator\Hard_Configurator.ini",9)
   $canread = $canread + Abs(@error)
   Switch $DisableCommandPrompt
      case "ON" 
         RegWrite ( 'HKCU\Software\Policies\Microsoft\Windows\System', 'DisableCMD','REG_DWORD',Number('1'))
      case "OFF"
         RegWrite ( 'HKCU\Software\Policies\Microsoft\Windows\System', 'DisableCMD','REG_DWORD',Number('0'))
      case Else 
        RegWrite ( 'HKCU\Software\Policies\Microsoft\Windows\System', 'DisableCMD','REG_DWORD',Number('1'))
        MsgBox(0,"", "Wrong parametr. 'Disable Command Prompt' will be set 'ON'")
   EndSwitch

   $DisableWSH = FileReadLine(@WindowsDir & "\Hard_Configurator\Hard_Configurator.ini",10)
   $canread = $canread + Abs(@error)
   Switch $DisableWSH
      case "ON"
         RegWrite ( 'HKLM\SOFTWARE\Microsoft\Windows Script Host\Settings', 'Enabled','REG_DWORD',Number('0'))
      case "OFF"
         RegWrite ( 'HKLM\SOFTWARE\Microsoft\Windows Script Host\Settings', 'Enabled','REG_DWORD',Number('1'))
      case Else 
         RegWrite ( 'HKLM\SOFTWARE\Microsoft\Windows Script Host\Settings', 'Enabled','REG_DWORD',Number('0'))
         MsgBox(0,"", "Wrong parametr. 'Disable Win. Script Host' will be set 'ON'")
   EndSwitch

   $HideRunAsAdmin = FileReadLine(@WindowsDir & "\Hard_Configurator\Hard_Configurator.ini",11)
   $canread = $canread + Abs(@error)
   Switch $HideRunAsAdmin
      case "OFF"
         RegWrite ( 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer', 'HideRunAsVerb','REG_DWORD',Number('0'))
      case "ON"
         RegWrite ( 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer', 'HideRunAsVerb','REG_DWORD',Number('1'))
      case Else 
         RegWrite ( 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer', 'HideRunAsVerb','REG_DWORD',Number('1'))
         MsgBox(0,"", "Wrong parametr. 'Hide Run As Administrator' will be set 'ON'")
   EndSwitch

   $RunAsSmartScreen = FileReadLine(@WindowsDir & "\Hard_Configurator\Hard_Configurator.ini",12)
   $canread = $canread + Abs(@error)
   Switch $RunAsSmartScreen
      case "OFF"
         RegDelete('HKEY_CLASSES_ROOT\*\shell\Run As SmartScreen')
      case "ON"
         RegDelete('HKEY_CLASSES_ROOT\*\shell\Run As SmartScreen')
         RunAsSmartScreen()
      case Else 
         RegDelete('HKEY_CLASSES_ROOT\*\shell\Run As SmartScreen')
         RunAsSmartScreen()
         MsgBox(0,"", "Wrong parametr. 'Run As SmartScreen' will be set 'ON'")
   EndSwitch

   $BlockRemoteAssistance = FileReadLine(@WindowsDir & "\Hard_Configurator\Hard_Configurator.ini",13)
   $canread = $canread + Abs(@error)
   select 
      case $BlockRemoteAssistance = 'ON'
         RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fAllowUnsolicited','REG_DWORD',Number('0'))
   RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fAllowToGetHelp','REG_DWORD',Number('0'))
   RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fDenyTSConnections','REG_DWORD',Number('1'))
     case "OFF" 
        RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fAllowUnsolicited','REG_DWORD',Number('1'))
        RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fAllowToGetHelp','REG_DWORD',Number('1'))
        RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fDenyTSConnections','REG_DWORD',Number('0'))
    case Else 
        RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fAllowUnsolicited','REG_DWORD',Number('0'))
        RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fAllowToGetHelp','REG_DWORD',Number('0'))
        RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services', 'fDenyTSConnections','REG_DWORD',Number('1'))
        MsgBox(0,"", "Wrong parametr. 'Block Remote Assistance' will be set 'ON'")
   EndSelect
   If $canread > 0 then MsgBox(0,"", "There were " & $canread & " errors when reading Defaults")
Else
   MsgBox(0, "", "Could not open the file Windows\Hard_Configurator\Hard_Configurator.ini - Defaults cannot be loaded.")   
EndIf
ShowRegistryTweaks()

EndFunc


Func SaveDefaults()
; Save actual settigs as defaults
If FileExists($HardConfigurator_IniFile) = 0 Then
    FileWrite($HardConfigurator_IniFile, "SKIN=" & $GuiSkin)
    For $i=2 to 13
       FileWrite ( $HardConfigurator_IniFile, @CRLF & @CRLF)
    Next
    MsgBox(0,"", "Hard_Configurator.ini file has been created")
EndIf
_FileWriteToLine ( $HardConfigurator_IniFile, 2, "ListColor=" & $ListwievColor, True)
_FileWriteToLine ( $HardConfigurator_IniFile, 3, $SRPDefaultLevel, True)
_FileWriteToLine ( $HardConfigurator_IniFile, 4, $SRPTransparentEnabled, True)
_FileWriteToLine ( $HardConfigurator_IniFile, 5, $DefenderAntiPUA, True)
_FileWriteToLine ( $HardConfigurator_IniFile, 6, $DisableUntrustedFonts, True)
_FileWriteToLine ( $HardConfigurator_IniFile, 7, $NoRemovableDisksExecution, True)
_FileWriteToLine ( $HardConfigurator_IniFile, 8, $NoPowerShellExecution, True)
_FileWriteToLine ( $HardConfigurator_IniFile, 9, $DisableCommandPrompt, True)
_FileWriteToLine ( $HardConfigurator_IniFile, 10, $DisableWSH, True)
_FileWriteToLine ( $HardConfigurator_IniFile, 11, $HideRunAsAdmin, True)
_FileWriteToLine ( $HardConfigurator_IniFile, 12, $RunAsSmartScreen, True)
_FileWriteToLine ( $HardConfigurator_IniFile, 13, $BlockRemoteAssistance, True)
MsgBox(0,"", "Configuration saved as default")
;MsgBox(0,"",FileRead($HardConfigurator_IniFile))

EndFunc


Func On_Close_Main()


If FileExists($HardConfigurator_IniFile) = 0 Then
    For $i=1 to 13
       FileWrite ( $HardConfigurator_IniFile, @CRLF & @CRLF)
Next
    MsgBox(0,"", "Hard_Configurator.ini file has been created")
EndIf
;MsgBox(0,"",$ListwievColor)
; Automatically save Skin settings on exit
_FileWriteToLine ( $HardConfigurator_IniFile, 1, "SKIN=" & $GuiSkin, True)
_FileWriteToLine ( $HardConfigurator_IniFile, 2, "ListColor=" & $ListwievColor, True)
Exit
EndFunc


