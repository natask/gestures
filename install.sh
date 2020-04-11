#!/bin/bash 
install_location=/usr/local/bin
config_location=~/.config/
autostart_location=~/.config/autostart

# install requirements
pkgM=$( command -v yum || command -v apt-get || command -v pamac || command -v pacman ) || echo "package manager not found"
case ${pkgM} in
  *pacman)
    install=-S
    auto=--noconfirm
    ;;

  *pamac)
    install=install
    auto=--no-confirm
    ;;

  *)
    install=install 
    auto=-y
    ;;
esac

## cat, stdbuf are builtin, may need to install daemonize by hand
cat pkg_requirements | xargs -n 1 sudo ${pkgM} ${install} ${auto} 
## subprocess, shlex, threading, queue, time, os, sys, math  are builtin
## installs on global python
sudo pip3 install pathlib simplejson

# place files in corresponding locations
sudo cp gestures evemu_do getConfig.py ${install_location}
if test -f "${config-location}/gestures.conf"; then
    echo "$FILE exist"
    while true; do
        echo "config file exists. override (saves backup as gestures.conf.bak)?" 
        read -p "(y/n):" choice
        case "$choice" in 
          y|Y ) cp ${config_location}/gestures.conf ${config_location}/gestures.conf.bak; cp gestures.conf ${config_location}; break;;
          n|N ) break;;
          * ) echo "Please answer y or n.";;
        esac
    done

fi
cp gestures.desktop ${autostart_location}

# add user to input group
sudo gpasswd -a $USER input

# kill others and start application
sudo pkill libinput-gestures
sudo pkill fusuma 
sudo pkill touchegg
${install_location}/gestures
