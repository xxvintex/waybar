#!/bin/bash

# Check if bluetooth service is running
if ! systemctl is-active --quiet bluetooth; then
    echo "off"
    exit 0
fi

# Check if bluetooth is powered on
powered=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [ "$powered" = "yes" ]; then
    # Check for connected devices
    connected_devices=$(bluetoothctl devices Connected 2>/dev/null)
    
    if [ -n "$connected_devices" ]; then
        # Get the first connected device MAC and battery info
        device_mac=$(echo "$connected_devices" | head -1 | awk '{print $2}')
        battery_info=$(bluetoothctl info "$device_mac" | grep "Battery Percentage" | awk '{print $4}' | tr -d '()')
        
        if [ -n "$battery_info" ]; then
            echo "$battery_info%"
        else
            echo "on"
        fi
    else
        echo "on"
    fi
else
    echo "off"
fi