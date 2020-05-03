#!/bin/bash 
install_location=/usr/local/bin
config_location=~/.config
autostart_location=~/.config/autostart

# uninstall requirements
pkgM=$( command -v yum || command -v apt-get || command -v pamac || command -v pacman ) || echo "package manager not found"
case ${pkgM} in
  *pacman)
    uninstall=-R
    auto=--noconfirm
    ;;

  *pamac)
    uninstall=remove
    auto=--no-confirm
    ;;

  *)
    uninstall=remove
    auto=-y
    ;;
esac
## cat, stdbuf are builtin, may need to install daemonize by hand
echo "Uninstalling $(sed -n -e 'H;${x;s/\n/, /g;s/^,[ ]//;p;}' pkg_requirements)."
xargs -d"\n" -n 1 -ra <( cat pkg_requirements ) sudo ${pkgM} ${uninstall}

## subprocess, shlex, threading, queue, time, os, sys, math  are builtin
## uninstalls on global python
echo "Uninstalling $(sed -n -e 'H;${x;s/\n/, /g;s/^,[ ]//;p;}' py_requirements)."
xargs -d"\n" -n 1 -ra <( cat py_requirements ) sudo pip3 uninstall

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
echo "Removing placed files gestures evemu_do getConfig.py and orientation"
sudo rm -i ${install_location}/gestures 
sudo rm -i ${install_location}/evemu_do 
sudo rm -i ${install_location}/getConfig.py
sudo rm -i ${install_location}/orientation

## remove config file
while true; do
    echo "Remove configuration file (~/.config/gesture.conf)? Warning: will need to rewrite to get back." 
    read -p "(y/n):" choice
    case "$choice" in 
      y|Y ) echo "Removing config file."; rm -i ${config_location}/gestures.conf; break;;
      n|N ) echo "Skipping Removal of config file."; break;;
      * ) echo "Please answer y or n.";;
    esac
done

echo "Removing from auto start."
rm -i ${autostart_location}/gestures.desktop 

