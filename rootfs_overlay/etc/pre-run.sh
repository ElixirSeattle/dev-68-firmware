#!/bin/sh

# ------------------------------------------------------------------------------
# This pre-run script executes before the BEAM starts.
# ------------------------------------------------------------------------------

set -e

# Mount configfs if it's not already mounted
mount -t configfs none /sys/kernel/config

# Load USB gadget description.
gadget-import hidg /etc/usb_gadget/hidg.schema
echo `ls /sys/class/udc` > /sys/kernel/config/usb_gadget/hidg/UDC

# Bond USB gadget network adapters.
BOND_DIR="/sys/class/net/bond0/bonding"

ip link set bond0 down

echo "active-backup" > "${BOND_DIR}/mode"
echo "100" > "${BOND_DIR}/miimon"
echo "+usb0" > "${BOND_DIR}/slaves"
echo "+usb1" > "${BOND_DIR}/slaves"
echo "usb1" > "${BOND_DIR}/primary"

ip link set bond0 up
