#!/bin/sh
abspath() {
    olddir=$(pwd)
    if [ -d "$1" ]; then
        cd "$1" || exit 1
        pwd -P
    else
        cd "$(dirname "$1")" || exit 1
        echo "$(pwd -P)/$(basename "$1")"
    fi
    cd "$olddir" || exit 1
}

: "${HOME?Need to set HOME}"

[ -z "$HOSTNAME" ] && HOSTNAME="$(hostname)"

[ -z "$XDG_CONFIG_HOME" ] && XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$XDG_CONFIG_HOME"

[ -z "$XDG_DATA_HOME" ] && XDG_DATA_HOME="$HOME/.local/share"
mkdir -p "$XDG_DATA_HOME"

[ -z "$BINDIR" ] && BINDIR="$HOME/.local/bin"
mkdir -p "$BINDIR"

DOTFILES="$(abspath "$(dirname "$0")")"

# Logging
exec 3>&1
log ()
{
    echo "$1" 1>&3
}

# Installation
symlink() {
    if [ -L "$2" ]; then
        # FIXME: We could use readlink's "-m" argument to follow deep symlinks
        # but it's not POSIX compliant
        if [ "$(readlink "$2")" != "$1" ]; then
            log "Deleting old symlink '$2' (pointed to '$(readlink "$2")')"
            rm "$2"
            ln -s "$1" "$2"
        fi
    elif [ ! -e "$2" ]; then
       log "File '$2' does not exist, creating symlink..."
       ln -s "$1" "$2"
    elif [ -e "$2" ] && [ ! -e "$2.old" ]; then
        log "Creating Backup for '$2' -> '$2.old'"
        mv "$2" "$2.old"
        ln -s "$1" "$2"
    else
        log "Unable to install '$2'"
    fi
}

# alacritty
symlink "$DOTFILES/alacritty"            "$XDG_CONFIG_HOME/alacritty"

# autorandr
if [ -e "$DOTFILES/autorandr/host.$HOSTNAME" ]
then
    symlink "$DOTFILES/autorandr/host.$HOSTNAME"  "$XDG_CONFIG_HOME/autorandr"
fi

# compton
symlink "$DOTFILES/compton/compton.conf" "$HOME/.compton.conf"

# dunst
symlink "$DOTFILES/dunst"                "$XDG_CONFIG_HOME/dunst"

# i3-gaps config
symlink "$DOTFILES/i3"                   "$HOME/.i3"

# polybar
symlink "$DOTFILES/polybar"              "$XDG_CONFIG_HOME/polybar"

# qutebrowser
mkdir -p "$XDG_DATA_HOME/qutebrowser"
symlink "$DOTFILES/qutebrowser"             "$XDG_CONFIG_HOME/qutebrowser"
symlink "$DOTFILES/qutebrowser/userscripts" "$XDG_DATA_HOME/qutebrowser/userscripts"

# redshift
symlink "$DOTFILES/redshift"             "$XDG_CONFIG_HOME/redshift"

# rofi
symlink "$DOTFILES/rofi"                 "$HOME/.rofi"

# rxvt-unicode
symlink "$DOTFILES/urxvt"                "$HOME/.urxvt"


# xinitrc
symlink "$DOTFILES/xinitrc"              "$HOME/.xinitrc"
symlink "$DOTFILES/xinitrc.d"            "$HOME/.xinitrc.d"

# Xresources
symlink "$DOTFILES/xcolors"              "$HOME/.xcolors"
symlink "$DOTFILES/Xresources"           "$HOME/.Xresources"
symlink "$DOTFILES/Xresources.d"         "$HOME/.Xresources.d"

# Zathura
symlink "$DOTFILES/zathura"              "$XDG_CONFIG_HOME/zathura"

for executable in "$DOTFILES/bin/"*
do
    if [ -x "$executable" ]
    then
        symlink "$executable" "$BINDIR/$(basename "$executable")"
    fi
done
