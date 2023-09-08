#! /bin/bash

# This script checks if the any of the physical disks in the system are running out of space.
# The threshold is `DISK_SPACE_THRESHOLD` (as a percent) (default of 75%). If any disk is above this threshold, it prints a warning message.
# NOTE: Ignores any disks mounted in /boot or are from /dev/loop*
# Exit code is the number of disks that are above the threshold

if [ -z "$DISK_SPACE_THRESHOLD" ]
then
    DISK_SPACE_THRESHOLD=75
fi

DISK_INFO="$(df -h --output=source,target,pcent,used,size | sed 1d)"
IFS=$'\n'

SEEN=""
WARNINGS=0
for line in $DISK_INFO
do
    source="$(echo $line | awk '{print $1}')"

    if [[ $source != /* ]] 
    then
        continue
    fi
    if [[ $source == /dev/loop* ]]
    then
        continue
    fi
    # Prevent duplicate entries
    if [[ $SEEN == *"$source"* ]]
    then
        continue
    fi
    # SEEN+=" $source"

    target="$(echo $line | awk '{print $2}')"

    if [[ $target == /boot* ]]
    then
        continue
    fi

    percent="$(echo $line | awk '{print $3}' | sed 's/%//')"

    used="$(echo $line | awk '{print $4}')"
    size="$(echo $line | awk '{print $5}')"

    if [ $percent -gt $DISK_SPACE_THRESHOLD ]
    then
        echo "$target ($source) is at $percent% capacity ($used/$size)"
        WARNINGS=$(($WARNINGS + 1))
    fi
done

exit $WARNINGS