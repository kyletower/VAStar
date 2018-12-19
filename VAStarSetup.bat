@ECHO off
title %computername%
ECHO Created by Kyle Tower.

REM Get Serial Number for use with Loading Dell.com/Drivers/SerialTag
FOR /F "tokens=2 delims='='" %%A in ('wmic Bios Get SerialNumber /value') do SET serialnumber=%%A
ECHO Serial Number is %serialnumber%

REM Run Multiple PS Commands
REM powershell -command "& {&'some-command' someParam}"; "& {&'some-command' -SpecificArg someParam}"

:Prep_PowerShell
PowerShell -command "Set-ExecutionPolicy Unrestricted -Scope CurrentUser"; 
GOTO End_Routine

REM ------------
REM --- MAIN ---
REM ------------
GOTO Menu

REM Display Menu
:Menu
ECHO.
ECHO   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ECHO   @@                                                                      @@
ECHO   @@                        FOR Virginia Star ONLY                        @@ 
ECHO   @@                 MUST RUN AS ADMINISTRATOR (ELEVATED)                 @@
ECHO   @@                                                                      @@
ECHO   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ECHO.
ECHO   0.  Get PC Info
ECHO   1.  Rename PC
ECHO   2.  Uninstall Unnecessary Pre-Installed Software and Apps
ECHO   3.  Add HCPS Proxy Certificates
ECHO   4.  Install Chocolatey with Chrome, Firefox, Adobe, etc
ECHO   5.  Configure Chrome for Adblock Plus
ECHO   6.  Configure Firefox for Adblock Plus and Flash
ECHO   7.  Get Dell Drivers
ECHO   8.  Install Dell Driver's via .cab file
ECHO   9.  Device Manager: Ensure All Devices Have Drivers
ECHO  10.  Windows Updates
ECHO.
ECHO  11.  Full Scan of HDD chkdsk c: /r
ECHO  12.  dism /online /cleanup-image /restorehealth
ECHO  13.  sfc /scannow
ECHO  14.  Empty ALL Recycle Bins rd /s c:\$Recycle.Bin
ECHO  15.  Defrag (Only for HDDs, not SSDs)
ECHO  16.  defrag c: /b (Boot Defrag, only for HDDs, not SSDs)
ECHO   x. Exit
ECHO.
SET /P number=Choice: 

IF %number%==0 GOTO Get_PC_Info
IF %number%==1 GOTO Rename_PC
IF %number%==2 GOTO Uninstall_Software
IF %number%==3 GOTO Add_HCPS_Proxy
IF %number%==4 GOTO Install_Chocolatey
IF %number%==5 GOTO Configure_Chrome
IF %number%==6 GOTO Configure_Firefox
IF %number%==7 GOTO Get_Dell_Drivers
IF %number%==8 GOTO Install_Dell_Cab
IF %number%==9 GOTO Device_Manager
IF %number%==10 GOTO Windows_Updates 
IF %number%==x EXIT /B 0

:End_Routine
REM 
rundll32 user32.dll,MessageBeep
REM rundll32.exe cmdext.dll,MessageBeepStub
PAUSE
GOTO Menu


:Add_HCPS_Proxy
start cmd.exe /K "%userprofile%\downloads\VAStar-master\VAStar-master\Install_HCPS_Certificates.bat"
GOTO End_Routine


:Install_Chocolatey
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco install -y adobereader
choco install -y flashplayerplugin
choco install -y googlechrome-allusers
REM choco install -y googlechrome
choco install -y jre8
choco install -y flashplayeractivex
choco install -y firefox
choco install -y vlc
choco install -y ccleaner
choco install -y adblockplusie
choco install -y adblockpluschrome
choco install -y adblockplusfirefox
choco install -y teamviewer
choco install -y youtube-dl
choco install -y ffmpeg
choco install -y windirstat
choco install -y dotnet4.0
choco install -y audacity
choco install -y audacity-lame
choco install -y rufus

choco install -y notepadplusplus.install
choco install -y atom
choco install -y python3
choco install -y vscode
choco install -y vscode-csharp
choco install -y unity
choco install -y unitywebplayer

