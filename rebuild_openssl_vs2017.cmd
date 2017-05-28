
set OPENSSL_DIR=d:\openssl
cd %OPENSSL_DIR%
set OPENSSL_VERSION=1.0.2l
set SEVENZIP="C:\Program Files\7-Zip\7z.exe"
set VS2017="%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars32.bat"
set VS2017_AMD64="%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"
set path=%path%;C:\Program Files (x86)\NASM

REM Remove openssl source directories
IF NOT EXIST "%OPENSSL_DIR%\openssl-src-win32" GOTO NO_WIN32_SOURCE
DEL "%OPENSSL_DIR%\openssl-src-win32" /Q /F /S
RMDIR /S /Q "%OPENSSL_DIR%\openssl-src-win32"
:NO_WIN32_SOURCE

IF NOT EXIST "%OPENSSL_DIR%\openssl-src-win64" GOTO NO_WIN64_SOURCE
DEL "%OPENSSL_DIR%\openssl-src-win64" /Q /F /S
RMDIR /S /Q "%OPENSSL_DIR%\openssl-src-win64"
:NO_WIN64_SOURCE

IF NOT EXIST "%OPENSSL_DIR%\openssl-%OPENSSL_VERSION%" GOTO NO_OPENSSL_SOURCE
DEL "%OPENSSL_DIR%\openssl-%OPENSSL_VERSION%" /Q /F /S
RMDIR /S /Q "%OPENSSL_DIR%\openssl-%OPENSSL_VERSION%"
:NO_OPENSSL_SOURCE

del openssl-%OPENSSL_VERSION%.tar
%SEVENZIP% e openssl-%OPENSSL_VERSION%.tar.gz
%SEVENZIP% x -y openssl-%OPENSSL_VERSION%.tar
ren openssl-%OPENSSL_VERSION% openssl-src-win32-VS2017
%SEVENZIP% x -y openssl-%OPENSSL_VERSION%.tar
ren openssl-%OPENSSL_VERSION% openssl-src-win64-VS2017

CALL %VS2017%

cd %OPENSSL_DIR%\openssl-src-win32-VS2017
perl Configure VC-WIN32 --prefix=%OPENSSL_DIR%\openssl-%OPENSSL_VERSION%-32bit-release-DLL-VS2017
call ms\do_ms.bat
call ms\do_nasm.bat
..\replace.py ms\nt.mak /MD /MT
..\replace.py ms\ntdll.mak /MD /MT
nmake -f ms\ntdll.mak
REM cd \
REM python patch_ntdll_mak.py
REM cd \openssl-src-win32-VS2017
REM nmake -f ms\ntdll.mak
nmake -f ms\ntdll.mak install

REM perl Configure debug-VC-WIN32 --prefix=%OPENSSL_DIR%\openssl-%OPENSSL_VERSION%-32bit-debug-DLL-VS2017
REM call ms\do_ms.bat
REM call ms\do_nasm.bat
REM ..\replace.py ms\nt.mak /MD /MT
REM nmake -f ms\ntdll.mak
REM REM cd \
REM REM python patch_ntdll_mak.py
REM REM cd \openssl-src-win32-VS2017
REM REM nmake -f ms\ntdll.mak
REM nmake -f ms\ntdll.mak install

REM perl Configure VC-WIN32 --prefix=%OPENSSL_DIR%\openssl-%OPENSSL_VERSION%-32bit-release-static-VS2017
REM call ms\do_ms.bat
REM call ms\do_nasm.bat
REM ..\replace.py ms\nt.mak /MD /MT
REM nmake -f ms\nt.mak
REM REM cd \
REM REM python patch_ntdll_mak.py
REM REM cd \openssl-src-win32-VS2017
REM REM nmake -f ms\ntdll.mak
REM nmake -f ms\nt.mak install

REM perl Configure debug-VC-WIN32 --prefix=%OPENSSL_DIR%\openssl-%OPENSSL_VERSION%-32bit-debug-static-VS2017
REM call ms\do_ms.bat
REM call ms\do_nasm.bat
REM ..\replace.py ms\nt.mak /MD /MT
REM nmake -f ms\nt.mak
REM REM cd \
REM REM python patch_ntdll_mak.py
REM REM cd \openssl-src-win32-VS2017
REM REM nmake -f ms\ntdll.mak
REM nmake -f ms\nt.mak install

