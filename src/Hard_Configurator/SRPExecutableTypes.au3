Func SRPExecutableTypes($x)

$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
$valuename = "DefaultLevel"
Local $TempSRPDefaultLevel = RegRead ( $keyname, $valuename )

$RegDataFull = 'ACCDA' & @LF & 'ACCDE' & @LF & 'ACCDR' & @LF & 'ACCDT' & @LF & 'ACM' & @LF & 'AD' & @LF & 'ADE' & @LF & 'ADN' & @LF & 'ADP' & @LF & 'AIR' & @LF & 'APP' & @LF & 'APPLICATION' & @LF & 'APPREF-MS' & @LF & 'ARC' & @LF & 'ASA' & @LF & 'ASP' & @LF & 'ASPX' & @LF & 'ASX' & @LF & 'AX' & @LF & 'BAS' & @LF & 'BAT' & @LF & 'BZ' & @LF & 'BZ2' & @LF & 'CAB' & @LF 

$RegDataFull  &= '' & 'CDB' & @LF & 'CER' & @LF & 'CFG' & @LF & 'CHI' & @LF & 'CHM' & @LF & 'CLA' & @LF & 'CLASS' & @LF & 'CLB' & @LF & 'CMD' & @LF & 'CNT' & @LF & 'CNV' & @LF & 'COM' & @LF & 'COMMAND' & @LF & 'CPL' & @LF & 'CPX' & @LF & 'CRAZY' & @LF & 'CRT' & @LF & 'CRX' & @LF & 'CSH' & @LF & 'CSV' & @LF & 'DB' & @LF & 'DCR' & @LF & 'DER' & @LF & 'DESKLINK' & @LF 

$RegDataFull  &= '' & 'DESKTOP' & @LF & 'DIAGCAB' & @LF & 'DIF' & @LF & 'DIR' & @LF & 'DLL' & @LF & 'DMG' & @LF & 'DOCB' & @LF & 'DOCM' & @LF & 'DOT' & @LF & 'DOTM' & @LF & 'DOTX' & @LF & 'DQY' & @LF & 'DRV' & @LF & 'EXE' & @LF & 'FON' & @LF & 'FXP' & @LF & 'GADGET' & @LF & 'GLK' & @LF & 'GRP' & @LF & 'GZ' & @LF & 'HEX' & @LF & 'HLP' & @LF & 'HPJ' & @LF & 'HQX' & @LF 

$RegDataFull  &= '' & 'HTA' & @LF & 'HTC' & @LF & 'HTM' & @LF & 'HTT' & @LF & 'IE' & @LF & 'IME' & @LF & 'INF' & @LF & 'INI' & @LF & 'INS' & @LF & 'IQY' & @LF & 'ISP' & @LF & 'ITS' & @LF & 'JAR' & @LF & 'JNLP' & @LF & 'JOB' & @LF & 'JS' & @LF & 'JSE' & @LF & 'KSH' & @LF & 'LACCDB' & @LF & 'LDB' & @LF & 'LIBRARY-MS' & @LF & 'LNK' & @LF & 'LOCAL' & @LF & 'LZH' & @LF 

$RegDataFull  &= '' & 'MAD' & @LF & 'MAF' & @LF & 'MAG' & @LF & 'MAM' & @LF & 'MANIFEST' & @LF & 'MAPIMAIL' & @LF & 'MAQ' & @LF & 'MAR' & @LF & 'MAS' & @LF & 'MAT' & @LF & 'MAU' & @LF & 'MAV' & @LF & 'MAW' & @LF & 'MAY' & @LF & 'MCF' & @LF & 'MDA' & @LF & 'MDB' & @LF & 'MDE' & @LF & 'MDF' & @LF & 'MDN' & @LF & 'MDT' & @LF & 'MDW' & @LF & 'MDZ' & @LF & 'MHT' & @LF 

$RegDataFull  &= '' & 'MHTML' & @LF & 'MMC' & @LF & 'MOF' & @LF & 'MSC' & @LF & 'MSH' & @LF & 'MSH1' & @LF & 'MSH1XML' & @LF & 'MSH2' & @LF & 'MSH2XML' & @LF & 'MSHXML' & @LF & 'MSP' & @LF & 'MST' & @LF & 'MSU' & @LF & 'MUI' & @LF & 'MYDOCS' & @LF & 'NLS' & @LF & 'NSH' & @LF & 'OCX' & @LF & 'ODS' & @LF & 'OPS' & @LF & 'OQY' & @LF & 'OSD' & @LF & 'PCD' & @LF & 'PERL' & @LF 

$RegDataFull  &= '' & 'PI' & @LF & 'PIF' & @LF & 'PKG' & @LF & 'PL' & @LF & 'PLG' & @LF & 'POT' & @LF & 'POTM' & @LF & 'POTX' & @LF & 'PPAM' & @LF & 'PPS' & @LF & 'PPSM' & @LF & 'PPSX' & @LF & 'PPTM' & @LF & 'PRF' & @LF & 'PRG' & @LF & 'PRINTEREXPORT' & @LF & 'PRN' & @LF & 'PS1' & @LF & 'PS1XML' & @LF & 'PS2' & @LF & 'PS2XML' & @LF & 'PSC1' & @LF & 'PSC2' & @LF 

