#!/usr/bin/env bash
case $1 in
	"dwm") urxvt -e bash -c 'nvim ~/.local/bin/dwm_keybinds/keys;' ;;
	"i3") urxvt -e bash -c 'nvim ~/.local/bin/i3-used-keybinds/keys;' ;;
esac

