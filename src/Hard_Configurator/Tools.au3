Func Tools()

  Global $Toolslistview
  Global $ToolslistGUI 
  Global $BtnSRPEnableLogging

  #include <Array.au3>
  #Include <File.au3>
  #include <FileConstants.au3>
  #include <GUIConstantsEx.au3>
  #include <GuiListView.au3>
  #include <StringConstants.au3>
  #include <MsgBoxConstants.au3>
;  #include 'Create_Restore_Point.au3'

;  GUISetState(@SW_HIDE,$listGUI)
;  GUISetState(@SW_DISABLE, $listGUI)
;  Opt("GUIOnEventMode", 1)
HideMainGUI()
  
  If not $X_ToolsGUI > 0 Then $X_ToolsGUI = -1
  If not $Y_ToolsGUI > 0 Then $X_ToolsGUI = -1
  $ToolslistGUI = GUICreate("TOOLS", 260, 550, $X_ToolsGUI, $Y_ToolsGUI, -1)
  GUISetBkColor(0xccccbb)

  GUISetOnEvent($GUI_EVENT_CLOSE, "CloseTools")
;  $Toolslistview = GUICtrlCreateListView("Tools MAINTENANCE" & @CRLF, 10, 10, 400, 450)
;  _GUICtrlListView_SetColumnWidth($Toolslistview, 0, 1300)
  
; While 1
; Local $_Array = Tools2Array()
; Local $element

; While UBound($_Array) > 0 
;    $element = _ArrayPop($_Array)
;    GUICtrlCreateListViewItem($element, $Toolslistview)
; WEnd
  local $dy = 5
  Global $BtnToolsHelp = GUICtrlCreateButton('Help', 90, 30-15, 80, 30)
  GUICtrlSetOnEvent(-1, "ToolsHelp")
  GUICtrlSetBkColor(-1, 0xbbbbbb)

  Global $BtnNirSoftFullEventLogView = GUICtrlCreateButton('Blocked Events / Security Logs', 30, 62+$dy, 180+20, 30)
  GUICtrlSetOnEvent(-1, "FullEventLogView")
  GUICtrlSetColor(-1, 0xffffff)
;  GUICtrlSetBkColor(-1, "0x00796b")
  GUICtrlSetBkColor(-1, "0x555555")

; Enabling/Disabling Advanced SRP Logging, and view log options
  Local $SRPL = RegRead('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers','LogFileName')
  If StringInStr($SRPL,'C:\WINDOWS\Hard_Configurator\SRP.log') < 1 Then
     $BtnSRPEnableLogging = GUICtrlCreateButton("Turn ON Advanced SRP Logging", 30, 213+$dy-(213-115), 180+20, 30)
     GUICtrlSetColor(-1, 0x000000)
;    GUICtrlSetBkColor(-1, "0x00796b")
     GUICtrlSetBkColor(-1, "0xa0a0ff")

  Else
     $BtnSRPEnableLogging = GUICtrlCreateButton("Turn OFF Advanced SRP Logging", 30, 213+$dy-(213-115), 180+20, 30)
   GUICtrlSetColor(-1, 0xffffff)
;   GUICtrlSetBkColor(-1, "0x00796b")
   GUICtrlSetBkColor(-1, "0x000000")

; 115+$dy dla Turn ON Advanced SRP Logging tj. odj¹æ (213-115)
; 213-30 dla Blocked Events / Security Logs tj. dodaæ 213-30-115

  EndIf
  GUICtrlSetOnEvent(-1, "SRPEnableLogging")
  Global $BtnSRPEnableLoggingUserSpace = GUICtrlCreateButton("Filtered", 45+5, 245+$dy-(213-115), 66, 20)
  GUICtrlSetOnEvent(-1, "SRPEnableLoggingUserSpace")
  Global $BtnSRPEnableLoggingAll = GUICtrlCreateButton("All", 113+5, 245+$dy-(213-115), 45, 20)
  GUICtrlSetOnEvent(-1, "SRPEnableLoggingAll")
  Global $BtnSRPEnableLoggingClear = GUICtrlCreateButton("Clear", 160+5, 245+$dy-(213-115), 45, 20)
  GUICtrlSetOnEvent(-1, "SRPEnableLoggingClear")

