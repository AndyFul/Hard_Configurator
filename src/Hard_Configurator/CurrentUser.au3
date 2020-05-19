#include<Security.au3>
Func _GetCurrentUser()
    Local $result = DllCall("Wtsapi32.dll","int", "WTSQuerySessionInformationW", "Ptr", 0, "int", -1, "int", 5, "ptr*", 0, "dword*", 0)
    If @error Or $result[0] = 0 Then Return SetError(1,0,"")
    Local $User = DllStructGetData(DllStructCreate("wchar[" & $result[5] & "]" , $result[4]),1)
    DllCall("Wtsapi32.dll", "int", "WTSFreeMemory", "ptr", $result[4])
    Return $User
EndFunc

Func _GetCurrentUserSID()
    ; Prog@ndy
    Local $User = _Security__LookupAccountName(_GetCurrentUser(),@ComputerName)
    If @error Then Return SetError(1,0,"")
    Return $User[0]
EndFunc

