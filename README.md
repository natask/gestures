
# Table of Contents

1.  [Motivation](#org3ed3e14)
2.  [Features](#org76909f7)
3.  [Dependencies](#org50fa07c)
4.  [Installation/Uninstallation](#org6e9b870)
5.  [Alternatives](#org978a4f0)
6.  [TODOS](#orge02d31b)
    1.  [add customization <code>[0/3]</code>](#org66d74b2)
    2.  [enrich readme](#org0284234)
    3.  [Write script to fulfill dependencies automatically](#orga5c4f06)
    4.  [Implement C++ version](#org96f0297)

![img](gestures.gif "demonstrating fluid gestures, five finger gestures, tap gestures and touchscreen gestures")


<a id="org3ed3e14"></a>

# Motivation

-   I wanted an application that will allow me to fluidly express my intent through the touchpad and touchscreen.
-   I felt shackled by one-shot gestures from [libinput-gestures](https://github.com/bulletmark/libinput-gestures) but from it I found the utility of eight-directional gestures.
-   I felt [fusuma](https://github.com/iberianpig/fusuma) was lacking Although it was more fluid.
-   I really missed keeping my fingers moving across the touchpad to switch applications.
-   I wanted tap gestures.
-   I wanted five finger gestures.
-   I wanted usable gestures for my touchscreen.

So I wrote this.


<a id="org76909f7"></a>

# Features

-   **vanilla gestures:** features present in [libinput-gestures](https://github.com/bulletmark/libinput-gestures) and [fusuma](https://github.com/iberianpig/fusuma).
-   **5 finger gestures:** 

This means that you can place 5 fingers on the touchpad and that is recognized as another class of gestures. BTN<sub>TOOL</sub><sub>QUINTTAP</sub> must supported. This feature must supported by your driver + touchpad.
check by running `evtest /dev/input/$(cat /proc/bus/input/devices | grep -iA 5 'touchpad' |grep -oP 'event[0-9]+') | grep BTN_TOOL_QUINTTAP`. if it prints a line containing `"BTN_TOOL_QUINTTAP"`, your touchpad+driver support it.

-   **tap gestures:** 

This means that tapping the touchpad with 4 or 5 fingers is recognized as a gesture.

-   **Touchscreen gestures:** 

Extend gestures to touchscreen.

-   **Fluid gestures:** 

Allow the user to do different things without raising their fingers from the touchpad. This takes advantage of the fact that gesture execution is separated into 3 parts, start, update, and end, by doing complementary actions in each.

For example, assume the shortcut to switch windows is "CTRL + ALT" + direction, where direction is "LEFT", "RIGHT", "UP", "DOWN".

to switch windows fluidly, "CTRL + ALT" are held down programmatically on a start gesture event, then depending on which direction the user is swiping while fingers are still on the touchpad, dynamically generate direction commands. Then when the user raises their fingers, which is an end gesture event, the "CTRL + ALT" are released programmatically.


<a id="org50fa07c"></a>

# Dependencies

-   **python dependencies:** subprocess, pathlib, shlex, threading, queue, time, os, sys, math
-   **\*nix dependencies:** cat, grep
-   **dependencies:** stdbuf, evtest
    -   **evtest:** will maybe replaced by evemu-record in the future.
    -   **daemonize:** using `& disown` should work as well but this is a sure way to detach and run this on a global scale.
-   **default dependencies (if running default configuration):** -   **evemu:** need evemu-do (alternative to xdotool that I wrote) in $PATH.


<a id="org6e9b870"></a>

# Installation/Uninstallation

-   **installation:** -   run ./install.sh
        -   it should handle most things.
        -   may need to install `daemonize` by hand. If on Arch, I recommend `daemonize-git` from AUR.
        -   may want to look at where it places things and if that meets your setup.
-   **uninstallation:** -   run ./uninstall.sh
    -   removes everything except that what was installed by the package manager. To uninstall those, remove `evtest` and `daemonize`.


<a id="org978a4f0"></a>

# Alternatives

-   **[libinput-gestures](https://github.com/bulletmark/libinput-gestures):** -   what I used to use.
    -   Works well, just that the gestures are one-shot, meaning that the command attached to a gesture is executed only once per full swipe.
    -   depends on libinput.
-   **[fusuma](https://github.com/iberianpig/fusuma):** -   Although it doesn't have one-shot limitation, it didn't support commands to run when the gesture begins and ends. This is useful for use-cases like switching applications which require alt-down to be pressed.
    -   didn't support eight-directional gestures.


<a id="orge02d31b"></a>

# TODOS



<a id="org66d74b2"></a>

## NEXT add customization <code>[0/3]</code>

-   [-] enable customization by refactoring code.
    -   [X] commands for gesture start
    -   [ ] commands for gesture update
    -   [ ] commands for gesture end
    -   [ ] rep rate
    -   [ ] detach implementation from personal workflow
-   [ ] use [libinput-gestures ](https://github.com/bulletmark/libinput-gestures)config file syntax.
-   [ ] use [fusuma](https://github.com/iberianpig/fusuma) config file syntax.


<a id="org0284234"></a>

## DONE enrich readme


<a id="orga5c4f06"></a>

## DONE Write script to fulfill dependencies automatically


<a id="org96f0297"></a>

## TODO Implement C++ version

