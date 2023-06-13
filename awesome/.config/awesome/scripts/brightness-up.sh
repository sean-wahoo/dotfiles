#!/bin/bash

DIR="/sys/class/backlight/intel_backlight"
TARGET="/sys/class/backlight/intel_backlight"
MAX=$(cat ${TARGET}/max_brightness)
CURRENT=$(cat ${TARGET}/actual_brightness)

if [[ $CURRENT -gt 0 ]]; then
  ((CURRENT=CURRENT+10))
  echo $CURRENT > $TARGET/brightness
fi
