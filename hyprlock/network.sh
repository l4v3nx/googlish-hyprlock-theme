#!/bin/bash

# Read the wifi-mode alias from hyprlock.conf
show_ssid=$(grep -oP '^\$wifi-mode\s*=\s*\K\S+' ~/.config/hypr/hyprlock.conf)

# Check if the SSID was successfully extracted else fallback?!
if [ -z "$show_ssid" ]; then
  show_ssid=false
fi

# Check if any Ethernet connection is active
ethernet_connected=$(nmcli -t -f DEVICE,TYPE,STATE dev | grep -E 'ethernet:connected')

# If Ethernet
if [ -n "$ethernet_connected" ]; then
    echo "󰈀  Ethernet"
    exit 0
fi

# Get the Wi-Fi interface
wifi_interface=$(iw dev | awk '/Interface/ {print $2; exit}')

# Check if Wi-Fi interface exists
if [ -z "$wifi_interface" ]; then
    echo "󰤮  No Wi-Fi Interface"
    exit 0
fi

# Check if Wi-Fi is connected and get SSID
ssid=$(iwgetid -r)

# If not connected, show "No Wi-Fi"
if [ -z "$ssid" ]; then
    echo "󰤮  No Wi-Fi"
    exit 0
fi

# Get signal strength from /proc/net/wireless
signal_strength=$(awk -v iface="$wifi_interface" '$1 ~ iface ":" {print int($3 * 100 / 70)}' /proc/net/wireless)

# Define Wi-Fi icons based on signal strength
wifi_icons=("󰤯" "󰤟" "󰤢" "󰤥" "󰤨") # From low to high signal

# Clamp signal strength between 0 and 100
signal_strength=$((signal_strength < 0 ? 0 : (signal_strength > 100 ? 100 : signal_strength)))

# Calculate the icon index based on signal strength
icon_index=$((signal_strength / 25))

# Get the corresponding icon
wifi_icon=${wifi_icons[$icon_index]}

# Output based on show_ssid variable
if [ "$show_ssid" = true ]; then
    echo "$wifi_icon  $ssid"
else
    echo "$wifi_icon  Connected"
fi
