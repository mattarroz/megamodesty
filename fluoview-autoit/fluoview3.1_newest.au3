#include <Math.au3>
#include <GuiSlider.au3>
#include <Array.au3>

; ----------------------------------------------------------------
; General Parameters for AutoExecution
; ----------------------------------------------------------------
Opt("WinTitleMatchMode", 1)
Opt("WinSearchChildren", 1)
Opt("CaretCoordMode", 2)
Opt("MouseCoordMode", 2) ; mouse coords are relative coords to the client area of the active window

; TimeOut for ExecuteTScan
; IMPORTANT: should be greater than normal acquisition time
$timeout = 20

Dim $check[2]
$check[0] = "UnCheck"
$check[1] = "Check"

;WHAT MICROSCOPE
If IsDeclared("microscope") Then
   $oldconfocal = $microscope 
Else
   $oldconfocal = 1 ;1 new confocal: set value to 0; for old confocal set value to 1
EndIf

;AREA CONSTANTS (Window Acquisition Setting/Area)
   $PanXMin=-800
   $PanXMax=800
   $PanYMin=-800
   $PanYMax=800

;PMT WAVELENGTHS (Light Path & Dyes)
   $PMT_Wavelength_Min=400
   $PMT_Wavelength_Max=800
   
;List of Window Names
   $W_OF       = "Olympus Fluoview"
   $W_IAC      = "Image Acquisition Control"
   $W_AS       = "Acquisition Setting"
   $W_LP       = "LightPath & Dyes"
   $W_LV       = "Live View"
   $W_MC	   = "Microscope Controller"
   $W_XY_RPL   = "Registered Point List"
   $W_XY_MATLC = "Multi Area Time Lapse Controller"
   $W_XY_TC    = "TimeController" ; feedback window in XY stage
   $W_XY_MATL  = "Multi Area Time Lapse" ; error window when aborting to open new FileChangeDir
   $W_XY_SZA   = "Shift Z axis"
   $W_XY_SC    = "Stage Controller"
   $W_SYM      = " SymPhoTime-RC"
   $W_HDDLG    = "Please set a destination file."




;Activate Window of Olympus Fluoview
If WinActive("OLYMPUS FLUOVIEW") = 0 Then
   WinActivate("OLYMPUS FLUOVIEW")
EndIf




; ----------------------------------------------------------------
; List of Implemented Functions
; ----------------------------------------------------------------
;TCPStartup()
;executeFLIMMeasurement(5,"E:\MTUser\Matthias Reis\testreal1.pt3")
;TCPShutdown()
;GoToSlice(13)
;SetPointScan(1,5)
;SetHardDiskRecording(0,"c:\test3")
;SetHardDiskRecording(1,"\\biodata\thbp\Matthias\FluoView-Automatisierung\AutoFocus-Bilder\autofocus-stack2")

