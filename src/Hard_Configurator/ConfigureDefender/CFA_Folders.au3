Func ManageCFAFolders()

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


Global $CFAFolderslistGUI = GUICreate("CFA Folders", 550, 300, -1, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseCFA_Folders")
Global $CFAFolderslistview = GUICtrlCreateListView("Protected Folders", 10, 10, 400, 260)
_GUICtrlListView_SetColumnWidth($CFAFolderslistview, 0, 1300)
  
Global $CFAFoldersKey = 'HKLM\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access\ProtectedFolders'
Global $CFAFoldersKeyPolicy = 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access\ProtectedFolders'


Local $_Array = PathsFromKey2Array($CFAFoldersKey)
Local $_ArrayPolicy = PathsFromKey2Array($CFAFoldersKeyPolicy)
Local $element
  While UBound($_ArrayPolicy) > 0
     $element = _ArrayPop($_ArrayPolicy)
     _ArrayAdd ($_Array, $element) 
  WEnd
_ArraySort ($_Array, 1)
;_ArrayDisplay($_Array)
  While UBound($_Array) > 0
     $element = _ArrayPop($_Array)
     GUICtrlCreateListViewItem($element, $CFAFolderslistview)
  WEnd

Global $BtnAddCFA_FolderExclusion = GUICtrlCreateButton("Add Folder", 440, 15, 80, 30)
GUICtrlSetOnEvent(-1, "AddCFA_FolderExclusion")
Global $BtnRemoveCFA_Folders = GUICtrlCreateButton("Remove", 440, 115, 80, 30)
GUICtrlSetOnEvent(-1, "RemoveCFA_Folders")
Global $BtnEndCFA_Folders = GUICtrlCreateButton("Close", 440, 240, 80, 30)
GUICtrlSetOnEvent(-1, "CloseCFA_Folders")

GUISetState(@SW_SHOW,$CFAFolderslistGUI)

While 1
Switch GUIGetMsg()
    Case $GUI_EVENT_CLOSE, $idOK
       CloseCFA_Folders()
       ExitLoop
    Case $BtnEndCFA_Folders
       CloseCFA_Folders()
       ExitLoop
    Case $BtnAddCFA_FolderExclusion
       AddCFA_FolderExclusion()
    Case $BtnRemoveCFA_Folders
       RemoveCFA_Folders()
EndSwitch
WEnd


EndFunc

 ; ///// Functions

Func CloseCFA_Folders()
   GuiDelete($CFAFolderslistGUI)
;   GUISetState(@SW_ENABLE, $MainDefenderGUI)
   GUISetState(@SW_SHOW, $MainDefenderGUI)
;   ShowMainDefenderGUI()
;   RefreshDefenderGUIWindow()
EndFunc


Func AddCFA_FolderExclusion()
Local $path = FindTheFolder()
; We must adopt quotes into quotes
Local $path1 = chr(34) & chr(39) & $path & chr(39) & chr(34)
If $path="" Then Return
RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -ControlledFolderAccessProtectedFolders " & $path1, "", @SW_HIDE)
GUICtrlCreateListViewItem ($path, $CFAFolderslistview)
MsgBox(262144, "", "Path added to the list:" & @CRLF & $path)
EndFunc


Func RemoveCFA_Folders()

Local $item
$item = GUICtrlRead(GUICtrlRead($CFAFolderslistview))
$item = StringTrimRight($item,1)
Local $item1 = chr(34) & chr(39) & $item & chr(39) & chr(34)
;FileWrite("aaa.txt", $item)
MsgBox(0,"",$item1)
If not ($item = "") Then
    RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Remove-MpPreference -ControlledFolderAccessProtectedFolders " & $item1, "", @SW_HIDE)
    RegDelete('HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access\ProtectedFolders', $item)
MsgBox(262144, "", "Path removed from the list:" & @CRLF & $item)
    _GUICtrlListView_DeleteItemsSelected ($CFAFolderslistview)
Else
    MsgBox(262144, "Selected Item", "Please, choose non-empty item.")
EndIf

EndFunc
  

