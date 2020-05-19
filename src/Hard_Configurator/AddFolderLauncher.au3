Func AddFolderLauncher()

;#include <Array.au3>
;#Include <File.au3>
;#include <FileConstants.au3>
;#include <GUIConstantsEx.au3>
;#include <GuiListView.au3>
;#include <StringConstants.au3>
;#include <MsgBoxConstants.au3>


Local $path=FindFolderPath()
;MsgBox(262144,"", $path)
If FolderCannotBeWhitelisted($path) = 1 Then
   _Metro_MsgBox(0,"","This folder cannot be whitelisted for security reasons.",500,12,"",10)
   Return
EndIf
Local $sToAdd = CalculateFilePaths($path)
If $sToAdd = "-1" Then
;   MsgBox(262144,"",'This Path is already whitelisted.')
   _Metro_MsgBox(0,"","This folder is already whitelisted.",500,12,"",5)
   Return
EndIf
If not ($sToAdd = "0") Then 
   $RefreshChangesCheck = $RefreshChangesCheck & "WhitelistPath" & @LF
   _Metro_MsgBox(0,"","The changes will be applied after logging OFF from the account.",500,12,"",10)
EndIf
EndFunc

Func FolderCannotBeWhitelisted($folderpath)
Local $flag = 0
Local $username = StringLower(@UserName)
$folderpath = StringLower($folderpath)
If $folderpath = 'c:\' Then $flag = 1
If StringInStr($folderpath, '\$recycle.Bin') > 0 Then $flag = 1
If StringInStr($folderpath, 'system volume information') > 0 Then $flag = 1
If $folderpath = 'c:\recovery' Then $flag = 1
If $folderpath = 'c:\users' Then $flag = 1
If $folderpath = 'c:\users\' & $username Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\appdata' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\appdata\local' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\appdata\local\temp' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\appdata\local\microsoft\windows' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\appdata\local\microsoft\windows\inetcache' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\appdata\local\microsoft\windows\history' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\appdata\local\microsoft\windows\temporary internet files' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\appdata\locallow' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\appdata\roaming' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\contacts' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\documents' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\downloads' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\favorites' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\links' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\music' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\pictures' Then $flag = 1
If $folderpath = 'c:\users\' & $username & '\videos' Then $flag = 1
If StringInStr($folderpath, 'c:\users\' & 'default') > 0 Then $flag = 1
If StringInStr($folderpath, 'c:\users\' & 'public') > 0 Then $flag = 1
Return $flag
EndFunc


Func CheckDefaults()
 Return "1"
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
            If $n > 999 Then
               MsgBox(262144,"ALERT", "Cannot whitelist by Path. There are too many entries already whitelisted")
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
    Local $sFileOpenDialog = FileOpenDialog($sMessage, @WindowsDir & "\", "All files (*.*)", $FD_FILEMUSTEXIST)
    If @error Then
        ; Display the error message.
;        MsgBox(262144, "", "No file was selected.")

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



Func FindFolderPath()

; Create a constant variable in Local scope of the message to display in FileOpenDialog.
Local $sMessage = "Select the folder to be whitelisted"

; Display an open dialog to select the folder.

Local $sFolderOpenDialog = FileSelectFolder("",$systemdrive & '\ProgramData')
If $sFolderOpenDialog = "" Then
; Display the error message.
;        MsgBox(262144, "", "No folder was selected.")
	_Metro_MsgBox(0,"","No folder was selected.",500,12,"",5)

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
 For $i = 1 To 100
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
