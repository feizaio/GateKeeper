Set WshShell = WScript.CreateObject("WScript.Shell")
Do While True
   If WshShell.AppActivate("License Service") Then
      WshShell.SendKeys "%{F4}"  ' 
   End If
   WScript.Sleep 5000
Loop