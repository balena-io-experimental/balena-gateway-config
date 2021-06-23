#!/bin/sh

source dbus-wait.sh

wait_for_dbus \
	&& wpa_supplicant -u -B \
	&& connmand -n -i wlan0 -d
