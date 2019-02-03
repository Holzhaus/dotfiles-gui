#!/bin/sh
# Screensaver / Locker
xset s 180 180
xset dpms 180 180 180
#gdbus call --system --dest org.freedesktop.login1 --object-path /org/freedesktop/login1/session/3 --method org.freedesktop.login1.Session.SetIdleHint boolean:false
xss-lock -l -- "$HOME/.local/bin/i3lock-multimonitor" \
    "$HOME/.i3/lockscreen.jpg" \
    --tiling \
    --clock \
    --line-uses-inside \
    --insidecolor=373445ff \
    --ringcolor=ffffffff --ringvercolor=ffffffff --ringwrongcolor=ffffffff \
    --keyhlcolor=d23c3dff --bshlcolor=d23c3dff --insidewrongcolor=d23c3dff \
    --separatorcolor=00000000 \
    --insidevercolor=fecf4dff \
    --date-align=2 \
    --time-align=2 \
    --indpos="x+50:y+h-50" \
    --timepos="x+w-50:y+50" \
    --radius=15 \
    --veriftext="" --wrongtext="" --noinputtext="" \
    --time-font="Fira Sans" \
    --date-font="Fira Sans" \
    --datestr="%A, %d. %B %Y" \
    &
