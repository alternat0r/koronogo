
; Script by alternat0r
; First coded on 10/10/2014, 11:20 PM

; This script designed for 'Persengketaan Puak' mobile game.
; It is suitable for new	 player and old player to
; archive its goal	 especially to prevent from being
; attack and  sustain  their resources without having
; to buy gems with real money. Bla bla bla ...

; Requirement:
; 1. Windows Operating System
; 2. Install BlueStack and PP game
; 3. Install AutoIt script
; 4. Assuming you have one monitor

; Configure:
; Before you can fully start. You need to configure
; some setting first.

; How to use?
; 1. First you need to run BlueStack and the game.
; 2. Open up

; Features:
; - Prevent other user from attack
; - Keep online forever
; - Fully randomize clicking position
; - Logoff and Login to prevent suspicious
; - Automatically collect all resources

; To Do
; 1. Set default Window position

#include <Timers.au3>
#include <Date.au3>

HotKeySet("s", "Quit") 	; hit s to stop
HotKeySet("p", "Pause") ; hit p to pause

Local $hWnd
Local $hTimer = TimerInit()
Local $j = 0
Local $cnt = 0
Local $LogOffCount = 0
Local $LogInCount = 0

Local $IsOffline = False
Local $RoundCnd = 0
Local $Pause = 0

; 14400 = 4 hours, 3600 = 1 hour, 1800 = 1/2 hour, 1200 = 20 minutes
Local $TIME_TO_LOGIN = Random(180, 200, 1)  ; Time to wait before login back. Between 5 minutes to 7 minutes
Local $TIME_TO_LOGOFF = Random(180, 300, 1) ; Time between 3 minutes to 5 minutes; Play time.

Debug("Will be LOGOFF within: " & $TIME_TO_LOGOFF)
Debug("Will be LOGGED IN within: " & $TIME_TO_LOGIN)

ConsoleWrite("Ready ..." & @CRLF)
Sleep(5000) ; Will be start in 3 seconds

