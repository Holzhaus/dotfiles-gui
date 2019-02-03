#!/bin/sh
case $1 in
    period-changed)
        if [ "$3" = "none" ]
        then
            exec notify-send --urgency=low "Redshift" "Temperature adjustment disabled"
        else
            exec notify-send --urgency=low "Redshift" "Period changed to $3"
        fi
esac
