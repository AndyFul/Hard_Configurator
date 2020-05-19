Func BlockSponsorsFromProfile($textSource)

Local $Array = TempReg2Array('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator', "text_reg")
;_ArrayDisplay($Array)
; $textSource = text variable with the list of blacklistet sponsors to load.
; Add SRP blacklist Sponsors keys on the base of "...\safer_Hard_Configurator\CodeIdentifiers\BlockSponsors"  keys.
Local $partkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-5E544B6A31'
Local $partkey1 = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-5E544B6A3'
Local $key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers\BlockSponsors'
;MsgBox(262144,"",$textSource)
; Write data to ...\safer\CodeIdentifiers\0\Paths
If  CheckIfSponsorExists($Array, 'IsPowerShellBlocked') = 1 Then
      RegWrite($partkey & '00}', 'Description','REG_SZ','PowerShell')
      RegWrite($partkey & '00}', 'SaferFlags','REG_DWORD',Number('0'))
      RegWrite($partkey & '00}', 'ItemData','REG_SZ','powershell.exe')
      RegWrite($key, 'IsPowerShellBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsPowerShell_iseBlocked') = 1 Then
      RegWrite($partkey & '01}', 'Description','REG_SZ','PowerShell_ise')
      RegWrite($partkey & '01}', 'SaferFlags','REG_DWORD',Number('0'))
      RegWrite($partkey & '01}', 'ItemData','REG_SZ','powershell_ise.exe')
      RegWrite($key, 'IsPowerShell_iseBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsCMDBlocked') = 1 Then
      RegWrite($partkey & '02}', 'Description','REG_SZ','Windows CMD')
      RegWrite($partkey & '02}', 'SaferFlags','REG_DWORD',Number('0'))
      RegWrite($partkey & '02}', 'ItemData','REG_SZ','cmd.exe')
      RegWrite($key, 'IsCMDBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsAttrib.exeBlocked') = 1 Then
      RegWrite($partkey & '03}', 'Description','REG_SZ','Attrib.exe')
      RegWrite($partkey & '03}', 'SaferFlags','REG_DWORD',Number('0'))
      RegWrite($partkey & '03}', 'ItemData','REG_SZ','Attrib.exe')
      RegWrite($key, 'IsAttrib.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsAuditpol.exeBlocked') = 1 Then
   RegWrite($partkey & '04}', 'Description','REG_SZ','Auditpol.exe')
   RegWrite($partkey & '04}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '04}', 'ItemData','REG_SZ','Auditpol.exe')
   RegWrite($key, 'IsAuditpol.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsBcdboot.exeBlocked') = 1 Then
   RegWrite($partkey & '05}', 'Description','REG_SZ','Bcdboot.exe')
   RegWrite($partkey & '05}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '05}', 'ItemData','REG_SZ','Bcdboot.exe')
   RegWrite($key, 'IsBcdboot.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsBcdedit.exeBlocked') = 1 Then
   RegWrite($partkey & '06}', 'Description','REG_SZ','Bcdedit.exe')
   RegWrite($partkey & '06}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '06}', 'ItemData','REG_SZ','Bcdedit.exe')
   RegWrite($key, 'IsBcdedit.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsBitsadmin.exeBlocked') = 1 Then
   RegWrite($partkey & '07}', 'Description','REG_SZ','Bitsadmin.exe')
   RegWrite($partkey & '07}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '07}', 'ItemData','REG_SZ','Bitsadmin.exe')
   RegWrite($key, 'IsBitsadmin.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsBootcfg.exeBlocked') = 1 Then
   RegWrite($partkey & '08}', 'Description','REG_SZ','Bootcfg.exe')
   RegWrite($partkey & '08}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '08}', 'ItemData','REG_SZ','Bootcfg.exe')
   RegWrite($key, 'IsBootcfg.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsBootim.exeBlocked') = 1 Then
   RegWrite($partkey & '09}', 'Description','REG_SZ','Bootim.exe')
   RegWrite($partkey & '09}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '09}', 'ItemData','REG_SZ','Bootim.exe')
   RegWrite($key, 'IsBootim.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsBootsect.exeBlocked') = 1 Then
   RegWrite($partkey & '10}', 'Description','REG_SZ','Bootsect.exe')
   RegWrite($partkey & '10}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '10}', 'ItemData','REG_SZ','Bootsect.exe')
   RegWrite($key, 'IsBootsect.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsByteCodeGenerator.exeBlocked') = 1 Then
   RegWrite($partkey & '11}', 'Description','REG_SZ','ByteCodeGenerator.exe')
   RegWrite($partkey & '11}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '11}', 'ItemData','REG_SZ','ByteCodeGenerator.exe')
   RegWrite($key, 'IsByteCodeGenerator.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsCacls.exeBlocked') = 1 Then
   RegWrite($partkey & '12}', 'Description','REG_SZ','Cacls.exe')
   RegWrite($partkey & '12}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '12}', 'ItemData','REG_SZ','Cacls.exe')
   RegWrite($key, 'IsCacls.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsIcacls.exeBlocked') = 1 Then
   RegWrite($partkey & '13}', 'Description','REG_SZ','Icacls.exe')
   RegWrite($partkey & '13}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '13}', 'ItemData','REG_SZ','Icacls.exe')
   RegWrite($key, 'IsIcacls.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsCsc.exeBlocked') = 1 Then
   RegWrite($partkey & '14}', 'Description','REG_SZ','Csc.exe')
   RegWrite($partkey & '14}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '14}', 'ItemData','REG_SZ','Csc.exe')
   RegWrite($key, 'IsCsc.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsDebug.exeBlocked') = 1 Then
   RegWrite($partkey & '15}', 'Description','REG_SZ','Debug.exe')
   RegWrite($partkey & '15}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '15}', 'ItemData','REG_SZ','Debug.exe')
   RegWrite($key, 'IsDebug.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsDFsvc.exeBlocked') = 1 Then
   RegWrite($partkey & '16}', 'Description','REG_SZ','DFsvc.exe')
   RegWrite($partkey & '16}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '16}', 'ItemData','REG_SZ','DFsvc.exe')
   RegWrite($key, 'IsDFsvc.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsDiskpart.exeBlocked') = 1 Then
   RegWrite($partkey & '17}', 'Description','REG_SZ','Diskpart.exe')
   RegWrite($partkey & '17}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '17}', 'ItemData','REG_SZ','Diskpart.exe')
   RegWrite($key, 'IsDiskpart.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsEventvwr.exeBlocked') = 1 Then
   RegWrite($partkey & '18}', 'Description','REG_SZ','Eventvwr.exe')
   RegWrite($partkey & '18}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '18}', 'ItemData','REG_SZ','Eventvwr.exe')
   RegWrite($key, 'IsEventvwr.exeBlocked', 'REG_DWORD',Number('1'))
