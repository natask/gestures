<p align="center">

<h1 align="center"><b>Gestures</b></h1>

<p align="center"><b>Gesture Application for Linux supporting up to 5 finger gestures on Touchscreen and Touchpad.</b></p>

<p align="center">

<img src="https://img.shields.io/github/license/natask/gestures">

<img src="https://img.shields.io/github/repo-size/natask/gestures">

<img src="https://img.shields.io/github/languages/top/natask/gestures">

<br>

<img src="https://img.shields.io/github/issues/natask/gestures">

<img src="https://img.shields.io/github/issues-closed/natask/gestures">

<img src="https://img.shields.io/github/v/release/natask/gestures?sort=semver">

</p>

</p>


# Table of Contents

1.  [Motivation](#orgaf5849b)
2.  [Features](#orgbcf9726)
3.  [Dependencies](#org302f373)
4.  [Installation/Uninstallation](#orgbf76685)
5.  [Customization](#org913325a)
6.  [Debugging](#orgc74900e)
7.  [Compatibility](#org3e72a58)
8.  [The Code](#orgc163661)
9.  [Alternatives](#org8196bbf)
10. [Thoughts](#org1116dfa)
11. [Versioning](#org96c52ef)
12. [<code>[3/8]</code> TODOS](#orga80ebe5)
    1.  [<code>[5/9]</code> enable customization by refactoring code.](#org9e9aafc)
        1.  [commands for gesture start](#org957d429)
        2.  [commands for gesture end](#org32ea67c)
        3.  [commands for touchscreen](#orgd3a404b)
        4.  [commands for gesture update](#orgb8547d5)
        5.  [rep rate](#orgeee76e8)
        6.  [add multi-finger pinch gestures](#org45801db)
        7.  [detach implementation from personal workflow](#org99dffe0)
        8.  [more nuanced application of gestures to different attached devices](#orga1fc416)
        9.  [add debugging notes about fixing config file (use online JSON linter if the interal JSON linter doesn't lead to debug point)"](#orgdaa7b4b)
    2.  [ask before doing stuff in installation and uninstallation scripts](#orgb33a1f0)
    3.  [<code>[1/3]</code> configuration syntax](#org8ad18aa)
        1.  [implement JSON config file support.](#orga8dfb0c)
        2.  [use libinput-gestures config file syntax.](#org88279e9)
        3.  [use fusuma config file syntax.](#orgbcde194)
    4.  [Create a standalone input device for this application](#org4924a94)
    5.  [enrich readme](#orga8d8b24)
    6.  [Write script to fulfill dependencies automatically](#org3e097c8)
    7.  [Include error handling for mistakes in config file](#orgec9ea9a)
    8.  [Implement C++ version](#org28ac510)

![img](gestures.gif "Demonstrating fluid gestures, five finger gestures, tap gestures and touchscreen gestures")


<a id="orgaf5849b"></a>

# Motivation

-   I wanted an application that will allow me to fluidly express my intent through the touchpad and touchscreen.
-   I felt shackled by one-shot gestures from [libinput-gestures](https://github.com/bulletmark/libinput-gestures) but from it I found the utility of eight-directional gestures.
-   I felt [fusuma](https://github.com/iberianpig/fusuma) was lacking Although it was more fluid.
-   I really missed keeping my fingers moving across the touchpad to switch applications.
-   I wanted tap gestures.
-   I wanted five finger gestures.
-   I wanted usable gestures for my touchscreen.

So I wrote this.


<a id="orgbcf9726"></a>

# Features

-   **Vanilla gestures:** features present in [libinput-gestures](https://github.com/bulletmark/libinput-gestures) and [fusuma](https://github.com/iberianpig/fusuma).
-   **5 finger gestures:** This means that you can place 5 fingers on the touchpad and that is recognized as another class of gestures. BTN<sub>TOOL</sub><sub>QUINTTAP</sub> must supported. This feature must supported by your driver + touchpad.
    check by running `evtest /dev/input/$(cat /proc/bus/input/devices | grep -iA 5 'touchpad' |grep -oP 'event[0-9]+') | grep BTN_TOOL_QUINTTAP`. if it prints a line containing `"BTN_TOOL_QUINTTAP"`, your touchpad+driver support it.
-   **Tap gestures:** This means that tapping the touchpad with 4 or 5 fingers is recognized as a gesture.
-   **Touchscreen gestures:** Extend gestures to touchscreen.
-   **Fluid gestures:** Allow the user to do different things without raising their fingers from the touchpad. This takes advantage of the fact that gesture execution is separated into 3 parts, start, update, and end, by doing complementary actions in each.
    
    For example, assume the shortcut to switch windows is "CTRL + ALT" + direction, where direction is "LEFT", "RIGHT", "UP", "DOWN".
    
    to switch windows fluidly, "CTRL + ALT" are held down programmatically on a start gesture event, then depending on which direction the user is swiping while fingers are still on the touchpad, dynamically generate direction commands. Then when the user raises their fingers, which is an end gesture event, the "CTRL + ALT" are released programmatically.
-   **Orientation adjustment:** -   using the script `orientation`, can figure out the orientation of screen to adjust both touchscreen and touchpad gestures. Script needs to be restarted for updates to take effect.
-   **Compatibility with both X11 and Wayland:** -   works on wayland as well as X11 if using the default keystroke generator. The keystroke generator, `evemu_d0` is based on `evemu` and injects keyboard events directly into a connected device. In the future, may create an input device solely for this application.


<a id="org302f373"></a>

# Dependencies

-   **python dependencies (>=3.6):** subprocess, pathlib, simplejson, shlex, threading, queue, time, os, sys, math
-   **\*nix dependencies:** cat, grep
-   **dependencies:** stdbuf, evtest
    -   **evtest:** will maybe replaced by evemu-record in the future.
    -   **daemonize:** using `& disown` should work as well but this is a sure way to detach and run this on a global scale.
    -   **xrandr:** used by `orientation` for orientation detection.
-   **default dependencies (if running default configuration):** -   **evemu:** need evemu-do (alternative to xdotool that I wrote) in $PATH.


<a id="orgbf76685"></a>

# Installation/Uninstallation

-   **installation:** -   run ./install.sh
        -   it should handle most things.
        -   may need to install `daemonize` by hand. If on Arch, I recommend `daemonize-git` from AUR.
        -   may want to look at where it places things and if that meets your setup.
        -   adds user to the input group.
        -   what you truly need from this repo are gestures.config, gestures, getConfig.py. Everything else is just dependencies.
        -   asks to replace config file if found. Saves a backup as default to avoid pain.
-   **uninstallation:** -   run ./uninstall.sh
    -   removes everything except that what was installed by the package manager. To uninstall those, remove `evtest` and `daemonize`.
    -   removes user from input group.
    -   asks before doing removing user from input group and specially deleting config file as it could be costly.


<a id="org913325a"></a>

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

-   **my setup:** -   **touchpad:** -   **2 finger:** -   2 finger pinch in and pinch out to zoom in and out (ctrl+plus and ctrl+minus)
        -   **3 finger:** -   3 finger horizontal to switch applications (alt + tab + DIRECTION)
            -   3 finger vertical to maximize/unmaximize application (super + i)
            -   3 finger // slanted gesture to change tabs (ctrl + page<sub>up</sub> and ctrl + page<sub>down</sub>)
            -   3 finger \\\\ slanted gestures to open and close tabs (ctrl+shift+t and ctrl+w)
        -   **4 finger:** -   4 finger tap to open workspace view (super + w)
            -   4 finger horizontal and vertical to switch work-spaces (Ctrl + alt + DIRECTION)
            -   4 finger // slanted gestures to go through history (Alt + DIRECTION)
            -   4 finger \\\\ slanted gestures to open and close windows (CTRL+shift+N and script to close application)
        -   **5 finger:** -   5 finger tap to open dictionary (goldendict)
            -   5 finger one shot gestures for doing a whole slew of things (a variety of scripts and applications)
    -   **touchpscreen:** -   same as touchpad except don't use pinch in and pinch out. just use regular. I also scale the screen so that an equivalent gesture on the touchscreen is much larger (as the screen is larger than the touchpad) than that of the touchpad. This provides consistency and a pleasant user experience.

-   **currently customizable:** -   swipe, pinch
    -   3,4,5 finger start and end gestures
    -   3,4 finger update gestures but tailored to my workflow (currently only "left" ("l") and "left down" ("ld"),  can be customized to do update gestures)
        -   still has limitations in terms of customizability since it is tailored for my workflow.
    -   2 finger fully customize pinch in/out gestures
    -   specific gestures for touchpad and touchscreen
-   **example:** {'touchpad': 
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
-   **breakdown:** -   **(touchscreen, touchpad):** -   make a set of gestures apply to touchpad or touchscreen
    -   **(swipe,pinch):** -   define if the gesture is a swipe or a pinch
    -   **(3,4,5):** -   define the number of fingers to activate the gesture
    -   **('t', 'l', 'r',&#x2026;,'ru'):** define tap and the 8 directions a swipe can be in.
    -   **('i', 'o'):** define pinch in and pinch out.
    -   **(start,end):** -   what to do when the gesture starts or ends.
    -   **(slated for a future update):** -   **(update):** -   what to do when the gesture is on going. going to start out with just 4 directions as that suffices my needs (and probably most others) but will expand to 8 directional configuration should there be demand.
        -   **(rep):** -   how frequently is gesture update run. can make this directional as well, but don't have plans for that yet.
        -   **(device level tag):** -   can already have gestures apply to touchscreen or touchpad. the extension to specify what device a specific set of gestures apply to.


<a id="orgc74900e"></a>

# Debugging

-   **Debugging script:** running the script with anything after it in the terminal will run it without using demonize. Which is to  say that all errors will be logged out to terminal.
    e.g
    
        gestures debug
-   **Syntactic issues in Config file:** -   There are times when the builtin syntax checker for the config file, simplejson, doesn't point to the correct place where a syntax error occurred within the config file. In such occasions use an online JSON linter. Those tend to work.
    -   To use them though, will need to remove all comments and change `"" to ''` from the config file. run the following code in a python shell to get a valid version.
        
            'Read given configuration file and store internal actions etc'
            import os
            conffile = os.path.expanduser("~/.config/gestures.conf")
            with open(conffile, "r") as fp:
                lines = []
                linenos = []
                for num, line in enumerate(fp, 1):
                    if not line or line[0] == '#':
                        continue
                    lines.append(line.replace("'", "\""))
                    linenos.append(num)
                print("".join(lines))


<a id="org3e72a58"></a>

# Compatibility

-   **X11:** -   works fine.
    -   may need to modify `orientation` if it is not tracking the screen with a touchscreen/touchpad.
-   **wayland:** -   works if using my script `evemu_do` to generate keystrokes.
    -   `orientation` may not work on wayland since it depends on xrandr although I haven't tested myself.


<a id="orgc163661"></a>

# The Code

-   may need to adjust the screen size and touchpad calibration. This can be automated by looking at the dimensions as evtest is called.
-   the knobs are as follows
    
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


<a id="org8196bbf"></a>

# Alternatives

-   **[libinput-gestures](https://github.com/bulletmark/libinput-gestures):** -   what I used to use.
    -   Works well, just that the gestures are one-shot, meaning that the command attached to a gesture is executed only once per full swipe.
    -   depends on libinput.
-   **[fusuma](https://github.com/iberianpig/fusuma):** -   Although it doesn't have one-shot limitation, it didn't support commands to run when the gesture begins and ends. This is useful for use-cases like switching applications which require alt-down to be pressed.
    -   didn't support eight-directional gestures.


<a id="org1116dfa"></a>

# Thoughts

-   **final version:** the current implementation suits my use case very well so I am in no hurry to customize. With that said, I would like to implement a fully customizable version of this. A C++ version would be good as well although current performance is more than enough.

something like nested gestures will be intersting where swipes are nested in a hierarchy. for example, swiping left, then right then up is integrated differently than swiping left then right then down. At this point though I think improvements like this only have diminishing marginal returns so I will not pursue them.


<a id="org96c52ef"></a>

# Versioning

-   this will be based upon Major and Minor completions in [12](#orga80ebe5).


<a id="orga80ebe5"></a>

# TODO <code>[3/8]</code> TODOS



<a id="org9e9aafc"></a>

## TODO <code>[5/9]</code> enable customization by refactoring code.


<a id="org957d429"></a>

### DONE commands for gesture start


<a id="org32ea67c"></a>

### DONE commands for gesture end


<a id="orgd3a404b"></a>

### DONE commands for touchscreen


<a id="orgb8547d5"></a>

### DONE commands for gesture update


<a id="orgeee76e8"></a>

### TODO rep rate


<a id="org45801db"></a>

### TODO add multi-finger pinch gestures


<a id="org99dffe0"></a>

### TODO detach implementation from personal workflow


<a id="orga1fc416"></a>

### TODO more nuanced application of gestures to different attached devices


<a id="orgdaa7b4b"></a>

### DONE add debugging notes about fixing config file (use online JSON linter if the interal JSON linter doesn't lead to debug point)"


<a id="orgb33a1f0"></a>

## DONE ask before doing stuff in installation and uninstallation scripts


<a id="org8ad18aa"></a>

## TODO <code>[1/3]</code> configuration syntax


<a id="orga8dfb0c"></a>

### DONE implement JSON config file support.


<a id="org88279e9"></a>

### TODO use [libinput-gestures ](https://github.com/bulletmark/libinput-gestures)config file syntax.


<a id="orgbcde194"></a>

### TODO use [fusuma](https://github.com/iberianpig/fusuma) config file syntax.


<a id="org4924a94"></a>

## TODO Create a standalone input device for this application

`evemu_do` injects keystroke events in existing connected input device. Attaching it to a standalone input device will be useful.


<a id="orga8d8b24"></a>

## DONE enrich readme


<a id="org3e097c8"></a>

## DONE Write script to fulfill dependencies automatically


<a id="orgec9ea9a"></a>

## TODO Include error handling for mistakes in config file

There is already error handling for syntactic issues of the config file.
But as noted in [this issue](https://github.com/natask/gestures/issues/2), error handling for incorrect proprieties within config is currently nonexistent. More 
specifically, lines such as 

    self.gesture_queue.extend(map(lambda x: shlex.split(x), self.gestures["swipe"]['5']['u']['end']));

do no error checking on whether proprieties "swipe", "5", "u" or "end" actually exist within the config file.


<a id="org28ac510"></a>

## TODO Implement C++ version

