#! /bin/bash

# This script checks if the any of the physical disks in the system are running out of space.
# If the number of disks that are above the threshold changes, it prints a warning message.
# See check-disk.sh for more details
# This was meant to be run as a cron job

cd "$(dirname "$0")"

DISK_STATUS="$(./check-disk.sh)"
DISKS_LOW="$?"
PREVIOUS_STATUS="$(cat /tmp/check-disk-history 2>/dev/null || echo 0)"

if [ "$DISKS_LOW" == "$PREVIOUS_STATUS" ]
then
    exit 0
fi

echo "$DISKS_LOW" > /tmp/check-disk-history

if [ "$DISKS_LOW" == "0" ]
then
    exit 0
else
    # Might want to change me to something more useful
    echo "$DISK_STATUS"
fi