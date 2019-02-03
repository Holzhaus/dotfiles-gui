#!/bin/sh
# Start polkit daemon
polkitagent="/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
[ -x "$polkitagent" ] && "$polkitagent" &
