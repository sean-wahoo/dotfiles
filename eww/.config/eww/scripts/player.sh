#!/usr/bin/bash

toggle() {
  playerctl play-pause
}

next() {
  playerctl next
}

prev() {
  playerctl prev
}

seek_back() {
  playerctl position "10-"
}

seek_forward() {
  playerctl position "10+"
}

get_position() {
  echo $(playerctl position --format "{{ duration(position) }}")
}

get_length() {
  echo $(playerctl metadata --format "{{ duration(mpris:length) }}")
}

get_title() {
  echo $(playerctl metadata title)
}

get_artist() {
  echo $(playerctl metadata artist)
}

get_status() {
  echo $(playerctl status)
}

case "$1" in
  "toggle")
    toggle ;;
  "next")
    next ;;
  "prev")
    prev ;;
  "seek_back")
    seek_back ;;
  "seek_forward")
    seek_forward ;;
  "get_position")
    get_position ;;
  "get_length")
    get_length ;;
  "get_title")
    get_title ;;
  "get_artist")
    get_artist ;;
  "get_status")
    get_status ;;
esac
