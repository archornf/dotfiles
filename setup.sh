#!/bin/bash

# Setup required dirs
mkdir -p $HOME/.config/
mkdir -p $HOME/.local/bin/
mkdir -p $HOME/Documents $HOME/Downloads $HOME/Pictures/Wallpapers
mkdir -p $HOME/Code/c $HOME/Code/c++ $HOME/Code/c# $HOME/Code/js $HOME/Code/python $HOME/Code/rust $HOME/Code2/C $HOME/Code2/C++ $HOME/Code2/C# $HOME/Code2/General $HOME/Code2/Go $HOME/Code2/Python $HOME/Code2/Wow/tools

# Copy stuff
cp -r .config/alacritty/ $HOME/.config/
cp -r .config/awesome/ $HOME/.config/
cp -r .config/cava/ $HOME/.config/
cp -r .config/conky/ $HOME/.config/
cp -r .config/dmenu/ $HOME/.config/
cp -r .config/dmenu_git/ $HOME/.config/
cp -r .config/dwm/ $HOME/.config/
cp -r .config/dwm_git/ $HOME/.config/
cp -r .config/dwmblocks/ $HOME/.config/
cp -r .config/dwm_mul_mon/ $HOME/.config/
cp -r .config/eww/ $HOME/.config/
cp -r .config/hypr/ $HOME/.config/
cp -r .config/i3/ $HOME/.config/
cp -r .config/kitty/ $HOME/.config/
cp -r .config/lf/ $HOME/.config/
cp -r .config/neofetch/ $HOME/.config/
cp -r .config/nvim/ $HOME/.config/
cp -r .config/picom/ $HOME/.config/
cp -r .config/polybar/ $HOME/.config/
cp -r .config/ranger/ $HOME/.config/
cp -r .config/rofi/ $HOME/.config/
cp -r .config/st/ $HOME/.config/
cp -r .config/st_git/ $HOME/.config/
cp -r .config/zathura/ $HOME/.config/

cp -r .dwm/ $HOME/
cp -r bin/cron $HOME/.local/bin/
cp -r bin/dwm_keybinds $HOME/.local/bin/
cp -r bin/i3-used-keybinds $HOME/.local/bin/
cp -r bin/my_scripts $HOME/.local/bin/
cp -r bin/statusbar $HOME/.local/bin/
cp -r bin/vim $HOME/.local/bin/
cp -r bin/widgets $HOME/.local/bin/
cp -r bin/xyz $HOME/.local/bin/
cp bin/lfub $HOME/.local/bin/
cp bin/lf-select $HOME/.local/bin/
cp bin/greenclip $HOME/.local/bin/

cp -r installation/ $HOME/Documents/
cp installation/help.txt $HOME/Documents/
cp Screenshots/space.jpg $HOME/Pictures/Wallpapers/

cp .bashrc $HOME/.bashrc
cp .tmux.conf $HOME/.tmux.conf
cp .xinitrc $HOME/.xinitrc
cp .Xresources $HOME/.Xresources
cp .Xresources_cat $HOME/.Xresources_cat
cp .zshrc $HOME/.zshrc

if [ ! -f $HOME/.bash_profile ]; then
    cp -r .bash_profile $HOME/.bash_profile
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
    mv $HOME/.config/nvim/init.lua $HOME/.config/nvim/temp.lua
    mv $HOME/.config/nvim/install.lua $HOME/.config/nvim/init.lua
    echo "Packer installed! Now open vim and do :PackerInstall and then move temp.lua to init.lua in $HOME/.config/nvim"
else
    echo "packer already installed."
fi

