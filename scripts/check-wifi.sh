#!/usr/bin/env bash

set -euo pipefail

# Original idea: https://www.weworkweplay.com/play/rebooting-the-raspberry-pi-when-it-loses-wireless-connection-wifi/

LOG_DIR="/var/log/check-wifi"
ROUTER_IP="192.168.1.1"

now(){
    date '+%Y-%m-%d %H:%M:%S %Z'
}

restart_system(){
    if [[ ${DEBUG-} != true  ]]; then
        sudo shutdown -r now
    else
        echo "Simulating reboot"
    fi
}

temperature(){
    vcgencmd measure_temp | tr -d "temp="
}

echo "[$(now)] $(temperature)" | sudo tee -a "$LOG_DIR/execution.log"

if ! ping -c3 "$ROUTER_IP" > /dev/null; then
    sudo mkdir -p "$LOG_DIR"
    echo "[$(now)] [$(temperature)] wifi disconnected -> reboot" | sudo tee -a "$LOG_DIR/history.log" > /dev/null
    restart_system
fi
