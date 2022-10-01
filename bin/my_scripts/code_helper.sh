#!/bin/bash

rofi_command="rofi -theme ~/.config/rofi/themes/gruvbox/gruvbox-dark.rasi"

case $1 in
	"old") codeDir="Code" ;;
	"new") codeDir="Code2" ;;
esac

# Options
csharpOpt="c#"
cplplOpt="c++"
cOpt="c"
javaOpt="java"
jsOpt="js"
latexOpt="latex"
luaOpt="lua"
sqlOpt="sql"
pythonOpt="python"
rOpt="r"
randomOpt="random"

# Variable passed to rofi
options="$csharpOpt\n$cplplOpt\n$cOpt\n$javaOpt\n$jsOpt\n$latexOpt\n$luaOpt\n$sqlOpt\n$pythonOpt\n$rOpt\n$randomOpt"

chosen="$(echo -e "$options" | $rofi_command -p "Choose a command" -dmenu -selected-row 0)"
case $chosen in
    $csharpOpt)
		urxvt -e bash -c 'cd ~/'"$codeDir"'/C#;ls --color=auto; zsh;'
        ;;
    $cplplOpt)
		urxvt -e bash -c 'cd ~/'"$codeDir"'/C++;ls --color=auto; zsh'
        ;;
    $cOpt)
		urxvt -e bash -c 'cd ~/'"$codeDir"'/C;ls --color=auto; zsh'
        ;;
    $javaOpt)
		urxvt -e bash -c 'cd ~/'"$codeDir"'/Java;ls --color=auto; zsh'
        ;;
    $jsOpt)
		urxvt -e bash -c 'cd ~/'"$codeDir"'/Javascript;ls --color=auto; zsh'
        ;;
    $latexOpt)
		urxvt -e bash -c 'cd ~/'"$codeDir"'/Latex;ls --color=auto; zsh'
        ;;
    $luaOpt)
		urxvt -e bash -c 'cd ~/'"$codeDir"'/Lua;ls --color=auto; zsh'
        ;;
    $sqlOpt)
		urxvt -e bash -c 'cd ~/'"$codeDir"'/SQL_CODE;ls --color=auto; zsh'
        ;;
    $pythonOpt)
		urxvt -e bash -c 'cd ~/'"$codeDir"'/Python;ls --color=auto; zsh'
        ;;
    $rOpt)
		urxvt -e bash -c 'cd ~/'"$codeDir"'/R;ls --color=auto; zsh'
        ;;
    $randomOpt)
		urxvt -e bash -c 'cd ~/'"$codeDir"'/Random;ls --color=auto; zsh'
        ;;
esac
