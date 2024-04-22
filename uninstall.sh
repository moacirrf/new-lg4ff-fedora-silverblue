#!/bin/bash
echo "Removing service..."
systemctl disable hid-logitech-new
rm /etc/systemd/system/hid-logitech-new.service

echo "Unloading module hid-logitech-new"
rmmod `pwd`/build/new-lg4ff/hid-logitech-new.ko

echo "Enabling original module hid-logitech"
rm /etc/modprobe.d/hid-logitech-blacklist.conf
modprobe hid-logitech

echo "Ok.Bye bye"
