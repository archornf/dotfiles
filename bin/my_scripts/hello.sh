#! /bin/bash

if [ -e ~/.local/bin/my_scripts/x.txt ]
then
	:
else
	pgrep -x dwm > /dev/null && neofetch && ~/.local/bin/my_scripts/namnsdag.py
	pgrep -x i3 > /dev/null && neofetch && ~/.local/bin/my_scripts/namnsdag.py && date +"Week: %V"
	pgrep -x awesome > /dev/null && neofetch && ~/.local/bin/my_scripts/namnsdag.py
	# neofetch
	touch ~/.local/bin/my_scripts/x.txt
fi
