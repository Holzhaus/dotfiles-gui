#!/bin/sh
# shellcheck disable=SC2153
[ -z "${KODI_HOST}" ] && { echo "KODI_HOST is empty, cannot continue" ; exit 1; }
[ -z "${KODI_PORT}" ] && { echo "KODI_PORT is empty, using 8080" ; KODI_PORT=8080; }

STREAM_URL="$(youtube-dl -g "$1")"
if [ -z "$STREAM_URL" ]; then
    STREAM_URL="$1"
fi

curl "http://${KODI_HOST}:${KODI_PORT}/jsonrpc" \
    -H "Content-Type: application/json" \
    --data "{\"method\":\"Player.Open\",\"id\":44,\"jsonrpc\":\"2.0\",\"params\":{\"item\":{\"file\":\"${STREAM_URL}\"}}}"
