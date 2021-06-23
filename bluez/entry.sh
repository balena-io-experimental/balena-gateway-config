#!/bin/sh

source dbus-wait.sh

rfkill block bluetooth && rfkill unblock bluetooth
wait_for_dbus \
	&& /usr/lib/bluetooth/bluetoothd  --nodetach
