#!/usr/bin/env bash

SIGRTMIN=34
LANG_MAP='{"English (US)": "US", "Icelandic": "IS"}'

get_active_layout() {
	swaymsg -rt get_inputs | jq -c '[.[] | select(.type == "keyboard" and .name != "virtual keyboard") | {langs: .xkb_layout_names, count: (.xkb_layout_names|length), active: .xkb_active_layout_index}] | unique[0]'
}

set_active_layout() {
	new_layout=`echo $1 | jq -r '(.active + 1) % .count'`
	swaymsg -- "input * xkb_switch_layout $new_layout" 2>&1 >/dev/null
}

format_output() {
	echo "{\"lang_map\": $LANG_MAP, \"active_layout\": $1}" | jq -c '{"text": .lang_map[(.active_layout | .langs[.active])], "tooltip": (.active_layout | .langs[.active])}'
}


case "$1" in
	"switch")
		set_active_layout "`get_active_layout`"
		pkill "-RTMIN+$2" waybar
		;;
	*)
		format_output "`get_active_layout`"
		;;
esac

