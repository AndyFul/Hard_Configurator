Func RefreshSavedWhitelistslistGUI()
  Local $pos = WinGetPos ($SavedWhitelistslistGUI)
  $X_SavedWhitelistslistGUI = $pos[0] 
  $Y_SavedWhitelistslistGUI = $pos[1]
  GUISetState(@SW_HIDE, $SavedWhitelistslistGUI)
  GuiDelete($SavedWhitelistslistGUI)
  SRPWhitelistSaveLoad()
EndFunc



Func SRPWhitelistSaveLoad()
Global $SavedWhitelistslistview
Global $SavedWhitelistslistGUI
Local $dx = 55

#include <Array.au3>
#Include <File.au3>
#include <FileConstants.au3>
;#include <Crypt.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <StringConstants.au3>
#include <MsgBoxConstants.au3>
;#include <GuiEdit.au3>
;#include <WindowsConstants.au3>

If $SRPDefaultLevel = "Allow All" Then
   MsgBox(262144,"","SRP are set to 'Allow All' security level, so all executables are allowed to run.")
EndIf

HideMainGUI()

If not ($X_SavedWhitelistslistGUI > 0) Then $X_SavedWhitelistslistGUI = -1
If not ($Y_SavedWhitelistslistGUI > 0) Then $Y_SavedWhitelistslistGUI = -1
$SavedWhitelistslistGUI = GUICreate("Saved White Lists", 510, 340, $X_SavedWhitelistslistGUI, $Y_SavedWhitelistslistGUI, -1, $WS_EX_ACCEPTFILES)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseSavedWhitelists")
$SavedWhitelistslistview = GUICtrlCreateListView("Whitelists", 10, 10, 300, 300)
_GUICtrlListView_SetColumnWidth($SavedWhitelistslistview, 0, 1300)

  
Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Hashes'

Local $_Array = SavedWhiteLists()
Local $element
_ArraySort ($_Array)
  While UBound($_Array) > 0 
     $element = _ArrayPop($_Array)
     GUICtrlCreateListViewItem($element, $SavedWhitelistslistview)
  WEnd

Global $BtnHelpWhitelistMenuSaveLoad = GUICtrlCreateButton("Help", 370, 15, 80, 30)
GUICtrlSetOnEvent(-1, "HelpWhitelistMenuSaveLoad")
Global $BtnSaveCurrentWhitelist = GUICtrlCreateButton("Save the current White List", 340, 15+$dx, 140, 30)
GUICtrlSetOnEvent(-1, "SRPWhitelistSave")
Global $BtnRemoveSavedWhitelist = GUICtrlCreateButton("Remove White List", 340, 65+$dx, 140, 30)
GUICtrlSetOnEvent(-1, "RemoveWhiteList")
Global $BtnLoadSavedWhitelist = GUICtrlCreateButton("Load White List", 340, 115+$dx, 140, 30)
GUICtrlSetOnEvent(-1, "SRPWhitelistLoad")
Global $BtnViewWhitelistInfo = GUICtrlCreateButton("View White List Info", 340, 165+$dx, 140, 30)
GUICtrlSetOnEvent(-1, "ViewWhitelistInfo")
Global $BtnEndHash = GUICtrlCreateButton("Close", 370, 280-5, 80, 30)
GUICtrlSetOnEvent(-1, "CloseSavedWhitelists")

GUISetState(@SW_SHOW,$SavedWhitelistslistGUI)

EndFunc

 ; ///// Functions

Func CloseSavedWhitelists()
   GuiDelete($SavedWhitelistslistGUI)
   ShowMainGUI()
   ShowRegistryTweaks()
EndFunc


Func ViewWhitelistInfo()

$NameOfWhitelist = GUICtrlRead(GUICtrlRead($SavedWhitelistslistview))
;Will remove the pipe "|" from the end of the string
$NameOfWhitelist = StringTrimRight($NameOfWhitelist, 1)
;MsgBox(262144,"",$NameOfWhitelist)
If not ($NameOfWhitelist="") Then 
   Local $keyWhitelist = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\Whitelist\'& $NameOfWhitelist
   $text = RegRead($keyWhitelist, 'text')
   $text = _HexToString($text)
