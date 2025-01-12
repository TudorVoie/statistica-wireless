#!/bin/bash
CURDIR=$(pwd)
INTERFACE=$1
HOME_SSID=$2

if [[ $2 ]]; then
    rm -f statistica-scanner.service
    rm -f statistica-web.service
    rm -f statistica.service
    rm -f monitor.sh

    echo "[Unit]
Description=Scanner statistica wireless
After=network.target

[Service]
ExecStart=$CURDIR/scan.sh $1 $2 $CURDIR
Restart=on-failure
RestartSec=20s
User=root
WorkingDirectory=$CURDIR

[Install]
WantedBy=multi-user.target" >> statistica-scanner.service
    echo "Service file generated to statistica-scanner.service"
    
    echo "[Unit]
Description=Web server statistica wireless
After=network.target

[Service]
ExecStart=$CURDIR/web.sh
User=root
WorkingDirectory=$CURDIR

[Install]
WantedBy=multi-user.target" >> statistica-web.service
    echo "Service file generated to statistica-web.service"

    echo "[Unit]
Description=Statistica wireless
After=network.target

[Service]
ExecStart=$CURDIR/monitor.sh
Restart=on-failure
User=root
WorkingDirectory=$CURDIR

[Install]
WantedBy=multi-user.target" >> statistica.service

    echo "Service file generated to statistica.service"

    echo "#!/bin/bash

SSID_TO_MONITOR="$HOME_SSID"
SCANNER_SERVICE="statistica-scanner"
WEB_SERVICE="statistica-web"
SCRIPTS_DIR="$CURDIR"
EXPORT_SCRIPT="\$SCRIPTS_DIR/export.sh"
GENERATOR_SCRIPT="\$SCRIPTS_DIR/generator.sh"

get_connected_ssid() {
    nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2
}

on_connect() {
    echo "Connected to \$SSID_TO_MONITOR. Performing tasks..."
    systemctl stop "\$SCANNER_SERVICE"
    bash "\$EXPORT_SCRIPT"
    bash "\$GENERATOR_SCRIPT"
    systemctl start "\$WEB_SERVICE"
}

on_disconnect() {
    echo "Disconnected from \$SSID_TO_MONITOR. Performing tasks..."
    systemctl stop "\$WEB_SERVICE"
    systemctl start "\$SCANNER_SERVICE"
}

while true; do
    CURRENT_SSID=\$(get_connected_ssid)
    if [[ "\$CURRENT_SSID" == "\$SSID_TO_MONITOR" ]]; then
        if [[ "\$LAST_STATE" != "connected" ]]; then
            on_connect
            LAST_STATE="connected"
        fi
    else
        if [[ "\$LAST_STATE" != "disconnected" ]]; then
            on_disconnect
            LAST_STATE="disconnected"
        fi
    fi
    sleep 5
done" >> monitor.sh

    echo "Shell file generated to monitor.sh"
    
    sudo chmod +x monitor.sh
    sudo chmod +x export.sh
    sudo chmod +x generator.sh
    sudo chmod +x scan.sh
    sudo chmod +x web.sh

    sudo systemctl enable $CURDIR/statistica-scanner.service
    sudo systemctl enable $CURDIR/statistica-web.service
    sudo systemctl enable $CURDIR/statistica.service

    sudo systemctl stop statistica-web
    sudo systemctl stop statistica-scanner
    sudo systemctl start statistica

    echo "Setup finished. DO NOT REMOVE THIS FOLDER"
    echo "Also: create a file api.key and paste in there the API key from macvendors.com. Else the export script won't work!"
else
    echo "Arguments incorrectly supplied! Exiting..."
    exit 1
fi

