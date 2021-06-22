#!/bin/bash

#set -e

function install_dbus_config() {
	cp gateway_config/config/com.helium.Config.conf /mnt/dbus-config
	echo "Installed gateway-config dbus policy"
}

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

#if ! test -f /mnt/dbus-config/com.helium.Config.conf; then
#	install_dbus_config
#fi

echo "Starting gateway_config"

wait_for_dbus \
	&& gateway_config/bin/gateway_config foreground

echo "gateway_config exited" && sleep 60
