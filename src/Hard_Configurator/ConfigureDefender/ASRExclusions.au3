Func ManageASRExclusions()

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


$ASRExclusionslistGUI = GUICreate("ASR Exclusions", 550, 300, -1, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseASR_Exclusions")
$ASRExclusionslistview = GUICtrlCreateListView("Excluded Paths", 10, 10, 400, 260)
_GUICtrlListView_SetColumnWidth($ASRExclusionslistview, 0, 1300)
  
Global $ASRExclusionsKey = 'HKLM\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\ASROnlyExclusions'
Global $ASRExclusionsKeyPolicy = 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\ASROnlyExclusions'


Local $_Array = PathsFromKey2Array($ASRExclusionsKey)
Local $_ArrayPolicy = PathsFromKey2Array($ASRExclusionsKeyPolicy)
Local $element
  While UBound($_ArrayPolicy) > 0
     $element = _ArrayPop($_ArrayPolicy)
     _ArrayAdd ($_Array, $element) 
  WEnd
_ArraySort ($_Array, 1)
;_ArrayDisplay($_Array)
  While UBound($_Array) > 0
     $element = _ArrayPop($_Array)
     GUICtrlCreateListViewItem($element, $ASRExclusionslistview)
  WEnd
Global $BtnAddASR_FileExclusion = GUICtrlCreateButton("Add File", 440, 15, 80, 30)
GUICtrlSetOnEvent(-1, "AddASR_FileExclusion")
Global $BtnAddASR_FolderExclusion = GUICtrlCreateButton("Add Folder", 440, 65, 80, 30)
GUICtrlSetOnEvent(-1, "AddASR_FolderExclusion")
Global $BtnRemoveASR_Exclusions = GUICtrlCreateButton("Remove", 440, 115, 80, 30)
GUICtrlSetOnEvent(-1, "RemoveASR_Exclusions")
Global $BtnEndASR_Exclusions = GUICtrlCreateButton("Close", 440, 240, 80, 30)
GUICtrlSetOnEvent(-1, "CloseASR_Exclusions")

GUISetState(@SW_SHOW,$ASRExclusionslistGUI)

While 1
Switch GUIGetMsg()
    Case $GUI_EVENT_CLOSE, $idOK
       CloseASR_Exclusions()
       ExitLoop
    Case $BtnEndASR_Exclusions
       CloseASR_Exclusions()
       ExitLoop
    Case $BtnAddASR_FileExclusion
       AddASR_FileExclusion()
    Case $BtnAddASR_FolderExclusion
       AddASR_FolderExclusion()
    Case $BtnRemoveASR_Exclusions
       RemoveASR_Exclusions()
EndSwitch
WEnd


EndFunc

 ; ///// Functions

Func CloseASR_Exclusions()
   GuiDelete($ASRExclusionslistGUI)
;   GUISetState(@SW_ENABLE, $MainDefenderGUI)
   GUISetState(@SW_SHOW, $MainDefenderGUI)
;   ShowMainDefenderGUI()
;   RefreshDefenderGUIWindow()
EndFunc


Func AddASR_FileExclusion()
Local $path = FindTheFile()
; We must adopt quotes into quotes
Local $path1 = chr(34) & chr(39) & $path & chr(39) & chr(34)
If $path="" Then Return
RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionOnlyExclusions " & $path1, "", @SW_HIDE)
GUICtrlCreateListViewItem ($path, $ASRExclusionslistview)
MsgBox(262144, "", "Path added to the list:" & @CRLF & $path)
EndFunc



Func AddASR_FolderExclusion()
Local $path = FindTheFolder()
; We must adopt quotes into quotes
Local $path1 = chr(34) & chr(39) & $path & chr(39) & chr(34)
If $path="" Then Return
RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Add-MpPreference -AttackSurfaceReductionOnlyExclusions " & $path1, "", @SW_HIDE)
GUICtrlCreateListViewItem ($path, $ASRExclusionslistview)
MsgBox(262144, "", "Path added to the list:" & @CRLF & $path)
EndFunc




Func RemoveASR_Exclusions()

Local $item
$item = GUICtrlRead(GUICtrlRead($ASRExclusionslistview))
$item = StringTrimRight($item,1)
Local $item1 = chr(34) & chr(39) & $item & chr(39) & chr(34)
;FileWrite("aaa.txt", $item)
MsgBox(0,"",$item1)
If not ($item = "") Then
    RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Remove-MpPreference -AttackSurfaceReductionOnlyExclusions " & $item1, "", @SW_HIDE)
    RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\ASROnlyExclusions', $item)
MsgBox(262144, "", "Path removed from the list:" & @CRLF & $item)
    _GUICtrlListView_DeleteItemsSelected ($ASRExclusionslistview)
Else
    MsgBox(262144, "Selected Item", "Please, choose non-empty item.")
EndIf

EndFunc
  

Func FindTheFile()
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

    ; Create a constant variable in Local scope of the message to display in FileOpenDialog.
    Local $sMessage = "Select the file to exclude."

    ; Display an open dialog to select a list of file(s).
    Local $sFileOpenDialog = FileOpenDialog($sMessage, "c:\", "All files (*.*)", $FD_FILEMUSTEXIST)
    If @error Then
        ; Display the error message.
        MsgBox(262144, "", "No file was selected." & $sFileOpenDialog)

        ; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
        FileChangeDir(@ScriptDir)
    Else
        ; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
        FileChangeDir(@ScriptDir)

        ; Replace instances of "|" with @CRLF in the string returned by FileOpenDialog.
        $sFileOpenDialog = StringReplace($sFileOpenDialog, "|", @CRLF)

        ; Display the list of selected files.
;        MsgBox(262144, "", "You chose the following files:" & @CRLF & $sFileOpenDialog)
    EndIf
Return $sFileOpenDialog
EndFunc  


Func FindTheFolder()
; Create a constant variable in Local scope of the message to display in FileOpenDialog.
Local $sMessage = "Select the folder to be whitelisted"

; Display an open dialog to select the folder.
Local $sFolderOpenDialog = FileSelectFolder("","")
If $sFolderOpenDialog = "" Then
; Display the error message.
        MsgBox(262144, "", "No folder was selected." & $sFolderOpenDialog)

; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
        FileChangeDir(@ScriptDir)
    Else
; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
        FileChangeDir(@ScriptDir)

; Display the list of selected files.
;        MsgBox(262144, "", "You chose the following files:" & @CRLF & $sFileOpenDialog)
EndIf
Return $sFolderOpenDialog
EndFunc



