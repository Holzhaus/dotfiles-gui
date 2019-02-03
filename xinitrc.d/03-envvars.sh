if [ ! -z "$GUIBROWSER" ] && command -v "$GUIBROWSER" >/dev/null 2>&1; then
    export BROWSER="$GUIBROWSER"
fi
