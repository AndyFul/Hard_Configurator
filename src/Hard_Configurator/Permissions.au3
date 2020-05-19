;#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -v 3
#include-once
#include <SecurityConstants.au3>
#include <FileConstants.au3>
;#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -v 3
;Opt('MustDeclareVars',1)
; #UDF# =========================================================================================================================
; Title .........: Permisssions
; Description ...: Functions to set, modify and clear Acl permissions and ownership of any object.
; Author(s) .....: Fred (FredAI)
; Dll(s) ........: advapi32.dll, kernel32.dll
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_InitiatePermissionResources
;_ClosePermissionResources
;_CopyFullDacl
;_InheritParentPermissions
;_SetDefaultFileAccess
;_DenyAllAccess
;_GrantAllAccess
;_GrantReadAccess
;_GrantReadDenyWrite
;_SetObjectPermissions
;_EditObjectPermissions
;_MergeDaclToArray
;_GetDaclSizeInformation
;_GetAce
;_CreateDaclFromArray
;_SetObjectSecurity
;_IsValidAcl
;_SetObjectSecurityDescriptor
;_TreeResetPermissions
;_Permissions_OpenProcess
;_Permissions_KillProcess
;_Permissions_CloseHandle
;_SetFileObjectSecurity
;_SetRegObjectSecurity
;_ClearObjectDacl
;_GetObjectDacl
;_GetObjectOwner
;_SetObjectOwner
;_GetSecurityDescriptorOwner
;_GetSecurityDescriptorGroup
;_GetSecurityDescriptorDacl
;_GetSecurityDescriptorSacl
;_GetObjectSecurityDescriptor
;_GetObjectStringSecurityDescriptor
;_SetObjectStringSecurityDescriptor
;_ConvertSecurityDescriptorToStringSecurityDescriptor
;_ConvertStringSecurityDescriptorToSecurityDescriptor
;_GetSidStruct
;_Security_RegKeyName
; ===============================================================================================================================

; #MODIFIED/IMPLEMENTED# ========================================================================================================
;_LookupAccountName
;_StringSidToSid
;_GetLengthSid
;_SidToStringSid
;_IsValidSid
;_SetPrivilege
;Credits to PaulIA and engine for these functions
; ===============================================================================================================================

#Region ;**** Global constants and vars ****
;$SECURITY_INFORMATION bit flags
Global Const $OWNER_SECURITY_INFORMATION	 = 0x00000001
Global Const $GROUP_SECURITY_INFORMATION	 = 0x00000002
Global Const $DACL_SECURITY_INFORMATION		 = 0x00000004
Global Const $SACL_SECURITY_INFORMATION		 = 0x00000008
Global Const $LABEL_SECURITY_INFORMATION	 = 0x00000010
	;$SECURITY_INFORMATION bit flags

Global Enum _ ;$_SE_OBJECT_TYPE
	$SE_UNKNOWN_OBJECT_TYPE = 0, _ ;Unknown object type.
	$SE_FILE_OBJECT, _ ;Indicates a file or directory. Can be an absolute path, such as FileName.dat, C:\DirectoryName\FileName.dat, or a handle to an opened file
	$SE_SERVICE, _;Indicates a Windows service. A service object can be a local service, such as ServiceName, or a remote service, such as \\ComputerName\ServiceName, or a handle to a service
	$SE_PRINTER, _;Indicates a printer. A printer object can be a local printer, such as PrinterName, or a remote printer, such as \\ComputerName\PrinterName.
	$SE_REGISTRY_KEY, _;Indicates a registry key. The names can be in the format 'HKLM\SOFTWARE\Example', or 'HKEY_LOCAL_MACHINE\SOFTWARE\Example'. It can also be a handle to a registry key
	$SE_LMSHARE, _;Indicates a network share. A share object can be local, such as ShareName, or remote, such as \\ComputerName\ShareName.
	$SE_KERNEL_OBJECT, _;Indicates a local kernel object. All types of kernel objects are supported. ie, A process handle obtained with _Permissions_OpenProcess
	$SE_WINDOW_OBJECT, _;Indicates a window station or desktop object on the local computer.
	$SE_DS_OBJECT, _;Indicates a directory service object or a property set or property of a directory service object. e.g.CN=SomeObject,OU=ou2,OU=ou1,DC=DomainName,DC=CompanyName,DC=com,O=internet
	$SE_DS_OBJECT_ALL, _;Indicates a directory service object and all of its property sets and properties.
	$SE_PROVIDER_DEFINED_OBJECT, _;Indicates a provider-defined object.
	$SE_WMIGUID_OBJECT, _;Indicates a WMI object.
	$SE_REGISTRY_WOW64_32KEY;Indicates an object for a registry entry under WOW64.
	;$_SE_OBJECT_TYPE

;Acl constants
Global Const $ACL_REVISION		 = 2
Global Const $ACL_REVISION_DS	 = 4
Global Const $ACL_REVISION1		 = 1
Global Const $ACL_REVISION2		 = 2
Global Const $ACL_REVISION3		 = 3
Global Const $ACL_REVISION4		 = 4

;System security access for process handle Sacl
;Global Const $ACCESS_SYSTEM_SECURITY	 = 0x01000000

;AccessMask constants
Global Const $DELETE					 = 0x00010000
Global Const $_SYNCHRONIZE				 = 0x00100000
Global Const $MAXIMUM_ALLOWED			 = 0x20000000

Global Const $FILE_LIST_DIRECTORY		 = 0x00000001
Global Const $FILE_READ_DATA			 = 0x00000001
Global Const $FILE_ADD_FILE				 = 0x00000002
Global Const $FILE_WRITE_DATA			 = 0x00000002
Global Const $FILE_ADD_SUBDIRECTORY		 = 0x00000004
Global Const $FILE_APPEND_DATA			 = 0x00000004
Global Const $FILE_CREATE_PIPE_INSTANCE	 = 0x00000004
Global Const $FILE_READ_EA				 = 0x00000008
Global Const $FILE_READ_PROPERTIES		 = 0x00000008
Global Const $FILE_WRITE_EA				 = 0x00000010
Global Const $FILE_WRITE_PROPERTIES		 = 0x00000010
Global Const $FILE_EXECUTE				 = 0x00000020
Global Const $FILE_TRAVERSE				 = 0x00000020
Global Const $FILE_DELETE_CHILD			 = 0x00000040
Global Const $FILE_READ_ATTRIBUTES		 = 0x00000080
Global Const $FILE_WRITE_ATTRIBUTES		 = 0x00000100

; Defaults file accessmask for "Users" and "Authenticated Users"
Global Const $FILE_USERS_DEFAULT		 = BitOR($GENERIC_READ,$FILE_LIST_DIRECTORY,$FILE_READ_DATA,$GENERIC_EXECUTE)
Global Const $FILE_AUTH_USERS_DEFAULT	 = BitOR($GENERIC_READ,$GENERIC_EXECUTE,$GENERIC_WRITE,$DELETE)

; Other object type access masks
Global Const $ACTRL_FILE_READ            = 0x00000001
Global Const $ACTRL_FILE_WRITE           = 0x00000002
Global Const $ACTRL_FILE_APPEND          = 0x00000004
Global Const $ACTRL_FILE_READ_PROP       = 0x00000008
Global Const $ACTRL_FILE_WRITE_PROP      = 0x00000010
Global Const $ACTRL_FILE_EXECUTE         = 0x00000020
Global Const $ACTRL_FILE_READ_ATTRIB     = 0x00000080
Global Const $ACTRL_FILE_WRITE_ATTRIB    = 0x00000100
Global Const $ACTRL_FILE_CREATE_PIPE     = 0x00000200
Global Const $ACTRL_DIR_LIST             = 0x00000001
Global Const $ACTRL_DIR_CREATE_OBJECT    = 0x00000002
Global Const $ACTRL_DIR_CREATE_CHILD     = 0x00000004
Global Const $ACTRL_DIR_DELETE_CHILD     = 0x00000040
Global Const $ACTRL_DIR_TRAVERSE         = 0x00000020
Global Const $ACTRL_KERNEL_TERMINATE     = 0x00000001
Global Const $ACTRL_KERNEL_THREAD        = 0x00000002
Global Const $ACTRL_KERNEL_VM            = 0x00000004
Global Const $ACTRL_KERNEL_VM_READ       = 0x00000008
Global Const $ACTRL_KERNEL_VM_WRITE      = 0x00000010
Global Const $ACTRL_KERNEL_DUP_HANDLE    = 0x00000020
Global Const $ACTRL_KERNEL_PROCESS       = 0x00000040
Global Const $ACTRL_KERNEL_SET_INFO      = 0x00000080
Global Const $ACTRL_KERNEL_GET_INFO      = 0x00000100
Global Const $ACTRL_KERNEL_CONTROL       = 0x00000200
Global Const $ACTRL_KERNEL_ALERT         = 0x00000400
Global Const $ACTRL_KERNEL_GET_CONTEXT   = 0x00000800
Global Const $ACTRL_KERNEL_SET_CONTEXT   = 0x00001000
Global Const $ACTRL_KERNEL_TOKEN         = 0x00002000
Global Const $ACTRL_KERNEL_IMPERSONATE   = 0x00004000
Global Const $ACTRL_KERNEL_DIMPERSONATE  = 0x00008000
Global Const $ACTRL_PRINT_SADMIN         = 0x00000001
Global Const $ACTRL_PRINT_SLIST          = 0x00000002
Global Const $ACTRL_PRINT_PADMIN         = 0x00000004
Global Const $ACTRL_PRINT_PUSE           = 0x00000008
Global Const $ACTRL_PRINT_JADMIN         = 0x00000010
Global Const $ACTRL_SVC_GET_INFO         = 0x00000001
Global Const $ACTRL_SVC_SET_INFO         = 0x00000002
Global Const $ACTRL_SVC_STATUS           = 0x00000004
Global Const $ACTRL_SVC_LIST             = 0x00000008
Global Const $ACTRL_SVC_START            = 0x00000010
Global Const $ACTRL_SVC_STOP             = 0x00000020
Global Const $ACTRL_SVC_PAUSE            = 0x00000040
Global Const $ACTRL_SVC_INTERROGATE      = 0x00000080
Global Const $ACTRL_SVC_UCONTROL         = 0x00000100
Global Const $ACTRL_REG_QUERY            = 0x00000001
Global Const $ACTRL_REG_SET              = 0x00000002
Global Const $ACTRL_REG_CREATE_CHILD     = 0x00000004
Global Const $ACTRL_REG_LIST             = 0x00000008
Global Const $ACTRL_REG_NOTIFY           = 0x00000010
Global Const $ACTRL_REG_LINK             = 0x00000020
Global Const $ACTRL_WIN_CLIPBRD          = 0x00000001
Global Const $ACTRL_WIN_GLOBAL_ATOMS     = 0x00000002
Global Const $ACTRL_WIN_CREATE           = 0x00000004
Global Const $ACTRL_WIN_LIST_DESK        = 0x00000008
Global Const $ACTRL_WIN_LIST             = 0x00000010
Global Const $ACTRL_WIN_READ_ATTRIBS     = 0x00000020
Global Const $ACTRL_WIN_WRITE_ATTRIBS    = 0x00000040
Global Const $ACTRL_WIN_SCREEN           = 0x00000080
Global Const $ACTRL_WIN_EXIT             = 0x00000100
Global Const $REG_GENERIC_READ			 = BitOR($ACTRL_REG_QUERY,$ACTRL_REG_LIST,$ACTRL_REG_NOTIFY,$READ_CONTROL)

;Inheritance constants
Global Const $SUB_OBJECTS_ONLY_INHERIT			 = 0x1
Global Const $SUB_CONTAINERS_ONLY_INHERIT		 = 0x2
Global Const $SUB_CONTAINERS_AND_OBJECTS_INHERIT = 0x3
Global Const $INHERIT_NO_PROPAGATE				 = 0x4
Global Const $INHERIT_ONLY						 = 0x8
Global Const $INHERITED_ACCESS_ENTRY			 = 0x10
Global Const $INHERITED_PARENT					 = 0x10000000
Global Const $INHERITED_GRANDPARENT				 = 0x20000000

;Ace inheritance constants
Global Const $OBJECT_INHERIT_ACE 			= 1
Global Const $CONTAINER_INHERIT_ACE 		= 2
Global Const $NO_PROPAGATE_INHERIT_ACE 		= 4
Global Const $INHERIT_ONLY_ACE 				= 8
Global Const $INHERITED_ACE					= 0x10
Global Const $SUCCESSFUL_ACCESS_ACE_FLAG	= 0x40
Global Const $FAILED_ACCESS_ACE_FLAG		= 0x80

;File / folder recurse modes
Global Const $RECURSE_ALL			 = 1
Global Const $RECURSE_CONTAINERS	 = 2
Global Const $RECURSE_OBJECTS		 = 3

