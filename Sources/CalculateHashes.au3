#include <ComboConstants.au3>
#include <Crypt.au3>
#include <GUIConstantsEx.au3>
#include <StringConstants.au3>
;#Include <File.au3>

CalculateFileHashes()


Func CalculateFileHashes()
Global Const $CALG_SHA_256 = 0x0000800c
Global Const $CALG_SHA_384 = 0x0000800d
Global Const $CALG_SHA_512 = 0x0000800e
Local $iAlgorithm = $CALG_SHA_256
Local $hGUI = GUICreate("Hash File", 425, 70)
Local $idInput = GUICtrlCreateInput(@ScriptFullPath, 5, 5, 200, 20)
Local $idBrowse = GUICtrlCreateButton("...", 210, 5, 35, 20)
Local $idCombo = GUICtrlCreateCombo("", 250, 5, 100, 20, $CBS_DROPDOWNLIST)
GUICtrlSetData($idCombo, "SHA_256|MD4|MD5|SHA1", "SHA_256")
Local $idCalculate = GUICtrlCreateButton("Calculate", 355, 40, 65, 25)
Local $idHashLabel = GUICtrlCreateLabel("Hash Digest", 5, 50, 350, 25)
GUISetState(@SW_SHOW, $hGUI)

_Crypt_Startup() ; To optimize performance start the crypt library.
Local $dHash = 0, _
$sRead = ""
While 1
      Switch GUIGetMsg()
      Case $GUI_EVENT_CLOSE
      ExitLoop
      Case $idBrowse
;                Select a file to find the hash.
                 Local $sFilePath = FileOpenDialog("Open a file", "", "All files (*.*)") 
                 If @error Then
                      ContinueLoop
                 EndIf
                 MsgBox(0,"",FileGetSize ($sFilePath))
                 Local $fileinfo = FileGetVersion ( $sFilePath, $FV_COMPANYNAME)
                 $fileinfo =  $fileinfo & @CRLF & FileGetVersion ( $sFilePath, $FV_FILEDESCRIPTION)
                 $fileinfo =  $fileinfo & @CRLF & FileGetVersion ( $sFilePath, $FV_FILEVERSION)
                 MsgBox(0,"",$fileinfo)
                 GUICtrlSetData($idInput, $sFilePath) ; Set the inputbox with the filepath.
                 GUICtrlSetData($idHashLabel, "Hash Digest") ; Reset the hash digest label.

      Case $idCombo ; Check when the combobox is selected and retrieve the correct algorithm.
                    Switch GUICtrlRead($idCombo) ; Read the combobox selection.
                    Case "MD4"
                         $iAlgorithm = $CALG_MD4
                    Case "MD5"
                         $iAlgorithm = $CALG_MD5
                    Case "SHA1"
                         $iAlgorithm = $CALG_SHA1
                    Case "SHA_256"
                         $iAlgorithm = $CALG_SHA_256
                    EndSwitch

     Case $idCalculate
                $sRead = GUICtrlRead($idInput)
                If StringStripWS($sRead, $STR_STRIPALL) <> "" And FileExists($sRead) Then ; Check there is a file available to find the hash digest
                    $dHash = _Crypt_HashFile($sRead, $iAlgorithm) ; Create a hash of the file.
                    GUICtrlSetData($idHashLabel, $dHash) ; Set the hash digest label with the hash data.
                EndIf
    EndSwitch
WEnd

GUIDelete($hGUI) ; Delete the previous GUI and all controls.
_Crypt_Shutdown() ; Shutdown the crypt library.

EndFunc 