Func AddRemovePath()
;Global $ARPathlistview
;Global $ARPathlistGUI 
;; Maximal number of user whitelisted paths. Cannot be changed.
;Global $MaxUserWhitelistEntries = 899
;; Used to search path duplicates
;GLobal $MaxWhitelistEntries = 2000

#include <Array.au3>
#Include <File.au3>
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <StringConstants.au3>
#include <MsgBoxConstants.au3>
;#include <GuiEdit.au3>
;#include <WindowsConstants.au3>

If $SRPDefaultLevel = "Allow All" Then
   MsgBox(262144,"","SRP is on 'Allow All' security level. All executables are allowed to run.")
EndIf

;GUISetState(@SW_HIDE,$listGUI)
;GUISetState(@SW_DISABLE, $listGUI)
;Opt("GUIOnEventMode", 1)
HideMainGUI()


$ARPathlistGUI = GUICreate("WHITELIST BY PATH", 570, 520, -1, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "ClosePath")
$ARPathlistview = GUICtrlCreateListView("PATH MAINTENANCE" & @CRLF, 10, 10, 400, 450)
_GUICtrlListView_SetColumnWidth($ARPathlistview, 0, 1300)
  
Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths'

;While 1
Local $_Array = Path2Array()
Local $element
  $_Array = _ArrayUnique ($_Array)
  _ArrayDelete ($_Array, 0)
  _ArraySort ($_Array)
  While UBound($_Array) > 0 
     $element = _ArrayPop($_Array)
     GUICtrlCreateListViewItem($element, $ARPathlistview)
  WEnd

Global $BtnAddFilePath = GUICtrlCreateButton("Add File", 450, 15, 80, 25)
GUICtrlSetOnEvent(-1, "AddFilePath")
Global $BtnAddFolderPath = GUICtrlCreateButton("Add Folder", 450, 60, 80, 25)
GUICtrlSetOnEvent(-1, "AddFolderPath")
Global $BtnAddWildcardPath = GUICtrlCreateButton("Add Path*Wildcards", 430, 105, 120, 25)
GUICtrlSetOnEvent(-1, "AddWildcardPath")
Global $BtnRemovePath = GUICtrlCreateButton("Remove", 450, 150, 80, 25)
GUICtrlSetOnEvent(-1, "RemovePath")
Global $BtnEditInfo = GUICtrlCreateButton("Edit Info", 450, 195, 80, 25)
GUICtrlSetOnEvent(-1, "EditInfo")

GUICtrlCreateLabel ("OneDrive for Accounts", 435, 245, 110, 25)
Global $BtnAddOneDrive = GUICtrlCreateButton("Add All", 430, 265, 50, 25)
GUICtrlSetOnEvent(-1, "AddOneDrive1")
Global $BtnRemoveOneDrive = GUICtrlCreateButton("Remove All", 480, 265, 70, 25)
GUICtrlSetOnEvent(-1, "RemoveOneDrive1")
GUICtrlCreateLabel ("Allow EXE and TMP", 440, 305, 100, 25)
Global $BtnAddAllowEXE = GUICtrlCreateButton("Add", 430, 325, 60, 25)
GUICtrlSetOnEvent(-1, "AddAllowEXE1")
Global $BtnRemoveAllowEXE = GUICtrlCreateButton("Remove", 490, 325, 60, 25)
GUICtrlSetOnEvent(-1, "RemoveAllowEXE1")
GUICtrlCreateLabel ("Allow MSI", 440, 365, 100, 25)
Global $BtnAddAllowMSI = GUICtrlCreateButton("Add", 430, 385, 60, 25)
GUICtrlSetOnEvent(-1, "AddAllowMSI1")
Global $BtnRemoveAllowMSI = GUICtrlCreateButton("Remove", 490, 385, 60, 25)
GUICtrlSetOnEvent(-1, "RemoveAllowMSI1")

Global $BtnEndPath = GUICtrlCreateButton("Close", 450, 460, 80, 30)
GUICtrlSetOnEvent(-1, "ClosePath")

GUISetState(@SW_SHOW,$ARPathlistGUI)

;WEnd

EndFunc

 ; ///// Functions

Func ClosePath()
   GuiDelete($ARPathlistGUI)
   ShowMainGUI()
   ShowRegistryTweaks()
EndFunc


Func AddFilePath()

