#!/usr/bin/env bash

set -euo pipefail

# Original idea: https://www.weworkweplay.com/play/rebooting-the-raspberry-pi-when-it-loses-wireless-connection-wifi/

LOG_DIR="/var/log/check-wifi"
ROUTER_IP="192.168.1.1"

if ! ping -c4 "$ROUTER_IP" > /dev/null; then
    now=$(date '+%Y-%m-%d %H:%M:%S %Z')
    sudo mkdir -p "$LOG_DIR"
    echo "[$now] wifi disconneted" | sudo tee "$LOG_DIR/history.log" > /dev/null
    sudo shutdown -r now
fi