;GetHardDiskRecState() ;0=inactivated, 1=activated
;GetHardDiskRecPath()
;SetEPILampStatus(0)
;SetNFrames(30)
;SetZZero()
;MsgBox(0, "bla",GetZPos())
;SetZSlices(0, 25)
;SetZStepSize(0, 0.9)
;SetZStart("-2.1727")
;SetZStop(5.8232)
;Execute_ScanXY_LZt()
;Execute_ScanXYRepeat()
;Execute_StopScan()
;Execute_TScan("00:00:12", 3)
;Execute_ZScan(-1.0,1.0,1.0)
;SetLightBulbStatus(0)
;  GetLightBulbStatus()
;  GetEPILampStatus()
;  SetBrightFieldStatus(1) please use the following function instead: SetTD1($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
;  GetBrightFieldStatus(); returns if bright field acquisition was checked or not

;SetLaser(6,1) ; ($laser, $state)
;	GetLaser(1) ; returns the on/off status of a laser line

;SetCHS1(0,6,1,705,1,0, 0) ;($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)  VOLTAGE NICHT zuverlaessig einstellbar!!! warum????
;  GetCHS1() ; returns settings for acquisition channel 1: [$state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power]
;SetCHS2(1,2,2,134,1,0, 0) ; VOLTAGE NICHT zuverlaessig einstellbar!!! warum????
;  GetCHS2() ; returns settings for acquisition channel 1: [$state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power]
;SetCHS3(1,2,3,734,1,0, 0) ; VOLTAGE NICHT zuverlaessig einstellbar!!! warum????
;  GetCHS3() ; returns settings for acquisition channel 1: [$state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power]
;SetTD1(-1,-2,-1,140,-1,-0, -30) ; VOLTAGE NICHT zuverlaessig einstellbar!!! warum????
;  GetTD1() ; returns settings for acquisition channel 1: [$state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power]
;SetRXD1(1,2,3,700,1,0, 30) ; VOLTAGE NICHT zuverlaessig einstellbar!!! warum????
;  GetRXD1() ; returns settings for acquisition channel 1: [$state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power]
;SetRXD2(1,2,3,700,1,0, 30) ; VOLTAGE NICHT zuverlaessig einstellbar!!! warum???? ($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
;  GetRXD2() ; returns settings for acquisition channel 1: [$state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power]

;SetExcitationDM("DM405/488/559/635")
;	GetExcitationDM() 
;SetEmissionDM1("Glass")
;	SetEmissionDM1()
;SetEmissionDM2("SDM510")
;	SetEmissionDM2()
;SetEmissionDM3("Mirror")
;	SetEmissionDM3()
;SetEmissionCh1(417, 600)
;	GetEmissionCh1() 
;SetEmissionCh2(555, 556)
;	GetEmissionCh2() 

;SetLScan(510, 620, 3, 33, 3)
;	GetLScan()
;SetScanType(1,0,0,0)
;setSequentialScan(0,"frame")
;  getSequentialScan
;SetTimeScan("00:00:05", "") ;($interval, $num)
;SetTimeScanInterval($interval) ; format: "hh:mm:ss.ms"
;  GetTimeScanInterval() ; returns format: "hh:mm:ss.ms"
;SetZoom(1.0)
;  GetZoom()
;SetEscapeObjective(0) ; "1"= escaped state; "0"=working state
;  GetEscapeObjective()
;HotKeySet("+!f", "SetFLIM") ;Shift-Alt-f
;HotKeySet("+!d", "SetOlympus") ;Shift-Alt-d
;SetPinhole(0, 120) ;"1"=auto, "0"=manual ;NOTE: diameter can be set only provided that $state is set to "1" (auto)
;	GetPinhole()
;setAcquisitionMode("oneway", 0, 5, 40, 0,0,0) ;($scanWay,$scanTypeRegion, $exposure,$stateAutoHV,$stateImageAdjust, $IA_outward, $IA_inward) not yet fully tested
;  getAcquisitionMode()
;ClearZSTartEnd()
;  GetNFrames()
;  GetZPos()
;  GetZStart()
;  GetZStop()
;  GetZSlices()
;  GetZSlicesStatus()
;  GetZStepSize()
;  GetZStepSizeStatus()
;ClearStartEndzPos()
;Execute_GoToZPos(200)
;SetLaser(5,1)
;SetScanningArea(0,-509.12,-509.12,5.0)
;  GetScanningArea()
;  GetAutoHVStatus()
;SetMicrController(3,-1,-1) ; currently, only setting mirror and the condenser works, setting EPIFilter does not work
;	GetMicrController() ;ERRROR: does not work yet, readout is always -1
;setObjective("LUCPLFLN  20X  NA:0.45") ;"UPLFN  10X 2 NA:0.30") ;"UPLSAPO  20X NA:0.75"
;  GetObjective()
;setDwellTime(40, 0) ;<------- funzt noch nicht
;  getDwellTime()
;  GetAutoHVStatus()
;SetFilterMode(0,0, 4) ; KalmanState, Line/Frame, KalmanRepetitions
; GetFilterMode()

;SetImageSize(1024)

;-----------------------------
; XY-Stage-related Functions
;-----------------------------
;XY_iniStage(1,1) 
;XY_RegisterPoint()
;XY_NewRegPointList(0, "")
;XY_OpenExistingRegPointList("TimeController.omp2",0, "deletemedooof.omp")
;XY_SaveRegPointListAs("DeleteMeTimeController.omp2")
;XY_SaveRegPointList()
;XY_ShiftZAxis(5) <--------- NOT FULLY IMPLEMENTED
;XY_ExecuteGetReady()
;XY_ExecuteRegPointList()
;XY_PauseExeRegPointList()
;XY_ContinueExeRegPointList()
;XY_StopExeRegPointList(0)
;XY_SetInterval("00:02:13.5")
;  XY_GetInterval()
;XY_SetRepeat(4)
;  XY_GetRepeat()
;  XY_GetTotalTime()
;  XY_GetFrameIntervalTime()
;XY_IsInitiated()
;  XY_GetXY()
;XY_OpenXYPos()
;XY_GotoXY(50,10)
;XY_MoveByXY(200,-40)

;-----------------------------
; CUSTOM COMPLEX SCRIPTS MS
;-----------------------------
;SetMSCustomzStackTDonly(1,2,1, 400,1, 0, 0.1, 1, 2.5,0, 5,8, 0, 0,1, 0) ; MS customized
;SetzStackFromCurrentzPos(1, 2.5, 0, 5)
;SetMSCustomzStackFLandTD(1,2,1,700,1,0, 10, 1,2,1, 200,1, 0, -1, 1, 0.49, 0, 25, 8, 0, 1,1, 5) ; MS customized
;SetzStackFromCurrentzPos(1, 2, 0, 5)



;;;; Body of program would go here ;;;;


;While 1
;    Sleep(10)
;WEnd



;------------------------------------------
; SEMI-SCRIPTS making use of Funcs
;------------------------------------------
Func SetFLIM()
;   If WinActive("SymPhoTime-RC") = 0 Then
;	  WinActivate("SymPhoTime-RC")
;   EndIf
;   $tab = ControlCommand("SymPhoTime-RC", "", "[CLASSNN:TPageControl1]", "CurrentTab", "")
;   MsgBox(0, "bla", $tab)
;   If WinActive("OLYMPUS FLUOVIEW") = 0 Then
;	  WinActivate("OLYMPUS FLUOVIEW")
;   EndIf  
   SetEmissionDM1("Glass")
   SetLaser(2,0)
   SetLaser(5,1)
   Return
EndFunc   

;FIXME: funzt ab und zu nicht wegen latch des buttons
;~ Func executeFLIMMeasurement($nimages)
;~    WinActivate( $W_SYM, "")
;~    ControlClick($W_SYM, "", "[CLASS:TPanel; INSTANCE:3]")
;~    Sleep(1000)
;~    $test = ControlGetText($W_SYM, "", "[CLASS:TStatusBar; INSTANCE:1]")
;~    If StringInStr($test,"Record")==0 Then
;~ 	  WinActivate( $W_SYM, "")
;~ 	  ControlClick($W_SYM, "", "[CLASS:TPanel; INSTANCE:3]")
;~ 	  Sleep(1000)
;~    EndIf
;~    Execute_TScan("",$nimages)
;~    
;~    WinActivate( $W_SYM, "")
;~    ControlClick($W_SYM, "", "[CLASS:TPanel; INSTANCE:1]")
;~    sleep(1000)
;~   $test = ControlGetText($W_SYM, "", "[CLASS:TStatusBar; INSTANCE:1]")
;~    If StringInStr($test,"Record")>0 Then
;~ 	  WinActivate( $W_SYM, "")
;~ 	  ControlClick($W_SYM, "", "[CLASS:TPanel; INSTANCE:1]")
;~    EndIf
;~    Return 1
;~ EndFunc

Func executeFLIMMeasurement($nimages,$fname)
 Local $socket = TCPConnect("192.168.2.110", 33330)
; TCPSend ($socket, "PicoHarpNewMeasurement;")
 TCPSend($socket,"PicoHarpSaveMeasurement;"&$fname)
 Sleep(2000)
 TCPSend ($socket, "PicoHarpStartMeasurement;")
 Sleep(1000)
 Execute_TScan("",$nimages)
 Sleep(500)
 TCPSend ($socket, "PicoHarpStopMeasurement;")
 Sleep(1000)
 TCPSend($socket,"Exit")
 Sleep(3000)
 TCPCloseSocket ($socket)
EndFunc
 
Func executeStackFLIMMeasurement($stop, $stepsize,$zslices,$fname)
 Local $socket = TCPConnect("192.168.2.110", 33330)
; TCPSend ($socket, "PicoHarpNewMeasurement;")
 TCPSend($socket,"PicoHarpSaveMeasurement;"&$fname)
 Sleep(2000)
 TCPSend ($socket, "PicoHarpStartMeasurement;")
 Sleep(1000)
 Execute_ZScan($stop, $stepsize,$zslices)
 Sleep(500)
 TCPSend ($socket, "PicoHarpStopMeasurement;")
 Sleep(1000)
 TCPSend($socket,"Exit")
 Sleep(3000)
 TCPCloseSocket ($socket)
EndFunc

Func SetOlympus()
   SetEmissionDM1("Mirror")
   SetLaser(2,1)
   SetLaser(5,0)
   Return
EndFunc   

Func GoToSlice($slice)
   $targetpos = GetZStart()+$slice*GetZStepSize();(GetZStop()-GetZStart())/2+GetZStart()+$offset*GetZStepSize()
   Execute_GoToZPos($targetpos)
   Return 1
EndFunc

Func SetMSCustomzStackTDonly($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power, $ZStepSizeAutoStatus, $Zstepsize, $ZSliceAutoStatus, $Zslices,$dwelltime, $AutoHVStatus, $KalmanState,$LineState, $KalmanRepetitions)
   ; custom function for MS to quickly switch to 5x slices with dZ=3um brightfield images
   ; not yey finished
   ;Example: SetzStackTDonly(1,2,1, 200,1, 0, 0.1, 1, 2.5,0, 5,4, 0, 0,1, 0)
   ;switch off all other channels
   SetCHS1(0,-1,-1,-1,-1,-1, -1) ; ($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
   SetCHS2(0,-1,-1,-1,-1,-1, -1) ; ($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
   SetCHS3(0,-1,-1,-1,-1,-1, -1) ; ($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
   SetRXD1(0,-1,-1,-1,-1,-1, -1) ; ($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
   SetRXD2(0,-1,-1,-1,-1,-1, -1) ; ($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
   
   ;switch on TD? brightfield
   SetTD1($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power) ; ($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
   
   ;set zStack Parameters
   SetZStepSize($ZStepSizeAutoStatus, $Zstepsize)
   SetZSlices($ZSliceAutoStatus, $Zslices)
   setDwellTime($dwelltime, $AutoHVStatus) 
   SetFilterMode($KalmanState,$LineState, $KalmanRepetitions) ; KalmanState, Line/Frame, KalmanRepetitions
Return
EndFunc
   
Func SetMSCustomzStackFLandTD($stateCh1,$laserCh1,$groupCh1, $PMTVoltageCh1,$multiCh1, $cutOffPercCh1, $powerCh1,$stateTD,$laserTD,$groupTD, $PMTVoltageTD,$multiTD, $cutOffPercTD, $powerTD, $ZStepSizeAutoStatus, $Zstepsize, $ZSliceAutoStatus, $Zslices,$dwelltime, $AutoHVStatus, $KalmanState,$LineState, $KalmanRepetitions)
   ; custom function for MS to quickly switch to typical FL and TD parameters
   ; 
   ;
   ;Example: SetzStackFLandTD(1,2,1,700,1,0, 30, 1,2,1, 200,1, 0, -1, 1, 0.49, 0, 25, 8, 0, 1,1, 5)
   
   ;switch off all other channels
   SetCHS2(0,-1,-1,-1,-1,-1, -1) ; ($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
   SetCHS3(0,-1,-1,-1,-1,-1, -1) ; ($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
   SetRXD1(0,-1,-1,-1,-1,-1, -1) ; ($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
   SetRXD2(0,-1,-1,-1,-1,-1, -1) ; ($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
   
   ;switch on TD? brightfield
   SetTD1($stateTD,$laserTD,$groupTD, $PMTVoltageTD, $multiTD, $cutOffPercTD, $powerCh1) ; ($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
   
   ;switch on Ch1-FL
   SetCHS1($stateCh1,$laserCh1,$groupCh1, $PMTVoltageCh1,$multiCh1, $cutOffPercCh1, $powerCh1)
   
   ;set zStack Parameters
   SetZStepSize($ZStepSizeAutoStatus, $Zstepsize)
   SetZSlices($ZSliceAutoStatus, $Zslices)
   setDwellTime($dwelltime, $AutoHVStatus) 
   SetFilterMode($KalmanState,$LineState, $KalmanRepetitions) ; KalmanState, Line/Frame, KalmanRepetitions
Return
EndFunc

Func SetzStackFromCurrentzPos($ZStepSizeAutoStatus, $Zstepsize, $ZSliceAutoStatus, $Zslices)
   ; ATTENTION: apparently, clicking the execution-button motivates Olympus to reset to zSTack data, such that sth else will be recorded!!! <------ fix issue
   ;functions sets zStack such that from the current positions zSlices will be taken
   ;
   ;example: SetzStackFromCurrentzPos(1, 0.49, 0, 30)
   
   ; set scan type to "XY only"
   ;SetScanType(0,1,0,0)
   
   ;prepare
   ;ClearStartEndzPos() ;deletes starting and ending zPosition
   ;SetScanType(0,1,0,0) ; set scanning tzpe to zSTack
   
   SetZStepSize(0, 0.01)
   SetZSlices(0, 100)
   ;ClearStartEndzPos() ;deletes starting and ending zPosition for zStack
   
   
   ;set current pos as the starting position
   $start=GetZPos()-($Zstepsize/2)
   ;SetZStart($start)
   SetZStartFromCurrPos()
   
   $End=$start+(($Zslices-1)*$Zstepsize)
   SetZStop($start+($Zslices*$Zstepsize))
   
   ;set stepSize, etc
   SetZStepSize($ZStepSizeAutoStatus, $Zstepsize)
   SetZSlices($ZSliceAutoStatus, $Zslices)
   
   
   ; set scan type to "Depth"
   ;SetScanType(0,1,0,0) ; for reasons unkown it is vitally important to set this again (see above)
   
   Return
EndFunc


Func SetPointScan($xpos,$ypos)


;   setAcquisitionMode(-1,3, -1,-1,-1, -1, -1)

   ; set PointScan, FIXME: should use setAcquisitionMode
   ControlCommand($W_AS, "", "[CLASSNN:Button85]", $check[1], "")
   Sleep(100)
   ; get Position and size of the Live View window
   $size = WinGetPos("[TITLE:"&$W_LV&"; CLASS:Afx:00400000:20b:00010013:00000010:00000000; INSTANCE:1]")
   If $size == 0 Then MsgBox(0, "Text read was:", "bla")
   Sleep(500)   
   ; Click in the middle of the window to create a temporary point ROI
   MouseClick("left", $size[0] + $size[2]/2, $size[1] + $size[3]/2)
   ; Open right-click mouse menu
   MouseClick("right", $size[0] + $size[2]/2, $size[1] + $size[3]/2)
   Sleep(100)
   ; select the ROI manager
   Send("r")
   ; set x and y coordinates in the roi manager
   ControlSetText("[TITLE:ROI Manager;CLASS:Afx:00400000:b:00010013:00000010:00000000; INSTANCE:1]", "","[CLASS:Edit; INSTANCE:1]",$xpos)
   ControlSend("[TITLE:ROI Manager;CLASS:Afx:00400000:b:00010013:00000010:00000000; INSTANCE:1]", "", "[CLASS:Edit; INSTANCE:1]", "{ENTER}")
   ControlSetText("[TITLE:ROI Manager;CLASS:Afx:00400000:b:00010013:00000010:00000000; INSTANCE:1]", "","[CLASS:Edit; INSTANCE:2]",$ypos)
   ControlSend("[TITLE:ROI Manager;CLASS:Afx:00400000:b:00010013:00000010:00000000; INSTANCE:1]", "", "[CLASS:Edit; INSTANCE:2]", "{ENTER}") 
   WinClose("[TITLE:ROI Manager;CLASS:Afx:00400000:b:00010013:00000010:00000000; INSTANCE:1]")
   Return
EndFunc

; ----------------------------------------------------------------
; Execute or Stop Scans (Basic functions, no parameters)
; ----------------------------------------------------------------
Func Execute_ScanXYRepeat()
   ; executes a scan without setting parameters
   ControlClick($W_IAC, "", 211)
   Return
EndFunc

;FIXME: latch problem, ähnlich wie symphotime
Func Execute_ScanXY_LZt()
   ; executes a scan without setting parameters
   ControlClick($W_IAC, "", 212)
   Return
EndFunc

Func Execute_StopScan ()
   ; stops any ongoing scans
   ControlClick($W_IAC, "", 216)
   Return
EndFunc

; ----------------------------------------------------------------
; Execute Scans (with parameters)
; ----------------------------------------------------------------
Func Execute_TScan($interval, $num)

   ; set scan type to "time" only
   SetScanType(0,0,1,0)
   
   ;set interval and/or number of repetitions
   SetTimeScan($interval, $num) ;($interval, $num)
   
   ; actually exectute Scanning
   Execute_ScanXY_LZt()
      ; FIXME: Series done erscheint nicht wenn Hard Disk Recording an ist
   Sleep(1000)
   $secs=0
   While (ControlCommand($W_IAC, "", "[CLASS:Button; TEXT:Check1; ID:216]", "IsChecked") == 0) And ($secs <= $timeout)
	  Sleep(1000)
	  $secs+=1
   WEnd
   
   Return 1
EndFunc


Func Execute_ZScan($stop, $stepsize,$zslices)
   ControlCommand($W_IAC, "", "[ID:213]", $check[1], "")
   ControlCommand($W_IAC, "", "[ID:214]", $check[0], "")
   Sleep(100)
   SetZStepSize(1,$stepsize)

   Sleep(100)
   SetZStop($stop)

   Sleep(100)
;   SetZStart($start)
   SetZSlices(0,$zslices)

   Sleep(1000)
   Execute_ScanXY_LZt()
   Sleep(1000)
   ; FIXME: Series done erscheint nicht wenn Hard Disk Recording an ist
   While ControlCommand($W_IAC, "", "[CLASS:Button; TEXT:Check1; ID:216]", "IsChecked") == 0
	  Sleep(1000)
   WEnd
;   While ControlCommand($W_IAC, "", 438, "IsVisible", "") <> 1
;   WEnd
;   ControlClick($W_IAC, "", 438)
   Return 1
EndFunc



; ----------------------------------------------------------------
; Hard Disk Recording Setting
; ----------------------------------------------------------------
Func SetHardDiskRecording($state,$path)
   ControlCommand($W_IAC, "", "[ID:571]", $check[$state], "")
   If $state <> 0 Then
	  WinActivate("OLYMPUS FLUOVIEW")
	  ControlClick($W_IAC, "", "[ID:915]")
	  sleep(1000)
	  ControlSetText($W_HDDLG, "", "[CLASS:Edit; INSTANCE:1]", $path)
	  ControlSend($W_HDDLG, "", "[CLASS:Edit; INSTANCE:1]","{ENTER}")
   EndIf
   Sleep(1000)
   Return 1
EndFunc

Func GetHardDiskRecState()
   ;returns state: 1=Hard Disk Recording activated, 0=Hard Disk Recording inactivated
   Return ControlCommand ($W_IAC, "","[ID:571]", "IsChecked", "")
EndFunc

;FIXME: funzt nicht wenn path leer
Func GetHardDiskRecPath()
   ;returns image saving-path for when Hard Disk Recording is activated
   $retval = String(ControlGetText($W_IAC,"",914))
   if $retval = "" Then $retval = 0
   Return $retval
EndFunc


; ----------------------------------------------------------------
; Acquisition Setting: MODE (oneway/roundtrip, exposure, etc)
; ----------------------------------------------------------------
Func setAcquisitionMode($scanWay,$scanTypeRegion, $dwellTime,$stateAutoHV,$stateImageAdjust, $IA_outward, $IA_inward)
   ; sets parameters in Acquistion Setting subwindow "Mode"
   ; Warning: setting "exposure time" and setting "Image Adjust" have not yet been tested
   ; usual values: $stateImageAdjust=0, $IA_outward=0, $IA_inward=0
   
   $handle = WinActivate($W_AS, "")
   
   ;set scanWay: "oneway", or (less often) "roundtrip": successfully tested
   if ($scanWay="oneway") then
	  ControlCommand($W_AS, "", "[CLASSNN:Button76]", $check[1], "")
   Elseif ($scanWay="roundtrip") then
	  ControlCommand($W_AS, "", "[CLASSNN:Button77]", $check[1], "")
   Else
	  MsgBox (0,"Command not recognized","Unexpected value in AutoItScript in Function setAcquisitionMode: $scanWay=" & $scanWay & ". Will continue with 'roundtrip'.")
	  ControlCommand($W_AS, "", "[CLASSNN:Button76]", $check[1], "") ;set to default-value nonetheless in order to attempt to continue
   EndIf
   
   ;set scanTypeRegion: ; successfully tested !!! but you need to set the correspondings ROIs afterwards seperately
   Switch $scanTypeRegion
	  Case 0 ; "square"
		 ControlCommand($W_AS, "", "[CLASSNN:Button82]", $check[1], "")
	  Case 1 ; "diamond" 
		 ControlCommand($W_AS, "", "[CLASSNN:Button83]", $check[1], "")
	  Case 2 ; "linescan"
		 ControlCommand($W_AS, "", "[CLASSNN:Button84]", $check[1], "")
	  Case 3 ; "pointscan"
		 ControlCommand($W_AS, "", "[CLASSNN:Button85]", $check[1], "")
	  Case	Else
		 MsgBox (0,"Internal Error","... unexpected value in AutoItScript in Function setAcquisitionMode: $scanTypeRegion= " & $scanTypeRegion & ". Will continue with 'diamond'.")
		 ControlCommand($W_AS, "", "[CLASSNN:Button82]", $check[1], "") ;set to default-value nonetheless in order to attempt to continue
	  Exit			
   EndSwitch
   
   ; set dwell time (Exposure Time) in microseconds/pixel and set AutoHV status
   setDwellTime($dwellTime, $stateAutoHV)
   
   ; set Image Adjust (outward, inward): not tested
   if $stateImageAdjust=0 or $stateImageAdjust=1 then ControlCommand($W_AS, "", "[CLASSNN:Button92]", $check[$stateImageAdjust], "")
	  
   if ($stateImageAdjust=1) Then
	  MsgBox (0,"Function 'Image Adjust' not implemented","...in AutoIT-script of function setAcquisitionMode")
	  ;set 4IA_outward, set $IA_inward
	  ;continue to implement!!!!!
   endif
   
   Return
EndFunc
 

Func getAcquisitionMode()
   ; GET parameters in Acquistion Setting subwindow "Mode"
   ; returns: $strScanWay, $scanTypeRegion, $dwellTime, $stateAutoHV, stateImageAdjust, $IA_outward, $IA_inward
   ;
   ; WARNING: $IA_outward, $IA_inward not yet implemented ... will always return 0
   
   $handle = WinActivate($W_AS, "")
   
   ;get scanning type
   $bOneway=ControlCommand($W_AS, "", "[CLASSNN:Button76]", "IsEnabled", "")
   $bRoundtrip=ControlCommand($W_AS, "", "[CLASSNN:Button76]", "IsEnabled", "")
   $strScanWay="" ;set empty assuming the worst
   if $bOneway then $strScanWay="oneway"
   if $bRoundtrip then $strScanWay="roundtrip"
   
   
   ;get scanTypeRegion: 
   ;$iSquare=0, $iDiamond=0, $iLineScan=0, $iPointScan=0 ; set null assuming the worst
   $iSquare=ControlCommand($W_AS, "", "[CLASSNN:Button82]", "IsEnabled", "")
   $iDiamond= ControlCommand($W_AS, "", "[CLASSNN:Button83]", "IsEnabled", "")
   $iLineScan = ControlCommand($W_AS, "", "[CLASSNN:Button84]", "IsEnabled", "")
   $iPointScan=ControlCommand($W_AS, "", "[CLASSNN:Button85]", "IsEnabled", "")
   $scanTypeRegion=-1	; assume failure
   if $iPointScan=1 then $scanTypeRegion = 3
   if $iLineScan=1 then $scanTypeRegion = 2
   if $iDiamond=1 then $scanTypeRegion = 1
   if $iSquare=1 then $scanTypeRegion = 0 ; in this row, this is the default value
   
   if ($iSquare+$iDiamond+$iLineScan+$iPointScan)<>1 then
		 ;MsgBox (0,"Internal Error","... unexpected value in AutoItScript in Function getAcquisitionMode: currently no scanType set up. Will continue anyway.")	
		 $iSquare=1
   Endif
	 
    ;get dwell time (Exposure Time) in microseconds/pixel
   $dwellTime=getDwellTime()
   ;get AutoHV status
   $stateAutoHV = getAutoHVStatus()
   
   ; get Image Adjust (outward, inward): not tested
   $stateImageAdjust = ControlCommand($W_AS, "", "[CLASSNN:Button92]", "IsEnabled", "")
   
   ; get $IA_outward (outward, inward): not tested
   $IA_outward=0 ;$IA_outward = ControlCommand($W_AS, "", "[CLASSNN:Button9?]", "IsEnabled", "") ; warning: not yet implemented
   
   
   ; get $IA_inward (outward, inward): not tested
   $IA_inward=0 ;$IA_inward = ControlCommand($W_AS, "", "[CLASSNN:Button9?]", "IsEnabled", "") ; warning: not yet implemented
   
   
   Local $avArray[7]
   $avArray[0] = $strScanWay
   $avArray[1] = $scanTypeRegion
   $avArray[2] = $dwellTime
   $avArray[3] = $stateAutoHV
   $avArray[4] = $stateImageAdjust
   $avArray[5] = $IA_outward
   $avArray[6] = $IA_inward
   
   Return $avArray
EndFunc



; ----------------------------------------------------------------
; Set Exposure-/ Dwell-Time of laser on pixel
; ----------------------------------------------------------------
Func setDwellTime($time, $AutoHVStatus) 
   ; ATTENTION: NOT yET OPERATIONAL <--------------------------------------------------- noch nicht fertig, da click nicht funzt---------------
   ; function sets dwelling time the laser spends per pixel (the higher, the more energy per point in sample)
   ; values (2012-02-22): 2,4,8,10, 12.5, 20, 40, 100, 200
   ; AutoHVStatus: 0=normal; status is set only if values 0 (inactivation) or 1 (activation) are passed; for any other value the status is left unchanged
   
   ;move slider to the utter left


  ;set how many left-clicks must be emulated in order to get to the right exposure-time-value when moving slider to the right
   Switch $time
	   Case 2
		   $n=0
	   Case 4
		   $n=1
	   Case 8
		   $n=2
	  Case 10
		   $n=3
	   Case 12.5
		   $n=4
	   Case 20
		   $n=5
	  Case 40
		   $n=6
	   Case 100
		   $n=7
	   Case 200
		   $n=8
	   Case Else
		   $n=0
   EndSwitch
	  
   $handle = ControlGetHandle($W_AS, "", "[CLASSNN:msctls_trackbar322;Text:Slider1]") ;<------------------------ FEHLER: FUNZT NET "[CLASSNN:Button81]"
   $posCheck = _GUICtrlSlider_GetPos($handle)

   WinActivate($W_AS, "")
   If $posCheck > $n Then
	  ;$buttonpos  =ControlGetPos($W_AS, "", "[CLASSNN:Button81]")
	  $button = "[CLASSNN:Button81]";"[ID:204;CLASS:Button;TEXT:Button4]" ;CLASSNN:Button81
   ElseIf $posCheck < $n Then
	  ;$buttonpos  =ControlGetPos($W_AS, "", "[CLASSNN:Button78]")
	   $button = "[CLASSNN:Button78]";"[ID:205;CLASS:Button;TEXT:Button4]" ;CLASSNN:Button78
   Else	
	  Return
   EndIf

   For $i = 1 To Abs($n-$posCheck)
	  ;ControlClick($W_AS, "", $button)
	  ;MouseClick("left", $buttonpos[0], $buttonpos[1])
	  WinActive($W_AS, "")
	  ;WinWaitActive($W_AS, "")
	  Sleep(100)
	  ControlSend($W_AS, "", $button,"{SPACE}")
	  
	  Sleep(500)
   Next

  ;move slider to the correct position
  
;   For $i = 0 to $n-1
;	  MouseClick("left", $buttonpos[0], $buttonpos[1])
	  ;ControlClick($W_AS, "", "[CLASSNN:Button78]","left", 1, 9, 11) ;<------------------------ FEHLER: FUNZT NET
;	  Sleep(200)
;   Next
   
   ;set AutoHVStatus:
   $handle = WinActivate($W_IAC, "") ;<--- WTF? warum falsches Fenster notwendig??? 
   if $AutoHVStatus=0 or $AutoHVStatus=1 then ControlCommand($W_AS, "", "[CLASSNN:Button79]", $check[$AutoHVStatus], "")  
   Return
EndFunc

Func getDwellTime() 
   ;returns $time, $AutoHVStatus 
   ; function gets dwelling time the laser spends per pixel (the higher, the more energy per point in sample)
   ; values (2012-02-22): 2,4,8,10, 12.5, 20, 40, 100, 200
   ; AutoHVStatus: 0=normal; status is set only if values 0 (inactivation) or 1 (activation) are passed; for any other value the status is left unchanged
	  
   $handle = ControlGetHandle($W_AS, "", "[CLASSNN:msctls_trackbar322]") ;<------------------------ FEHLER: FUNZT NET "[CLASSNN:Button81]"
   $pos = Number(_GUICtrlSlider_GetPos($handle))

  ;set how many left-clicks must be emulated in order to get to the right exposure-time-value when moving slider to the right
   Switch $pos
	   Case 0
		   $dwelltime=2
	   Case 1
		   $dwelltime=4
	   Case 2
		   $dwelltime=8
	  Case 3
		   $dwelltime=10
	   Case 4
		   $dwelltime=12.5
	   Case 5
		   $dwelltime=20
	  Case 6
		   $dwelltime=40
	   Case 7
		   $dwelltime=100
	   Case 8
		   $dwelltime=200
	   Case Else
		   $dwelltime=0
   EndSwitch

   Return $dwelltime
EndFunc

Func setImageSize($size)
  Switch $size
	   Case 64
		   $n=0
	   Case 128
		   $n=1
	   Case 256
		   $n=2
	  Case 320
		   $n=3
	   Case 512
		   $n=4
	   Case 640
		   $n=5
	  Case 800
		   $n=6
	   Case 1024
		   $n=7
	   Case 1600
		   $n=8
		Case 2048
		   $n = 9
		Case 4096
		   $n = 10
	   Case Else
		   $n=0
   EndSwitch

   $handle = ControlGetHandle($W_AS, "", "[CLASSNN:msctls_trackbar321;Text:Slider1]") ;<------------------------ FEHLER: FUNZT NET "[CLASSNN:Button81]"
   $posCheck = _GUICtrlSlider_GetPos($handle)
   ;MsgBox(0,"sd", $posCheck & "  " & $n)

      WinActivate($W_AS, "")
   If $posCheck > $n Then
	  $button = "[CLASSNN:Button73]"
   ElseIf $posCheck < $n Then
	  $button = "[CLASSNN:Button74]"
   Else	
	  Return
   EndIf
   ;MsgBox(0,$buttonpos[0],$buttonpos[1])
   For $i = 1 To Abs($n-$posCheck)
	  WinActivate($W_AS, "")
	  ControlSend($W_AS, "", $button,"{SPACE}")
	  ;MouseClick("left", $buttonpos[0], $buttonpos[1])
	  ;Sleep(100)
   Next

   Return
EndFunc

Func getImageSize()
    $handle = ControlGetHandle($W_AS, "", "[CLASSNN:msctls_trackbar321;Text:Slider1]") ;<------------------------ FEHLER: FUNZT NET "[CLASSNN:Button81]"
   $n = _GUICtrlSlider_GetPos($handle)
  
   
  Switch $n
	   Case 0
		   $n=64
	   Case 1
		   $size=128
	   Case 2
		   $size=256
	  Case 3
		   $size=320
	   Case 4
		   $size=512
	   Case 5
		   $size=640
	  Case 6
		   $size=800
	   Case 7
		   $size=1024
	   Case 8
		   $size=1600
		Case 9
		   $size = 2048
		Case 10
		   $size = 4096
	   Case Else
		   $size=0
   EndSwitch
   
   Return $size
EndFunc

Func GetAutoHVStatus()
   ;returns 0 if AutoHV is not activated, returns 1 if activated
   Return number(ControlCommand ( $W_AS, "", "[CLASSNN:Button79]", "IsChecked", ""))
EndFunc

; ----------------------------------------------------------------
; Set and Get Area-Roi for Scanning
; ----------------------------------------------------------------
Func GetScanningArea()
   ;returns array field on rotation, panX, panY and zoom: [$rotation, $PanX, $PanY, $zoom]
   Local $res[4]

   $res[0]=number(ControlGetText($W_AS,"","[CLASSNN:Edit21]"))
   $res[1]=number(ControlGetText($W_AS,"","[CLASSNN:Edit18]"))
   $res[2]=number(ControlGetText($W_AS,"","[CLASSNN:Edit19]"))
   $res[3]=number(ControlGetText($W_AS,"","[CLASSNN:Edit20]"))
   
   Return $res
EndFunc

Func SetScanningArea($rotation, $PanX, $PanY, $zoom)
   ;sets defined values for area scanning
   ;variables containing values out of reach are not set but ignored
   ;$handle = WinActivate($W_AS, "")
   if $zoom>=1 then SetZoom($zoom)
   Sleep(100)
   if $rotation>=0 then 
	  ControlSetText($W_AS, "", "[CLASSNN:Edit21]", $rotation)
	  ControlSend($W_AS, "",  "[CLASSNN:Edit21]", "{ENTER}")
   EndIf
   if ($PanX>$PanXMin and $PanX<$PanXMax) then 
	  ControlSetText($W_AS, "", "[CLASSNN:Edit18]", $PanX)
	  ControlSend($W_AS, "",  "[CLASSNN:Edit18]", "{ENTER}")
   EndIf
   if ($PanX>$PanYMin and $PanX<$PanYMax) then 
	  ControlSetText($W_AS, "", "[CLASSNN:Edit19]", $PanY)
	  ControlSend($W_AS, "",  "[CLASSNN:Edit19]", "{ENTER}")
   EndIf
  
   
   Return
EndFunc

Func SetZoom($zoom)
;   msgbox(0,"SetZomm", "Recived parameter for SetZoom: " & $zoom)
   ;check if zoom-level is compatible with X/Y-coordinates as a low zoom-level does not allow to access extreme X/Y coordinates
   ; 
; TODO: Fehler beheben!
;   $state=GetScanningArea()
;   if (abs($state[1])+($PanXMax/_Max($zoom,1))) > $PanXMax OR (abs($state[2])+($PanYMax/_Max($zoom,1))) > $PanYMax  Then
;	  MsgBox(48, "Zoom and Pan Area Values not compatible", "The function SetZoom of the script AutoIT wishes to set an unreachable combination of coordinates (PanX, PanY, Zoom). Try a higher zoom value or set both PanX and PanY to zero!")
;   Endif
   
   ControlSetText($W_AS, "", "[CLASSNN:Edit20]", $zoom)
   ControlSend($W_AS, "",  "[CLASSNN:Edit20]", "{ENTER}")
;   ControlClick($W_AS, "", "[CLASSNN:Edit20]", "left", 1)
;  ControlClick($W_AS, "", 201, "left", 1)
   Return
EndFunc


Func GetZoom()
   ;returns zoom-factor
   Return ControlGetText($W_AS, "", "[CLASSNN:Edit20]")
EndFunc

;------------------------------------------
; Select Objective to be used
;------------------------------------------
Func setObjective($objective) 
   ; not yet functional: getting itemref does not work yet
   ; function sets objective from list
   ; values (2012-02-22): "UPLFLN   10X 2  NA:0.30", "UPLSAPO  20X  NA:0.75", "LUCPLFLN  20X  NA:0.45", "UPLSAPO  40X 2  NA:0.95", "UPLSAPO  60X W  NA:1.20", "PLAPO      60X OTIRFM  NA:1.45"
   $handle = WinActivate($W_AS, "")
   ControlClick($W_AS, "", 219)
   ;Get Itemposition in ComboBox
   $itemref = ControlCommand($W_AS, "", "[CLASSNN:ComboBox1]","FindString", $objective) ;<------ does not work correctly
   ;Select new Item in ComboBox
   ;MsgBox(0,"Meldung","$objective:" & $objective & ": $itemref:" & $itemref )
   ControlCommand($W_AS, "", "[CLASSNN:ComboBox1]","SetCurrentSelection", $itemref)
   Return
EndFunc

Func GetObjective() 
   ; returns the name of the current objective as a string
   Return String(ControlGetText ($W_AS, "", "[CLASSNN:ComboBox1]"))
EndFunc




;------------------------------------------
; Manipulating the ObjectivePOSITION in z-direction
;------------------------------------------
Func SetZZero()
   ; uses the current position and sets it to the reference value 0
   ControlClick($W_AS, "", "[ID:209; CLASSNN:Button20]")
   Return
EndFunc

Func ClearZSTartEnd()
   ; removes all values from z-Dimension Fields in "Acquisition Setting/ Microscope"
   ControlClick($W_AS, "", "[ID:205; CLASSNN:Button28]", "left", 1)
   Return
EndFunc

Func GetZPos()
   ; returns numerical value of current zPosition
   
   Local $str=ControlGetText($W_AS, "", "[ID:217; CLASSNN:Static11]")
   ;strip string-characters of unit from Number
   if (StringIsAlNum($str)=0) Then
	  $str=StringTrimRight($str, 2)
   EndIf
   Return $str
EndFunc


Func SetZStart($start)
   ControlSetText($W_AS, "", 244, $start)
   ControlSend($W_AS, "", 244,"{ENTER}")
;   ControlClick($W_AS, "", 244, "left", 1)
;   ControlClick($W_AS, "", 201, "left", 1)
   Return
EndFunc

Func GetZStart()
   ; returns numerical value of zStart Position
   Return ControlGetText($W_AS,"",244)
EndFunc

Func SetZStartFromCurrPos()
   ;function emulates click such as current zPos positon will be set as starting point
   ControlClick($W_AS, "", 474, "left", 1)
   Return
EndFunc

Func SetZStop($stop)
   ControlSetText($W_AS, "", 231, $stop)
   ControlSend($W_AS, "", 231,"{ENTER}")
   Return
EndFunc

Func GetZStop()
   ; returns numerical value of current zStop
   Return ControlGetText($W_AS,"",231)
EndFunc

Func ClearStartEndzPos()
   ControlClick($W_AS, "Clear Start/End", 221, "left", 1)
   Return
EndFunc


Func SetZSlices($auto, $slices)
   ; sets number of ZSlices
   ; 	when auto is 0 or 1: slices are written into the field, and checkbox-status is set
   ; 	when auto neither 0 nor 1, then slices are written into the field ONLY IF the current status is 0
   
   ;uncheck checkbox in order to enter values
   If $auto = 0 OR $auto = 1 Then
	  ControlCommand($W_AS, "", 238, $check[0])
   EndIf
   
   ;write number of slices
   ControlSetText($W_AS, "", "[ID:239; CLASSNN:Edit5]", $slices)
   ControlSend($W_AS, "", "[ID:239; CLASSNN:Edit5]", "{Enter}")
   
   ;set checkbox to 1 if necessary
   If $auto = 1 Then
	  ControlCommand($W_AS, "", 238, $check[$auto])
   EndIf
   Return
EndFunc

Func GetZSlices()
   ; returns numerical value of current number of slices
   Return ControlGetText($W_AS,"",239)
EndFunc

Func GetZSlicesStatus()
   ; (for zStacks) returns the status of the checkbox for fixing the number of slices to a constant value
   Return ControlCommand( $W_AS, "", "[CLASS:Button; INSTANCE: 19; ID: 238]", "IsChecked", "")
EndFunc


Func SetZStepSize($auto, $stepsize)
   ; sets step size of z-direction movement
   ; 	when auto is 0 or 1: slices are written into the field, and checkbox-status is set
   ; 	when auto neither 0 nor 1, then slices are written into the field ONLY IF the current status is 0
   
   ;uncheck checkbox in order to enter values
   If $auto = 0 OR $auto = 1 Then
	  ControlCommand($W_AS, "", 243, $check[0])
   EndIf
   
   ;write step size
;   MsgBox(0, "dfs", $stepsize)
   ControlSetText($W_AS, "", "[ID:205; CLASSNN:Edit6]", $stepsize)
   ControlSend($W_AS, "", "[ID:205; CLASSNN:Edit6]","{ENTER}")
	  
   ;set checkbox to 1 if necessary
   If $auto = 1 Then
	  ControlCommand($W_AS, "", 243, $check[$auto])
   EndIf
   Return
EndFunc

Func GetZStepSize()
   ; returns numerical value of the step size in µm (for zStacks)
   Return ControlGetText($W_AS,"","[ID:205; CLASSNN:Edit6]")
EndFunc

Func GetZStepSizeStatus()
   ; (for zStacks) returns the status of the checkbox for fixing the zStep size to a constant value
   Return ControlCommand( $W_AS, "", "[CLASS:Button; INSTANCE: 18; ID: 243]", "IsChecked", "")
EndFunc




Func Execute_GoToZPos($zPos)
   ;moves objective to the zPos (reference is the current zeroPosition; attention: this can change)
   ;returns "1" when successfull, otherwise "0"
   ;test function with this command: MsgBox(0,"Result of shifting zPosition", "value: " & Execute_GoToZPos(-90))
   
   ;get current values
   $zStart=GetZStart()
   $zStop=GetZStop()
   $zStepSize=GetZStepSize()
   $zStepSizeStatus=GetZStepSizeStatus()
   $zSlices=GetZSlices()
   $zSlicesStatus=GetZSlicesStatus()
;MsgBox(0,"nach get", "$zSlices: " & $zSlices & "$zStepSize: " & $zStepSize & "$zStepSizeStatus: " & $zStepSizeStatus & "$zSlicesStatus: " & $zSlicesStatus)
   
   ;prepare ControlSend
   ClearZSTartEnd()
   
   ;set zPos
   SetZStart($zPos)
   ControlClick($W_AS, "", "[CLASSNN:Button12]")
   
   ;determine success of operation
   If (GetZStart()<>$zPos) Then
	  $status=0
   else
	  $status=1
   endif
   
   ;enter former values
 ;  MsgBox(0,"vor set", "$zSlices: " & $zSlices & "$zStepSize: " & $zStepSize & "$zStepSizeStatus: " & $zStepSizeStatus & "$zSlicesStatus: " & $zSlicesStatus)
   SetZStepSize($zStepSizeStatus, $zStepSize)
   SetZSlices($zSlicesStatus, $zSlices)
   SetZStart($zStart)
   SetZStop($zStop)
   
   Return $status
EndFunc

Func SetEscapeObjective($state)
   ; set to 1: removes objective from current position into lowest position
   ; set to 0: moves objective lowest position to prior position before escape was activated
   $handle = WinActivate($W_AS, "")
   ControlCommand($W_AS, "", "[CLASSNN:Button24]", $check[$state], "")
   ControlSend($W_AS, "", "[CLASSNN:Button24]","{ENTER}")
   Return
EndFunc

Func GetEscapeObjective()
   ; returns 1 if objective down, returns 0 if objective up
   Return ControlCommand($W_AS, "", "[CLASSNN:Button24]", "IsChecked", "")
EndFunc




; ----------------------------------------------------------------
; Set Checkbox for (non-) Sequential-Scanning, also Line- or Frame-Scanning
; ----------------------------------------------------------------
Func setSequentialScan($state,$sequentialScanType)
   ; values: $state = 1/0
   ; values: $sequentialScanType = "frame" or "line"
   
   ControlCommand($W_IAC, "", "[CLASSNN:Button15]", $check[$state], "")  
   if ($state) then
	  if ($sequentialScanType=="line") Then
		 ControlCommand($W_IAC, "", 227, $check[1], "")  	 
	  Elseif ($sequentialScanType=="frame") Then
		 ControlCommand($W_IAC, "", 235, $check[1], "")  	 
	  EndIf
   EndIf
   Return
EndFunc

Func getSequentialScan()
   ; returns array: [$state, $sequentialScanType]
   ; values: $state is boolean, $sequentialScanType is string: "frame" or "line"
   
   ;get $state
   $state = ControlCommand($W_IAC, "", "[CLASSNN:Button15]", "IsChecked", "") ;Sequential Scanning of Channels on or off
   
   ; get $sequentialScanType
   $bLine = ControlCommand($W_IAC, "", 227, "IsChecked", "")
   $bFrame = ControlCommand($W_IAC, "", 235, "IsChecked", "")
   $sequentialScanType=-""; assume failure
   if $bFrame=1 then $sequentialScanType = "frame"
   if $bLine=1 then $scanTypeRegion = "line"
   if $sequentialScanType = "" Then
		 ;MsgBox (0,"Internal Error","... unexpected value in AutoItScript in Function getSequentialScan. Will continue anyway.")	
		 $sequentialScanType = "line"
   Endif
   
   ; return results as array
   Local $arArray[2]
   $arArray[0] = $state
   $arArray[1] = $sequentialScanType
   Return $arArray
EndFunc


; ----------------------------------------------------------------
; Set Scan Type (Lambda, Depth, Time, HDRi
; ----------------------------------------------------------------
func SetScanType($lambda,$depth,$time,$HDRi)
   ;values: 0=off, 1=on
   
   ; set Lambda Scan State
   if ($lambda) Then setSequentialScan(1,"")
   ControlCommand($W_IAC, "", "[ID:215]", $check[$lambda], "")
   ; set Depth Scan State
   ControlCommand($W_IAC, "", "[ID:213]", $check[$depth], "")
   ; set Time Scan State
   ControlCommand($W_IAC, "", "[ID:214]", $check[$time], "")
   ; set HDRi Scan State
   ControlCommand($W_IAC, "", "[ID:925]", $check[$HDRi], "")
   Return
EndFunc

func GetScanType()
   ;returns array with [$lambda, $depth, $time, $HDRi] all of type boolean
   
   Local $arArray[4]
   $arArray[0] = ControlCommand($W_IAC, "", "[ID:215]", "IsChecked", "")
   $arArray[1] = ControlCommand($W_IAC, "", "[ID:213]", "IsChecked", "")
   $arArray[0] = ControlCommand($W_IAC, "", "[ID:214]", "IsChecked", "")
   $arArray[1] = ControlCommand($W_IAC, "", "[ID:925]", "IsChecked", "")
   Return $arArray
   Return
EndFunc



func SetTimeScan($interval, $nframes)
   ; sets two parameters for the time scan
   ; attention: this enforces TimeScan only and removes all flags set on other scan types (lambda, HDRi, z)
   ;(optional) interval: Format: "hh:mm:ss.ms"
   
   $handle = WinActivate($W_AS, "") ;TimeScanfield -> Button1
   
   if ($interval<>"") Then SetTimeScanInterval($interval)
   if ($nframes<>"") Then SetNFrames($nframes)
   
   ;set ScanType to TimeScan ONLY!!!!
   SetScanType(0,0,1,0) ; ($lambda, $depth,$time,$HDRi)
   Return
Endfunc

Func SetTimeScanInterval($interval)
   ;sets interval-time for a TimeScan
   ;format: "hh:mm:ss.ms" ;SetTimeScanInterval("00:10:00.12")
   ControlSetText($W_AS, "", "[CLASSNN:Edit1]", $interval)
   ControlSend($W_AS, "", "[CLASSNN:Edit1]","{ENTER}")
   Return
EndFunc

Func GetTimeScanInterval()
   ;gets a string with the intervals for a time-scan
   ;format: "hh:mm:ss.ms" ;SetTimeScanInterval("00:10:00.12")
   Return String(ControlGetText($W_AS, "", "[CLASSNN:Edit1]"))
EndFunc

Func SetNFrames($nframes)
   ;sets number of images to be recorded at a TimeScan
   ControlSetText($W_AS, "", "[CLASSNN:Edit2]", $nframes)
   ControlSend($W_AS, "", "[CLASSNN:Edit2]","{ENTER}")
   
   ;ControlSetText($W_AS, "","[ID:202; CLASSNN:Edit2]", $nframes)
   ;ControlClick($W_AS, "", "[ID:202; CLASSNN:Edit2]")
   ;ControlClick($W_AS, "", 201, "left", 1)
   Return
EndFunc

Func GetNFrames()
   ;gets number of images to be recorded at a TimeScan
   Return ControlGetText($W_AS, "","[ID:202; CLASSNN:Edit2]")
EndFunc



Func SetLightBulbStatus($state)
   ControlCommand($W_IAC, "", 281, $check[$state], "")
   Return
EndFunc

Func GetLightBulbStatus()
   ;returns if transmission light is activated
   Return ControlCommand($W_IAC, "", 281, "IsChecked", "")
EndFunc

Func SetEPILampStatus($state)
   ControlCommand($W_IAC, "", "[ID:202; CLASSNN:Button2]", $check[$state], "")
   Return
EndFunc

Func GetEPILampStatus()
   ;returns if epifluorescence light is activated
   Return ControlCommand($W_IAC, "", "[ID:202; CLASSNN:Button2]", "IsChecked", "")
EndFunc


Func SetBrightFieldStatus($state)
   
   ; ATTENTION: please use the following function instead because it is faster:
   ; 				SetTD1($state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power)
   
   $handle = WinActivate($W_IAC, "")
   $handle = ControlClick($W_IAC, "", 205)
   
   ; Open LightPath Window
   $handle = WinActivate("LightPath", "")
   ; Switch Brightfield
   ControlCommand("LightPath", "", 780, $check[$state], "")
   WinClose("LightPath", "")
   
   Return
EndFunc   

Func GetBrightFieldStatus()
   ; returns if bright field acquisition was checked or not
   ; ATTENTION: please use the following function instead because it is more complete/offers more data: GetTD1()
   return ControlCommand($W_IAC, "", "[CLASSNN:Button70]", "IsChecked", "")
EndFunc

; ----------------------------------------------------------------
; Laser Excitation Parameters
; ----------------------------------------------------------------
Func SetLaser($laser,$state)
   ; this function activates or inactivates laser lines.
   ; ATTENTION: in theory activated lasers can be blocked by AOTF ... but in practise
   ;   an activated laser line, even though set to 0%, will still irradiate the sample!!
   WinActivate($W_AS, "Laser")
   If $oldconfocal Then
	  ControlClick($W_AS, "", "[CLASSNN:ScrollBar1]", "left", 1, 8, 8 )
	  Switch $laser
		; Case 0 ; as in CHS1 laser menue there is the position "none", here, laser0 does not exist
			; nothing happens
		 Case 0 ; 405 nm (state:2012-04-23)
			ControlCommand($W_AS, "", "[CLASSNN:Button35]", $check[$state], "")
		 Case 1 ; 440 nm (state:2012-04-23) 
			ControlCommand($W_AS, "", "[CLASSNN:Button36]", $check[$state], "")
		 Case 2 ; 488 nm (state:2012-04-23)
			ControlCommand($W_AS, "", "[CLASSNN:Button37]", $check[$state], "")
		 Case 3 ; 515 nm (state:2012-04-23)
			ControlCommand($W_AS, "", "[CLASSNN:Button38]", $check[$state], "")
		 Case 4 ; 559 nm (state:2012-04-23)
			ControlCommand($W_AS, "", "[CLASSNN:Button39]", $check[$state], "")
		 Case 5 ; 635 nm (state:2012-04-23)
			ControlClick($W_AS, "", "[CLASSNN:ScrollBar1]", "left", 1, 9, 75 )
			ControlCommand($W_AS, "", "[CLASSNN:Button39]", $check[$state], "")
		 Case	Else
			MsgBox (0,"Internal Error","... in AutoItScript in Function SetLaser (Switch laser) for old confocal")
		 EndSwitch		 
	  Else
		 ControlClick($W_AS, "", "[CLASSNN:ScrollBar1]", "left", 2, 8, 8 )
		 Switch $laser
		 ;Case 0 ; as in CHS1 laser menue there is the position "none", here, laser0 does not exist
			; nothing happens
		 Case 0 ; 405 nm (state:2012-04-23)
			ControlCommand($W_AS, "", "[CLASSNN:Button35]", $check[$state], "")
		 Case 1 ; 440 nm (state:2012-04-23) 
			ControlCommand($W_AS, "", "[CLASSNN:Button36]", $check[$state], "")
		 Case 2 ; 488 nm (state:2012-04-23)
			ControlCommand($W_AS, "", "[CLASSNN:Button37]", $check[$state], "")
		 Case 3 ; 515 nm (state:2012-04-23)
			ControlCommand($W_AS, "", "[CLASSNN:Button38]", $check[$state], "")
		 Case 4 ; 559 nm (state:2012-04-23)
			ControlCommand($W_AS, "", "[CLASSNN:Button39]", $check[$state], "")
		 Case 5 ; 635 nm (state:2012-04-23)
			ControlClick($W_AS, "", "[CLASSNN:ScrollBar1]", "left", 1, 9, 75 )
			ControlCommand($W_AS, "", "[CLASSNN:Button39]", $check[$state], "")
		 Case 6 ; 2-photon-laser (state:2012-04-23)
			ControlClick($W_AS, "", "[CLASSNN:ScrollBar1]", "left", 2, 9, 75 )
			ControlCommand($W_AS, "", "[CLASSNN:Button39]", $check[$state], "")
		 Case	Else
			MsgBox (0,"Internal Error","... in AutoItScript in Function SetLaser (Switch laser) for new confocal")
	  EndSwitch
   EndIf
   
   Return
EndFunc



Func GetLaser($laser); ($laser,$state)
   ; returns the on/off status of a laser line
   
   WinActivate($W_AS, "Laser")
   If $oldconfocal Then
	  ControlClick($W_AS, "", "[CLASSNN:ScrollBar1]", "left", 1, 8, 8 )
	  Switch $laser
		 Case 0 ; 405 nm (state:2012-01-26)
			$state = ControlCommand($W_AS, "", "[CLASSNN:Button35]", "IsChecked", "")
		 Case 1 ; 440 nm (state:2012-01-26) 
			$state = ControlCommand($W_AS, "", "[CLASSNN:Button36]", "IsChecked", "")
		 Case 2 ; 488 nm (state:2012-01-26)
			$state = ControlCommand($W_AS, "", "[CLASSNN:Button37]", "IsChecked", "")
		 Case 3 ; 515 nm (state:2012-01-26)
			$state = ControlCommand($W_AS, "", "[CLASSNN:Button38]", "IsChecked", "")
		 Case 4 ; 559 nm (state:2012-01-26)
			$state = ControlCommand($W_AS, "", "[CLASSNN:Button39]", "IsChecked", "")
		 Case 5 ; 635 nm (state:2012-01-26)
			ControlClick($W_AS, "", "[CLASSNN:ScrollBar1]", "left", 1, 8, 75 )
			$state = ControlCommand($W_AS, "", "[CLASSNN:Button39]", "IsChecked", "")
		 Case	Else
			MsgBox (0,"Internal Error","... in AutoItScript in Function GetLaser for oldconfocal")
			$state = -1
		 EndSwitch		 
	  Else
		 ControlClick($W_AS, "", "[CLASSNN:ScrollBar1]", "left", 2, 8, 8 )
		 Switch $laser
		 Case 0 ; 405 nm (state:2012-01-26)
			$state = ControlCommand($W_AS, "", "[CLASSNN:Button35]", "IsChecked", "")
		 Case 1 ; 440 nm (state:2012-01-26) 
			$state = ControlCommand($W_AS, "", "[CLASSNN:Button36]", "IsChecked", "")
		 Case 2 ; 488 nm (state:2012-01-26)
			$state = ControlCommand($W_AS, "", "[CLASSNN:Button37]", "IsChecked", "")
		 Case 3 ; 515 nm (state:2012-01-26)
			$state = ControlCommand($W_AS, "", "[CLASSNN:Button38]", "IsChecked", "")
		 Case 4 ; 559 nm (state:2012-01-26)
			$state = ControlCommand($W_AS, "", "[CLASSNN:Button39]", "IsChecked", "")
		 Case 5 ; 635 nm (state:2012-01-26)
			$state = ControlCommand($W_AS, "", "[CLASSNN:Button39]", "IsChecked", "")
		 Case 6 ; 2-photon-laser (state:2012-01-26)
			$state = ControlCommand($W_AS, "", "[CLASSNN:Button39]", "IsChecked", "")
		 Case	Else
			MsgBox (0,"Internal Error","... in AutoItScript in Function GetLaser for newconfocal")
			$state = -1
	  EndSwitch
   EndIf
   
   Return String(Int($state))
EndFunc


Func SetCHS1($state,$laser,$group, $PMTVoltage,$gain, $cutOffPerc, $power)
   ; for any negative value recieved the corresponding setting will be maintained (thus: no change)
   ; attention: values are changed only when state=1; this is due to FV1000 user interface and not due to autoit
   
   ;set current window focus
   ;$handle = WinActivate($W_IAC, "") ;not strictly necessary
   ;ControlClick($W_IAC, "", 205) 	 ;not strictly necessary
   
   ;set state (box checked or unchecked)
   If ($state >= 0) Then
	  ControlCommand($W_IAC, "", "[CLASSNN:Button49]", $check[$state], "")
   Endif
   
   ;chose and set laser from list
   if ($laser>=0) then
	  ControlCommand($W_IAC, "", "[CLASSNN:ComboBox1]","SetCurrentSelection", $laser)
	  ;SUGGESTED IMPROVERMENT: improve by allowing for string entry: "405", "440", .... 
   EndIf
   
   ;set group-pertenecence
   If ($group>=0) then 
	  ControlCommand($W_IAC, "", "[CLASSNN:ComboBox2]","SetCurrentSelection", $group)
   EndIf
   
   ;set Photomultiplier Tube Voltage
   if ($PMTVoltage>0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit3]", $PMTVoltage)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit3]", "{ENTER}")
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit3]", $PMTVoltage) ; no idea why, but repetition necessary; otherwise only every 2nd time the correct value is set
	  ControlSend($W_IAC, "", "[CLASSNN:Edit3]", "{ENTER}")
   EndIf
   
   ;set multiplier gain (recommended leaving at "1" !!!)
   if ($gain>=0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit4]", $gain)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit4]", "{ENTER}")
   EndIf
   
   ;set cut-off as relative percentage (recommended leaving at "0"!!!)
   if ($cutOffPerc>=0) then 
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit5]", $cutOffPerc)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit5]", "{ENTER}")
   EndIf
   
   ;set AOTF-controlled laser output (in percent) 219
   if ($power>=0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit6]", $power)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit6]", "{ENTER}")
   EndIf
   
   Return
EndFunc

Func GetCHS1()
   ; returns settings for acquisition channel 1: [$state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power]
   
   ;$handle = WinActivate("Image Acquisition", "") ; necessary?
   ;ControlClick($W_IAC, "", 205) ; necessary?
   
   ;set state (box checked or unchecked)
   $state = ControlCommand($W_IAC, "", "[CLASSNN:Button49]", "IsChecked", "")
   
   ;get laser from list
   $strlaser = ControlGetText($W_IAC, "", "[CLASSNN:ComboBox1]")
   $laserNativeListPosition=ControlCommand ( $W_IAC, "", "[CLASSNN:ComboBox1]", "FindString", $strlaser)
	  
   ;get group-pertenecence
   $strGroup = ControlGetText($W_IAC, "", "[CLASSNN:ComboBox2]")
   $group=ControlCommand ( $W_IAC, "", "[CLASSNN:ComboBox2]", "FindString", $strGroup)
   
   ;get Photomultiplier Tube Voltage
   $PMTVoltage = ControlGetText($W_IAC, "", "[CLASSNN:Edit3]")

   ;get multiplier gain
   $multi = ControlGetText($W_IAC, "", "[CLASSNN:Edit4]")

   ;get cut-off (relative percentage)
   $cutOffPerc = ControlGetText($W_IAC, "", "[CLASSNN:Edit5]")
   
   ;get AOTF-controlled laser output (in percent)
   $power = ControlGetText($W_IAC, "", "[CLASSNN:Edit6]")
   
   ; return values: der Übersichtlichkeit wegen wird array erst hier 'befüllt'
   Local $arArray[7]
   $arArray[0] = $state
   $arArray[1] = $laserNativeListPosition
   $arArray[2] = $group
   $arArray[3] = $PMTVoltage
   $arArray[4] = $multi
   $arArray[5] = $cutOffPerc
   $arArray[6] = $power
   Return $arArray
EndFunc


Func SetCHS2($state,$laser,$group, $PMTVoltage,$gain, $cutOffPerc, $power)
   ; for any negative value recieved the corresponding setting will be maintained (thus: no change)
   ; attention: values are changed only when state=1; this is due to FV1000 user interface and not due to autoit

   ;set current window focus
   ;$handle = WinActivate($W_IAC, "") ;not strictly necessary
   ;ControlClick($W_IAC, "", 205) 	 ;not strictly necessary
   
   ;set state (box checked or unchecked)
   If ($state >= 0) Then
	  ControlCommand($W_IAC, "", "[CLASSNN:Button56]", $check[$state], "")
   Endif
   
   ;chose and set laser from list
   if ($laser>=0) then
	  ControlCommand($W_IAC, "", "[CLASSNN:ComboBox3]","SetCurrentSelection", $laser)
	  ;SUGGESTED IMPROVERMENT: improve by allowing for string entry: "405", "440", .... 
   EndIf
   
   ;set group-pertenecence
   If ($group>=0) then 
	  ControlCommand($W_IAC, "", "[CLASSNN:ComboBox4]","SetCurrentSelection", $group)
   EndIf
   
   ;set Photomultiplier Tube Voltage
   if ($PMTVoltage>0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit7]", $PMTVoltage)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit7]", "{ENTER}")
   	  ControlSetText($W_IAC, "", "[CLASSNN:Edit7]", $PMTVoltage) ; no idea why, but repetition necessary; otherwise only every 2nd time the correct value is set
	  ControlSend($W_IAC, "", "[CLASSNN:Edit7]", "{ENTER}")
   EndIf
   
   ;set multiplier gain (recommended leaving at "1" !!!)
   if ($gain>=0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit8]", $gain)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit8]", "{ENTER}")
   EndIf
   
   ;set cut-off as relative percentage (recommended leaving at "0"!!!)
   if ($cutOffPerc>=0) then 
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit9]", $cutOffPerc)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit9]", "{ENTER}")
   EndIf
   
   ;set AOTF-controlled laser output (in percent) 219
   if ($power>=0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit10]", $power)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit10]", "{ENTER}")
   EndIf
   
   Return
EndFunc

Func GetCHS2()
   ; returns settings for acquisition channel 2: [$state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power]
   
   ;$handle = WinActivate("Image Acquisition", "") ; necessary?
   ;ControlClick($W_IAC, "", 205) ; necessary?
   
   ;set state (box checked or unchecked)
   $state = ControlCommand($W_IAC, "", "[CLASSNN:Button56]", "IsChecked", "")
   
   ;get laser from list
   $strlaser = ControlGetText($W_IAC, "", "[CLASSNN:ComboBox3]")
   $laserNativeListPosition=ControlCommand ( $W_IAC, "", "[CLASSNN:ComboBox3]", "FindString", $strlaser)
	  
   ;get group-pertenecence
   $strGroup = ControlGetText($W_IAC, "", "[CLASSNN:ComboBox4]")
   $group=ControlCommand ( $W_IAC, "", "[CLASSNN:ComboBox4]", "FindString", $strGroup)
   
   ;get Photomultiplier Tube Voltage
   $PMTVoltage = ControlGetText($W_IAC, "", "[CLASSNN:Edit7]")

   ;get multiplier gain
   $multi = ControlGetText($W_IAC, "", "[CLASSNN:Edit48")

   ;get cut-off (relative percentage)
   $cutOffPerc = ControlGetText($W_IAC, "", "[CLASSNN:Edit9]")
   
   ;get AOTF-controlled laser output (in percent)
   $power = ControlGetText($W_IAC, "", "[CLASSNN:Edit10]")

   ; return values: der Übersichtlichkeit wegen wird array erst hier 'befüllt'
   Local $arArray[7]
   $arArray[0] = $state
   $arArray[1] = $laserNativeListPosition
   $arArray[2] = $group
   $arArray[3] = $PMTVoltage
   $arArray[4] = $multi
   $arArray[5] = $cutOffPerc
   $arArray[6] = $power
   Return $arArray
EndFunc


Func SetCHS3($state,$laser,$group, $PMTVoltage,$gain, $cutOffPerc, $power)
   ; for any negative value recieved the corresponding setting will be maintained (thus: no change)
   ; attention: values are changed only when state=1; this is due to FV1000 user interface and not due to autoit

   ;set current window focus
   ;$handle = WinActivate($W_IAC, "") ;not strictly necessary
   ;ControlClick($W_IAC, "", 205) 	 ;not strictly necessary
   
   ;set state (box checked or unchecked)
   If ($state >= 0) Then
	  ControlCommand($W_IAC, "", "[CLASSNN:Button63]", $check[$state], "")
   Endif
   
   ;chose and set laser from list
   if ($laser>=0) then
	  ControlCommand($W_IAC, "", "[CLASSNN:ComboBox5]","SetCurrentSelection", $laser)
	  ;SUGGESTED IMPROVERMENT: improve by allowing for string entry: "405", "440", .... 
   EndIf
   
   ;set group-pertenecence
   If ($group>=0) then 
	  ControlCommand($W_IAC, "", "[CLASSNN:ComboBox6]","SetCurrentSelection", $group)
   EndIf
   
   ;set Photomultiplier Tube Voltage
   if ($PMTVoltage>0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit11]", $PMTVoltage)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit11]", "{ENTER}")
   	  ControlSetText($W_IAC, "", "[CLASSNN:Edit11]", $PMTVoltage) ; no idea why, but repetition necessary; otherwise only every 2nd time the correct value is set
	  ControlSend($W_IAC, "", "[CLASSNN:Edit11]", "{ENTER}")
   EndIf
   
   ;set multiplier gain (recommended leaving at "1" !!!)
   if ($gain>=0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit12]", $gain)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit12]", "{ENTER}")
   EndIf
   
   ;set cut-off as relative percentage (recommended leaving at "0"!!!)
   if ($cutOffPerc>=0) then 
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit13]", $cutOffPerc)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit13]", "{ENTER}")
   EndIf
   
   ;set AOTF-controlled laser output (in percent) 219
   if ($power>=0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit14]", $power)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit14]", "{ENTER}")
   EndIf
   
   Return
