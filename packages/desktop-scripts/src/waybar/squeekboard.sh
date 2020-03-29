#!/usr/bin/env bash

# I'm using dbus activation so we give it a little time to start up
for i in 1 2 3 4; do
  currentState=`busctl --user get-property sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 Visible`
  if [[ $? == 0 ]]; then break; fi
  sleep 0.1
done

case "$currentState" in
"b true")
  busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false
  ;;
"b false")
  busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true
  ;;
esac