;   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
;   _ExtMsgBox(0,"&OK", "", $text)
   MsgBox(262144,"", $text)
   Return
EndIf
MsgBox(262144,"", "Please, choose the right entry from the list.")
EndFunc


Func SRPWhitelistSave()
Local $text=""
HideMainGUI()

; Input for Whitelist name
$NameOfWhitelist = GUICtrlRead(GUICtrlRead($SavedWhitelistslistview))
;Will remove the pipe "|" from the end of the string
$NameOfWhitelist = StringTrimRight($NameOfWhitelist, 1)
;Global $NameOfWhitelist = InputBox ( "White List Name", "Please, write the name of the White List to save.")
If $NameOfWhitelist = "" Then 
   $NameOfWhitelist = InputBox ( "White List Name", "Please, write the name of the Whitelist to save.")
   If $NameOfWhitelist = "" Then Return
EndIf
;MsgBox(262144,"","")

Local $keyWhitelist = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\Whitelist\'& $NameOfWhitelist

; Get the info about the saved whitelist, if exist.
; $NameOfWhitelist = name of the whitelist
If not (RegEnumKey($keyWhitelist, 1) = 1 or RegEnumKey($keyWhitelist, 1) = 2) Then
  Local $text = RegRead($keyWhitelist, 'text')
  $text = _HexToString ($text)
EndIf
Local $sWow64 = ""
If @AutoItX64 Then $sWow64 = "\Wow6432Node"

