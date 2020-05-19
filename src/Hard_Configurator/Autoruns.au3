Func Autoruns1()
Autoruns()
;   Refresh TOOLS GUI WIndow
    RefreshToolsGUIWindow()
EndFunc

Func Autoruns()
 #include <AutoItConstants.au3>
   Local $x
   Local $y
   Local $temp
   Local $FileDrive, $FilePath, $Filename, $FileExt
   Local $ArrayFilePathSplit
   Local $AutorunsArray[1] = [""]
   Global $ValidPathsArray[1] = [""]
   Global $NoValidPathsArray[1] = [""]
   Global $ScriptAutorunsLogArray[1]=[""]
   Local $autorunsEula = 0
;  Execute Sysinternals Autorunsc64.exe to have log with autoruns entries.
;  $STDOUT_CHILD and StdoutRead are needed to get the output from commandline program Autorunsc64.exe
   RegWrite("HKCU\Software\Sysinternals\AutoRuns", "EulaAccepted", "REG_DWORD", 1)
   Local $autorunsEula = RegRead("HKCU\Software\Sysinternals\AutoRuns", "EulaAccepted")
   If @OSARCH = "X64" Then
     If not ($autorunsEula = 1) Then RunWait($ProgramFolder & 'TOOLS\Autoruns(x64)\autorunsc64.exe -a * *', "", @SW_SHOW, "")
     Local $iPID = Run($ProgramFolder & 'TOOLS\Autoruns(x64)\autorunsc64.exe -a * *', "", @SW_HIDE, $STDOUT_CHILD)
   EndIf
   If @OSARCH = "X86" Then
     If not ($autorunsEula = 1) Then RunWait($ProgramFolder & 'TOOLS\Autoruns(x86)\autorunsc.exe -a * *', "", @SW_SHOW, "")
     Local $iPID = Run($ProgramFolder & 'TOOLS\Autoruns(x86)\autorunsc.exe -a * *', "", @SW_SHOW, $STDOUT_CHILD)
   EndIf
Local $sMessage = "Please wait !  It will take some time."
SplashTextOn("Autoruns check", $sMessage, 250, 40, -1, -1, 0, "", 10)
   ProcessWaitClose($iPID)
   Local $sOutput = StdoutRead($iPID, False, True)
   FileWrite($ProgramFolder & 'Autoruns.log', $sOutput)
;  Read the Autoruns.log into an array.
      _FileReadToArray($ProgramFolder & 'Autoruns.log', $AutorunsArray)
      If @error Then
          MsgBox($MB_SYSTEMMODAL, "", "There was an error reading the file. @error: " & @error)
      Else
;        _ArrayDisplay($AutorunsArray)
      EndIf