CALL %VS2017_AMD64%

cd %OPENSSL_DIR%\openssl-src-win64-VS2017
perl Configure VC-WIN64A --prefix=%OPENSSL_DIR%\openssl-%OPENSSL_VERSION%-64bit-release-DLL-VS2017
call ms\do_win64a.bat
..\replace.py ms\nt.mak /MD /MT
..\replace.py ms\ntdll.mak /MD /MT
nmake -f ms\ntdll.mak
nmake -f ms\ntdll.mak install

REM perl Configure debug-VC-WIN64A --prefix=%OPENSSL_DIR%\openssl-%OPENSSL_VERSION%-64bit-debug-DLL-VS2017
REM call ms\do_win64a.bat
REM ..\replace.py ms\nt.mak /MD /MT
REM nmake -f ms\ntdll.mak
REM nmake -f ms\ntdll.mak install

REM cd \openssl-src-win64-VS2017
REM perl Configure VC-WIN64A --prefix=%OPENSSL_DIR%\openssl-%OPENSSL_VERSION%-64bit-release-static-VS2017
REM call ms\do_win64a.bat
REM ..\replace.py ms\nt.mak /MD /MT
REM nmake -f ms\nt.mak
REM nmake -f ms\nt.mak install

REM perl Configure debug-VC-WIN64A --prefix=%OPENSSL_DIR%\openssl-%OPENSSL_VERSION%-64bit-debug-static-VS2017
REM call ms\do_win64a.bat
REM ..\replace.py ms\nt.mak /MD /MT
REM nmake -f ms\nt.mak
REM nmake -f ms\nt.mak install

cd %OPENSSL_DIR%\
python copy_openssl_pys.py

%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-32bit-debug-DLL-VS2017.7z openssl-%OPENSSL_VERSION%-32bit-debug-DLL-VS2017\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-32bit-release-DLL-VS2017.7z openssl-%OPENSSL_VERSION%-32bit-release-DLL-VS2017\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-64bit-debug-DLL-VS2017.7z openssl-%OPENSSL_VERSION%-64bit-debug-DLL-VS2017\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-64bit-release-DLL-VS2017.7z openssl-%OPENSSL_VERSION%-64bit-release-DLL-VS2017\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-32bit-debug-static-VS2017.7z openssl-%OPENSSL_VERSION%-32bit-debug-static-VS2017\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-32bit-release-static-VS2017.7z openssl-%OPENSSL_VERSION%-32bit-release-static-VS2017\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-64bit-debug-static-VS2017.7z openssl-%OPENSSL_VERSION%-64bit-debug-static-VS2017\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-64bit-release-static-VS2017.7z openssl-%OPENSSL_VERSION%-64bit-release-static-VS2017\*

DEL openssl-%OPENSSL_VERSION%-32bit-debug-DLL-VS2017 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-32bit-release-DLL-VS2017 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-64bit-debug-DLL-VS2017 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-64bit-release-DLL-VS2017 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-32bit-debug-static-VS2017 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-32bit-release-static-VS2017 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-64bit-debug-static-VS2017 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-64bit-release-static-VS2017 /Q /F /S

RMDIR /S /Q openssl-%OPENSSL_VERSION%-32bit-debug-DLL-VS2017
RMDIR /S /Q openssl-%OPENSSL_VERSION%-32bit-release-DLL-VS2017
RMDIR /S /Q openssl-%OPENSSL_VERSION%-64bit-debug-DLL-VS2017
RMDIR /S /Q openssl-%OPENSSL_VERSION%-64bit-release-DLL-VS2017
RMDIR /S /Q openssl-%OPENSSL_VERSION%-32bit-debug-static-VS2017
RMDIR /S /Q openssl-%OPENSSL_VERSION%-32bit-release-static-VS2017
RMDIR /S /Q openssl-%OPENSSL_VERSION%-64bit-debug-static-VS2017
RMDIR /S /Q openssl-%OPENSSL_VERSION%-64bit-release-static-VS2017

