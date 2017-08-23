#!/bin/bash
opt=$1
adb push govtuner /sdcard/GT_dev/Beta/govtuner
adb push govtuner_hybrid /sdcard/GT_dev/Beta/GovTuner_hybrid
if [ "$opt" = "all" ]; then
adb push 00gt_init /sdcard/GT_dev/Beta/00gt_init
adb push change.sh /sdcard/GT_dev/Beta/change.sh
adb push changelog.txt /sdcard/GT_dev/Beta/changelog.txt
adb push profiles/field_table_big /sdcard/GT_dev/Beta/profiles/field_table_big
adb push profiles/field_table_little /sdcard/GT_dev/Beta/profiles/field_table_little
adb push profiles/field_table_middle /sdcard/GT_dev/Beta/profiles/field_table_middle
adb push profiles/field_table_reg /sdcard/GT_dev/Beta/profiles/field_table_reg
fi
echo "pushed"
exit
