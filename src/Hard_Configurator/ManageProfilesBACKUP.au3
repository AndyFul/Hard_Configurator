Func ManageProfilesBACKUP()

  Local  $deltaX=50

  GUISetState(@SW_HIDE, $ToolslistGUI)


  $ManageProfilesBackupGUI = GUICreate("BACKUP", 240, 250, -1, -1, -1)
  GUISetOnEvent($GUI_EVENT_CLOSE, "CloseManageProfilesBackupGUI")
 
  $BtnHelpManageProfilesBackup = GUICtrlCreateButton("Help", $deltaX+40, 20, 60, 30)
  GUICtrlSetOnEvent(-1, "HelpManageProfilesBackup")

  $BtnExport_HC_Profiles = GUICtrlCreateButton("Export Profiles",  $deltaX, 70, 140, 30)
  GUICtrlSetOnEvent(-1, "Export_HC_Profiles")

  $BtnImport_HC_Profiles = GUICtrlCreateButton("Import Profiles",  $deltaX, 110, 140, 30)
  GUICtrlSetOnEvent(-1, "Import_HC_Profiles")

  $BtnViewProfilesInBackup = GUICtrlCreateButton("List Profiles in Backup",  $deltaX, 150, 140, 30)
  GUICtrlSetOnEvent(-1, "ViewProfilesInBackup")
 
  $BtnCloseManageProfilesBackup = GUICtrlCreateButton("Close", $deltaX+40, 200, 60, 30)
  GUICtrlSetOnEvent(-1, "CloseManageProfilesBackupGUI")

  Opt("GUIOnEventMode", 1)

  GUISetState(@SW_SHOW, $ManageProfilesBackupGUI)

EndFunc


Func CloseManageProfilesBackupGUI()
   GuiDelete($ManageProfilesBackupGUI)
   CloseTools()
EndFunc


Func HelpManageProfilesBackup()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\ManageProfilesBackup.txt")
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.8)
  _ExtMsgBox(0,"OK", "", $help)
EndFunc

Func RefreshManageProfilesBackupGUI()
  GUISetState(@SW_HIDE,$ManageProfilesBackupGUI)
  GuiDelete($ManageProfilesBackupGUI)
  ManageProfilesBACKUP()
EndFunc


Func Export_HC_Profiles()
; Choose the name
  local $backupPath = SaveBackup2File()
  If $backupPath = "ERROR" Then Return
  Local $7zipPath = "ERROR"
  If @OSArch = "X86" Then $7zipPath = 'c:\windows\Hard_Configurator\TOOLS\7zip(x86)\7z.exe'
  If @OSArch = "X64" Then $7zipPath = 'c:\windows\Hard_Configurator\TOOLS\7zip(x64)\7z.exe'
; MsgBox(0,"",$backupPath)
  If $7zipPath = "ERROR" Then 
     MsgBox(262144,"", "ERROR!. Something is wrong with OS architecture.")
     Return
  EndIf
  If FileExists($7zipPath) = 0 Then
     MsgBox(262144,"", "ERROR!. File (7z.exe) not found.")
     Return
  EndIf
If FileExists($backupPath) Then
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
   Local $y = _ExtMsgBox(0,"&OVERWRITE|CANCEL", "", 'The backup file exists already. Do you want to overwrite it?')
   If $y = 2 Then Return 'DoNotCreate'
   FileDelete($backupPath)
EndIf
; Password input (password must be written)
Local $p = ""
While $p = "" 
  $p = InputBox("Password input.", "Please, write the password for the backup file.", "hard_configurator")
  If @error Then   
     If SaveBackup2File() = 'ERROR' Then Return
  EndIf
WEnd
ExportWhitelistProfiles2RegFile()
WhiteListProfilesToWHL()
Local $iPID = Run($7zipPath & ' a -r -p' & $p & ' ' & chr(34) & $backupPath & chr(34) & ' ' & $ProgramConfigurationFolder & '*.*', "", @SW_HIDE, $STDOUT_CHILD)
ProcessWaitClose($iPID)
$p=""
FileDelete($ProgramConfigurationFolder & "WhitelistProfilesBackup.reg")
FileDelete($ProgramConfigurationFolder & '*.whl')
FileMove($backupPath, StringTrimRight($backupPath, 3) & 'hbp')
MsgBox(262144,"", "Backup file created in the path: " & @CRLF & StringTrimRight($backupPath, 3) & 'hbp')
EndFunc


