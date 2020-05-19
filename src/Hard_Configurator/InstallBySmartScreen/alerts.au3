
#include <Array.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include 'ExtMsgBox.au3'
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

   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
    If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
        _ExtMsgBox(0,"OK", "Install By SmartScreen Alert", "Use it with executable file path as an argument.")
    Else
        _ExtMsgBox(0,"OK", "Install application Alert", "Use it with executable file path as an argument.")
    EndIf

   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
   If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
      _ExtMsgBox(0,"OK", "Install By SmartScreen Alert", "The file has been blocked. It has tried to run a command line. This is the common way used by malware to change system settings or run malicious scripts. Run this file only if you are certain that it is safe.")
   Else    
      _ExtMsgBox(0,"OK", "Install application Alert", "The file has been blocked. It has tried to run a command line. This is the common way used by malware to change system settings or run malicious scripts. Run this file only if you are certain that it is safe.")
   EndIf


   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
   If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
      _ExtMsgBox(0,"OK", "Install By SmartScreen Alert", "Only EXE and MSI files are supported.")
   Else
      _ExtMsgBox(0,"OK", "Install application Alert", "Only EXE and MSI files are supported.")
   EndIf

      _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
      _ExtMsgBox(0,"OK", "Install By SmartScreen Alert", "Windows SmartScreen is disabled. Please enable it to make use of 'Install By SmartScreen'")
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
   If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
      _ExtMsgBox(0,"OK", "Install By SmartScreen Alert", "Warning." & @CRLF & "Something is trying to bypass 'Install by SmartScreen' feature via DLL hijacking. Your computer is probably compromised by unknown malware.")
   Else
      _ExtMsgBox(0,"OK", "Install application Alert", "Warning." & @CRLF & "Something is trying to bypass 'Install application' feature via DLL hijacking. Your computer is probably compromised by unknown malware.")
   EndIf


Local $name = 'Install By SmartScreen'
If not (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then $name = 'Install application'

Local $help1 = "This file cannot be run via '" & $name & "' from the current location. One or more DLL files are in the same location, and this can bypass SmartScreen via DLL hijacking. " & @Crlf
Local $help2 = "The file will be executed from another location, without loading the DLL files from the current location." & @Crlf & @Crlf
Local $help3 = "Warning." & @Crlf
Local $help4 = "Do not run this file from the current location without using '" & $name & "' or 'Run By SmartScreen', until you are sure that DLL files in the current location are clean. Please note, that they can be often hidden, except when Windows Explorer is set to show hidden files." & @Crlf
_ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.6)
Local $x = _ExtMsgBox(0,"&CANCEL|RUN ANYWAY", $name & " HELP", $help1 & $help2 & $help3 & $help4)


Local $name = 'Install By SmartScreen'
If not (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8") Then $name = 'Install application'

   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
   _ExtMsgBox(0,"OK", $name & " Alert", "Warning." & @CRLF & "Something has been tampered '" & $name & "'. This can be a disk error or your computer is compromised by unknown malware.") 



   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
   _ExtMsgBox(0,"OK", $name & " Alert", "Warning." & @CRLF & "Free disk space on your home hard disk " & "c:\" & " is too low. '" & $name & "' requires " & 1000 & " MB of free space to run this file.")
   Exit
