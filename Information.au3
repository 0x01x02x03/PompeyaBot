#include <String.au3>
#include <Inet.au3>

Func GetRAM()
   Return RegRead("HKLM\HARDWARE\RESOURCEMAP\System Resources\Physical Memory", ".Translated")
EndFunc

Func GetHWID()
   $Ret = ""
   $objWMIService = ObjGet("winmgmts:\\.\root\CIMV2")
   $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Processor")
   For $objItem In $colItems
	  $Ret &= $objItem.ProcessorId
   Next
   If StringLen($Ret) = 0 Then $Ret = "Unknown"
   Return $Ret
EndFunc

Func GetUsername()
   Return EnvGet("USERNAME")
EndFunc

Func GetPcName()
   Return EnvGet("COMPUTERNAME")
EndFunc

Func GetOs()
   $Ret = ""
   $objWMIService = ObjGet("winmgmts:\\.\root\CIMV2")
   $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_OperatingSystem")
   For $objItem In $colItems
	  $Ret &= $objItem.Caption
   Next
   If StringLen($Ret) = 0 Then $Ret = "Unknown"
   Return $Ret
EndFunc

Func GetCountry()
   Return RegRead("HKEY_CURRENT_USER\Control Panel\International", "sCountry")
EndFunc

Func _GetGPU()
   If @OSArch = "X64" then
	  $REG = "HKLM64"
   ElseIf @OSArch = "X86" then
	  $REG = "HKLM"
   EndIf
   Return RegRead($REG & "\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winsat", "PrimaryAdapterString")
EndFunc

Func GetCountryFlag()
   $sCountry = RegRead("HKEY_CURRENT_USER\Control Panel\International", "LocaleName")
   $sSplit = StringSplit($sCountry, "-")
   Return $sSplit[1]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetIP_Country
; Description ...: Retrieve details about the country of origin for an IP address.
; Syntax ........: _GetIP_Country()
; Parameters ....: Success - An array contain details:
;                  $aArray[0] - IP address
;                  $aArray[1] - ISP
;                  $aArray[2] - Region
;                  $aArray[3] - Country code
;                  Failuer - Returns 0 and sets @error to non-zero.
; Return values .: None
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func _GetIP_Country()
    Local $aSRE = StringRegExp(BinaryToString(InetRead('http://xml.utrace.de/?query=' & _GetIP())), _
            '<ip>([\d.]{7,15})</ip>\n' & _
            '<host>[^>]*</host>\n' & _
            '<isp>([^>]+)</isp>\n' & _
            '<org>[^>]+</org>\n' & _
            '<region>([^>]+)</region>\n' & _
            '<countrycode>([^>]+)</countrycode>\n', 3)
    If @error Then Return SetError(@error, 0, 0)
    Return $aSRE
EndFunc   ;==>_GetIP_Country