EndFunc

Func GetCHS3()
   ; returns settings for acquisition channel 3: [$state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power]
   
   ;$handle = WinActivate("Image Acquisition", "") ; necessary?
   ;ControlClick($W_IAC, "", 205) ; necessary?
   
   ;set state (box checked or unchecked)
   $state = ControlCommand($W_IAC, "", "[CLASSNN:Button63]", "IsChecked", "")
   
   ;get laser from list
   $strlaser = ControlGetText($W_IAC, "", "[CLASSNN:ComboBox5]")
   $laserNativeListPosition=ControlCommand ( $W_IAC, "", "[CLASSNN:ComboBox5]", "FindString", $strlaser)
	  
   ;get group-pertenecence
   $strGroup = ControlGetText($W_IAC, "", "[CLASSNN:ComboBox6]")
   $group=ControlCommand ( $W_IAC, "", "[CLASSNN:ComboBox6]", "FindString", $strGroup)
   
   ;get Photomultiplier Tube Voltage
   $PMTVoltage = ControlGetText($W_IAC, "", "[CLASSNN:Edit11]")

   ;get multiplier gain
   $multi = Number(ControlGetText($W_IAC, "", "[CLASSNN:Edit12]"))

   ;get cut-off (relative percentage)
   $cutOffPerc = Number(ControlGetText($W_IAC, "", "[CLASSNN:Edit13]"))
   
   ;get AOTF-controlled laser output (in percent)
   $power = Number(ControlGetText($W_IAC, "", "[CLASSNN:Edit14]"))
   
   ; return values: der Übersichtlichkeit wegen wird array erst hier 'befüllt'
   Local $arArray[7]
   $arArray[0] = $state
   $arArray[1] = $laserNativeListPosition
   $arArray[2] = $group
   $arArray[3] = $PMTVoltage
   $arArray[4] = $multi
   $arArray[5] = $cutOffPerc
   $arArray[6] = $power
   Return $arArray
