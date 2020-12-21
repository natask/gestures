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
echo "Installing $(sed -n -e 'H;${x;s/\n/, /g;s/^,[ ]//;p;}' pkg_requirements)."
cat pkg_requirements | xargs -n 1 -I{} sh -c "echo; echo Installing {}; sudo ${pkgM} ${install} ${auto} {}"

## subprocess, shlex, threading, queue, time, os, sys, math  are builtin
## installs on global python
echo "Installing $(sed -n -e 'H;${x;s/\n/, /g;s/^,[ ]//;p;}' py_requirements)."
cat py_requirements | xargs -n 1 -I{} sh -c "echo; echo Installing {} through pip; sudo pip3 install {};"


echo ""
echo ""
# create locations if they don't exist.
if test ! -d "${config_location}"; then
        echo "creating ${config_location}"; mkdir -p ${config_location}
fi

if test ! -d "${autostart_location}"; then
        echo "creating ${autostart_location}"; mkdir -p ${autostart_location}
fi

if test ! -d "${install_location}"; then
        echo "creating ${install_location}"; mkdir -p ${install_location}
fi

echo ""
# place files in corresponding locations
echo "Placing gestures getConfig.py in ${install_location}."
sudo cp gestures getConfig.py ${install_location}

echo ""
echo ""
while true; do
    echo "Should I install utilities, $(ls -m utilities), in ${install_location}? Recommended for default operation."
    read -p "(y/n):" choice
    case "$choice" in 
        y|Y )  echo "Placing $(ls -m utilities) in ${install_location}.";sudo cp $(ls -d utilities/*) ${install_location}; break;;
      n|N ) echo "Skipping utilities placement."; break;;
      * ) echo "Please answer y or n.";;
    esac
done

echo ""
echo ""
if test -f "${config_location}/gestures.conf"; then
    while true; do
        echo "Config file exists. override (saves backup as gestures.conf.bak)?" 
        read -p "(y/n):" choice
        case "$choice" in
                y|Y )  echo "Would you like xdo-tool version (x or y) or evemu_do version (e or n)? xdo-tool version is recommended unless using wayland."
                        read -p "([x/y]do-tool/[e/n]vemu_do):" version
                        case "$version" in
                                x|X|y|Y ) echo "Placing xdo-tool version of config file in ${config_location} while making a temporary backup.";cp ${config_location}/gestures.conf ${config_location}/gestures.conf.bak; cp gestures_xdo_tool.conf ${config_location}/gestures.conf; break;;
                                e|E|n|N ) echo "Placing evemu_do version of config file in ${config_location} while making a temporary backup.";cp ${config_location}/gestures.conf ${config_location}/gestures.conf.bak; cp gestures_evemu_do.conf ${config_location}/gestures.conf; break;;
                        esac; break;;
          n|N ) echo "Skipping config file placement."; break;;
          * ) echo "Please answer y or n.";;
        esac
    done
else
                         echo "Would you like xdo-tool version (x or y) or evemu_do version (e or n)? xdo-tool version is recommended unless using wayland."
                        read -p "([x/y]do-tool/[e/n]vemu_do):" version
                        case "$version" in
                                x|X|y|Y ) echo "Placing xdo-tool version of config file in ${config_location}.";cp ${config_location}/gestures.conf ${config_location}/gestures.conf.bak; cp gestures_xdo_tool.conf ${config_location}/gestures.conf; break;;
                                e|E|n|N ) echo "Placing evemu_do version of config file in ${config_location}.";cp ${config_location}/gestures.conf ${config_location}/gestures.conf.bak; cp gestures_evemu_do.conf ${config_location}/gestures.conf; break;;
                        esac;
fi

echo ""
echo ""
echo "Placing desktop file in ${autostart_location}."
cp gestures.desktop ${autostart_location}

# add user to input group
echo "Adding user $USER to input group."
sudo gpasswd -a $USER input

# kill others and start application
echo "Starting gestures. Welcome!"
sudo pkill libinput-gestures
sudo pkill fusuma 
sudo pkill touchegg
${install_location}/gestures
