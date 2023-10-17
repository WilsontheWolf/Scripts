#! /bin/bash

# This script installs a .deb package from the local filesystem to a remote device. 
# Designed to be mostly compatible with theos' make install
# Recommended you have an SSH Key
# It requires the following environment variables to be set:
# - SSH_HOST: The hostname of the remote device. If not avaible fallsback to THEOS_DEVICE_IP
# - SSH_PORT: The port of the remote device. If not avaible fallsback to THEOS_DEVICE_PORT or blank
# - SSH_AFTER_COMMAND: A command to run on the device after successful installation. Useful for respringing the device. Defaults to none.

if [ -z "$SSH_HOST" ]
then
    if [ -z "$THEOS_DEVICE_IP" ]
    then
        echo "SSH_HOST not set"
        exit 1
    else
        SSH_HOST="$THEOS_DEVICE_IP"
    fi
fi

if [ -z "$SSH_PORT" ]
then
    if [ -z "$THEOS_DEVICE_PORT" ]
    then
        SSH_PORT=""
    else
        SSH_PORT="$THEOS_DEVICE_PORT"
    fi
fi

if [ -z "$SSH_AFTER_COMMAND" ]
then
    SSH_AFTER_COMMAND=""
fi

if [ -z "$1" ]
then
    echo "No .deb file provided"
    exit 1
fi

if [ ! -f "$1" ]
then
    echo "File $1 does not exist"
    exit 1
fi

if [ -z "$SSH_PORT" ]
then
    scp "$1" "root@$SSH_HOST:/tmp/ssh-deb-install.deb"
else
    scp -P "$SSH_PORT" "$1" "root@$SSH_HOST:/tmp/ssh-deb-install.deb"
fi

if [ -z "$SSH_PORT" ]
then
    ssh "root@$SSH_HOST" 'dpkg -i /tmp/ssh-deb-install.deb ; export SSH_DPKG_EXIT_CODE=$? ; rm /tmp/ssh-deb-install.deb ; [ $SSH_DPKG_EXIT_CODE -eq 0 ] && '"$SSH_AFTER_COMMAND"
else
    ssh -p "$SSH_PORT" "root@$SSH_HOST" "dpkg -i /tmp/ssh-deb-install.deb && rm /tmp/ssh-deb-install.deb && $SSH_AFTER_COMMAND"
fi

