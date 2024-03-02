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

clone_repo_if_missing() {
    local repo_dir=$1
    local repo_url=$2
    local branch=$3
    local parent_dir="."

    # Case insensitive check
    if find "$parent_dir" -maxdepth 1 -type d -iname "$(basename "$repo_dir")" | grep -iq "$(basename "$repo_dir")$"; then
        echo "$repo_dir already cloned."
        return 0
    else
        echo "Cloning $repo_dir from $repo_url"
        # Clone based on specific cases
        local clone_cmd="git clone --recurse-submodules"
        if [[ "${repo_dir,,}" == "trinitycore" || "${repo_dir,,}" == "simc" ]]; then
            clone_cmd="$clone_cmd --single-branch --depth 1"
        fi
        if [ -n "$branch" ]; then
            clone_cmd="$clone_cmd -b $branch"
        fi
        clone_cmd="$clone_cmd $repo_url $repo_dir"
        eval "$clone_cmd"
        return $?
    fi
}

# Clone projects (unless they already exist)
clone_projects() {

    echo "Cloning projects in ~/Documents..."
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "Error: GITHUB_TOKEN environment variable is not set. Skipping..."
    else
        if [ ! -d "$HOME/Documents/my_notes" ]; then
            cd ~/Documents || exit
            git clone https://$GITHUB_TOKEN@github.com/archornf/my_notes
        else
            echo "my_notes already cloned."
        fi
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
    clone_repo_if_missing "OpenJK" "https://github.com/JACoders/OpenJK"
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

# Helper functions
print_and_cd_to_dir() {
    local dir_path=$1

    echo "Compiling projects in $dir_path..."
    cd "$dir_path" || exit
    sleep 1
}

check_dir() {
    local project_name=$1
    local dir_type=${2:-build} # Default to build
    local parent_dir=$(dirname "${project_name}")
    local project_dir_name=$(basename "${project_name}")
    local target_dir="${project_name}/${dir_type}"

    parent_dir=$(cd "$parent_dir" && pwd)

    local match_found=false
    if [ -d "$parent_dir" ]; then
        # Check case-insensitively
        while IFS= read -r dir; do
            if [[ "$(basename "$dir")" =~ ^[${project_dir_name^}${project_dir_name,,}]$ ]]; then
                match_found=true
                break
            fi
        done < <(find "$parent_dir" -maxdepth 1 -type d)
    fi

    if $match_found && [ -d "$target_dir" ]; then
        echo "${target_dir} already exists."
        return 1 # Return false
    elif $match_found; then
        if [[ "$dir_type" != "node_modules" ]]; then
            mkdir -p "$target_dir"
        fi
        cd "$parent_dir/$project_dir_name"
        [[ "$dir_type" != "node_modules" ]] && cd "$dir_type"
        return 0 # Return true
    else
        echo "Project directory $project_name does not exist."
        return 1 # Return false
    fi
}

# Compile projects (unless already done)
compile_projects() {
    architecture=$(uname -m)

    echo "Compiling projects in ~/.config..."
    install_if_missing dwm dwm
    install_if_missing dwmblocks dwmblocks
    install_if_missing dmenu dmenu
    install_if_missing st st
    # TODO: Picom?
    sleep 1

    print_and_cd_to_dir "~/Code/c"

    # TODO: check if already built...
    if dpkg -l | grep -qw "neovim"; then
        sudo apt remove neovim
    fi
    cd neovim && git checkout stable
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    cd ...

    # Note: If the shell has issues with '++', you might need to quote or escape it...
    print_and_cd_to_dir "~/Code/c++"

    # TODO: sed Change the BuildJK2SPEngine, BuildJK2SPGame, and BuildJK2SPRdVanilla
    # options to ON in CMakeLists.txt.
    if check_dir "OpenJK"; then
        cmake -DCMAKE_INSTALL_PREFIX=/home/jonas/Downloads/ja_data -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
        make -j$(nproc)
        sudo make install
        cd ...
    fi

    if check_dir "JediKnightGalaxies"; then
        cmake -DCMAKE_INSTALL_PREFIX=/home/jonas/Downloads/ja_data -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
        make -j$(nproc)
        sudo make install
        cd ...
    fi

    if check_dir "jk2mv.js" "build_new"; then
        cmake .. CMAKE_BUILD_TYPE=Release
        make -j$(nproc)
        sudo make install
        cd ...
    fi

    if check_dir "Unvanquished"; then
        cd .. && ./download-paks build/pkg && cd -
        cmake .. -DCMAKE_BUILD_TYPE=Release
        make -j$(nproc)
        cd ...
    fi

    # re3
    if check_dir "re3"; then
        cd ..
        if [[ "$architecture" == arm* ]] || [[ "$architecture" == aarch64* ]]; then
            cd ~/Downloads
            git clone --recurse-submodules https://github.com/premake/premake-core
            cd premake-core
            make -f Bootstrap.mak linux
            cd bin/release
            # Verify that it's built for ARM64:
            file premake5
            sudo mv premake5 /usr/local/bin
            premake5 --version
            cd "~/Code/c++/re3"
            premake5 --with-librw gmake
            cd build && make help
            make config=release_linux-arm64-librw_gl3_glfw-oal
        else
            ./premake5Linux --with-librw gmake2
            cd build && make help
            make config=release_linux-amd64-librw_gl3_glfw-oal
        fi
        cd ...
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
        cd ...
    fi

    # TODO check if compiled...
    cd reone && cmake -B build -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo
    make -j$(nproc)
    sudo make install

    print_and_cd_to_dir "~/Code/js"

    if check_dir "KotOR.js" "node_modules"; then
        npm install
        npm run webpack:dev-watch
    fi

    print_and_cd_to_dir "~/Code/rust"

    # TODO check if compiled...
    # Only compile if rust version is >= ?
    cd swww
    cargo build --release
    cd ..
    cd eww
    cargo build --release --no-default-features --features x11
    cd target/release
    chmod +x ./eww

    print_and_cd_to_dir "~/Code2/C"

    cd ioq3 && make

    print_and_cd_to_dir "~/Code2/C++"

    if check_dir "stk-code"; then
        cmake .. -DCMAKE_BUILD_TYPE=Release -DNO_SHADERC=on
        make -j$(nproc)
        cd ...
    fi

    # Simply check for Craft binary for this...
    if [ ! -f "small_games/Craft/craft" ]; then
        cd small_games

        cd BirdGame
        g++ -std=c++17 -g *.cpp -o main -lSDL2main -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_mixer
        cp -r BirdGame/graphics ./

        cd ../CPP_FightingGame/FightingGameProject
        cmake . && make -j$(nproc)

        cd ../../Craft
        cmake . && make -j$(nproc)
        gcc -std=c99 -O3 -fPIC -shared -o world -I src -I deps/noise deps/noise/noise.c src/world.c

        cd ../pacman/
        mkdir build && cd build
        cmake ..
        cmake --build .
        cd ...
    else
        echo "small_games already compiled."
    fi


    # TODO CHECK
    cd OpenJKDF2
    export CC=clang
    export CXX=clang++
    ./build_linux64.sh
    cd ..

    if check_dir "azerothcore-wotlk"; then
        cmake ../ -DCMAKE_INSTALL_PREFIX=$HOME/acore/ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS_BUILD=all -DSCRIPTS=static -DMODULES=static -DWITH_COREDEBUG=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
        make -j$(nproc)
        make install
    fi

    if check_dir "trinitycore"; then
        cmake ../ -DCMAKE_INSTALL_PREFIX=$HOME/tcore/ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS_BUILD=all -DSCRIPTS=static -DMODULES=static -DWITH_COREDEBUG=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
        make -j$(nproc)
        make install
    fi

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
            cd ...
        else
            echo "MyGUI is not installed or not found."
            cd ..
        fi
    fi

    # TODO CHECK
    cd devilutionX
    if grep -qEi 'debian|raspbian' /etc/os-release; then
        echo "Running on Debian or Raspbian. Installing smpq package from tools script."
        sudo apt remove smpq
        cd tools && ./build_and_install_smpq.sh
        sudo cp /usr/local/bin/smpq /usr/bin/smpq
        cd ..
    fi
    if [[ "$architecture" == arm* ]] || [[ "$architecture" == aarch64* ]]; then
        Packaging/nix/debian-cross-aarch64-prep.sh
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

    # TODO CHECK
    cd crispy-doom
    autoreconf -fiv
    ./configure
    make -j$(nproc)

    if check_dir "dhewm3"; then
        cmake ../neo/
        make -j$(nproc)
    fi

    print_and_cd_to_dir "~/Code2/Wow/tools"

    # TODO CHECK
    cd gophercraft_mpq
    go build github.com/Gophercraft/mpq/cmd/gophercraft_mpq_set
    cd ..

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

    if check_dir "simc"; then
        cmake ../ -DCMAKE_BUILD_TYPE=Release
        make -j$(nproc)
        sudo make install
    fi

    if check_dir "wowser" "node_modules"; then
        git checkout minimal
        npm install
    fi

    cd src/stormlib && make -f Makefile.linux
    cd .. && make

    if check_dir "WebWowViewerCpp"; then
        cmake .. && make -j$(nproc)
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