REM choco install pstools
REM choco install psexec
REM choco install teracopy
REM choco install sudo
REM choco install zotero-standalone
REM choco install nsis
REM choco install googlechrome-allusers
REM choco install handbrake.install
REM choco install kodi
REM choco install autoit
REM choco install discord
REM choco install makemkv
GOTO End_Routine


:Install_Dell_Cab
ECHO With the introduction of Windows Vista, Windows will not prompt the "Found New Hardware" Wizard 
ECHO any longer and the installation occurs silently. The end user will only see Windows UA prompts 
ECHO for unsigned driver. Total runtime ~ 10 - 15 minutes depending on number of driver in the CAB file.
cd /
md Drivers
expand "%userprofile%\downloads\*.CAB" c:\Drivers -f:*
cd Drivers
for /f "tokens=*" %a in ('dir *.inf /b /s') do (pnputil –i -a "%a\..\*.inf")
GOTO End_Routine


:Get_Dell_Drivers
REM This will launch the dell website for the drivers for the detected model based on its serial number
REM I was hoping for a simpler URL and there may be one such as: dell.com/drivers/SerialTag ???
start chrome http://www.dell.com/support/home/us/en/19/product-support/servicetag/%serialnumber%/drivers http://en.community.dell.com/techcenter/enterprise-client/w/wiki/2065.dell-command-deploy-driver-packs-for-enterprise-client-os-deployment
GOTO End_Routine


:Get_PC_Info
REM SOURCE: https://community.spiceworks.com/canonical_answer_pages/555-need-to-run-a-batch-file-on-multiple-servers
winver.exe
if %os%==Windows_NT goto WINNT
goto NOCON

:WINNT
echo .Using a Windows NT based system
echo ..%computername%

REM set variables
set system=
set manufacturer=
set model=
set serialnumber=
set osname=
set sp=
setlocal ENABLEDELAYEDEXPANSION
set "volume=C:"
set totalMem=
set availableMem=
set usedMem=
set IPv4=
set Domain=

echo Getting data [Computer: %computername%]...
echo Please Wait....

REM Get Computer Name
FOR /F "tokens=2 delims='='" %%A in ('wmic OS Get csname /value') do SET system=%%A

REM Get Computer Manufacturer
FOR /F "tokens=2 delims='='" %%A in ('wmic ComputerSystem Get Manufacturer /value') do SET manufacturer=%%A

REM Get Computer Model
FOR /F "tokens=2 delims='='" %%A in ('wmic ComputerSystem Get Model /value') do SET model=%%A

REM Get Computer Serial Number
FOR /F "tokens=2 delims='='" %%A in ('wmic Bios Get SerialNumber /value') do SET serialnumber=%%A

REM Get Computer OS
FOR /F "tokens=2 delims='='" %%A in ('wmic os get Name /value') do SET osname=%%A
FOR /F "tokens=1 delims='|'" %%A in ("%osname%") do SET osname=%%A

REM Get Computer OS SP
FOR /F "tokens=2 delims='='" %%A in ('wmic os get ServicePackMajorVersion /value') do SET sp=%%A

REM Get Memory
FOR /F "tokens=4" %%a in ('systeminfo ^| findstr Physical') do if defined totalMem (set availableMem=%%a) else (set totalMem=%%a)
set totalMem=%totalMem:,=%
set availableMem=%availableMem:,=%
set /a usedMem=totalMem-availableMem

FOR /f "tokens=1*delims=:" %%i IN ('fsutil volume diskfree %volume%') DO (
    SET "diskfree=!disktotal!"
    SET "disktotal=!diskavail!"
    SET "diskavail=%%j"
)
FOR /f "tokens=1,2" %%i IN ("%disktotal% %diskavail%") DO SET "disktotal=%%i"& SET "diskavail=%%j"

echo done!