; Changed button name "Run  Autoruns: Scripts/UserSpace" --> "Whitelist Autoruns / View Scripts"
  Global $BtnUserSpaceAutoruns = GUICtrlCreateButton("Whitelist Autoruns / View Scripts", 30, $dy+213-20, 180+20, 30)
  GUICtrlSetOnEvent(-1, "Autoruns1")
  GUICtrlSetBkColor(-1, 0xa0a0ff)
;  GUICtrlSetFont ( $BtnUserSpaceAutoruns, -1, 700) 
  Global $BtnUserSpaceAutorunsNonValid = GUICtrlCreateButton("Skipped", 45+5, 147+$dy+213-20-115, 66, 20)
  GUICtrlSetOnEvent(-1, "UserSpaceAutorunsNonValid")
  Global $BtnUserSpaceAutorunsValid = GUICtrlCreateButton("Added", 113+5, 147+$dy+213-20-115, 45, 20)
  GUICtrlSetOnEvent(-1, "UserSpaceAutorunsValid")
  Global $BtnUserSpaceAutorunsClear = GUICtrlCreateButton("Clear", 160+5, 147+$dy+213-20-115, 45, 20)
  GUICtrlSetOnEvent(-1, "AutorunsClear")
  Global $BtnViewAllScriptAutoruns = GUICtrlCreateButton("View All Script Autoruns", 45+5, 169+$dy+213-20-115, 160, 20)
  GUICtrlSetOnEvent(-1, "ViewAllScriptAutoruns")

  Global $BtnRestoreWindowsDefaults = GUICtrlCreateButton("Restore Windows Defaults", 30, 288+$dy, 180+20, 30)
  GUICtrlSetOnEvent(-1, "RestoreWindowsDefaults")
  GUICtrlSetBkColor(-1, 0xff5050)
  GUICtrlSetFont ( $BtnRestoreWindowsDefaults, -1, 700) 

  Global $BtnUninstallHardConfigurator = GUICtrlCreateButton("Uninstall Hard_Configurator", 30, 338+$dy, 180+20, 30)
  GUICtrlSetOnEvent(-1, "UninstallHardConfigurator")
  GUICtrlSetBkColor(-1, 0xff5050)
  GUICtrlSetFont ( $BtnUninstallHardConfigurator, -1, 700)

  Global $BtnCreateSystemRestorePoint = GUICtrlCreateButton("Create System Restore Point", 30, 338+$dy+50, 180+20, 30)
  GUICtrlSetOnEvent(-1, "CreateSystemRestorePoint")
  GUICtrlSetBkColor(-1, 0xa0a0ff)

  Global $BtnManageProfilesBACKUP = GUICtrlCreateButton("Manage Profiles BACKUP", 30, 388+$dy+50, 180+20, 30)
  GUICtrlSetOnEvent(-1, "ManageProfilesBACKUP")
  GUICtrlSetBkColor(-1, 0x00dd44)

  Global $BtnEndTools = GUICtrlCreateButton("Close", 90, 400+$dy+45+50, 80, 30)
  GUICtrlSetOnEvent(-1, "CloseTools")
  GUICtrlSetBkColor(-1, 0xaaaaaa)

  Local $Reg = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers'
  IF RegRead($Reg, 'LogFileName') = $ProgramFolder & 'SRP.log' Then
     _GUICtrlButton_Enable($BtnSRPEnableLoggingUserSpace, True)
     _GUICtrlButton_Enable($BtnSRPEnableLoggingAll, True)
  Else
     _GUICtrlButton_Enable($BtnSRPEnableLoggingUserSpace, False)
     _GUICtrlButton_Enable($BtnSRPEnableLoggingAll, False)
  EndIf

  If $isSRPinstalled = "Not Installed" Then _GUICtrlButton_Enable($BtnSRPEnableLogging, False)

