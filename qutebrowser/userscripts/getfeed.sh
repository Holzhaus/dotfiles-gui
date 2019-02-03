#!/bin/bash
# getfeed.sh
# (c) 2018 Jan Holthuis
#
# This qutebrowser userscript finds RSS/Atom-Feed-URLS in the HTML code
# of the current page (or in the code of the URL passed as command line
# argument) and adds them to a file.

FEEDFILE="$HOME/.newsboat/urls"

set -o pipefail
[ -z "$QUTE_FIFO" ] && printf 'QUTE_FIFO not set!\n' && exit 1

function qute_run() {
    # shellcheck disable=SC2059
    printf "$@" > "$QUTE_FIFO"
}

if ! [ -z "$1" ]
then
    QUTE_URL="$1"
    QUTE_HTML="$(mktemp --suffix=".html")"
    trap 'rm -f "$QUTE_HTML"' EXIT
    if ! curl --silent --location --output "$QUTE_HTML" "$QUTE_URL"
    then
        qute_run 'message-error "curl exited with code %d"' "$?"
    fi
fi
URLS="$(grep -oP '<link [^>]*type="application/(atom|rss)\+xml" [^>]*href="\K[^"]+' "$QUTE_HTML" | sed 's/&amp;/\&/g' | sort -u)"
if [ -z "$URLS" ]
then
    qute_run 'message-warning "Did not find any feeds links!"'
    exit 0
fi

BASEURL="$(dirname "$QUTE_URL" | sed -E 's|/$||')"
URLS="$(printf '%s' "$URLS" | sed -E '/:\/\//! {s|.*|'"$BASEURL"'/\0|g}')"

# Prompt the user if multiple URLs have been found
if [ "$(printf '%s\n' "$URLS" | wc -l)" -gt 1 ]
then
    FEED="$(printf '%s' "$URLS" | rofi -dmenu -p "feed" -i --only-match)"
else
    FEED="$URLS"
fi

if [ ! -z "$FEED" ]
then
    if TMPFILE="$(mktemp --suffix=-feedurls.txt)"
    then
        printf '%s' "$FEED" | sort -u "$FEEDFILE" - > "$TMPFILE"
        mv "$TMPFILE" "$FEEDFILE"
        qute_run 'message-info "Feed added!"'
    else
        qute_run 'message-error "Unable to create tempfile!"'
    fi
else
    qute_run 'message-warning "No newsfeed available!"'
fi
