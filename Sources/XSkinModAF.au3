; Function XSkinGUICreate from XSkin.au3 v1.3.7 Feb. 12, 2007 by Valuater
; Some Skins and above function were downloaded from: 
;https://github.com/erichybner/autoIT/blob/master/snippits/XSkin_Fully_Loaded.zip
; Modified slightly to work with Hard_Configurator by Andy Ful


#include-once
#include <GUIConstants.au3>
;Opt("MustDeclareVars", 1)
Dim $CtrlIDA[1], $CtrlIDB[1], $CtrlIDC[1], $CtrlIDMA[3], $CtrlIDMB[3], $XS_gui[1], $Skin_Folder, $Icon_Folder, $iLoop, $XS_debug = 0
Dim $over_color, $btn_color, $bkg_color, $fnt_color, $tile_size, $XS_TMB, $XS_TMA, $SKBox_[2], $XSkinID[1]
Dim $XSolid = 1, $XSlid = 1, $XSlid1, $XSlid2, $XSlid3, $XSlpr, $XS_Isize, $XS_Istyle, $XadjLt, $XadjDn, $XStrans = 200
Dim $GlobalHeader, $GlobalCorners, $Globalcolor, $CtrlButton[1][4]
If $XS_debug Then Opt("TrayIconDebug", 1)
Func XSkinGUICreate($XS_guiTitle, $XS_width, $XS_height, $Skin_Folder, $guiHeader = 1, $guiCorners = 25)
	If Not FileExists($Skin_Folder) Then XSkinError("The GUI Skin <" & $GuiSkin & "> was not found")
	$GlobalCorners = $guiCorners
	$GlobalHeader = $guiHeader
	$bkg_color = IniRead($Skin_Folder & "\Skin.dat", "color", "background", 0xE6E6EF)
	$btn_color = IniRead($Skin_Folder & "\Skin.dat", "color", "button", 0xD9F6FF)
	$over_color = IniRead($Skin_Folder & "\Skin.dat", "color", "mouseover", 0xD9F6FF)
	$fnt_color = IniRead($Skin_Folder & "\Skin.dat", "color", "fontcolor", 0x000000)
	$tile_size = IniRead($Skin_Folder & "\Skin.dat", "settings", "size", 20)
	$XS_Istyle = IniRead($Skin_Folder & "\Skin.dat", "icon", "style", "Standard")
	$XS_Isize = IniRead($Skin_Folder & "\Skin.dat", "icon", "Isize", 17)
	$XadjLt = IniRead($Skin_Folder & "\Skin.dat", "icon", "adjustleft", 20)
	$XadjDn = IniRead($Skin_Folder & "\Skin.dat", "icon", "adjustdown", 20)
	Local $elements[8]
	If $XS_width < 100 Then $XS_width = 100
	If $XS_height < 50 Then $XS_height = 50
	If $tile_size < 15 Then $tile_size = 15
	For $XS_px = 0 To 7
		$elements[$XS_px] = $Skin_Folder & "\" & $XS_px & ".bmp"
;		If Not FileExists($elements[$XS_px]) Then XSkinError("A skin picture was not found #" & $XS_px & "  ")
	Next
	If IsArray($XSkinID) And UBound($XSkinID) >= 2 Then $iLoop = 1
	Local $guiHeader2 = $guiHeader
	If $guiHeader >= 1 Then
		$guiHeader2 = $WS_POPUP
	ElseIf $guiHeader = 0 Then
		$XS_height = $XS_height + 32
		$XS_width = $XS_width + 6
	EndIf
	ReDim $XS_gui[UBound($XS_gui) + 1]
	$XS_TMA = UBound($XS_gui) - 1
	$XS_gui[$XS_TMA] = GUICreate($XS_guiTitle, $XS_width, $XS_height, -1, -1, $guiHeader2)
	If Not $Globalcolor = 1 Then GUISetBkColor($bkg_color)
	If $guiHeader = 0 Then
		$XS_height = $XS_height - 32
		$XS_width = $XS_width - 6
	EndIf
	GUICtrlCreatePic($elements[0], 0, 0, $tile_size, $tile_size, $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic($elements[2], ($XS_width - $tile_size), 0, $tile_size, $tile_size, $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic($elements[5], 0, ($XS_height - $tile_size), $tile_size, $tile_size, $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic($elements[7], ($XS_width - $tile_size) , ($XS_height - $tile_size), $tile_size, $tile_size, $WS_CLIPSIBLINGS)
	For $XS_i = 0 To (Ceiling($XS_width / $tile_size) - 3)
		GUICtrlCreatePic($elements[1], ($tile_size * ($XS_i + 1)), 0, $tile_size, $tile_size, BitOR($SS_NOTIFY, $WS_CLIPSIBLINGS), $GUI_WS_EX_PARENTDRAG)
		If $XS_i > ((Ceiling($XS_width / $tile_size) - 3) / 3) * 2 Then GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreatePic($elements[6], ($tile_size * ($XS_i + 1)) , ($XS_height - $tile_size), $tile_size, $tile_size, $WS_CLIPSIBLINGS)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Next
	For $XS_i = 0 To (Ceiling($XS_height / $tile_size) - 3)
		GUICtrlCreatePic($elements[3], 0, ($tile_size * ($XS_i + 1)), $tile_size, $tile_size, $WS_CLIPSIBLINGS)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreatePic($elements[4], ($XS_width - $tile_size) , ($tile_size * ($XS_i + 1)), $tile_size, $tile_size, $WS_CLIPSIBLINGS)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Next
	GUICtrlCreatePic($elements[0], 0, 0, $tile_size, $tile_size, $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic($elements[2], ($XS_width - $tile_size), 0, $tile_size, $tile_size, $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic($elements[5], 0, ($XS_height - $tile_size), $tile_size, $tile_size, $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic($elements[7], ($XS_width - $tile_size) , ($XS_height - $tile_size), $tile_size, $tile_size, $WS_CLIPSIBLINGS)
	If $XS_debug Then ConsoleWrite("gui = " & $XS_gui[$XS_TMA] & " Error = " & @error & @CRLF)
	If $guiCorners Then _GuiRoundCorners($XS_gui[$XS_TMA], 0, 0, $guiCorners, $guiCorners)
	Return $XS_gui[$XS_TMA]
EndFunc   ;==>XSkinGUICreate


Func _GuiRoundCorners($h_win, $i_x1, $i_y1, $i_x3, $i_y3) ; thanks gafrost
	Local $XS_pos, $XS_ret, $XS_ret2
	$XS_pos = WinGetPos($h_win)
	$XS_ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", $i_x1, "long", $i_y1, "long", $XS_pos[2], "long", $XS_pos[3], "long", $i_x3, "long", $i_y3)
	If $XS_ret[0]Then
		$XS_ret2 = DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $XS_ret[0], "int", 1)
	EndIf
EndFunc   ;==>_GuiRoundCorners
Func XSkinError($XE_msg)
	MsgBox(262208, "XSkin Error", $XE_msg, 5)
        Return "NoSkin"
	Exit
EndFunc   ;==>XSkinError