; Autoruns Button maintenance  
  Local $clear = 0
  If FileExists($ProgramFolder & 'ScriptAutorunsPaths.log') = 0 Then 
     _GUICtrlButton_Enable($BtnViewAllScriptAutoruns, False)
     $clear = $clear + 1
  EndIf
  If FileExists($ProgramFolder & 'AutorunsValidPaths.log') = 0 Then
     _GUICtrlButton_Enable($BtnUserSpaceAutorunsValid, False)
     $clear = $clear + 1
  EndIf
  If FileExists($ProgramFolder & 'AutorunsNonValidPaths.log') = 0 Then
     _GUICtrlButton_Enable($BtnUserSpaceAutorunsNonValid, False)
     $clear = $clear + 1
  EndIf
  If $clear = 3 Then _GUICtrlButton_Enable($BtnUserSpaceAutorunsClear, False)

; SRP Logging Button maintenance  
  If FileExists($ProgramFolder & 'SRP.log') = 0 Then
     _GUICtrlButton_Enable($BtnSRPEnableLoggingClear, False)
  EndIf

  GUISetState(@SW_SHOW,$ToolslistGUI)

; The First RUN Maintenance
  FirstRUNMaintenance()
  
; WEnd

EndFunc

; ///// Functions


Func CloseTools()
   GuiDelete($ToolslistGUI)
   ShowMainGUI()
   ShowRegistryTweaks()
EndFunc


Func FullEventLogView()
  If @OSARCH = "X64" Then
     ShellExecute($ProgramFolder & 'TOOLS\FullEventLogView(x64)\FullEventLogView.exe', "", $ProgramFolder & 'TOOLS\FullEventLogView(x64)')
  EndIf
  If @OSARCH = "X86" Then
     ShellExecute($ProgramFolder & 'TOOLS\FullEventLogView(x86)\FullEventLogView.exe', "", $ProgramFolder & 'TOOLS\FullEventLogView(x86)')
  EndIf

  Local $sMessage = "Please wait! It will take some time"
  SplashTextOn("Warning", $sMessage, 300, 50, -1, -1, 1, "", 10)
     Sleep(5000)
  SplashOff()
EndFunc


Func SRPEnableLogging()

  Local $Reg = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers'
  Local $SRPL = RegRead($Reg,'LogFileName')
  If StringInStr($SRPL,'C:\WINDOWS\Hard_Configurator\SRP.log') < 1 Then
      RegWrite($Reg, 'LogFileName','REG_SZ', $ProgramFolder & 'SRP.log')
  Else
      RegDelete($Reg, 'LogFileName')
  EndIf 
  ;Refresh Tools GUI WIndow
  RefreshToolsGUIWindow()

ENdFUnc



Func SRPEnableLoggingUserSpace()

;Filter User Space and Scripts
Local $sMessage = "Please wait! It will take some time."

  Local $SRPLogArray
  Local $ScriptLogArray[1] = [""]
;    Read the SRP.log into an array.
      _FileReadToArray($ProgramFolder & 'SRP.log', $SRPLogArray)
      If @error Then
          MsgBox(262144,"","The log is empty.")
          Return
      Else

SplashTextOn("Warning", $sMessage, 300, 50, -1, -1, 1, "", 10)
;        _ArrayDisplay($SRPLogArray)
      EndIf
