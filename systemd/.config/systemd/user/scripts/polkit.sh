#!/bin/sh

if test "$1" != '_INTERNAL'; then
  prepParams() { for i in "$@"; do printf "'%s' " "$i"; done }
  parameters="$(prepParams "$@")"

  exec cmd-polkit-agent -v -s -c "$0 _INTERNAL $parameters*"
else
  shift 1

  while read -r msg; do
    if echo "$msg" | jq -e '.action == "request password"' 1>/dev/null 2>/dev/null
    then
      prompt="$( printf '%s' "$msg" | jq -rc '.prompt // "Password:"' )"
      message="$(printf "%s" "$msg" | jq -rc '.message // "No message!"')"

      response="$(rofi -dmenu -p "$prompt" -mesg "$message" -password -no-fixed-num-lines -theme polkit "$@")"

      if [ -z "$response" ]
      then echo '{"action":"cancel"}'
      else echo "{\"action\":\"authenticate\",\"password\":\"$response\"}"
      fi
    fi
  done
fi
