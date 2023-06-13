#!/bin/sh

xrdb -merge ~/.Xresources

xset r rate 200 25

picom -b --no-fading-openclose
/usr/bin/dunst &
exec awesome
