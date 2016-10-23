Func RASExecutableTypes($x)
#include <File.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

Local $_Array = Reg2Array()

;MsgBox($MB_SYSTEMMODAL, "", $_Array)

Local $_Array = Reg2Array()

If $x = "light" Then  
          Local $n=0
          While $n <>-1
          $n = _ArraySearch($_Array, "BAT")
          _ArrayDelete($_Array, $n)
          WEnd

          $n=0
          While $n <>-1
          $n = _ArraySearch($_Array, "CMD")
          _ArrayDelete($_Array, $n)
          WEnd

          $n=0
          While $n <>-1
          $n = _ArraySearch($_Array, "JSE")
          _ArrayDelete($_Array, $n)
          WEnd

          $n=0
          While $n <>-1
          $n = _ArraySearch($_Array, "VBE")
          _ArrayDelete($_Array, $n)
          WEnd

          Array2Reg($_Array)  
          MsgBox($MB_SYSTEMMODAL, "ALERT", "If  BAT CMD JSE VBE extensions were stored in SRP registry key then they have been removed from the Registry to work with Run As Smartscreen. Those extensions are still protected by SRP in the WhiteList setup. You can manually add any of above extensions (using ADD button in the Menu) to block them even when using Run As Smartscreen.")
          
          Else 
          If _ArraySearch($_Array, "BAT") = -1 Then _ArrayAdd($_Array, "BAT")
          If _ArraySearch($_Array, "CMD") = -1 Then _ArrayAdd($_Array, "CMD")
          If _ArraySearch($_Array, "JSE") = -1 Then _ArrayAdd($_Array, "JSE")
          If _ArraySearch($_Array, "VBE") = -1 Then _ArrayAdd($_Array, "VBE")
          Array2Reg($_Array)  
          MsgBox($MB_SYSTEMMODAL, "ALERT", "If BAT CMD JSE VBE extensions were not stored in SRP registry key then they have just been added and not allowed to execute. You can manually remove any of above extensions (using REMOVE button in the Menu) to unblock them when using SRP.") 
EndIf

EndFunc
