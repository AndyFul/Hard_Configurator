Func SubkeysFromKey2Array($_key)

#include <Array.au3>
#Include <File.au3>
#include <FileConstants.au3>

Local $hArray[1] =[""]

Local $n = 1
Local $subKey = RegEnumKey($_key, 1)
While $subKey <> ""
   $subKey = RegEnumKey($_key, $n)
;  MsgBox($MB_SYSTEMMODAL, "", $n)
  _ArrayAdd($hArray, $subKey)
  $n = $n + 1
WEnd

;Kasuje pusty rekord powsta³y przy tworzeniu wektora
_ArrayPop($hArray)
;_ArrayDisplay($hArray)

Return $hArray

EndFunc