Local $path=FindFilePath()
;MsgBox(262144,"", $path)
Local $sToAdd = CalculateFilePaths($path)
If $sToAdd = "-1" Then
   MsgBox(262144,"",'This Path is already whitelisted.')
   Return
EndIf
If not ($sToAdd = "0") Then 
   GUICtrlCreateListViewItem($sToAdd, $ARPathlistview)
   $RefreshChangesCheck = $RefreshChangesCheck & "WhitelistPath" & @LF
   AddSRPExtension('*****')
   DeleteSRPExtension('*****')
EndIf
EndFunc


Func AddFolderPath()

Local $path=FindFolderPath()
;MsgBox(262144,"", $path)
If CheckPathsForUpdateMode($path) = 1 Then
   MsgBox(262144,"Whitelist by path",'This folder cannot be whitelisted. Please, use the <Add File> option to whitelist any particular file there.')
   Return
EndIf

Local $sToAdd = CalculateFilePaths($path)
If $sToAdd = "-1" Then
   MsgBox(262144,"Whitelist by path",'This Path is already whitelisted.')
   Return
EndIf
If not ($sToAdd = "0") Then 
   GUICtrlCreateListViewItem($sToAdd, $ARPathlistview)
   $RefreshChangesCheck = $RefreshChangesCheck & "WhitelistPath" & @LF
   AddSRPExtension('*****')
   DeleteSRPExtension('*****')
EndIf
EndFunc


Func AddWildcardPath()
Local $path=InputBox("Whitelist by path.","Enter the path with wildcards.")
If StringInStr($path, '%') > 0 Then 
   MsgBox(262144,"", 'Invalid path. Using environment variables is forbidden.')
   Return
EndIf
If CheckPathsForUpdateMode1($path) = 1 Then
   MsgBox(262144,"Whitelist by path",'This folder cannot be whitelisted. Please, use the <Add File> option to whitelist any particular file there.')
   Return
EndIf

;MsgBox(262144,"", $path)
Local $sToAdd = CalculateFilePaths($path)
If $sToAdd = "-1" Then
   MsgBox(262144,"",'This Path is already whitelisted.')
   Return
EndIf

If not ($sToAdd = "0") Then 
   GUICtrlCreateListViewItem($sToAdd, $ARPathlistview)
   $RefreshChangesCheck = $RefreshChangesCheck & "WhitelistPath" & @LF
   AddSRPExtension('*****')
   DeleteSRPExtension('*****')
EndIf
EndFunc