;  Remove from the array, the autoruns entries located in the System Space
   For $n=1 To $AutorunsArray[0]
      If (StringInStr ( $AutorunsArray[$n], ':\') = 0 And StringInStr ( $AutorunsArray[$n], '%\') = 0 ) Then $AutorunsArray[$n] = ""
;     CheckScriptAutoruns() puts script path to $ScriptAutorunsLogArray Global Array
      CheckScriptAutoruns($AutorunsArray[$n])
      If not (StringInStr ( $AutorunsArray[$n], @WindowsDir & '\') = 0 ) Then
        If (StringInStr ( $AutorunsArray[$n], ':\', 0, 2) = 0) & (StringInStr ( $AutorunsArray[$n], '%\') = 0 ) Then  $AutorunsArray[$n] = ""
      EndIf
      If not (StringInStr ( $AutorunsArray[$n], @ProgramFilesDir & '\') = 0 ) Then
        If (StringInStr ( $AutorunsArray[$n], ':\', 0, 2) = 0) & (StringInStr ( $AutorunsArray[$n], '%\') = 0 ) Then  $AutorunsArray[$n] = ""
      EndIf
      If @OSARCH = "X64" Then
         If not (StringInStr ( $AutorunsArray[$n], @ProgramFilesDir & ' (x86)\') = 0 ) Then
           If (StringInStr ( $AutorunsArray[$n], ':\', 0, 2) = 0) & (StringInStr ( $AutorunsArray[$n], '%\') = 0 ) Then  $AutorunsArray[$n] = ""
         EndIf
      EndIf
      If (@OSVersion = "WIN_10" Or @OSVersion = "WIN_81" Or @OSVersion = "WIN_8") Then
         If StringInStr($AutorunsArray[$n], '\ProgramData\Microsoft\Windows Defender\') > 0 Then $AutorunsArray[$n] = ""
         If StringInStr($AutorunsArray[$n], '%ProgramData%\Microsoft\Windows Defender\') > 0 Then $AutorunsArray[$n] = ""
         If StringInStr($AutorunsArray[$n], '\appdata\local\microsoft\onedrive\') > 0 Then
	   Local $_arrAccountInfo = _sGetAllAccountsInfo()
	   If Ubound($_arrAccountInfo) > 1 Then
	 	 $x = FindUserFromOneDrivePath($AutorunsArray[$n])
		 For $ii = 1 to Ubound($_arrAccountInfo)-1
		    If StringInStr($_arrAccountInfo[$ii], ':\Users\' & $x) > 0 Then
			   $temp = StringTrimLeft($_arrAccountInfo[$ii], StringInStr($_arrAccountInfo[$ii], "(***)")+4)
			   $temp = StringTrimRight($temp,StringLen($temp) - StringInStr($temp, "(****)")+1)
			   AddOneDrive($temp , "*OneDrive for Account: " & $_arrAccountInfo[$ii])
		    EndIf
		 Next
	   EndIf
		 $AutorunsArray[$n] = "" 
	 EndIf
         If StringInStr($AutorunsArray[$n], '%LocalAppdata%\microsoft\onedrive\') > 0 Then $AutorunsArray[$n] = "" 
      EndIf
;     Change to lowercase string
      $AutorunsArray[$n] = StringLower($AutorunsArray[$n])
;      If StringInStr($AutorunsArray[$n], 'c:\windows\system32\bcdboot.exe c:\windows') > 0 Then $AutorunsArray[$n] = ""
      If not ($AutorunsArray[$n] = "") Then 
;       Add the autoruns entries located in the User Space
	 $x = RemoveUnnecessaryCharacters($AutorunsArray[$n])
;        Check if the path exists
         If FileExists ($x) = 1 Then
           $x = StringLower($x)
;	 Check if it is not the foldername
	    $ArrayFilePathSplit = _PathSplit ( $x, $FileDrive, $FilePath, $Filename, $FileExt)
	    If not ($ArrayFilePathSplit[4] = "") Then
	       _ArrayAdd ($ValidPathsArray, $x)
	    EndIf
         Else
           $x = StringLower($x)
           _ArrayAdd ($NoValidPathsArray, $x)
         EndIf
      EndIf
    Next 
 
;   Manage script selection from $ScriptAutorunsLogArray to $ValidPathsArray or $NoValidPathsArray 
    SelectScriptAutoruns()
;   Delete duplicates
    $ValidPathsArray = _ArrayUnique($ValidPathsArray)
    $NoValidPathsArray = _ArrayUnique($NoValidPathsArray)
;   _ArrayDisplay($ValidPathsArray)
    $NoValidPathsArray[0] = UBound($NoValidPathsArray)-1
;   If testing file !!AutorunsNonValidPaths.log exists then load it to test filtering functions 
    If FileExists($ProgramFolder & '!!AutorunsNonValidPaths.log') Then 
       $NoValidPathsArray = ""
       _FileReadToArray($ProgramFolder & '!!AutorunsNonValidPaths.log', $NoValidPathsArray)
       _ArrayDisplay($NoValidPathsArray)
    EndIf 

;   Remove records from $NoValidPathsArray that have: %windir% , %systemroot%, %programfiles% and are located in 
;   System Space, and add to ValidPathsArray entries with %Userprofile%, %LocalAppdata%, etc.
    RefineNoValidPathsArray()
;   Delete duplicates in $ValidPathsArray
    $ValidPathsArray = _ArrayUnique($ValidPathsArray)
    _ArrayDelete($ValidPathsArray,0)
    $ValidPathsArray[0] = UBound($ValidPathsArray)-1
;   Remove INI and CFG file paths form $ValidPathsArray
    RefineValidPathsArray()
;    _ArrayDisplay($ValidPathsArray)
;   _ArrayDisplay($NoValidPathsArray)
 SplashOff()

;   Display results
    If $NoValidPathsArray[0] > 0 Then 
;       MsgBox (0,"",'Some Autostart Paths were not recognized as valid, they must be checked manually')
;      _ArrayDisplay($NoValidPathsArray)
       FileWriteLine($ProgramFolder & 'AutorunsNonValidPaths.log', @CRLF & '**************' & @CRLF & 'Non Recognized User Space Autoruns REPORT DATE (Y:M:D  H:M): ' & @YEAR & ':' & @MON & ':' & @MDAY & '  ' & @HOUR & ':' & @MIN & @CRLF)
       For $i=1 To $NoValidPathsArray[0]
          FileWriteLine($ProgramFolder & 'AutorunsNonValidPaths.log', $NoValidPathsArray[$i])
       Next
;      ShellExecute('notepad.exe',$ProgramFolder & 'AutorunsNonValidPaths.log')
    EndIf

;   Add valid User Space Autoruns to Path Whitelist
;   Clear Global temporary arrays created by CalculateFilePaths() function
    $NewPathsArray = ClearArray($NewPathsArray)
    $PathDuplicatesArray = ClearArray($PathDuplicatesArray)

;   Delete empty records from $ValidPathsArray
    While _ArraySearch($ValidPathsArray,'') > 0
          _ArrayDelete($ValidPathsArray,_ArraySearch($ValidPathsArray,''))
    WEnd
;   Correct the number of Array records written in 0-th record.
    $ValidPathsArray[0] = UBound($ValidPathsArray)-1

    If $ValidPathsArray[0] > 0 Then
;       _ArrayDisplay($ValidPathsArray)
       FileWriteLine($ProgramFolder & 'AutorunsValidPaths.log', @CRLF & '**************' & @CRLF & 'AUTORUNS REPORT DATE (Y:M:D  H:M): ' & @YEAR & ':' & @MON & ':' & @MDAY & '  ' & @HOUR & ':' & @MIN & @CRLF & '@@@@@ New Whitelisted User Space Autoruns:' & @CRLF)
;       MsgBox(262144,"","Some User Space Autoruns have been found. They will be saved in the file AutorunsValidPaths.log in the Hard_Configurator folder. New items will be automatically whitelisted.")
;      ShellExecute('notepad.exe',$ProgramFolder & 'AutorunsValidPaths.log')
;      Add User Space Path to SRP Whitelist
;      Global variable $DescriptionLabel is used in CalculateFilePaths() function to label items
       $DescriptionLabel = '*Autoruns : '
       For $i=1 To $ValidPathsArray[0]
;       MsgBox(262144,"",$ValidPathsArray[$i])
          CalculateFilePaths($ValidPathsArray[$i])
       Next
;      Add User Space Autoruns Paths to the log file
       If UBound($NewPathsArray) = 1 Then FileWriteLine($ProgramFolder & 'AutorunsValidPaths.log', 'No new paths.')
       If UBound($NewPathsArray) > 1 Then
          For $i=1 To UBound($NewPathsArray)-1
              FileWriteLine($ProgramFolder & 'AutorunsValidPaths.log', $NewPathsArray[$i])
          Next
       EndIf
       FileWriteLine($ProgramFolder & 'AutorunsValidPaths.log', @CRLF & '@@@@@@  Already Whitelisted User Space Autoruns:' & @CRLF) 
;       _ArrayDisplay($ValidPathsArray)
;       _ArrayDisplay($PathDuplicatesArray)      
       If UBound($PathDuplicatesArray) = 1 Then FileWriteLine($ProgramFolder & 'AutorunsValidPaths.log', 'No paths.')
       If UBound($PathDuplicatesArray) > 1 Then
          For $i=1 To UBound($PathDuplicatesArray)-1
             FileWriteLine($ProgramFolder & 'AutorunsValidPaths.log', $PathDuplicatesArray[$i])
          Next       
       EndIf
;      Clear Global temporary arrays created by CalculateFilePaths() function
       $NewPathsArray = ClearArray($NewPathsArray)
       $PathDuplicatesArray = ClearArray($PathDuplicatesArray)
;      Clear Global temporary variable
       $DescriptionLabel = ''
    Else
;       MsgBox(262144,"","No User Space Autoruns.")
       FileWriteLine($ProgramFolder & 'AutorunsValidPaths.log', @CRLF & '**************' & @CRLF & 'AUTORUNS REPORT DATE (Y:M:D  H:M): ' & @YEAR & ':' & @MON & ':' & @MDAY & '  ' & @HOUR & ':' & @MIN & @CRLF & '@@@@@ No User Space Autoruns.' & @CRLF)
    EndIf
 
;   ShowRegistryTweaks()
    FileDelete($ProgramFolder & 'Autoruns.log')
EndFunc


Func RemoveUnnecessaryCharacters($y)
 Local $x

; Remove spaces before the path
    While StringInStr($y, ' ') = 1
       $x = StringReplace ($y, ' ', "", 1)
       $y = $x
    Wend

; Remove spaces after the path
    While StringInStr($y, ' ', 0, 1, StringLen($y)) = StringLen($y)
       $x = StringReplace ($y, ' ', "", -1)
       $y = $x
    Wend

; Remove quotation marks
    $x = StringReplace ($y, '"', "") 
    $y = $x

; Remove slashes
    Local $m = StringInStr ($y, "/")
    If $m > 0 Then $x = StringLeft ($y, $m-2)

  Return $x
EndFunc

Func RefineValidPathsArray()
  local $an
  local $ext
  If $ValidPathsArray[0] < 1 Then Return
  For $n=1 To $ValidPathsArray[0]
    $ext =  StringRight ($ValidPathsArray[$n], 4)
    If StringInStr ($ext, '.ini') > 0 Then $ValidPathsArray[$n] = ""
    If StringInStr ($ext, '.cfg') > 0 Then $ValidPathsArray[$n] = ""
  Next
    $ValidPathsArray = _ArrayUnique($ValidPathsArray)
    _ArrayDelete($ValidPathsArray,0)
    $ValidPathsArray[0] = UBound($ValidPathsArray)-1
EndFunc


Func RefineNoValidPathsArray()
local $an
Local $temp
  If $NoValidPathsArray[0] < 1 Then Return
  For $n=1 To $NoValidPathsArray[0]
    $an = $NoValidPathsArray[$n]
    $temp = StringInStr($NoValidPathsArray[$n], '%systemroot%')
    If ($temp > 0  and $temp < 5) Then $an = ""
    $temp = StringInStr($NoValidPathsArray[$n], '%windir%')
    If ($temp > 0  and $temp < 5) Then $an = ""
    $temp = StringInStr($NoValidPathsArray[$n], '%programfiles%')
    If ($temp > 0  and $temp < 5) Then $an = ""
    $temp = StringInStr($NoValidPathsArray[$n], '%CommonProgramFiles%')
    If ($temp > 0  and $temp < 5) Then $an = ""
    $temp = StringInStr($NoValidPathsArray[$n], '%CommonProgramFiles(x86)%')
    If ($temp > 0  and $temp < 5) Then $an = ""
    $temp = StringInStr($NoValidPathsArray[$n], '%CommonProgramW6432%')
    If ($temp > 0  and $temp < 5) Then $an = ""
    $temp = StringInStr($NoValidPathsArray[$n], '%ComSpec%')
    If ($temp > 0  and $temp < 5) Then $an = ""
    $temp = StringInStr($NoValidPathsArray[$n], '%ProgramFiles(x86)%')
    If ($temp > 0  and $temp < 5) Then $an = ""
    $temp = StringInStr($NoValidPathsArray[$n], '%ProgramW6432%')
    If ($temp > 0  and $temp < 5) Then $an = ""
    $temp = StringInStr($NoValidPathsArray[$n], '%PSModulePath%')
    If ($temp > 0  and $temp < 5) Then $an = ""
    $an = StringReplace ( $an, '%SystemDrive%', $systemdrive) 
    $an = StringReplace ( $an, '%systemroot%', @WindowsDir)
    $an = StringReplace ( $an, '%windir%', @WindowsDir)    
    $an = StringReplace ( $an, '%programfiles%', @ProgramFilesDir)
    $an = StringReplace ( $an, '%CommonProgramFiles%', @CommonFilesDir)
    $an = StringReplace ( $an, '%CommonProgramFiles(x86)%', @ProgramFilesDir & ' (x86)\Common Files')
    $an = StringReplace ( $an, '%CommonProgramW6432%', @CommonFilesDir)
    $an = StringReplace ( $an, '%ComSpec%', @ComSpec)
    $an = StringReplace ( $an, '%ALLUSERSPROFILE%', $systemdrive & '\ProgramData')
    $an = StringReplace ( $an, '%ProgramData%', $systemdrive & '\ProgramData')
    $an = StringReplace ( $an, '%ProgramFiles%', @ProgramFilesDir)
    $an = StringReplace ( $an, '%ProgramFiles(x86)%', @ProgramFilesDir & ' (x86)')
    $an = StringReplace ( $an, '%ProgramW6432%', @ProgramFilesDir)
    $an = StringReplace ( $an, '%PSModulePath%', @WindowsDir & '\system32\WindowsPowerShell\v1.0\Modules')
    $an = StringReplace ( $an, '%PUBLIC%', @HomeDrive & '\Users\Public')
    $an = StringReplace ( $an, '%HOMEDRIVE%', @HomeDrive)
;   Variables %USERPROFILE%,  %APPDATA%, %LOCALAPPDATA% are replaced later, bacause we want them in $ValidPathsArray


    If (StringInStr($an,'%') = 0 ) & (StringInStr($an,'\\') = 0 ) Then 
      If not (StringInStr ( $an, @WindowsDir & '\') = 0) Then
;       MsgBox(262144,"",$an & "       " & FileExists ($an))
        If FileExists ($an) = 1  Then $an = ""
        If StringInStr ( $an, ':\', 0, 2) = 0 Then $an = ""
        If not (StringInStr ( $an, @WindowsDir & '\system32\rundll32.exe' & ' ' & @ProgramFilesDir & '\')) = 0 Then
            If StringInStr ( $an, ':\', 0, 3) = 0 Then $an = ""
        EndIf
        If @OSARCH = "X64" Then
          If not (StringInStr ( $an, @WindowsDir & '\system32\rundll32.exe' & ' ' & @ProgramFilesDir & ' (x86)\')) = 0 Then
             If StringInStr ( $an, ':\', 0, 3) = 0 Then $an = ""
          EndIf
        EndIf
        If not (StringInStr ( $an, @WindowsDir & '\system32\rundll32.exe' & ' ' &  @WindowsDir & '\')) = 0 Then
            If StringInStr ( $an, ':\', 0, 3) = 0 Then $an = ""
        EndIf
      EndIf   
    If not (StringInStr ( $an, @ProgramFilesDir & '\') = 0) Then
;     MsgBox(262144,"",$an & "       " & FileExists ($an))
      If FileExists ($an) = 1  Then $an = ""
      If StringInStr ( $an, ':\', 0, 2) = 0 Then $an = ""
    EndIf
    If @OSARCH = "X64" Then
       If not (StringInStr ( $an, @ProgramFilesDir & ' (x86)\') = 0) Then
;          MsgBox(262144,"",$an & "       " & FileExists ($an))
           If FileExists ($an) = 1  Then $an = ""
           If StringInStr ( $an, ':\', 0, 2) = 0 Then $an = ""
       EndIf
    EndIf
    If not (StringInStr ( $an, @WindowsDir & '\') = 0) Then
        If @OSARCH = "X64" Then
           If not (StringInStr ( $an, @ProgramFilesDir & ' (x86)\') = 0) Then
              If StringInStr ( $an, ':\', 0, 3) = 0 Then $an = ""
           EndIf
        EndIf
        If not (StringInStr ( $an, @ProgramFilesDir & '\') = 0) Then
            If StringInStr ( $an, ':\', 0, 3) = 0 Then $an = ""
        EndIf
        If not (StringInStr ( $an, @WindowsDir & '\', 0, 2) = 0) Then
            If StringInStr ( $an, ':\', 0, 3) = 0 Then $an = ""
        EndIf    
    EndIf
    If not (StringInStr ( $an, @ProgramFilesDir & '\') = 0) Then
        If not (StringInStr ( $an, @ProgramFilesDir & '\', 0, 2) = 0) Then
            If StringInStr ( $an, ':\', 0, 3) = 0 Then $an = ""
        EndIf    
    EndIf
    If @OSARCH = "X64" Then
       If not (StringInStr ( $an, @ProgramFilesDir & ' (x86)\') = 0) Then
          If not (StringInStr ( $an, @ProgramFilesDir & ' (x86)\', 0, 2) = 0) Then
             If StringInStr ( $an, ':\', 0, 3) = 0 Then $an = ""
          EndIf
       EndIf    
    EndIf
;   Refresh the $NoValidPathsArray
    $NoValidPathsArray[$n] = $an
;   Check if file exist, and if so, add to $ValidPathsArray and remove from $NoValidPathsArray.
    $an = StringReplace ( $an, '%USERPROFILE%', @UserProfileDir)
    $an = StringReplace ( $an, '%APPDATA%', @AppDataDir)
    $an = StringReplace ( $an, '%LOCALAPPDATA%', @LocalAppDataDir)
    If FileExists ($an) = 1  Then 
       _ArrayAdd ($ValidPathsArray, $NoValidPathsArray[$n])
       $NoValidPathsArray[$n] = ""
    EndIf
  EndIf
 Next
 While _ArraySearch($NoValidPathsArray,"") > 0
       _ArrayDelete($NoValidPathsArray,_ArraySearch($NoValidPathsArray,""))
 WEnd
; Correct the number of Array records written in 0-th record.
  $NoValidPathsArray[0] = UBound($NoValidPathsArray)-1

;  MsgBox(262144,"",$NoValidPathsArray[$NoValidPathsArray[0]])
; _ArrayDisplay($NoValidPathsArray)

EndFunc


Func ClearArray($xxx)
While UBound($xxx)-1 > 0
;MsgBox(262144, "", 'wymiar wektora = ' & UBound($xxx)-1)
;_ArrayDisplay($xxx)
  _ArrayPop($xxx)
;_ArrayDisplay($xxx)
WEnd 
$xxx[0] = 0
Return $xxx
EndFunc


Func CheckScriptAutoruns($AutorunsPath)

  If (StringInStr ( $AutorunsPath, '.PS1') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath) 
  If (StringInStr ( $AutorunsPath, '.PS1XML') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.PS2') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.PS2XML') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.PSC1') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.PSC2') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.VB') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.VBS') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.VBE') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.JS') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.JSE') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.WS') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.WSF') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.WSC') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.WSH') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.BAT') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '.CMD') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
;  If (StringInStr ( $AutorunsPath, 'cmd.exe') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
;  If (StringInStr ( $AutorunsPath, 'cscript.exe') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
;  If (StringInStr ( $AutorunsPath, 'wscript.exe') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, 'powershell.exe') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, 'powershell_ise.exe') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '\vbscript.dll') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
  If (StringInStr ( $AutorunsPath, '\jscript.dll') > 0) Then _ArrayAdd ( $ScriptAutorunsLogArray, $AutorunsPath)
EndFunc


Func SelectScriptAutoruns()
 Local $an
 Local $n
 $ScriptAutorunsLogArray[0] = UBound($ScriptAutorunsLogArray)-1
 For $n = 1 To $ScriptAutorunsLogArray[0]
    $an = $ScriptAutorunsLogArray[$n]
    $an = StringReplace ( $an, '%SystemDrive%', $systemdrive) 
    $an = StringReplace ( $an, '%systemroot%', @WindowsDir)
    $an = StringReplace ( $an, '%windir%', @WindowsDir)    
    $an = StringReplace ( $an, '%programfiles%', @ProgramFilesDir)
    $an = StringReplace ( $an, '%CommonProgramFiles%', @CommonFilesDir)
    $an = StringReplace ( $an, '%CommonProgramFiles(x86)%', @ProgramFilesDir & ' (x86)\Common Files')
    $an = StringReplace ( $an, '%CommonProgramW6432%', @CommonFilesDir)
    $an = StringReplace ( $an, '%ComSpec%', @ComSpec)
    $an = StringReplace ( $an, '%ALLUSERSPROFILE%', $systemdrive & '\ProgramData')
    $an = StringReplace ( $an, '%ProgramData%', $systemdrive & '\ProgramData')
    $an = StringReplace ( $an, '%ProgramFiles%', @ProgramFilesDir)
    $an = StringReplace ( $an, '%ProgramFiles(x86)%', @ProgramFilesDir & ' (x86)')
    $an = StringReplace ( $an, '%ProgramW6432%', @ProgramFilesDir)
    $an = StringReplace ( $an, '%PSModulePath%', @WindowsDir & '\system32\WindowsPowerShell\v1.0\Modules')
    $an = StringReplace ( $an, '%PUBLIC%', @HomeDrive & '\Users\Public')
    $an = StringReplace ( $an, '%HOMEDRIVE%', @HomeDrive)
    $an = StringReplace ( $an, '%USERPROFILE%', @UserProfileDir)
    $an = StringReplace ( $an, '%APPDATA%', @AppDataDir)
    $an = StringReplace ( $an, '%LOCALAPPDATA%', @LocalAppDataDir)
    $an = RemoveUnnecessaryCharacters($an)
    $ScriptAutorunsLogArray[$n] = StringLower ($an)
 Next
 $ScriptAutorunsLogArray = _ArrayUnique($ScriptAutorunsLogArray)
 If UBound($ScriptAutorunsLogArray) > 1 Then _ArrayDelete($ScriptAutorunsLogArray,1)
 $ScriptAutorunsLogArray[0] = UBound($ScriptAutorunsLogArray) - 1
; _ArrayDisplay($ScriptAutorunsLogArray)
; Creating Report
 FileWriteLine($ProgramFolder & 'ScriptAutorunsPaths.log', @CRLF & '**************' & @CRLF & 'SCRIPT AUTORUNS REPORT DATE (Y:M:D  H:M): ' & @YEAR & ':' & @MON & ':' & @MDAY & '  ' & @HOUR & ':' & @MIN & @CRLF & '@@@@@ Script Autoruns:' & @CRLF)
 If $ScriptAutorunsLogArray[0] > 0 Then
    For $i=1 To $ScriptAutorunsLogArray[0]
        FileWriteLine($ProgramFolder & 'ScriptAutorunsPaths.log', $ScriptAutorunsLogArray[$i])
    Next
 Else
    FileWriteLine($ProgramFolder & 'ScriptAutorunsPaths.log', 'No paths.')
 EndIf
 ClearArray($ScriptAutorunsLogArray)

EndFunc

Func FindUserFromOneDrivePath($OneDrivePath)
; MsgBox(0,"",$OneDrivePath)
  Local $n = StringInStr($OneDrivePath, ':\Users\')
  Local $item1 = StringTrimLeft($OneDrivePath, $n+7)
  $n = StringInStr($item1, '\')
  $item = StringTrimRight($item1, StringLen($item1) - $n +1)
;  MsgBox(0,"","#" & $item & "#")
  Return $item
EndFunc