While 1

   ; Check internet connection
   $connect = _GetNetworkConnect()
   If $connect Then
	  ConsoleWrite("Internet Connection is Good!" & @CRLF)

	  CloseTeamviewer()

	  ; Check if BlueStack is crash or Not
	  $GetPlayer = WinGetTitle("HD-Frontend.exe")
	  If Not $GetPlayer = 0 Then
		 Debug("Ho Lee Schiit, HD-Frontend.exe is CRASH!")
		 Beep(1000, 100)
		 Beep(500, 100)
		 Beep(1000, 100)

		 WinClose("HD-Frontend.exe") ; close ita
		 KillProc("HD-Frontend.exe") ; kill the process

		 Sleep(10000)

		 $GetPlayer = WinGetTitle("Error") ; got another popup error message?
		 If Not $GetPlayer = 0 Then
			Debug("Ho Lee Schiit, another crash!!")
			WinClose("Error") ; close it
			ShellExecute("C:\Program Files (x86)\BlueStacks\HD-StartLauncher.exe")
			Sleep(60000) ; just to make sure the player is completely load
		 Else
			ShellExecute("C:\Program Files (x86)\BlueStacks\HD-StartLauncher.exe")
			Sleep(60000) ; just to make sure the player is completely load
		 EndIf

		 LogIn() ; lets play

	  Else ; else if player still ok, keep going
		 if $Pause = 0 Then ; if not pause, then keep going

			; After few minutes, login the game
			if $IsOffline = True Then
			   While $cnt <= $TIME_TO_LOGIN
				  $cnt = $cnt + 1
				  ConsoleWrite("Currently LogOff ... " & $cnt & @CRLF)
				  if GetOffline() >= $TIME_TO_LOGIN Then ; if more than minutes then get online
					 Debug("Offline Time: " & GetOffline())
					 $hTimer = TimerInit()
					 $IsOffline = False
					 $cnt = 0
					 $LogInCount = $LogInCount + 1
					 Debug("Logged In ... [" & $LogInCount & "]")

					 LogIn() ; Lets play

					 Sleep(50000) ; Wait 50 second to fully load the game.

					 ; Collect Resource on Screen 1
					 Debug("#1: Collect All Resources")
					 CollectRes1()

					 ; Collect Resource on Screen 27
					 ;Debug("#2: Collect All Resources")
					 ;CollectRes2()

					 ExitLoop
				  EndIf
				  Sleep(1000)
			   WEnd
			EndIf

			$RoundCnd = $RoundCnd + 1

			Debug("CURRENT TIME BEFORE LOGOFF: " & GetRunningTime() & " Sec.")
			Debug("Cycle Round: " & $RoundCnd)
			Debug("First Screen ...")
			Sleep(8000)

			Debug("#1: Random Mouse Drag ...")
			For $i = 1 To Random(2, 6, 1)
			   MouseClickDrag("left", Random(470, 490, 1), Random(270, 290, 1), Random(910, 930, 1), Random(630, 650, 1))
			   Sleep(100)
			   MouseClickDrag("left", Random(1070, 1090, 1), Random(270, 290, 1), Random(500, 520, 1), Random(610, 630, 1))
			   Sleep(100)
			Next

			; After randomly click, clear the clicked object to other position
			; This to prevent the object from accidently move to other location.
			; Screen 1
			Debug("#1: Clear click focus")
			MouseClickDrag("left", 314, 770, 990, 259)
			Sleep(100)
			MouseClickDrag("left", 314, 770, 990, 259)
			Sleep(100)
			MouseClick("left", 314, 770)
			Sleep(100)

			Local $rNum
			$rNum = Random(2000, 10000, 1)
			Sleep($rNum) ; take a breath bro.
			Debug("Take a breath: " & StringFormat("%d", $rNum)/1000 & " sec.")

			; If more than 1 hour playing the game, lets take a break
			if GetRunningTime() >= $TIME_TO_LOGOFF Then ; 14400 = 4 hours, 3600 = 1 hour
			   Debug("Running Time: " & GetRunningTime())
			   ;$hTimer = TimerInit()
			   $hOfflineTimer = TimerInit()
			   $IsOffline = True
			   $LogOffCount = $LogOffCount + 1
			   Debug("Logging Off ... [" & $LogOffCount & "]")
			   LogOff()
			   Sleep(1000)

			   ; Clear log to save some memory
			   MouseClick("left", 2320, 539)
			   Send("+{F5}")
			EndIf
		 Else
			Debug("Program is PAUSED! Press P to resume.")
		 EndIf
	  EndIf
   Else
	  Debug("WARNING! No Internet Connection.")
	  Sleep(5000)
   EndIf

WEnd

; Get how long this program has been running
Func GetRunningTime()
   Local $fDiff = TimerDiff($hTimer)
   Return StringFormat("%d", $fDiff)/1000
EndFunc

; Get how long this program has been offline
Func GetOffline()
   Local $fDiff = TimerDiff($hOfflineTimer)
   Return StringFormat("%d", $fDiff)/1000
EndFunc

Func OfflineTimer()
   While 1
	  Sleep(1000)
   WEnd
EndFunc

; Lets play
Func LogIn()
   ; Screen 1
   MouseClick("left", 703, 31) ; Click on Window title to focus
   Sleep(100)
   MouseClick("left", 69, 921) ; Back button to make sure screen cleared
   Sleep(100)
   MouseClick("left", 192, 175) ; Run the game
   Sleep(100)

   ; Screen 2
   ;MouseClick("left", 2045, 314) ; Click center of the game screen to focus
   ;Sleep(100)
   ;MouseClick("left", 1454, 615) ; Back button to make sure screen cleared
   ;Sleep(100)
   ;MouseClick("left", 1640, 395) ; Run the game
   ;Sleep(100)
EndFunc

