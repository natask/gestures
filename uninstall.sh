#!/bin/bash 
install_location=/usr/local/bin
config_location=~/.config
autostart_location=~/.config/autostart

# remove user from input group
while true; do
    echo "Remove input group? Other tools may depend on it." 
    read -p "(y/n):" choice
    case "$choice" in 
      y|Y ) sudo gpasswd -d $USER input; break;;
      n|N ) break;;
      * ) echo "Please answer y or n.";;
    esac
done

# remove placed files
sudo rm ${install_location}/gestures 
sudo rm ${install_location}/evemu_do 
sudo rm ${install_location}/getConfig.py

## remove config file
while true; do
    echo "Remove configuration file (~/.config/gesture.conf)? Warning: will need to rewrite to get back." 
    read -p "(y/n):" choice
    case "$choice" in 
      y|Y ) rm ${config_location}/gestures.conf; break;;
      n|N ) break;;
      * ) echo "Please answer y or n.";;
    esac
done

rm ${autostart_location}/gestures.desktop 

