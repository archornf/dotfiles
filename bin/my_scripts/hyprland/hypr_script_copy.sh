#!/usr/bin/env bash

fileText=$(cat ~/.local/bin/my_scripts/script_help_docs/script_copy.txt)

#set -o noglob
IFS=$'\n' textSplit=($fileText)
#set +o noglob

# Options
#echo "${textSplit[0]}"
firstOpt="${textSplit[0]}"
secondOpt="${textSplit[1]}"
thirdOpt="${textSplit[2]}"
fourthOpt="${textSplit[3]}"
fifthOpt="${textSplit[4]}"
sixthOpt="${textSplit[5]}"
seventhOpt="${textSplit[6]}"
eighthOpt="${textSplit[7]}"
ninthOpt="${textSplit[8]}"
tenthOpt="${textSplit[9]}"
eleventhOpt="${textSplit[10]}"
twelfthOpt="${textSplit[11]}"
thirteenthOpt="${textSplit[12]}"
fourteenthOpt="${textSplit[13]}"
fifteenthOpt="${textSplit[14]}"
sixteenthOpt="${textSplit[15]}"
seventeenthOpt="${textSplit[16]}"
eighteenthOpt="${textSplit[17]}"
nineteenthOpt="${textSplit[18]}"
twentiethOpt="${textSplit[19]}"
twentyfirstOpt="${textSplit[20]}"
twentysecondOpt="${textSplit[21]}"
twentythirdOpt="${textSplit[22]}"
twentyfourthOpt="${textSplit[23]}"
twentyfifthOpt="${textSplit[24]}"
twentysixthOpt="${textSplit[25]}"
twentyseventhOpt="${textSplit[26]}"
twentyeighthOpt="${textSplit[27]}"
twentyninthOpt="${textSplit[28]}"
#otherOpt=$(echo $fileText | sed -n '1p')
#otherOpt=$(echo $fileText | awk 'NR==1')

# Variable passed to rofi
options="$firstOpt\n$secondOpt\n$thirdOpt\n$fourthOpt\n$fifthOpt\n$sixthOpt\n$seventhOpt\n$eighthOpt\n$ninthOpt\n$tenthOpt\n$eleventhOpt\n$twelfthOpt\n$thirteenthOpt\n$fourteenthOpt\n$fifteenthOpt\n$sixteenthOpt\n$seventeenthOpt\n$eighteenthOpt\n$nineteenthOpt\n$twentiethOpt\n$twentyfirstOpt\n$twentysecondOpt\n$twentythirdOpt\n$twentyfourthOpt\n$twentyfifthOpt\n$twentysixthOpt\n$twentyseventhOpt\n$twentyeighthOpt\n$twentyninthOpt"

chosen="$(echo -e "$options" | rofi -theme "/home/jonas/.config/rofi/themes/gruvbox/gruvbox-dark2.rasi" -p "Choose a command to copy" -dmenu -selected-row 0)"

case $chosen in
    $firstOpt)
		echo "$firstOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $secondOpt)
		echo "$secondOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $thirdOpt)
		echo "$thirdOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $fourthOpt)
		echo "$fourthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $fifthOpt)
		echo "$fifthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $sixthOpt)
		echo "$sixthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $seventhOpt)
		echo "$seventhOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $eighthOpt)
		echo "$eighthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $ninthOpt)
		echo "$ninthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $tenthOpt)
		echo "$tenthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $eleventhOpt)
		python3 ~/.local/bin/my_scripts/script_help_docs/command_copy3.py
        ;;
    $twelfthOpt)
		echo "$twelfthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $thirteenthOpt)
		echo "$thirteenthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $fourteenthOpt)
		echo "$fourteenthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $fifteenthOpt)
		python3 ~/.local/bin/my_scripts/script_help_docs/command_copy1.py
        ;;
    $sixteenthOpt)
		python3 ~/.local/bin/my_scripts/script_help_docs/command_copy2.py
        ;;
    $seventeenthOpt)
		echo "$seventeenthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $eighteenthOpt)
		echo "$eighteenthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $nineteenthOpt)
		echo "$nineteenthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $twentiethOpt)
		echo "$twentiethOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $twentyfirstOpt)
		echo "$twentyfirstOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $twentysecondOpt)
		echo "$twentysecondOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $twentythirdOpt)
		echo "$twentythirdOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $twentyfourthOpt)
		echo "$twentyfourthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $twentyfifthOpt)
		echo "$twentyfifthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $twentysixthOpt)
		echo "$twentysixthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $twentyseventhOpt)
		echo "$twentyseventhOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
    $twentyeighthOpt)
		python3 ~/.local/bin/my_scripts/script_help_docs/command_copy4.py
        ;;
    $twentyninthOpt)
		echo "$twentyninthOpt" | sed "s/\s*#.*//g" | wl-copy
        ;;
esac