# jetbrains nerd fonts
check_font_exists() {
    if ls $HOME/.local/share/fonts/*JetBrainsMonoNerdFont*.ttf 1> /dev/null 2>&1 || ls $HOME/.fonts/*JetBrainsMonoNerdFont*.ttf 1> /dev/null 2>&1; then
        return 0 # Font exists
    else
        return 1 # Font does not exist
    fi
}

# Download and install
install_jetbrains_mono() {
    echo "Downloading JetBrains Mono font..."
    cd $HOME/Downloads && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
    
    echo "Installing JetBrains Mono font..."
    mkdir -p $HOME/.local/share/fonts/ && unzip JetBrainsMono.zip -d $HOME/.local/share/fonts/
    
    echo "Updating font cache..."
    fc-cache -fv
}

# Install fonts on debian only since arch uses the package: ttf-jetbrains-mono-nerd
if grep -qEi 'debian|raspbian' /etc/os-release; then
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
# Variable to control whether to only inform about missing repos / builds
justInform=true

# Helper function
print_and_cd_to_dir() {
    local dir_path=$1
    local print_prefix=$2

    echo -e "\n--------------------------------------------------------"
    echo -e "$print_prefix projects in $dir_path...\n"
    cd "$dir_path" || exit
}

clone_repo_if_missing() {
    local repo_dir=$1
    local repo_url=$2
    local branch=$3
    local parent_dir="."

    echo "--------------------------------------------------------"
    if [[ "${repo_dir,,}" == "my_notes" || "${repo_dir,,}" == "utils" ]]; then
        if [ -z "$GITHUB_TOKEN" ]; then
            echo "Error: GITHUB_TOKEN environment variable is not set. Skipping $repo_dir..."
            return 1
        fi
    fi

    # Case insensitive check
    if find "$parent_dir" -maxdepth 1 -type d -iname "$(basename "$repo_dir")" | grep -iq "$(basename "$repo_dir")$"; then
        echo "$repo_dir already cloned."
        return 0
    else
        if $justInform; then
            echo "$repo_dir NOT cloned."
            return 0
        fi
        echo "Cloning $repo_dir from $repo_url"

        # Clone based on specific cases
        local clone_cmd="git clone --recurse-submodules"

        if [[ "${repo_dir,,}" == "trinitycore" || "${repo_dir,,}" == "simc" ]]; then
            clone_cmd="$clone_cmd --single-branch --depth 1"
        fi

        if [ -n "$branch" ]; then
            clone_cmd="$clone_cmd -b $branch"
        fi

        if [[ "${repo_dir,,}" == "my_notes" || "${repo_dir,,}" == "utils" ]]; then
            repo_url="${repo_url/https:\/\//https:\/\/$GITHUB_TOKEN@}"
        fi

        clone_cmd="$clone_cmd $repo_url $repo_dir"
        eval "$clone_cmd"
        return $?
    fi
}

# Clone projects (unless they already exist)
clone_projects() {

    print_and_cd_to_dir "$HOME/Documents" "Cloning"
    clone_repo_if_missing "my_notes" "https://github.com/archornf/my_notes"

    print_and_cd_to_dir "$HOME/Code/c" "Cloning"
    clone_repo_if_missing "neovim" "https://github.com/neovim/neovim"

    print_and_cd_to_dir "$HOME/Code/c++" "Cloning"

    clone_repo_if_missing "openmw" "https://github.com/OpenMW/openmw"
    clone_repo_if_missing "OpenJK" "https://github.com/JACoders/OpenJK"
    clone_repo_if_missing "JediKnightGalaxies" "https://github.com/JKGDevs/JediKnightGalaxies"
    clone_repo_if_missing "jk2mv" "https://github.com/mvdevs/jk2mv"
    clone_repo_if_missing "Unvanquished" "https://github.com/Unvanquished/Unvanquished"
    clone_repo_if_missing "re3" "https://github.com/halpz/re3"
    clone_repo_if_missing "re3_vice" "https://github.com/halpz/re3" "miami"
    clone_repo_if_missing "reone" "https://github.com/seedhartha/reone"

    print_and_cd_to_dir "$HOME/Code/js" "Cloning"
    clone_repo_if_missing "KotOR.js" "https://github.com/KobaltBlu/KotOR.js"

    print_and_cd_to_dir "$HOME/Code/rust" "Cloning"
    clone_repo_if_missing "eww" "https://github.com/elkowar/eww"
    clone_repo_if_missing "swww" "https://github.com/LGFae/swww"

    print_and_cd_to_dir "$HOME/Code2/C" "Cloning"
    clone_repo_if_missing "ioq3" "https://github.com/ornfelt/ioq3"
    clone_repo_if_missing "picom-animations" "https://github.com/ornfelt/picom-animations"

    print_and_cd_to_dir "$HOME/Code2/C++" "Cloning"
    clone_repo_if_missing "stk-code" "https://github.com/ornfelt/stk-code"
    if [ ! -d "stk-assets" ]; then
        if $justInform; then
            echo "$repo_dir NOT cloned."
        else
            svn co https://svn.code.sf.net/p/supertuxkart/code/stk-assets stk-assets
        fi
    else
        echo "stk-assets already cloned."
    fi
    clone_repo_if_missing "small_games" "https://github.com/ornfelt/small_games" "linux"
    clone_repo_if_missing "AzerothCore-wotlk-with-NPCBots" "https://github.com/rewow/AzerothCore-wotlk-with-NPCBots"
    ACORE_DIR="AzerothCore-wotlk-with-NPCBots/modules"
    if [ -d "$ACORE_DIR" ]; then
        cd "$ACORE_DIR"
        clone_repo_if_missing "mod-eluna" "https://github.com/azerothcore/mod-eluna"
        cd ../..
    else
        echo "Directory $DIR does not exist."
    fi
    clone_repo_if_missing "Trinitycore-3.3.5-with-NPCBots" "https://github.com/rewow/Trinitycore-3.3.5-with-NPCBots" "npcbots_3.3.5"
    clone_repo_if_missing "simc" "https://github.com/ornfelt/simc"
    clone_repo_if_missing "OpenJKDF2" "https://github.com/ornfelt/OpenJKDF2" "linux"
    clone_repo_if_missing "devilutionX" "https://github.com/ornfelt/devilutionX"
    clone_repo_if_missing "crispy-doom" "https://github.com/ornfelt/crispy-doom"
    clone_repo_if_missing "dhewm3" "https://github.com/ornfelt/dhewm3"

    print_and_cd_to_dir "$HOME/Code2/General" "Cloning"
    clone_repo_if_missing "Svea-Examples" "https://github.com/ornfelt/Svea-Examples"
    clone_repo_if_missing "1brc" "https://github.com/ornfelt/1brc"
    clone_repo_if_missing "utils" "https://github.com/ornfelt/utils"

    print_and_cd_to_dir "$HOME/Code2/Go" "Cloning"
    clone_repo_if_missing "wotlk-sim" "https://github.com/ornfelt/wotlk-sim"

    print_and_cd_to_dir "$HOME/Code2/Python" "Cloning"
    clone_repo_if_missing "wander_nodes_util" "https://github.com/ornfelt/wander_nodes_util"

    print_and_cd_to_dir "$HOME/Code2/Wow/tools" "Cloning"
    clone_repo_if_missing "mpq" "https://github.com/Gophercraft/mpq"
    clone_repo_if_missing "StormLib" "https://github.com/ladislav-zezula/StormLib"
    clone_repo_if_missing "BLPConverter" "https://github.com/ornfelt/BLPConverter"
    clone_repo_if_missing "spelunker" "https://github.com/wowserhq/spelunker"
    clone_repo_if_missing "wowser" "https://github.com/ornfelt/wowser"
    clone_repo_if_missing "wowmapview" "https://github.com/ornfelt/wowmapview" "linux"
    clone_repo_if_missing "wowmapviewer" "https://github.com/ornfelt/wowmapviewer" "linux"
    clone_repo_if_missing "WebWoWViewer" "https://github.com/ornfelt/WebWoWViewer" "new"

    architecture=$(uname -m)
    #if grep -q -i 'raspbian\|raspberry pi os' /etc/os-release; then
    if [[ "$architecture" == arm* ]] || [[ "$architecture" == aarch64* ]]; then
        clone_repo_if_missing "WebWoWViewercpp" "https://github.com/ornfelt/WebWoWViewercpp" "linux"
    else
        clone_repo_if_missing "WebWoWViewercpp" "https://github.com/ornfelt/WebWoWViewercpp" "linux"
    fi
}

if $justDoIt; then
    clone_projects
else
    if $justInform; then
        echo -e "\nDo you want to check cloned projects? (yes/y)"
    else
        echo -e "\nDo you want to proceed with cloning projects? (yes/y)"
    fi
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

    echo "--------------------------------------------------------"
    if ! command -v $binary &> /dev/null; then
        echo "$binary NOT found..."
        if $justInform; then
            return 0
        fi
        echo "installing: $binary"
        cd $HOME/.config/$directory || exit
        sudo make clean install
        cd - || exit # Return to previous directory
    else
        echo "$binary exists, skipping installation."
    fi
}

check_dir() {
    local dir_name=$1
    local dir_type=${2:-build} # Default to build
    echo "--------------------------------------------------------"

    read -p "Compile $dir_name? (yes/y to confirm): " user_input
    if [[ "$user_input" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "Proceeding with compilation of $dir_name..."
    else
        echo "Skipping compilation of $dir_name."
        return 1 # False, exit function
    fi
    
    # Capture the actual directory name, preserving its case
    #local actual_dir_name=$(find . -maxdepth 1 -type d -iname "${dir_name}" -exec basename {} \; | head -n 1)
    # Use loop instead to get rid of find basename terminated by signal 13...
    while IFS= read -r path; do
        actual_dir_name=$(basename "$path")
        break
    done < <(find . -maxdepth 1 -type d -iname "${dir_name}")
    
    if [[ -n "$actual_dir_name" ]]; then
        local target_dir="./${actual_dir_name}/${dir_type}"

        # Check if the directory exists based on the dir_type pattern
        if [[ "$dir_type" == "build*" ]]; then
            # Use find and grep to check for the existence of matching directories
            if find "./${actual_dir_name}" -maxdepth 1 -type d -name "${dir_type}" | grep -q .; then
                echo "${target_dir} already compiled."
                return 1 # Return false
            else
                if $justInform; then
                    echo "${target_dir} NOT compiled."
                    return 1
                fi
                echo "Entering ${actual_dir_name}..."
                cd "./${actual_dir_name}"
                sleep 1
                return 0 # Return true
            fi
        else
            if [ -d "$target_dir" ]; then
                echo "${target_dir} already compiled."
                return 1 # Return false
            else
                if $justInform; then
                    echo "${target_dir} NOT compiled."
                    return 1
                fi
                if [[ "$dir_type" == *"build"* ]]; then
                    echo "Creating and entering ${target_dir}..."
                    mkdir -p "$target_dir" && cd "$target_dir"
                else
                    echo "Entering ${actual_dir_name}..."
                    cd "./${actual_dir_name}"
                fi
                sleep 1
                return 0 # Return true
            fi
        fi
    else
        echo "Directory $dir_name does not exist."
        return 1 # Return false
    fi
}

check_file() {
    local dir_name=$1
    local file_path=$2
    echo "--------------------------------------------------------"

    read -p "Compile $dir_name? (yes/y to confirm): " user_input
    if [[ "$user_input" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "Proceeding with compilation of $dir_name..."
    else
        echo "Skipping compilation of $dir_name."
        return 1 # False, exit function
    fi
    
    # Capture the actual directory name, preserving its case
    #local actual_dir_name=$(find . -maxdepth 1 -type d -iname "$dir_name" -exec basename {} \; | head -n 1)
    # Use loop instead to get rid of find basename terminated by signal 13...
    while IFS= read -r path; do
        actual_dir_name=$(basename "$path")
        break
    done < <(find . -maxdepth 1 -type d -iname "${dir_name}")

    local full_file_path="./${actual_dir_name}/${file_path}"

    #if [ -f "$full_file_path" ]; then
    # Check case-insensitively if the file exists
    if find "$(dirname "$full_file_path")" -maxdepth 1 -type f -iname "$(basename "$full_file_path")" 2>/dev/null | grep -iq "$(basename "$full_file_path")$" >/dev/null 2>&1; then
        echo "${dir_name} already compiled."
        return 1 # Return false
    else
        echo "File ${file_path} in ${dir_name} does not exist."
        if $justInform; then
            echo "${dir_name} NOT compiled."
            return 1
        fi
        echo "Entering ${actual_dir_name}..."
        cd "./${actual_dir_name}"
        return 0 # Return true
    fi
}

# Compile projects (unless already done)
compile_projects() {
    architecture=$(uname -m)
    echo -e "Identified architecture: $architecture\n"

    echo "Compiling projects in $HOME/.config..."
    install_if_missing dwm dwm
    install_if_missing dwmblocks dwmblocks
    install_if_missing dmenu dmenu
    install_if_missing st st

    print_and_cd_to_dir "$HOME/Code/c" "Compiling"

    #if check_dir "neovim"; then
    #    cd ..
    #    if dpkg -l | grep -qw "neovim"; then
    #        sudo apt remove neovim -y
    #    fi
    #    git checkout stable
    #    make CMAKE_BUILD_TYPE=RelWithDebInfo
    #    sudo make install
    #    cd ..
    #fi

    # Note: If the shell has issues with '++', you might need to quote or escape it...
    print_and_cd_to_dir "$HOME/Code/c++" "Compiling"

    if check_dir "openmw"; then
        # Check MyGUI version
        mygui_version=$(dpkg -l | grep mygui | awk '{print $3}')
        if [ ! -z "$mygui_version" ]; then
            echo "MyGUI version detected: $mygui_version"
            if [[ "$mygui_version" == "3.4.2"* ]]; then
                echo "MyGUI version is 3.4.2"
                git checkout 1c2f92cac9
            elif [[ "$mygui_version" == "3.4.1"* ]]; then
                echo "MyGUI version is 3.4.1"
                git checkout abb71eeb
            else
                echo "MyGUI version is: $mygui_version"
            fi
            cmake .. -DCMAKE_BUILD_TYPE=Release
            make -j$(nproc)
            sudo make install
            #cd ...
            cd ../..
        else
            echo "MyGUI is not installed or not found."
            cd ..
        fi
    fi

    if check_dir "OpenJK"; then
        sed -i '/option(BuildJK2SPEngine /s/OFF)/ON)/; /option(BuildJK2SPGame /s/OFF)/ON)/; /option(BuildJK2SPRdVanilla /s/OFF)/ON)/' ../CMakeLists.txt
        cmake -DCMAKE_INSTALL_PREFIX=/home/jonas/.local/share/openjk -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
        make -j$(nproc)
        sudo make install
        cd ../..
    fi

    # Compile if NOT arm arch
    if ! [[ "$architecture" == arm* ]] && ! [[ "$architecture" == aarch64* ]]; then
        if check_dir "JediKnightGalaxies"; then
            cmake -DCMAKE_INSTALL_PREFIX=/home/jonas/Downloads/ja_data -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
            make -j$(nproc)
            sudo make install
            cd ../..
        fi

        if check_dir "jk2mv.js" "build_new"; then
            cmake .. CMAKE_BUILD_TYPE=Release
            make -j$(nproc)
            sudo make install
            cd ../..
        fi

        if check_dir "Unvanquished"; then
            cd .. && ./download-paks build/pkg && cd -
            cmake .. -DCMAKE_BUILD_TYPE=Release
            make -j$(nproc)
            cd ../..
        fi
    fi

    # re3
    if check_dir "re3"; then
        cd ..
        if [[ "$architecture" == arm* ]] || [[ "$architecture" == aarch64* ]]; then
            cd $HOME/Downloads
            git clone --recurse-submodules https://github.com/premake/premake-core
            cd premake-core
            make -f Bootstrap.mak linux
            cd bin/release
            # Verify that it's built for ARM64:
            file premake5
            sudo mv premake5 /usr/local/bin
            premake5 --version
            cd "$HOME/Code/c++/re3"
            premake5 --with-librw gmake
            cd build && make help
            make config=release_linux-arm64-librw_gl3_glfw-oal
        else
            ./premake5Linux --with-librw gmake2
            cd build && make help
            make config=release_linux-amd64-librw_gl3_glfw-oal
        fi
        cd ../..
    fi

    if check_dir "re3_vice"; then
        cd ..
        if [[ "$architecture" == arm* ]] || [[ "$architecture" == aarch64* ]]; then
            premake5 --with-librw gmake
            cd build && make help
            make config=release_linux-arm64-librw_gl3_glfw-oal
        else
            ./premake5Linux --with-librw gmake2
            cd build && make help
            make config=release_linux-amd64-librw_gl3_glfw-oal
        fi
        cd ../..
    fi

    if check_dir "reone"; then
        cd ..
        cmake -B build -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo
        cd build && make -j$(nproc)
        sudo make install
        cd ../..
    fi

    print_and_cd_to_dir "$HOME/Code/js" "Compiling"

    if check_dir "KotOR.js" "node_modules"; then
        npm install
        #npm run webpack:dev-watch
        npm run webpack:dev -- --no-watch # No watch to exit after compile
        cd ..
    fi

    print_and_cd_to_dir "$HOME/Code/rust" "Compiling"

    # Only compile if rust version is > 1.63
    #rust_version=$(rustc --version | awk '{print $2}') # Also works...
    rust_version=$(rustc --version | grep -oP 'rustc \K[^\s]+')
    major_version=$(echo "$rust_version" | cut -d'.' -f1)
    minor_version=$(echo "$rust_version" | cut -d'.' -f2)
    echo "Rust version: $rust_version"
    echo "major: $major_version"
    echo "minor: $minor_version"

    if check_dir "eww" "target"; then
        if [ "$major_version" -gt 1 ] || { [ "$major_version" -eq 1 ] && [ "$minor_version" -gt 63 ]; }; then
            echo "rustc version is above 1.63"
            cargo build --release --no-default-features --features x11
            cd target/release
            chmod +x ./eww
            cd ../../..
        else
            echo "rustc version is 1.63 or below. Skipping rust project..."
            cd ..
        fi
    fi

    if check_dir "swww" "target"; then
        if [ "$major_version" -gt 1 ] || { [ "$major_version" -eq 1 ] && [ "$minor_version" -gt 63 ]; }; then
            echo "rustc version is above 1.63"
            cargo build --release
            cd ..
        else
            echo "rustc version is 1.63 or below. Skipping rust project..."
            cd ..
        fi
    fi

    print_and_cd_to_dir "$HOME/Code2/C" "Compiling"

    if check_dir "ioq3"; then
        cd ..
        make
        cd ..
    fi

    #if check_dir "picom-animations"; then
    #    cd ..
    #    meson --buildtype=release . build
    #    ninja -C build
    #    cd ..
    #fi

    print_and_cd_to_dir "$HOME/Code2/C++" "Compiling"

    if check_dir "stk-code"; then
        cmake .. -DCMAKE_BUILD_TYPE=Release -DNO_SHADERC=on
        make -j$(nproc)
        cd ../..
    fi

    # Simply check for Craft binary for this...
    if check_file "small_games" "Craft/craft"; then
        cd BirdGame
        g++ -std=c++17 -g *.cpp -o main -lSDL2main -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_mixer
        cp -r BirdGame/graphics ./

        echo "--------------------------------------------------------"
        cd ../CPP_FightingGame/FightingGameProject
        cmake . && make -j$(nproc)

        echo "--------------------------------------------------------"
        cd ../../Craft
        cmake . && make -j$(nproc)
        gcc -std=c99 -O3 -fPIC -shared -o world -I src -I deps/noise deps/noise/noise.c src/world.c

        echo "--------------------------------------------------------"
        cd ../space-shooter/
        make linux
        #make linux-release

        echo "--------------------------------------------------------"
        cd ../pacman/
        mkdir build && cd build
        cmake ..
        cmake --build .
        cd ../../..
    fi

    if check_dir "AzerothCore-wotlk-with-NPCBots"; then
        cmake ../ -DCMAKE_INSTALL_PREFIX=$HOME/acore/ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS_BUILD=all -DSCRIPTS=static -DMODULES=static -DWITH_COREDEBUG=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
        make -j$(nproc)
        make install
        cd ../..
    fi

    if check_dir "Trinitycore-3.3.5-with-NPCBots"; then
        cmake ../ -DCMAKE_INSTALL_PREFIX=$HOME/tcore/ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS_BUILD=all -DSCRIPTS=static -DMODULES=static -DWITH_COREDEBUG=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
        make -j$(nproc)
        make install
        cd ../..
    fi

    if check_dir "simc"; then
        cmake ../ -DCMAKE_BUILD_TYPE=Release
        make -j$(nproc)
        sudo make install
        cd ../..
    fi

    if check_dir "OpenJKDF2" "build*"; then
        export CC=clang
        export CXX=clang++
        source build_linux64.sh
        cd ..
    fi

    if check_dir "devilutionX" "build*"; then
        if grep -qEi 'debian|raspbian' /etc/os-release; then
            echo "Running on Debian or Raspbian. Installing smpq package from tools script."
            sudo apt remove smpq -y
            cd tools
            source build_and_install_smpq.sh
            sudo cp /usr/local/bin/smpq /usr/bin/smpq
            cd ..
        fi
        if [[ "$architecture" == arm* ]] || [[ "$architecture" == aarch64* ]]; then
            source Packaging/nix/debian-cross-aarch64-prep.sh
            cmake -S. -Bbuild-aarch64-rel \
            -DCMAKE_TOOLCHAIN_FILE=../CMake/platforms/aarch64-linux-gnu.toolchain.cmake \
            -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCPACK=ON \
            -DDEVILUTIONX_SYSTEM_LIBFMT=OFF
            cmake --build build-aarch64-rel -j $(getconf _NPROCESSORS_ONLN) --target package
        else
            cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
            cmake --build build -j $(getconf _NPROCESSORS_ONLN)
        fi
        cd ..
    fi

    if check_file "crispy-doom" "src/crispy-doom"; then
        autoreconf -fiv
        ./configure
        make -j$(nproc)
        cd ..
    fi

    if check_dir "dhewm3"; then
        cmake ../neo/
        make -j$(nproc)
        cd ..
    fi

    print_and_cd_to_dir "$HOME/Code2/Wow/tools" "Compiling"

    if check_file "mpq" "gophercraft_mpq_set"; then
        go build github.com/Gophercraft/mpq/cmd/gophercraft_mpq_set
        cd ..
    fi

    if check_dir "BLPConverter"; then
        cmake .. -DWITH_LIBRARY=YES
        sudo make install
        sudo cp /usr/local/lib/libblp.so /usr/lib/
        sudo ldconfig
        cd ../../
    fi

    if check_dir "StormLib"; then
        cmake .. -DBUILD_SHARED_LIBS=ON
        sudo make install
        sudo cp /usr/local/lib/libstorm.so /usr/lib/
        sudo ldconfig
        cd ../../
    fi

    if check_dir "spelunker" "node_modules"; then
        npm install
        cd packages/spelunker-api && npm install && cd -
        cd packages/spelunker-web && npm install && cd -
        cd ..
    fi

    if check_dir "wowser" "node_modules"; then
        git checkout new
        npm install
        cd ..
    fi

    if check_dir "wowmapview"; then
        cmake .. && make -j$(nproc)
        cd ..
    fi

    if check_file "wowmapviewer" "bin/wowmapview"; then
        #cd src/stormlib && make -f Makefile.linux
        #cd .. && make
        #cd ..
        cd src
        mkdir build && cd build
        cmake .. && make -j$(nproc)
        cd ../../..
    fi

    if check_dir "WebWoWViewer" "node_modules"; then
        npm install
        cd ..
    fi

    if check_dir "WebWowViewerCpp"; then
        cmake .. && make -j$(nproc)
        cd ..
    fi

    cd "$original_dir"
}

if $justDoIt; then
    compile_projects
else
    if $justInform; then
        echo -e "\nDo you want to check compiled projects? (yes/y)"
    else
        echo -e "\nDo you want to proceed with compiling projects? (yes/y)"
    fi
    read answer
    # To lowercase using awk
    answer=$(echo $answer | awk '{print tolower($0)}')

    if [[ "$answer" == "yes" ]] || [[ "$answer" == "y" ]]; then
        compile_projects
    fi
fi

check_pip_packages() {
    requirements_path="$HOME/Documents/installation/requirements.txt"

    # Extract package names from requirements.txt, ignoring versions
    requirements_packages=$(cut -d'=' -f1 < "$requirements_path")

    # Extract installed packages names, ignoring versions
    installed_packages=$(pip freeze | cut -d'=' -f1)

    # Convert to arrays (assuming Bash 4+ for associative array support)
    declare -A reqs
    declare -A installed

    # Populate arrays
    for pkg in $requirements_packages; do reqs["$pkg"]=1; done
    for pkg in $installed_packages; do installed["$pkg"]=1; done

    # Compare: Find packages in requirements.txt not installed
    echo -e "\nPackages in requirements.txt but not installed:\n"
    for pkg in "${!reqs[@]}"; do
        if [[ ! ${installed["$pkg"]} ]]; then
            echo "$pkg"
        fi
    done

    # Compare: Find installed packages not in requirements.txt
    echo -e "\nInstalled packages not in requirements.txt:\n"
    for pkg in "${!installed[@]}"; do
        if [[ ! ${reqs["$pkg"]} ]]; then
            echo "$pkg"
        fi
    done
}

install_pip_packages() {
    #pip3 install -r $HOME/Documents/installation/requirements.txt
    requirements_path="$HOME/Documents/installation/requirements.txt"

    # Read each line in requirements.txt, remove version specifications, and install
    while read -r package || [[ -n $package ]]; do
        package_name=$(echo "$package" | cut -d'=' -f1)
        pip3 install "$package_name"
    done < "$requirements_path"
}

# Install python packages
if $justDoIt; then
    echo "Installing python packages..."
    install_pip_packages
else
    if $justInform; then
        echo -e "\nDo you want to check python packages? (yes/y)"
    else
        echo -e "\nDo you want to install python packages? (yes/y)"
    fi
    read answer
    # To lowercase using awk
    answer=$(echo $answer | awk '{print tolower($0)}')

    if [[ "$answer" == "yes" ]] || [[ "$answer" == "y" ]]; then
        if $justInform; then
            check_pip_packages
        else
            echo "Installing python packages..."
            install_pip_packages
        fi
    fi
fi


# Kept for reference...

#clone_repo_if_missing() {
#    local repo_dir=$1
#    local repo_url=$2
#    local branch=$3
#
#    local parent_dir=$(dirname "$repo_dir")
#    local target_dir_name=$(basename "$repo_dir")
#    local target_dir_name_lower=$(echo "$target_dir_name" | tr '[:upper:]' '[:lower:]')
#    local dir_exists=false
#
#    # Might be more robust than the above for directories with a large number
#    # of files or when dealing with special characters in filenames
#    if [ -d "$parent_dir" ]; then
#        while IFS= read -r dir; do
#            dir_name=$(basename "$dir")
#            if [ "$(echo "$dir_name" | tr '[:upper:]' '[:lower:]')" = "$target_dir_name_lower" ]; then
#                dir_exists=true
#                break
#            fi
#        done < <(find "$parent_dir" -maxdepth 1 -type d)
#    fi
#
#    if ! $dir_exists; then
#        echo "Cloning $repo_dir from $repo_url"
#
#        if [[ "$target_dir_name_lower" == "trinitycore" || "$target_dir_name_lower" == "simc" ]]; then
#            echo "Cloning $repo_dir with --single-branch --depth 1"
#            if [ -z "$branch" ]; then
#                git clone --recurse-submodules $repo_url --single-branch --depth 1 "$repo_dir"
#            else
#                git clone --recurse-submodules -b $branch $repo_url --single-branch --depth 1 "$repo_dir"
#            fi
#        else
#            if [ -z "$branch" ]; then
#                git clone --recurse-submodules $repo_url "$repo_dir"
#            else
#                git clone --recurse-submodules -b $branch $repo_url "$repo_dir"
#            fi
#        fi
#    else
#        echo "$repo_dir already cloned."
#    fi
#}

