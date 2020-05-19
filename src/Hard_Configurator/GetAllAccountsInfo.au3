#include <Array.au3>
#Include <File.au3>
#include <FileConstants.au3>
#include <Security.au3>

;_sGetAllAccountsInfo()

Func _sGetAllAccountsInfo()

local $var[3]
Local $_ProfileImagePath
Local $hArray[1] =[""]
Local $_AccountName[1] = [""]
Local $n = 1
Local $profilesList = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"

Local $vSID = RegEnumKey($profilesList, 1)

While $vSID <> ""
; $vSID 
  $vSID = RegEnumKey($profilesList, $n)
  $var[1] = $profilesList & '\' & $vSID
  $_ProfileImagePath = Regread($var[1], 'ProfileImagePath')
  $_AccountName = _Security__LookupAccountSid ($vSID)
  If FileExists($_ProfileImagePath &'\Appdata\Local\Microsoft\OneDrive') = 1 Then _ArrayAdd($hArray, $_AccountName[0] & "(***)" & $_ProfileImagePath & "(****)" & $vSID)
  $n = $n + 1
WEnd
;_ArrayDisplay($hArray)
Return $hArray
EndFunc
