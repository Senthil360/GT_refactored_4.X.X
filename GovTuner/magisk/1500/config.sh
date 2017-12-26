MODID=govtuner
AUTOMOUNT=true
PROPFILE=false
POSTFSDATA=true
LATESTARTSERVICE=true

print_modname() {
  ui_print "****************************************"
  ui_print "*          Gov-Tuner v 4.1.0       *"
  ui_print "****************************************"
  ui_print ""
  ui_print "Systemless for Magisk, v0.1"
  ui_print ""
  ui_print "@Debuffer"
  ui_print "@Senthil360"
  ui_print "@Paget96"
  ui_print "@N1m0Y"
  ui_print "@veez21"
  ui_print "@F4"
  ui_print "@GreekDragon"
}

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info about how Magic Mount works, and why you need this

# This is an example
REPLACE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here, it will override the example above
# !DO NOT! remove this if you don't need to replace anything, leave it empty as it is now
REPLACE="
"

REPLACE="
"

set_permissions() {
  set_perm_recursive  $MODPATH  0  0  0755  0644
  set_perm_recursive $MODPATH/system/etc/GovTuner/ 0 0 0755 0644
  set_perm $MODPATH/system/bin/govtuner 0 0 0777 02000
  set_perm $MODPATH/system/etc/GovTuner/init/00gt_init 0 0 0777 02000
}