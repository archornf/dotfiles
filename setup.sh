#!/bin/bash

# Setup required dirs
mkdir -p ~/.config/
mkdir -p ~/.local/bin/
mkdir -p ~/Documents ~/Downloads ~/Pictures/Wallpapers
mkdir -p ~/Code/c ~/Code/c++ ~/Code/c# ~/Code/js ~/Code/python ~/Code2/C ~/Code2/C++ ~/Code2/C# ~/Code2/General ~/Code2/Python ~/Code2/Wow/tools

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

clone_repo_if_missing() {
    local repo_dir=$1
    local repo_url=$2
    local branch=$3

    # Convert the repo_dir to lowercase for case-insensitive comparison
    local repo_dir_lower=$(echo "$repo_dir" | tr '[:upper:]' '[:lower:]')

    if [ ! -d "$repo_dir" ]; then
        echo "Cloning $repo_dir from $repo_url"

        # Check if repo_dir matches specific cases and clone accordingly
        if [[ "$repo_dir_lower" == "trinitycore" || "$repo_dir_lower" == "simc" ]]; then
            echo "Cloning $repo_dir with --single-branch --depth 1"
            if [ -z "$branch" ]; then
                git clone --recurse-submodules $repo_url --single-branch --depth 1 $repo_dir
            else
                git clone --recurse-submodules -b $branch $repo_url --single-branch --depth 1 $repo_dir
            fi
        else
            if [ -z "$branch" ]; then
                git clone --recurse-submodules $repo_url $repo_dir
            else
                git clone --recurse-submodules -b $branch $repo_url $repo_dir
            fi
        fi
    else
        echo "$repo_dir already cloned."
    fi
}

