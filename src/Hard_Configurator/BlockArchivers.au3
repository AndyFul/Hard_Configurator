;RestrictArchivers()
;RemoveArchiversRestrictions()

;******* This number has to be greater than 1 and less or equal to 15
Global $NumberOfArchivers = 13
;********************************

Func RemoveArchiversRestrictions()
Local $PA_RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-3E544B6A30'
Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-3E544B6A3'
For $i = 97 To 99
   RegDelete($PA_RegGUID & $i & '}')
Next
For $i=101 to 100 + $NumberOfArchivers * 60
   RegDelete($RegGUID & $i & '}')
Next
EndFunc


Func AddDisallowedRuleForFileExtension($RegGUID_Key, $InitialFolder, $StartNumber, $EndNumber, $FileExtension)
Local $path = $InitialFolder
If $StartNumber < 97 or $EndNumber > 999 Then
   MsgBox(0,"AddDisallowedRuleFoFileExtension", "Error. The StartNumber and $EndNumber must be in the interval {100, ..., 999}."
EndIf
For $i = $StartNumber to $EndNumber
;  MsgBox(0,"",$RegGUID_Key & $i & '}'& @CRLF & $path & $FileExtension)
   RegWrite($RegGUID_Key & $i & '}', 'Description','REG_SZ','')
   RegWrite($RegGUID_Key & $i & '}', 'SaferFlags','REG_DWORD',Number('0'))
   If StringInStr($path, '%') = 0 Then
      RegWrite($RegGUID_Key & $i & '}', 'ItemData','REG_SZ', $path & $FileExtension)
   Else
      RegWrite($RegGUID_Key & $i & '}', 'ItemData','REG_EXPAND_SZ', $path & $FileExtension) 
   EndIf
   $path = $path & '\*'
Next
EndFunc



Func RestrictArchivers($flag)
; If $flag = 1 then the restrictions for EXE and TMP will be skipped
If $flag = 1 Then RemoveArchiversRestrictions()
Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-3E544B6A3'
Local $path0 = '%USERPROFILE%\AppData\Local\Temp'
Local $path
Local $EXEext = '\*.exe'
Local $TMPext = '\*.tmp'
Local $MSIext = '\*.msi'

Local $Explorer_Temp = '\Temp*_*.zip'
Local $WinZip_Temp = '\wz????'
Local $WinRar_Temp = '\Rar$EX*'
Local $7Zip_Temp = '\7zO????????'
Local $PeaZip_Temp = '\.ptmp??????'
Local $PowerArchiver_Temp = '\_PA*'
Local $B1FreeArchiver_Temp = '\B1FreeArchiver-*-*-*-*-*'
Local $Bandizip_Temp = '\BNZ.???????????????'
Local $IZArc_Temp = '\$$_????'
Local $ALZip_Temp = '\_AZTMP*_'
Local $ExpressZip_Temp = '\ExpressZip-*-*'
Local $PKZip_Temp = '\PK????.tmp'
Local $Explzh = '\?EXTMP??'

; 0. PowerArchiver Disallowed rules for EXE, TMP, and MSI in Appdata\LocalLow.
Local $PA_RegGUID = $RegGUID & '0'
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($PA_RegGUID, '%USERPROFILE%\AppData\LocalLow', 97, 97, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($PA_RegGUID, '%USERPROFILE%\AppData\LocalLow', 98, 98, $TMPext)
AddDisallowedRuleForFileExtension($PA_RegGUID, '%USERPROFILE%\AppData\LocalLow', 99, 99, $MSIext)
; 1. Explorer Disallowed rules for EXE, TMP, and MSI.
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $Explorer_Temp, 101, 120, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $Explorer_Temp, 121, 140, $TMPext)
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $Explorer_Temp, 141, 160, $MSIext)
; 2. WinZip Disallowed rules for EXE, TMP, and MSI.
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $WinZip_Temp, 161, 180, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $WinZip_Temp, 181, 200, $TMPext)
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $WinZip_Temp, 201, 220, $MSIext)
; 3. WinRar Disallowed rules for EXE, TMP, and MSI.
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $WinRar_Temp, 221, 240, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $WinRar_Temp, 241, 260, $TMPext)
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $WinRar_Temp, 261, 280, $MSIext)
; 4. 7-Zip Disallowed rules for EXE, TMP, and MSI.
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $7Zip_Temp, 281, 300, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $7Zip_Temp, 301, 320, $TMPext)
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $7Zip_Temp, 321, 340, $MSIext)
; 5. PeaZip Disallowed rules for EXE, TMP, and MSI.
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $PeaZip_Temp, 341, 360, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $PeaZip_Temp, 361, 380, $TMPext)
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $PeaZip_Temp, 381, 400, $MSIext)
; 6. PowerArchiver Disallowed rules for EXE, TMP, and MSI.
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $PowerArchiver_Temp, 401, 420, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $PowerArchiver_Temp, 421, 440, $TMPext)
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $PowerArchiver_Temp, 441, 460, $MSIext)
; 7. B1 Free Archiver Disallowed rules for EXE, TMP, and MSI.
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $B1FreeArchiver_Temp, 461, 480, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $B1FreeArchiver_Temp, 481, 500, $TMPext)
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $B1FreeArchiver_Temp, 501, 520, $MSIext)
; 8. Bandizip Disallowed rules for EXE, TMP, and MSI.
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $Bandizip_Temp, 521, 540, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $Bandizip_Temp, 541, 560, $TMPext)
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $Bandizip_Temp, 561, 580, $MSIext)
; 9. IZArc Disallowed rules for EXE, TMP, and MSI.
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $IZArc_Temp, 581, 600, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $IZArc_Temp, 601, 620, $TMPext)
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $IZArc_Temp, 621, 640, $MSIext)
; 10. ALZip Disallowed rules for EXE, TMP, and MSI.
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $ALZip_Temp, 641, 660, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $ALZip_Temp, 661, 680, $TMPext)
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $ALZip_Temp, 681, 700, $MSIext)
; 11. ExpressZip Disallowed rules for EXE, TMP, and MSI.
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $ExpressZip_Temp, 701, 720, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $ExpressZip_Temp, 721, 740, $TMPext)
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $ExpressZip_Temp, 741, 760, $MSIext)
; 12. PKZip Disallowed rules for EXE, TMP, and MSI.
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $PKZip_Temp, 761, 780, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $PKZip_Temp, 781, 800, $TMPext)
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $PKZip_Temp, 801, 820, $MSIext)
; 13. Explzh Disallowed rules for EXE, TMP, and MSI.
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $Explzh, 821, 840, $EXEext)
If not ($flag = 1) Then AddDisallowedRuleForFileExtension($RegGUID, $path0 & $Explzh, 841, 860, $TMPext)
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $Explzh, 861, 880, $MSIext)

