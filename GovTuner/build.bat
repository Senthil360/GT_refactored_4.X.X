@Echo Off
SetLocal EnableDelayedExpansion
:: Gov-Tuner ZIP creation script
:: Written by F4, with the help of Gov-Tuner Team
:: zip, bzip2, and sed binary provided by GnuWin/gnuwin32 at http://gnuwin32.sourceforge.net
::
:: dos2unix binary provided by the people at https://sourceforge.net/projects/dos2unix/

:: This script should build a zip archive containing all the files excluding the ".git" folder.
:: The needed binaries is provided in the "win" folder, this folder will also be excluded out when compiling the zip.
::
:: Usage:
:: build <VERSION> <TYPE>
::
:: Build types:
:: build: Build a regular flashable zip
:: magisk : Build a Magisk-compatible zip
:: install : Build a regular zip then install
:: magisk-install : Build a Magisk-compatible zip then install
::
:: Example:
:: build 4.0.1 build

set version=%1
set build=%2
set home_dir=%cd%
set prev_dir=%cd%
set zip_exec=%home_dir%\win\zip.exe
set sed_exec=%home_dir%\win\sed.exe
set d2u_exec=%home_dir%\win\d2u.exe

if !version! EQU "" (
	echo No version number supplied, exiting.
	exit
)

if !build! EQU "" (
	:: Don't do anything.
	echo No build type supplied, exiting.
	exit
)

if not exist "output" (
	mkdir output
)

if not exist "output\temp-magisk" (
	mkdir output\temp-magisk
	mkdir output\temp-magisk\system
)

echo:
echo Building Gov-Tuner v%version%
echo -----------------------------

if !build! EQU build (
	:: Build and copy uninstaller before doing anything
	echo Building Uninstaller
	cd uninstaller
	..\%zip_home_dir%\%zip_exec% -r Uninstall_Gov-Tuner.zip .>nul
	echo Moving Uninstaller to common\system\etc\GovTuner
	move /y Uninstall_Gov-Tuner.zip ..\common\system\etc\GovTuner>nul
	cd ..
	echo Using zip to build output
	echo Building output zip
	%zip_exec% -r output\Gov-Tuner_%version%.zip . -x ".git/*" "win/*" "uninstaller/*" "output/*" "magisk/*" "build.*" ".gitignore" "Gov-Tuner_*.zip">nul
	echo Output created: %home_dir%\output\Gov-Tuner_%version%.zip
)

if !build! EQU magisk (
	:: Use xcopy instead of robocopy for compatibility reason.
	echo Copying files
	xcopy %home_dir%\magisk\1500 %home_dir%\output\temp-magisk /E>nul
	xcopy %home_dir%\common\system %home_dir%\output\temp-magisk\system /E>nul
	mkdir %home_dir%\output\temp-magisk\system\bin
	mkdir %home_dir%\output\temp-magisk\system\etc\GovTuner\busybox-install
	mkdir %home_dir%\output\temp-magisk\system\etc\GovTuner\busybox-install\arm
	mkdir %home_dir%\output\temp-magisk\system\etc\GovTuner\busybox-install\x86
	copy %home_dir%\common\system\etc\GovTuner\govtuner %home_dir%\output\temp-magisk\system\bin\govtuner>nul
	copy %home_dir%\common\system\etc\GovTuner\govtuner_hybrid %home_dir%\output\temp-magisk\system\etc\GovTuner\profiles\govtuner_hybrid>nul
	:: Set the module's version number.
	%sed_exec% -i -e s/version=#version/version=v%version%-Magisk/g %home_dir%\output\temp-magisk\module.prop
	%sed_exec% -i -e s/#version/%version%/g %home_dir%\output\temp-magisk\config.sh
	:: Convert potentially non-Unix line endings.
	for /f "tokens=* delims=" %%a in ('dir %home_dir%\output\temp-magisk /s /b') do ( %d2u_exec% %%a )
	:: Copy busybox after line ending conversion to prevent it from being broken by dos2unix.
	copy %home_dir%\arm\busybox %home_dir%\output\temp-magisk\system\etc\GovTuner\busybox-install\arm\busybox>nul
	copy %home_dir%\x86\busybox %home_dir%\output\temp-magisk\system\etc\GovTuner\busybox-install\x86\busybox>nul
	:: Build output.
	cd output\temp-magisk
	echo Building output zip.
	%zip_exec% -0 -r ..\Gov-Tuner_%version%-Magisk.zip .>nul
	pushd %prev_dir%
	echo Deleting temporary folder
	rd /s /q %home_dir%\output\temp-magisk>nul
	echo Output created: %home_dir%\output\Gov-Tuner_%version%-Magisk.zip
)
