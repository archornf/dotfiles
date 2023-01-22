#! /bin/bash
# You can skip rtl8852be-dkms-git / rtw89... and 
# replace picom-pijulius-git with regular picom if you wish...

# Other optional packages:
# lf, ffmpegthumbnailer, epub-thumbnailer-git, chafa, wkhtmltopdf

# Other picom animation repos:
# https://github.com/dccsillag/picom
# https://github.com/jonaburg/picom

#for x in $(cat packages.txt); do yay -S --noconfirm $x; done
for x in $(cat pk1); do yay -S --noconfirm $x; done

