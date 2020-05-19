#include 'RegCopyKey.au3'
#RequireAdmin

;$key1 = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModel'
;$key2 = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModellll'

;$key1 = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModel\CloudExtensions'
;$key2 = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CCCCodeIdentifiers\262144\Paths\{625B53C3-AB48-4EC1-BA1F-A1EF4146FC19}'

$key2 = 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\MitigationOpions'
$key1 = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\WindowsDefaults\MitigationOpions'

MsgBox(0,"", _RegCopyKey($key1, $key2, False) & "   " & @error & "    " & @extended)
