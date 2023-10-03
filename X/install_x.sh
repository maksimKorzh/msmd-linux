#!/bin/sh

########################################
#
#   Install X server & Window Manager
#
########################################

# Install X packages
dipi Xfbdev
dipi jwm

sudo mkdir -p /etc/init.d
sudo mkdir -p /etc/sysconfig
echo "Xfbdev" > /etc/sysconfig/Xserver
echo "jwm" > /etc/sysconfig/desktop
echo "msmd" > /etc/sysconfig/tcuser
echo "wbar" > /etc/sysconfig/icons

git clone https://github.com/tinycorelinux/Core-scripts
sudo cp Core-scripts/etc/init.d/tc-functions /etc/init.d/tc-functions
sudo cp Core-scripts/usr/bin/select /usr/bin/select
