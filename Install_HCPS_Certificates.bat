@title Install HCPS Certificates
@echo off
echo Created by Kyle Tower
echo Updated: 05.15.2019
rem Reference #1: https://docs.microsoft.com/en-us/dotnet/framework/tools/certmgr-exe-certificate-manager-tool
rem Reference #2: https://stackoverflow.com/questions/23869177/import-certificate-to-trusted-root-but-not-to-personal-command-line

rem Automatically Install Certificates
::This will install 6 proxy certificates for Hanover County Public Schools on a Windows 7, 8, or 10 machine.
::Install_HCPS_Certificates.bat, v1, 05.15.2019, Kyle Tower, ktower@hcps.us
::The certificates are available for download at hcps.us/certificates

echo Navigating to %userprofile%\downloads\VAStar-master\VAStar-master
cd %userprofile%\downloads\VAStar-master\VAStar-master

echo Adding proxy-1.der
CertUtil -AddStore "Root" proxy-1.der
echo.

echo Adding proxy-2.der
CertUtil -AddStore "Root" proxy-2.der
echo.

echo Adding proxy-3.der
CertUtil -AddStore "Root" proxy-3.der
echo.

echo Adding proxy-4.der
CertUtil -AddStore "Root" proxy-4.der
echo.

echo Adding proxy-5.der
CertUtil -AddStore "Root" proxy-5.der
echo.

echo Adding proxy-6.der
CertUtil -AddStore "Root" proxy-6.der
echo.
echo.
echo.

echo Opening Certificate Manager so you can Verify Certificates are installed to Trusted Root
CertMgr.msc

rem Manage Computer Certificates > Trusted Root Certification Authorities > Certificates 
rem Prompt for restart

echo You may need to restart your Internet Browser or computer for this to take effect.
pause