#!/bin/bash
# Will turn a drive into a bootable disk from an iso.

image=$1
disk=$2
diskutil unmountDisk /dev/disk$disk
sudo dd if=$image of=/dev/rdisk$disk bs=1m
echo "Done!"