echo --------------------------------------------
echo System Name: %system%
echo Manufacturer: %manufacturer%
echo Model: %model%
echo Serial Number: %serialnumber%
echo Operating System: %osname%
echo C:\ Total: %disktotal:~0,-9% GB
echo C:\ Avail: %diskavail:~0,-9% GB
echo Total Memory: %totalMem%
echo Used  Memory: %usedMem%
echo Computer Processor: %processor_architecture%
echo Service Pack: %sp%
echo --------------------------------------------
GOTO End_Routine

:NOCON
echo Error...Invalid Operating System...
echo Error...No actions were made...
GOTO End_Routine


:Device_Manager
REM Ensure that all drivers are up to date in the device manager.
devmgmt.msc
GOTO End_Routine


:Restart_Windows
shutdown -r -t 0
GOTO End_Routine


:Rename_PC
SET old_name=%computername%
REM alternatively SET old_name=%hostname%
SET /P new_name=Type New Computer Name:
WMIC computersystem where caption='%old_name%' rename %new_name%
GOTO End_Routine


REM Uninstall pre-installed software, MS Office, McAfee, Dell Digital, Get Office, OneDrive, Netflix, News, Sketchbook, Skype Preview, Spotify
REM appwiz.cpl
:Uninstall_Software
@rem NOW JUST SOME TWEAKS
REM *** Show hidden files in Explorer ***
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f
 
REM *** Show super hidden system files in Explorer ***
REM reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 1 /f

REM *** Show file extensions in Explorer ***
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t  REG_DWORD /d 0 /f

REM *** Uninstall OneDrive ***
start /wait "" "%SYSTEMROOT%\SYSWOW64\ONEDRIVESETUP.EXE" /UNINSTALL
rd C:\OneDriveTemp /Q /S >NUL 2>&1
rd "%USERPROFILE%\OneDrive" /Q /S >NUL 2>&1
rd "%LOCALAPPDATA%\Microsoft\OneDrive" /Q /S >NUL 2>&1
rd "%PROGRAMDATA%\Microsoft OneDrive" /Q /S >NUL 2>&1
reg add "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /f /v Attributes /t REG_DWORD /d 0 >NUL 2>&1
reg add "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /f /v Attributes /t REG_DWORD /d 0 >NUL 2>&1
echo OneDrive has been removed. Windows Explorer needs to be restarted.
start /wait TASKKILL /F /IM explorer.exe
start explorer.exe

REM source: https://www.hwinfo.com/misc/RemoveW10Bloat.bat.txt
REM source: https://www.hwinfo.com/misc/RemoveW10Bloat.htm

REM msiexec.exe /X {uninstall string} /qn
REM to find uninstall string: https://archive.codeplex.com/?p=finduninstallstring

REM if you know the product name use the following
REM source: https://www.sevenforums.com/tutorials/272460-programs-uninstall-using-command-prompt-windows.html
REM wmic product where name="Adobe Acrobat Reader DC" call uninstall
REM wmic product where name="Adobe Acrobat Reader DC" call uninstall /nointeractive

REM VERY DETAILED https://www.tenforums.com/tutorials/4689-uninstall-apps-windows-10-a.html

REM List all Programs/Apps that have an Uninstaller
REM wmic product get name
REM (To be prompted Y/N to approve. Recommended)
REM wmic product where name="NameOfProgram" call uninstall

REM Remove all apps except store from new accounts created afterwards
REM Get-appxprovisionedpackage -online | where-object {$_.packagename -notlike '*store*'} | Remove-AppxProvisionedPackage -online

REM  4. To Remove All Apps except Store from New Accounts Created Afterwards
REM PowerShell -Command "Get-appxprovisionedpackage –online | where-object {$_.packagename –notlike '*store*'} | Remove-AppxProvisionedPackage -online"

REM  5. To Remove All Apps except Store from All Current Accounts on PC
REM PowerShell -Command "Get-AppxPackage -AllUsers | where-object {$_.name –notlike “*store*”} | Remove-AppxPackage"

@rem *** Disable Some Service ***
sc stop DiagTrack
sc stop diagnosticshub.standardcollector.service
sc stop dmwappushservice
sc stop WMPNetworkSvc
sc stop WSearch

