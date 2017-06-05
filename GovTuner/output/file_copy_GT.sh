#!/system/bin/sh
dir1="/sdcard/GT_dev"
dir2="/system/bin"
dir3="/system/etc/GovTuner"
dir4="/system/etc/GovTuner/profiles"
dir5="system/etc/init.d"

mount -o remount, rw /system
   cp -f $dir1/GovTuner_hybrid $dir4/GovTuner_hybrid
   cp -f $dir1/field_table_big $dir4/field_table_big
   cp -f $dir1/field_table_middle $dir4/field_table_middle
   cp -f $dir1/field_table_little $dir4/field_table_little
   chmod 777 $dir4/*
   cp -f $dir1/Changelogs $dir3/Changelogs
   chmod 777 $dir3/Changelogs
   cp -f $dir1/changelog.txt $dir3/changelog.txt
   cp -f $dir1/govtuner $dir2/govtuner
   chmod 777 $dir2/govtuner
   cp -f $dir1/00gt_init $dir3/00gt_init
   chmod 777 $dir5/00gt_init
mount -o remount, ro /system
   
