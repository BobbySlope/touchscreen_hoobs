#!/bin/bash

# DO NOT USE THIS SCRIPT - ITS IN TESTING STATE AND MAY CORRUPT YOUR HOOBS DEVICE


# HOW TO RUN THE SCRIPT

# sudo wget -q -O - https://raw.githubusercontent.com/BobbySlope/touchscreen_hoobs/main/install.sh | sudo bash -



##################################################################################################
# ext_display_hoobs.                                                                             #
# Copyright (C) 2022 HOOBS                                                                       #
#                                                                                                #
# This program is free software: you can redistribute it and/or modify                           #
# it under the terms of the GNU General Public License as published by                           #
# the Free Software Foundation, either version 3 of the License, or                              #
# (at your option) any later version.                                                            #
#                                                                                                #
# This program is distributed in the hope that it will be useful,                                #
# but WITHOUT ANY WARRANTY; without even the implied warranty of                                 #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                                  #
# GNU General Public License for more details.                                                   #
#                                                                                                #
# You should have received a copy of the GNU General Public License                              #
# along with this program.  If not, see <http://www.gnu.org/licenses/>.                          #
##################################################################################################
# Author: Bobby Slope     


sudo apt-get update --yes
echo "----------------------------------------------------------------"
echo "This script will Setup the external Touchdisplay Widget for HOOBS"
echo "----------------------------------------------------------------"

echo "Setup Touchscreen...."
sudo rm -rf LCD-show
git clone https://github.com/goodtft/LCD-show.git
sudo chmod -R 755 LCD-show
cd LCD-show/
sudo ./LCD35-show
echo "----------------------------------------------------------------"
echo "Touchscreen Installed"
echo "----------------------------------------------------------------"

echo "set screen...."
sudo rm -rf /usr/share/X11/xorg.conf.d/99-fbturbo.conf
cat > /usr/share/X11/xorg.conf.d/99-fbturbo.conf <<EOL
Section "InputClass"
   Identifier "calibration"
   MatchProduct "ADS7846 Touchscreen"
   # Hat trick to get the pen to work properly on the touch screen, rotate 90 degrees clockwise:
   Option "TransformationMatrix" "0 -1 1 1 0 0 0 0 1"
   # Touch screen rotation by 90deg
   #Option "TransformationMatrix" "0 1 0 -1 0 1 0 0 1"
   # Don't use libinput but evdev for the touch screen and the pen so calibration works:
   Driver "evdev"
   Option "Calibration"   "3936 227 268 3880"
   Option "InvertY" "true"
   #Option "InvertX" "true"
   # Right mouse button is long press with pen:
   Option "EmulateThirdButton" "1"
   Option "EmulateThirdButtonTimeout" "750"
   Option "EmulateThirdButtonMoveThreshold" "30"
EndSection

Section "Device"
   # WaveShare SpotPear 3.5", framebuffer 1
   Identifier "uga"
   driver "fbdev"
   # Switch to /dev/fb0 for default output (usually hdmi)
   Option "fbdev" "/dev/fb1"
   Option "ShadowFB" "off"
EndSection

Section "Monitor"
   # Primary monitor. WaveShare SpotPear 480x320
   Identifier "WSSP"
EndSection

Section "Screen"
   Identifier "primary"
   Device "uga"
   Monitor "WSSP"
EndSection

Section "ServerLayout"
   Identifier "default"
   Screen 0 "primary"
EndSection
EOL

echo "----------------------------------------------------------------"
echo "Setup Fullscreen Dashboard"
echo "----------------------------------------------------------------"
echo "rebooting in 10secs"
echo "----------------------------------------------------------------"
sleep 10
sudo reboot
