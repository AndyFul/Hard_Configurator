#include <Array.au3>
#Include <File.au3>
#include <FileConstants.au3>

Func PathsFromKey2Array($_key)
#include <MsgBoxConstants.au3>
#include <Array.au3> ; Required for _ArrayDisplay() only.

Local $hArray[1] =[""]
;Local $ASRExclusionsKey = 'HKLM\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\ASROnlyExclusions'

Local $n = 1
Local $sValue = RegEnumVal($_key, 1)
While $sValue <> ""
  Local $sValue = RegEnumVal($_key, $n)
;  MsgBox($MB_SYSTEMMODAL, "", $n)
 _ArrayAdd($hArray, $sValue)
$n = $n + 1
WEnd

;Kasuje pusty rekord powsta³y przy tworzeniu wektora
_ArrayPop($hArray)
;_ArrayDisplay($hArray)

Return $hArray

EndFunc