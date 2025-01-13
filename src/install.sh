#!/bin/bash
CURDIR=$(pwd)
INTERFACE=$1

if [[ $1 ]]; then
    rm -f scanner.service
    rm -f bot.service

    echo "[Unit]
Description=Scanner statistica wireless
After=network.target

[Service]
ExecStart=$CURDIR/scan.sh $INTERFACE $CURDIR
Restart=on-failure
RestartSec=20s
User=root
WorkingDirectory=$CURDIR

[Install]
WantedBy=multi-user.target" >> scanner.service
    echo "Service file generated to scanner.service"
    
    echo "[Unit]
Description=Bot statistica wireless
After=network.target

[Service]
ExecStart=sudo /usr/bin/python3 bot.py
Restart=on-failure
RestartSec=20s
User=root
WorkingDirectory=$CURDIR

[Install]
WantedBy=multi-user.target" >> bot.service
    echo "Service file generated to bot.service"
    sudo chmod +x generator.sh
    sudo chmod +x scan.sh

    sudo systemctl enable $CURDIR/scanner.service
    sudo systemctl enable $CURDIR/bot.service

    sudo systemctl stop scanner
    sudo systemctl start bot

    echo "Setup finished. DO NOT REMOVE THIS FOLDER"
    echo "Also: create a file bot.key and paste in there the discord bot token. Else the export script won't work!"
else
    echo "Arguments incorrectly supplied! Exiting..."
    exit 1
fi