#RequireAdmin

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Icon=C:\Windows\Hard_Configurator\Icons\HFW2.ico
#AutoIt3Wrapper_Res_Comment=Utility for hardening Windows Firewall
#AutoIt3Wrapper_Res_Description=Utility for hardening Windows Firewall
#AutoIt3Wrapper_Res_Fileversion=1.0.1.1
#AutoIt3Wrapper_Res_LegalCopyright=
#AutoIt3Wrapper_Res_Field=|Firewall Hardening
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


#include <Array.au3>
#Include <File.au3>
#include <FileConstants.au3>
#include <GuiButton.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <StringConstants.au3>
#include <MsgBoxConstants.au3>
;#include <GuiEdit.au3>
#include <WindowsConstants.au3>

#include <Constants.au3>
#include <String.au3>
#include <Date.au3>
#Include <WinAPIEx.au3>

#include 'FWRule2Array.au3'
#include 'FirewallEvents.au3'
#include 'ExtMsgBox.au3'

Global $systemdrive = EnvGet('systemdrive')
Global $ARFWRulelistview
Global $ARFWRulelistGUI 
Global $MainFWKey = 'HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\FirewallRules'
Global $FWPart_GUID='{f016bbe0-a716-428b-822e-5E544B6A3'
Global $StartLogging = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\FirewallRules'
Global $SpacesAndStars = "                                                                             (***)  "
Local $_Array
Local $element


;GUISetState(@SW_HIDE,$listGUI)
;GUISetState(@SW_DISABLE, $listGUI)
Opt("GUIOnEventMode", 1)
;HideMainGUI()


