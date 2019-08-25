  # messaging protcol
* have main loop send updates as queues
 - three types
   + finger_start : called when a new finger verifies both its x and y coordinates (merged with finger_add  : called when a new finger is touches to touchpad)
   + finger_update: called when a finger updates x and y after verification
   + finger_remove: called when a finger is removed from touchpad

# event consiquences
## finger_start
* end gesture
  * signify end of a started gesture
  * restart gesture params
  * restart debounce
* initiate state for new finger
* increment counter for number of fingers started which signfies current gesture level

## finger_update
* update state for updated finger
* pick which type of guesture is currenlty executing after all fingures have been verified
* inqueue gesture to run

## finger_remove
* end gesture
  * signify end of a started gesture
  * restart gesture params
  * restart debounce
* execute tap based gesture if any other gesture had not been started
* update state to reflect removed finger

# main run loop
* get messages(dequeue from message queue) and do approperate action
* dequeue from gesture queue and execute after debounce times out

# factor to run on all devices
* can calculate the factor number from the size of the x and y, check how it scales down to touchpad
* for now set manually

# all guestures to implement
## holy grail feature
* finger/s specific tap, swipe and pinch while any number of fingers are resting on the touchpad which are used as modifiers

## for now
* swipe in the 8 different directions with all 3, 4 and 5 fingers
* tap with all 4, and 5 fingers
* maybe pinch clockwize and counterclockwize?
* pin in and out with all 2,3, 4, 5 fingers
* maybe pinch clockwize and counterclockwize?

## to do
* pinch guestures
* HOLY GRAIL: finger/s specific tap, swipe and pinch while any number of fingers are resting on the touchpad which are used as modifiers


# comments
* the desgin was a sucess
  * big lesson is that you really need OS + window enviroment + window manager support to smoothly implement features