sc config DiagTrack start= disabled
sc config diagnosticshub.standardcollector.service start= disabled
sc config dmwappushservice start= disabled
REM sc config RemoteRegistry start= disabled
REM sc config TrkWks start= disabled
sc config WMPNetworkSvc start= disabled
sc config WSearch start= disabled
REM sc config SysMain start= disabled

REM *** SCHEDULED TASKS tweaks ***
REM schtasks /Change /TN "Microsoft\Windows\AppID\SmartScreenSpecific" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
schtasks /Change /TN "Microsoft\Office\Office 15 Subscription Heartbeat" /Disable

@rem *** Remove Telemetry & Data Collection ***
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v PreventDeviceMetadataFromNetwork /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v DontOfferThroughWUAU /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v "Start" /t REG_DWORD /d 0 /f

@REM Settings -> Privacy -> General -> Let apps use my advertising ID...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f

REM - SmartScreen Filter for Store Apps: Disable
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v EnableWebContentEvaluation /t REG_DWORD /d 0 /f

REM - Let websites provide locally...
reg add "HKCU\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f

@REM WiFi Sense: HotSpot Sharing: Disable
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v value /t REG_DWORD /d 0 /f

@REM WiFi Sense: Shared HotSpot Auto-Connect: Disable
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v value /t REG_DWORD /d 0 /f

@REM Change Windows Updates to "Notify to schedule restart"
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v UxOption /t REG_DWORD /d 1 /f

@REM Disable P2P Update downlods outside of local network
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f

@REM *** Disable Cortana & Telemetry ***
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0

REM *** Hide the search box from taskbar. You can still search by pressing the Win key and start typing what you're looking for ***
REM 0 = hide completely, 1 = show only icon, 2 = show long search box
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f

REM *** Disable MRU lists (jump lists) of XAML apps in Start Menu ***
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d 0 /f

REM *** Set Windows Explorer to start on This PC instead of Quick Access ***
REM 1 = This PC, 2 = Quick access
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f

REM *** Disable Suggestions in the Start Menu ***
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f 

@rem Remove Apps
REM To remove all apps except store from current user

REM ECHO removing all apps except store from current user...
REM PowerShell -Command "Get-AppXPackage | where-object {$_.name -notlike "*store*"} | Remove-AppxPackage"

REM TESTED AND WORKS
REM SOURCE: https://www.tenforums.com/software-apps/97113-updating-bat-file-removing-default-apps-2.html
REM PowerShell -Command "Get-appxpackage | where-object {$_.name -notlike '*store*'} | remove-appxpackage"
REM PowerShell -Command "Get-appxprovisionedpackage -online | where-object {$_.packagename -notlike '*store*'} | remove-appxprovisionedpackage -online"

REM OTHER Apps
ECHO Removing AdobePhotoshopExpress
PowerShell -Command "Get-AppxPackage -AllUsers *AdobeSystemsIncorporated.AdobePhotoshopExpress* | Remove-AppxPackage"
PowerShell -Command "Get-AppxProvisionedPackage -online | where-object {$_.packagename -like '*AdobeSystemsIncorporated.AdobePhotoshopExpress*'} | Remove-AppxProvisionedPackage -online"

ECHO Removing candyCrushSodaSaga
PowerShell -Command "Get-AppxPackage -AllUsers *king.com.CandyCrushSodaSaga* | Remove-AppxPackage"
PowerShell -Command "Get-AppxProvisionedPackage -online | where-object {$_.packagename -like '*king.com.CandyCrushSodaSaga*'} | Remove-AppxProvisionedPackage -online"

ECHO Removing Minecraft
PowerShell -Command "Get-AppxPackage -AllUsers *MineCraftUWP* | Remove-AppxPackage"
PowerShell -Command "Get-AppxProvisionedPackage -online | where-object {$_.packagename -like '*MinecraftUWP*'} | Remove-AppxProvisionedPackage -online"