Func SaveBackup2File()
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
    $sMessage = 'Select the path and name of the backup.'
    ; Display an open dialog to select a list of file(s).
    
    Local $sFileSaveDialog = FileSaveDialog($sMessage, $ProgramFolder & 'Backup', "Configuration files (*.hbp)", $FD_FILEMUSTEXIST)
    If @error Then
        ; Display the error message.
        MsgBox($MB_SYSTEMMODAL, "", "No file(s) were selected." & $sFileSaveDialog)

        ; Change the working directory (@WorkingDir) back to the location of the Configuration folder as FileSaveDialog sets it to the last accessed folder.
        FileChangeDir($ProgramFolder & 'Backup')
        Return "ERROR"
    Else
        ; Change the working directory (@WorkingDir) back to the location of the Configuration folder as FileSaveDialog sets it to the last accessed folder.
        FileChangeDir($ProgramFolder & 'Backup')

        ; Replace instances of "|" with @CRLF in the string returned by FileSaveDialog.
        $sFileSaveDialog = StringReplace($sFileSaveDialog, "|", @CRLF)

        ; Display the list of selected files.
;        MsgBox($MB_SYSTEMMODAL, "", "You chose the following files:" & @CRLF & $sFileSaveDialog)
    EndIf
Return $sFileSaveDialog
EndFunc 


Func ExportWhitelistProfiles2RegFile()
  local $regkey0 = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\Whitelist"
  RunWait(@WindowsDir & "\regedit.exe /e " & $ProgramConfigurationFolder & "WhitelistProfilesBackup.reg" & " " & $regkey0 )
  Local $searchString = '[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\Whitelist'
  Local $replacementString = '[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\temp\Whitelist'
  local $text = FileRead($ProgramConfigurationFolder & "WhitelistProfilesBackup.reg")
  $text = StringReplace($text, $searchString, $replacementstring)
  FileDelete($ProgramConfigurationFolder & "WhitelistProfilesBackup.reg")
  FileWrite($ProgramConfigurationFolder & "WhitelistProfilesBackup.reg", $text)
EndFunc


Func WhiteListProfilesToWHL()

local $var
Local $element
Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\Whitelist'
Local $n = 1
Local $sSubKey = RegEnumKey($mainkey, 1)

While $sSubKey <> ""
  Local $sSubKey = RegEnumKey($mainkey, $n)
  $var = $mainkey & '\' & $sSubKey
  $element = Regread($var, 'text')
  $element = _HexToString($element)
; MsgBox(0,"",$sSubKey & "   " & $element)
  If not ($sSubKey = "") Then FileWrite($ProgramConfigurationFolder & $sSubKey &'.whl',$element)
  $n = $n + 1
WEnd

EndFunc


Func ImportBackup()
   ; Display an open dialog to select a file.
   Local $sFileOpenDialog = FileOpenDialog("Please, choose the backup file to load.", $ProgramFolder & 'Backup', "Backup Files (*.hbp)", $FD_FILEMUSTEXIST)
   If @error Then
      ; Display the error message.
      MsgBox(262144, "", "No file was selected." & $sFileOpenDialog) 
      ; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
      FileChangeDir($ProgramFolder & 'Backup')
      Return 'ERROR'
   Else
      ; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
      FileChangeDir($ProgramFolder & 'Backup')
      If $sFileOpenDialog = "" Then ImportBackup()
      Return $sFileOpenDialog
   EndIf
EndFunc



Func Import_HC_Profiles()
Local $FileDrive, $FilePath, $Filename, $FileExt
Local $backupPath = ImportBackup()
  If $backupPath = 'ERROR' Then Return
  Local $7zipPath = "ERROR"
  If @OSArch = "X86" Then $7zipPath = 'c:\windows\Hard_Configurator\TOOLS\7zip(x86)\7z.exe'
  If @OSArch = "X64" Then $7zipPath = 'c:\windows\Hard_Configurator\TOOLS\7zip(x64)\7z.exe'
; MsgBox(0,"",$backupPath)
  If $7zipPath = "ERROR" Then 
     MsgBox(262144,"", "ERROR!. Something is wrong with OS architecture.")
     Return
  EndIf
  If FileExists($7zipPath) = 0 Then
     MsgBox(262144,"", "ERROR!. File (7z.exe) not found.")
     Return
  EndIf
; Password input
Local $p = ""
While $p = "" 
  $p = InputBox("Password input.", "Please, write the password for the backup file.", "hard_configurator")
  If @error Then   
     If ImportBackup() = 'ERROR' Then Return
  EndIf
WEnd
; Decompress files from backup
Local $path = chr(34) & $ProgramConfigurationFolder & chr(34)
Local $iPID = Run($7zipPath & ' e ' & chr(34) & $backupPath & chr(34) & ' -aos -p' & $p &' -o' & $path, "", @SW_HIDE, $STDOUT_CHILD)
ProcessWaitClose($iPID)
$p=""
Local $sOutput = _HexToString(StdoutRead($iPID, False, True))
;MsgBox(0,"",$sOutput)
; Check if errors
If not (StringInStr($sOutput, 'Archives with Errors:') = 0) Then
   MsgBox(262144,"", "ERROR. Wrong password or corrupted backup file.")
   Return
EndIf
If StringInStr($sOutput, "Can't open as archive:") > 0 Then
   MsgBox(262144,"", "ERROR. Corrupted backup file.")
   Return
