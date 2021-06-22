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

rfkill unblock bluetooth \
	&& wait_for_dbus \
	&& /usr/lib/bluetooth/bluetoothd  --nodetach
