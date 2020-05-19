#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Windows\Hard_Configurator\Icons\RBS.ico
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Comment=
#AutoIt3Wrapper_Res_Description=Run By SmartScreen
#AutoIt3Wrapper_Res_Fileversion=3.1.0.1
#AutoIt3Wrapper_Res_LegalCopyright=Copyright *  Andy Ful , December 2019
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; 'Run By Smartscreen' can run the executable file with SmartScreen check even if it does not have
;'Mark of the Web'.

#include <Array.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include 'ExtMsgBox.au3'
#include <Crypt.au3>
#include <StringConstants.au3>
Global $oldHash

Local $FileDrive=''
Local $Filename=''
Local $FilePath=''
Local $FileExt=''
Local $IsSmartScreenEnabled = 1
Local $FileTempDir = @TempDir & '\' & 'H_C_'
Local $FileTempDirRandom = $FileTempDir & '\' & Random(5150,6230,1)
Local $fileAlreadyCopied = 0

_ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)

;Test the Windows version
If not (@OSVersion="WIN_10" or  @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
   _ExtMsgBox(0,"&OK", "Run By SmartScreen", "Only Windows 10, Windows 8.1, and Windows 8 are supported.")
EndIf

If (@ScriptName = 'RunBySmartscreen(x64).exe' And @OSArch = "X86") Then
   _ExtMsgBox(0,"&OK", "Run By SmartScreen", "This file works only on 64-bit Windows version.")
   Exit
EndIf

If (@ScriptName = 'RunBySmartscreen(x86).exe' And @OSArch = "X64") Then
   _ExtMsgBox(0,"&OK", "Run By SmartScreen", "This file works only on 32-bit Windows version.")
   Exit
EndIf

;Test if Smartscreen is enabled
Local $ES1 = RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows\System', 'EnableSmartScreen')
If $ES1="0" Then $IsSmartScreenEnabled = 0
Local $ES2 = RegRead('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer', 'SmartScreenEnabled')
If @error Then $IsSmartScreenEnabled = 0
If (@OSBuild < 15063) And (StringLower($ES2) <> "prompt" And StringLower($ES2) <> "requireadmin") Then
   $IsSmartScreenEnabled = 0
EndIf
If $ES2 = 'Off' Then $IsSmartScreenEnabled = 0
If $IsSmartScreenEnabled = 0 Then
      If IsAdmin() = 0 Then
         If $CmdLine[0] > 0 Then
            _ExtMsgBox(0,"&OK", "Run By SmartScreen", "Cannot use 'Run By SmartScreen' because SmartScreen for Explorer is Disabled. Please, enable SmartScreen or reinstall RunBySmartScreen application to correct this issue.")
            Exit
         EndIf
      Else
        RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer', 'SmartScreenEnabled', 'REG_SZ', 'Prompt')
        RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\System', 'EnableSmartScreen')
        RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\System', 'ShellSmartScreenLevel')
      EndIf
EndIf

;MsgBox(0,"", "OS build = " & @OSBuild & @crlf & "Policy = " & $ES1 & @crlf & "Explorer = " & $ES2)

;Commandline parameters check. If greater than 1 then block with alert.
If $CmdLine[0] > 1 Then
    _ExtMsgBox(0,"&OK", "Run By SmartScreen", "The file has been blocked. It has tried to run with the command line. This is the common way used by malware to change system settings or run malicious scripts. Run this file only if you are certain that it is safe.")
    Exit
EndIf


;Commandline parameters check. If equal 0 then install 'Run By SmartScreen'.
;If not 0, then 'Run By SmartScreen' the file in $CmdLine[1]
If $CmdLine[0] = 0 Then
   ;Check if the program has been run with Administrative Rights (needed to write keys to the Registry)
   If IsAdmin() = 0 Then
      _ExtMsgBox(0,"&OK", "Run By SmartScreen", "You have to run this file with 'Run as administrator' from Explorer context menu.")
      Exit
   EndIf
;   Local $YesNo = MsgBox(4,"","Do you want to add the 'Run By SmartScreen' option in Explorer context menu?")
    Local $YesNo = _ExtMsgBox(0,"&YES|NO|HELP", "Run By SmartScreen", "Do you want to add the 'Run By SmartScreen' option in Explorer context menu?")
   Switch $YesNo
       case 1
	  Local $value
          If @OSArch="X64" Then $value = @WindowsDir & '\RunBySmartscreen(x64).exe "%1" %*'
          If @OSArch="X86" Then $value = @WindowsDir & '\RunBySmartscreen(x86).exe "%1" %*'
          Copy_RunBySmartScreen_to_Windows()
          Local $keyname = 'HKEY_CLASSES_ROOT\*\shell\Run By SmartScreen\command'
          Local $valuename = ""
          Local $keynameIcon = 'HKCR\*\shell\Run By SmartScreen'
          Local $valueIcon
          If @OSArch="X64" Then $valueIcon = @WindowsDir & '\RunBySmartscreen(x64).exe'
          If @OSArch="X86" Then $valueIcon = @WindowsDir & '\RunBySmartscreen(x86).exe'
          RegWrite($keynameIcon, 'Icon','REG_SZ',$valueIcon)
          RegWrite($keyname, '','REG_SZ',$value)
          ADD_WSH_TO_ExplorerContextMenu()
	  ADD_URL_TO_ExplorerContextMenu()
	  ADD_PIF_TO_ExplorerContextMenu()
	  ADD_apprefms_TO_ExplorerContextMenu()
	  ADD_WEBSITE_TO_ExplorerContextMenu()
; 	Enable system-wide protected view for files from unsafe locations for Adobe  Reader 10+ and Adobe Reader DC
 	  If @OSArch = "X64" Then
	     RegWrite('HKLM\SOFTWARE\Wow6432Node\Policies\Adobe\Acrobat Reader\11.0\FeatureLockDown', 'iProtectedView','REG_DWORD',Number('1'))
	     RegWrite('HKLM\SOFTWARE\Wow6432Node\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown', 'iProtectedView','REG_DWORD',Number('1'))
	     RegWrite('HKLM\SOFTWARE\Wow6432Node\Policies\Adobe\Acrobat Reader\10.0\FeatureLockDown', 'iProtectedView','REG_DWORD',Number('1'))
	  EndIf
	  RegWrite('HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\10.0\FeatureLockDown', 'iProtectedView','REG_DWORD',Number('1'))
	  RegWrite('HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\11.0\FeatureLockDown', 'iProtectedView','REG_DWORD',Number('1'))
	  RegWrite('HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown', 'iProtectedView','REG_DWORD',Number('1'))
          _ExtMsgBox(0,"&OK", "Run By SmartScreen", "'Run By SmartScreen' is enabled. Please, choose this option in Explorer right-click context menu to open all new files. This program can run/check executables with SmartScreen, open vulnerable files with warning, and block files with dangerous extensions. Safe files will be run/opened without warning." )
          Exit
       case 2
          RegDelete('HKEY_CLASSES_ROOT\*\shell\Run By SmartScreen')
          REMOVE_WSH_FROM_ExplorerContextMenu()
	  REMOVE_URL_FROM_ExplorerContextMenu()
	  REMOVE_PIF_FROM_ExplorerContextMenu()
	  REMOVE_apprefms_FROM_ExplorerContextMenu()
	  REMOVE_WEBSITE_FROM_ExplorerContextMenu()
 	  If @OSArch = "X64" Then
	     RegDelete('HKLM\SOFTWARE\Wow6432Node\Policies\Adobe\Acrobat Reader\11.0\FeatureLockDown', 'iProtectedView')
	     RegDelete('HKLM\SOFTWARE\Wow6432Node\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown', 'iProtectedView')
	     RegDelete('HKLM\SOFTWARE\Wow6432Node\Policies\Adobe\Acrobat Reader\10.0\FeatureLockDown', 'iProtectedView')
	  EndIf
	  RegDelete('HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\10.0\FeatureLockDown', 'iProtectedView')
	  RegDelete('HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\11.0\FeatureLockDown', 'iProtectedView')
	  RegDelete('HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown', 'iProtectedView')
          _ExtMsgBox(0,"&OK", "Run By SmartScreen", "'Run By SmartScreen' is disabled." )
          Exit
       case 3
          HelpRBS()
          Exit
       case Else
	  Exit
   EndSwitch
EndIf

;MsgBox(0,"",$Cmdline[1] & @CRLF & $FilePath & @CRLF & $Filename & @CRLF & $FileExt )


_PathSplit ( $CmdLine[1], $FileDrive, $FilePath, $Filename, $FileExt)
Local $FileSystem = DriveGetFileSystem ($FileDrive)
Local $Arr_DLL_list = _FileListToArray ( $FileDrive & $FilePath, "*.dll", 1)

$FileExt = StringLower($FileExt)


; Find the hash of the file to run
$oldHash = FindFileHash($CmdLine[1])
; Remove old H_C temporary files.
DirRemove($FileTempDir,1)

;Trim file path to compare next with Windows, Program Files, and Program Files (x86).
Local $x = StringLeft($CmdLine[1],11)
Local $y = StringLeft($CmdLine[1],17)
Local $z = StringLeft($CmdLine[1],23)
Local $PF86=1
Local $UserSpace = 1
Local $SmartScreen = -1

;Check for false "Program Files (x86)" folder in 32Bit Windows
If (@OSArch='X86' and FileExists ( @ProgramFilesDir & ' (x86)\') = 1) then $PF86=0

;Exclude System Space from SmartScreen check
If StringLower($x) = StringLower(@WindowsDir & '\') Then $UserSpace = 0
If StringLower($y)=StringLower(@ProgramFilesDir & '\') Then $UserSpace = 0
If ($PF86=1 and StringLower($z)=StringLower(@ProgramFilesDir & ' (x86)\')) then $UserSpace = 0

;https://fileinfo.com/search
;https://gist.github.com/rxwx/8834cee60e077531c4db2f260ee55e2a
;Check dangerous extensions (like file extensions blocked in SRP, OWA, Adobe Reader) to be blocked
If ($FileExt = ".app" or $FileExt = ".arc" or $FileExt = ".asp" or $FileExt = ".bz" or $FileExt = ".bz2" or $FileExt = ".cab" or $FileExt = ".class" or $FileExt = ".command" or $FileExt = ".csh" or $FileExt = ".diagcab" or $FileExt = ".desktop" or $FileExt = ".fxp" or $FileExt = ".gz" or $FileExt = ".hex" or $FileExt = ".hpj" or $FileExt = ".htc" or $FileExt = ".hqx" or $FileExt = ".ie" or $FileExt = ".ini" or $FileExt = ".its" or $FileExt = ".job" or $FileExt = ".ksh" or $FileExt = ".lzh" or $FileExt = ".mad" or $FileExt = ".mag" or $FileExt = ".mas" or $FileExt = ".mau" or $FileExt = ".mav" or $FileExt = ".may" or $FileExt = ".mcf" or $FileExt = ".maw" or $FileExt = ".mdz" or $FileExt = ".msu" or $FileExt = ".nsh" or $FileExt = ".osd" or $FileExt = ".ops" or $FileExt = ".pi" or $FileExt = ".pif" or $FileExt = ".pkg" or $FileExt = ".prf" or $FileExt = ".prg" or $FileExt = ".printerexport" or $FileExt = ".pst" or $FileExt = ".sea" or $FileExt = ".shb" or $FileExt = ".sit" or $FileExt = ".tar" or $FileExt = ".taz" or $FileExt = ".tgz" or $FileExt = ".tool" or $FileExt = ".term" or $FileExt = ".terminal" or $FileExt = ".theme" or $FileExt = ".tmp" or $FileExt = ".url" or $FileExt = ".vbp" or $FileExt = ".vsmacros" or $FileExt = ".vss" or $FileExt = ".vst" or $FileExt = ".vsw" or $FileExt = ".was" or $FileExt = ".webloc" or $FileExt = ".webpnp" or $FileExt = ".z" or $FileExt = ".zlo" or $FileExt = ".zoo" or $FileExt = ".air" or $FileExt = ".appref-ms" or $FileExt = ".acm" or $FileExt = ".asa" or $FileExt = ".aspx" or $FileExt = ".ax" or $FileExt = ".ad" or $FileExt = ".application" or $FileExt = ".asx" or $FileExt = ".cer" or $FileExt = ".cfg" or $FileExt = ".chi" or $FileExt = ".cla" or $FileExt = ".clb" or $FileExt = ".cnt" or $FileExt = ".cnv" or $FileExt = ".cpx" or $FileExt = ".crx" or $FileExt = ".crazy" or $FileExt = ".der" or $FileExt = ".dir" or $FileExt = ".dcr" or $FileExt = ".dmg" or $FileExt = ".drv" or $FileExt = ".fon" or $FileExt = ".gadget" or $FileExt = ".grp" or $FileExt = ".htt" or $FileExt = ".ime" or $FileExt = ".jnlp" or $FileExt = ".local" or $FileExt = ".manifest" or $FileExt = ".mht" or $FileExt = ".mhtml" or $FileExt = ".mmc" or $FileExt = ".mof" or $FileExt = ".msh" or $FileExt = ".msh1" or $FileExt = ".msh2" or $FileExt = ".mshxml" or $FileExt = ".msh1xml" or $FileExt = ".msh2xml" or $FileExt = ".mui" or $FileExt = ".nls" or $FileExt = ".pl" or $FileExt = ".perl" or $FileExt = ".plg" or $FileExt = ".ps1" or $FileExt = ".ps2" or $FileExt = ".ps1xml" or $FileExt = ".ps2xml" or $FileExt = ".psc1" or $FileExt = ".psc2" or $FileExt = ".psd1" or $FileExt = ".psdm1" or $FileExt = ".pstreg" or $FileExt = ".py" or $FileExt = ".pyc" or $FileExt = ".pyo" or $FileExt = ".pyd" or $FileExt = ".py3" or $FileExt = ".pyx" or $FileExt = ".pyw" or $FileExt = ".pywz" or $FileExt = ".pxd" or $FileExt = ".pyi" or $FileExt = ".pyz" or $FileExt = ".pyde" or $FileExt = ".pyp" or $FileExt = ".pyt" or $FileExt = ".pyzw" or $FileExt = ".rb" or $FileExt = ".rpy" or $FileExt = ".sys" or $FileExt = ".tlb" or $FileExt = ".tsp" or $FileExt = ".xbap" or $FileExt = ".xnk" or $FileExt = ".xpi" or $FileExt = ".desklink" or $FileExt = ".glk" or $FileExt = ".library-ms" or $FileExt = ".mapimail" or $FileExt = ".mydocs" or $FileExt = ".sct" or $FileExt = ".search-ms" or $FileExt = ".searchConnector-ms" or $FileExt = ".stm" or $FileExt = ".swf" or $FileExt = ".spl" or $FileExt = ".vxd" or $FileExt = ".website" or $FileExt = ".zfsendtotarget" or $FileExt = ".xml") Then
$Smartscreen = 0
EndIf

If ($FileExt = ".wsh" or $FileExt = ".wsf" or $FileExt = ".wsc" or $FileExt = ".ws" or $FileExt = ".vbs" or $FileExt = ".vb" or $FileExt = ".shs" or $FileExt = ".settingcontent-ms" or $FileExt = ".sct" or $FileExt = ".reg" or $FileExt = ".pcd" or $FileExt = ".ocx" or $FileExt = ".mst" or $FileExt = ".msp" or $FileExt = ".msc" or $FileExt = ".mde" or $FileExt = ".mdb" or $FileExt = ".js" or $FileExt = ".jar" or $FileExt = ".isp" or $FileExt = ".iqy" or $FileExt = ".ins" or $FileExt = ".inf" or $FileExt = ".hta" or $FileExt = ".hlp" or $FileExt = ".dll" or $FileExt = ".crt" or $FileExt = ".cpl" or $FileExt = ".chm" or $FileExt = ".bas" or $FileExt = ".adp" or $FileExt = ".ade" or $FileExt = ".bat" or $FileExt = ".cmd" or $FileExt = ".jse" or $FileExt = ".vbe" or $FileExt = ".dot" or $FileExt = ".wbk" or $FileExt = ".wiz" or $FileExt = ".docm" or $FileExt = ".dotx" or $FileExt = ".dotm" or $FileExt = ".docb" or $FileExt = ".rtf" or $FileExt = ".xlt" or $FileExt = ".xlm" or $FileExt = ".xlsm" or $FileExt = ".xltx" or $FileExt = ".xltm" or $FileExt = ".xlsb" or $FileExt = ".xla" or $FileExt = ".xlam" or $FileExt = ".xll" or $FileExt = ".xlw" or $FileExt = ".pot" or $FileExt = ".pps" or $FileExt = ".pptm" or $FileExt = ".potx" or $FileExt = ".potm" or $FileExt = ".ppam" or $FileExt = ".ppsx" or $FileExt = ".ppsm" or $FileExt = ".sldx" or $FileExt = ".xps" or $FileExt = ".sldm" or $FileExt = ".adn" or $FileExt = ".accdr" or $FileExt = ".accdt" or $FileExt = ".accda" or $FileExt = ".mdw" or $FileExt = ".accde" or $FileExt = ".mam" or $FileExt = ".maq" or $FileExt = ".mar" or $FileExt = ".mat" or $FileExt = ".maf" or $FileExt = ".laccdb" or $FileExt = ".cdb" or $FileExt = ".mda" or $FileExt = ".mdn" or $FileExt = ".mdt" or $FileExt = ".mdf" or $FileExt = ".ldb" or $FileExt = ".csv" or $FileExt = ".db" or $FileExt = ".dif" or $FileExt = ".dqy" or $FileExt = ".htm" or $FileExt = ".ods" or $FileExt = ".oqy" or $FileExt = ".prn" or $FileExt = ".rqy" or $FileExt = ".slk" or $FileExt = ".xla" or $FileExt = ".xlb" or $FileExt = ".xlc" or $FileExt = ".xld" or $FileExt = ".xltm") Then
$Smartscreen = 0
EndIf


; Enumerate file extensions for adding MOTW
If ($FileExt = ".com" or $FileExt = ".exe" or $FileExt = ".msi" or $FileExt = ".scr" or $FileExt = ".docx" or $FileExt = ".doc" or $FileExt = ".xls" or $FileExt = ".xlsx" or $FileExt = ".ppt" or $FileExt = ".pub" or $FileExt = ".pptx" or $FileExt = ".accdb" or $FileExt = ".zip" or $FileExt = ".pdf") Then $Smartscreen = 1

If ($FileExt = ".7z" or $FileExt = ".arj" or $FileExt = ".rar" or $FileExt = ".zipx") Then $Smartscreen = 2

; Block dangerous file extensions
If ($UserSpace = 1 And $Smartscreen = 0) Then
;      MsgBox(0,"", "The  " & StringUpper($FileExt) & "  file can be dangerous. Please open it only if you are really sure that it is safe.")
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.4)
   _ExtMsgBox(0,"&OK", "Run By SmartScreen", "The  " & StringUpper($FileExt) & "  file can be dangerous. Please open it only if you are really sure that it is safe.")
      Exit
EndIf

If ($UserSpace = 1 And $Smartscreen = 2) Then
   If $FileSystem="NTFS" Then
;      Add MOTW
       FileSetAttrib($CmdLine[1],"-RHS")
       ADS_Delete($CmdLine[1])
       ADS_ADD($CmdLine[1])
   EndIf
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
   If $FileExt = ".7z" Then _ExtMsgBox(0,"&OK", "Run By SmartScreen", "This is 7-ZIP compressed archive. Please, use the 7-ZIP program or another program that can support .7z archives to decompres the archive. Next, use 'Run By SmartScreen' to safely open/check the decompressed files.")
   If $FileExt = ".arj" Then _ExtMsgBox(0,"&OK", "Run By SmartScreen", "This is ARJ-compressed archive. Please, use the WinArj program or another program that can support .arj archives to decompres the archive. Next use 'Run By SmartScreen' to safely open/check the decompressed files.")
   If $FileExt = ".rar" Then _ExtMsgBox(0,"&OK", "Run By SmartScreen", "This is RAR-compressed archive. Please, use the WinRar program or another program that can support .rar archives to decompres the archive. Next use 'Run By SmartScreen' to safely open/check the decompressed files.")
   If $FileExt = ".zipx" Then _ExtMsgBox(0,"&OK", "Run By SmartScreen", "This is ZIPX-compressed archive. Please, use the WinZip program or another program that can support .zipx archives to decompres the archive. Next use 'Run By SmartScreen' to safely open/check the decompressed files.")
   Exit
EndIf


If ($UserSpace = 1 And $Smartscreen = 1) Then
;;  Special alert for DLL and OCX files
;   If ($FileExt = ".dll" or $FileExt = ".ocx") Then
;      _ExtMsgBox(0,"&OK", "Run By SmartScreen", "The 'Mark of the Web' was added to  " & $Filename & $FileExt & "  file.")
;      Exit
;   EndIf

  If ($FileExt = ".rtf" or $FileExt = ".docx" or $FileExt = ".doc" or $FileExt = ".xls" or $FileExt = ".xlsx" or $FileExt = ".ppt" or $FileExt = ".pub" or $FileExt = ".pptx" or $FileExt = ".accdb") Then
      _ExtMsgBox(0,"&OK", "Run By SmartScreen", "This is the popular file type related to Office applications, but also a very popular way to infect the computers via e-mail attachments. Can be dangerous because of the embedded active executable code. Be very careful and do not ignore security warnings." & @crlf & "* Do not change from protected view to editing mode (when 'Enable editing')." & @crlf & "* Do not enable macros." & @crlf & "* Do not allow updating links that may refer to other files." & @crlf & "* Do not click icons or other objects embedded in the document." & @crlf & "* Do not allow running external files." & @crlf & "* Do not follow the links embedded in the document." & @crlf & "Do not do this especially when you are instructed in the document to do so, because it is the well known phishing trick. Anyway, the documents with an active content can be often non-malicious, but you must be really sure about this when enabling the full content.")
  EndIf

  If $FileExt = ".pdf" Then
      _ExtMsgBox(0,"&OK", "Run By SmartScreen", "This is Adobe PDF document which can be often abused to infect the computers via e-mail attachments. Can be dangerous because of the embedded active executable code. Be very careful and do not ignore security warnings." & @crlf & "* Do not change from the 'Protected view' to 'Enable all functions' mode." & @crlf & "* Do not enable scripts." & @crlf & "* Do not allow updating links that may refer to the external sources." & @crlf & "* Do not click icons or other objects embedded in the document." & @crlf & "* Do not follow the links embedded in the document." & @crlf & "Do not do the above, especially when you are instructed in the document to do so, because it is the well known phishing trick." & @crlf & "Anyway, the PDF documents with an active content can be non-malicious, but you must be really sure about this when enabling the full content.")
  EndIf

; Manage non NTFS drives = copy file to @TempDir on the system hard drive.
  If  ($Smartscreen > 0 And $fileAlreadyCopied = 0) Then
    If not ($FileSystem="NTFS") Then
	DirCreate($FileTempDirRandom)
	FileCopy ( $CmdLine[1], $FileTempDirRandom & '\' & $Filename & $FileExt)
	$CmdLine[1] = $FileTempDirRandom & '\' & $Filename & $FileExt
        $fileAlreadyCopied = 1
    EndIf
  EndIf

;  MsgBox(0,"",UBound($Arr_DLL_list))
  If ($fileAlreadyCopied = 0 And $FileExt = ".exe" and FileGetSize ($CmdLine[1]) < 11000000 and UBound($Arr_DLL_list) > 1) Then
;	MsgBox(0,"", FileGetSize ($CmdLine[1]))
;	_ArrayDisplay($Arr_DLL_list)
	Help2_RBS()
	If $FileSystem="NTFS" Then
		DirCreate($FileTempDirRandom)
		FileCopy ( $CmdLine[1], $FileTempDirRandom & '\' & $Filename & $FileExt)
		$CmdLine[1] = $FileTempDirRandom & '\' & $Filename & $FileExt
	EndIf
  EndIf
; Add MOTW
  FileSetAttrib($CmdLine[1],"-RHS")
  ADS_Delete($CmdLine[1])
  ADS_ADD($CmdLine[1])
EndIf

;MsgBox(0,"**2**",$oldHash)

; Check the DLL hijacking attempt in the FileTempDirRandom folder
$Arr_DLL_list = _FileListToArray ($FileTempDirRandom, "*.dll", 1)
;_ArrayDisplay($Arr_DLL_list)
If UBound($Arr_DLL_list) > 1 Then
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
   _ExtMsgBox(0,"OK", "Run By SmartScreen Alert", "Warning." & @CRLF & "Something is trying to bypass 'Run by SmartScreen' feature via DLL hijacking. Your computer is probably compromised by unknown malware.")
   Exit  
EndIf

;Finally, check the file hash and run the file
If $oldHash = FindFileHash($CmdLine[1]) Then
   ShellExecute($CmdLine[1],"",$FileDrive & $FilePath)
Else
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
   _ExtMsgBox(0,"OK", "Run By SmartScreen Alert", "Warning." & @CRLF & "Something has been tampered 'Run by SmartScreen'. This can be a disk error or your computer is compromised by unknown malware.") 
   Exit
EndIf



; Functions

Func ADS_ADD($sFilename)
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
     _ExtMsgBox(0,"&OK", "Run By SmartScreen", "Write access error. The 'Mark of the Web' was skipped. The file  " & $sFilename & "  cannot be 'Run By Smartscreen'.")
     Exit
  EndIf
EndFunc


Func ADS_Delete($sFilename)
;Delete Alternate Data Stream (Zone.Identifier) used by Smartscreen to mark files

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


Func Copy_RunBySmartScreen_to_Windows()
Local $error
If @OSArch="X64" Then
   $error=FileCopy( @ScriptDir & '\RunBySmartscreen(x64).exe', @WindowsDir & '\RunBySmartscreen(x64).exe', 1)
   If $error=0 Then
        _ExtMsgBox(0,"&OK", "Run By SmartScreen", 'Installation aborted. Cannot copy the file  ' & @ScriptDir & '\RunBySmartscreen(x64).exe' & '  to C:\Windows  folder' )
        Exit
   EndIf
EndIf
If @OSArch="X86" Then
   $error=FileCopy( @ScriptDir & '\RunBySmartscreen(x86).exe', @WindowsDir & '\RunBySmartscreen(x86).exe', 1)
   If $error=0 Then
        _ExtMsgBox(0,"&OK", "Run By SmartScreen", 'Installation aborted. Cannot copy the file  ' & @ScriptDir & '\RunBySmartscreen(x86).exe' & '  to C:\Windows  folder' )
        Exit
   EndIf
EndIf
EndFunc


Func ADD_WSH_TO_ExplorerContextMenu()
RegRead('HKEY_CLASSES_ROOT\WSHFile', 'IsShortcut')
If not @error Then 
   RegDelete('HKEY_CLASSES_ROOT\WSHFile', 'IsShortcut')
   RegWrite('HKEY_CLASSES_ROOT\WSHFile', 'NoIsShortcut', 'REG_SZ','')
EndIf
EndFunc


Func REMOVE_WSH_FROM_ExplorerContextMenu()
RegRead('HKEY_CLASSES_ROOT\WSHFile', 'NoIsShortcut')
If not @error Then 
   RegDelete('HKEY_CLASSES_ROOT\WSHFile', 'NoIsShortcut')
   RegWrite('HKEY_CLASSES_ROOT\WSHFile', 'IsShortcut', 'REG_SZ','')
EndIf
EndFunc


Func ADD_URL_TO_ExplorerContextMenu()
RegRead('HKEY_CLASSES_ROOT\IE.AssocFile.URL', 'IsShortcut')
If not @error Then 
   RegDelete('HKEY_CLASSES_ROOT\IE.AssocFile.URL', 'IsShortcut')
   RegWrite('HKEY_CLASSES_ROOT\IE.AssocFile.URL', 'NoIsShortcut', 'REG_SZ','')
EndIf
RegRead('HKEY_CLASSES_ROOT\InternetShortcut', 'IsShortcut')
If not @error Then 
   RegDelete('HKEY_CLASSES_ROOT\InternetShortcut', 'IsShortcut')
   RegWrite('HKEY_CLASSES_ROOT\InternetShortcut', 'NoIsShortcut', 'REG_SZ','')
EndIf
EndFunc

Func REMOVE_URL_FROM_ExplorerContextMenu()
RegRead('HKEY_CLASSES_ROOT\IE.AssocFile.URL', 'NoIsShortcut')
If not @error Then 
   RegDelete('HKEY_CLASSES_ROOT\IE.AssocFile.URL', 'NoIsShortcut')
   RegWrite('HKEY_CLASSES_ROOT\IE.AssocFile.URL', 'IsShortcut', 'REG_SZ','')
EndIf
RegRead('HKEY_CLASSES_ROOT\InternetShortcut', 'NoIsShortcut')
If not @error Then 
   RegDelete('HKEY_CLASSES_ROOT\InternetShortcut', 'NoIsShortcut')
   RegWrite('HKEY_CLASSES_ROOT\InternetShortcut', 'IsShortcut', 'REG_SZ','')
EndIf
EndFunc


Func ADD_apprefms_TO_ExplorerContextMenu()
RegRead('HKEY_CLASSES_ROOT\Application.Reference', 'IsShortcut')
If not @error Then 
   RegDelete('HKEY_CLASSES_ROOT\Application.Reference', 'IsShortcut')
   RegWrite('HKEY_CLASSES_ROOT\Application.Reference', 'NoIsShortcut', 'REG_SZ','')
EndIf
EndFunc


Func REMOVE_apprefms_FROM_ExplorerContextMenu()
RegRead('HKEY_CLASSES_ROOT\Application.Reference', 'NoIsShortcut')
If not @error Then 
   RegDelete('HKEY_CLASSES_ROOT\Application.Reference', 'NoIsShortcut')
   RegWrite('HKEY_CLASSES_ROOT\Application.Reference', 'IsShortcut', 'REG_SZ','')
EndIf
EndFunc


Func ADD_PIF_TO_ExplorerContextMenu()
RegRead('HKEY_CLASSES_ROOT\piffile', 'IsShortcut')
If not @error Then 
   RegDelete('HKEY_CLASSES_ROOT\piffile', 'IsShortcut')
   RegWrite('HKEY_CLASSES_ROOT\piffile', 'NoIsShortcut', 'REG_SZ','')
EndIf
EndFunc


Func REMOVE_PIF_FROM_ExplorerContextMenu()
RegRead('HKEY_CLASSES_ROOT\piffile', 'NoIsShortcut')
If not @error Then 
   RegDelete('HKEY_CLASSES_ROOT\piffile', 'NoIsShortcut')
   RegWrite('HKEY_CLASSES_ROOT\piffile', 'IsShortcut', 'REG_SZ','')
EndIf
EndFunc

Func ADD_WEBSITE_TO_ExplorerContextMenu()
RegRead('HKCR\IE.AssocFile.WEBSITE', 'IsShortcut')
If not @error Then
   RegDelete('HKCR\IE.AssocFile.WEBSITE', 'IsShortcut')
   RegWrite('HKCR\IE.AssocFile.WEBSITE', 'NoIsShortcut', 'REG_SZ','')
EndIf
RegRead('HKCR\Microsoft.Website', 'IsShortcut')
If not @error Then
   RegDelete('HKCR\Microsoft.Website', 'IsShortcut')
   RegWrite('HKCR\Microsoft.Website', 'NoIsShortcut', 'REG_SZ','')
EndIf
EndFunc

Func REMOVE_WEBSITE_FROM_ExplorerContextMenu()
RegRead('HKEY_CLASSES_ROOT\IE.AssocFile.WEBSITE', 'NoIsShortcut')
If not @error Then 
   RegDelete('HKEY_CLASSES_ROOT\IE.AssocFile.WEBSITE', 'NoIsShortcut')
   RegWrite('HKEY_CLASSES_ROOT\IE.AssocFile.WEBSITE', 'IsShortcut', 'REG_SZ','')
EndIf
RegRead('HKEY_CLASSES_ROOT\Microsoft.Website', 'NoIsShortcut')
If not @error Then 
   RegDelete('HKEY_CLASSES_ROOT\Microsoft.Website', 'NoIsShortcut')
   RegWrite('HKEY_CLASSES_ROOT\Microsoft.Website', 'IsShortcut', 'REG_SZ','')
EndIf
EndFunc


Func HelpRBS()
;***************
Local $help ="'Run By SmartScreen' works only with Windows 8 and higher versions." & @crlf & "It is based on a very simple idea to open/run safely the new files, when using right-click Explorer context menu. It covers in a smart way file opening in the User Space ( = everything outside 'C:\Windows', 'C:\Program Files', 'C:\Program Files (x86)'). This program can manage files in the User Space, as follows:" & @crlf & "1. Run/check executables with SmartScreen." & @crlf & "2. Block files with potentially dangerous extensions." & @crlf & "3. Open vulnerable files with the warning instruction." & @crlf & "Safe files are run/opened without warnings." & @crlf & "Advanced users can apply 'Run By SmartScreen' for EXE and MSI installers (from sources not supported by SmartScreen) to force the SmartScreen check. Not Advanced users should consistently use 'Run By SmartScreen' for all new files." & @crlf & "See *HOW 'RUN BY SMARTSCREEN' WORKS* section for more details." & @crlf & "" & @crlf & "Why the SmartScreen?" & @crlf & "The SmartScreen technology is one of the best for fighting 0-day malware files." & @crlf & "" & @crlf & "Why 'Run By SmartScreen'?" & @crlf & "SmartScreen technology is fully adopted in Windows 10 Enterprise editions (via Application Control), but not in Windows Home or Professional editions. 'SmartScreen Application Reputation' (on Run) usually checks the executable with MOTW (Mark of the Web), that is attached to the file after downloading from the Internet by popular Web Browsers, Microsoft Store, Windows OneDrive, or another online service with MOTW. Yet, there are many cases when the files do not have MOTW, and then SmartScreen filter can ignore them on the run (see REMARKS)." & @crlf & "" & @crlf & "" & @crlf & "" & @crlf & "INSTALLATION" & @crlf & "" & @crlf & "For 64-bit OS" & @crlf & "Run executable  RunBySmartScreen(x64).exe with Administrative Rights ('Run as administrator' option in Explorer context menu). The message: *Do you want to add the 'Run By SmartScreen' option in Explorer context menu?* will be shown. Choose the 'YES' button. After that, the 'Run By SmartScreen' option should appear in Explorer context menu." & @crlf & "" & @crlf & "For 32-bit OS" & @crlf & "Do as in the case of 64-bit, but choose RunBySmartScreen(x86).exe" & @crlf & "" & @crlf & "The installation changes the default 'Protected View' setting in Adobe Reader 10+/DC, so the files from potentially unsafe locations are opened in 'Protected View'." & @crlf & "" & @crlf & "" & @crlf & "UNINSTALLATION" & @crlf & "" & @crlf & "For 64-bit OS" & @crlf & "Navigate to RunBySmartScreen(x64).exe in 'C:\Windows' folder, and run this file with Administrative Rights ('Run as administrator' option in Explorer context menu). The message: *Do you want to add the 'Run By SmartScreen' option in Explorer context menu?* will be shown. Choose the 'NO' button. After that, the executable can be manually deleted." & @crlf & "" & @crlf & "For 32-bit OS" & @crlf & "Do as in the case of 64-bit, but choose RunBySmartScreen(x86).exe" & @crlf & "" & @crlf & "The uninstallation recovers the default 'Protected View' = OFF setting in Adobe Reader 10+/DC." & @crlf & "" & @crlf & "" & @crlf 

$help = $help & "HOW 'RUN BY SMARTSCREEN' WORKS" & @crlf & "" & @crlf & "This program is intended to help inexperienced users to open all new files. If the user tries to open the file with 'Run By SmartScreen' it works as follows:" & @crlf & "1. Executables (COM, EXE, MSI, and SCR files) located in the System Space (= inside 'C:\Windows', 'C:\Program Files', 'C:\Program Files (x86)') are opened normally, without SmartScreen check." & @crlf & "2. The above executables located in the User Space (= outside 'C:\Windows', 'C:\Program Files', 'C:\Program Files (x86)') are checked by SmartScreen before running." & @crlf & "3. Files from the User Space, with potentially dangerous extensions (scripts, most MS Office files, etc.), are not allowed to open (similarly to Software Restriction Policies), and the program shows an alert." & @crlf & "4. Shortcuts with a command line in the 'Target' area, are always blocked and the program shows an alert." & @crlf & "5. Compressed archives not supported by Windows build-in unpacker  (.7z, .arj, .rar, .zipx) are not opened - only the short instruction is displayed." & @crlf & "6. Popular formats related to MS Office and Adobe Acrobat Reader (DOC, DOCX, XLS, XLSX, PUB, PPT, PPTX, ACCDB, PDF) are opened with the warning instruction, and the MOTW is added to the file." & @crlf & "7. During the installation, 'Run By SmartScreen' changes the Adobe Reader 10+/DC 'Protected View' setting, similarly to the default 'Protected View' setting in MS Office 2010+. So, the popular file types (DOC, DOCX, XLS, XLSX, PUB, PPT, PPTX, ACCDB, PDF) are opened in 'Protected View'." & @crlf & "8. Other files (ZIP archives, media, photos, etc.) are opened normally without warnings." & @crlf & "" & @crlf & "The program has hardcoded list of unsafe (potentially dangerous) file extensions:" & @crlf & "ACCDA, ACCDE, ACCDR, ACCDT, ACM, AD, ADE, ADN, ADP, AIR, APP, APPLICATION, APPREF-MS, ARC, ASA, ASP, ASPX, ASX, AX, BAS, BAT, BZ, BZ2, CAB, CDB, CER, CFG, CHI, CHM, CLA, CLASS, CLB, CMD, CNT, CNV, COMMAND, CPL, CPX, CRAZY, CRT, CRX, CSH, CSV, DB, DCR, DER, DESKLINK, DESKTOP, DIAGCAB, DIF, DIR, DLL, DMG, DOCB, DOCM, DOT, DOTM, DOTX, DQY, DRV, FON, FXP, GADGET, GLK, GRP, GZ, HEX, HLP, HPJ, HQX, HTA, HTC, HTM, HTT, IE, IME, INF, INI, INS, IQY, ISP, ITS, JAR, JNLP, JOB, JS, JSE, KSH, LACCDB, LDB, LIBRARY-MS, LOCAL, LZH, MAD, MAF, MAG, MAM, MANIFEST, MAPIMAIL, MAQ, MAR, MAS, MAT, MAU, MAV, MAW, MAY, MCF, MDA, MDB, MDE, MDF, MDN, MDT, MDW, MDZ, MHT, MHTML, MMC, MOF, MSC, MSH, MSH1, MSH1XML, MSH2, MSH2XML, MSHXML, MSP, MST, MSU, MUI, MYDOCS, NLS, NSH, OCX, ODS, OPS, OQY, OSD, PCD, PERL, PI, PIF, PKG, PL, PLG, POT, POTM, POTX, PPAM, PPS, PPSM, PPSX, PPTM, PRF, PRG, PRINTEREXPORT, PRN, PS1, PS1XML, PS2, PS2XML, PSC1, PSC2, PSD1, PSDM1, PST, PSTREG, PXD, PY, PY3, PYC, PYD, PYDE, PYI, PYO, PYP, PYT, PYW, PYWZ, PYX, PYZ, PYZW, RB, REG, RPY, RQY, RTF, SCT, SEA, SEARCH-MS, SEARCHCONNECTOR-MS, SETTINGCONTENT-MS, SHB, SHS, SIT, SLDM, SLDX, SLK, SPL, STM, SWF, SYS, TAR, TAZ, TERM, TERMINAL, TGZ, THEME, TLB, TMP, TOOL, TSP, URL, VB, VBE, VBP, VBS, VSMACROS, VSS, VST, VSW, VXD, WAS, WBK, WEBLOC, WEBPNP, WEBSITE, WIZ, WS, WSC, WSF, WSH, XBAP, XLA, XLAM, XLB, XLC, XLD, XLL, XLM, XLSB, XLSM, XLT, XLTM, XLTX, XLW, XML, XNK, XPI, XPS, Z, ZFSENDTOTARGET, ZLO, ZOO" & @crlf & @crlf & "The above list is based on SRP, Outlook Web Access, Gmail, and Adobe Acrobat Reader file extension blacklists." & @crlf & "The files with extensions: BAT, CMD, CPL, DLL, JSE, OCX, and VBE are supported by SmartScreen Application Reputation. But, their SmartScreen detection is not good, so they are added to the list of unsafe file extensions. Even if they are accepted by SmartScreen, then will be blocked with notification." & @crlf & "" & @crlf & "" & @crlf & "" & @crlf 

$help = $help & "REMARKS" & @crlf & "The SmartScreen Filter in Windows 8+ allows some vectors of infection listed below:" & @crlf & "" & @crlf & "A) You have got the executable file (BAT, CMD, COM, CPL, DLL, EXE, JSE, MSI, OCX, SCR and VBE) using:" & @crlf & "* the downloader or torrent application (EagleGet, utorrent etc.);" & @crlf & "* container format file (ZIP, 7Z, ARJ, RAR, etc.), except for ZIP files unpacked by Windows built-in unpacker." & @crlf & "* CD/DVD/Blue-ray disc;" & @crlf & "* CD/DVD/Blue-ray disc image (iso, bin, etc.);" & @crlf & "* non NTFS USB storage device (FAT32 pendrive, FAT32 USB disk);" & @crlf & "* Memory Card;" & @crlf & "so the file does not have the proper Alternate Data Stream attached ('Mark of the Web')." & @crlf & "" & @crlf & "B) You have run the executable file with runas.exe (Microsoft), AdvancedRun (Nirsoft), RunAsSystem.exe (AprelTech.com), etc." & @crlf & "" & @crlf & "'Run By SmartScreen' covers all vectors of infection listed in the A) point." & @crlf & "" & @crlf & "Registry changes:" & @crlf & "HKCR\*\shell\Run By SmartScreen\" & @crlf & "HKCR\WSHFile!IsShortcut" & @crlf & "HKCR\WSHFile!NoIsShortcut" & @crlf & "HKCR\IE.AssocFile.URL!IsShortcut" & @crlf & "HKCR\IE.AssocFile.URL!NoIsShortcut" & @crlf & "HKCR\InternetShortcut!IsShortcut" & @crlf & "HKCR\InternetShortcut!NoIsShortcut" & @crlf & "HKCR\Application.Reference!IsShortcut" & @crlf & "HKCR\Application.Reference!NoIsShortcut" & @crlf & @crlf & "The Registry keys (except the first) allow displaying 'Run By SmartScreen' option in Explorer context menu for WSH, URL, and APPREF-MS shortcut files (NoIsShortcut entry), which normally are not displayed (IsShortcut entry)." & @crlf & @crlf & "PROGRAM INFO" & @crlf & "'Run By SmartScreen' was coded and compiled with AutoIt v3.3.14.2 (see RunBySmartscreen.au3 source file)." & @crlf & "This is the stable version 3.1.0.0, updated in June 2019." & @crlf & "Download files from:" & @crlf & "https://github.com/AndyFul/Run-By-Smartscreen"
;***************
FileDelete(@TempDir & '\RBSHelp.txt')
FileWrite(@TempDir & '\RBSHelp.txt', $help)
ShellExecute('notepad.exe',@TempDir & '\RBSHelp.txt')
EndFunc


Func Help2_RBS()

Local $help1 = "This is an executable EXE file (*.exe) and it should not be run from the current location. SmartScreen can be bypassed here, because some DLL files have been found in the same location." & @Crlf & @Crlf

Local $help2 = "Press the <CANCEL> button if you are not sure what to do. The file execution will be canceled and these DLLs will not execute, too." & @Crlf & @Crlf

Local $help3 = "Press the <RUN ANYWAY> button to run the file from a safe location while skipping these DLLs. Please note, that the file will execute successfully, only if it is an application installer or portable application." & @Crlf & @Crlf

Local $help4 = "Warning." & @Crlf & "Do not run any file from the current location without using 'Run By SmartScreen' until you are sure that these DLLs are clean. Please note, that they can be often hidden, except when Windows Explorer is set to show hidden files." & @Crlf

_ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.6)
Local $x = _ExtMsgBox(0,"&CANCEL|RUN ANYWAY", "Run By SmartScreen HELP", $help1 & $help2 & $help3 & $help4)
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