EndFunc


Func SetTD1($state,$laser,$group, $PMTVoltage,$gain, $cutOffPerc, $power)
   ; for any negative value recieved the corresponding setting will be maintained (thus: no change)
   ; attention: values are changed only when state=1; this is due to FV1000 user interface and not due to autoit

   ;set current window focus
   ;$handle = WinActivate($W_IAC, "") ;not strictly necessary
   ;ControlClick($W_IAC, "", 205) 	 ;not strictly necessary
   
   ;set state (box checked or unchecked)
   If ($state >= 0) Then
	  ControlCommand($W_IAC, "", "[CLASSNN:Button70]", $check[$state], "")
   Endif
   
   ;chose and set laser from list
   if ($laser>=0) then
	  ControlCommand($W_IAC, "", "[CLASSNN:ComboBox7]","SetCurrentSelection", $laser)
	  ;SUGGESTED IMPROVERMENT: improve by allowing for string entry: "405", "440", .... 
   EndIf
   
   ;set group-pertenecence
   If ($group>=0) then 
	  ControlCommand($W_IAC, "", "[CLASSNN:ComboBox8]","SetCurrentSelection", $group)
   EndIf
   
   ;set Photomultiplier Tube Voltage
   if ($PMTVoltage>0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit15]", $PMTVoltage)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit15]", "{ENTER}")
   	  ControlSetText($W_IAC, "", "[CLASSNN:Edit15]", $PMTVoltage) ; no idea why, but repetition necessary; otherwise only every 2nd time the correct value is set
	  ControlSend($W_IAC, "", "[CLASSNN:Edit15]", "{ENTER}")
   EndIf
   
   ;set multiplier gain (recommended leaving at "1" !!!)
   if ($gain>=0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit16]", $gain)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit16]", "{ENTER}")
   EndIf
   
   ;set cut-off as relative percentage (recommended leaving at "0"!!!)
   if ($cutOffPerc>=0) then 
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit17]", $cutOffPerc)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit17]", "{ENTER}")
   EndIf
   
   ;set AOTF-controlled laser output (in percent) 219
   if ($power>=0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit18]", $power)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit18]", "{ENTER}")
   EndIf
   
   Return
