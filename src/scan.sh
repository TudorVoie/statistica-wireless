#!/bin/bash

HOME_SSID=$1
PPATH=$2

while true; do
    FILE_NAME=$(date +"%F-%H-%M-%S").txt
    OUTPUT_FILE="$2/scans/$FILE_NAME"
    sudo iwlist $NETWORK_INTERFACE scanning > "$OUTPUT_FILE"
    echo "Wireless networks scanned and saved to $OUTPUT_FILE"
    sleep 20
done