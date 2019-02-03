#!/bin/sh
# Switch to preferred monitor setup
if command -v "autorandr" >/dev/null 2>&1 && [ -e "$HOME/.config/autorandr" ]
then
    [ -z "$(autorandr --current)" ] && autorandr --change
fi
