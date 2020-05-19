#include-once
#RequireAdmin
; #INDEX# =======================================================================================================================
; Title .........: SystemRestore
; Description ...: Functions to manage the system retore. This includes create, enum and delete restore points.
; Author(s) .....: Fred (FredAI)
; Dll(s) ........: SrClient.dll
; ============================================================================================================================

; #MODIFIED/IMPLEMENTED# =====================================================================================================================
; WMIDateStringToDate
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _SR_Enable
; Description ...: Enables the system restore.
; Syntax.........: _SR_Enable($DriveL = $SystemDrive)
; Parameters ....: $DriveL: The letter of the hard drive to monitor. Defaults to the system drive (Usually C:). See remarks.
; Return values .:         Success - 1.
;                                        Failure - 0
; Author ........: FredAI
; Modified.......:
; Remarks .......: Acording to MSDN, setting a blank string as the drive letter, will enable the system restore for all drives,
;                                        +but some tests revealed that, on Windows 7, only the system drive is enabled.
;                                        +This parameter must end with a backslash. e.g. C:\
; Related .......: _SR_Disable
; Link ..........:
; Example .......: $enabled = _SR_Enable()
; ===============================================================================================================================
Func _SR_Enable($DriveL = $SystemDrive)
   #RequireAdmin
   Global $obj_SR
   If Not IsObj($obj_SR) Then
      $obj_SR = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestore")
   EndIf
   If Not IsObj($obj_SR) Then Return 0
   If $obj_SR.Enable($DriveL) = 0 Then Return 1
   Return 0
EndFunc;==>_SR_Enable


Func _ResizeSR_MaxDiskStorage()
   #include <AutoItConstants.au3>
   Local $sMessage = "Disk space reserved for restore points was resized to 1GB."
   Local $resize = Run(@WindowsDir & '\system32\vssadmin.exe' & ' Resize' & ' ShadowStorage' & ' /For=C:' & ' /On=C:' & ' /Maxsize=1GB', "", @SW_HIDE)
   If not ($resize = "0") Then 
;      MsgBox(0,"",$sMessage, 2)
      Return 1
   Else
;      MsgBox(0,"", "Error", 4)
      Return 0
   EndIf
EndFunc

