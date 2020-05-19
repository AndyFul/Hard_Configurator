#include <Array.au3>
#Include <File.au3>
#include <FileConstants.au3>

Hash2Array()
;_ArrayDisplay(Hash2Array())

Func Hash2Array()
#include <MsgBoxConstants.au3>
#include <Array.au3> ; Required for _ArrayDisplay() only.

local $var[3]
Local $element
Local $hArray[1] =[""]
Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Hashes'
Local $n = 1
Local $sSubKey = RegEnumKey($mainkey, 1)

While $sSubKey <> ""
  Local $sSubKey = RegEnumKey($mainkey, $n)
  $var[1] = $mainkey & '\' & $sSubKey
  $element = Regread($var[1], 'Description')
;  MsgBox($MB_SYSTEMMODAL, "", $n)
;  MsgBox($MB_SYSTEMMODAL, "", $var[1])
;  MsgBox($MB_SYSTEMMODAL, "", $sSubKey) 
;  MsgBox($MB_SYSTEMMODAL, "", $element) 
 _ArrayAdd($hArray, $element)
$n = $n + 1
WEnd


;Kasuje pusty rekord powsta�y przy tworzeniu wektora
_ArrayPush($hArray,"")
_ArrayPop($hArray)
_ArrayPop($hArray)
;_ArrayDisplay($hArray)

Return $hArray

EndFunc