#!/bin/bash

# Array of packages to exclude from installation
exclude_packages=("linux" "linux-firmware" "yay" "yay-git")

# Function to check if a package is in the exclusion list
is_excluded() {
    for excluded_pkg in "${exclude_packages[@]}"; do
        if [[ $1 == "$excluded_pkg" ]]; then
            return 0 # Package is excluded
        fi
    done
    return 1 # Package is not excluded
}

# Function to install packages for Arch
install_arch() {
    for file in pk1.txt pk2.txt pk3.txt; do
        while read -r pkg; do
            if ! is_excluded "$pkg"; then
                sudo pacman -S --noconfirm "$pkg"
            fi
        done < "$file"
    done
}

# Function to install packages for Debian
install_debian() {
    for file in pk1.txt pk2.txt pk3.txt; do
        while read -r pkg; do
            if ! is_excluded "$pkg"; then
                sudo apt-get install -y "$pkg"
            fi
        done < "$file"
    done
}

# Check the Linux distribution and call the appropriate function
if grep -q 'ID=arch' /etc/os-release; then
    echo "Use arch branch instead of this!"
    #install_arch
elif grep -q 'ID=debian' /etc/os-release || grep -q 'ID_LIKE=debian' /etc/os-release; then
    install_debian
else
    echo "Unsupported Linux distribution."
    exit 1
fi
