Func CheckBoxBlockSponsors()

#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
    Global $BlockSponsorsGUI
    Global $MainBlockSponsorsGUI
    Global $X_BlockSponsorsGUI = 200
    Global $Y_BlockSponsorsGUI = 400

;****************************************
;    Global $BlockSponsorsNumber = 0
;    Global $idCheckboxCMD
;    Global $idCheckboxPowerShell
;    Global $DisablePowerShell
;    Global $DisablePowerShell_ise
;****************************************
;    GUISetState(@SW_DISABLE, $listGUI)
;    GUISetState(@SW_HIDE,$listGUI)
;    Opt("GUIOnEventMode", 1)
     HideMainGUI()

    If not ($X_BlockSponsorsGUI > 0) Then $X_BlockSponsorsGUI = -1
    If not ($Y_BlockSponsorsGUI > 0) Then $Y_BlockSponsorsGUI = -1

;   Create a GUI with various controls.
;    Local $BlockSponsorsGUI = GUICreate("Block Sponsors", $X_BlockSponsorsGUI, $Y_BlockSponsorsGUI)
     $MainBlockSponsorsGUI = GUICreate("Block Sponsors", 375, 435, -1, -1, -1)
     GUISetOnEvent($GUI_EVENT_CLOSE, "CloseBlockSponsors")

   Local $labelBlockScriptInterpretersOnOff = GUICtrlCreateLabel ("Script Interpreters", 220-3, 50, 150, 16,$SS_CENTER,-1)
    GUICtrlSetFont ( $labelBlockScriptInterpretersOnOff, 10, 600)

    $BtnBlockScriptInterpretersON = GUICtrlCreateButton("ON", 250, 80, 40, 25)
    GUICtrlSetOnEvent($BtnBlockScriptInterpretersON, "BlockScriptInterpretersON1")

    $BtnBlockScriptInterpretersOFF = GUICtrlCreateButton("OFF", 295, 80, 40, 25)
    GUICtrlSetOnEvent($BtnBlockScriptInterpretersOFF, "BlockScriptInterpretersOFF1")

   Local $labelListEnhanced = GUICtrlCreateLabel ("Enhanced", 220 + 25, 50+80, 90, 16,$SS_CENTER,-1)
    GUICtrlSetFont ( $labelListEnhanced, 10, 600)

    $BtnBlockSponsorsEnhancedON = GUICtrlCreateButton("ON", 250, 80+80, 40, 25)
    GUICtrlSetOnEvent($BtnBlockSponsorsEnhancedON, "BlockSponsorsEnhancedON1")

    $BtnBlockSponsorsEnhancedOFF = GUICtrlCreateButton("OFF", 295, 80+80, 40, 25)
    GUICtrlSetOnEvent($BtnBlockSponsorsEnhancedOFF, "BlockSponsorsEnhancedOFF1")



; Deselect All Button
    $BtnClearAll = GUICtrlCreateButton("Clear All", 50+200, 430-200, 85, 25)
    GUICtrlSetOnEvent($BtnClearAll, "AllowAllSponsors1")

; Select All Button
    $BtnSelectAll = GUICtrlCreateButton("Select All", 50+200, 460-200, 85, 25)
    GUICtrlSetOnEvent($BtnSelectAll, "BlockAllSponsors1")


;   Close Button
    $BtnCloseBlockSponsors = GUICtrlCreateButton("Close", 50+200, 490-100, 85, 25)
    GUICtrlSetOnEvent($BtnCloseBlockSponsors, "CloseBlockSponsors")

$BlockSponsorsGUI = GUICreate("Child GUI", 200, 400, 10, 10, $WS_CHILD, $WS_EX_CLIENTEDGE, $MainBlockSponsorsGUI)
;Opt("GUIOnEventMode", 1)
GUIRegisterMsg($WM_VSCROLL, "WM_VSCROLL")

; Set how long has to be the scroll window (is set as depending on the number of entries).
    _GUIScrollBars_Init ($BlockSponsorsGUI, -1, 135/100*$NumberOfExecutables)
    _GUIScrollBars_EnableScrollBar($BlockSponsorsGUI, $SB_HORZ, $ESB_DISABLE_LEFT)
    _GUIScrollBars_EnableScrollBar($BlockSponsorsGUI, $SB_HORZ, $ESB_DISABLE_RIGHT)

;************************
;   Create a checkbox controls.
;   Assign names of executables to array
    Arr_GetSponsorNames()
;   Create the Label
;    Local $labelList1 = GUICtrlCreateLabel ("   List nr 1", 20, 7, 100, 16,$SS_CENTER,-1)
;    GUICtrlSetFont ( $labelList1, 10, 600)

Local $arraySortedSponsors = $arrBlockSponsors
_ArrayDelete($arraySortedSponsors, 0)
_ArraySort($arraySortedSponsors)
;_ArrayDisplay($arraySortedSponsors)


