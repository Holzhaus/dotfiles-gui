#!/bin/sh
# Gnome Keyring
if command -v "gnome-keyring-daemon" >/dev/null 2>&1
then
    dbus-update-activation-environment --systemd DISPLAY
    gnome-keyring-daemon --start --components=pkcs11,secrets,ssh
    export SSH_AUTH_SOCK
fi
