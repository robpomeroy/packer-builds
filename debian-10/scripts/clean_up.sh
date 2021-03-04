#!/bin/bash -eux

# Remove unused packages and clean up
apt -y autoremove --purge
apt-get clean

# Zero all free space (allows us to compact the virtual hard drive efficiently)
dd if=/dev/zero of=/tmp/zeroes bs=1M
rm -f /tmp/zeroes

# Force file system to synchronise before Packer shuts down the system
sync