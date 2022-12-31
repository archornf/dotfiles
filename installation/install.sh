#! /bin/bash
# You can skip rtl8852be-dkms-git / rtw89... and 
# replace picom-pijulius-git with regular picom if you wish...

#for x in $(cat packages.txt); do yay -S --noconfirm $x; done
for x in $(cat pk1); do yay -S --noconfirm $x; done

