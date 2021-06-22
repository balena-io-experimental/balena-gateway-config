#!/bin/sh

function wait_for_dbus() {
	while true; do
		dbus-send --system \
			  --print-reply \
			  --dest=org.freedesktop.DBus \
			  /org/freedesktop/DBus \
			  org.freedesktop.DBus.ListNames

		if [ $? ]; then
			break;
		else
			sleep 0.1
		fi
	done

	echo "DBus is now accepting connections"
}


wait_for_dbus \
	&& wpa_supplicant -u -B \
	&& connmand -n -i wlan0 -d
