#!/usr/bin/env python3
import json
import sys
# Table of configuration commands
# https://stackoverflow.com/questions/19328605/update-values-for-multiple-keys-in-python

# gesture, finger, motion, spec
all_commands = {"swipe" : [{3 : {"left" : {"start" : "" , "update" : [{"motion" : "", "command" : ""}],  "end" : "", "rep" : None}}}]}
 
def get_conf(conffile):
    'Read given configuration file and store internal actions etc'
    with open(conffile, "r") as fp:
        json_string = ""
        for num, line in enumerate(fp, 1):
            line = line.strip()
            if not line or line[0] == '#':
                continue
            
            try:
                json_string += line.replace("'", "\"")
                #command = json.loads(json_string)
                #all_commands.update(command)
            except Exception as errmsg:
                sys.exit('Error at line {} in file {}:\n>> {} <<\n{}.'.format(
                    num, conffile, line, errmsg))        
        return(json.loads(json_string))

# print(all_commands)
# all_commands = get_conf("test.conf")
# print(all_commands)


#making this for this to be compatable with libinput-gestures
#most code from libinput-gestures
# conf_commands = OrderedDict()
# 
# def add_conf_command(func):
#     'Add configuration command to command lookup table based on name'
#     conf_commands[re.sub('^conf_', '', func.__name__)] = func
# 
# @add_conf_command
# def conf_gesture(lineargs):
#     'Process a single gesture line in conf file'
#     fields = lineargs.split(maxsplit=2)
# 
#     # Look for configured gesture. Sanity check the line.
#     if len(fields) < 3:
#         return 'Invalid gesture line - not enough fields'
# 
#     gesture, motion, command = fields
#     handler = handlers.get(gesture.upper())
# 
#     if not handler:
#         return 'Gesture "{}" is not supported.\nMust be "{}"'.format(
#                 gesture, '" or "'.join([h.lower() for h in handlers]))
# 
#     # Gesture command can be configured with optional specific finger
#     # count so look for that
# #    fingers, *fcommand = command.split(maxsplit=1)
# #    if fingers.isdigit() and len(fingers) == 1:
# #        command = fcommand[0] if fcommand else ''
# #    else:
# #        fingers = None
#     
# 
#     specs = {"start" : "" , "update" : [{"motion" : "", "command" : ""}],  "end" : "", "rep" : None}
#     #get fingers
#     fingers, fcommand = command.split(maxsplit=1)
#     if not fingers.isdigit():
#         fingers = None    
#     if fcommand[0] != "~": # how we are going to specify extra stuff is being used for this script 
#         specs["end"] =  fcommand if fcommand else ''
#    
#     json_string = fcommand[1:].replace("'", "\"")
#     specs = json.loads(json_string)
# 
#     # Add the configured gesture
#     all_commands[gesture][motion][fingers] = specs
#  
# @add_conf_command
# def conf_device(lineargs):
#     'Process a single device line in conf file'
#     # Command line overrides configuration file
#     if not args.device:
#         args.device = lineargs
# 
#     return None if args.device else 'No device specified'
# 
# @add_conf_command
# def swipe_threshold(lineargs):
#     'Change swipe threshold'
#     global swipe_min_threshold
#     try:
#         swipe_min_threshold = int(lineargs)
#     except Exception:
#         return 'Must be integer value'
# 
#     return None if swipe_min_threshold >= 0 else 'Must be >= 0'
# 
# @add_conf_command
# def timeout(lineargs):
#     'Change gesture timeout'
#     global timeoutv
#     try:
#         timeoutv = float(lineargs)
#     except Exception:
#         return 'Must be float value'
# 
#     return None if timeoutv >= 0 else 'Must be >= 0'
# 
# def get_conf_line(line):
#     'Process a single line in conf file'
#     key, *argslist = line.split(maxsplit=1)
# 
#     # Old format conf files may have a ":" appended to the key
#     key = key.rstrip(':')
#     conf_func = conf_commands.get(key)
# 
#     if not conf_func:
#         return 'Configuration command "{}" is not supported.\n' \
#                 'Must be "{}"'.format(key, '" or "'.join(conf_commands))
# 
#     return conf_func(argslist[0] if argslist else '')
# 
# def get_conf(conffile, confname):
#     'Read given configuration file and store internal actions etc'
#     with conffile.open() as fp:
#         for num, line in enumerate(fp, 1):
#             line = line.strip()
#             if not line or line[0] == '#':
#                 continue
# 
#             errmsg = get_conf_line(line)
#             if errmsg:
#                 sys.exit('Error at line {} in file {}:\n>> {} <<\n{}.'.format(
#                     num, confname, line, errmsg))
