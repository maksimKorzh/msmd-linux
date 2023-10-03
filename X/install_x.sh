#!/bin/sh

########################################
#
#   Install X server & Window Manager
#
########################################

# Install X packages
for PAC in $(cat packages.lst); do
  dipi $PAC
done

# Fix permissions
sudo sed -i 's/staff/msmd/g' /usr/local/bin/*

# Symlink libs
sudo ln -s /usr/local/lib/* /lib/

# Provide Tiny Core related configurations
sudo mkdir -p /var/log
sudo mkdir -p /etc/skel
sudo mkdir -p /etc/init.d
sudo mkdir -p /etc/sysconfig
sudo chmod -R +w /etc/sysconfig
sudo echo "Xorg" | sudo tee /etc/sysconfig/Xserver
sudo echo "flwm" | sudo tee /etc/sysconfig/desktop
sudo echo "msmd" | sudo tee /etc/sysconfig/tcuser
sudo echo "wbar" | sudo tee /etc/sysconfig/icons

# Add missing scripts & files
#git clone https://github.com/tinycorelinux/Core-scripts
#sudo cp Core-scripts/etc/init.d/tc-functions /etc/init.d/tc-functions
#sudo cp Core-scripts/usr/bin/select /usr/bin/select
sudo cp XSESSION /home/msmd/.xsession
cp WBARCONF /home/msmd/.wbarconf
cp XDEFAULTS /home/msmd/.Xdefaults
cp SETBACKGROUND /home/msmd/.setbackground
ln -s /usr/local/tce.icons /home/msmd/.wbar
