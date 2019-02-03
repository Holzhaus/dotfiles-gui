# System-wide xinit files
if [ -d "/etc/X11/xinit/xinitrc.d" ]
then
    for f in "/etc/X11/xinit/xinitrc.d/"?*
    do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# User-local xinit files
: "${HOME?Need to set HOME}"
if [ -d "$HOME/.xinitrc.d" ]
then
    for f in "$HOME/.xinitrc.d/"?*
    do
        logger --id=$$ "Sourcing file: $f"
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

i3-make-config
exec i3
