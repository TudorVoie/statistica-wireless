#!/bin/bash
CURDIR=$(pwd)
INTERFACE=$1
HOME_SSID=$2

if [[ $2 ]]; then
    rm -f statistica-scanner.service
    rm -f statistica-web.service

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
    
    sudo systemctl enable $CURDIR/statistica-scanner.service
    sudo systemctl enable $CURDIR/statistica-web.service
    sudo systemctl stop statistica-web
    sudo systemctl start statistica-scanner

else
    echo "Arguments incorrectly supplied! Exiting..."
    exit 1
fi

