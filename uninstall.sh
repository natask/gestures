#!/bin/bash 
install_location=/usr/local/bin
config_location=~/.config
autostart_location=~/.config/autostart

# remove user from input group
sudo gpasswd -d $USER input

# remove placed files
sudo rm ${install_location}/gestures 
sudo rm ${install_location}/evemu_do 
sudo rm ${install_location}/getConfig.py
rm ${config_location}/gestures.conf 
rm ${autostart_location}/gestures.desktop 

