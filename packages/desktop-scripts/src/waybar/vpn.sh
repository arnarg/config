#!/usr/bin/env bash

CONNECTED_VPNS=`nmcli -t -f name,type,state -c no c | grep vpn | grep activated | wc -l`

if [[ $CONNECTED_VPNS -gt 0 ]]; then
	echo '{"text": "", "tooltip": "VPN connected"}'
	exit 0
fi
exit 1
