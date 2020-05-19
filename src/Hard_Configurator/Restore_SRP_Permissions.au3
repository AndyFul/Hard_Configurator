Func Restore_SRP_Permissions()

;#include 'Permissions.au3'
;#RequireAdmin

Local $oName = "HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers"
$SetOwner = 'Administrators'

_InitiatePermissionResources()
_GrantAllAccess($oName, $SE_REGISTRY_KEY, $SetOwner, 1)
_ClearObjectDacl($oName, $SE_REGISTRY_KEY)
_InheritParentPermissions($oName, $SE_REGISTRY_KEY, 1)
_ClosePermissionResources()

EndFunc
