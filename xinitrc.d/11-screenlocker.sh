#!/bin/bash
# Screensaver / Locker
xset s 180 180
xset dpms 180 180 180
#gdbus call --system --dest org.freedesktop.login1 --object-path /org/freedesktop/login1/session/3 --method org.freedesktop.login1.Session.SetIdleHint boolean:false

if man i3lock | grep -q i3lock-color; then
    printf 'i3lock-color found, using extra command line options...\n';
    I3LOCK_COLOR_ARGS=(
        '--tiling'
        '--clock'
        '--line-uses-inside'
        '--insidecolor=37344580'
        '--insidevercolor=fecf4d80'
        '--insidewrongcolor=d23c3d80'
        '--ringcolor=ffffffff'
        '--ringvercolor=ffffffff'
        '--ringwrongcolor=ffffffff'
        '--keyhlcolor=d23c3dff'
        '--bshlcolor=d23c3dff'
        '--separatorcolor=00000000'
        '--timecolor=ffffffff'
        '--datecolor=ffffffff'
        '--date-align=2'
        '--time-align=2'
        '--timepos=x+w-50:y+50'
        '--veriftext='
        '--wrongtext='
        '--noinputtext='
        '--time-font=Fira Sans'
        '--date-font=Fira Sans'
        '--datestr=%A, %d. %B %Y'
    )
else
    printf 'i3lock-color not found, using standard command line options only...\n';
    I3LOCK_COLOR_ARGS=()
fi

xss-lock -l -- "$HOME/.local/bin/i3lock-multimonitor" \
    "$HOME/.i3lock/lockscreens/" \
    "$HOME/.i3lock/lock-icon.png" \
    "${I3LOCK_COLOR_ARGS[@]}" \
    &
