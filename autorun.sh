#!/bin/sh

# helper function
run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

# run xrandr script to setup monitors correctly
run "/home/jeremy/.screenlayout/default.sh"
