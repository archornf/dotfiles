#! /usr/bin/bash
export TESSDATA_PREFIX=/usr/local/share/tessdata

grim -g "$(slurp)" Pictures/ocr.png && python3 /home/jonas/.local/bin/my_scripts/hyprland/hypr_pytess.py
