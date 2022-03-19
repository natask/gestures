#!/usr/bin/env python3
import json

ERR_PRINT = 5;
def get_conf(conffile):
    'Read given configuration file and store internal actions etc'
    with open(conffile, "r") as fp:
        lines = []
        linenos = []
        for num, line in enumerate(fp, 1):
            if not line or line[0] == '#':
                continue
            lines.append(line.replace("'", "\""))
            linenos.append(num)
        try:
            return(json.loads("".join(lines)))
        except Exception as e: 
            print("Error with loading gestures config.")
            print("This is probably caused by not observing configuration syntax.")
            print("Check if your configuration is a valid JS object (JSON).")
            print()
            print("problem at {0} line number, and {1} column.".format(linenos[e.lineno - 2], e.colno))
            print(e.msg, "or '{'")
            print()
            for num in range(e.lineno - ERR_PRINT, e.lineno - 1, 1):
                print("line ", linenos[num],": ", end="")
                if(num  >= e.lineno - 3):
                    print("Error somewhere on this lines => ", end="")
                print("\"",lines[num][:-1],"\"") # array offset
            raise Exception('error with loading gestures config.')