EndFunc


Func GetTD1()
   ; returns settings for acquisition channel TD1(brightfield): [$state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power]
   
   ;$handle = WinActivate("Image Acquisition", "") ; necessary?
   ;ControlClick($W_IAC, "", 205) ; necessary?
   
   ;set state (box checked or unchecked)
   $state = ControlCommand($W_IAC, "", "[CLASSNN:Button70]", "IsChecked", "")
   
   ;get laser from list
   $strlaser = ControlGetText($W_IAC, "", "[CLASSNN:ComboBox7]")
   $laserNativeListPosition=ControlCommand ( $W_IAC, "", "[CLASSNN:ComboBox7]", "FindString", $strlaser)
	  
   ;get group-pertenecence
   $strGroup = ControlGetText($W_IAC, "", "[CLASSNN:ComboBox8]")
   $group=ControlCommand ( $W_IAC, "", "[CLASSNN:ComboBox8]", "FindString", $strGroup)
   
   ;get Photomultiplier Tube Voltage
   $PMTVoltage = ControlGetText($W_IAC, "", "[CLASSNN:Edit15]")

   ;get multiplier gain
   $multi = ControlGetText($W_IAC, "", "[CLASSNN:Edit16]")

   ;get cut-off (relative percentage)
   $cutOffPerc = ControlGetText($W_IAC, "", "[CLASSNN:Edit17]")
   
   ;get AOTF-controlled laser output (in percent)
   $power = ControlGetText($W_IAC, "", "[CLASSNN:Edit18]")
   
   ; return values: der Übersichtlichkeit wegen wird array erst hier 'befüllt'
   Local $arArray[7]
   $arArray[0] = $state
   $arArray[1] = $laserNativeListPosition ;$strlaser FIXME
   $arArray[2] = $strgroup
   $arArray[3] = $PMTVoltage
   $arArray[4] = $multi
   $arArray[5] = $cutOffPerc
   $arArray[6] = $power
   Return $arArray
EndFunc


Func SetRXD1($state,$laser,$group, $PMTVoltage,$gain, $cutOffPerc, $power)
   ; for any negative value recieved the corresponding setting will be maintained (thus: no change)
   ; attention: values are changed only when state=1; this is due to FV1000 user interface and not due to autoit
   
   ;set current window focus
   ;$handle = WinActivate($W_IAC, "") ;not strictly necessary
   ;ControlClick($W_IAC, "", 205) 	 ;not strictly necessary
   
   ;set state (box checked or unchecked)
   If ($state >= 0) Then
	  ControlCommand($W_IAC, "", "[CLASSNN:Button77]", $check[$state], "")
   Endif
   
   ;chose and set laser from list
   if ($laser>=0) then
	  ControlCommand($W_IAC, "", "[CLASSNN:ComboBox9]","SetCurrentSelection", $laser)
	  ;SUGGESTED IMPROVERMENT: improve by allowing for string entry: "405", "440", .... 
   EndIf
   
   ;set group-pertenecence
   If ($group>=0) then 
	  ControlCommand($W_IAC, "", "[CLASSNN:ComboBox10]","SetCurrentSelection", $group)
   EndIf
   
   ;set Photomultiplier Tube Voltage
   if ($PMTVoltage>0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit19]", $PMTVoltage)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit19]", "{ENTER}")
	   ControlSetText($W_IAC, "", "[CLASSNN:Edit19]", $PMTVoltage) ; no idea why, but repetition necessary; otherwise only every 2nd time the correct value is set
	  ControlSend($W_IAC, "", "[CLASSNN:Edit19]", "{ENTER}")
   EndIf
   
   ;set multiplier gain (recommended leaving at "1" !!!)
   if ($gain>=0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit20]", $gain)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit20]", "{ENTER}")
   EndIf
   
   ;set cut-off as relative percentage (recommended leaving at "0"!!!)
   if ($cutOffPerc>=0) then 
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit21]", $cutOffPerc)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit21]", "{ENTER}")
   EndIf
   
   ;set AOTF-controlled laser output (in percent) 219
   if ($power>=0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit22]", $power)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit22]", "{ENTER}")
   EndIf
   
   Return
EndFunc

