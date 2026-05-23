#!/usr/bin/bash

LAT=39.75
LON=-84.19
UNITS=imperial
APPID=7ce8064f0a815eb7befd43cd8a8d33f4

weather_api_response=$(curl -sf "https://api.openweathermap.org/data/2.5/weather?appid=$APPID&lat=$LAT&lon=$LON&units=$UNITS")

weather_icon=$(echo $weather_api_response | jq '.weather[0].icon')

weather_icon=${weather_icon//\"/}


# if [! -f "$HOME/.config/eww/icons/_weather_$weather_icon.png"]; then
#   curl -sf "https://openweathermap.org/img/wn/$weather_icon@4x.png" > "$HOME/.config/eww/icons/_weather_$weather_icon.png"
# fi

echo "$weather_api_response"
