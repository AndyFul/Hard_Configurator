#include-once
; ===============================================================================================================================
; <_ShellExecuteWithReducedPrivileges.au3>
;
; Function to ShellExecute() a program with reduced privileges, by using Windows Explorer's SHELL object's ShellExecute.
;	Useful when running in a higher privilege mode, but need to start a program with reduced privileges.
;	- A common problem this fixes is drag-and-drop not working, and misc functions (sendmessage, etc) not working
;	  with lesser-privilege mode processes.
;	- Also, this helps to restrict a process's rights (useful after an Install)
;
; Functions:
;	_ShellExecuteWithReducedPrivileges()		; ShellExecute()'s a program/command with reduced privileges if currently
;												; running in a higher privilege mode
;
; Requirements:
;	- Vista/2008+ O/S. (Lower O/S's are supported by calling native AutoIt functions, however)
;	- Also, installing a COM error-handler is a MUST, in case a COM error occurs (see ObjEvent("AutoIt.Error"))
;
; See also:
;	<_RunWithReducedPrivileges.au3>		; Uses CreateProcessWithTokenW() to run a program
;
; Reference:
;	See 'Getting the shell to run an application for you - Part 2:How | BrandonLive'
;		@ http://brandonlive.com/2008/04/27/getting-the-shell-to-run-an-application-for-you-part-2-how/
; - Also, from _RunWithReducedPrivileges:
;	'Creating a process with Medium Integration Level from the process with High Integration Level in Vista'
;		@ http://www.codeproject.com/KB/vista-security/createprocessexplorerleve.aspx
;	  See Elmue's comment 'Here the cleaned and bugfixed code'
;	'High elevation can be bad for your application: How to start a non-elevated process at the end of the installation'
;		@ http://www.codeproject.com/KB/vista-security/RunNonElevated.aspx
;	  (Elmue has the same code here too in his response to FaxedHead's comment ('Another alternative to this method'))
;
; Additional:
;	'ChangeWindowMessageFilterEx Function (Windows)' on MSDN
;		@ http://msdn.microsoft.com/en-us/library/dd388202%28v=VS.85%29.aspx
;	  (allows altering IL (uers privilege) filter for a Window)
;	See Trancexx's remarks on this on 'ITaskbarList3' - post # 18
;		@ http://www.autoitscript.com/forum/topic/110768-itaskbarlist3/page__view__findpost__p__853156
;
; Author: Ascend4nt, based on code by Brandon (of the 'BrandonLive' blog)
; ===============================================================================================================================


; ===================================================================================================================
; Func _ShellExecuteWithReducedPrivileges($sPath,$sCmd='',$sFolder='',$sVerb='',$iShowFlag=@SW_SHOWNORMAL,$bWait=False)
;
; Function to ShellExecute() a program/command with reduced privileges.  This uses a COM method of finding
;	Windows explorer's SHELL object and using that to ShellExecute() a program/command so that the IL level of
;	Explorer is used. This is useful if there is a need to start a program/command with reduced privileges.
;	- A common problem this fixes is drag-and-drop not working, and misc functions (sendmessage, etc) not working.
;
; All of the following parameters work the same as for ShellExecute(), with $bWait being the exception.
;
; $sPath = Path to executable
; $sCmd = Command-line (optional)
; $sFolder = Folder to start in (optional)
; $sVerb = 'Verb' or operation to perform. Default of '' uses default in Registry, or 'open'.
; $iShowFlag = how the program should appear on startup. Default is @SW_SHOWNORMAL.
;	All the regular @SW_SHOW* macros should work here
; $bWait = This only applies if A.) The process is no running elevated or B.) This is a pre-Vista O/S
;	If either of those is true, AutoIt's built-in ShellExecute() is called.
;	Setting $bWait to True/non-zero will instead run ShellExecuteWait()
;
; Returns:
;	Success: If $bWait is True, and ShellExecuteWait() is called, the return is the exit code of the Process
;		used to open/run command. Otherwise, this returns 1
;	Failure: 0, with @error set:
;		@error = 1 = Error returned from AutoIt's built-in ShellExecute*() function
;		@error = 2 = Object creation failure for Shell object
;		@error = 3 = Object creation failure for InternetExplorer object
;		@error = 4 = Object creation failure for Explorer's Shell object
;
; Author: Ascend4nt, based on code by Brandon (of the 'BrandonLive' blog)
; ===================================================================================================================

Func _ShellExecuteWithReducedPrivileges($sPath,$sCmd='',$sFolder='',$sVerb='',$iShowFlag=@SW_SHOWNORMAL,$bWait=False)
	Local $oShell,$oWebBrowser,$oIShellDispatch

;	ShellExecute() normally if not in an elevated state, or if pre-Vista O/S.
	If Not IsAdmin() Or StringRegExp(@OSVersion,"_(XP|200(0|3))") Then
		Local $iRet
		If $bWait Then
			$iRet=ShellExecuteWait($sPath,$sCmd,$sFolder,$sVerb,$iShowFlag)
		Else
			$iRet=ShellExecute($sPath,$sCmd,$sFolder,$sVerb,$iShowFlag)
		EndIf
		Return SetError(@error,@extended,$iRet)
	EndIf

;	-- Vista/2008+ O/S. We're good to go! --

;	Shell Object (IShellDispatch5 on Vista+)
	$oShell=ObjCreate("Shell.Application")
	If Not IsObj($oShell) Then Return SetError(2,0,0)

;	IShellDispatch5->IShellWindows ('ShellWindows Collection') object->FindWindow
	; 	NULL, NULL, SWC_DESKTOP (0x08) [Vista+], Hwnd-Out (NULL), SWFO_NEEDDISPATCH (0x01)
	;  Returns IWebBrowser2 (InternetExplorer) object
	$oWebBrowser = $oShell.Windows.FindWindowSW(0,0,8,0,1)
	If Not IsObj($oWebBrowser) Then Return SetError(3,0,0)

;	IWebBrowser2->IShellFolderViewDual3 (ShellFolderView)->IShellDispatch5 (Explorer's Shell object)
	$oIShellDispatch= $oWebBrowser.Document.Application
	If Not IsObj($oIShellDispatch) Then Return SetError(4,0,0)

;	Call Shell->ShellExecute.  The return seems to always be a blank string, so nothing we can do about that
	$oIShellDispatch.ShellExecute($sPath,$sCmd,$sFolder,$sVerb,$iShowFlag)
	Return 1
EndFunc