Func GetRXD1()
   ; returns settings for acquisition channel RXD1: [$state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power]
   
   ; check if oldconfocal, because oldconfocal does not have these channels
   if $oldconfocal = 1 then Exit
	  
   ;$handle = WinActivate("Image Acquisition", "") ; necessary?
   ;ControlClick($W_IAC, "", 205) ; necessary?
   
   ;set state (box checked or unchecked)
   $state = ControlCommand($W_IAC, "", "[CLASSNN:Button77]", "IsChecked", "")
   
   ;get laser from list
   $strlaser = ControlGetText($W_IAC, "", "[CLASSNN:ComboBox9]")
   $laserNativeListPosition=ControlCommand ( $W_IAC, "", "[CLASSNN:ComboBox9]", "FindString", $strlaser)
	  
   ;get group-pertenecence
   $strGroup = ControlGetText($W_IAC, "", "[CLASSNN:ComboBox10]")
   $group=ControlCommand ( $W_IAC, "", "[CLASSNN:ComboBox10]", "FindString", $strGroup)
   
   ;get Photomultiplier Tube Voltage
   $PMTVoltage = Number(ControlGetText($W_IAC, "", "[CLASSNN:Edit19]"))

   ;get multiplier gain
   $multi = Number(ControlGetText($W_IAC, "", "[CLASSNN:Edit20]"))

   ;get cut-off (relative percentage)
   $cutOffPerc = Number(ControlGetText($W_IAC, "", "[CLASSNN:Edit21]"))
   
   ;get AOTF-controlled laser output (in percent)
   $power = Number(ControlGetText($W_IAC, "", "[CLASSNN:Edit22]"))
   
   ; return values: der Übersichtlichkeit wegen wird array erst hier 'befüllt'
   Local $arArray[7]
   $arArray[0] = $state
   $arArray[1] = $laserNativeListPosition
   $arArray[2] = $group
   $arArray[3] = $PMTVoltage
   $arArray[4] = $multi
   $arArray[5] = $cutOffPerc
   $arArray[6] = $power
   Return $arArray
EndFunc


Func SetRXD2($state,$laser,$group, $PMTVoltage,$gain, $cutOffPerc, $power)
   ; for any negative value recieved the corresponding setting will be maintained (thus: no change)
   ; attention: values are changed only when state=1; this is due to FV1000 user interface and not due to autoit
   
   ;set current window focus
   ;$handle = WinActivate($W_IAC, "") ;not strictly necessary
   ;ControlClick($W_IAC, "", 205) 	 ;not strictly necessary
   
   ;set state (box checked or unchecked)
   If ($state >= 0) Then
	  ControlCommand($W_IAC, "", "[CLASSNN:Button84]", $check[$state], "")
   Endif
   
   ;chose and set laser from list
   if ($laser>=0) then
	  ControlCommand($W_IAC, "", "[CLASSNN:ComboBox11]","SetCurrentSelection", $laser)
	  ;SUGGESTED IMPROVERMENT: improve by allowing for string entry: "405", "440", .... 
   EndIf
   
   ;set group-pertenecence
   If ($group>=0) then 
	  ControlCommand($W_IAC, "", "[CLASSNN:ComboBox12]","SetCurrentSelection", $group)
   EndIf
   
   ;set Photomultiplier Tube Voltage
   if ($PMTVoltage>0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit23]", $PMTVoltage)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit23]", "{ENTER}")
   	  ControlSetText($W_IAC, "", "[CLASSNN:Edit23]", $PMTVoltage) ; no idea why, but repetition necessary; otherwise only every 2nd time the correct value is set
	  ControlSend($W_IAC, "", "[CLASSNN:Edit23]", "{ENTER}")
   EndIf
   
   ;set multiplier gain (recommended leaving at "1" !!!)
   if ($gain>=0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit24]", $gain)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit24]", "{ENTER}")
   EndIf
   
   ;set cut-off as relative percentage (recommended leaving at "0"!!!)
   if ($cutOffPerc>=0) then 
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit25]", $cutOffPerc)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit25]", "{ENTER}")
   EndIf
   
   ;set AOTF-controlled laser output (in percent) 219
   if ($power>=0) then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit26]", $power)
	  ControlSend($W_IAC, "", "[CLASSNN:Edit26]", "{ENTER}")
   EndIf
   
   Return
EndFunc

Func GetRXD2()
   ; returns settings for acquisition channel RXD2: [$state,$laser,$group, $PMTVoltage,$multi, $cutOffPerc, $power]
   
   ; check if oldconfocal, because oldconfocal does not have these channels
   if $oldconfocal = 1 then Exit
   
   ;$handle = WinActivate("Image Acquisition", "") ; necessary?
   ;ControlClick($W_IAC, "", 205) ; necessary?
   
   ;set state (box checked or unchecked)
   $state = ControlCommand($W_IAC, "", "[CLASSNN:Button84]", "IsChecked", "")
   
   ;get laser from list
   $strlaser = ControlGetText($W_IAC, "", "[CLASSNN:ComboBox11]")
   $laserNativeListPosition=ControlCommand ( $W_IAC, "", "[CLASSNN:ComboBox11]", "FindString", $strlaser)
	  
   ;get group-pertenecence
   $strGroup = ControlGetText($W_IAC, "", "[CLASSNN:ComboBox12]")
   $group=ControlCommand ( $W_IAC, "", "[CLASSNN:ComboBox12]", "FindString", $strGroup)
   
   ;get Photomultiplier Tube Voltage
   $PMTVoltage = Number(ControlGetText($W_IAC, "", "[CLASSNN:Edit23]"))

   ;get multiplier gain
   $multi = Number(ControlGetText($W_IAC, "", "[CLASSNN:Edit24]"))

   ;get cut-off (relative percentage)
   $cutOffPerc = Number(ControlGetText($W_IAC, "", "[CLASSNN:Edit25]"))
   
   ;get AOTF-controlled laser output (in percent)
   $power = Number(ControlGetText($W_IAC, "", "[CLASSNN:Edit26]"))
   
   ; return values: der Übersichtlichkeit wegen wird array erst hier 'befüllt'
   Local $arArray[7]
   $arArray[0] = $state
   $arArray[1] = $laserNativeListPosition
   $arArray[2] = $group
   $arArray[3] = $PMTVoltage
   $arArray[4] = $multi
   $arArray[5] = $cutOffPerc
   $arArray[6] = $power
   Return $arArray
EndFunc


; ----------------------------------------------------------------
; FILTER MODE
; ----------------------------------------------------------------
Func SetFilterMode($KalmanState,$LineState, $KalmanRepetitions)
   
   ;basic check if window exists
   if WinExists ($W_IAC) Then
		 winactivate($W_IAC)
   Else
	  Return -1
   EndIf
   
   ;click on correct area
   ControlClick($W_IAC, "", 706) ;not strictly necessary
   
   ;set state (box checked or unchecked)
   if $KalmanState=1 or $KalmanState=0 then ControlCommand($W_IAC, "", "[CLASSNN:Button97]", $check[$KalmanState], "")
   
   ; set Line or Frame Scanning
   if $LineState=1 then ;needs both in order not to send FluowView into endless loop
	  ControlCommand($W_IAC, "", "[CLASSNN:Button94]", $check[1], "") ; switch to "LineScanning"
	  ControlCommand($W_IAC, "", "[CLASSNN:Button95]", $check[0], "") ; switch to "LineScanning"
   EndIf
   if $LineState=0 then ;needs both in order not to send FluowView into endless loop
	  ControlCommand($W_IAC, "", "[CLASSNN:Button95]", $check[1], "") ; switch to "FrameScanning"
	  ControlCommand($W_IAC, "", "[CLASSNN:Button94]", $check[0], "") ; switch to "FrameScanning"
   EndIf
   
   ;set number of Kalmanrepetitions
   if $KalmanRepetitions>=0 then
	  ControlSetText($W_IAC, "", "[CLASSNN:Edit29]", $KalmanRepetitions)
	  ControlClick($W_IAC, "", "[CLASSNN:Edit29]", "left", 1)
	  ControlClick($W_IAC, "", 223, "left", 1)
   Endif
   Return
EndFunc

Func GetFilterMode()
   
   ;basic check if XY-stage is initiated
   if WinExists ($W_IAC) Then
		 winactivate($W_IAC)
   Else
	  Return -1
   EndIf
   
   ;click on correct area
   ControlClick($W_IAC, "", 706)
   
   ;get state (box checked or unchecked)
   $KalmanState = ControlCommand($W_IAC, "", "[CLASSNN:Button97]", "IsChecked", "")
   
   ;get Line or Frame Scanning (if LineState=0 that automatically means that frame-scanning is on!!!)
   $LineState = ControlCommand($W_IAC, "", "[CLASSNN:Button94]", "IsChecked", "")
   
   ;set number of Kalmanrepetitions
   $KalmanRepetitions = Number(ControlGetText($W_IAC, "", "[CLASSNN:Edit29]"))
   
   ;return results
   Local $arArray[3]
   $arArray[0] = $KalmanState
   $arArray[1] = $LineState
   $arArray[2] = $KalmanRepetitions
   Return $arArray
EndFunc


; ----------------------------------------------------------------
; Dichroic Mirrors: Excitation and Emission DMs
; ----------------------------------------------------------------
Func SetExcitationDM($dichroic)
   ;WinActivate($W_IAC, "")
   ;ControlClick($W_IAC, "", 205)
   
   ; Open LightPath Window
   $handle = WinActivate($W_LP, "")
   $itemref = ControlCommand($W_LP, "", 307,"FindString", $dichroic)
   ControlCommand($W_LP, "", 307,"SetCurrentSelection", $itemref)
   WinClose($W_LP, "")
   
   Return
EndFunc

Func GetExcitationDM() 
   ; returns the name of the current objective as a string
   Return String(ControlGetText ($W_LP, "", "[CLASSNN:ComboBox1]"))
EndFunc


Func SetEmissionDM1($dichroic)
   ; acceptable values (2012-01-24): "Mirror", "Glass", "SDM490", "SDM560", "SDM510", "SDM460"
   $handle = WinActivate("Image Acquisition", "")
   ControlClick($W_IAC, "", 205)
   ; Open LightPath Window
   $handle = WinActivate($W_LP, "")
   $itemref = ControlCommand($W_LP, "", 301,"FindString", $dichroic)
   ControlCommand($W_LP, "", 301,"SetCurrentSelection", $itemref)
   ;sleep(1000)
   WinClose("LightPath", "")
   
   Return
EndFunc  

Func GetEmissionDM1() 
   ; returns the name of the current objective as a string
 
   ; acceptable values (2012-01-24): "Mirror", "Glass", "SDM490", "SDM560", "SDM510", "SDM460"
   $handle = WinActivate("Image Acquisition", "")
   ControlClick($W_IAC, "", 205)
   ; Open LightPath Window
   $handle = WinActivate($W_LP, "")
   
   $strDM = String(ControlGetText ($W_LP, "", 301)) 
   ;sleep(1000)
   WinClose("LightPath", "")
  
   Return $strDM
EndFunc

Func SetEmissionDM2($dichroic)
   ; acceptable values (2012-01-24): "Mirror", "Glass", "SDM640", "SDM560", "SDM510", "None"
   $handle = WinActivate("Image Acquisition", "")
   ControlClick($W_IAC, "", 205)
   
   ; Open LightPath Window
   $handle = WinActivate($W_LP, "")
   
   ;search string position in item list
   $itemref = ControlCommand($W_LP, "", "[CLASSNN:ComboBox7]","FindString", $dichroic)
   
   ;select corresponding item from list
   ControlCommand($W_LP, "", "[CLASSNN:ComboBox7]","SetCurrentSelection", $itemref)
   WinClose($W_LP, "")
   
   Return
EndFunc  

Func GetEmissionDM2() 
   ; returns the name of the current objective as a string
   Return String(ControlGetText ($W_LP, "", "[CLASSNN:ComboBox7]"))
EndFunc

Func SetEmissionDM3($dichroic)
   ; acceptable values (2012-01-24): "BA655-755", "BA575-675", "BA575-620", "None"
   ;$handle = WinActivate("Image Acquisition", "")
   ;ControlClick($W_IAC, "", 205)
   
   ; Open LightPath Window
   $handle = WinActivate($W_LP, "")
   
   ;search string position in item list
   $itemref = ControlCommand($W_LP, "", "[CLASSNN:ComboBox5]","FindString", $dichroic)
   
   ;select corresponding item from list
   ControlCommand($W_LP, "", "[CLASSNN:ComboBox5]","SetCurrentSelection", $itemref)
   WinClose($W_LP, "")
   
   Return
EndFunc  

Func GetEmissionDM3() 
   ; returns the name of the current objective as a string
   Return String(ControlGetText ($W_LP, "", "[CLASSNN:ComboBox5]"))
EndFunc

; ----------------------------------------------------------------
; Emission Detection Range
; ----------------------------------------------------------------

Func SetEmissionCh1($rngStart, $rngEnd)
   ; ATTENTION: FEEDBACK necessary if values unacceptable ---- to be implemented!!!!
	  ;Bedingung1: rngStart < rngEnd
	  ;Bedingung2: 400 <= rngStart <700
	  ;Bedingung3: 400 < rngEnd <=700
	  ;Bedingung4: rngEnd-rngStart <= 100
     
   ; Open LightPath Window
   $handle = WinActivate($W_LP, "")
   
   ; set lower Emission Detection
   ControlSetText($W_LP, "", "[CLASSNN:Edit5]", $rngStart)
   ControlSend($W_LP, "", "[CLASSNN:Edit5]", "{ENTER}")
   
   ; set upper Emission Detection
   if $rngStart<$rngEnd then
	  ControlSetText($W_LP, "", "[CLASSNN:Edit4]", $rngEnd)
	  ControlSend($W_LP, "", "[CLASSNN:Edit4]", "{ENTER}")
   Endif
   
   WinClose($W_LP, "")
   Return
EndFunc

Func GetEmissionCh1() 
   ;returns the lowest and highest detection wavelength as an array
   
   ; returns the name of the current detection range lowest wavelength
   $rngStart=Number(ControlGetText ($W_LP, "", "[CLASSNN:Edit5]"))
   
   ; returns the name of the current detection range highest wavelength
   $rngEnd=Number(ControlGetText ($W_LP, "", "[CLASSNN:Edit4]"))
      
   ; return values: der Übersichtlichkeit wegen wird array erst hier 'befüllt'
   Local $arArray[2]
   $arArray[0] = $rngStart
   $arArray[1] = $rngEnd
   Return $arArray
EndFunc

Func SetEmissionCh2($rngStart, $rngEnd)
   ; ATTENTION: FEEDBACK necessary if values unacceptable ---- to be implemented!!!!
	  ;Bedingung1: rngStart < rngEnd
	  ;Bedingung2: 400 <= rngStart <700
	  ;Bedingung3: 400 < rngEnd <=700
	  ;Bedingung4: rngEnd-rngStart <= 100
   
   ; Open LightPath Window
   $handle = WinActivate($W_LP, "")
   
   ; set lower Emission Detection
   ControlSetText($W_LP, "", "[CLASSNN:Edit3]", $rngStart)
   ControlSend($W_LP, "", "[CLASSNN:Edit3]", "{ENTER}")
   
   ; set upper Emission Detection
   if $rngStart<$rngEnd then
	  ControlSetText($W_LP, "", "[CLASSNN:Edit2]", $rngEnd)
	  ControlSend($W_LP, "", "[CLASSNN:Edit2]", "{ENTER}")
   EndIf
   
   WinClose("LightPath", "")
   Return
EndFunc

Func GetEmissionCh2()
   ;returns the lowest and highest detection wavelength as an array
   
   ; returns the name of the current detection range lowest wavelength
   $rngStart=Number(ControlGetText ($W_LP, "", "[CLASSNN:Edit3]"))
   
   ; returns the name of the current detection range highest wavelength
   $rngEnd=Number(ControlGetText ($W_LP, "", "[CLASSNN:Edit2]"))
      
   ; return values: der Übersichtlichkeit wegen wird array erst hier 'befüllt'
   Local $arArray[2]
   $arArray[0] = $rngStart
   $arArray[1] = $rngEnd
   Return $arArray
EndFunc


