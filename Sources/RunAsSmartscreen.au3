#include <Array.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#RequireAdmin
Local $FileDrive='' 
Local $Filename=''
Local $FilePath=''
Local $FileExt=''
 
_PathSplit ( $CmdLine[1], $FileDrive, $FilePath, $Filename, $FileExt)
Local $FileSystem = DriveGetFileSystem ($FileDrive)

;Manage non NTFS drives = copy file to @TempDir on the system hard drive.
If not ($FileSystem="NTFS") Then 
FileCopy ( $CmdLine[1], @TempDir & '\' & $Filename & $FileExt)
$CmdLine[1] = @TempDir & '\' & $Filename & $FileExt
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

;Manage Alternate Data Stream to force SmartScreen check
If $Smartscreen = 1 Then
   FileSetAttrib($CmdLine[1],"-RHS")
   ADS_Delete($CmdLine[1])   
   ADS_ADD($CmdLine[1])
EndIf

;Run the file
ShellExecute($CmdLine[1],"",$FileDrive & $FilePath)

;EndIf



; Functions
Func ADS_ADD($sFilename)
    Local $sZoneIDFileName
    ; Streams are assembled as "filename" + ":" + "Stream_ID"
    $sZoneIDFileName = FileWriteLine($sFilename & ":Zone.Identifier","[ZoneTransfer]")
    $sZoneIDFileName = FileWriteLine($sFilename & ":Zone.Identifier","ZoneId=3") 
EndFunc


Func ADS_Delete($sFilename)
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