EndIF
If  CheckIfSponsorExists($Array, 'IsHH.exeBlocked') = 1 Then
   RegWrite($partkey & '19}', 'Description','REG_SZ','HH.exe')
   RegWrite($partkey & '19}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '19}', 'ItemData','REG_SZ','HH.exe')
   RegWrite($key, 'IsHH.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsIEExec.exeBlocked') = 1 Then
   RegWrite($partkey & '20}', 'Description','REG_SZ','IEExec.exe')
   RegWrite($partkey & '20}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '20}', 'ItemData','REG_SZ','IEExec.exe')
   RegWrite($key, 'IsIEExec.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsIexplore.exeBlocked') = 1 Then
   RegWrite($partkey & '21}', 'Description','REG_SZ','Iexplore.exe')
   RegWrite($partkey & '21}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '21}', 'ItemData','REG_SZ','Iexplore.exe')
   RegWrite($key, 'IsIexplore.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsIexpress.exeBlocked') = 1 Then
   RegWrite($partkey & '22}', 'Description','REG_SZ','Iexpress.exe')
   RegWrite($partkey & '22}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '22}', 'ItemData','REG_SZ','Iexpress.exe')
   RegWrite($key, 'IsIexpress.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsIlasm.exeBlocked') = 1 Then
   RegWrite($partkey & '23}', 'Description','REG_SZ','Ilasm.exe')
   RegWrite($partkey & '23}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '23}', 'ItemData','REG_SZ','Ilasm.exe')
   RegWrite($key, 'IsIlasm.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsInstallUtilLib*Blocked') = 1 Then
   RegWrite($partkey & '24}', 'Description','REG_SZ','InstallUtilLib*')
   RegWrite($partkey & '24}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '24}', 'ItemData','REG_SZ','InstallUtilLib*')
   RegWrite($key, 'IsInstallUtilLib*Blocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsInstallUtil.exeBlocked') = 1 Then
   RegWrite($partkey & '25}', 'Description','REG_SZ','InstallUtil.exe')
   RegWrite($partkey & '25}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '25}', 'ItemData','REG_SZ','InstallUtil.exe')
   RegWrite($key, 'IsInstallUtil.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsJournal.exeBlocked') = 1 Then
   RegWrite($partkey & '26}', 'Description','REG_SZ','Journal.exe')
   RegWrite($partkey & '26}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '26}', 'ItemData','REG_SZ','Journal.exe')
   RegWrite($key, 'IsJournal.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsJsc.exeBlocked') = 1 Then
   RegWrite($partkey & '27}', 'Description','REG_SZ','Jsc.exe')
   RegWrite($partkey & '27}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '27}', 'ItemData','REG_SZ','Jsc.exe')
   RegWrite($key, 'IsJsc.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsMmc.exeBlocked') = 1 Then
   RegWrite($partkey & '28}', 'Description','REG_SZ','Mmc.exe')
   RegWrite($partkey & '28}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '28}', 'ItemData','REG_SZ','Mmc.exe')
   RegWrite($key, 'IsMmc.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsMrsa.exeBlocked') = 1 Then
   RegWrite($partkey & '29}', 'Description','REG_SZ','Mrsa.exe')
   RegWrite($partkey & '29}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '29}', 'ItemData','REG_SZ','Mrsa.exe')
   RegWrite($key, 'IsMrsa.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsMSBuild.exeBlocked') = 1 Then
   RegWrite($partkey & '30}', 'Description','REG_SZ','MSBuild.exe')
   RegWrite($partkey & '30}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '30}', 'ItemData','REG_SZ','MSBuild.exe')
   RegWrite($key, 'IsMSBuild.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsMshta.exeBlocked') = 1 Then
   RegWrite($partkey & '31}', 'Description','REG_SZ','Mshta.exe')
   RegWrite($partkey & '31}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '31}', 'ItemData','REG_SZ','Mshta.exe')
   RegWrite($key, 'IsMshta.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsMstsc.exeBlocked') = 1 Then
   RegWrite($partkey & '32}', 'Description','REG_SZ','Mstsc.exe')
   RegWrite($partkey & '32}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '32}', 'ItemData','REG_SZ','Mstsc.exe')
   RegWrite($key, 'IsMstsc.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsNetsh.exeBlocked') = 1 Then
   RegWrite($partkey & '33}', 'Description','REG_SZ','Netsh.exe')
   RegWrite($partkey & '33}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '33}', 'ItemData','REG_SZ','Netsh.exe')
   RegWrite($key, 'IsNetsh.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsNetstat.exeBlocked') = 1 Then
   RegWrite($partkey & '34}', 'Description','REG_SZ','Netstat.exe')
   RegWrite($partkey & '34}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '34}', 'ItemData','REG_SZ','Netstat.exe')
   RegWrite($key, 'IsNetstat.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsPresentationHost.exeBlocked') = 1 Then
   RegWrite($partkey & '35}', 'Description','REG_SZ','PresentationHost.exe')
   RegWrite($partkey & '35}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '35}', 'ItemData','REG_SZ','PresentationHost.exe')
   RegWrite($key, 'IsPresentationHost.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsQuser.exeBlocked') = 1 Then
   RegWrite($partkey & '36}', 'Description','REG_SZ','Quser.exe')
   RegWrite($partkey & '36}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '36}', 'ItemData','REG_SZ','Quser.exe')
   RegWrite($key, 'IsQuser.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsReg.exeBlocked') = 1 Then
   RegWrite($partkey & '37}', 'Description','REG_SZ','Reg.exe')
   RegWrite($partkey & '37}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '37}', 'ItemData','REG_SZ','Reg.exe')
   RegWrite($key, 'IsReg.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsRegAsmGlobal*Blocked') = 1 Then
   RegWrite($partkey & '38}', 'Description','REG_SZ','RegAsmGlobal*')
   RegWrite($partkey & '38}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '38}', 'ItemData','REG_SZ','RegAsmGlobal*')
   RegWrite($key, 'IsRegAsmGlobal*Blocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsRegini.exeBlocked') = 1 Then
   RegWrite($partkey & '39}', 'Description','REG_SZ','Regini.exe')
   RegWrite($partkey & '39}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '39}', 'ItemData','REG_SZ','Regini.exe')
   RegWrite($key, 'IsRegini.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsRegsvcs.exeBlocked') = 1 Then
   RegWrite($partkey & '40}', 'Description','REG_SZ','Regsvcs.exe')
   RegWrite($partkey & '40}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '40}', 'ItemData','REG_SZ','Regsvcs.exe')
   RegWrite($key, 'IsRegsvcs.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsRegsvr32.exeBlocked') = 1 Then
   RegWrite($partkey & '41}', 'Description','REG_SZ','Regsvr32.exe')
   RegWrite($partkey & '41}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '41}', 'ItemData','REG_SZ','Regsvr32.exe')
   RegWrite($key, 'IsRegsvr32.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsRunLegacyCPLElevated.exeBlocked') = 1 Then
   RegWrite($partkey & '42}', 'Description','REG_SZ','RunLegacyCPLElevated.exe')
   RegWrite($partkey & '42}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '42}', 'ItemData','REG_SZ','RunLegacyCPLElevated.exe')
   RegWrite($key, 'IsRunLegacyCPLElevated.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsRunonce.exeBlocked') = 1 Then
   RegWrite($partkey & '43}', 'Description','REG_SZ','Runonce.exe')
   RegWrite($partkey & '43}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '43}', 'ItemData','REG_SZ','Runonce.exe')
   RegWrite($key, 'IsRunonce.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsRunas.exeBlocked') = 1 Then
   RegWrite($partkey & '44}', 'Description','REG_SZ','Runas.exe')
   RegWrite($partkey & '44}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '44}', 'ItemData','REG_SZ','Runas.exe')
   RegWrite($key, 'IsRunas.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'Is*script.exeBlocked') = 1 Then
   RegWrite($partkey & '45}', 'Description','REG_SZ','*script.exe')
   RegWrite($partkey & '45}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '45}', 'ItemData','REG_SZ','*script.exe')
   RegWrite($key, 'Is*script.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsSet.exeBlocked') = 1 Then
   RegWrite($partkey & '46}', 'Description','REG_SZ','Set.exe')
   RegWrite($partkey & '46}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '46}', 'ItemData','REG_SZ','Set.exe')
   RegWrite($key, 'IsSet.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsSetx.exeBlocked') = 1 Then
   RegWrite($partkey & '47}', 'Description','REG_SZ','Setx.exe')
   RegWrite($partkey & '47}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '47}', 'ItemData','REG_SZ','Setx.exe')
   RegWrite($key, 'IsSetx.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsStash*Blocked') = 1 Then
   RegWrite($partkey & '48}', 'Description','REG_SZ','Stash*')
   RegWrite($partkey & '48}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '48}', 'ItemData','REG_SZ','Stash*')
   RegWrite($key, 'IsStash*Blocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsSystemreset.exeBlocked') = 1 Then
   RegWrite($partkey & '49}', 'Description','REG_SZ','Systemreset.exe')
   RegWrite($partkey & '49}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '49}', 'ItemData','REG_SZ','Systemreset.exe')
   RegWrite($key, 'IsSystemreset.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsTakeown.exeBlocked') = 1 Then
   RegWrite($partkey & '50}', 'Description','REG_SZ','Takeown.exe')
   RegWrite($partkey & '50}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '50}', 'ItemData','REG_SZ','Takeown.exe')
   RegWrite($key, 'IsTakeown.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsTaskkill.exeBlocked') = 1 Then
   RegWrite($partkey & '51}', 'Description','REG_SZ','Taskkill.exe')
   RegWrite($partkey & '51}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '51}', 'ItemData','REG_SZ','Taskkill.exe')
   RegWrite($key, 'IsTaskkill.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsUserAccountControlSettings.exeBlocked') = 1 Then
   RegWrite($partkey & '52}', 'Description','REG_SZ','UserAccountControlSettings.exe')
   RegWrite($partkey & '52}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '52}', 'ItemData','REG_SZ','UserAccountControlSettings.exe')
   RegWrite($key, 'IsUserAccountControlSettings.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsVbc.exeBlocked') = 1 Then
   RegWrite($partkey & '53}', 'Description','REG_SZ','Vbc.exe')
   RegWrite($partkey & '53}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '53}', 'ItemData','REG_SZ','Vbc.exe')
   RegWrite($key, 'IsVbc.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsVssadmin.exeBlocked') = 1 Then
   RegWrite($partkey & '54}', 'Description','REG_SZ','Vssadmin.exe')
   RegWrite($partkey & '54}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '54}', 'ItemData','REG_SZ','Vssadmin.exe')
   RegWrite($key, 'IsVssadmin.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsWmic.exeBlocked') = 1 Then
   RegWrite($partkey & '55}', 'Description','REG_SZ','Wmic.exe')
   RegWrite($partkey & '55}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '55}', 'ItemData','REG_SZ','Wmic.exe')
   RegWrite($key, 'IsWmic.exeBlocked', 'REG_DWORD',Number('1'))
EndIf
If  CheckIfSponsorExists($Array, 'IsXcacls.exeBlocked') = 1 Then
   RegWrite($partkey & '56}', 'Description','REG_SZ','Xcacls.exe')
   RegWrite($partkey & '56}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey & '56}', 'ItemData','REG_SZ','Xcacls.exe')
   RegWrite($key, 'IsXcacls.exeBlocked', 'REG_DWORD',Number('1'))
EndIf


; Checking/Loading entries from the second sponsors list.
For $i = 157 To $NumberOfExecutables + 102
If  CheckIfSponsorExists($Array, 'Is' & $arrBlockSponsors[$i-102] & 'Blocked') = 1 Then
   RegWrite($partkey1 & $i & '}', 'Description','REG_SZ',$arrBlockSponsors[$i-102])
   RegWrite($partkey1 & $i & '}', 'SaferFlags','REG_DWORD',Number('0'))
   RegWrite($partkey1 & $i & '}', 'ItemData','REG_SZ',$arrBlockSponsors[$i-102])
   RegWrite($key, 'Is' & $arrBlockSponsors[$i-102] & 'Blocked', 'REG_DWORD',Number('1'))
EndIf
Next

$RefreshChangesCheck = $RefreshChangesCheck & "BlockAllSponsors" & @LF

EndFunc

Func CheckIfSponsorExists($LoadedSponsorsArray, $SponsorFlag)
  local $n = _ArraySearch ($LoadedSponsorsArray, $SponsorFlag)
  If $n > -1 Then
     If $LoadedSponsorsArray[$n] = $SponsorFlag Then Return 1
  Else 
     Return 0
  EndIf
EndFunc