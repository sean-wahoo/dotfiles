#!/bin/bash

AMOUNT=$(pactl list sinks short | awk 'END {print NR}')
DOT="•"
D="-"
BAR=""
TARGET=""

if [ $AMOUNT -eq 1 ]; then
  TARGET=$(pactl list sinks | grep Volume | awk 'FNR == 1 {print substr($5, 1, length($5)-2)}')
  for ((i = 0; i < $TARGET; i++)); do
    BAR+=$DOT
  done
  for ((i = $TARGET; i < 10; i++)); do
    BAR+=$D
  done
  echo "$BAR"
elif [ $AMOUNT -eq 2 ]; then
  TARGET=$(pactl list sinks | grep Volume | awk 'FNR == 3 {print substr($5, 1, length($5)-2)}')
  for ((i = 0; i < $TARGET; i++)); do
    BAR+=$DOT
  done
  for ((i = $TARGET; i < 10; i++)); do
    BAR+=$D
  done
  echo "$BAR"
elif [ $AMOUNT -eq 3 ]; then
  TARGET=$(amixer --card 3 | awk 'BEGIN{RS="Simple mixer control"}; /Mono: Playback / {print substr($18, 2, length($18) - 2)}')
  if [ $TARGET -lt 10 ]; then
    TARGET=0;
  else
    TARGET=${TARGET::1};
  fi
  for ((i = 0; i < $TARGET; i++)); do
    BAR+=$DOT
  done
  for ((i = $TARGET; i < 10; i++)); do
    BAR+=$D
  done
  echo "$BAR"
else
  echo "Not found."
fi
