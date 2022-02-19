#! /bin/bash
#import -window root /home/jonas/Pictures/Screenshots-ocr.png
scrot -s -o /home/jonas/Pictures/Screenshots/ocr.png && python3 /home/jonas/.local/bin/my_scripts/print_ocr.py
