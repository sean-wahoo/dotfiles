#!/bin/bash

restart_xorg="Restart Xorg\0icon\x1fimage-x-generic"
restart_pc="Restart PC\0icon\x1fsystem-reboot"
go_to_bios="Go to BIOS\0icon\x1fterminal-settings"
shutdown="Shutdown\0icon\x1fsystem-shutdown-symbolic"

case "$1" in
  "")
    echo -e "$restart_xorg"
    echo -e "$restart_pc"
    echo -e "$go_to_bios"
    echo -e "$shutdown"
    ;;
  "$restart_xorg")
    pkexec pkill Xorg
    ;;
  "$restart_pc")
    pkexec systemctl reboot
    ;;
  "$go_to_bios")
    pkexec systemctl reboot --firmware-setup
    ;;
  "$shutdown")
    pkexec shutdown -P +0.1 "shutdown imminent 10 seconds"
    ;;
  *)
    exit 1
    ;;
esac