Global $h__Advapi32Dll 			= @SystemDir&'\Advapi32.dll'
Global $h__Kernel32Dll 			= @SystemDir&'\Kernel32.dll'

Global $a__Priv[4][2], $a__Prev[4][2]
Global $ResourcesState = 0
#EndRegion ;**** Global Constants and vars ****


; #FUNCTION# ====================================================================================================================
; Name...........: _InitiatePermissionResources
; Description ...: Opens the needed DLLs, and sets the necessary privileges
; Syntax.........: _InitiatePermissionResources()
; Parameters ....: None
; Return values .: None
; Author ........: FredAI
; Modified.......:
; Remarks .......: Call this function if planning on using the other functions repeatedly.
; Related .......: _ClosePermissionResources
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _InitiatePermissionResources()
	$h__Advapi32Dll = DllOpen(@SystemDir&'\Advapi32.dll')
	$h__Kernel32Dll = DllOpen(@SystemDir&'\Kernel32.dll')
	$a__Priv[0][0] = "SeRestorePrivilege"
	$a__Priv[0][1] = 2
	$a__Priv[1][0] = "SeTakeOwnershipPrivilege"
	$a__Priv[1][1] = 2
	$a__Priv[2][0] = "SeDebugPrivilege"
	$a__Priv[2][1] = 2
	$a__Priv[3][0] = "SeSecurityPrivilege"
	$a__Priv[3][1] = 2
	$a__Prev = _SetPrivilege($a__Priv)
	$ResourcesState = 1
EndFunc ;==>_InitiatePermissionResources

; #FUNCTION# ====================================================================================================================
; Name...........: _ClosePermissionResources
; Description ...: Closes the opened DLL handles, and restores the privileges
; Syntax.........: _ClosePermissionResources()
; Parameters ....: None
; Return values .: None
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _InitiatePermissionResources
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _ClosePermissionResources()
	_SetPrivilege($a__Prev)
	DllClose($h__Advapi32Dll)
	DllClose($h__Kernel32Dll)
	$h__Advapi32Dll = @SystemDir&'\Advapi32.dll'
	$h__Kernel32Dll = @SystemDir&'\Kernel32.dll'
	$ResourcesState = 0
EndFunc ;==>_ClosePermissionResources()

; #FUNCTION# ====================================================================================================================
; Name...........: _CopyFullDacl
; Description ...: Copies the DACL from an object to another one.
; Syntax.........: _CopyFullDacl($oName, $_SE_OBJECT_TYPE, $oName2, $_SE_OBJECT_TYPE2, $SetOwner, $ClearDacl)
; Parameters ....: $oName   - The name of the object to copy the DACL to. This can be a path to a file or folder, a registry key, a service name, etc
;						+See the comments on the _SE_OBJECT_TYPE enum for more info
;					$_SE_OBJECT_TYPE (optional) - The type of the object to copy the DACL to. This must be one of the values of the
;						+_SE_OBJECT_TYPE enum. The default is $SE_FILE_OBJECT (a file or folder).
;					$oName2 - The name of the object to copy the DACL from.
;					$_SE_OBJECT_TYPE2 - The type of the $oName2 object
;					$SetOwner (optional) - The user name or SID to set as the owner of the object. Setting a blank string '' will
;						+make no changes to the owner. The default is the administrators group ('Administrators')
;					$ClearDacl - Whether to clear the existing object's DACL before setting the new one.
; Return values .: Success      - True
;                  Failure      - False and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _SetObjectDacl, _ClearObjectDacl, _GetObjectDACL
; Link ..........:
; Example .......: _CopyFullDacl('C:\example.txt', $SE_FILE_OBJECT, @UserProfileDir)
; ===============================================================================================================================
Func _CopyFullDacl($oName, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT, $oName2 = @ScriptFullPath, $_SE_OBJECT_TYPE2 = $SE_FILE_OBJECT, $SetOwner = '')
	If $ResourcesState = 0 Then _InitiatePermissionResources()
	Local $newDacl = _GetObjectDACL($oName2, $_SE_OBJECT_TYPE2), $SECURITY_INFORMATION = 4, $pOwner = 0
	If $SetOwner <> '' Then
		If Not IsDllStruct($SetOwner) Then $SetOwner = _GetSidStruct($SetOwner)
		$pOwner = DllStructGetPtr($SetOwner)
		If $pOwner And _IsValidSid($pOwner) Then
			$SECURITY_INFORMATION = 5
		Else
			$pOwner = 0
		EndIf
	EndIf
	Return _SetObjectSecurity($oName, $_SE_OBJECT_TYPE, $SECURITY_INFORMATION,$pOwner,0, $newDacl,0)
EndFunc ;==>_CopyFullDacl

; #FUNCTION# ====================================================================================================================
; Name...........: _InheritParentPermissions
; Description ...: Propagates the inherited permissions through an object tree
; Syntax.........: _InheritParentPermissions($oName, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT, $ClearDacl = 0)
; Parameters ....: $oName   - The name of the object to copy the DACL to. This can be a path to a folder, or a registry key.
;					$_SE_OBJECT_TYPE (optional) - The type of the object to copy the DACL to. This must be either $SE_FILE_OBJECT
;					+ or $SE_REGISTRY_KEY
;					$ClearDacl - Whether to clear the existing object's DACL.
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _SetDefaultFileAccess, _CopyFullDacl
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _InheritParentPermissions($oName, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT, $ClearDacl = 0)
	Local $pSD = _GetObjectSecurityDescriptor($oName, $_SE_OBJECT_TYPE), $SecInfo = 0
	If $Psd = 0 Then Return SetError(1,0,0)
	Local $pOwner = _GetSecurityDescriptorOwner($pSD,1)
	If $pOwner Then $SecInfo += 1
	Local $Dacl =  _GetSecurityDescriptorDacl($pSD)
	If $Dacl Then $SecInfo += 4
	If $ClearDacl Then _ClearObjectDacl($oName, $_SE_OBJECT_TYPE)
	Return _TreeResetPermissions($oName, $_SE_OBJECT_TYPE, $SecInfo, $pOwner, 0, $Dacl,0,$ClearDacl)
EndFunc ;==> _InheritParentPermissions

; #FUNCTION# ====================================================================================================================
; Name...........: _SetDefaultFileAccess
; Description ...: Resets the default access permissions for a given path, sub containers and objects (If selected)
; Syntax.........: __SetDefaultFileAccess($Path, $Recurse = 1)
; Parameters ....: 	$Path - The path of the folder or file to set access.
;					$Recurse (Optional)
;
; Return values .: Success      - True
;                  Failure      - False and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _GrantAllAccess, _GrantReadAccess, _GrantReadDenyWrite, _CopyFullDacl
; Link ..........:
; Example .......: _DenyAllAccess('C:\example.txt', $_SE_OBJECT_TYPE, @UserName)
; ===============================================================================================================================
Func _SetDefaultFileAccess($Path, $Recurse = 0)
	Local $aFilePerm[4][4], $Owner
	If StringInStr($Path,@UserProfileDir) Then
		$Owner = @UserName
		$aFilePerm[0][0] = 'Administrators'
		$aFilePerm[0][1] = 1
		$aFilePerm[0][2] = $GENERIC_ALL
		$aFilePerm[0][3] = $SUB_CONTAINERS_AND_OBJECTS_INHERIT
		$aFilePerm[1][0] = 'System'
		$aFilePerm[1][1] = 1
		$aFilePerm[1][2] = $GENERIC_ALL
		$aFilePerm[1][3] = $SUB_CONTAINERS_AND_OBJECTS_INHERIT
		$aFilePerm[2][0] = @UserName
		$aFilePerm[2][1] = 1
		$aFilePerm[2][2] = $GENERIC_ALL
		$aFilePerm[2][3] = $SUB_CONTAINERS_AND_OBJECTS_INHERIT
	Else
		$Owner = 'Administrators'
		$aFilePerm[0][0] = 'Administrators'
		$aFilePerm[0][1] = 1
		$aFilePerm[0][2] = $GENERIC_ALL
		$aFilePerm[0][3] = $SUB_CONTAINERS_AND_OBJECTS_INHERIT
		$aFilePerm[1][0] = 'System'
		$aFilePerm[1][1] = 1
		$aFilePerm[1][2] = $GENERIC_ALL
		$aFilePerm[1][3] = $SUB_CONTAINERS_AND_OBJECTS_INHERIT
		$aFilePerm[2][0] = 'Users'
		$aFilePerm[2][1] = 1
		$aFilePerm[2][2] = $FILE_USERS_DEFAULT
		$aFilePerm[2][3] = $SUB_CONTAINERS_AND_OBJECTS_INHERIT
		$aFilePerm[3][0] = 'Authenticated Users'
		$aFilePerm[3][1] = 1
		$aFilePerm[3][2] = $FILE_AUTH_USERS_DEFAULT
		$aFilePerm[3][3] = $SUB_CONTAINERS_AND_OBJECTS_INHERIT
		If StringInStr($Path,@WindowsDir) Or StringInStr($Path,@ProgramFilesDir) _
		And Not StringInStr('WIN_2003|WIN_XP|WIN_XPe|WIN_2000',@OSVersion) Then
			ReDim $aFilePerm[5][4]
			$aFilePerm[4][0] = 'TrustedInstaller'
			$aFilePerm[4][1] = 1
			$aFilePerm[4][2] = $GENERIC_ALL
			$aFilePerm[4][3] = $SUB_CONTAINERS_AND_OBJECTS_INHERIT
		EndIf
	EndIf
	Return _EditObjectPermissions($Path, $aFilePerm, $SE_FILE_OBJECT, $Owner, 0, $Recurse)
EndFunc ;==> _SetDefaultFileAccess

; #FUNCTION# ====================================================================================================================
; Name...........: _DenyAllAccess
; Description ...: Denies everyone access for the given object
; Syntax.........: _DenyAllAccess($oName, $_SE_OBJECT_TYPE, $SetOwner)
; Parameters ....: $oName   - The name of the object. This can be a path to a file or folder, a registry key, a service name, etc
;						+See the comments on the _SE_OBJECT_TYPE enum for more info
;					$_SE_OBJECT_TYPE (optional) - The type of the object to set permissions. This must be one of the values of the
;						+_SE_OBJECT_TYPE enum. The default is $SE_FILE_OBJECT (a file or folder).
;					$SetOwner (optional) - The user name or SID to set as the owner of the object. Setting a blank string '' will
;						+make no changes to the owner. The default is the administrators group ('Administrators')
;
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _GrantAllAccess, _GrantReadAccess, _GrantReadDenyWrite, _CopyFullDacl
; Link ..........:
; Example .......: _DenyAllAccess('C:\example.txt', $_SE_OBJECT_TYPE, @UserName)
; ===============================================================================================================================
Func _DenyAllAccess($oName, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT, $SetOwner = 'Administrators', $Recurse = 1)
	Local $aPerm[1][3]
	$aPerm[0][0] = 'Everyone'
	$aPerm[0][1] = 0
	$aPerm[0][2] = $GENERIC_ALL
	Return _SetObjectPermissions($oName, $aPerm, $_SE_OBJECT_TYPE, $SetOwner, 0, $Recurse)
EndFunc ;==>_DenyAllAccess

; #FUNCTION# ====================================================================================================================
; Name...........: _GrantAllAccess
; Description ...: Grants everyone access for the given object
; Syntax.........: _GrantAllAccess($oName, $_SE_OBJECT_TYPE, $SetOwner)
; Parameters ....: $oName   - The name of the object. This can be a path to a file or folder, a registry key, a service name, etc
;						+See the comments on the _SE_OBJECT_TYPE enum for more info
;					$_SE_OBJECT_TYPE (optional) - The type of the object to set permissions. This must be one of the values of the
;						+_SE_OBJECT_TYPE enum. The default is $SE_FILE_OBJECT (a file or folder).
;					$SetOwner (optional) - The user name or SID to set as the owner of the object. Setting a blank string '' will
;						+make no changes to the owner. The default is the administrators group ('Administrators')
;
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _DenyAllAccess, _GrantReadAccess, _GrantReadDenyWrite, _CopyFullDacl
; Link ..........:
; Example .......: _GrantAllAccess('C:\example.txt', $_SE_OBJECT_TYPE, @UserName)
; ===============================================================================================================================
Func _GrantAllAccess($oName, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT, $SetOwner = 'Administrators', $Recurse = 1)
	Local $aPerm[1][3]
	$aPerm[0][0] = 'Everyone'
	$aPerm[0][1] = 1
	$aPerm[0][2] = $GENERIC_ALL
	Return _SetObjectPermissions($oName, $aPerm, $_SE_OBJECT_TYPE, $SetOwner, 1, $Recurse)
EndFunc ;==>_GrantAllAccess

