#!/bin/sh

########################################
#
#     Install Xfbdev (Tiny X) & JWM
#
########################################

# Install X packages
for PAC in $(cat packages.lst); do
  dipi $PAC
done

# Install latest firefox
cd /home/msmd
wget -O firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&amp;os=linux64&amp;lang=en-US"
tar -xvf firefox.tar.bz2
rm firefox.tar.bz2

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
sudo echo "Xfbdev" | sudo tee /etc/sysconfig/Xserver
sudo echo "jwm" | sudo tee /etc/sysconfig/desktop
sudo echo "msmd" | sudo tee /etc/sysconfig/tcuser

# Add missing scripts & files
git clone https://github.com/tinycorelinux/Core-scripts
sudo cp Core-scripts/etc/init.d/tc-functions /etc/init.d/tc-functions
sudo cp Core-scripts/usr/bin/select /usr/bin/select
sudo cp .xsession /etc/skel/.xsession
cp .setbackground /home/msmd/.setbackground
mkdir -p /home/msmd/Images
cp wallpaper.jpg /home/msmd/Images/wallpaper.jpg
cp .jwm* /home/msmd/
cp .Xdefaults /home/msmd/.Xdefaults

# Setup X environment
xsetup.sh
sed -i '1s/^/sudo /' /home/msmd/.xsession
echo 'sudo mkdir -p /dev/pts' >> /home/msmd/.xsession
echo 'sudo mount -t devpts devpts /dev/pts' >> /home/msmd/.xsession
