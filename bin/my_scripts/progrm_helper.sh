#!/usr/bin/env bash

# rofi_command="rofi -theme $dir/powermenu.rasi"
rofi_command="rofi -theme ~/.config/rofi/themes/gruvbox/gruvbox-dark.rasi"

# Options
compOpt="complexities"
dpOpt="design patterns"
dsOpt="data structures"
genOpt="general"
praOpt="practical"
priOpt="principles"

# Variable passed to rofi
options="$compOpt\n$dpOpt\n$dsOpt\n$genOpt\n$praOpt\n$priOpt"

# Dmenu
#chosen="$(echo -e "$options" | dmenu -i -p "Choose a command" -l 10)"
# Rofi
chosen="$(echo -e "$options" | $rofi_command -p "Choose a command" -dmenu -selected-row 0)"
case $chosen in
    $compOpt)
		# ; zsh keeps the terminal alive after closing document
		$1 -e bash -c 'nvim ~/Documents/progrm_help_docs/complexities.txt; zsh'
        ;;
    $dpOpt)
		$1 -e bash -c 'nvim ~/Documents/progrm_help_docs/dp.txt; zsh'
        ;;
    $dsOpt)
		$1 -e bash -c 'nvim ~/Documents/progrm_help_docs/ds.txt; zsh'
        ;;
    $genOpt)
		$1 -e bash -c 'nvim ~/Documents/progrm_help_docs/general.txt; zsh'
        ;;
    $praOpt)
		$1 -e bash -c 'nvim ~/Documents/progrm_help_docs/practical.txt; zsh'
        ;;
    $priOpt)
		$1 -e bash -c 'nvim ~/Documents/progrm_help_docs/principles.txt; zsh'
        ;;
esac
