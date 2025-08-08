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

# xrandr --output "DP2-1" --mode 2560x1440 --rate 144 --pos 0x0 --output "eDP1" --mode 2400x1600 --rate 120 --pos 2560x0 --output "DP2-3" --mode 2560x1440 --rate 144 --pos 4960x0 > ~/xrandr.log 2>&1
xrdb -merge ./.Xresources 

if [[ "$(uname -r)" == *"surface" ]]; then
  xrandr --verbose > xrandr_v.log 2>&1
  xrandr --output DP2-1 --mode "2560x1440" --rate 144 --pos "0x0" --output eDP1 --mode "2400x1600" --rate 120 --scale 0.85x0.85 --pos "2560x0" --output "DP2-3" --mode "2560x1440" --rate 144 --pos "4600x0" > ~/xrandr.log 2>&1
else
  xrandr --output DP-4-1 --mode 2560x1440 --rate 144 --pos 0x0 --output eDP-1 --mode 2256x1504 --pos 2560x0 --output DP-4-3 --mode 2560x1440 --rate 144.00 --pos 4816x0 
fi

feh --bg-scale ~/.wallpapers/wp2.png 
/usr/local/bin/picom -f -b 
exec ~/.config/dwm/scripts/launch_dwm.sh
# while true; do
#   # dwmblocks 2> ~/.config/dwm/dwmblocks-async.log &
#   dwm 2> ~/.config/dwm/dwm.log 
#   # $BIN_PATH/dwm 2> ~/.config/dwm/dwm.log &
#   # $BIN_PATH/dwmblocks 2> ~/.config/dwm/dwmblocks-async.log 
# done
