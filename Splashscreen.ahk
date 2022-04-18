; Splashscreen.ahk
; show a splash screen
; Written by Michael Casey
; Copyright Michael Casey
; This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
;
;
;
; every 30 seconds move the mouse alternately 1 pixel down and to the right and 1 pixel to the left and up
; press win z to toggle the splash screen or it automatically comes on after 5 minutes of inactivity


; optional win q to disable the script
;#q::
;ExitApp
;return

; this has to go first otherwise it doesn't work, this is the auto-execute section
; move the mouse one pixel every X seconds (20 or 30 works well)

#Persistent
; need the following two for A_TimeIdlePhysical to work and #z to reset the timer
#InstallMouseHook
#InstallKeybdHook

; put all global variables in the first section
toggle:= 1
oddeven:= 1
ClipKeys = 1234567890


; read the config file
i := 0
Loop, read, Splashscreen_config.txt
{
	i  += 1
    StringSplit, config%i%, A_LoopReadLine, ";", %A_Space%%A_Tab%
}
; first value is mouse move frequency in seconds
mmf := config11 * 1000 ; to convert  to milliseconds
; second value is auto show splash screen in minutes
ass := config21 * 60000 ; to convert  to milliseconds
; third value is show mode (OffOrImage) =0 is  show a splash screen on primary and black image on the rest of the screens, =1 show splash screen on primary, turn other screens off,  =2 turn all screens off
ooi := config31

	;splashTextOn,,, mmf = %mmf%
	;Sleep 3000
	;SplashTextOff
	;Sleep 1000
	;splashTextOn,,, ass %ass%
	;Sleep 3000
	;SplashTextOff

SetTimer, Alert1, %mmf%
return

Alert1:
if (oddeven = 1)
{
	; move mouse one pixel to the right and down
	MouseMove, 1, 1, 50, R
	oddeven:= 0
}
else
{
	; move one pixel to the left and up
	MouseMove, -1, -1, 50, R
	oddeven:= 1
}
	;splashTextOn,,, %A_TimeIdlePhysical%
	;Sleep 3000
	;SplashTextOff
if (toggle = 1) and (ass > 0)
{
	if (A_TimeIdlePhysical > ass)
	{
		; automatically toggle splash screen
		Gosub, #z
	}
}


; allow the blanking part
#z::
{
	if (toggle = 1)
	{
		;MsgBox, MonitorLeft: `t%MonitorLeft% `nMonitorTop: `t%MonitorTop% `nMonitorRight: `t%MonitorRight% `nMonitorBottom:  `t%MonitorBottom%

		if (ooi = 0)
		{
			; now go through all the monitors putting a black GUI on top
			SysGet, MonitorCount, MonitorCount
			Loop, %MonitorCount%
			{
				SysGet, Monitor, Monitor, %A_Index%
				mon_w :=  MonitorRight - MonitorLeft
				mon_h :=  MonitorBottom - MonitorTop

				; now show the blackscreen on all the monitors
				Gui, g%A_Index%:New
				Gui, g%A_Index%:Color , Black
				Gui, g%A_Index%:+AlwaysOnTop -Caption +ToolWindow
				Gui, g%A_Index%:Show,  X%MonitorLeft% Y%MonitorTop% w%mon_w% H%mon_h% NA
			}

			; get the size of the primary window on which the splash image will be displayed
			SysGet, MonitorPrimary, MonitorPrimary
			SysGet, Monitor, Monitor, MonitorPrimary
			;%MonitorLeft% %MonitorTop% %MonitorRight% %MonitorBottom%
			mprime_w :=  MonitorRight - MonitorLeft
			mprime_h :=  MonitorBottom - MonitorTop

			; add a splash image to the primary monitor only
			Gui, g%MonitorPrimary%:Add, Picture, w%mprime_w% H%mprime_h% ,splash.jpg
		}
		toggle = 0
	}
	else
	{
		; destroy the gui's
		; go through all the monitors destroying the gui's including the prime monitor with the splash image
		SysGet, MonitorCount, MonitorCount
		Loop, %MonitorCount%
		{
			Gui,g%A_Index%:Destroy
		}
		toggle = 1
	}
}



return



ExitApp
