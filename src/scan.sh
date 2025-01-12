#!/bin/bash

NETWORK_INTERFACE=$1
HOME_SSID=$2

CURRENT_SSID=$(iwgetid -r)
if [[ "$CURRENT_SSID" == "$HOME_SSID" ]]; then
    exit 0
fi

FILE_NAME=$(date +"%F-%H-%M-%S").txt
OUTPUT_FILE="scans/$FILE_NAME"

sudo iwlist $NETWORK_INTERFACE scanning > "$OUTPUT_FILE"

echo "Wireless networks scanned and saved to $OUTPUT_FILE"