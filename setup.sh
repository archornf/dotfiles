#!/bin/bash

# Should be ran from $HOME/Downloads/dotfiles only...

# Setup required dirs
mkdir -p ~/.config/
mkdir -p ~/.local/bin/
mkdir -p ~/Documents ~/Downloads ~/Pictures/Wallpapers
mkdir -p ~/Code/c ~/Code/c++ ~/Code/c# ~/Code/python ~/Code2/C ~/Code2/C++ ~/Code2/C# ~/Code2/Python ~/Code2/Wow/tools

# Copy stuff
cp -r .config/awesome/ ~/.config/awesome
cp -r .config/cava/ ~/.config/cava
cp -r .config/conky/ ~/.config/conky
cp -r .config/dmenu/ ~/.config/dmenu
cp -r .config/dmenu_git/ ~/.config/dmenu_git
cp -r .config/dwm/ ~/.config/dwm
cp -r .config/dwm_git/ ~/.config/dwm_git
cp -r .config/dwmblocks/ ~/.config/dwmblocks
cp -r .config/dwm_mul_mon/ ~/.config/dwm_mul_mon
cp -r .config/eww/ ~/.config/eww
cp -r .config/hypr/ ~/.config/hypr
cp -r .config/i3/ ~/.config/i3
cp -r .config/kitty/ ~/.config/kitty
cp -r .config/lf/ ~/.config/lf
cp -r .config/neofetch/ ~/.config/neofetch
cp -r .config/nvim/ ~/.config/nvim
cp -r .config/picom/ ~/.config/picom
cp -r .config/polybar/ ~/.config/polybar
cp -r .config/ranger/ ~/.config/ranger
cp -r .config/rofi/ ~/.config/rofi
cp -r .config/st/ ~/.config/st
cp -r .config/st_git/ ~/.config/st_git
cp -r .config/zathura/ ~/.config/zathura

cp -r .dwm/ ~/.dwm
cp -r bin/cron ~/.local/bin/
cp -r bin/dwm_keybinds ~/.local/bin/
cp -r bin/i3-used-keybinds ~/.local/bin/
cp -r bin/my_scripts ~/.local/bin/
cp -r bin/statusbar ~/.local/bin/
cp -r bin/vim ~/.local/bin/
cp -r bin/widgets ~/.local/bin/
cp -r bin/xyz ~/.local/bin/
cp -r installation/ ~/Documents/
cp installation/help.txt ~/Documents/

cp -r .bashrc ~/.bashrc
cp -r .tmux.conf ~/.tmux.conf
cp -r .xinitrc ~/.xinitrc
cp -r .Xresources ~/.Xresources
cp -r .Xresources_cat ~/.Xresources_cat
cp -r .zshrc ~/.zshrc

# oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "oh-my-zsh already installed."
fi

# zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/.git" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions already installed."
fi

# zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/.git" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting already installed."
fi

original_dir=$(pwd)
cd "$HOME/Downloads"

# polybar-themes
if [ ! -d "$HOME/Downloads/polybar-themes" ]; then
    git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
    cd polybar-themes
    chmod +x setup.sh
    ./setup.sh
    cd "$original_dir"
else
    echo "polybar-themes already cloned."
fi

# gruvbox-dark-gtk theme
if [ ! -d "$HOME/.themes/gruvbox-dark-gtk" ]; then
    git clone https://github.com/jmattheis/gruvbox-dark-gtk "$HOME/.themes/gruvbox-dark-gtk"
    echo "Set gruvbox-dark theme through lxappearance (should appear through dmenu)"
else
    echo "gruvbox-dark-gtk theme already installed."
fi

# fzf
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install"
else
    echo "fzf already installed."
fi

# packer.nvim
if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim/.git" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
    mv ~/.config/nvim/init.lua ~/.config/nvim/temp.lua
    mv ~/.config/nvim/install.lua ~/.config/nvim/init.lua
    echo "Now open vim and do :PackerInstall and then move temp.lua to init.lua in ~/.config/nvim"
else
    echo "packer already installed."
fi

gruvbox, font (no?) to setup.sh
Add more mkdirs and clones to setup.sh (only clone if not exists...)
Do all compiles in setup.sh also?? sleep 5s between each?
also add pip install -r requirements.txt??