;   Create checkboxes
    local $n_itemposition

    $idCheckboxCMD = GUICtrlCreateCheckbox("Cmd.exe", 10, 20 + 10, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlockCMD")    

    $idCheckboxPowerShell = GUICtrlCreateCheckbox("Powershell.exe", 10, 20 + 30, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlockPowerShell") 

    $idCheckboxPowerShell_ise = GUICtrlCreateCheckbox("Powershell_ise.exe", 10, 20 + 50, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlockPowerShell_ise")       
 
    $n_itemposition = SortedPosition($arrBlockSponsors[1], $arraySortedSponsors)
    $idCheckbox1 = GUICtrlCreateCheckbox($arrBlockSponsors[1], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock1")    

    $n_itemposition = SortedPosition($arrBlockSponsors[2], $arraySortedSponsors)
    $idCheckbox2 = GUICtrlCreateCheckbox($arrBlockSponsors[2], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock2")    

    $n_itemposition = SortedPosition($arrBlockSponsors[3], $arraySortedSponsors)
    $idCheckbox3 = GUICtrlCreateCheckbox($arrBlockSponsors[3], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock3")    

    $n_itemposition = SortedPosition($arrBlockSponsors[4], $arraySortedSponsors)
    $idCheckbox4 = GUICtrlCreateCheckbox($arrBlockSponsors[4], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock4")    

    $n_itemposition = SortedPosition($arrBlockSponsors[5], $arraySortedSponsors)
    $idCheckbox5 = GUICtrlCreateCheckbox($arrBlockSponsors[5], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock5")    

    $n_itemposition = SortedPosition($arrBlockSponsors[6], $arraySortedSponsors)
    $idCheckbox6 = GUICtrlCreateCheckbox($arrBlockSponsors[6], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock6")    

    $n_itemposition = SortedPosition($arrBlockSponsors[7], $arraySortedSponsors)
    $idCheckbox7 = GUICtrlCreateCheckbox($arrBlockSponsors[7], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock7")    

    $n_itemposition = SortedPosition($arrBlockSponsors[8], $arraySortedSponsors)
    $idCheckbox8 = GUICtrlCreateCheckbox($arrBlockSponsors[8], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock8")    

    $n_itemposition = SortedPosition($arrBlockSponsors[9], $arraySortedSponsors)
    $idCheckbox9 = GUICtrlCreateCheckbox($arrBlockSponsors[9], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock9")    

    $n_itemposition = SortedPosition($arrBlockSponsors[10], $arraySortedSponsors)
    $idCheckbox10 = GUICtrlCreateCheckbox($arrBlockSponsors[10], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock10")    

    $n_itemposition = SortedPosition($arrBlockSponsors[11], $arraySortedSponsors)
    $idCheckbox11 = GUICtrlCreateCheckbox($arrBlockSponsors[11], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock11")    

    $n_itemposition = SortedPosition($arrBlockSponsors[12], $arraySortedSponsors)
    $idCheckbox12 = GUICtrlCreateCheckbox($arrBlockSponsors[12], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock12")    

    $n_itemposition = SortedPosition($arrBlockSponsors[13], $arraySortedSponsors)
    $idCheckbox13 = GUICtrlCreateCheckbox($arrBlockSponsors[13], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock13")    

    $n_itemposition = SortedPosition($arrBlockSponsors[14], $arraySortedSponsors)
    $idCheckbox14 = GUICtrlCreateCheckbox($arrBlockSponsors[14], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock14")    

    $n_itemposition = SortedPosition($arrBlockSponsors[15], $arraySortedSponsors)
    $idCheckbox15 = GUICtrlCreateCheckbox($arrBlockSponsors[15], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock15")    

    $n_itemposition = SortedPosition($arrBlockSponsors[16], $arraySortedSponsors)
    $idCheckbox16 = GUICtrlCreateCheckbox($arrBlockSponsors[16], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock16")    

    $n_itemposition = SortedPosition($arrBlockSponsors[17], $arraySortedSponsors)
    $idCheckbox17 = GUICtrlCreateCheckbox($arrBlockSponsors[17], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock17")    

    $n_itemposition = SortedPosition($arrBlockSponsors[18], $arraySortedSponsors)
    $idCheckbox18 = GUICtrlCreateCheckbox($arrBlockSponsors[18], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock18")    

    $n_itemposition = SortedPosition($arrBlockSponsors[19], $arraySortedSponsors)
    $idCheckbox19 = GUICtrlCreateCheckbox($arrBlockSponsors[19], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock19")    

    $n_itemposition = SortedPosition($arrBlockSponsors[20], $arraySortedSponsors)
    $idCheckbox20 = GUICtrlCreateCheckbox($arrBlockSponsors[20], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock20")    

    $n_itemposition = SortedPosition($arrBlockSponsors[21], $arraySortedSponsors)
    $idCheckbox21 = GUICtrlCreateCheckbox($arrBlockSponsors[21], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock21")    

    $n_itemposition = SortedPosition($arrBlockSponsors[22], $arraySortedSponsors)
    $idCheckbox22 = GUICtrlCreateCheckbox($arrBlockSponsors[22], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock22")    

    $n_itemposition = SortedPosition($arrBlockSponsors[23], $arraySortedSponsors)
    $idCheckbox23 = GUICtrlCreateCheckbox($arrBlockSponsors[23], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock23")    

    $n_itemposition = SortedPosition($arrBlockSponsors[24], $arraySortedSponsors)
    $idCheckbox24 = GUICtrlCreateCheckbox($arrBlockSponsors[24], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock24")    

    $n_itemposition = SortedPosition($arrBlockSponsors[25], $arraySortedSponsors)
    $idCheckbox25 = GUICtrlCreateCheckbox($arrBlockSponsors[25], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock25")    

    $n_itemposition = SortedPosition($arrBlockSponsors[26], $arraySortedSponsors)
    $idCheckbox26 = GUICtrlCreateCheckbox($arrBlockSponsors[26], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock26")    

    $n_itemposition = SortedPosition($arrBlockSponsors[27], $arraySortedSponsors)
    $idCheckbox27 = GUICtrlCreateCheckbox($arrBlockSponsors[27], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock27")    

    $n_itemposition = SortedPosition($arrBlockSponsors[28], $arraySortedSponsors)
    $idCheckbox28 = GUICtrlCreateCheckbox($arrBlockSponsors[28], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock28")    

    $n_itemposition = SortedPosition($arrBlockSponsors[29], $arraySortedSponsors)
    $idCheckbox29 = GUICtrlCreateCheckbox($arrBlockSponsors[29], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock29")    

    $n_itemposition = SortedPosition($arrBlockSponsors[30], $arraySortedSponsors)
    $idCheckbox30 = GUICtrlCreateCheckbox($arrBlockSponsors[30], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock30")    

    $n_itemposition = SortedPosition($arrBlockSponsors[31], $arraySortedSponsors)
    $idCheckbox31 = GUICtrlCreateCheckbox($arrBlockSponsors[31], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock31")    

    $n_itemposition = SortedPosition($arrBlockSponsors[32], $arraySortedSponsors)
    $idCheckbox32 = GUICtrlCreateCheckbox($arrBlockSponsors[32], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock32")    

    $n_itemposition = SortedPosition($arrBlockSponsors[33], $arraySortedSponsors)
    $idCheckbox33 = GUICtrlCreateCheckbox($arrBlockSponsors[33], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock33")    

    $n_itemposition = SortedPosition($arrBlockSponsors[34], $arraySortedSponsors)
    $idCheckbox34 = GUICtrlCreateCheckbox($arrBlockSponsors[34], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock34")    

    $n_itemposition = SortedPosition($arrBlockSponsors[35], $arraySortedSponsors)
    $idCheckbox35 = GUICtrlCreateCheckbox($arrBlockSponsors[35], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock35")    

    $n_itemposition = SortedPosition($arrBlockSponsors[36], $arraySortedSponsors)
    $idCheckbox36 = GUICtrlCreateCheckbox($arrBlockSponsors[36], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock36")    

    $n_itemposition = SortedPosition($arrBlockSponsors[37], $arraySortedSponsors)
    $idCheckbox37 = GUICtrlCreateCheckbox($arrBlockSponsors[37], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock37")    

    $n_itemposition = SortedPosition($arrBlockSponsors[38], $arraySortedSponsors)
    $idCheckbox38 = GUICtrlCreateCheckbox($arrBlockSponsors[38], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock38")    

    $n_itemposition = SortedPosition($arrBlockSponsors[39], $arraySortedSponsors)
    $idCheckbox39 = GUICtrlCreateCheckbox($arrBlockSponsors[39], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock39")    

    $n_itemposition = SortedPosition($arrBlockSponsors[40], $arraySortedSponsors)
    $idCheckbox40 = GUICtrlCreateCheckbox($arrBlockSponsors[40], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock40")    

    $n_itemposition = SortedPosition($arrBlockSponsors[41], $arraySortedSponsors)
    $idCheckbox41 = GUICtrlCreateCheckbox($arrBlockSponsors[41], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock41")    

    $n_itemposition = SortedPosition($arrBlockSponsors[42], $arraySortedSponsors)
    $idCheckbox42 = GUICtrlCreateCheckbox($arrBlockSponsors[42], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock42")    

    $n_itemposition = SortedPosition($arrBlockSponsors[43], $arraySortedSponsors)
    $idCheckbox43 = GUICtrlCreateCheckbox($arrBlockSponsors[43], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock43")    

    $n_itemposition = SortedPosition($arrBlockSponsors[44], $arraySortedSponsors)
    $idCheckbox44 = GUICtrlCreateCheckbox($arrBlockSponsors[44], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock44")    

    $n_itemposition = SortedPosition($arrBlockSponsors[45], $arraySortedSponsors)
    $idCheckbox45 = GUICtrlCreateCheckbox($arrBlockSponsors[45], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock45")    

    $n_itemposition = SortedPosition($arrBlockSponsors[46], $arraySortedSponsors)
    $idCheckbox46 = GUICtrlCreateCheckbox($arrBlockSponsors[46], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock46")    

    $n_itemposition = SortedPosition($arrBlockSponsors[47], $arraySortedSponsors)
    $idCheckbox47 = GUICtrlCreateCheckbox($arrBlockSponsors[47], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock47")    

    $n_itemposition = SortedPosition($arrBlockSponsors[48], $arraySortedSponsors)
    $idCheckbox48 = GUICtrlCreateCheckbox($arrBlockSponsors[48], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock48")    

    $n_itemposition = SortedPosition($arrBlockSponsors[49], $arraySortedSponsors)
    $idCheckbox49 = GUICtrlCreateCheckbox($arrBlockSponsors[49], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock49")    

    $n_itemposition = SortedPosition($arrBlockSponsors[50], $arraySortedSponsors)
    $idCheckbox50 = GUICtrlCreateCheckbox($arrBlockSponsors[50], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock50")    

    $n_itemposition = SortedPosition($arrBlockSponsors[51], $arraySortedSponsors)
    $idCheckbox51 = GUICtrlCreateCheckbox($arrBlockSponsors[51], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock51")    

    $n_itemposition = SortedPosition($arrBlockSponsors[52], $arraySortedSponsors)
    $idCheckbox52 = GUICtrlCreateCheckbox($arrBlockSponsors[52], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock52")    

    $n_itemposition = SortedPosition($arrBlockSponsors[53], $arraySortedSponsors)
    $idCheckbox53 = GUICtrlCreateCheckbox($arrBlockSponsors[53], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock53")    

    $n_itemposition = SortedPosition($arrBlockSponsors[54], $arraySortedSponsors)
    $idCheckbox54 = GUICtrlCreateCheckbox($arrBlockSponsors[54], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock54")  



;The second list
;    Local $labelList2 = GUICtrlCreateLabel ("   List nr 2", 20, 65 + 50 + 20*54, 100, 16,$SS_CENTER,-1)
;    GUICtrlSetFont ( $labelList2, 10, 600)

    $n_itemposition = SortedPosition($arrBlockSponsors[55], $arraySortedSponsors)
    $idCheckbox55 = GUICtrlCreateCheckbox($arrBlockSponsors[55], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock55")  

    $n_itemposition = SortedPosition($arrBlockSponsors[56], $arraySortedSponsors)
    $idCheckbox56 = GUICtrlCreateCheckbox($arrBlockSponsors[56], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock56")  

    $n_itemposition = SortedPosition($arrBlockSponsors[57], $arraySortedSponsors)
    $idCheckbox57 = GUICtrlCreateCheckbox($arrBlockSponsors[57], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock57")  

    $n_itemposition = SortedPosition($arrBlockSponsors[58], $arraySortedSponsors)
    $idCheckbox58 = GUICtrlCreateCheckbox($arrBlockSponsors[58], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock58")  

    $n_itemposition = SortedPosition($arrBlockSponsors[59], $arraySortedSponsors)
    $idCheckbox59 = GUICtrlCreateCheckbox($arrBlockSponsors[59], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock59")  

    $n_itemposition = SortedPosition($arrBlockSponsors[60], $arraySortedSponsors)
    $idCheckbox60 = GUICtrlCreateCheckbox($arrBlockSponsors[60], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock60")  

    $n_itemposition = SortedPosition($arrBlockSponsors[61], $arraySortedSponsors)
    $idCheckbox61 = GUICtrlCreateCheckbox($arrBlockSponsors[61], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock61")  

    $n_itemposition = SortedPosition($arrBlockSponsors[62], $arraySortedSponsors)
    $idCheckbox62 = GUICtrlCreateCheckbox($arrBlockSponsors[62], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock62")  

    $n_itemposition = SortedPosition($arrBlockSponsors[63], $arraySortedSponsors)
    $idCheckbox63 = GUICtrlCreateCheckbox($arrBlockSponsors[63], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock63")  

    $n_itemposition = SortedPosition($arrBlockSponsors[64], $arraySortedSponsors)
    $idCheckbox64 = GUICtrlCreateCheckbox($arrBlockSponsors[64], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock64")  

    $n_itemposition = SortedPosition($arrBlockSponsors[65], $arraySortedSponsors)
    $idCheckbox65 = GUICtrlCreateCheckbox($arrBlockSponsors[65], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock65")  

    $n_itemposition = SortedPosition($arrBlockSponsors[66], $arraySortedSponsors)
    $idCheckbox66 = GUICtrlCreateCheckbox($arrBlockSponsors[66], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock66")  

    $n_itemposition = SortedPosition($arrBlockSponsors[67], $arraySortedSponsors)
    $idCheckbox67 = GUICtrlCreateCheckbox($arrBlockSponsors[67], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock67")  

    $n_itemposition = SortedPosition($arrBlockSponsors[68], $arraySortedSponsors)
    $idCheckbox68 = GUICtrlCreateCheckbox($arrBlockSponsors[68], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock68")  

    $n_itemposition = SortedPosition($arrBlockSponsors[69], $arraySortedSponsors)
    $idCheckbox69 = GUICtrlCreateCheckbox($arrBlockSponsors[69], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock69")  

    $n_itemposition = SortedPosition($arrBlockSponsors[70], $arraySortedSponsors)
    $idCheckbox70 = GUICtrlCreateCheckbox($arrBlockSponsors[70], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock70")  

    $n_itemposition = SortedPosition($arrBlockSponsors[71], $arraySortedSponsors)
    $idCheckbox71 = GUICtrlCreateCheckbox($arrBlockSponsors[71], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock71")  

    $n_itemposition = SortedPosition($arrBlockSponsors[72], $arraySortedSponsors)
    $idCheckbox72 = GUICtrlCreateCheckbox($arrBlockSponsors[72], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock72")  

    $n_itemposition = SortedPosition($arrBlockSponsors[73], $arraySortedSponsors)
    $idCheckbox73 = GUICtrlCreateCheckbox($arrBlockSponsors[73], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock73")  

    $n_itemposition = SortedPosition($arrBlockSponsors[74], $arraySortedSponsors)
    $idCheckbox74 = GUICtrlCreateCheckbox($arrBlockSponsors[74], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock74")  

    $n_itemposition = SortedPosition($arrBlockSponsors[75], $arraySortedSponsors)
    $idCheckbox75 = GUICtrlCreateCheckbox($arrBlockSponsors[75], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock75")  

    $n_itemposition = SortedPosition($arrBlockSponsors[76], $arraySortedSponsors)
    $idCheckbox76 = GUICtrlCreateCheckbox($arrBlockSponsors[76], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock76")  

    $n_itemposition = SortedPosition($arrBlockSponsors[77], $arraySortedSponsors)
    $idCheckbox77 = GUICtrlCreateCheckbox($arrBlockSponsors[77], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock77")  

    $n_itemposition = SortedPosition($arrBlockSponsors[78], $arraySortedSponsors)
    $idCheckbox78 = GUICtrlCreateCheckbox($arrBlockSponsors[78], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock78")  

    $n_itemposition = SortedPosition($arrBlockSponsors[79], $arraySortedSponsors)
    $idCheckbox79 = GUICtrlCreateCheckbox($arrBlockSponsors[79], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock79")  

    $n_itemposition = SortedPosition($arrBlockSponsors[80], $arraySortedSponsors)
    $idCheckbox80 = GUICtrlCreateCheckbox($arrBlockSponsors[80], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock80")  

    $n_itemposition = SortedPosition($arrBlockSponsors[81], $arraySortedSponsors)
    $idCheckbox81 = GUICtrlCreateCheckbox($arrBlockSponsors[81], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock81")  

    $n_itemposition = SortedPosition($arrBlockSponsors[82], $arraySortedSponsors)
    $idCheckbox82 = GUICtrlCreateCheckbox($arrBlockSponsors[82], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock82")  

    $n_itemposition = SortedPosition($arrBlockSponsors[83], $arraySortedSponsors)
    $idCheckbox83 = GUICtrlCreateCheckbox($arrBlockSponsors[83], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock83")  

    $n_itemposition = SortedPosition($arrBlockSponsors[84], $arraySortedSponsors)
    $idCheckbox84 = GUICtrlCreateCheckbox($arrBlockSponsors[84], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock84")  

    $n_itemposition = SortedPosition($arrBlockSponsors[85], $arraySortedSponsors)
    $idCheckbox85 = GUICtrlCreateCheckbox($arrBlockSponsors[85], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock85")  

    $n_itemposition = SortedPosition($arrBlockSponsors[86], $arraySortedSponsors)
    $idCheckbox86 = GUICtrlCreateCheckbox($arrBlockSponsors[86], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock86")  

    $n_itemposition = SortedPosition($arrBlockSponsors[87], $arraySortedSponsors)
    $idCheckbox87 = GUICtrlCreateCheckbox($arrBlockSponsors[87], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock87")  

    $n_itemposition = SortedPosition($arrBlockSponsors[88], $arraySortedSponsors)
    $idCheckbox88 = GUICtrlCreateCheckbox($arrBlockSponsors[88], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock88")  

    $n_itemposition = SortedPosition($arrBlockSponsors[89], $arraySortedSponsors)
    $idCheckbox89 = GUICtrlCreateCheckbox($arrBlockSponsors[89], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock89")  

    $n_itemposition = SortedPosition($arrBlockSponsors[90], $arraySortedSponsors)
    $idCheckbox90 = GUICtrlCreateCheckbox($arrBlockSponsors[90], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock90")  

    $n_itemposition = SortedPosition($arrBlockSponsors[91], $arraySortedSponsors)
    $idCheckbox91 = GUICtrlCreateCheckbox($arrBlockSponsors[91], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock91")  

    $n_itemposition = SortedPosition($arrBlockSponsors[92], $arraySortedSponsors)
    $idCheckbox92 = GUICtrlCreateCheckbox($arrBlockSponsors[92], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock92")  

    $n_itemposition = SortedPosition($arrBlockSponsors[93], $arraySortedSponsors)
    $idCheckbox93 = GUICtrlCreateCheckbox($arrBlockSponsors[93], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock93")  

    $n_itemposition = SortedPosition($arrBlockSponsors[94], $arraySortedSponsors)
    $idCheckbox94 = GUICtrlCreateCheckbox($arrBlockSponsors[94], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock94")  

    $n_itemposition = SortedPosition($arrBlockSponsors[95], $arraySortedSponsors)
    $idCheckbox95 = GUICtrlCreateCheckbox($arrBlockSponsors[95], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock95")  

    $n_itemposition = SortedPosition($arrBlockSponsors[96], $arraySortedSponsors)
    $idCheckbox96 = GUICtrlCreateCheckbox($arrBlockSponsors[96], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock96")  

    $n_itemposition = SortedPosition($arrBlockSponsors[97], $arraySortedSponsors)
    $idCheckbox97 = GUICtrlCreateCheckbox($arrBlockSponsors[97], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock97")  

    $n_itemposition = SortedPosition($arrBlockSponsors[98], $arraySortedSponsors)
    $idCheckbox98 = GUICtrlCreateCheckbox($arrBlockSponsors[98], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock98")  

    $n_itemposition = SortedPosition($arrBlockSponsors[99], $arraySortedSponsors)
    $idCheckbox99 = GUICtrlCreateCheckbox($arrBlockSponsors[99], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock99")  

    $n_itemposition = SortedPosition($arrBlockSponsors[100], $arraySortedSponsors)
    $idCheckbox100 = GUICtrlCreateCheckbox($arrBlockSponsors[100], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock100")  

    $n_itemposition = SortedPosition($arrBlockSponsors[101], $arraySortedSponsors)
    $idCheckbox101 = GUICtrlCreateCheckbox($arrBlockSponsors[101], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock101")  

    $n_itemposition = SortedPosition($arrBlockSponsors[102], $arraySortedSponsors)
    $idCheckbox102 = GUICtrlCreateCheckbox($arrBlockSponsors[102], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock102")  

    $n_itemposition = SortedPosition($arrBlockSponsors[103], $arraySortedSponsors)
    $idCheckbox103 = GUICtrlCreateCheckbox($arrBlockSponsors[103], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock103")  

    $n_itemposition = SortedPosition($arrBlockSponsors[104], $arraySortedSponsors)
    $idCheckbox104 = GUICtrlCreateCheckbox($arrBlockSponsors[104], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock104")  

    $n_itemposition = SortedPosition($arrBlockSponsors[105], $arraySortedSponsors)
    $idCheckbox105 = GUICtrlCreateCheckbox($arrBlockSponsors[105], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock105")  

    $n_itemposition = SortedPosition($arrBlockSponsors[106], $arraySortedSponsors)
    $idCheckbox106 = GUICtrlCreateCheckbox($arrBlockSponsors[106], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock106")  

    $n_itemposition = SortedPosition($arrBlockSponsors[107], $arraySortedSponsors)
    $idCheckbox107 = GUICtrlCreateCheckbox($arrBlockSponsors[107], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock107")  

    $n_itemposition = SortedPosition($arrBlockSponsors[108], $arraySortedSponsors)
    $idCheckbox108 = GUICtrlCreateCheckbox($arrBlockSponsors[108], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock108")

    $n_itemposition = SortedPosition($arrBlockSponsors[109], $arraySortedSponsors)
    $idCheckbox109 = GUICtrlCreateCheckbox($arrBlockSponsors[109], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock109")  

    $n_itemposition = SortedPosition($arrBlockSponsors[110], $arraySortedSponsors)
    $idCheckbox110 = GUICtrlCreateCheckbox($arrBlockSponsors[110], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock110")  

    $n_itemposition = SortedPosition($arrBlockSponsors[111], $arraySortedSponsors)
    $idCheckbox111 = GUICtrlCreateCheckbox($arrBlockSponsors[111], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock111")  

    $n_itemposition = SortedPosition($arrBlockSponsors[112], $arraySortedSponsors)
    $idCheckbox112 = GUICtrlCreateCheckbox($arrBlockSponsors[112], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock112")  

    $n_itemposition = SortedPosition($arrBlockSponsors[113], $arraySortedSponsors)
    $idCheckbox113 = GUICtrlCreateCheckbox($arrBlockSponsors[113], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock113")  

    $n_itemposition = SortedPosition($arrBlockSponsors[114], $arraySortedSponsors)
    $idCheckbox114 = GUICtrlCreateCheckbox($arrBlockSponsors[114], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock114")  

    $n_itemposition = SortedPosition($arrBlockSponsors[115], $arraySortedSponsors)
    $idCheckbox115 = GUICtrlCreateCheckbox($arrBlockSponsors[115], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock115")  

    $n_itemposition = SortedPosition($arrBlockSponsors[116], $arraySortedSponsors)
    $idCheckbox116 = GUICtrlCreateCheckbox($arrBlockSponsors[116], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock116")  

    $n_itemposition = SortedPosition($arrBlockSponsors[117], $arraySortedSponsors)
    $idCheckbox117 = GUICtrlCreateCheckbox($arrBlockSponsors[117], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock117")  

    $n_itemposition = SortedPosition($arrBlockSponsors[118], $arraySortedSponsors)
    $idCheckbox118 = GUICtrlCreateCheckbox($arrBlockSponsors[118], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock118")  

    $n_itemposition = SortedPosition($arrBlockSponsors[119], $arraySortedSponsors)
    $idCheckbox119 = GUICtrlCreateCheckbox($arrBlockSponsors[119], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock119")  

    $n_itemposition = SortedPosition($arrBlockSponsors[120], $arraySortedSponsors)
    $idCheckbox120 = GUICtrlCreateCheckbox($arrBlockSponsors[120], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock120")  

    $n_itemposition = SortedPosition($arrBlockSponsors[121], $arraySortedSponsors)
    $idCheckbox121 = GUICtrlCreateCheckbox($arrBlockSponsors[121], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock121")  

    $n_itemposition = SortedPosition($arrBlockSponsors[122], $arraySortedSponsors)
    $idCheckbox122 = GUICtrlCreateCheckbox($arrBlockSponsors[122], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock122")  

    $n_itemposition = SortedPosition($arrBlockSponsors[123], $arraySortedSponsors)
    $idCheckbox123 = GUICtrlCreateCheckbox($arrBlockSponsors[123], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock123")  

    $n_itemposition = SortedPosition($arrBlockSponsors[124], $arraySortedSponsors)
    $idCheckbox124 = GUICtrlCreateCheckbox($arrBlockSponsors[124], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock124")  

    $n_itemposition = SortedPosition($arrBlockSponsors[125], $arraySortedSponsors)
    $idCheckbox125 = GUICtrlCreateCheckbox($arrBlockSponsors[125], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock125")  

    $n_itemposition = SortedPosition($arrBlockSponsors[126], $arraySortedSponsors)
    $idCheckbox126 = GUICtrlCreateCheckbox($arrBlockSponsors[126], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock126")  

    $n_itemposition = SortedPosition($arrBlockSponsors[127], $arraySortedSponsors)
    $idCheckbox127 = GUICtrlCreateCheckbox($arrBlockSponsors[127], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock127")  

    $n_itemposition = SortedPosition($arrBlockSponsors[128], $arraySortedSponsors)
    $idCheckbox128 = GUICtrlCreateCheckbox($arrBlockSponsors[128], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock128")  

    $n_itemposition = SortedPosition($arrBlockSponsors[129], $arraySortedSponsors)
    $idCheckbox129 = GUICtrlCreateCheckbox($arrBlockSponsors[129], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock129")  

    $n_itemposition = SortedPosition($arrBlockSponsors[130], $arraySortedSponsors)
    $idCheckbox130 = GUICtrlCreateCheckbox($arrBlockSponsors[130], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock130")  

    $n_itemposition = SortedPosition($arrBlockSponsors[131], $arraySortedSponsors)
    $idCheckbox131 = GUICtrlCreateCheckbox($arrBlockSponsors[131], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock131")  

    $n_itemposition = SortedPosition($arrBlockSponsors[132], $arraySortedSponsors)
    $idCheckbox132 = GUICtrlCreateCheckbox($arrBlockSponsors[132], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock132")  

    $n_itemposition = SortedPosition($arrBlockSponsors[133], $arraySortedSponsors)
    $idCheckbox133 = GUICtrlCreateCheckbox($arrBlockSponsors[133], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock133")  

    $n_itemposition = SortedPosition($arrBlockSponsors[134], $arraySortedSponsors)
    $idCheckbox134 = GUICtrlCreateCheckbox($arrBlockSponsors[134], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock134")  

    $n_itemposition = SortedPosition($arrBlockSponsors[135], $arraySortedSponsors)
    $idCheckbox135 = GUICtrlCreateCheckbox($arrBlockSponsors[135], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock135")  

    $n_itemposition = SortedPosition($arrBlockSponsors[136], $arraySortedSponsors)
    $idCheckbox136 = GUICtrlCreateCheckbox($arrBlockSponsors[136], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock136")  

    $n_itemposition = SortedPosition($arrBlockSponsors[137], $arraySortedSponsors)
    $idCheckbox137 = GUICtrlCreateCheckbox($arrBlockSponsors[137], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock137")  

    $n_itemposition = SortedPosition($arrBlockSponsors[138], $arraySortedSponsors)
    $idCheckbox138 = GUICtrlCreateCheckbox($arrBlockSponsors[138], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock138")  

    $n_itemposition = SortedPosition($arrBlockSponsors[139], $arraySortedSponsors)
    $idCheckbox139 = GUICtrlCreateCheckbox($arrBlockSponsors[139], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock139")  

    $n_itemposition = SortedPosition($arrBlockSponsors[140], $arraySortedSponsors)
    $idCheckbox140 = GUICtrlCreateCheckbox($arrBlockSponsors[140], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock140")  

    $n_itemposition = SortedPosition($arrBlockSponsors[141], $arraySortedSponsors)
    $idCheckbox141 = GUICtrlCreateCheckbox($arrBlockSponsors[141], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock141")  

    $n_itemposition = SortedPosition($arrBlockSponsors[142], $arraySortedSponsors)
    $idCheckbox142 = GUICtrlCreateCheckbox($arrBlockSponsors[142], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock142")  

    $n_itemposition = SortedPosition($arrBlockSponsors[143], $arraySortedSponsors)
    $idCheckbox143 = GUICtrlCreateCheckbox($arrBlockSponsors[143], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock143")  

    $n_itemposition = SortedPosition($arrBlockSponsors[144], $arraySortedSponsors)
    $idCheckbox144 = GUICtrlCreateCheckbox($arrBlockSponsors[144], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock144")  

    $n_itemposition = SortedPosition($arrBlockSponsors[145], $arraySortedSponsors)
    $idCheckbox145 = GUICtrlCreateCheckbox($arrBlockSponsors[145], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock145")  

    $n_itemposition = SortedPosition($arrBlockSponsors[146], $arraySortedSponsors)
    $idCheckbox146 = GUICtrlCreateCheckbox($arrBlockSponsors[146], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock146")  

    $n_itemposition = SortedPosition($arrBlockSponsors[147], $arraySortedSponsors)
    $idCheckbox147 = GUICtrlCreateCheckbox($arrBlockSponsors[147], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock147")  

    $n_itemposition = SortedPosition($arrBlockSponsors[148], $arraySortedSponsors)
    $idCheckbox148 = GUICtrlCreateCheckbox($arrBlockSponsors[148], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock148")  

    $n_itemposition = SortedPosition($arrBlockSponsors[149], $arraySortedSponsors)
    $idCheckbox149 = GUICtrlCreateCheckbox($arrBlockSponsors[149], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock149")  

    $n_itemposition = SortedPosition($arrBlockSponsors[150], $arraySortedSponsors)
    $idCheckbox150 = GUICtrlCreateCheckbox($arrBlockSponsors[150], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock150")  

    $n_itemposition = SortedPosition($arrBlockSponsors[151], $arraySortedSponsors)
    $idCheckbox151 = GUICtrlCreateCheckbox($arrBlockSponsors[151], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock151")  

    $n_itemposition = SortedPosition($arrBlockSponsors[152], $arraySortedSponsors)
    $idCheckbox152 = GUICtrlCreateCheckbox($arrBlockSponsors[152], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock152")  

    $n_itemposition = SortedPosition($arrBlockSponsors[153], $arraySortedSponsors)
    $idCheckbox153 = GUICtrlCreateCheckbox($arrBlockSponsors[153], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock153")  

    $n_itemposition = SortedPosition($arrBlockSponsors[154], $arraySortedSponsors)
    $idCheckbox154 = GUICtrlCreateCheckbox($arrBlockSponsors[154], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock154")  

    $n_itemposition = SortedPosition($arrBlockSponsors[155], $arraySortedSponsors)
    $idCheckbox155 = GUICtrlCreateCheckbox($arrBlockSponsors[155], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock155")

    $n_itemposition = SortedPosition($arrBlockSponsors[156], $arraySortedSponsors)
    $idCheckbox156 = GUICtrlCreateCheckbox($arrBlockSponsors[156], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock156")  

    $n_itemposition = SortedPosition($arrBlockSponsors[157], $arraySortedSponsors)
    $idCheckbox157 = GUICtrlCreateCheckbox($arrBlockSponsors[157], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock157")  

    $n_itemposition = SortedPosition($arrBlockSponsors[158], $arraySortedSponsors)
    $idCheckbox158 = GUICtrlCreateCheckbox($arrBlockSponsors[158], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock158")  

    $n_itemposition = SortedPosition($arrBlockSponsors[159], $arraySortedSponsors)
    $idCheckbox159 = GUICtrlCreateCheckbox($arrBlockSponsors[159], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock159")  

    $n_itemposition = SortedPosition($arrBlockSponsors[160], $arraySortedSponsors)
    $idCheckbox160 = GUICtrlCreateCheckbox($arrBlockSponsors[160], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock160")  

    $n_itemposition = SortedPosition($arrBlockSponsors[161], $arraySortedSponsors)
    $idCheckbox161 = GUICtrlCreateCheckbox($arrBlockSponsors[161], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock161")  

    $n_itemposition = SortedPosition($arrBlockSponsors[162], $arraySortedSponsors)
    $idCheckbox162 = GUICtrlCreateCheckbox($arrBlockSponsors[162], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock162")  

    $n_itemposition = SortedPosition($arrBlockSponsors[163], $arraySortedSponsors)
    $idCheckbox163 = GUICtrlCreateCheckbox($arrBlockSponsors[163], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock163")  

    $n_itemposition = SortedPosition($arrBlockSponsors[164], $arraySortedSponsors)
    $idCheckbox164 = GUICtrlCreateCheckbox($arrBlockSponsors[164], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock164")  

    $n_itemposition = SortedPosition($arrBlockSponsors[165], $arraySortedSponsors)
    $idCheckbox165 = GUICtrlCreateCheckbox($arrBlockSponsors[165], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock165")  

    $n_itemposition = SortedPosition($arrBlockSponsors[166], $arraySortedSponsors)
    $idCheckbox166 = GUICtrlCreateCheckbox($arrBlockSponsors[166], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock166")  

    $n_itemposition = SortedPosition($arrBlockSponsors[167], $arraySortedSponsors)
    $idCheckbox167 = GUICtrlCreateCheckbox($arrBlockSponsors[167], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock167")  

    $n_itemposition = SortedPosition($arrBlockSponsors[168], $arraySortedSponsors)
    $idCheckbox168 = GUICtrlCreateCheckbox($arrBlockSponsors[168], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock168")  

    $n_itemposition = SortedPosition($arrBlockSponsors[169], $arraySortedSponsors)
    $idCheckbox169 = GUICtrlCreateCheckbox($arrBlockSponsors[169], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock169")  

    $n_itemposition = SortedPosition($arrBlockSponsors[170], $arraySortedSponsors)
    $idCheckbox170 = GUICtrlCreateCheckbox($arrBlockSponsors[170], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock170")  

    $n_itemposition = SortedPosition($arrBlockSponsors[171], $arraySortedSponsors)
    $idCheckbox171 = GUICtrlCreateCheckbox($arrBlockSponsors[171], 10, 20 + 50 + 20*$n_itemposition, 185, 25)
    GUICtrlSetOnEvent(-1, "_CheckBoxSponsorBlock171")

;   Checking the state of checkboxes
    CheckStateOfSponsorsCheckboxes()

;   Display the GUI.
    GUISetState(@SW_SHOW, $MainBlockSponsorsGUI)
    GUISetState(@SW_SHOW, $BlockSponsorsGUI)

EndFunc   ;==>CheckBoxBlockSponsors

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked


;*************
Func _CheckBoxSponsorBlockCMD()
   BlockSponsors('cmd.exe', 'Windows CMD', 'IsCMDBlocked', '{1016bbe0-a716-428b-822e-5E544B6A3102}')
EndFunc

Func _CheckBoxSponsorBlockPowerShell()
   BlockSponsors('powershell.exe', 'PowerShell', 'IsPowerShellBlocked', '{1016bbe0-a716-428b-822e-5E544B6A3100}')
EndFunc

Func _CheckBoxSponsorBlockPowerShell_ise()
   BlockSponsors('powershell_ise.exe', 'PowerShell_ise', 'IsPowerShell_iseBlocked', '{1016bbe0-a716-428b-822e-5E544B6A3101}')
EndFunc

Func _CheckBoxSponsorBlock1()
   BlockSponsors($arrBlockSponsors[1], $arrBlockSponsors[1], 'Is' & $arrBlockSponsors[1] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3103}')
EndFunc

Func _CheckBoxSponsorBlock2()
   BlockSponsors($arrBlockSponsors[2], $arrBlockSponsors[2], 'Is' & $arrBlockSponsors[2] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3104}')
EndFunc

Func _CheckBoxSponsorBlock3()
   BlockSponsors($arrBlockSponsors[3], $arrBlockSponsors[3], 'Is' & $arrBlockSponsors[3] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3105}')
EndFunc

Func _CheckBoxSponsorBlock4()
   BlockSponsors($arrBlockSponsors[4], $arrBlockSponsors[4], 'Is' & $arrBlockSponsors[4] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3106}')
EndFunc

Func _CheckBoxSponsorBlock5()
   BlockSponsors($arrBlockSponsors[5], $arrBlockSponsors[5], 'Is' & $arrBlockSponsors[5] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3107}')
EndFunc

Func _CheckBoxSponsorBlock6()
   BlockSponsors($arrBlockSponsors[6], $arrBlockSponsors[6], 'Is' & $arrBlockSponsors[6] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3108}')
EndFunc

Func _CheckBoxSponsorBlock7()
   BlockSponsors($arrBlockSponsors[7], $arrBlockSponsors[7], 'Is' & $arrBlockSponsors[7] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3109}')
EndFunc

Func _CheckBoxSponsorBlock8()
   BlockSponsors($arrBlockSponsors[8], $arrBlockSponsors[8], 'Is' & $arrBlockSponsors[8] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3110}')
EndFunc

Func _CheckBoxSponsorBlock9()
   BlockSponsors($arrBlockSponsors[9], $arrBlockSponsors[9], 'Is' & $arrBlockSponsors[9] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3111}')
EndFunc

Func _CheckBoxSponsorBlock10()
   BlockSponsors($arrBlockSponsors[10], $arrBlockSponsors[10], 'Is' & $arrBlockSponsors[10] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3112}')
EndFunc

Func _CheckBoxSponsorBlock11()
   BlockSponsors($arrBlockSponsors[11], $arrBlockSponsors[11], 'Is' & $arrBlockSponsors[11] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3113}')
EndFunc

Func _CheckBoxSponsorBlock12()
   BlockSponsors($arrBlockSponsors[12], $arrBlockSponsors[12], 'Is' & $arrBlockSponsors[12] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3114}')
EndFunc

Func _CheckBoxSponsorBlock13()
   BlockSponsors($arrBlockSponsors[13], $arrBlockSponsors[13], 'Is' & $arrBlockSponsors[13] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3115}')
EndFunc

Func _CheckBoxSponsorBlock14()
   BlockSponsors($arrBlockSponsors[14], $arrBlockSponsors[14], 'Is' & $arrBlockSponsors[14] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3116}')
EndFunc

Func _CheckBoxSponsorBlock15()
   BlockSponsors($arrBlockSponsors[15], $arrBlockSponsors[15], 'Is' & $arrBlockSponsors[15] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3117}')
EndFunc

Func _CheckBoxSponsorBlock16()
   BlockSponsors($arrBlockSponsors[16], $arrBlockSponsors[16], 'Is' & $arrBlockSponsors[16] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3118}')
EndFunc

Func _CheckBoxSponsorBlock17()
   BlockSponsors($arrBlockSponsors[17], $arrBlockSponsors[17], 'Is' & $arrBlockSponsors[17] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3119}')
EndFunc

Func _CheckBoxSponsorBlock18()
   BlockSponsors($arrBlockSponsors[18], $arrBlockSponsors[18], 'Is' & $arrBlockSponsors[18] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3120}')
EndFunc

Func _CheckBoxSponsorBlock19()
   BlockSponsors($arrBlockSponsors[19], $arrBlockSponsors[19], 'Is' & $arrBlockSponsors[19] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3121}')
EndFunc

Func _CheckBoxSponsorBlock20()
   BlockSponsors($arrBlockSponsors[20], $arrBlockSponsors[20], 'Is' & $arrBlockSponsors[20] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3122}')
EndFunc

Func _CheckBoxSponsorBlock21()
   BlockSponsors($arrBlockSponsors[21], $arrBlockSponsors[21], 'Is' & $arrBlockSponsors[21] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3123}')
EndFunc

Func _CheckBoxSponsorBlock22()
   BlockSponsors($arrBlockSponsors[22], $arrBlockSponsors[22], 'Is' & $arrBlockSponsors[22] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3124}')
EndFunc

Func _CheckBoxSponsorBlock23()
   BlockSponsors($arrBlockSponsors[23], $arrBlockSponsors[23], 'Is' & $arrBlockSponsors[23] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3125}')
EndFunc

Func _CheckBoxSponsorBlock24()
   BlockSponsors($arrBlockSponsors[24], $arrBlockSponsors[24], 'Is' & $arrBlockSponsors[24] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3126}')
EndFunc

Func _CheckBoxSponsorBlock25()
   BlockSponsors($arrBlockSponsors[25], $arrBlockSponsors[25], 'Is' & $arrBlockSponsors[25] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3127}')
EndFunc

Func _CheckBoxSponsorBlock26()
   BlockSponsors($arrBlockSponsors[26], $arrBlockSponsors[26], 'Is' & $arrBlockSponsors[26] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3128}')
EndFunc

Func _CheckBoxSponsorBlock27()
   BlockSponsors($arrBlockSponsors[27], $arrBlockSponsors[27], 'Is' & $arrBlockSponsors[27] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3129}')
EndFunc

Func _CheckBoxSponsorBlock28()
   BlockSponsors($arrBlockSponsors[28], $arrBlockSponsors[28], 'Is' & $arrBlockSponsors[28] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3130}')
EndFunc

Func _CheckBoxSponsorBlock29()
   BlockSponsors($arrBlockSponsors[29], $arrBlockSponsors[29], 'Is' & $arrBlockSponsors[29] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3131}')
EndFunc

Func _CheckBoxSponsorBlock30()
   BlockSponsors($arrBlockSponsors[30], $arrBlockSponsors[30], 'Is' & $arrBlockSponsors[30] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3132}')
EndFunc

Func _CheckBoxSponsorBlock31()
   BlockSponsors($arrBlockSponsors[31], $arrBlockSponsors[31], 'Is' & $arrBlockSponsors[31] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3133}')
EndFunc

Func _CheckBoxSponsorBlock32()
   BlockSponsors($arrBlockSponsors[32], $arrBlockSponsors[32], 'Is' & $arrBlockSponsors[32] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3134}')
EndFunc

Func _CheckBoxSponsorBlock33()
   BlockSponsors($arrBlockSponsors[33], $arrBlockSponsors[33], 'Is' & $arrBlockSponsors[33] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3135}')
EndFunc

Func _CheckBoxSponsorBlock34()
   BlockSponsors($arrBlockSponsors[34], $arrBlockSponsors[34], 'Is' & $arrBlockSponsors[34] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3136}')
EndFunc

Func _CheckBoxSponsorBlock35()
   BlockSponsors($arrBlockSponsors[35], $arrBlockSponsors[35], 'Is' & $arrBlockSponsors[35] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3137}')
EndFunc

Func _CheckBoxSponsorBlock36()
   BlockSponsors($arrBlockSponsors[36], $arrBlockSponsors[36], 'Is' & $arrBlockSponsors[36] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3138}')
EndFunc

Func _CheckBoxSponsorBlock37()
   BlockSponsors($arrBlockSponsors[37], $arrBlockSponsors[37], 'Is' & $arrBlockSponsors[37] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3139}')
EndFunc

Func _CheckBoxSponsorBlock38()
   BlockSponsors($arrBlockSponsors[38], $arrBlockSponsors[38], 'Is' & $arrBlockSponsors[38] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3140}')
EndFunc

Func _CheckBoxSponsorBlock39()
   BlockSponsors($arrBlockSponsors[39], $arrBlockSponsors[39], 'Is' & $arrBlockSponsors[39] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3141}')
EndFunc

Func _CheckBoxSponsorBlock40()
   BlockSponsors($arrBlockSponsors[40], $arrBlockSponsors[40], 'Is' & $arrBlockSponsors[40] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3142}')
EndFunc

Func _CheckBoxSponsorBlock41()
   BlockSponsors($arrBlockSponsors[41], $arrBlockSponsors[41], 'Is' & $arrBlockSponsors[41] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3143}')
EndFunc

Func _CheckBoxSponsorBlock42()
   BlockSponsors($arrBlockSponsors[42], $arrBlockSponsors[42], 'Is' & $arrBlockSponsors[42] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3144}')
EndFunc

Func _CheckBoxSponsorBlock43()
   BlockSponsors($arrBlockSponsors[43], $arrBlockSponsors[43], 'Is' & $arrBlockSponsors[43] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3145}')
EndFunc

Func _CheckBoxSponsorBlock44()
   BlockSponsors($arrBlockSponsors[44], $arrBlockSponsors[44], 'Is' & $arrBlockSponsors[44] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3146}')
EndFunc

Func _CheckBoxSponsorBlock45()
   BlockSponsors($arrBlockSponsors[45], $arrBlockSponsors[45], 'Is' & $arrBlockSponsors[45] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3147}')
EndFunc

Func _CheckBoxSponsorBlock46()
   BlockSponsors($arrBlockSponsors[46], $arrBlockSponsors[46], 'Is' & $arrBlockSponsors[46] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3148}')
EndFunc

Func _CheckBoxSponsorBlock47()
   BlockSponsors($arrBlockSponsors[47], $arrBlockSponsors[47], 'Is' & $arrBlockSponsors[47] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3149}')
EndFunc

Func _CheckBoxSponsorBlock48()
   BlockSponsors($arrBlockSponsors[48], $arrBlockSponsors[48], 'Is' & $arrBlockSponsors[48] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3150}')
EndFunc

Func _CheckBoxSponsorBlock49()
   BlockSponsors($arrBlockSponsors[49], $arrBlockSponsors[49], 'Is' & $arrBlockSponsors[49] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3151}')
EndFunc

Func _CheckBoxSponsorBlock50()
   BlockSponsors($arrBlockSponsors[50], $arrBlockSponsors[50], 'Is' & $arrBlockSponsors[50] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3152}')
EndFunc

Func _CheckBoxSponsorBlock51()
   BlockSponsors($arrBlockSponsors[51], $arrBlockSponsors[51], 'Is' & $arrBlockSponsors[51] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3153}')
EndFunc

Func _CheckBoxSponsorBlock52()
   BlockSponsors($arrBlockSponsors[52], $arrBlockSponsors[52], 'Is' & $arrBlockSponsors[52] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3154}')
EndFunc

Func _CheckBoxSponsorBlock53()
   BlockSponsors($arrBlockSponsors[53], $arrBlockSponsors[53], 'Is' & $arrBlockSponsors[53] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3155}')
EndFunc

Func _CheckBoxSponsorBlock54()
   BlockSponsors($arrBlockSponsors[54], $arrBlockSponsors[54], 'Is' & $arrBlockSponsors[54] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3156}')
EndFunc

Func _CheckBoxSponsorBlock55()
   BlockSponsors($arrBlockSponsors[55], $arrBlockSponsors[55], 'Is' & $arrBlockSponsors[55] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3157}')
EndFunc

Func _CheckBoxSponsorBlock56()
   BlockSponsors($arrBlockSponsors[56], $arrBlockSponsors[56], 'Is' & $arrBlockSponsors[56] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3158}')
EndFunc

Func _CheckBoxSponsorBlock57()
   BlockSponsors($arrBlockSponsors[57], $arrBlockSponsors[57], 'Is' & $arrBlockSponsors[57] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3159}')
EndFunc

Func _CheckBoxSponsorBlock58()
   BlockSponsors($arrBlockSponsors[58], $arrBlockSponsors[58], 'Is' & $arrBlockSponsors[58] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3160}')
EndFunc

Func _CheckBoxSponsorBlock59()
   BlockSponsors($arrBlockSponsors[59], $arrBlockSponsors[59], 'Is' & $arrBlockSponsors[59] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3161}')
EndFunc

Func _CheckBoxSponsorBlock60()
   BlockSponsors($arrBlockSponsors[60], $arrBlockSponsors[60], 'Is' & $arrBlockSponsors[60] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3162}')
EndFunc

Func _CheckBoxSponsorBlock61()
   BlockSponsors($arrBlockSponsors[61], $arrBlockSponsors[61], 'Is' & $arrBlockSponsors[61] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3163}')
EndFunc

Func _CheckBoxSponsorBlock62()
   BlockSponsors($arrBlockSponsors[62], $arrBlockSponsors[62], 'Is' & $arrBlockSponsors[62] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3164}')
EndFunc

Func _CheckBoxSponsorBlock63()
   BlockSponsors($arrBlockSponsors[63], $arrBlockSponsors[63], 'Is' & $arrBlockSponsors[63] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3165}')
EndFunc

Func _CheckBoxSponsorBlock64()
   BlockSponsors($arrBlockSponsors[64], $arrBlockSponsors[64], 'Is' & $arrBlockSponsors[64] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3166}')
EndFunc

Func _CheckBoxSponsorBlock65()
   BlockSponsors($arrBlockSponsors[65], $arrBlockSponsors[65], 'Is' & $arrBlockSponsors[65] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3167}')
EndFunc

Func _CheckBoxSponsorBlock66()
   BlockSponsors($arrBlockSponsors[66], $arrBlockSponsors[66], 'Is' & $arrBlockSponsors[66] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3168}')
EndFunc

Func _CheckBoxSponsorBlock67()
   BlockSponsors($arrBlockSponsors[67], $arrBlockSponsors[67], 'Is' & $arrBlockSponsors[67] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3169}')
EndFunc

Func _CheckBoxSponsorBlock68()
   BlockSponsors($arrBlockSponsors[68], $arrBlockSponsors[68], 'Is' & $arrBlockSponsors[68] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3170}')
EndFunc

Func _CheckBoxSponsorBlock69()
   BlockSponsors($arrBlockSponsors[69], $arrBlockSponsors[69], 'Is' & $arrBlockSponsors[69] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3171}')
EndFunc

Func _CheckBoxSponsorBlock70()
   BlockSponsors($arrBlockSponsors[70], $arrBlockSponsors[70], 'Is' & $arrBlockSponsors[70] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3172}')
EndFunc

Func _CheckBoxSponsorBlock71()
   BlockSponsors($arrBlockSponsors[71], $arrBlockSponsors[71], 'Is' & $arrBlockSponsors[71] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3173}')
EndFunc

Func _CheckBoxSponsorBlock72()
   BlockSponsors($arrBlockSponsors[72], $arrBlockSponsors[72], 'Is' & $arrBlockSponsors[72] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3174}')
EndFunc

Func _CheckBoxSponsorBlock73()
   BlockSponsors($arrBlockSponsors[73], $arrBlockSponsors[73], 'Is' & $arrBlockSponsors[73] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3175}')
EndFunc

Func _CheckBoxSponsorBlock74()
   BlockSponsors($arrBlockSponsors[74], $arrBlockSponsors[74], 'Is' & $arrBlockSponsors[74] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3176}')
EndFunc

Func _CheckBoxSponsorBlock75()
   BlockSponsors($arrBlockSponsors[75], $arrBlockSponsors[75], 'Is' & $arrBlockSponsors[75] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3177}')
EndFunc

Func _CheckBoxSponsorBlock76()
   BlockSponsors($arrBlockSponsors[76], $arrBlockSponsors[76], 'Is' & $arrBlockSponsors[76] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3178}')
EndFunc

Func _CheckBoxSponsorBlock77()
   BlockSponsors($arrBlockSponsors[77], $arrBlockSponsors[77], 'Is' & $arrBlockSponsors[77] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3179}')
EndFunc

Func _CheckBoxSponsorBlock78()
   BlockSponsors($arrBlockSponsors[78], $arrBlockSponsors[78], 'Is' & $arrBlockSponsors[78] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3180}')
EndFunc

Func _CheckBoxSponsorBlock79()
   BlockSponsors($arrBlockSponsors[79], $arrBlockSponsors[79], 'Is' & $arrBlockSponsors[79] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3181}')
EndFunc

Func _CheckBoxSponsorBlock80()
   BlockSponsors($arrBlockSponsors[80], $arrBlockSponsors[80], 'Is' & $arrBlockSponsors[80] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3182}')
EndFunc

Func _CheckBoxSponsorBlock81()
   BlockSponsors($arrBlockSponsors[81], $arrBlockSponsors[81], 'Is' & $arrBlockSponsors[81] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3183}')
EndFunc

Func _CheckBoxSponsorBlock82()
   BlockSponsors($arrBlockSponsors[82], $arrBlockSponsors[82], 'Is' & $arrBlockSponsors[82] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3184}')
EndFunc

Func _CheckBoxSponsorBlock83()
   BlockSponsors($arrBlockSponsors[83], $arrBlockSponsors[83], 'Is' & $arrBlockSponsors[83] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3185}')
EndFunc

Func _CheckBoxSponsorBlock84()
   BlockSponsors($arrBlockSponsors[84], $arrBlockSponsors[84], 'Is' & $arrBlockSponsors[84] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3186}')
EndFunc

Func _CheckBoxSponsorBlock85()
   BlockSponsors($arrBlockSponsors[85], $arrBlockSponsors[85], 'Is' & $arrBlockSponsors[85] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3187}')
EndFunc

Func _CheckBoxSponsorBlock86()
   BlockSponsors($arrBlockSponsors[86], $arrBlockSponsors[86], 'Is' & $arrBlockSponsors[86] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3188}')
EndFunc

Func _CheckBoxSponsorBlock87()
   BlockSponsors($arrBlockSponsors[87], $arrBlockSponsors[87], 'Is' & $arrBlockSponsors[87] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3189}')
EndFunc

Func _CheckBoxSponsorBlock88()
   BlockSponsors($arrBlockSponsors[88], $arrBlockSponsors[88], 'Is' & $arrBlockSponsors[88] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3190}')
EndFunc

Func _CheckBoxSponsorBlock89()
   BlockSponsors($arrBlockSponsors[89], $arrBlockSponsors[89], 'Is' & $arrBlockSponsors[89] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3191}')
EndFunc

Func _CheckBoxSponsorBlock90()
   BlockSponsors($arrBlockSponsors[90], $arrBlockSponsors[90], 'Is' & $arrBlockSponsors[90] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3192}')
EndFunc

Func _CheckBoxSponsorBlock91()
   BlockSponsors($arrBlockSponsors[91], $arrBlockSponsors[91], 'Is' & $arrBlockSponsors[91] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3193}')
EndFunc

Func _CheckBoxSponsorBlock92()
   BlockSponsors($arrBlockSponsors[92], $arrBlockSponsors[92], 'Is' & $arrBlockSponsors[92] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3194}')
EndFunc

Func _CheckBoxSponsorBlock93()
   BlockSponsors($arrBlockSponsors[93], $arrBlockSponsors[93], 'Is' & $arrBlockSponsors[93] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3195}')
EndFunc

Func _CheckBoxSponsorBlock94()
   BlockSponsors($arrBlockSponsors[94], $arrBlockSponsors[94], 'Is' & $arrBlockSponsors[94] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3196}')
EndFunc

Func _CheckBoxSponsorBlock95()
   BlockSponsors($arrBlockSponsors[95], $arrBlockSponsors[95], 'Is' & $arrBlockSponsors[95] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3197}')
EndFunc

Func _CheckBoxSponsorBlock96()
   BlockSponsors($arrBlockSponsors[96], $arrBlockSponsors[96], 'Is' & $arrBlockSponsors[96] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3198}')
EndFunc

Func _CheckBoxSponsorBlock97()
   BlockSponsors($arrBlockSponsors[97], $arrBlockSponsors[97], 'Is' & $arrBlockSponsors[97] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3199}')
EndFunc

Func _CheckBoxSponsorBlock98()
   BlockSponsors($arrBlockSponsors[98], $arrBlockSponsors[98], 'Is' & $arrBlockSponsors[98] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3200}')
EndFunc

Func _CheckBoxSponsorBlock99()
   BlockSponsors($arrBlockSponsors[99], $arrBlockSponsors[99], 'Is' & $arrBlockSponsors[99] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3201}')
EndFunc

Func _CheckBoxSponsorBlock100()
   BlockSponsors($arrBlockSponsors[100], $arrBlockSponsors[100], 'Is' & $arrBlockSponsors[100] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3202}')
EndFunc

Func _CheckBoxSponsorBlock101()
   BlockSponsors($arrBlockSponsors[101], $arrBlockSponsors[101], 'Is' & $arrBlockSponsors[101] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3203}')
EndFunc

Func _CheckBoxSponsorBlock102()
   BlockSponsors($arrBlockSponsors[102], $arrBlockSponsors[102], 'Is' & $arrBlockSponsors[102] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3204}')
EndFunc

Func _CheckBoxSponsorBlock103()
   BlockSponsors($arrBlockSponsors[103], $arrBlockSponsors[103], 'Is' & $arrBlockSponsors[103] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3205}')
EndFunc

Func _CheckBoxSponsorBlock104()
   BlockSponsors($arrBlockSponsors[104], $arrBlockSponsors[104], 'Is' & $arrBlockSponsors[104] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3206}')
EndFunc

Func _CheckBoxSponsorBlock105()
   BlockSponsors($arrBlockSponsors[105], $arrBlockSponsors[105], 'Is' & $arrBlockSponsors[105] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3207}')
EndFunc

Func _CheckBoxSponsorBlock106()
   BlockSponsors($arrBlockSponsors[106], $arrBlockSponsors[106], 'Is' & $arrBlockSponsors[106] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3208}')
EndFunc

Func _CheckBoxSponsorBlock107()
   BlockSponsors($arrBlockSponsors[107], $arrBlockSponsors[107], 'Is' & $arrBlockSponsors[107] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3209}')
EndFunc

Func _CheckBoxSponsorBlock108()
   BlockSponsors($arrBlockSponsors[108], $arrBlockSponsors[108], 'Is' & $arrBlockSponsors[108] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3210}')
EndFunc

Func _CheckBoxSponsorBlock109()
   BlockSponsors($arrBlockSponsors[109], $arrBlockSponsors[109], 'Is' & $arrBlockSponsors[109] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3211}')
EndFunc

Func _CheckBoxSponsorBlock110()
   BlockSponsors($arrBlockSponsors[110], $arrBlockSponsors[110], 'Is' & $arrBlockSponsors[110] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3212}')
EndFunc

Func _CheckBoxSponsorBlock111()
   BlockSponsors($arrBlockSponsors[111], $arrBlockSponsors[111], 'Is' & $arrBlockSponsors[111] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3213}')
EndFunc

Func _CheckBoxSponsorBlock112()
   BlockSponsors($arrBlockSponsors[112], $arrBlockSponsors[112], 'Is' & $arrBlockSponsors[112] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3214}')
EndFunc

Func _CheckBoxSponsorBlock113()
   BlockSponsors($arrBlockSponsors[113], $arrBlockSponsors[113], 'Is' & $arrBlockSponsors[113] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3215}')
EndFunc

Func _CheckBoxSponsorBlock114()
   BlockSponsors($arrBlockSponsors[114], $arrBlockSponsors[114], 'Is' & $arrBlockSponsors[114] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3216}')
EndFunc

Func _CheckBoxSponsorBlock115()
   BlockSponsors($arrBlockSponsors[115], $arrBlockSponsors[115], 'Is' & $arrBlockSponsors[115] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3217}')
EndFunc

Func _CheckBoxSponsorBlock116()
   BlockSponsors($arrBlockSponsors[116], $arrBlockSponsors[116], 'Is' & $arrBlockSponsors[116] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3218}')
EndFunc

Func _CheckBoxSponsorBlock117()
   BlockSponsors($arrBlockSponsors[117], $arrBlockSponsors[117], 'Is' & $arrBlockSponsors[117] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3219}')
EndFunc

Func _CheckBoxSponsorBlock118()
   BlockSponsors($arrBlockSponsors[118], $arrBlockSponsors[118], 'Is' & $arrBlockSponsors[118] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3220}')
EndFunc

Func _CheckBoxSponsorBlock119()
   BlockSponsors($arrBlockSponsors[119], $arrBlockSponsors[119], 'Is' & $arrBlockSponsors[119] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3221}')
EndFunc

Func _CheckBoxSponsorBlock120()
   BlockSponsors($arrBlockSponsors[120], $arrBlockSponsors[120], 'Is' & $arrBlockSponsors[120] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3222}')
EndFunc

Func _CheckBoxSponsorBlock121()
   BlockSponsors($arrBlockSponsors[121], $arrBlockSponsors[121], 'Is' & $arrBlockSponsors[121] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3223}')
EndFunc

Func _CheckBoxSponsorBlock122()
   BlockSponsors($arrBlockSponsors[122], $arrBlockSponsors[122], 'Is' & $arrBlockSponsors[122] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3224}')
EndFunc

Func _CheckBoxSponsorBlock123()
   BlockSponsors($arrBlockSponsors[123], $arrBlockSponsors[123], 'Is' & $arrBlockSponsors[123] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3225}')
EndFunc

Func _CheckBoxSponsorBlock124()
   BlockSponsors($arrBlockSponsors[124], $arrBlockSponsors[124], 'Is' & $arrBlockSponsors[124] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3226}')
EndFunc

Func _CheckBoxSponsorBlock125()
   BlockSponsors($arrBlockSponsors[125], $arrBlockSponsors[125], 'Is' & $arrBlockSponsors[125] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3227}')
EndFunc

Func _CheckBoxSponsorBlock126()
   BlockSponsors($arrBlockSponsors[126], $arrBlockSponsors[126], 'Is' & $arrBlockSponsors[126] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3228}')
EndFunc

Func _CheckBoxSponsorBlock127()
   BlockSponsors($arrBlockSponsors[127], $arrBlockSponsors[127], 'Is' & $arrBlockSponsors[127] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3229}')
EndFunc

Func _CheckBoxSponsorBlock128()
   BlockSponsors($arrBlockSponsors[128], $arrBlockSponsors[128], 'Is' & $arrBlockSponsors[128] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3230}')
EndFunc

Func _CheckBoxSponsorBlock129()
   BlockSponsors($arrBlockSponsors[129], $arrBlockSponsors[129], 'Is' & $arrBlockSponsors[129] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3231}')
EndFunc

Func _CheckBoxSponsorBlock130()
   BlockSponsors($arrBlockSponsors[130], $arrBlockSponsors[130], 'Is' & $arrBlockSponsors[130] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3232}')
EndFunc

Func _CheckBoxSponsorBlock131()
   BlockSponsors($arrBlockSponsors[131], $arrBlockSponsors[131], 'Is' & $arrBlockSponsors[131] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3233}')
EndFunc

Func _CheckBoxSponsorBlock132()
   BlockSponsors($arrBlockSponsors[132], $arrBlockSponsors[132], 'Is' & $arrBlockSponsors[132] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3234}')
EndFunc

Func _CheckBoxSponsorBlock133()
   BlockSponsors($arrBlockSponsors[133], $arrBlockSponsors[133], 'Is' & $arrBlockSponsors[133] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3235}')
EndFunc

Func _CheckBoxSponsorBlock134()
   BlockSponsors($arrBlockSponsors[134], $arrBlockSponsors[134], 'Is' & $arrBlockSponsors[134] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3236}')
EndFunc

Func _CheckBoxSponsorBlock135()
   BlockSponsors($arrBlockSponsors[135], $arrBlockSponsors[135], 'Is' & $arrBlockSponsors[135] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3237}')
EndFunc

Func _CheckBoxSponsorBlock136()
   BlockSponsors($arrBlockSponsors[136], $arrBlockSponsors[136], 'Is' & $arrBlockSponsors[136] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3238}')
EndFunc

Func _CheckBoxSponsorBlock137()
   BlockSponsors($arrBlockSponsors[137], $arrBlockSponsors[137], 'Is' & $arrBlockSponsors[137] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3239}')
EndFunc

Func _CheckBoxSponsorBlock138()
   BlockSponsors($arrBlockSponsors[138], $arrBlockSponsors[138], 'Is' & $arrBlockSponsors[138] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3240}')
EndFunc

Func _CheckBoxSponsorBlock139()
   BlockSponsors($arrBlockSponsors[139], $arrBlockSponsors[139], 'Is' & $arrBlockSponsors[139] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3241}')
EndFunc

Func _CheckBoxSponsorBlock140()
   BlockSponsors($arrBlockSponsors[140], $arrBlockSponsors[140], 'Is' & $arrBlockSponsors[140] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3242}')
EndFunc

Func _CheckBoxSponsorBlock141()
   BlockSponsors($arrBlockSponsors[141], $arrBlockSponsors[141], 'Is' & $arrBlockSponsors[141] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3243}')
EndFunc

Func _CheckBoxSponsorBlock142()
   BlockSponsors($arrBlockSponsors[142], $arrBlockSponsors[142], 'Is' & $arrBlockSponsors[142] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3244}')
EndFunc

Func _CheckBoxSponsorBlock143()
   BlockSponsors($arrBlockSponsors[143], $arrBlockSponsors[143], 'Is' & $arrBlockSponsors[143] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3245}')
EndFunc

Func _CheckBoxSponsorBlock144()
   BlockSponsors($arrBlockSponsors[144], $arrBlockSponsors[144], 'Is' & $arrBlockSponsors[144] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3246}')
EndFunc

Func _CheckBoxSponsorBlock145()
   BlockSponsors($arrBlockSponsors[145], $arrBlockSponsors[145], 'Is' & $arrBlockSponsors[145] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3247}')
EndFunc

Func _CheckBoxSponsorBlock146()
   BlockSponsors($arrBlockSponsors[146], $arrBlockSponsors[146], 'Is' & $arrBlockSponsors[146] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3248}')
EndFunc

Func _CheckBoxSponsorBlock147()
   BlockSponsors($arrBlockSponsors[147], $arrBlockSponsors[147], 'Is' & $arrBlockSponsors[147] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3249}')
EndFunc

Func _CheckBoxSponsorBlock148()
   BlockSponsors($arrBlockSponsors[148], $arrBlockSponsors[148], 'Is' & $arrBlockSponsors[148] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3250}')
EndFunc

Func _CheckBoxSponsorBlock149()
   BlockSponsors($arrBlockSponsors[149], $arrBlockSponsors[149], 'Is' & $arrBlockSponsors[149] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3251}')
EndFunc

Func _CheckBoxSponsorBlock150()
   BlockSponsors($arrBlockSponsors[150], $arrBlockSponsors[150], 'Is' & $arrBlockSponsors[150] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3252}')
EndFunc

Func _CheckBoxSponsorBlock151()
   BlockSponsors($arrBlockSponsors[151], $arrBlockSponsors[151], 'Is' & $arrBlockSponsors[151] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3253}')
EndFunc

Func _CheckBoxSponsorBlock152()
   BlockSponsors($arrBlockSponsors[152], $arrBlockSponsors[152], 'Is' & $arrBlockSponsors[152] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3254}')
EndFunc

Func _CheckBoxSponsorBlock153()
   BlockSponsors($arrBlockSponsors[153], $arrBlockSponsors[153], 'Is' & $arrBlockSponsors[153] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3255}')
EndFunc

Func _CheckBoxSponsorBlock154()
   BlockSponsors($arrBlockSponsors[154], $arrBlockSponsors[154], 'Is' & $arrBlockSponsors[154] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3256}')
EndFunc

Func _CheckBoxSponsorBlock155()
   BlockSponsors($arrBlockSponsors[155], $arrBlockSponsors[155], 'Is' & $arrBlockSponsors[155] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3257}')
EndFunc

Func _CheckBoxSponsorBlock156()
   BlockSponsors($arrBlockSponsors[156], $arrBlockSponsors[156], 'Is' & $arrBlockSponsors[156] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3258}')
EndFunc

Func _CheckBoxSponsorBlock157()
   BlockSponsors($arrBlockSponsors[157], $arrBlockSponsors[157], 'Is' & $arrBlockSponsors[157] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3259}')
EndFunc

Func _CheckBoxSponsorBlock158()
   BlockSponsors($arrBlockSponsors[158], $arrBlockSponsors[158], 'Is' & $arrBlockSponsors[158] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3260}')
EndFunc

Func _CheckBoxSponsorBlock159()
   BlockSponsors($arrBlockSponsors[159], $arrBlockSponsors[159], 'Is' & $arrBlockSponsors[159] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3261}')
EndFunc

Func _CheckBoxSponsorBlock160()
   BlockSponsors($arrBlockSponsors[160], $arrBlockSponsors[160], 'Is' & $arrBlockSponsors[160] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3262}')
EndFunc

Func _CheckBoxSponsorBlock161()
   BlockSponsors($arrBlockSponsors[161], $arrBlockSponsors[161], 'Is' & $arrBlockSponsors[161] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3263}')
EndFunc

Func _CheckBoxSponsorBlock162()
   BlockSponsors($arrBlockSponsors[162], $arrBlockSponsors[162], 'Is' & $arrBlockSponsors[162] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3264}')
EndFunc

Func _CheckBoxSponsorBlock163()
   BlockSponsors($arrBlockSponsors[163], $arrBlockSponsors[163], 'Is' & $arrBlockSponsors[163] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3265}')
EndFunc

Func _CheckBoxSponsorBlock164()
   BlockSponsors($arrBlockSponsors[164], $arrBlockSponsors[164], 'Is' & $arrBlockSponsors[164] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3266}')
EndFunc

Func _CheckBoxSponsorBlock165()
   BlockSponsors($arrBlockSponsors[165], $arrBlockSponsors[165], 'Is' & $arrBlockSponsors[165] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3267}')
EndFunc

Func _CheckBoxSponsorBlock166()
   BlockSponsors($arrBlockSponsors[166], $arrBlockSponsors[166], 'Is' & $arrBlockSponsors[166] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3268}')
EndFunc

Func _CheckBoxSponsorBlock167()
   BlockSponsors($arrBlockSponsors[167], $arrBlockSponsors[167], 'Is' & $arrBlockSponsors[167] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3269}')
EndFunc

Func _CheckBoxSponsorBlock168()
   BlockSponsors($arrBlockSponsors[168], $arrBlockSponsors[168], 'Is' & $arrBlockSponsors[168] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3270}')
EndFunc

Func _CheckBoxSponsorBlock169()
   BlockSponsors($arrBlockSponsors[169], $arrBlockSponsors[169], 'Is' & $arrBlockSponsors[169] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3271}')
EndFunc

Func _CheckBoxSponsorBlock170()
   BlockSponsors($arrBlockSponsors[170], $arrBlockSponsors[170], 'Is' & $arrBlockSponsors[170] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3272}')
EndFunc

Func _CheckBoxSponsorBlock171()
   BlockSponsors($arrBlockSponsors[171], $arrBlockSponsors[171], 'Is' & $arrBlockSponsors[171] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3273}')
EndFunc

Func CheckBoxSponsorBlock($idCheckbox, $DisableSponsorVariableName, $DisableSponsorRegValueName, $Sponsor_GUID)
;MsgBox(0,"",'idCheckbox=' & $idCheckbox & @CRLF & 'DisableSponsorVariableName=' & $DisableSponsorVariableName  & @CRLF & 'DisableSponsorRegValueName=' & $DisableSponsorRegValueName)
        $DisableSponsorVariableName = CheckBlockedSponsors($DisableSponsorVariableName, $DisableSponsorRegValueName, $Sponsor_GUID)
        If $DisableSponsorVariableName = 'ON' Then 
           GUICtrlSetState ($idCheckbox, 1)
           $BlockSponsorsNumber = $BlockSponsorsNumber + 1
        Else 
           GUICtrlSetState ($idCheckbox, 4)
        EndIf
EndFunc

Func CloseBlockSponsors()
   GuiDelete($MainBlockSponsorsGUI)
;   GUISetState(@SW_ENABLE, $listGUI)
;   GUISetState(@SW_HIDE,$listGUI)
;   GUISetState(@SW_SHOW,$listGUI)
   ShowMainGUI()
   ShowRegistryTweaks()
EndFunc


Func RefreshBlockSponsorsGUIWindow()
  Local $pos = WinGetPos ($BlockSponsorsGUI)
  $X_BlockSponsorsGUI = $pos[0] 
  $Y_BlockSponsorsGUI = $pos[1]
  GUISetState(@SW_HIDE,$BlockSponsorsGUI)
  GuiDelete($BlockSponsorsGUI)
  CheckBoxBlockSponsors()
EndFunc


Func CheckBlockedSponsors($BlockSponsors, $valuename, $GUID0)

$keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers\BlockSponsors'
$keyname0 = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\' & $GUID0

If ($SRPTransparentEnabled = "No Enforcement" or $SRPTransparentEnabled = "not found" or $SRPTransparentEnabled = "?") Then
;   RegDelete($keyname0)
;   RegDelete($keyname, $valuename)
   $BlockSponsors = "OFF"
Else
   $BlockSponsors = RegRead ( $keyname, $valuename )
   Switch $BlockSponsors
     case 1
         $BlockSponsors = "ON"
     case ''
         $BlockSponsors = "OFF"
     case Else
         $BlockSponsors = "?"
     EndSwitch
EndIf
Return $BlockSponsors
EndFunc


Func AddMoreRestrictionsOutput($BlockSponsor, $Output)
   Switch $BlockSponsor
      case "ON"
            $Output = $Output & '1'
      case "OFF"
         $Output = $Output & '0'
      case Else
         $Output = $Output & '?'
   EndSwitch
Return $Output
EndFunc


Func BlockSponsors($EXEName, $Description, $IsBlocked, $GUID)
;MsgBox(0,"","")
; For example: BlockSponsors('regedit.exe', 'REGEDIT', 'IsRegeditBlocked', '{1016bbe0-a716-428b-822e-5E544B6A3107}')
; Each run of this function writes/deletes file with $EXEName on SRP blacklist with guid = $GUID.
If $isSRPinstalled = "Installed" Then
   If not ( $SRPTransparentEnabled = "No Enforcement") Then
      Local $keyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers\BlockSponsors'
      Local $BlacklistKeyname = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\'
      Local $CheckBlocked = RegRead ( $keyname, $IsBlocked )
         Switch $CheckBlocked
            case 0
               RegWrite($BlacklistKeyname & $GUID, 'Description', 'REG_SZ', $Description)
               RegWrite($BlacklistKeyname & $GUID, 'SaferFlags','REG_DWORD',Number('0'))
               RegWrite($BlacklistKeyname & $GUID, 'ItemData','REG_SZ',$EXEName)
               RegWrite($keyname, $IsBlocked, 'REG_DWORD', Number('1'))
;               MsgBox(0,"", $keyname & '!' & $IsBlocked )
               RefreshChangesCheck($IsBlocked)
            case Else
               RegDelete($BlacklistKeyname & $GUID)
               RegDelete($keyname, $IsBlocked)
               RefreshChangesCheck($IsBlocked)
         EndSwitch
;         RegDelete($BlacklistKeyname & $GUID)
;         RegDelete($keyname, $IsBlocked)
   Else
;      MsgBox(262144,"","The Enforcement option must be set to 'Skip DLLs' or 'All Files'.")
   EndIf
Else
   MsgBox(262144,"","This option needs SRP to be installed, with Enforcement set to 'Skip DLLs' or 'All Files'.")
EndIf
;RefreshBlockSponsorsGUIWindow()   
DeleteSwichSponsors()

EndFunc

;**********
Func CheckStateOfSponsorsCheckboxes()
    $BlockSponsorsNumber = 0
    CheckStateOfSponsorsCheckboxes1()
EndFunc

Func CheckStateOfSponsorsCheckboxes1() 
    Arr_GetSponsorNames()
    CheckBoxSponsorBlock($idCheckboxCMD, $DisableCommandPrompt, 'IsCMDBlocked', '{1016bbe0-a716-428b-822e-5E544B6A3102}')
    CheckBoxSponsorBlock($idCheckboxPowerShell, $DisablePowerShell, 'IsPowerShellBlocked', '{1016bbe0-a716-428b-822e-5E544B6A3100}')
    CheckBoxSponsorBlock($idCheckboxPowerShell_ise, $DisablePowerShell_ise, 'IsPowerShell_iseBlocked', '{1016bbe0-a716-428b-822e-5E544B6A3101}')
    CheckBoxSponsorBlock($idCheckbox1, $DisableAttribExe, 'Is' & $arrBlockSponsors[1] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3103}')
    CheckBoxSponsorBlock($idCheckbox2, $DisableAuditpolExe, 'Is' & $arrBlockSponsors[2] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3104}')
    CheckBoxSponsorBlock($idCheckbox3, $DisableBcdbootExe, 'Is' & $arrBlockSponsors[3] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3105}')
    CheckBoxSponsorBlock($idCheckbox4, $DisableBcdeditExe, 'Is' & $arrBlockSponsors[4] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3106}')
    CheckBoxSponsorBlock($idCheckbox5, $DisableBitsadminExe, 'Is' & $arrBlockSponsors[5] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3107}')
    CheckBoxSponsorBlock($idCheckbox6, $DisableBootcfgExe, 'Is' & $arrBlockSponsors[6] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3108}')
    CheckBoxSponsorBlock($idCheckbox7, $DisableBootimExe, 'Is' & $arrBlockSponsors[7] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3109}')
    CheckBoxSponsorBlock($idCheckbox8, $DisableBootsectExe, 'Is' & $arrBlockSponsors[8] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3110}')
    CheckBoxSponsorBlock($idCheckbox9, $DisableByteCodeGeneratorExe, 'Is' & $arrBlockSponsors[9] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3111}')
    CheckBoxSponsorBlock($idCheckbox10, $DisableCaclsExe, 'Is' & $arrBlockSponsors[10] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3112}')
    CheckBoxSponsorBlock($idCheckbox11, $DisableIcaclsExe, 'Is' & $arrBlockSponsors[11] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3113}')
    CheckBoxSponsorBlock($idCheckbox12, $DisableCscExe, 'Is' & $arrBlockSponsors[12] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3114}')
    CheckBoxSponsorBlock($idCheckbox13, $DisableDebugExe, 'Is' & $arrBlockSponsors[13] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3115}')
    CheckBoxSponsorBlock($idCheckbox14, $DisableDFsvcExe, 'Is' & $arrBlockSponsors[14] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3116}')
    CheckBoxSponsorBlock($idCheckbox15, $DisableDiskpartExe, 'Is' & $arrBlockSponsors[15] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3117}')
    CheckBoxSponsorBlock($idCheckbox16, $DisableEventvwrExe, 'Is' & $arrBlockSponsors[16] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3118}')
    CheckBoxSponsorBlock($idCheckbox17, $DisableHHExe, 'Is' & $arrBlockSponsors[17] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3119}')
    CheckBoxSponsorBlock($idCheckbox18, $DisableIEExecExe, 'Is' & $arrBlockSponsors[18] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3120}')
    CheckBoxSponsorBlock($idCheckbox19, $DisableIexploreExe, 'Is' & $arrBlockSponsors[19] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3121}')
    CheckBoxSponsorBlock($idCheckbox20, $DisableIexpressExe, 'Is' & $arrBlockSponsors[20] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3122}')
    CheckBoxSponsorBlock($idCheckbox21, $DisableIlasmExe, 'Is' & $arrBlockSponsors[21] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3123}')
    CheckBoxSponsorBlock($idCheckbox22, $DisableInstallUtilLibDLL, 'Is' & $arrBlockSponsors[22] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3124}')
    CheckBoxSponsorBlock($idCheckbox23, $DisableInstallUtilExe, 'Is' & $arrBlockSponsors[23] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3125}')
    CheckBoxSponsorBlock($idCheckbox24, $DisableJournalExe, 'Is' & $arrBlockSponsors[24] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3126}')
    CheckBoxSponsorBlock($idCheckbox25, $DisableJscExe, 'Is' & $arrBlockSponsors[25] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3127}')
    CheckBoxSponsorBlock($idCheckbox26, $DisableMmcExe, 'Is' & $arrBlockSponsors[26] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3128}')
    CheckBoxSponsorBlock($idCheckbox27, $DisableMrsaExe, 'Is' & $arrBlockSponsors[27] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3129}')
    CheckBoxSponsorBlock($idCheckbox28, $DisableMSBuildExe, 'Is' & $arrBlockSponsors[28] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3130}')
    CheckBoxSponsorBlock($idCheckbox29, $DisableMshtaExe, 'Is' & $arrBlockSponsors[29] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3131}')
    CheckBoxSponsorBlock($idCheckbox30, $DisableMstscExe, 'Is' & $arrBlockSponsors[30] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3132}')
    CheckBoxSponsorBlock($idCheckbox31, $DisableNetshExe, 'Is' & $arrBlockSponsors[31] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3133}')
    CheckBoxSponsorBlock($idCheckbox32, $DisableNetstatExe, 'Is' & $arrBlockSponsors[32] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3134}')
    CheckBoxSponsorBlock($idCheckbox33, $DisablePresentationHostExe, 'Is' & $arrBlockSponsors[33] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3135}')
    CheckBoxSponsorBlock($idCheckbox34, $DisableQuserExe, 'Is' & $arrBlockSponsors[34] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3136}')
    CheckBoxSponsorBlock($idCheckbox35, $DisableRegExe, 'Is' & $arrBlockSponsors[35] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3137}')
    CheckBoxSponsorBlock($idCheckbox36, $DisableRegAsmGlobal, 'Is' & $arrBlockSponsors[36] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3138}')
    CheckBoxSponsorBlock($idCheckbox37, $DisableReginiExe, 'Is' & $arrBlockSponsors[37] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3139}')
    CheckBoxSponsorBlock($idCheckbox38, $DisableRegsvcsExe, 'Is' & $arrBlockSponsors[38] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3140}')
    CheckBoxSponsorBlock($idCheckbox39, $DisableRegsvr32Exe, 'Is' & $arrBlockSponsors[39] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3141}')
    CheckBoxSponsorBlock($idCheckbox40, $DisableRunLegacyCPLElevatedExe, 'Is' & $arrBlockSponsors[40] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3142}')
    CheckBoxSponsorBlock($idCheckbox41, $DisableRunonceExe, 'Is' & $arrBlockSponsors[41] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3143}')
    CheckBoxSponsorBlock($idCheckbox42, $DisableRunasExe, 'Is' & $arrBlockSponsors[42] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3144}')
    CheckBoxSponsorBlock($idCheckbox43, $DisableStarScriptExe, 'Is' & $arrBlockSponsors[43] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3145}')
    CheckBoxSponsorBlock($idCheckbox44, $DisableSetExe, 'Is' & $arrBlockSponsors[44] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3146}')
    CheckBoxSponsorBlock($idCheckbox45, $DisableSetxExe, 'Is' & $arrBlockSponsors[45] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3147')
    CheckBoxSponsorBlock($idCheckbox46, $DisableStashStar, 'Is' & $arrBlockSponsors[46] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3148')
    CheckBoxSponsorBlock($idCheckbox47, $DisableSystemresetExe, 'Is' & $arrBlockSponsors[47] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3149')
    CheckBoxSponsorBlock($idCheckbox48, $DisableTakeownExe, 'Is' & $arrBlockSponsors[48] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3150')
    CheckBoxSponsorBlock($idCheckbox49, $DisableTaskkillExe, 'Is' & $arrBlockSponsors[49] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3151')
    CheckBoxSponsorBlock($idCheckbox50, $DisableUserAccountControlSettingsExe, 'Is' & $arrBlockSponsors[50] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3152')
   CheckBoxSponsorBlock($idCheckbox51, $DisableVbcExe, 'Is' & $arrBlockSponsors[51] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3153')
   CheckBoxSponsorBlock($idCheckbox52, $DisableVssadminExe, 'Is' & $arrBlockSponsors[52] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3154')
   CheckBoxSponsorBlock($idCheckbox53, $DisableWmicExe, 'Is' & $arrBlockSponsors[53] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3155')
   CheckBoxSponsorBlock($idCheckbox54, $DisableXcaclsExe, 'Is' & $arrBlockSponsors[54] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3156')
   CheckBoxSponsorBlock($idCheckbox55, $DisableAspnetCompilerExe, 'Is' & $arrBlockSponsors[55] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3157')
   CheckBoxSponsorBlock($idCheckbox56, $DisableBashExe, 'Is' & $arrBlockSponsors[56] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3158')
   CheckBoxSponsorBlock($idCheckbox57, $DisableBginfoExe, 'Is' & $arrBlockSponsors[57] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3159')
   CheckBoxSponsorBlock($idCheckbox58, $DisableBitsadmin, 'Is' & $arrBlockSponsors[58] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3160')
   CheckBoxSponsorBlock($idCheckbox59, $DisableCdbExe, 'Is' & $arrBlockSponsors[59] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3161')
   CheckBoxSponsorBlock($idCheckbox60, $DisableCsiExe, 'Is' & $arrBlockSponsors[60] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3162')
   CheckBoxSponsorBlock($idCheckbox61, $DisableCvtresExe, 'Is' & $arrBlockSponsors[61] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3163')
   CheckBoxSponsorBlock($idCheckbox62, $DisableDbghostExe, 'Is' & $arrBlockSponsors[62] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3164')
   CheckBoxSponsorBlock($idCheckbox63, $DisableDbgsvcExe, 'Is' & $arrBlockSponsors[63] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3165')
   CheckBoxSponsorBlock($idCheckbox64, $DisableDnxExe, 'Is' & $arrBlockSponsors[64] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3166')
   CheckBoxSponsorBlock($idCheckbox65, $DisableFsiExe, 'Is' & $arrBlockSponsors[65] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3167')
   CheckBoxSponsorBlock($idCheckbox66, $DisablefsiAnyCpuExe, 'Is' & $arrBlockSponsors[66] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3168')
   CheckBoxSponsorBlock($idCheckbox67, $DisableInfDefaultInstallExe, 'Is' & $arrBlockSponsors[67] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3169')
   CheckBoxSponsorBlock($idCheckbox68, $DisableInstallUtil, 'Is' & $arrBlockSponsors[68] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3170')
   CheckBoxSponsorBlock($idCheckbox69, $DisableKdExe, 'Is' & $arrBlockSponsors[69] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3171')
   CheckBoxSponsorBlock($idCheckbox70, $DisableLpkInstall, 'Is' & $arrBlockSponsors[70] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3172')
   CheckBoxSponsorBlock($idCheckbox71, $DisableLxssManagerDll, 'Is' & $arrBlockSponsors[71] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3173')
   CheckBoxSponsorBlock($idCheckbox72, $DisableMsiexecExe, 'Is' & $arrBlockSponsors[72] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3174')
   CheckBoxSponsorBlock($idCheckbox73, $DisableNtkdExe, 'Is' & $arrBlockSponsors[73] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3175')
   CheckBoxSponsorBlock($idCheckbox74, $DisableNtsdExe, 'Is' & $arrBlockSponsors[74] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3176')
   CheckBoxSponsorBlock($idCheckbox75, $DisableOdbcConfExe, 'Is' & $arrBlockSponsors[75] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3177')
   CheckBoxSponsorBlock($idCheckbox76, $DisableRcsiExe, 'Is' & $arrBlockSponsors[76] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3178')
   CheckBoxSponsorBlock($idCheckbox77, $DisableRegAsm, 'Is' & $arrBlockSponsors[77] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3179')
   CheckBoxSponsorBlock($idCheckbox78, $DisableRegsvcs, 'Is' & $arrBlockSponsors[78] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3180')
   CheckBoxSponsorBlock($idCheckbox79, $DisableRunScriptHelperExe, 'Is' & $arrBlockSponsors[79] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3181')
   CheckBoxSponsorBlock($idCheckbox80, $DisableSchTasksExe, 'Is' & $arrBlockSponsors[80] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3182')
   CheckBoxSponsorBlock($idCheckbox81, $DisableScrconsExe, 'Is' & $arrBlockSponsors[81] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3183')
   CheckBoxSponsorBlock($idCheckbox82, $DisableSdbinstExe, 'Is' & $arrBlockSponsors[82] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3184')
   CheckBoxSponsorBlock($idCheckbox83, $DisableSdcltExe, 'Is' & $arrBlockSponsors[83] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3185')
   CheckBoxSponsorBlock($idCheckbox84, $DisableSyskeyExe, 'Is' & $arrBlockSponsors[84] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3186')
   CheckBoxSponsorBlock($idCheckbox85, $DisableUtilmanExe, 'Is' & $arrBlockSponsors[85] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3187')
   CheckBoxSponsorBlock($idCheckbox86, $DisableVisualUiaVerifyNativeExe, 'Is' & $arrBlockSponsors[86] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3188')
   CheckBoxSponsorBlock($idCheckbox87, $DisableWbemTestExe, 'Is' & $arrBlockSponsors[87] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3189')
   CheckBoxSponsorBlock($idCheckbox88, $DisableWinDbgExe, 'Is' & $arrBlockSponsors[88] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3190')

;*********

   CheckBoxSponsorBlock($idCheckbox89, $DisableAtExe, 'Is' & $arrBlockSponsors[89] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3191}')
   CheckBoxSponsorBlock($idCheckbox90, $DisableAdvpackDll, 'Is' & $arrBlockSponsors[90] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3192}')
   CheckBoxSponsorBlock($idCheckbox91, $DisableAppvlpExe, 'Is' & $arrBlockSponsors[91] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3193}')
   CheckBoxSponsorBlock($idCheckbox92, $DisableAtbrokerExe, 'Is' & $arrBlockSponsors[92] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3194}')
   CheckBoxSponsorBlock($idCheckbox93, $DisableCertutilEexe, 'Is' & $arrBlockSponsors[93] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3195}')
   CheckBoxSponsorBlock($idCheckbox94, $DisableCL_InvocationPs1, 'Is' & $arrBlockSponsors[94] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3196}')
   CheckBoxSponsorBlock($idCheckbox95, $DisableCL_MutexverifiersPs1, 'Is' & $arrBlockSponsors[95] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3197}')
   CheckBoxSponsorBlock($idCheckbox96, $DisableCmdkeyExe, 'Is' & $arrBlockSponsors[96] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3198}')
   CheckBoxSponsorBlock($idCheckbox97, $DisableCmstpExe, 'Is' & $arrBlockSponsors[97] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3199}')
   CheckBoxSponsorBlock($idCheckbox98, $DisableControlExe, 'Is' & $arrBlockSponsors[98] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3200}')
   CheckBoxSponsorBlock($idCheckbox99, $DisableDiskshadowExe, 'Is' & $arrBlockSponsors[99] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3201}')
   CheckBoxSponsorBlock($idCheckbox100, $DisableDnscmdExe, 'Is' & $arrBlockSponsors[100] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3202}')
   CheckBoxSponsorBlock($idCheckbox101, $DisableDxcapExe, 'Is' & $arrBlockSponsors[101] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3203}')
   CheckBoxSponsorBlock($idCheckbox102, $DisableEsentutlExe, 'Is' & $arrBlockSponsors[102] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3204}')
   CheckBoxSponsorBlock($idCheckbox103, $DisableExpandExe, 'Is' & $arrBlockSponsors[103] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3205}')
   CheckBoxSponsorBlock($idCheckbox104, $DisableExtexportExe, 'Is' & $arrBlockSponsors[104] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3206}')
   CheckBoxSponsorBlock($idCheckbox105, $DisableExtrac32Exe, 'Is' & $arrBlockSponsors[105] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3207}')
   CheckBoxSponsorBlock($idCheckbox106, $DisableFindstrExe, 'Is' & $arrBlockSponsors[106] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3208}')
   CheckBoxSponsorBlock($idCheckbox107, $DisableForfilesExe, 'Is' & $arrBlockSponsors[107] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3209}')
   CheckBoxSponsorBlock($idCheckbox108, $DisableFtpExe, 'Is' & $arrBlockSponsors[108] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3210}')
   CheckBoxSponsorBlock($idCheckbox109, $DisableGpscriptExe, 'Is' & $arrBlockSponsors[109] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3211}')
   CheckBoxSponsorBlock($idCheckbox110, $DisableIe4uinitExe, 'Is' & $arrBlockSponsors[110] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3212}')
   CheckBoxSponsorBlock($idCheckbox111, $DisableIeadvpackDll, 'Is' & $arrBlockSponsors[111] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3213}')
   CheckBoxSponsorBlock($idCheckbox112, $DisableIeaframeDll, 'Is' & $arrBlockSponsors[112] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3214}')
   CheckBoxSponsorBlock($idCheckbox113, $DisableJscriptDll, 'Is' & $arrBlockSponsors[113] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3215}')
   CheckBoxSponsorBlock($idCheckbox114, $DisableMakecabExe, 'Is' & $arrBlockSponsors[114] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3216}')
   CheckBoxSponsorBlock($idCheckbox115, $DisableManagebdeWsf, 'Is' & $arrBlockSponsors[115] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3217}')
   CheckBoxSponsorBlock($idCheckbox116, $DisableMavinjectExe, 'Is' & $arrBlockSponsors[116] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3218}')
   CheckBoxSponsorBlock($idCheckbox117, $DisableMftraceExe, 'Is' & $arrBlockSponsors[117] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3219}')
   CheckBoxSponsorBlock($idCheckbox118, $DisableMicrosoftWorkflowCompilerExe, 'Is' & $arrBlockSponsors[118] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3220}')
   CheckBoxSponsorBlock($idCheckbox119, $DisableMsconfigExe, 'Is' & $arrBlockSponsors[119] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3221}')
   CheckBoxSponsorBlock($idCheckbox120, $DisableMsdeployExe, 'Is' & $arrBlockSponsors[120] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3222}')
   CheckBoxSponsorBlock($idCheckbox121, $DisableMsdtExe, 'Is' & $arrBlockSponsors[121] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3223}')
   CheckBoxSponsorBlock($idCheckbox122, $DisableMshtmlDll, 'Is' & $arrBlockSponsors[122] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3224}')
   CheckBoxSponsorBlock($idCheckbox123, $DisableMspubExe, 'Is' & $arrBlockSponsors[123] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3225}')
   CheckBoxSponsorBlock($idCheckbox124, $DisableMsraExe, 'Is' & $arrBlockSponsors[124] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3226}')
   CheckBoxSponsorBlock($idCheckbox125, $DisableMsxslExe, 'Is' & $arrBlockSponsors[125] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3227}')
   CheckBoxSponsorBlock($idCheckbox126, $DisablePcaluaExe, 'Is' & $arrBlockSponsors[126] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3228}')
   CheckBoxSponsorBlock($idCheckbox127, $DisablePcwrunExe, 'Is' & $arrBlockSponsors[127] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3229}')
   CheckBoxSponsorBlock($idCheckbox128, $DisablePcwutlDll, 'Is' & $arrBlockSponsors[128] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3230}')
   CheckBoxSponsorBlock($idCheckbox129, $DisablePesterBat, 'Is' & $arrBlockSponsors[129] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3231}')
   CheckBoxSponsorBlock($idCheckbox130, $DisablePrintExe, 'Is' & $arrBlockSponsors[130] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3232}')
   CheckBoxSponsorBlock($idCheckbox131, $DisablePsrExe, 'Is' & $arrBlockSponsors[131] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3233}')
   CheckBoxSponsorBlock($idCheckbox132, $DisablePubprnVbs, 'Is' & $arrBlockSponsors[132] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3234}')
   CheckBoxSponsorBlock($idCheckbox133, $DisableRegeditExe, 'Is' & $arrBlockSponsors[133] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3235}')
   CheckBoxSponsorBlock($idCheckbox134, $DisableRegisterCimproviderExe, 'Is' & $arrBlockSponsors[134] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3236}')
   CheckBoxSponsorBlock($idCheckbox135, $DisableReplaceExe, 'Is' & $arrBlockSponsors[135] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3237}')
   CheckBoxSponsorBlock($idCheckbox136, $DisableRobocopyExe, 'Is' & $arrBlockSponsors[136] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3238}')
   CheckBoxSponsorBlock($idCheckbox137, $DisableRpcpingExe, 'Is' & $arrBlockSponsors[137] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3239}')
   CheckBoxSponsorBlock($idCheckbox138, $DisableScExe, 'Is' & $arrBlockSponsors[138] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3240}')
   CheckBoxSponsorBlock($idCheckbox139, $DisableScriptrunnerExe, 'Is' & $arrBlockSponsors[139] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3241}')
   CheckBoxSponsorBlock($idCheckbox140, $DisableSetupapiDll, 'Is' & $arrBlockSponsors[140] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3242}')
   CheckBoxSponsorBlock($idCheckbox141, $DisableShdocvwDll, 'Is' & $arrBlockSponsors[141] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3243}')
   CheckBoxSponsorBlock($idCheckbox142, $DisableShell32Dll, 'Is' & $arrBlockSponsors[142] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3244}')
   CheckBoxSponsorBlock($idCheckbox143, $DisableSlmgrVbs, 'Is' & $arrBlockSponsors[143] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3245}')
   CheckBoxSponsorBlock($idCheckbox144, $DisableSqldumperExe, 'Is' & $arrBlockSponsors[144] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3246}')
   CheckBoxSponsorBlock($idCheckbox145, $DisableSqlpsExe, 'Is' & $arrBlockSponsors[145] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3247}')
   CheckBoxSponsorBlock($idCheckbox146, $DisableSQLToolsPSExe, 'Is' & $arrBlockSponsors[146] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3248}')
   CheckBoxSponsorBlock($idCheckbox147, $DisableSyncAppvPublishingServerExe, 'Is' & $arrBlockSponsors[147] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3249}')
   CheckBoxSponsorBlock($idCheckbox148, $DisableSyncAppvPublishingServerVbs, 'Is' & $arrBlockSponsors[148] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3250}')
   CheckBoxSponsorBlock($idCheckbox149, $DisableSyssetupDll, 'Is' & $arrBlockSponsors[149] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3251}')
   CheckBoxSponsorBlock($idCheckbox150, $DisableTeExe, 'Is' & $arrBlockSponsors[150] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3252}')
   CheckBoxSponsorBlock($idCheckbox151, $DisableTrackerExe, 'Is' & $arrBlockSponsors[151] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3253}')
   CheckBoxSponsorBlock($idCheckbox152, $DisableUrlDll, 'Is' & $arrBlockSponsors[152] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3254}')
   CheckBoxSponsorBlock($idCheckbox153, $DisableVerClsidExe, 'Is' & $arrBlockSponsors[153] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3255}')
   CheckBoxSponsorBlock($idCheckbox154, $DisableVsJitDebuggerExe, 'Is' & $arrBlockSponsors[154] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3256}')
   CheckBoxSponsorBlock($idCheckbox155, $DisableWabExe, 'Is' & $arrBlockSponsors[155] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3257}')
   CheckBoxSponsorBlock($idCheckbox156, $DisableWinrmVbs, 'Is' & $arrBlockSponsors[156] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3258}')
   CheckBoxSponsorBlock($idCheckbox157, $DisableWsresetExe, 'Is' & $arrBlockSponsors[157] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3259}')
   CheckBoxSponsorBlock($idCheckbox158, $DisableXwizardExe, 'Is' & $arrBlockSponsors[158] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3260}')
   CheckBoxSponsorBlock($idCheckbox159, $DisableZipfldrDll, 'Is' & $arrBlockSponsors[159] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3261}')
   CheckBoxSponsorBlock($idCheckbox160, $DisableAddInProcessExe, 'Is' & $arrBlockSponsors[160] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3262}')
   CheckBoxSponsorBlock($idCheckbox161, $DisableAddInProcess32Exe, 'Is' & $arrBlockSponsors[161] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3263}')
   CheckBoxSponsorBlock($idCheckbox162, $DisableAddInUtilExe, 'Is' & $arrBlockSponsors[162] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3264}')
   CheckBoxSponsorBlock($idCheckbox163, $DisableKillExe, 'Is' & $arrBlockSponsors[163] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3265}')
   CheckBoxSponsorBlock($idCheckbox164, $DisableLxrunExe, 'Is' & $arrBlockSponsors[164] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3266}')
   CheckBoxSponsorBlock($idCheckbox165, $DisablePowershellCustomHostExe, 'Is' & $arrBlockSponsors[165] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3267}')
   CheckBoxSponsorBlock($idCheckbox166, $DisableTextTransformExe, 'Is' & $arrBlockSponsors[166] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3268}')
   CheckBoxSponsorBlock($idCheckbox167, $DisableWfcExe, 'Is' & $arrBlockSponsors[167] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3269}')
   CheckBoxSponsorBlock($idCheckbox168, $DisableWslExe, 'Is' & $arrBlockSponsors[168] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3270}')
   CheckBoxSponsorBlock($idCheckbox169, $DisableWslconfigExe, 'Is' & $arrBlockSponsors[169] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3271}')
   CheckBoxSponsorBlock($idCheckbox170, $DisableWslhostExe, 'Is' & $arrBlockSponsors[170] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3272}')

   CheckBoxSponsorBlock($idCheckbox171, $DisableRDPShellExe, 'Is' & $arrBlockSponsors[171] & 'Blocked', '{1016bbe0-a716-428b-822e-5E544B6A3273}')

;**********

EndFunc




Func WM_VSCROLL($hWnd, $iMsg, $wParam, $lParam)
    #forceref $iMsg, $wParam, $lParam
    Local $iScrollCode = BitAND($wParam, 0x0000FFFF)
    Local $iIndex = -1, $iCharY, $iPosY
    Local $iMin, $iMax, $iPage, $iPos, $iTrackPos

    For $x = 0 To UBound($__g_aSB_WindowInfo) - 1
        If $__g_aSB_WindowInfo[$x][0] = $hWnd Then
            $iIndex = $x
            $iCharY = $__g_aSB_WindowInfo[$iIndex][3]
            ExitLoop
        EndIf
    Next
    If $iIndex = -1 Then Return 0

    ; Get all the vertial scroll bar information
    Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_VERT)
    $iMin = DllStructGetData($tSCROLLINFO, "nMin")
    $iMax = DllStructGetData($tSCROLLINFO, "nMax")
    $iPage = DllStructGetData($tSCROLLINFO, "nPage")
    ; Save the position for comparison later on
    $iPosY = DllStructGetData($tSCROLLINFO, "nPos")
    $iPos = $iPosY
    $iTrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")


    Switch $iScrollCode
        Case $SB_TOP ; user clicked the HOME keyboard key
            DllStructSetData($tSCROLLINFO, "nPos", $iMin)

        Case $SB_BOTTOM ; user clicked the END keyboard key
            DllStructSetData($tSCROLLINFO, "nPos", $iMax)

        Case $SB_LINEUP ; user clicked the top arrow
            DllStructSetData($tSCROLLINFO, "nPos", $iPos - 1)

        Case $SB_LINEDOWN ; user clicked the bottom arrow
            DllStructSetData($tSCROLLINFO, "nPos", $iPos + 1)

        Case $SB_PAGEUP ; user clicked the scroll bar shaft above the scroll box
            DllStructSetData($tSCROLLINFO, "nPos", $iPos - $iPage)

        Case $SB_PAGEDOWN ; user clicked the scroll bar shaft below the scroll box
            DllStructSetData($tSCROLLINFO, "nPos", $iPos + $iPage)

        Case $SB_THUMBTRACK ; user dragged the scroll box
            DllStructSetData($tSCROLLINFO, "nPos", $iTrackPos)
        Case Else
    EndSwitch

    ; // Set the position and then retrieve it.  Due to adjustments
    ; //   by Windows it may not be the same as the value set.

    DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
    _GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
    _GUIScrollBars_GetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
    ;// If the position has changed, scroll the window and update it
    $iPos = DllStructGetData($tSCROLLINFO, "nPos")

    If ($iPos <> $iPosY) Then
       _GUIScrollBars_ScrollWindow($hWnd, 0, $iCharY * ($iPosY - $iPos))

        $iPosY = $iPos
    EndIf

    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_VSCROLL


Func Arr_GetSponsorNames()

;Uses global value $NumberOfExecutables
; Make room for  elements
;Global $arrBlockSponsors[$NumberOfExecutables + 1] 
;Assign the names of blocked executables
$arrBlockSponsors[0] = $NumberOfExecutables
$arrBlockSponsors[1] = 'attrib.exe'
$arrBlockSponsors[2] = 'auditpol.exe'
$arrBlockSponsors[3] = 'bcdboot.exe'
$arrBlockSponsors[4] = 'bcdedit.exe'
$arrBlockSponsors[5] = 'bitsadmin.exe'
$arrBlockSponsors[6] = 'bootcfg.exe'
$arrBlockSponsors[7] = 'bootim.exe'
$arrBlockSponsors[8] = 'bootsect.exe'
$arrBlockSponsors[9] = 'ByteCodeGenerator.exe'
$arrBlockSponsors[10] = 'cacls.exe'
$arrBlockSponsors[11] = 'icacls.exe'
$arrBlockSponsors[12] = 'Csc.exe'
$arrBlockSponsors[13] = 'debug.exe'
$arrBlockSponsors[14] = 'dfsvc.exe'
$arrBlockSponsors[15] = 'diskpart.exe'
$arrBlockSponsors[16] = 'eventvwr.exe'
$arrBlockSponsors[17] = 'hh.exe'
$arrBlockSponsors[18] = 'ieexec.exe'
$arrBlockSponsors[19] = 'iexplore.exe'
$arrBlockSponsors[20] = 'iexpress.exe'
$arrBlockSponsors[21] = 'Ilasm.exe'
$arrBlockSponsors[22] = 'InstallUtilLib*'
$arrBlockSponsors[23] = 'InstallUtil.exe'
$arrBlockSponsors[24] = 'journal.exe'
$arrBlockSponsors[25] = 'Jsc.exe'
$arrBlockSponsors[26] = 'mmc.exe'
$arrBlockSponsors[27] = 'mrsa.exe'
$arrBlockSponsors[28] = 'MsBuild.exe'
$arrBlockSponsors[29] = 'mshta.exe'
$arrBlockSponsors[30] = 'mstsc.exe'
$arrBlockSponsors[31] = 'netsh.exe'
$arrBlockSponsors[32] = 'netstat.exe'
$arrBlockSponsors[33] = 'PresentationHost.exe'
$arrBlockSponsors[34] = 'quser.exe'
$arrBlockSponsors[35] = 'reg.exe'
$arrBlockSponsors[36] = 'RegAsmGlobal*'
$arrBlockSponsors[37] = 'regini.exe'
$arrBlockSponsors[38] = 'RegSvcs.exe'
$arrBlockSponsors[39] = 'regsvr32.exe'
$arrBlockSponsors[40] = 'RunLegacyCPLElevated.exe'
$arrBlockSponsors[41] = 'runonce.exe'
$arrBlockSponsors[42] = 'runas.exe'
$arrBlockSponsors[43] = '*script.exe'
$arrBlockSponsors[44] = 'set.exe'
$arrBlockSponsors[45] = 'setx.exe'
$arrBlockSponsors[46] = 'stash*'
$arrBlockSponsors[47] = 'systemreset.exe'
$arrBlockSponsors[48] = 'takeown.exe'
$arrBlockSponsors[49] = 'taskkill.exe'
$arrBlockSponsors[50] = 'UserAccountControlSettings.exe'
$arrBlockSponsors[51] = 'Vbc.exe'
$arrBlockSponsors[52] = 'vssadmin.exe'
$arrBlockSponsors[53] = 'wmic.exe'
$arrBlockSponsors[54] = 'xcacls.exe'

; The second list
$arrBlockSponsors[55] = 'Aspnet_Compiler.exe'
$arrBlockSponsors[56] = 'bash.exe'
$arrBlockSponsors[57] = 'bginfo.exe'
$arrBlockSponsors[58] = 'bitsadmin*'
$arrBlockSponsors[59] = 'cdb.exe'
$arrBlockSponsors[60] = 'csi.exe'
$arrBlockSponsors[61] = 'Cvtres.exe'
$arrBlockSponsors[62] = 'dbghost.exe'
$arrBlockSponsors[63] = 'dbgsvc.exe'
$arrBlockSponsors[64] = 'dnx.exe'
$arrBlockSponsors[65] = 'fsi.exe'
$arrBlockSponsors[66] = 'FsiAnyCpu.exe'
$arrBlockSponsors[67] = 'InfDefaultInstall.exe'
$arrBlockSponsors[68] = 'InstallUtil*'
$arrBlockSponsors[69] = 'kd.exe'
$arrBlockSponsors[70] = 'lpkinstall*'
$arrBlockSponsors[71] = 'LxssManager.dll'
$arrBlockSponsors[72] = 'msiexec.exe'
$arrBlockSponsors[73] = 'ntkd.exe'
$arrBlockSponsors[74] = 'ntsd.exe'
$arrBlockSponsors[75] = 'odbcconf.exe'
$arrBlockSponsors[76] = 'rcsi.exe'
$arrBlockSponsors[77] = 'RegAsm*'
$arrBlockSponsors[78] = 'RegSvcs*'
$arrBlockSponsors[79] = 'RunScriptHelper.exe'
$arrBlockSponsors[80] = 'schtasks.exe'
$arrBlockSponsors[81] = 'scrcons.exe'
$arrBlockSponsors[82] = 'sdbinst.exe'
$arrBlockSponsors[83] = 'sdclt.exe'
$arrBlockSponsors[84] = 'syskey.exe'
$arrBlockSponsors[85] = 'utilman.exe'
$arrBlockSponsors[86] = 'VisualUiaVerifyNative.exe'
$arrBlockSponsors[87] = 'wbemtest.exe'
$arrBlockSponsors[88] = 'windbg.exe'

;additional list
$arrBlockSponsors[89] = 'at.exe'
$arrBlockSponsors[90] = 'advpack.dll'
$arrBlockSponsors[91] = 'appvlp.exe'
$arrBlockSponsors[92] = 'atbroker.exe'
$arrBlockSponsors[93] = 'certutil.exe'
$arrBlockSponsors[94] = 'CL_Invocation.ps1*'
$arrBlockSponsors[95] = 'CL_Mutexverifiers.ps1*'
$arrBlockSponsors[96] = 'cmdkey.exe'
$arrBlockSponsors[97] = 'cmstp.exe'
$arrBlockSponsors[98] = 'control.exe'
$arrBlockSponsors[99] = 'diskshadow.exe'
$arrBlockSponsors[100] = 'dnscmd.exe'
$arrBlockSponsors[101] = 'dxcap.exe'
$arrBlockSponsors[102] = 'esentutl.exe'
$arrBlockSponsors[103] = 'expand.exe'
$arrBlockSponsors[104] = 'extexport.exe'
$arrBlockSponsors[105] = 'extrac32.exe'
$arrBlockSponsors[106] = 'findstr.exe'
$arrBlockSponsors[107] = 'forfiles.exe'
$arrBlockSponsors[108] = 'ftp.exe'
$arrBlockSponsors[109] = 'gpscript.exe'
$arrBlockSponsors[110] = 'ie4uinit.exe'
$arrBlockSponsors[111] = 'ieadvpack.dll'
$arrBlockSponsors[112] = 'ieaframe.dll'
$arrBlockSponsors[113] = 'jscript*.dll*'
$arrBlockSponsors[114] = 'makecab.exe'
$arrBlockSponsors[115] = 'manage-bde.wsf*'
$arrBlockSponsors[116] = 'mavinject.exe'
$arrBlockSponsors[117] = 'mftrace.exe'
$arrBlockSponsors[118] = 'Microsoft.Workflow.Compiler.exe'
$arrBlockSponsors[119] = 'msconfig.exe'
$arrBlockSponsors[120] = 'msdeploy.exe'
$arrBlockSponsors[121] = 'msdt.exe'
$arrBlockSponsors[122] = 'mshtml.dll'
$arrBlockSponsors[123] = 'mspub.exe'
$arrBlockSponsors[124] = 'msra.exe'
$arrBlockSponsors[125] = 'msxsl.exe'
$arrBlockSponsors[126] = 'pcalua.exe'
$arrBlockSponsors[127] = 'pcwrun.exe'
$arrBlockSponsors[128] = 'pcwutl.dll'
$arrBlockSponsors[129] = 'pester.bat*'
$arrBlockSponsors[130] = 'print.exe'
$arrBlockSponsors[131] = 'psr.exe'
$arrBlockSponsors[132] = 'pubprn.vbs*'
$arrBlockSponsors[133] = 'regedit.exe'
$arrBlockSponsors[134] = 'register-cimprovider.exe'
$arrBlockSponsors[135] = 'replace.exe'
$arrBlockSponsors[136] = 'robocopy.exe'
$arrBlockSponsors[137] = 'rpcping.exe'
$arrBlockSponsors[138] = 'sc.exe'
$arrBlockSponsors[139] = 'scriptrunner.exe'
$arrBlockSponsors[140] = 'setupapi.dll'
$arrBlockSponsors[141] = 'shdocvw.dll'
$arrBlockSponsors[142] = 'shell32.dll'
$arrBlockSponsors[143] = 'slmgr.vbs*'
$arrBlockSponsors[144] = 'sqldumper.exe'
$arrBlockSponsors[145] = 'sqlps.exe'
$arrBlockSponsors[146] = 'SQLToolsPS.exe'
$arrBlockSponsors[147] = 'SyncAppvPublishingServer.exe'
$arrBlockSponsors[148] = 'SyncAppvPublishingServer.vbs*'
$arrBlockSponsors[149] = 'syssetup.dll'
$arrBlockSponsors[150] = 'te.exe'
$arrBlockSponsors[151] = 'tracker.exe'
$arrBlockSponsors[152] = 'url.dll'
$arrBlockSponsors[153] = 'verclsid.exe'
$arrBlockSponsors[154] = 'vsjitdebugger.exe'
$arrBlockSponsors[155] = 'wab.exe'
$arrBlockSponsors[156] = 'winrm.vbs'
$arrBlockSponsors[157] = 'wsreset.exe'
$arrBlockSponsors[158] = 'xwizard.exe'
$arrBlockSponsors[159] = 'zipfldr.dll'
$arrBlockSponsors[160] = 'AddInProcess.exe'
$arrBlockSponsors[161] = 'AddInProcess32.exe'
$arrBlockSponsors[162] = 'AddInUtil.exe'
$arrBlockSponsors[163] = 'kill.exe'
$arrBlockSponsors[164] = 'lxrun.exe'
$arrBlockSponsors[165] = 'PowershellCustomHost.exe'
$arrBlockSponsors[166] = 'TextTransform.exe'
$arrBlockSponsors[167] = 'wfc.exe'
$arrBlockSponsors[168] = 'wsl.exe'
$arrBlockSponsors[169] = 'wslconfig.exe'
$arrBlockSponsors[170] = 'wslhost.exe'
$arrBlockSponsors[171] = 'rdpshell.exe'
EndFunc


Func BlockAllSponsors()

; Write data to ...\safer\CodeIdentifiers\0\Paths

Local $partkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-5E544B6A31'
RegWrite($partkey & '00}', 'Description','REG_SZ','PowerShell')
RegWrite($partkey & '00}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & '00}', 'ItemData','REG_SZ','powershell.exe')
RegWrite($partkey & '01}', 'Description','REG_SZ','PowerShell_ise')
RegWrite($partkey & '01}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & '01}', 'ItemData','REG_SZ','powershell_ise.exe')
RegWrite($partkey & '02}', 'Description','REG_SZ','Windows CMD')
RegWrite($partkey & '02}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & '02}', 'ItemData','REG_SZ','cmd.exe')

Local $partkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-5E544B6A3'
For $i = 103 To $NumberOfExecutables + 102
RegWrite($partkey & $i & '}', 'Description','REG_SZ',$arrBlockSponsors[$i-102])
RegWrite($partkey & $i & '}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & $i & '}', 'ItemData','REG_SZ',$arrBlockSponsors[$i-102])
Next

; Write data to ...\safer_Hard_Configurator\CodeIdentifiers\BlockSponsors
$key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers\BlockSponsors'
RegWrite($key, 'IsCMDBlocked','REG_DWORD',Number('1'))
RegWrite($key, 'IsPowerShellBlocked','REG_DWORD',Number('1'))
RegWrite($key, 'IsPowerShell_iseBlocked','REG_DWORD',Number('1'))

For $i = 103 To $NumberOfExecutables + 102
 RegWrite($key, 'Is' & $arrBlockSponsors[$i-102] & 'Blocked','REG_DWORD',Number('1'))
Next
DeleteSwichSponsors()
EndFunc


Func DeleteSwichSponsors()
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers\SwitchBlockSponsors')
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers\SwitchOFF')
RegWrite('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers', 'TurnOFFAllSRP', 'REG_SZ', "0")
EndFunc



Func BlockAllSponsors1()
BlockAllSponsors()
$RefreshChangesCheck = $RefreshChangesCheck & "AllSponsors" & @LF
CheckStateOfSponsorsCheckboxes()
EndFunc



Func AllowAllSponsors()
Local $partkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-5E544B6A3'
For $i = 100 To $NumberOfExecutables + 102
  RegDelete($partkey & $i & '}')
Next
RegDelete('HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers\BlockSponsors')
EndFunc


Func AllowAllSponsors1()
  AllowAllSponsors()
$RefreshChangesCheck = $RefreshChangesCheck & "AllSponsors" & @LF
  CheckStateOfSponsorsCheckboxes()
DeleteSwichSponsors()
EndFunc



Func BlockScriptInterpretersON()
; Write data to ...\safer\CodeIdentifiers\0\Paths
Local $partkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-5E544B6A3'
RegWrite($partkey & '100}', 'Description','REG_SZ','PowerShell')
RegWrite($partkey & '100}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & '100}', 'ItemData','REG_SZ','powershell.exe')
RegWrite($partkey & '101}', 'Description','REG_SZ','PowerShell_ise')
RegWrite($partkey & '101}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & '101}', 'ItemData','REG_SZ','powershell_ise.exe')
RegWrite($partkey & '102}', 'Description','REG_SZ','Windows CMD')
RegWrite($partkey & '102}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & '102}', 'ItemData','REG_SZ','cmd.exe')
RegWrite($partkey & '107}', 'Description','REG_SZ','forfiles.exe')
RegWrite($partkey & '107}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & '107}', 'ItemData','REG_SZ','forfiles.exe')
RegWrite($partkey & '119}', 'Description','REG_SZ','HH.exe')
RegWrite($partkey & '119}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & '119}', 'ItemData','REG_SZ','HH.exe')
RegWrite($partkey & '131}', 'Description','REG_SZ','Mshta.exe')
RegWrite($partkey & '131}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & '131}', 'ItemData','REG_SZ','Mshta.exe')
RegWrite($partkey & '145}', 'Description','REG_SZ','*script.exe')
RegWrite($partkey & '145}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & '145}', 'ItemData','REG_SZ','*script.exe')
RegWrite($partkey & '155}', 'Description','REG_SZ','Wmic.exe')
RegWrite($partkey & '155}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & '155}', 'ItemData','REG_SZ','Wmic.exe')

Local  $key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers\BlockSponsors'
RegWrite($key, 'IsCMDBlocked','REG_DWORD',Number('1'))
RegWrite($key, 'IsPowerShellBlocked','REG_DWORD',Number('1'))
RegWrite($key, 'IsPowerShell_iseBlocked','REG_DWORD',Number('1'))
RegWrite($key, 'IsHH.exeBlocked','REG_DWORD',Number('1'))
RegWrite($key, 'IsMshta.exeBlocked','REG_DWORD',Number('1'))
RegWrite($key, 'Is*script.exeBlocked','REG_DWORD',Number('1'))
RegWrite($key, 'Isforfiles.exeBlocked','REG_DWORD',Number('1'))
RegWrite($key, 'IsWmic.exeBlocked','REG_DWORD',Number('1'))

DeleteSwichSponsors()

EndFunc



Func BlockScriptInterpretersON1()
  BlockScriptInterpretersON()
  $RefreshChangesCheck = $RefreshChangesCheck & "ScriptInterpreters" & @LF
  CheckStateOfSponsorsCheckboxes()
EndFunc


Func BlockScriptInterpretersOFF()
  Local $partkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-5E544B6A3'
  RegDelete($partkey & '100}')
  RegDelete($partkey & '101}')
  RegDelete($partkey & '102}')
  RegDelete($partkey & '107}')
  RegDelete($partkey & '119}')
  RegDelete($partkey & '131}')
  RegDelete($partkey & '145}')
  RegDelete($partkey & '155}')

  Local  $key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers\BlockSponsors'
  RegDelete($key, 'IsCMDBlocked')
  RegDelete($key, 'IsPowerShellBlocked')
  RegDelete($key, 'IsPowerShell_iseBlocked')
  RegDelete($key, 'IsHH.exeBlocked')
  RegDelete($key, 'IsMshta.exeBlocked')
  RegDelete($key, 'Is*script.exeBlocked')
  RegDelete($key, 'Isforfiles.exeBlocked')
  RegDelete($key, 'IsWmic.exeBlocked')

  DeleteSwichSponsors()
EndFunc


Func BlockScriptInterpretersOFF1()
  BlockScriptInterpretersOFF()
  $RefreshChangesCheck = $RefreshChangesCheck & "ScriptInterpreters" & @LF
  CheckStateOfSponsorsCheckboxes()
EndFunc



Func BlockSponsorsEnhancedON()

; Write data to ...\safer\CodeIdentifiers\0\Paths
Local $partkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-5E544B6A3'
; Write data to ...\safer_Hard_Configurator\CodeIdentifiers\BlockSponsors
Local $key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers\BlockSponsors'
RegWrite($partkey & '100}', 'Description','REG_SZ','PowerShell')
RegWrite($partkey & '100}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & '100}', 'ItemData','REG_SZ','powershell.exe')
RegWrite($partkey & '101}', 'Description','REG_SZ','PowerShell_ise')
RegWrite($partkey & '101}', 'SaferFlags','REG_DWORD',Number('0'))
RegWrite($partkey & '101}', 'ItemData','REG_SZ','powershell_ise.exe')
RegWrite($key, 'IsPowerShellBlocked','REG_DWORD',Number('1'))
RegWrite($key, 'IsPowerShell_iseBlocked','REG_DWORD',Number('1'))
For $i=102 to $NumberOfExecutables + 102
  If ($i=107 or $i=114 or $i=119 or $i=120 or $i=121 or $i=125 or $i=130 or $i=131 or $i=135 or $i=137 or $i=139 or $i=140 or $i=155 or $i=158 or $i=179 or $i=182 or $i=190 or $i=209 or $i=240) Then 
     RegWrite($partkey & $i & '}', 'Description','REG_SZ',$arrBlockSponsors[$i-102])
     RegWrite($partkey & $i & '}', 'SaferFlags','REG_DWORD',Number('0'))
     RegWrite($partkey & $i & '}', 'ItemData','REG_SZ',$arrBlockSponsors[$i-102])
     RegWrite($key, 'Is' & $arrBlockSponsors[$i-102] & 'Blocked','REG_DWORD',Number('1'))
  EndIf
Next
DeleteSwichSponsors()

EndFunc



Func BlockSponsorsEnhancedON1()
  BlockSponsorsEnhancedON()
  $RefreshChangesCheck = $RefreshChangesCheck & "SponsorsEnhanced" & @LF
  CheckStateOfSponsorsCheckboxes()
EndFunc



Func BlockSponsorsEnhancedOFF()
Local $partkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-5E544B6A3'
Local  $key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers\BlockSponsors'
  RegDelete($partkey & '100}')
  RegDelete($partkey & '101}')
  RegDelete($key, 'IsPowerShellBlocked')
  RegDelete($key, 'IsPowerShell_iseBlocked')
  For $i=102 to $NumberOfExecutables + 102
     If ($i=107 or $i=114 or $i=119 or $i=120 or $i=121 or $i=125 or $i=130 or $i=131 or $i=135 or $i=137 or $i=139 or $i=140 or $i=155 or $i=158 or $i=179 or $i=182 or $i=190 or $i=209 or $i=240) Then 
        RegDelete($partkey & $i & '}')
        RegDelete($key, 'Is' & $arrBlockSponsors[$i-102] & 'Blocked')
     EndIf
  Next
DeleteSwichSponsors()
EndFunc



Func BlockSponsorsEnhancedOFF1()
  BlockSponsorsEnhancedOFF()
  $RefreshChangesCheck = $RefreshChangesCheck & "SponsorsEnhanced" & @LF
  CheckStateOfSponsorsCheckboxes()
EndFunc


Func EnableShdocvwDLL()
Local $partkey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\CodeIdentifiers\0\Paths\{1016bbe0-a716-428b-822e-5E544B6A3'
Local  $key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\safer_Hard_Configurator\CodeIdentifiers\BlockSponsors'
RegDelete($partkey & '243' & '}')
RegDelete($key, 'Is' & $arrBlockSponsors[141] & 'Blocked')
$RefreshChangesCheck = $RefreshChangesCheck & "EnableShdocvwDLL" & @LF
;CheckStateOfSponsorsCheckboxes()
DeleteSwichSponsors()
EndFunc



Func SortedPosition($SponsorName, $arraySorted)

Local $position = _ArraySearch($arraySorted, $SponsorName) + 1
If @error Then Return 0
;MsgBox(0,"",$position & "    " & $SponsorName)
If UBound(_ArrayFindAll($arraySorted, $SponsorName)) > 1 Then MsgBox(0,"Double entry",$position & "    " & $SponsorName)
Return $position

EndFunc
