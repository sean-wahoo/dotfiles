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
      --pos "0x0"
      --output "$MON_2" \
      --mode "2560x1440" \
      --rate 144 \
      --pos "2560x0"
      --output "$MON_3" \
      --mode "2560x1440" \
      --rate 164.55 \
      --primary \
      --pos "1280x1440"
    ;;
esac

systemctl --user import-environment DISPLAY

# autorandr --load
feh --bg-scale ~/.wallpapers/$wallpaper

# if ! command -v linux-wallpaperengine >/dev/null 2>&1
# then
#   feh --bg-scale ~/.wallpapers/$wallpaper
# else
  # MON1_WP="3002821218"
  # MON2_WP="3477867160" # 3466567674
  # MON3_WP="3174796374"
  # XDG_SESSION_TYPE="x11"
  #
  # linux-wallpaperengine \
  #   --screen-root "DisplayPort-2" --bg $MON1_WP \
  #   --screen-root "DisplayPort-1" --bg $MON2_WP \
  #   --screen-root "DisplayPort-0" --bg $MON3_WP 
  # XDG_SESSION_TYPE=x11 linux-wallpaperengine --screen-root DisplayPort-2 --bg 3517767676 --screen-root DisplayPort-0 --bg 3174796374 --screen-root DisplayPort-1 --bg 3477867160 &

# fi

picom -f -b &
exec ~/.config/dwm/scripts/launch_dwm.sh