ECHO Removing Twitter
PowerShell -Command "Get-AppxPackage -AllUsers *Twitter* | Remove-AppxPackage"
PowerShell -Command "Get-AppxProvisionedPackage -online | where-object {$_.packagename -like '*Twitter*'} | Remove-AppxProvisionedPackage -online"

ECHO Removing PicsArt
PowerShell -Command "Get-AppxPackage -AllUsers *PicsArt* | Remove-AppxPackage"
PowerShell -Command "Get-AppxProvisionedPackage -online | where-object {$_.packagename -like '*PicsArt*'} | Remove-AppxProvisionedPackage -online"

ECHO Removing Flipboard
PowerShell -Command "Get-AppxPackage -AllUsers *Flipboard* | Remove-AppxPackage"
PowerShell -Command "Get-AppxProvisionedPackage -online | where-object {$_.packagename -like '*Flipboard*'} | Remove-AppxProvisionedPackage -online"

ECHO Removing 3DBuilder
PowerShell -Command "Get-AppxPackage *3DBuilder* | Remove-AppxPackage"
PowerShell -Command "Get-AppxProvisionedPackage -online | where-object {$_.packagename -like '*3DBuilder*'} | Remove-AppxProvisionedPackage -online"

ECHO Removing Bing
PowerShell -Command "Get-AppxPackage *bing* | Remove-AppxPackage"
PowerShell -Command "Get-AppxProvisionedPackage -online | where-object {$_.packagename -like '*bing*'} | Remove-AppxProvisionedPackage -online"

ECHO Removing MicrosoftOfficeHub
PowerShell -Command "Get-AppxPackage *MicrosoftOfficeHub* | Remove-AppxPackage"
PowerShell -Command "Get-AppxProvisionedPackage -online | where-object {$_.packagename -like '*MicrosoftOfficeHub*'} | Remove-AppxProvisionedPackage -online"

ECHO Removing SkypeApp
PowerShell -Command "Get-AppxPackage *Skype* | Remove-AppxPackage"
PowerShell -Command "Get-AppxProvisionedPackage -online | where-object {$_.packagename -like '*SkypeApp*'} | Remove-AppxProvisionedPackage -online"

ECHO Removing Solitaire
PowerShell -Command "Get-AppxPackage *solit* | Remove-AppxPackage"
PowerShell -Command "Get-AppxProvisionedPackage -online | where-object {$_.packagename -like '*solit*'} | Remove-AppxProvisionedPackage -online"

ECHO Removing Netflix
PowerShell -Command "Get-appxpackage -allusers *Netflix* | Remove-AppxPackage"
PowerShell -Command "Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*Netflix*'} | remove-appxprovisionedpackage -online"

ECHO Removing Bubble Witch
PowerShell -Command "Get-appxpackage -allusers *Witch* | Remove-AppxPackage"
PowerShell -Command "Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*Witch*'} | remove-appxprovisionedpackage -online"

ECHO Removing SketchBook
PowerShell -Command "Get-appxpackage -allusers *SketchBook* | Remove-AppxPackage"
PowerShell -Command "Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*SketchBook*'} | remove-appxprovisionedpackage -online"

ECHO Removing Bamboo
PowerShell -Command "Get-appxpackage -allusers *Bamboo* | Remove-AppxPackage"
PowerShell -Command "Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*Bamboo*'} | remove-appxprovisionedpackage -online"

ECHO Removing OneNote
PowerShell -Command "Get-AppxPackage -AllUsers *OneNote* | Remove-AppxPackage"
PowerShell -Command "Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*OneNote*'} | remove-appxprovisionedpackage -online"

ECHO Removing XBOX
REM PowerShell -Command "Get-AppxPackage -AllUsers *xbox* | Remove-AppxPackage"
PowerShell -Command "Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*xbox*'} | remove-appxprovisionedpackage -online"

ECHO Removing Drawboard PDF
PowerShell -Command "Get-AppxPackage -AllUsers *Drawboard* | Remove-AppxPackage"
PowerShell -Command "Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*Drawboard*'} | remove-appxprovisionedpackage -online"

