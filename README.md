
# Table of Contents

1.  [Motivation](#org74a04f4)
2.  [Features](#org0e8bbf6)
3.  [Dependencies](#org8ac1a9a)
4.  [Installation/Uninstallation](#org1bf7aa5)
5.  [Customization](#orgcd71d4c)
6.  [The Code](#orgcb0af08)
7.  [Alternatives](#orgce52aa6)
8.  [Thoughts](#org7647c54)
9.  [TODOS](#org17188fd)
    1.  [add features <code>[0/3]</code>](#org763865f)
    2.  [enrich readme](#orgc91a837)
    3.  [Write script to fulfill dependencies automatically](#orga04247d)
    4.  [Implement C++ version](#org4e52207)

![img](gestures.gif "demonstrating fluid gestures, five finger gestures, tap gestures and touchscreen gestures")


<a id="org74a04f4"></a>

# Motivation

-   I wanted an application that will allow me to fluidly express my intent through the touchpad and touchscreen.
-   I felt shackled by one-shot gestures from [libinput-gestures](https://github.com/bulletmark/libinput-gestures) but from it I found the utility of eight-directional gestures.
-   I felt [fusuma](https://github.com/iberianpig/fusuma) was lacking Although it was more fluid.
-   I really missed keeping my fingers moving across the touchpad to switch applications.
-   I wanted tap gestures.
-   I wanted five finger gestures.
-   I wanted usable gestures for my touchscreen.

So I wrote this.


<a id="org0e8bbf6"></a>

# Features

-   **vanilla gestures:** 
   - features present in [libinput-gestures](https://github.com/bulletmark/libinput-gestures) and [fusuma](https://github.com/iberianpig/fusuma).
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


<a id="org8ac1a9a"></a>

# Dependencies

-   **python dependencies (>=3.6):** subprocess, pathlib, simplejson, shlex, threading, queue, time, os, sys, math
-   **\*nix dependencies:** cat, grep
-   **dependencies:** stdbuf, evtest
    -   **evtest:** will maybe replaced by evemu-record in the future.
    -   **daemonize:** using `& disown` should work as well but this is a sure way to detach and run this on a global scale.
-   **default dependencies (if running default configuration):** 
    -   **evemu:** need evemu-do (alternative to xdotool that I wrote) in $PATH.


<a id="org1bf7aa5"></a>

# Installation/Uninstallation

-   **installation:** -   run ./install.sh
        -   it should handle most things.
        -   may need to install `daemonize` by hand. If on Arch, I recommend `daemonize-git` from AUR.
        -   may want to look at where it places things and if that meets your setup.
        -   adds user to the input group.
        -   what you truly need from this repo are gestures.conf, gestures, getConfig.py. Everything else is just dependencies.
        -   asks to replace config file if found. Saves a backup as default to avoid pain.
-   **uninstallation:** -   run ./uninstall.sh
    -   removes everything except that what was installed by the package manager. To uninstall those, remove `evtest` and `daemonize`.
    -   removes user from input group.
    -   asks before doing removing user from input group and specially deleting config file as it could be costly.


<a id="orgcd71d4c"></a>

# Customization

-   **default customization:** -   the default customization is my config.
    -   uses extensively `evemu_do`, a script I wrote to replace `xdotool`. Much less buggy and also works on wayland.
    -   `evemu_do` works much like xdotool but only for keyboard inputs.
        -   `evemu_do tab` presses tab (also supports `evemu_do key tab`)
        -   `evemu_do keydown tab` holds down tab
        -   `evemu_do keyup tab` de-presses tab
        -   also supports deprecated commands like `evemu_do tab down` and `evemu_do tab up` that hold down and de-presse tab respectively.
    -   currently works by dumping events in the first keyboard it finds under /proc/bus/input/devices.
        -   may look into creating a keyboard device for it to dump all its events on.
    -   underneath it uses `evemu-event`, which is part of the `evemu` toolkit.
    -   needs access to input group.

-   **my setup:** 
   -   **touchpad:**
        -   **2 finger:**
            -   2 finger pinch in and pinch out to zoom in and out (ctrl+plus and ctrl+minus)
        -   **3 finger:** 
            -   3 finger horizontal to switch applications (alt + tab + DIRECTION)
            -   3 finger vertical to maximize/unmaximize application (super + i)
            -   3 finger // slanted gesture to change tabs (ctrl + page<sub>up</sub> and ctrl + page<sub>down</sub>)
            -   3 finger \\\\ slanted gestures to open and close tabs (ctrl+shift+t and ctrl+w)
        -   **4 finger:**
            -   4 finger tap to open workspace view (super + w)
            -   4 finger horizontal and vertical to switch work-spaces (Ctrl + alt + DIRECTION)
            -   4 finger // slanted gestures to go through history (Alt + DIRECTION)
            -   4 finger \\\\ slanted gestures to open and close windows (CTRL+shift+N and script to close application)
        -   **5 finger:**
            -   5 finger tap to open dictionary (goldendict)
            -   5 finger one shot gestures for doing a whole slew of things (a variety of scripts and applications)
    -   **touchpscreen:** 
        -   same as touchpad except don't use pinch in and pinch out. just use regular. I also scale the screen so that an equivalent gesture on the touchscreen is much larger (as the screen is larger than the touchpad) than that of the touchpad. This provides consistency and a pleasant user experience.

-   **currently customizable:** 
    -   swipe, pinch
    -   3,4,5 finger start and end gestures
    -   3,4 finger update gestures but tailored to my workflow (currently only "left" ("l") and "left down" ("ld"),  can be customized to do update gestures)
        -   still has limitations in terms of customizability since it is tailored for my workflow.
    -   2 finger fully customize pinch in/out gestures
    -   specific gestures for touchpad and touchscreen
-   **example:**
```
 {'touchpad': 
         {'swipe': {
             '3': {
                 'l' : {'start': ['evemu_do keydown alt', 'evemu_do tab'], 'update': {'l': ["evemu_do Left"], 'r': ["evemu_do Right"], 'u': ["evemu_do Up"], 'd': ["evemu_do Down"], 'lu': [], 'rd': [], 'ld': [], 'ru': []}, 'end': ['evemu_do keyup alt'], 'rep': ''},
             }
         },
          'pinch': {
              '2': {
                  'i' : {'start': ['evemu_do keydown control', 'evemu_do equal'], 'update': {'i': ['evemu_do plus'], 'o': ['evemu_do minus']}, 'end': ['evemu_do keyup ctrl'], 'rep': ''},
                  'o' : {'start': ['evemu_do keydown control', 'evemu_do minus'], 'update': {'i': ['evemu_do plus'], 'o': ['evemu_do minus']}, 'end': ['evemu_do keyup ctrl'], 'rep': ''}
              }
          }
         }
   ```
-   **breakdown:**
    -   **(touchscreen, touchpad):**
       -   make a set of gestures apply to touchpad or touchscreen
    -   **(swipe,pinch):** 
       -   define if the gesture is a swipe or a pinch
    -   **(3,4,5):** 
       -   define the number of fingers to activate the gesture
    -   **('t', 'l', 'r',&#x2026;,'ru'):** define tap and the 8 directions a swipe can be in.
    -   **('i', 'o'):** define pinch in and pinch out.
    -   **(start,end):**
        -   what to do when the gesture starts or ends.
    -   **(slated for a future update):** 
        -   **(update):** 
            -   what to do when the gesture is on going. going to start out with just 4 directions as that suffices my needs (and probably most others) but will expand to 8 directional configuration should there be demand.
        -   **(rep):** 
            -   how frequently is gesture update run. can make this directional as well, but don't have plans for that yet.
        -   **(device level tag):** 
            -   can already have gestures apply to touchscreen or touchpad. the extension to specify what device a specific set of gestures apply to.


<a id="orgcb0af08"></a>

# The Code

-   may need to adjust the screen size and touchpad calibration. This can be automated by looking at the dimensions as evtest is called.
-   the knobs are as follows
```
    TOUCHPAD_CALIBRATION = 1 # scaling down for touchpad movements
    TOUCHSCREEN_CALIBRATION = 2 # scaling down for touchscreen movements
    
    DECISION = 450 # sufficient movement to make decision on direction
    PINCH_DECISION = 160 #seems like x_cum and y_cum should got to around 0 if finges moved symetrically in or out  #sufficient momvent to make pinch
    
    ANGLE = 70 #x/y angle cleance
    CLEARANCE = 10#clearance for not intrepreting swipes between diagonal and horizontal or vertical
    
    DEBOUNCE = 0.04  #sleep for now 40 ms, fastest tap around 25 ms , gotten from new_touch, touchpad data. in practice works well.
    THRESHOLD = 150 # threashold to be considered a move, squared sum of x and y
    PINCH_THRESHOLD = 100
    
    REP_THRES = 0.2 #need to break this TIME before REP engage
    REP = 350 # for 3 finger stuff
    REP_3 = 150 # for 3 finger stuff
    REP_4x= 450 # for 4 finger x, was having issue with horizontal swipes overstepping but vertical ones being perdicatable
    REP_4 = 450 # for 4 finger stuff; repeat after this much x,y movement
    PINCH_REP = 40
```

<a id="orgce52aa6"></a>

# Alternatives

-   **[libinput-gestures](https://github.com/bulletmark/libinput-gestures):** -   what I used to use.
    -   Works well, just that the gestures are one-shot, meaning that the command attached to a gesture is executed only once per full swipe.
    -   depends on libinput.
-   **[fusuma](https://github.com/iberianpig/fusuma):** -   Although it doesn't have one-shot limitation, it didn't support commands to run when the gesture begins and ends. This is useful for use-cases like switching applications which require alt-down to be pressed.
    -   didn't support eight-directional gestures.


<a id="org7647c54"></a>

# Thoughts

-   **final version:** the current implementation suits my use case very well so I am in no hurry to customize. With that said, I would like to implement a fully customizable version of this. A C++ version would be good as well although current performance is more than enough.

something like nested gestures will be intersting where swipes are nested in a hierarchy. for example, swiping left, then right then up is integrated differently than swiping left then right then down. At this point though I think improvements like this only have diminishing marginal returns so I will not pursue them.


<a id="org17188fd"></a>

# TODOS



<a id="org763865f"></a>

## TODO add features <code>[0/3]</code>

-   [-]<code>[4/7]</code> enable customization by refactoring code.
    -   [X] commands for gesture start
    -   [X] commands for gesture end
    -   [X] commands for touchscreen
    -   [X] commands for gesture update
    -   [ ] rep rate
    -   [ ] detach implementation from personal workflow
    -   [ ] more nuanced application of gestures to different attached devices
-   [X] ask before doing stuff 
-   [ ] use [libinput-gestures ](https://github.com/bulletmark/libinput-gestures)config file syntax.
-   [ ] use [fusuma](https://github.com/iberianpig/fusuma) config file syntax.


<a id="orgc91a837"></a>

## DONE enrich readme


<a id="orga04247d"></a>

## DONE Write script to fulfill dependencies automatically


<a id="org4e52207"></a>

## TODO Implement C++ version