; #FUNCTION# ====================================================================================================================
; Name...........: _GrantReadAccess
; Description ...: Grants everyone read access for the given object, and full access to the system and the administrators group
; Syntax.........: _GrantReadAccess($oName, $_SE_OBJECT_TYPE, $SetOwner)
; Parameters ....: $oName   - The name of the object. This can be a path to a file or folder, a registry key, a service name, etc
;						+See the comments on the _SE_OBJECT_TYPE enum for more info
;					$_SE_OBJECT_TYPE (optional) - The type of the object to set permissions. This must be one of the values of the
;						+_SE_OBJECT_TYPE enum. The default is $SE_FILE_OBJECT (a file or folder).
;					$SetOwner (optional) - The user name or SID to set as the owner of the object. Setting a blank string '' will
;						+make no changes to the owner. The default is the administrators group ('Administrators')
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _DenyAllAccess, _GrantAllAccess, _GrantReadDenyWrite, _CopyFullDacl
; Link ..........:
; Example .......: _GrantReadAccess('C:\example.txt', $SE_FILE_OBJECT, @UserName)
; ===============================================================================================================================
Func _GrantReadAccess($oName, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT, $SetOwner = 'Administrators', $Recurse = 1)
	Local $aPerm[3][3]
	$aPerm[0][0] = 'Everyone'
	$aPerm[0][1] = 1
	$aPerm[0][2] = $GENERIC_READ
	$aPerm[1][0] = 'Administrators'
	$aPerm[1][1] = 1
	$aPerm[1][2] = $GENERIC_ALL
	$aPerm[2][0] = 'System'
	$aPerm[2][1] = 1
	$aPerm[2][2] = $GENERIC_ALL
	Return _SetObjectPermissions($oName, $aPerm, $_SE_OBJECT_TYPE, $SetOwner, 1, $Recurse)
EndFunc ;==>_GrantReadAccess

; #FUNCTION# ====================================================================================================================
; Name...........: _GrantReadDenyWrite
; Description ...: Grants everyone read access, and denies everyone write access for the given registry key
; Syntax.........: _GrantReadDenyWrite($oName, $SetOwner)
; Parameters ....: $oName   - The name of the object. This must be a registry key. e.g. 'HKLM\SOFTWARE\Example'.
;					$SetOwner (optional) - The user name or SID to set as the owner of the object. Setting a blank string '' will
;						+make no changes to the owner. The default is the administrators group ('Administrators')
;
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......: This function only works for registry keys. Usefull to prevent them from being changed.
; Related .......: _DenyAllAccess, _GrantAllAccess, _CopyFullDacl
; Link ..........:
; Example .......: _GrantReadDenyWrite('HKCU\Software\Example', @UserName)
; ===============================================================================================================================
Func _GrantReadDenyWrite($oName, $SetOwner = 'Administrators', $Recurse = 1)
	Local $aPerm[2][3]
	$aPerm[0][0] = 'Everyone'
	$aPerm[0][1] = 0
	$aPerm[0][2] = BitOR($ACTRL_REG_SET,$ACTRL_REG_CREATE_CHILD,$WRITE_DAC,$WRITE_OWNER)
	$aPerm[1][0] = 'Everyone'
	$aPerm[1][1] = 1
	$aPerm[1][2] = $REG_GENERIC_READ
	Return _SetObjectPermissions($oName, $aPerm, $SE_REGISTRY_KEY, $SetOwner, 1, $Recurse)
EndFunc ;==>_GrantReadDenyWrite

; #FUNCTION# ====================================================================================================================
; Name...........: _SetObjectPermissions
; Description ...: Sets the access permissions for a given object.
; Syntax.........: _SetObjectPermissions($oName, $_SE_OBJECT_TYPE, $aPermissions, $SetOwner, $ClearDacl, $Recurse)
; Parameters ....: $oName - The handle or name of the object. This can be a path to a file or folder, a registry key, service name,
;						+a handle to a window or process, etc. See the comments on the _SE_OBJECT_TYPE enum for more info
;					$aPermissions - A bi-dimensional array containing info on the aces to add. The info must be on the folowing format:
;						$array[n][0] - The user name or Sid string to add. 'Everyone', 'Administrators', and 'System' are also allowed.
;						$array[n][1] - The access type to set. A value of 1 grants acecess, 0 denies access.
;						$array[n][2] - The access mask. This must be one or more of the access mask constants. Use BitOR to combine.
;						$array[n][3] - (optional) The inheritance flag for the ace. Can not have the $INHERITED_ACE or the $INHERIT_ONLY_ACE flags.
;					$_SE_OBJECT_TYPE - The type of the object to set permissions. This must be one of the values of the
;						+_SE_OBJECT_TYPE enum.
;					$SetOwner - The user name to set as the owner of the object. Leaving blank '' will make no changes to the owner.
;					$ClearDacl - Whether to clear the existing DACL. If this value is 0, the new aces will be merged to the existing
;						+inherited aces.
;					$Recurse - For folders or registry keys, setting this value to 1 will make the function set the same permissions to
;						+all the sub containers and objects.
;					$InHerit - The object's inheritance flag. Can be a combination of the inheritance contants.
;						+The default is 3 ($SUB_CONTAINERS_AND_OBJECTS_INHERIT)
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error: 1- Bad formated array of permissions; 2 - Unable to initialize the Dacl
; Author ........: FredAI
; Modified.......:
; Remarks .......: If using a folder or registry key handle rether than the name, the recursion will be ignored
; Related .......: _EditObjectPermissions, _GrantReadAccess, _GrantAllAccess, _DenyAllAccess, _GrantReadDenyWrite
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _SetObjectPermissions($oName, $aPermissions, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT, $SetOwner = '', $ClearDacl = 0, $Recurse = 0, $InHerit = 3)
	If $ResourcesState = 0 Then _InitiatePermissionResources()
	If Not IsArray($aPermissions) Or UBound($aPermissions,2) < 3 Then Return SetError(1,0,0)
	Local $DACL = _CreateDaclFromArray($aPermissions,$InHerit)
	Local $HasDeniedAces = @extended
	Local $SECURITY_INFORMATION = 4, $pOwner = 0
	If $SetOwner <> '' Then
		If Not IsDllStruct($SetOwner) Then $SetOwner = _GetSidStruct($SetOwner)
		$pOwner = DllStructGetPtr($SetOwner)
		If $pOwner And _IsValidSid($pOwner) Then
			$SECURITY_INFORMATION = 5
		Else
			$pOwner = 0
		EndIf
	EndIf
	If Not IsPtr($oName) And $_SE_OBJECT_TYPE = $SE_FILE_OBJECT Then
		Return _SetFileObjectSecurity($oName, $DACL, $pOwner, $ClearDacl, $Recurse, $HasDeniedAces, $SECURITY_INFORMATION)
	ElseIf Not IsPtr($oName) And $_SE_OBJECT_TYPE = $SE_REGISTRY_KEY Then
		Return _SetRegObjectSecurity($oName, $DACL, $pOwner, $ClearDacl, $Recurse, $HasDeniedAces, $SECURITY_INFORMATION)
	Else
		If $ClearDacl Then _ClearObjectDacl($oName,$_SE_OBJECT_TYPE)
		Return _SetObjectSecurity($oName, $_SE_OBJECT_TYPE, $SECURITY_INFORMATION, $pOwner, 0, $DACL,0)
	EndIf
EndFunc ;==>_SetObjectPermissions

; #FUNCTION# ====================================================================================================================
; Name...........: _EditObjectPermissions
; Description ...: Edits the access permissions for a given object.
; Syntax.........: _EditObjectPermissions($oName, $aPermissions, $_SE_OBJECT_TYPE, $SetOwner, $ClearDacl, $Recurse, $InHerit)
; Parameters ....: $oName        - The name of the object. This can be a path to a file or folder, a registry key, service name, etc
;						+See the comments on the _SE_OBJECT_TYPE enum for more info
;					$aPermissions - A bi-dimensional array containing info on the aces to add. The info must be on the folowing format:
;						$array[n][0] - Can be a user name, Sid string or Sid structure. See _GetSidStruct for more info.
;						$array[n][1] - The access type to set. A value of 1 grants acecess, 0 denies access.
;						$array[n][2] - The access mask. This must be one or more of the access mask constants. Use BitOR to combine.
;						$array[n][3] - (optional) The inheritance flag for the ace. Can not have the $INHERITED_ACE or the $INHERIT_ONLY_ACE flags.
;					$_SE_OBJECT_TYPE - The type of the object to set permissions. This must be one of the values of the
;						+_SE_OBJECT_TYPE enum.
;					$SetOwner - The user name to set as the owner of the object. Leaving blank '' will make no changes to the owner.
;					$ClearDacl - Whether to clear the inherited aces in the DACL. If this value is 0, the new aces will be merged to the existing
;						+inherited aces. If this value is 1, the inherited aces will be kept, but the $INHERITED_ACE flag will be removed.
;					$Recurse - For folders or registry keys, setting this value to 1 will make the function set the same permissions to
;						+all the sub containers and objects.
;					$InHerit - The object's inheritance flag. Can be any of the inheritance contants. The default is 3 ($SUB_CONTAINERS_AND_OBJECTS_INHERIT)
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......: Unlike _SetObjectPermissions, this function is able to edit the inherithed entries in the DACL, instead of adding new ones.
;					+ For instance if an object has a denied ace entry this function can edit it and make it a granted acces ace.
; Related .......: _SetObjectPermissions, _GrantReadAccess, _GrantAllAccess, _DenyAllAccess, _GrantReadDenyWrite
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _EditObjectPermissions($oName, $aPermissions, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT, $SetOwner = '', $ClearDacl = 0, $Recurse = 0, $InHerit = 3)
	If Not IsArray($aPermissions) Or UBound($aPermissions,2) < 3 Then Return SetError(1,0,0)
	If $ResourcesState = 0 Then _InitiatePermissionResources()
	Local $Dacl = _GetObjectDacl($oName, $_SE_OBJECT_TYPE)
	_MergeDaclToArray($Dacl, $aPermissions)
	Local $newDacl = _CreateDaclFromArray($aPermissions, $InHerit)
	Local $HasDeniedAces = @extended
	Local $SECURITY_INFORMATION = 4, $pOwner = 0
	If $SetOwner <> '' Then
		If Not IsDllStruct($SetOwner) Then $SetOwner = _GetSidStruct($SetOwner)
		$pOwner = DllStructGetPtr($SetOwner)
		If $pOwner And _IsValidSid($pOwner) Then
			$SECURITY_INFORMATION = 5
		Else
			$pOwner = 0
		EndIf
	EndIf
	If $ClearDacl Then _ClearObjectDacl($oName,$_SE_OBJECT_TYPE)
	If Not IsPtr($oName) And $_SE_OBJECT_TYPE = $SE_FILE_OBJECT Then
		Return _SetFileObjectSecurity($oName, $newDacl, $pOwner, $ClearDacl, $Recurse, $HasDeniedAces, $SECURITY_INFORMATION)
	ElseIf Not IsPtr($oName) And $_SE_OBJECT_TYPE = $SE_REGISTRY_KEY Then
		Return _SetRegObjectSecurity($oName, $newDacl, $pOwner, $ClearDacl, $Recurse, $HasDeniedAces, $SECURITY_INFORMATION)
	Else
		Return _SetObjectSecurity($oName, $_SE_OBJECT_TYPE, $SECURITY_INFORMATION,$pOwner,0, $newDacl,0)
	EndIf
EndFunc ;==> _EditObjectPermissions

; #FUNCTION# ====================================================================================================================
; Name...........: _MergeDaclToArray
; Description ...: Merges the aces in a Dacl to an array of permissions
; Syntax.........: _MergeDaclToArray(ByRef $Dacl, ByRef $aPerm)
; Parameters ....: $Dacl - The Dacl to merge. can be obtained with _GetObjectDacl or _GetSecurityDescriptorDacl
;					$aPerm - A bi-dimensional array containing info on the aces to add. The info must be on the folowing format:
;						$array[n][0] - Can be a user name, Sid string or Sid structure. See _GetSidStruct for more info.
;						$array[n][1] - The access type to set. A value of 1 grants acecess, 0 denies access.
;						$array[n][2] - The access mask. This must be one or more of the access mask constants. Use BitOR to combine.
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......: Unlike _SetObjectPermissions, this function is able to edit the inherithed entries in the DACL, instead of adding new ones.
;					+ For instance if an object has a denied ace entry this function can edit it and make it a granted acces ace.
; Related .......: _SetObjectPermissions, _GrantReadAccess, _GrantAllAccess, _DenyAllAccess, _GrantReadDenyWrite
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _MergeDaclToArray(ByRef $Dacl, ByRef $aPerm)
	If Not IsArray($aPerm) Or UBound($aPerm,2) < 3 Then Return SetError(1,0,0)
	Local $aDaclInfo = _GetDaclSizeInformation($Dacl)
	If @error Then Return 0
	Local $uB = UBound($aPerm), $uB2 = UBound($aPerm,2), $aAce, $pSID, $DupSid, $aCall, $ret = 0
	For $i = 0 To $uB -1
		If Not IsDllStruct($aPerm[$i][0]) Then $aPerm[$i][0] = _GetSidStruct($aPerm[$i][0])
	Next
	For $i = 0 To $aDaclInfo[0] -1
		$aAce = _GetAce($Dacl, $i)
		$pSID = DllStructGetPtr($aAce[0])
		If @error Then ContinueLoop
		$DupSid = 0
		For $l = 0 To $uB -1
			$aCall = DllCall($h__Advapi32Dll,'bool','EqualSid','ptr',DllStructGetPtr($aPerm[$l][0]),'ptr',$pSID)
			If Not @error And $aCall[0] Then
				$DupSid = 1
				ExitLoop
			EndIf
		Next
		If $DupSid Then ContinueLoop
		ReDim $aPerm[$uB + $ret +1][$uB2]
		$aPerm[$uB + $ret][0] = $aAce[0]
		$aPerm[$uB + $ret][1] = Number($aAce[1] <> 1)
		$aPerm[$uB + $ret][2] = $aAce[2]
		If $uB2 > 3 Then $aPerm[$uB + $ret][3] = $aAce[3]
		$ret += 1
	Next
	Return $ret
