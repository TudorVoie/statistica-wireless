#!/bin/bash

INPUT_DIR="scans"
OUTPUT_FILE="wifi_scan.json"
TEMP_FILE="temp.txt"
API_FILE=$1
API=$(cat $API_FILE)

> "$TEMP_FILE"

json_escape() {
    echo "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}
t
parse_iwlist_file() {
    local file="$1"

    SSID=""
    MAC=""
    CHANNEL=""
    FREQ=""
    ENCRYPTION=""
    MANUFACTURER=""

    while IFS= read -r line; do
        if [[ "$line" =~ ESSID:\"(.*)\" ]]; then
            SSID=$(json_escape "${BASH_REMATCH[1]}")
        elif [[ "$line" =~ Address:\ ([0-9A-Fa-f:]{17}) ]]; then
            MAC="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ Channel:([0-9]+) ]]; then
            CHANNEL="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ Frequency:([0-9.]+\ GHz) ]]; then
            FREQ="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ Encryption\ key:(on|off) ]]; then
            ENCRYPTION="${BASH_REMATCH[1]}"
        fi

        if [[ -n "$SSID" && -n "$MAC" && -n "$CHANNEL" && -n "$FREQ" && -n "$ENCRYPTION" ]]; then
            MANUFACTURER=$(curl -G "https://api.macvendors.com/v1/lookup/$MAC" \
    -H "Authorization: Bearer $API" \
    -H "Accept: text/plain")
            sleep 0.5
            if [[ "$MANUFACTURER" == "{\"errors\":{\"detail\":\"Not Found\"}}" ]]; then
                MANUFACTURER="Not Found"
            fi

            echo "{\"SSID\":\"$SSID\",\"MAC\":\"$MAC\",\"Channel\":$CHANNEL,\"Frequency\":\"$FREQ\",\"Encryption\":\"$ENCRYPTION\",\"Manufacturer\":\"$MANUFACTURER\"}" >> "$TEMP_FILE"
            SSID=""
            MAC=""
            CHANNEL=""
            FREQ=""
            ENCRYPTION=""
        fi
    done < "$file"
}

for file in "$INPUT_DIR"/*.txt; do
    echo "Processing file: $file"
    parse_iwlist_file "$file"
    echo "Removing file: $file"
    rm "$file"
done

awk '!seen[$0]++' "$TEMP_FILE" | jq -s '.' > "$OUTPUT_FILE"

echo "Removing $TEMP_FILE"
rm -f "$TEMP_FILE"

echo "Combined JSON output saved to $OUTPUT_FILE"
