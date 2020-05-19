#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Windows\Hard_Configurator\Icons\RAS.ico
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Comment=Compiled with AutoIt 3.3.14.2
#AutoIt3Wrapper_Res_Description=InstallBySmartScreen, Run installation/update executables with SmartScreen check.
#AutoIt3Wrapper_Res_Fileversion=3.0.0.1
#AutoIt3Wrapper_Res_LegalCopyright=Copyright *  Andy Ful , April 2020
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; This script can run the executable files with Administrative Rights + SmartScreen.
; If the file is in User Space the program adds "Mark of the Web" , so it is run with SmartScreen check.
; If the file is in System Space (Windows, Program Files, Program Files (x86)) then the SmartScreen
; check is skipped.
; Only EXE and MSI files are supported

#include <Array.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include 'ExtMsgBox.au3'
;#include 'BlockArchivers.au3'
#include <Crypt.au3>
#include <StringConstants.au3>

;#RequireAdmin
;#include <WinAPIProc.au3>
Global $systemdrive = EnvGet('systemdrive')
Local $oldHash = 0
Local $FileDrive='' 
Local $Filename=''
Local $FilePath=''
Local $FileExt=''
Local $IsSmartScreenEnabled = 1
Local $FileTempDir = @TempDir & '\' & 'H_C_'
Local $FileTempDirRandom = $FileTempDir & '\' & Random(5150,6230,1)
Local $LowerExeRestrictions = 0
Local $InitialFileSize = 0
Local $fileAlreadyCopied = 0
Local $text = ""

;Run parameters check 
If $CmdLine[0] = 0 Then 
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
    If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
        _ExtMsgBox(0,"OK", "Install By SmartScreen Alert", "Use it with executable file path as an argument.")
    Else
        _ExtMsgBox(0,"OK", "Install application Alert", "Use it with executable file path as an argument.")
    EndIf
  Exit
EndIf

;Commandline parameters check. If greater than 1 then block with alert.
If $CmdLine[0] > 1 Then
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
   If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
      _ExtMsgBox(0,"OK", "Install By SmartScreen Alert", "The file has been blocked. It has tried to run the command line. This is the common way used by malware to change system settings or run malicious scripts. Run this file only if you are certain that it is safe.")
   Else    
      _ExtMsgBox(0,"OK", "Install application Alert", "The file has been blocked. It has tried to run the command line. This is the common way used by malware to change system settings or run malicious scripts. Run this file only if you are certain that it is safe.")
   EndIf
   Exit
EndIf

; Find the hash of the file to run
$oldHash = FindFileHash($CmdLine[1])
$InitialFileSize = FileGetSize ($CmdLine[1])

_PathSplit ( $CmdLine[1], $FileDrive, $FilePath, $Filename, $FileExt)
Local $FileSystem = DriveGetFileSystem ($FileDrive)
Local $Arr_DLL_list = _FileListToArray ( $FileDrive & $FilePath, "*.dll", 1)
;MsgBox(262144,"",$Cmdline[1] & @CRLF & $FilePath & @CRLF & $Filename & @CRLF & $FileExt )

$FileExt = StringLower($FileExt)

If not ($FileExt = ".exe" or $FileExt = ".msi") Then
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
   If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
      _ExtMsgBox(0,"OK", "Install By SmartScreen Alert", "Only EXE and MSI files are supported.")
   Else
      _ExtMsgBox(0,"OK", "Install application Alert", "Only EXE and MSI files are supported.")
   EndIf
   Exit
EndIf

If StringInStr(StringLower($FileDrive & $FilePath), StringLower($FileTempDir)) = 1 Then
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
   _ExtMsgBox(0,"OK", "Install Alert", "The file cannot be run from this location.")
   Exit
EndIf


;Test if SmartScreen is Enabled
If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
   Local $ES1 = RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows\System', 'EnableSmartScreen')
   If @error<>0  Then $ES1 = 'ERROR'
   Local $ES2 = RegRead('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer', 'SmartScreenEnabled')
   If @error<>0 Then $ES2 = 'ERROR'
   If $ES1='0' Then
      $IsSmartScreenEnabled = 0
   Else
      IF ($ES2='Off' and $ES1='ERROR') Then $IsSmartScreenEnabled = 0
   EndIf
   If ($ES1 = 'ERROR' and $ES2 = 'ERROR') Then
      RegWrite ('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer', 'SmartScreenEnabled', 'REG_SZ', 'Prompt')
      $IsSmartScreenEnabled = 1
   EndIf
