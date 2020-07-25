#!/usr/bin/env bash

DISPLAY="$1"
CURRENT_LID_STATE=`cat /proc/acpi/button/lid/LID/state | awk '{print $2}'`
CURRENT_DISPLAY_STATE=`swaymsg -rt get_outputs | jq -r ".[]|select(.name == \"$DISPLAY\")|.active"`
ACTIVE_OTHER_DISPLAYS=`swaymsg -rt get_outputs | jq -r "[.[]|select(.active == true)|select(.name != \"$DISPLAY\")]|length"`

if [[ $ACTIVE_OTHER_DISPLAYS > 0 && $CURRENT_LID_STATE == "closed" ]]; then
	echo "Turning off display '$DISPLAY'"
	swaymsg output "$DISPLAY" disable
elif [[ $CURRENT_DISPLAY_STATE == "false" ]]; then
	echo "Turning on display '$DISPLAY'"
	swaymsg output "$DISPLAY" enable
fi