; Create GUI
$EditWhitelistInfoGUI = GUICreate("Write the info about the White List to be saved.", 400, 330, -1, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseWhitelistEditInfo")

; Create Edit window
$EditWhitelistInfo = GUICtrlCreateEdit("", 2, 2, 394, 268, BitOR($ES_WANTRETURN, $WS_VSCROLL))

GUISetState(@SW_SHOW)
; Set Margins
_GUICtrlEdit_SetMargins($EditWhitelistInfo, BitOR($EC_LEFTMARGIN, $EC_RIGHTMARGIN), 10, 10)
; Set Text
If $text = "" Then 
   _GUICtrlEdit_SetText($EditWhitelistInfo, "" & @CRLF)
Else
   _GUICtrlEdit_SetText($EditWhitelistInfo, "")
EndIf
; Insert text
 _GUICtrlEdit_InsertText($EditWhitelistInfo, $text, 0)

; Create buttons
Local $BtnEditInfoHelp = GUICtrlCreateButton("Help",175, 285, 50, 30)
GUICtrlSetOnEvent(-1, "EditWhitelistInfoHelp")
Local $BtnCloseWhitelistEditInfo = GUICtrlCreateButton("OK", 330,  285, 50, 30)
GUICtrlSetOnEvent(-1, "CloseWhitelistEditInfo")

GUISetState(@SW_SHOW,$EditWhitelistInfoGUI)

EndFunc


Func EditWhitelistInfoHelp()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\helpWhitelistEditInfo.txt")
;   MsgBox(262144,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.41)
   _ExtMsgBox(0,"CLOSE", "", $help)
EndFunc


Func CloseWhitelistEditInfo()
    Local $ProfileInfoText = _GUICtrlEdit_GetText($EditWhitelistInfo) 
    Local $n = StringInStr ( $ProfileInfoText, @LF, 0 , 25) 
    Local $m = 0
    If $n > 0 Then 
       $ProfileInfoText = StringLeft($ProfileInfoText, $n)
       $m=1
    EndIf
    If StringLen($ProfileInfoText) > 1400 Then
       $ProfileInfoText = StringLeft($ProfileInfoText, '1400')
       $m = 1
    EndIf
    If $m = 1 Then MsgBox(262144,"","The info text too long. Only part of it will be saved.")
;    MsgBox(262144,"", $n & '   ' & $m & '   ' & StringLen($ProfileInfoText))
   GuiDelete($EditWhitelistInfoGUI)
;  Transfer the text Info Profile to the saving profile function
   SaveWhitelistDefaults($ProfileInfoText)
EndFunc


Func SaveWhitelistDefaults($ProfileInfo)
; Info about the profile embeded in $ProfileInfo, is saved in the binary form in the registry.
$ProfileInfo = _StringToHex($ProfileInfo)
;RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\Whitelist\'& $NameOfWhitelist, 'text', 'REG_SZ', $ProfileInfo) 
;Save actual settings for all restrictions as defaults
If ExportWhitelistRegSettings($ProfileInfo) = 'DoNotCreate' Then Return
MsgBox(262144,"", "White List saved successfully.")
RefreshSavedWhitelistslistGUI()
EndFunc


Func ExportWhitelistRegSettings($textsource)
Local $key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\Whitelist\'& $NameOfWhitelist
; $NameOfWhitelist = name of the whitelist
;MsgBox(262144,"",$NameOfWhitelist)
;MsgBox(262144,"",RegEnumKey($key, 1))
If (RegEnumKey($key, 1) = "Paths" or RegEnumKey($key, 1) = "Hashes") Then
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
   Local $y = _ExtMsgBox(0,"&OVERWRITE|CANCEL", "", 'The White List profile exists already. Do you want to overwrite it?')
   If $y = 2 Then Return 'DoNotCreate'
EndIf
Local $Export_Profile = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144'
RegDelete($key)
_RegCopyKey($Export_Profile, $key)
;Remove *Default System Space entries from the Whitelist saved in the Profile Base
RemoveSystemSpaceFromWhitelist($key)
RegWrite($key, 'text', 'REG_SZ', $textsource) 
;MsgBox(262144,"","")
Return ""
EndFunc


Func RemoveSystemSpaceFromWhitelist($NewWhitelistRegistryKey)
  RegDelete($NewWhitelistRegistryKey & '\' & 'Paths\' & '{6D809377-6AF0-444B-8957-A3773F02200E}')
  RegDelete($NewWhitelistRegistryKey & '\' & 'Paths\' & '{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}')
  RegDelete($NewWhitelistRegistryKey & '\' & 'Paths\' & '{f073d7e6-ec43-4bf6-a2a8-536eb63b03c8}')
  RegDelete($NewWhitelistRegistryKey & '\' & 'Paths\' & '{905E63B6-C1BF-494E-B29C-65B732D3D21A}')
  RegDelete($NewWhitelistRegistryKey & '\' & 'Paths\' & '{F38BF404-1D43-42F2-9305-67DE0B28FC23}')
EndFunc


Func RemoveWhiteList()

Local $item = GUICtrlRead(GUICtrlRead($SavedWhitelistslistview))
;Will remove the pipe "|" from the end of the string
$item = StringTrimRight($item, 1)
If $item = "" Then
   MsgBox(262144, "", "Please, choose non-empty item from the list.")
   Return
EndIf
Local $y = MsgBox(262145,"", "Do you want to remove  " & $item & "  White List?" )
If $y = 2 Then Return
If not ($item = "") Then
    RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\Whitelist' & '\' & $item)
    _GUICtrlListView_DeleteItemsSelected ($SavedWhitelistslistview)
Else
    MsgBox(262144, "Selected Item", "Please, choose non-empty item from the list.")
EndIf

EndFunc



Func SRPWhitelistLoad()

$NameOfWhitelist = GUICtrlRead(GUICtrlRead($SavedWhitelistslistview))
$NameOfWhitelist = StringTrimRight($NameOfWhitelist, 1)
Local $InputKey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\Whitelist\'& $NameOfWhitelist
;Will remove the pipe "|" from the end of the string
;MsgBox(262144,"",$NameOfWhitelist)
If not ($NameOfWhitelist = "") Then 
   If not (CheckWhitelistIntegrity($NameOfWhitelist) = '1') Then
      RegDelete($InputKey)
      RefreshSavedWhitelistslistGUI()
      MsgBox(262144, "", 'The chosen White List profile was altered by the external factor (virus maybe). Hard_Configurator deleted that White List profile. Please use another one.')
      Return
   EndIf
   Local $OutputKey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144'
   RegDelete($OutputKey)  
   _RegCopyKey($InputKey, $OutputKey) 
   RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144','text')
   If not (CheckDefaultCurrentWhitelistedFolders() = '1') Then CorrectDefaultWhitelistedFolders()
;   ShowRegistryTweaks()
;  Turn ON refreshing Windows Explorer
   $RefreshExplorer = 1
   $RefreshChangesCheck = $RefreshChangesCheck & "LoadDefaults" & @LF
   MsgBox(262144,"", "White List profile  " & $NameOfWhitelist & " loaded successfully." & @CRLF & "Please, remember to <APPLY CHANGES>, after configuration is done." )
   ProtectShortcutsRefresh()
   CloseSavedWhitelists()
   Return
EndIf
MsgBox(262144,"", "Please, choose the right entry from the list.")

EndFunc


Func CheckWhitelistIntegrity($x)
  Return '1'
EndFunc

Func CorrectDefaultWhitelistedFolders()
Local $key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\'
;Windows 64Bit related
If @OSArch = "X64" Then
   RegWrite($key & '{6D809377-6AF0-444B-8957-A3773F02200E}', 'Description','REG_SZ','*Default : Program Files on 64 bits')
   RegWrite($key & '{6D809377-6AF0-444B-8957-A3773F02200E}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($key & '{6D809377-6AF0-444B-8957-A3773F02200E}', 'ItemData','REG_EXPAND_SZ','%HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\ProgramW6432Dir%')
   RegWrite($key & '{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}', 'Description','REG_SZ','*Default : Program Files (x86) on 64 bits')
   RegWrite($key & '{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($key & '{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}', 'ItemData','REG_EXPAND_SZ','%HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\ProgramFilesDir (x86)%')
EndIf
; Delete 64-bit entries on 32-bit system
If @OSArch = "X86" Then
   RegDelete($key & '{6D809377-6AF0-444B-8957-A3773F02200E}')
   RegDelete($key & '{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}')
EndIf

RegWrite($key & '{905E63B6-C1BF-494E-B29C-65B732D3D21A}', 'Description','REG_SZ','*Default : Program Files (default)')
RegWrite($key & '{905E63B6-C1BF-494E-B29C-65B732D3D21A}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($key & '{905E63B6-C1BF-494E-B29C-65B732D3D21A}', 'ItemData','REG_EXPAND_SZ','%HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\ProgramFilesDir%')
RegWrite($key & '{F38BF404-1D43-42F2-9305-67DE0B28FC23}', 'Description','REG_SZ','*Default : Windows')
RegWrite($key & '{F38BF404-1D43-42F2-9305-67DE0B28FC23}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($key & '{F38BF404-1D43-42F2-9305-67DE0B28FC23}', 'ItemData','REG_EXPAND_SZ','%HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\SystemRoot%')
If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
  RegWrite($key & '{f073d7e6-ec43-4bf6-a2a8-536eb63b03c8}', 'Description','REG_SZ','*Default : ProgramData\Microsoft\Windows Defender')
  RegWrite($key & '{f073d7e6-ec43-4bf6-a2a8-536eb63b03c8}', 'SaferFlags','REG_DWORD',Number('0'))
  RegWrite($key & '{f073d7e6-ec43-4bf6-a2a8-536eb63b03c8}', 'ItemData','REG_EXPAND_SZ','%HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\ProductAppDataPath%')
EndIf

EndFunc


Func ProtectShortcutsRefresh()
; The new whitelist can have settings not compatible with Protect Shortcuts, so this setting myst be refreshed.
If $DenyShortcuts = "ON" Then
   Deny_ShortcutsOFF()
   $DenyShortcuts = "OFF"
   Deny_Shortcuts('1')
   $DenyShortcuts = "ON" 
EndIf
If $DenyShortcuts = "OFF" Then
   Deny_ShortcutsOFF()
   $DenyShortcuts = "OFF"
EndIf
EndFunc

Func HelpWhitelistMenuSaveLoad()
  Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\WhitelistMenuSaveLoad.txt")
;  MsgBox(262144,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
   _ExtMsgBox(0,"CLOSE", "Whitelist Profiles Help", $help)
EndFunc
