#!/bin/bash
set -o pipefail
[ -z "$QUTE_FIFO" ] && printf "QUTE_FIFO not set!\n" && exit 1

function qute_run() {
    # shellcheck disable=SC2059
    printf "$@" > "$QUTE_FIFO"
}

if ! [ -z "$1" ]
then
    QUTE_HTML=$(mktemp --suffix=".html")
    trap 'rm -f "$QUTE_HTML"' EXIT
    if ! curl --silent --location --output "$QUTE_HTML" "$1"
    then
        qute_run 'message-error "curl exited with code %d"' "$?"
    fi
fi

URLS="$(grep -oP 'href="\Kmagnet:[^"]+' "$QUTE_HTML" | sed 's/&amp;/\&/g')"
if [ -z "$URLS" ]
then
    qute_run 'message-warning "Did not find any magnet links!"'
    exit 0
fi

IFS=$'\n'
for URL in $URLS
do
    if command transmission-remote "$TRANSMISSION_HOST" -a "$URL"
    then
        qute_run 'message-info "Added url: %s"' "$URL"
    else
        qute_run 'message-warning "Failed to add url: %s"' "$URL"
    fi
done
exit 0