EndFunc ;==> _MergeDaclToArray

; #FUNCTION# ====================================================================================================================
; Name...........: _GetDaclSizeInformation
; Description ...: Returns a Dacl size information in an array
; Syntax.........: GetDaclSizeInformation(ByRef $Dacl)
; Parameters ....: $Dacl - A pointer to a Dacl.
; Return values .: Success      - An array containing the ace info:
;					$aRet[0] = The number of aces in the Dacl.
;					$aRet[1] = The number of bytes used by the dacl
;					$aRet[2] = The number of free bytes in the dacl
;                  Failure      - An empty array and sets @error: 1 - Invalid Dacl.
; Author ........: FredAI
; Modified.......:
; Remarks .......: The total size of the Dacl is obviously $aRet[1] + $aRet[2]
; Related .......: _GetAce, _MergeDaclToArray
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GetDaclSizeInformation(ByRef $Dacl)
	Local $aRet[3] = [0,0,0]
	If Not IsPtr($Dacl) Then Return SetError(1,0,$aRet)
	Local $_ACL_SIZE_INFORMATION = DllStructCreate('DWORD AceCount;DWORD AclBytesInUse;WORD AclBytesFree')

	Local $aCall = DllCall($h__Advapi32Dll,'bool','GetAclInformation','ptr',$Dacl, _
	'ptr',DllStructGetPtr($_ACL_SIZE_INFORMATION),'dword',DllStructGetSize($_ACL_SIZE_INFORMATION),'dword',2)
	If @error Or $aCall[0] = 0 Then Return SetError(2,0,$aRet)
	$aRet[0] = DllStructGetData($_ACL_SIZE_INFORMATION,'AceCount')
	$aRet[1] = DllStructGetData($_ACL_SIZE_INFORMATION,'AclBytesInUse')
	$aRet[2] = DllStructGetData($_ACL_SIZE_INFORMATION,'AclBytesFree')
	Return $aRet
EndFunc ;==> _GetDaclSizeInformation

; #FUNCTION# ====================================================================================================================
; Name...........: _GetAce
; Description ...: Returns the ACL's ace defined by the $index parameter
; Syntax.........: _GetAce(ByRef $Dacl, $index)
; Parameters ....: $Dacl - A pointer to a Dacl.
;					$index - The zero based ace index.
; Return values .: Success      - An array containing the ace info:
;					$aRet[0] = The ace's trustee SID structure.
;					$aRet[1] = A dword value defining the ace type Some possible values are ACCESS_DENIED_ACE_TYPE (1) and ACCESS_ALLOWED_ACE_TYPE (0)
;					$aRet[2] = The acces mask of the ace
;					$aRet[3] = The ace inheritance flags
;                  Failure      - An empty array and sets @error: 1 - Invalid Dacl. 2 - DllCall error.
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _GetDaclSizeInformation, _MergeDaclToArray
; Link ..........:
; Example .......: $aAce = _GetAce($Dacl, 0)
; ===============================================================================================================================
Func _GetAce(ByRef $Dacl, $index)
	Local $aRet[4]
	If Not IsPtr($Dacl) Then Return SetError(1,0,$aRet)
	Local $pAce = DllStructCreate('ptr')
	Local $aCall = DllCall($h__Advapi32Dll,'bool','GetAce','ptr',$Dacl,'dword',$index,'ptr',DllStructGetPtr($pAce,1))
	If @error Or Not $aCall[0] Then Return SetError(2,0,$aRet)
	Local $_ACE = DllStructCreate('BYTE AceType;BYTE AceFlags;WORD AceSize;DWORD ACCESS_MASK;byte SID[256]',DllStructGetData($pAce,1))
	Local $SID = DllStructCreate('byte SID[256]',DllStructGetPtr($_ACE,'SID'))
	$aRet[0] = $SID
	$aRet[1] = DllStructGetData($_ACE,'AceType')
	$aRet[2] = DllStructGetData($_ACE,'ACCESS_MASK')
	$aRet[3] = DllStructGetData($_ACE,'AceFlags')
	;If the ace is inherited, it won't work, so remove this flag
	If BitAND($aRet[3],16) Then
		$aRet[3] -= 16
	ElseIf BitAnd($aRet[3],8) Then
		$aRet[3] -= 8
	EndIf
	Return $aRet
EndFunc ;==> _GetAce

; #FUNCTION# ====================================================================================================================
; Name...........: _CreateDaclFromArray
; Description ...: Creates a Dacl from an array of permissions
; Syntax.........: _CreateDaclFromArray($aPermissions)
; Parameters ....: $aPermissions - A bi-dimensional array containing info on the aces to add. The info must be on the folowing format:
;						$array[n][0] - Can be a user name, Sid string or Sid structure. See _GetSidStruct for more info.
;						$array[n][1] - The access type to set. A value of 1 grants acecess, 0 denies access.
;						$array[n][2] - The access mask. This must be one or more of the access mask constants. Use BitOR to combine.
;					$InHerit - The object's inheritance flag. Can be any of the inheritance contants. The default is 3 ($SUB_CONTAINERS_AND_OBJECTS_INHERIT)
; Return values .: Success      - The new created Dacl
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _ClearObjectDacl, _GetObjectDACL
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CreateDaclFromArray(ByRef $aPermissions, ByRef $InHerit)
	Local $uB2 = UBound($aPermissions,2)
	If Not IsArray($aPermissions) Or $uB2 < 3 Then Return SetError(1,0,0)
	Local $uB = UBound($aPermissions), $pSID[$uB], $l = 0, $_TRUSTEE_TYPE = 1
	Local $AccessMode, $HasDeniedAces = 0,  $aCall
	Local $_EXPLICIT_ACCESS, $t_EXPLICIT_ACCESS = 'DWORD;DWORD;DWORD;ptr;DWORD;DWORD;DWORD;ptr'

	For $i = 1 To $uB - 1
		$t_EXPLICIT_ACCESS &= ';DWORD;DWORD;DWORD;ptr;DWORD;DWORD;DWORD;ptr'
	Next

	$_EXPLICIT_ACCESS = DllStructCreate($t_EXPLICIT_ACCESS)

	For $i = 0 To $uB -1
		If Not IsDllStruct($aPermissions[$i][0]) Then $aPermissions[$i][0] = _GetSidStruct($aPermissions[$i][0])
		$pSID[$i] = DllStructGetPtr($aPermissions[$i][0])
		If Not _IsValidSid($pSID[$i]) Then ContinueLoop
		DllStructSetData($_EXPLICIT_ACCESS,$l+1,$aPermissions[$i][2]);grfAccessPermissions
		If $aPermissions[$i][1] = 0 Then
			$HasDeniedAces = 1
			$AccessMode = $DENY_ACCESS
		Else
			$AccessMode = $SET_ACCESS
		EndIf
		If $uB2 > 3 Then $InHerit = $aPermissions[$i][3]
		DllStructSetData($_EXPLICIT_ACCESS,$l+2,$AccessMode);grfAccessMode
		DllStructSetData($_EXPLICIT_ACCESS,$l+3,$InHerit);grfInheritance
		DllStructSetData($_EXPLICIT_ACCESS,$l+6,0);TrusteeForm = $TRUSTEE_IS_SID = 0

		$aCall = DllCall($h__Advapi32Dll,'BOOL','LookupAccountSid','ptr',0,'ptr',$pSID[$i],'ptr*',0,'dword*',32,'ptr*',0,'dword*',32,'dword*',0)
		If Not @error Then $_TRUSTEE_TYPE = $aCall[7]
		DllStructSetData($_EXPLICIT_ACCESS,$l+7,$_TRUSTEE_TYPE);TrusteeType
		DllStructSetData($_EXPLICIT_ACCESS,$l+8,$pSID[$i]);Pointer to the SID
		$l += 8
	Next

	Local $p_EXPLICIT_ACCESS = DllStructGetPtr($_EXPLICIT_ACCESS)
	$aCall = DllCall($h__Advapi32Dll,'DWORD','SetEntriesInAcl','ULONG',$uB,'ptr',$p_EXPLICIT_ACCESS ,'ptr',0,'ptr*',0)
	If @error Or $aCall[0] Then Return SetError(1,0,0)
	Return SetExtended($HasDeniedAces, $aCall[4])
EndFunc ;==> _CreateDaclFromArray

; #FUNCTION# ====================================================================================================================
; Name...........: _SetObjectSecurity
; Description ...: Sets the security info of an object
; Syntax.........: _SetObjectSecurity($oName, $_SE_OBJECT_TYPE, $SECURITY_INFORMATION, $pOwner = 0, $pGroup = 0, $Dacl = 0,$Sacl = 0)
; Parameters ....:  $oName   - The name or handle to the object. This can be a path to a file or folder, a registry key,
;					+ a service name, a process handle, etc. See the comments on the _SE_OBJECT_TYPE enum for more info.
;					$_SE_OBJECT_TYPE - The type of the object to set permissions. This must be one of the values of the
;					+_SE_OBJECT_TYPE enum. The default is $SE_FILE_OBJECT (a file or folder).
;					$SECURITY_INFORMATION - A combination of the Security information constants. This combination must match the
;					+info to set. ie, to set the owner and the Dacl it must be BitOR($OWNER_SECURITY_INFORMATION,$DACL_SECURITY_INFORMATION)
;					$pOwner (Optional) - A pointer to a SID that identifies the owner of the object.
;					$pGroup (Optional) - A pointer to a SID that identifies the primary group of the object.
;					$Dacl (Optional) - A pointer to the new DACL for the object.
;					$Sacl (Optional) - A pointer to the new SACL for the object.
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _SetObjectSecurityDescriptor
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _SetObjectSecurity($oName, $_SE_OBJECT_TYPE, $SECURITY_INFORMATION, $pOwner = 0, $pGroup = 0, $Dacl = 0, $Sacl = 0)
	Local $aCall
	If $ResourcesState = 0 Then _InitiatePermissionResources()
	If $Dacl And Not _IsValidAcl($Dacl) Then Return 0
	If $Sacl And Not _IsValidAcl($Sacl) Then Return 0
	If IsPtr($oName) Then ; If it's a handle object
		$aCall = DllCall($h__Advapi32Dll,'dword','SetSecurityInfo','handle',$oName,'dword',$_SE_OBJECT_TYPE, _
		'dword',$SECURITY_INFORMATION,'ptr',$pOwner,'ptr',$pGroup,'ptr',$Dacl,'ptr',$Sacl)
	Else ;If it's a named object
		If $_SE_OBJECT_TYPE = $SE_REGISTRY_KEY Then $oName = _Security_RegKeyName($oName)
		$aCall = DllCall($h__Advapi32Dll,'dword','SetNamedSecurityInfo','str',$oName,'dword',$_SE_OBJECT_TYPE, _
		'dword',$SECURITY_INFORMATION,'ptr',$pOwner,'ptr',$pGroup,'ptr',$Dacl,'ptr',$Sacl)
	EndIf
	If @error Then Return SetError(1,0,0)
	If $aCall[0] And $pOwner Then ; If failed, set owner and try again
		If _SetObjectOwner($oName, $_SE_OBJECT_TYPE,_SidToStringSid($pOwner)) Then _
		Return _SetObjectSecurity($oName, $_SE_OBJECT_TYPE, $SECURITY_INFORMATION - 1, 0, $pGroup, $Dacl, $Sacl)
	EndIf
	Return SetError($aCall[0] , 0, Number($aCall[0] = 0))
EndFunc ;==> _SetObjectSecurity

