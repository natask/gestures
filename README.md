
# Table of Contents

1.  [Motivation](#orgd0b4224)
2.  [Features](#org130ead3)
3.  [Dependencies](#orgec9fd5f)
4.  [Installation/Uninstallation](#org57018b8)
5.  [Customization](#org875c473)
6.  [Alternatives](#orga5241ea)
7.  [TODOS](#org4d901d6)
    1.  [add features <code>[0/2]</code>](#orgcf21f93)
    2.  [enrich readme](#orgb6e2d3c)
    3.  [Write script to fulfill dependencies automatically](#orgbfeee1b)
    4.  [Implement C++ version](#orgf4a1a06)

![img](gestures.gif "demonstrating fluid gestures, five finger gestures, tap gestures and touchscreen gestures")


<a id="orgd0b4224"></a>

# Motivation

-   I wanted an application that will allow me to fluidly express my intent through the touchpad and touchscreen.
-   I felt shackled by one-shot gestures from [libinput-gestures](https://github.com/bulletmark/libinput-gestures) but from it I found the utility of eight-directional gestures.
-   I felt [fusuma](https://github.com/iberianpig/fusuma) was lacking Although it was more fluid.
-   I really missed keeping my fingers moving across the touchpad to switch applications.
-   I wanted tap gestures.
-   I wanted five finger gestures.
-   I wanted usable gestures for my touchscreen.

So I wrote this.


<a id="org130ead3"></a>

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


<a id="orgec9fd5f"></a>

# Dependencies

-   **python dependencies:** subprocess, pathlib, shlex, threading, queue, time, os, sys, math
-   **\*nix dependencies:** cat, grep
-   **dependencies:** stdbuf, evtest
    -   **evtest:** will maybe replaced by evemu-record in the future.
    -   **daemonize:** using `& disown` should work as well but this is a sure way to detach and run this on a global scale.
-   **default dependencies (if running default configuration):** -   **evemu:** need evemu-do (alternative to xdotool that I wrote) in $PATH.


<a id="org57018b8"></a>

# Installation/Uninstallation

-   **installation:** -   run ./install.sh
        -   it should handle most things.
        -   may need to install `daemonize` by hand. If on Arch, I recommend `daemonize-git` from AUR.
        -   may want to look at where it places things and if that meets your setup.
-   **uninstallation:** -   run ./uninstall.sh
    -   removes everything except that what was installed by the package manager. To uninstall those, remove `evtest` and `daemonize`.


<a id="org875c473"></a>

# Customization

-   **currently customizable:** 

-   swipe, pinch
-   3,4,5 finger start and end gestures

-   **example:** 

    {'swipe': {
        '3': {
            'l' : {'start': ['evemu_do alt down', 'evemu_do tab'], 'update': {'l': [], 'r': [], 'u': [], 'd': [], 'lu': [], 'rd': [], 'ld': [], 'ru': []}, 'end': ['evemu_do alt up'], 'rep': ''}
        }
    }
    }

-   **breakdown:** 

-   **(swipe,pinch):** -   define if the gesture is a swipe or a pinch
-   **(3,4,5):** -   define the number of fingers to activate the gesture
-   **('t', 'l', 'r',&#x2026;,'ru'):** define tap and the 8 directions a swipe can be in.
-   **(start,end):** -   what to do when the gesture starts or ends.
-   **(slated for a future update):** 

-   **(update):** -   what to do when the gesture is on going. going to start out with just 4 directions as that suffices my needs (and probably most others) but will expand to 8 directional configuration should there be demand.
-   **(rep):** -   how frequently is gesture update run. can make this directional as well, but don't have plans for that yet.
-   **(touchscreen, touchpad (even device level tag)):** to specify what a specific set of gestures apply to.


<a id="orga5241ea"></a>

# Alternatives

-   **[libinput-gestures](https://github.com/bulletmark/libinput-gestures):** -   what I used to use.
    -   Works well, just that the gestures are one-shot, meaning that the command attached to a gesture is executed only once per full swipe.
    -   depends on libinput.
-   **[fusuma](https://github.com/iberianpig/fusuma):** -   Although it doesn't have one-shot limitation, it didn't support commands to run when the gesture begins and ends. This is useful for use-cases like switching applications which require alt-down to be pressed.
    -   didn't support eight-directional gestures.


<a id="org4d901d6"></a>

# TODOS



<a id="orgcf21f93"></a>

## TODO add features <code>[0/2]</code>

-   [-]<code>[2/7]</code> enable customization by refactoring code.
    -   [X] commands for gesture start
    -   [X] commands for gesture end
    -   [ ] commands for touchscreen
    -   [ ] commands for gesture update
    -   [ ] rep rate
    -   [ ] detach implementation from personal workflow
    -   [ ] more nuanced application of gestures to different attached devices
-   [ ] use [libinput-gestures ](https://github.com/bulletmark/libinput-gestures)config file syntax.
-   [ ] use [fusuma](https://github.com/iberianpig/fusuma) config file syntax.


<a id="orgb6e2d3c"></a>

## DONE enrich readme


<a id="orgbfeee1b"></a>

## DONE Write script to fulfill dependencies automatically


<a id="orgf4a1a06"></a>

## TODO Implement C++ version

