Func AddRemoveHash()
Global $ARHashlistview
Global $ARHashlistGUI 

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

;GUISetState(@SW_HIDE,$listGUI)
;GUISetState(@SW_DISABLE, $listGUI)
;Opt("GUIOnEventMode", 1)
HideMainGUI()

$ARHashlistGUI = GUICreate("WHITELIST FILE BY HASH", 550, 500, -1, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseHash")
$ARHashlistview = GUICtrlCreateListView("HASH MAINTENANCE", 10, 10, 400, 450)
_GUICtrlListView_SetColumnWidth($ARHashlistview, 0, 1300)
  
Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Hashes'

;While 1
Local $_Array = Hash2Array()
Local $element
_ArraySort ($_Array)
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

GUISetState(@SW_SHOW,$ARHashlistGUI)

;WEnd


EndFunc

 ; ///// Functions

Func CloseHash()
   GuiDelete($ARHashlistGUI)
   ShowMainGUI()
   ShowRegistryTweaks()
EndFunc


Func AddHash()

Local $sToAdd = CalculateFileHashes()
;MsgBox(262144,"",$sToAdd)
If not ($sToAdd = "0") Then 
   GUICtrlCreateListViewItem ($sToAdd, $ARHashlistview)
   $RefreshChangesCheck = $RefreshChangesCheck & "WhitelistHash" & @LF
   AddSRPExtension('*****')
   DeleteSRPExtension('*****')
EndIf
EndFunc


Func RemoveHash()

Local $item
Local $item1 = GUICtrlRead(GUICtrlRead($ARHashlistview))
$item = StringInStr($item, 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Hashes')
;Will remove the pipe "|" from the end of the string
$item = StringRight($item1, 39)
$item = StringLeft($item, 38)
;MsgBox(262144,"", $item)
If not ($item = "") Then
    RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Hashes' & '\' & $item)
    _GUICtrlListView_DeleteItemsSelected ($ARHashlistview)
    $RefreshChangesCheck = $RefreshChangesCheck & "WhitelistHash" & @LF
Else
    MsgBox(262144, "Selected Item", "Please, choose non-empty item.")
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
$item = InputBox("Whitelist by hash.", "The name of whitelisted item, can be edited in the input box below.", $item )
; Dodanie do zmienionego rekordu œcie¿ki rejestru
$var[0] = StringTrimRight($item & $item2, 1)
;Zapis do Rejestru Windows
If not ($item = "") Then 
       _GUICtrlListView_DeleteItemsSelected ($ARHashlistview)
       GUICtrlCreateListViewItem($var[0], $ARHashlistview)
       $item1 = StringRight($item1, 39)
       $var[1] = StringLeft($item1, 38)
;       MsgBox(262144,"", $var[1])
;       MsgBox(262144,"", $var[0])
       RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Hashes' & '\' & $var[1],'Description','REG_SZ', $var[0])
EndIf

EndFunc


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
If not ($var[0] = "") Then
;         _Crypt_Startup() ; To optimize performance start the crypt library.
;       Get the filesize
        $var[1] = FileGetSize ($var[0])
;       MsgBox(262144,"", $var[0] & @CRLF & $var[1])
;       Get the info about the file               
        Local $fileinfo = FileGetVersion ( $var[0], $FV_COMPANYNAME)
        $fileinfo =  $fileinfo & "   " & FileGetVersion ( $var[0], $FV_FILEDESCRIPTION)
        $var[2] =  $fileinfo & "   " & FileGetVersion ( $var[0], $FV_FILEVERSION)
;       MsgBox(262144,"", $var[2])
        If StringStripWS($var[0], $STR_STRIPALL) <> "" And FileExists($var[0]) Then 
;       Get the file hashes
             Local $dHashMD5 = _Crypt_HashFile($var[0], $CALG_MD5) ; Create a hash of the file.
             Local $dHashSHA256 = _Crypt_HashFile($var[0], $CALG_SHA_256) ; Create a hash of the file.
             $var[3] = $dHashMD5
             $var[4] = $dHashSHA256
;            MsgBox(262144,"", $dHashMD5 & @CRLF & $dHashSHA256)
        EndIf
        
;       Create new GUID
        Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Hashes'
        Local $sSubKey = RegEnumKey($mainkey, 1)
        Local $partSubkey = $mainkey & '\{1016bbe0-a716-428b-822e-7E544B6A3'

        Local $i = 1
        Local $n = 100

        While ($sSubKey <> "")
            If $n > 999 Then
               MsgBox(262144,"ALERT", "The file cannot be whitelisted by hash. There are too many files already whitelisted.")
               ExitLoop
            EndIf
            $sSubKey = RegEnumKey($mainkey, $i)
            If @error Then ExitLoop  
;           MsgBox(262144,"", $partSubkey & $n  & "}" & @CRLF & $mainkey & '\' & $sSubKey)
            If $partSubkey & $n & "}" = $mainkey & '\' & $sSubKey Then
                $n = $n + 1
                $i = 0
            EndIf
            $i = $i + 1
;           MsgBox(262144,"", "$i = " & $i & @CRLF & "$n = " & $n)
        WEnd

;Here is the path with the new GUID
        $var[5] = $partSubkey & $n & '}'
;       MsgBox(262144,"Found the new GUID", $var[5])
        If SearchWhitelistedHashDuplicates ($var[4]) = 0 Then
;          Write data to the Registry
           RegWrite ($var[5], 'Description','REG_SZ', $var[0] & "  (***)  " & $var[2] & '  REG = ' & $var[5])
           RegWrite ($var[5], 'FriendlyName','REG_SZ', $var[2] )
           RegWrite ($var[5], 'SaferFlags','REG_DWORD', Number('0'))
           RegWrite ($var[5], 'ItemSize','REG_QWORD', Number($var[1]))
           RegWrite ($var[5], 'ItemData','REG_BINARY', Binary($var[3]))
           RegWrite ($var[5], 'HashAlg','REG_DWORD', Number('32771'))
           RegWrite ($var[5] & '\SHA256', 'ItemData','REG_BINARY', Binary($var[4]))
           RegWrite ($var[5] & '\SHA256', 'HashAlg','REG_DWORD', Number('32780'))
;          _Crypt_Shutdown() ; Shutdown the crypt library.
;          Content of the added list item 
           If Stringlen($var[2]) > 200 Then $var[2] = StringLeft($var[2],200)
;          MsgBox(262144,"",$var[4])
           Return $var[0] & "  (***)  " & $var[2] & '   REG = ' & $var[5]
        Else
           MsgBox(262144,"", 'This file is already whitelisted by hash.')
           Return "0"           
        EndIf
EndIf
EndFunc 


Func FindTheFile()
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

    ; Create a constant variable in Local scope of the message to display in FileOpenDialog.
    Local $sMessage = "Select the file to be whitelisted by hash."

    ; Display an open dialog to select a list of file(s).
    Local $sFileOpenDialog = FileOpenDialog($sMessage, @WindowsDir & "\", "All files (*.*)", $FD_FILEMUSTEXIST)
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


Func SearchWhitelistedHashDuplicates ($itemnew)

 #include <MsgBoxConstants.au3>
 Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Hashes\'
 Local $sSubKey = ""
 For $i = 1 To 100
   $sSubKey = RegEnumKey($mainkey, $i)
   If @error Then ExitLoop
   Local $itemold = RegRead($mainkey & $sSubKey & '\SHA256' , 'ItemData')
;   MsgBox (0,"", 'old: ' & $itemold & @CRLF & 'new: ' & $itemnew)
   If (StringInStr($itemold, $itemnew) = 1 ) And (StringInStr($itemnew, $itemold) = 1 ) Then
;   MsgBox (0,"", StringInStr($itemold, $itemnew) & '    ' &  StringInStr($itemnew, $itemold))
   Return '1'
   EndIf
 Next
 Return '0'

EndFunc