; #FUNCTION# ====================================================================================================================
; Name...........: _IsValidAcl
; Description ...: Validates an Acl.
; Syntax.........: _IsValidAcl($Acl)
; Parameters ....: $Acl - A poiter to an Acl (Dacl or Sacl)
; Return values .: If the Acl is valid, The return value is non zero. If the Acl is not valid, the function returns 0
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _GetObjectDacl
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _IsValidAcl($Acl)
	If $Acl = 0 Then Return SetError(1,0,0)
	Local $aCall = DllCall($h__Advapi32Dll,'bool','IsValidAcl','ptr',$Acl)
	If @error Or Not $aCall[0] Then Return 0
	Return 1
EndFunc ;==> _IsValidAcl

; #FUNCTION# ====================================================================================================================
; Name...........: _SetObjectSecurityDescriptor
; Description ...: Sets the security descriptor of an object
; Syntax.........: _SetObjectSecurityDescriptor($oName, $pSecDescriptor, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT)
; Parameters ....:  $oName   - The name or handle to the object. This can be a path to a file or folder, a registry key,
;					+ a service name, a process handle, etc. See the comments on the _SE_OBJECT_TYPE enum for more info.
;					$pSecDescriptor - A pointer to a security descriptor. Can be obtained with _GetObjectSecurityDescriptor
;					$_SE_OBJECT_TYPE - The type of the object to set permissions. This must be one of the values of the
;					+_SE_OBJECT_TYPE enum. The default is $SE_FILE_OBJECT (a file or folder).
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _SetObjectSecurity, _GetObjectSecurityDescriptor
; Link ..........:
; Example .......: _SetRegObjectSecurity('HKCU\Software\Example', _GetObjectDACL('HKLM\SOFTWARE), @UserName, 1, 1)
; ===============================================================================================================================
Func _SetObjectSecurityDescriptor($oName, ByRef $pSecDescriptor, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT)
	If $ResourcesState = 0 Then _InitiatePermissionResources()
	Local $SECURITY_INFORMATION = BitOR($OWNER_SECURITY_INFORMATION,$GROUP_SECURITY_INFORMATION,$DACL_SECURITY_INFORMATION,$SACL_SECURITY_INFORMATION), $aCall
	If $_SE_OBJECT_TYPE = $SE_KERNEL_OBJECT Then
		$aCall = DllCall($h__Advapi32Dll,'BOOL','SetKernelObjectSecurity','handle',$oName,'dword',$SECURITY_INFORMATION,'ptr',$pSecDescriptor)
		If @error Or $aCall[0] = 0 Then Return SetError(1,0,0)
		Return 1
	Else
		Local $pOwner = _GetSecurityDescriptorOwner($pSecDescriptor,1)
		Local $pGroup = _GetSecurityDescriptorGroup($pSecDescriptor,1)
		Local $Dacl = _GetSecurityDescriptorDacl($pSecDescriptor)
		Local $Sacl = _GetSecurityDescriptorSacl($pSecDescriptor)
		Return _SetObjectSecurity($oName,$_SE_OBJECT_TYPE,$SECURITY_INFORMATION,$pOwner,$pGroup,$Dacl,$Sacl)
	EndIf
EndFunc ;==> _SetObjectSecurityDescriptor

; #FUNCTION# ====================================================================================================================
; Name...........: _TreeResetPermissions
; Description ...: Sets the security info of an object tree
; Syntax.........: _TreeResetPermissions($oName, $_SE_OBJECT_TYPE, $SECURITY_INFORMATION, $pOwner = 0, $pGroup = 0, $Dacl = 0,$Sacl = 0, $ClearDacl = 0))
; Parameters ....:  $oName   - The name or handle to the object. This can be a path to a file or folder, a registry key,
;					+ a service name, a process handle, etc. See the comments on the _SE_OBJECT_TYPE enum for more info.
;					$_SE_OBJECT_TYPE - The type of the object tree to set permissions. This must be either $SE_FILE_OBJECT or $SE_REGISTRY_KEY
;					$SECURITY_INFORMATION - A combination of the Security information constants. This combination must match the
;					+info to set. ie, to set the owner and the Dacl it must be BitOR($OWNER_SECURITY_INFORMATION,$DACL_SECURITY_INFORMATION)
;					$pOwner (Optional) - A pointer to a SID that identifies the owner of the object. Set to 0 if not changing the owner.
;					$pGroup (Optional) - A pointer to a SID that identifies the primary group of the object. Set to 0 if not changing the group.
;					$Dacl (Optional) - A pointer to the new DACL for the object. Set to 0 if not changing the DACL.
;					$Sacl (Optional) - A pointer to the new SACL for the object. Set to 0 if not changing the SACL.
;					$$ClearDacl (Optional) - Whether to clear existing explicit entries in the tree of objects.
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _SetObjectSecurityDescriptor, _SetObjectSecurity
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _TreeResetPermissions($oName, $_SE_OBJECT_TYPE, $SECURITY_INFORMATION, $pOwner = 0, $pGroup = 0, $Dacl = 0, $Sacl = 0, $ClearDacl = 0)
	If $ResourcesState = 0 Then _InitiatePermissionResources()
	If $Dacl And Not _IsValidAcl($Dacl) Then Return 0
	If $Sacl And Not _IsValidAcl($Sacl) Then Return 0
	If $_SE_OBJECT_TYPE = $SE_REGISTRY_KEY Then $oName = _Security_RegKeyName($oName)
	Local $aCall = DllCall($h__Advapi32Dll,'dword','TreeResetNamedSecurityInfoW','wstr',$oName,'dword',$_SE_OBJECT_TYPE, _
		'dword',$SECURITY_INFORMATION,'ptr',$pOwner,'ptr',$pGroup,'ptr',$Dacl,'ptr',$Sacl,'bool',$ClearDacl = 0,'ptr',0,'dword',1,'ptr',0)
	If @error Then Return SetError(1,0,0)
	Return SetError($aCall[0] , 0, Number($aCall[0] = 0))
EndFunc ;==> _TreeResetPermissions

; #FUNCTION# ====================================================================================================================
; Name...........: _Permissions_OpenProcess
; Description ...: Opens a process and returns a handle
; Syntax.........: _Permissions_OpenProcess($Process, $dAccess = -1)
; Parameters ....:  $Process - A process name or Pid. If more than one process with the specified name exists,
;					+the Pid of the first one will be used
;					$dAccess - The desired access. the default is $READ_CONTROL, $WRITE_DAC, $WRITE_OWNER (combined)
; Return values .: Success      - A handle to the open process
;                  Failure      - 0 and sets @error: 1 - the process doesn't exist; 2 - the process could not be opened
; Author ........: FredAI
; Modified.......:
; Remarks .......: If more than one process with the  specified name exists, the first one will be used.
;					After finish using the handle, it must be closed with _Permissions_CloseHandle
; Related .......: _Permissions_CloseHandle
; Link ..........:
; Example .......: _ClearObjectDacl('C:\Example.txt')
; ===============================================================================================================================
Func _Permissions_OpenProcess($Process, $dAccess = -1)
	If $ResourcesState = 0 Then _InitiatePermissionResources()
	If $dAccess = -1 Then $dAccess = BitOR($READ_CONTROL, $WRITE_DAC, $WRITE_OWNER, $ACCESS_SYSTEM_SECURITY)
	$Process = ProcessExists($Process)
	If $Process = 0 Then Return SetError(1,0,0)
	Local $aCall = DllCall($h__Kernel32Dll,'handle','OpenProcess','dword',$dAccess,'bool',False,'dword',$Process)
	If @error Or $aCall[0] = 0 Then Return SetError(2,0,0)
	Return $aCall[0]
EndFunc ;==> _Permissions_OpenProcess

; #FUNCTION# ====================================================================================================================
; Name...........: _Permissions_KillProcess
; Description ...: Grants full access to a process, and then terminates it
; Syntax.........: _Permissions_KillProcess($Process)
; Parameters ....:  $Process - A process name or Pid. If more than one process with the specified name exists,
;					+the Pid of the first one will be used
; Return values .: Success      - 1
;                  Failure      - 0
; Author ........: FredAI
; Modified.......:
; Remarks .......: The function tries to kill the process up to 10 times within 300 miliseconds
; Related .......: _Permissions_OpenProcess, _Permissions_CloseHandle
; Link ..........:
; Example .......: _Permissions_KillProcess('Notepad.exe')
; ===============================================================================================================================
Func _Permissions_KillProcess($Process)
	Local $hProcess = _Permissions_OpenProcess($Process,BitOR(1,$READ_CONTROL, $WRITE_DAC, $WRITE_OWNER, $ACCESS_SYSTEM_SECURITY))
	If $hProcess = 0 Then Return SetError(1,0,0)
	Local $ret = 0
	_GrantAllAccess($hProcess,$SE_KERNEL_OBJECT)
	For $i = 1 To 10
		DllCall($h__Kernel32Dll,'bool','TerminateProcess','handle',$hProcess,'uint',0)
		If @error Then $ret = 0
		Sleep(30)
		If Not ProcessExists($Process) Then
			$ret = 1
			ExitLoop
		EndIf
	Next
	_Permissions_CloseHandle($hProcess)
	Return $ret
EndFunc ;==> _Permissions_KillProcess

; #FUNCTION# ====================================================================================================================
; Name...........: _Permissions_CloseHandle
; Description ...: Frees the specified handle. This can be the handle returned by _Permissions_OpenProcess
; Syntax.........: _Permissions_CloseHandle($handle)
; Parameters ....:  $handle - The process or thread handle to close
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _Permissions_OpenProcess
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Permissions_CloseHandle($handle)
	Local $aCall = DllCall($h__Kernel32Dll,'bool','CloseHandle','handle',$handle)
	If @error Then Return SetError(@error,0,0)
	Return $aCall[0]
EndFunc ;==> _Permissions_CloseHandle

; #FUNCTION# ====================================================================================================================
; Name...........: _SetFileObjectSecurity
; Description ...: Sets the access to a file or folder. If $Recurse = 1 the function will set the same DACL to all the sub
;						+containers and objects and set the inheritance
; Syntax.........: _SetFileObjectSecurity($oName, $DACL, $pOwner, $ClearDacl, $Recurse, $HasDeniedAces, $SECURITY_INFORMATION)
; Parameters ....:  $oName   - The name of the object. This must be a path to a file or folder. e.g. 'C:\Example.txt'
;					$DACL - A pointer to a DACL. Can be obtained with _GetObjectDACL or created with _SetObjectPermissions.
;					$pOwner - A pointer to a Sid to set as the object's owner. Set to 0 to make no changes to the owner.
;					$ClearDacl - Whether to clear the existing inherited DACL. 1=Clear, 0=Don't clear
;					$Recurse -  Whether to recurse sub containers and objects  0=Don't recurse, 1=Recurse all.
;								2 = Recurse sub folders, 3 = Recurse files
;					$HasDeniedAces - A flag informing if the Dacl has denied aces.
;					$SECURITY_INFORMATION - A set of bit flags that indicate the type of security information to set.
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......: This function only works for files and folders. It's mostly for internal use.
; Related .......: _SetRegObjectSecurity, _ClearObjectDacl, _SetObjectDacl
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _SetFileObjectSecurity($oName, ByRef $DACL, ByRef $pOwner, ByRef $ClearDacl, ByRef $Recurse, ByRef $HasDeniedAces, ByRef $SECURITY_INFORMATION)
	Local $Ret, $Name
	If Not $HasDeniedAces Then
		If $ClearDacl Then _ClearObjectDacl($oName,$SE_FILE_OBJECT)
		$Ret = _SetObjectSecurity($oName, $SE_FILE_OBJECT, $SECURITY_INFORMATION, $pOwner, 0, $DACL,0)
	EndIf
	If $Recurse Then
		Local $H = FileFindFirstFile($oName&'\*')
		While 1
			$Name = FileFindNextFile($H)
			If $Recurse = 1 Or $Recurse = 2 And @extended = 1  Then
				_SetFileObjectSecurity($oName&'\'&$Name, $DACL, $pOwner, $ClearDacl, $Recurse, $HasDeniedAces,$SECURITY_INFORMATION)
			ElseIf @error Then
				ExitLoop
			ElseIf $Recurse = 1 Or $Recurse = 3 Then
				If $ClearDacl Then _ClearObjectDacl($oName&'\'&$Name,$SE_FILE_OBJECT)
				_SetObjectSecurity($oName&'\'&$Name, $SE_FILE_OBJECT, $SECURITY_INFORMATION, $pOwner, 0, $DACL,0)
			EndIf
		WEnd
		FileClose($H)
	EndIf
	If $HasDeniedAces Then
		If $ClearDacl Then _ClearObjectDacl($oName,$SE_FILE_OBJECT)
		$Ret = _SetObjectSecurity($oName, $SE_FILE_OBJECT, $SECURITY_INFORMATION, $pOwner, 0, $DACL,0)
	EndIf
	Return $Ret
EndFunc ;==>_SetFileObjectSecurity

; #FUNCTION# ====================================================================================================================
; Name...........: _SetRegObjectSecurity
; Description ...: Sets the access to a registry key. If $Recurse is set to 1 the function will write the same DACL to all the sub
;						+containers and objects and set the inheritance
; Syntax.........: WriteDaclToRegObject($oName, $DACL, $SetOwner, $ClearDacl, $Recurse, $HasDeniedAces, $SECURITY_INFORMATION)
; Parameters ....:  $oName   - The name of the object. This must be a registry key. e.g. 'HKLM\SOFTWARE\Example'.
;					$DACL - A pointer to a DACL. Can be obtained with _GetObjectDACL or created with _SetObjectPermissions.
;					$pOwner - A pointer to a Sid to set as the object's owner. Set to 0 to make no changes to the owner.
;					$ClearDacl - Whether to clear the existing inherited DACL. 1=Clear, 0=Don't clear.
;					$Recurse -  Whether to recurse sub keys  0=Don't recurse, 1=Recurse all.
;								2 = Recurse sub folders, 3 = Recurse files
;					$HasDeniedAces - A flag informing if the Dacl has denied aces.
;					$SECURITY_INFORMATION - A set of bit flags that indicate the type of security information to set.
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......: This function only works for registry keys
; Related .......: _SetFileObjectSecurity, _ClearObjectDacl, _SetObjectDacl
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _SetRegObjectSecurity($oName, ByRef $DACL, ByRef $pOwner, ByRef $ClearDacl, ByRef $Recurse, ByRef $HasDeniedAces, ByRef $SECURITY_INFORMATION)
	If $ResourcesState = 0 Then _InitiatePermissionResources()
	Local $Ret, $i = 0, $Name
	If Not $HasDeniedAces Then
		If $ClearDacl Then _ClearObjectDacl($oName,$SE_REGISTRY_KEY)
		$Ret = _SetObjectSecurity($oName, $SE_REGISTRY_KEY, $SECURITY_INFORMATION, $pOwner, 0, $DACL,0)
	EndIf
	If $Recurse Then
		While 1
			$i += 1
			$Name = RegEnumKey($oName,$i)
			If @error Then ExitLoop
			_SetRegObjectSecurity($oName&'\'&$Name, $DACL, $pOwner, $ClearDacl, $Recurse, $HasDeniedAces, $SECURITY_INFORMATION)
		WEnd
	EndIf
	If $HasDeniedAces Then
		If $ClearDacl Then _ClearObjectDacl($oName,$SE_REGISTRY_KEY)
		$Ret = _SetObjectSecurity($oName, $SE_REGISTRY_KEY, $SECURITY_INFORMATION, $pOwner, 0, $DACL,0)
	EndIf
	Return $Ret
EndFunc ;==>_SetRegObjectSecurity

; #FUNCTION# ====================================================================================================================
; Name...........: _ClearObjectDacl
; Description ...: Clears the DACL to an object.
; Syntax.........: _ClearObjectDacl($oName, $_SE_OBJECT_TYPE)
; Parameters ....:  $oName   - The name or handle to the object. This can be a path to a file or folder, a registry key,
;						+ a service name, a process handle, etc. See the comments on the _SE_OBJECT_TYPE enum for more info.
;					$_SE_OBJECT_TYPE - The type of the object to set permissions. This must be one of the values of the
;						+_SE_OBJECT_TYPE enum. The default is $SE_FILE_OBJECT (a file or folder).
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _GetObjectDACL, _SetFileObjectSecurity, _SetRegObjectSecurity, _SetObjectDacl
; Link ..........:
; Example .......: _ClearObjectDacl('C:\Example.txt')
; ===============================================================================================================================
Func _ClearObjectDacl($oName, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT)
	If $ResourcesState = 0 Then _InitiatePermissionResources()
	Local $Buffer = DllStructCreate('byte[32]'), $aRet
	Local $DACL = DllStructGetPtr($Buffer,1)
	DllCall($h__Advapi32Dll,'bool','InitializeAcl','Ptr',$DACL,'dword',DllStructGetSize($Buffer),'dword',$ACL_REVISION)
	If IsPtr($oName) Then
		$aRet = DllCall($h__Advapi32Dll,"dword","SetSecurityInfo",'handle',$oName,'dword',$_SE_OBJECT_TYPE,'dword',4,'ptr',0,'ptr',0,'ptr',$DACL,'ptr',0)
	Else
		If $_SE_OBJECT_TYPE = $SE_REGISTRY_KEY Then $oName = _Security_RegKeyName($oName)
		DllCall($h__Advapi32Dll,'DWORD','SetNamedSecurityInfo','str',$oName,'dword',$_SE_OBJECT_TYPE,'DWORD',4,'ptr',0,'ptr',0,'ptr',0,'ptr',0)
		$aRet = DllCall($h__Advapi32Dll,'DWORD','SetNamedSecurityInfo','str',$oName,'dword',$_SE_OBJECT_TYPE,'DWORD',4,'ptr',0,'ptr',0,'ptr',$DACL,'ptr',0)
	EndIf
	If @error Then Return SetError(@error,0,0)
	Return SetError($aRet[0],0,Number($aRet[0] = 0))
EndFunc ;==>_ClearObjectDacl

; #FUNCTION# ====================================================================================================================
; Name...........: _GetObjectDACL
; Description ...: Returns a pointer to the the DACL structure of an object.
; Syntax.........: _GetObjectDACL($oName, $_SE_OBJECT_TYPE)
; Parameters ....:  $oName   - The name or handle to the object. This can be a path to a file or folder, a registry key,
;					+ a service name, a process handle, etc. See the comments on the _SE_OBJECT_TYPE enum for more info.
;					$_SE_OBJECT_TYPE - The type of the object to set permissions. This must be one of the values of the
;						+_SE_OBJECT_TYPE enum. The default is $SE_FILE_OBJECT (a file or folder).
; Return values .: Success      - A pointer to the the DACL
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _ClearObjectDacl, _SetFileObjectSecurity, _SetRegObjectSecurity, _SetObjectDacl
; Link ..........:
; Example .......: _GetObjectDACL('C:\Example.txt')
; ===============================================================================================================================
Func _GetObjectDacl($oName, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT)
	If $ResourcesState = 0 Then _InitiatePermissionResources()
	Local $pSD = _GetObjectSecurityDescriptor($oName, $_SE_OBJECT_TYPE)
	If Not $pSD Then Return SetError(1,0,0)
	Return _GetSecurityDescriptorDacl($pSD)
EndFunc ;==>_GetObjectDACL

; #FUNCTION# ====================================================================================================================
; Name...........: _GetObjectOwner
; Description ...: Returns a pointer to the the DACL structure of an object.
; Syntax.........: Owner($oName, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT, $Format = 0)
; Parameters ....:  $oName   - The name or handle to the object. This can be a path to a file or folder, a registry key,
;					+ a service name, a process handle, etc. See the comments on the _SE_OBJECT_TYPE enum for more info.
;					$_SE_OBJECT_TYPE - The type of the object to set permissions. This must be one of the values of the
;						+_SE_OBJECT_TYPE enum. The default is $SE_FILE_OBJECT (a file or folder).
;					$Format - The format to return: 0 (default) - A sid string;  1 - A pointer to a Sid
; Return values .: Success      - A pointer to the the DACL
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _ClearObjectDacl, _SetFileObjectSecurity, _SetRegObjectSecurity, _SetObjectDacl
; Link ..........:
; Example .......: _GetObjectDACL('C:\Example.txt')
; ===============================================================================================================================
Func _GetObjectOwner($oName, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT, $Format = 0)
	If $ResourcesState = 0 Then _InitiatePermissionResources()
	Local $pSD = _GetObjectSecurityDescriptor($oName, $_SE_OBJECT_TYPE)
	If Not $pSD Then Return SetError(1,0,0)
	Return  _GetSecurityDescriptorOwner($pSD, $Format)
EndFunc ;==>_GetObjectDACL

; #FUNCTION# ====================================================================================================================
; Name...........: _SetObjectOwner
; Description ...: Sets the owner of an object.
; Syntax.........:  _SetObjectOwner($oName, $_SE_OBJECT_TYPE, $AccountName)
; Parameters ....:  $oName   - The name or handle to the object. This can be a path to a file or folder, a registry key,
;					+ a service name, a process handle, etc. See the comments on the _SE_OBJECT_TYPE enum for more info.
;					$_SE_OBJECT_TYPE (Optional) - The type of the object to set permissions. This must be one of the values of the
;					+_SE_OBJECT_TYPE enum. The default is $SE_FILE_OBJECT (a file or folder).
;					$AccountName (Optional) - The account name or SID string to set. the default is the administrators group.
;						+Can be any user name or SID string, see GetSidStruct() for more info.
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _GetSidStruct
; Link ..........:
; Example .......: _SetObjectOwner('C:\Example.txt')
; ===============================================================================================================================
Func _SetObjectOwner($oName, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT, $AccountName = 'Administrators')
	If $ResourcesState = 0 Then _InitiatePermissionResources()
	Local $SID = _GetSidStruct($AccountName), $aRet
	Local $pSID = DllStructGetPtr($SID)
	If IsPtr($oName) Then
		$aRet = DllCall($h__Advapi32Dll,"dword","SetSecurityInfo",'handle',$oName,'dword',$_SE_OBJECT_TYPE,'dword',1,'ptr',$pSID,'ptr',0,'ptr',0,'ptr',0)
	Else
		If $_SE_OBJECT_TYPE = $SE_REGISTRY_KEY Then $oName = _Security_RegKeyName($oName)
		$aRet = DllCall($h__Advapi32Dll,'DWORD','SetNamedSecurityInfo','str',$oName,'dword',$_SE_OBJECT_TYPE,'DWORD',1,'ptr',$pSID,'ptr',0,'ptr',0,'ptr',0)
	EndIf
	If @error Then Return SetError(@error,0,False)
	Return SetError($aRet[0],0,Number($aRet[0] = 0))
EndFunc ;==>_SetObjectOwner

; #FUNCTION# ====================================================================================================================
; Name...........:  _GetSecurityDescriptorOwner
; Description ...: Returns the owner of a security descriptor.
; Syntax.........: _GetSecurityDescriptorOwner($pSecDescriptor)
;					$pSecDescriptor - A pointer to a security descriptor structure. Can be obtained with _GetObjectSecurityDescriptor
;					+or _ConvertStringSecurityDescriptorToSecurityDescriptor.
;					$Format - The format to return: 0 - A sid string;  1 - A pointer to a Sid
; Return values .: Success      - The security descriptor's owner SID string.
;                  Failure      - '' and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _GetSecurityDescriptorDacl, _GetObjectSecurityDescriptor
; Link ..........:
; Example .......: _GetSecurityDescriptorOwner(_GetObjectSecurityDescriptor(@DesktoDir&'\example.txt'))
; ===============================================================================================================================
Func _GetSecurityDescriptorOwner(ByRef $pSecDescriptor,$Format = 0)
	 If Not IsPtr($pSecDescriptor) Then Return SetError(1,0,0)
	 Local $aRet = DllCall($h__Advapi32Dll,'bool','GetSecurityDescriptorOwner', _
	'ptr',$pSecDescriptor,'ptr*',0,'bool*',0)
	 If @error Then Return SetError(@error,0,'')
	 If $format = 1 Then Return $aRet[2]
	 Return _SidToStringSid($aRet[2])
EndFunc ;==>_GetSecurityDescriptorOwner

; #FUNCTION# ====================================================================================================================
; Name...........:  _GetSecurityDescriptorGroup
; Description ...: Returns the group of a security descriptor.
; Syntax.........: _GetSecurityDescriptorGroup($pSecDescriptor, $Format = 0)
;					$pSecDescriptor - A pointer to a security descriptor structure. Can be obtained with _GetObjectSecurityDescriptor
;					+or _ConvertStringSecurityDescriptorToSecurityDescriptor.
;					$Format - The format to return: 0 - A sid string;  1 - A pointer to a Sid
; Return values .: Success      - The security descriptor in the desired format
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _GetSecurityDescriptorOwner, _GetObjectSecurityDescriptor
; Link ..........:
; Example .......: _GetObjectStringSecurityDescriptor(@DesktoDir&'\example.txt')
; ===============================================================================================================================
Func _GetSecurityDescriptorGroup(ByRef $pSecDescriptor,$Format = 0)
	If Not IsPtr($pSecDescriptor) Then Return SetError(1,0,0)
	Local $aCall = DllCall($h__Advapi32Dll,'BOOL','GetSecurityDescriptorGroup', _
	'ptr',$pSecDescriptor,'ptr*',0,'bool*',0)
	 If @error Then Return SetError(@error,0,0)
	 If $format = 1 Then Return $aCall[2]
	 Return _SidToStringSid($aCall[2])
EndFunc ;==> _GetSecurityDescriptorGroup

; #FUNCTION# ====================================================================================================================
; Name...........:  _GetSecurityDescriptorDacl
; Description ...: Returns the DACL of a security descriptor.
; Syntax.........: _GetSecurityDescriptorDacl($pSecDescriptor)
;					$pSecDescriptor - A pointer to a security descriptor structure. Can be obtained with _GetObjectSecurityDescriptor
;					+or _ConvertStringSecurityDescriptorToSecurityDescriptor.
; Return values .: Success      - A pointer to the DACL of the security descriptor
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _GetSecurityDescriptorOwner, _GetObjectSecurityDescriptor
; Link ..........:
; Example .......: _GetObjectStringSecurityDescriptor(@DesktoDir&'\example.txt')
; ===============================================================================================================================
 Func _GetSecurityDescriptorDacl(ByRef $pSecDescriptor)
	 If Not IsPtr($pSecDescriptor) Then Return SetError(1,0,0)
	 Local $aRet = DllCall($h__Advapi32Dll,'bool','GetSecurityDescriptorDacl', _
	'ptr',$pSecDescriptor,'bool*',0,'ptr*',0,'bool*',0)
	 If @error Then Return SetError(@error,0,0)
	 If Not $aRet[2] Then Return SetError(1,0,0)
	 Return $aRet[3]
EndFunc ;==>_GetSecurityDescriptorDacl

; #FUNCTION# ====================================================================================================================
; Name...........:  _GetSecurityDescriptorSacl
; Description ...: Returns the SACL of a security descriptor.
; Syntax.........: _GetSecurityDescriptorDacl($pSecDescriptor)
;					$pSecDescriptor - A pointer to a security descriptor structure. Can be obtained with _GetObjectSecurityDescriptor
;					+or _ConvertStringSecurityDescriptorToSecurityDescriptor.
; Return values .: Success      - A pointer to the SACL of the security descriptor
;                  Failure      - 0 and sets @error: 1 - Not valid security descriptor
;									2 - DllCall error
;									3 - Sacl not present
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _GetSecurityDescriptorOwner, _GetObjectSecurityDescriptor
; Link ..........:
; Example .......: _GetObjectStringSecurityDescriptor(@DesktoDir&'\example.txt')
; ===============================================================================================================================
Func _GetSecurityDescriptorSacl(ByRef $pSecDescriptor)
	 If Not IsPtr($pSecDescriptor) Then Return SetError(1,0,0)
	 Local $aRet = DllCall($h__Advapi32Dll,'bool','GetSecurityDescriptorSacl', _
	'ptr',$pSecDescriptor,'bool*',0,'ptr*',0,'bool*',0)
	 If @error Then Return SetError(2,0,0)
	 If Not $aRet[2] Then Return SetError(3,0,0)
	 Return $aRet[3]
EndFunc ;==>_GetSecurityDescriptorSacl

; #FUNCTION# ====================================================================================================================
; Name...........: _GetObjectSecurityDescriptor
; Description ...: Returns a pointer to the security descriptor of the given object.
; Syntax.........:  _GetObjectSecurityDescriptor($oName, $_SE_OBJECT_TYPE)
;					$oName   - The name or handle to the object. This can be a path to a file or folder, a registry key,
;						+ a service name, a process handle, etc. See the comments on the _SE_OBJECT_TYPE enum for more info.
;					$_SE_OBJECT_TYPE (Optional) - The type of the object to set permissions. This must be one of the values of the
;						+_SE_OBJECT_TYPE enum. The default is $SE_FILE_OBJECT (a file or folder).
; Return values .: Success      - A pointer to the security descriptor
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _ConvertSecurityDescriptorToStringSecurityDescriptor, _GetObjectStringSecurityDescriptor
; Link ..........:
; Example .......: _GetObjectSecurityDescriptor(@DesktoDir&'\example.txt')
; ===============================================================================================================================
Func _GetObjectSecurityDescriptor($oName, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT)
	Local $SECURITY_INFORMATION = BitOR($OWNER_SECURITY_INFORMATION,$GROUP_SECURITY_INFORMATION,$DACL_SECURITY_INFORMATION,$SACL_SECURITY_INFORMATION), $aRet
	If $ResourcesState = 0 Then _InitiatePermissionResources()
	If IsPtr($oName) Then
		$aRet = DllCall($h__Advapi32Dll,'DWORD','GetSecurityInfo','handle',$oName,'dword',$_SE_OBJECT_TYPE, _
		'DWORD',$SECURITY_INFORMATION,'ptr',0,'ptr',0,'ptr',0,'ptr',0,'ptr*',0)
	Else
		If $_SE_OBJECT_TYPE = $SE_REGISTRY_KEY Then $oName = _Security_RegKeyName($oName)
		$aRet = DllCall($h__Advapi32Dll,'DWORD','GetNamedSecurityInfo','str',$oName,'dword',$_SE_OBJECT_TYPE, _
		'DWORD',$SECURITY_INFORMATION,'ptr',0,'ptr',0,'ptr',0,'ptr',0,'ptr*',0)
	EndIf
	If @error Then Return SetError(@error,0,0)
	Return SetError($aRet[0],0,$aRet[8])
EndFunc ;==>_GetObjectSecurityDescriptor

; #FUNCTION# ====================================================================================================================
; Name...........: _GetObjectStringSecurityDescriptor
; Description ...: Returns the security descriptor of the given object in the string format.
; Syntax.........:  _GetObjectStringSecurityDescriptor($oName, $_SE_OBJECT_TYPE
;					$oName   - The name of the object. This can be a path to a file or folder, a registry key, a service name, etc.
;						+See the comments on the _SE_OBJECT_TYPE enum for more info.
;					$_SE_OBJECT_TYPE (Optional) - The type of the object to set permissions. This must be one of the values of the
;						+_SE_OBJECT_TYPE enum. The default is $SE_FILE_OBJECT (a file or folder).
; Return values .: Success      - A string security descriptor
;                  Failure      - '' and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _ConvertSecurityDescriptorToStringSecurityDescriptor, _ConvertStringSecurityDescriptorToSecurityDescriptor
; Link ..........:
; Example .......:_GetObjectStringSecurityDescriptor(@DesktoDir&'\example.txt')
; ===============================================================================================================================
 Func _GetObjectStringSecurityDescriptor($oName, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT)
	Local $pSecDescriptor = _GetObjectSecurityDescriptor($oName, $_SE_OBJECT_TYPE)
	If $pSecDescriptor = 0 Then Return SetError(2,0,'')
	Local $strSecDescriptor = _ConvertSecurityDescriptorToStringSecurityDescriptor($pSecDescriptor)
	DllCall($h__Kernel32Dll,'handle','LocalFree','handle',$pSecDescriptor)
	Return $strSecDescriptor
EndFunc ;==>_GetObjectStringSecurityDescriptor

; #FUNCTION# ====================================================================================================================
; Name...........: _SetObjectStringSecurityDescriptor
; Description ...: Sets the secuity descriptor of an object based on a string security descriptor.
; Syntax.........:   _SetObjectStringSecurityDescriptor($oName, $StrSecDescriptor, $_SE_OBJECT_TYPE, $ClearDacl)
;					$strSecDescriptor - A string security cescriptor. Can be obtained with _GetObjectStringSecurityDescriptor
;					+or _ConvertSecurityDescriptorToStringSecurityDescriptor.
;					$_SE_OBJECT_TYPE (Optional) - The type of the object to set permissions. This must be one of the values of the
;						+_SE_OBJECT_TYPE enum. The default is $SE_FILE_OBJECT (a file or folder).
;					$ClearDacl (Optional) - 1 or 0, whether to clear the existing object's Dacl.
; Return values .: Success      - 1
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _ConvertSecurityDescriptorToStringSecurityDescriptor, _ConvertStringSecurityDescriptorToSecurityDescriptor
; Link ..........:
; Example .......: _ConvertSecurityDescriptorToStringSecurityDescriptor(_GetObjectSecurityDescriptor(@DesktoDir&'\example.txt'))
; ===============================================================================================================================
Func _SetObjectStringSecurityDescriptor($oName, $StrSecDescriptor, $_SE_OBJECT_TYPE = $SE_FILE_OBJECT)
	If Not IsString($strSecDescriptor) Then Return SetError(1,0,0)
	Local $pSecDescriptor = _ConvertStringSecurityDescriptorToSecurityDescriptor($StrSecDescriptor)
	If $pSecDescriptor = 0 Then Return SetError(2,0,0)
	Return _SetObjectSecurityDescriptor($oName, $pSecDescriptor,$_SE_OBJECT_TYPE)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _ConvertSecurityDescriptorToStringSecurityDescriptor
; Description ...: Returns a security descriptor's string.
; Syntax.........:  _ConvertSecurityDescriptorToStringSecurityDescriptor($pSecDescriptor)
;					$pSecDescriptor - A pointer to a security descriptor structure. Can be obtained with _GetObjectSecurityDescriptor
;					+or _ConvertStringSecurityDescriptorToSecurityDescriptor.
; Return values .: Success      - A string security descriptor
;                  Failure      - ''
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _ConvertSecurityDescriptorToStringSecurityDescriptor, _ConvertStringSecurityDescriptorToSecurityDescriptor
; Link ..........:
; Example .......: _ConvertSecurityDescriptorToStringSecurityDescriptor(_GetObjectSecurityDescriptor(@DesktoDir&'\example.txt'))
; ===============================================================================================================================
Func  _ConvertSecurityDescriptorToStringSecurityDescriptor(ByRef $pSecDescriptor)
	 If Not IsPtr($pSecDescriptor) Then Return SetError(1,0,0)
	Local $SECURITY_INFORMATION = BitOR($DACL_SECURITY_INFORMATION,$OWNER_SECURITY_INFORMATION)
	Local $aRet = DllCall($h__Advapi32Dll,'bool','ConvertSecurityDescriptorToStringSecurityDescriptor', _
	'ptr',$pSecDescriptor,'DWORD',1,'DWORD',$SECURITY_INFORMATION,'str*',0,'ptr',0)
	If @error Then Return SetError(1,0,'')
	Return $aRet[4]
EndFunc ;==>_ConvertSecurityDescriptorToStringSecurityDescriptor

; #FUNCTION# ====================================================================================================================
; Name...........: _ConvertStringSecurityDescriptorToSecurityDescriptor
; Description ...: Converts a security descriptor in the string format to a pointer to a security descriptor's structure.
; Syntax.........:   _ConvertStringSecurityDescriptorToSecurityDescriptor($strSecDescriptor)
;					$strSecDescriptor - A string security cescriptor.
; Return values .: Success      - A pointer to the security descriptor
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _ConvertSecurityDescriptorToStringSecurityDescriptor, _ConvertStringSecurityDescriptorToSecurityDescriptor
; Link ..........:
; Example .......: _ConvertSecurityDescriptorToStringSecurityDescriptor(_GetObjectSecurityDescriptor(@DesktoDir&'\example.txt'))
; ===============================================================================================================================
Func  _ConvertStringSecurityDescriptorToSecurityDescriptor($strSecDescriptor)
	 If Not IsString($strSecDescriptor) Then Return SetError(1,0,0)
	Local $aRet = DllCall($h__Advapi32Dll,'bool','ConvertStringSecurityDescriptorToSecurityDescriptor', _
	'str',$strSecDescriptor,'DWORD',1,'ptr*',0,'ptr',0)
	If @error Then Return SetError(1,0,0)
	Return $aRet[3]
EndFunc ;==>_ConvertStringSecurityDescriptorToSecurityDescriptor

; #FUNCTION# ====================================================================================================================
; Name...........: _GetSidStruct
; Description ...: Returns The given account name or SID string in a SID Structure.
; Syntax.........:  _GetSidStruct($AccountName)
;					$AccountName - The account name or SID string to set. Can be any user name or SID string,
;					 +or 'Administrators', 'System', 'Everyone', 'Authenticated Users', 'Users', 'Guests', 'Power Users',
;					+'Local Authority', 'Creator Owner', 'NT Authority', 'Restricted' and 'TrustedInstaller'
; Return values .: Success      - A SID structure
;                  Failure      - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......: The strings work for all languages. Get more universal SIDs from http://support.microsoft.com/kb/243330
; Related .......: _LookupAccountName, _StringSidToSid
; Link ..........:
; Example .......: _GetSidStruct(@UserName)
; ===============================================================================================================================
Func _GetSidStruct($AccountName)
	If $AccountName = 'TrustedInstaller' Then $AccountName = 'NT SERVICE\TrustedInstaller'
	If $AccountName = 'Everyone' Then
		Return _StringSidToSid('S-1-1-0')
	ElseIf $AccountName = 'Authenticated Users' Then
		Return _StringSidToSid('S-1-5-11')
	ElseIf $AccountName = 'System' Then
		Return _StringSidToSid('S-1-5-18')
	ElseIf $AccountName = 'Administrators' Then
		Return _StringSidToSid('S-1-5-32-544')
	ElseIf $AccountName = 'Users' Then
		Return _StringSidToSid('S-1-5-32-545')
	ElseIf $AccountName = 'Guests' Then
		Return _StringSidToSid('S-1-5-32-546')
	ElseIf $AccountName = 'Power Users' Then
		Return _StringSidToSid('S-1-5-32-547')
	ElseIf $AccountName = 'Local Authority' Then
		Return _StringSidToSid('S-1-2')
	ElseIf $AccountName = 'Creator Owner' Then
		Return _StringSidToSid('S-1-3-0')
	ElseIf $AccountName = 'NT Authority' Then
		Return _StringSidToSid('S-1-5-1')
	ElseIf $AccountName = 'Restricted' Then
		Return _StringSidToSid('S-1-5-12')
	ElseIf StringRegExp($AccountName,'\A(S-1-\d+(-\d+){0,5})\z') Then
		Return _StringSidToSid($AccountName)
	Else
		Local $SID = _LookupAccountName($AccountName)
		Return _StringSidToSid($SID)
	EndIf
EndFunc ;==>_GetSidStruct

; #FUNCTION# ====================================================================================================================
; Name...........: _Security_RegKeyName
; Description ...: Converts a common registry path to a valid path to use with the Dllcalls in this UDF
; Syntax.........:  _Security_RegKeyName($RegKey)
;					$RegKey - A common registry path to convert. e.g. 'HKLM\SOFTWARE' will return 'MACHINE\SOFTWARE'
; Return values .: A converted registry path
; Author ........: FredAI
; Modified.......:
; Remarks .......: This function also converts remote registry paths
; Related .......:
; Link ..........:
; Example .......: $Key = _Security_RegKeyName('HKCU\Software\Example')
; ===============================================================================================================================
Func _Security_RegKeyName($RegKey)
	If StringInStr($RegKey,'\\') = 1 Then
		$RegKey = StringRegExpReplace($RegKey,'(?i)\\(HKEY_CLASSES_ROOT|HKCR)','\CLASSES_ROOT')
		$RegKey = StringRegExpReplace($RegKey,'(?i)\\(HKEY_CURRENT_USER|HKCU)','\CURRENT_USER')
		$RegKey = StringRegExpReplace($RegKey,'(?i)\\(HKEY_LOCAL_MACHINE|HKLM)','\MACHINE')
		$RegKey = StringRegExpReplace($RegKey,'(?i)\\(HKEY_USERS|HKU)','\USERS')
	Else
		$RegKey = StringRegExpReplace($RegKey,'(?i)\A(HKEY_CLASSES_ROOT|HKCR)','CLASSES_ROOT')
		$RegKey = StringRegExpReplace($RegKey,'(?i)\A(HKEY_CURRENT_USER|HKCU)','CURRENT_USER')
		$RegKey = StringRegExpReplace($RegKey,'(?i)\A(HKEY_LOCAL_MACHINE|HKLM)','MACHINE')
		$RegKey = StringRegExpReplace($RegKey,'(?i)\A(HKEY_USERS|HKU)','USERS')
	EndIf
	Return $RegKey
EndFunc ;==>_Security_RegKeyName

; #FUNCTION# ====================================================================================================================
; Name...........: _LookupAccountName
; Description ...: Retrieves a security identifier (SID) for the account and the name of the domain
; Syntax.........:_LookupAccountName($sAccount[, $sSystem = ""])
; Parameters ....: $sAccount    - Specifies the account name.
;                  $sSystem     - Name of the system. This string can be the name of a remote computer.  If this string is blank,
;                  +the account name translation begins on the local system.  If the name cannot be resolved on the local system,
;                  +this function will try to resolve the name using domain controllers trusted by the local system.
; Return values .: Success - SID String
; Author ........: Paul Campbell (PaulIA)
; Modified.......: FredAI
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ LookupAccountName
; Example .......:
; ===============================================================================================================================
Func _LookupAccountName($sAccount, $sSystem = "")
	Local $tData = DllStructCreate("byte SID[256]")
	Local $pSID = DllStructGetPtr($tData, "SID")
	Local $aResult = DllCall($h__Advapi32Dll, "bool", "LookupAccountNameW", "wstr", $sSystem, "wstr", $sAccount, "ptr", $pSID, "dword*", 256, _
			"wstr", "", "dword*", 256, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If Not $aResult[0] Then Return 0
	Return _SidToStringSid($pSID)
EndFunc   ;==>_LookupAccountName

; #FUNCTION# ====================================================================================================================
; Name...........: _StringSidToSid
; Description ...: Converts a String SID to a binary SID
; Syntax.........: _StringSidToSid($sSID)
; Parameters ....: $sSID        - String SID to be converted
; Return values .: Success      - SID in a byte structure
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: FredAI
; Remarks .......:
; Related .......: _SidToStringSid
; Link ..........: @@MsdnLink@@ ConvertStringSidToSid
; Example .......:
; ===============================================================================================================================
Func _StringSidToSid($sSID)
	Local $aResult = DllCall($h__Advapi32Dll, "bool", "ConvertStringSidToSidW", "wstr", $sSID, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If Not $aResult[0] Then Return 0

	Local $iSize = _GetLengthSid($aResult[2])
	Local $tBuffer = DllStructCreate("byte Data[" & $iSize & "]", $aResult[2])
	Local $tSID = DllStructCreate("byte Data[" & $iSize & "]")
	DllStructSetData($tSID, "Data", DllStructGetData($tBuffer, "Data"))
	DllCall($h__Kernel32Dll, "ptr", "LocalFree", "ptr", $aResult[2])
	; No need to test @error.
	Return $tSID
EndFunc   ;==>_StringSidToSid

; #FUNCTION# ====================================================================================================================
; Name...........: _GetLengthSid
; Description ...: Returns the length, in bytes, of a valid SID
; Syntax.........: _Security__GetLengthSid($pSID)
; Parameters ....: $pSID        - Pointer to a SID
; Return values .: Success      - Length of SID
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: FredAI
; Remarks .......:
; Related .......: _Security__IsValidSid
; Link ..........: @@MsdnLink@@ GetLengthSid
; Example .......:
; ===============================================================================================================================
Func _GetLengthSid($pSID)
	If Not _IsValidSid($pSID) Then Return SetError(-1, 0, "")
	Local $aResult = DllCall($h__Advapi32Dll, "dword", "GetLengthSid", "ptr", $pSID)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GetLengthSid

; #FUNCTION# ====================================================================================================================
; Name...........: _SidToStringSid
; Description ...: Converts a binary SID to a string
; Syntax.........: _SidToStringSid($pSID)
; Parameters ....: $pSID        - Pointer to a binary SID to be converted
; Return values .: Success      - SID in string form
;                  Failure      - Empty string
; Author ........: Paul Campbell (PaulIA)
; Modified.......: FredAI
; Remarks .......:
; Related .......: _StringSidToSid
; Link ..........: @@MsdnLink@@ ConvertSidToStringSid
; Example .......:
; ===============================================================================================================================
Func _SidToStringSid($pSID)
	If Not _IsValidSid($pSID) Then Return SetError(-1, 0, "")

	Local $aResult = DllCall($h__Advapi32Dll, "int", "ConvertSidToStringSidW", "ptr", $pSID, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, "")
	If Not $aResult[0] Then Return ""
	Local $tBuffer = DllStructCreate("wchar Text[256]", $aResult[2])
	Local $sSID = DllStructGetData($tBuffer, "Text")
	DllCall($h__Kernel32Dll, "ptr", "LocalFree", "ptr", $aResult[2])
	; No neeed to test @error.
	Return $sSID
EndFunc   ;==> _SidToStringSid($pSID)

; #FUNCTION# ====================================================================================================================
; Name...........: _IsValidSid
; Description ...: Validates a SID
; Syntax.........: _IsValidSid($pSID)
; Parameters ....: $pSID        - Pointer to a SID
; Return values .: True         - SID is valid
;                  False        - SID is not valid
; Author ........: Paul Campbell (PaulIA)
; Modified.......: FredAI
; Remarks .......:
; Related .......: _GetLengthSid
; Link ..........: @@MsdnLink@@ IsValidSid
; Example .......:
; ===============================================================================================================================
Func _IsValidSid($pSID)
	Local $aResult = DllCall($h__Advapi32Dll, "bool", "IsValidSid", "ptr", $pSID)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_IsValidSid

; #FUNCTION# ====================================================================================================================================
; Name...........: _SetPrivilege
; Description ...: Enables or disables special privileges as required by some DllCalls
; Syntax.........: _SetPrivilege($avPrivilege)
; Parameters ....: $avPrivilege - An array of privileges and respective attributes
;                                 $SE_PRIVILEGE_ENABLED - The function enables the privilege
;                                 $SE_PRIVILEGE_REMOVED - The privilege is removed from the list of privileges in the token
;                                 0 - The function disables the privilege
; Requirement(s).: None
; Return values .: Success - An array of modified privileges and their respective previous attribute state
;                  Failure - An empty array
;                            Sets @error
; Author ........: engine
; Modified.......: FredAI
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================================

Func _SetPrivilege($avPrivilege)
	Local $iDim = UBound($avPrivilege, 0), $avPrevState[1][2]
	If Not ( $iDim <= 2 And UBound($avPrivilege, $iDim) = 2 ) Then Return SetError(1300, 0, $avPrevState)
	If $iDim = 1 Then
		Local $avTemp[1][2]
		$avTemp[0][0] = $avPrivilege[0]
		$avTemp[0][1] = $avPrivilege[1]
		$avPrivilege = $avTemp
		$avTemp = 0
	EndIf
	Local $k, $tagTP = "dword", $iTokens = UBound($avPrivilege, 1)
	Do
		$k += 1
		$tagTP &= ";dword;long;dword"
	Until $k = $iTokens
	Local $tCurrState, $tPrevState, $pPrevState, $tLUID, $ahGCP, $avOPT, $aiGLE
	$tCurrState = DLLStructCreate($tagTP)
	$tPrevState = DllStructCreate($tagTP)
	$pPrevState = DllStructGetPtr($tPrevState)
	$tLUID = DllStructCreate("dword;long")
	DLLStructSetData($tCurrState, 1, $iTokens)
	For $i = 0 To $iTokens - 1
		DllCall($h__Advapi32Dll, "int", "LookupPrivilegeValue", _
			"str", "", _
			"str", $avPrivilege[$i][0], _
			"ptr", DllStructGetPtr($tLUID) )
		DLLStructSetData( $tCurrState, 3 * $i + 2, DllStructGetData($tLUID, 1) )
		DLLStructSetData( $tCurrState, 3 * $i + 3, DllStructGetData($tLUID, 2) )
		DLLStructSetData( $tCurrState, 3 * $i + 4, $avPrivilege[$i][1] )
	Next
	$ahGCP = DllCall($h__Kernel32Dll, "hwnd", "GetCurrentProcess")
	$avOPT = DllCall($h__Advapi32Dll, "int", "OpenProcessToken", _
		"hwnd", $ahGCP[0], _
		"dword", BitOR(0x00000020, 0x00000008), _
		"hwnd*", 0 )
	DllCall( $h__Advapi32Dll, "int", "AdjustTokenPrivileges", _
		"hwnd", $avOPT[3], _
		"int", False, _
		"ptr", DllStructGetPtr($tCurrState), _
		"dword", DllStructGetSize($tCurrState), _
		"ptr", $pPrevState, _
		"dword*", 0 )
	$aiGLE = DllCall($h__Kernel32Dll, "dword", "GetLastError")
	DllCall($h__Kernel32Dll, "int", "CloseHandle", "hwnd", $avOPT[3])
	Local $iCount = DllStructGetData($tPrevState, 1)
	If $iCount > 0 Then
		Local $pLUID, $avLPN, $tName, $avPrevState[$iCount][2]
		For $i = 0 To $iCount - 1
			$pLUID = $pPrevState + 12 * $i + 4
			$avLPN = DllCall($h__Advapi32Dll, "int", "LookupPrivilegeName", _
				"str", "", _
				"ptr", $pLUID, _
				"ptr", 0, _
				"dword*", 0 )
			$tName = DllStructCreate("char[" & $avLPN[4] & "]")
			DllCall($h__Advapi32Dll, "int", "LookupPrivilegeName", _
				"str", "", _
				"ptr", $pLUID, _
				"ptr", DllStructGetPtr($tName), _
				"dword*", DllStructGetSize($tName) )
			$avPrevState[$i][0] = DllStructGetData($tName, 1)
			$avPrevState[$i][1] = DllStructGetData($tPrevState, 3 * $i + 4)
		Next
	EndIf
	Return SetError($aiGLE[0], 0, $avPrevState)
EndFunc ;==> _SetPrivilege
