; Author = Venom007 (slightly modified by Andy Ful)
Func _CreateRestorePoint()
    #RequireAdmin
    $sRestorePointName = 'Hard_Configurator'
;    SplashTextOn("Restore Point", "Creating Restore Point." & @CRLF & @CRLF & _
;            "Please Wait", 300, 90, -1, -1, 18)
    SplashTextOn("Restore Point", "Creating Restore Point. Please Wait", 300, 50, -1, -1, 0, "", 10)

    Local $objSystemRestore
    If (@OSVersion="WIN_10" or  @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
       Local $Reg = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore'
       Local $save_val = RegRead($Reg, 'SystemRestorePointCreationFrequency')
       If not (@error = 0 ) Then $save_val = ""
       RegWrite($Reg, 'SystemRestorePointCreationFrequency', 'REG_DWORD', Number('0'))
    EndIf
    $objSystemRestore = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestore")
    If Not ($objSystemRestore.createrestorepoint($sRestorePointName, 0, 100) = 0) Then SetError(1)
    SplashOff()
    If Not @error Then
        SplashTextOn("System Restore", "System Restore Point Created Successfully.", 300, 50, -1, -1, 0, "", 10)
        Sleep(3000)
        SplashOff()
        Return 1
    Else
        SplashTextOn("System Restore Error", "System Restore Point Was Not Created.", 300, 50, -1, -1, 0, "", 10)
        Sleep(4000)
        SplashOff()
        Return 0
    EndIf
    If (@OSVersion="WIN_10" or  @OSVersion="WIN_81" or @OSVersion="WIN_8") Then
       If not ($save_val = "") Then
           RegWrite($Reg, 'SystemRestorePointCreationFrequency', 'REG_DWORD', $save_val)
       Else
           RegDelete($Reg, 'SystemRestorePointCreationFrequency')
       EndIf
    EndIf
EndFunc