;  Remove from the array, the entries located in the System Space
   For $n=1 To $SRPLogArray[0]
      If not (StringInStr ( $SRPLogArray[$n], '.PS1 ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n]) 
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.PS1XML ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.PS2 ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.PS2XML ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.PSC1 ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.PSC2 ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.VB ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.VBS ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.VBE ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.JS ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.JSE ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.WS ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.WSF ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.WSC ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], '.WSH ') = 0) Then
         _ArrayAdd ( $ScriptLogArray, $SRPLogArray[$n])
         $SRPLogArray[$n] = ""
      EndIf
      If not (StringInStr ( $SRPLogArray[$n], 'c:\Windows\') = 0) Then $SRPLogArray[$n] = ""
      If not (StringInStr ( $SRPLogArray[$n], 'c:\program files\') = 0) Then $SRPLogArray[$n] = ""
      If @OSARCH = "X64" Then
         If not (StringInStr ( $SRPLogArray[$n], 'c:\program files (x86)\') = 0) Then $SRPLogArray[$n] = ""
      EndIf
   Next
;  Delete duplicates
   $SRPLogArray = _ArrayUnique($SRPLogArray)
   $ScriptLogArray = _ArrayUnique($ScriptLogArray)
;  Correct the number of Array records written in 0-th record.
   $SRPLogArray[0] = UBound($SRPLogArray)-1
   $ScriptLogArray[0] = UBound($ScriptLogArray)-1
;  _ArrayDisplay($SRPLogArray)
;  _ArrayDisplay($ScriptLogArray)
   Local $NewItems = 0
      FileWriteLine($ProgramFolder & 'SRPUserSpace&Script.log', @CRLF & '**************' & @CRLF & 'PROGRAMS AND SCRIPTS RUN WITH ADMINISTRATIVE RIGHTS' & @CRLF)
      FileWriteLine($ProgramFolder & 'SRPUserSpace&Script.log', 'REPORT DATE (Y:M:D  H:M): ' & @YEAR & ':' & @MON & ':' & @MDAY & '  ' & @HOUR & ':' & @MIN & @CRLF)
   If $SRPLogArray[0] > 2 Then 
      FileWriteLine($ProgramFolder & 'SRPUserSpace&Script.log', @CRLF & '@@@@@@   USER SPACE PATHS:' & @CRLF)
      $NewItems = $NewItems + 1
      For $i=2 To $SRPLogArray[0]
         FileWriteLine($ProgramFolder & 'SRPUserSpace&Script.log', $SRPLogArray[$i])
      Next
   EndIf
   If $ScriptLogArray[0] > 1 Then 
      $NewItems = $NewItems + 1
      FileWriteLine($ProgramFolder & 'SRPUserSpace&Script.log', @CRLF & '@@@@@@   SCRIPTS:' & @CRLF)
      For $i=1 To $ScriptLogArray[0]
         FileWriteLine($ProgramFolder & 'SRPUserSpace&Script.log', $ScriptLogArray[$i])
      Next 
   EndIf   
SplashOff()            
   If $NewItems > 0 Then 
      ShellExecute('notepad.exe',$ProgramFolder & 'SRPUserSpace&Script.log')
;     Refresh Tools GUI WIndow
      RefreshToolsGUIWindow()
   Else
      MsgBox(262144,"","The log is empty.")
   EndIf

EndFunc



Func SRPEnableLoggingAll()
  ShellExecute('notepad.exe',$ProgramFolder & 'SRP.log')
; Refresh GUI WIndow
  RefreshToolsGUIWindow()
EndFunc

Func SRPEnableLoggingClear()
  FileDelete($ProgramFolder & 'SRPUserSpace&Script.log')
  FileDelete($ProgramFolder & 'SRP.log')
; Refresh GUI WIndow
  RefreshToolsGUIWindow()
EndFunc


Func UserSpaceAutorunsValid()
 If FileExists($ProgramFolder & 'AutorunsValidPaths.log') = 1 Then
    ShellExecute('notepad.exe',$ProgramFolder & 'AutorunsValidPaths.log')
 Else
    MsgBox(262144,"","The log is empty.")
 EndIf
EndFunc


Func UserSpaceAutorunsNonValid()
 If FileExists($ProgramFolder & 'AutorunsNonValidPaths.log') = 1 Then
    ShellExecute('notepad.exe',$ProgramFolder & 'AutorunsNonValidPaths.log')
 Else
    MsgBox(262144,"","The log is empty.")
 EndIf
EndFUnc


Func AutorunsClear()
  FileDelete($ProgramFolder & 'AutorunsValidPaths.log')
  FileDelete($ProgramFolder & 'AutorunsNonValidPaths.log')
  FileDelete($ProgramFolder & 'ScriptAutorunsPaths.log')
; Refresh GUI WIndow
  RefreshToolsGUIWindow()
EndFunc

Func ViewAllScriptAutoruns()
 If FileExists($ProgramFolder & 'ScriptAutorunsPaths.log') = 1 Then
    ShellExecute('notepad.exe',$ProgramFolder & 'ScriptAutorunsPaths.log')
 Else
    MsgBox(262144,"","The log is empty.")
 EndIf

EndFunc


Func RefreshToolsGUIWindow()
  Local $pos = WinGetPos ($ToolslistGUI)
  $X_ToolsGUI = $pos[0] 
  $Y_ToolsGUI = $pos[1]
  GUISetState(@SW_HIDE,$ToolslistGUI)
  GuiDelete($ToolslistGUI)
  Tools()
EndFunc

Func HelpInstall()
   Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\HelpInstall.txt")
  _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
  Local $YesNo = _ExtMsgBox(64,"&Yes|No", "", $help)
  Switch $YesNo
       case 1
          Return 1
       case else
          Return 0
   EndSwitch
EndFunc


Func FirstRUNMaintenance()
GUISetState(@SW_DISABLE, $ToolslistGUI) 
Local $key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers'
; Check Install flag in the registry
  Local $Reg = RegRead($key, 'Installed')
  If not ($Reg = '1') Then 
;    Set Install flag in the registry
     RegWrite($key, 'Installed', 'REG_SZ','1')
     Local $YesNo = _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
     Local $YesNo = _ExtMsgBox(64,"&Yes|No", "Hard_Configurator", "Do you want to make the System Restore Point?")
     Switch $YesNo
          case 1
             CreateSystemRestorePoint()
          case else
     EndSwitch
     If HelpInstall() = "1" Then  
          Autoruns1()
          Local $whitelist = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\262144\Paths'
          _RegCopyKey($whitelist, $key & '\Temp\262144\FirstRunWhitelist')
     EndIf
  EndIf 
GUISetState(@SW_ENABLE, $ToolslistGUI)
EndFunc


Func CheckMaxShadowStorage()

;Returns the Floor of the Maximum size (in GB) of Shadow Copy Storage (for Sytem Restore Points).
 Local $command = @WindowsDir & '\system32\vssadmin.exe' & ' List' & ' ShadowStorage' & ' /On=' & $systemdrive
 Local $iPID = Run($command , "", @SW_HIDE, $STDOUT_CHILD)
 ProcessWaitClose($iPID)
 Local $sOutput = StdoutRead($iPID, False, True)
 FileWrite($ProgramFolder & 'ShadowStorageInfo.log', $sOutput)
;Read the 'ShadowStorage.log' into the string
 Local $ShadowStorageInfo =  FileRead($ProgramFolder & 'ShadowStorageInfo.log')
 If @error Then
    MsgBox($MB_SYSTEMMODAL, "", "There was an error reading the file. @error: " & @error)
 Else
;    MsgBox(262144,"",$ShadowStorageInfo)
 EndIf
 FileDelete($ProgramFolder & 'ShadowStorageInfo.log')
 Local $n = StringInStr($ShadowStorageInfo, 'Maximum Shadow Copy Storage space: ')
 $ShadowStorageInfo = StringTrimLeft($ShadowStorageInfo, $n-1)
 $ShadowStorageInfo = StringReplace($ShadowStorageInfo, 'Maximum Shadow Copy Storage space: ', "")
 $n = StringInStr($ShadowStorageInfo, "(")
 If not ($n=0) Then
    $ShadowStorageInfo = StringTrimRight($ShadowStorageInfo, StringLen($ShadowStorageInfo) - $n+1)
 EndIf
 Local $measure = StringTrimRight($ShadowStorageInfo,3)
; MsgBox(262144,"", $ShadowStorageInfo & "    " & StringInStr($ShadowStorageInfo, 'GB'))
 Select
    case StringInStr($ShadowStorageInfo, 'GB') > 0
;       MsgBox(262144,"", $measure & "GB")
       Return Floor($measure)
    case StringInStr($ShadowStorageInfo , 'MB') > 0
;       MsgBox(262144,"", $measure/1024 & "GB")
       Return Floor($measure/1024)
    case StringInStr($ShadowStorageInfo , 'TB') > 0
;       MsgBox(262144,"", $measure*1024 & "GB")
       Return Floor($measure*1024)
    case Else
       Return 'error'
 EndSelect

EndFunc


Func CreateSystemRestorePoint()
Local $iPID
Local $aArray[2][2] = [[0,0],[0,0]]
Local $PreviousControlName
; Uses external _CreateRestorePoint(), _SR_Enable(), and  _ResizeSR_MaxDiskStorage() functions.
;   Check if System Restore is not enabled.
;   It must be RegRead() = 0 because it handles RPSessionInterval=0 and also missing RPSessionInterval value in the Registry
;   (fresh installed Windows 10)
    If RegRead('HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore', 'RPSessionInterval') = 0 Then
;       Enable System Restore
        If _SR_Enable($systemdrive & '\') = "1" Then
           MsgBox(262144,"","System Restore Enabled.", 1)
        Else
           MsgBox(262144,"","Error. Failed to enable System Restore." & @CRLF & "Please, make System Restore Point manually." & @CRLF & "Hard_Configurator will exit now." )
           RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers', 'Installed', 'REG_SZ','1')
           Exit
        EndIf
    EndIf
;   Create the System Restore Point
;   Check if the space reserved for restore points is not too small (minimum 1GB)
;   MsgBox(262144,"", CheckMaxShadowStorage() & 'GB')
    If CheckMaxShadowStorage() < 1 Then 
;   It contains the 'error' or less than 1 values returned by CheckMaxShadowStorage()
       If _ResizeSR_MaxDiskStorage() = "0" Then
          MsgBox(262144,"","Error. Failed to resize System Restore Storage to make System Restore Point." & @CRLF & "Please, make System Restore Point manually." & @CRLF & "Hard_Configurator will exit now." )
          Exit
       EndIf
    EndIf
    If not (@OSVersion="WIN_10" or @OSVersion="WIN_81" or @OSVersion="WIN_8" or @OSVersion="WIN_7" or @OSVersion="WIN_VISTA") Then
       MsgBox(262144, "", "Error. Unsupported Windows version. Only Windows Vista, 7, 8, 8.1, and 10 are supported.")
       Return
    EndIf
    $iPID = Run('C:\Windows\System32\SystemPropertiesProtection.exe')
    SplashTextOn("Restore Point", "Please Wait. Do not use the mouse and keybord for a while.", 300, 80, -1, -1, 0, "", 10) 
; Loop checking if the process is created after running 'SystemPropertiesProtection.exe'
      Local $nn = 1
      While 1
        If $nn > 100 Then
           MsgBox( 262144, "", "Error. Cannot run 'SystemPropertiesProtection.exe' to make System Restore Point.")
           SplashOff()
           Return
        EndIf
        Sleep (100)
        $nn = $nn+1
        If ProcessExists($iPID) = $iPID Then ExitLoop
      WEnd
      $nn = 1
; Loop checking if $aArray is created, because _WinAPI_EnumProcessWindows takes a while to find $aArray[1][0] 
      While 1
        $aArray = _WinAPI_EnumProcessWindows ($iPID) 
        If $nn > 6 Then
           MsgBox( 262144, "", "Error. Cannot run 'SystemPropertiesProtection.exe' to make System Restore Point.")
           SplashOff()
           Return
        EndIf
        Sleep ($nn*500)
        _ArrayMax($aArray)
        If @error Then 
           $nn = $nn+1
        Else
           ExitLoop
        EndIf
      WEnd   
      WinWaitActive($aArray[1][0],"")
      $PreviousControlName = FindPreviousControlName($aArray[1][0])
      ControlClick($aArray[1][0],"",$PreviousControlName)
      Sleep(2000)
      Send("Hard_Configurator{ENTER}")
    SplashOff()
EndFunc


Func FindPreviousControlName($hWnd)
    Local $avArr
    If UBound($avArr, 0) <> 2 Then
        Local $avTmp[10][2] = [[0]]
        $avArr = $avTmp
    EndIf
    Global $ActualControlName
    Global $PreviousControlName
    Local $hChild = _WinAPI_GetWindow($hWnd, $GW_CHILD)
    
    While $hChild
        If $avArr[0][0]+1 > UBound($avArr, 1)-1 Then ReDim $avArr[$avArr[0][0]+10][2]
        $avArr[$avArr[0][0]+1][0] = $hChild
        $avArr[$avArr[0][0]+1][1] = _WinAPI_GetWindowText($hChild)
        $ActualControlName = _WinAPI_GetWindowText($hChild)
;        MsgBox(262144,"",$ActualControlName)
        If $ActualControlName = "OK" Then 
           Return $PreviousControlName
;           MsgBox(262144,"",$PreviousControlName)
        EndIf
        $PreviousControlName = $ActualControlName
        $avArr[0][0] += 1
        FindPreviousControlName($hChild)
        $hChild = _WinAPI_GetWindow($hChild, $GW_HWNDNEXT)

    WEnd
    
    ReDim $avArr[$avArr[0][0]+1][2]
EndFunc


Func UninstallHardConfigurator()

_ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.5)
Local $YesNo = _ExtMsgBox(0,"&Yes|No", "", "Do you really want to uninstall Hard_Configurator?" & @crlf & @crlf & "WARNING" & @crlf & "All system-wide restrictions which could be applied via Hard_Configurator, ConfigureDefender and FirewallHardening will be set to Windows default values. The DocumentsAntiExploit tool will be copied to the PUBLIC Desktop - it can be used to apply or remove the hardening of MS Office and Adobe Acrobat Reader applications on each particular account.")
Switch $YesNo
  case 1
     FileDelete(@WindowsDir & "\DocumentsAntiExploit(x64).exe")
     FileDelete(@WindowsDir & "\DocumentsAntiExploit(x86).exe")
     If @OSArch = "X64" Then FileCopy(@WindowsDir & "\Hard_Configurator\DocumentsAntiExploit(x64).exe", @WindowsDir)
     If @OSArch = "X86" Then FileCopy(@WindowsDir & "\Hard_Configurator\DocumentsAntiExploit(x86).exe", @WindowsDir)
     RestoreWindowsDefaults1()
     FileDelete(@DesktopCommonDir & "\Hard_Configurator.lnk")
     FileDelete(@DesktopCommonDir & "\Switch Default Deny.lnk")

     If @OSArch = "X64" Then 
       FileCopy(@WindowsDir & "\Hard_Configurator\DocumentsAntiExploit(x64).exe", @DesktopCommonDir)
       If FileExists (@DesktopCommonDir & "\DocumentsAntiExploit(x64).exe" ) = 1 Then
          FileDelete (@WindowsDir & "\DocumentsAntiExploit(x64).exe")
       Else
         _ExtMsgBox(0,"OK", "Uninstall Hard_Configurator","Due to the protection of Public Desktop, the DocumentsAntiExploit tool could not be copied there, so it has been copied to the Windows folder.")
       EndIf
     EndIf
     If @OSArch = "X86" Then
       FileCopy(@WindowsDir & "\Hard_Configurator\DocumentsAntiExploit(x86).exe", @DesktopCommonDir)     
       If FileExists (@DesktopCommonDir & "\DocumentsAntiExploit(x86).exe" ) = 1 Then
          FileDelete (@WindowsDir & "\DocumentsAntiExploit(x86).exe")
       Else
          _ExtMsgBox(0,"OK", "Uninstall Hard_Configurator","Due to the protection of Public Desktop, the DocumentsAntiExploit tool could not be copied there, so it has been copied to the Windows folder.")
       EndIf
     EndIf

     Local $ShortcutExists = FileExists (@DesktopCommonDir & "\Hard_Configurator.lnk")
     $ShortcutExists = $ShortcutExists + FileExists (@DesktopCommonDir & "\Switch Default Deny.lnk")
     If $ShortcutExists > 0 Then
         _ExtMsgBox(0,"OK", "Uninstall Hard_Configurator","Due to the protection of Desktop, the uninstaller had a problem with removing one of the shortcuts: 'Hard_Configurator.lnk' or 'Switch Default Deny.lnk'. If the problem will persist, then the shortcut has to be removed manually.")
     EndIf

     MsgBox(262144,"","Please, remember to restart the computer after deinstallation.")
     If @OSVersion="WIN_10" Then DefaultDefender()
     While ProcessExists("ConfigureDefender_x64.exe")
        Run("ConfigureDefender_x64.exe",Call(ProcessClose("ConfigureDefender_x64.exe")))
     WEnd
     While ProcessExists("ConfigureDefender_x86.exe")
        Run("ConfigureDefender_x86.exe",Call(ProcessClose("ConfigureDefender_x86.exe")))
     WEnd
     While ProcessExists("SwitchDefaultDeny(x64).exe")
        Run("SwitchDefaultDeny(x64).exe",Call(ProcessClose("SwitchDefaultDeny(x64).exe")))
     WEnd
     While ProcessExists("SwitchDefaultDeny(x86).exe")
        Run("SwitchDefaultDeny(x86).exe",Call(ProcessClose("SwitchDefaultDeny(x86).exe")))
     WEnd
     While ProcessExists("DocumentsAntiExploit(x86).exe")
        Run("DocumentsAntiExploit(x86).exe",Call(ProcessClose("DocumentsAntiExploit(x86).exe")))
     WEnd
     While ProcessExists("DocumentsAntiExploit(x64).exe")
        Run("DocumentsAntiExploit(x64).exe",Call(ProcessClose("DocumentsAntiExploit(x64).exe")))
     WEnd
     While ProcessExists("FirewallHardening(x86).exe")
        Run("FirewallHardening(x86).exe",Call(ProcessClose("FirewallHardening(x86).exe")))
     WEnd
     While ProcessExists("FirewallHardening(x64).exe")
        Run("FirewallHardening(x64).exe",Call(ProcessClose("FirewallHardening(x64).exe")))
     WEnd
     Run($ProgramFolder & "unins000.exe")
     If not @error Then
     While ProcessExists("Hard_Configurator(x64).exe")
        Run("Hard_Configurator(x64).exe",Call(ProcessClose("Hard_Configurator(x64).exe")))
     WEnd
     While ProcessExists("Hard_Configurator(x86).exe")
        Run("Hard_Configurator(x86).exe",Call(ProcessClose("Hard_Configurator(x86).exe")))
     WEnd
       Exit
     Else
       MsgBox(0,"", "Error. Hard_Configurator restored Windows Defaults, but has not been uninstalled. Please, manually delete the folder: " & @CRLF & $ProgramFolder)
       Exit
     EndIf
  case 2
     Return
  EndSwitch 
EndFunc

Func DefaultDefender()
Local $PowerShellDir = 'c:\Windows\System32\WindowsPowerShell\v1.0\'
Local $MpenginePolicyKey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine'
Local $SmartScreenForExplorerKey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\System'
Local $SmartScreenForEdgeKey = 'HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter'
Local $SmartScreenForIEKey = 'HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter'

RunWait($PowerShellDir & "PowerShell -NonInteractive -WindowStyle hidden -command Set-MpPreference -EnableNetworkProtection Disabled; Set-MpPreference -EnableControlledFolderAccess Disabled; Set-MpPreference -DisableRealtimeMonitoring 0; Set-MpPreference -DisableBehaviorMonitoring 0; Set-MpPreference -DisableBlockAtFirstSeen 0; Set-MpPreference -MAPSReporting 2; Set-MpPreference -SubmitSamplesConsent 1; Set-MpPreference -DisableIOAVProtection 0; Set-MpPreference -DisableScriptScanning 0; Set-MpPreference -PUAProtection Disabled; Set-MpPreference -ScanAvgCPULoadFactor 50; $get = (Get-Mppreference).AttackSurfaceReductionRules_Ids; Remove-MpPreference -AttackSurfaceReductionRules_Ids $get; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:ProgramFiles; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions ${env:ProgramFiles(x86)}; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:ProgramW6432; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:SystemRoot; Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $env:ProgramData'\Microsoft\Windows Defender'; ", "", @SW_HIDE)
RegDelete($SmartScreenForExplorerKey, 'EnableSmartScreen')
RegDelete($SmartScreenForExplorerKey, 'ShellSmartScreenLevel')
RegDelete($SmartScreenForEdgeKey, 'EnabledV9')
RegDelete($SmartScreenForEdgeKey, 'PreventOverride')
RegDelete($SmartScreenForIEKey, 'EnabledV9')
RegDelete($SmartScreenForIEKey, 'PreventOverride')
RegDelete($MpenginePolicyKey)
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\NIS')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard')
; Unhiding Security Center
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','DisallowExploitProtectionOverride')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Firewall and network protection','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection','UILockdown')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security','UILockdown')
EndFunc




Func ToolsHelp()
    Local $help = FileRead(@WindowsDir & "\Hard_Configurator\HELP\Tools.txt")
;   MsgBox(262144,"", $help)
   _ExtMsgBoxSet(1+4+8+32, 0, -1, -1, 10, "Arial", @DesktopWidth*0.9)
   _ExtMsgBox(0,"CLOSE", "Tools Help", $help)
EndFunc