; ----------------------------------------------------------------
; LAMBDA Scan
; ----------------------------------------------------------------
Func SetLScan($rngStart, $rngEnd, $StepSize, $Num, $BandWidth)
   ; only parameters with values > 0 are set, others are ignored/ stay unchanged
   ;
   ; works independent of visibility
   
   $handle = WinActivate($W_AS, "")
   
   ; set spectrum start
   if ($rngStart>0) then
	  ControlSetText($W_AS, "", "[CLASSNN:Edit8]", $rngStart)
	 ControlSend($W_AS, "", "[CLASSNN:Edit8]", "{ENTER}")
   EndIf
   
   ; set spectrum end
   if ($rngEnd>0) then
	  ControlSetText($W_AS, "", "[CLASSNN:Edit9]", $rngEnd)
	  ControlSend($W_AS, "", "[CLASSNN:Edit9]", "{ENTER}")
   EndIf
   
   ; set spectrum stepsize
   if ($StepSize>0) then
	  ControlSetText($W_AS, "", "[CLASSNN:Edit10]", $StepSize)
	  ControlSend($W_AS, "", "[CLASSNN:Edit10]", "{ENTER}")
   EndIf
   
   ; set amount of steps to be taken
   if ($Num>0) then
	  ControlSetText($W_AS, "", "[CLASSNN:Edit11]", $Num)
	  ControlSend($W_AS, "", "[CLASSNN:Edit11]", "{ENTER}")
   EndIf
   
   ; set bandwidht
   if ($BandWidth>0) then
	  ControlSetText($W_AS, "", "[CLASSNN:Edit12]", $BandWidth)
	  ControlSend($W_AS, "", "[CLASSNN:Edit12]", "{ENTER}")
   EndIf
   
   Return
EndFunc

Func GetLScan()
   ;returns all parameters necessary for a lambda scan
   
   ; get spectrum start
   $rngStart = ControlGetText($W_AS, "", "[CLASSNN:Edit8]")
   
   ; get spectrum end
   $rngEnd=ControlGetText($W_AS, "", "[CLASSNN:Edit9]")
   
   ; get spectrum stepsize
   $StepSize=ControlGetText($W_AS, "", "[CLASSNN:Edit10]")
   
   ; get amount of steps to be taken
   $Num=ControlGetText($W_AS, "", "[CLASSNN:Edit11]")
   
   ; get bandwidht
   $BandWidth=ControlGetText($W_AS, "", "[CLASSNN:Edit12]")
   
   ; return values: der Übersichtlichkeit wegen wird array erst hier 'befüllt'
   Local $arArray[5]
   $arArray[0] = $rngStart
   $arArray[1] = $rngEnd
   $arArray[2] = $StepSize
   $arArray[3] = $Num
   $arArray[4] = $BandWidth
   Return $arArray
EndFunc


; ----------------------------------------------------------------
; Pinhole
; ----------------------------------------------------------------
Func SetPinhole($state, $diameter)
   ;$state: "1"=auto, "0"=manual
   ;NOTE: diameter can be set only provided that $state is set to "1" (auto)
   ;negative values are ignored
   
   $handle = WinActivate($W_IAC, "")
   
   ;set state (box checked or unchecked) for autoSizePinhole
   if $state=0 or $state=1 then
	  ControlCommand($W_IAC, "", "[ID:470]", $check[$state], "")
   EndIf
   
   ;set diameter of pinhole manually
   if ($state>0 and $diameter>0) then
	  ControlSetText($W_IAC, "", "[CLASS:Edit;INSTANCE:19]", $diameter)
	  ControlSend($W_IAC, "", "[CLASS:Edit;INSTANCE:19]", "{ENTER}")
   EndIf
   
   Return
Endfunc
   
Func GetPinhole()
   ; returns parameters necessary for setting the pinhole (auto-state and diameter)
   ;$state: "1"=auto, "0"=manual
   
   ;set state (box checked or unchecked) for autoSizePinhole
   $state = ControlCommand($W_IAC, "", "[ID:470]", "IsChecked", "")
   
   ;get diameter of pinhole manually
   $diameter=ControlGetText($W_IAC, "", "[ID:243]")
   
   ; return values: der Übersichtlichkeit wegen wird array erst hier 'befüllt'
   Local $arArray[2]
   $arArray[0] = $state
   $arArray[1] = $diameter
   Return $arArray
endfunc



; ----------------------------------------------------------------
; Microscope Controller: ToolbarWindow323
; ----------------------------------------------------------------
Func SetMicrController($mirror, $EPIFilter, $Condenser)
; function sets various controls of the microscope controler
; ATTENTION: does not work yet
; values <1 are ignored and have no effect
; Lazout-Setting: Button1

   $handle = WinActivate($W_OF, "")
   
   ;Open Window "Microscope Controller" and wait until it appears
   Send("!d")
   Send("{DOWN}")
   Send("{ENTER}")
   WinWait("Microscope Controller")

   if $mirror>0 then ;<--------------------- works great
	  Switch $mirror ; state as of 2012-04-20
		  Case 1 ; = LSM
			  ControlClick($W_MC, "LSM", "[CLASSNN:Button28]", "left", 1)
		  Case 2 ;=RDM690
			  ControlClick($W_MC, "RDM690", "[CLASSNN:Button27]", "left", 1)
		  Case 3 ;=UV/B/G
			  ControlClick($W_MC, "", "[CLASSNN:Button26]", "left", 1)
		  Case 4 ; = DICT
			  ControlClick($W_MC, "", "[CLASSNN:Button23]", "left", 1)
		  Case 5 ;=TIRF
			  ControlClick($W_MC, "TIRF", "[CLASSNN:Button24]", "left", 1)
		  Case 6 ;=CFP/YFP
			  ControlClick($W_MC, "CFP / YFP", "[CLASSNN:Button25]", "left", 1)
	  EndSwitch
   EndIf
   
   if $EPIFilter>0 Then ;<--------------------- DOES NOT WORK !!!!!!!!!!!!!!!!!!!!!!!!!!!
	  Switch $EPIFilter ; state as of 2012-04-20
		  Case 1 ; = none
			  ControlClick($W_MC, "none", "[CLASSNN:Button72]", "left", 1)
		  Case 2 ;=ND50
			  ControlClick($W_MC, "ND50", "[CLASSNN:Button71]", "left", 1)
		  Case 3 ;=ND25
			  ControlClick($W_MC, "ND25", "[CLASSNN:Button70]", "left", 1)
		  Case 4 ;=cfp exciter
			  ControlClick($W_MC, "cfp exciter", "[CLASSNN:Button67]", "left", 1)
		  Case 5 ;=
			  ControlClick($W_MC, "", "[CLASSNN:Button68]", "left", 1)
		  Case 6 ;=close
			  ControlClick($W_MC, "close", "[CLASSNN:Button69]", "left", 1)
	  EndSwitch
   EndIf
   
   If $Condenser>0 Then ;<--------------------- works great
	  Switch $Condenser ; state as of 2012-04-20
		  Case 1 ; = 
			  ControlClick($W_MC, "", "[CLASSNN:Button18]", "left", 1)
		  Case 2 ;=DIC40
			  ControlClick($W_MC, "DIC40", "[CLASSNN:Button17]", "left", 1)
		  Case 3 ;=DIC10
			  ControlClick($W_MC, "DIC10", "[CLASSNN:Button16]", "left", 1)
		  Case 4 ;
			  ControlClick($W_MC, "", "[CLASSNN:Button13]", "left", 1)
		  Case 5 ;=DIC20
			  ControlClick($W_MC, "DIC20", "[CLASSNN:Button14]", "left", 1)
		  Case 6 ;=DIC60
			  ControlClick($W_MC, "DIC60", "[CLASSNN:Button15]", "left", 1)
	  EndSwitch
   EndIf
   
   Return
EndFunc

Func GetMicrController()
   ;returns parameters necessary for setting the microscope controller
   ; ATTENTION: does not work yet
   ;
   $handle = WinActivate($W_OF, "")
   
   ;Open Window "Microscope Controller" and wait until it appears
   Send("!d")
   Send("{DOWN}")
   Send("{ENTER}")
   WinWait("Microscope Controller")
   
   ;initiate variables
   $mirror=-1
   $EPIFilter=-1
   $Condenser=-1
   
   ;get mirror type: 1=LSM, 2=RDM690, 3=UV/B/G, 4=DICT, 5=TIRF, 6=CFP/YFP ; state as of 2012-04-20
   if ControlCommand($W_MC, "", "[CLASSNN:Button28]", "IsChecked", "") Then $mirror=1
   if ControlCommand($W_MC, "", "[CLASSNN:Button27]", "IsChecked", "") Then $mirror=2
   if ControlCommand($W_MC, "", "[CLASSNN:Button26]", "IsChecked", "") Then $mirror=3
   if ControlCommand($W_MC, "", "[CLASSNN:Button23]", "IsChecked", "") Then $mirror=4
   if ControlCommand($W_MC, "", "[CLASSNN:Button24]", "IsChecked", "") Then $mirror=5
   if ControlCommand($W_MC, "", "[CLASSNN:Button25]", "IsChecked", "") Then $mirror=6

   ;get epifilter: 1=none, 2=ND50, 3=ND25, 4=cfp exciter, 5=, 6=close ; state as of 2012-04-20
   if ControlCommand($W_MC, "", "[CLASSNN:Button72]", "IsChecked", "") Then $EPIFilter=1
   if ControlCommand($W_MC, "", "[CLASSNN:Button71]", "IsChecked", "") Then $EPIFilter=2
   if ControlCommand($W_MC, "", "[CLASSNN:Button70]", "IsChecked", "") Then $EPIFilter=3
   if ControlCommand($W_MC, "", "[CLASSNN:Button67]", "IsChecked", "") Then $EPIFilter=4
   if ControlCommand($W_MC, "", "[CLASSNN:Button68]", "IsChecked", "") Then $EPIFilter=5
   if ControlCommand($W_MC, "", "[CLASSNN:Button69]", "IsChecked", "") Then $EPIFilter=6
   
   ;get condenser: 1=, 2=DIC40, 3=DIC10, 4=, 5=DIC20, 6=DIC60 ; state as of 2012-04-20
   if ControlCommand($W_MC, "", "[CLASSNN:Button18]", "IsChecked", "") Then $Condenser=1
   if ControlCommand($W_MC, "", "[CLASSNN:Button17]", "IsChecked", "") Then $Condenser=2
   if ControlCommand($W_MC, "", "[CLASSNN:Button16]", "IsChecked", "") Then $Condenser=3
   if ControlCommand($W_MC, "", "[CLASSNN:Button13]", "IsChecked", "") Then $Condenser=4
   if ControlCommand($W_MC, "", "[CLASSNN:Button14]", "IsChecked", "") Then $Condenser=5
   if ControlCommand($W_MC, "", "[CLASSNN:Button15]", "IsChecked", "") Then $Condenser=6

   ; return values: der Übersichtlichkeit wegen wird array erst hier 'befüllt'
   Local $arArray[3]
   $arArray[0] = $mirror
   $arArray[1] = $EPIFilter
   $arArray[2] = $Condenser
   Return $arArray
EndFunc





;SetMicrController(4, -1, -2)
;$x=GetMicrController()
;MsgBox(0,"",$x[2])
;MsgBox(0,"",GetEmissionCh1())







;========================================================================================
;========================================================================================
;		 ----------------------------------------------------------------
;								Multi Time Laps / XY-Stage
;		 ----------------------------------------------------------------
;========================================================================================
;========================================================================================


 Func XY_iniStage($oriDetect,$waitForWindow)
	;this function opens the XY-Stage-Window
	; default call: iniXYStage(1,1)
	; if oriDetect=1 the physical origin of the stage will be checked/detected
	; if waitForWindow=1 the function will wait for the apparence of the Multi A. Time Lapse controller before returning/finishing
	
	Local $ESCAuto=1; warning: do not change! Physical damage at objective can result
	
	;exit if window already open
	if WinExists ( "Multi Area Time Lapse Controller") Then Return
   
   ;open window of XY-Stage
   WinActivate("Olympus Fluoview", "")
   Send("!d")
   Send("{ENTER}")
   Send("{DOWN}")
   Send("{DOWN}")
   Send("{ENTER}")
   winwait("XY Stage warning")
	
	;set true/false for Escape Automatically
	if $ESCAuto=0 or $ESCAuto=1 then ControlCommand("XY Stage warning", "", "[CLASSNN:Button1]", $check[$ESCAuto], "")  
    
   ;initialization
   if $oriDetect=1 then
	  ControlClick("XY Stage warning", "", "[CLASSNN:Button2]", "left", 1)
   Else
	  ControlClick("XY Stage warning", "", "[CLASSNN:Button3]", "left", 1)
   Endif
   
   if $waitForWindow=1 Then
	  winwait("Multi Area Time Lapse Controller")
   endif
   
Return
EndFunc

Func XY_OpenWindowRegPointList()
   ; NOT YET IMPLEMENTED <-------------------- NOT YEYT IMPLEMENTED
   ; check if generally the Multi Area Time Lapse Viewer has been started
   if not WinExists ($W_XY_MATLC) Then Return
   
   ;activate RegPointList
   WinActivate ($W_XY_RPL)
   
   Return
EndFunc

Func XY_RegisterPoint()
   ;Local $XYSW_Win="XY Stage warning"
   ; Menuleiste MATLC_Win: RichEdit20W + File=43, Edit=42, View=59, Options=60   
   
   if not WinExists ($W_XY_RPL) Then 
	  MsgBox(0,"AutoIT-Warning", "Script of AutoIT did not find window of " & $W_XY_MATLC)
	  Return
   EndIf
   
   ControlClick($W_XY_MATLC, "", 1002, "left", 1)
   
   Return
EndFunc

Func XY_NewRegPointList($saveOld, $pathSave)
   ;function opens a NEW and EMPTY RegPointList of the XY-Stage
   ;WARNING: no error checking function for valid path-names yet established!!!!!
   ;WARNING2: saving old RegPointList works only if it was changed recently, otherwise refer to XY_SaveRegPointListAs($path)
   ; $saveOld: 1=yes save old RegPointList file
   ; $pathSave: specify path and filename
   ;Example: XY_NewRegPointList(0,"")
      
   ;Click to make a NEW and EMPTY RegPointList
   ControlClick($W_XY_RPL, "", "[CLASSNN:Button8]", "left", 1)
   sleep(200) ;workaround
   
   ;check if window asks to save existing RegPointList
   if WinExists($W_XY_TC) then
	  if $saveOld <> 1 Then
		 ControlClick($W_XY_TC, "&No", "[CLASSNN:Button2]", "left", 1)
	  Else
		 ControlClick($W_XY_TC, "&Yes", "[CLASSNN:Button1]", "left", 1)
		  ;save old file. WARNING: when the program knows the file name already, no "save as" dialog is opened anyway
		 if $pathSave<>"" then
			sleep(500); WinWait("Save As","",1)
			ControlSetText("Save As", "", "[CLASSNN:Edit1]", $pathSave) ; enter path for saving old RegPointList
			ControlClick("Save As", "&Save", "[CLASSNN:Button2]", "left", 1) ;click "save"
			sleep(2000) ; workaround, not ideal solution
		 Else
			MsgBox(0,"Warning: Path not provided","A script in AutoIT attempts to save a RegPointList via opening a new and empty RegPointList but did not provide a path.")
		 EndIf
	  EndIF
   EndIf
   
   Return
EndFunc

Func XY_SaveRegPointListAs($path)
   ;function saves an existing RegPointList of the XY-Stage
   ;WARNING: no error checking function for valid path-names yet established!!!!!
   ; $path: specify path and filename
   ;Example: SaveRegPointListAs("TimeController.omp2")
   
   ;Click to "Save As" an existing RegPointList
   ControlClick($W_XY_RPL, "", "[CLASSNN:Button10]", "left", 1)
   WinWait("Save As"); ,"",2) ;WARNING: not always the Case
   
   ;Enter Path and FileChangeDir
   ControlSetText("Save As", "", "[CLASSNN:Edit1]", $path) ; enter path for saving old RegPointList
   
   ;click to save
   ControlClick("Save As", "&Save", "[CLASSNN:Button2]", "left", 1) ;click "save"

   sleep(2000) ; workaround, not ideal solution
   Return
