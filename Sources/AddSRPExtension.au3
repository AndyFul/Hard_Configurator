Func AddSRPExtension($x)

#Include <Array.au3>
#include <MsgBoxConstants.au3>

Local $_Array = Reg2Array()
_ArrayAdd($_Array, $x)
_ArraySort($_Array)
;_ArrayDisplay($_Array)
Array2Reg($_Array)

EndFunc


