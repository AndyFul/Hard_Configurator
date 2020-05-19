RegWrite('HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', 'Hard_ConfiguratorSwitch', 'REG_SZ', @WindowsDir & "\explorer.exe " & @WindowsDir & "\Hard_Configurator\SwitchDefaultDeny(x86).exe")

