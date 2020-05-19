Func RemoveSRP($flag)
; $flag = "0" means standard way, $flag = "1" means advanced way
Local $key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer'
Local $key1 = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator'

If $flag = "1" Then Restore_SRP_Permissions()

RegWrite($key & '\CodeIdentifiers', 'DefaultLevel','REG_DWORD',Number('262144'))
RegWrite($key & '\CodeIdentifiers', 'TransparentEnabled','REG_DWORD',Number('0'))
RegWrite($key & '\CodeIdentifiers', 'PolicyScope','REG_DWORD',Number('1'))
RegWrite($key & '\CodeIdentifiers', 'AuthenticodeEnabled','REG_DWORD',Number('0'))
RegDelete($key & '\CodeIdentifiers', 'ExecutableTypes')
RegDelete($key & '\CodeIdentifiers\0')
RegDelete($key & '\CodeIdentifiers\131072')
AddSRPExtension('*****')
DeleteSRPExtension('*****')
RegDelete($key & '\CodeIdentifiers\262144')
AddSRPExtension('*****')
DeleteSRPExtension('*****')
RegDelete($key)
RegDelete($key1 & '\CodeIdentifiers')

RegWrite($key1 & '\CodeIdentifiers', 'Installed', 'REG_SZ', '1')
RegWrite($key1 & '\CodeIdentifiers', 'TurnOFFAllSRP', 'REG_SZ', '0')
RegWrite($key & '\CodeIdentifiers', 'AuthenticodeEnabled', 'REG_DWORD', Number('0'))
$RefreshChangesCheck = $RefreshChangesCheck & "SRPTransparentEnabled" & @LF

EndFunc