;Test the Windows version
If not (@OSVersion="WIN_10" or  @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_Vista") Then
   _ExtMsgBox(0,"&OK", "Firewall Hardening", "This tool works only on Windows Vista and higher versions.")
EndIf

If (@ScriptName = 'FirewallHardening(x64).exe' And @OSArch = "X86") Then
   _ExtMsgBox(0,"&OK", "Firewall Hardening", "This file works only on 64-bit Windows version.")
   Exit
EndIf

If (@ScriptName = 'FirewallHardening(x86).exe' And @OSArch = "X64") Then
   _ExtMsgBox(0,"&OK", "Firewall Hardening", "This file works only on 32-bit Windows version.")
   Exit
EndIf



Global $NumberOfLOLBinsRules = 113
Global $arrFirewallLOLBins[$NumberOfLOLBinsRules+2] 
;Assign the names of blocked executables
$arrFirewallLOLBins[0] = $NumberOfLOLBinsRules+2
$arrFirewallLOLBins[1] = @ProgramFilesDir & '\windows nt\accessories\wordpad.exe'
$arrFirewallLOLBins[2] = @ProgramFilesDir & ' (x86)\windows nt\accessories\wordpad.exe'
$arrFirewallLOLBins[3] = @WindowsDir & '\explorer.exe'
$arrFirewallLOLBins[4] = @WindowsDir & '\hh.exe'
$arrFirewallLOLBins[5] = @WindowsDir & '\Microsoft.NET\Framework\v2.0.50727\Dfsvc.exe'
$arrFirewallLOLBins[6] = @WindowsDir & '\Microsoft.NET\Framework64\v2.0.50727\Dfsvc.exe'
$arrFirewallLOLBins[7] = @WindowsDir & '\Microsoft.NET\Framework\v4.0.30319\Dfsvc.exe'
$arrFirewallLOLBins[8] = @WindowsDir & '\Microsoft.NET\Framework64\v4.0.30319\Dfsvc.exe'
$arrFirewallLOLBins[9] = @WindowsDir & '\Microsoft.NET\Framework\v2.0.50727\InstallUtil.exe'
$arrFirewallLOLBins[10] = @WindowsDir & '\Microsoft.NET\Framework64\v2.0.50727\InstallUtil.exe'
$arrFirewallLOLBins[11] = @WindowsDir & '\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe'
$arrFirewallLOLBins[12] = @WindowsDir & '\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe'
$arrFirewallLOLBins[13] = @WindowsDir & '\Microsoft.NET\Framework\v2.0.50727\Msbuild.exe'
$arrFirewallLOLBins[14] = @WindowsDir & '\Microsoft.NET\Framework64\v2.0.50727\Msbuild.exe'
$arrFirewallLOLBins[15] = @WindowsDir & '\Microsoft.NET\Framework\v3.5\Msbuild.exe'
$arrFirewallLOLBins[16] = @WindowsDir & '\Microsoft.NET\Framework64\v3.5\Msbuild.exe'
$arrFirewallLOLBins[17] = @WindowsDir & '\Microsoft.NET\Framework\v4.0.30319\Msbuild.exe'
$arrFirewallLOLBins[18] = @WindowsDir & '\Microsoft.NET\Framework64\v4.0.30319\Msbuild.exe'
$arrFirewallLOLBins[19] = @WindowsDir & '\Microsoft.NET\Framework\v2.0.50727\regasm.exe'
$arrFirewallLOLBins[20] = @WindowsDir & '\Microsoft.NET\Framework64\v2.0.50727\regasm.exe'
$arrFirewallLOLBins[21] = @WindowsDir & '\Microsoft.NET\Framework\v4.0.30319\regasm.exe'
$arrFirewallLOLBins[22] = @WindowsDir & '\Microsoft.NET\Framework64\v4.0.30319\regasm.exe'
$arrFirewallLOLBins[23] = @WindowsDir & '\Microsoft.NET\Framework\v2.0.50727\regsvcs.exe'
$arrFirewallLOLBins[24] = @WindowsDir & '\Microsoft.NET\Framework64\v2.0.50727\regsvcs.exe'
$arrFirewallLOLBins[25] = @WindowsDir & '\Microsoft.NET\Framework\v4.0.30319\regsvcs.exe'
$arrFirewallLOLBins[26] = @WindowsDir & '\Microsoft.NET\Framework64\v4.0.30319\regsvcs.exe'
$arrFirewallLOLBins[27] = @SystemDir & '\wbem\wmic.exe'
$arrFirewallLOLBins[28] = @WindowsDir & '\SysWOW64\wbem\wmic.exe'
$arrFirewallLOLBins[29] = @WindowsDir & '\SysWOW64\WindowsPowerShell\v1.0\powershell.exe'
$arrFirewallLOLBins[30] = @WindowsDir & '\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe'
$arrFirewallLOLBins[31] = @SystemDir & '\WindowsPowerShell\v1.0\powershell.exe'
$arrFirewallLOLBins[32] = @SystemDir & '\WindowsPowerShell\v1.0\powershell_ise.exe'
$arrFirewallLOLBins[33] = @SystemDir & '\bash.exe'
$arrFirewallLOLBins[34] = @SystemDir & '\Attrib.exe'
$arrFirewallLOLBins[35] = @SystemDir & '\Atbroker.exe'
$arrFirewallLOLBins[36] = @SystemDir & '\Certutil.exe'
$arrFirewallLOLBins[37] = @SystemDir & '\Cmstp.exe'
$arrFirewallLOLBins[38] = @SystemDir & '\CompatTelRunner.exe'
$arrFirewallLOLBins[39] = @SystemDir & '\control.exe'
$arrFirewallLOLBins[40] = @SystemDir & '\cscript.exe'
$arrFirewallLOLBins[41] = @SystemDir & '\ctfmon.exe'
$arrFirewallLOLBins[42] = @SystemDir & '\DeviceDisplayObjectProvider.exe'
$arrFirewallLOLBins[43] = @SystemDir & '\Dnscmd.exe'
$arrFirewallLOLBins[44] = @SystemDir & '\dwm.exe'
$arrFirewallLOLBins[45] = @SystemDir & '\eventvwr.exe'
$arrFirewallLOLBins[46] = @SystemDir & '\explorer.exe'
$arrFirewallLOLBins[47] = @SystemDir & '\hh.exe'
$arrFirewallLOLBins[48] = @SystemDir & '\Ie4uinit.exe'
$arrFirewallLOLBins[49] = @SystemDir & '\Ieexec.exe'
$arrFirewallLOLBins[50] = @SystemDir & '\Infdefaultinstall.exe'
$arrFirewallLOLBins[51] = @SystemDir & '\mmc.exe'
$arrFirewallLOLBins[52] = @SystemDir & '\mshta.exe' 
$arrFirewallLOLBins[53] = @SystemDir & '\msiexec.exe' 
$arrFirewallLOLBins[54] = @SystemDir & '\odbcconf.exe'
$arrFirewallLOLBins[55] = @SystemDir & '\PresentationHost.exe'
$arrFirewallLOLBins[56] = @SystemDir & '\regsvr32.exe'
$arrFirewallLOLBins[57] = @SystemDir & '\rundll32.exe'
$arrFirewallLOLBins[58] = @SystemDir & '\services.exe'
$arrFirewallLOLBins[59] = @SystemDir & '\SyncAppvPublishingServer.exe'
$arrFirewallLOLBins[60] = @SystemDir & '\telnet.exe'
$arrFirewallLOLBins[61] = @SystemDir & '\wininit.exe'
$arrFirewallLOLBins[62] = @SystemDir & '\winlogon.exe'
$arrFirewallLOLBins[63] = @SystemDir & '\wscript.exe'
$arrFirewallLOLBins[64] = @SystemDir & '\wsmprovhost.exe'
$arrFirewallLOLBins[65] = @WindowsDir & '\SysWOW64' & '\Attrib.exe'
$arrFirewallLOLBins[66] = @WindowsDir & '\SysWOW64' & '\Atbroker.exe'
$arrFirewallLOLBins[67] = @WindowsDir & '\SysWOW64' & '\Certutil.exe'
$arrFirewallLOLBins[68] = @WindowsDir & '\SysWOW64' & '\Cmstp.exe'
$arrFirewallLOLBins[69] = @WindowsDir & '\SysWOW64' & '\control.exe'
$arrFirewallLOLBins[70] = @WindowsDir & '\SysWOW64' & '\cscript.exe'
$arrFirewallLOLBins[71] = @WindowsDir & '\SysWOW64' & '\ctfmon.exe'
$arrFirewallLOLBins[72] = @WindowsDir & '\SysWOW64' & '\Dnscmd.exe'
$arrFirewallLOLBins[73] = @WindowsDir & '\SysWOW64' & '\dwm.exe'
$arrFirewallLOLBins[74] = @WindowsDir & '\SysWOW64' & '\eventvwr.exe'
$arrFirewallLOLBins[75] = @WindowsDir & '\SysWOW64' & '\explorer.exe'
$arrFirewallLOLBins[76] = @WindowsDir & '\SysWOW64' & '\hh.exe'
$arrFirewallLOLBins[77] = @WindowsDir & '\SysWOW64' & '\Ie4uinit.exe'
$arrFirewallLOLBins[78] = @WindowsDir & '\SysWOW64' & '\Ieexec.exe'
$arrFirewallLOLBins[79] = @WindowsDir & '\SysWOW64' & '\Infdefaultinstall.exe'
$arrFirewallLOLBins[80] = @WindowsDir & '\SysWOW64' & '\mmc.exe'
$arrFirewallLOLBins[81] = @WindowsDir & '\SysWOW64' & '\mshta.exe' 
$arrFirewallLOLBins[82] = @WindowsDir & '\SysWOW64' & '\msiexec.exe' 
$arrFirewallLOLBins[83] = @WindowsDir & '\SysWOW64' & '\odbcconf.exe'
$arrFirewallLOLBins[84] = @WindowsDir & '\SysWOW64' & '\PresentationHost.exe'
$arrFirewallLOLBins[85] = @WindowsDir & '\SysWOW64' & '\regsvr32.exe'
$arrFirewallLOLBins[86] = @WindowsDir & '\SysWOW64' & '\rundll32.exe' 
$arrFirewallLOLBins[87] = @WindowsDir & '\SysWOW64' & '\SyncAppvPublishingServer.exe'
$arrFirewallLOLBins[88] = @WindowsDir & '\SysWOW64' & '\telnet.exe'
$arrFirewallLOLBins[89] = @WindowsDir & '\SysWOW64' & '\wscript.exe'
$arrFirewallLOLBins[90] = @WindowsDir & '\SysWOW64' & '\wsmprovhost.exe'
$arrFirewallLOLBins[91] = @SystemDir & '\esentutl.exe'
$arrFirewallLOLBins[92] = @WindowsDir & '\SysWOW64' & '\esentutl.exe'
$arrFirewallLOLBins[93] = @SystemDir & '\expand.exe'
$arrFirewallLOLBins[94] = @WindowsDir & '\SysWOW64' & '\expand.exe'
$arrFirewallLOLBins[95] = @SystemDir & '\extrac32.exe'
$arrFirewallLOLBins[96] = @WindowsDir & '\SysWOW64' & '\extrac32.exe'
$arrFirewallLOLBins[97] = @SystemDir & '\ftp.exe'
$arrFirewallLOLBins[98] = @WindowsDir & '\SysWOW64' & '\ftp.exe'
$arrFirewallLOLBins[99] = @SystemDir & '\lsass.exe'
$arrFirewallLOLBins[100] = @SystemDir & '\makecab.exe'
$arrFirewallLOLBins[101] = @WindowsDir & '\SysWOW64' & '\makecab.exe'
$arrFirewallLOLBins[102] = @SystemDir & '\pcalua.exe'
$arrFirewallLOLBins[103] = @SystemDir & '\print.exe'
$arrFirewallLOLBins[104] = @WindowsDir & '\SysWOW64' & '\print.exe'
$arrFirewallLOLBins[105] = @SystemDir & '\replace.exe'
$arrFirewallLOLBins[106] = @WindowsDir & '\SysWOW64' & '\replace.exe'
$arrFirewallLOLBins[107] = @SystemDir & '\ScriptRunner.exe'
$arrFirewallLOLBins[108] = @WindowsDir & '\SysWOW64' & '\ScriptRunner.exe'
$arrFirewallLOLBins[109] = @SystemDir & '\wbem' & '\scrcons.exe'
$arrFirewallLOLBins[110] = @SystemDir & '\tftp.exe'
$arrFirewallLOLBins[111] = @WindowsDir & '\SysWOW64' & '\tftp.exe'
$arrFirewallLOLBins[112] = @SystemDir & '\curl.exe'
$arrFirewallLOLBins[113] = @WindowsDir & '\SysWOW64' & '\curl.exe'

_ArraySort($arrFirewallLOLBins)
_ArrayPush($arrFirewallLOLBins, "")
;_ArrayDisplay($arrFirewallLOLBins)

If @OSArch = "X86" Then
   For $i=1 To $NumberOfLOLBinsRules
      If StringInStr($arrFirewallLOLBins[$i], @WindowsDir & '\SysWOW64\') = 1 Then $arrFirewallLOLBins[$i] = ""
      If StringInStr($arrFirewallLOLBins[$i], @WindowsDir & '\Microsoft.NET\Framework64\') = 1 Then $arrFirewallLOLBins[$i] = ""
      If StringInStr($arrFirewallLOLBins[$i], @ProgramFilesDir & ' (x86)\') = 1 Then $arrFirewallLOLBins[$i] = ""
   Next
   $arrFirewallLOLBins = _ArrayUnique($arrFirewallLOLBins)
   _ArraySort($arrFirewallLOLBins)
   _ArrayPush($arrFirewallLOLBins, "")
   _ArrayDelete($arrFirewallLOLBins, "1")
;   _ArrayDisplay($arrFirewallLOLBins)
EndIf

; Incompatibility with SmartScreen when blocking explorer.exe on Windows 8 and 8.1
If (@OSVersion="WIN_8" Or @OSVersion="WIN_81") Then 
   For $i=1 To $NumberOfLOLBinsRules
      If StringInStr($arrFirewallLOLBins[$i], @WindowsDir & '\explorer.exe') = 1 Then 
         $arrFirewallLOLBins[$i] = ""
         ExitLoop
      EndIf
   Next
   _ArraySort($arrFirewallLOLBins)
   _ArrayPush($arrFirewallLOLBins, "")
   _ArrayDelete($arrFirewallLOLBins, "1")
;   _ArrayDisplay($arrFirewallLOLBins)
EndIf

Global $NumberOf_H_C_Rules = 45
Global $arrFirewallH_C[$NumberOf_H_C_Rules+2]
$arrFirewallH_C[0] = $NumberOf_H_C_Rules+2
$arrFirewallH_C[1] = @ProgramFilesDir & '\windows nt\accessories\wordpad.exe'
$arrFirewallH_C[2] = @ProgramFilesDir & ' (x86)\windows nt\accessories\wordpad.exe'
$arrFirewallH_C[3] = @SystemDir & '\bash.exe'
$arrFirewallH_C[4] = @SystemDir & '\control.exe'
$arrFirewallH_C[5] = @WindowsDir & '\SysWOW64' & '\control.exe'
$arrFirewallH_C[6] = @SystemDir & '\cscript.exe'
$arrFirewallH_C[7] = @WindowsDir & '\SysWOW64' & '\cscript.exe'
$arrFirewallH_C[8] = @SystemDir & '\ctfmon.exe'
$arrFirewallH_C[9] = @WindowsDir & '\SysWOW64' & '\ctfmon.exe'
$arrFirewallH_C[10] = @SystemDir & '\Dnscmd.exe'
$arrFirewallH_C[11] = @WindowsDir & '\SysWOW64' & '\Dnscmd.exe'
$arrFirewallH_C[12] = @WindowsDir & '\hh.exe'
$arrFirewallH_C[13] = @SystemDir & '\hh.exe'
$arrFirewallH_C[14] = @WindowsDir & '\SysWOW64' & '\hh.exe'
$arrFirewallH_C[15] = @SystemDir & '\mmc.exe'
$arrFirewallH_C[16] = @WindowsDir & '\SysWOW64' & '\mmc.exe'
$arrFirewallH_C[17] = @SystemDir & '\mshta.exe'
$arrFirewallH_C[18] = @WindowsDir & '\SysWOW64' & '\mshta.exe'
$arrFirewallH_C[19] = @SystemDir & '\msiexec.exe'
$arrFirewallH_C[20] = @WindowsDir & '\SysWOW64' & '\msiexec.exe'
$arrFirewallH_C[21] = @SystemDir & '\regsvr32.exe'
$arrFirewallH_C[22] = @WindowsDir & '\SysWOW64' & '\regsvr32.exe'
$arrFirewallH_C[23] = @SystemDir & '\rundll32.exe'
$arrFirewallH_C[24] = @WindowsDir & '\SysWOW64' & '\rundll32.exe'
$arrFirewallH_C[25] = @SystemDir & '\wscript.exe'
$arrFirewallH_C[26] = @WindowsDir & '\SysWOW64' & '\wscript.exe'
$arrFirewallH_C[27] = @SystemDir & '\wbem' & '\scrcons.exe'
$arrFirewallH_C[28] = @SystemDir & '\wbem\wmic.exe'
$arrFirewallH_C[29] = @WindowsDir & '\SysWOW64\wbem\wmic.exe'
$arrFirewallH_C[30] = @WindowsDir & '\Microsoft.NET\Framework\v2.0.50727\regasm.exe'
$arrFirewallH_C[31] = @WindowsDir & '\Microsoft.NET\Framework64\v2.0.50727\regasm.exe'
$arrFirewallH_C[32] = @WindowsDir & '\Microsoft.NET\Framework\v4.0.30319\regasm.exe'
$arrFirewallH_C[33] = @WindowsDir & '\Microsoft.NET\Framework64\v4.0.30319\regasm.exe'
$arrFirewallH_C[34] = @WindowsDir & '\Microsoft.NET\Framework\v2.0.50727\regsvcs.exe'
$arrFirewallH_C[35] = @WindowsDir & '\Microsoft.NET\Framework64\v2.0.50727\regsvcs.exe'
$arrFirewallH_C[36] = @WindowsDir & '\Microsoft.NET\Framework\v4.0.30319\regsvcs.exe'
$arrFirewallH_C[37] = @WindowsDir & '\Microsoft.NET\Framework64\v4.0.30319\regsvcs.exe'
$arrFirewallH_C[38] = @SystemDir & '\WindowsPowerShell\v1.0\powershell.exe'
$arrFirewallH_C[39] = @SystemDir & '\WindowsPowerShell\v1.0\powershell_ise.exe'
$arrFirewallH_C[40] = @WindowsDir & '\SysWOW64\WindowsPowerShell\v1.0\powershell.exe'
$arrFirewallH_C[41] = @WindowsDir & '\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe'
$arrFirewallH_C[42] = @SystemDir & '\curl.exe'
$arrFirewallH_C[43] = @WindowsDir & '\SysWOW64\curl.exe'
$arrFirewallH_C[44] = @SystemDir & '\certutil.exe'
$arrFirewallH_C[45] = @WindowsDir & '\SysWOW64\certutil.exe'


_ArraySort($arrFirewallH_C)
_ArrayPush($arrFirewallH_C, "")

If @OSArch = "X86" Then
   For $i=1 To $NumberOf_H_C_Rules
      If StringInStr($arrFirewallH_C[$i], @WindowsDir & '\SysWOW64\') = 1 Then $arrFirewallH_C[$i] = ""
      If StringInStr($arrFirewallH_C[$i], @WindowsDir & '\Microsoft.NET\Framework64\') = 1 Then $arrFirewallH_C[$i] = ""
      If StringInStr($arrFirewallH_C[$i], @ProgramFilesDir & ' (x86)\') = 1 Then $arrFirewallH_C[$i] = ""
   Next
   $arrFirewallH_C = _ArrayUnique($arrFirewallH_C)
   _ArraySort($arrFirewallH_C)
   _ArrayPush($arrFirewallH_C, "")
   _ArrayDelete($arrFirewallH_C, "1")
;   _ArrayDisplay($arrFirewallH_C)
EndIf

$ARFWRulelistGUI = GUICreate("Firewall Rules", 670, 550)
GUISetBkColor(0xccccbb, $ARFWRulelistGUI)
GUISetFont(10, 300, 0, "", $ARFWRulelistGUI, 5)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseFWRule")
$ARFWRulelistview = GUICtrlCreateListView("" & @CRLF, 10, 10, 500, 450,  BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER, $LVS_REPORT))
_GUICtrlListView_SetColumnWidth($ARFWRulelistview, 0, 1300)
_GUICtrlListView_SetBkColor($ARFWRulelistview, 0xF0F0F0)
_GUICtrlListView_SetTextBkColor($ARFWRulelistview, 0xF0F0F0)


Local $sMessage = "Initializing Firewall Hardening tool. Please wait."
SplashTextOn("Warning", $sMessage, 300, 40, -1, -1, 1, "", 10)
  $_Array = FWRule2Array()
  $_Array = _ArrayUnique ($_Array)
  _ArrayDelete ($_Array, 0)
  _ArraySort ($_Array)
While UBound($_Array) > 0 
;  _ArrayDisplay($_Array)
     $element = _ArrayPop($_Array)
;     If _GUICtrlListView_FindItem ($ARFWRulelistview, -1, $element) = 0 Then
        GUICtrlCreateListViewItem($element, $ARFWRulelistview)
;     EndIf
WEnd
       _GUICtrlListView_SimpleSort ($ARFWRulelistview, False, 0, False)
;       _GUICtrlListView_SortItems ($ARFWRulelistview, 1 )
_GUICtrlListView_SetItemSelected($ARFWRulelistview, -1, False)
SplashOFF()

  Global $BtnHelp = GUICtrlCreateButton("Help", 445+90, 35, 100, 30)
  GUICtrlSetBkColor($BtnHelp, 0xbbbbff)
  GUICtrlSetOnEvent($BtnHelp, "Help1")

;   Create a label
  Global $LOLBinsLabel = GUICtrlCreateLabel("LOLBins", 440+90, 85, 150, 16,$SS_LEFT,-1)
  GUICtrlSetFont ( $LOLBinsLabel, 9, 500)

  Global $BtnAddLOLBins = GUICtrlCreateButton("ADD", 440+90, 105, 40, 25)
  GUICtrlSetBkColor($BtnAddLOLBins, 0x00dd44)
  GUICtrlSetOnEvent($BtnAddLOLBins, "AddLOLBins")
  GUICtrlSetFont ( $BtnAddLOLBins, 8, 500)

  Global $BtnRemoveLOLBins = GUICtrlCreateButton("REMOVE", 485+90, 105, 70, 25)
  GUICtrlSetBkColor($BtnRemoveLOLBins, 0xff9090)
  GUICtrlSetOnEvent($BtnRemoveLOLBins, "RemoveLOLBins")
  GUICtrlSetFont ( $BtnRemoveLOLBins, 8, 500)

;   Create a label
  Global $MSOfficeLabel = GUICtrlCreateLabel("MS Office", 440+90, 145, 100, 16,$SS_LEFT,-1)
  GUICtrlSetFont ( $MSOfficeLabel, 9, 500)

  Global $BtnAddMSOffice = GUICtrlCreateButton("ADD", 440+90, 165, 40, 25)
  GUICtrlSetBkColor($BtnAddMSOffice, 0x00dd44)
  GUICtrlSetOnEvent($BtnAddMSOffice, "AddMSOffice")
  GUICtrlSetFont ( $BtnAddMSOffice, 8, 500)

  Global $BtnRemoveMSOffice = GUICtrlCreateButton("REMOVE", 485+90, 165, 70, 25)
  GUICtrlSetBkColor($BtnRemoveMSOffice, 0xff9090)
  GUICtrlSetOnEvent($BtnRemoveMSOffice, "RemoveMSOffice")
  GUICtrlSetFont ( $BtnRemoveMSOffice, 8, 500)

;   Create a label
  Global $AAReaderLabel = GUICtrlCreateLabel("Adobe Acrobat Reader", 440+90, 205, 180, 16,$SS_LEFT,-1)
  GUICtrlSetFont ( $AAReaderLabel, 9, 500)

  Global $BtnAddAAReader = GUICtrlCreateButton("ADD", 440+90, 225, 40, 25)
  GUICtrlSetBkColor($BtnAddAAReader, 0x00dd44)
  GUICtrlSetOnEvent($BtnAddAAReader, "AddAAReader")
  GUICtrlSetFont ( $BtnAddAAReader, 8, 500)

  Global $BtnRemoveAAReader = GUICtrlCreateButton("REMOVE", 485+90, 225, 70, 25)
  GUICtrlSetBkColor($BtnRemoveAAReader, 0xff9090)
  GUICtrlSetOnEvent($BtnRemoveAAReader, "RemoveAAReader")
  GUICtrlSetFont ( $BtnRemoveAAReader, 8, 500)


;   Create a label
  Global $RecommendedBy_H_CLabel = GUICtrlCreateLabel("Recommended H_C", 440+90, 265, 130, 16,$SS_LEFT,-1)
  GUICtrlSetFont ($RecommendedBy_H_CLabel, 9, 500)

  Global $BtnAddRecommendedBy_H_C = GUICtrlCreateButton("ADD", 440+90, 285, 40, 25)
  GUICtrlSetBkColor($BtnAddRecommendedBy_H_C, 0x00dd44)
  GUICtrlSetOnEvent($BtnAddRecommendedBy_H_C, "AddRecommendedByH_C")
  GUICtrlSetFont ($BtnAddRecommendedBy_H_C, 8, 500)

  Global $BtnRemoveRecommendedBy_H_C = GUICtrlCreateButton("REMOVE", 485+90, 285, 70, 25)
  GUICtrlSetBkColor($BtnRemoveRecommendedBy_H_C, 0xff9090)
  GUICtrlSetOnEvent($BtnRemoveRecommendedBy_H_C, "RemoveRecommendedByH_C")
  GUICtrlSetFont ( $BtnRemoveRecommendedBy_H_C, 8, 500)

  Global $BtnAddFileFWRule = GUICtrlCreateButton("Add Rule", 20, 490, 70, 30)
  GUICtrlSetBkColor($BtnAddFileFWRule, 0x00dd44)
  GUICtrlSetOnEvent($BtnAddFileFWRule, "AddFileFWRule")

  Global $BtnAllowFWRule = GUICtrlCreateButton("Deactivate Rule", 100, 490, 100, 30)
  GUICtrlSetBkColor($BtnAllowFWRule, 0xcccccc)
  GUICtrlSetOnEvent($BtnAllowFWRule, "InactiveFWRule")

  Global $BtnBlockFWRule = GUICtrlCreateButton("Block Rule", 210, 490, 80, 30)
  GUICtrlSetBkColor($BtnBlockFWRule, 0x00dd44)
  GUICtrlSetOnEvent($BtnBlockFWRule, "BlockFWRule")

  Global $BtnRemoveFWRule = GUICtrlCreateButton("Remove Rule", 300, 490, 100, 30)
  GUICtrlSetBkColor($BtnRemoveFWRule, 0xff9090)
  GUICtrlSetOnEvent($BtnRemoveFWRule, "RemoveFWRule")

;   Create a label
  Global $StartLOG = GUICtrlCreateLabel("Start logging events", 440+90, 360, 150, 16,$SS_LEFT,-1)
  GUICtrlSetFont ($StartLOG , 9, 500)
  Global $idRadio1 = GUICtrlCreateRadio("OFF", 440+90, 380, 40, 20)
  GUICtrlSetOnEvent($idRadio1, "CheckStartLogging")

  Global $idRadio2 = GUICtrlCreateRadio("ON", 500+90, 380, 40, 20)
  GUICtrlSetOnEvent($idRadio2, "CheckStartLogging")

  Global $BtnSeeBlockedEvents = GUICtrlCreateButton("Blocked Events", 435+90, 410, 130, 30)
  GUICtrlSetBkColor($BtnSeeBlockedEvents, 0xbbbbff)
  GUICtrlSetOnEvent($BtnSeeBlockedEvents, "GetFirewallEvents")
  GUICtrlSetFont ($BtnSeeBlockedEvents, 10, 500)
  If RegRead($StartLogging, 'StartLogging') = 0 Then _GUICtrlButton_Enable($BtnSeeBlockedEvents, False)

  Global $BtnEndFWRule = GUICtrlCreateButton("Close", 450+90, 490, 100, 30)
  GUICtrlSetBkColor($BtnEndFWRule, 0xdcdcc0)
  GUICtrlSetOnEvent($BtnEndFWRule, "CloseFWRule")




While 1
  GUISetState(@SW_SHOW,$ARFWRulelistGUI)
  If RegRead($StartLogging, 'StartLogging') = '1' Then
     GUICtrlSetState($idRadio1, $GUI_UNCHECKED)
     GUICtrlSetState($idRadio2, $GUI_CHECKED)
  Else
     GUICtrlSetState($idRadio2, $GUI_UNCHECKED)
     GUICtrlSetState($idRadio1, $GUI_CHECKED)
  EndIf
Sleep(10)
WEnd


 ; ///// Functions

Func CloseFWRule()
   GuiDelete($ARFWRulelistGUI)
   Exit
EndFunc

Func FindFilePath()
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

    ; Create a constant variable in Local scope of the message to display in FileOpenDialog.
    Local $sMessage = "Select the file to be blacklisted."

    ; Display an open dialog to select a list of file(s).
    Local $sFileOpenDialog = FileOpenDialog($sMessage, $systemdrive & '\ProgramData', "All files (*.*)", $FD_FILEMUSTEXIST)
    If @error Then
        ; Display the error message.
        MsgBox(262144, "", "No file was selected." & $sFileOpenDialog)

        ; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
        FileChangeDir($systemdrive & '\ProgramData')
    Else
        ; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
        FileChangeDir($systemdrive & '\ProgramData')

        ; Replace instances of "|" with @CRLF in the string returned by FileOpenDialog.
        $sFileOpenDialog = StringReplace($sFileOpenDialog, "|", @CRLF)

        ; Display the list of selected files.
;        MsgBox($MB_SYSTEMMODAL, "", "You chose the following files:" & @CRLF & $sFileOpenDialog)
    EndIf
Return $sFileOpenDialog
EndFunc  



Func AddFileFWRule()
Local $FWPath=FindFilePath()
;MsgBox(262144,"", $FWPath)
Local $sToAdd = CalculateFilePathsFW($FWPath, $FWPart_GUID, 0)
If $sToAdd = "-1" Then
   MsgBox(262144,"",'This Path is already on the list.')
   Return
EndIf
If not ($sToAdd = "0") Then 
   GUICtrlCreateListViewItem("Block: " & $sToAdd, $ARFWRulelistview)
EndIf
EndFunc


Func AddFileFWRule1($path)
;MsgBox(262144,"", $path)
Local $sToAdd = CalculateFilePathsFW($path, $FWPart_GUID, 0)
If $sToAdd = "-1" Then
;   MsgBox(262144,"",'This Path is already on the list.')
   Return -1
EndIf
If not ($sToAdd = "0") Then 
   GUICtrlCreateListViewItem("Block: " & $sToAdd, $ARFWRulelistview)
EndIf
Return 0
EndFunc


Func RemoveFWRule()
Local $bArray
$bArray = _GUICtrlListView_GetSelectedIndices($ARFWRulelistview, True) 
;_ArrayDisplay($bArray)
Select
  case  $bArray[0] = 1 
    $bArray = _GUICtrlListView_GetSelectedIndices($ARFWRulelistview, True) 
    RemoveFWRule1($bArray[1])
  case $bArray[0] > 1 
    While $bArray[0] > 1
      $bArray = _GUICtrlListView_GetSelectedIndices($ARFWRulelistview, True) 
      RemoveFWRule1($bArray[1])
    WEnd
  case $bArray[0] = 0
        MsgBox(262144, "Selected Item", "Please choose non-empty item")
  case Else
        MsgBox(0,"Firewall rules", "Error. Cannot read the item from the list")
EndSelect
EndFunc


Func RemoveFWRule1($index)
;MsgBox(0,"",$index)
;It is not necessary to remove the pipe "|" from the end of the string
Local $rule = _GUICtrlListView_GetItem($ARFWRulelistview, $index)[3]
Local $item = StringRight($rule, 38)
If StringInStr($item, $FWPart_GUID) = 1 Then
    RegDelete($MainFWKey, $item)
    _GUICtrlListView_DeleteItem ($ARFWRulelistview, $index)
EndIf
EndFunc


Func BlockFWRule()
Local $bArray
$bArray = _GUICtrlListView_GetSelectedIndices($ARFWRulelistview, True) 
Select
  case  $bArray[0] = 1 
    $bArray = _GUICtrlListView_GetSelectedIndices($ARFWRulelistview, True) 
    BlockFWRule1($bArray[1])
  case $bArray[0] > 1 
    While $bArray[0] > 1
      $bArray = _GUICtrlListView_GetSelectedIndices($ARFWRulelistview, True) 
      BlockFWRule1($bArray[1])
    WEnd
  case $bArray[0] = 0
        MsgBox(262144, "Selected Item", "Please choose non-empty item")
  case Else
        MsgBox(0,"Firewall rules", "Error. Cannot read the item from the list")
EndSelect
_GUICtrlListView_SetItemSelected($ARFWRulelistview, -1, False)
EndFunc


Func BlockFWRule1($index)
;It is not necessary to remove the pipe "|" from the end of the string
Local $rule = _GUICtrlListView_GetItem($ARFWRulelistview, $index)[3]
Local $item = StringRight($rule, 38)
Local $sToAdd
;MsgBox(262144,"", $item)
If StringInStr($item, $FWPart_GUID) = 1 Then
    Local $temp = RegRead($MainFWKey, $item)
    $BlockFWRule = StringReplace($temp, "|Action=Allow|", "|Action=Block|")
    $BlockFWRule = StringReplace($BlockFWRule, "|Active=FALSE|", "|Active=TRUE|")
    RegDelete($MainFWKey, $item)
    RegWrite ($MainFWKey, $item, 'REG_SZ', $BlockFWRule)
    _GUICtrlListView_DeleteItem ($ARFWRulelistview, $index)
    $sToAdd = StringReplace($rule, "Inactive: ", "Block: ", 1)
    $sToAdd = StringReplace($sToAdd, "Allow: ", "Block: ", 1)
    GUICtrlCreateListViewItem($sToAdd, $ARFWRulelistview)
Else
    MsgBox(262144, "Selected Item", "Please choose non-empty item")
EndIf
EndFunc
  

Func InactiveFWRule()
Local $bArray
$bArray = _GUICtrlListView_GetSelectedIndices($ARFWRulelistview, True) 
Select
  case  $bArray[0] = 1 
    $bArray = _GUICtrlListView_GetSelectedIndices($ARFWRulelistview, True) 
    InactiveFWRule1($bArray[1])
  case $bArray[0] > 1 
    While $bArray[0] > 1
      $bArray = _GUICtrlListView_GetSelectedIndices($ARFWRulelistview, True) 
      InactiveFWRule1($bArray[1])
    WEnd
  case $bArray[0] = 0
        MsgBox(262144, "Selected Item", "Please choose non-empty item")
  case Else
        MsgBox(0,"Firewall rules", "Error. Cannot read the item from the list")
EndSelect
EndFunc


Func InactiveFWRule1($index)
;It is not necessary to remove the pipe "|" from the end of the string
Local $rule = _GUICtrlListView_GetItem($ARFWRulelistview, $index)[3]
Local $item = StringRight($rule, 38)
Local $sToAdd
If StringInStr($item, $FWPart_GUID) = 1 Then
    Local $temp = RegRead($MainFWKey, $item)
    Local $InactiveFWRule = StringReplace($temp, "|Active=TRUE|", "|Active=FALSE|")
    RegDelete($MainFWKey, $item)
    RegWrite ($MainFWKey, $item, 'REG_SZ', $InactiveFWRule)
    _GUICtrlListView_DeleteItem ($ARFWRulelistview, $index)
    $sToAdd = StringReplace($rule, "Block: ", "Inactive: ", 1)
    $sToAdd = StringReplace($sToAdd, "Allow: ", "Inactive: ", 1)
    GUICtrlCreateListViewItem($sToAdd, $ARFWRulelistview)
Else
    MsgBox(262144, "Selected Item", "Please choose non-empty item")
EndIf
EndFunc


;Func SearchWhitelistedFWRulesDuplicates ($itemnew)

; #include <MsgBoxConstants.au3>
;Local $sSubKey = ""
; For $i = 1 To 1000
;   $sSubKey = RegEnumKey($MainFWKey, $i)
;   If @error Then ExitLoop
;   Local $itemold = RegRead($MainFWKey & $sSubKey, 'ItemData')
;   If (StringInStr($itemold, $itemnew) = 1 ) And (StringInStr($itemnew, $itemold) = 1 ) Then
;;   MsgBox (0,"", StringInStr($itemold, $itemnew) & '    ' &  StringInStr($itemnew, $itemold))
;   Return '1'
;   EndIf
; Next
; Return '0'

;EndFunc


;Func ViewDuplicateFWRules()

;If UBound($FWRuleDuplicatesArray) > 1 Then
;    $FWRuleDuplicatesArray[0] = 'The Paths below are already on the list'
;    _ArrayDisplay($FWRuleDuplicatesArray)
;EndIf
;;Clear the $FWRuleDuplicatesArray
;While UBound($FWRuleDuplicatesArray) > 1
;  _ArrayPop($FWRuleDuplicatesArray)
;WEnd 

;EndFunc


Func RefreshAddRemoveFWRuleGUIWindow()
  GUISetState(@SW_HIDE,$ARFWRulelistGUI)
  GuiDelete($ARFWRulelistGUI)
  AddRemoveFWRule()
EndFunc


Func CalculateFilePathsFW($FWRule, $Part_GUID, $write2registry)
;MsgBox(0,"",$write2registry)
;MsgBox(0,"",$FWRule & @crlf & $Part_GUID & @crlf & $whitelist_Info)
;$DescriptionLabel variable is the Global variable defined in Autoruns() function !!!
#include <GUIConstantsEx.au3>
#include <StringConstants.au3>
#Include <File.au3>
#include <FileConstants.au3>
#RequireAdmin

Local $var[6]
;Select a file for adding to the block list
$var[0] = $FWRule
;MsgBox(262144,"calculate FW", $var[0])
If not ($var[0] = "") Then
;Get the filesize
        $var[1] = FileGetSize ($var[0])
;       MsgBox(262144,"", $var[0] & @CRLF & $var[1])
;Get the info about the file               
        Local $fileinfo = FileGetVersion ( $var[0], $FV_COMPANYNAME)
        $fileinfo =  $fileinfo & "   " & FileGetVersion ( $var[0], $FV_FILEDESCRIPTION)
        $var[2] =  $fileinfo & "   " & FileGetVersion ( $var[0], $FV_FILEVERSION)
;       MsgBox(262144,"", $var[2])
;Create new GUID
        Local $IsVal = RegEnumVal($MainFWKey, 1)
        Local $i = 1
        Local $n = 100
        While ($IsVal <> "")
            If $n > 999 Then
               MsgBox(262144,"ALERT", "There are too many policy Firewall rules")
               ExitLoop
            EndIf
            $IsVal = RegEnumVal($MainFWKey, $i)
            If @error Then ExitLoop  
;           MsgBox(262144,"", $Part_GUID & $n  & "}" & @CRLF & $MainFWKey & '\' & $IsVal)
            If $Part_GUID & $n & "}" = $IsVal Then
                $n = $n + 1
                $i = 0
            EndIf
            $i = $i + 1
;           MsgBox(262144,"", "$i = " & $i & @CRLF & "$n = " & $n)
        WEnd

;Here is the FWRule with the new GUID
        $var[5] = $Part_GUID & $n & '}'
;       MsgBox(262144,"Found the new GUID", $var[5])

;	Write data to the Registry
      Local $n = StringInStr(StringReverse ($var[0]),"\") -1
      Local $RuleName = "H_C rule for: " & StringRight($var[0], $n)
      Local $FirewallRule = "v2.29|Action=Block|Active=TRUE|Dir=Out|App="& $var[0] & "|Name=" & $RuleName & "|EmbedCtxt=H_C Firewall Rules|"
;  Check if similar rule exists under another GUID
   If SearchFWRuleDuplicates ($FirewallRule) = 0 Then
      If $write2registry = 0 Then RegWrite ($MainFWKey, $var[5], 'REG_SZ', $FirewallRule)
;      MsgBox("0","",RegRead ($var[5], 'ItemData'))
   Else
;;;    MsgBox(262144,"", 'This item is already on the list' & @CRLF & $var[0])
    Return '-1'
   EndIf

;Content of the added list item 
   If Stringlen($var[2]) > 200 Then $var[2] = StringLeft($var[2],200)
   Return $var[0] & $SpacesAndStars & $var[2] & '   REG = ' & $var[5]
EndIf
EndFunc 


Func SearchFWRuleDuplicates ($itemnew)
; $itemnew is a Firewall rule data under GUID in the Firewall policy key $MainFWKey
 #include <MsgBoxConstants.au3>
 Local $itemold
 Local $GUID = RegEnumVal($MainFWKey, 1)
 Local $n = 1
 $itemnew = StringReplace($itemnew, "|Action=Block|", "|Action=|")
 $itemnew = StringReplace($itemnew, "|Action=Allow|", "|Action=|")
 $itemnew = StringReplace($itemnew, "|Active=FALSE|", "|Active=|")
 $itemnew = StringReplace($itemnew, "|Active=TRUE|", "|Active=|")
 While $GUID <> ""
   $GUID = RegEnumVal($MainFWKey, $n)
   $itemold = RegRead($MainFWKey, $GUID)
   $itemold = StringReplace($itemold, "|Action=Block|", "|Action=|")
   $itemold = StringReplace($itemold, "|Action=Allow|", "|Action=|")
   $itemold = StringReplace($itemold, "|Active=FALSE|", "|Active=|")
   $itemold = StringReplace($itemold, "|Active=TRUE|", "|Active=|")

   If $itemold = $itemnew Then
;      MsgBox (0,"", StringInStr($itemold, $itemnew) & '    ' &  StringInStr($itemnew, $itemold))
      Return '1'
   EndIf
   $n = $n + 1
 WEnd
 Return '0'
EndFunc


Func DeleteFW_GUIDs($_item)
;Deletes the entries (GUIDs) from the Policy Firewall key if the 'Description' value contains the string = $_item
#include <MsgBoxConstants.au3>
#include <Array.au3> ; Required for _ArrayDisplay() only.

Local $hArray[1] =[""]
Local $n = 1
Local $sSubVal = RegEnumVal($MainFWKey, 1)
While $sSubVal <> ""
  $sSubVal = RegEnumVal($MainFWKey, $n)
  If StringInStr($sSubVal, $_item) > 0 Then _ArrayAdd($hArray, $sSubVal)
    $n = $n + 1
WEnd
;_ArrayDisplay($hArray)
If UBound($hArray) < 2 Then Return
For $n=1 to UBound($hArray)-1
  RegDelete($MainFWKey, $hArray[$n])
Next

EndFunc


Func AddLOLBins()
Local $failure = 0
Local $n = 1
Local $sMessage = "Writing firewall rules."
SplashTextOn("Firewall rules", $sMessage, 300, 40, -1, -1, 1, "", 10)
;_ArraySort($arrFirewallLOLBins)
 While $arrFirewallLOLBins[$n] <> ""
   $failure = AddFileFWRule1($arrFirewallLOLBins[$n]) + $failure
   $n=$n+1
 WEnd
SplashOff()
If $failure < 0 Then MsgBox(0,"", "Some rules are already on the list")
EndFunc


Func RemoveLOLBins()
Local $index
Local $n = 1
While $arrFirewallLOLBins[$n] <> ""
   $index = _GUICtrlListView_FindInText($ARFWRulelistview, $arrFirewallLOLBins[$n])
   RemoveFWRule1($index)
   $n=$n+1
WEnd
EndFUnc


Func AddRecommendedByH_C()
Local $failure = 0
Local $n = 1
Local $sMessage = "Writing firewall rules."
SplashTextOn("Firewall rules", $sMessage, 300, 40, -1, -1, 1, "", 10)
;_ArraySort($arrFirewallH_C)
 While $arrFirewallH_C[$n] <> ""
   $failure = AddFileFWRule1($arrFirewallH_C[$n]) + $failure
   $n=$n+1
 WEnd
SplashOff()
If $failure < 0 Then MsgBox(0,"", "Some rules are already on the list")
EndFunc


Func RemoveRecommendedByH_C()
Local $index
Local $n = 1
While $arrFirewallH_C[$n] <> ""
   $index = _GUICtrlListView_FindInText($ARFWRulelistview, $arrFirewallH_C[$n])
   RemoveFWRule1($index)
   $n=$n+1
WEnd
EndFUnc





Func AddMSOffice()
 Local $path
 Local $pathExcel = RegRead('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\excel.exe', 'path')
 Local $pathPowerPnt = RegRead('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\powerpnt.exe', 'path')
 Local $pathWinword = RegRead('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\winword.exe', 'path')

 $path = $pathWinword & 'winword.exe'
 If FileExists($path) = 1 Then AddFileFWRule1($path)
 $path = $pathExcel & 'excel.exe'
 If FileExists($path) = 1 Then AddFileFWRule1($path)
 $path = $pathPowerPnt & 'powerpnt.exe'
 If FileExists($path) = 1 Then AddFileFWRule1($path)
 $path = @ProgramFilesDir & '\Common Files\Microsoft Shared\EQUATION\eqnedt32.exe'
 If FileExists($path) = 1 Then AddFileFWRule1($path)
 $path = @ProgramFilesDir & ' (x86)\Common Files\microsoft shared\EQUATION\eqnedt32.exe'
 If $pathExcel & $pathPowerPnt & $pathWinword = "" Then MsgBox(0, "Firewall Rules", "Cannot find the installation folder of MS Office applications.")
EndFUnc


Func RemoveMSOffice()
 Local $path
 Local $index
 Local $pathExcel = RegRead('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\excel.exe', 'path')
 Local $pathPowerPnt = RegRead('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\powerpnt.exe', 'path')
 Local $pathWinword = RegRead('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\winword.exe', 'path')
 $path = $pathWinword & 'winword.exe'
 $index = _GUICtrlListView_FindInText($ARFWRulelistview, $path)
 RemoveFWRule1($index)
 $path = $pathExcel & 'excel.exe'
 $index = _GUICtrlListView_FindInText($ARFWRulelistview, $path)
 RemoveFWRule1($index)
 $path = $pathPowerPnt & 'powerpnt.exe'
 $index = _GUICtrlListView_FindInText($ARFWRulelistview, $path)
 RemoveFWRule1($index)
 $path = @ProgramFilesDir & '\Common Files\Microsoft Shared\EQUATION\eqnedt32.exe'
 $index = _GUICtrlListView_FindInText($ARFWRulelistview, $path)
 RemoveFWRule1($index)
 $path = @ProgramFilesDir & ' (x86)\Common Files\microsoft shared\EQUATION\eqnedt32.exe'
 $index = _GUICtrlListView_FindInText($ARFWRulelistview, $path)
 RemoveFWRule1($index)
 If $pathExcel & $pathPowerPnt & $pathWinword = "" Then MsgBox(0, "Firewall Rules", "Cannot find the installation folder of MS Office applications.")
EndFunc


Func AddAAReader()
Local $path = RegRead('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\AcroRd32.exe', '')
If FileExists($path) = 1 Then
   AddFileFWRule1($path)
Else
   MsgBox(0, "Firewall Rules", "Cannot find the installation folder of Adobe Acrobat Reader.")
EndIf
EndFunc


Func RemoveAAReader()
Local $index
Local $path = RegRead('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\AcroRd32.exe', '')
If FileExists($path) = 1 Then
   $index = _GUICtrlListView_FindInText($ARFWRulelistview, $path)
   RemoveFWRule1($index)
Else
   MsgBox(0, "Firewall Rules", "Cannot find the installation folder of Adobe Acrobat Reader.")
EndIf
EndFUnc

Func CheckStartLogging()
; Logging of blocked connections by Windows Firewall (subcategory "Audit Filtering Platform Packet Drop")
;subcategory:"{0CCE9225-69AE-11D9-BED3-505054503030}"
;MsgBox(0,"",GUICtrlRead($idRadio1) & @crlf & GUICtrlRead($idRadio2))
Switch GUICtrlRead($idRadio2)
   case '1'
      RegWrite($StartLogging, 'StartLogging', 'REG_DWORD', Number('1'))
      Local $COMMAND1 = 'auditpol /set /subcategory:"{0CCE9225-69AE-11D9-BED3-505054503030}" /failure:enable'
;      Local $COMMAND1 = 'auditpol /set /subcategory:"{0CCE9226-69AE-11D9-BED3-505054503030}" /failure:enable'
      Run($COMMAND1, "", @SW_HIDE)
;     Setting the 2x default max size of the LOG File
      RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Security', 'MaxSize', 'REG_DWORD', Number('41943040'))
   case Else 
      RegDelete($StartLogging, 'StartLogging')
; Disable auditing subcategories "Audit Filtering Platform Packet Drop"
; The first was used in the version 1.0.0.1 and is not used in the higher versions.
      Local $COMMAND2 = 'auditpol /set /subcategory:"{0CCE9225-69AE-11D9-BED3-505054503030}" /failure:disable'
;      Local $COMMAND3 = 'auditpol /set /subcategory:"{0CCE9226-69AE-11D9-BED3-505054503030}" /failure:disable'
      Run($COMMAND2, "", @SW_HIDE)
;      Run($COMMAND3, "", @SW_HIDE)
;     Setting Windows default max size of the LOG File
      RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Security', 'MaxSize', 'REG_DWORD', Number('20971520'))
EndSwitch
If RegRead($StartLogging, 'StartLogging') = 0 Then 
   _GUICtrlButton_Enable($BtnSeeBlockedEvents, False)
Else
   _GUICtrlButton_Enable($BtnSeeBlockedEvents, True)
EndIf
EndFunc


Func Help1()
Local $text = "Firewall Hardening tool can apply and manage Outbound Block Rules in Windows Firewall by using Windows policies. The restart of Windows is required to apply the configuration changes." & @crlf & "The paths of blocked executables are displayed as a list. Each entry can be managed by using the buttons located at the bottom of the application GUI. The applied rules may be also viewed when using Windows Firewall Advanced settings, but can be managed only by Firewall Hardening tool, or by editing the Registry under the key:" & @crlf & "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\FirewallRules" & @crlf & @crlf & "<Add Rule> button allows adding the rule for any executable." & @crlf & @crlf & "<Deactivate Rule> button makes the highlighted rules inactive, but does not remove any rules." & @crlf & @crlf & "<Block Rule> button changes highlighted inactive rules to blocked." & @crlf & @crlf & "<Remove Rule> button removes highlighted rules from the list (and Windows Firewall settings)." & @crlf & @crlf & "The user can add/remove some predefined rules: 'LOLBins', 'MS Office', 'Adobe Acrobat Reader', 'Recommended H_C'. They are visible on the right of the application GUI." & @crlf & @crlf & "Press <NEXT> button to continue."

_ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.6)
Local $x = _ExtMsgBox(0,"CLOSE|&NEXT", "Firewall Hardening HELP", $text)
If $x < 2 Then Return
If $x = 2 Then Help2()
EndFunc


Func Help2()
Local $text = "'LOLBins' rules are related to Living Of The Land executables from system folders, which are known to be commonly abused by malc0ders." & @crlf & @crlf & "'MS Office' and 'Adobe Acrobat Reader' rules are related to Word, Excel, PowerPoint, Equation Editor, and Acrobat Reader applications." & @crlf & @crlf & "'Recommended H_C' rules are selected from the larger set of LOLBins rules. They are suited to users who installed Firewall Hardening tool as a part of Hard_Configurator Windows hardening application and applied the <Recommended Settings>." & @crlf & @crlf & "The user can enable auditing Windows Firewall with Advanced Security in category 'Object Access' and subcategory 'Audit Filtering Platform Connection'. This can be done by choosing the radio button 'ON', under 'Start logging events'." & @crlf & @crlf & "If auditing is enabled, then the blocked events can be filtered from Windows Event Log by 5157 Event Id. This can be done when pressing <Blocked Events> button, visible under the OFF/ON radio buttons. The Event Log file can store the entries from several hours (usually 24 hours). Please note, that some entries may be unrelated to Firewall Hardening tool, but to another security application installed in the system. Firewall Hardening tool can block only programs by path. These paths are listed in the main application window."

_ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.6)
Local $x = _ExtMsgBox(0,"&CLOSE|BACK", "Firewall Hardening HELP", $text)
If $x < 2 Then Return
If $x = 2 Then Help1()
EndFunc
