$systemdrive = EnvGet('systemdrive')
$homedrive = EnvGet('homedrive')
$Hpath0 = EnvGet('homedrive') & '\Users\*\AppData'
$Hpath = @HomeDrive & '\Users\*\AppData'
;MsgBox(0,"",$systemdrive & @crlf & $homedrive & @crlf & @homedrive & @crlf & $Hpath0 & @crlf & $Hpath)
ShellExecute("c:\zz\ccc\IsSmartScreen2.exe","","")