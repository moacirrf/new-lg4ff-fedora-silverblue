#!/bin/bash
FILE=`pwd`/build/new-lg4ff/hid-logitech-new.ko
if test -f "$FILE"; then

echo "Creating service on /etc/systemd/system/hid-logitech-new.service ..."

echo "
[Unit]
Description=Loads new logitech driver for wheels.
DefaultDependencies=false
After=systemd-user-sessions.service
OnFailure=hid-logitech-new-failure.service
[Service]
Type=simple
WorkingDirectory=`pwd`
ExecStart=sh `pwd`/load-hid-logitech-new.sh --scope user
Restart=on-failure
RestartSec=60
[Install]
Alias=hid-logitech-new.service
WantedBy=multi-user.target" > /etc/systemd/system/hid-logitech-new.service

echo "Creating service on /etc/systemd/system/hid-logitech-new-failure.service ..."

echo "
[Unit]
Description=Build new logitech driver for wheels 
DefaultDependencies=false
After=systemd-user-sessions.service
[Service]
User=`logname`
Type=simple
WorkingDirectory=`pwd`
ExecStart=sh `pwd`/podman_build.sh --scope user
[Install]
Alias=hid-logitech-new-failure.service
WantedBy=multi-user.target" > /etc/systemd/system/hid-logitech-new-failure.service

echo "Disabling original module hid-logitech"
echo "Creating a black list file  /etc/modprobe.d/hid-logitech-blacklist.conf"

echo "blacklist hid-logitech
install hid-logitech /bin/false
" > /etc/modprobe.d/hid-logitech-blacklist.conf

chmod +x /etc/systemd/system/hid-logitech-new.service
chmod +x /etc/systemd/system/hid-logitech-new-failure.service

echo "Enable service..."
systemctl enable hid-logitech-new.service

echo "Starting service"
systemctl restart hid-logitech-new.service

echo "OK.Bye bye"
else
    echo "$FILE does not exist. You must execute podman_build.sh first."
fi
