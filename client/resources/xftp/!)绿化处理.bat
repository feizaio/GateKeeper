@ECHO OFF&(PUSHD "%~DP0")&(REG QUERY "HKU\S-1-5-19">NUL 2>&1)||(
powershell -Command "Start-Process '%~sdpnx0' -Verb RunAs"&&EXIT)

taskkill /f /im Xftp* >NUL 2>NUL
taskkill /f /im FNPLicensingService* >NUL 2>NUL

::�Ƴ����֤�������
net stop "FlexNet Licensing Service" >NUL 2>NUL
sc delete "FlexNet Licensing Service" >NUL 2>NUL
rd/s/q "%CommonProgramFiles%\Macrovision Shared"2>NUL
rd/s/q "%CommonProgramFiles(x86)%\Macrovision Shared"2>NUL
reg delete "HKCU\Software\Microsoft\NetLicense" /F>NUL 2>NUL
reg delete "HKCU\Software\Microsoft\NetLicense" /F>NUL 2>NUL

regsvr32 /s NsCopyHook3.dll

::�����Ự�ļ���ʽ
reg delete "HKCR\.xfp" /f >NUL 2>NUL
reg delete "HKCR\Xftp.xfp" /f >NUL 2>NUL
reg delete "HKCR\Xtransport.xts" /f >NUL 2>NUL
reg add "HKLM\SOFTWARE\Classes\.xfp" /f /ve /d "Xftp.xfp" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Classes\.xts" /f /ve /d "Xtransport.xts" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Classes\Xftp.xfp\DefaultIcon" /f /ve /d "%~dp0Xftp.exe,0" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Classes\Xftp.xfp\shell\open\command" /f /ve /d "\"%~dp0Xftp.exe\" \"%%1\"" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Classes\Xtransport.xts\shell\open\command" /f /ve /d "\"%~dp0Xtransport.exe\" -f \"%%1\"" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Xftp.exe" /f /ve /d "%~dp0Xftp.exe" >NUL 2>NUL

::ˢ�»Ự��ʽͼ��
assoc .=.file >NUL 2>NUL

IF NOT EXIST "%ProgramW6432%" (
::����������·��
reg add "HKLM\SOFTWARE\NetSarang\Xftp\7" /f /v "Path" /d "%~dp0\" >NUL 2>NUL
::������ʾ�汾�ţ����޸ü�ֵ���ڶԻ�������ʾ�汾�ţ�
reg add "HKLM\SOFTWARE\NetSarang\Xftp\7" /f /v "Version" /d "7.0.0063" >NUL 2>NUL
::��Ҫ��Ʒ�����Ϣ����������������������������ʧ�ܣ�
reg add "HKLM\SOFTWARE\NetSarang\Xftp\7" /f /v "MagicCode" /t REG_BINARY /d "57405f2263e1f58f85ed6cc0d04f9184e50704000600" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SharedDlls" /f /v "%~dp0XftpCore.tlb">NUL 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SharedDlls" /f /v "%~dp0NsCopyHook3.dll" /t REG_DWORD /d "1" >NUL 2>NUL
) ELSE (
reg add "HKLM\SOFTWARE\NetSarang\Xftp\7" /f /v "Path" /d "%~dp0\" /reg:32 >NUL 2>NUL
reg add "HKLM\SOFTWARE\NetSarang\Xftp\7" /f /v "Version" /d "7.0.0063" /reg:32 >NUL 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SharedDlls" /f /v "%~dp0XftpCore.tlb" /reg:32 >NUL 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SharedDlls" /f /v "%~dp0NsCopyHook3.dll" /t REG_DWORD /d "1" /reg:32 >NUL 2>NUL
reg add "HKLM\SOFTWARE\NetSarang\Xftp\7" /f /v "MagicCode" /t REG_BINARY /d "57405f2263e1f58f85ed6cc0d04f9184e50704000600" /reg:32 >NUL 2>NUL
)

::���������ݷ�ʽ
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\Xftp.lnk""):b.TargetPath=""%~sdp0Xftp.exe"":b.WorkingDirectory=""%~sdp0"":b.Save:close")

ECHO.&ECHO ��� &TIMEOUT /t 2 >NUL&EXIT