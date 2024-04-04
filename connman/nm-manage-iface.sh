#!/bin/sh
iface=$1
managed=$2

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Usage: <str interface> <bool managed>"
	exit 1
fi

device_path=$(dbus-send --system \
			--print-reply \
			--dest=org.freedesktop.NetworkManager \
			/org/freedesktop/NetworkManager \
			org.freedesktop.NetworkManager.GetDeviceByIpIface \
			string:"$iface" | awk '/object path/ {print $3}')

if [ -z "$device_path" ]; then
	echo "failed getting device object path"
	exit 1
fi


if dbus-send --system \
	     --print-reply \
	     --dest=org.freedesktop.NetworkManager \
	     "$(echo "$device_path" | xargs)" \
	     org.freedesktop.DBus.Properties.Set \
	     string:"org.freedesktop.NetworkManager.Device" \
	     string:"Managed" \
	     variant:boolean:"$managed" 1>&2 > /dev/null; then
	state=$([ "$managed" = "true" ] && echo "managed" || echo "unmanaged")
	echo "$iface is now $state"
else
	echo "failed making $iface $state: $?"
fi
