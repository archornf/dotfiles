#!/bin/bash

# If you run this command with an argument, it will use greenclip
if [ -n "$1" ]; then
	#sleep 0.1
	/usr/bin/diodon
else
	rofi -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}'
fi
