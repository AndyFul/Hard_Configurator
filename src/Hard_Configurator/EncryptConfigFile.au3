; Encrypt
;Local $x = "c:\Windows\Hard_Configurator\Configuration\2.hdc"
;Local $y = EncryptConfigFile($x, 'ENCRYPT')
;FileWrite("c:\Windows\Hard_Configurator\Configuration\encrypted.hdc", $y)

; Decrypt
;Local $x = "c:\Windows\Hard_Configurator\Configuration\encrypted.hdc"
;Local $y = EncryptConfigFile($x, 'DECRYPT')
;FileWrite("c:\Windows\Hard_Configurator\Configuration\decrypted.hdc", $y)

Func EncryptConfigFile($file, $flag)
Local $sEncrypted
Local $sDecrypted

; $file = path to the file that is going to be encrypted
    Local $original = FileRead($file)
;    MsgBox(0,"",$original)
;   Encrypt text using a generic password.
    If $flag = 'ENCRYPT' Then 
       $sEncrypted = StringEncrypt(True, $original)
;      Display the encrypted text.
;      MsgBox($MB_SYSTEMMODAL, '', "DONE")
;       MsgBox($MB_SYSTEMMODAL, 'Encrypted', $sEncrypted)
       Return $sEncrypted
    EndIf
    ; Decrypt the encrypted text using the generic password.
    If $flag = 'DECRYPT' Then 
       $sDecrypted = StringEncrypt(False, $original)
;      Display the decrypted text.
;      MsgBox($MB_SYSTEMMODAL, '', "DONE")
;       MsgBox($MB_SYSTEMMODAL, 'Decrypted', $sDecrypted)
       Return $sDecrypted
    EndIf
    Return 'ERROR'
EndFunc


Func StringEncrypt($bEncrypt, $sData)
    Local Const $sPassword = '*y^vv%:;BQ!l+'
    _Crypt_Startup() ; Start the Crypt library.
    Local $sReturn = ''
    If $bEncrypt Then ; If the flag is set to True then encrypt, otherwise decrypt.
        $sReturn = _Crypt_EncryptData($sData, $sPassword, $CALG_AES_256)
    Else
        $sDecrypted = _Crypt_DecryptData($sData, $sPassword, $CALG_AES_256)
        $sReturn = BinaryToString($sDecrypted)
    EndIf
    _Crypt_Shutdown() ; Shutdown the Crypt library.
    Return $sReturn
EndFunc   ;==>StringEncrypt