ECHO Removing Autodesk
PowerShell -Command "Get-AppxPackage -AllUsers *Autodesk* | Remove-AppxPackage"
PowerShell -Command "Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*Autodesk*'} | remove-appxprovisionedpackage -online"

ECHO Removing Microsoft News
PowerShell -Command "Get-AppxPackage -AllUsers *News* | Remove-AppxPackage"
PowerShell -Command "Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*News*'} | remove-appxprovisionedpackage -online"

ECHO Removing Disney Magic Kingdoms
PowerShell -Command "Get-AppxPackage -AllUsers *Disney* | Remove-AppxPackage"
PowerShell -Command "Get-appxprovisionedpackage -online | where-object {$_.packagename -like '*Disney*'} | remove-appxprovisionedpackage -online"

REM wmic product get name
ECHO This will attempt to remove additional unnecessary software.
ECHO You may see the message No Instance(s) Available. 
ECHO This will take about 5 to 10 minutes depending on the speed of the PC.

REM Dell Digital Delivery
wmic product where name="Dell Digital Delivery" call uninstall /nointeractive

REM Dell Mobile Connect Drivers
wmic product where name="Dell Mobile Connect Drivers" call uninstall /nointeractive

REM Dell SupportAssist ... not found?
wmic product where name="Dell SupportAssist" call uninstall /nointeractive

REM Dell SupportAssist Remediation
wmic product where name="Dell SupportAssist Remediation" call uninstall /nointeractive

REM Dell SupportAssistAgent
wmic product where name="Dell SupportAssistAgent" call uninstall /nointeractive

REM Dell Update
wmic product where name="Dell Update" call uninstall /nointeractive

REM Dell Update - SupportAssist Update Plugin
wmic product where name="Dell Update - SupportAssist Update Plugin" call uninstall /nointeractive

REM OTHER
wmic product where name="Dell Customer Connect" call uninstall /nointeractive
wmic product where name="Dell Foundation Services" call uninstall /nointeractive
wmic product where name="Dell Help & Support" call uninstall /nointeractive
wmic product where name="Dell Product Registration" call uninstall /nointeractive
wmic product where name="Dropbox 20 GB" call uninstall /nointeractive
wmic product where name="*PROSet/Wireless*" call uninstall /nointeractive
wmic product where name="McAfee LiveSafe" call uninstall /nointeractive

REM Error with spacing?
REM wmic product where name="*Office Home*" call uninstall /nointeractive

REM McAfee Security ... not found?
wmic product where name="McAfee Security" call uninstall /nointeractive
REM The "Uninstall" entry in the registry doesn't have a PowerShell/MSI-friendly GUID. It is, instead, 
"C:\Program Files\McAfee\MSC\mcuihost.exe /body:misp://MSCJsRes.dll::uninstall.html /id:uninstall"

ECHO Launching Add/Remove Programs...
appwiz.cpl

REM https://stackoverflow.com/questions/20861432/batch-file-to-uninstall-a-program
GOTO End_Routine


REM Config Firefox, install adblock plus and english filter subs
:Configure_Firefox
ECHO Launching Firefox
start firefox.exe "https://eyeo.to/adblockplus/firefox_install" "https://get.adobe.com/flashplayer/download/?installer=FP_30_for_Firefox_-_NPAPI&os=Windows%2010&browser_type=Gecko&browser_dist=Firefox&dualoffer=false&mdualoffer=true&stype=7612&d=McAfee_Security_Scan_Plus&d=McAfee_Safe_Connect"
GOTO End_Routine
 

REM remove pre-loaded toolbars (Google, Ask, etc)


REM Config Google Chrome
:Configure_Chrome
PowerShell -command "Install-Package -name AdblockPlusChrome -force -verbose" 

ECHO Launching Chrome
start chrome.exe "https://chrome.google.com/webstore/detail/cfhdojbkjhnklbpkdaibdccddilifddb"
REM start ms-settings:defaultapps
GOTO End_Routine

:Windows_Updates
wuauclt.exe /detectnow /updatenow
start ms-settings:windowsupdate
GOTO End_Routine