EndIf
; Importing White List profiles
ImportWhitelistProfilesFromReg()
_PathSplit($backupPath, $FileDrive, $FilePath, $Filename, $FileExt)
FileDelete($ProgramConfigurationFolder & '*.whl')
FileDelete($ProgramConfigurationFolder & '*.reg')
MsgBox(262144, "", "The new profiles from:  " & $Filename & $FileExt & "  have been successfully imported." & @CRLF & "No profile was overwritten. Profiles with duplicated names were skipped.")
EndFunc


Func ViewProfilesInBackup()
  Local $7zipPath = "ERROR"
  If @OSArch = "X86" Then $7zipPath = 'c:\windows\Hard_Configurator\TOOLS\7zip(x86)\7z.exe'
  If @OSArch = "X64" Then $7zipPath = 'c:\windows\Hard_Configurator\TOOLS\7zip(x64)\7z.exe'
  If $7zipPath = "ERROR" Then 
     MsgBox(262144,"", "ERROR!. Something is wrong with OS architecture.")
     Return
  EndIf
  If FileExists($7zipPath) = 0 Then
     MsgBox(262144,"", "ERROR!. File (7z.exe) not found.")
     Return
  EndIf
Local $backupPath = ImportBackup()
If $backupPath = 'ERROR' Then Return
;ShellExecute($backupPath)
local $iPID = Run($7zipPath & ' l ' & chr(34) & $backupPath & chr(34), "", @SW_HIDE, $STDOUT_CHILD)
ProcessWaitClose($iPID)
Local $sOutput = StdoutRead($iPID, False, True)
; Skip some initial 7-zip info
$sOutput = _HexToString($sOutput)
local $n = StringInStr($sOutput, 'Path = ')
$sOutput = StringTrimLeft($sOutput, $n-1)
; Find local time and convert to string yyyy/mm/dd hh:mm:ss -> yyyy.mm.dd_hh.mm.ss
local $tTime = _Date_Time_GetSystemTime()
$tTime = _Date_Time_SystemTimeToDateTimeStr($tTime, 1)
$tTime = StringReplace($tTime, ':', ".")
$tTime = StringReplace($tTime, '/', ".")
$tTime = StringReplace($tTime, ' ', "_")
; Write the info to file and open it in the notepad with medium rights.
FileWrite($ProgramFolder & 'temp\' & $tTime & '.txt', $sOutput)
local $sCmd = $ProgramFolder & 'temp\' & $tTime & '.txt'
FindWhitelstDuplicatesInBackup($sOutput, $sCmd)
_ShellExecuteWithReducedPrivileges(@WindowsDir & '\notepad.exe ',$sCmd, '', '', @SW_SHOWNORMAL, False)
If @error > 0 Then 
   ShellExecuteWithReducedPrivileges(@WindowsDir & '\notepad.exe ',$sCmd, '', '', @SW_SHOWNORMAL, False)
   MsgBox(0,"", 'Could not run Notepad with reduced rights. Notepad will be run with elevation.')
EndIf
EndFunc


Func ImportWhitelistProfilesFromReg()
RunWait(@WindowsDir & "\regedit.exe /s " & $ProgramConfigurationFolder & 'WhitelistProfilesBackup.reg')
Local $s_key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\temp\Whitelist'
Local $d_key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\Whitelist'
_RegCopyKey($s_key, $d_key, False)
RegDelete($s_key)
EndFunc


Func FindWhitelstDuplicatesInBackup($x, $y)
; $x contain the info text
Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\Whitelist'
Local $n = 1
Local $sSubKey = RegEnumKey($mainkey, 1)
Local $duplicatedSettingProfile
Local $starstext = @CRLF & '******************************************************************' & @CRLF
Local $minustext = '------------------------------------------------------------------------------------'
FileWrite($y, @CRLF & @CRLF & 'Duplicated Profiles, that cannot be imported (already present in Hard_Configurator):')
FileWrite($y,  @CRLF & $minustext & @CRLF & 'Duplicated White List profiles (*.whl):' & @CRLF)
While $sSubKey <> ""
  Local $sSubKey = RegEnumKey($mainkey, $n)
  If StringInStr($x, $sSubKey &'.whl') > 0 Then
      If not ($sSubKey = "") Then FileWrite($y, $sSubKey &'.whl' & @CRLF)
  EndIf
  $n = $n + 1
WEnd
Local $ArraySettingProfileList = _FileListToArray ($ProgramConfigurationFolder, "*.hdc", 1)
;_ArrayDisplay($ArraySettingProfileList)
;MsgBox(0,"", UBound($ArraySettingProfileList))

FileWrite($y, @CRLF & 'Duplicated Setting Profiles (*.hdc):' & @CRLF)
If UBound($ArraySettingProfileList) >1 Then
   For $n =1 To UBound($ArraySettingProfileList) - 1
;     MsgBox(0,"", $ArraySettingProfileList[$n])
     If StringInStr($x, $ArraySettingProfileList[$n]) > 0 Then
        FileWrite($y, $ArraySettingProfileList[$n] & @CRLF)
     EndIf
   Next
EndIf

EndFunc