# Clone projects (unless they already exist)
clone_projects() {

    echo "Cloning projects in ~/Documents..."
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "Error: GITHUB_TOKEN environment variable is not set. Skipping..."
    else
        cd ~/Documents || exit
        git clone https://$GITHUB_TOKEN@github.com/archornf/my_notes
    fi


    echo "Cloning projects in ~/Code/c..."
    cd ~/Code/c || exit
    clone_repo_if_missing "neovim" "https://github.com/neovim/neovim"

    echo "Cloning projects in ~/Code/c++..."
    cd "~/Code/c++" || exit
    clone_repo_if_missing "JediKnightGalaxies" "https://github.com/JKGDevs/JediKnightGalaxies"
    clone_repo_if_missing "jk2mv" "https://github.com/mvdevs/jk2mv"
    clone_repo_if_missing "Unvanquished" "https://github.com/Unvanquished/Unvanquished"
    clone_repo_if_missing "reone" "https://github.com/seedhartha/reone"
    clone_repo_if_missing "re3" "https://github.com/halpz/re3"
    if [ ! -d "re3_vice" ]; then
        git clone --recurse-submodules -b miami https://github.com/halpz/re3 re3_vice
    else
        echo "re3_vice already cloned."
    fi

    echo "Cloning projects in ~/Code/js..."
    cd ~/Code/js || exit
    clone_repo_if_missing "KotOR.js" "https://github.com/KobaltBlu/KotOR.js"

    echo "Cloning projects in ~/Code/rust..."
    cd ~/Code/rust || exit
    clone_repo_if_missing "eww" "https://github.com/elkowar/eww"
    clone_repo_if_missing "swww" "https://github.com/LGFae/swww"

    echo "Cloning projects in ~/Code2/C..."
    cd ~/Code2/C || exit
    clone_repo_if_missing "ioq3" "https://github.com/ornfelt/ioq3"

    echo "Cloning projects in ~/Code2/C++..."
    cd "~/Code2/C++" || exit
    clone_repo_if_missing "small_games" "https://github.com/ornfelt/small_games" "linux"
    clone_repo_if_missing "OpenJKDF2" "https://github.com/ornfelt/OpenJKDF2" "linux"
    clone_repo_if_missing "devilutionX" "https://github.com/ornfelt/devilutionX"
    clone_repo_if_missing "crispy-doom" "https://github.com/ornfelt/crispy-doom"
    clone_repo_if_missing "dhewm3" "https://github.com/ornfelt/dhewm3"
    clone_repo_if_missing "openmw" "https://github.com/OpenMW/openmw"
    clone_repo_if_missing "azerothcore-wotlk" "https://github.com/ornfelt/azerothcore-wotlk"
    clone_repo_if_missing "trinitycore" "https://github.com/ornfelt/TrinityCore" "3.3.5"
    clone_repo_if_missing "simc" "https://github.com/ornfelt/simc"
    clone_repo_if_missing "stk-code" "https://github.com/ornfelt/stk-code"
    if [ ! -d "stk-assets" ]; then
        svn co https://svn.code.sf.net/p/supertuxkart/code/stk-assets stk-assets
    else
        echo "stk-assets already cloned."
    fi

    echo "Cloning projects in ~/Code2/Python..."
    cd ~/Code2/Python || exit
    clone_repo_if_missing "wander_nodes_util" "https://github.com/ornfelt/wander_nodes_util"

    echo "Cloning projects in ~/Code2/Wow/tools..."
    cd ~/Code2/Wow/tools || exit
    clone_repo_if_missing "mpq" "https://github.com/Gophercraft/mpq"
    clone_repo_if_missing "spelunker" "https://github.com/wowserhq/spelunker"
    clone_repo_if_missing "wowser" "https://github.com/ornfelt/wowser"
    clone_repo_if_missing "wowmapviewer" "https://github.com/ornfelt/wowmapviewer" "linux"
    clone_repo_if_missing "WebWoWViewer" "https://github.com/ornfelt/WebWoWViewer"

    architecture=$(uname -m)
    if [[ "$architecture" == arm* ]] || [[ "$architecture" == aarch64* ]]; then
    #if grep -q -i 'raspbian\|raspberry pi os' /etc/os-release; then
        clone_repo_if_missing "WebWoWViewercpp" "https://github.com/ornfelt/WebWoWViewercpp" "raspbian"
    else
        clone_repo_if_missing "WebWoWViewercpp" "https://github.com/ornfelt/WebWoWViewercpp" "linux"
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

# Function to install if binary doesn't exist
install_if_missing() {
    local binary=$1
    local directory=$2

    if ! command -v $binary &> /dev/null; then
        echo "$binary not found, installing..."
        cd ~/.config/$directory || exit
        sudo make clean install
        cd - || exit # Return to the previous directory
    else
        echo "$binary exists, skipping installation."
    fi
}

print_and_cd_to_dir() {
    local dir_path=$1

    echo "Compiling projects in $dir_path..."
    cd "$dir_path" || exit
    sleep 1
}

# Compile projects (unless already done)
compile_projects() {

    echo "Compiling projects in ~/.config..."
    install_if_missing dwm dwm
    install_if_missing dwmblocks dwmblocks
    install_if_missing dmenu dmenu
    install_if_missing st st
    sleep 1

    print_and_cd_to_dir "~/Code/c"

    # Note: If the shell has issues with '++', you might need to quote or escape it...
    print_and_cd_to_dir "~/Code/c++"

    # If raspbian / arm, compile premake for gta...
    #git clone --recurse-submodules https://github.com/premake/premake-core

    print_and_cd_to_dir "~/Code/go"

    print_and_cd_to_dir "~/Code2/C"

    print_and_cd_to_dir "~/Code2/C++"

    # Diablo: check that smpq is not installed and compile smpq and use aarch64-prep for raspbian/arm

    print_and_cd_to_dir "~/Code2/Python"

    print_and_cd_to_dir "~/Code2/Rust"

    print_and_cd_to_dir "~/Code2/Wow/tools"

    cd gophercraft_mpq
    go build github.com/Gophercraft/mpq/cmd/gophercraft_mpq_set
    cd -

    # Compile and install BLPConverter if build directory doesn't exist
    if [ ! -d "BLPConverter/build" ]; then
        echo "Compiling and installing BLPConverter..."
        cd BLPConverter
        mkdir build && cd build
        cmake .. -DWITH_LIBRARY=YES
        sudo make install
        sudo cp /usr/local/lib/libblp.so /usr/lib/
        sudo ldconfig
        cd ../../
    else
        echo "BLPConverter build directory exists, skipping..."
    fi

    # Compile and install StormLib if build directory doesn't exist
    if [ ! -d "StormLib/build" ]; then
        echo "Compiling and installing StormLib..."
        cd StormLib
        mkdir build && cd build
        cmake .. -DBUILD_SHARED_LIBS=ON
        sudo make install
        sudo cp /usr/local/lib/libstorm.so /usr/lib/
        sudo ldconfig
        cd ../../
    else
        echo "StormLib build directory exists, skipping..."
    fi
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

# Install python packages
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
