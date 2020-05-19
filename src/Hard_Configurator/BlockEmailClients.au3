;RestrictEmailClients()
;RemoveEmailClientsRestrictions()

Func RemoveEmailClientsRestrictions()
Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-8E544B6A3'
For $i=101 to 200
   RegDelete($RegGUID & $i & '}')
Next
EndFunc

;This function is required but it is already included in BlockArchivers.au3 module
;Func AddDisallowedRuleForFileExtension($RegGUID_Key, $InitialFolder, $StartNumber, $EndNumber, $FileExtension)
;Local $path = $InitialFolder
;If $StartNumber < 97 or $EndNumber > 999 Then
;   MsgBox(0,"AddDisallowedRuleFoFileExtension", "Error. The StartNumber and $EndNumber must be in the interval {100, ..., 999}."
;EndIf
;For $i = $StartNumber to $EndNumber
;;  MsgBox(0,"",$RegGUID_Key & $i & '}'& @CRLF & $path & $FileExtension)
;   RegWrite($RegGUID_Key & $i & '}', 'Description','REG_SZ','')
;   RegWrite($RegGUID_Key & $i & '}', 'SaferFlags','REG_DWORD',Number('0'))
;   RegWrite($RegGUID_Key & $i & '}', 'ItemData','REG_SZ', $path & $FileExtension)
;   $path = $path & '\*'
;Next
;EndFunc



Func RestrictEmailClients()
Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-8E544B6A3'
Local $path0 = '%USERPROFILE%\AppData\Local\Temp'
Local $path1 = '%USERPROFILE%\AppData\Roaming'
Local $path2 = '%USERPROFILE%\AppData\Local'
Local $ext = '\*'
Local $eM_Client = '\eM Client temporary files\*'
Local $Foxmail = '\Foxmail*\Temp-*\Attach'
Local $Claws_mail = '\Claws-mail\mimetmp'
Local $Mailspring = '\Mailspring\files\*\*\*'
Local $Hiri = '\hiri\temp'

; eM_Client Disallowed rules
AddDisallowedRuleForFileExtension($RegGUID, $path0 & $eM_Client, 101, 120, $ext)
; Foxmail Disallowed rules
AddDisallowedRuleForFileExtension($RegGUID, $path1 & $Foxmail, 121, 140, $ext)
; Claws_mail Disallowed rules
AddDisallowedRuleForFileExtension($RegGUID, $path1 & $Claws_mail, 141, 160, $ext)
; $Mailspring Disallowed rules
AddDisallowedRuleForFileExtension($RegGUID, $path1 & $Mailspring, 161, 180, $ext)
; PeaZip Disallowed rules for EXE, TMP, and MSI.
AddDisallowedRuleForFileExtension($RegGUID, $path2 & $Hiri, 181, 200, $ext)
EndFunc


;This function is required but it is already included in BlockArchivers.au3 module
;Func CheckDisallowedRuleForFileExtension($RegGUID_Key, $InitialFolder, $StartNumber, $EndNumber, $FileExtension)
;Local $path = $InitialFolder
;If $StartNumber < 97 or $EndNumber > 999 Then
;   MsgBox(0,"CheckDisallowedRuleForFileExtension", "Error. The $StartNumber and $EndNumber must be in the interval {100, ..., 999}.")
;EndIf
;Local $n=0
;If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
;   For $i = $StartNumber to $EndNumber
;      $path = $path & '\*'
;      If RegRead($RegGUID_Key & $i & '}', 'SaferFlags') = '0' Then $n = $n+1
;      If RegRead($RegGUID_Key & $i & '}', 'ItemData') = $path & $FileExtension Then $n = $n+1      
;;     MsgBox(0,"",$RegGUID_Key & $i & '}'& @CRLF & $path & $FileExtension)
;   Next
;;   MsgBox(0,"",$n)
;EndIf
;   Return $n 
;EndFunc



Func CheckRestrictEmailClients()
Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-8E544B6A3'
Local $path0 = '%USERPROFILE%\AppData\Local\Temp'
Local $path1 = '%USERPROFILE%\AppData\Roaming'
Local $path2 = '%USERPROFILE%\AppData\Local'
Local $ext = '\*'
Local $eM_Client = '\eM Client temporary files\*'
Local $Foxmail = '\Foxmail*\Temp-*\Attach'
Local $Claws_mail = '\Claws-mail\mimetmp'
Local $Mailspring = '\Mailspring\files\*\*\*'
Local $Hiri = '\hiri\temp'
Local $n = 0
Local $temp
; eM_Client Disallowed rules
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path0 & $eM_Client, 101, 120, $ext)
; Foxmail Disallowed rules
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path1 & $Foxmail, 121, 140, $ext)
; Claws_mail Disallowed rules
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path1 & $Claws_mail, 141, 160, $ext)
; $Mailspring Disallowed rules
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path1 & $Mailspring, 161, 180, $ext)
; PeaZip Disallowed rules for EXE, TMP, and MSI.
$n = $n + CheckDisallowedRuleForFileExtension($RegGUID, $path2 & $Hiri, 181, 200, $ext)

;MsgBox(0,"",$n)
; Correction to version 5.0.0.1
;$temp = RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-8E544B6A3101}', 'ItemData')
;If ($n= 100 And StringInStr($temp, '\Users\*\AppData\Local\Temp\eM Client temporary files\*\*') > 0) Then Return 4
If $n= 100 Then Return 4
; Normal check
If $n= 200 Then Return 1
If $n = 0  Then Return 0
If $n > 0  Then Return 2 

EndFunc