; Adding the new archiver requires changing the global variable $NumberOfArchivers (see the beginning of BlockArvchives.au3)
;The number of archiver applications <= 15 !!! Larger number will require changing the $RegGUID .
 
EndFunc



Func CheckDisallowedRuleForFileExtension($RegGUID_Key, $InitialFolder, $StartNumber, $EndNumber, $FileExtension)
Local $path = $InitialFolder

If $StartNumber < 97 or $EndNumber > 999 Then
   MsgBox(0,"CheckDisallowedRuleForFileExtension", "Error. The $StartNumber and $EndNumber must be in the interval {100, ..., 999}.")
EndIf

Local $n=0
If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
   For $i = $StartNumber to $EndNumber
;      $path = $path & '\*'
      If RegRead($RegGUID_Key & $i & '}', 'SaferFlags') = '0' Then $n = $n+1
      If RegRead($RegGUID_Key & $i & '}', 'ItemData') = $path & $FileExtension Then
	 $n = $n+1
         $path = $path & '\*'      
      EndIf
   Next
;   MsgBox(0,"",$n)
EndIf
;   If $EndNumber = 880 then MsgBox(0,"", $EndNumber & @crlf & $n & @crlf & $RegGUID_Key & $i & '}')
   Return $n 
EndFunc



Func CheckRestrictArchivers()

Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-3E544B6A3'
Local $path0 = '%USERPROFILE%\AppData\Local\Temp'
Local $path
Local $EXEext = '\*.exe'
Local $TMPext = '\*.tmp'
Local $MSIext = '\*.msi'

