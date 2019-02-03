#!/bin/sh
# Load Xresources
: "${HOME?Need to set HOME}"

[ -z "$HOSTNAME" ] && HOSTNAME="$(hostname)"

xrdb -load "$HOME/.Xresources"

XRESOURCES_HOSTCONFIG="$HOME/.Xresources.d/$HOSTNAME.xrdb"
if [ -r "$XRESOURCES_HOSTCONFIG" ]
then
    xrdb -merge "$XRESOURCES_HOSTCONFIG"
fi
