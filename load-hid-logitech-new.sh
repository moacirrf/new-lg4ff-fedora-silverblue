#!/bin/bash
modprobe -r hid-logitech
modprobe ff-memless
insmod ./build/new-lg4ff/hid-logitech-new.ko
