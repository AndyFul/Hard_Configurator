Func SRPExecutableTypes($x)

$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
$valuename = "DefaultLevel"
$SRPDefaultLevel = RegRead ( $keyname, $valuename )

$RegDataFull = 'WSH' & @LF & 'WSF' & @LF & 'WSC' & @LF & 'WS' & @LF & 'VBS' & @LF & 'VBE' & @LF & 'VB' & @LF & 'URL' & @LF & 'SHS' & @LF & 'SCT' & @LF & 'SCR' & @LF & 'REG' & @LF & 'PS1' & @LF & 'PIF' & @LF & 'PCD' & @LF & 'OCX' & @LF & 'MST' & @LF & 'MSP' & @LF & 'MSC' & @LF & 'MDE' & @LF & 'MDB' & @LF & 'JSE' & @LF & 'JS' & @LF & 'JAR' & @LF & 'ISP'
$RegDataFull &= '' & @LF & 'INS' & @LF & 'INF' & @LF & 'HTA' & @LF & 'HLP' & @LF & 'CRT' & @LF & 'CPL' & @LF & 'CMD' & @LF & 'CHM' & @LF & 'BAS' & @LF & 'BAT' & @LF & 'ADP' & @LF & 'ADE' & @LF

$RegDataLight = 'WSF' & @LF & 'WSH' & @LF & 'WSC' & @LF & 'WS' & @LF & 'VB' & @LF & 'VBS' & @LF & 'URL' & @LF & 'SHS' & @LF & 'SCT' & @LF & 'SCR' & @LF & 'REG' & @LF & 'PS1' & @LF & 'PIF' & @LF & 'PCD' & @LF & 'OCX' & @LF & 'MST' & @LF & 'MSP' & @LF & 'MSC' & @LF & 'MDE' & @LF & 'MDB' & @LF & 'JS' & @LF & 'JAR' & @LF & 'ISP' & @LF & 'INS'
$RegDataLight &= '' & @LF & 'INF' & @LF & 'HTA' & @LF & 'HLP'& @LF & 'CRT' & @LF & 'CPL' & @LF & 'CHM' & @LF & 'BAS' & @LF & 'ADP' & @LF & 'ADE' & @LF

;Remove last empty record
$RegDataFull = StringLeft($RegDataFull, StringLen($RegDataFull)-1)
$RegDataLight = StringLeft($RegDataLight, StringLen($RegDataLight)-1)


If $x = "full" Then 
   $RegData = $RegDataFull
   Else
   $RegData = $RegDataLight
EndIf

IF ($SRPDefaultLevel = 0 or $SRPDefaultLevel = 131072 or $SRPDefaultLevel = 262144) Then
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'ExecutableTypes','REG_MULTI_SZ',  $RegData)
Else
EndIf

EndFunc