EndFunc

Func XY_SaveRegPointList()
   ;function directly saves an existing RegPointList of the XY-Stage
   
   ;Click to "Save As" an existing RegPointList
   ControlClick($W_XY_RPL, "", "[CLASSNN:Button11]", "left", 1)

   sleep(2000) ; workaround, not ideal solution
   Return
EndFunc


Func XY_OpenExistingRegPointList($pathOpen,$saveOld, $pathSave)
   ;function opens an existing RegPointList of the XY-Stage
   ;WARNING: no error checking function for valid path-names yet established!!!!!
   ; $pathOpen: specify path and filename
   ; $saveOld: 0=no do not save file, 1=yes save file, 3=cancel
   ; $pathSave: specify path and filename
   ;Example: XY_OpenExistingRegPointList("TimeController.omp2",0,"")
      
   ;Click to Open an existing RegPointList
   ControlClick($W_XY_RPL, "", "[CLASSNN:Button9]", "left", 1)
   WinWait("TimeController"); ,"",2) ;WARNING: not always the Case
   
   Switch $saveOld
   Case 0 ;no, do not save old file
	  ControlClick($W_XY_TC, "&No", "[CLASSNN:Button2]", "left", 1) ;deny saving old RegPointList
   Case 1 ; yes, save old file
	  ControlClick($W_XY_TC, "&Yes", "[CLASSNN:Button1]", "left", 1)
	   ;save old file. WARNING: when the program knows the file name already, no "save as" dialog is opened anyway
	  if $pathSave<>"" then
		 sleep(500); WinWait("Save As","",1)
		 ControlSetText("Save As", "", "[CLASSNN:Edit1]", $pathSave) ; enter path for saving old RegPointList
		 ControlClick("Save As", "&Save", "[CLASSNN:Button2]", "left", 1) ;click "save"
	  EndIf
   Case 2 ; cancel
	  ControlClick($W_XY_TC, "Cancel", "[CLASSNN:Button3]", "left", 1) ;cancel operations
	  ControlClick($W_XY_MATL, "OK", "[CLASSNN:Button1]", "left", 1)
   Case Else
	  MsgBox(0,"Warning: AutoIt opening new RegPointList","Opening Parameter not recognized. Operation aborted.")
	  return
   EndSwitch
   
   ;Check if required window "open" is already there
   ;WinWait("Open"); ,"",2) ;<------ does not work
   sleep(1500) ; workaround, not ideal solution
   ;Open a saved RegPointList from path
   ControlSetText("Open", "", "[CLASSNN:Edit1]", $pathOpen) ; enter path
   ControlClick("Open", "Open", "[CLASSNN:Button2]", "left", 1) ;click "save"
   sleep(2000) ; workaround, not ideal solution
   Return
EndFunc

Func XY_ShiftZAxis($shift)
   ; WARNING: NOT YET FULLY IMPELEMTED <-------------------------------------------------
   ;function shifts zAxis for the currently selected entries in RegPointList
   ;$shift: shift in micrometers, +/-
   
   ;basic check if XY-stage is initiated
   if not WinExists ($W_XY_MATLC) Then Return -1
      if not IsNumber($shift) Then
	  MsgBox(0,"Variable not a number","Script AutoIT passed a variable to function XY_ShiftZAxis($shift) which was not a number.")
	  return -1
   EndIf
   ;click shift Z Axis
   ControlClick($W_XY_RPL, "", "[CLASSNN:Button18]", "left", 1)
   WinWait($W_XY_SZA)
   
   ;Enter value in micrometers
   ControlSetText($W_XY_SZA, "", "[CLASSNN:Edit1]", $shift)
   sleep(1500)
   ControlClick($W_XY_SZA,"","[CLASSNN:Button1]", "left", 1) ;<----------------- this click is not recognized: why?
   
   Return 1
EndFunc

Func XY_ExecuteGetReady()
   ;clicks on "get ready" button prior to starting an automated recording
   
   ;basic check if XY-stage is initiated
   if not WinExists ($W_XY_MATLC) Then Return -1
   
   ;click shift Z Axis
   ControlClick($W_XY_RPL, "", "[CLASSNN:Button3]", "left", 1)
   sleep(200) ; workaround: allows the program to de-enable the button
   While not ControlCommand ($W_XY_RPL, "", "[CLASSNN:Button4]", "IsEnabled", "")
	  sleep(100) ; WARNING: not well coded as interrupt misses
   WEnd
   Return 1
EndFunc

Func XY_ExecuteRegPointList($force)
   ;clicks on "get ready" button prior to starting an automated recording
   ; force: if 1 then the RegPointList will be both readied and executed without further questions
   
   ;basic check if XY-stage is initiated
   if not WinExists ($W_XY_MATLC) Then Return -1
   if not IsNumber($force) Then
	  MsgBox(0,"Variable not a number","Script AutoIT passed a variable to function XY_ExecuteRegPointList($force) which was not a number.")
	  return -1
   EndIf
   
   ;checks if control is enabled
   if ControlCommand ($W_XY_RPL, "", "[CLASSNN:Button4]", "IsEnabled", "") Then
	  ControlClick($W_XY_RPL, "", "[CLASSNN:Button4]", "left", 1)
   Else
	  if $forceStart=1 then 
		 XY_ExecuteGetReady() ;only if $force=1 the RegPointList will be readied, too
		 ControlClick($W_XY_RPL, "", "[CLASSNN:Button4]", "left", 1)
	  Else
		 return -1 ;not started as "forced status" was off
	  EndIf
   EndIf
   
   Return 1
EndFunc

Func XY_PauseExeRegPointList()
   ;function pauses the execution of a RegPointList
   ;WARNING: Olympus-Software not stable
   ;WARNING: operations are not paused inmediately, but rather the running scan at the current position is executed but then the program halts
   
   
   ;basic check if XY-stage is initiated
   if not WinExists ($W_XY_MATLC) Then Return -1
   
   ;checks if control is enabled
   if ControlCommand ($W_XY_RPL, "", "[CLASSNN:Button5]", "IsEnabled", "") and not ControlCommand ($W_XY_RPL, "", 1002, "IsEnabled", "") Then
	  ;clicks pause button
	  ControlClick($W_XY_RPL, "", "[CLASSNN:Button5]", "left", 1)
	  sleep(200) ; workaround: allows the program to de-enable the button
	  While not ControlCommand ($W_XY_RPL, "", "[CLASSNN:Button4]", "IsEnabled", "")
		 sleep(100) ; WARNING: not well coded as interrupt misses
	  WEnd
   Endif
   
   Return 1
EndFunc

Func XY_ContinueExeRegPointList()
   ;function continues the execution of a paused operation
   ;WARNING: Olympus-Software not stable
   
   ;basic check if XY-stage is initiated
   if not WinExists ($W_XY_MATLC) Then Return -1
   
   ;checks if control is enabled
   if ControlCommand ($W_XY_RPL, "", "[CLASSNN:Button5]", "IsEnabled", "") and ControlCommand ($W_XY_RPL, "", 1002, "IsEnabled", "") Then ;very important: no "NOT"
	  ;clicks continue-button
	  ControlClick($W_XY_RPL, "", "[CLASSNN:Button5]", "left", 1)
	  sleep(200) ; workaround
   Endif
   
   Return
EndFunc

Func XY_StopExeRegPointList($force)
   ;function continues the execution of a paused operation
   ;WARNING: Olympus-Software not stable
   ;WARNING: currently(2012-FEB) Olympus software will crash when forced to stop without prior pausing
   ;$force: (number) if 1 then execution is stopped inmediately, else it is paused first and then stopped (=safer)
   ;
   ;Example: XY_StopExeRegPointList(0)
   
   ;basic check if XY-stage is initiated
   if not WinExists ($W_XY_MATLC) Then Return -1
   if not IsNumber($force) Then
	  MsgBox(0,"Variable not a number","Script AutoIT passed a variable to function XY_StopExeRegPointList($force) which was not a number.")
	  return -1
   EndIf
   
   ;checks if control is enabled
   if ControlCommand ($W_XY_RPL, "", "[CLASSNN:Button6]", "IsEnabled", "") Then
	  if $force<> 1 Then 
		 XY_PauseExeRegPointList() 
	  EndIf
	  ControlClick($W_XY_RPL, "", "[CLASSNN:Button6]", "left", 1)
	  While not ControlCommand ($W_XY_RPL, "", "[CLASSNN:Button4]", "IsEnabled", "")
		 sleep(100) ; WARNING: not well coded: missing interrupt, particularily when program crashes!!!!!!!!!!! ------ !!!!!!!
	  WEnd
   Endif
   
   Return
EndFunc

Func XY_SetInterval($interval)
   ;function sets an time interval
   ;WARNING: string is not checked for correct format
   ;format: hh:mm:ss.S
   ;
   ;Example: XY_Interval(00:02:13.5)
   
   ;basic check if XY-stage is initiated
   if not WinExists ($W_XY_MATLC) Then Return -1
   if not IsString($interval) then 
	  MsgBox(0,"Variable $interval not a sting","Script AutoIT passed a variable to function XY_Interval($interval) which was not a string.")
	  return -1
   EndIf
	  
   ;checks if control is enabled
   if ControlCommand ($W_XY_RPL, "", "[CLASSNN:Edit2]", "IsEnabled", "") Then
	  ControlSetText($W_XY_RPL, "", "[CLASSNN:Edit2]", $interval) ; enter interval
   Else
	  return -1
   EndIf
   
   Return 1
EndFunc

Func XY_GetInterval()
   ;function reads out current time interval and returns a string when successful
   
   ;basic check if XY-stage is initiated
   if not WinExists ($W_XY_MATLC) Then Return -1
   
   Return ControlGetText($W_XY_RPL,"","[CLASSNN:Edit2]")
EndFunc

Func XY_SetRepeat($n)
   ;function sets the number of repetitions 
   ;
   ;Example: XY_Repeat(10)
   
   ;basic check if XY-stage is initiated
   if not WinExists ($W_XY_MATLC) Then Return -1
   if IsString($n) then 
	  MsgBox(0,"Variable $n not a number","Script AutoIT passed a variable to function XY_Repeat($n) which was not a number.")
	  return -1
   EndIf
	  
   ;checks if control is enabled
   if ControlCommand ($W_XY_RPL, "", "[CLASSNN:Edit1]", "IsEnabled", "") Then
	  ControlSetText($W_XY_RPL, "", "[CLASSNN:Edit1]", $n) ; enter interval
   Else
	  return -1
   EndIf
   
   Return 1
EndFunc

Func XY_GetRepeat()
   ;function reads out current repetition number and returns positive number when successful
   
   ;basic check if XY-stage is initiated
   if not WinExists ($W_XY_MATLC) Then Return -1
   
   Return number(ControlGetText($W_XY_RPL,"","[CLASSNN:Edit1]"))
EndFunc

Func XY_GetTotalTime()
   ;function reads out current Total Time Estimation and returns a string when successful
   ;format: [##d ##:##:##.#]
   
   ;basic check if XY-stage is initiated
   if not WinExists ($W_XY_MATLC) Then Return -1
   
   Return ControlGetText($W_XY_RPL,"","[CLASSNN:Static3]")
EndFunc

Func XY_GetFrameIntervalTime()
   ;function reads out current FrameIntervalTime and returns a string when successful
   ;format: [##d ##:##:##.#]
   
   ;basic check if XY-stage is initiated
   if not WinExists ($W_XY_MATLC) Then Return -1
   
   Return ControlGetText($W_XY_RPL,"","[CLASSNN:Static4]")
EndFunc

Func XY_IsInitiated()
   ;checks for the existance of the window "Multi Area Time Lapse Controller"
   Return WinExists ($W_XY_MATLC)
EndFunc

Func XY_OpenXYPos()
   ;this function opens the window "Stage Controller" necessary for getting of, setting of and moving to coordinates via xy-stage
   ;returns:
   ;	1 if initiation was successfull
   ;	0.5 if only one window could be opened successfully
   ;	0 if initiation failed completely
   
   ;initiate XY-stage if necessary
   if not WinExists ($W_XY_MATLC) Then
	  ;initiate XY-stage
	  XY_iniStage(1,1) ; bDetectOrigin, bWaitUntilExecutionFinished
   EndIf
   
   ;open Stage Controller if necessary
   if not WinExists ($W_XY_SC) Then
	  ControlClick($W_XY_MATLC, "", 1006, "left", 1)
   EndIf   
   
   Return ((WinExists ($W_XY_MATLC)+ WinExists ($W_XY_SC))/2)
EndFunc

Func XY_GetXY()
   ;this function retrieves the current position on the xy-stage
   ;note: position varies, depending on if relative to origin at stage-initiation or not
   ;returning values are in micrometers
   
   Local $arr[2]=[0,0]
   
   ;initiate window and catch error if necessary
   if (XY_OpenXYPos()<>1) then return -1
   
   $arr[0] = ControlGetText($W_XY_SC,"",600)
   $arr[1] = ControlGetText($W_XY_SC,"",601)
   
   Return $arr
EndFunc


Func XY_GotoXY($x,$y)
   ;moves automatic stage to a new position and returns the new current position
   ;x: x-Coordinate in micrometer
   ;y: y-coordinate in micrometer
   ; function returns the new position
   ;
   ;WARNING: x position hardware controller is inverted, y is not
   
   ;arbitrary sleeping time while checking to finish moving stage
	  $waitTime = 300 ; in milli seconds
	  
   ;define local array
	  Local $arrPos[2]=[0,0]
   
   ;initiate "stage controller" window and catch error if necessary
   if (XY_OpenXYPos()<>1) then 
	  MsgBox(0,"Initiation failed","AutoIT could not initiate the stage controller steering xy-coordinates. Aborting now.")
	  return -1
   EndIf
   
   ;set position
   ControlSetText($W_XY_SC, "",600,number($x)) ; set x-coordinate
   ControlSend($W_XY_SC, "", 600, "{ENTER}")
   ControlSetText($W_XY_SC, "",601,number($y)) ; set y-coordinate
   ControlSend($W_XY_SC, "", 601, "{ENTER}")
   
   ;go to set position
   ControlClick($W_XY_SC, "", 602, "left", 1)
   
   ;wait until finished
   while ControlCommand ($W_XY_MATLC, "", 1002, "IsEnabled", "") == 0
	  sleep($waitTime)
   WEnd
   
   Return  XY_GetXY()
EndFunc


Func XY_MoveByXY($x,$y)
   ;moves automatic stage by the distances specified in x and y
   ;x: delta X in micrometer
   ;y: delta y in micrometer
   ;
   ; function returns the new position
   ;WARNING: x position hardware controller is inverted, y is not
   
   
   ;arbitrary sleeping time while checking to finish moving stage
	  $waitTime = 300 ; in milli seconds
   
   ;initiate "stage controller" window and catch error if necessary
   if (XY_OpenXYPos()<>1) then 
	  MsgBox(0,"Initiation failed","AutoIT could not initiate the stage controller steering xy-coordinates. Aborting now.")
	  return -1
   EndIf
   
   ;get current position
   $arrPos=XY_GetXY() ; overwrite zero-pos array
	  
   ;catch error if returned value is not an array
   if not IsArray($arrPos) then return -1 ;as XY_GetXY() failed to retrieve a position
   
   ;set position
   ControlSetText($W_XY_SC, "",600,number($x+$arrPos[0])) ; set x-coordinate
   ControlSend($W_XY_SC, "", 600, "{ENTER}")
   ControlSetText($W_XY_SC, "",601,number($y+$arrPos[1])) ; set y-coordinate
   ControlSend($W_XY_SC, "", 601, "{ENTER}")
   
   ;go to set position
   ControlClick($W_XY_SC, "", 602, "left", 1)
   
   ;wait until finished
   while ControlCommand ($W_XY_MATLC, "", 1002, "IsEnabled", "") == 0
	  sleep($waitTime)
   WEnd
   
   Return  XY_GetXY()
EndFunc
