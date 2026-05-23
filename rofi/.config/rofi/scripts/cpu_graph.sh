#!/bin/bash

mapfile -t recent_percentages <<< "$(curl -s http://localhost:61208/api/4/cpu/history/30 | jq '.user[][1]')"
{
  for per in "${recent_percentages[@]}"; do
    echo "$per";
  done
  while true; do curl -s "http://localhost:61208/api/4/cpu" | jq '.user'; sleep 1; done
} | ttyplot -t "cpu" -m 80 -C dark1 -u "%"
