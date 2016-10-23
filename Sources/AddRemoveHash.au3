Func AddRemoveHash()

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

Opt("GUIOnEventMode", 1)
Global $ARHashlistview
Global $ARHashlistGUI 
$ARHashlistGUI = GUICreate("HASH", 550, 500, 100, 100, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseHash")
$ARHashlistview = GUICtrlCreateListView("Hash maintenance", 10, 10, 400, 450)
_GUICtrlListView_SetColumnWidth($ARHashlistview, 0, 1300)
  
Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Hashes'

;While 1
Local $_Array = Hash2Array()
Local $element

  While UBound($_Array) > 0 
     $element = _ArrayPop($_Array)
     GUICtrlCreateListViewItem($element, $ARHashlistview)
  WEnd
Global $BtnAddHash = GUICtrlCreateButton("Add", 440, 15, 80, 30)
GUICtrlSetOnEvent(-1, "AddHash")
Global $BtnRemoveHash = GUICtrlCreateButton("Remove", 440, 65, 80, 30)
GUICtrlSetOnEvent(-1, "RemoveHash")
Global $BtnEditHash = GUICtrlCreateButton("Edit", 440, 115, 80, 30)
GUICtrlSetOnEvent(-1, "EditHash")
Global $BtnEndHash = GUICtrlCreateButton("Close", 440, 400, 80, 30)
GUICtrlSetOnEvent(-1, "CloseHash")

GUISetState(@SW_SHOW)

;WEnd


EndFunc

 ; ///// Functions

Func CloseHash()
   GUISetState(@SW_HIDE)
   ShowRegistryTweaks()
EndFunc


Func AddHash()

Local $sToAdd = CalculateFileHashes()
If not $sToAdd = 0 Then GUICtrlCreateListViewItem($sToAdd, $ARHashlistview)

EndFunc


Func RemoveHash()

Local $item
Local $item1 = GUICtrlRead(GUICtrlRead($ARHashlistview))
$item = StringInStr($item, 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Hashes')
;Will remove the pipe "|" from the end of the string
$item = StringRight($item1, 39)
$item = StringLeft($item, 38)
;MsgBox(0,"", $item)
If not $item = "" Then
    RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Hashes' & '\' & $item)
    _GUICtrlListView_DeleteItemsSelected ($ARHashlistview)
Else
    MsgBox(0, "Selected Item", "Please chosoe non empty item")
EndIf

EndFunc
  

Func EditHash()


Local $var[2]
;Wczytanie rekordu z listy
Local $item1 = GUICtrlRead(GUICtrlRead($ARHashlistview))
;Wczytanie koñcówki rekordu ze œcie¿k¹ rejestru REG = ...
Local $item2 = StringRight($item1,123)
;Wczytanie rekordu z odciêt¹ czêœci¹ dot. œcie¿ki rejestru (dane dot. hashowanego programu)
Local $item = StringLeft($item1,StringLen($item1)-123)
;Edycja powy¿szego rekordu
$item = InputBox("Add", "Enter Item Name", $item )
; Dodanie do zmienionego rekordu œcie¿ki rejestru
$var[0] = StringTrimRight($item & $item2, 1)
;Zapis do Rejestru Windows
If not $item = "" Then 
       _GUICtrlListView_DeleteItemsSelected ($ARHashlistview)
       GUICtrlCreateListViewItem($var[0], $ARHashlistview)
       $item1 = StringRight($item1, 39)
       $var[1] = StringLeft($item1, 38)
;       MsgBox(0,"", $var[1])
;       MsgBox(0,"", $var[0])
       RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Hashes' & '\' & $var[1],'Description','REG_SZ', $var[0])
EndIf

EndFunc



;Func On_Close_Main()
;   Exit
;EndFunc

Func CalculateFileHashes()

;#include <ComboConstants.au3>
;#include <Crypt.au3>
#include <GUIConstantsEx.au3>
#include <StringConstants.au3>
#Include <File.au3>
#include <FileConstants.au3>
#RequireAdmin

Global $CALG_SHA_256 = 0x0000800c
Global $CALG_SHA_384 = 0x0000800d
Global $CALG_SHA_512 = 0x0000800e
Local $iAlgorithm = $CALG_SHA_256

Local $var[6]
;Select a file to find the hash.
$var[0] = FindTheFile()
If not $var[0] = "" Then
;         _Crypt_Startup() ; To optimize performance start the crypt library.
;Get the filesize
        $var[1] = FileGetSize ($var[0])
;       MsgBox(0,"", $var[0] & @CRLF & $var[1])
;Get the info about the file               
        Local $fileinfo = FileGetVersion ( $var[0], $FV_COMPANYNAME)
        $fileinfo =  $fileinfo & @CRLF & FileGetVersion ( $var[0], $FV_FILEDESCRIPTION)
        $var[2] =  $fileinfo & @CRLF & FileGetVersion ( $var[0], $FV_FILEVERSION)
;       MsgBox(0,"", $var[2])
        If StringStripWS($var[0], $STR_STRIPALL) <> "" And FileExists($var[0]) Then 
;Get the file hashes
             Local $dHashMD5 = _Crypt_HashFile($var[0], $CALG_MD5) ; Create a hash of the file.
             Local $dHashSHA256 = _Crypt_HashFile($var[0], $CALG_SHA_256) ; Create a hash of the file.
             $var[3] = $dHashMD5
             $var[4] = $dHashSHA256
;            MsgBox(0,"", $dHashMD5 & @CRLF & $dHashSHA256)
        EndIf
        
;Create new GUID
        Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Hashes'
        Local $sSubKey = RegEnumKey($mainkey, 1)
        Local $partSubkey = $mainkey & '\{0016bbe0-a716-428b-822e-5E544B6A3'

        Local $i = 1
        Local $n = 200

        While ($sSubKey <> "")
            If $n > 300 Then
               MsgBox(0,"ALERT", "The file cannot be whitelisted by hash. There's to many files already whitelisted")
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
     RegWrite ($var[5], 'Description','REG_SZ', $var[0] & "  (***)  " & $var[2] & '  REG = ' & $var[5])
     RegWrite ($var[5], 'FriendlyName','REG_SZ', $var[2] )
     RegWrite ($var[5], 'SaferFlags','REG_DWORD', Number('0'))
     RegWrite ($var[5], 'ItemSize','REG_QWORD', Number($var[1]))
     RegWrite ($var[5], 'ItemData','REG_BINARY', Binary($var[3]))
     RegWrite ($var[5], 'HashAlg','REG_DWORD', Number('32771'))
     RegWrite ($var[5] & '\SHA256', 'ItemData','REG_BINARY', Binary($var[4]))
     RegWrite ($var[5] & '\SHA256', 'HashAlg','REG_DWORD', Number('32780'))

;_Crypt_Shutdown() ; Shutdown the crypt library.

;Content of the added list item 
If Stringlen($var[2]) > 200 Then $var[2] = StringLeft($var[2],200)
Return $var[0] & "  (***)  " & $var[2] & '   REG = ' & $var[5]


EndIf

EndFunc 


Func FindTheFile()
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

    ; Create a constant variable in Local scope of the message to display in FileOpenDialog.
    Local $sMessage = "Select the file to be whitelisted by hash"

    ; Display an open dialog to select a list of file(s).
    Local $sFileOpenDialog = FileOpenDialog($sMessage, @WindowsDir & "\", "All files (*.*)", $FD_FILEMUSTEXIST + $FD_MULTISELECT)
    If @error Then
        ; Display the error message.
        MsgBox($MB_SYSTEMMODAL, "", "No file(s) were selected." & $sFileOpenDialog)

        ; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
        FileChangeDir(@ScriptDir)
    Else
        ; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
        FileChangeDir(@ScriptDir)

        ; Replace instances of "|" with @CRLF in the string returned by FileOpenDialog.
        $sFileOpenDialog = StringReplace($sFileOpenDialog, "|", @CRLF)

        ; Display the list of selected files.
;        MsgBox($MB_SYSTEMMODAL, "", "You chose the following files:" & @CRLF & $sFileOpenDialog)
    EndIf
Return $sFileOpenDialog
EndFunc  


