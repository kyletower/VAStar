@ECHO off


REM Created by Kyle Tower

REM 08.08.2018


REM Reference #1: https://docs.microsoft.com/en-us/dotnet/framework/tools/certmgr-exe-certificate-manager-tool

REM Reference #2: https://stackoverflow.com/questions/23869177/import-certificate-to-trusted-root-but-not-to-personal-command-line


REM Automatically Install Certificates


ECHO Navigating to downloads
cd %userprofile%\downloads\VAStar-master\VAStar-master

ECHO Adding proxy-1.der

CertUtil -AddStore "Root" proxy-1.der
ECHO.



ECHO Adding proxy-2.der

CertUtil -AddStore "Root" proxy-2.der

ECHO.



ECHO Adding proxy-3.der

CertUtil -AddStore "Root" proxy-3.der

ECHO.



ECHO Adding proxy-4.der

CertUtil -AddStore "Root" proxy-4.der

ECHO.

ECHO Adding proxy-5.der

CertUtil -AddStore "Root" proxy-5.der

ECHO.

ECHO Adding proxy-6.der

CertUtil -AddStore "Root" proxy-6.der

ECHO.

ECHO.

ECHO.


REM Verify Certificates

CertMgr.msc
REM Manage Computer Certificates > Trusted Root Certification Authorities > Certificates 

REM Prompt for restart

ECHO You must restart your computer for this to take effect.


PAUSE
