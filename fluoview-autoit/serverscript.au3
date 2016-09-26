Opt("WinTitleMatchMode", 1)
Opt("WinSearchChildren", 1)

  ;SERVER!! Start Me First !!!!!!!!!!!!!!!
;Autor: GtaSpider
#include <GUIConstants.au3>

; Set Some reusable info
; Set your Public IP address (@IPAddress1) here.
Global $microscope = 1 ; 0 := new confocal, 1:= old confocal
#include "fluoview3.1_newest.au3"


Dim $ip[2]
Dim $port[2]
$ip[0] = "192.168.2.102"
$port[0] = 33333
$ip[1] = "192.168.2.104"
$port[1] = 33332

Dim $szIPADDRESS = $ip[$microscope]; "127.0.0.1"; "141.20.63.13" ;"127.0.0.1"
Dim $nPORT = $port[$microscope]


; Start The TCP Services
;==============================================
TCPStartUp()

; Create a Listening "SOCKET".
;   Using your IP Address and Port 33891.
;==============================================
$MainSocket = TCPListen($szIPADDRESS, $nPORT)
;MsgBox (0,"huhu", "neeee, Jungs!!!")
; If the Socket creation fails, exit.
If $MainSocket = -1 Then Exit

;MsgBox (0,"huhu", "neeee, Jungasdfasdfasdfs!!!")

; Create a GUI for messages
;==============================================
Dim $GOOEY = GUICreate("My Server (IP: " & $szIPADDRESS & ")",300,200)
Dim $edit = GUICtrlCreateEdit("",10,10,280,180)
GUISetState()


; Initialize a variable to represent a connection
;==============================================
Dim $ConnectedSocket = -1


;Wait for and Accept a connection
;==============================================
Do
    $ConnectedSocket = TCPAccept($MainSocket)
Until $ConnectedSocket <> -1


; Get IP of client connecting
Dim $szIP_Accepted = SocketToIP($ConnectedSocket)
;MsgBox(0, $szIP_Accepted, $ConnectedSocket)

Dim $msg, $recv
; GUI Message Loop
;==============================================
While 1
   $msg = GUIGetMsg()

; GUI Closed
;--------------------
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop

; Try to receive (up to) 2048 bytes
;----------------------------------------------------------------
    $recv = TCPRecv( $ConnectedSocket, 2048 )
;    MsgBox(0, $szIP_Accepted, @error)
; If the receive failed with @error then the socket has disconnected
;----------------------------------------------------------------
;    If @error Then ExitLoop

; Update the edit control with what we have received
;----------------------------------------------------------------
    If $recv <> "" Then 
		 GUICtrlSetData($edit, $recv & @CRLF & GUICtrlRead($edit))
		 Switch $recv
		 Case	"Exit"
			TCPSend($ConnectedSocket, '1')
			If $ConnectedSocket <> -1 Then TCPCloseSocket( $ConnectedSocket )
			GUICtrlSetData($edit, 'Connection terminated. Waiting for new connection...' & @CRLF & GUICtrlRead($edit))
			Do 
			   $ConnectedSocket = TCPAccept($MainSocket)
			Until $ConnectedSocket <> -1
			GUICtrlSetData($edit, 'Successfully connected! :))' & @CRLF & GUICtrlRead($edit))
		 Case	Else
			;interpret
			$posSep = StringInStr ( $recv,";")
			
			;error check
			;if $posSep <= 0 then ABBRUCH
			
			$myFun = StringLeft ( $recv, $posSep-1)
			$myPar = StringRight ( $recv, StringLen($recv)-$posSep)
			$arrPar = StringSplit($myPar, ";")
			If $arrPar[1] <> "" Then
			   $arrPar[0] = "CallArgArray"
;			MsgBox(0, "oyutput", "recived: " & $recv & ", myFun: " & $myFun & ", myPar0: " & $arrPar[0]) ; & ", myPar1: " & $arrPar[2])
			   ;GUICtrlSetData($edit,"Parameter" & $arrPar[1] & @CRLF & GUICtrlRead($edit))
			   $retval = Call($myFun, $arrPar)
			Else
			   ;GUICtrlSetData($edit,"No Parameters" & @CRLF & GUICtrlRead($edit))
			   $retval = Call($myFun)
			EndIf
			;MsgBox(0,"asd",$retval & GetZoom())
			$retstring = ""
			If IsArray($retval) Then
			   $retstring = String($retval[0])
			   For $i = 1 To UBound($retval)-1
				  $retstring = $retstring & ';' & String($retval[$i])
			   Next
			Else
			   $retstring = String($retval)
			EndIf
			TCPSend($ConnectedSocket, $retstring)
			GUICtrlSetData($edit, "Sent retval=" & $retstring & @CRLF & GUICtrlRead($edit))
			$arrPar[1] = ""
		 EndSwitch
    EndIf
WEnd


If $ConnectedSocket <> -1 Then TCPCloseSocket( $ConnectedSocket )

TCPShutDown()


Func ShowSideBar ()
   WinActivate("OLYMPUS FLUOVIEW Ver.3.0 Viewer")
   WinActivate ("2D View")
   ControlClick("OLYMPUS FLUOVIEW Ver.3.0 Viewer", "", 350)
   
   Return
EndFunc


; Function to return IP Address from a connected socket.
;----------------------------------------------------------------------
Func SocketToIP($SHOCKET)
    Local $sockaddr = DLLStructCreate("short;ushort;uint;char[8]")

    Local $aRet = DLLCall("Ws2_32.dll","int","getpeername","int",$SHOCKET, _
            "ptr",DLLStructGetPtr($sockaddr),"int_ptr",DLLStructGetSize($sockaddr))
    If Not @error And $aRet[0] = 0 Then
        $aRet = DLLCall("Ws2_32.dll","str","inet_ntoa","int",DLLStructGetData($sockaddr,3))
        If Not @error Then $aRet = $aRet[0]
    Else
        $aRet = 0
    EndIf

    $sockaddr = 0

    Return $aRet
EndFunc 