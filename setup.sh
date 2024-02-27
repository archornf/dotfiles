#!/bin/bash

# Setup required dirs
mkdir -p ~/.config/
mkdir -p ~/.local/bin/
mkdir -p ~/Documents ~/Downloads ~/Pictures/Wallpapers
mkdir -p ~/Code/c ~/Code/c++ ~/Code/c# ~/Code/python ~/Code2/C ~/Code2/C++ ~/Code2/C# ~/Code2/General ~/Code2/Python ~/Code2/Wow/tools

# Copy stuff
cp -r .config/awesome/ ~/.config/
cp -r .config/cava/ ~/.config/
cp -r .config/conky/ ~/.config/
cp -r .config/dmenu/ ~/.config/
cp -r .config/dmenu_git/ ~/.config/
cp -r .config/dwm/ ~/.config/
cp -r .config/dwm_git/ ~/.config/
cp -r .config/dwmblocks/ ~/.config/
cp -r .config/dwm_mul_mon/ ~/.config/
cp -r .config/eww/ ~/.config/
cp -r .config/hypr/ ~/.config/
cp -r .config/i3/ ~/.config/
cp -r .config/kitty/ ~/.config/
cp -r .config/lf/ ~/.config/
cp -r .config/neofetch/ ~/.config/
cp -r .config/nvim/ ~/.config/
cp -r .config/picom/ ~/.config/
cp -r .config/polybar/ ~/.config/
cp -r .config/ranger/ ~/.config/
cp -r .config/rofi/ ~/.config/
cp -r .config/st/ ~/.config/
cp -r .config/st_git/ ~/.config/
cp -r .config/zathura/ ~/.config/

cp -r .dwm/ ~/
cp -r bin/cron ~/.local/bin/
cp -r bin/dwm_keybinds ~/.local/bin/
cp -r bin/i3-used-keybinds ~/.local/bin/
cp -r bin/my_scripts ~/.local/bin/
cp -r bin/statusbar ~/.local/bin/
cp -r bin/vim ~/.local/bin/
cp -r bin/widgets ~/.local/bin/
cp -r bin/xyz ~/.local/bin/
cp bin/lfub ~/.local/bin/
cp bin/lf-select ~/.local/bin/

cp -r installation/ ~/Documents/
cp installation/help.txt ~/Documents/
cp Screenshots/space.jpg ~/Pictures/Wallpapers/

cp .bashrc ~/.bashrc
cp .tmux.conf ~/.tmux.conf
cp .xinitrc ~/.xinitrc
cp .Xresources ~/.Xresources
cp .Xresources_cat ~/.Xresources_cat
cp .zshrc ~/.zshrc

if [ ! -f ~/.bash_profile ]; then
    cp -r .bash_profile ~/.bash_profile
else
    echo ".bash_profile already exists."
fi

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
    echo "Packer installed! Now open vim and do :PackerInstall and then move temp.lua to init.lua in ~/.config/nvim"
else
    echo "packer already installed."
fi

# jetbrains nerd fonts
check_font_exists() {
    if ls ~/.local/share/fonts/*JetBrainsMonoNerdFont*.ttf 1> /dev/null 2>&1 || ls ~/.fonts/*JetBrainsMonoNerdFont*.ttf 1> /dev/null 2>&1; then
        return 0 # Font exists
    else
        return 1 # Font does not exist
    fi
}

# Download and install
install_jetbrains_mono() {
    echo "Downloading JetBrains Mono font..."
    cd ~/Downloads && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
    
    echo "Installing JetBrains Mono font..."
    mkdir -p ~/.local/share/fonts/ && unzip JetBrainsMono.zip -d ~/.local/share/fonts/
    
    echo "Updating font cache..."
    fc-cache -fv
}

# Install fonts on debian only since arch uses the package: ttf-jetbrains-mono-nerd
if grep -iq "debian" /etc/os-release; then
    if ! check_font_exists; then
        install_jetbrains_mono
    else
        echo "JetBrains Mono font already installed."
    fi
else
    echo "Install jetbrains via sudo pacman -S ttf-jetbrains-mono-nerd"
fi

# Variable to control whether to skip prompts and proceed directly
justDoIt=false

# Clone projects (unless they already exist)
clone_projects() {
    echo "Cloning projects..."
    cd ~/Code2/C++ || exit

    if [ ! -d "azerothcore-wotlk" ]; then
        git clone https://github.com/ornfelt/azerothcore-wotlk
    else
        echo "azerothcore-wotlk already cloned."
    fi

    if [ ! -d "TrinityCore" ]; then
        git clone -b 3.3.5 https://github.com/ornfelt/TrinityCore --single-branch --depth 1
    else
        echo "trinitycore already cloned."
    fi

    if [ ! -d "small_games" ]; then
        git clone --recurse-submodules -b linux https://github.com/ornfelt/small_games
    else
        echo "small_games already cloned."
    fi

    if [ ! -d "OpenJKDF2" ]; then
        git clone --recurse-submodules https://github.com/ornfelt/OpenJKDF2 -b linux
    else
        echo "OpenJKDF2 already cloned."
    fi

    if [ ! -d "simc" ]; then
        git clone --recurse-submodules https://github.com/ornfelt/simc --single-branch --depth 1
    else
        echo "simc already cloned."
    fi

    if [ ! -d "stk-code" ]; then
        git clone https://github.com/ornfelt/stk-code
        if [ ! -d "stk-assets" ]; then
            svn co https://svn.code.sf.net/p/supertuxkart/code/stk-assets stk-assets
        else
            echo "stk-assets already cloned."
        fi
    else
        echo "stk-code already cloned."
    fi

    if [ ! -d "devilutionX" ]; then
        git clone https://github.com/ornfelt/devilutionX
    else
        echo "devilutionX already cloned."
    fi

    if [ ! -d "crispy-doom" ]; then
        git clone --recurse-submodules https://github.com/ornfelt/crispy-doom
    else
        echo "crispy-doom already cloned."
    fi

    if [ ! -d "dhewm3" ]; then
        git clone --recurse-submodules https://github.com/ornfelt/dhewm3
    else
        echo "dhewm3 already cloned."
    fi
}

if $justDoIt; then
    clone_projects
else
    echo "Do you want to proceed with cloning projects? (yes/y)"
    read answer

    # To lowercase using awk
    answer=$(echo $answer | awk '{print tolower($0)}')

    if [[ "$answer" == "yes" ]] || [[ "$answer" == "y" ]]; then
        clone_projects
    fi
fi

# Compile projects (unless already done)
compile_projects() {
    echo "Compiling projects..."
    cd ~/Code2/C++ || exit

    # compile...
    echo "compiling x..."
    sleep 5
    echo "compiling y..."
    sleep 5
}

if $justDoIt; then
    compile_projects
else
    echo "Do you want to proceed with compiling projects? (yes/y)"
    read answer

    # To lowercase using awk
    answer=$(echo $answer | awk '{print tolower($0)}')

    if [[ "$answer" == "yes" ]] || [[ "$answer" == "y" ]]; then
        compile_projects
    fi
fi


if $justDoIt; then
    echo "Installing python packages..."
    pip3 install -r ~/Documents/installation/requirements.txt
else
    echo "Do you want to install python packages? (yes/y)"
    read answer

    # To lowercase using awk
    answer=$(echo $answer | awk '{print tolower($0)}')

    if [[ "$answer" == "yes" ]] || [[ "$answer" == "y" ]]; then
        echo "Installing python packages..."
        pip3 install -r ~/Documents/installation/requirements.txt
    fi
fi