Func CheckDefaults()
;Default whitelisted path entries have not 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths'
;string in Description. This allows to differ them from other whitelisted entries that have it in Description.
Local $item
;Description string from $ARPathlistview list
Local $item1 = GUICtrlRead(GUICtrlRead($ARPathlistview))
If StringLeft($item1, 23) = "*OneDrive for Account: " Then Return $item1
;Check if it has 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths' string
$item = StringInStr($item1, 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths')
;MsgBox(262144,"",$item1 & @CRLF & $item)
If $item="0" Then
;Default whitelisted path
   Return "0"
EndIf
;Non default whitelisted path
Return "1"
EndFunc



Func RemovePath()
Local $listEntry = CheckDefaults()
If StringLeft($listEntry, 23) = "*OneDrive for Account: " Then
;   MsgBox(0,"",StringTrimRight($listEntry,1))
   DeleteGUIDs(StringTrimRight($listEntry,1))
   _GUICtrlListView_DeleteItemsSelected ($ARPathlistview)
   $RefreshChangesCheck = $RefreshChangesCheck & "WhitelistPath" & @LF
Return
EndIf
If $listEntry = "0" Then
;Default whitelisted path
  MsgBox(262144, "", "This item cannot be removed.")
  Return
EndIf
;Will remove the pipe "|" from the end of the string
Local $item1 = GUICtrlRead(GUICtrlRead($ARPathlistview))
Local $item = StringRight($item1, 39)
$item = StringLeft($item, 38)
;MsgBox(262144,"", $item)
If not ($item = "") Then
    RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths' & '\' & $item)
    _GUICtrlListView_DeleteItemsSelected ($ARPathlistview)
    $RefreshChangesCheck = $RefreshChangesCheck & "WhitelistPath" & @LF
Else
    MsgBox(262144, "Selected Item", "Please choose non-empty item")
EndIf

EndFunc
  

Func EditInfo()

If CheckDefaults() = "0" Then
  MsgBox(262144, "", "This item cannot be edited.")
  Return
EndIf
Local $var[2]
;Wczytanie rekordu z listy
Local $item1 = GUICtrlRead(GUICtrlRead($ARPathlistview))
If StringLeft($item1,23) = "*OneDrive for Account: " Then
  MsgBox(262144, "", "This item cannot be edited.")
  Return
EndIf
;Wczytanie koñcówki rekordu ze œcie¿k¹ rejestru REG = ...
Local $item2 = StringRight($item1,123)
;Wczytanie rekordu z odciêt¹ czêœci¹ dot. œcie¿ki rejestru (dane dot. programu dodawanego do Whitelist)
Local $item = StringLeft($item1,StringLen($item1)-123)
;Edycja powy¿szego rekordu
$item = InputBox("Whitelist by path.", "The name of whitelisted item, can be edited in the input box below.", $item )
; Dodanie do zmienionego rekordu œcie¿ki rejestru
$var[0] = StringTrimRight($item & $item2, 1)
;Zapis do Rejestru Windows
If not ($item = "") Then 
       _GUICtrlListView_DeleteItemsSelected ($ARPathlistview)
       GUICtrlCreateListViewItem($var[0], $ARPathlistview)
       $item1 = StringRight($item1, 39)
       $var[1] = StringLeft($item1, 38)
;       MsgBox(262144,"", $var[1])
;       MsgBox(262144,"", $var[0])
       RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths' & '\' & $var[1],'Description','REG_SZ', $var[0])
EndIf

EndFunc


Func CalculateFilePaths($path)

;$DescriptionLabel variable is the Global variable defined in Autoruns() function !!!
#include <GUIConstantsEx.au3>
#include <StringConstants.au3>
#Include <File.au3>
#include <FileConstants.au3>
#RequireAdmin

Local $var[6]
;Select a file for adding to the Whitelist.
$var[0] = $path
;MsgBox(262144,"", $var[0])
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
        Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths'
        Local $sSubKey = RegEnumKey($mainkey, 1)
        Local $partSubkey = $mainkey & '\{1016bbe0-a716-428b-822e-6E544B6A3'
        Local $i = 1
        Local $n = 100
        While ($sSubKey <> "")
            If $n > 100 + $MaxUserWhitelistEntries Then
               MsgBox(262144,"ALERT", "Cannot be whitelist by Path. There are too many entries already whitelisted")
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

        ;Write data to the Registry
   If SearchWhitelistedPathsDuplicates ($var[0]) = 0 Then
     RegWrite ($var[5], 'Description','REG_SZ', $DescriptionLabel & $var[0] & "  (***)  " & $var[2] & '  REG = ' & $var[5])
     RegWrite ($var[5], 'SaferFlags','REG_DWORD', Number('0'))
     RegWrite ($var[5], 'ItemData','REG_SZ', $var[0])
;    MsgBox("0","",RegRead ($var[5], 'ItemData'))
     _ArrayAdd($NewPathsArray, $var[0])
   Else
     _ArrayAdd($PathDuplicatesArray, $var[0])
;    MsgBox(262144,"", 'This item is already on the list' & @CRLF & $PathDuplicatesArray[1])
     Return '-1'
   EndIf

;Content of the added list item 
If Stringlen($var[2]) > 200 Then $var[2] = StringLeft($var[2],200)
   Return $var[0] & "  (***)  " & $var[2] & '   REG = ' & $var[5]
EndIf
EndFunc 


Func FindFilePath()
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

    ; Create a constant variable in Local scope of the message to display in FileOpenDialog.
    Local $sMessage = "Select the file to be whitelisted."

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



Func FindFolderPath()

; Create a constant variable in Local scope of the message to display in FileOpenDialog.
Local $sMessage = "Select the folder to be whitelisted"

; Display an open dialog to select the folder.
Local $sFolderOpenDialog = FileSelectFolder("",$systemdrive & '\ProgramData')
If $sFolderOpenDialog = "" Then
; Display the error message.
        MsgBox(262144, "", "No folder was selected." & $sFolderOpenDialog)

; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
        FileChangeDir($systemdrive & '\ProgramData')
    Else
; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
        FileChangeDir($systemdrive & '\ProgramData')

; Display the list of selected files.
;        MsgBox(262144, "", "You chose the following files:" & @CRLF & $sFileOpenDialog)
EndIf
Return $sFolderOpenDialog
EndFunc


Func SearchWhitelistedPathsDuplicates ($itemnew)

 #include <MsgBoxConstants.au3>
 Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\'
 Local $sSubKey = ""
 For $i = 1 To $MaxWhitelistEntries
   $sSubKey = RegEnumKey('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths', $i)
   If @error Then ExitLoop
   Local $itemold = RegRead($mainkey & $sSubKey, 'ItemData')
   If (StringInStr($itemold, $itemnew) = 1 ) And (StringInStr($itemnew, $itemold) = 1 ) Then
;   MsgBox (0,"", StringInStr($itemold, $itemnew) & '    ' &  StringInStr($itemnew, $itemold))
   Return '1'
   EndIf
 Next
 Return '0'

EndFunc


Func ViewDuplicatePaths()

If UBound($PathDuplicatesArray) > 1 Then
    $PathDuplicatesArray[0] = 'The Paths below are already whitelisted'
    _ArrayDisplay($PathDuplicatesArray)
EndIf
;Clear the $PathDuplicatesArray
While UBound($PathDuplicatesArray) > 1
  _ArrayPop($PathDuplicatesArray)
WEnd 

EndFunc

Func AddOneDrive1()
Local $_xarr = _sGetAllAccountsInfo()
Local $temp
If Ubound($_xarr) < 2 Then
   MsgBox(262144, "", "Error. Cannot find OneDrive on any Account.")
   Return
EndIf
For $n=1 to Ubound($_xarr)-1
   $temp = StringTrimLeft($_xarr[$n], StringInStr($_xarr[$n], "(***)")+4)
   $temp = StringTrimRight($temp,StringLen($temp) - StringInStr($temp, "(****)")+1)
;   MsgBox(262144, "", $temp)
   AddOneDrive($temp , "*OneDrive for Account: " & $_xarr[$n])
Next

Local $temp = $_xarr[1]
;MsgBox(0,"",$temp)

$RefreshChangesCheck = $RefreshChangesCheck & "WhitelistPath" & @LF
RefreshAddRemovePathGUIWindow()
EndFunc

Func AddOneDrive($PathToUserProfile, $whitelist_Info)
Local $_path
;MsgBox(0,"",$PathToUserProfile)
Local $_Part_GUID = '{1016bbe0-a716-428b-822e-0E544B6A3'
Local $_LocalAppdataDir = $PathToUserProfile & '\AppData\Local'
;   OneDrive on the Whitelist
   $_path = $_LocalAppdataDir & '\Microsoft\OneDrive\OneDrive.exe'
   If SearchWhitelistedPathsDuplicates ($_path) = 0 Then
      CalculateFilePaths2($_path, $_Part_GUID, $whitelist_Info)
   EndIf 
   $_path = $_LocalAppdataDir & '\Microsoft\OneDrive\*\*.dll'
   If SearchWhitelistedPathsDuplicates ($_path) = 0 Then
       CalculateFilePaths2($_path, $_Part_GUID, $whitelist_Info)
   EndIf
   $_path = $_LocalAppdataDir & '\Microsoft\OneDrive\*\OneDriveStandaloneUpdater.exe'
   If SearchWhitelistedPathsDuplicates ($_path) = 0 Then
       CalculateFilePaths2($_path, $_Part_GUID, $whitelist_Info)
   EndIf
   $_path = $_LocalAppdataDir & '\Microsoft\OneDrive\OneDrivePersonal.cmd'
   If SearchWhitelistedPathsDuplicates ($_path) = 0 Then
       CalculateFilePaths2($_path, $_Part_GUID, $whitelist_Info)
   EndIf
   $_path = $_LocalAppdataDir & '\Microsoft\OneDrive\*\*\*.dll'
   If SearchWhitelistedPathsDuplicates ($_path) = 0 Then
       CalculateFilePaths2($_path, $_Part_GUID, $whitelist_Info)
   EndIf
   $_path = $_LocalAppdataDir & '\Microsoft\OneDrive\Update\OneDriveSetup.exe'
   If SearchWhitelistedPathsDuplicates ($_path) = 0 Then
       CalculateFilePaths2($_path, $_Part_GUID, $whitelist_Info)
   EndIf
   $_path = $_LocalAppdataDir & '\Microsoft\OneDrive\OneDriveStandaloneUpdater.exe'
   If SearchWhitelistedPathsDuplicates ($_path) = 0 Then
       CalculateFilePaths2($_path, $_Part_GUID, $whitelist_Info)
   EndIf
   $_path = $_LocalAppdataDir & '\Microsoft\OneDrive\*\FileSyncConfig.exe'
   If SearchWhitelistedPathsDuplicates ($_path) = 0 Then
       CalculateFilePaths2($_path, $_Part_GUID, $whitelist_Info)
   EndIf
   $_path = $_LocalAppdataDir & '\Microsoft\OneDrive\*\FileCoAuth.exe'
   If SearchWhitelistedPathsDuplicates ($_path) = 0 Then
       CalculateFilePaths2($_path, $_Part_GUID, $whitelist_Info)
   EndIf
   $_path = $_LocalAppdataDir & '\Microsoft\OneDrive\*\OneDriveSetup.exe'
   If SearchWhitelistedPathsDuplicates ($_path) = 0 Then
       CalculateFilePaths2($_path, $_Part_GUID, $whitelist_Info)
   EndIf
   $_path = $_LocalAppdataDir & '\Microsoft\OneDrive\*\CollectSyncLogs.bat'
   If SearchWhitelistedPathsDuplicates ($_path) = 0 Then
       CalculateFilePaths2($_path, $_Part_GUID, $whitelist_Info)
   EndIf
   AddSRPExtension('*****')
   DeleteSRPExtension('*****')
EndFunc

Func RefreshAddRemovePathGUIWindow()
  GUISetState(@SW_HIDE,$ARPathlistGUI)
  GuiDelete($ARPathlistGUI)
  AddRemovePath()
EndFunc

Func RemoveOneDrive()
Local $partKey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144\Paths\{1016bbe0-a716-428b-822e-DE544B6A350'
; Delete OneDrive from the Whitelist
   DeleteGUIDs('OneDrive')
EndFunc

Func RemoveOneDrive1()
   RemoveOneDrive()
   $RefreshChangesCheck = $RefreshChangesCheck & "WhitelistPath" & @LF
   RefreshAddRemovePathGUIWindow()
EndFunc


Func _GetConsoleUser($strComputer = ".")

   Local $objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\Root\CIMV2")
   Local $colProcesses, $objProcess
   Local $strUser = "", $strDomain = ""
   Local $strAccount, $lReturn
;   $colProcesses = $objWMIService.ExecQuery("Select Name from Win32_Process Where Name = 'Explorer.exe' AND SessionId = 0")
   $colProcesses = $objWMIService.ExecQuery("Select Name from Win32_Process Where Name = 'Explorer.exe'")
   For $objProcess In $colProcesses
      Local $lReturn = $objProcess.GetOwner($strUser, $strDomain)
;      MsgBox(0,"", $strUser & @crlf & $strDomain)
      If $lReturn = 0 Then 
         $strAccount = $strUser
      EndIf
   Next

   If $strAccount <> "" Then
      Return $strAccount
   Else
      Return SetError(1, 0, 0)
   EndIf
EndFunc


Func CalculateFilePaths2($path, $Part_GUID, $whitelist_Info)
;MsgBox(0,"",$path & @crlf & $Part_GUID & @crlf & $whitelist_Info)
;$DescriptionLabel variable is the Global variable defined in Autoruns() function !!!
#include <GUIConstantsEx.au3>
#include <StringConstants.au3>
#Include <File.au3>
#include <FileConstants.au3>
#RequireAdmin

Local $var[6]
;Select a file for adding to the Whitelist.
$var[0] = $path
;MsgBox(262144,"", $var[0])
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
        Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths'
        Local $sSubKey = RegEnumKey($mainkey, 1)
        Local $partSubkey = $mainkey & '\' & $Part_GUID
        Local $i = 1
        Local $n = 100
        While ($sSubKey <> "")
            If $n > 100 + $MaxUserWhitelistEntries Then
               MsgBox(262144,"ALERT", "Cannot be whitelist by Path. There are too many entries already whitelisted")
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

        ;Write data to the Registry
   If SearchWhitelistedPathsDuplicates ($var[0]) = 0 Then
      If $whitelist_Info = "" Then
          RegWrite ($var[5], 'Description','REG_SZ', $DescriptionLabel & $var[0] & "  (***)  " & $var[2] & '  REG = ' & $var[5])
      Else
;          MsgBox(0,"",$var[5] & @crlf & $whitelist_Info)
          RegWrite ($var[5], 'Description','REG_SZ', $whitelist_Info)
      EndIf
      _ArrayAdd($NewPathsArray, $var[0])
      RegWrite ($var[5], 'SaferFlags','REG_DWORD', Number('0'))
      RegWrite ($var[5], 'ItemData','REG_SZ', $var[0])
;     MsgBox("0","",RegRead ($var[5], 'ItemData'))
   Else
     _ArrayAdd($PathDuplicatesArray, $var[0])
;    MsgBox(262144,"", 'This item is already on the list' & @CRLF & $PathDuplicatesArray[1])
     Return '-1'
   EndIf

;Content of the added list item 
   If Stringlen($var[2]) > 200 Then $var[2] = StringLeft($var[2],200)
   Return $var[0] & "  (***)  " & $var[2] & '   REG = ' & $var[5]
EndIf
EndFunc 


Func AddAllowEXE1()
AddAllowEXE()
$RefreshChangesCheck = $RefreshChangesCheck & "WhitelistPath" & @LF
RefreshAddRemovePathGUIWindow()
EndFunc

Func AddAllowEXE()
Local $KeyEXE
Local $KeyTMP
$KeyEXE = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144\Paths\{1016bbe0-a716-428b-822e-DE544B6A3520}'
RegWrite($KeyEXE, 'Description','REG_SZ', '*Allow EXE files')
RegWrite($KeyEXE, 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($KeyEXE, 'ItemData','REG_SZ','*.exe')
$KeyTMP = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144\Paths\{1016bbe0-a716-428b-822e-DE544B6A3521}'
RegWrite($KeyTMP, 'Description','REG_SZ', '*Allow TMP files')
RegWrite($KeyTMP, 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($KeyTMP, 'ItemData','REG_SZ','*.tmp')
AddSRPExtension('*****')
DeleteSRPExtension('*****')
EndFunc


Func RemoveAllowEXE1()
RemoveAllowEXE()
$RefreshChangesCheck = $RefreshChangesCheck & "WhitelistPath" & @LF
RefreshAddRemovePathGUIWindow()
EndFunc

Func RemoveAllowEXE()
Local $Key
$Key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144\Paths\{1016bbe0-a716-428b-822e-DE544B6A3520}'
RegDelete($Key)
$Key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144\Paths\{1016bbe0-a716-428b-822e-DE544B6A3521}'
RegDelete($Key)
$SRPAllowExe = "OFF"
EndFunc

Func AddAllowMSI1()
AddAllowMSI()
$RefreshChangesCheck = $RefreshChangesCheck & "WhitelistPath" & @LF
RefreshAddRemovePathGUIWindow()
EndFunc

Func AddAllowMSI()
Local $Key
$Key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144\Paths\{1016bbe0-a716-428b-822e-DE544B6A3522}'
RegWrite($Key, 'Description','REG_SZ', '*Allow MSI files')
RegWrite($Key, 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($Key, 'ItemData','REG_SZ','*.msi')
AddSRPExtension('*****')
DeleteSRPExtension('*****')
EndFunc


Func RemoveAllowMSI1()
RemoveAllowMSI()
$RefreshChangesCheck = $RefreshChangesCheck & "WhitelistPath" & @LF
RefreshAddRemovePathGUIWindow()
EndFunc

Func RemoveAllowMSI()
Local $Key
$Key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144\Paths\{1016bbe0-a716-428b-822e-DE544B6A3522}'
RegDelete($Key)
$SRPAllowMsi = "OFF"
EndFunc


Func FindWhitelistedEntriesNumber()
Local $_Array = Path2Array()
$_Array = _ArrayUnique ($_Array)
;MsgBox(0,"",UBound($_Array))

If UBound($_Array) > 0 Then
;   Delete empty records from $_Array
    While _ArraySearch($_Array,'') > 0
          _ArrayDelete($_Array,_ArraySearch($_Array,''))
    WEnd
;   Correct the number of Array records written in 0-th record.
    $_Array[0] = UBound($_Array)-1
EndIf
;_ArrayDisplay($_Array)
Return UBound($_Array)-1
EndFunc



Func CheckUpdateModeCompatibility()
If CheckAllowEXE() = 2 Then
   $SRPAllowExe = "ON"
Else
   RemoveAllowEXE()
   $SRPAllowExe = "OFF"
EndIf

If CheckAllowMSI() = 2 Then
   $SRPAllowMsi = "ON"
Else
   RemoveAllowMSI()
   $SRPAllowMsi = "OFF"
EndIf

If ($SRPAllowExe = "ON" And $SRPAllowMsi = "ON") Then
   If not ($LowerExeRestrictions = 'OFF') Then
      _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
      _ExtMsgBox(64,"&OK", "Hard_Configurator", "Your current settings allow EXE (TMP) and MSI files globally in UserSpace. Now, you do not need to allow additionally the EXE (TMP) and MSI files in ProgramData and user AppData folders - the <Update Mode> will be set to OFF.")
;MsgBox(0,"CheckUpdateModeCompatibility", 0)
      $LowerExeRestrictions = 'ON'
      LowerExeRestrictions('1', 0)
      $LowerExeRestrictions = 'OFF'
   EndIf
   Return
EndIf

;MsgBox(0,"", $LowerExeRestrictions & @crlf & $SRPAllowExe & @crlf & $SRPAllowMsi)
If $LowerExeRestrictions = "ON" and $SRPAllowExe = "ON" Then
      _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
      _ExtMsgBox(64,"&OK", "Hard_Configurator", "You have just allowed EXE (TMP) files globally in UserSpace, so you do not need to allow additionally both EXE (TMP) and MSI files in ProgramData and user AppData folders - the <Update Mode> will be set to MSI.")
   RemoveProtectLowerExeRestrictions()
   $LowerExeRestrictions = 'OFF'
   LowerExeRestrictions('1', 0)
   $LowerExeRestrictions = 'MSI'
   Return	
EndIf


If ($LowerExeRestrictions = 'MSI' And $SRPAllowMsi = "ON") Then
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
   _ExtMsgBox(64,"&OK", "Hard_Configurator", "You have just allowed MSI files globally in UserSpace, so you do not need to allow additionally the MSI files in ProgramData and user AppData folders - the <Update Mode> will be set to OFF.")
   $LowerExeRestrictions = 'ON'
   LowerExeRestrictions('1', 0)
   $LowerExeRestrictions = 'OFF'
   Return
EndIf

EndFunc


Func CheckPathsForUpdateMode($item)
; Designed for folder paths from Explorer
Local $FileDrive=''
Local $Filename=''
Local $FilePath=''
Local $FileExt=''
  If $LowerExeRestrictions = 'OFF' Then Return 0
  If StringInStr($item, '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup') > 0 Then Return 1
  $item = StringReplace($item, " ", "")
  _PathSplit ($item, $FileDrive, $FilePath, $Filename, $FileExt)
;  MsgBox(0,"CheckPathsForUpdateMode",$item & @crlf & $FileExt )
  If $FileExt = '.msi' Then Return 1
  If $LowerExeRestrictions = 'MSI' Then Return 0
  If $FileExt = '.tmp' Then Return 1
  If $FileExt = '.exe' Then Return 1
  Return 0
EndFunc


Func CheckPathsForUpdateMode1($item)
; Designed for paths with wildcards
Local $FileDrive=''
Local $Filename=''
Local $FilePath=''
Local $FileExt=''
  If $LowerExeRestrictions = 'OFF' Then Return 0
  $item = StringReplace($item, " ", "")
  If not (Stringleft(StringReverse($item),1) = '\') Then Return 0
  _PathSplit ($item, $FileDrive, $FilePath, $Filename, $FileExt)
  If $FileExt = "" Then
	$item = StringTrimRight($item, 1)
	_PathSplit ($item, $FileDrive, $FilePath, $Filename, $FileExt)
  EndIf
  MsgBox(0,"CheckPathsForUpdateMode",$item & @crlf & $FileExt )
  If $FileExt = '.msi' Then Return 1
  If $LowerExeRestrictions = 'MSI' Then Return 0
  If $FileExt = '.tmp' Then Return 1
  If $FileExt = '.exe' Then Return 1
  Return 0
EndFunc