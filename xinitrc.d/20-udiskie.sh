#!/bin/sh
# Auto-mount removable media
( command -v "udiskie" >/dev/null 2>&1 ) && udiskie --automount --notify --smart-tray &
