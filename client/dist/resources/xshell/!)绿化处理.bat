@ECHO OFF&(PUSHD "%~DP0")&(REG QUERY "HKU\S-1-5-19">NUL 2>&1)||(
powershell -Command "Start-Process '%~sdpnx0' -Verb RunAs"&&EXIT)

taskkill /f /im Xshell* >NUL 2>NUL
taskkill /f /im FNPLicensingService* >NUL 2>NUL

::ɾ���֤�������
net stop "FlexNet Licensing Service" >NUL 2>NUL
sc delete "FlexNet Licensing Service" >NUL 2>NUL
rd/s/q "%CommonProgramFiles%\Macrovision Shared"2>NUL
rd/s/q "%CommonProgramFiles(x86)%\Macrovision Shared"2>NUL
reg delete "HKCU\Software\Microsoft\NetLicense" /F>NUL 2>NUL
reg delete "HKCU\Software\Microsoft\NetLicense" /F>NUL 2>NUL

::�����Ự�ļ���ʽ
reg delete "HKCR\.xsh" /f >NUL 2>NUL
reg delete "HKCR\.xts" /f >NUL 2>NUL
reg delete "HKCR\Xshell.xsh" /f >NUL 2>NUL
reg delete "HKCR\Xtransport.xts" /f >NUL 2>NUL
reg add "HKLM\SOFTWARE\Classes\.xsh" /f /ve /d "Xshell.xsh" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Classes\.xts" /f /ve /d "Xtransport.xts" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Classes\Xshell.xsh" /f /ve /d "Xshell session" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Classes\Xshell.xsh\DefaultIcon" /f /ve /d "%~dp0Xshell.exe,0" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Classes\Xshell.xsh\shell\open\command" /f /ve /d "\"%~dp0Xshell.exe\" \"%%1\"" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Classes\Xtransport.xts\shell\open" /f /ve /d "" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Classes\Xtransport.xts\shell\open\command" /f /ve /d "\"%~dp0Xtransport.exe\" -f \"%%1\"" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Xagent.exe" /f /ve /d "%~dp0Xagent.exe" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Xshell.exe" /f /ve /d "%~dp0Xshell.exe" >NUL 2>NUL
::ˢ�»Ự��ʽͼ��
ASSOC .=. >NUL 2>NUL

IF NOT EXIST "%ProgramW6432%" (
::����������·��
reg add "HKLM\SOFTWARE\NetSarang\Xshell\7" /f /v "Path" /d "%~dp0\" >NUL 2>NUL
::������ʾ�汾�ţ����޸ü�ֵ���ڶԻ�������ʾ�汾�ţ�
reg add "HKLM\SOFTWARE\NetSarang\Xshell\7" /f /v "Version" /d "7.0.0164" >NUL 2>NUL
::��Ҫ��Ʒ�����Ϣ����������������������������ʧ�ܣ�
reg add "HKLM\SOFTWARE\NetSarang\Xshell\7" /f /v "MagicCode" /t REG_BINARY /d "7f740cdc7d5fa37bea575ad92d78de73e60704000c00" >NUL 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SharedDlls" /f /v "%~dp0XshellCore.tlb">NUL 2>NUL
) ELSE (
reg add "HKLM\SOFTWARE\NetSarang\Xshell\7" /f /v "Path" /d "%~dp0\" /reg:32 >NUL 2>NUL
reg add "HKLM\SOFTWARE\NetSarang\Xshell\7" /f /v "Version" /d "7.0.0164" /reg:32 >NUL 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SharedDlls" /f /v "%~dp0XshellCore.tlb" /reg:32 >NUL 2>NUL
reg add "HKLM\SOFTWARE\NetSarang\Xshell\7" /f /v "MagicCode" /t REG_BINARY /d "7f740cdc7d5fa37bea575ad92d78de73e60704000c00" /reg:32 >NUL 2>NUL
)

::���������ݷ�ʽ
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\Xshell.lnk""):b.TargetPath=""%~sdp0Xshell.exe"":b.WorkingDirectory=""%~sdp0\"":b.Save:close")

ECHO.&ECHO ��� &TIMEOUT /t 2 >NUL&EXIT