Local $Explorer_Temp = '\Temp*_*.zip'
Local $WinZip_Temp = '\wz????'
Local $WinRar_Temp = '\Rar$EX*'
Local $7Zip_Temp = '\7zO????????'
Local $PeaZip_Temp = '\.ptmp??????'
Local $PowerArchiver_Temp = '\_PA*'
Local $B1FreeArchiver_Temp = '\B1FreeArchiver-*-*-*-*-*'
Local $Bandizip_Temp = '\BNZ.???????????????'
Local $IZArc_Temp = '\$$_????'
Local $ALZip_Temp = '\_AZTMP*_'
Local $ExpressZip_Temp = '\ExpressZip-*-*'
Local $PKZip_Temp = '\PK????.tmp'
Local $Explzh = '\?EXTMP??'
Local $n = 0
Local $PA_RegGUID = $RegGUID & '0'
$n = $n + CheckDisallowedRuleForFileExtension($PA_RegGUID, '%USERPROFILE%\AppData\LocalLow', 97, 97, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($PA_RegGUID, '%USERPROFILE%\AppData\LocalLow', 98, 98, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($PA_RegGUID, '%USERPROFILE%\AppData\LocalLow', 99, 99, $MSIext)
; Explorer Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $Explorer_Temp, 101, 120, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $Explorer_Temp, 121, 140, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $Explorer_Temp, 141, 160, $MSIext)
; WinZip Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $WinZip_Temp, 161, 180, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $WinZip_Temp, 181, 200, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $WinZip_Temp, 201, 220, $MSIext)
; WinRar Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $WinRar_Temp, 221, 240, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $WinRar_Temp, 241, 260, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $WinRar_Temp, 261, 280, $MSIext)
; 7-Zip Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $7Zip_Temp, 281, 300, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $7Zip_Temp, 301, 320, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $7Zip_Temp, 321, 340, $MSIext)
; PeaZip Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $PeaZip_Temp, 341, 360, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $PeaZip_Temp, 361, 380, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $PeaZip_Temp, 381, 400, $MSIext)
; PowerArchiver Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $PowerArchiver_Temp, 401, 420, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $PowerArchiver_Temp, 421, 440, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $PowerArchiver_Temp, 441, 460, $MSIext)
; B1 Free Archiver Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $B1FreeArchiver_Temp, 461, 480, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $B1FreeArchiver_Temp, 481, 500, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $B1FreeArchiver_Temp, 501, 520, $MSIext)
; Bandizip Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $Bandizip_Temp, 521, 540, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $Bandizip_Temp, 541, 560, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $Bandizip_Temp, 561, 580, $MSIext)
; IZArc Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $IZArc_Temp, 581, 600, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $IZArc_Temp, 601, 620, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $IZArc_Temp, 621, 640, $MSIext)
; ALZip Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $ALZip_Temp, 641, 660, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $ALZip_Temp, 661, 680, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $ALZip_Temp, 681, 700, $MSIext)
; ExpressZip Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $ExpressZip_Temp, 701, 720, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $ExpressZip_Temp, 721, 740, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $ExpressZip_Temp, 741, 760, $MSIext)
; PKZip Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $PKZip_Temp, 761, 780, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $PKZip_Temp, 781, 800, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $PKZip_Temp, 801, 820, $MSIext)
; Explzh Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $Explzh, 821, 840, $EXEext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $Explzh, 841, 860, $TMPext)
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $Explzh, 861, 880, $MSIext)
;MsgBox(0,"BlockArch",$n & @crlf & $NumberOfArchivers)
; For H_C version 5.0.1.0 and later
If $n = ($NumberOfArchivers*60 + 3)*2 Then Return 1
If $n = ($NumberOfArchivers*20 + 1)*2 Then Return 3
; For H_C Beta 5.0.0.1
If $n = (($NumberOfArchivers-1)*60 + 3) Then Return 4
If $n = (($NumberOfArchivers-1)*20 + 1) Then Return 5
If $n = 0 Then Return 0
; This has to be the last "IF". 
; If not 1,3,4,5 then return 2 (error code)
If $n > 0  Then Return 2 

EndFunc


