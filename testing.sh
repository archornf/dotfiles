#!/bin/bash


architecture=$(uname -m)
echo "arch: $architecture"
if [[ "$architecture" == arm* ]] || [[ "$architecture" == aarch64* ]]; then
    echo "is arm"
else
    echo "not arm"
fi
        
if grep -qEi 'debian|raspbian' /etc/os-release; then
    echo "is debian"
else
    echo "Not debian"
fi
