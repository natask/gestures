#!/bin/bash 
install_location=/usr/local/bin
config_location=~/.config
autostart_location=~/.config/autostart

# detect distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    OS=Debian
    VER=$(cat /etc/debian_version)
else
    ...
fi

# uninstall requirements
case $OS in
    openSUSE*) 
        pkgM=zypper;;
    Debain*)
        pkgM=apt-get;;
    Ubuntu*)
        pkgM=apt-get;;
    Fedora*)
        pkgM=dnf;;
    CentOS*)
        pkgM=yum;;
    *)
        pkgM=$( command -v pamac || command -v pacman ) || echo "package manager not found"
esac

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

# filter package list by distro
# ATTENTION: needs further work, currently only openSUSE and non-openSUSE.
case $OS in
    openSUSE*)
        cat ./pkg_requirements | grep openSUSE | awk '{ print $1 }' > PKG_REQ_LIST;;
    *)
        cat ./pkg_requirements | grep ALL | awk '{ print $1 }' > PKG_REQ_LIST;;
esac


## subprocess, shlex, threading, queue, time, os, sys, math  are builtin
## uninstalls on global python
echo "Uninstalling $(sed -n -e 'H;${x;s/\n/, /g;s/^,[ ]//;p;}' py_requirements)."
xargs -d"\n" -n 1 -I{} -ra <( cat py_requirements ) sh -c "echo; echo Uninstalling {} through pip; sudo pip3 uninstall {};"

## cat, stdbuf are builtin, may need to install daemonize by hand
echo "Uninstalling $(sed -n -e 'H;${x;s/\n/, /g;s/^,[ ]//;p;}' PKG_REQ_LIST)."
xargs -d"\n" -n 1 -I{} -ra <( cat PKG_REQ_LIST ) sh -c "echo; echo Uninstalling {}; sudo ${pkgM} ${uninstall} {}"

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
echo "Removing placed files gestures, getConfig.py, $(ls -m utilities) from ${install_location}."
sudo rm -i ${install_location}/gestures 
sudo rm -i ${install_location}/getConfig.py
xargs -I {} -d"\n" -n 1 -ra <( ls utilities ) sudo rm -i ${install_location}/{}
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

