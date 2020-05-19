;Func DeleteGUIDs($_item) is imported from Path2Array.au3
;#include <Array.au3>
;#Include <File.au3>
;#include <FileConstants.au3>
;#include <MsgBoxConstants.au3>

Func FWRule2Array()
; Creates an array of entries from the $mainkey values, each entry has the form: application path & info & Guid
Local $hArray[1] =[""]
Local $mainkey = 'HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\FirewallRules'
Local $FRRule
Local $RuleName
Local $RuleAction
Local $sSubVal
Local $element
Local $filepath
Local $n = 1
Local $m
Local $p
Local $end
Local $sSubVal = RegEnumVal($mainkey, 1)
Local $sToAdd
Local $fileinfo

While $sSubVal <> ""
  $sSubVal = RegEnumVal($mainkey, $n)
  If StringInStr($sSubVal, $FWPart_GUID) = 1 Then
     $FRRule = RegRead($mainkey, $sSubVal)
     If StringInStr($FRRule, "|Action=Block|") Then $RuleAction = "Block: "
     If StringInStr($FRRule, "|Action=Allow|") Then $RuleAction = "Allow: "
     If StringInStr($FRRule, "|Active=FALSE|") Then $RuleAction = "Inactive: "
;     MsgBox(0, "", $sSubVal & @crlf & $FRRule)
     $end = StringInStr($FRRule, "|Name=H_C rule for: ") - 1
     $element = StringReverse(StringLeft($FRRule, $end))
     $m = StringInStr($element, "=", 1)
     $filepath = StringReverse(StringLeft($element, $m - 1))
;     MsgBox(0,"",$filepath)
     If StringInStr($FRRule, "|EmbedCtxt=H_C Firewall Rules|")>0 Then
        $fileinfo = FileGetVersion ( $filepath, $FV_COMPANYNAME)
        $fileinfo = $fileinfo & "   " & FileGetVersion ( $filepath, $FV_FILEDESCRIPTION)
        $fileinfo = $fileinfo & "   " & FileGetVersion ( $filepath, $FV_FILEVERSION)
        $element = $filepath & $SpacesAndStars & $fileinfo & '   REG = ' & $sSubVal
        $p = StringInStr(StringReverse ($filepath),"\") -1
        $RuleName = $RuleAction & $element
;        MsgBox(0,"",$RuleName)
        _ArrayAdd($hArray, $RuleName)
     EndIf  
  EndIf
   $n = $n + 1
WEnd

;Kasuje pusty rekord powsta³y przy tworzeniu wektora
;_ArrayPush($hArray,"")
;_ArrayPop($hArray)
;_ArrayDisplay($hArray)
;_ArrayPop($hArray)
;_ArrayDisplay($hArray)

Return $hArray

EndFunc