$RegDataFull  &= '' & 'PSD1' & @LF & 'PSDM1' & @LF & 'PST' & @LF & 'PSTREG' & @LF & 'PXD' & @LF & 'PY' & @LF & 'PY3' & @LF & 'PYC' & @LF & 'PYD' & @LF & 'PYDE' & @LF & 'PYI' & @LF & 'PYO' & @LF & 'PYP' & @LF & 'PYT' & @LF & 'PYW' & @LF & 'PYWZ' & @LF & 'PYX' & @LF & 'PYZ' & @LF & 'PYZW' & @LF & 'RB' & @LF & 'REG' & @LF & 'RPY' & @LF & 'RQY' & @LF & 'RTF' & @LF & 'SCR' & @LF 

$RegDataFull  &= '' & 'SCT' & @LF & 'SEA' & @LF & 'SEARCH-MS' & @LF & 'SEARCHCONNECTOR-MS' & @LF & 'SETTINGCONTENT-MS' & @LF & 'SHB' & @LF & 'SHS' & @LF & 'SIT' & @LF & 'SLDM' & @LF & 'SLDX' & @LF & 'SLK' & @LF & 'SPL' & @LF & 'STM' & @LF & 'SWF' & @LF & 'SYS' & @LF & 'TAR' & @LF & 'TAZ' & @LF & 'TERM' & @LF & 'TERMINAL' & @LF & 'TGZ' & @LF & 'THEME' & @LF & 'TLB' & @LF 

$RegDataFull  &= '' & 'TMP' & @LF & 'TOOL' & @LF & 'TSP' & @LF & 'URL' & @LF & 'VB' & @LF & 'VBE' & @LF & 'VBP' & @LF & 'VBS' & @LF & 'VSMACROS' & @LF & 'VSS' & @LF & 'VST' & @LF & 'VSW' & @LF & 'VXD' & @LF & 'WAS' & @LF & 'WBK' & @LF & 'WEBLOC' & @LF & 'WEBPNP' & @LF & 'WEBSITE' & @LF & 'WIZ' & @LF & 'WS' & @LF & 'WSC' & @LF & 'WSF' & @LF & 'WSH' & @LF 

$RegDataFull  &= '' & 'XBAP' & @LF & 'XLA' & @LF & 'XLAM' & @LF & 'XLB' & @LF & 'XLC' & @LF & 'XLD' & @LF & 'XLL' & @LF & 'XLM' & @LF & 'XLSB' & @LF & 'XLSM' & @LF & 'XLT' & @LF & 'XLTM' & @LF & 'XLTX' & @LF & 'XLW' & @LF & 'XML' & @LF & 'XNK' & @LF & 'XPI' & @LF & 'XPS' & @LF & 'Z' & @LF & 'ZFSENDTOTARGET' & @LF & 'ZLO' & @LF & 'ZOO' & @LF


$RegDataLight = 'WSC' & @LF & 'WS' & @LF & 'VB' & @LF & 'URL' & @LF & 'SHS' & @LF & 'SETTINGCONTENT-MS' & @LF & 'SCT' & @LF & 'SCR' & @LF & 'REG' & @LF & 'PIF' & @LF & 'PCD' & @LF & 'OCX' & @LF & 'MST' & @LF & 'MSP' & @LF & 'MSC' & @LF & 'MDE' & @LF & 'MDB' & @LF & 'LNK' & @LF & 'JAR' & @LF & 'IQY' & @LF & 'ISP' & @LF & 'INS'
$RegDataLight &= '' & @LF & 'INF' & @LF & 'HTA' & @LF & 'HLP' & @LF & 'EXE' & @LF & 'DLL' & @LF & 'CRT' & @LF & 'CPL' & @LF & 'COM' & @LF & 'CMD' & @LF & 'CHM' & @LF & 'BAT' & @LF & 'BAS' & @LF & 'ADP' & @LF & 'ADE' & @LF


;Remove last empty record
$RegDataFull = StringLeft($RegDataFull, StringLen($RegDataFull)-1)
$RegDataLight = StringLeft($RegDataLight, StringLen($RegDataLight)-1)

Switch $x
   case 'paranoid'
      $RegData = $RegDataFull
   case 'light'
      $RegData = $RegDataLight
   case Else
      $RegData = $RegDataFull
EndSwitch

IF ($TempSRPDefaultLevel = 0 or $TempSRPDefaultLevel = 131072 or $TempSRPDefaultLevel = 262144) Then
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers', 'ExecutableTypes','REG_MULTI_SZ',  $RegData)
Else
EndIf




EndFunc