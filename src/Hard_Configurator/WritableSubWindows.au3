Func WritableSubWindows($flag)
#RequireAdmin

Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-5E544B6A33'
Local $ToolsGUID = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{5d175a36-ec0e-4585-a588-95a5f942b3a3}'
; Poprawka na star¹ wersjê Hard_Configuratora
If @OSArch = "X86" Then 
            RegDelete($RegGUID & '02}')
            RegDelete($RegGUID & '03}')
EndIf
;   Switch to 'OFF'
If not ($WritableSubWindows = 'OFF') Then
         RegDelete($ToolsGUID)
         If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
            RegDelete($RegGUID & '02}')
            RegDelete($RegGUID & '03}')
            RegDelete($RegGUID & '04}')
            RegDelete($RegGUID & '05}')
            RegDelete($RegGUID & '06}')
            RegDelete($RegGUID & '07}')
            RegDelete($RegGUID & '08}')
            RegDelete($RegGUID & '09}')
            RegDelete($RegGUID & '10}')
            RegDelete($RegGUID & '11}')
            RegDelete($RegGUID & '12}')
            RegDelete($RegGUID & '13}')
	    RegDelete($RegGUID & '14}')
            RegDelete($RegGUID & '15}')
            RegDelete($RegGUID & '16}')
            RegDelete($RegGUID & '17}')
            RegDelete($RegGUID & '18}')
            RegDelete($RegGUID & '19}')
            RegDelete($RegGUID & '20}')
         EndIf
         RefreshChangesCheck("WritableSubWindows")
Else
    If $isSRPinstalled = "Installed" Then
       If not ( $SRPTransparentEnabled = "No Enforcement") Then
; Switch to 'ON'
         RegWrite($ToolsGUID, 'Description','REG_SZ','')
         RegWrite($ToolsGUID, 'SaferFlags','REG_DWORD',Number('0'))
         RegWrite($ToolsGUID, 'ItemData','REG_SZ', $ProgramFolder & 'Tools')
         If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
            If @OSArch = "X64" Then 
               RegWrite($RegGUID & '02}', 'Description','REG_SZ','')
               RegWrite($RegGUID & '02}', 'SaferFlags','REG_DWORD',Number('0'))
               RegWrite($RegGUID & '02}', 'ItemData','REG_SZ', @WindowsDir & '\SysWOW64\FxsTmp')
               RegWrite($RegGUID & '03}', 'Description','REG_SZ','')
               RegWrite($RegGUID & '03}', 'SaferFlags','REG_DWORD',Number('0'))
               RegWrite($RegGUID & '03}', 'ItemData','REG_SZ', @WindowsDir & '\SysWOW64\Com\dmp')
            EndIf
            RegWrite($RegGUID & '04}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '04}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '04}', 'ItemData','REG_SZ', @WindowsDir & '\System32\FxsTmp')
            RegWrite($RegGUID & '05}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '05}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '05}', 'ItemData','REG_SZ', @WindowsDir & '\debug\WIA')
            RegWrite($RegGUID & '06}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '06}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '06}', 'ItemData','REG_SZ', @WindowsDir & '\Registration\CRMLog')
            RegWrite($RegGUID & '07}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '07}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '07}', 'ItemData','REG_SZ', @WindowsDir & '\System32\spool\drivers\color')
            RegWrite($RegGUID & '08}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '08}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '08}', 'ItemData','REG_SZ', @WindowsDir & '\System32\Com\dmp')
            RegWrite($RegGUID & '09}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '09}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '09}', 'ItemData','REG_SZ', @WindowsDir & '\Tasks')
            RegWrite($RegGUID & '10}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '10}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '10}', 'ItemData','REG_SZ', @WindowsDir & '\tracing')
            RegWrite($RegGUID & '11}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '11}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '11}', 'ItemData','REG_SZ', @WindowsDir & '\System32\Tasks')
            RegWrite($RegGUID & '12}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '12}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '12}', 'ItemData','REG_SZ', @WindowsDir & '\Temp')
            RegWrite($RegGUID & '13}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '13}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '13}', 'ItemData','REG_SZ', @WindowsDir & '\System32\spool\PRINTERS')
            If @OSArch = "X64" Then
               RegWrite($RegGUID & '14}', 'Description','REG_SZ','')
               RegWrite($RegGUID & '14}', 'SaferFlags','REG_DWORD',Number('0'))
               RegWrite($RegGUID & '14}', 'ItemData','REG_SZ', @WindowsDir & '\SysWOW64\Tasks')
            EndIf
            RegWrite($RegGUID & '15}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '15}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '15}', 'ItemData','REG_SZ', @WindowsDir & '\System32\catroot2\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}')
            RegWrite($RegGUID & '16}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '16}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '16}', 'ItemData','REG_SZ', @WindowsDir & '\System32\Microsoft\Crypto\RSA\MachineKeys')
            RegWrite($RegGUID & '17}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '17}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '17}', 'ItemData','REG_SZ', @WindowsDir & '\System32\spool\SERVERS')
            RegWrite($RegGUID & '18}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '18}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '18}', 'ItemData','REG_SZ', @WindowsDir & '\System32\Tasks_Migrated')
            RegWrite($RegGUID & '19}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '19}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '19}', 'ItemData','REG_SZ', @WindowsDir & '\servicing\Packages')
            RegWrite($RegGUID & '20}', 'Description','REG_SZ','')
            RegWrite($RegGUID & '20}', 'SaferFlags','REG_DWORD',Number('0'))
            RegWrite($RegGUID & '20}', 'ItemData','REG_SZ', @WindowsDir & '\servicing\Sessions')
         EndIf
         RefreshChangesCheck("WritableSubWindows")
       Else
