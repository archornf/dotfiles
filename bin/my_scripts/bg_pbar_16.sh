#!/usr/bin/env bash

# Color files
PFILE="$HOME/.config/polybar/colorblocks/colors.ini"
RFILE="$HOME/.config/polybar/colorblocks/scripts/rofi/colors.rasi"
export DISPLAY=:0

# Change colors
change_color() {
	# polybar
	sed -i -e "s/background = #.*/background = $BG/g" $PFILE
	sed -i -e "s/foreground = #.*/foreground = $FG/g" $PFILE
	sed -i -e "s/foreground-alt = #.*/foreground-alt = $FGA/g" $PFILE
	sed -i -e "s/shade1 = #.*/shade1 = $SH1/g" $PFILE
	sed -i -e "s/shade2 = #.*/shade2 = $SH2/g" $PFILE
	sed -i -e "s/shade3 = #.*/shade3 = $SH3/g" $PFILE
	sed -i -e "s/shade4 = #.*/shade4 = $SH4/g" $PFILE
	sed -i -e "s/shade5 = #.*/shade5 = $SH5/g" $PFILE
	sed -i -e "s/shade6 = #.*/shade6 = $SH6/g" $PFILE
	sed -i -e "s/shade7 = #.*/shade7 = $SH7/g" $PFILE
	sed -i -e "s/shade8 = #.*/shade8 = $SH8/g" $PFILE
	
	polybar-msg cmd restart
}

get_random_number() {
	RNUM=$(( ($RANDOM % $1) + 1 ))
}

get_random_bg() {
	get_random_number "16"
	case $RNUM in
		"1") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/green.jpg"
			#FG="#F5F5F5"
			FG="#ebdbb2"
			SH1="#1B5E20"	SH2="#2E7D32"	SH3="#388E3C"	SH4="#43A047"
			SH5="#4CAF50"	SH6="#66BB6A"	SH7="#81C784"	SH8="#A5D6A7"
			;;
		"2") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/blue.jpg"
			#FG="#F5F5F5"
			FG="#ebdbb2"
			SH1="#0D47A1"	SH2="#1565C0"	SH3="#1976D2"	SH4="#1E88E5"
			SH5="#2196F3"	SH6="#42A5F5"	SH7="#64B5F6"	SH8="#90CAF9"
			;;
		"3") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/pink.jpg"
			#FG="#F5F5F5"
			FG="#ebdbb2"
			SH1="#880E4F"	SH2="#AD1457"	SH3="#C2185B"	SH4="#D81B60"
			SH5="#E91E63"	SH6="#EC407A"	SH7="#F06292"	SH8="#F48FB1"
			;;
		"4") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/purple.jpg"
			#FG="#F5F5F5"
			FG="#ebdbb2"
			SH1="#311B92"	SH2="#4527A0"	SH3="#512DA8"	SH4="#5E35B1"
			SH5="#673AB7"	SH6="#7E57C2"	SH7="#9575CD"	SH8="#B39DDB"
			;;
		"5") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/red.jpg"
			#FG="#F5F5F5"
			FG="#ebdbb2"
			SH1="#B71C1C"	SH2="#C62828"	SH3="#D32F2F"	SH4="#E53935"
			SH5="#EE413D"	SH6="#EF5350"	SH7="#E57373"	SH8="#EF9A9A"
			;;
		"6") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/yellow.jpg"
			FG="#141C21"
			SH1="#F57F17"	SH2="#F9A825"	SH3="#FBC02D"	SH4="#FDD835"
			SH5="#FFEB3B"	SH6="#FFEE58"	SH7="#FFF176"	SH8="#FFF59D"
			;;
		"7") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/gray.jpg"
			#FG="#F5F5F5"
			FG="#ebdbb2"
			SH1="#263238"	SH2="#37474F"	SH3="#455A64"	SH4="#546E7A"
			SH5="#607D8B"	SH6="#78909C"	SH7="#90A4AE"	SH8="#B0BEC5"
			;;
		"8") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/blue2.png"
			#FG="#F5F5F5"
			FG="#ebdbb2"
			SH1="#004D40"	SH2="#00695C"	SH3="#00796B"	SH4="#00897B"
			SH5="#009688"	SH6="#26A69A"	SH7="#4DB6AC"	SH8="#80CBC4"
			;;
		"9") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/green2.jpg"
			FG="#141C21"
			SH1="#33691E"	SH2="#558B2F"	SH3="#689F38"	SH4="#7CB342"
			SH5="#8BC34A"	SH6="#9CCC65"	SH7="#AED581"	SH8="#C5E1A5"
			;;
		"10") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/amber.jpg"
			FG="#141C21"
			SH1="#E65100"	SH2="#EF6C00"	SH3="#F57C00"	SH4="#FB8C00"
			SH5="#FF9800"	SH6="#FFA726"	SH7="#FFB74D"	SH8="#FFCC80"
			;;
		"11") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/brown.jpg"
			#FG="#F5F5F5"
			FG="#ebdbb2"
			SH1="#3E2723"	SH2="#4E342E"	SH3="#5D4037"	SH4="#6D4C41"
			SH5="#795548"	SH6="#8D6E63"	SH7="#A1887F"	SH8="#BCAAA4"
			;;
		"12") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/blue2.png"
			#FG="#F5F5F5"
			FG="#ebdbb2"
			SH1="#1A237E"	SH2="#283593"	SH3="#303F9F"	SH4="#3949AB"
			SH5="#3F51B5"	SH6="#5C6BC0"	SH7="#7986CB"	SH8="#9FA8DA"
			;;
		"13") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/blue3.png"
			FG="#141C21"
			SH1="#01579B"	SH2="#0277BD"	SH3="#0288D1"	SH4="#039BE5"
			SH5="#03A9F4"	SH6="#29B6F6"	SH7="#4FC3F7"	SH8="#81D4FA"
			;;
		"14") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/yellow.jpg"
			FG="#141C21"
			SH1="#FF6F00"	SH2="#FF8F00"	SH3="#FFA000"	SH4="#FFB300"
			SH5="#FFC107"	SH6="#FFCA28"	SH7="#FFD54F"	SH8="#FFE082"
			;;
		"15") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/cyan.jpg"
			FG="#141C21"
			SH1="#006064"	SH2="#00838F"	SH3="#0097A7"	SH4="#00ACC1"
			SH5="#00BCD4"	SH6="#26C6DA"	SH7="#4DD0E1"	SH8="#80DEEA"
			;;
		"16") 
			PIC="/home/jonas/Pictures/Wallpapers/colorblocks/gruv.jpg"
			FG="#ebdbb2"
			FG="#141C21"
			#SH1="#8ec07c"	SH2="#d3869b"	SH3="#83a598"	SH4="#fabd2f"
			#SH5="#b8bb26"	SH6="#fb4934"	SH7="#928374"	SH8="#689d6a"
			SH1="#689d6a"	SH2="#d3869b"	SH3="#83a598"	SH4="#b8bb26"
			#SH5="#fb4934"	SH6="#fabd2f"	SH7="#928374"	SH8="#8ec07c"
			SH5="#fb4934"	SH6="#fabd2f"	SH7="#8ec07c"	SH8="#928374"
			;;
	esac
	
	echo $PIC
}

# Main
BG='#282828'
FG='#282828'
FGA='#ebdbb2'

get_random_bg
# CHANGE BG TO PIC:
feh --bg-fill $PIC
change_color
