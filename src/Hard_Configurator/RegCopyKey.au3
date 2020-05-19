#cs
    x64 Platforms:
    
    For all registry functions, the root key may be suffixed with either 32 or 64 to specify the
    particular registry view on which to operate.
    
    For example, HKLM32 will unconditionally reference the 32-bit registry view, while HKLM64 will
    unconditionally reference the 64-bit registry view.
    
    Examples:
    HKEY_LOCAL_MACHINE32
    HKEY_CURRENT_USER64
    HKU32
#ce

#RequireAdmin

;Global Const $ReG_NoNE = 0
;Global Const $REG_SZ = 1
;Global Const $REG_EXPAND_SZ = 2
;Global Const $REG_BINARY = 3
;Global Const $REG_DWORD = 4
;Global Const $REG_MULTI_SZ = 7
;Global $Temp_Dir, $Temp_reg, $Name, $Path, $Reg1, $Reg2, $AU3, $Error = 0, $Key, $n
;Global Const $REG_QWORD = 11
Global Const $HKEY_CLASSES_ROOT = 0x80000000
Global Const $HKEY_CURRENT_USER = 0x80000001
Global Const $HKEY_LOCAL_MACHINE = 0x80000002
Global Const $HKEY_USERS = 0x80000003
Global Const $HKEY_PERFORMANCE_DATA = 0x80000004
Global Const $HKEY_PERFORMANCE_TEXT = 0x80000050
Global Const $HKEY_PERFORMANCE_NLSTEXT = 0x80000060
Global Const $HKEY_CURRENT_CONFIG = 0x80000005
Global Const $HKEY_DYN_DATA = 0x80000006
Global Const $KEY_QUERY_VALUE = 0x0001
Global Const $KEY_SET_VALUE = 0x0002
Global Const $KEY_ENUMERATE_SUB_KEYS = 0x0008
Global Const $KEY_WRITE = 0x20006
Global Const $KEY_READ = 0x20019
Global Const $REG_OPTION_NON_VOLATILE = 0x0000
Global Const $REG_OPTION_VOLATILE = 0x0001
Global Const $KEY_WOW64_64KEY = 0x0100
Global Const $KEY_WOW64_32KEY = 0x0200


; #FUNCTION# ====================================================================================================
; Name...........:  _RegCopyKey
; Description....:  Recursively copy a registry key, including all subkeys and values
; Syntax.........:  _RegCopyKey($s_key, $d_key)
; Parameters.....:  $s_key  - Source key
;                   $d_key  - Destination key
;                   $delete - [Internal]
;
; Return values..:  Success - 1
;                   Failure - 0 and sets @error
;                           |-1 - Source and destination keys are the same
;                           | 1 - Source does not exist or cannot be accessed
;                           | 2 - Failed to write destination key (@extended contains _RegWrite error code)
;                           | 3 - Failed to read one or more values from source key or subkey(s)
; Author.........:  Erik Pilsits  (with small modifications by Andy Ful to work with REG_MULTI_SZ values)
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================

Func _RegCopyKey($s_key, $d_key, $delete = False)


    If $s_key = $d_key Then Return SetError(-1, 0, 0) ; destination is the same as source
    If Not _RegKeyExists($s_key) Then Return SetError(1, 0, 0)
;Modification made by Andy Ful 
;********************************************************
    RegWrite($d_key) ; write destination key in case source key empty
    If @error Then Return SetError(2, @error, 0)
;Modification made by Andy Ful 
;********************************************************
    ; value loop
    Local $i = 0, $val, $data, $err = 0
    While 1
        $val = _RegEnumValue($s_key, $i)
        If @error Then ExitLoop ; no more values
;Modification made by Andy Ful 
;**************************************
        $data = RegRead($s_key, $val)
;**************************************
        If @error Then
            $err = 3
            ContinueLoop ; some error reading value, skip it
        EndIf
        _RegWrite($d_key, $val, @extended, $data) ; write new value
;Modification made by Andy Ful 
;********************************************************
        If @error = 5 Then
            RegWrite($d_key, $val, 'REG_MULTI_SZ', $data)
        EndIf
