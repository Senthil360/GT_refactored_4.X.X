#!/bin/bash
## Gov-Tuner ZIP creation
### Written by F4uzan, with the help of Gov-Tuner Team
#
# This script should build a zip archive containing all the files excluding the ".git" folder
# Works on Linux with proper "zip" installation
#
# Usage:
# ./build.sh <ARGUMENTS> <VERSION>
#
# Additional arguments:
# build: Build a regular flashable zip
# magisk : Build a Magisk-compatible zip
# install : Build a regular zip then install
# magisk-install : Build a Magisk-compatible zip then install
#
# Example:
# ./build.sh 4.0.1

version=$1
build=$2
dir=$(pwd)
GT_in1="$dir/common/system/etc/GovTuner"
GT_in2="$dir/common/system/etc/GovTuner/profiles"
GT_out1="/sdcard/GT_dev"
#GT_out2="/system/etc/GovTuner/profiles"
if [ ! -d output ]; then
	mkdir output
fi

echo "Building Gov-Tuner v$version"
echo "----------------------"

if [ "$build" = "bu" ]; then
   # Build and copy uninstaller before doing anything
   echo "Building Uninstaller"
   cd uninstaller; zip -r Uninstall_Gov-Tuner.zip .>/dev/null
   echo "Moving Uninstaller to common/system/etc/GovTuner"
   mv Uninstall_Gov-Tuner.zip ../common/system/etc/GovTuner
   cd ..
fi

if [ "$build" = "b" ] || [ "$build" = "bu" ]; then
   echo "Using zip to build output"
   echo "Building output zip"
   zip -r output/Gov-Tuner_$version.zip . -x ".git/*" "win/*" "uninstaller/*" "output/*" "magisk/*" "build.*" ".gitignore" "Gov-Tuner_*.zip">/dev/null
   echo "Output created: $dir/output/Gov-Tuner_$version.zip"
   echo ""
fi

echo "Push file to sdcard? (Y/n) : "
  read -r p
  case $p in
	y|Y)
          total=$(adb devices | grep "device" | wc -l)
          if [ "$total" -le 1 ]; then
             echo "Device not found , check adb connection"
             exit
          fi
          if [ "$total" -gt 1 ]; then
             adb push $dir/output/Gov-Tuner_$version.zip /sdcard/Gov-Tuner_$version.zip
             adb push $dir/output/file_copy_GT.sh $GT_out1/file_copy_GT.sh
             adb push $GT_in1/govtuner $GT_out1/govtuner
             adb push $GT_in1/govtuner_hybrid $GT_out1/GovTuner_hybrid
             adb push $GT_in2/field_table_big $GT_out1/field_table_big
             adb push $GT_in2/field_table_middle $GT_out1/field_table_middle
             adb push $GT_in2/field_table_little $GT_out1/field_table_little
             adb push $GT_in1/change.sh $GT_out1/change.sh
             adb push $GT_in1/changelog.txt $GT_out1/changelog.txt
             adb push $GT_in1/00gt_init $GT_out1/00gt_init
             sleep 0.5
             sleep 0.5
             echo "Files copied to sdcard"
               echo "Reboot recovery? (Y/n) : "
               read -r q
               case $q in
                  y|Y)
                     echo "Rebooting to recovery in 3 seconds , press Ctrl+C to abort"
                     sleep 4
                     adb reboot recovery
                  ;;
                  n|N)
                     echo "Carry on with the development"
                     exit
                  ;;
                  *)
	             echo "Invalid option, please try again";
	             exit
	          ;;
               esac
          fi
        ;;
        n|N)
          echo "Carry on with the development"
          exit
        ;;

        *)
	  echo "Invalid option, please try again";
	  exit
	;;
  esac
