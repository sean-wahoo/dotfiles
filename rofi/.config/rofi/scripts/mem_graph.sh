#!/bin/bash

mapfile -t recent_percentages <<< "$(curl -s http://localhost:61208/api/4/mem/history/30 | jq '.percent[][1]')"
{
  for per in "${recent_percentages[@]}"; do
    echo "$per";
  done
  while true; do curl -s "http://localhost:61208/api/4/mem" | jq '.percent'; sleep 1; done
} | ttyplot -t "mem" -m 80 -C dark1 -u "%"
# used="$(echo $response | jq '.total')"
# total="$(echo $response | jq '.total')"
# percent="$(echo $response | jq '.total')"
