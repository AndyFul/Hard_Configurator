Func ManageCFAExclusions()

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


GUISetState(@SW_HIDE,$MainDefenderGUI)
;GUISetState(@SW_DISABLE, $MainDefenderGUI)


$CFAExclusionslistGUI = GUICreate("CFA Exclusions", 550, 300, -1, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseCFA_Exclusions")
$CFAExclusionslistview = GUICtrlCreateListView("Allowed Applications", 10, 10, 400, 260)
_GUICtrlListView_SetColumnWidth($CFAExclusionslistview, 0, 1300)
  
Global $CFAExclusionsKey = 'HKLM\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access\AllowedApplications'
Global $CFAExclusionsKeyPolicy = 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access\AllowedApplications'

Local $_Array = PathsFromKey2Array($CFAExclusionsKey)
Local $_ArrayPolicy = PathsFromKey2Array($CFAExclusionsKeyPolicy)
Local $element
  While UBound($_ArrayPolicy) > 0
     $element = _ArrayPop($_ArrayPolicy)
     _ArrayAdd ($_Array, $element) 
  WEnd
_ArraySort ($_Array, 1)
;_ArrayDisplay($_Array)
  While UBound($_Array) > 0
     $element = _ArrayPop($_Array)
     GUICtrlCreateListViewItem($element, $CFAExclusionslistview)
  WEnd
Global $BtnAddCFA_FileExclusion = GUICtrlCreateButton("Add File", 440, 15, 80, 30)
GUICtrlSetOnEvent(-1, "AddCFA_FileExclusion")
Global $BtnRemoveCFA_Exclusions = GUICtrlCreateButton("Remove", 440, 115, 80, 30)
GUICtrlSetOnEvent(-1, "RemoveCFA_Exclusions")
Global $BtnEndCFA_Exclusions = GUICtrlCreateButton("Close", 440, 240, 80, 30)
GUICtrlSetOnEvent(-1, "CloseCFA_Exclusions")

GUISetState(@SW_SHOW,$CFAExclusionslistGUI)

While 1
Switch GUIGetMsg()
    Case $GUI_EVENT_CLOSE, $idOK
       CloseCFA_Exclusions()
       ExitLoop
    Case $BtnEndCFA_Exclusions
       CloseCFA_Exclusions()
       ExitLoop
    Case $BtnAddCFA_FileExclusion
       AddCFA_FileExclusion()
    Case $BtnRemoveCFA_Exclusions
       RemoveCFA_Exclusions()
EndSwitch
WEnd


EndFunc

 ; ///// Functions

Func CloseCFA_Exclusions()
   GuiDelete($CFAExclusionslistGUI)
;   GUISetState(@SW_ENABLE, $MainDefenderGUI)
   GUISetState(@SW_SHOW, $MainDefenderGUI)
;   ShowMainDefenderGUI()
;   RefreshDefenderGUIWindow()
EndFunc


Func AddCFA_FileExclusion()
Local $path = FindTheFile()
; We must adopt quotes into quotes
Local $path1 = chr(34) & chr(39) & $path & chr(39) & chr(34)
If $path="" Then Return
RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -ControlledFolderAccessAllowedApplications " & $path1, "", @SW_HIDE)
GUICtrlCreateListViewItem ($path, $CFAExclusionslistview)
MsgBox(262144, "", "Path added to the list:" & @CRLF & $path)
EndFunc



Func RemoveCFA_Exclusions()

Local $item
$item = GUICtrlRead(GUICtrlRead($CFAExclusionslistview))
$item = StringTrimRight($item,1)
Local $item1 = chr(34) & chr(39) & $item & chr(39) & chr(34)
;FileWrite("aaa.txt", $item)
MsgBox(0,"",$item1)
If not ($item = "") Then
    RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Remove-MpPreference -ControlledFolderAccessAllowedApplications " & $item1, "", @SW_HIDE)
    RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access\AllowedApplications', $item)
MsgBox(262144, "", "Path removed from the list:" & @CRLF & $item)
    _GUICtrlListView_DeleteItemsSelected ($CFAExclusionslistview)
Else
    MsgBox(262144, "Selected Item", "Please, choose non-empty item.")
EndIf

EndFunc
  
