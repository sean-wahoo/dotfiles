#!/bin/sh

prefix="/usr"
exec_prefix="${prefix}"
xrdb="xrdb"
xinitdir="$HOME"
xclock="xclock"
xterm="xterm"
twm="twm"
xmodmap="xmodmap"

userresources="$HOME/.Xresources"
usermodmap="$HOME/.Xmodmap"
sysresources="$xinitdir/.Xresources"
sysmodmap="$xinitdir/.Xmodmap"

# merge in defaults and keymaps

BIN_PATH="~/.local/bin"

xrdb -merge ./.Xresources 

wallpaper="wp1.jpg"

MON_1="eDP-1"
MON_2="DP-4-1"
MON_3="DP-4-2"

case "$HOSTNAME" in
  "box")
    wallpaper="wp2.png"
    MON_1="DisplayPort-1"
    MON_2="DisplayPort-0"
    MON_3="DisplayPort-2"
  ;&
  *)
    xrandr \
      --output "$MON_1" \
      --mode "2560x1440" \
      --rate 144 \
      --output "$MON_2" \
      --mode "2560x1440" \
      --rate 144 \
      --right-of "$MON_1" \
      --output "$MON_3" \
      --mode "2560x1440" \
      --rate 164.55 \
      --primary \
      --pos "-1280x1440"
    ;;
esac

feh --bg-scale ~/.wallpapers/$wallpaper
picom -f -b 
exec ~/.config/dwm/scripts/launch_dwm.sh