;********************************************************
        $i += 1
    WEnd
    ; key loop
    Local $key
    $i = 0
    While 1
        $key = _RegEnumKey($s_key, $i)
        If @error Then ExitLoop ; no more keys
        _RegCopyKey($s_key & "\" & $key, $d_key & "\" & $key) ; recurse
        If @error = 3 Then $err = 3 ; test for errors reading subkey values
        $i += 1
    WEnd
    If $err Then Return SetError($err, 0, 0) ; error(s) reading value(s) or subkey value(s)
    ; move key
    If $delete Then
        ; delete source key only if copy was entirely successful
        _RegDelete($s_key)
        If @error Then Return SetError(4, @error, 0) ; error deleting source key
    EndIf
    Return SetError(0, 0, 1)
EndFunc

; ===============================================================================================================
Func _RegKeyExists($s_key)
;Modification made by Andy Ful 
;**************************************
    RegRead($s_key, "") ; try to read default value
;**************************************
    Switch @error
        Case 1, 2
            ; invalid root key | failed to open key
            Return SetError(@error, 0, 0)
        Case Else
            ; key exists
            Return SetError(0, 0, 1)
    EndSwitch
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........:  _RegValueExists
; Description....:  Test for the existence of a registry value
; Syntax.........:  _RegValueExists($s_key, $s_val)
; Parameters.....:  $s_key  - Source key
;                   $s_val  - Value to test
;
; Return values..:  Success - 1
;                   Failure - 0 and sets @error
;                           | 1 - Root key does not exist
;                           | 2 - Target key does not exist
;                           | 4 - Target value does not exist
; Author.........:  Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegValueExists($s_key, $s_val)
;Modification made by Andy Ful 
;**************************************
    RegRead($s_key, $s_val)
;**************************************
    ; @error = 3 is 'unsupported value type', implying value still exists
    Switch @error
        Case 1, 2, 4
            ; invalid root key | failed to open key | failed to read value
            Return SetError(@error, 0, 0)
        Case Else
            Return SetError(0, 0, 1)
    EndSwitch
EndFunc



Func _RegTrimBinary($data, $pattern)
    ; trim a repeating binary pattern from the end of binary data
    ; set starting point to pattern byte size from end (BinaryMid is 1-based, so decrement 1 byte less than pattern length)
    Local $pLen = BinaryLen($pattern)
    Local $start = BinaryLen($data) - ($pLen - 1)
    While 1
        If $start < 0 Then
            ; if start is < 0, then there is no data left
            ; set start to 0 (returns empty binary variant from BinaryMid) and exit loop
            $start = 0
            ExitLoop
        EndIf
        ; test if a terminating null and decrement
        If BinaryMid($data, $start, $pLen) = $pattern Then
            $start -= $pLen
        Else
            ; found data, increment one byte
            $start += ($pLen - 1)
            ExitLoop
        EndIf
    WEnd
    ; get data
    Return BinaryMid($data, 1, $start)
EndFunc



Func _RegOpenKey($szKey, $iAccess, $fOpen = True, $dwOptions = $REG_OPTION_NON_VOLATILE)
    ; $iView is set and returned because RegDeleteKeyEx takes the 32/64 registry view flag determined in this function
    Local $iView = 0
    Local $hRoot = StringLeft($szKey, StringInStr($szKey, "\") - 1)
    If $hRoot = "" Then $hRoot = $szKey ; passed a root key
    Switch $hRoot
        Case "HKEY_LOCAL_MACHINE", "HKLM"
            $hRoot = $HKEY_LOCAL_MACHINE
        Case "HKEY_LOCAL_MACHINE32", "HKLM32"
            $hRoot = $HKEY_LOCAL_MACHINE
            $iAccess = BitOR($iAccess, $KEY_WOW64_32KEY)
            $iView = $KEY_WOW64_32KEY
        Case "HKEY_LOCAL_MACHINE64", "HKLM64"
            $hRoot = $HKEY_LOCAL_MACHINE
            $iAccess = BitOR($iAccess, $KEY_WOW64_64KEY)
            $iView = $KEY_WOW64_64KEY
        Case "HKEY_USERS", "HKU"
            $hRoot = $HKEY_USERS
        Case "HKEY_USERS32", "HKU32"
            $hRoot = $HKEY_USERS
            $iAccess = BitOR($iAccess, $KEY_WOW64_32KEY)
            $iView = $KEY_WOW64_32KEY
        Case "HKEY_USERS64", "HKU64"
            $hRoot = $HKEY_USERS
            $iAccess = BitOR($iAccess, $KEY_WOW64_64KEY)
            $iView = $KEY_WOW64_64KEY
        Case "HKEY_CURRENT_USER", "HKCU"
            $hRoot = $HKEY_CURRENT_USER
        Case "HKEY_CURRENT_USER32", "HKCU32"
            $hRoot = $HKEY_CURRENT_USER
            $iAccess = BitOR($iAccess, $KEY_WOW64_32KEY)
            $iView = $KEY_WOW64_32KEY
        Case "HKEY_CURRENT_USER64", "HKCU64"
            $hRoot = $HKEY_CURRENT_USER
            $iAccess = BitOR($iAccess, $KEY_WOW64_64KEY)
            $iView = $KEY_WOW64_64KEY
        Case "HKEY_CLASSES_ROOT", "HKCR"
            $hRoot = $HKEY_CLASSES_ROOT
        Case "HKEY_CURRENT_CONFIG", "HKCC"
            $hRoot = $HKEY_CURRENT_CONFIG
        Case Else
            Return SetError(1, 0, 0)
    EndSwitch

    Local $szSubkey = StringTrimLeft($szKey, StringInStr($szKey, "\"))
    If $szSubkey = $szKey Then $szSubkey = "" ; root key
    Local $ret
    If $fOpen Then
        ; RegOpenKeyExW
        $ret = DllCall("advapi32.dll", "long", "RegOpenKeyExW", "ulong_ptr", $hRoot, "wstr", $szSubkey, "dword", 0, "ulong", $iAccess, "ulong_ptr*", 0)
        If @error Or ($ret[0] <> 0) Then
            If IsArray($ret) Then
                Return SetError(2, $ret[0], 0)
            Else
                Return SetError(2, 0, 0)
            EndIf
        EndIf
        Return SetError(0, $iView, $ret[5])
    Else
        ; RegCreateKeyExW, really just for _RegWrite
        $ret = DllCall("advapi32.dll", "long", "RegCreateKeyExW", "ulong_ptr", $hRoot, "wstr", $szSubkey, "dword", 0, "ptr", 0, "dword", $dwOptions, _
                "ulong", $iAccess, "ptr", 0, "ulong_ptr*", 0, "ptr*", 0)
        If @error Or ($ret[0] <> 0) Then
            If IsArray($ret) Then
                Return SetError(2, $ret[0], 0)
            Else
                Return SetError(2, 0, 0)
            EndIf
        EndIf
        Return SetError(0, $iView, $ret[8])
    EndIf
EndFunc       ;==>_RegOpenKey

; #FUNCTION# ====================================================================================================
; Name...........:  _RegWrite
; Description....:  Create a registry key or value.
; Syntax.........:  _RegWrite($szKey[, $szValue = ""[, $iType = -1[, $bData = Default[, $dwOptions = $REG_OPTION_NON_VOLATILE]]]])
; Parameters.....:  $szKey      - Destination key
;                       $szValue        - [Optional] Destination value (Empty string for Default value, must also supply $iType and $bData)
;                       $iType      - [Optional] Type of data to write to $szValue ($iType < 0 writes key only)
;                       $bData      - [Optional] Data to write to $szValue ($bData = Default creates key only)
;                       $dwOptions  - [Optional] Optional flags (can be $REG_OPTION_NON_VOLATILE or $REG_OPTION_VOLATILE)
;
; Return values..:  Success - 1
;                       Failure - 0 and sets @error
;                               | 1 - Invalid root key
;                               | 2 - Failed to open / create destination key (@extended contains RegCreateKeyExW return value)
;                               | 3 - Unsupported value type
;                               | 4 - Failed to write data (@extended contains RegSetValueExW return value)
; Author.........:  Erik Pilsits
; Modified.......:
; Remarks........:  Provide REG_MULTI_SZ values as a single string made up of NULL separated substrings.
;                       Terminating NULLs for all string data types are correctly appended by the function.
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegWrite($szKey, $szValue = "", $iType = -1, $bData = Default, $dwOptions = $REG_OPTION_NON_VOLATILE)
    Local $hKey = _RegOpenKey($szKey, $KEY_WRITE, False, $dwOptions) ; open using RegCreateKeyExW
    If @error Then Return SetError(@error, @extended, 0)
    Local $lpData
    If $iType >= 0 And $bData <> Default Then
        Switch $iType
            ; handle strings as binary data, make sure they are properly terminated
            Case 1, 2
                $bData = StringToBinary($bData, 2) ; UTF16LE
                $bData = _RegTrimBinary($bData, "0x0000") & Binary("0x0000") ; add terminating null
                $lpData = DllStructCreate("byte[" & BinaryLen($bData) & "]")
            Case 7
                Return SetError(5, 0, 0)
                $bData = StringToBinary($bData, 2) ; UTF16LE
                $bData = _RegTrimBinary($bData, "0x0000") & Binary("0x00000000") ; add 2 terminating nulls
                $lpData = DllStructCreate("byte[" & BinaryLen($bData) & "]")
            Case 4
                $lpData = DllStructCreate("dword")
            Case 11
                $lpData = DllStructCreate("int64")
            Case 3, 0
                $lpData = DllStructCreate("byte[" & BinaryLen($bData) & "]")
            Case 5, 6, 8, 9, 10
                ; other uncommon value types
                $lpData = DllStructCreate("byte[" & BinaryLen($bData) & "]")
            Case Else
                DllCall("advapi32.dll", "long", "RegCloseKey", "ulong_ptr", $hKey)
                Return SetError(3, 0, 0)
        EndSwitch
        DllStructSetData($lpData, 1, $bData)
        Local $ret = DllCall("advapi32.dll", "long", "RegSetValueExW", "ulong_ptr", $hKey, "wstr", $szValue, "dword", 0, "dword", $iType, _
                "ptr", DllStructGetPtr($lpData), "dword", DllStructGetSize($lpData))
        If @error Or ($ret[0] <> 0) Then
            If IsArray($ret) Then
                Return SetError(4, $ret[0], 0)
            Else
                Return SetError(4, 0, 0)
            EndIf
        EndIf
    EndIf
    DllCall("advapi32.dll", "long", "RegCloseKey", "ulong_ptr", $hKey)
    Return SetError(0, 0, 1)
EndFunc       ;==>_RegWrite

; #FUNCTION# ====================================================================================================
; Name...........:  _RegEnumKey
; Description....:  Enumerate subkeys of the specified key
; Syntax.........:  _RegEnumKey($szKey, $iIndex)
; Parameters.....:  $szKey  - Parent key
;                       $iIndex - 0-based key instance to retrieve
;
; Return values..:  Success - Requested registry key name (name only, not full path)
;                       Failure - 0 and sets @error
;                               | 1 - Invalid root key
;                               | 2 - Failed to open key (@extended contains RegOpenKeyExW return value)
;                               | 3 - Key index out of range (@extended contains RegEnumKeyExW return value)
; Author.........:  Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegEnumKey($szKey, $iIndex)
    Local $hKey = _RegOpenKey($szKey, $KEY_READ)
    If @error Then Return SetError(@error, @extended, 0)
    Local $ret = DllCall("advapi32.dll", "long", "RegEnumKeyExW", "ptr", $hKey, "dword", $iIndex, "wstr", "", "dword*", 1024, "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0)
    DllCall("advapi32.dll", "long", "RegCloseKey", "ulong_ptr", $hKey)
    If (Not IsArray($ret)) Or ($ret[0] <> 0) Then
        If IsArray($ret) Then
            Return SetError(3, $ret[0], 0)
        Else
            Return SetError(3, 0, 0)
        EndIf
    EndIf
    Return SetError(0, 0, $ret[3])
EndFunc       ;==>_RegEnumKey

; #FUNCTION# ====================================================================================================
; Name...........:  _RegEnumValue
; Description....:  Enumerate values of the specified key
; Syntax.........:  _RegEnumValue($szKey, $iIndex)
; Parameters.....:  $szKey  - Parent key
;                       $iIndex - 0-based value instance to retrieve
;
; Return values..:  Success - Requested registry value
;                       Failure - 0 and sets @error
;                               | 1 - Invalid root key
;                               | 2 - Failed to open key (@extended contains RegOpenKeyExW return value)
;                               | 3 - Value index out of range (@extended contains RegEnumValueW return value)
; Author.........:  Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegEnumValue($szKey, $iIndex)
    Local $hKey = _RegOpenKey($szKey, $KEY_READ)
    If @error Then Return SetError(@error, @extended, 0)
    Local $ret = DllCall("advapi32.dll", "long", "RegEnumValueW", "ptr", $hKey, "dword", $iIndex, "wstr", "", "dword*", 1024, "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0)
    DllCall("advapi32.dll", "long", "RegCloseKey", "ulong_ptr", $hKey)
    If (Not IsArray($ret)) Or ($ret[0] <> 0) Then
        If IsArray($ret) Then
            Return SetError(3, $ret[0], 0)
        Else
            Return SetError(3, 0, 0)
        EndIf
    EndIf
    Return SetError(0, 0, $ret[3])
EndFunc       ;==>_RegEnumValue

