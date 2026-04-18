#!/bin/bash

controller_info="$(bluetoothctl show)"
discoverable=$( [ "$(echo "$controller_info" | awk '/Discoverable: /' | cut -f2 -d ' ')" = "yes" ] && echo true || echo false )