;         MsgBox(262144,"","The Enforcement option must be set to 'Skip DLLs' or 'All Files'.")
       EndIf
    Else
       MsgBox(262144,"","This option needs SRP to be installed, with Enforcement set to 'Skip DLLs' or 'All Files'.")
    EndIf
EndIf

;ShowRegistryTweaks()
If not ($flag = '1') Then 
   RefreshMoreSRPRestrictionsGUI()
EndIf

EndFunc


Func CheckWritableSubWindows()

Local $RegGUID='HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-5E544B6A33'
Local $ToolsGUID = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{5d175a36-ec0e-4585-a588-95a5f942b3a3}'
Local $n=0
If RegRead($ToolsGUID, 'SaferFlags') = '0' Then $n = $n+1
If RegRead($ToolsGUID, 'ItemData') = $ProgramFolder & 'Tools' Then $n = $n+1  
If (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
   If @OSArch = "X64" Then 
      If RegRead($RegGUID & '02}', 'SaferFlags') = '0' Then $n = $n+1
      If RegRead($RegGUID & '02}', 'ItemData') = @WindowsDir & '\SysWOW64\FxsTmp' Then $n = $n+1
      If RegRead($RegGUID & '03}', 'SaferFlags') = '0' Then $n = $n+1
      If RegRead($RegGUID & '03}', 'ItemData') = @WindowsDir & '\SysWOW64\Com\dmp' Then $n = $n+1
   EndIf
   If RegRead($RegGUID & '04}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '04}', 'ItemData') = @WindowsDir & '\System32\FxsTmp' Then $n = $n+1
   If RegRead($RegGUID & '05}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '05}', 'ItemData') = @WindowsDir & '\debug\WIA' Then $n = $n+1
   If RegRead($RegGUID & '06}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '06}', 'ItemData') = @WindowsDir & '\Registration\CRMLog' Then $n = $n+1
   If RegRead($RegGUID & '07}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '07}', 'ItemData') = @WindowsDir & '\System32\spool\drivers\color' Then $n = $n+1
   If RegRead($RegGUID & '08}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '08}', 'ItemData') = @WindowsDir & '\System32\Com\dmp' Then $n = $n+1
   If RegRead($RegGUID & '09}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '09}', 'ItemData') = @WindowsDir & '\Tasks' Then $n = $n+1
   If RegRead($RegGUID & '10}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '10}', 'ItemData') = @WindowsDir & '\tracing' Then $n = $n+1
   If RegRead($RegGUID & '11}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '11}', 'ItemData') = @WindowsDir & '\System32\Tasks' Then $n = $n+1
   If RegRead($RegGUID & '12}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '12}', 'ItemData') = @WindowsDir & '\Temp' Then $n = $n+1
   If RegRead($RegGUID & '13}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '13}', 'ItemData') = @WindowsDir & '\System32\spool\PRINTERS' Then $n = $n+1
   If @OSArch = "X64" Then 
      If RegRead($RegGUID & '14}', 'SaferFlags') = '0' Then $n = $n+1
      If RegRead($RegGUID & '14}', 'ItemData') = @WindowsDir & '\SysWOW64\Tasks' Then $n = $n+1
   EndIf
   If RegRead($RegGUID & '15}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '15}', 'ItemData') = @WindowsDir & '\System32\catroot2\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}' Then $n = $n+1
   If RegRead($RegGUID & '16}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '16}', 'ItemData') = @WindowsDir & '\System32\Microsoft\Crypto\RSA\MachineKeys' Then $n = $n+1
   If RegRead($RegGUID & '17}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '17}', 'ItemData') = @WindowsDir & '\System32\spool\SERVERS' Then $n = $n+1
   If RegRead($RegGUID & '18}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '18}', 'ItemData') = @WindowsDir & '\System32\Tasks_Migrated' Then $n = $n+1
   If RegRead($RegGUID & '19}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '19}', 'ItemData') = @WindowsDir & '\servicing\Packages' Then $n = $n+1
   If RegRead($RegGUID & '20}', 'SaferFlags') = '0' Then $n = $n+1
   If RegRead($RegGUID & '20}', 'ItemData') = @WindowsDir & '\servicing\Sessions' Then $n = $n+1
;   MsgBox(0,"",$n)
   If (@OSArch = "X64" And $n = 40) Then Return 1
   If (@OSArch = "X86" And $n = 34) Then Return 1
   If $n = 0  Then Return 0
   If $n > 0  Then Return 2
EndIf

EndFunc