#!/bin/sh

########################################
#
#   Install X server & Window Manager
#
########################################

# Install X packages
dipi Xfbdev
dipi jwm

# Fix permissions
sudo sed -i 's/staff/msmd/g' /usr/local/bin/*

# Provide Tiny Core related configurations
sudo mkdir -p /etc/skel
sudo mkdir -p /etc/init.d
sudo mkdir -p /etc/sysconfig
sudo chmod -R +w /etc/sysconfig
sudo echo "Xfbdev" | sudo tee /etc/sysconfig/Xserver
sudo echo "jwm" | sudo tee /etc/sysconfig/desktop
sudo echo "msmd" | sudo tee /etc/sysconfig/tcuser
sudo echo "wbar" | sudo tee /etc/sysconfig/icons

# Add missing scripts
git clone https://github.com/tinycorelinux/Core-scripts
sudo cp Core-scripts/etc/init.d/tc-functions /etc/init.d/tc-functions
sudo cp Core-scripts/usr/bin/select /usr/bin/select
