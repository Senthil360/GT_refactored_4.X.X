@Echo Off
:: Gov-Tuner ZIP creation script
:: Written by F4uzan, with the help of Gov-Tuner Team
:: zip and bzip2 binaries provided by GnuWin / gnuwin32 at http://gnuwin32.sourceforge.net
:: ssed (super sed) provided by http://sed.sourceforge.net/grabbag/ssed/ with win32 binary by Laurent Vogel.
::
:: This script should build a zip archive containing all the files excluding the ".git" folder
:: "zip" binary is provided in the "win" folder, this folder will also be excluded out when compiling the zip
::
:: Usage:
:: build <ARGUMENTS> <VERSION>
::
:: Additional arguments:
:: build: Build a regular flashable zip
:: magisk : Build a Magisk-compatible zip
:: install : Build a regular zip then install
:: magisk-install : Build a Magisk-compatible zip then install
::
:: Example:
:: build 4.0.1 build

set version=%1
set build=%2
set zip_exec=win\zip.exe
set sed_exec=win\ssed.exe
set dir=%cd%

if %version% == "" (
	echo No version number supplied, exiting.
	exit
)

if %build% == "" (
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

if %build% == "build" (
	:: Build and copy uninstaller before doing anything
	echo Building Uninstaller
	cd uninstaller
	..\%zip_dir%\%zip_exec% -r Uninstall_Gov-Tuner.zip .>nul
	echo Moving Uninstaller to common\system\etc\GovTuner
	move /y Uninstall_Gov-Tuner.zip ../common/system/etc/GovTuner>nul
	cd ..
	echo Using zip to build output
	echo Building output zip
	%zip_exec% -r output/Gov-Tuner_%version%.zip . -x ".git/*" "win/*" "uninstaller/*" "output/*" "magisk/*" "build.*" ".gitignore" "Gov-Tuner_*.zip">nul
	echo Output created: %dir%\output\Gov-Tuner_%version%.zip
)

if %build% == "magisk" (
	:: Use xcopy instead of robocopy for compatibility reason.
	echo Copying files
	xcopy /s /e %dir%\magisk\1500 %dir%\output\temp-magisk
	xcopy /s /e %dir%\common\system %dir%\output\temp-magisk\system
	mkdir %dir%\output\temp-magisk\system\bin
	mkdir %dir%\output\temp-magisk\system\etc\GovTuner\busybox-install
	mkdir %dir%\output\temp-magisk\system\etc\GovTuner\busybox-install\arm
	mkdir %dir%\output\temp-magisk\system\etc\GovTuner\busybox-install\x86
	copy %dir%\arm %dir%\output\temp-magisk\system\etc\GovTuner\busybox-install
	copy %dir%\x86 %dir%\output\temp-magisk\system\etc\GovTuner\busybox-install
	copy %dir%\common\system\etc\GovTuner\govtuner %dir%\output\temp-magisk\system\bin\govtuner
	copy %dir%\common\system\etc\GovTuner\govtuner_hybrid %dir%\output\temp-magisk\system\etc\GovTuner\profiles\govtuner_hybrid
	:: Set the module's version number.
	%sed_exec% -i -e "s/version=#version/version=v$version-Magisk/g" "$dir/output/temp-magisk/module.prop"
	%sed_exec% -i -e "s/#version/$version/g" "$dir/output/temp-magisk/config.sh"
	:: Build output.
	echo Building output zip
	set prev_dir=%dir%
	cd %dir\output\temp-magisk
	%zip_exec% -r ../Gov-Tuner_$version-Magisk.zip . -x "*/\.*">nul
	echo Deleting temporary folder
	cd %prev_dir%
	rd /s /q %dir%\output\temp-magisk
	echo Output created: %dir%\output\Gov-Tuner_%version%-Magisk.zip
)