Func LogOff()
   ; Time to logoff
   ; Screen 1
   MouseClick("left", 703, 31) ; Click on Window title to focus
   Sleep(100)
   MouseClick("left", 69, 921) ; Back button to make sure screen cleared
   Sleep(100)
   MouseClick("left", 853, 547) ; click OK to exit the game
   Sleep(100)

   $hTimer = TimerInit()
   ; Screen 2
   ;MouseClick("left", 1579, 302) ; Click center of the game screen to focus
   ;Sleep(100)
   ;MouseClick("left", 1454, 615)
   ;Sleep(100)
   ;MouseClick("left", 1658, 366)
   ;Sleep(100)
   ;MsgBox(0, "PP - Logged Off", "The game has been logged off.", 20)
EndFunc

; Collect all resource at screen 1
Func CollectRes1()
   ;Gold
   MouseClick("left", 874, 157)
   Sleep(500)
   MouseClick("left", 1043, 160)
   Sleep(500)
   MouseClick("left", 959, 225)
   Sleep(500)
   MouseClick("left", 1044, 284)
   Sleep(500)
   MouseClick("left", 1126, 224)
   Sleep(500)
   ;Elixir
   MouseClick("left", 538, 592)
   Sleep(500)
   MouseClick("left", 453, 653)
   Sleep(500)
   MouseClick("left", 540, 712)
   Sleep(500)
   MouseClick("left", 622, 653)
   Sleep(500)
   MouseClick("left", 706, 727)
   Sleep(500)
EndFunc

; Collect all resource at screen 2
Func CollectRes2()
   ; Elixir
   MouseClick("left", 1405, 171)
   Sleep(500)
   MouseClick("left", 1330, 225)
   Sleep(500)
   MouseClick("left", 1405, 287)
   Sleep(500)
   MouseClick("left", 1482, 227)
   Sleep(500)
   MouseClick("left", 1554, 284)
   Sleep(500)
   MouseClick("left", 1574, 464)
   Sleep(500)
   ; Gold
   MouseClick("left", 1853, 173)
   Sleep(500)
   MouseClick("left", 1928, 228)
   Sleep(500)
   MouseClick("left", 1779, 230)
   Sleep(500)
   MouseClick("left", 1854, 284)
   Sleep(500)
   MouseClick("left", 1705, 284)
   Sleep(500)
   MouseClick("left", 1684, 471)
   Sleep(500)
EndFunc

Func CloseTeamviewer()
   Local $hWnd = WinWait("Sponsored session", "", 10)
   WinActivate($hWnd)
   WinClose("Sponsored session", "")
   Send("{ENTER}")
EndFunc

; Check Network and internet connection
Func _GetNetworkConnect()
    Local Const $NETWORK_ALIVE_LAN = 0x1  ;net card connection
    Local Const $NETWORK_ALIVE_WAN = 0x2  ;RAS (internet) connection
    Local Const $NETWORK_ALIVE_AOL = 0x4  ;AOL

    Local $aRet, $iResult

    $aRet = DllCall("sensapi.dll", "int", "IsNetworkAlive", "int*", 0)

    If BitAND($aRet[1], $NETWORK_ALIVE_LAN) Then $iResult &= "LAN connected" & @LF
    If BitAND($aRet[1], $NETWORK_ALIVE_WAN) Then $iResult &= "WAN connected" & @LF
    If BitAND($aRet[1], $NETWORK_ALIVE_AOL) Then $iResult &= "AOL connected" & @LF

    Return $iResult
 EndFunc

; For console debug message
Func Debug($Phrase)
   ConsoleWrite(_NowTime() & ": " & $Phrase & @CRLF)
EndFunc

; Get the hell out of here.
Func Quit()
   Exit
EndFunc

; Terminate process by given name
Func KillProc($sPID)
    If IsString($sPID) Then $sPID = ProcessExists($sPID)
    If Not $sPID Then Return SetError(1, 0, 0)
	ProcessClose($sPID)
EndFunc

; Give a pause
Func Pause()
   If $Pause = 0 Then
	  $Pause = 1
   Else
	  $Pause = 0
   EndIf
EndFunc