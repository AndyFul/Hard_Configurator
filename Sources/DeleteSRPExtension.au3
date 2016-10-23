Func DeleteSRPExtension($x)

#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Array.au3> ; Required for _ArrayDisplay() only.

Local $_Array = Reg2Array()

local $n = _ArraySearch ( $_Array, $x)
If $n <> -1 Then
     If UBound($_Array) = 2  Then
             $_Array = [""]
             Array2Reg($_Array)
;           MsgBox($MB_SYSTEMMODAL, "Alert", "There is no extensions on the list." & @CRLF & "Consider to reinstall SRP")
     Else
             _ArrayDelete ( $_Array, $n )
             Array2Reg($_Array)
             Return "true"
;    MsgBox($MB_SYSTEMMODAL, "SUCCESS", $n)
     EndIf
Else
     If $x <> "" Then MsgBox($MB_SYSTEMMODAL, "ERROR", "Extension not found")
     Return "false"
EndIf

EndFunc


Func Array2Reg($aArray)

#include <MsgBoxConstants.au3>
#include <Array.au3> ; Required for _ArrayDisplay() only.

_ArraySort($aArray)
Local $element
Local $sVar = ""
While UBound($aArray) > 0
$element = _ArrayPop ($aArray)
$sVar = $sVar & $element & @LF
WEnd

$sVar = StringLeft($sVar, StringLen($sVar)-1)

;MsgBox($MB_SYSTEMMODAL, "", $sVar)

RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'ExecutableTypes','REG_MULTI_SZ',  $sVar)

EndFunc


Func Reg2Array()
#include <MsgBoxConstants.au3>
#include <Array.au3> ; Required for _ArrayDisplay() only.

Local $aArray[1] =[""]
Local $sVar = RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', "ExecutableTypes")&@LF
Local $element
Local $n
;MsgBox($MB_SYSTEMMODAL, "", $sVar)

While StringLen ( $sVar ) > 1
;MsgBox($MB_SYSTEMMODAL, "", StringLen ( $sVar ))
$n = StringInStr ( $sVar, @LF)
$element = StringLeft ( $sVar, $n-1)
_ArrayAdd($aArray, $element)
$sVar = StringRight ( $sVar,StringLen ( $sVar )-$n)
WEnd

;Kasuje pusty rekord powsta³y przy tworzeniu wektora
_ArrayPush($aArray,"")
_ArrayPop($aArray)
;_ArrayDisplay($aArray)

Return $aArray

EndFunc