EndIf

;correction to InstallBySmartScreen for WIndows 7 and Vista
;If not (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
;   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
;   _ExtMsgBox(0,"OK", "Install By SmartScreen Alert", "Install By SmartScreen is not supported in this version of Windows.")
;   Exit
;EndIf

;correction to InstallBySmartScreen for WIndows 7 and Vista
If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
   If $IsSmartScreenEnabled = 0 Then
      _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
      _ExtMsgBox(0,"OK", "Install By SmartScreen Alert", "Windows SmartScreen is disabled. Please enable it to make use of 'Install By SmartScreen'")
      Exit
   EndIf
EndIf



;Trim file path to compare next with Windows, Program Files, and Program Files (x86).
Local $x = StringLeft($CmdLine[1],11)
Local $y = StringLeft($CmdLine[1],17)
Local $z = StringLeft($CmdLine[1],23)
Local $PF86=1
Local $Smartscreen = 1

;Check for false "Program Files (x86)" folder in 32Bit Windows
If (@OSArch='X86' and FileExists ( @ProgramFilesDir & ' (x86)\') = 1) then $PF86=0

;Exclude System Space from SmartScreen check
If StringLower($x) = StringLower(@WindowsDir & '\') Then $Smartscreen = 0
If StringLower($y)=StringLower(@ProgramFilesDir & '\') Then $Smartscreen = 0
If ($PF86=1 and StringLower($z)=StringLower(@ProgramFilesDir & ' (x86)\')) then $Smartscreen = 0
If SearchWhitelistedPaths($CmdLine[1]) = 1 Then $Smartscreen = 0


If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
   $text = "SmartScreen check. "
Else
   $text = ""
EndIf
;****************************************************************************
SplashTextOn("", $text & "Please wait a minute.", 300, 40, -1, -1, 1, "", 10)
;****************************************************************************

;Manage non NTFS drives = copy file to @TempDir on the system hard drive.
If  ($Smartscreen = 1 And $fileAlreadyCopied = 0) Then
   If not ($FileSystem="NTFS") Then
	DirRemove($FileTempDir,1)
	DirCreate($FileTempDirRandom)
	FileCopy ( $CmdLine[1], $FileTempDirRandom & '\' & $Filename & $FileExt)
	$CmdLine[1] = $FileTempDirRandom & '\' & $Filename & $FileExt
        $fileAlreadyCopied = 1
   EndIf
EndIf


;  MsgBox(0,"",UBound($Arr_DLL_list))

If ($fileAlreadyCopied = 0 And $FileExt = ".exe" and $InitialFileSize < 11000000 and UBound($Arr_DLL_list) > 1 and  $Smartscreen = 1) Then
;	MsgBox(0,"", FileGetSize ($CmdLine[1]))
;	_ArrayDisplay($Arr_DLL_list)
	Help2_RAS()
	If $FileSystem="NTFS" Then
		DirRemove($FileTempDir,1)
		DirCreate($FileTempDirRandom)
		FileCopy ( $CmdLine[1], $FileTempDirRandom & '\' & $Filename & $FileExt)
		$CmdLine[1] = $FileTempDirRandom & '\' & $Filename & $FileExt
		$fileAlreadyCopied = 1
	EndIf
EndIf

;MsgBox(0,"**2**",$oldHash)

; Check the DLL hijacking attempt in the FileTempDirRandom folder
$Arr_DLL_list = _FileListToArray ($FileTempDirRandom, "*.dll", 1)
;_ArrayDisplay($Arr_DLL_list)
If UBound($Arr_DLL_list) > 1 Then
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
   If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
      _ExtMsgBox(0,"OK", "Install By SmartScreen Alert", "Warning." & @CRLF & "Something is trying to bypass 'Install by SmartScreen' feature via DLL hijacking. Your computer is probably compromised by unknown malware.")
   Else
      _ExtMsgBox(0,"OK", "Install application Alert", "Warning." & @CRLF & "Something is trying to bypass 'Install application' feature via DLL hijacking. Your computer is probably compromised by unknown malware.")
   EndIf
   Exit  
EndIf


$LowerExeRestrictions = CheckLowerExeRestrictions()
If ($LowerExeRestrictions > 0 And $Smartscreen = 1 And $fileAlreadyCopied = 0) Then
	DirRemove($FileTempDir,1)
	DirCreate($FileTempDirRandom)
	FileCopy ( $CmdLine[1], $FileTempDirRandom & '\' & $Filename & $FileExt)
	$CmdLine[1] = $FileTempDirRandom & '\' & $Filename & $FileExt
	$fileAlreadyCopied = 1
EndIf

;MsgBox(0,"",$CmdLine[1] & @crlf & $LowerExeRestrictions & @crlf & $Smartscreen & @crlf & $fileAlreadyCopied)

;Finally, check the file hash and run the file
If $InitialFileSize > 250000000 Then CheckFreeSpace($CmdLine[1], $InitialFileSize)

Manage_ADS()
FinallyRunTheFile($CmdLine[1], $oldHash, $FileDrive & $FilePath, $LowerExeRestrictions)

;************
SplashOff()
;*************

;*******************************************************************

; Functions

Func ADS_ADD($sFilename)
Local $name = "'Install By SmartScreen'"
If (@OSVersion="WIN_7" or @OSVersion="WIN_VISTA") then $name = "'Install application'"
;If not (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then Return
;Add "Mark of the Web"
  Local $sZoneIDFileName
  ; Streams are assembled as "filename" + ":" + "Stream_ID"
  $sZoneIDFileName = FileWriteLine($sFilename & ":Zone.Identifier","[ZoneTransfer]")
  $sZoneIDFileName = FileWriteLine($sFilename & ":Zone.Identifier","ZoneId=3") 
  ;Test if the 'Mark of the Web' was properly written
  Local $isOK1 = FileReadLine($sFilename & ":Zone.Identifier",1)
  Local $isOK2 = FileReadLine($sFilename & ":Zone.Identifier",2)
  If ($isOK1 = "[ZoneTransfer]" and $isOK2 = "ZoneId=3") Then
     Return
  Else
     _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
     _ExtMsgBox(0,"OK", $name & " Alert", "Write access error. The 'Mark of the Web' was skipped. The file  " & $sFilename & "  cannot be run via " & $name & ".") 
     Exit
  EndIf

EndFunc


Func ADS_Delete($sFilename)
;If not (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then Return
;Delete Alternate Data Stream used by SmartScreen to mark files
    Local $aRet, $sZoneIDFileName
    ; Streams are assembled as "filename" + ":" + "Stream_ID"
    $sZoneIDFileName = $sFilename & ":Zone.Identifier"

    ; Make sure the stream exists
    If FileExists($sZoneIDFileName) Then
        ; While FileExists() works, FileDelete() doesn't, probably due to some internal sanity checks
        $aRet = DllCall("kernel32.dll", "bool", "DeleteFileW", "wstr", $sZoneIDFileName)
        If @error Then Return SetError(2, @error,0)
        Return $aRet[0]
    EndIf
    Return 0
EndFunc


Func IsMarkOfTheWeb($Filename)
 ;Test if the 'Mark of the Web' was properly written
  Local $isOK1 = FileReadLine($Filename & ":Zone.Identifier",1)
  Local $isOK2 = FileReadLine($Filename & ":Zone.Identifier",2)
  If ($isOK1 = "[ZoneTransfer]" and $isOK2 = "ZoneId=3") Then
     Return "1"
  Else 
     Return "0"
  EndIf
EndFunc

Func IsSRPDefaultDeny()
  Local $keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
  Local $valuename = "DefaultLevel"
  Local $SRPDefaultLevel = RegRead ( $keyname, $valuename )
  Switch $SRPDefaultLevel
     case "0"
        Return "1"
     case 131072
        Return "1"
     case Else
        Return "?"
  EndSwitch
EndFunc


Func SearchWhitelistedPaths($itemnew)
Local $MaxWhitelistEntries = 2000
 #include <MsgBoxConstants.au3>
 Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\'
 Local $sSubKey = ""
 For $i = 1 To $MaxWhitelistEntries
   $sSubKey = RegEnumKey('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths', $i)
   If @error Then ExitLoop
   Local $itemold = RegRead($mainkey & $sSubKey, 'ItemData')
   If (StringInStr($itemnew, $itemold) = 1 ) Then
;   MsgBox (0,"", StringInStr($itemold, $itemnew) & '    ' &  StringInStr($itemnew, $itemold))
   Return '1'
   EndIf
 Next
 Return '0'

EndFunc

Func Help2_RAS()
Local $name = 'Install By SmartScreen'
If not (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then $name = 'Install application'

Local $help1 = "This file cannot be run via '" & $name & "' from the current location. One or more DLL files are in the same location, and this can tamper the installation via DLL hijacking." & @Crlf

Local $help2 = "The file will be executed from another location, without loading the DLL files from the current location." & @Crlf & @Crlf

Local $help3 = "Warning." & @Crlf

Local $help4 = "Do not run this file from the current location without using '" & $name & "', until you are sure that DLL files in the current location are clean. Please note, that they can be often hidden, except when Windows Explorer is set to show hidden files." & @Crlf

_ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.6)
Local $x = _ExtMsgBox(0,"&CANCEL|RUN ANYWAY", $name & " HELP", $help1 & $help2 & $help3 & $help4)
If $x < 2 Then Exit
If $x = 2 Then Return

EndFunc


Func FindFileHash($FilePathToHash)
   Local $iAlgorithm = $CALG_SHA1
   _Crypt_Startup()
   Local $dHash = 0
   If (StringStripWS($FilePathToHash, $STR_STRIPALL) <> "" And FileExists($FilePathToHash)) Then
      $dHash = _Crypt_HashFile($FilePathToHash, $iAlgorithm)
;      MsgBox(0,"",$FilePathToHash & @CRLF & $oldHash & @CRLF & $dHash)
   EndIf
   _Crypt_Shutdown()
   Return $dHash
EndFunc



Func CheckLowerExeRestrictions()
;***************This function must be exactly copied from MoreSRPRestrictions.au3 ************
Local $path0 = $systemdrive & '\Users\*\AppData'
Local $path1 = $systemdrive & '\ProgramData'
Local $path = $path0
Local $EXEext = '\*.exe'
Local $TMPext = '\*.tmp'
Local $MSIext = '\*.msi'

Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144\Paths\{1016bbe0-a716-428b-822e-4E544B6A3'
Local $n = 0
Local $m = 0
If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
   For $i = 301 to 320
      $path = $path & '\*'
      If RegRead($RegGUID & $i & '}', 'SaferFlags') = '0' Then
	$m = $m + 1
      EndIf
      If RegRead($RegGUID & $i & '}', 'ItemData') = $path & $EXEext Then
	$m = $m + 1
      EndIf
;     MsgBox(0,"",RegRead($RegGUID & $i & '}', 'ItemData') & @CRLF & $path & $EXEext)
   Next
   $path = $path0
   For $i = 321 to 340
      $path = $path & '\*'
      If RegRead($RegGUID & $i & '}', 'SaferFlags') = '0' Then
	$m = $m + 1
      EndIf
      If RegRead($RegGUID & $i & '}', 'ItemData') = $path & $TMPext Then
	$m = $m + 1
      EndIf
;     MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $TMPext)
   Next
   $path = $path0
   For $i = 341 to 360
      $path = $path & '\*'
      If RegRead($RegGUID & $i & '}', 'SaferFlags') = '0' Then $n = $n+1
      If RegRead($RegGUID & $i & '}', 'ItemData') = $path & $MSIext Then $n = $n+1
;     MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $MSIext)
   Next
   $path = $path1
   For $i = 361 to 380
      $path = $path & '\*'
      If RegRead($RegGUID & $i & '}', 'SaferFlags') = '0' Then
	$m = $m + 1
      EndIf
      If RegRead($RegGUID & $i & '}', 'ItemData') = $path & $EXEext Then
	$m = $m + 1
      EndIf
;     MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $EXEext)
   Next
   $path = $path1
   For $i = 381 to 400
      $path = $path & '\*'
      If RegRead($RegGUID & $i & '}', 'SaferFlags') = '0' Then
	$m = $m + 1
      EndIf
      If RegRead($RegGUID & $i & '}', 'ItemData') = $path & $TMPext Then
	$m = $m + 1
      EndIf
;     MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $TMPext)
   Next
   $path = $path1
   For $i = 401 to 420
      $path = $path & '\*'
      If RegRead($RegGUID & $i & '}', 'SaferFlags') = '0' Then $n = $n+1
      If RegRead($RegGUID & $i & '}', 'ItemData') = $path & $MSIext Then $n = $n+1
;     MsgBox(0,"",$RegGUID & $i & '}'& @CRLF & $path & $MSIext)
   Next
;   MsgBox(0,"",$m & @crlf & $n)
; Return 1 ----> '\*.exe', '\*.tmp', and '\*.msi' paths restricted
; Return 3 ----> only '\*.msi' paths restricted
; Return 0 = no restrictions
; Return 2 wrong settings
   If $m + $n = 240 Then Return 1
   If ($m = 0 and $n = 80) Then Return 3
   If ($m = 120 and $n = 60) Then Return 4
   If ($m = 0 and $n = 60) Then Return 5
   If $m + $n = 0 Then Return 0
   Return 2
EndIf

EndFunc




Func FinallyRunTheFile($_path, $_hash, $_currFolder, $standard)
Local $name = 'Install By SmartScreen'
If not (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then $name = 'Install application'

;MsgBox(0,"",$_path)
If $_hash = FindFileHash($_path) Then
    Switch $standard
	case '0'
	    Local $MSIPid = ShellExecute($_path,"",$_currFolder, "runas")
	case Else
	    Local $MSIPid = ShellExecute($_path,"",$_currFolder)
    EndSwitch

; Exit when chosing 'Do not Run' from SmartScreen prompt.
   If ($MSIPid=0) Then Exit
Else
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
   _ExtMsgBox(0,"OK", $name & " Alert", "Warning." & @CRLF & "Something has been tampered '" & $name & "'. This can be a disk error or your computer is compromised by unknown malware.") 
   Exit
EndIf
EndFunc


Func CheckFreeSpace($_path, $_filesize)
Local $name = 'Install By SmartScreen'
If not (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then $name = 'Install application'

Local $FileDrive='' 
Local $Filename=''
Local $FilePath=''
Local $FileExt=''
_PathSplit ($_path, $FileDrive, $FilePath, $Filename, $FileExt)
Local $iFreeSpace = Round(DriveSpaceFree($FileDrive & "\") - 4*$_filesize/1000000 - 500)
;MsgBox(0, "", "Free Space: " & $iFreeSpace & " MB")
If $iFreeSpace -1000 >= 0 Then
   Return 1
Else
    $iFreeSpace = - ($iFreeSpace - 1000)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
   _ExtMsgBox(0,"OK", $name & " Alert", "Warning." & @CRLF & "Free disk space on your home hard disk " & $FileDrive & " is too low. '" & $name & "' requires " & $iFreeSpace & " MB of free space to run this file.")
   Exit
EndIf
EndFunc


Func Manage_ADS()
;Manage Alternate Data Stream to force SmartScreen check
If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
   If $Smartscreen = 1 Then
      If not ($FileExt = ".bat" or $FileExt = ".cmd" or $FileExt = ".com" or $FileExt = ".cpl" or $FileExt = ".dll" or $FileExt = ".exe" or $FileExt = ".jse" or $FileExt = ".msi"  or $FileExt = ".ocx" or $FileExt = ".scr" or $FileExt = ".vbe") Then
         _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
         _ExtMsgBox(0,"OK", "Install By SmartScreen Alert", "The  " & $FileExt & "  files are not supported by SmartScreen Application Reputation.")
         Exit
      EndIf
      FileSetAttrib($CmdLine[1],"-RHS")
      ADS_Delete($CmdLine[1])   
      ADS_ADD($CmdLine[1])
;;     Special alert for DLL and OCX files   
;      If ($FileExt = ".dll" or $FileExt = ".ocx") Then
;         _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
;         _ExtMsgBox(0,"OK", "Install By SmartScreen Alert", "The 'Mark of the Web' was added to  " & $Filename & $FileExt & "  file.")
;         Exit
;      EndIf
   EndIf
EndIf
If (@OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
   If $Smartscreen = 1 Then
      FileSetAttrib($CmdLine[1],"-RHS")
      ADS_Delete($CmdLine[1])   
      ADS_ADD($CmdLine[1])
   EndIf
EndIf
EndFunc

